-- ============================================================
--  CAP HOMARD BEACH VOLLEY 974 — Migration v4
--  À exécuter dans : Supabase > SQL Editor > New query
--  SANS RISQUE sur une base existante (idempotent).
--
--  Apporte : la LISTE D'ATTENTE.
--   - Une équipe peut s'inscrire en liste d'attente quand le tournoi est complet.
--   - Les équipes en liste d'attente ne comptent PAS dans le quota de places.
--   - Le décompte « complet » ne considère que les équipes réellement inscrites.
-- ============================================================

-- 1) Nouvelle colonne ---------------------------------------
alter table public.equipes
  add column if not exists liste_attente boolean not null default false;

-- 2) Décomptes publics : ne compter que les équipes inscrites (hors attente)
create or replace function public.tournois_ouverts()
returns table (
  id uuid, nom text, slug text, type text,
  date_tournoi date, tarif_par_joueur numeric, image_url text,
  max_equipes int, nb_equipes int
)
language sql security definer set search_path = public
as $$
  select t.id, t.nom, t.slug, t.type, t.date_tournoi, t.tarif_par_joueur, t.image_url,
         t.max_equipes,
         (select count(*)::int from public.equipes e
           where e.tournoi_id = t.id and e.liste_attente = false) as nb_equipes
  from public.tournois t
  where t.statut = 'ouvert' and t.is_historique = false
  order by t.date_tournoi asc nulls last, t.created_at desc;
$$;
grant execute on function public.tournois_ouverts() to anon, authenticated;

create or replace function public.tournoi_public(p_slug text)
returns table (
  id uuid, nom text, type text, date_tournoi date,
  tarif_par_joueur numeric, statut text, is_historique boolean, image_url text,
  max_equipes int, nb_equipes int
)
language sql security definer set search_path = public
as $$
  select t.id, t.nom, t.type, t.date_tournoi, t.tarif_par_joueur,
         t.statut, t.is_historique, t.image_url,
         t.max_equipes,
         (select count(*)::int from public.equipes e
           where e.tournoi_id = t.id and e.liste_attente = false) as nb_equipes
  from public.tournois t
  where t.slug = p_slug
  limit 1;
$$;
grant execute on function public.tournoi_public(text) to anon, authenticated;

-- 3) inscrire_equipe : nouveau paramètre p_liste_attente ----
--    - en liste d'attente : on ignore la limite de places
--    - inscription normale : on refuse si le tournoi est complet
--      (le quota ne compte que les équipes hors liste d'attente)
drop function if exists public.inscrire_equipe(text, text, text[], text, text, text);

create or replace function public.inscrire_equipe(
  p_slug              text,
  p_nom_equipe        text,
  p_joueurs           text[],
  p_contact_nom       text,
  p_contact_prenom    text,
  p_contact_telephone text,
  p_liste_attente     boolean default false
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_tournoi   public.tournois%rowtype;
  v_equipe_id uuid;
  v_nom       text;
  v_pos       int := 0;
  v_count     int;
  v_nb        int;
begin
  select * into v_tournoi from public.tournois where slug = p_slug limit 1 for update;
  if not found then
    raise exception 'Tournoi introuvable';
  end if;
  if v_tournoi.statut <> 'ouvert' or v_tournoi.is_historique then
    raise exception 'Les inscriptions pour ce tournoi sont fermées';
  end if;

  -- limite de places : uniquement pour une inscription normale
  if not p_liste_attente and v_tournoi.max_equipes is not null then
    select count(*) into v_nb
    from public.equipes
    where tournoi_id = v_tournoi.id and liste_attente = false;
    if v_nb >= v_tournoi.max_equipes then
      raise exception 'Le tournoi est complet';
    end if;
  end if;

  select count(*) into v_count
  from unnest(p_joueurs) j
  where btrim(coalesce(j, '')) <> '';

  if v_count < 4 then
    raise exception 'Minimum 4 joueurs requis';
  end if;
  if v_count > 8 then
    raise exception 'Maximum 8 joueurs autorisés';
  end if;
  if btrim(coalesce(p_nom_equipe, '')) = '' then
    raise exception 'Le nom de l''équipe est obligatoire';
  end if;
  if btrim(coalesce(p_contact_nom, '')) = ''
     or btrim(coalesce(p_contact_prenom, '')) = ''
     or btrim(coalesce(p_contact_telephone, '')) = '' then
    raise exception 'Le contact (nom, prénom, téléphone) est obligatoire';
  end if;

  insert into public.equipes
    (tournoi_id, nom, contact_nom, contact_prenom, contact_telephone, liste_attente)
  values
    (v_tournoi.id, btrim(p_nom_equipe), btrim(p_contact_nom),
     btrim(p_contact_prenom), btrim(p_contact_telephone), p_liste_attente)
  returning id into v_equipe_id;

  foreach v_nom in array p_joueurs loop
    if btrim(coalesce(v_nom, '')) <> '' then
      v_pos := v_pos + 1;
      insert into public.joueurs (equipe_id, nom, position, paye)
      values (v_equipe_id, btrim(v_nom), v_pos, false);
    end if;
  end loop;

  return v_equipe_id;
end;
$$;

grant execute on function
  public.inscrire_equipe(text, text, text[], text, text, text, boolean)
  to anon, authenticated;

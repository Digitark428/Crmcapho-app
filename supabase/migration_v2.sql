-- ============================================================
--  CAP HOMARD BEACH VOLLEY 974 — Migration v2
--  À exécuter dans : Supabase > SQL Editor > New query
--  SANS RISQUE sur une base existante (idempotent).
--
--  Apporte :
--   1. Affiche du tournoi (image_url + bucket de stockage)
--   2. Contact d'équipe obligatoire (nom, prénom, téléphone)
--   3. Fonction publique listant les tournois ouverts (lien unique)
--   4. RPC d'inscription enrichi (contact) + tournoi_public (image)
-- ============================================================

-- 1) Nouvelles colonnes -------------------------------------
alter table public.tournois add column if not exists image_url text;

alter table public.equipes  add column if not exists contact_nom        text;
alter table public.equipes  add column if not exists contact_prenom     text;
alter table public.equipes  add column if not exists contact_telephone  text;

-- 2) Stockage des affiches (bucket public en lecture) -------
insert into storage.buckets (id, name, public)
values ('tournoi-images', 'tournoi-images', true)
on conflict (id) do update set public = true;

-- Lecture publique des affiches
drop policy if exists "affiches lecture publique" on storage.objects;
create policy "affiches lecture publique"
  on storage.objects for select
  to public
  using (bucket_id = 'tournoi-images');

-- Envoi / modification / suppression réservés aux organisateurs connectés
drop policy if exists "affiches ecriture admin" on storage.objects;
create policy "affiches ecriture admin"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'tournoi-images');

drop policy if exists "affiches maj admin" on storage.objects;
create policy "affiches maj admin"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'tournoi-images');

drop policy if exists "affiches suppression admin" on storage.objects;
create policy "affiches suppression admin"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'tournoi-images');

-- 3) Liste publique des tournois ouverts (lien unique) ------
create or replace function public.tournois_ouverts()
returns table (
  id uuid,
  nom text,
  slug text,
  type text,
  date_tournoi date,
  tarif_par_joueur numeric,
  image_url text
)
language sql
security definer
set search_path = public
as $$
  select t.id, t.nom, t.slug, t.type, t.date_tournoi, t.tarif_par_joueur, t.image_url
  from public.tournois t
  where t.statut = 'ouvert'
    and t.is_historique = false
  order by t.date_tournoi asc nulls last, t.created_at desc;
$$;

grant execute on function public.tournois_ouverts() to anon, authenticated;

-- 4) tournoi_public : renvoie aussi l'affiche ---------------
create or replace function public.tournoi_public(p_slug text)
returns table (
  id uuid,
  nom text,
  type text,
  date_tournoi date,
  tarif_par_joueur numeric,
  statut text,
  is_historique boolean,
  image_url text
)
language sql
security definer
set search_path = public
as $$
  select t.id, t.nom, t.type, t.date_tournoi, t.tarif_par_joueur,
         t.statut, t.is_historique, t.image_url
  from public.tournois t
  where t.slug = p_slug
  limit 1;
$$;

grant execute on function public.tournoi_public(text) to anon, authenticated;

-- 5) inscrire_equipe : contact obligatoire ------------------
-- (l'ancienne signature à 3 arguments est remplacée)
drop function if exists public.inscrire_equipe(text, text, text[]);

create or replace function public.inscrire_equipe(
  p_slug              text,
  p_nom_equipe        text,
  p_joueurs           text[],
  p_contact_nom       text,
  p_contact_prenom    text,
  p_contact_telephone text
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
begin
  select * into v_tournoi from public.tournois where slug = p_slug limit 1;
  if not found then
    raise exception 'Tournoi introuvable';
  end if;
  if v_tournoi.statut <> 'ouvert' or v_tournoi.is_historique then
    raise exception 'Les inscriptions pour ce tournoi sont fermées';
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

  insert into public.equipes (tournoi_id, nom, contact_nom, contact_prenom, contact_telephone)
  values (
    v_tournoi.id,
    btrim(p_nom_equipe),
    btrim(p_contact_nom),
    btrim(p_contact_prenom),
    btrim(p_contact_telephone)
  )
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
  public.inscrire_equipe(text, text, text[], text, text, text)
  to anon, authenticated;

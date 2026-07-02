import json, re, unicodedata

hist = json.load(open('scripts/historique.json', encoding='utf-8'))

MOIS = {'janv':1,'jan':1,'fevr':2,'fev':2,'fevrier':2,'mars':3,'avr':4,'avril':4,'mai':5,
        'juin':6,'juil':7,'juillet':7,'aout':8,'sept':9,'septemnbre':9,'septembre':9,
        'oct':10,'octobre':10,'nov':11,'novembre':11,'dec':12,'decembre':12}

def strip_accents(s):
    return ''.join(c for c in unicodedata.normalize('NFD', s) if unicodedata.category(c) != 'Mn')

def slugify(s):
    s = strip_accents(s).lower()
    s = re.sub(r'[^a-z0-9]+', '-', s).strip('-')
    return s[:60] or 'tournoi'

def infer_type(nom):
    u = strip_accents(nom).upper()
    if '3VS3' in u or '3MAN' in u: return '3x3'
    if 'MIXTE' in u and ('4VS4' in u or '4MAN' in u): return 'mixte'
    if 'MIXTE' in u: return 'mixte'
    if '4VS4' in u or '4MAN' in u or '4WOMAN' in u: return '4x4'
    return 'autre'

def infer_date(nom):
    u = strip_accents(nom).lower()
    # format dd-mois-yy  ex 25-janv-26 / 01-mai-26
    m = re.search(r'(\d{1,2})-([a-z]+)-(\d{2})', u)
    if m:
        d, mo, y = int(m.group(1)), MOIS.get(m.group(2)), 2000+int(m.group(3))
        if mo: return f'{y:04d}-{mo:02d}-{d:02d}'
    # format dd/mm/yyyy
    m = re.search(r'(\d{1,2})/(\d{1,2})/(\d{4})', u)
    if m: return f'{int(m.group(3)):04d}-{int(m.group(2)):02d}-{int(m.group(1)):02d}'
    # format "dd mois yyyy" ex 21 septemnbre 2025 / 23 novembre 2025
    m = re.search(r'(\d{1,2})\s+([a-z]+)\s+(\d{4})', u)
    if m:
        mo = MOIS.get(m.group(2))
        if mo: return f'{int(m.group(3)):04d}-{mo:02d}-{int(m.group(1)):02d}'
    # format "dd mois" sans année (tournois 2025 début) ex "16 fevrier"
    m = re.search(r'(\d{1,2})\s+([a-z]+)', u)
    if m:
        mo = MOIS.get(m.group(2))
        if mo: return f'2025-{mo:02d}-{int(m.group(1)):02d}'
    return None

def esc(s):
    return s.replace("'", "''")

def numlit(v):
    return 'null' if v is None else f'{v}'

seen = {}
lines = ["-- Seed historique CAP HOMARD — généré depuis GESTION_Tournoi_CAP_HOMARD_.csv",
         "-- 13 tournois, 422 équipes. À exécuter APRÈS schema.sql.",
         "begin;", ""]

for t in hist:
    nom = t['nom']
    base = slugify(nom)
    slug = base
    seen[base] = seen.get(base, 0) + 1
    if seen[base] > 1:
        slug = f'{base}-{seen[base]}'
    typ = infer_type(nom)
    date = infer_date(nom)
    fin = t.get('finances', {})
    ins = fin.get('inscriptions')
    rb = fin.get('rentre_buvette') or 0
    db = fin.get('depense_buvette') or 0

    date_lit = f"'{date}'" if date else 'null'
    lines.append(f"-- {nom}")
    lines.append(
        "with tt as (\n"
        "  insert into public.tournois "
        "(nom, slug, type, date_tournoi, tarif_par_joueur, statut, is_historique, "
        "rentree_buvette, depense_buvette, rentree_inscriptions_manuelle)\n"
        f"  values ('{esc(nom)}', '{slug}', '{typ}', {date_lit}, 10, 'cloture', true, "
        f"{rb}, {db}, {numlit(ins)})\n"
        "  returning id\n)"
    )

    # équipes
    eq_vals = []
    for e in t['equipes']:
        eq_vals.append(f"((select id from tt), '{esc(e['nom'])}', {numlit(e['montant'])})")
    # achats divers
    ac_vals = []
    for i, a in enumerate(t['achats_divers'], 1):
        ac_vals.append(f"((select id from tt), '{esc(a['description'])}', {a.get('montant') or 0}, {i})")
    # frais
    fr_vals = []
    for i, fr in enumerate(t['frais_association'], 1):
        fonc = esc(fr.get('fonction') or '')
        fr_vals.append(f"((select id from tt), '{esc(fr['description'])}', {fr.get('montant') or 0}, '{fonc}', {i})")

    # Emit inserts referencing tt via chained CTE data-modifying statements.
    # We wrap all in one statement using CTEs.
    stmt = []
    if eq_vals:
        stmt.append(", ins_eq as (\n  insert into public.equipes (tournoi_id, nom, montant_historique) values\n  "
                    + ",\n  ".join(eq_vals) + "\n  returning id)")
    if ac_vals:
        stmt.append(", ins_ac as (\n  insert into public.achats_divers (tournoi_id, description, montant, position) values\n  "
                    + ",\n  ".join(ac_vals) + "\n  returning id)")
    if fr_vals:
        stmt.append(", ins_fr as (\n  insert into public.frais_association (tournoi_id, description, montant, fonction, position) values\n  "
                    + ",\n  ".join(fr_vals) + "\n  returning id)")
    # need a terminal select
    if stmt:
        lines[-1] = lines[-1]  # keep
        lines.append("".join(stmt))
    lines.append("select 1;")
    lines.append("")

lines.append("commit;")
open('supabase/seed.sql','w',encoding='utf-8').write("\n".join(lines))
print("seed.sql généré:", len(lines), "lignes")

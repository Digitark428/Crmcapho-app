# 🦞 CAP HOMARD BEACH VOLLEY 974 — Gestion des tournois

Application web complète pour gérer les inscriptions et les finances des tournois
de beach-volley de l'association **CAP HOMARD BEACH VOLLEY 974** (La Réunion).

- **Inscriptions publiques** via un **lien unique** (`/inscription`) : les joueurs y
  voient tous les tournois ouverts, choisissent le leur, puis remplissent le formulaire
  (contact obligatoire, engagements à cocher, paiement sur place).
- **Espace organisateur sécurisé** : tableau de bord, affiche par tournoi, équipes
  entièrement modifiables, suivi des paiements par joueur, bilan financier automatique,
  archivage / suppression, historique importé depuis votre fichier.
- **Formules financières reproduites à l'identique** de votre fichier Excel
  (validées sur les 13 tournois existants — 13/13 exacts).

Stack : **Next.js 14** (App Router) · **React 18** · **TypeScript** · **Tailwind CSS**
· **Supabase** (base de données PostgreSQL + authentification) · déploiement **Vercel**.

---

## 📐 La formule de bénéfice (reprise de votre fichier)

```
Bénéfice net = Rentrée inscriptions
             + Rentrée buvette
             − Dépense buvette
             − Total achats divers
             − Total frais association
```

- Pour un **tournoi en cours**, la rentrée inscriptions est calculée automatiquement :
  `nombre de joueurs payés × tarif par joueur`.
- Pour les **tournois archivés** (historique), le total d'inscriptions saisi dans
  votre fichier est conservé tel quel.

---

## 🗂️ Structure du projet

```
cap-homard/
├── app/
│   ├── page.tsx                      Page d'accueil publique
│   ├── login/page.tsx                Connexion organisateur
│   ├── inscription/page.tsx          🔗 Lien public unique — liste des tournois ouverts
│   ├── tournoi/[slug]/page.tsx       Formulaire d'inscription d'un tournoi
│   └── admin/
│       ├── page.tsx                  Liste des tournois actifs
│       ├── tournoi/[id]/page.tsx     Tableau de bord d'un tournoi
│       └── historique/…              Tournois archivés
├── components/                       Composants React (formulaire, dashboard, affiche…)
├── lib/
│   ├── finance.ts                    ⭐ Le module de calcul financier exact
│   ├── export.ts                     Export Excel
│   ├── upload.ts                     Envoi des affiches (Supabase Storage)
│   └── supabase/                     Connexion Supabase (client + serveur)
├── supabase/
│   ├── schema.sql                    ⭐ Nouvelle install : tables + sécurité + stockage
│   ├── migration_v2.sql              ⭐ Base existante : ajoute les nouveautés v2
│   └── seed.sql                      ⭐ Votre historique (après schema.sql)
├── middleware.ts                     Protection de l'espace /admin
└── .env.example                      Variables d'environnement à copier
```

---

## 🚀 Installation pas à pas

### 1. Créer le projet Supabase

1. Aller sur [supabase.com](https://supabase.com), créer un compte, puis
   **New project**. Choisissez une région proche (Europe).
2. Notez le mot de passe de la base de données.
3. Une fois le projet créé, allez dans **Project Settings → API** et récupérez :
   - **Project URL** (ex. `https://xxxx.supabase.co`)
   - la clé **anon public**

### 2. Créer les tables et importer l'historique

Dans Supabase, ouvrez **SQL Editor → New query**, puis :

1. Copiez-collez tout le contenu de **`supabase/schema.sql`** → **Run**.
   (Crée les tables, la sécurité, le **bucket d'affiches** `tournoi-images`, et les
   fonctions d'inscription publique.)
2. Nouvelle requête : copiez-collez tout **`supabase/seed.sql`** → **Run**.
   (Importe vos 13 tournois, 422 équipes, achats et frais.)

> L'ordre est important : **schema.sql** d'abord, **seed.sql** ensuite.

> **Vous avez déjà une base en place ?** N'exécutez pas à nouveau schema.sql.
> Lancez les migrations manquantes, dans l'ordre, comme nouvelles requêtes SQL
> (chacune est idempotente et ne touche pas à vos données) :
> **`supabase/migration_v2.sql`** (affiche, contact d'équipe, lien public, bucket)
> puis **`supabase/migration_v3.sql`** (limite de places « complet » + suivi des
> boissons) puis **`supabase/migration_v4.sql`** (liste d'attente). Si vous partez
> de schema.sql à jour, tout est déjà inclus.

### 3. Créer votre compte organisateur

Dans Supabase : **Authentication → Users → Add user → Create new user**.
Renseignez votre e-mail et un mot de passe. C'est ce compte qui vous connectera
à l'espace `/admin`. (Aucune inscription publique n'est possible — seuls les
comptes créés ici peuvent se connecter.)

### 4. Configurer les variables d'environnement

Copiez `.env.example` en `.env.local` et remplissez :

```bash
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=votre-cle-anon-public
```

### 5. Lancer en local

```bash
npm install
npm run dev
```

Ouvrez [http://localhost:3000](http://localhost:3000).
- Espace organisateur : [http://localhost:3000/login](http://localhost:3000/login)

---

## ☁️ Déploiement sur Vercel

1. Poussez ce dossier sur un dépôt **GitHub**.
2. Sur [vercel.com](https://vercel.com) : **Add New → Project**, importez le dépôt.
3. Dans **Environment Variables**, ajoutez les deux mêmes variables qu'au point 4
   (`NEXT_PUBLIC_SUPABASE_URL` et `NEXT_PUBLIC_SUPABASE_ANON_KEY`).
4. **Deploy**. Vercel détecte Next.js automatiquement.

> ℹ️ Le provisionnement de Supabase et le déploiement Vercel se font depuis vos
> propres comptes (ils ne peuvent pas être réalisés à votre place). Les étapes
> ci-dessus sont tout ce dont vous avez besoin.

---

## 🧭 Utilisation

### Créer un tournoi
Espace organisateur → **Nouveau tournoi**. Choisissez le nom, une **affiche**
(optionnelle), le format, la date, le tarif par joueur (10 € par défaut) et le
**nombre de places** (équipes) — laissez vide pour illimité. Les tableaux
financiers démarrent **vides**. Le nombre de places est modifiable à tout moment
depuis l'onglet **Aperçu → Réglages**.

### Recueillir les inscriptions
Partagez le **lien unique** `/inscription`. Les joueurs y voient tous les tournois
ouverts (avec leur affiche), choisissent le leur, renseignent leur **contact**
(prénom, nom, téléphone), leur composition (4 à 8 joueurs), acceptent les
**engagements** et valident. Le règlement se fait **sur place** (carte ou espèces).
Quand le quota de places est atteint, la page affiche **« Tournoi complet »** et
propose un bouton **« S'inscrire en liste d'attente »** (même formulaire). Pour
fermer un tournoi manuellement : **Aperçu → Réglages → Clôturer**.

### Gérer la liste d'attente
Les équipes inscrites en liste d'attente n'occupent pas de place et n'entrent pas
dans les finances. Elles apparaissent dans l'onglet **Équipes**, dans une section
**« Équipes en liste d'attente »** en bas, **numérotées par ordre d'inscription**
(1, 2, 3…). Si une équipe inscrite déclare forfait, ouvre la première de la liste
et clique **« Faire passer inscrite »** : elle rejoint les équipes inscrites et
libère sa place dans la file.

### Suivre paiements, boissons et équipes
Onglet **Équipes** : dépliez une équipe pour **tout modifier** — nom d'équipe,
contact, noms des joueurs, ajout / suppression de joueurs. Pour chaque joueur, deux
cases : **Payé** et **🥤 Boisson** (la boisson offerte a-t-elle été récupérée). Le
statut de paiement passe de 🔴 → 🟠 → 🟢, et l'Aperçu récapitule les places
occupées et le total des boissons récupérées. Recherche par équipe, joueur ou
contact.

### Archiver ou supprimer
Depuis la liste des tournois (menu **…**) ou le tableau de bord : **Archiver**
bascule le tournoi vers l'Historique ; **Supprimer** le retire définitivement
(confirmation demandée). Dans l'Historique, vous pouvez **Désarchiver** ou supprimer.

### Suivre les finances
Onglet **Finances** : saisissez la buvette (recette / dépense), ajoutez vos achats
divers et frais. Le **bénéfice net** se recalcule en direct avec votre formule.

### Exporter
Boutons **Export Excel** (classeur équipes + finances) et **Export PDF**
(via l'impression du navigateur).

### Historique
Menu **Historique** : consultez le bilan et les équipes de chaque tournoi archivé,
ainsi que le **bénéfice cumulé** de l'association.

---

## ✅ Vérifier les formules vous-même

```bash
npm run verify:finance
```

Recalcule le bénéfice des 13 tournois de votre fichier et le compare aux montants
d'origine (résultat attendu : `13/13 tournois reproduits à l'identique`).

---

## 🎨 Charte

Direction artistique **monochrome premium**, inspirée de l'univers Apple / Notion /
Linear : noir profond, blanc, gris anthracite. Interface épurée, moderne, sportive
et professionnelle. Les couleurs ne servent qu'aux **statuts de paiement** (vert /
orange / rouge, façon couleurs système). L'affiche du tournoi est fortement mise en
avant sur la page publique pour une immersion immédiate. Entièrement responsive,
pensé mobile d'abord.

Tokens dans `tailwind.config.ts` : `noir`, `encre`, `ardoise`, `ligne`, `brume`,
`nuage`, `blanc`, `anthracite`.

# 🦞 CAP HOMARD BEACH VOLLEY 974 — Gestion des tournois

Application web complète pour gérer les inscriptions et les finances des tournois
de beach-volley de l'association **CAP HOMARD BEACH VOLLEY 974** (La Réunion).

- **Inscriptions publiques** via un lien unique par tournoi (`/tournoi/<slug>`).
- **Espace organisateur sécurisé** : tableau de bord, suivi des paiements par joueur,
  bilan financier automatique, historique importé depuis votre fichier.
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
│   ├── tournoi/[slug]/page.tsx       Formulaire d'inscription public
│   └── admin/
│       ├── page.tsx                  Liste des tournois actifs
│       ├── tournoi/[id]/page.tsx     Tableau de bord d'un tournoi
│       └── historique/…              Tournois archivés (lecture seule)
├── components/                       Composants React (formulaire, dashboard…)
├── lib/
│   ├── finance.ts                    ⭐ Le module de calcul financier exact
│   ├── export.ts                     Export Excel
│   └── supabase/                     Connexion Supabase (client + serveur)
├── supabase/
│   ├── schema.sql                    ⭐ À exécuter en 1er : tables + sécurité
│   └── seed.sql                      ⭐ À exécuter en 2nd : votre historique
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
   (Crée les tables, la sécurité, et les fonctions d'inscription publique.)
2. Nouvelle requête : copiez-collez tout **`supabase/seed.sql`** → **Run**.
   (Importe vos 13 tournois, 422 équipes, achats et frais.)

> L'ordre est important : **schema.sql** d'abord, **seed.sql** ensuite.

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
Espace organisateur → **Nouveau tournoi**. Choisissez le nom, le format, la date et
le tarif par joueur (10 € par défaut). Deux lignes de frais récurrents (assurances)
sont pré-remplies — modifiables.

### Recueillir les inscriptions
Onglet **Aperçu** → copiez le **lien d'inscription public** et partagez-le.
Les équipes saisissent leur nom et de 4 à 8 joueurs ; elles apparaissent
automatiquement dans l'onglet **Équipes**.

### Suivre les paiements
Onglet **Équipes** : dépliez une équipe et cochez les joueurs qui ont payé.
Le statut passe automatiquement de 🔴 Non payé → 🟠 Partiel → 🟢 Payé.
Recherche par nom d'équipe ou de joueur, ajout / suppression d'équipe.

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

Thème sombre « océan » aux couleurs de l'association : bleu lagon turquoise,
accent corail/orange homard, fond abysse. Responsive et pensé mobile d'abord.

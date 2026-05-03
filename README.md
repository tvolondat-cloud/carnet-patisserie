# 🥐 Brigade Sucrée

> *« Tu fais partie de la Brigade Sucrée. »*

PWA mobile-first pour les étudiants **CAP Pâtissier** et particuliers passionnés de pâtisserie. Carnet de recettes, mode laboratoire (test → quiz → chrono), suivi de progression et export PDF.

**Production** : https://brigadesucree.app · https://brigadesucree.fr
**Repo** : https://github.com/tvolondat-cloud/carnet-patisserie

> **Stack** : SvelteKit · Supabase · vite-plugin-pwa · jsPDF · Chart.js
> **Mobile-first** (max-width 480px) · **Offline-first** (Workbox) · **Vanilla CSS** (design tokens)

---

## ⚡ Quick start

```bash
# 1. Installer les dépendances
npm install

# 2. Copier le template d'env et remplir avec tes clés Supabase
cp .env.example .env.local

# 3. Lancer en dev
npm run dev
# → http://localhost:5173
```

Voir [`docs/SETUP.md`](docs/SETUP.md) pour la config Supabase complète (schéma SQL, OAuth Google, RLS).

---

## 📐 Architecture

```
src/
├── lib/
│   ├── data/recipes.json         ← 17 recettes CAP (fallback statique)
│   ├── stores/
│   │   ├── auth.js               ← session, profil, OAuth, signOut
│   │   ├── recettes.js           ← CRUD recettes + ingrédients + commentaires
│   │   └── progression.js        ← statuts, scores, stats dérivées
│   └── supabase.js               ← client singleton
├── routes/
│   ├── +layout.svelte            ← auth guard + bottom nav
│   ├── +page.svelte              ← Home (score ring, exam countdown)
│   ├── auth/                     ← login + callback OAuth
│   ├── recettes/                 ← liste + fiche détail
│   ├── laboratoire/[id]/         ← Mode Labo (3 étapes)
│   ├── suivi/                    ← Dashboard progression
│   ├── reviser/                  ← Hub révision par statut
│   ├── ordonnancement/           ← Cours EP1/EP2 (7 sections)
│   └── carnet-pdf/               ← Export PDF
├── app.css                       ← Design system complet
└── app.html                      ← Shell HTML PWA

supabase/
├── schema.sql                    ← 6 tables + RLS + triggers
└── seed.sql                      ← seed_recettes_cap(user_id)
```

Détails complets : [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)

---

## 🎯 Features

### Mode Laboratoire (cœur du produit)
Stepper 3 étapes : **Tester → Quiz → Chrono**.
- Quiz validé si score ≥ 75 %
- Chrono validé si temps ≤ chrono_cible × 1.2
- Recette **maîtrisée** quand les 3 étapes sont validées

### Calculateur de rendement
Multiplicateur 0.25× à 10×, mise à jour temps réel des ingrédients. Édition inline persistée en Supabase.

### Notes & commentaires
- Notes libres avec auto-save (debounce 800 ms)
- Commentaires catégorisés : `note` · `astuce` · `erreur` · `variation`

### Export PDF
100 % client-side via jsPDF. Format A4, marge gauche 3 cm (perforation classeur 3 trous), couleurs Berry Jam (`#7D2333`).

---

## 🚦 Scripts

```bash
npm run dev      # serveur dev (HMR + PWA)
npm run build    # build production (adapter-static)
npm run preview  # tester le build localement
```

---

## 🔐 Variables d'environnement

```env
VITE_SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOi...
```

⚠️ La clé **anon** est publique (utilisée côté navigateur, RLS protège). **Ne jamais commit** la clé `service_role`.

---

## 📚 Documentation

| Doc | Contenu |
|---|---|
| [`docs/SETUP.md`](docs/SETUP.md) | Création projet Supabase, schéma SQL, Google OAuth |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Stores Svelte, modèle de données, design system |
| [`docs/AUDIT.md`](docs/AUDIT.md) | Audit du conseil — bugs, sécurité, optimisations, roadmap |
| [`CLAUDE.md`](CLAUDE.md) | Spec produit & contraintes techniques (NE PAS modifier sans validation) |

---

## 🚧 Roadmap

**Sprint 1 (en cours)** : Onboarding, freemium gate, landing page, page profil
**Sprint 2** : Upload photos (Supabase Storage), favoris, mode cuisine grand format
**Sprint 3** : Stripe, push notifications, streak hebdo

Détail dans [`CLAUDE.md`](CLAUDE.md) section *Roadmap produit*.

---

## 📝 Licence

Privé — tous droits réservés.

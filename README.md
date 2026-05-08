# 🥐 Brigade Sucrée

> *« Tu fais partie de la Brigade Sucrée. »*

PWA mobile-first pour les étudiants **CAP Pâtissier** et particuliers passionnés de pâtisserie. Carnet de recettes, mode laboratoire (test → quiz → chrono), suivi de progression et export PDF.

| | |
|---|---|
| **Production** | https://brigadesucree.app |
| **Repo** | https://github.com/tvolondat-cloud/carnet-patisserie |
| **Stack** | SvelteKit · Supabase · Cloudflare Pages · vite-plugin-pwa · jsPDF |

**Mobile-first** (max-width 480px) · **Offline-first** (Workbox) · **Vanilla CSS** (design tokens) · **Dark mode auto** · **PWA installable**

---

## ⚡ Quick start

```bash
# 1. Installer les dépendances (active aussi les git hooks)
npm install

# 2. Copier le template d'env et remplir avec tes clés Supabase
cp .env.example .env.local

# 3. Lancer en dev
npm run dev
# → http://localhost:5173
```

Voir [`docs/SETUP.md`](docs/SETUP.md) pour la config Supabase complète (schéma SQL, RLS, OAuth Google).

---

## 📐 Architecture

```
src/
├── lib/
│   ├── data/                     ← recipes.json, fiches-cap.json, questions-examen.json
│   ├── stores/                   ← auth, recettes, progression
│   ├── components/               ← ConsentBanner.svelte
│   ├── analytics.js              ← GTM/GA4 wrapper + Consent Mode v2
│   └── supabase.js               ← client + flowType:'pkce'
├── routes/
│   ├── +layout.svelte            ← auth guard + bottom nav + tracking
│   ├── +page.svelte              ← Home (score ring, exam countdown)
│   ├── auth/                     ← login + callback OAuth
│   ├── recettes/                 ← liste + fiche détail + calculateur
│   ├── laboratoire/[id]/         ← Mode Labo 3 étapes
│   ├── suivi/                    ← Dashboard
│   ├── reviser/                  ← Hub révision
│   ├── ordonnancement/           ← Cours EP1/EP2
│   ├── carnet-pdf/               ← Export PDF
│   └── profil/                   ← Édition profil + signOut + privacy
├── app.css                       ← Design system + dark mode + a11y
└── app.html                      ← Shell + GTM + Consent Mode v2 + canonical

scripts/
├── generate-icons.js             ← Génère 7 icônes PWA depuis SVG
└── sync-docs.js                  ← Auto-update CHANGELOG depuis git log

.githooks/
└── pre-push                      ← Lance sync-docs avant push (auto-actif via npm install)

supabase/
├── schema.sql                    ← 6 tables + RLS
├── seed.sql                      ← 17 recettes CAP
└── migrations/                   ← Sécurité, contraintes, idempotence
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
Multiplicateur 0.25× à 10×, mise à jour temps réel des ingrédients. Édition inline persistée en Supabase avec optimistic updates et rollback.

### Notes & commentaires
- Notes libres avec auto-save (debounce 800 ms)
- Commentaires catégorisés : `note` · `astuce` · `erreur` · `variation`

### Suivi & Profil
- Score ring + countdown date d'examen
- Skill bars par compétence CAP
- Export PDF du carnet (Berry Jam `#7D2333`, marge 3 cm classeur)
- Cours d'ordonnancement EP1/EP2 (7 sections)
- Dark mode automatique selon préférence système

### Analytics RGPD-compliant
GTM + GA4 avec **Consent Mode v2** : aucun cookie analytics avant opt-in explicite. Bannière de consentement révocable depuis le profil.

---

## 🚦 Scripts

```bash
npm run dev          # serveur dev (HMR + PWA active)
npm run build        # build production (adapter-static)
npm run preview      # tester le build localement
npm run icons        # régénère les 7 icônes PWA depuis SVG
npm run docs:sync    # synchronise CHANGELOG.md depuis git log
```

À chaque `git push`, le hook `pre-push` lance automatiquement `docs:sync` et crée un commit `docs(auto):` si CHANGELOG a évolué. Voir [`docs/UPDATE-DOCS.md`](docs/UPDATE-DOCS.md).

---

## 🔐 Variables d'environnement

```env
VITE_SUPABASE_URL=https://wkexxddknocpmwgfvodw.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOi...
```

⚠️ La clé **anon** est publique (utilisée côté navigateur, RLS protège). **Ne jamais commit** la clé `service_role`.

En **production** sur Cloudflare Pages : Settings → Environment variables. En **dev** : `.env.local` (gitignored).

---

## 📚 Documentation

| Doc | Contenu |
|---|---|
| [`CLAUDE.md`](CLAUDE.md) | **Source de vérité** — contexte projet complet pour Claude Code |
| [`docs/SETUP.md`](docs/SETUP.md) | Création projet Supabase, schéma SQL, Google OAuth |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Stores Svelte, modèle de données, design system |
| [`docs/AUDIT.md`](docs/AUDIT.md) | Audit du conseil — bugs, sécurité, optimisations, roadmap |
| [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) | Déploiement Cloudflare Pages + custom domain + monitoring |
| [`docs/UPDATE-DOCS.md`](docs/UPDATE-DOCS.md) | Routine d'auto-update des docs (script + git hook) |
| [`CHANGELOG.md`](CHANGELOG.md) | Historique des évolutions (auto-géré) |

---

## 🚧 Roadmap

**Sprint 1 (en cours)** : Module Fiches CAP, Examen blanc 60 QCM, Onboarding 3 écrans, Freemium gate, Page profil avancée, Install prompt PWA, Skeleton loaders

**Sprint 2** : Upload photos (Supabase Storage), Favoris, Mode cuisine grand format, Partage recette public

**Sprint 3** : Stripe (Pro 4,99€/mois · Annuel 39€/an), Push notifications, Streak hebdo, Email digest

Détail dans [`CLAUDE.md`](CLAUDE.md) section *Roadmap produit*.

---

## 📝 Licence

Privé — tous droits réservés.

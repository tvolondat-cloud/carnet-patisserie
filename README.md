# 🥐 Brigade Sucrée

> *« Tu fais partie de la Brigade Sucrée. »*

PWA mobile-first pour les étudiants **CAP Pâtissier** et particuliers passionnés de pâtisserie. **58 recettes** du référentiel officiel 2025-2026, mode laboratoire (test → quiz → chrono), suivi de progression et export PDF. Modèle **freemium** : 10 recettes gratuites, plan Pro (4,99 €/mois ou 39 €/an) pour tout débloquer.

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
│   ├── data/                     ← recipes.json (58 recettes), fiches-cap.json, questions-examen.json, landing-faq.js
│   ├── stores/                   ← auth (isPro, FREE_RECIPE_SLUGS), recettes, progression
│   ├── components/landing/       ← Hero, Pricing, FAQ, SEO… (landing prérendue)
│   ├── components/               ← ConsentBanner.svelte
│   ├── utils/slugify.js          ← nom recette → slug URL
│   ├── analytics.js              ← GTM/GA4 wrapper + Consent Mode v2
│   └── supabase.js               ← client + flowType:'pkce'
├── routes/
│   ├── +layout.svelte            ← auth guard + nav (sidebar/bottom) + tracking
│   ├── +page.svelte              ← Landing (anon) / Home (score ring, countdown)
│   ├── auth/                     ← login + callback OAuth
│   ├── recettes/                 ← liste + menu "comptoir" + fiche + calculateur (gate Pro)
│   ├── laboratoire/[id]/         ← Mode Labo Test→Quiz (gate Pro ; chrono sur la fiche recette)
│   ├── suivi/ · reviser/ · ordonnancement/ · carnet-pdf/ (gate Pro) · profil/ (#plan)
├── app.css                       ← Design system + dark mode + a11y
└── app.html                      ← Shell + GTM + Consent Mode v2 + canonical

scripts/
├── generate-icons.js             ← Génère favicon + icônes PWA depuis scripts/favicon-source.png
├── generate-seed.js              ← Génère seed.sql depuis recipes.json (npm run seed:generate)
├── security-scan.js              ← Scan secrets + npm audit (CI + pre-push)
└── sync-docs.js                  ← Auto-update CHANGELOG depuis git log

.github/workflows/                ← CI (build + security) + docs-nightly (cron 18h)
.githooks/pre-push                ← build check + security + sync-docs (auto via npm install)

supabase/
├── schema.sql                    ← tables + RLS
├── seed.sql                      ← 58 recettes CAP (AUTO-GÉNÉRÉ — ne pas éditer à la main)
└── migrations/                   ← sécurité, contraintes, idempotence, plan freemium
```

Détails complets : [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)

---

## 🎯 Features

### Mode Laboratoire (cœur du produit)
Mode Labo = **Tester → Quiz**. Le **chrono** est sur la fiche recette (on suit les étapes en se chronométrant).
- Quiz validé si score ≥ 75 %
- Chrono validé si temps ≤ chrono_cible × 1.2
- Recette **maîtrisée** = testé + quiz + chrono validés (sinon **validée** au quiz seul)

### Calculateur de rendement
Multiplicateur 0.25× à 10×, mise à jour temps réel des ingrédients. Édition inline persistée en Supabase avec optimistic updates et rollback.

### Notes & commentaires
- Notes libres avec auto-save (debounce 800 ms)
- Commentaires catégorisés : `note` · `astuce` · `erreur` · `variation`

### Freemium
- 10 recettes gratuites (`FREE_RECIPE_SLUGS`) · Pro = 58 recettes + Carnet PDF + fiches + QCM
- Gate client via `isPro` (dérivé de `profiles.plan` : `free|pro|admin`), paywall → `/profil#plan`
- Pricing : Pro 4,99 €/mois ou **39 €/an (−35 %)**

### Landing (visiteurs anonymes, prérendue)
- Hero plein écran avec **fiche recette interactive** (calculateur de rendement + étapes dépliables)
- Pricing freemium, comparatif, FAQ unifiée, schema.org (Organization/WebApplication/FAQPage)

### Suivi & Profil
- Score ring + countdown date d'examen · Skill bars par compétence CAP
- Export PDF du carnet (Berry Jam `#7D2333`, marge 3 cm classeur)
- Cours d'ordonnancement EP1/EP2 (7 sections) · Dark mode automatique

### Analytics RGPD-compliant
GTM + GA4 avec **Consent Mode v2** : aucun cookie analytics avant opt-in explicite. Bannière de consentement révocable depuis le profil.

---

## 🚦 Scripts

```bash
npm run dev            # serveur dev (HMR + PWA active)
npm run build          # build production (adapter-static)
npm run preview:check  # build + preview local (OBLIGATOIRE avant push)
npm run icons          # régénère favicon + icônes PWA depuis scripts/favicon-source.png
npm run seed:generate  # régénère supabase/seed.sql depuis recipes.json
npm run security       # scan sécurité (secrets + npm audit)
npm run docs:sync      # synchronise CHANGELOG.md depuis git log
npm run push:staging   # pousse sur staging
npm run push:prod      # pousse main → prod (brigadesucree.app)
```

⚠️ `supabase/seed.sql` est **auto-généré** : modifier `src/lib/data/recipes.json` puis `npm run seed:generate`, ne jamais éditer le SQL à la main.

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
| [`docs/PRD.md`](docs/PRD.md) | **PRD — source produit unique** : vision, idées, roadmap, matrice ICE |
| [`CLAUDE.md`](CLAUDE.md) | **Source de vérité technique** — contexte projet pour Claude Code |
| [`docs/SETUP.md`](docs/SETUP.md) | Création projet Supabase, schéma SQL, Google OAuth |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Stores Svelte, modèle de données, design system |
| [`docs/AUDIT.md`](docs/AUDIT.md) | Audit du conseil — bugs, sécurité, optimisations (historique) |
| [`docs/roadmap-audit-2026.md`](docs/roadmap-audit-2026.md) | Annexe PRD : audit 2026, prospection B2B, spec feature PRO |
| [`docs/carnet-cap-2025-2026.md`](docs/carnet-cap-2025-2026.md) | Référentiel CAP (quantités, techniques) — source contenu recettes |
| [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) | Déploiement Cloudflare Pages + custom domain + monitoring |
| [`docs/UPDATE-DOCS.md`](docs/UPDATE-DOCS.md) | Routine d'auto-update des docs (script + git hook) |
| [`CHANGELOG.md`](CHANGELOG.md) | Historique des évolutions (auto-géré) |

---

## 🚧 Roadmap

✅ **Livré récemment** : modèle freemium (10 recettes gratuites / Pro), 58 recettes,
landing refondue, menu catégories "comptoir", PRD + priorisation ICE.

📌 **Roadmap & priorisation canoniques** → [`docs/PRD.md`](docs/PRD.md)
(catalogue d'idées §5, roadmap par horizon §6, matrice ICE §7).
Prochains chantiers prioritaires : instrumentation KPI, Wake Lock, pages recettes
publiques SEO, offre B2B CFA.

---

## 📝 Licence

Privé — tous droits réservés.

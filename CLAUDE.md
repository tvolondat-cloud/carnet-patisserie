# BRIGADE SUCRÉE — Claude Code System Prompt

> **Dernière mise à jour** : 2026-05-18

## Rôle
Tu es un expert senior SvelteKit, Supabase, PWA et déploiement Cloudflare. Tu travailles sur **Brigade Sucrée**, une PWA mobile-first pour les étudiants CAP Pâtissier et les particuliers passionnés de pâtisserie.

**Tagline** : *« Tu fais partie de la Brigade Sucrée. »*

Tu exécutes, améliores et optimises. Tu ne remets pas en question les décisions architecturales validées (voir §Interdits).

---

## 🔑 ACCÈS GITHUB — À LIRE EN PREMIER, CHAQUE SESSION

**Owner du projet** : Timothy Volondat — email `tvolondat@gmail.com`
**Compte GitHub correct** : `tvolondat-cloud` (NOT `googlepartner-debug`)
**Repo** : https://github.com/tvolondat-cloud/carnet-patisserie

### ⚠️ Bug connu : Windows Credential Manager mal configuré

Le système d'exploitation a un cache obsolète qui pointe vers
`googlepartner-debug` (ancien compte). Un `git push` direct échoue avec
**403 Permission denied**.

### ✅ Solution validée — utiliser le token gh CLI à chaque push

`gh` est authentifié comme `tvolondat-cloud` (vérifie avec `gh auth status`).
Le pattern qui marche pour pousser :

```bash
TOKEN=$(gh auth token) && git push "https://x-access-token:${TOKEN}@github.com/tvolondat-cloud/carnet-patisserie.git" main
```

### Workflow standard à chaque changement

```
1. npm run dev          → développer + tester en local
2. npm run preview:check → build + preview local (OBLIGATOIRE avant push)
3. git add / git commit  → conventional commit
4. npm run push:staging  → pousse sur staging (auto-switch compte gh)
5. Valider sur https://staging.brigade-sucree.pages.dev (~90s)
6. npm run push:prod     → pousse sur main = déploiement prod
```

- Le hook `pre-push` lance automatiquement le **build check** + **sync CHANGELOG**
- Bypass build check si besoin : `SKIP_BUILD_CHECK=1 npm run push:staging`
- Le CI GitHub Actions valide aussi chaque push `staging` et `main`

### Vérifications utiles

```bash
gh auth status                                              # doit montrer tvolondat-cloud ✓
gh repo view tvolondat-cloud/carnet-patisserie             # doit afficher le repo
gh run list --repo tvolondat-cloud/carnet-patisserie --limit 3  # voir le dernier CI
curl -s https://brigadesucree.app/_app/version.json        # voir la version prod déployée
curl -s https://staging.brigade-sucree.pages.dev/_app/version.json  # version staging
```

### URLs staging vs prod

| | URL |
|---|---|
| **Prod** | https://brigadesucree.app |
| **Staging** | https://staging.brigade-sucree.pages.dev |

### Si jamais `gh` n'est plus auth comme tvolondat-cloud

Demander à l'utilisateur de lancer (dans un terminal local interactif) :
```bash
gh auth refresh -h github.com
# ou
gh auth login
```

**Ne jamais** lui demander un Personal Access Token (PAT) — passer par `gh`.

---

---

## URLs du projet

| | URL |
|---|---|
| **Production** | https://brigadesucree.app |
| **Production alt.** | https://www.brigadesucree.app (redirect 301 → apex) |
| **Cloudflare interne** | https://brigade-sucree.pages.dev (redirect 301 → apex) |
| **Repo GitHub** | https://github.com/tvolondat-cloud/carnet-patisserie |
| **Supabase** | https://supabase.com/dashboard/project/wkexxddknocpmwgfvodw |
| **Cloudflare Pages** | https://dash.cloudflare.com → Workers & Pages → `brigade-sucree` |

Les domaines `brigadesucree.app` et `brigadesucree.fr` sont enregistrés chez **Gandi** mais leurs **nameservers pointent vers Cloudflare** (DNS managé par CF).

---

## Stack technique — NON NÉGOCIABLE

```
Framework      : SvelteKit 2 + Svelte 4 (pas React, pas Next, pas Vue)
Auth + BDD     : Supabase (PostgreSQL + RLS + Google OAuth + email)
PWA            : vite-plugin-pwa + Workbox (offline-first)
Deploy         : adapter-static → Cloudflare Pages (auto-deploy GitHub)
DNS            : Cloudflare (zones brigadesucree.app et brigadesucree.fr)
CSS            : Vanilla CSS avec design tokens (src/app.css)
Charts         : Chart.js (lazy import)
Export PDF     : jsPDF (client-side, lazy import)
Export XLS     : SheetJS (client-side, prévu Sprint 3)
Typage         : JavaScript + JSDoc (pas TypeScript)
Analytics      : Google Tag Manager + GA4 (Consent Mode v2 RGPD)
Icônes PWA     : sharp (devDep) → script de génération
```

---

## Architecture du projet

```
src/
├── lib/
│   ├── analytics.js              ← Wrapper GTM/GA4 + Consent Mode v2
│   ├── components/
│   │   └── ConsentBanner.svelte  ← Bannière cookies RGPD
│   ├── data/
│   │   ├── recipes.json          ← 58 recettes CAP (12 catégories, compétences) — source de seed.sql
│   │   ├── fiches-cap.json       ← 50 fiches référentiel (PDF source)
│   │   └── questions-examen.json ← 60 QCM examen blanc
│   ├── stores/
│   │   ├── auth.js               ← session, profile, isPro, FREE_RECIPE_SLUGS, signIn/Out
│   │   ├── recettes.js           ← CRUD + cache + optimistic + rollback
│   │   ├── progression.js        ← upsert + stats dérivées
│   │   ├── exam.js               ← notes examen blanc (Supabase + cache local + migration)
│   │   └── realtime.js           ← Supabase Realtime (sync live multi-device)
│   ├── utils/exam-scores.js      ← helpers purs (note /20, statut couleur, moyenne)
│   └── supabase.js               ← client + flowType:'pkce' + polyfill WS (SSR) + env validation
├── routes/
│   ├── +layout.svelte            ← auth guard + nav + tracking + load/refetch focus + Realtime
│   ├── +page.svelte              ← Home V5 (score ring + countdown + activité)
│   ├── auth/
│   │   ├── +page.svelte          ← Login/Signup (form + a11y + FR errors)
│   │   └── callback/+page.svelte ← OAuth callback (poll session)
│   ├── recettes/
│   │   ├── +page.svelte          ← Liste + menu catégories "comptoir" (tuiles colorées + compteurs)
│   │   └── [id]/+page.svelte     ← Détail + calculateur + notes + commentaires
│   ├── laboratoire/[id]/+page.svelte ← Mode Labo 3 étapes
│   ├── suivi/+page.svelte        ← Dashboard skill bars + listes par statut
│   ├── reviser/+page.svelte      ← Hub révision (à enrichir avec /examen)
│   ├── ordonnancement/+page.svelte ← Cours EP1/EP2 (7 sections)
│   ├── carnet-pdf/+page.svelte   ← Export PDF jsPDF
│   ├── profil/+page.svelte       ← Édition profil + Outils + Privacy + signOut
│   └── (à venir) fiches/, fiches/[id]/, reviser/examen/
├── app.css                       ← Design system (tokens + dark mode + a11y)
└── app.html                      ← Shell + GTM + Consent Mode v2 + canonical + OG

supabase/
├── schema.sql                              ← 6 tables + RLS de base + triggers
├── seed.sql                                ← AUTO-GÉNÉRÉ (58 recettes) — ne pas éditer à la main
└── migrations/
    ├── 20260501_security_hardening.sql    ← RLS WITH CHECK + index + constraints + idempotence
    ├── 20260513_fix_oeufs_unite.sql
    ├── 20260513_photos_suggestions_nb_pieces.sql
    ├── 20260514_add_plan_freemium.sql     ← colonne profiles.plan (free/pro/admin)
    ├── 20260521_exam_scores.sql           ← table exam_scores (notes examen blanc, RLS)
    └── 20260521_realtime.sql              ← publication supabase_realtime + REPLICA IDENTITY FULL

scripts/
├── generate-icons.js             ← Génère 7 icônes PWA depuis SVG (lettre B)
├── generate-seed.js              ← Génère seed.sql depuis recipes.json (npm run seed:generate)
├── security-scan.js              ← Scan secrets + npm audit (CI prod + pre-push main)
└── sync-docs.js                  ← Auto-update CHANGELOG depuis git log

.githooks/
└── pre-push                      ← Lance sync-docs avant push

static/
├── favicon.ico, favicon-32.png
├── apple-touch-icon.png
├── icon-192.png, icon-512.png, icon-maskable-512.png
└── icon.svg

docs/
├── SETUP.md
├── ARCHITECTURE.md
├── AUDIT.md
├── DEPLOYMENT.md
└── UPDATE-DOCS.md
```

---

## Base de données Supabase

### Tables
```sql
profiles          -- créé auto via trigger handle_new_user (robuste, fallback metadata) ; colonne plan
recettes          -- user_id, nom, categorie, competences[], temps, difficulte, ep, chrono_cible, notes, etapes (JSONB)
ingredients       -- recette_id, user_id, nom, quantite, unite, ordre
quiz_questions    -- recette_id, user_id, question, reponses[], bonne, ordre
progression       -- user_id, recette_id, statut, tested, quiz_score, chrono_seconds, chrono_valide, UNIQUE(user_id, recette_id)
commentaires      -- user_id, recette_id, contenu, type (note/erreur/astuce/variation)
recipe_photos     -- user_id, recette_id, storage_path  (migration photos)
suggestions       -- user_id, contenu, type            (migration suggestions)
exam_scores       -- user_id, theme, score, total, pct, UNIQUE(user_id, theme)  (notes examen blanc)
```

### Synchronisation multi-device
- Données serveur (Supabase, par `user_id` + RLS) : recettes, progression, notes,
  commentaires, photos, **exam_scores**. Synchronisées entre appareils.
- **3 couches** : (1) chargement au login ; (2) **refetch au focus**
  (`visibilitychange`/`focus` dans `+layout`) ; (3) **Supabase Realtime**
  (`stores/realtime.js`, browser-only, `postgres_changes` filtrés `user_id`).
- Realtime requiert d'avoir exécuté la migration `20260521_realtime.sql`
  (publication `supabase_realtime` + `REPLICA IDENTITY FULL`). Sans elle :
  pas de live, mais le refetch au focus reste actif (dégradation gracieuse).
- Examen blanc : `stores/exam.js` = Supabase source de vérité + cache localStorage
  (offline + migration one-shot des anciennes notes locales).

### Modèle freemium

| Plan | Accès |
|---|---|
| `free` | 10 recettes fondamentales (slugs dans `FREE_RECIPE_SLUGS`), Mode Labo, Suivi, Ordonnancement, Calculateur |
| `pro` | Tout : 58 recettes, Carnet PDF, fiches, QCM |
| `admin` | = pro |

- Colonne `profiles.plan TEXT DEFAULT 'free'` (migration `20260514_add_plan_freemium.sql`)
- Store dérivé `isPro` + Set `FREE_RECIPE_SLUGS` dans `src/lib/stores/auth.js`
- Gate côté client : `locked = !$isPro && !FREE_RECIPE_SLUGS.has(slugify(r.nom))`
- Paywall sur : liste recettes, détail recette, Mode Labo, Carnet PDF
- Slugs gratuits = `slugify(nom)` (ex. « Pâte sablée » → `pate-sablee`)
- Paiement Stripe : Sprint 3 (boutons `disabled` « Bientôt disponible »)

### Statuts progression (ordre)
```
a-tester → testee → validee → maitrisee
```

### RLS (post-migration sécurité)
- Toutes les tables ont `auth.uid() = user_id` ET `WITH CHECK (auth.uid() = user_id)`
- `ingredients`, `quiz_questions`, `progression`, `commentaires` valident en plus que `recette_id` appartient à l'user (anti-cross-user)
- Index secondaires sur user_id, recette_id, (user_id, statut)
- Triggers `set_updated_at` sur recettes et progression
- CHECK constraints : quiz_score ∈ [0,100], chrono_seconds ≥ 0, bonne ∈ [0, len(reponses)), competences whitelist

### Fonctions RPC
- `seed_recettes_cap(p_user_id)` — seed 58 recettes (auto-généré depuis recipes.json)
- `seed_recettes_cap_safe(p_user_id)` — wrapper idempotent (no-op si déjà seedé) ← utilisé par le client
- `get_user_stats(p_user_id)` — stats côté DB (pour optim future)

---

## Variables d'environnement

```env
VITE_SUPABASE_URL=https://wkexxddknocpmwgfvodw.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGci...
```

- En **dev** : `.env.local` à la racine (gitignored)
- En **prod** (Cloudflare Pages) : Settings → Environment variables → Production + Preview
- `NODE_VERSION=20` ajouté à CF Pages env vars (sinon Node trop ancien)

---

## Analytics (GTM + GA4)

| | |
|---|---|
| **GTM Container** | `GTM-KRKFJLVD` |
| **GA4 Property** | `G-XJMXR88JGC` |
| **Stratégie** | Consent Mode v2 — `denied` par défaut en EU/EEA/GB/CH |
| **Bannière** | `src/lib/components/ConsentBanner.svelte`, affichée si pas de choix |
| **Wrapper** | `src/lib/analytics.js` → `track(event, params)` + `events.*` helpers |
| **Dev mode** | `console.log('[analytics]', ...)`, rien envoyé en réel |

### Events tracking actuel
- `page_view` (auto à chaque navigation SvelteKit)
- `sign_up` / `login` (method: google/email)
- `logout`
- `view_recipe` (recipe_id, recipe_name, recipe_categorie, recipe_ep, recipe_difficulte)
- `lab_started` (recipe_id)
- `lab_quiz_completed` (recipe_id, score, passed)
- `lab_chrono_completed` (recipe_id, seconds, passed)
- `recipe_mastered` (recipe_id, recipe_name)
- `notes_saved` (recipe_id)
- `comment_added` (recipe_id, comment_type)
- `pdf_exported` (count, only_maitrisees)
- `profile_updated`
- `consent_granted`

⚠️ Pour que GA4 reçoive les events, il faut configurer dans GTM une balise **Google Tag** avec `Tag ID: G-XJMXR88JGC` + trigger `Initialization - All Pages`, puis **Submit → Publish**.

---

## Données — 58 recettes CAP

Référentiel complet : [`docs/carnet-cap-2025-2026.md`](docs/carnet-cap-2025-2026.md).
Source unique : `src/lib/data/recipes.json` → `npm run seed:generate` → `supabase/seed.sql`.

### Catégories (12)
`cremes` · `pates` · `bases-cap` · `biscuits` · `fours-secs` · `gateaux-voyage` · `choux` · `feuilletage` · `tartes` · `entremets` · `viennoiseries` · `glacages`

### Compétences CAP
`cuissons` · `textures` · `pesees` · `assemblages` · `organisation` · `techniques`

### Répartition (58)
cremes 10 · pates 5 · bases-cap 4 · biscuits 4 · fours-secs 5 · gateaux-voyage 3 · choux 5 · feuilletage 3 · tartes 5 · entremets 7 · viennoiseries 5 · glacages 2

⚠️ `seed.sql` est **auto-généré** : ne jamais l'éditer à la main. Modifier `recipes.json`
puis lancer `npm run seed:generate`, et ré-exécuter le SQL dans Supabase pour mettre à jour
la fonction `seed_recettes_cap` (les users existants gardent leurs recettes — wrapper idempotent).

---

## Features validées (NE PAS MODIFIER)

### Mode Laboratoire (cœur du produit)
- Stepper 3 étapes : Tester → Quiz → Chrono
- Quiz validé si score ≥ 75%
- Chrono validé si temps ≤ chrono_cible × 1.2
- Maîtrisée si les 3 étapes sont validées
- Jamais de message négatif — toujours positif/encourageant

### Calculateur de rendement
- Multiplicateur 0.25 → ×10
- Mise à jour temps réel des ingrédients
- Édition inline (modifier nom, quantité, unité)
- Ajout / suppression d'ingrédients persistés en Supabase
- **Optimistic updates avec rollback** si erreur réseau

### Notes & Commentaires
- Notes libres auto-save (debounce 800ms) + rollback
- Commentaires catégorisés : note / astuce / erreur / variation
- CRUD complet avec optimistic updates + cache TTL 60s

### Export PDF (Mon Carnet)
- Couleur catégories : Berry Jam RGB(125, 35, 51) = `#7D2333`
- Titres recettes en encart beige (`#F5F0E8`)
- Marge gauche 3 cm (perforation classeur 3 trous)
- Grille 3 colonnes, alignement par le haut
- Filtres par catégorie + option "seulement maîtrisées"
- Génération 100% client-side via jsPDF (lazy import)

### Ordonnancement EP1/EP2
- 7 sections navigables avec chips
- Contenu conforme référentiel CAP officiel 2024-2025
- Ordre de priorité EP1 (viennoiserie en premier)
- Ordre de priorité EP2 (insert en premier)

### Page Profil
- Édition prénom, type (CAP/particulier), date d'examen
- Score ring + stats globales
- Outils : Ordonnancement, Carnet PDF
- Plan freemium dynamique (`#plan`) : badge Pro actif, ou CTA upgrade (boutons disabled « Bientôt disponible »)
- Confidentialité (re-paramétrer cookies analytics)
- Bouton signOut avec confirm

---

## Design System

### Tokens CSS principaux (`src/app.css`)
```css
--color-brand: #6c63ff           /* violet principal */
--color-maitrisee: #10b981       /* vert = maîtrisée */
--color-testee: #f59e0b          /* ambre = testée */
--color-validee: #3b82f6         /* bleu = validée */
--color-a-tester: #94a3b8        /* gris = à tester */
--berry-jam: #7D2333             /* PDF */
--nav-h: 64px
--safe-bottom, --safe-top         /* env(safe-area-inset-*) */
```

### Dark mode
Automatique via `@media (prefers-color-scheme: dark)` — tokens override.

### A11y
- `:focus-visible { outline: 2px solid brand }`
- `@media (prefers-reduced-motion: reduce)` → animations désactivées
- Tap targets `.nav-item { min-height: 48px }` (Apple/Android compliant)
- Safe area top (notches iPhone)

### Composants CSS disponibles
`.card`, `.card-sm`, `.recipe-card`, `.btn-primary/secondary/ghost/danger`, `.btn-block/sm/lg`, `.fab`, `.badge-{statut}`, `.badge-ep1/ep2`, `.chip`, `.filter-chips`, `.skill-bar`, `.stepper`, `.step`, `.bottom-nav`, `.nav-item`, `.score-ring`, `.stat-card`, `.spinner`, `.toast`, `.empty-state`, `.input`, `.label`

### Menu catégories "comptoir" (page `/recettes`, styles scoped)
- Grille `.cat-grid` de tuiles `.cat-tile` (responsive 3/4/6 col), pas de scroll tronqué
- Identité couleur par catégorie : map `CAT_COLORS` dans `recettes/+page.svelte`, exposée en `--c` ; teintes via `color-mix()` (dark-mode safe, fallback `--color-surface`)
- Compteur par catégorie calculé réactivement depuis `$recettes` (`catCounts`)
- Repli progressif `visibleCats` : 6 catégories + "Toutes" ; la catégorie active reste toujours visible même repliée
- Cibles ≥ 92px, entrée animée en cascade (`--i`), `prefers-reduced-motion` respecté
- Pour ajouter une catégorie : l'ajouter dans `recipes.json` ET lui donner une teinte dans `CAT_COLORS` (sinon fallback `--color-brand`)

### Bottom nav (5 tabs — refonte itération 2 du conseil)
```
🏠 Accueil (/)  ·  📖 Recettes (/recettes)  ·  🧪 Réviser (/reviser)
📊 Suivi (/suivi)  ·  👤 Profil (/profil)
```
(Ordo et Carnet PDF accessibles depuis `/profil`)

---

## Roadmap produit

> **La roadmap et la priorisation canoniques sont dans le [PRD](docs/PRD.md)**
> (catalogue d'idées §5, roadmap par horizon §6, matrice ICE §7).
> Ci-dessous : uniquement le « déjà livré ». Ne plus tenir de backlog ici.

### ✅ Fait
- MVP : Home, Recettes, Mode Labo, Suivi, Réviser, Ordonnancement, Carnet PDF
- Itérations conseil 1-4 : sécurité (RLS WITH CHECK, index, constraints), UX (icônes
  PWA, profil, a11y, bottom nav), robustesse (rollback, upsert, FR errors), dark mode
- **58 recettes** CAP 2025-2026 (12 catégories dont `glacages`), `seed.sql` auto-généré
- **Modèle freemium livré** : `isPro` + `FREE_RECIPE_SLUGS` (10 recettes gratuites),
  Carnet PDF / Mode Labo Pro, migration `plan` (`free|pro|admin`), paywall cohérent
- **Landing** refondue : hero plein écran avec fiche recette interactive
  (calculateur + étapes dépliables), pricing freemium (annuel −35 % mis en avant),
  FAQ unifiée, schema.org prérendu, cohérence chiffres
- **Menu catégories "comptoir"** (tuiles colorées + compteurs, repli progressif)
- Routines : docs nightly cron, security scan CI, sync CHANGELOG pre-push
- Suite audit 2026 + **PRD** (source produit unique) + roadmap ICE
- Branding + domaines `.fr`/`.app`, Cloudflare Pages custom domain, GTM/GA4 Consent v2

### Backlog & priorisation
→ **[`docs/PRD.md`](docs/PRD.md)** (Fiches CAP, Examen blanc, onboarding, Wake Lock,
pages recettes SEO, B2B CFA, Stripe, feature PRO compta, etc. — tous scorés ICE).

### Mode Compta v2 (prévu) — PRO : coût matières & rentabilité par projet
Tables : `ingredient_prices`, `frais_variables`, `frais_fixes`, `projections_ca`. Export XLSX + CSV + PDF.
Réservé au plan **Pro**. Priorisé ICE 5.0 dans le [PRD §7](docs/PRD.md) ; spec phasée + checklist : [`docs/roadmap-audit-2026.md`](docs/roadmap-audit-2026.md) §6.

---

## Personas

### Léa (19 ans) — CAP Pâtissier
- Priorité : Mode Labo, date exam, statuts recettes, **Fiches & Examen blanc** (Sprint 1)
- WTP : 2-5€/mois
- Usage : labo (mains sales), transport, nuit avant exam

### Sophie (42 ans) — Particulière passionnée
- Priorité : calculateur, photos, collections, partage
- WTP : 8-15€/mois
- Usage : weekend en cuisine, soirée canapé

---

## Commandes utiles

```bash
npm install              # installer les dépendances
npm run dev              # dev avec PWA active (localhost:5173)
npm run build            # build production
npm run preview          # tester le build offline (localhost:4173)
npm run preview:check    # build + preview en une commande (avant tout push)
npm run security         # scan sécurité complet (secrets + npm audit)
npm run security:staged  # scan rapide des fichiers staged seulement
npm run push:staging     # pousse sur la branche staging → staging.brigade-sucree.pages.dev
npm run push:prod        # pousse main en prod → brigadesucree.app
npm run icons            # régénère les 7 icônes PWA depuis SVG
npm run docs:sync        # synchronise CHANGELOG.md depuis git log
```

À chaque `git push` : `pre-push` hook lance build check + `docs:sync` automatiquement.
À chaque push sur `main` : job CI **Security Scan** tourne (secrets + npm audit).

---

## 🔒 Sécurité — Scan automatique

### Ce qui est scanné à chaque push en prod (`main`)

| Vérification | Outil | Déclencheur |
|---|---|---|
| Secrets hardcodés (JWT, tokens, clés privées, credentials dans URLs…) | `scripts/security-scan.js` | CI — job `security` |
| Vulnérabilités npm nouvelles (critical + high hors allowlist) | `npm audit --production` | CI — job `security` |
| Secrets dans les fichiers staged | `npm run security:staged` | Optionnel en local |

### Commandes locales

```bash
npm run security          # scan complet avant un push prod
npm run security:staged   # scan rapide (fichiers staged seulement, sans audit npm)
```

### Patterns détectés

- Clés Supabase `service_role` (toujours bloquant)
- JWTs longs hardcodés (hors `src/lib/supabase.js` et docs)
- GitHub PAT (`ghp_...`) et OAuth token (`gho_...`)
- Clés OpenAI/Anthropic (`sk-...`)
- Clés privées PEM
- Fichiers `.env` commités par accident
- URLs avec credentials intégrés

### Ignorer un faux positif

Ajoute `// security-scan-ignore` en fin de ligne :

```js
const url = `https://x-access-token:${token}@github.com/...`; // security-scan-ignore
```

### Vulnérabilités connues sans fix (allowlist)

Définies dans `scripts/security-scan.js` → `AUDIT_ALLOWLIST` :

| Package | Sévérité | Raison |
|---|---|---|
| `jspdf` | critical | Pas de version corrigée — export PDF client-side uniquement |
| `xlsx` | high | SheetJS ReDoS — exports locaux uniquement, pas de parsing tiers |
| `@sveltejs/kit` | high | Vuln transitive, surveiller les releases |

Pour ajouter un package à l'allowlist, modifier `AUDIT_ALLOWLIST` dans `scripts/security-scan.js` avec le nom, la sévérité et la justification.

---

## Conventions de code

- **Stores Svelte** : toujours `writable` + persistance Supabase + optimistic update + rollback
- **Pas de TypeScript** : JSDoc pour les types
- **CSS** : toujours utiliser les tokens CSS (`var(--color-brand)`), jamais de valeurs hardcodées
- **Offline-first** : toute action doit fonctionner sans réseau (Workbox cache)
- **Jamais de message négatif** dans le Mode Labo — toujours positif
- **Composants** : un fichier = un composant, maximum 300 lignes
- **Imports** : utiliser `$lib/...` pour tous les imports internes
- **Commits** : préfixe `feat:`, `fix:`, `docs:`, `brand:`, `seo:`, `deploy:`, `chore:`, `refactor:` — utilisé par `sync-docs.js` pour catégoriser le CHANGELOG
- **Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>** sur tous les commits AI

---

## Ce qui est interdit

- ❌ Migrer vers React, Next.js ou tout autre framework
- ❌ Ajouter TypeScript (JSDoc seulement)
- ❌ Remplacer Supabase par une autre BDD
- ❌ Modifier la logique du Mode Laboratoire (3 étapes, seuils 75% et ×1.2)
- ❌ Changer les couleurs des statuts (maîtrisée=vert, etc.)
- ❌ Supprimer l'offline-first
- ❌ Ajouter des messages négatifs dans le Mode Labo
- ❌ Hardcoder des couleurs (toujours `var(--color-*)`)
- ❌ Tracker analytics avant consentement (Consent Mode v2 = `denied` par défaut)
- ❌ Exposer la clé `service_role` Supabase côté client
- ❌ Modifier `vite.config.js` pour changer d'adapter (`adapter-static` est verrouillé)
- ❌ Casser les routes existantes : `/`, `/auth`, `/recettes`, `/recettes/[id]`, `/laboratoire/[id]`, `/suivi`, `/reviser`, `/ordonnancement`, `/carnet-pdf`, `/profil`

---

## Produit — PRD (source unique)

📌 **[`docs/PRD.md`](docs/PRD.md) est LE document produit canonique.**
Vision, personas, **catalogue des idées d'évolution**, **roadmap** et
**matrice de priorisation ICE** y vivent. Toute nouvelle idée / repriorisation
entre dans le PRD en premier. Les autres docs le **référencent**, ne le dupliquent pas.
`docs/roadmap-audit-2026.md` n'est plus qu'une **annexe** du PRD (détail audit,
prospection B2B §4, spec feature PRO §6).

## Documentation pointers

- [`docs/PRD.md`](docs/PRD.md) — **PRD : source unique produit (idées, roadmap, ICE)**
- [`README.md`](README.md) — quick start utilisateur
- [`docs/SETUP.md`](docs/SETUP.md) — Supabase + Google OAuth + troubleshooting
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — stores, modèle de données, design system
- [`docs/AUDIT.md`](docs/AUDIT.md) — audit du conseil + roadmap optimisations
- [`docs/roadmap-audit-2026.md`](docs/roadmap-audit-2026.md) — **annexe du PRD** : traçabilité audit 2026, **prospection B2B CFA/écoles** (§4), **spec feature PRO coût/rentabilité** (§6)
- [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) — Cloudflare Pages, custom domain, monitoring
- [`docs/UPDATE-DOCS.md`](docs/UPDATE-DOCS.md) — comment fonctionne la routine doc auto-update
- [`CHANGELOG.md`](CHANGELOG.md) — historique des évolutions (auto-géré)

---

## Si tu reprends ce projet

1. Lis ce CLAUDE.md en entier d'abord
2. Lis le [`docs/PRD.md`](docs/PRD.md) — vision produit, idées, roadmap, priorisation ICE
3. Lis [`CHANGELOG.md`](CHANGELOG.md) pour voir ce qui a été fait récemment
4. Avant de coder : `npm install` + lancer `npm run dev` pour confirmer que l'app tourne en local
5. Pour toute action sensible (DB, paiement, déploiement) : demander confirmation
6. Toujours commit + push avec `Co-Authored-By: Claude Sonnet 4.6`
7. Le hook `pre-push` met à jour CHANGELOG automatiquement avant chaque push

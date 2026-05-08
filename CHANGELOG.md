# Changelog

Toutes les modifications notables sont documentées ici. Format inspiré de [Keep a Changelog](https://keepachangelog.com/), versioning [SemVer](https://semver.org/).

> Ce fichier est **auto-géré** : un hook git `pre-push` lance `npm run docs:sync` avant chaque push pour prepend les nouveaux commits dans la section [Unreleased]. Voir [`docs/UPDATE-DOCS.md`](docs/UPDATE-DOCS.md).

---

## [Unreleased]

### 📝 Documentation
- Réécriture complète de `CLAUDE.md` avec contexte projet à date (branding, prod URL, GA4, déploiement, audit, conventions)
- Nouveau `README.md` avec quick start, architecture, scripts, environnements
- Nouveau `docs/UPDATE-DOCS.md` documentant la routine d'auto-update
- `CHANGELOG.md` réorganisé avec catégories par emoji

### 🧹 Tooling
- Nouveau script `scripts/sync-docs.js` : prepend automatique des commits récents dans CHANGELOG `[Unreleased]`, groupés par préfixe conventional commits
- Nouveau hook `.githooks/pre-push` : lance `sync-docs` avant chaque push, crée un commit `docs(auto):` si CHANGELOG modifié
- `package.json` : ajout des scripts `docs:sync` et `prepare` (active `core.hooksPath`)

---

## [0.4.0] — 2026-05-04 — Production live

### ✨ Features
- **Brigade Sucrée en ligne** sur https://brigadesucree.app (Cloudflare Pages)
- Domaines `brigadesucree.app` et `brigadesucree.fr` actifs (DNS managé par Cloudflare)
- HTTPS automatique via Google Trust Services
- Redirects 301 client-side : `www.brigadesucree.app` et `brigade-sucree.pages.dev` → apex `brigadesucree.app`

### 🔍 SEO
- Tag `<link rel="canonical" href="https://brigadesucree.app">` pour éviter l'indexation des doublons
- Meta Open Graph (og:site_name, og:type, og:url, og:title, og:description, og:image)
- Meta `twitter:card`

### ✨ Analytics
- **GTM** (`GTM-KRKFJLVD`) injecté dans `<head>` + `<noscript>` body
- **GA4** (`G-XJMXR88JGC`) configurable via GTM UI
- **Consent Mode v2** RGPD : `denied` par défaut en EU/EEA/GB/CH
- Bannière de consentement (`ConsentBanner.svelte`) avec persistance localStorage
- Wrapper `analytics.js` avec `track()` et helpers `events.*`
- 12 events métier câblés : sign_up, login, view_recipe, lab_started, lab_quiz_completed, lab_chrono_completed, recipe_mastered, notes_saved, comment_added, pdf_exported, profile_updated, logout
- Page `/profil` permet de re-paramétrer le consentement
- Mode dev : log dans la console au lieu d'envoyer

---

## [0.3.0] — 2026-05-03 — Brigade Sucrée

### 🎨 Branding
- **Rebrand "Carnet" → "Brigade Sucrée"** suite à recherche concurrentielle (mabrigade.io déjà utilisé en SaaS resto)
- Tagline : *« Tu fais partie de la Brigade Sucrée. »*
- Domaines réservés chez Gandi : `brigadesucree.fr` + `brigadesucree.app`
- Aucune collision INPI / Google / Instagram / TikTok après vérif
- Icônes PWA régénérées (lettre **B** au lieu de **C**)
- Manifest, app.html, page d'auth, page profil mis à jour

---

## [0.2.0] — 2026-05-02 — Itérations 1-3 du conseil (sécurité, UX, robustesse)

### 🐛 Sécurité (Itération 1)
- Migration SQL `supabase/migrations/20260501_security_hardening.sql`
- RLS `WITH CHECK` sur toutes les tables (anti-INSERT au nom d'un autre user)
- Validation cross-table : `ingredients`, `quiz_questions`, `progression`, `commentaires` vérifient que `recette_id` appartient à l'user courant
- Index secondaires : `recettes(user_id)`, `ingredients(recette_id, user_id)`, `progression(user_id, statut)`, etc.
- Triggers `updated_at` sur `recettes` et `progression` (BEFORE UPDATE)
- CHECK constraints : `quiz_score ∈ [0,100]`, `chrono_seconds ≥ 0`, `bonne ∈ [0, len(reponses))`, `competences` whitelist
- `seed_recettes_cap_safe()` : wrapper idempotent (no-op si déjà seedé)
- RPC `get_user_stats(p_user_id)` pour stats côté DB

### 🐛 Fixes
- `auth.js` : filtre des events `onAuthStateChange` (TOKEN_REFRESHED ignoré pour reload), reset stores au signOut, lock `seedingPromise` anti race-condition multi-onglets
- `supabase.js` : validation env vars + `flowType: 'pkce'` explicite
- Erreurs auth Supabase traduites en français (`translateAuthError()`)
- `recettes.js` : try/catch + rollback sur tous les CRUD, cache TTL 60s sur commentaires
- `progression.js` : upsert avec `onConflict: 'user_id,recette_id'` (anti-doublon double-clic)

### ✨ UX (Itération 2)
- Auth guard : `{#if shouldRender}` au lieu de `goto()` (plus de flash de page protégée)
- **Page `/profil`** créée : édition prénom + type (CAP/particulier) + date d'examen, accès Ordo + Carnet PDF, bouton signOut
- Bottom nav refondue : 🏠 Accueil · 📖 Recettes · 🧪 Réviser · 📊 Suivi · 👤 Profil (Ordo et Carnet PDF déplacés dans /profil)
- Auth form : `<form on:submit|preventDefault>`, `type="button"` sur boutons non-submit, labels `for`/`id`, `autocomplete`, `required`, `role="alert"`

### 💄 PWA / a11y
- 7 icônes générées via `sharp` : favicon, favicon-32, icon-192, icon-512, icon-maskable-512, apple-touch-icon, icon.svg
- Script `scripts/generate-icons.js` + commande `npm run icons`
- Manifest enrichi : `id`, `lang`, `scope`, `categories`, `purpose: any+maskable`
- `:focus-visible` global avec outline brand
- `@media (prefers-reduced-motion: reduce)` → animations désactivées
- `@media (prefers-color-scheme: dark)` → dark mode automatique
- `.nav-item { min-height: 48px }` (tap target Apple/Android compliant)
- `padding-top: env(safe-area-inset-top)` (notches iPhone)

---

## [0.1.0] — 2026-05-01 — MVP initial

### ✨ Features
- Setup SvelteKit + Vite + adapter-static + vite-plugin-pwa
- 3 stores Svelte : `auth`, `recettes`, `progression`
- 7 routes principales : Home, Auth (+ callback), Recettes (+ détail), Laboratoire, Suivi, Réviser, Ordonnancement, Carnet PDF
- Schéma SQL Supabase (6 tables + RLS basique + triggers `handle_new_user` & `seed_recettes_cap`)
- Seed de 17 recettes CAP Pâtissier
- Design system complet (`src/app.css` — tokens, cards, buttons, badges, stepper, score ring)
- Mode Laboratoire 3 étapes (Tester → Quiz → Chrono)
- Calculateur de rendement
- Notes auto-save + commentaires catégorisés (note/astuce/erreur/variation)
- Export PDF jsPDF (A4, marge 3 cm classeur, couleurs Berry Jam)
- Cours Ordonnancement EP1/EP2 (7 sections)

### Setup initial
- Repo GitHub : https://github.com/tvolondat-cloud/carnet-patisserie
- Projet Supabase : `wkexxddknocpmwgfvodw`

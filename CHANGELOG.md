# Changelog

Toutes les modifications notables seront documentées ici.

Format inspiré de [Keep a Changelog](https://keepachangelog.com/), versioning [SemVer](https://semver.org/).

---

## [Unreleased]

### Documentation
- Ajout `README.md` complet (quick start, architecture, scripts, env)
- Ajout `.env.example` (template à copier)
- Ajout `docs/SETUP.md` (Supabase + Google OAuth + troubleshooting)
- Ajout `docs/ARCHITECTURE.md` (stores, modèle de données, design system, conventions)
- Ajout `docs/AUDIT.md` (audit du conseil + roadmap priorisée des optimisations)
- Ajout `docs/DEPLOYMENT.md` (Vercel + custom domain + monitoring)
- Ajout `CHANGELOG.md`

### À venir (priorisé via AUDIT.md)
- Itération 1 — sécurité critique (RLS `WITH CHECK`, garde idempotente seed, reset stores au signOut)
- Itération 2 — UX bloquants (icônes PWA, page profil, accessibilité, tap targets)
- Itération 3 — robustesse (try/catch + rollback, contraintes SQL, upsert progression)
- Itération 4 — perf (lazy load, cache, dark mode, reduced motion)

---

## [0.1.0] — 2026-05-01

### Initial commit
- Setup SvelteKit + Vite + adapter-static + vite-plugin-pwa
- Stores Svelte : `auth`, `recettes`, `progression`
- 7 routes : Home, Auth (+ callback), Recettes (+ détail), Laboratoire, Suivi, Réviser, Ordonnancement, Carnet PDF
- Schéma SQL Supabase (6 tables + RLS basique + triggers `handle_new_user` & `seed_recettes_cap`)
- Seed de 17 recettes CAP Pâtissier
- Design system complet (`src/app.css` — tokens, cards, buttons, badges, stepper, score ring, …)
- Mode Laboratoire 3 étapes (Tester → Quiz → Chrono)
- Calculateur de rendement
- Notes auto-save + commentaires catégorisés (note/astuce/erreur/variation)
- Export PDF jsPDF (A4, marge 3 cm classeur, couleurs Berry Jam)
- Cours Ordonnancement EP1/EP2 (7 sections)

### Connecté à
- Repo GitHub : https://github.com/tvolondat-cloud/carnet-patisserie
- Projet Supabase : `wkexxddknocpmwgfvodw`

### Bugs connus (cf. AUDIT.md)
- Race condition possible sur `seed_recettes_cap` (2 onglets → doublons)
- RLS sans `WITH CHECK` (faille INSERT cross-user)
- Icônes PWA manquantes dans `static/`
- Bouton signOut non accessible (pas de page profil)
- Onglet Réviser absent du bottom nav
- Inputs sans `for`/`id` (a11y)

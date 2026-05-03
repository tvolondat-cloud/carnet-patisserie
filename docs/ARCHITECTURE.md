# Architecture — Brigade Sucrée

Guide technique : modèle de données, stores Svelte, design system, conventions.

---

## 1. Stack

| Couche | Choix | Pourquoi |
|---|---|---|
| Framework | **SvelteKit 2** + Svelte 4 | Réactif, léger, SSG simple via adapter-static |
| Auth + DB | **Supabase** | Postgres + RLS + OAuth out of the box |
| PWA | **vite-plugin-pwa** + Workbox | Offline-first, install prompt natif |
| Déploiement | **Vercel** + adapter-static | Édition statique = CDN global, gratuit |
| CSS | **Vanilla CSS** + tokens | Pas de runtime, contrôle total |
| Charts | **Chart.js** (lazy) | Suffit pour les besoins, dynamic import |
| PDF | **jsPDF** (lazy) | Client-side, pas de serveur |
| Excel | **SheetJS** (lazy) | Pour mode Compta v2 (futur) |
| Types | **JSDoc** (pas de TS) | Décision projet — voir CLAUDE.md |

---

## 2. Modèle de données

### Schéma relationnel

```
auth.users (Supabase managé)
    │
    └─ profiles (1:1, créé par trigger)
        │   id (PK = auth.users.id)
        │   full_name, avatar_url, profil_type, exam_date
        │
        ├─ recettes (1:N)
        │   id, nom, categorie, competences[], temps, difficulte,
        │   ep, chrono_cible, notes, etapes (JSONB)
        │   │
        │   ├─ ingredients (1:N)
        │   │   nom, quantite, unite, ordre
        │   │
        │   └─ quiz_questions (1:N)
        │       question, reponses[], bonne, ordre
        │
        ├─ progression (1:1 par recette, UNIQUE(user_id, recette_id))
        │   statut, tested, quiz_score, chrono_seconds, chrono_valide
        │
        └─ commentaires (1:N)
            contenu, type (note/astuce/erreur/variation)
```

### Statuts progression

```
a-tester → testee → validee → maitrisee
```

Promotion automatique :
- `tested = true` → `statut = testee`
- `quiz_score ≥ 75` → étape quiz validée
- `chrono ≤ chrono_cible × 1.2` → étape chrono validée
- 3 étapes validées → `statut = maitrisee`

### RLS

Toutes les tables ont `auth.uid() = user_id`. Un user ne voit que ses données.

⚠️ **Faille connue** (à corriger — voir AUDIT.md) : `WITH CHECK` manque, et `recette_id` d'`ingredients` n'est pas validé contre la propriété de la recette.

---

## 3. Stores Svelte

### `src/lib/stores/auth.js`

```js
session         // writable<Session | null>
profile         // writable<Profile | null>
authLoading     // writable<boolean>
isAuthenticated // derived<boolean>

initAuth()              // au démarrage de l'app
signInWithGoogle()      // OAuth
signInWithEmail(e, p)
signUpWithEmail(e, p, nom)
signOut()
```

**Comportement spécial** : `loadProfile()` vérifie si l'user a des recettes ; sinon appelle `rpc('seed_recettes_cap')` pour seeder les 17 recettes.

### `src/lib/stores/recettes.js`

```js
recettes        // writable<Recette[]>  (avec ingredients + quiz_questions imbriqués)
commentaires    // writable<{ [recetteId]: Commentaire[] }>
recettesLoading // writable<boolean>

loadRecettes()                    // au login
loadCommentaires(recetteId)       // au mount de [id]
addCommentaire / deleteCommentaire
updateNotes(recetteId, notes)     // auto-save debounced
addIngredient / updateIngredient / deleteIngredient
```

### `src/lib/stores/progression.js`

```js
progression  // writable<{ [recetteId]: Progression }>
stats        // derived<Stats>  ← recalculé auto

stats = {
  total,
  byStatut: { 'a-tester', testee, validee, maitrisee },
  score,             // % de recettes maîtrisées
  maitrisees,
  competences: { cuissons, textures, ... }   // % par compétence
}
```

---

## 4. Routes

| Route | Rôle |
|---|---|
| `/` | Home V5 — score ring + countdown exam + activité récente |
| `/auth` | Login/Signup (Google + email) |
| `/auth/callback` | OAuth callback (poll session, redirige vers `/`) |
| `/recettes` | Liste avec filtres (catégorie, compétence, statut, recherche) |
| `/recettes/[id]` | Détail — calculateur réactif, notes, commentaires |
| `/laboratoire/[id]` | Mode Labo — stepper Tester → Quiz → Chrono |
| `/suivi` | Dashboard progression (skill bars + listes par statut) |
| `/reviser` | Hub révision groupé par statut, lien vers Labo |
| `/ordonnancement` | Cours EP1/EP2 (7 sections navigables) |
| `/carnet-pdf` | Export PDF (filtres + génération jsPDF) |

### Bottom nav (5 tabs)

🏠 Accueil · 📖 Recettes · 🧪 Réviser · 📊 Suivi · 👤 Profil

(Ordo et Carnet PDF déplacés dans `/profil` après itération 2 du conseil.)

---

## 5. Flux critique : connexion + seed

```
1. user → /auth → signInWithGoogle()
2. Google → /auth/callback (poll getSession 30×200ms)
3. session établie → onAuthStateChange déclenché
4. loadProfile(userId)
   ├─ SELECT * FROM profiles WHERE id = userId
   └─ SELECT count(*) FROM recettes WHERE user_id = userId
       └─ si count = 0 : rpc('seed_recettes_cap', { p_user_id })
           → INSERT 17 recettes + ingredients + quiz_questions
5. loadRecettes() + loadProgression() depuis +layout.svelte onMount
6. redirect → /
```

⚠️ **Race condition** : si l'user ouvre 2 onglets simultanément, le seed peut être appelé 2 fois. Voir AUDIT.md pour le fix (garde idempotente dans la fonction SQL).

---

## 6. Design System

### Tokens (`src/app.css`)

```css
--color-brand: #6c63ff       /* violet principal */
--color-maitrisee: #10b981   /* vert */
--color-testee: #f59e0b      /* ambre */
--color-validee: #3b82f6     /* bleu */
--color-a-tester: #94a3b8    /* gris */
--berry-jam: #7D2333         /* PDF */

--radius-sm/md/lg/xl/full
--shadow-sm/md/lg
--nav-h: 64px
--safe-bottom: env(safe-area-inset-bottom)
```

### Composants CSS

- Layout : `.page`, `.page-title`, `.page-subtitle`
- Cards : `.card`, `.card-sm`, `.recipe-card`
- Buttons : `.btn`, `.btn-primary/secondary/ghost/danger`, `.btn-block/sm/lg`, `.fab`
- Badges : `.badge`, `.badge-{statut}`, `.badge-ep1/ep2`
- Filtres : `.filter-chips`, `.chip`
- Skill : `.skill-bar`, `.skill-bar-track/fill`
- Stepper : `.stepper`, `.step`, `.step-circle`, `.step-label`
- Nav : `.bottom-nav`, `.nav-item`
- Forms : `.input`, `.label`, `.form-group`
- Stats : `.score-ring`, `.stat-grid`, `.stat-card`
- Feedback : `.toast`, `.spinner`, `.empty-state`

### Mobile-first

- Container max 480px centré
- Tap targets ≥ 44px (à corriger sur nav-item — 36px actuellement)
- Safe areas iOS via `env(safe-area-inset-*)`
- Pas de hover-only (utilise `:active` et `:focus-visible`)

---

## 7. Conventions de code

| Règle | Application |
|---|---|
| **Pas de TypeScript** | JSDoc pour types (`/** @typedef {...} */`) |
| **Imports** | Toujours `$lib/...`, jamais de relatifs `../../` |
| **CSS** | Toujours `var(--token)`, jamais de hardcode |
| **Composants** | ≤ 300 lignes par fichier (sinon extraire) |
| **Stores** | `writable` + persistance Supabase + optimistic update |
| **Offline-first** | Toute action doit fonctionner sans réseau (Workbox) |
| **Mode Labo** | **Jamais de message négatif** — toujours encourageant |

---

## 8. PWA

### Manifest (`vite.config.js`)

- `name`, `short_name`, `description`, `theme_color: #6c63ff`
- `display: standalone`, `orientation: portrait`
- ⚠️ Icônes référencées : `icon-192.png`, `icon-512.png` (à créer dans `/static`)

### Service Worker

Généré par Workbox via vite-plugin-pwa :
- Stratégie : `autoUpdate`
- `globPatterns` : tous les assets statiques
- `runtimeCaching` : Supabase API en `NetworkFirst` (1j max, 50 entries)

### Install prompt

Pas encore implémenté — feature listée dans AUDIT.md / Sprint 1.

---

## 9. Build & Déploiement

### Build statique

```bash
npm run build
```

Sortie dans `build/` (HTML + assets pré-générés). adapter-static avec `fallback: 'index.html'` pour le SPA mode (toutes les routes côté client).

### Tailles attendues (à benchmarker)

- Bundle JS initial : ~ 100-150kb (gzip)
- jsPDF / xlsx : lazy import → 0kb dans le bundle initial
- recipes.json : ~ 50kb (statique, fallback)

### Cache PWA

Workbox cache automatiquement tous les assets versionnés. Les modifications du schéma DB ne nécessitent pas de bump cache.

---

## 10. Évolutions prévues

Voir [`CLAUDE.md`](../CLAUDE.md) section *Roadmap produit*.

Mode Compta v2 nécessitera 4 nouvelles tables :
- `ingredient_prices` (prix unitaire + taux perte)
- `frais_variables` (énergie, emballage)
- `frais_fixes` (loyer, assurance)
- `projections_ca` (CA 3/6/12 mois)

Export XLSX + CSV + PDF obligatoires pour cette feature.

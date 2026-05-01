# Audit du conseil — Carnet

> Audit multi-agents lancé après le 1er commit fonctionnel. 2 spécialistes ont rendu leurs findings : **backend/Supabase/sécurité** et **frontend/UX/PWA/a11y**. (2 autres — perf et architecture — ont rate-limité, leurs sujets sont en partie couverts.)

Cette doc liste les points d'attention par sévérité, avec le fix proposé. Sert de **roadmap technique** pour les itérations à venir.

---

## 🚨 Bloquants — à fixer avant prod

### Backend / Sécurité

#### B1. Race condition sur le seed des 17 recettes
**Fichier** : `src/lib/stores/auth.js` + `supabase/seed.sql`
**Problème** : `loadProfile` se déclenche à chaque event `onAuthStateChange` (incl. `TOKEN_REFRESHED`). Avec 2 onglets ouverts, le check `count === 0` puis `seed_recettes_cap` peut s'exécuter en parallèle → **34 recettes au lieu de 17**.

**Fix** :
1. Garde idempotente côté SQL — ajouter au début de `seed_recettes_cap` :
   ```sql
   IF (SELECT COUNT(*) FROM recettes WHERE user_id = p_user_id) > 0 THEN
     RETURN;
   END IF;
   ```
2. Filtrer les events côté client :
   ```js
   supabase.auth.onAuthStateChange((event, newSession) => {
     if (event !== 'SIGNED_IN' && event !== 'INITIAL_SESSION') return;
     // ...
   });
   ```

#### B2. RLS — fuite via `recette_id` cross-user
**Fichier** : `supabase/schema.sql` (tables `ingredients`, `quiz_questions`, `commentaires`)
**Problème** : RLS vérifie `user_id` mais pas que `recette_id` appartient à l'user. Un attaquant peut INSERT un ingrédient avec son `user_id` mais le `recette_id` d'un autre user → pollution.

**Fix** :
```sql
DROP POLICY "Ingrédients utilisateur" ON ingredients;
CREATE POLICY "Ingrédients utilisateur" ON ingredients
FOR ALL USING (auth.uid() = user_id)
WITH CHECK (
  auth.uid() = user_id
  AND EXISTS (SELECT 1 FROM recettes WHERE id = recette_id AND user_id = auth.uid())
);
```
Idem pour `quiz_questions`, `commentaires`, `progression`.

#### B3. Policies sans `WITH CHECK`
**Fichier** : `supabase/schema.sql` (toutes les tables)
**Problème** : `FOR ALL USING` permet l'UPDATE qui change `user_id` → un user peut transférer ses données à un autre, ou s'attribuer celles d'un autre.

**Fix** : ajouter `WITH CHECK (auth.uid() = user_id)` (ou `id` pour `profiles`) sur chaque policy.

#### B4. Optimistic updates sans rollback
**Fichier** : `src/lib/stores/recettes.js` (toutes les fonctions CRUD)
**Problème** : Si l'API échoue, le store reste modifié → état UI incohérent. Aucun `try/catch`, aucun `error` capturé.

**Fix** :
```js
export async function deleteCommentaire(recetteId, id) {
  const previous = get(commentaires)[recetteId] ?? [];
  commentaires.update(c => ({ ...c, [recetteId]: previous.filter(x => x.id !== id) }));
  const { error } = await supabase.from('commentaires').delete().eq('id', id);
  if (error) {
    commentaires.update(c => ({ ...c, [recetteId]: previous })); // rollback
    throw error;
  }
}
```

### Frontend / UX

#### B5. Icônes PWA manquantes
**Fichier** : `static/` (vide) + `vite.config.js`
**Problème** : Le manifest référence `icon-192.png` et `icon-512.png` introuvables. **L'installation PWA est cassée**. Le favicon est aussi manquant (404 sur `app.html:5`).

**Fix** : générer dans `/static/` :
- `favicon.ico` (32×32)
- `icon-192.png` (192×192, `purpose: any`)
- `icon-512.png` (512×512, `purpose: any`)
- `icon-maskable-512.png` (512×512, `purpose: maskable`, padding ~10%)
- `apple-touch-icon.png` (180×180)

Outil : https://realfavicongenerator.net (à partir d'un SVG/PNG haute résolution).

#### B6. Auth guard fuit pendant la redirect
**Fichier** : `src/routes/+layout.svelte:19-22`
**Problème** : Le `goto('/auth')` est déclenché mais `<slot />` rend déjà la page protégée pendant la nav.

**Fix** :
```svelte
{#if $isAuthenticated || isPublic}
  <slot />
{/if}
```

#### B7. Pas de bouton de déconnexion
**Problème** : Le bouton 👤 sur la home redirige vers `/auth` qui redirige immédiatement vers `/` si authentifié → **boucle infinie**. Aucun moyen de se déconnecter.

**Fix** : créer `src/routes/profil/+page.svelte` avec photo, `exam_date` picker, bouton `signOut`.

#### B8. Onglet "Réviser" absent du bottom nav
**Problème** : `+layout.svelte` n'a pas la tab Réviser, alors que la home button pointe vers `/reviser`.

**Fix** : décision design — soit 6e tab, soit remplacer "Ordo" par "Réviser" et déplacer Ordo dans `/profil` ou en sous-page.

---

## ⚠️ Haute priorité

### Backend

| # | Problème | Fix |
|---|---|---|
| H1 | **Aucun index secondaire** sur les tables (perf catastrophique > 100 rows) | `CREATE INDEX ON recettes(user_id); CREATE INDEX ON ingredients(recette_id, user_id); CREATE INDEX ON quiz_questions(recette_id); CREATE INDEX ON progression(user_id, statut); CREATE INDEX ON commentaires(recette_id, user_id);` |
| H2 | `updated_at` jamais mis à jour | Trigger `BEFORE UPDATE` qui set `NEW.updated_at = NOW()` |
| H3 | `quiz_questions.bonne` peut pointer hors `reponses[]` | `CHECK (bonne >= 0 AND bonne < array_length(reponses, 1))` |
| H4 | `quiz_score` peut être > 100, `chrono_seconds` négatif | `CHECK (quiz_score BETWEEN 0 AND 100)`, `CHECK (chrono_seconds >= 0)` |
| H5 | `competences TEXT[]` sans contrainte de valeurs | Soit enum, soit `CHECK (competences <@ ARRAY['cuissons','textures','pesees','assemblages','organisation','techniques']::text[])` |
| H6 | `signOut()` ne reset pas les stores → fuite cross-user | `recettes.set([]); progression.set({}); commentaires.set({});` après signOut |
| H7 | `recettesLoading` reste `false` si crash réseau | `try/finally` dans `loadRecettes` |
| H8 | Race condition `updateProgression` (double-clic = 2 lignes) | Utiliser `upsert({ ... }, { onConflict: 'user_id,recette_id' })` |

### Frontend / a11y

| # | Problème | Fix |
|---|---|---|
| H9 | **Inputs sans `for`/`id`** (a11y cassée pour lecteurs d'écran) | `<label for="email">` + `id="email"` sur chaque input |
| H10 | Pas d'`aria-label` ni `aria-current` sur la nav | `<nav aria-label="Navigation principale">`, `aria-current={isActive ? 'page' : undefined}` |
| H11 | **Tap targets nav-item < 44px** (≈ 36px actuels — viole guidelines iOS/Android) | `min-height: 48px` sur `.nav-item` |
| H12 | Pas de `:focus-visible` global | `:focus-visible { outline: 2px solid var(--color-brand); outline-offset: 2px; }` |
| H13 | Erreurs Supabase affichées brutes en anglais | Mapper `e.message` vers messages FR (`"Identifiants incorrects"`...) |
| H14 | `<button>` sans `type="button"` dans formulaires → submit accidentel | Wrap dans `<form on:submit\|preventDefault>` + `type="submit"` |
| H15 | Score ring sans accessibilité | `role="img" aria-label="{pct}% maîtrisé"` |

---

## 💡 Optimisations

| # | Domaine | Optim | Gain estimé |
|---|---|---|---|
| O1 | DB | Lazy load `ingredients`/`quiz_questions` au clic recette (au lieu de tout charger) | −80% payload initial liste |
| O2 | DB | Cache TTL 60s sur `loadCommentaires` | Évite re-fetch en navigation |
| O3 | DB | RPC `get_dashboard_stats(user_id)` côté SQL | Calcul stats côté DB > client (100+ recettes) |
| O4 | Auth | Activer `flowType: 'pkce'` explicite | Sécurité OAuth renforcée |
| O5 | Auth | Throw si `VITE_SUPABASE_URL` manquant dans `supabase.js` | Erreurs claires en dev |
| O6 | Frontend | `each` blocks avec `(r.id)` partout | Évite re-render full après filtrage |
| O7 | CSS | `prefers-reduced-motion` | Respecte préférences accessibilité |
| O8 | CSS | Dark mode (`prefers-color-scheme: dark`) | Adopté par défaut iOS/Android |
| O9 | PWA | Splash screens iOS (`apple-touch-startup-image`) | UX install iPhone |
| O10 | PWA | `padding-top: calc(16px + env(safe-area-inset-top))` sur `.page` | Notches iPhone |
| O11 | Bundle | `recipesData` utilisé que pour `categories`/`competences` → store partagé | Pas de re-import du JSON 50kb |
| O12 | Bundle | Vérifier que jspdf/xlsx/chartjs ne sont QUE en dynamic import | Bundle initial allégé |

---

## 🎁 Bonus — features futures

| # | Feature | Sprint |
|---|---|---|
| F1 | **Page `/profil`** avec photo, exam_date, signOut, plan freemium | 1 |
| F2 | **Skeleton loaders** au lieu de spinner | 1 |
| F3 | **Toast offline** : `online`/`offline` events → "Mode hors-ligne — sync à la reco" | 1 |
| F4 | **Install prompt PWA** : capter `beforeinstallprompt`, CTA après J+2 | 1 |
| F5 | **Haptic feedback** sur validations Quiz/Chrono : `navigator.vibrate(15)` | 1 |
| F6 | Table `chrono_history` (id, user, recette, seconds, at) pour graphes de progression | 2 |
| F7 | Table `recette_photos` + Supabase Storage bucket | 2 |
| F8 | Audit log : table `actions_log` pour traçabilité | 3 |

---

## 📋 Roadmap d'application des fixes

### Itération 1 — sécurité critique (1-2h)
- [ ] B1 — garde idempotente seed + filtre events
- [ ] B2 — `WITH CHECK` + validation `recette_id` cross-table
- [ ] B3 — `WITH CHECK (auth.uid() = user_id)` sur toutes policies
- [ ] H1 — index secondaires
- [ ] H6 — reset stores au signOut

### Itération 2 — bugs UX bloquants (1-2h)
- [ ] B5 — icônes PWA + favicon
- [ ] B6 — auth guard `{#if}` au lieu de `goto`
- [ ] B7 — page `/profil` avec signOut
- [ ] B8 — décision Réviser dans bottom nav
- [ ] H9-H15 — accessibilité (labels, aria, focus, tap targets)

### Itération 3 — robustesse (2-3h)
- [ ] B4 — try/catch + rollback dans tous les CRUD
- [ ] H2-H8 — contraintes SQL + upsert + reset stores
- [ ] O4-O5 — pkce + validation env

### Itération 4 — perf & DX (2-3h)
- [ ] O1-O3 — lazy load + cache + RPC dashboard
- [ ] O7-O8 — dark mode + reduced motion
- [ ] O11-O12 — vérif bundle size + extraction store meta

### Itération 5 — features sprint 1 (1 semaine)
- [ ] F1 — page profil
- [ ] F2 — skeleton loaders
- [ ] F3 — toast offline
- [ ] F4 — install prompt
- [ ] F5 — haptics

---

## 🤔 À garder à l'esprit

1. **`CLAUDE.md` est la source de vérité produit**. Si un fix entre en conflit avec ses contraintes (ex : "pas de TypeScript"), garder la contrainte produit.
2. **Tester chaque fix** sur mobile réel + lecteur d'écran pour les a11y.
3. **Mesurer avant/après** — bundle size, Lighthouse score, requêtes DB.
4. **Le seed change pour devenir idempotent** : OK pour les nouveaux users, mais penser à un script de cleanup pour ceux qui auraient déjà des doublons.

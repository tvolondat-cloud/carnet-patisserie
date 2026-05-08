# Tracking plan — Brigade Sucrée

Plan de tracking complet : tous les events poussés dans le `dataLayer` par l'app, leur déclencheur, leurs paramètres, leur usage en GA4.

> Source de vérité du code : [`src/lib/analytics.js`](../src/lib/analytics.js) — l'objet `events.*` à la fin du fichier.

---

## Vue d'ensemble

| # | Event | Type | Conversion ? | Catégorie param principal |
|---|---|---|---|---|
| 1 | `page_view` | Navigation | non | `page_path` |
| 2 | `sign_up` | Acquisition | ✅ | `method` |
| 3 | `login` | Acquisition | non | `method` |
| 4 | `logout` | Acquisition | non | — |
| 5 | `view_recipe` | Engagement | non | `recipe_id` + 4 dim |
| 6 | `lab_started` | Engagement | non | `recipe_id` |
| 7 | `lab_quiz_completed` | Engagement | non | `score`, `passed` |
| 8 | `lab_chrono_completed` | Engagement | non | `seconds`, `passed` |
| 9 | `recipe_mastered` | **Engagement clé** | ✅ | `recipe_id` |
| 10 | `notes_saved` | Engagement | non | `recipe_id` |
| 11 | `comment_added` | Engagement | non | `comment_type` |
| 12 | `pdf_exported` | **Engagement clé** | ✅ | `count`, `only_maitrisees` |
| 13 | `profile_updated` | Profile | non | — |
| 14 | `consent_granted` | Consent | non | `all` |
| 15 | `consent_denied` | Consent | non | — |
| 16 | `consent_customized` | Consent | non | `analytics`, `marketing` |

---

## 1. `page_view`

**Déclencheur** : à chaque navigation SvelteKit (réactif au store `$page` dans `+layout.svelte`).

**Code** : `src/routes/+layout.svelte`
```js
$: if (initialized && currentPath) {
  trackPageView(currentPath);
}
```

**Params** :
| Param | Type | Source | Exemple |
|---|---|---|---|
| `page_path` | string | `location.pathname` | `/recettes/abc-123` |
| `page_title` | string | `document.title` | `Brigade Sucrée — Ton CAP Pâtissier` |

**Note** : on désactive `send_page_view: false` sur le tag GA4 — Configuration pour éviter les doublons (sinon GA4 envoie aussi un `page_view` automatiquement).

---

## 2. `sign_up` 🎯 conversion

**Déclencheur** : succès d'une inscription (email ou Google).

**Code** : `src/routes/auth/+page.svelte` → fonctions `handleGoogle()` / `handleSubmit()` (mode signup)

**Params** :
| Param | Type | Valeurs |
|---|---|---|
| `method` | enum | `google` \| `email` |

---

## 3. `login`

Identique à sign_up mais pour les connexions existantes. Param `method` : `google` ou `email`.

---

## 4. `logout`

**Déclencheur** : clic sur "Se déconnecter" dans `/profil`.

**Params** : aucun.

---

## 5. `view_recipe`

**Déclencheur** : chargement d'une fiche recette (`/recettes/[id]`).

**Code** : `src/routes/recettes/[id]/+page.svelte`
```js
$: if (recette && !viewTracked) {
  events.viewRecipe(recette);
  viewTracked = true; // anti double-tracking dans la même session
}
```

**Params** :
| Param | Type | Exemple |
|---|---|---|
| `recipe_id` | UUID | `abc-123-def` |
| `recipe_name` | string | `Crème pâtissière` |
| `recipe_categorie` | enum | `cremes`, `pates`, `entremets`, ... |
| `recipe_ep` | enum | `EP1` \| `EP2` |
| `recipe_difficulte` | int (1-5) | `2` |

---

## 6. `lab_started`

**Déclencheur** : entrée dans le mode laboratoire (`/laboratoire/[id]`), une seule fois par session de page.

**Code** : `src/routes/laboratoire/[id]/+page.svelte`

**Params** :
| Param | Type |
|---|---|
| `recipe_id` | UUID |

---

## 7. `lab_quiz_completed`

**Déclencheur** : clic sur "Valider le quiz" en mode Labo (étape 2/3).

**Params** :
| Param | Type | Notes |
|---|---|---|
| `recipe_id` | UUID | |
| `score` | int (0-100) | Pourcentage |
| `passed` | boolean | `true` si score ≥ 75% |

---

## 8. `lab_chrono_completed`

**Déclencheur** : clic sur "Arrêter" dans le chrono Labo (étape 3/3).

**Params** :
| Param | Type | Notes |
|---|---|---|
| `recipe_id` | UUID | |
| `seconds` | int | Durée totale |
| `passed` | boolean | `true` si seconds ≤ chrono_cible × 1.2 |

---

## 9. `recipe_mastered` 🎯 conversion

**Déclencheur** : statut d'une recette passe à `maitrisee` (3 étapes Labo validées OU promotion manuelle via `advanceStatut`).

**Code** : `src/routes/laboratoire/[id]/+page.svelte` (`finishLab`) + `src/routes/recettes/[id]/+page.svelte` (`advanceStatut`)

**Params** :
| Param | Type |
|---|---|
| `recipe_id` | UUID |
| `recipe_name` | string |

**Usage GA4** : conversion principale d'engagement, mesure la rétention. Cohorte des "users avec ≥ 1 recette maîtrisée" = cible Pro.

---

## 10. `notes_saved`

**Déclencheur** : auto-save des notes après debounce 800ms.

**Params** :
| Param | Type |
|---|---|
| `recipe_id` | UUID |

⚠️ Volume potentiellement élevé (1 event par modification). Utiliser pour analyser les recettes les plus annotées.

---

## 11. `comment_added`

**Déclencheur** : ajout d'un commentaire sur une recette.

**Params** :
| Param | Type | Valeurs |
|---|---|---|
| `recipe_id` | UUID | |
| `comment_type` | enum | `note` \| `astuce` \| `erreur` \| `variation` |

---

## 12. `pdf_exported` 🎯 conversion

**Déclencheur** : clic sur "Générer le PDF" dans `/carnet-pdf`.

**Params** :
| Param | Type | Notes |
|---|---|---|
| `count` | int | Nombre de recettes incluses |
| `only_maitrisees` | boolean | Filtre activé |

**Usage GA4** : indicateur fort d'engagement (l'utilisateur veut emporter son carnet en cuisine).

---

## 13. `profile_updated`

**Déclencheur** : sauvegarde du profil (prénom, type CAP/particulier, date d'examen).

**Params** : aucun (volontairement, pas d'info perso dans GA).

---

## 14-16. Events de consentement

| Event | Déclencheur | Params |
|---|---|---|
| `consent_granted` | Clic "Allons-y" sur la bannière | `all: true` |
| `consent_denied` | Clic "Non merci" | — |
| `consent_customized` | Sauvegarde depuis le drawer | `analytics: bool, marketing: bool` |

⚠️ Ces events ne sont envoyés **qu'après** consent, donc `consent_granted` arrivera mais pas `consent_denied` (puisque pas d'analytics_storage).

→ Pour tracker `consent_denied`, on pourrait utiliser un mode debug serveur-side (Cloudflare Worker) ou logguer en DB Supabase. Pas implémenté pour l'instant.

---

## Roadmap tracking (Sprint 1-3)

### Sprint 1 (Module Fiches + Examen blanc)
- `view_fiche` (fiche_id, fiche_categorie, fiche_titre)
- `examen_started`
- `examen_completed` (score, duration_seconds, questions_count)
- `install_pwa_prompt_shown`
- `install_pwa_accepted`
- `install_pwa_dismissed`

### Sprint 2 (Photos, favoris, partage)
- `photo_uploaded` (recipe_id, file_size)
- `recipe_favorited` (recipe_id)
- `recipe_unfavorited` (recipe_id)
- `recipe_shared` (recipe_id, channel: link/twitter/whatsapp)
- `cuisine_mode_enabled` (recipe_id)

### Sprint 3 (Stripe, push, streaks)
- `pricing_viewed`
- `checkout_started` (plan: monthly/annual)
- `purchase` (plan, value, currency, transaction_id)
- `subscription_canceled` (reason)
- `push_subscribed`
- `streak_milestone` (days)

---

## Funnels GA4 à créer

### Funnel d'acquisition
1. `page_view` (path = /auth)
2. `sign_up` (any method)
3. `view_recipe` (premier)
4. `lab_started` (premier)
5. `recipe_mastered` (premier)

### Funnel de monétisation (Sprint 3)
1. `pricing_viewed`
2. `checkout_started`
3. `purchase`

---

## Audiences GA4 à créer

| Audience | Critère |
|---|---|
| **Power users** | ≥ 5 `recipe_mastered` dans les 30 derniers jours |
| **At-risk users** | Inscrit > 7j ET 0 `view_recipe` dans les 14 derniers jours |
| **PDF lovers** | ≥ 1 `pdf_exported` |
| **CAP students** | event `profile_updated` avec param `profil_type=cap` (à ajouter) |
| **Particuliers** | param `profil_type=particulier` |

---

## Relais entre code, GTM et GA4

```
src/lib/analytics.js                     → window.dataLayer.push({event, ...params})
                ↓
GTM (GTM-KRKFJLVD)                       → catch via Custom Event Trigger
                ↓
Tag GA4 — Custom Events (catch-all)      → forward to GA4 with params
                ↓
GA4 (G-XJMXR88JGC)                       → reports + conversions + audiences
```

Chaque maillon doit être configuré pour que le tracking arrive jusque GA4. Le détail dans [`README.md`](README.md).

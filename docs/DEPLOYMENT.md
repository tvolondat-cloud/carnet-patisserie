# Déploiement — Brigade Sucrée

> **Plateforme** : Cloudflare Pages (adapter-static, SPA fallback `200.html`)
> **Repo** : `tvolondat-cloud/carnet-patisserie`
> **Prod** : https://brigadesucree.app
> **Staging** : https://staging.brigade-sucree.pages.dev

---

## Workflow standard (à suivre à chaque changement)

```
1. Coder en local  →  npm run dev
2. Vérifier le build  →  npm run preview:check
3. Pousser sur staging  →  npm run push:staging
4. Valider sur  https://staging.brigade-sucree.pages.dev  (~90s)
5. Pousser en prod  →  npm run push:prod
```

### Commandes disponibles

| Commande | Action |
|---|---|
| `npm run dev` | Dev server local (HMR, :5173) |
| `npm run preview:check` | Build + preview local (:4173) — **à lancer avant tout push** |
| `npm run push:staging` | Push branche courante → `staging` (auto-switch compte gh) |
| `npm run push:prod` | Push `main` → `main` = déploiement prod |
| `npm run build` | Build seul (sans preview) |

### Bypass des hooks

```bash
# Sauter le build check (garde sync docs)
SKIP_BUILD_CHECK=1 git push ...

# Sauter le docs sync (garde build check)
SKIP_DOCS_SYNC=1 git push ...

# Sauter tout
SKIP_ALL=1 git push ...
```

---

## Environnements

### Production
| | |
|---|---|
| **URL** | https://brigadesucree.app |
| **Branch** | `main` |
| **Deploy** | Auto à chaque push sur `main` |
| **Rollback** | CF Pages → Deployments → ⋯ → Rollback |

### Staging (preview)
| | |
|---|---|
| **URL** | https://staging.brigade-sucree.pages.dev |
| **Branch** | `staging` |
| **Deploy** | Auto à chaque `npm run push:staging` |
| **Variables** | Mêmes variables Supabase que prod (configurées dans CF Pages) |

### Dev local
| | |
|---|---|
| **URL** | http://localhost:5173 |
| **Commande** | `npm run dev` |
| **Variables** | `.env.local` à la racine (gitignored) |

---

## Cloudflare Pages — Configuration

### Variables d'environnement (Settings → Environment variables)

| Variable | Valeur | Environnements |
|---|---|---|
| `VITE_SUPABASE_URL` | `https://wkexxddknocpmwgfvodw.supabase.co` | Production + Preview |
| `VITE_SUPABASE_ANON_KEY` | `eyJhbGci...` (clé anon) | Production + Preview |
| `NODE_VERSION` | `20` | Production + Preview |

> ⚠️ **Jamais la clé `service_role`** côté client. Anon key uniquement.

### Build settings (Workers & Pages → brigade-sucree → Settings)

| Setting | Valeur |
|---|---|
| Build command | `npm run build` |
| Build output directory | `build` |
| Root directory | *(vide)* |
| Node version | 20 (via `NODE_VERSION` env var) |

### Branches déployées

CF Pages déploie automatiquement **toutes les branches** poussées sur GitHub :
- `main` → production (https://brigadesucree.app)
- `staging` → preview (https://staging.brigade-sucree.pages.dev)
- Toute autre branche → preview URL aléatoire `<hash>.brigade-sucree.pages.dev`

---

## Push sécurisé — Bug Windows Credential Manager

Le système a un cache obsolète pointant vers `googlepartner-debug` (ancien compte).
Un `git push` direct échoue avec **403 Permission denied**.

**Solution** : les scripts `push:staging` et `push:prod` utilisent `gh auth token`
automatiquement. Ils basculent aussi le compte actif si nécessaire.

```bash
# Vérifier le compte actif
gh auth status

# Basculer manuellement si besoin
gh auth switch --user tvolondat-cloud

# Pattern manuel (si les scripts npm ne fonctionnent pas)
TOKEN=$(gh auth token) && git push "https://x-access-token:${TOKEN}@github.com/tvolondat-cloud/carnet-patisserie.git" staging
```

---

## Validation post-déploiement

### Checklist staging

- [ ] `https://staging.brigade-sucree.pages.dev` répond 200
- [ ] La landing page s'affiche correctement
- [ ] La connexion Supabase fonctionne (login test)
- [ ] Les nouvelles features à valider fonctionnent
- [ ] Console navigateur sans erreur critique

```bash
# Vérifier les chunks JS (tous doivent retourner 200)
curl -s -o /dev/null -w "%{http_code}" https://staging.brigade-sucree.pages.dev

# Voir la version déployée
curl -s https://staging.brigade-sucree.pages.dev/_app/version.json
```

### Checklist prod (après push:prod)

```bash
# Version prod
curl -s https://brigadesucree.app/_app/version.json

# CI derniers runs
gh run list --repo tvolondat-cloud/carnet-patisserie --limit 3
```

---

## Rollback

### Rollback rapide (CF Pages)

1. Ouvre https://dash.cloudflare.com → Workers & Pages → `brigade-sucree`
2. Onglet **Deployments**
3. Trouve le dernier déploiement stable
4. Clique **⋯ → Rollback to this deployment**

Le rollback est instantané (changement de pointeur CDN, sans rebuild).

### Rollback via git

```bash
# Revenir au commit précédent sur main
git revert HEAD --no-edit
npm run push:prod
```

---

## CI GitHub Actions

Le workflow `.github/workflows/ci.yml` tourne sur :
- Chaque push sur `main` (prod)
- Chaque push sur `staging` (validation pre-prod)
- Chaque PR vers `main`

Il vérifie : JSON valides, build propre, fichiers critiques présents, bundle size.

Sur un push `staging` réussi, le CI affiche l'URL de preview dans les logs.

```bash
# Voir le statut du dernier run CI
gh run list --repo tvolondat-cloud/carnet-patisserie --limit 3

# Logs d'un run spécifique
gh run view <run-id> --repo tvolondat-cloud/carnet-patisserie --log-failed
```

---

## Monitoring

### Vérifier que la prod tourne

```bash
curl -s https://brigadesucree.app | grep -o '<title>[^<]*</title>'
curl -s -o /dev/null -w "%{http_code}" https://brigadesucree.app
```

### Supabase

- **Database → Logs** : erreurs SQL et triggers
- **Auth → Logs** : échecs de connexion
- Dashboard : https://supabase.com/dashboard/project/wkexxddknocpmwgfvodw

### PWA & Performance (Lighthouse)

```bash
npx lighthouse https://brigadesucree.app --view
```

Scores cibles :
- Performance : ≥ 90
- Accessibility : ≥ 95
- Best Practices : ≥ 95
- SEO : ≥ 90

---

## Domaines

| Domaine | DNS | Cible |
|---|---|---|
| `brigadesucree.app` | Cloudflare | Prod (CNAME → brigade-sucree.pages.dev) |
| `www.brigadesucree.app` | Cloudflare | Redirect 301 → apex |
| `brigadesucree.fr` | Cloudflare | Redirect 301 → brigadesucree.app |
| `staging.brigade-sucree.pages.dev` | CF Pages auto | Staging branch |

Les domaines sont enregistrés chez **Gandi**, nameservers pointent vers **Cloudflare**.

---

## Première configuration (si reprise from scratch)

1. Crée un projet CF Pages → importe `tvolondat-cloud/carnet-patisserie`
2. Build command : `npm run build` | Output : `build`
3. Ajoute les 3 env vars (URL + ANON_KEY + NODE_VERSION=20)
4. Premier deploy → associe `brigadesucree.app` comme domaine custom
5. Supabase → Auth → Redirect URLs : ajoute `https://brigadesucree.app/auth/callback`
6. Crée la branche `staging` : `git checkout -b staging && npm run push:staging`

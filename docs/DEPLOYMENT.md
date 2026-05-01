# Déploiement — Carnet

Guide de déploiement sur Vercel (recommandé) avec auto-deploy depuis GitHub.

---

## Pré-requis

- Repo poussé sur GitHub : `tvolondat-cloud/carnet-patisserie` ✅
- Compte Vercel lié à GitHub : https://vercel.com/login → Continue with GitHub
- Projet Supabase configuré ([SETUP.md](SETUP.md))

---

## 1. Importer le projet sur Vercel

1. https://vercel.com/new
2. **Import Git Repository** → sélectionne `tvolondat-cloud/carnet-patisserie`
3. Vercel détecte automatiquement **SvelteKit** comme framework
4. Avant de cliquer Deploy, configure les variables d'environnement ↓

---

## 2. Variables d'environnement

Dans la page **Configure Project** → section **Environment Variables**, ajoute :

| Variable | Valeur | Environments |
|---|---|---|
| `VITE_SUPABASE_URL` | `https://wkexxddknocpmwgfvodw.supabase.co` | Production, Preview, Development |
| `VITE_SUPABASE_ANON_KEY` | `eyJhbGci...` (la clé anon) | Production, Preview, Development |

> ⚠️ **N'utilise jamais la clé `service_role`** — c'est la clé admin, elle ne doit jamais être exposée côté client.

Clique **Deploy**.

---

## 3. Premier déploiement

Vercel va :
1. Cloner le repo
2. `npm install`
3. `npm run build` (adapter-static génère `build/` avec HTML statique + service worker)
4. Servir depuis le CDN global

Au bout de ~1-2 min : tu obtiens une URL `https://carnet-patisserie-xyz.vercel.app`.

---

## 4. Mettre à jour les URLs OAuth

Une fois ton domaine prod connu, **remonter dans Supabase et Google Cloud** :

### Supabase
**Authentication → URL Configuration** :
- **Site URL** : `https://carnet-patisserie.vercel.app` (ou domaine custom)
- **Redirect URLs** (ajouter) :
  - `https://carnet-patisserie.vercel.app/auth/callback`

### Google Cloud Console
**APIs & Services → Credentials** → ton OAuth client → **Edit** :
- **Authorized JavaScript origins** : ajouter `https://carnet-patisserie.vercel.app`
- **Authorized redirect URIs** : déjà configurée pour Supabase, ne pas y ajouter le domaine Vercel

---

## 5. Domaine custom (optionnel)

Vercel → ton projet → **Settings → Domains** :
- Ajoute ton domaine (ex: `carnet.app`)
- Configure les DNS comme indiqué (CNAME ou A record)
- HTTPS auto via Let's Encrypt

Puis **remonter le domaine custom** dans Supabase + Google Cloud (étape 4).

---

## 6. Auto-deploy

À chaque `git push origin main` :
- Vercel build et déploie automatiquement
- L'URL `production` reste stable
- Chaque PR a un déploiement preview unique : `https://carnet-patisserie-git-feature-tvolondat.vercel.app`

---

## 7. PWA en production

Le service worker est généré par `vite-plugin-pwa` au build. Il sera actif dès le 2e chargement (1er chargement = installation).

### Tester l'installation PWA

**Chrome desktop** : icône d'installation à droite de la barre d'URL.

**Mobile Safari (iOS)** : Partager → "Sur l'écran d'accueil".

**Chrome Android** : "Installer l'application" via menu ⋮.

### Mises à jour

Avec `registerType: 'autoUpdate'` (config actuelle), le SW vérifie une nouvelle version à chaque chargement. Il l'applique au refresh suivant.

---

## 8. Monitoring

### Vercel Analytics

**Settings → Analytics** : active l'option (gratuit jusqu'à 2500 events/mois).

### Supabase

**Database → Logs** pour les erreurs SQL et triggers.
**Auth → Logs** pour les échecs de connexion.

### Lighthouse (perf + a11y + PWA)

```bash
# Local
npx lighthouse https://carnet-patisserie.vercel.app --view
```

Score cible :
- Performance : ≥ 90
- Accessibility : ≥ 95 (après fixes a11y de [AUDIT.md](AUDIT.md))
- Best Practices : ≥ 95
- SEO : ≥ 90
- PWA : "Installable" + critères Workbox

---

## 9. Rollback

En cas de bug en prod :

**Vercel** → ton projet → **Deployments** → trouve le dernier déploiement OK → **⋯ → Promote to Production**.

Le rollback est instantané (changement de pointeur, pas de rebuild).

---

## 10. Variables d'environnement par environnement

Tu peux avoir des projets Supabase distincts pour preview/prod :

| Environment | Supabase Project | Use case |
|---|---|---|
| Production | `wkexxddknocpmwgfvodw` (prod) | Domaine principal |
| Preview | (ex: `carnet-staging`) | PRs, branches |
| Development | (local seul) | `npm run dev` |

Utile pour ne pas polluer la prod avec des données de test.

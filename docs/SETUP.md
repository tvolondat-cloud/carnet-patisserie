# Setup — Brigade Sucrée

Guide complet pour configurer le projet de zéro : Supabase, Google OAuth, déploiement.

---

## 1. Pré-requis

- **Node.js ≥ 18** — `node --version`
- **Compte Supabase** — https://supabase.com
- **Compte Google Cloud** (pour OAuth) — https://console.cloud.google.com
- **Compte Vercel** (pour déploiement) — https://vercel.com

---

## 2. Création du projet Supabase

1. Va sur https://supabase.com/dashboard → **New Project**
2. Choisis :
   - **Name** : `brigade-sucree`
   - **Database password** : génère un mot de passe fort (à stocker dans un gestionnaire)
   - **Region** : `eu-west-3` (Paris) ou la plus proche
   - **Plan** : Free pour démarrer
3. Attends la création (~2 min)

### Récupérer les clés API

Settings → API : copie
- **URL** : `https://xxxxx.supabase.co`
- **anon public** key (commence par `eyJ...`)

⚠️ **Ne jamais utiliser** la clé `service_role` côté client — c'est la clé admin.

### Configurer `.env.local`

```bash
cp .env.example .env.local
```

Édite `.env.local` :
```env
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOi...
```

---

## 3. Appliquer le schéma SQL

### Étape A — Schéma

Dans **SQL Editor** Supabase → New query :
- Copie tout le contenu de `supabase/schema.sql`
- Clique **Run** ▶

Cela crée :
- 6 tables : `profiles`, `recettes`, `ingredients`, `quiz_questions`, `progression`, `commentaires`
- RLS activé sur toutes les tables (`auth.uid() = user_id`)
- Trigger `handle_new_user` qui crée auto un profil à l'inscription

### Étape B — Seed (fonction)

Dans **SQL Editor** → New query :
- Copie tout le contenu de `supabase/seed.sql`
- **Run** ▶

Cela crée la fonction `seed_recettes_cap(p_user_id UUID)`. Elle est appelée automatiquement par l'app à la première connexion d'un utilisateur (voir `src/lib/stores/auth.js`).

### Vérification

Dans **Table Editor**, tu dois voir les 6 tables vides. Dans **Database → Functions**, tu dois voir `handle_new_user` et `seed_recettes_cap`.

---

## 4. Configurer l'authentification

### Authentification email

Authentication → **Providers** → **Email** est activé par défaut. Rien à faire.

### Authentification Google OAuth

#### 4.1 Récupérer la callback URL Supabase

Authentication → Providers → **Google** → tu verras :
```
Callback URL (for OAuth):
https://wkexxddknocpmwgfvodw.supabase.co/auth/v1/callback
```
Garde cette URL ouverte.

#### 4.2 Créer un projet Google Cloud

1. https://console.cloud.google.com → **New Project** → nom `Brigade Sucrée`
2. **APIs & Services → OAuth consent screen** :
   - User Type : `External`
   - App name : `Brigade Sucrée`
   - User support / Developer email : ton email
   - Save & Continue (laisse Scopes et Test users par défaut)

#### 4.3 Créer les credentials OAuth

**APIs & Services → Credentials → Create Credentials → OAuth client ID** :
- Application type : `Web application`
- Name : `Brigade Sucrée Web`
- **Authorized JavaScript origins** :
  - `http://localhost:5173`
  - `https://wkexxddknocpmwgfvodw.supabase.co`
  - (ajoute ton domaine de prod plus tard)
- **Authorized redirect URIs** :
  - L'URL de callback Supabase copiée à l'étape 4.1

Clique **Create** → tu obtiens **Client ID** + **Client Secret**.

#### 4.4 Renseigner dans Supabase

Authentication → Providers → **Google** :
- Toggle ON
- Colle **Client ID** + **Client Secret**
- Save

### URLs de redirection autorisées

Authentication → **URL Configuration** :
- **Site URL** : `http://localhost:5173` (dev) ou ton domaine de prod
- **Redirect URLs** (additionnels) :
  - `http://localhost:5173/auth/callback`
  - `https://ton-domaine.vercel.app/auth/callback`

---

## 5. Lancer le dev

```bash
npm install
npm run dev
```

→ http://localhost:5173

### Vérifier que tout fonctionne

1. Tu es redirigé vers `/auth`
2. Crée un compte (email ou Google)
3. À la première connexion, l'app appelle `seed_recettes_cap()` automatiquement → 17 recettes apparaissent
4. Va dans `/recettes` : la liste s'affiche

### En cas d'erreur

| Symptôme | Cause | Fix |
|---|---|---|
| Page blanche, console : `VITE_SUPABASE_URL undefined` | `.env.local` mal configuré ou absent | Vérifier le fichier, redémarrer `npm run dev` |
| `error: ...ving new user` | Trigger `handle_new_user` planté | Re-exécuter `schema.sql` (le trigger a un fallback robuste) |
| `invalid request: auth code and code verifier should be non-empty` | Conflit `detectSessionInUrl` + appel manuel | Le callback page laisse maintenant Supabase gérer auto |
| Liste recettes vide après login | `seed_recettes_cap` non créé ou échec | Vérifier `Database → Functions` ; relancer `seed.sql` |

---

## 6. Déploiement Vercel

### 6.1 Push sur GitHub

Le repo est déjà connecté à `tvolondat-cloud/carnet-patisserie`. À chaque push sur `main`, Vercel redéploie auto (une fois lié).

### 6.2 Lier à Vercel

1. https://vercel.com → **Add New Project**
2. Importer `tvolondat-cloud/carnet-patisserie`
3. **Framework Preset** : SvelteKit (auto-détecté)
4. **Environment Variables** : ajouter
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
5. **Deploy**

### 6.3 Mettre à jour les URL OAuth

Une fois ton domaine prod connu (`brigadesucree.app`), retourner :
1. **Google Cloud Console** → ajouter le domaine dans Authorized origins/redirects
2. **Supabase** → URL Configuration → ajouter `https://ton-domaine/auth/callback`

---

## 7. Maintenance

### Mettre à jour le schéma

Modifie `supabase/schema.sql`, puis applique uniquement le delta dans le SQL Editor (Supabase ne migre pas auto).

Pour les changements destructifs, créer un fichier `supabase/migrations/YYYYMMDD_description.sql`.

### Réinitialiser un utilisateur

Pour effacer toutes les données d'un user (utile en dev) :
```sql
DELETE FROM auth.users WHERE id = 'user-uuid';
-- ON DELETE CASCADE supprime profile, recettes, etc.
```

### Re-seeder après suppression

```sql
SELECT seed_recettes_cap('user-uuid');
```

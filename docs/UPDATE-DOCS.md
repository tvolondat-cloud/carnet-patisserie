# Routine d'auto-update des docs

Système qui maintient `CHANGELOG.md` à jour automatiquement à chaque `git push`, à partir des messages de commits.

---

## Comment ça marche

```
┌─────────────────┐
│  git commit -m  │  "feat: ajout du module fiches"
│  "feat: ..."    │  "fix: corrige le glaçage"
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   git push      │  Déclenche le hook .githooks/pre-push
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│  scripts/sync-docs.js           │
│  --auto-stage                   │
│                                 │
│  1. Lit le dernier SHA du       │
│     CHANGELOG (hors auto)       │
│  2. Liste les commits depuis    │
│  3. Filtre les "docs(auto):"    │
│  4. Groupe par préfixe          │
│  5. Prepend dans [Unreleased]   │
│  6. git add CHANGELOG.md        │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│  Si CHANGELOG modifié           │
│  → git commit -m                │
│    "docs(auto): sync CHANGELOG" │
│  → push inclut le nouveau commit│
└─────────────────────────────────┘
```

---

## Activation

Le hook est activé automatiquement à `npm install` via le script `prepare` :

```json
{
  "scripts": {
    "prepare": "git config core.hooksPath .githooks 2>/dev/null || true"
  }
}
```

Cela configure `git` pour utiliser `.githooks/` (versionné dans le repo) au lieu de `.git/hooks/` (local, non versionné).

**Vérifier que c'est actif** :
```bash
git config core.hooksPath
# → .githooks
```

---

## Convention des commits (catégorisation)

Le script reconnaît les préfixes [Conventional Commits](https://www.conventionalcommits.org/) :

| Préfixe | Section CHANGELOG |
|---|---|
| `feat:` | ✨ Features |
| `fix:` | 🐛 Bug Fixes |
| `brand:` | 🎨 Branding |
| `seo:` | 🔍 SEO |
| `deploy:` | 🚀 Deploy |
| `docs:` | 📝 Documentation |
| `refactor:` | ♻️ Refactoring |
| `perf:` | ⚡ Performance |
| `style:` | 💄 Style |
| `test:` | ✅ Tests |
| `chore:` | 🧹 Chores |

**Exemples valides** :
```bash
git commit -m "feat: ajout du module Fiches CAP"
git commit -m "fix(auth): corrige redirect callback OAuth"
git commit -m "perf: lazy-load chart.js"
git commit -m "docs: explique le déploiement Cloudflare"
```

Les commits sans préfixe reconnu sont placés dans 🧹 *Chores*.

---

## Filtres automatiques

Le script **ignore** ces commits pour éviter les boucles :
- `docs(auto): ...` (créé par le hook lui-même)
- `chore(release): ...`

Il ajoute aussi une signature `<!-- sync-docs: YYYY-MM-DD -->` dans `[Unreleased]` pour ne pas re-prepend les mêmes lignes plusieurs fois le même jour.

---

## Lancer manuellement

```bash
npm run docs:sync
# ou avec verbose
node scripts/sync-docs.js --verbose

# Pour stager auto sans commit (utile en pre-push)
node scripts/sync-docs.js --auto-stage
```

Si rien n'a bougé : output `[sync-docs] Aucun nouveau commit à intégrer.`

---

## Désactiver pour un push spécifique

```bash
SKIP_DOCS_SYNC=1 git push
```

Ou avec `--no-verify` (désactive TOUS les hooks) :
```bash
git push --no-verify
```

---

## Désactiver complètement

```bash
git config --unset core.hooksPath
```

Le hook ne sera plus appelé. Tu peux toujours lancer `npm run docs:sync` manuellement.

---

## Structure du CHANGELOG

```markdown
# Changelog

## [Unreleased]
<!-- sync-docs: 2026-05-04 -->

### ✨ Features
- ajout du module Fiches CAP (`abc1234`)

### 🐛 Bug Fixes
- corrige redirect callback OAuth (`def5678`)

## [0.4.0] — 2026-05-04
...
```

Quand tu releases une version, déplace manuellement le contenu d'`[Unreleased]` sous une nouvelle section versionnée :

```bash
# Manuel pour le moment :
# - Renommer [Unreleased] en [0.5.0] — 2026-05-15
# - Ajouter une nouvelle [Unreleased] vide au-dessus
# - git add CHANGELOG.md && git commit -m "chore(release): 0.5.0"
```

---

## Quand ça ne marche pas

| Symptôme | Cause | Fix |
|---|---|---|
| Hook ne se lance pas | `core.hooksPath` non configuré | `npm install` (déclenche `prepare`) ou `git config core.hooksPath .githooks` |
| Erreur `node: not found` | Node pas dans le PATH | Le hook skip silencieusement, lance manuellement |
| CHANGELOG non modifié | Pas de nouveaux commits depuis le dernier sync | Normal, signature anti-doublon |
| Commit `docs(auto):` créé même quand pas voulu | Hook trop zélé | `SKIP_DOCS_SYNC=1 git push` |
| Conflits CHANGELOG entre branches | Plusieurs branches qui éditent simultanément | Faire un rebase, le hook re-syncera proprement au push |

---

## Améliorations futures possibles

- Bump auto de `package.json` version selon le type de commits (semver)
- Génération de release notes pour GitHub Releases
- Détection de breaking changes (`feat!: ...` ou `BREAKING CHANGE:` dans le body)
- Lien vers le commit GitHub dans les entrées CHANGELOG
- Lint sur le format des commits (refuser un push si commit non-conventional)

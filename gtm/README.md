# GTM — Brigade Sucrée

Configuration Google Tag Manager pour Brigade Sucrée (`GTM-KRKFJLVD`) avec GA4 (`G-XJMXR88JGC`) et Consent Mode v2.

## Contenu

| Fichier | Rôle |
|---|---|
| `brigade-sucree-container.json` | Conteneur GTM complet, importable via Admin → Import Container |
| `tracking-plan.md` | Plan de tracking détaillé : 13 events, params, déclencheurs |

---

## 🚀 Import en 3 minutes

### 1. Importer le conteneur

👉 https://tagmanager.google.com → ton conteneur **GTM-KRKFJLVD**

1. **Admin** (en haut à droite) → **Import Container**
2. **Choose container file** → `gtm/brigade-sucree-container.json`
3. **Choose workspace** : `Default Workspace`
4. **Choose import option** :
   - ✅ **Merge** (recommandé) — fusionne avec ce qui existe déjà
   - ⚠️ Overwrite seulement si tu veux écraser tout ce qui existe
5. Clique **Continue** → revue des changements (4 tags, 4 triggers, 14 variables, 14 built-in)
6. **Confirm**

### 2. Vérifier les tags

Dans **Tags** tu dois voir :
- ✅ `GA4 — Configuration` (tag de base, charge GA4)
- ✅ `GA4 — Page View` (firing sur l'event `page_view` push par notre app)
- ✅ `GA4 — Custom Events (catch-all)` (firing sur tous nos events métier)
- ✅ `GA4 — Conversions` (firing sur `sign_up` / `recipe_mastered` / `pdf_exported`)

Tous ont **Consent Settings → analytics_storage required** (RGPD compliant).

### 3. Tester en Preview

Bouton **Preview** en haut à droite → entre `https://brigadesucree.app` → ton navigateur s'ouvre avec la **Tag Assistant Console** en bas.

Navigue dans l'app, déclenche des events :
- Va sur une recette → tu dois voir `GA4 — Custom Events (catch-all)` se firer pour `view_recipe`
- Lance le mode Labo → `lab_started`
- Etc.

⚠️ Si tu n'as pas accepté les cookies, les tags ne se firent pas (c'est le comportement attendu en RGPD).

### 4. Submit

Quand tout est OK → **Submit** (en haut à droite) → version name = `v1 — Brigade Sucrée initial setup` → **Publish**.

---

## ⚙️ Configuration GA4 recommandée

Une fois GTM publié, va dans GA4 (https://analytics.google.com) :

### Marquer comme conversions

**Admin → Events → Mark as Conversion** (toggle sur les events suivants après leur première occurrence) :
- `sign_up` (acquisition)
- `recipe_mastered` (engagement core)
- `pdf_exported` (engagement secondaire)

### Custom dimensions à créer

**Admin → Custom definitions → Custom dimensions** :

| Dimension | Scope | Param |
|---|---|---|
| Recipe Categorie | Event | `recipe_categorie` |
| Recipe EP | Event | `recipe_ep` |
| Comment Type | Event | `comment_type` |
| Login Method | Event | `method` |
| Quiz Passed | Event | `passed` |
| PDF Filter Maitrisees | Event | `only_maitrisees` |

### Data retention

**Admin → Data Settings → Data Retention** : passer de 2 à **14 mois** (max gratuit).

### Anonymisation IP

Déjà activée dans le tag GA4 — Configuration via le param `anonymize_ip = true`.

### Désactiver les signaux Google (RGPD)

**Admin → Data Collection** : désactive les Google signals.

---

## 🧪 Vérification

### Realtime (le plus rapide)

GA4 → **Reports → Realtime** : navigue dans l'app, tu dois voir tes propres events arriver dans les 30 sec.

### DebugView

1. Installe l'extension Chrome [GA Debugger](https://chrome.google.com/webstore/detail/ga-debugger/jnkmfdileelhofjcijamephohjechhna)
2. Active-la
3. Recharge brigadesucree.app
4. GA4 → **Admin → DebugView** : tu vois chaque event avec ses params en détail

### Vérifier le Consent Mode

- En navigation privée → la bannière apparaît → **n'accepte pas**
- Charge plusieurs pages
- Va dans GA4 Realtime → tu **ne dois rien voir** (consent denied = pas de tracking)
- Reviens, accepte la bannière → les events arrivent

---

## 🛡️ Conformité RGPD

- ✅ Consent Mode v2 par défaut `denied` en EU/EEA/GB/CH
- ✅ Aucun cookie analytics avant opt-in explicite
- ✅ Bannière 3 boutons équivalents (Refuser / Personnaliser / Accepter) — conforme reco CNIL
- ✅ Re-paramétrable depuis `/profil` et `/confidentialite`
- ✅ Tous les tags GA4 ont `consentSettings.consentStatus = NEEDED` avec `analytics_storage`
- ✅ IP anonymisée
- ✅ Pas de Google Signals
- ✅ Pas de remarketing

---

## 🔄 Mise à jour du conteneur

Quand on ajoute de nouveaux events dans le code (`src/lib/analytics.js`), il faut :

1. Ajouter le nom de l'event au regex du trigger `Trigger — All Custom Events`
2. Si l'event a un nouveau param custom, créer une nouvelle Data Layer Variable + l'ajouter dans la liste des `eventParameters` du tag `GA4 — Custom Events (catch-all)`
3. Si l'event est une conversion, ajouter au regex du trigger `Trigger — Conversions`
4. Submit + Publish la nouvelle version GTM

Pour exporter le conteneur mis à jour :
- **Admin → Export Container** → version actuelle → JSON
- Remplacer `gtm/brigade-sucree-container.json` dans le repo
- Commit avec préfixe `feat(analytics):`

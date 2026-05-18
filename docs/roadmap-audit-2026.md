# Roadmap & checklist — suite audit 2026

> Source : `Audit_BrigadeSucree_2026.pdf` (v1.0, 18/05/2026). Score global 7/10.
> Ce document trace les actions **déjà faites**, **à moyen terme** et **long terme**,
> avec un volet dédié à la **prospection commerciale B2B (CFA, lycées, écoles)**.

---

## 0. Fait dans ce lot (quick wins techniques)

- [x] **P0 — Contradiction bêta/pricing supprimée.** Les mentions « 100 % gratuit
  pendant la bêta » (FAQ ×2, CTA) sont remplacées par un message freemium clair
  (10 recettes gratuites / Pro 4,99€ ou 39€). Cause racine traitée : FAQ centralisée
  dans `src/lib/data/landing-faq.js` (plus de tableau dupliqué entre `LandingFAQ`
  et `LandingSEO` → fin de la dérive).
- [x] **P0/P1 — Schema.org.** L'audit le croyait absent : il est en fait injecté par
  `LandingSEO.svelte` et **présent dans le HTML prérendu** (`@graph` :
  Organization + WebSite + WebApplication/EducationalApplication + FAQPage).
  Données corrigées : 17→58 recettes, référentiel 2024-2025→2025-2026,
  `offers` = 3 tiers (Gratuit / Pro mensuel / Pro annuel) au lieu de « free during beta ».
- [x] **SEO — `sitemap.xml` & `robots.txt`** : déjà présents (audit obsolète sur ce
  point). `lastmod` de la home rafraîchi.
- [x] **Cohérence chiffres** : toutes les occurrences « 17 recettes » de la landing
  corrigées en 58 (`LandingFeatures`, `LandingPersonas`, `LandingCTA`).

---

## 1. Quick wins restants (0–2 semaines) — à faire

| P | Action | Détail | Effort | Impact |
|---|--------|--------|--------|--------|
| P0 | Screenshots produit dans la landing | 1 mockup dans le hero + 3-4 captures (Mode Labo, recette, suivi) en section features. **Bloqueur design, pas dev** : nécessite de vraies captures. | 2-4 h | 🔴 Très fort conversion |
| P1 | Compteur d'inscrits | « Déjà X étudiants dans la Brigade » alimenté par un `count` Supabase exposé via une RPC publique (pas d'accès direct à `profiles`). Ne pas afficher de chiffre fictif (anti-pattern relevé par l'audit). | 2-3 h dev | 🟠 Fort conversion |
| P1 | Témoignages réels | Collecter 3-5 verbatims (étudiant CAP, candidat libre, passionné) + prénom/contexte. Bloc entre features et pricing. **Pas de faux avis.** | 1 sem (collecte) | 🟠 Fort conversion |
| P2 | Contraste couleur marque | Vérifier `#6c63ff` sur blanc (≈ 3,6:1, sous le seuil WCAG AA 4.5:1 pour texte normal). OK pour gros boutons/gras ; à corriger pour tout texte fin sur fond clair (assombrir vers `--color-brand-dark`). | 1-2 h | 🟡 A11y |
| P2 | A/B test CTA | « Commencer gratuitement » vs « Rejoindre la Brigade » vs « Tester 7 jours ». GTM/GA4 déjà en place. | 1 h config | 🟡 Conversion |

---

## 2. Moyen terme (1–3 mois)

| P | Action | Détail | Impact |
|---|--------|--------|--------|
| P1 | **Pages recettes publiques (SEO)** | 5-10 recettes indexables sans auth : intro + ingrédients + contexte CAP, étapes détaillées derrière paywall. Cible : « crème pâtissière CAP », « pâte feuilletée recette CAP ». C'est le **levier d'acquisition organique #1** (la SPA cache tout le contenu). | 🔴 SEO majeur |
| P1 | Recipe schema.org sur ces pages | `Recipe` JSON-LD (rich snippets cuisine Google = fort CTR). | 🟠 SEO |
| P2 | Blog / contenu | 10 articles : « comment réviser le CAP Pâtissier », « programme EP1/EP2 », « candidat libre : conseils »… mots-clés fort volume identifiés dans l'audit. | 🟠 SEO long terme |
| P2 | Partenariats blogs CAP | Empreinte Sucrée, PatisCoach : guest post croisé + affiliation. Autorité SEO + audience alignée. → voir §4. | 🟠 Backlinks |
| P2 | Contenu hors-saison | Trafic CAP = pic oct-juin, creux juil-sept. Prévoir contenu passionnés (recettes saisonnières, défis) pour lisser. | 🟡 Rétention |

---

## 3. Long terme (3–12 mois)

| P | Action | Détail | Impact |
|---|--------|--------|--------|
| P1 | **Offre B2B CFA / lycées pro** | Le vrai levier de scale (x3-5 du revenu). Voir checklist §4. | 🔴 Scale majeur |
| P2 | App Store (iOS/Android) | Wrapper PWA via Capacitor/PWABuilder. +30-50 % de découvrabilité. | 🟠 Acquisition |
| P3 | Extension CAP Boulanger / Chocolatier | Même moteur, coût marginal faible, marché ×3-4. | 🟢 Expansion |
| P3 | Communauté / partage recettes | Forum ou partage + corrections croisées. Effet réseau mais **risque de dilution du focus** — à surveiller. | 🟢 À surveiller |
| — | Robustesse référentiel | Si l'Éducation Nationale change les épreuves, contenu à refaire. Garder `recipes.json` + `docs/carnet-cap-2025-2026.md` comme source unique facilite la mise à jour. | 🟡 Risque produit |

---

## 4. Prospection commerciale B2B — CFA, lycées pro, écoles

> Cible : structures formant au CAP Pâtissier. ~Plusieurs centaines de CFA/lycées
> pro en France avec section pâtisserie/boulangerie. Objectif : **3-5 CFA pilotes**
> sur la saison, puis déploiement.

### 4.1 Offre à construire (préalable)

- [ ] Définir le **pricing groupe** : ~99-199 €/an accès illimité par promo
  (1 CFA × 20 élèves = 100-200 € ARR ; 10 CFA = 1-2 k€ ARR + crédibilité institutionnelle).
- [ ] Créer un **plan `school`** côté produit : code d'accès / licence promo
  (colonne `profiles.plan` déjà prête → ajouter une valeur + table `school_licenses`).
- [ ] **Dashboard formateur** (V1 minimale) : suivi agrégé anonymisé de la promo
  (% recettes maîtrisées, recettes faibles) — argument de vente clé.
- [ ] Préparer un **kit de démo** : compte de démo pré-rempli + 1 page PDF
  « Brigade Sucrée pour les CFA » (bénéfices, RGPD/Supabase FR, prix).
- [ ] **RGPD scolaire** : élèves souvent mineurs → mention consentement / registre,
  pas d'analytics sur comptes school par défaut.

### 4.2 Ciblage & fichier de prospection

- [ ] Constituer un fichier : CFA + lycées pro avec section CAP Pâtissier/Boulangerie.
  Sources : annuaire ONISEP, Carif-Oref régionaux, sites des CMA (Chambres de Métiers),
  réseau des CFA de l'artisanat, fédération de la boulangerie-pâtisserie.
- [ ] Prioriser : (a) CFA proches géographiquement, (b) établissements à forte promo,
  (c) ceux déjà actifs sur les réseaux (réceptifs au digital).
- [ ] Pour chaque cible : nom, ville, contact (chef de travaux / formateur pâtisserie /
  directeur), email, tél, statut, date de relance.

### 4.3 Approche commerciale (séquence)

- [ ] **Accroche** : email court personnalisé au formateur pâtisserie (pas l'admin).
  Angle : « outil de révision entre les sessions, pensé sur le référentiel officiel,
  suivi de progression pour la promo ». Pas de jargon SaaS.
- [ ] **Démo** : visio 20 min ou présentiel — montrer le Mode Labo + dashboard promo.
- [ ] **Pilote gratuit** : 1 trimestre offert pour 1 promo, en échange d'un retour
  + autorisation de citer l'établissement (témoignage / logo).
- [ ] **Conversion** : bilan de fin de pilote chiffré → proposition licence annuelle.
- [ ] **Référence** : transformer chaque pilote réussi en étude de cas (page dédiée,
  réutilisable en prospection et en SEO B2B).

### 4.4 Canaux & relais

- [ ] Salons / événements : Europain, salons régionaux de l'artisanat, journées
  portes ouvertes CFA.
- [ ] Réseau prescripteurs : The French Pâtissier (formation vidéo → recommander
  Brigade comme outil de révision complémentaire), Empreinte Sucrée, PatisCoach.
- [ ] Fournisseurs matériel (Matfer Bourgeat, De Buyer) : co-branding / encart.
- [ ] Académies (Ferrandi à distance, Lenôtre) : distribution croisée.
- [ ] Communautés : groupes Facebook « CAP Pâtissier candidat libre », subreddits,
  Discord de promos.

### 4.5 Objectifs jalonnés

- [ ] **M+1** : offre + plan `school` + kit démo prêts ; fichier de 50 cibles.
- [ ] **M+3** : 20 contacts engagés, 3-5 démos réalisées, 1-2 pilotes signés.
- [ ] **M+6** : 3-5 pilotes en cours, 1 étude de cas publiée.
- [ ] **M+9** : conversion des pilotes en licences payantes, fichier élargi (200 cibles).
- [ ] **M+12** : 10 CFA/écoles clients (objectif 1-2 k€ ARR B2B + crédibilité).

---

## 5. Suivi

- Mettre à jour les cases à cocher au fil de l'eau.
- Revue mensuelle : avancement + reprioriser selon traction.
- Indicateurs à instrumenter (manquants aujourd'hui) : inscrits, actifs (DAU/MAU),
  taux de conversion Free→Pro, NPS. Sans ces chiffres, impossible de rassurer un
  partenaire ou un CFA — **prérequis transverse à toute la prospection**.

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

## 5. Priorisation ICE

**KPI cible** : (A) acquisition organique (trafic non-auth) + (B) conversion Free→Pro ; B2B = ARR (levier de scale).
**Contraintes** : dev solo, urgence saisonnière (fenêtre d'acquisition jusqu'à l'examen de juin), **aucune baseline analytics** aujourd'hui (plafonne la Confidence de plusieurs actions).
**Méthode** : ICE — score = (Impact + Confidence + Ease) / 3.
**Date** : 2026-05-18.

| Rang | Action | I | C | E | Score | Justifications |
|------|--------|---|---|---|-------|----------------|
| 1 | Instrumenter les indicateurs (inscrits, DAU/MAU, Free→Pro, NPS) | 7 | 9 | 8 | **8.0** | I : prérequis transverse, débloque la priorisation de tout le reste / C : nécessité évidente, GTM+Supabase déjà en place / E : events GA4 + 1 vue SQL, ~1j |
| 2 | Screenshots produit dans la landing | 8 | 7 | 6 | **7.0** | I : 100% du trafic visiteurs, "chat dans un sac" = fuite conversion / C : best practice universelle + audit critique / E : front, ~1-2j mais bloqueur = vraies captures |
| 3 | Pages recettes publiques (SEO) | 9 | 8 | 4 | **7.0** | I : levier d'acquisition #1, débloque le SEO (SPA cache tout) / C : audit le désigne frein majeur, mots-clés volume identifiés / E : 1-2 sem dev+rédac, prerender + paywall partiel — **big bet** |
| 4 | Compteur d'inscrits réel | 5 | 6 | 8 | **6.3** | I : FOMO, modéré si volume faible / C : best practice, efficacité dépend du chiffre réel / E : RPC count public + UI, ~2-3h |
| 5 | Contraste couleur marque (WCAG AA) | 3 | 9 | 7 | **6.3** | I : a11y + qualité perçue, effet conversion faible / C : ratio mesurable objectivement / E : ajustement token ciblé <1j (vérifier régressions) |
| 6 | Témoignages utilisateurs réels | 7 | 7 | 5 | **6.3** | I : social proof réel = fort, audit "important" / C : best practice + audit / E : collecte humaine ~1 sem (bloqueur = obtenir les verbatims) |
| 7 | Partenariats blogs CAP (Empreinte Sucrée, PatisCoach) | 7 | 6 | 5 | **6.0** | I : backlinks (autorité faible) + audience alignée / C : audience qualifiée mais dépend de négo / E : négo externe, cycle long, 0 dev |
| 8 | Offre B2B CFA / lycées pro | 9 | 6 | 3 | **6.0** | I : scale x3-5 du revenu (ARR) = transformateur / C : audit insiste, marché structuré, non validé terrain / E : plan `school` + dashboard + prospection, 3-6 mois — **big bet** |
| 9 | App Store (wrapper PWA) | 7 | 6 | 4 | **5.7** | I : +30-50% découvrabilité / C : wrappers connus, review stores incertaine / E : 2-4 sem + comptes dev |
| 10 | A/B test CTA landing | 5 | 5 | 6 | **5.3** | I : hero = 100% trafic, lift wording modéré / C : test = incertain par nature / E : config GTM ~1h mais **significativité bloquée par le faible trafic actuel** |
| 11 | Blog / contenu SEO (10 articles) | 7 | 6 | 3 | **5.3** | I : fort volume mots-clés / C : mécanique connue, résultat différé / E : ~2 mois rédaction — **big bet** |
| 12 | Recipe schema.org sur pages publiques | 6 | 8 | 8 | **7.3** | Score élevé MAIS **dépend de l'action #3** → ne peut pas être exécuté avant. Séquencé après les pages recettes. |
| 13 | Extension CAP Boulanger / Chocolatier | 6 | 4 | 3 | **4.3** | I : marché ×3-4 mais futur, hors cœur / C : hypothèse non validée / E : 3-6 mois contenu |
| 14 | Contenu hors-saison (passionnés) | 4 | 4 | 4 | **4.0** | I : lisse la saisonnalité, segment secondaire / C : hypothèse, peu de data / E : production continue |
| 15 | Communauté / partage de recettes | 5 | 3 | 2 | **3.3** | I : rétention + effet réseau mais **risque de dilution du focus** / C : double tranchant / E : 6+ mois |

### Quick wins à lancer en premier
*(Ease ≥ 7 ET Impact ≥ 5)*
1. **Instrumenter les indicateurs** (#1) — ~1j. **Prérequis** : sans baseline, toutes les Confidence restent plafonnées et aucun argument chiffré pour les CFA.
2. **Compteur d'inscrits réel** (#4) — ~2-3h, à enchaîner une fois #1 en place (réutilise le `count`).
3. **Recipe schema.org** (#12) — trivial **mais bloqué** par les pages recettes (#3) : à faire dans la foulée de #3.

### Sprint suivant (2–4 semaines)
4. **Screenshots produit landing** (#2) — dès que des captures propres du Mode Labo / menu comptoir / suivi sont disponibles.
5. **Contraste WCAG** (#5) — assombrir le texte fin vers `--color-brand-dark`, vérifier régressions.
6. **Témoignages réels** (#6) — lancer la collecte maintenant (délai humain), publier sous 2-3 sem.

### Big bets (planifier, séquencer hors sprint courant)
*(Impact ≥ 8, Ease ≤ 4)*
- **Pages recettes publiques SEO** (#3) — chantier d'acquisition prioritaire. Le démarrer en parallèle des quick wins car c'est le levier de fond. Puis **#12 schema** dans la foulée.
- **Offre B2B CFA** (#8) — vraie trajectoire de scale. Préparer l'offre + plan `school` (cf. §4) **en parallèle**, sans attendre que le reste soit fini : cycle commercial long, à amorcer tôt.

### À écarter pour l'instant
- **Communauté / partage** (#15) : score 3.3, risque de dilution du focus relevé par l'audit. À reconsidérer une fois la conversion Free→Pro et le B2B stabilisés.
- **Contenu hors-saison** (#14) : faible priorité, pas éliminé — utile pour lisser juil-sept une fois l'acquisition CAP rodée.

### Hypothèses de test A/B prioritaires
1. **Pages recettes publiques** : si on expose 5-10 recettes en contenu partiel indexable, alors le trafic organique non-auth augmentera significativement sous 2-3 mois, parce que 0 contenu n'est crawlable aujourd'hui (frein #1 de l'audit).
2. **Screenshots landing** : si on ajoute un mockup hero + 3-4 captures, alors le taux inscription visiteur→/auth augmentera, parce que le visiteur "achète un chat dans un sac" actuellement.
3. **Compteur d'inscrits** : si on affiche un compteur réel, alors la conversion landing augmentera via preuve sociale — **à valider seulement quand le chiffre est crédible** (ne pas afficher de faux).

### Notes / arbitrages
- **#12 (schema recettes) a le meilleur score isolé (7.3) mais est rétrogradé** : dépendance dure à #3. La séquence l'emporte sur le score brut.
- **#8 (B2B CFA) sous-classé par l'Ease (3)** mais c'est le levier de revenu le plus fort : à amorcer en parallèle malgré le rang, le cycle commercial est long (cf. jalons §4.5).
- **#10 (A/B CTA)** : Ease nominalement correcte (config 1h) mais **Impact réel bridé par le faible trafic** → repoussé tant que l'acquisition (#3) n'a pas augmenté le volume, sinon test non significatif.
- Recalibrer Impact/Confidence après 1-2 mois, à la lumière des indicateurs (#1).

---

## 6. Suivi

- Mettre à jour les cases à cocher au fil de l'eau.
- Revue mensuelle : avancement + reprioriser selon traction.
- Indicateurs à instrumenter (manquants aujourd'hui) : inscrits, actifs (DAU/MAU),
  taux de conversion Free→Pro, NPS. Sans ces chiffres, impossible de rassurer un
  partenaire ou un CFA — **prérequis transverse à toute la prospection** (= action ICE #1).

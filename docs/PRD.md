# PRD — Brigade Sucrée

> **Product Requirements Document — source unique produit.**
> Vision, personas, périmètre actuel, **catalogue des idées d'évolution**,
> **roadmap** et **matrice de priorisation ICE** vivent ici.
> Ce document est itératif : on l'enrichit à chaque demande.
>
> **Dernière mise à jour** : 2026-05-19 · **Statut** : vivant
>
> Annexes détaillées (ne pas dupliquer ici) :
> - [`docs/roadmap-audit-2026.md`](roadmap-audit-2026.md) — traçabilité audit 2026 (§0),
>   **prospection B2B CFA/écoles** (§4), **spec feature PRO coût/rentabilité** (§6)
> - [`docs/carnet-cap-2025-2026.md`](carnet-cap-2025-2026.md) — référentiel CAP (contenu recettes)
> - [`CLAUDE.md`](../CLAUDE.md) — contexte technique, stack, conventions, interdits

---

## 1. Gouvernance du document

- **Source unique** : toute idée d'évolution, priorisation ou roadmap entre **ici en premier**.
  Les autres docs (roadmap-audit, CLAUDE.md) **référencent** le PRD, ne le dupliquent pas.
- **Cadence** : revue mensuelle (avancement + repriorisation selon la traction).
- **Édition** : ajouter une idée → l'inscrire au §5 (catalogue) **et** la scorer au §7 (ICE).
  La matrice ICE n'est pas renumérotée ligne à ligne à chaque insertion : **le score fait foi**.
- **Décision** : l'ICE est un outil d'arbitrage, pas un verdict automatique. La **séquence**
  (dépendances) prime sur le score brut.

---

## 2. Vision & positionnement

**Brigade Sucrée** — PWA mobile-first de révision et d'entraînement au **CAP Pâtissier**,
+ audience des **particuliers passionnés**.
Tagline : *« Tu fais partie de la Brigade Sucrée. »*

Position hybride rare : **outil d'entraînement structuré (méthode CFA)** + **app de révision
digitale**, sans concurrent digital direct sur le créneau CAP Pâtissier FR.

| Force | Faiblesse |
|---|---|
| Niche précise, peu de concurrence directe | Audience FR restreinte (~20-25k/an) |
| Urgence calendaire (examen juin) = forte intention | Saisonnalité marquée (pic oct-juin) |
| PWA = distribution sans App Store | Découvrabilité réduite (pas de store, SPA peu indexée) |
| Double cible CAP + passionnés | Message parfois ambigu entre les 2 personas |

**KPI produit** : (A) acquisition organique (trafic non-auth), (B) conversion Free→Pro,
(C) ARR B2B (levier de scale). **Prérequis transverse** : instrumenter ces KPI (aucune
baseline analytics aujourd'hui — voir ICE #1).

---

## 3. Personas

- **Léa, 19 ans — étudiante CAP / candidate libre** *(persona cœur)*.
  Priorité : Mode Labo, date d'examen, statuts recettes, fiches & examen blanc.
  Usage : labo (mains sales), transport, veille d'examen. WTP 2-5 €/mois.
- **Sophie, 42 ans — particulière passionnée** *(persona secondaire)*.
  Priorité : calculateur, photos, collections, partage. WTP 8-15 €/mois.
- **Segment émergent — passionné qui vend / micro-entrepreneur** : cible de la feature
  PRO coût & rentabilité (§ annexe roadmap-audit §6).
- **B2B — CFA / lycées pro** : structures formant au CAP (levier de scale, annexe §4).

---

## 4. Périmètre actuel (livré)

- **Mode Laboratoire** (cœur) : Test → Quiz (≥75 %) → Chrono (×1.2). Maîtrise = 3 validés.
- **58 recettes** du référentiel CAP 2025-2026, 12 catégories, suivi par compétence (4 statuts).
- **Freemium** : Gratuit (10 recettes, Labo, suivi, cours EP1/EP2, calculateur) ·
  Pro 4,99 €/mois ou 39 €/an (−35 %) → 58 recettes, Carnet PDF, 50 fiches, 60 QCM.
- Calculateur de rendement (×0.25→×10), notes/commentaires, export PDF (jsPDF),
  ordonnancement EP1/EP2, PWA offline, countdown examen.
- **Landing** : hero plein écran avec aperçu produit réel (fiche Pâte à choux interactive :
  calculateur + étapes dépliables), pricing freemium, comparatif, FAQ unifiée,
  schema.org prérendu (Organization/WebSite/WebApplication/FAQPage).
- **Menu catégories "comptoir"** (tuiles colorées + compteurs, repli progressif).
- Routines : sync docs nightly, security scan CI, sync CHANGELOG pre-push.
- Suite audit 2026 traitée (cohérence freemium, FAQ, schema, chiffres) — détail annexe §0.

---

## 5. Catalogue des idées d'évolution

> Regroupées par thème. Chaque idée est scorée au §7 (référence `#n` = rang ICE).
> Cases à cocher = avancement.

### 5.1 Mesure & socle (transverse)
- [ ] **Instrumenter les KPI** : inscrits, DAU/MAU, conversion Free→Pro, NPS (#1).
  Prérequis à toute priorisation fiable et à tout argumentaire B2B.

### 5.2 Produit cœur (Labo / recettes / confort)
- [ ] **Wake Lock** — écran toujours allumé sur pages recette/labo (#2).
  Pain point persona cœur (mains sales, écran qui s'éteint).
- [ ] Pistes ouvertes : photos de réalisations, favoris/collections, mode cuisine
  grand format, haptique, skeleton loaders, toast offline.

### 5.3 Acquisition / SEO
- [ ] **Pages recettes publiques** indexables (#5) — **levier d'acquisition #1**
  (la SPA cache tout le contenu derrière auth).
- [ ] **Recipe schema.org** sur ces pages (#3, bloqué par #5).
- [ ] **Blog** — (a) SEO (« comment réviser le CAP », EP1/EP2…) + (b) idées recettes /
  inspirations / variations saisonnières (#13). Absorbe le « contenu hors-saison ».
- [ ] **Partenariats blogs CAP** (Empreinte Sucrée, PatisCoach) — backlinks (#9).
- [ ] **App Store** (wrapper PWA Capacitor/PWABuilder) — découvrabilité (#11).
- [ ] **A/B test CTA** landing (#12, bridé par le trafic actuel).

### 5.4 Conversion / confiance (landing)
- [ ] **Screenshots produit** supplémentaires (sections features) (#4).
  (Le hero montre déjà la fiche Pâte à choux.)
- [ ] **Compteur d'inscrits réel** (#6) — preuve sociale, **jamais de chiffre fictif**.
- [ ] **Témoignages réels** (#8) — verbatims étudiant/candidat libre/passionné.
- [ ] **Contraste couleur marque WCAG AA** (#7) — `#6c63ff` ≈ 3,6:1 sur blanc.

### 5.5 Monétisation / Pro
- [ ] **PRO — Coût matières premières & rentabilité par projet** (#14).
  Mode Compta v2. Spec + roadmap phasée + checklist : **annexe roadmap-audit §6**.

### 5.6 Scale / B2B
- [ ] **Offre B2B CFA / lycées pro** (#10) — vrai levier de scale (x3-5 du revenu).
  Plan `school`, dashboard formateur, prospection : **annexe roadmap-audit §4**.

### 5.7 Expansion (long terme / à surveiller)
- [ ] **Extension CAP Boulanger / Chocolatier** (#15) — même moteur, marché ×3-4.
- [ ] **Communauté / partage de recettes** (#17) — effet réseau **mais risque de
  dilution du focus** → écarté pour l'instant.
- [ ] Robustesse référentiel : si l'Éducation Nationale modifie les épreuves, contenu
  à refaire (`recipes.json` + `docs/carnet-cap-2025-2026.md` = source unique facilitante).

---

## 6. Roadmap par horizon

> Synthèse priorisée (détail des scores au §7). Dépendances signalées.

**Quick wins (0–2 sem.)** — *Ease ≥ 7 & Impact ≥ 5*
1. Instrumenter les KPI (#1) — prérequis, ~1j.
2. Wake Lock recette/labo (#2) — ~2-4h, front seul.
3. Compteur d'inscrits réel (#6) — ~2-3h, après #1 (réutilise le `count`).

**Court terme / sprint suivant (2–4 sem.)**
4. Screenshots produit landing (#4) — dès captures propres dispo.
5. Contraste WCAG (#7) — assombrir texte fin vers `--color-brand-dark`.
6. Témoignages réels (#8) — lancer la collecte maintenant (délai humain).

**Moyen terme (1–3 mois)** — *big bets à séquencer*
- Pages recettes publiques SEO (#5) — chantier d'acquisition de fond, démarrer en
  parallèle. Puis **Recipe schema (#3)** dans la foulée (dépendance).
- Blog SEO + inspirations (#13).
- Partenariats blogs CAP (#9).

**Long terme (3–12 mois)**
- Offre B2B CFA (#10) — **amorcer en parallèle dès maintenant** (cycle commercial
  long), cf. annexe roadmap-audit §4.
- Feature PRO coût/rentabilité (#14) — cf. annexe roadmap-audit §6.
- App Store (#11). Extension CAP Boulanger/Chocolatier (#15).

**Écarté pour l'instant** : Communauté/partage (#17, dilution). Contenu hors-saison
(absorbé par le blog #13).

---

## 7. Matrice de priorisation ICE

**Méthode** : ICE — score = (Impact + Confidence + Ease) / 3, échelle 1–10.
**KPI cible** : acquisition organique + conversion Free→Pro ; B2B = ARR.
**Contraintes** : dev solo, urgence saisonnière (examen juin), **aucune baseline analytics**
(plafonne la Confidence de plusieurs actions).
**Date de calibrage** : 2026-05-19.

| Rang | Action | I | C | E | Score | Justifications |
|---|---|---|---|---|---|---|
| 1 | Instrumenter les KPI (inscrits, DAU/MAU, Free→Pro, NPS) | 7 | 9 | 8 | **8.0** | I : prérequis transverse / C : nécessité évidente, GTM+Supabase déjà là / E : events GA4 + 1 vue SQL, ~1j |
| 2 | Wake Lock écran (recette/labo) | 6 | 8 | 8 | **7.3** | I : pain point persona cœur / C : `navigator.wakeLock` documenté / E : front seul ~2-4h (ré-acquérir sur `visibilitychange`, fallback iOS<16.4) |
| 3 | Recipe schema.org (pages publiques) | 6 | 8 | 8 | **7.3** | **Bloqué par #5** → séquencé après. Score isolé élevé mais la séquence prime. |
| 4 | Screenshots produit landing | 8 | 7 | 6 | **7.0** | I : 100 % du trafic visiteurs / C : best practice + audit / E : front ~1-2j, bloqueur = vraies captures |
| 5 | Pages recettes publiques (SEO) | 9 | 8 | 4 | **7.0** | I : levier d'acquisition #1 / C : audit, mots-clés volume identifiés / E : 1-2 sem dev+rédac — **big bet** |
| 6 | Compteur d'inscrits réel | 5 | 6 | 8 | **6.3** | I : FOMO modéré si volume faible / C : efficacité dépend du chiffre / E : RPC count + UI ~2-3h |
| 7 | Contraste couleur marque (WCAG AA) | 3 | 9 | 7 | **6.3** | I : a11y, effet conversion faible / C : ratio mesurable / E : token ciblé <1j |
| 8 | Témoignages utilisateurs réels | 7 | 7 | 5 | **6.3** | I : social proof réel fort / C : best practice + audit / E : collecte humaine ~1 sem |
| 9 | Partenariats blogs CAP | 7 | 6 | 5 | **6.0** | I : backlinks + audience alignée / C : dépend de négo / E : négo externe, 0 dev |
| 10 | Offre B2B CFA / lycées pro | 9 | 6 | 3 | **6.0** | I : scale x3-5 ARR / C : marché structuré, non validé terrain / E : plan `school` + prospection 3-6 mois — **big bet** |
| 11 | App Store (wrapper PWA) | 7 | 6 | 4 | **5.7** | I : +30-50 % découvrabilité / C : wrappers connus / E : 2-4 sem + comptes dev |
| 12 | A/B test CTA landing | 5 | 5 | 6 | **5.3** | I : hero 100 % trafic, lift modéré / C : incertain par nature / E : ~1h config mais **significativité bridée par le faible trafic** |
| 13 | Blog (SEO + idées recettes/inspirations) | 7 | 6 | 3 | **5.3** | (a) SEO + (b) inspirations/saisonnier (rétention). E : ~2 mois éditorial + rendu Markdown prérendu — **big bet**. Absorbe « hors-saison ». |
| 14 | PRO — Coût matières & rentabilité par projet | 6 | 6 | 3 | **5.0** | Levier monétisation Pro, persona secondaire. E : tables + UX + moteur + exports, plusieurs sprints. Spec → annexe roadmap-audit §6. |
| 15 | Extension CAP Boulanger / Chocolatier | 6 | 4 | 3 | **4.3** | I : marché ×3-4 mais futur / C : non validé / E : 3-6 mois contenu |
| 16 | Contenu hors-saison (passionnés) | 4 | 4 | 4 | **4.0** | Absorbé par le blog #13 ; faible priorité isolée |
| 17 | Communauté / partage de recettes | 5 | 3 | 2 | **3.3** | Effet réseau mais **risque de dilution** / C : double tranchant / E : 6+ mois |

> _Convention : la matrice s'enrichit au fil des itérations. Pas de renumérotation
> ligne à ligne à chaque insertion — **le score ICE fait foi**, pas le numéro de rang.
> Départage des ex æquo : Ease desc, puis Confidence desc._

### Hypothèses de test prioritaires
1. **Pages recettes publiques** : exposer 5-10 recettes en contenu partiel indexable →
   trafic organique non-auth ↑ sous 2-3 mois (0 contenu crawlable aujourd'hui).
2. **Screenshots landing** : mockups produit → taux inscription visiteur→/auth ↑.
3. **Compteur d'inscrits** : preuve sociale → conversion landing ↑ — *valider seulement
   quand le chiffre est crédible (jamais de faux)*.

### Notes / arbitrages
- **#3 (schema recettes)** : score 7.3 mais **dépendance dure à #5** → séquencé après.
- **#10 (B2B CFA)** : sous-classé par l'Ease (3) mais **levier de revenu le plus fort**
  → amorcer en parallèle (cycle long), cf. annexe roadmap-audit §4.
- **#12 (A/B CTA)** : repoussé tant que #5 n'a pas augmenté le volume (sinon test non
  significatif).
- **#14 (PRO)** : reconsidérer à la hausse si la donnée (#1) montre une demande ou si
  le pivot semi-pro se confirme.
- Recalibrer I/C après 1-2 mois à la lumière des indicateurs (#1).

---

## 8. Suivi

- Mettre à jour les cases du §5 au fil de l'eau ; recalibrer le §7 mensuellement.
- Sans les KPI (#1), impossible de rassurer un partenaire/CFA ni de mesurer l'effet
  des autres chantiers : **#1 est le déblocage transverse n°1**.
- Toute nouvelle idée → §5 (catalogue) + §7 (ICE) dans la même itération.

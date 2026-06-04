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
- **Examen blanc** : 60 QCM par thème, note /20 + statut couleur, moyenne dans le Suivi.
  Notes persistées côté **Supabase** (table `exam_scores`) → **sync multi-device**.
- **Synchronisation multi-device** : chargement au login + refetch au focus +
  **Supabase Realtime** (`stores/realtime.js`). Migrations requises :
  `20260521_exam_scores.sql` puis `20260521_realtime.sql`.

---

## 5. Catalogue des idées d'évolution

> Regroupées par thème. Chaque idée est scorée au §7 (référence `#n` = rang ICE).
> Cases à cocher = avancement.

### 5.1 Mesure & socle (transverse)
- [~] **Instrumenter les KPI** (#1) — **events funnel câblés** : `paywall_viewed`
  (recette/labo/carnet-pdf), `upgrade_clicked` (toutes les CTA Pro), `exam_completed`
  (+ note /20). **Reste** : vues SQL serveur (inscrits, conversion Free→Pro, DAU/MAU)
  + NPS. Prérequis à toute priorisation fiable et argumentaire B2B.
- [x] **Page admin `/admin`** (✅ fait 2026-06-04). Gate `isAdmin` (`profiles.plan='admin'`) +
  RPC SECURITY DEFINER (`admin_list_users`, `admin_update_user_plan`, `admin_kpi_users`,
  `admin_kpi_recipes`, `admin_kpi_features`). KPI live : users (total/par plan/inscrits/actifs),
  features (progression, examens, notes, commentaires, photos), top 10 recettes testées/maîtrisées.
  Modification de plan par row. Sécurité serveur via RLS + check `is_admin()`.

### 5.2 Produit cœur (Labo / recettes / confort)
- [x] **Chrono d'entraînement — déplacé sur la fiche recette** (#0, ✅ fait 2026-05-21).
  Décision produit : le chrono n'est **pas** un 3ᵉ écran de Labo, il est **sur la page
  recette** pour qu'on suive les étapes en se chronométrant (chrono *sticky* pendant
  qu'il tourne). Modèle de maîtrise : **testé + quiz ≥ 75 % (Labo) + chrono validé (×1.2,
  fiche)** → `maitrisee` ; quiz seul → `validee` (corrige le statut `validee` jamais
  atteint). Le Labo reste Test→Quiz (intentionnel).
- [x] **Wake Lock** — écran toujours allumé sur pages recette/labo (#2, ✅ fait 2026-05-22).
  Action Svelte `wakeLock` (`src/lib/utils/wake-lock.js`), ré-acquise au focus,
  dégradation silencieuse si l'API manque (iOS < 16.4).
- [x] **Chrono désactivable** (#19, ✅ fait 2026-06-04). Toggle dans `/profil` →
  `profiles.show_chrono` (migration `20260604_show_chrono.sql`). Quand désactivé : le
  widget chrono est masqué sur la fiche recette, et la maîtrise dans le Mode Labo
  passe directement de test+quiz à `maitrisee` (sans exiger le chrono).
- [x] **Carnet PDF refondu conforme arrêté du 3 oct 2022** (✅ fait 2026-06-04).
  Format conforme aux consignes nationales CAP : page de garde + sections magenta
  par catégorie + grille 3 colonnes de tables. **Aucune méthode, technique ou
  température** (sinon le jury retire le carnet le jour de l'examen). Ingrédients
  triés par **ordre d'utilisation** (heuristique : 1ʳᵉ apparition dans les étapes).
  Masse totale calculée en grammes (œufs convertis 1u = 50g).
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
- [x] **Unifier le récit pricing bêta/payant** (#0bis, ✅ fait 2026-05-21). Récit unique :
  **plan Pro « bientôt disponible »**, paiement pas encore activé. Retiré « 7 jours gratuits /
  Stripe / essai / annulable » de Pricing + FAQ + foot ; CTA Pro = « Commencer gratuitement ».
  Fix `feature-cta` → `#how`. (Reste cohérent avec `profil` « Bientôt disponible ».)
- [x] **Fix landing « 2024-2025 »** (#24, ✅ fait 2026-06-04) sur `LandingPersonas.svelte`
  (signalé par Anne CFA, bug de crédibilité).
- [x] **Glossaire CAP** (#18, ✅ fait 2026-06-04). Page publique `/glossaire` (27 entrées,
  5 catégories : examen, méthode, progression, technique, ingrédient) + composant
  `<GlossaryTerm key="…">` (tooltip inline avec lien vers la page). Branchement sur
  les badges EP1/EP2 des fiches recettes.
- [ ] **Onboarding post-signup 3 voies** (#20) — « débutant / CAP / passionné » + parcours
  guidé sur les 10 recettes gratuites. Évite le décrochage en semaine 2.
- [ ] **Screenshots produit** supplémentaires (sections features) (#4).
  (Le hero montre déjà la fiche Pâte à choux.)
- [ ] **Compteur d'inscrits réel** (#6) — preuve sociale, **jamais de chiffre fictif**.
- [ ] **Témoignages réels** (#8) — verbatims étudiant/candidat libre/passionné.
- [ ] **Contraste couleur marque WCAG AA** (#7) — `#6c63ff` ≈ 3,6:1 sur blanc.

### 5.5 Monétisation / Pro
- [ ] **Activer Stripe + plan Pro réellement payable** (#21). Prérequis economic du
  lancement early adopters : sans paiement actif, « Pro bientôt » = frustration et
  zéro revenu testable. ICE 7.7.
- [ ] **PRO — Créer / ajouter ses propres recettes** (#13bis, **recalibré** suite test
  personas : Sophie + Marc convergent, Confidence 6→8, ICE 5.3→6.0). UI de création
  (recette + ingrédients + étapes + quiz) ; Marc demande aussi un champ **prix/kg**
  par ingrédient (fait pont avec #14 compta).
  Argument Pro fort pour Sophie (passionnée). Déjà annoncé « à venir » dans la FAQ.
- [ ] **PRO — Coût matières premières & rentabilité par projet** (#14).
  Mode Compta v2. Spec + roadmap phasée + checklist : **annexe roadmap-audit §6**.

### 5.6 Scale / B2B
- [ ] **Dashboard formateur V1** (#22) — vue classe + progression élèves agrégée
  (% recettes maîtrisées, top recettes faibles). **Condition pilote Anne CFA**, big bet.
- [ ] **Cadre RGPD mineurs documenté** (#23) — consentement parental, registre, désact.
  analytics par défaut sur comptes `school`. Condition pilote (apprentis CAP mineurs).
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

### 🎯 Lancement early adopters (CEO, test 4 personas 2026-06-04)

**Verdict** : **GO ciblé** sur le segment **candidats libres CAP** uniquement (Marc + Pierre).
**Pas grand public**, **pas B2B**, **pas passionnés** → on évite la dilution et les promesses
non tenues qui brûleraient des leads.

**Conditions sine qua non avant ouverture** (séquencées) :
1. **#24** Fix landing « 2024-2025 » → ✅ fait.
2. **#21** Stripe live + Pro payable (~3-5 j, prérequis economic).
3. **#18** Glossaire CAP + **#19** chrono désactivable (~1-2 j combiné).
4. **#20** Onboarding 3 voies + parcours guidé 10 recettes (~2-3 j).
5. **#1 reste** vues SQL serveur (inscrits, Free→Pro, DAU/MAU) (~½ j).

**Stratégie d'acquisition** : 30-50 candidats libres CAP session 2027, via groupes FB
« CAP Pâtissier candidat libre », r/pastry FR, commentaires Empreinte Sucrée / PatisCoach,
TikTok #CAPpâtissier. Offre early bird : **Pro annuel à 19 € au lieu de 39 € à vie**
contre 1 témoignage 60 s + NPS J30. Mails J15 et J45 pour structurer les retours
(alimente #8 témoignages).

**Métriques de décision ouverture grand public** :
| Métrique | Seuil GO grand public |
|---|---|
| Conversion Free→Pro à J30 | ≥ 8 % |
| Rétention W2 (revient ≥ 1×) | ≥ 50 % |
| NPS early adopters | ≥ 40 |
| Témoignages exploitables | ≥ 10 |

**À exclure de l'early adoption** : Sophie / passionnés (tant que #13bis pas livré),
Marc côté « vente pro » (tant que #14 pas livré), B2B CFA (pilote conditionnel ≠ early).



**🔴 Correctifs de confiance — AVANT tout (issus du test équipe 2026-05-21)**
0. **Restaurer le Chrono du Mode Labo** (#0) — régression bloquante, ~1j. Répare la promesse cœur avant de mesurer.
0bis. **Unifier le récit pricing bêta/payant** (#0bis) + fix `feature-cta` — ~½j, copy.

**Quick wins (0–2 sem.)** — *Ease ≥ 7 & Impact ≥ 5*
1. Instrumenter les KPI (#1) — prérequis, ~1j. Events précisés par l'analyste : `paywall_viewed`, `upgrade_clicked`, `exam_completed`(+note), `sync_applied` + vues Supabase.
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
**Date de calibrage** : 2026-05-21 (repriorisé après le test équipe).

| Rang | Action | I | C | E | Score | Justifications |
|---|---|---|---|---|---|---|
| 0 | ✅ **Chrono d'entraînement sur la fiche recette** (fait — relocalisé hors du Labo) | 9 | 9 | 7 | **8.3** | Livré : chrono sticky sur `/recettes/[id]` (suivre la recette en se chronométrant), maîtrise = test + quiz ≥75 % + chrono ×1.2 ; Labo reste Test→Quiz ; corrige le statut `validee` jamais atteint. `lab_chrono_completed` câblé. |
| 0bis | ✅ **Récit pricing unifié (« Pro bientôt »)** | 7 | 9 | 8 | **8.0** | Fait : retiré « 7j/Stripe/essai » de Pricing+FAQ+foot, CTA « Commencer gratuitement », fix `feature-cta`→`#how`. Cohérent avec profil « Bientôt disponible ». |
| 1 | 🟡 Instrumenter les KPI (events funnel **faits** ; reste vues SQL serveur + NPS) | 7 | 9 | 8 | **8.0** | Fait : `paywall_viewed`, `upgrade_clicked`, `exam_completed`(+note) câblés. Reste : vues SQL (inscrits, Free→Pro, DAU/MAU) + NPS. |
| 2 | ✅ Wake Lock écran (recette/labo) | 6 | 8 | 8 | **7.3** | Fait : action `wakeLock`, ré-acquise au focus, fallback silencieux iOS<16.4. |
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
| 13bis | PRO — Créer / ajouter ses propres recettes | 6 | 8 | 4 | **6.0** | **Convergence Sophie + Marc** (test personas 2026-06-04) : argument Pro confirmé. Schéma prêt (table `recettes` par user) → manque l'UI création + gating Pro. Marc : « ma priorité #1, avec champ prix d'achat/kg ». |
| 18 | ✅ **Glossaire CAP intégré** (tooltip + page `/glossaire`) | 7 | 8 | 8 | **7.7** | Fait 2026-06-04 : 27 entrées, 5 catégories, composant `<GlossaryTerm>` branché sur les badges EP1/EP2. |
| 19 | ✅ **Chrono désactivable** (toggle profil → `show_chrono`) | 6 | 8 | 8 | **7.3** | Fait 2026-06-04 : toggle dans `/profil`, désactive le widget sur la fiche ET bypass dans le Labo (mastery = test+quiz). Migration `20260604_show_chrono.sql`. |
| 20 | **Onboarding post-signup 3 voies** + parcours guidé sur les 10 recettes gratuites | 8 | 7 | 5 | **6.7** | Pierre décroche semaine 2 sans onboarding. Structure l'early adoption. |
| 21 | **Stripe live + plan Pro réellement payable** | 9 | 9 | 5 | **7.7** | Prérequis economic de l'early adoption. Sans ça « Pro bientôt » = frustration + 0 revenu testable. |
| 22 | Dashboard formateur V1 (vue classe + progression élèves) | 8 | 5 | 3 | **5.3** | Condition pilote B2B Anne. Big bet, démarrer en parallèle. |
| 23 | Cadre RGPD mineurs documenté (consent parental, DPA) | 6 | 7 | 5 | **6.0** | Condition pilote B2B (apprentis CAP mineurs). Doc + checkbox, pas dev lourd. |
| 24 | ✅ **Fix landing « 2024-2025 »** | 4 | 10 | 10 | **8.0** | Bug crédibilité repéré par Anne sur `LandingPersonas`. Corrigé 2026-06-04. |
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
- **Confiance avant features (CEO, test équipe 2026-05-21)** : #0 (Chrono) et #0bis
  (pricing) passent **devant l'instrumentation #1 elle-même** — inutile de mesurer une
  conversion sur un funnel qui ment / une promesse non tenue. On répare le produit
  promis, puis on instrumente le vrai funnel. Aucun nouveau chantier (B2B, compta,
  multi-CAP) ne remonte tant que ces deux ruptures de confiance ne sont pas réglées.
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

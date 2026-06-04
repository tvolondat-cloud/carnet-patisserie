/**
 * Glossaire CAP Pâtissier — vocabulaire essentiel.
 *
 * Source unique pour :
 *  - la page /glossaire (publique)
 *  - le composant <GlossaryTerm key="…"> (tooltip inline)
 *
 * Ajouter une entrée : { key, term, cat, short, [long] }
 *  - key : slug stable (utilisé dans les ancres et les `key` du composant)
 *  - cat : 'examen' | 'methode' | 'progression' | 'technique' | 'ingredient'
 *  - short : 1-2 phrases (affichées dans le tooltip)
 *  - long  : détail optionnel pour la page (markdown léger)
 */

export const CATEGORIES = [
	{ id: 'examen',      label: 'Examen & cadre',  emoji: '🎓' },
	{ id: 'methode',     label: 'Méthode Brigade', emoji: '🧪' },
	{ id: 'progression', label: 'Progression',     emoji: '📊' },
	{ id: 'technique',   label: 'Techniques',      emoji: '🛠️' },
	{ id: 'ingredient',  label: 'Ingrédients',     emoji: '🥚' }
];

export const glossaire = [
	// ── Examen & cadre ─────────────────────────────────────────
	{
		key: 'ep1', term: 'EP1', cat: 'examen',
		short: '1ʳᵉ épreuve pratique du CAP Pâtissier (5h). Au programme : viennoiseries, pâte feuilletée et un gâteau de voyage.',
		long: 'Tu réalises 1 viennoiserie (croissant ou pain au chocolat), 1 pâte feuilletée détaillée + cuite, et 1 gâteau de voyage (cake, financier, madeleine…). Notation sur la maîtrise gestuelle, l\'organisation et la conformité au cahier des charges.'
	},
	{
		key: 'ep2', term: 'EP2', cat: 'examen',
		short: '2ᵉ épreuve pratique (5h) : un entremets imposé + un dessert à l\'assiette ou des tartes.',
		long: 'Plus exigeante côté assemblage et finitions : un entremets multi-couches (biscuit, mousse, glaçage) et une déclinaison sur fiche technique. L\'ordonnancement et la rigueur priment.'
	},
	{
		key: 'candidat-libre', term: 'Candidat libre', cat: 'examen',
		short: 'Tu prépares le CAP seul (sans école), tu t\'inscris à l\'examen via le rectorat de ton académie. Inscriptions oct-nov pour l\'examen de juin.',
	},

	// ── Méthode Brigade Sucrée ──────────────────────────────────
	{
		key: 'mode-labo', term: 'Mode Labo', cat: 'methode',
		short: 'Test en cuisine → Quiz théorique. Le chrono se fait sur la fiche recette pour que tu suives les étapes en te chronométrant.',
	},
	{
		key: 'chrono', term: 'Chrono ×1.2', cat: 'methode',
		short: 'Le temps cible avec 20 % de tolérance. Ex : cible 30 min → validé si tu finis en ≤ 36 min.',
	},
	{
		key: 'quiz-75', term: 'Quiz ≥ 75 %', cat: 'methode',
		short: 'Le seuil de validation du quiz théorique : 3 bonnes réponses sur 4 minimum.',
	},

	// ── Statuts de progression ──────────────────────────────────
	{ key: 'statut-a-tester',  term: 'À tester',  cat: 'progression', short: 'Tu n\'as pas encore touché à cette recette.' },
	{ key: 'statut-testee',    term: 'Testée',    cat: 'progression', short: 'Tu as réalisé la recette au moins une fois (en cuisine).' },
	{ key: 'statut-validee',   term: 'Validée',   cat: 'progression', short: 'Quiz réussi (≥ 75 %) mais chrono pas encore validé.' },
	{ key: 'statut-maitrisee', term: 'Maîtrisée', cat: 'progression', short: 'Les 3 critères validés : testée + quiz + chrono. Tu la fais les yeux fermés.' },

	// ── Techniques de base ─────────────────────────────────────
	{ key: 'sablage', term: 'Sablage', cat: 'technique', short: 'Mélanger la farine avec le beurre froid en dés, en frottant entre les paumes, jusqu\'à obtenir une texture sableuse.' },
	{ key: 'fraser', term: 'Fraser', cat: 'technique', short: 'Écraser la pâte avec la paume sur le plan de travail pour finir l\'homogénéisation, sans corser le gluten.' },
	{ key: 'foncer', term: 'Foncer', cat: 'technique', short: 'Mettre la pâte abaissée en place dans un cercle ou un moule, en épousant les angles.' },
	{ key: 'pointage', term: 'Pointage', cat: 'technique', short: '1ʳᵉ pousse d\'une pâte levée, en masse, à 24-26°C (~1h selon la recette).' },
	{ key: 'apprêt', term: 'Apprêt', cat: 'technique', short: '2ᵉ pousse, après façonnage, juste avant cuisson. À l\'étuve 26-28°C.' },
	{ key: 'tourage', term: 'Tourage', cat: 'technique', short: 'Donner des tours simples (×3 ou ×6) ou doubles à la pâte feuilletée pour créer les couches beurre/détrempe.' },
	{ key: 'cremage', term: 'Crémage', cat: 'technique', short: 'Travailler beurre pommade + sucre au fouet ou à la feuille jusqu\'à blanchiment et texture aérienne.' },
	{ key: 'pasteurisation', term: 'Pasteurisation', cat: 'technique', short: 'Monter une crème pâtissière à 85°C pendant 1 min pour détruire les bactéries et stabiliser.' },
	{ key: 'dessecher', term: 'Dessécher (panade)', cat: 'technique', short: 'Pour la pâte à choux : remettre la pâte sur le feu après ajout farine, jusqu\'à formation d\'une boule qui se décolle de la casserole.' },
	{ key: 'tablette', term: 'Mise au point chocolat', cat: 'technique', short: 'Faire passer le chocolat par 3 températures (45°C → 27°C → 31-32°C noir) pour obtenir un beau brillant et un cassant net.' },

	// ── Ingrédients / matériel ─────────────────────────────────
	{ key: 't55', term: 'Farine T55', cat: 'ingredient', short: 'Farine standard, ~10 % de protéines. Pour pâtes brisées, feuilletées, sablées, choux.' },
	{ key: 't45', term: 'Farine T45', cat: 'ingredient', short: 'Farine plus blanche et plus riche en gluten (~11-12 %). Idéale pour viennoiseries et brioches.' },
	{ key: 'beurre-tourage', term: 'Beurre de tourage', cat: 'ingredient', short: 'Beurre sec à ~84 % de matière grasse, reste malléable à 14-16°C — c\'est lui qui fait les couches du feuilletage.' },
	{ key: 'beurre-pommade', term: 'Beurre pommade', cat: 'ingredient', short: 'Beurre travaillé à 18-22°C jusqu\'à texture crémeuse et souple (consistance dentifrice).' },
	{ key: 'gelatine', term: 'Gélatine', cat: 'ingredient', short: 'Feuilles à réhydrater 10 min dans l\'eau froide avant emploi. 1 feuille ≈ 2 g.' },
	{ key: 'tpt', term: 'TPT (tant pour tant)', cat: 'ingredient', short: 'Mélange à parts égales de poudre d\'amandes + sucre glace. Base de la frangipane, du biscuit Joconde, des macarons.' }
];

/** Retourne une entrée par sa clé. */
export function findTerm(key) {
	return glossaire.find((g) => g.key === key);
}

/** Groupe par catégorie (pour la page). */
export function byCategory() {
	const map = new Map(CATEGORIES.map((c) => [c.id, []]));
	for (const e of glossaire) map.get(e.cat)?.push(e);
	return CATEGORIES.map((c) => ({ ...c, entries: map.get(c.id) ?? [] }));
}

<script>
/**
 * SEO + GEO de la landing Brigade Sucrée.
 *
 * Combo classique :
 * - <title> + meta description optimisés mots-clés cibles
 * - Open Graph + Twitter Card (partage social)
 * - canonical (déjà dans app.html mais on peut surcharger)
 * - Structured data JSON-LD pour Google + AI engines :
 *   • Organization
 *   • WebApplication / EducationalApplication (Schema.org)
 *   • FAQPage (reprend nos 8 Q/R)
 *   • BreadcrumbList
 *
 * GEO (Generative Engine Optimization) :
 * - JSON-LD structuré = digestible par ChatGPT, Perplexity, Claude, Gemini
 * - FAQ explicite pour les AI Overviews / Featured Snippets Google
 * - Description d'entité claire avec faits chiffrés (17 recettes, etc.)
 */

const SITE_URL = 'https://brigadesucree.app';
const TITLE = 'Brigade Sucrée — App CAP Pâtissier · Recettes, Mode Labo & Suivi de progression';
const DESCRIPTION = 'L\'app gratuite des étudiants CAP Pâtissier et passionnés. 17 recettes du référentiel officiel, mode laboratoire (test + quiz + chrono), suivi par compétence, carnet PDF imprimable. Conforme au référentiel CAP 2024-2025.';
const KEYWORDS = 'CAP Pâtissier, app CAP Pâtissier, réviser CAP Pâtissier, préparer CAP Pâtissier, examen CAP Pâtissier, candidat libre CAP Pâtissier, EP1 EP2 pâtisserie, recettes CAP, mode laboratoire pâtisserie, app pâtisserie';
const OG_IMAGE = `${SITE_URL}/og-image.png`;

// FAQ identique à LandingFAQ.svelte (à garder synchro)
const faqs = [
	{ q: 'Brigade Sucrée est-elle adaptée à un débutant complet ?', a: 'Oui. Chaque recette inclut les étapes détaillées, le vocabulaire technique expliqué, les pièges courants à éviter, et un quiz pour ancrer la théorie. Le mode Labo te guide pas à pas, avec des messages encourageants même si tu rates.' },
	{ q: 'Combien coûte l\'app ?', a: '100% gratuit pendant la bêta — toutes les fonctionnalités incluses. Le plan Pro à 4,99€/mois (ou 39€/an) sortira après le Sprint 3 avec des features avancées (photos, partage, streak). Les inscrits avant le passage en Pro gardent leur accès gratuit aux fonctionnalités actuelles.' },
	{ q: 'Le mode Laboratoire, c\'est concrètement quoi ?', a: 'Une méthode en 3 étapes : (1) Tester la recette en cuisine et la cocher. (2) Quiz théorique avec 4 questions, validé à 75%. (3) Chrono de réalisation, validé si tu es dans les temps + 20% de tolérance. Quand les 3 sont validées → recette "maîtrisée".' },
	{ q: 'Est-ce que Brigade Sucrée remplace une école de pâtisserie ?', a: 'Non, c\'est un complément. L\'app structure ta révision et te fait gagner du temps, mais le geste se travaille en pratique. Pour les étudiants CAP en alternance, c\'est l\'outil idéal entre les sessions au CFA. Pour les particuliers, c\'est un guide structuré.' },
	{ q: 'Sur quels appareils ça marche ?', a: 'Brigade Sucrée est une PWA (Progressive Web App) : ça tourne sur iOS, Android, desktop, peu importe le navigateur moderne. Tu peux l\'installer comme une app native (icône sur l\'écran d\'accueil) et l\'utiliser hors-ligne grâce au cache.' },
	{ q: 'Mes données sont-elles privées ?', a: 'Oui. Tes recettes, notes et progression sont stockées en France (Supabase Paris) avec Row Level Security : seul ton compte y accède. Pas de revente, pas de pub. Les analytics sont opt-in (Consent Mode v2 RGPD), tu peux refuser depuis la bannière cookies.' },
	{ q: 'Je peux exporter mes recettes ?', a: 'Oui : export PDF complet (format A4, marge 3 cm classeur, couleurs Berry Jam). Le PDF inclut les ingrédients, les étapes, tes notes personnelles. Filtres par catégorie ou option "uniquement les recettes maîtrisées".' },
	{ q: 'Puis-je ajouter mes propres recettes ?', a: 'Pas encore : la bêta inclut les 17 recettes du référentiel CAP officiel. Les recettes personnelles arrivent au Sprint 2 (création, édition, photos). En attendant, tu peux modifier les ingrédients, les notes et les commentaires sur les recettes existantes.' }
];

// JSON-LD : Organization
const orgJsonLd = {
	'@context': 'https://schema.org',
	'@type': 'Organization',
	name: 'Brigade Sucrée',
	url: SITE_URL,
	logo: `${SITE_URL}/icon-512.png`,
	description: 'App PWA pour étudiants CAP Pâtissier et particuliers passionnés.',
	sameAs: [
		'https://github.com/tvolondat-cloud/carnet-patisserie'
	],
	contactPoint: {
		'@type': 'ContactPoint',
		email: 'hello@brigadesucree.app',
		contactType: 'Customer Support',
		availableLanguage: 'French'
	}
};

// JSON-LD : WebApplication (catégorie EducationalApplication)
const appJsonLd = {
	'@context': 'https://schema.org',
	'@type': ['WebApplication', 'EducationalApplication'],
	name: 'Brigade Sucrée',
	url: SITE_URL,
	applicationCategory: 'EducationApplication',
	applicationSubCategory: 'Cooking & Pastry Education',
	operatingSystem: 'Web, iOS, Android (PWA)',
	description: DESCRIPTION,
	inLanguage: 'fr-FR',
	educationalLevel: 'CAP (Niveau 3)',
	educationalUse: 'Self-paced training, exam preparation',
	teaches: [
		'Pâtisserie française',
		'Techniques CAP Pâtissier',
		'Référentiel EP1 EP2',
		'Recettes traditionnelles',
		'Mode laboratoire pâtisserie'
	],
	audience: {
		'@type': 'EducationalAudience',
		audienceType: 'Étudiants CAP Pâtissier et particuliers passionnés'
	},
	offers: {
		'@type': 'Offer',
		price: '0',
		priceCurrency: 'EUR',
		availability: 'https://schema.org/InStock',
		category: 'Free during beta'
	},
	featureList: [
		'17 recettes du référentiel CAP officiel',
		'Mode Laboratoire (test + quiz + chrono)',
		'Suivi de progression par compétence',
		'Calculateur de rendement (×0.25 à ×10)',
		'Carnet PDF imprimable A4',
		'Cours d\'ordonnancement EP1/EP2',
		'Mode hors-ligne (PWA)',
		'Authentification Google OAuth ou email'
	],
	creator: {
		'@type': 'Organization',
		name: 'Brigade Sucrée'
	},
	aggregateRating: undefined // À ajouter dès qu'on a 10+ vrais avis
};

// JSON-LD : FAQPage (reprend toutes nos questions)
const faqJsonLd = {
	'@context': 'https://schema.org',
	'@type': 'FAQPage',
	mainEntity: faqs.map((f) => ({
		'@type': 'Question',
		name: f.q,
		acceptedAnswer: {
			'@type': 'Answer',
			text: f.a
		}
	}))
};

// JSON-LD : WebSite avec SearchAction (utile pour Google Sitelinks)
const websiteJsonLd = {
	'@context': 'https://schema.org',
	'@type': 'WebSite',
	url: SITE_URL,
	name: 'Brigade Sucrée',
	description: DESCRIPTION,
	inLanguage: 'fr-FR',
	publisher: {
		'@type': 'Organization',
		name: 'Brigade Sucrée'
	}
};

// Combine tous les schemas
const jsonLd = {
	'@context': 'https://schema.org',
	'@graph': [orgJsonLd, websiteJsonLd, appJsonLd, faqJsonLd]
};
</script>

<svelte:head>
	<title>{TITLE}</title>
	<meta name="description" content={DESCRIPTION} />
	<meta name="keywords" content={KEYWORDS} />
	<meta name="author" content="Brigade Sucrée" />
	<meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large" />

	<!-- Open Graph -->
	<meta property="og:type" content="website" />
	<meta property="og:url" content={SITE_URL} />
	<meta property="og:title" content={TITLE} />
	<meta property="og:description" content={DESCRIPTION} />
	<meta property="og:image" content={OG_IMAGE} />
	<meta property="og:image:width" content="1200" />
	<meta property="og:image:height" content="630" />
	<meta property="og:image:alt" content="Brigade Sucrée — App CAP Pâtissier" />
	<meta property="og:site_name" content="Brigade Sucrée" />
	<meta property="og:locale" content="fr_FR" />

	<!-- Twitter Card -->
	<meta name="twitter:card" content="summary_large_image" />
	<meta name="twitter:title" content={TITLE} />
	<meta name="twitter:description" content={DESCRIPTION} />
	<meta name="twitter:image" content={OG_IMAGE} />
	<meta name="twitter:image:alt" content="Brigade Sucrée — App CAP Pâtissier" />

	<!-- Hreflang (futur multi-langue) -->
	<link rel="alternate" hreflang="fr" href={SITE_URL} />
	<link rel="alternate" hreflang="x-default" href={SITE_URL} />

	<!-- JSON-LD Structured Data -->
	{@html `<script type="application/ld+json">${JSON.stringify(jsonLd)}</script>`}
</svelte:head>

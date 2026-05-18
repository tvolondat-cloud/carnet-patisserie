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
 * - Description d'entité claire avec faits chiffrés (58 recettes, etc.)
 */

import { faqs } from '$lib/data/landing-faq.js';

const SITE_URL = 'https://brigadesucree.app';
const TITLE = 'Brigade Sucrée — App CAP Pâtissier · Recettes, Mode Labo & Suivi de progression';
const DESCRIPTION = 'L\'app des étudiants CAP Pâtissier et passionnés. 58 recettes du référentiel officiel, mode laboratoire (test + quiz + chrono), suivi par compétence, carnet PDF imprimable. 10 recettes gratuites, plan Pro dès 39€/an. Conforme au référentiel CAP 2025-2026.';
const KEYWORDS = 'CAP Pâtissier, app CAP Pâtissier, réviser CAP Pâtissier, préparer CAP Pâtissier, examen CAP Pâtissier, candidat libre CAP Pâtissier, EP1 EP2 pâtisserie, recettes CAP, mode laboratoire pâtisserie, app pâtisserie';
const OG_IMAGE = `${SITE_URL}/og-image.png`;

// FAQ : source unique partagée avec LandingFAQ.svelte (pas de duplication)
// → src/lib/data/landing-faq.js

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
	offers: [
		{
			'@type': 'Offer',
			name: 'Gratuit',
			price: '0',
			priceCurrency: 'EUR',
			availability: 'https://schema.org/InStock',
			description: '10 recettes fondamentales, Mode Labo, suivi, cours EP1/EP2'
		},
		{
			'@type': 'Offer',
			name: 'Pro mensuel',
			price: '4.99',
			priceCurrency: 'EUR',
			availability: 'https://schema.org/InStock',
			description: '58 recettes, carnet PDF, 50 fiches, 60 QCM'
		},
		{
			'@type': 'Offer',
			name: 'Pro annuel',
			price: '39',
			priceCurrency: 'EUR',
			availability: 'https://schema.org/InStock',
			description: 'Plan Pro complet, −35% vs mensuel'
		}
	],
	featureList: [
		'58 recettes du référentiel CAP Pâtissier 2025-2026',
		'Mode Laboratoire (test + quiz + chrono)',
		'Suivi de progression par compétence',
		'Calculateur de rendement (×0.25 à ×10)',
		'Carnet PDF imprimable A4',
		'50 fiches de révision + 60 QCM d\'examen blanc',
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

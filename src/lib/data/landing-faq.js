/**
 * Source unique des Q/R de la landing.
 *
 * Utilisée à la fois par :
 *  - LandingFAQ.svelte    → affichage (accordéon)
 *  - LandingSEO.svelte    → JSON-LD FAQPage (rich snippets Google / GEO)
 *
 * ⚠️ Ne JAMAIS dupliquer ce tableau ailleurs : un seul fichier = pas de
 * désynchronisation entre l'affichage et les données structurées.
 */
export const faqs = [
	{
		q: 'Brigade Sucrée est-elle adaptée à un débutant complet ?',
		a: 'Oui. Chaque recette inclut les étapes détaillées, le vocabulaire technique expliqué, les pièges courants à éviter, et un quiz pour ancrer la théorie. Le mode Labo te guide pas à pas, avec des messages encourageants même si tu rates.'
	},
	{
		q: 'Combien coûte l\'app ?',
		a: 'Le plan Gratuit l\'est pour toujours : 10 recettes fondamentales, Mode Labo complet, suivi de progression et cours EP1/EP2 — sans carte bancaire. Le plan Pro (4,99€/mois ou 39€/an, soit −35%) débloquera les 58 recettes CAP, le carnet PDF imprimable, les 50 fiches de révision et les 60 QCM d\'examen blanc. Le paiement n\'est pas encore activé : pendant la bêta, profite du gratuit, le plan Pro arrive bientôt.'
	},
	{
		q: 'Le mode Laboratoire, c\'est concrètement quoi ?',
		a: 'Une méthode en 3 étapes : (1) Tester la recette en cuisine et la cocher. (2) Quiz théorique avec 4 questions, validé à 75%. (3) Chrono de réalisation, validé si tu es dans les temps + 20% de tolérance. Quand les 3 sont validées → recette "maîtrisée".'
	},
	{
		q: 'Est-ce que Brigade Sucrée remplace une école de pâtisserie ?',
		a: 'Non, c\'est un complément. L\'app structure ta révision et te fait gagner du temps, mais le geste se travaille en pratique. Pour les étudiants CAP en alternance, c\'est l\'outil idéal entre les sessions au CFA. Pour les particuliers, c\'est un guide structuré.'
	},
	{
		q: 'Sur quels appareils ça marche ?',
		a: 'Brigade Sucrée est une PWA (Progressive Web App) : ça tourne sur iOS, Android, desktop, peu importe le navigateur moderne. Tu peux l\'installer comme une app native (icône sur l\'écran d\'accueil) et l\'utiliser hors-ligne grâce au cache.'
	},
	{
		q: 'Mes données sont-elles privées ?',
		a: 'Oui. Tes recettes, notes et progression sont stockées en France (Supabase Paris) avec Row Level Security : seul ton compte y accède. Pas de revente, pas de pub. Les analytics sont opt-in (Consent Mode v2 RGPD), tu peux refuser depuis la bannière cookies.'
	},
	{
		q: 'Je peux exporter mes recettes ?',
		a: 'Oui : export PDF complet (format A4, marge 3 cm classeur, couleurs Berry Jam). Le PDF inclut les ingrédients, les étapes, tes notes personnelles. Filtres par catégorie ou option "uniquement les recettes maîtrisées".'
	},
	{
		q: 'Puis-je ajouter mes propres recettes ?',
		a: 'Pas encore : l\'app couvre les 58 recettes du référentiel CAP Pâtissier officiel 2025-2026. Les recettes personnelles (création, édition, photos) arrivent prochainement. En attendant, tu peux modifier les ingrédients, ajuster les quantités au calculateur, et ajouter tes notes et commentaires sur chaque recette.'
	}
];

<script>
let activeSection = 0;

const sections = [
	{
		title: '📋 Stratégie générale',
		content: [
			{ heading: 'Priorité EP1 — Viennoiserie', body: 'Commence TOUJOURS par les viennoiseries. La pâte levée feuilletée demande 3 tours minimum et 30 min de repos entre chaque. Lance-la dès l\'arrivée au labo.' },
			{ heading: 'Règle d\'or du timing', body: 'Planifie à rebours depuis la remise : si tu remets à 12h, la cuisson doit démarrer à 11h. La déco et le dressage = 20 min incompressibles.' },
			{ heading: 'Organisation du plan de travail', body: 'Zone froide à gauche, zone chaude à droite. Nettoie au fur et à mesure — un plan propre = un esprit clair.' },
		]
	},
	{
		title: '🥐 EP1 — Viennoiseries',
		content: [
			{ heading: 'Pâte levée feuilletée (PLF)', body: 'Détrempe → 30 min froid → Beurrage → 1er tour simple → 30 min → 2e tour → 30 min → 3e tour → Façonnage. Respecter 16°C pour le beurre.' },
			{ heading: 'Croissants', body: 'Abaisser à 3mm. Triangle 8×20cm. Rouler sans écraser les feuillets. Dorer avec œuf battu sans toucher les bords (colle les feuillets).' },
			{ heading: 'Pains au chocolat', body: 'Rectangle 8×10cm. 2 bâtons de chocolat à 1/3 et 2/3. Éviter de passer le doigt sur la tranche.' },
			{ heading: 'Fermentation', body: '2h à 25°C maxi. Les viennoiseries doublent de volume. Ne jamais mettre au four trop tôt (effondrement).' },
		]
	},
	{
		title: '🎂 EP2 — Entremets',
		content: [
			{ heading: 'Insert en premier', body: 'L\'insert (crémeux, confit, gelée) doit être congelé avant le montage. Prépare-le dès le début de la séance EP2.' },
			{ heading: 'Montage à l\'envers', body: 'Mousse → Insert congelé → Biscuit → Retourner sur semelle. L\'entremets congelé se glace parfaitement.' },
			{ heading: 'Glaçage miroir', body: 'Utiliser à 35°C. Entremets sortant du congélateur (-18°C). Verser en une fois au centre et laisser couler. Ne jamais toucher avec une spatule.' },
			{ heading: 'Températures critiques', body: 'Mousse bavaroise : crème anglaise à 82-84°C, gélatine gonflée froide, monter crème à 35% avant incorporation.' },
		]
	},
	{
		title: '⚖️ Pesées & Hygiène',
		content: [
			{ heading: 'Précision obligatoire', body: 'Tarer la balance entre chaque ingrédient. En pâtisserie, 5g d\'écart sur la levure = ratage. Peser dans l\'ordre de la recette.' },
			{ heading: 'HACCP en labo', body: 'Laver les mains : avant de commencer, après chaque interruption, après contact avec œufs crus, après avoir touché le sol.' },
			{ heading: 'Traçabilité', body: 'Étiqueter tous les contenants avec : Nom du produit, Date de fabrication, DLC. Indispensable pour l\'examen.' },
		]
	},
	{
		title: '🔥 Cuissons',
		content: [
			{ heading: 'Préchauffer le four', body: 'Minimum 20 min avant. Four à sole : 220°C pour viennoiseries, 180°C pour biscuits, 160°C pour crèmes.' },
			{ heading: 'Enfourner sans hésiter', body: 'Ne pas ouvrir le four pendant les 10 premières minutes (chute de température = effondrement des soufflés et choux).' },
			{ heading: 'Test de cuisson', body: 'Crème patissière : 1 min à ébullition après épaississement. Biscuit Joconde : rebond au toucher. Pâte à choux : creux quand on tape le dessous.' },
		]
	},
	{
		title: '🎓 Techniques essentielles',
		content: [
			{ heading: 'Tempérage du chocolat', body: 'Fondre à 50°C → Tablage à 27°C → Remonter à 31-32°C (noir) ou 29-30°C (lait/blanc). Travailler vite, le chocolat cristallise.' },
			{ heading: 'Pochage', body: 'Tenir la poche à 90° pour les choux, 45° pour les éclairs. Pression constante = régularité. S\'entraîner sur papier cuisson.' },
			{ heading: 'Montage crème', body: 'Bol + fouet froids. Crème à 4°C minimum. Monter à vitesse moyenne puis rapide. Arrêter au bec d\'oiseau pour la chantilly.' },
		]
	},
	{
		title: '📅 Méthode d\'entraînement',
		content: [
			{ heading: 'Semaines 1-4 : Bases', body: 'Maîtriser les crèmes de base (patissière, anglaise, chantilly) et la pâte à choux. 2 sessions/semaine en reproduisant les gestes.' },
			{ heading: 'Semaines 5-8 : Vitesse', body: 'Chronométrer chaque recette. Objectif : être dans les temps CAP (voir chrono_cible). Analyser les gestes qui perdent du temps.' },
			{ heading: 'Semaines 9-12 : Assemblages', body: 'Enchaîner 2-3 recettes en une session. Simuler les conditions d\'examen (4h EP1, 4h EP2). Gestion du stress et de l\'organisation.' },
			{ heading: 'La veille de l\'examen', body: 'Ne rien tenter de nouveau. Réviser les fiches recettes. Préparer son matériel. Dormir 8h. La fatigue est l\'ennemi n°1.' },
		]
	},
];
</script>

<div class="page">
	<h1 class="page-title">📋 Ordonnancement</h1>
	<p class="page-subtitle">Cours EP1 & EP2 — Référentiel CAP 2024-2025</p>

	<div class="filter-chips mb-4">
		{#each sections as s, i}
		<button class="chip" class:active={activeSection === i} on:click={() => activeSection = i}>
			{s.title.split(' ')[0]} {s.title.split(' ').slice(1, 3).join(' ')}
		</button>
		{/each}
	</div>

	<div class="card">
		<h2 style="font-size:1.1rem;font-weight:700;margin-bottom:16px">{sections[activeSection].title}</h2>
		{#each sections[activeSection].content as item}
		<div style="margin-bottom:16px;padding-bottom:16px;border-bottom:1px solid var(--color-border)">
			<h3 style="font-size:0.9rem;font-weight:700;margin-bottom:6px;color:var(--color-brand)">{item.heading}</h3>
			<p class="text-sm" style="line-height:1.6;color:var(--color-text-2)">{item.body}</p>
		</div>
		{/each}
	</div>
</div>

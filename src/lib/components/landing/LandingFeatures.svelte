<script>
const features = [
	{
		icon: '🧪',
		title: 'Mode Laboratoire',
		desc: 'Tester → Quiz → Chrono. La méthode des CFA pour ancrer chaque recette en mémoire.',
		bullets: ['Quiz validé à 75%', 'Chrono +20% tolérance', 'Maîtrisée = 3 étapes ✓']
	},
	{
		icon: '🎯',
		title: 'Examen blanc',
		desc: '60 QCM officiels rangés par thème (cadre, EP1, EP2, hygiène, technologie…). Tu choisis un thème, tu enchaînes — comme le jour J.',
		bullets: ['10 thèmes du programme', 'Note /20 + verdict couleur', 'Moyenne suivie dans le tableau de bord'],
		featured: true
	},
	{
		icon: '📚',
		title: '58 recettes du référentiel',
		desc: 'Crèmes, pâtes, viennoiseries, entremets, glaçages… Tout le référentiel CAP 2025-2026, prêt à étudier.',
		bullets: ['Programme EP1 / EP2 couvert', 'Pâte feuilletée, à choux, brioche', 'Opéra, Paris-Brest, Tarte Tatin']
	},
	{
		icon: '📊',
		title: 'Suivi par compétence',
		desc: 'Score global, barres par compétence CAP et moyenne d\'examen blanc. Tu vois où tu progresses, où tu cales.',
		bullets: ['Cuissons · Textures · Pesées', 'Moyenne examen blanc /20', '4 statuts : à tester → maîtrisée']
	},
	{
		icon: '📄',
		title: 'Carnet PDF imprimable',
		desc: 'Exporte tes fiches au format A4, marge 3 cm classeur, couleurs Berry Jam. Parfait pour le labo.',
		bullets: ['100% client-side', 'Filtres par catégorie', 'Tes notes incluses']
	},
	{
		icon: '🥐',
		title: 'Calculateur de rendement',
		desc: 'Multiplicateur ×0.25 à ×10. Adapte chaque recette en temps réel selon tes besoins.',
		bullets: ['Édition inline', 'Sauvegarde auto', 'Toutes les unités']
	}
];
</script>

<section class="ld-section ld-section-cream features" id="features">
	<div class="ld-container">
		<div class="features-header">
			<span class="ld-eyebrow">Tout ce qu'il te faut</span>
			<h2 class="ld-h2">Une boîte à outils pensée pour le CAP</h2>
			<p class="ld-lead">
				Chaque feature est calibrée sur le référentiel officiel et conçue pour les conditions réelles :
				cuisine, transport, révision la veille de l'examen.
			</p>
		</div>

		<div class="ld-grid ld-grid-3 features-grid">
			{#each features as f}
				<article class="feature-card ld-card" class:feature-card-featured={f.featured}>
					{#if f.featured}<span class="feature-badge">Nouveau</span>{/if}
					<div class="feature-icon" aria-hidden="true">{f.icon}</div>
					<h3 class="ld-h3">{f.title}</h3>
					<p class="feature-desc">{f.desc}</p>
					<ul class="feature-bullets">
						{#each f.bullets as b}
							<li>{b}</li>
						{/each}
					</ul>
					{#if f.featured}
					<a href="#pricing" class="feature-cta" data-track="cta:examen-feature">Voir comment ça marche →</a>
					{/if}
				</article>
			{/each}
		</div>
	</div>
</section>

<style>
.features-header {
	text-align: center;
	max-width: 720px;
	margin: 0 auto 48px;
}
.features-header .ld-lead { margin-left: auto; margin-right: auto; }

.feature-card {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.feature-icon {
	width: 56px;
	height: 56px;
	border-radius: 14px;
	background: linear-gradient(135deg, var(--ld-orange-light), var(--ld-orange));
	display: grid;
	place-items: center;
	font-size: 1.6rem;
	margin-bottom: 8px;
	box-shadow: 0 6px 14px rgba(210, 104, 61, 0.25);
}

.feature-desc {
	color: var(--ld-text-muted);
	margin: 0 0 12px;
	font-size: 0.92rem;
	line-height: 1.55;
}

.feature-bullets {
	list-style: none;
	padding: 0;
	margin: 0;
	display: flex;
	flex-direction: column;
	gap: 6px;
}
.feature-bullets li {
	font-size: 0.85rem;
	color: var(--ld-deep);
	padding-left: 22px;
	position: relative;
}
.feature-bullets li::before {
	content: '✓';
	position: absolute;
	left: 0;
	color: var(--ld-orange);
	font-weight: 700;
}

/* Carte Examen blanc — mise en avant */
.feature-card-featured {
	position: relative;
	border: 1.5px solid var(--ld-orange);
	background: linear-gradient(180deg, var(--ld-white), rgba(232, 152, 85, 0.06));
	box-shadow: 0 18px 38px rgba(210, 104, 61, 0.16);
}
.feature-badge {
	position: absolute;
	top: -10px;
	left: 18px;
	background: var(--ld-orange);
	color: #fff;
	font-size: 0.66rem;
	font-weight: 800;
	letter-spacing: 0.06em;
	text-transform: uppercase;
	padding: 4px 10px;
	border-radius: 999px;
	box-shadow: 0 4px 10px rgba(210, 104, 61, 0.3);
}
.feature-card-featured .feature-icon {
	background: linear-gradient(135deg, #fbbf24, var(--ld-orange));
}
.feature-cta {
	margin-top: 4px;
	font-size: 0.85rem;
	font-weight: 800;
	color: var(--ld-orange-dark);
	text-decoration: none;
	transition: color 0.15s, transform 0.15s;
	display: inline-flex;
	align-items: center;
	gap: 4px;
	align-self: flex-start;
}
.feature-cta:hover { color: var(--ld-orange); transform: translateX(3px); }
</style>

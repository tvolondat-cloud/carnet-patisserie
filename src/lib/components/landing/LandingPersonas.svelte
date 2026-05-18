<script>
// Cas d'usage type — ces profils sont des illustrations marketing,
// PAS des témoignages clients. Recadrage post-audit CRO pour ne
// pas tromper la perception de preuve sociale.
const profiles = [
	{
		emoji: '🎓',
		title: 'Si tu es étudiant CAP',
		subtitle: 'En alternance, en formation continue ou en candidat libre',
		bullets: [
			'Le Mode Labo reproduit la méthode des CFA : test, quiz, chrono',
			'Date d\'examen + countdown sur ton tableau de bord',
			'Carnet PDF imprimable pour réviser n\'importe où',
			'Vocabulaire technique conforme au référentiel 2024-2025'
		],
		cta: 'Voir le mode Labo',
		anchor: '#how'
	},
	{
		emoji: '🥐',
		title: 'Si tu es particulier passionné',
		subtitle: 'Sans école, mais avec l\'envie de progresser sérieusement',
		bullets: [
			'58 recettes incontournables, pédagogiques et détaillées',
			'Calculateur de rendement ×0.25 → ×10 en temps réel',
			'Notes et commentaires : ton journal de cuisine perso',
			'Mode cuisine grand format pour les mains farinées'
		],
		cta: 'Voir les recettes',
		anchor: '#features'
	}
];
</script>

<section class="ld-section ld-section-cream personas">
	<div class="ld-container">
		<div class="personas-header">
			<span class="ld-eyebrow">Pour qui ?</span>
			<h2 class="ld-h2">Que tu sois en CAP ou passionné</h2>
			<p class="ld-lead">
				Brigade Sucrée s'adapte à ton profil. L'app détecte ton niveau et personnalise
				le vocabulaire, les priorités et le contenu d'aide.
			</p>
		</div>

		<div class="ld-grid ld-grid-2">
			{#each profiles as p}
				<article class="persona-card ld-card">
					<div class="persona-header">
						<div class="persona-emoji" aria-hidden="true">{p.emoji}</div>
						<div>
							<h3 class="ld-h3">{p.title}</h3>
							<p class="persona-role">{p.subtitle}</p>
						</div>
					</div>
					<ul class="persona-bullets">
						{#each p.bullets as b}
							<li>{b}</li>
						{/each}
					</ul>
					<a href={p.anchor} class="persona-link" data-track="cta:persona-{p.emoji}">
						{p.cta} →
					</a>
				</article>
			{/each}
		</div>
	</div>
</section>

<style>
.personas-header {
	text-align: center;
	max-width: 640px;
	margin: 0 auto 56px;
}
.personas-header .ld-lead { margin-left: auto; margin-right: auto; }

.persona-card { padding: 32px; }

.persona-header {
	display: flex;
	align-items: center;
	gap: 16px;
	margin-bottom: 20px;
}

.persona-emoji {
	width: 56px;
	height: 56px;
	border-radius: 14px;
	background: linear-gradient(135deg, var(--ld-cream-dark), var(--ld-cream));
	display: grid;
	place-items: center;
	font-size: 2rem;
	flex-shrink: 0;
}

.persona-role {
	color: var(--ld-text-muted);
	font-size: 0.85rem;
	margin: 4px 0 0;
}

.persona-bullets {
	list-style: none;
	padding: 0;
	margin: 0 0 20px;
	display: flex;
	flex-direction: column;
	gap: 10px;
}
.persona-bullets li {
	font-size: 0.92rem;
	color: var(--ld-text);
	padding-left: 26px;
	position: relative;
	line-height: 1.5;
}
.persona-bullets li::before {
	content: '✓';
	position: absolute;
	left: 0;
	top: 1px;
	color: var(--ld-orange);
	font-weight: 800;
	font-size: 1rem;
}

.persona-link {
	color: var(--ld-orange);
	font-weight: 700;
	text-decoration: none;
	font-size: 0.9rem;
	transition: gap 0.15s;
}
.persona-link:hover { color: var(--ld-orange-dark); }
</style>

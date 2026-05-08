<script>
const personas = [
	{
		emoji: '🎓',
		name: 'Léa, 19 ans',
		role: 'Étudiante CAP Pâtissier en alternance',
		quote: 'Je révisais mes recettes sur des post-it dans la cuisine. Avec Brigade Sucrée, j\'ai mon labo dans la poche, je m\'auto-évalue avec les quiz et je vois si je suis dans les temps.',
		highlights: ['Mode Labo', 'Date d\'examen + countdown', 'Carnet PDF en cours']
	},
	{
		emoji: '🥐',
		name: 'Sophie, 42 ans',
		role: 'Particulière passionnée',
		quote: 'J\'ai pas fait d\'école, mais je veux progresser sérieusement. Le calculateur de rendement, les fiches détaillées et le suivi par compétence m\'ont changé la vie.',
		highlights: ['Calculateur ×0.25 → ×10', 'Notes & commentaires', 'Mode cuisine grand format']
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
			{#each personas as p}
				<article class="persona-card ld-card">
					<div class="persona-header">
						<div class="persona-emoji" aria-hidden="true">{p.emoji}</div>
						<div>
							<h3 class="ld-h3">{p.name}</h3>
							<p class="persona-role">{p.role}</p>
						</div>
					</div>
					<blockquote class="persona-quote">
						<span class="quote-mark" aria-hidden="true">"</span>
						{p.quote}
					</blockquote>
					<div class="persona-highlights">
						{#each p.highlights as h}
							<span class="highlight-tag">{h}</span>
						{/each}
					</div>
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

.persona-quote {
	position: relative;
	font-style: italic;
	color: var(--ld-text);
	margin: 0 0 20px;
	padding-left: 24px;
	font-size: 1rem;
	line-height: 1.6;
	border-left: 3px solid var(--ld-orange);
}

.quote-mark {
	color: var(--ld-orange);
	font-size: 1.4rem;
	font-weight: 900;
	margin-right: 4px;
}

.persona-highlights {
	display: flex;
	gap: 8px;
	flex-wrap: wrap;
}

.highlight-tag {
	background: rgba(31, 77, 69, 0.08);
	color: var(--ld-deep);
	padding: 6px 12px;
	border-radius: 20px;
	font-size: 0.78rem;
	font-weight: 600;
}
</style>

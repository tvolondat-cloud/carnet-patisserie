<script>
const steps = [
	{
		num: '01',
		title: 'Choisis ta recette',
		desc: 'Parmi les 58 du référentiel CAP, ou crée la tienne. Filtre par catégorie, EP, statut, compétence.',
		img: '/perso-recette.png'
	},
	{
		num: '02',
		title: 'Lance le mode Labo',
		desc: 'Tester en cuisine, valider le quiz, chronométrer. La méthode CFA, en 3 étapes guidées.',
		img: '/perso-cuisine.png'
	},
	{
		num: '03',
		title: 'Maîtrise et progresse',
		desc: 'Statut "maîtrisée" débloqué quand les 3 étapes passent. Suivi par compétence CAP.',
		img: '/perso-celebration.png'
	}
];
</script>

<section class="ld-section how" id="how">
	<div class="ld-container">
		<div class="how-header">
			<span class="ld-eyebrow">Comment ça marche</span>
			<h2 class="ld-h2">3 étapes pour maîtriser une recette</h2>
		</div>

		<div class="how-grid">
			{#each steps as step, i}
				<div class="step-card">
					<div class="step-visual">
						<img src={step.img} alt="" class="step-img" loading="lazy" width="140" height="140" />
					</div>
					<div class="step-num" aria-hidden="true">{step.num}</div>
					<h3 class="ld-h3">{step.title}</h3>
					<p>{step.desc}</p>
				</div>
				{#if i < steps.length - 1}
					<div class="step-arrow" aria-hidden="true">→</div>
				{/if}
			{/each}
		</div>

		<div class="how-cta">
			<a href="/auth" class="ld-btn ld-btn-primary ld-btn-large" data-track="cta:how-signup">
				Tester gratuitement →
			</a>
		</div>
	</div>
</section>

<style>
.how-header {
	text-align: center;
	max-width: 640px;
	margin: 0 auto 56px;
}

.how-grid {
	display: grid;
	grid-template-columns: 1fr auto 1fr auto 1fr;
	gap: 16px;
	align-items: start;
}

.step-card {
	background: var(--ld-white);
	padding: 32px 24px;
	border-radius: 20px;
	text-align: center;
	border: 1px solid rgba(31, 77, 69, 0.06);
	box-shadow: 0 4px 14px rgba(31, 77, 69, 0.05);
	position: relative;
}

.step-visual {
	display: grid;
	place-items: center;
	margin-bottom: 16px;
	background: linear-gradient(135deg, var(--ld-cream-light), var(--ld-cream));
	border-radius: 16px;
	padding: 16px;
}
.step-img {
	width: 140px;
	height: 140px;
	object-fit: contain;
	display: block;
}

.step-num {
	color: var(--ld-orange);
	font-weight: 900;
	font-size: 0.95rem;
	letter-spacing: 0.1em;
	margin-bottom: 8px;
}

.step-card p {
	color: var(--ld-text-muted);
	font-size: 0.92rem;
	margin: 0;
	line-height: 1.55;
}

.step-arrow {
	font-size: 2rem;
	color: var(--ld-orange);
	font-weight: 800;
	display: grid;
	place-items: center;
	height: 100%;
	padding-top: 100px;
}

.how-cta {
	margin-top: 56px;
	text-align: center;
}

@media (max-width: 920px) {
	.how-grid { grid-template-columns: 1fr; }
	.step-arrow { transform: rotate(90deg); padding-top: 0; }
}
</style>

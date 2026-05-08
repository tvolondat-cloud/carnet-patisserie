<script>
const plans = [
	{
		name: 'Free',
		price: '0',
		period: 'pendant la bêta',
		desc: 'Tout est gratuit pendant le lancement.',
		features: [
			'Les 17 recettes du référentiel',
			'Mode Laboratoire complet',
			'Suivi de progression',
			'Carnet PDF illimité',
			'Cours EP1 / EP2',
			'Calculateur de rendement'
		],
		cta: 'Commencer maintenant',
		highlighted: true
	},
	{
		name: 'Pro',
		price: '4,99',
		period: '/mois',
		desc: 'À partir de la sortie officielle (Sprint 3).',
		features: [
			'Tout le plan Free',
			'Recettes personnelles illimitées',
			'Photos de réalisations',
			'Partage de fiches publiques',
			'Mode cuisine grand format',
			'Streak hebdo + email digest'
		],
		cta: 'Notifier au lancement',
		highlighted: false,
		soon: true
	}
];
</script>

<section class="ld-section ld-section-white pricing" id="pricing">
	<div class="ld-container">
		<div class="pricing-header">
			<span class="ld-eyebrow">Tarifs</span>
			<h2 class="ld-h2">Simple, transparent, beta gratuite</h2>
			<p class="ld-lead">
				On lance Brigade Sucrée en bêta gratuite jusqu'au lancement officiel
				du plan Pro (Sprint 3, été 2026). Inscris-toi maintenant pour bloquer
				l'accès gratuit à toutes les fonctionnalités.
			</p>
			<div class="pricing-banner">
				<span class="banner-icon" aria-hidden="true">🚀</span>
				<span><strong>Offre bêta de lancement</strong> — Tous les inscrits avant le passage en Pro gardent leur accès gratuit aux fonctionnalités actuelles.</span>
			</div>
		</div>

		<div class="ld-grid ld-grid-2 pricing-grid">
			{#each plans as plan}
				<article class="plan-card" class:highlighted={plan.highlighted}>
					{#if plan.highlighted}
						<span class="plan-badge">Recommandé</span>
					{/if}
					{#if plan.soon}
						<span class="plan-badge plan-badge-soon">Bientôt</span>
					{/if}

					<div class="plan-header">
						<h3 class="plan-name">{plan.name}</h3>
						<div class="plan-price">
							<span class="price-amount">{plan.price}€</span>
							<span class="price-period">{plan.period}</span>
						</div>
						<p class="plan-desc">{plan.desc}</p>
					</div>

					<ul class="plan-features">
						{#each plan.features as f}
							<li>
								<span class="check" aria-hidden="true">✓</span>
								<span>{f}</span>
							</li>
						{/each}
					</ul>

					<a
						href="/auth"
						class="ld-btn {plan.highlighted ? 'ld-btn-primary' : 'ld-btn-secondary'} ld-btn-large plan-cta"
						data-track="cta:pricing-{plan.name.toLowerCase()}"
					>
						{plan.cta}
					</a>
				</article>
			{/each}
		</div>

		<p class="pricing-foot">
			🔒 Aucune carte bancaire requise pour la bêta · Tu peux annuler à tout moment plus tard.
		</p>
	</div>
</section>

<style>
.pricing-header {
	text-align: center;
	max-width: 720px;
	margin: 0 auto 48px;
}
.pricing-header .ld-lead { margin-left: auto; margin-right: auto; }

.pricing-banner {
	display: inline-flex;
	align-items: center;
	gap: 12px;
	background: linear-gradient(135deg, rgba(232, 152, 85, 0.16), rgba(210, 104, 61, 0.08));
	border: 1.5px solid var(--ld-orange);
	border-radius: 14px;
	padding: 14px 22px;
	margin-top: 20px;
	font-size: 0.9rem;
	color: var(--ld-deep);
	text-align: left;
	max-width: 620px;
}
.pricing-banner .banner-icon { font-size: 1.4rem; flex-shrink: 0; }
.pricing-banner strong { color: var(--ld-orange-dark); }

.pricing-grid { max-width: 880px; margin: 0 auto; }

.plan-card {
	position: relative;
	background: var(--ld-white);
	border-radius: 20px;
	padding: 40px 32px;
	border: 2px solid var(--ld-cream-dark);
	display: flex;
	flex-direction: column;
}

.plan-card.highlighted {
	border-color: var(--ld-orange);
	background: linear-gradient(180deg, var(--ld-white), rgba(232, 152, 85, 0.04));
	box-shadow: 0 20px 50px rgba(210, 104, 61, 0.15);
	transform: scale(1.02);
}

.plan-badge {
	position: absolute;
	top: 16px;
	right: 16px;
	background: var(--ld-orange);
	color: var(--ld-white);
	padding: 4px 12px;
	border-radius: 20px;
	font-size: 0.72rem;
	font-weight: 700;
	letter-spacing: 0.04em;
}
.plan-badge-soon {
	background: var(--ld-deep);
}

.plan-header { margin-bottom: 24px; }

.plan-name {
	font-size: 1.4rem;
	font-weight: 800;
	color: var(--ld-deep);
	margin: 0 0 12px;
}

.plan-price {
	display: flex;
	align-items: baseline;
	gap: 6px;
	margin-bottom: 8px;
}

.price-amount {
	font-size: 3rem;
	font-weight: 900;
	color: var(--ld-deep);
	line-height: 1;
	letter-spacing: -0.02em;
}

.price-period {
	color: var(--ld-text-muted);
	font-size: 0.9rem;
}

.plan-desc {
	color: var(--ld-text-muted);
	font-size: 0.9rem;
	margin: 0;
}

.plan-features {
	list-style: none;
	padding: 0;
	margin: 0 0 28px;
	display: flex;
	flex-direction: column;
	gap: 10px;
	flex: 1;
}

.plan-features li {
	display: flex;
	align-items: flex-start;
	gap: 10px;
	font-size: 0.92rem;
	color: var(--ld-text);
}

.check {
	color: var(--ld-orange);
	font-weight: 800;
	flex-shrink: 0;
}

.plan-cta { width: 100%; }

.pricing-foot {
	text-align: center;
	margin-top: 32px;
	color: var(--ld-text-muted);
	font-size: 0.88rem;
}

@media (max-width: 768px) {
	.plan-card.highlighted { transform: none; }
	.plan-card { padding: 32px 24px; }
}
</style>

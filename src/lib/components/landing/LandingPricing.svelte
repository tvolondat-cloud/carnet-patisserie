<script>
const FREE_FEATURES = [
	{ text: '10 recettes CAP (crèmes, pâtes, bases)', icon: '📖' },
	{ text: 'Mode Laboratoire complet (quiz + chrono)', icon: '🧪' },
	{ text: 'Suivi de progression', icon: '📊' },
	{ text: 'Cours EP1 / EP2', icon: '📋' },
	{ text: 'Calculateur de rendement', icon: '⚖️' },
];

const PRO_FEATURES = [
	{ text: 'Tout le plan Gratuit', icon: '✓', base: true },
	{ text: '58 recettes CAP complètes', icon: '🎯', highlight: true },
	{ text: 'Carnet PDF imprimable (Berry Jam)', icon: '📄', highlight: true },
	{ text: '50 fiches de révision CAP', icon: '📚', highlight: true },
	{ text: '60 QCM examen blanc par thème (note /20)', icon: '🎓', highlight: true },
	{ text: 'Notes & commentaires illimitées', icon: '✏️' },
	{ text: 'Mode Labo sur toutes les recettes', icon: '⭐' },
];
</script>

<section class="ld-section ld-section-white pricing" id="pricing">
	<div class="ld-container">
		<div class="pricing-header">
			<span class="ld-eyebrow">Tarifs</span>
			<h2 class="ld-h2">Simple et transparent</h2>
			<p class="ld-lead">
				Commence gratuitement avec les 10 recettes fondamentales.
				Débloque les 58 recettes CAP complètes, le carnet PDF et toutes les fiches de révision avec le plan Pro.
			</p>
		</div>

		<div class="pricing-grid">

			<!-- Plan Gratuit -->
			<article class="plan-card">
				<div class="plan-header">
					<h3 class="plan-name">Gratuit</h3>
					<div class="plan-price">
						<span class="price-amount">0€</span>
						<span class="price-period">pour toujours</span>
					</div>
					<p class="plan-desc">Les bases pour commencer à s'entraîner.</p>
				</div>

				<ul class="plan-features">
					{#each FREE_FEATURES as f}
					<li>
						<span class="feat-icon" aria-hidden="true">{f.icon}</span>
						<span>{f.text}</span>
					</li>
					{/each}
				</ul>

				<a href="/auth" class="ld-btn ld-btn-secondary ld-btn-large plan-cta" data-track="cta:pricing-free">
					Commencer gratuitement
				</a>
			</article>

			<!-- Plan Pro -->
			<article class="plan-card plan-card-pro">
				<span class="plan-badge">Recommandé</span>

				<div class="plan-header">
					<h3 class="plan-name">Pro</h3>
					<div class="plan-price">
						<span class="price-amount">4,99€</span>
						<span class="price-period">/mois</span>
					</div>
					<div class="plan-annual">ou <strong>39€/an</strong> <span class="annual-save">−35%</span></div>
					<p class="plan-desc">Le référentiel CAP complet dans ta poche.</p>
				</div>

				<ul class="plan-features">
					{#each PRO_FEATURES as f}
					<li class:highlight={f.highlight}>
						<span class="feat-icon" aria-hidden="true">{f.icon}</span>
						<span>{f.text}</span>
					</li>
					{/each}
				</ul>

				<a href="/auth" class="ld-btn ld-btn-primary ld-btn-large plan-cta" data-track="cta:pricing-pro">
					Commencer gratuitement →
				</a>
				<p class="plan-note">Plan Pro <strong>bientôt disponible</strong> — démarre dès maintenant avec le gratuit.</p>
			</article>

		</div>

		<!-- Tableau comparatif condensé -->
		<div class="compare-table">
			<h3 class="compare-title">Ce qui change avec Pro</h3>
			<div class="compare-rows">
				<div class="compare-row compare-row-head">
					<span></span>
					<span class="compare-col-label">Gratuit</span>
					<span class="compare-col-label compare-col-pro">Pro</span>
				</div>
				{#each [
					['Recettes accessibles', '10', '58'],
					['Mode Laboratoire', '✓', '✓'],
					['Carnet PDF imprimable', '✗', '✓'],
					['Fiches de révision', '✗', '50 fiches'],
					['Examen blanc QCM', '✗', '60 QCM · /20'],
					['Suivi & statistiques', '✓', '✓'],
				] as [label, free, pro]}
				<div class="compare-row">
					<span class="compare-label">{label}</span>
					<span class="compare-val" class:val-no={free === '✗'}>{free}</span>
					<span class="compare-val compare-val-pro" class:val-no={pro === '✗'}>{pro}</span>
				</div>
				{/each}
			</div>
		</div>

		<p class="pricing-foot">
			Pendant la bêta : 10 recettes gratuites, sans carte bancaire. Le plan Pro (paiement sécurisé) arrive bientôt.
		</p>
	</div>
</section>

<style>
.pricing-header {
	text-align: center;
	max-width: 680px;
	margin: 0 auto 48px;
}
.pricing-header .ld-lead { margin-left: auto; margin-right: auto; }

/* ── Grid ── */
.pricing-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 24px;
	max-width: 860px;
	margin: 0 auto 48px;
	align-items: start;
}

/* ── Cards ── */
.plan-card {
	position: relative;
	background: var(--ld-white);
	border-radius: 20px;
	padding: 36px 28px 28px;
	border: 2px solid var(--ld-cream-dark);
	display: flex;
	flex-direction: column;
}
.plan-card-pro {
	border-color: var(--ld-orange);
	background: linear-gradient(180deg, var(--ld-white), rgba(232, 152, 85, 0.04));
	box-shadow: 0 20px 50px rgba(210, 104, 61, 0.14);
}

.plan-badge {
	position: absolute;
	top: -14px;
	left: 50%;
	transform: translateX(-50%);
	background: var(--ld-orange);
	color: var(--ld-white);
	padding: 5px 18px;
	border-radius: 20px;
	font-size: 0.72rem;
	font-weight: 700;
	letter-spacing: 0.04em;
	white-space: nowrap;
}

.plan-header { margin-bottom: 20px; }
.plan-name {
	font-size: 1.3rem;
	font-weight: 800;
	color: var(--ld-deep);
	margin: 0 0 10px;
}
.plan-price {
	display: flex;
	align-items: baseline;
	gap: 6px;
	margin-bottom: 4px;
}
.price-amount {
	font-size: 2.8rem;
	font-weight: 900;
	color: var(--ld-deep);
	line-height: 1;
	letter-spacing: -0.02em;
}
.price-period { color: var(--ld-text-muted); font-size: 0.9rem; }

.plan-annual {
	font-size: 0.82rem;
	color: var(--ld-text-muted);
	margin-bottom: 8px;
}
.annual-save {
	background: rgba(16, 185, 129, 0.12);
	color: #059669;
	font-weight: 700;
	padding: 1px 6px;
	border-radius: 6px;
	font-size: 0.75rem;
}
.plan-desc { color: var(--ld-text-muted); font-size: 0.88rem; margin: 0; }

/* ── Features ── */
.plan-features {
	list-style: none;
	padding: 0;
	margin: 0 0 24px;
	display: flex;
	flex-direction: column;
	gap: 9px;
	flex: 1;
}
.plan-features li {
	display: flex;
	align-items: flex-start;
	gap: 8px;
	font-size: 0.88rem;
	color: var(--ld-text);
	line-height: 1.4;
}
.plan-features li.highlight {
	font-weight: 600;
	color: var(--ld-deep);
}
.feat-icon { flex-shrink: 0; font-size: 0.95rem; margin-top: 1px; }

.plan-cta { width: 100%; text-align: center; }
.plan-note {
	text-align: center;
	font-size: 0.76rem;
	color: var(--ld-text-muted);
	margin: 8px 0 0;
}

/* ── Compare table ── */
.compare-table {
	max-width: 680px;
	margin: 0 auto 24px;
	background: var(--ld-cream);
	border-radius: 16px;
	padding: 24px 28px;
}
.compare-title {
	font-size: 1rem;
	font-weight: 700;
	color: var(--ld-deep);
	margin: 0 0 16px;
	text-align: center;
}
.compare-rows { display: flex; flex-direction: column; gap: 0; }
.compare-row {
	display: grid;
	grid-template-columns: 1fr 80px 80px;
	align-items: center;
	padding: 9px 0;
	border-bottom: 1px solid rgba(31, 77, 69, 0.07);
	font-size: 0.85rem;
}
.compare-row:last-child { border-bottom: none; }
.compare-row-head {
	font-weight: 700;
	font-size: 0.78rem;
	color: var(--ld-text-muted);
	text-transform: uppercase;
	letter-spacing: 0.04em;
	padding-bottom: 12px;
}
.compare-col-label { text-align: center; }
.compare-col-pro { color: var(--ld-orange); }
.compare-label { color: var(--ld-text); }
.compare-val { text-align: center; font-weight: 500; color: var(--ld-deep); }
.compare-val-pro { color: var(--ld-orange); font-weight: 700; }
.val-no { color: var(--ld-text-muted) !important; font-weight: 400; }

.pricing-foot {
	text-align: center;
	color: var(--ld-text-muted);
	font-size: 0.84rem;
}

@media (max-width: 720px) {
	.pricing-grid { grid-template-columns: 1fr; }
	.plan-card { padding: 32px 20px 24px; }
	.compare-table { padding: 18px 16px; }
}
</style>

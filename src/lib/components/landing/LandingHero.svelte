<script>
// Recette vitrine = données canoniques de la pâte à choux (recipes.json).
// Hardcodé volontairement : on n'importe pas les 58 recettes dans le
// bundle critique de la landing (prérendu).
const ingredients = [
	{ n: 'Eau', q: 125, u: 'g' },
	{ n: 'Lait entier', q: 125, u: 'g' },
	{ n: 'Beurre', q: 100, u: 'g' },
	{ n: 'Farine T55', q: 150, u: 'g' },
	{ n: 'Œufs entiers', q: 5, u: 'u' },
	{ n: 'Sel', q: 4, u: 'g' },
	{ n: 'Sucre', q: 5, u: 'g' }
];
const steps = [
	'Porter à ébullition eau, lait, beurre, sel et sucre.',
	'Hors du feu, ajouter la farine d’un coup, mélanger.',
	'Dessécher la panade jusqu’au décollement des parois.'
];

// Calculateur de rendement (comme dans l'app : ×0.25 → ×10)
const presets = [0.5, 1, 2, 3];
let mult = 1;
function fmt(q, m) {
	const v = Math.round(q * m * 10) / 10;
	return Number.isInteger(v) ? String(v) : String(v).replace('.', ',');
}
// Réactif : recalculé à chaque changement de `mult` (une fonction appelée
// dans le template ne serait pas re-évaluée toute seule par Svelte).
$: rows = ingredients.map((ing) => ({ n: ing.n, u: ing.u, d: fmt(ing.q, mult) }));

// Étapes dépliables — repliées par défaut pour garder la carte compacte
// (toute la hero, CTA compris, doit tenir sans scroll).
let stepsOpen = false;
</script>

<section class="hero">
	<div class="ld-container hero-grid">
		<div class="hero-intro">
			<span class="ld-eyebrow">🍪 L'app des passionnés de pâtisserie</span>
			<h1 class="ld-h1">
				Réussis ton CAP Pâtissier<br />
				<span class="accent">sans stress.</span>
			</h1>
			<p class="ld-lead">
				La méthode CFA dans ta poche : <strong>58 recettes CAP Pâtissier</strong>,
				mode laboratoire avec quiz et chrono, fiches de révision, examen blanc.
				Pour étudiants CAP <strong>et</strong> particuliers passionnés.
			</p>
		</div>

		<div class="hero-visual">
			<div class="hero-glow" aria-hidden="true"></div>

			<!-- Aperçu réel de l'app : la fiche recette telle qu'on l'a dedans -->
			<article class="recipe-preview" aria-label="Aperçu d'une recette dans l'application : Pâte à choux">
				<header class="rp-head">
					<div class="rp-title-row">
						<span class="rp-emoji" aria-hidden="true">🍮</span>
						<h2 class="rp-title">Pâte à choux</h2>
					</div>
					<div class="rp-meta">
						<span class="rp-tag rp-ep">EP1</span>
						<span class="rp-dot">·</span>
						<span class="rp-time">⏱ 35 min</span>
						<span class="rp-diff" aria-label="Difficulté 3 sur 5">
							{#each Array(5) as _, i}
								<i class:on={i < 3}></i>
							{/each}
						</span>
					</div>
				</header>

				<div class="rp-calc">
					<span class="rp-label">Calculateur de rendement</span>
					<div class="rp-calc-ctrl" role="group" aria-label="Multiplicateur de quantités">
						{#each presets as p}
						<button
							type="button"
							class="rp-mult"
							class:on={mult === p}
							aria-pressed={mult === p}
							on:click={() => (mult = p)}
						>×{String(p).replace('.', ',')}</button>
						{/each}
					</div>
				</div>

				<div class="rp-section">
					<span class="rp-label">Ingrédients</span>
					<ul class="rp-ings">
						{#each rows as ing, i}
						<li class:rp-extra={i >= 5}>
							<span>{ing.n}</span><span class="rp-q">{ing.d} {ing.u}</span>
						</li>
						{/each}
					</ul>
				</div>

				<div class="rp-section rp-steps-sec">
					<button
						type="button"
						class="rp-steps-toggle"
						aria-expanded={stepsOpen}
						on:click={() => (stepsOpen = !stepsOpen)}
					>
						<span class="rp-label">Étapes ({steps.length})</span>
						<span class="rp-chev" class:open={stepsOpen} aria-hidden="true">⌄</span>
					</button>
					{#if stepsOpen}
					<ol class="rp-steps">
						{#each steps as s, i}
						<li><span class="rp-num">{i + 1}</span>{s}</li>
						{/each}
					</ol>
					{/if}
				</div>

				<div class="rp-foot">
					<span class="rp-labo">🧪 Mode Labo</span>
					<span class="rp-labo-steps">Test · Quiz 75% · Chrono</span>
				</div>
			</article>
		</div>

		<div class="hero-actions">
			<div class="hero-cta">
				<a href="/auth" class="ld-btn ld-btn-primary ld-btn-large" data-track="cta:hero-signup">
					Commencer gratuitement →
				</a>
				<a href="#pricing" class="ld-btn ld-btn-secondary ld-btn-large" data-track="cta:hero-pricing">
					Voir les formules
				</a>
			</div>

			<p class="hero-reassurance">
				⏱️ <strong>30 secondes</strong> pour t'inscrire · 10 recettes gratuites ·
				Pas de carte bancaire requise
			</p>

			<div class="hero-trust">
				<div class="trust-stars" aria-hidden="true">
					<span>⭐</span><span>⭐</span><span>⭐</span><span>⭐</span><span>⭐</span>
				</div>
				<span class="trust-text">Référentiel CAP officiel 2025-2026 · Mode labo complet</span>
			</div>
		</div>
	</div>
</section>

<style>
.hero {
	position: relative;
	padding: 22px 0 36px;
	overflow: hidden;
}

.hero::before {
	content: '';
	position: absolute;
	top: -100px;
	right: -100px;
	width: 500px;
	height: 500px;
	background: radial-gradient(circle, rgba(232, 152, 85, 0.18), transparent 70%);
	pointer-events: none;
}

/* Desktop : 2 colonnes — intro + actions à gauche, visuel à droite */
.hero-grid {
	display: grid;
	grid-template-columns: 1.1fr 1fr;
	grid-template-areas:
		"intro  visual"
		"actions visual";
	column-gap: 60px;
	row-gap: 12px;
	align-items: start;
}
.hero-intro { grid-area: intro; max-width: 580px; }
.hero-visual { grid-area: visual; align-self: center; }
.hero-actions { grid-area: actions; max-width: 580px; }

/* Rythme vertical resserré : tout doit tenir une fois la barre
   d'onglets + d'adresse du navigateur déduite de la hauteur visible. */
.hero-intro .ld-eyebrow { margin-bottom: 14px; }
.hero-intro .ld-h1 {
	font-size: clamp(1.8rem, 3.4vw, 2.6rem);
	line-height: 1.06;
	margin: 0 0 14px;
}
.hero-intro .ld-lead {
	font-size: clamp(0.96rem, 1.5vw, 1.06rem);
	line-height: 1.5;
	margin: 0;
}

.hero-cta {
	display: flex;
	gap: 12px;
	margin-bottom: 12px;
	flex-wrap: wrap;
}

.hero-reassurance {
	margin: 0 0 12px;
	font-size: 0.85rem;
	color: var(--ld-text-muted);
	line-height: 1.5;
}
.hero-reassurance strong { color: var(--ld-deep); }

.hero-trust {
	display: flex;
	align-items: center;
	gap: 12px;
	color: var(--ld-text-muted);
	font-size: 0.88rem;
}
.trust-stars { display: flex; gap: 1px; font-size: 0.95rem; }
.trust-text { line-height: 1.4; }

.hero-visual {
	position: relative;
	display: grid;
	place-items: center;
}

.hero-glow {
	position: absolute;
	inset: 6% 6%;
	background: radial-gradient(circle, rgba(168, 109, 61, 0.22), transparent 70%);
	filter: blur(40px);
	pointer-events: none;
}

/* ── Fiche recette (aperçu réel de l'app) ─────────────────────── */
.recipe-preview {
	position: relative;
	width: 100%;
	max-width: 360px;
	background: var(--ld-white);
	border-radius: 20px;
	padding: 18px 20px 0;
	box-shadow:
		0 24px 60px rgba(31, 77, 69, 0.16),
		0 2px 6px rgba(31, 77, 69, 0.06);
	border: 1px solid rgba(31, 77, 69, 0.06);
	overflow: hidden;
	animation: rp-rise 0.7s cubic-bezier(0.16, 1, 0.3, 1) backwards;
}
.recipe-preview::before {
	content: '';
	position: absolute;
	inset: 0 0 auto;
	height: 5px;
	background: linear-gradient(90deg, var(--ld-orange), var(--ld-orange-light));
}

.rp-title-row { display: flex; align-items: center; gap: 10px; }
.rp-emoji {
	display: grid;
	place-items: center;
	width: 34px;
	height: 34px;
	border-radius: 50%;
	background: rgba(210, 104, 61, 0.12);
	font-size: 1.05rem;
	flex-shrink: 0;
}
.rp-title {
	font-size: 1.1rem;
	font-weight: 800;
	color: var(--ld-deep);
	margin: 0;
	line-height: 1.1;
}
.rp-meta {
	display: flex;
	align-items: center;
	gap: 8px;
	margin: 9px 0 10px;
	font-size: 0.78rem;
	color: var(--ld-text-muted);
}
.rp-tag {
	font-size: 0.7rem;
	font-weight: 800;
	letter-spacing: 0.03em;
	padding: 2px 8px;
	border-radius: 999px;
	background: rgba(31, 77, 69, 0.1);
	color: var(--ld-deep);
}
.rp-dot { opacity: 0.4; }
.rp-time { font-weight: 600; }
.rp-diff { display: inline-flex; gap: 3px; margin-left: auto; }
.rp-diff i {
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: rgba(31, 77, 69, 0.15);
}
.rp-diff i.on { background: var(--ld-orange); }

/* Calculateur de rendement */
.rp-calc {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 10px;
	padding: 8px 10px;
	margin-bottom: 10px;
	background: rgba(210, 104, 61, 0.06);
	border: 1px solid rgba(210, 104, 61, 0.16);
	border-radius: 12px;
}
.rp-calc-ctrl { display: flex; gap: 5px; }
.rp-mult {
	min-width: 34px;
	padding: 5px 8px;
	font-size: 0.78rem;
	font-weight: 800;
	color: var(--ld-text-muted);
	background: var(--ld-white);
	border: 1.5px solid rgba(31, 77, 69, 0.12);
	border-radius: 8px;
	cursor: pointer;
	transition: all 0.15s;
	font-variant-numeric: tabular-nums;
}
.rp-mult:hover { border-color: var(--ld-orange); color: var(--ld-orange-dark); }
.rp-mult.on {
	background: var(--ld-orange);
	border-color: var(--ld-orange);
	color: #fff;
}

.rp-section { margin-bottom: 10px; }
.rp-label {
	display: block;
	font-size: 0.64rem;
	font-weight: 800;
	letter-spacing: 0.12em;
	text-transform: uppercase;
	color: var(--ld-orange);
	margin-bottom: 6px;
}

.rp-ings {
	list-style: none;
	margin: 0;
	padding: 0;
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 4px 16px;
}
.rp-ings li {
	display: flex;
	justify-content: space-between;
	gap: 8px;
	font-size: 0.8rem;
	color: var(--ld-text);
	border-bottom: 1px dashed rgba(31, 77, 69, 0.1);
	padding-bottom: 3px;
}
.rp-q {
	color: var(--ld-text-muted);
	font-variant-numeric: tabular-nums;
	white-space: nowrap;
}

/* Étapes dépliables */
.rp-steps-toggle {
	display: flex;
	align-items: center;
	justify-content: space-between;
	width: 100%;
	background: none;
	border: none;
	padding: 0;
	cursor: pointer;
}
.rp-steps-toggle .rp-label { margin-bottom: 0; }
.rp-chev {
	color: var(--ld-orange);
	font-size: 1rem;
	line-height: 0;
	transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.rp-chev.open { transform: rotate(180deg); }
.rp-steps {
	list-style: none;
	margin: 10px 0 0;
	padding: 0;
	display: flex;
	flex-direction: column;
	gap: 8px;
	animation: rp-unfold 0.25s ease;
}
.rp-steps li {
	display: flex;
	gap: 9px;
	font-size: 0.82rem;
	line-height: 1.4;
	color: var(--ld-text);
}
.rp-num {
	flex-shrink: 0;
	width: 19px;
	height: 19px;
	border-radius: 50%;
	background: var(--ld-deep);
	color: #fff;
	font-size: 0.68rem;
	font-weight: 800;
	display: grid;
	place-items: center;
	margin-top: 1px;
}

.rp-foot {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 10px;
	margin: 2px -20px 0;
	padding: 11px 20px;
	background: linear-gradient(180deg, transparent, rgba(210, 104, 61, 0.06));
	border-top: 1px solid rgba(31, 77, 69, 0.07);
}
.rp-labo {
	font-weight: 800;
	font-size: 0.9rem;
	color: var(--ld-orange-dark);
}
.rp-labo-steps { font-size: 0.74rem; color: var(--ld-text-muted); }

@keyframes rp-rise {
	from { opacity: 0; transform: translateY(18px) scale(0.97); }
	to   { opacity: 1; transform: translateY(0) scale(1); }
}
@keyframes rp-unfold {
	from { opacity: 0; transform: translateY(-4px); }
	to   { opacity: 1; transform: translateY(0); }
}
@media (prefers-reduced-motion: reduce) {
	.recipe-preview,
	.rp-steps { animation: none; }
	.rp-chev { transition: none; }
}

/* ── Tablette / mobile : 1 colonne, ordre intro → recette → CTA ── */
@media (max-width: 920px) {
	.hero-grid {
		grid-template-columns: 1fr;
		grid-template-areas:
			"intro"
			"visual"
			"actions";
		row-gap: 20px;
	}
	.hero-intro,
	.hero-actions { max-width: 100%; }
	.recipe-preview { max-width: 420px; }
}

/* ── Mobile ───────────────────────────────────────────────────── */
@media (max-width: 520px) {
	.hero { padding: 16px 0 32px; }
	.hero-grid { row-gap: 18px; }
	.hero-cta { flex-direction: column; align-items: stretch; }
	.hero-cta .ld-btn { width: 100%; }

	.recipe-preview { max-width: 100%; padding: 18px 18px 0; border-radius: 18px; }
	.rp-title { font-size: 1.05rem; }
	/* 1 colonne d'ingrédients, on garde l'essentiel pour rester compact */
	.rp-ings { grid-template-columns: 1fr; gap: 4px; }
	.rp-ings .rp-extra { display: none; }     /* 5 ingrédients affichés */
	.rp-foot { margin: 2px -18px 0; padding: 11px 18px; }
}
</style>

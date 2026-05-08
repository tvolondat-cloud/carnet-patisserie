<script>
import Gingerbread from './Gingerbread.svelte';
</script>

<section class="hero">
	<div class="ld-container hero-grid">
		<div class="hero-text">
			<span class="ld-eyebrow">🍪 L'app des passionnés de pâtisserie</span>
			<h1 class="ld-h1">
				Réussis ton CAP Pâtissier<br />
				<span class="accent">sans stress.</span>
			</h1>
			<p class="ld-lead">
				La méthode CFA dans ta poche : <strong>17 recettes incontournables</strong>,
				mode laboratoire avec quiz et chrono, suivi de progression.
				Pour étudiants CAP <strong>et</strong> particuliers passionnés.
			</p>

			<div class="hero-cta">
				<a href="/auth" class="ld-btn ld-btn-primary ld-btn-large" data-track="cta:hero-signup">
					Commencer gratuitement →
				</a>
				<a href="#how" class="ld-btn ld-btn-secondary ld-btn-large" data-track="cta:hero-howto">
					Voir comment ça marche
				</a>
			</div>

			<div class="hero-trust">
				<div class="trust-stars" aria-hidden="true">
					<span>⭐</span><span>⭐</span><span>⭐</span><span>⭐</span><span>⭐</span>
				</div>
				<span class="trust-text">100% gratuit pendant la bêta · Aucune carte bancaire requise</span>
			</div>
		</div>

		<div class="hero-visual">
			<div class="hero-glow" aria-hidden="true"></div>
			<Gingerbread pose="celebrating" size={320} />
			<div class="hero-badge badge-quiz" aria-hidden="true">
				<span>📚</span>
				<div>
					<strong>Quiz</strong>
					<small>17 recettes</small>
				</div>
			</div>
			<div class="hero-badge badge-chrono" aria-hidden="true">
				<span>⏱️</span>
				<div>
					<strong>Chrono</strong>
					<small>×1.2 tolérance</small>
				</div>
			</div>
			<div class="hero-badge badge-pdf" aria-hidden="true">
				<span>📄</span>
				<div>
					<strong>Carnet PDF</strong>
					<small>Berry Jam</small>
				</div>
			</div>
		</div>
	</div>
</section>

<style>
.hero {
	position: relative;
	padding: 60px 0 100px;
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

.hero-grid {
	display: grid;
	grid-template-columns: 1.1fr 1fr;
	gap: 60px;
	align-items: center;
}

.hero-text { max-width: 580px; }
.hero-text .ld-h1 { margin-bottom: 24px; }

.hero-cta {
	display: flex;
	gap: 12px;
	margin-bottom: 32px;
	flex-wrap: wrap;
}

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
	min-height: 380px;
}

.hero-glow {
	position: absolute;
	inset: 10% 10%;
	background: radial-gradient(circle, rgba(168, 109, 61, 0.25), transparent 70%);
	filter: blur(40px);
	pointer-events: none;
}

.hero-badge {
	position: absolute;
	background: var(--ld-white);
	border-radius: 14px;
	padding: 12px 16px;
	box-shadow: 0 12px 28px rgba(31, 77, 69, 0.12);
	display: flex;
	align-items: center;
	gap: 10px;
	font-size: 0.84rem;
	border: 1px solid rgba(31, 77, 69, 0.05);
	animation: float 4s ease-in-out infinite;
}
.hero-badge span:first-child { font-size: 1.4rem; }
.hero-badge strong {
	display: block;
	color: var(--ld-deep);
	font-weight: 700;
	font-size: 0.92rem;
}
.hero-badge small { color: var(--ld-text-muted); font-size: 0.75rem; }

.badge-quiz {
	top: 8%;
	left: -8%;
	animation-delay: 0s;
}
.badge-chrono {
	top: 38%;
	right: -10%;
	animation-delay: 1.2s;
}
.badge-pdf {
	bottom: 12%;
	left: -4%;
	animation-delay: 2.4s;
}

@keyframes float {
	0%, 100% { transform: translateY(0); }
	50% { transform: translateY(-8px); }
}

@media (prefers-reduced-motion: reduce) {
	.hero-badge { animation: none; }
}

@media (max-width: 920px) {
	.hero-grid { grid-template-columns: 1fr; gap: 40px; }
	.hero-visual { order: -1; min-height: 280px; }
	.hero-badge {
		font-size: 0.76rem;
		padding: 8px 12px;
	}
	.hero-badge span:first-child { font-size: 1.1rem; }
	.badge-quiz { left: 0%; top: 0; }
	.badge-chrono { right: 0%; top: 50%; }
	.badge-pdf { left: 5%; bottom: 0; }
}

@media (max-width: 520px) {
	.hero { padding: 40px 0 60px; }
	.hero-cta { flex-direction: column; align-items: stretch; }
	.hero-cta .ld-btn { width: 100%; }
}
</style>

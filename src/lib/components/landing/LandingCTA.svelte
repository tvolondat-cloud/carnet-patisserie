<script>
import Gingerbread from './Gingerbread.svelte';
</script>

<section class="ld-section ld-section-deep cta">
	<div class="ld-container cta-grid">
		<div class="cta-text">
			<span class="ld-eyebrow">Le moment, c'est maintenant</span>
			<h2 class="ld-h2">Tu fais partie de la <span class="cta-accent">Brigade Sucrée</span>.</h2>
			<p class="ld-lead">
				Inscription en 30 secondes, sans carte bancaire. Tu démarres gratuitement avec
				10 recettes fondamentales et le Mode Labo complet. Passe au plan Pro quand tu veux
				pour débloquer les 58 recettes CAP.
			</p>

			<div class="cta-actions">
				<a href="/auth" class="ld-btn ld-btn-primary ld-btn-large" data-track="cta:final-signup">
					Rejoindre la Brigade →
				</a>
			</div>

			<div class="cta-stats">
				<div class="stat">
					<strong>17</strong>
					<span>recettes CAP prêtes</span>
				</div>
				<div class="stat">
					<strong>50</strong>
					<span>fiches référentiel</span>
				</div>
				<div class="stat">
					<strong>60</strong>
					<span>QCM examen blanc</span>
				</div>
			</div>
		</div>

		<div class="cta-visual">
			<Gingerbread pose="celebrating" size={260} />
		</div>
	</div>
</section>

<style>
.cta {
	position: relative;
	overflow: hidden;
}
.cta::before {
	content: '';
	position: absolute;
	top: -200px;
	right: -200px;
	width: 600px;
	height: 600px;
	background: radial-gradient(circle, rgba(232, 152, 85, 0.18), transparent 70%);
	pointer-events: none;
}
.cta::after {
	content: '';
	position: absolute;
	bottom: -150px;
	left: -150px;
	width: 400px;
	height: 400px;
	background: radial-gradient(circle, rgba(210, 104, 61, 0.12), transparent 70%);
	pointer-events: none;
}

.cta-grid {
	display: grid;
	grid-template-columns: 1.4fr 1fr;
	gap: 60px;
	align-items: center;
	position: relative;
	z-index: 1;
}

.cta-accent { color: var(--ld-orange-light); }

.cta-actions {
	display: flex;
	gap: 16px;
	margin-bottom: 40px;
}

.cta-stats {
	display: flex;
	gap: 32px;
	flex-wrap: wrap;
}

.stat {
	display: flex;
	flex-direction: column;
	gap: 4px;
}

.stat strong {
	font-size: 2.2rem;
	font-weight: 900;
	color: var(--ld-orange-light);
	line-height: 1;
}

.stat span {
	font-size: 0.82rem;
	color: rgba(244, 229, 210, 0.7);
}

.cta-visual {
	display: grid;
	place-items: center;
	background: rgba(244, 229, 210, 0.06);
	border-radius: 30px;
	padding: 30px;
	backdrop-filter: blur(10px);
	-webkit-backdrop-filter: blur(10px);
}

@media (max-width: 920px) {
	.cta-grid { grid-template-columns: 1fr; gap: 32px; text-align: center; }
	.cta-text .ld-lead { margin-left: auto; margin-right: auto; }
	.cta-actions { justify-content: center; }
	.cta-stats { justify-content: center; }
	.cta-visual { order: -1; }
}
</style>

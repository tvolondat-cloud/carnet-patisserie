<script>
const rows = [
	{ label: 'Conforme référentiel CAP officiel', bs: true, cfa: true, yt: false, books: 'partial' },
	{ label: 'Mode Laboratoire (test + quiz + chrono)', bs: true, cfa: 'partial', yt: false, books: false },
	{ label: 'Suivi de progression personnalisé', bs: true, cfa: 'partial', yt: false, books: false },
	{ label: 'Calculateur de rendement temps réel', bs: true, cfa: false, yt: false, books: false },
	{ label: 'Carnet PDF imprimable A4 classeur', bs: true, cfa: 'partial', yt: false, books: 'partial' },
	{ label: 'Disponible en cuisine sur mobile', bs: true, cfa: false, yt: 'partial', books: 'partial' },
	{ label: 'Marche hors-ligne (PWA)', bs: true, cfa: false, yt: false, books: true },
	{ label: 'Mise à jour continue', bs: true, cfa: 'partial', yt: 'partial', books: false },
	{ label: 'Coût mensuel', bs: '0€ bêta', cfa: '~50€', yt: '0€', books: '~30€/livre' }
];

function cell(v) {
	if (v === true) return { icon: '✓', class: 'yes' };
	if (v === false) return { icon: '✕', class: 'no' };
	if (v === 'partial') return { icon: '~', class: 'partial' };
	return { icon: v, class: 'text' };
}
</script>

<section class="ld-section ld-section-white comparison">
	<div class="ld-container">
		<div class="comparison-header">
			<span class="ld-eyebrow">Comparaison</span>
			<h2 class="ld-h2">Pourquoi Brigade Sucrée ?</h2>
			<p class="ld-lead">
				Tu peux apprendre la pâtisserie de plein de façons. Voici comment Brigade Sucrée
				se positionne face aux alternatives classiques.
			</p>
		</div>

		<div class="comparison-table-wrapper">
			<table class="comparison-table">
				<thead>
					<tr>
						<th class="row-label" aria-label="Critère"></th>
						<th class="col-bs">
							<div class="col-header bs-header">
								<span class="col-emoji">🍪</span>
								<strong>Brigade Sucrée</strong>
							</div>
						</th>
						<th>
							<div class="col-header">
								<span class="col-emoji">🏫</span>
								<strong>CFA / Cours</strong>
							</div>
						</th>
						<th>
							<div class="col-header">
								<span class="col-emoji">📺</span>
								<strong>YouTube</strong>
							</div>
						</th>
						<th>
							<div class="col-header">
								<span class="col-emoji">📚</span>
								<strong>Livres</strong>
							</div>
						</th>
					</tr>
				</thead>
				<tbody>
					{#each rows as row}
						<tr>
							<th scope="row" class="row-label">{row.label}</th>
							{#each [row.bs, row.cfa, row.yt, row.books] as v, i}
								{@const c = cell(v)}
								<td class={c.class} class:col-bs={i === 0}>
									<span aria-label={c.class === 'yes' ? 'Oui' : c.class === 'no' ? 'Non' : c.class === 'partial' ? 'Partiel' : ''}>
										{c.icon}
									</span>
								</td>
							{/each}
						</tr>
					{/each}
				</tbody>
			</table>
		</div>

		<p class="comparison-foot">
			Brigade Sucrée n'a pas vocation à <strong>remplacer</strong> une formation diplômante.
			C'est un outil d'entraînement et de révision quotidien, complémentaire.
		</p>
	</div>
</section>

<style>
.comparison-header {
	text-align: center;
	max-width: 640px;
	margin: 0 auto 48px;
}
.comparison-header .ld-lead { margin-left: auto; margin-right: auto; }

.comparison-table-wrapper {
	overflow-x: auto;
	border-radius: 16px;
	border: 1px solid rgba(31, 77, 69, 0.1);
	box-shadow: 0 4px 14px rgba(31, 77, 69, 0.06);
}

.comparison-table {
	width: 100%;
	border-collapse: collapse;
	background: var(--ld-white);
	min-width: 640px;
}

.comparison-table th,
.comparison-table td {
	padding: 14px 16px;
	text-align: center;
	border-bottom: 1px solid rgba(31, 77, 69, 0.06);
	font-size: 0.9rem;
}

.comparison-table tr:last-child th,
.comparison-table tr:last-child td {
	border-bottom: none;
}

.comparison-table thead th {
	background: var(--ld-cream);
	padding: 18px 16px;
	color: var(--ld-deep);
	font-weight: 700;
	font-size: 0.85rem;
}

.comparison-table .col-bs {
	background: linear-gradient(180deg, rgba(232, 152, 85, 0.12), rgba(232, 152, 85, 0.04));
	border-left: 2px solid var(--ld-orange);
	border-right: 2px solid var(--ld-orange);
}

.comparison-table thead .col-bs { border-top: 2px solid var(--ld-orange); }
.comparison-table tr:last-child .col-bs { border-bottom: 2px solid var(--ld-orange); }

.col-header {
	display: flex;
	flex-direction: column;
	gap: 4px;
	align-items: center;
}
.col-emoji { font-size: 1.4rem; }

.bs-header strong { color: var(--ld-orange); }

.row-label {
	text-align: left;
	font-weight: 600;
	color: var(--ld-deep);
	width: 40%;
	background: rgba(244, 229, 210, 0.4);
}

.comparison-table .yes {
	color: #059669;
	font-weight: 800;
	font-size: 1.3rem;
}
.comparison-table .no {
	color: #94a3b8;
	font-weight: 700;
	font-size: 1.1rem;
}
.comparison-table .partial {
	color: var(--ld-orange);
	font-weight: 700;
	font-size: 1.2rem;
}
.comparison-table .text {
	font-weight: 700;
	color: var(--ld-deep);
	font-size: 0.85rem;
}

.comparison-foot {
	margin-top: 24px;
	text-align: center;
	color: var(--ld-text-muted);
	font-size: 0.88rem;
	max-width: 720px;
	margin-left: auto;
	margin-right: auto;
}

@media (max-width: 768px) {
	.comparison-table { font-size: 0.82rem; }
	.comparison-table th,
	.comparison-table td { padding: 10px 8px; }
	.col-emoji { font-size: 1.1rem; }
}
</style>

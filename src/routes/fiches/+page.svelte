<script>
import fichesData from '$lib/data/fiches-cap.json';

const { categories, fiches } = fichesData;

let filterCat = 'all';
let search = '';

$: filtered = fiches.filter((f) => {
	if (filterCat !== 'all' && f.categorie !== filterCat) return false;
	if (search) {
		const q = search.toLowerCase();
		const hay = (f.titre + ' ' + f.theme + ' ' + (f.notions ?? []).join(' ')).toLowerCase();
		if (!hay.includes(q)) return false;
	}
	return true;
});

$: groupedByCategory = categories
	.map((cat) => ({
		...cat,
		fiches: filtered.filter((f) => f.categorie === cat.id)
	}))
	.filter((g) => g.fiches.length > 0);

function catById(id) {
	return categories.find((c) => c.id === id);
}
</script>

<svelte:head>
	<title>Fiches CAP — Brigade Sucrée</title>
	<meta name="description" content="50 fiches du référentiel CAP Pâtissier : cadre du diplôme, EP1 EP2, technologie, techniques, hygiène, organisation, recettes, pièges, vocabulaire." />
</svelte:head>

<div class="page">
	<h1 class="page-title">📚 Fiches CAP</h1>
	<p class="page-subtitle">{fiches.length} fiches du référentiel officiel</p>

	<input
		id="fiches-search"
		class="input mb-3"
		type="search"
		placeholder="🔍 Rechercher dans 50 fiches..."
		bind:value={search}
		aria-label="Rechercher une fiche"
		autocomplete="off"
	/>

	<div class="filter-chips" role="tablist" aria-label="Filtrer par catégorie">
		<button
			type="button"
			class="chip"
			class:active={filterCat === 'all'}
			on:click={() => (filterCat = 'all')}
			role="tab"
			aria-selected={filterCat === 'all'}
		>
			Toutes ({fiches.length})
		</button>
		{#each categories as cat}
			{@const count = fiches.filter((f) => f.categorie === cat.id).length}
			<button
				type="button"
				class="chip"
				class:active={filterCat === cat.id}
				on:click={() => (filterCat = cat.id)}
				role="tab"
				aria-selected={filterCat === cat.id}
				style:--cat-color={cat.color}
			>
				{cat.emoji} {cat.label} ({count})
			</button>
		{/each}
	</div>

	{#if filtered.length === 0}
		<div class="empty-state">
			<div class="empty-state-emoji">🔍</div>
			<div class="empty-state-title">Aucune fiche trouvée</div>
			<div class="empty-state-desc">Essaie d'autres mots-clés ou retire les filtres.</div>
		</div>
	{:else}
		{#each groupedByCategory as group}
			<section class="cat-section">
				<div class="cat-header" style:--cat-color={group.color}>
					<span class="cat-emoji" aria-hidden="true">{group.emoji}</span>
					<h2 class="cat-title">{group.label}</h2>
					<span class="cat-count">{group.fiches.length}</span>
				</div>

				<div class="fiches-grid">
					{#each group.fiches as fiche (fiche.id)}
						<a href="/fiches/{fiche.id}" class="fiche-card" data-track="fiche:click">
							<div class="fiche-num">Fiche {fiche.numero}</div>
							<h3 class="fiche-title">{fiche.titre}</h3>
							<p class="fiche-theme">{fiche.theme}</p>
						</a>
					{/each}
				</div>
			</section>
		{/each}
	{/if}
</div>

<style>
.cat-section {
	margin-bottom: 32px;
}

.cat-header {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 14px;
	padding-bottom: 10px;
	border-bottom: 2px solid var(--cat-color, var(--color-brand));
}

.cat-emoji { font-size: 1.4rem; }

.cat-title {
	flex: 1;
	font-size: 1rem;
	font-weight: 700;
	color: var(--color-text);
	margin: 0;
}

.cat-count {
	background: var(--cat-color, var(--color-brand));
	color: #fff;
	padding: 2px 10px;
	border-radius: var(--radius-full);
	font-size: 0.78rem;
	font-weight: 700;
}

.fiches-grid {
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.fiche-card {
	display: block;
	background: var(--color-surface);
	border: 1px solid var(--color-border);
	border-radius: var(--radius-lg);
	padding: 14px 16px;
	text-decoration: none;
	color: inherit;
	transition: border-color 0.15s, box-shadow 0.15s, transform 0.15s;
}

.fiche-card:hover {
	border-color: var(--color-brand);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
	transform: translateY(-1px);
}

.fiche-card:active { transform: translateY(0); }

.fiche-num {
	font-size: 0.7rem;
	font-weight: 700;
	color: var(--color-text-3);
	text-transform: uppercase;
	letter-spacing: 0.06em;
	margin-bottom: 4px;
}

.fiche-title {
	font-size: 1rem;
	font-weight: 700;
	margin: 0 0 6px;
	color: var(--color-text);
	line-height: 1.3;
}

.fiche-theme {
	font-size: 0.85rem;
	color: var(--color-text-2);
	line-height: 1.5;
	margin: 0;
	display: -webkit-box;
	-webkit-line-clamp: 2;
	-webkit-box-orient: vertical;
	overflow: hidden;
}

.chip[style*="--cat-color"].active {
	background: var(--cat-color);
	border-color: var(--cat-color);
}
</style>

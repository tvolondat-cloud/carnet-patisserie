<script>
import { recettes, recettesLoading } from '$lib/stores/recettes.js';
import { progression } from '$lib/stores/progression.js';
import { isPro, FREE_RECIPE_SLUGS } from '$lib/stores/auth.js';
import { goto } from '$app/navigation';
import recipesData from '$lib/data/recipes.json';
import { slugify } from '$lib/utils/slugify.js';

const categories = recipesData.categories;
const competences = recipesData.competences;

let filterCat = 'all';
let filterComp = 'all';
let filterStatut = 'all';
let search = '';
let showAllCats = false;

// Identité couleur par catégorie — palette pâtisserie chaude
const CAT_COLORS = {
	cremes: '#e0a93f',
	pates: '#cf9350',
	'bases-cap': '#6c63ff',
	biscuits: '#9a6440',
	'fours-secs': '#c8893f',
	'gateaux-voyage': '#dd6f93',
	choux: '#cf8a3c',
	feuilletage: '#b8954e',
	tartes: '#c33b56',
	entremets: '#7d2333',
	viennoiseries: '#d98e3c',
	glacages: '#a85fce'
};

$: catCounts = $recettes.reduce((m, r) => {
	m[r.categorie] = (m[r.categorie] || 0) + 1;
	return m;
}, {});

// Repli progressif : 6 catégories + "Toutes", l'active reste toujours visible
$: visibleCats = showAllCats
	? categories
	: (() => {
			const base = categories.slice(0, 6);
			if (filterCat !== 'all' && !base.some((c) => c.id === filterCat)) {
				const sel = categories.find((c) => c.id === filterCat);
				if (sel) return [...base.slice(0, 5), sel];
			}
			return base;
	  })();

const statuts = [
	{ id: 'all', label: 'Tous' },
	{ id: 'a-tester', label: 'À tester' },
	{ id: 'testee', label: 'Testées' },
	{ id: 'validee', label: 'Validées' },
	{ id: 'maitrisee', label: 'Maîtrisées' },
];

$: filtered = $recettes.filter(r => {
	const p = $progression[r.id];
	const statut = p?.statut ?? 'a-tester';
	if (filterCat !== 'all' && r.categorie !== filterCat) return false;
	if (filterComp !== 'all' && !(r.competences ?? []).includes(filterComp)) return false;
	if (filterStatut !== 'all' && statut !== filterStatut) return false;
	if (search && !r.nom.toLowerCase().includes(search.toLowerCase())) return false;
	return true;
});

const statutLabel = { 'a-tester': 'À tester', testee: 'Testée', validee: 'Validée', maitrisee: 'Maîtrisée' };
</script>

<div class="page">
	<h1 class="page-title">📖 Recettes</h1>
	<p class="page-subtitle">{$recettes.length} recettes CAP</p>

	<input class="input mb-3" type="search" placeholder="🔍 Rechercher..." bind:value={search}>

	<div class="filter-chips">
		<button class="chip" class:active={filterStatut === 'all'} on:click={() => filterStatut = 'all'}>Tous</button>
		{#each statuts.slice(1) as s}
		<button class="chip" class:active={filterStatut === s.id} on:click={() => filterStatut = s.id}>{s.label}</button>
		{/each}
	</div>

	<div class="cat-board">
		<div class="cat-board-head">
			<span class="cat-board-label">Catégories</span>
			<button
				type="button"
				class="cat-toggle"
				aria-expanded={showAllCats}
				on:click={() => (showAllCats = !showAllCats)}
			>
				{showAllCats ? 'Réduire' : `Voir les ${categories.length}`}
				<span class="cat-toggle-chevron" class:up={showAllCats} aria-hidden="true">⌄</span>
			</button>
		</div>

		<div class="cat-grid" role="group" aria-label="Filtrer par catégorie">
			<button
				type="button"
				class="cat-tile cat-tile-all"
				class:on={filterCat === 'all'}
				aria-pressed={filterCat === 'all'}
				on:click={() => (filterCat = 'all')}
			>
				<span class="cat-emoji" aria-hidden="true">🍰</span>
				<span class="cat-name">Toutes</span>
				<span class="cat-count">{$recettes.length}</span>
				{#if filterCat === 'all'}<span class="cat-check" aria-hidden="true">✓</span>{/if}
			</button>

			{#each visibleCats as cat, i (cat.id)}
			<button
				type="button"
				class="cat-tile"
				class:on={filterCat === cat.id}
				style="--c:{CAT_COLORS[cat.id] ?? 'var(--color-brand)'};--i:{i}"
				aria-pressed={filterCat === cat.id}
				aria-label="{cat.label} — {catCounts[cat.id] ?? 0} recettes"
				on:click={() => (filterCat = cat.id)}
			>
				<span class="cat-emoji" aria-hidden="true">{cat.emoji}</span>
				<span class="cat-name">{cat.label}</span>
				<span class="cat-count">{catCounts[cat.id] ?? 0}</span>
				{#if filterCat === cat.id}<span class="cat-check" aria-hidden="true">✓</span>{/if}
			</button>
			{/each}
		</div>
	</div>

	{#if $recettesLoading}
	<div style="padding:48px 0;text-align:center"><div class="spinner"></div></div>
	{:else if filtered.length === 0}
	<div class="empty-state">
		<div class="empty-state-emoji">🔍</div>
		<div class="empty-state-title">Aucune recette trouvée</div>
		<div class="empty-state-desc">Change tes filtres pour en voir plus.</div>
	</div>
	{:else}
	{#each filtered as r}
	{@const p = $progression[r.id]}
	{@const statut = p?.statut ?? 'a-tester'}
	{@const slug = slugify(r.nom)}
	{@const locked = !$isPro && !FREE_RECIPE_SLUGS.has(slug)}
	<a href={locked ? '/profil#plan' : `/recettes/${slug}`} class="recipe-card" class:recipe-locked={locked} style="margin-bottom:10px;display:block">
		<div class="recipe-card-title">
			{r.nom}
			{#if locked}<span class="pro-badge">Pro</span>{/if}
		</div>
		<div class="recipe-card-meta">
			{#if !locked}
			<span class="badge badge-{statut}">{statutLabel[statut]}</span>
			{/if}
			<span class="badge badge-{r.ep?.toLowerCase()}">{r.ep}</span>
			<span class="text-xs text-muted">⏱ {r.temps} min</span>
			<div class="recipe-difficulty">
				{#each Array(5) as _, i}
				<div class="dot" class:filled={i < r.difficulte}></div>
				{/each}
			</div>
		</div>
		{#if (r.competences ?? []).length && !locked}
		<div style="display:flex;gap:4px;flex-wrap:wrap;margin-top:4px">
			{#each r.competences as comp}
			{@const c = competences.find(x => x.id === comp)}
			{#if c}<span class="text-xs" style="color:var(--color-text-3)">{c.emoji} {c.label}</span>{/if}
			{/each}
		</div>
		{/if}
	</a>
	{/each}
	{/if}
</div>

<style>
/* ── Le comptoir : grille de catégories tactiles ───────────────── */
.cat-board { margin: 4px 0 20px; }

.cat-board-head {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 10px;
}
.cat-board-label {
	font-size: 0.7rem;
	font-weight: 800;
	letter-spacing: 0.13em;
	text-transform: uppercase;
	color: var(--color-text-3);
}
.cat-toggle {
	display: inline-flex;
	align-items: center;
	gap: 5px;
	font-size: 0.78rem;
	font-weight: 700;
	color: var(--color-brand);
	background: none;
	border: none;
	padding: 4px 2px;
	cursor: pointer;
}
.cat-toggle:hover { color: var(--color-brand-dark); }
.cat-toggle-chevron {
	font-size: 1rem;
	line-height: 0;
	transition: transform 0.28s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.cat-toggle-chevron.up { transform: rotate(180deg); }

.cat-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 9px;
}
@media (min-width: 560px) {
	.cat-grid { grid-template-columns: repeat(4, 1fr); }
}
@media (min-width: 900px) {
	.cat-grid { grid-template-columns: repeat(6, 1fr); }
}

.cat-tile {
	--c: var(--color-brand);
	position: relative;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 5px;
	padding: 14px 8px 12px;
	min-height: 92px;
	border-radius: var(--radius-lg);
	background: var(--color-surface);
	background: color-mix(in srgb, var(--c) 7%, var(--color-surface));
	border: 1.5px solid var(--color-border);
	border-color: color-mix(in srgb, var(--c) 20%, var(--color-border));
	cursor: pointer;
	overflow: hidden;
	transition:
		transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1),
		box-shadow 0.2s ease,
		background 0.2s ease,
		border-color 0.2s ease;
	animation: tile-in 0.34s cubic-bezier(0.16, 1, 0.3, 1) backwards;
	animation-delay: calc(var(--i, 0) * 22ms);
}
.cat-tile::after {
	/* lueur diagonale subtile, façon vitrine vernie */
	content: '';
	position: absolute;
	inset: 0;
	background: linear-gradient(135deg, rgba(255, 255, 255, 0.22), transparent 42%);
	opacity: 0;
	transition: opacity 0.2s ease;
	pointer-events: none;
}
.cat-tile:hover {
	transform: translateY(-3px);
	box-shadow: 0 10px 22px color-mix(in srgb, var(--c) 26%, transparent);
	border-color: color-mix(in srgb, var(--c) 55%, transparent);
}
.cat-tile:active { transform: translateY(-1px) scale(0.97); }

.cat-emoji {
	display: grid;
	place-items: center;
	width: 38px;
	height: 38px;
	font-size: 1.15rem;
	border-radius: var(--radius-full);
	background: color-mix(in srgb, var(--c) 16%, var(--color-surface));
	transition: background 0.2s ease, transform 0.2s ease;
}
.cat-tile:hover .cat-emoji { transform: scale(1.08) rotate(-4deg); }
.cat-name {
	font-size: 0.76rem;
	font-weight: 700;
	color: var(--color-text);
	text-align: center;
	line-height: 1.15;
}
.cat-count {
	font-size: 0.68rem;
	font-weight: 700;
	color: var(--color-text-3);
	font-variant-numeric: tabular-nums;
}

/* État sélectionné — la catégorie s'allume de sa couleur */
.cat-tile.on {
	background: linear-gradient(155deg, var(--c), color-mix(in srgb, var(--c) 72%, #000));
	border-color: transparent;
	box-shadow: 0 12px 26px color-mix(in srgb, var(--c) 40%, transparent);
	transform: translateY(-2px);
}
.cat-tile.on::after { opacity: 1; }
.cat-tile.on .cat-emoji { background: rgba(255, 255, 255, 0.22); }
.cat-tile.on .cat-name { color: #fff; }
.cat-tile.on .cat-count { color: rgba(255, 255, 255, 0.78); }
.cat-check {
	position: absolute;
	top: 7px;
	right: 8px;
	width: 17px;
	height: 17px;
	display: grid;
	place-items: center;
	font-size: 0.62rem;
	font-weight: 900;
	color: var(--c);
	background: #fff;
	border-radius: var(--radius-full);
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
}

/* La tuile "Toutes" prend l'accent marque */
.cat-tile-all { --c: var(--color-brand); }

@keyframes tile-in {
	from { opacity: 0; transform: translateY(8px) scale(0.96); }
	to   { opacity: 1; transform: translateY(0) scale(1); }
}
@media (prefers-reduced-motion: reduce) {
	.cat-tile,
	.cat-tile:hover,
	.cat-tile:active { transform: none; animation: none; }
	.cat-toggle-chevron { transition: none; }
}

.recipe-locked {
	opacity: 0.65;
	filter: saturate(0.4);
	cursor: default;
}
.recipe-locked:hover {
	border-color: var(--color-brand);
	opacity: 0.85;
}
.pro-badge {
	display: inline-block;
	font-size: 0.65rem;
	font-weight: 800;
	letter-spacing: 0.04em;
	background: var(--color-brand);
	color: #fff;
	padding: 1px 6px;
	border-radius: 6px;
	margin-left: 6px;
	vertical-align: middle;
}
</style>

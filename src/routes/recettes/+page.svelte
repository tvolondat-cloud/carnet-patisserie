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

	<div class="cat-filter">
		<div class="filter-chips chips-wrap" class:collapsed={!showAllCats}>
			<button class="chip" class:active={filterCat === 'all'} on:click={() => filterCat = 'all'}>Toutes</button>
			{#each categories as cat}
			<button class="chip" class:active={filterCat === cat.id} on:click={() => filterCat = cat.id}>{cat.emoji} {cat.label}</button>
			{/each}
		</div>
		<button
			type="button"
			class="cat-toggle"
			aria-expanded={showAllCats}
			on:click={() => (showAllCats = !showAllCats)}
		>
			{showAllCats ? '▲ Réduire' : `▾ Toutes les catégories (${categories.length})`}
		</button>
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
/* Filtre catégories : wrap multi-lignes + repli, plus de scroll tronqué */
.cat-filter { margin-bottom: 16px; }
.filter-chips.chips-wrap {
	flex-wrap: wrap;
	overflow: visible;
	margin-bottom: 8px;
	transition: max-height 0.25s ease;
}
.filter-chips.chips-wrap.collapsed {
	max-height: 84px; /* ~2 rangées */
	overflow: hidden;
	-webkit-mask-image: linear-gradient(180deg, #000 60%, transparent);
	mask-image: linear-gradient(180deg, #000 60%, transparent);
}
.cat-toggle {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	font-size: 0.8rem;
	font-weight: 600;
	color: var(--color-brand);
	background: none;
	border: none;
	padding: 4px 2px;
	cursor: pointer;
}
.cat-toggle:hover { text-decoration: underline; }

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

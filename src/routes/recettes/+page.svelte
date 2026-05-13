<script>
import { recettes, recettesLoading } from '$lib/stores/recettes.js';
import { progression } from '$lib/stores/progression.js';
import { goto } from '$app/navigation';
import recipesData from '$lib/data/recipes.json';
import { slugify } from '$lib/utils/slugify.js';

const categories = recipesData.categories;
const competences = recipesData.competences;

let filterCat = 'all';
let filterComp = 'all';
let filterStatut = 'all';
let search = '';

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

	<div class="filter-chips">
		<button class="chip" class:active={filterCat === 'all'} on:click={() => filterCat = 'all'}>Catégories</button>
		{#each categories as cat}
		<button class="chip" class:active={filterCat === cat.id} on:click={() => filterCat = cat.id}>{cat.emoji} {cat.label}</button>
		{/each}
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
	<a href="/recettes/{slugify(r.nom)}" class="recipe-card" style="margin-bottom:10px;display:block">
		<div class="recipe-card-title">{r.nom}</div>
		<div class="recipe-card-meta">
			<span class="badge badge-{statut}">{statutLabel[statut]}</span>
			<span class="badge badge-{r.ep?.toLowerCase()}">{r.ep}</span>
			<span class="text-xs text-muted">⏱ {r.temps} min</span>
			<div class="recipe-difficulty">
				{#each Array(5) as _, i}
				<div class="dot" class:filled={i < r.difficulte}></div>
				{/each}
			</div>
		</div>
		{#if (r.competences ?? []).length}
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

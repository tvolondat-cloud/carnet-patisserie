<script>
import { byCategory, glossaire, CATEGORIES } from '$lib/data/glossaire.js';
import { onMount } from 'svelte';

let search = '';
let activeCat = 'all';

$: groups = byCategory();
$: q = search.trim().toLowerCase();
$: filtered = groups
	.filter((g) => activeCat === 'all' || g.id === activeCat)
	.map((g) => ({
		...g,
		entries: g.entries.filter(
			(e) =>
				!q ||
				e.term.toLowerCase().includes(q) ||
				e.short.toLowerCase().includes(q) ||
				(e.long ?? '').toLowerCase().includes(q)
		)
	}))
	.filter((g) => g.entries.length > 0);

let totalCount;
$: totalCount = glossaire.length;

// Scroll vers l'ancre au mount si fragment présent
onMount(() => {
	const hash = location.hash?.slice(1);
	if (hash) {
		const el = document.getElementById(hash);
		el?.scrollIntoView({ behavior: 'smooth', block: 'center' });
		el?.classList.add('flash');
		setTimeout(() => el?.classList.remove('flash'), 1800);
	}
});
</script>

<svelte:head>
	<title>Glossaire CAP Pâtissier — Brigade Sucrée</title>
	<meta
		name="description"
		content="Vocabulaire essentiel du CAP Pâtissier : EP1, EP2, techniques (sablage, fraser, tourage…), méthode Brigade Sucrée, ingrédients et statuts de progression."
	/>
	<link rel="canonical" href="https://brigadesucree.app/glossaire" />
</svelte:head>

<div class="page glossary">
	<div style="margin-bottom:8px">
		<a href="/" class="btn btn-ghost btn-sm">← Accueil</a>
	</div>

	<h1 class="page-title">📚 Glossaire CAP</h1>
	<p class="page-subtitle">
		Le vocabulaire essentiel — examen, méthode, techniques, ingrédients.
		<strong>{totalCount}</strong> entrées.
	</p>

	<input
		class="input mb-2"
		type="search"
		placeholder="🔍 Rechercher un terme, une technique…"
		bind:value={search}
	/>

	<div class="filter-chips" role="tablist" aria-label="Filtrer par catégorie">
		<button
			class="chip"
			class:active={activeCat === 'all'}
			on:click={() => (activeCat = 'all')}
			role="tab"
			aria-selected={activeCat === 'all'}
		>Tous</button>
		{#each CATEGORIES as c}
		<button
			class="chip"
			class:active={activeCat === c.id}
			on:click={() => (activeCat = c.id)}
			role="tab"
			aria-selected={activeCat === c.id}
		>{c.emoji} {c.label}</button>
		{/each}
	</div>

	{#if filtered.length === 0}
	<div class="empty-state">
		<div class="empty-state-emoji">🔍</div>
		<div class="empty-state-title">Aucun résultat</div>
		<div class="empty-state-desc">Essaie un autre mot-clé ou enlève les filtres.</div>
	</div>
	{:else}
	{#each filtered as g}
	<section class="glossary-cat" aria-labelledby="cat-{g.id}">
		<h2 id="cat-{g.id}" class="glossary-cat-title">{g.emoji} {g.label}</h2>
		<dl class="glossary-list">
			{#each g.entries as e}
			<div id={e.key} class="glossary-entry">
				<dt>{e.term}</dt>
				<dd>
					<p>{e.short}</p>
					{#if e.long}<p class="glossary-long">{e.long}</p>{/if}
				</dd>
			</div>
			{/each}
		</dl>
	</section>
	{/each}
	{/if}
</div>

<style>
.glossary { padding-bottom: 32px; }
.glossary-cat { margin-top: 24px; }
.glossary-cat-title {
	font-size: 0.95rem;
	font-weight: 800;
	color: var(--color-brand);
	letter-spacing: 0.04em;
	text-transform: uppercase;
	margin-bottom: 10px;
}
.glossary-list { margin: 0; padding: 0; }
.glossary-entry {
	background: var(--color-surface);
	border: 1px solid var(--color-border);
	border-radius: var(--radius-md);
	padding: 12px 14px;
	margin-bottom: 8px;
	scroll-margin-top: 88px;
	transition: background 0.4s, border-color 0.4s;
}
.glossary-entry :global(.flash),
.glossary-entry.flash {
	background: rgba(108, 99, 255, 0.12);
	border-color: var(--color-brand);
}
.glossary-entry dt {
	font-weight: 800;
	font-size: 0.95rem;
	color: var(--color-text);
	margin-bottom: 4px;
}
.glossary-entry dd {
	margin: 0;
	font-size: 0.86rem;
	color: var(--color-text-2);
	line-height: 1.55;
}
.glossary-entry dd p { margin: 0; }
.glossary-entry dd p + p { margin-top: 6px; }
.glossary-long {
	font-size: 0.82rem;
	color: var(--color-text-3);
	padding-top: 6px;
	border-top: 1px dashed var(--color-border);
}
</style>

<script>
import { page } from '$app/stores';
import { goto } from '$app/navigation';
import { onMount } from 'svelte';
import fichesData from '$lib/data/fiches-cap.json';
import { track } from '$lib/analytics.js';

const { categories, fiches } = fichesData;

$: id = $page.params.id;
$: fiche = fiches.find((f) => f.id === id);
$: cat = fiche ? categories.find((c) => c.id === fiche.categorie) : null;

$: idx = fiche ? fiches.findIndex((f) => f.id === id) : -1;
$: prev = idx > 0 ? fiches[idx - 1] : null;
$: next = idx >= 0 && idx < fiches.length - 1 ? fiches[idx + 1] : null;

let viewTracked = false;
$: if (fiche && !viewTracked) {
	track('view_fiche', {
		fiche_id: fiche.id,
		fiche_categorie: fiche.categorie,
		fiche_titre: fiche.titre,
		fiche_numero: fiche.numero
	});
	viewTracked = true;
}

onMount(() => {
	if (!fiche) {
		goto('/fiches');
	}
});
</script>

<svelte:head>
	{#if fiche}
		<title>Fiche {fiche.numero} — {fiche.titre} | Brigade Sucrée</title>
		<meta name="description" content={fiche.theme} />
	{:else}
		<title>Fiches CAP | Brigade Sucrée</title>
	{/if}
</svelte:head>

{#if fiche && cat}
	<div class="page">
		<div class="fiche-header-row">
			<button type="button" class="btn btn-ghost btn-sm" on:click={() => goto('/fiches')}>← Fiches</button>
			<span class="cat-badge" style:--cat-color={cat.color}>
				{cat.emoji} {cat.label}
			</span>
		</div>

		<div class="fiche-meta">
			<span class="fiche-num-pill">Fiche {fiche.numero} / {fiches.length}</span>
		</div>

		<h1 class="page-title">{fiche.titre}</h1>

		<!-- Thème -->
		<div class="theme-card" style:--cat-color={cat.color}>
			<div class="section-label">📌 Thème</div>
			<p>{fiche.theme}</p>
		</div>

		<!-- Notions théoriques -->
		{#if fiche.notions?.length}
			<section class="card mb-3">
				<h2 class="section-title-h2">💡 Notions théoriques clés</h2>
				<ul class="bullet-list">
					{#each fiche.notions as n}
						<li>{n}</li>
					{/each}
				</ul>
			</section>
		{/if}

		<!-- Techniques -->
		{#if fiche.techniques?.length}
			<section class="card mb-3">
				<h2 class="section-title-h2">🛠️ Techniques à maîtriser</h2>
				<ul class="bullet-list">
					{#each fiche.techniques as t}
						<li>{t}</li>
					{/each}
				</ul>
			</section>
		{/if}

		<!-- Recettes associées -->
		{#if fiche.recettes_associees?.length}
			<section class="card mb-3">
				<h2 class="section-title-h2">📖 Recettes associées</h2>
				<div class="recettes-chips">
					{#each fiche.recettes_associees as r}
						<span class="recette-chip">{r}</span>
					{/each}
				</div>
			</section>
		{/if}

		<!-- Tips formateur -->
		{#if fiche.tips?.length}
			<aside class="alert alert-tips">
				<div class="alert-icon" aria-hidden="true">🎓</div>
				<div>
					<div class="alert-title">Tips de formateur</div>
					<ul class="bullet-list">
						{#each fiche.tips as tip}
							<li>{tip}</li>
						{/each}
					</ul>
				</div>
			</aside>
		{/if}

		<!-- Piège classique -->
		{#if fiche.piege}
			<aside class="alert alert-piege">
				<div class="alert-icon" aria-hidden="true">⚠️</div>
				<div>
					<div class="alert-title">Piège classique</div>
					<p>{fiche.piege}</p>
				</div>
			</aside>
		{/if}

		<!-- Navigation prev/next -->
		<nav class="prev-next" aria-label="Navigation entre fiches">
			{#if prev}
				<a href="/fiches/{prev.id}" class="nav-card nav-prev" data-track="fiche:prev">
					<span class="nav-arrow" aria-hidden="true">←</span>
					<div>
						<div class="nav-label">Précédent</div>
						<div class="nav-title">Fiche {prev.numero} · {prev.titre}</div>
					</div>
				</a>
			{:else}
				<div></div>
			{/if}

			{#if next}
				<a href="/fiches/{next.id}" class="nav-card nav-next" data-track="fiche:next">
					<div>
						<div class="nav-label">Suivant</div>
						<div class="nav-title">Fiche {next.numero} · {next.titre}</div>
					</div>
					<span class="nav-arrow" aria-hidden="true">→</span>
				</a>
			{/if}
		</nav>
	</div>
{:else}
	<div class="page">
		<div class="spinner" style="margin: 60px auto" role="status" aria-label="Chargement"></div>
	</div>
{/if}

<style>
.fiche-header-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
	margin-bottom: 16px;
	flex-wrap: wrap;
}

.cat-badge {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	padding: 4px 12px;
	background: color-mix(in srgb, var(--cat-color) 12%, transparent);
	color: var(--cat-color, var(--color-brand));
	border: 1px solid var(--cat-color, var(--color-brand));
	border-radius: var(--radius-full);
	font-size: 0.78rem;
	font-weight: 600;
}

.fiche-meta {
	margin-bottom: 8px;
}

.fiche-num-pill {
	font-size: 0.72rem;
	color: var(--color-text-3);
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.06em;
}

.theme-card {
	background: color-mix(in srgb, var(--cat-color) 6%, var(--color-surface));
	border-left: 3px solid var(--cat-color, var(--color-brand));
	border-radius: var(--radius-md);
	padding: 14px 18px;
	margin-bottom: 16px;
}
.theme-card p {
	margin: 0;
	font-size: 0.95rem;
	line-height: 1.6;
	color: var(--color-text);
}

.section-label {
	font-size: 0.72rem;
	font-weight: 700;
	color: var(--cat-color, var(--color-brand));
	text-transform: uppercase;
	letter-spacing: 0.06em;
	margin-bottom: 6px;
}

.section-title-h2 {
	font-size: 1rem;
	font-weight: 700;
	margin: 0 0 12px;
	color: var(--color-text);
}

.bullet-list {
	list-style: none;
	padding: 0;
	margin: 0;
	display: flex;
	flex-direction: column;
	gap: 8px;
}
.bullet-list li {
	font-size: 0.92rem;
	color: var(--color-text);
	padding-left: 20px;
	position: relative;
	line-height: 1.55;
}
.bullet-list li::before {
	content: '•';
	position: absolute;
	left: 4px;
	color: var(--color-brand);
	font-weight: 700;
}

.recettes-chips {
	display: flex;
	gap: 6px;
	flex-wrap: wrap;
}

.recette-chip {
	background: var(--color-surface-2);
	color: var(--color-text);
	padding: 5px 12px;
	border-radius: var(--radius-full);
	font-size: 0.82rem;
	font-weight: 500;
}

.alert {
	display: flex;
	gap: 12px;
	padding: 14px 16px;
	border-radius: var(--radius-md);
	margin-bottom: 12px;
}
.alert-icon { font-size: 1.4rem; line-height: 1; flex-shrink: 0; }
.alert-title {
	font-weight: 700;
	font-size: 0.92rem;
	margin-bottom: 6px;
}
.alert p { margin: 0; font-size: 0.9rem; line-height: 1.55; }

.alert-tips {
	background: rgba(59, 130, 246, 0.08);
	border-left: 3px solid var(--color-validee);
}
.alert-tips .alert-title { color: var(--color-validee); }

.alert-piege {
	background: rgba(245, 158, 11, 0.1);
	border-left: 3px solid var(--color-testee);
}
.alert-piege .alert-title { color: var(--color-testee); }

.prev-next {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 10px;
	margin-top: 24px;
}

.nav-card {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 12px 14px;
	background: var(--color-surface);
	border: 1px solid var(--color-border);
	border-radius: var(--radius-md);
	text-decoration: none;
	color: inherit;
	transition: border-color 0.15s, background 0.15s;
}
.nav-card:hover {
	border-color: var(--color-brand);
	background: var(--color-surface-2);
}

.nav-next { justify-content: flex-end; text-align: right; }

.nav-arrow {
	font-size: 1.2rem;
	color: var(--color-brand);
	font-weight: 700;
	flex-shrink: 0;
}

.nav-label {
	font-size: 0.7rem;
	color: var(--color-text-3);
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.06em;
}

.nav-title {
	font-size: 0.84rem;
	font-weight: 600;
	color: var(--color-text);
	display: -webkit-box;
	-webkit-line-clamp: 1;
	-webkit-box-orient: vertical;
	overflow: hidden;
}
</style>

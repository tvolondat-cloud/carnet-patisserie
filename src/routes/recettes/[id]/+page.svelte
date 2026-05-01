<script>
import { page } from '$app/stores';
import { goto } from '$app/navigation';
import { recettes, commentaires, loadCommentaires, addCommentaire, deleteCommentaire, updateNotes, updateIngredient, addIngredient, deleteIngredient } from '$lib/stores/recettes.js';
import { progression, updateProgression } from '$lib/stores/progression.js';
import { derived } from 'svelte/store';
import { onMount } from 'svelte';

$: id = $page.params.id;
$: recette = $recettes.find(r => r.id === id);
$: p = $progression[id];
$: statut = p?.statut ?? 'a-tester';
$: recCommentaires = $commentaires[id] ?? [];

let multiplicateur = 1;
let notes = '';
let notesTimer;
let newComment = '';
let newCommentType = 'note';
let showAddComment = false;
let editingIngId = null;
let editIng = {};
let toast = '';
let toastTimer;

onMount(async () => {
	if (recette) {
		notes = recette.notes ?? '';
		await loadCommentaires(id);
	}
});

$: if (recette && notes !== recette.notes) {
	clearTimeout(notesTimer);
	notesTimer = setTimeout(() => updateNotes(id, notes), 800);
}

function calcQte(q) {
	return (q * multiplicateur).toFixed(multiplicateur < 1 ? 1 : 0).replace('.0', '');
}

function showToast(msg) {
	toast = msg;
	clearTimeout(toastTimer);
	toastTimer = setTimeout(() => toast = '', 2500);
}

async function advanceStatut() {
	const order = ['a-tester', 'testee', 'validee', 'maitrisee'];
	const i = order.indexOf(statut);
	if (i < order.length - 1) {
		await updateProgression(id, { statut: order[i + 1] });
		showToast('Statut mis à jour ! 🎉');
	}
}

async function handleAddComment() {
	if (!newComment.trim()) return;
	await addCommentaire(id, newComment.trim(), newCommentType);
	newComment = '';
	showAddComment = false;
	showToast('Commentaire ajouté ✅');
}

function startEditIng(ing) {
	editingIngId = ing.id;
	editIng = { nom: ing.nom, quantite: ing.quantite, unite: ing.unite };
}

async function saveEditIng() {
	await updateIngredient(editingIngId, editIng);
	editingIngId = null;
	showToast('Ingrédient modifié ✅');
}

async function handleAddIng() {
	const ordre = (recette?.ingredients?.length ?? 0) + 1;
	await addIngredient(id, { nom: 'Nouvel ingrédient', quantite: 100, unite: 'g', ordre });
	showToast('Ingrédient ajouté ✅');
}

const statutLabel = { 'a-tester': 'À tester', testee: 'Testée', validee: 'Validée', maitrisee: 'Maîtrisée' };
const nextStatutLabel = { 'a-tester': 'Marquer testée', testee: 'Marquer validée', validee: 'Marquer maîtrisée', maitrisee: '' };
const typeLabel = { note: '📝', astuce: '💡', erreur: '⚠️', variation: '🔄' };
const typeOptions = [
	{ id: 'note', label: '📝 Note' },
	{ id: 'astuce', label: '💡 Astuce' },
	{ id: 'erreur', label: '⚠️ Erreur' },
	{ id: 'variation', label: '🔄 Variation' },
];
</script>

{#if !recette}
<div class="page"><div class="spinner" style="margin-top:48px"></div></div>
{:else}
<div class="page">
	<div style="display:flex;align-items:center;gap:12px;margin-bottom:16px">
		<button class="btn btn-ghost btn-sm" on:click={() => goto('/recettes')}>← Retour</button>
	</div>

	<h1 class="page-title">{recette.nom}</h1>
	<div style="display:flex;gap:8px;margin-bottom:16px;flex-wrap:wrap">
		<span class="badge badge-{statut}">{statutLabel[statut]}</span>
		<span class="badge badge-{recette.ep?.toLowerCase()}">{recette.ep}</span>
		<span class="text-sm text-muted">⏱ {recette.temps} min</span>
	</div>

	{#if statut !== 'maitrisee'}
	<div style="display:flex;gap:8px;margin-bottom:20px">
		<button class="btn btn-primary" style="flex:1" on:click={advanceStatut}>
			✅ {nextStatutLabel[statut]}
		</button>
		<a href="/laboratoire/{id}" class="btn btn-secondary" style="flex:1">🧪 Mode Labo</a>
	</div>
	{:else}
	<div style="background:var(--color-maitrisee);color:#fff;border-radius:var(--radius-md);padding:12px 16px;text-align:center;margin-bottom:20px">
		⭐ Recette maîtrisée !
	</div>
	{/if}

	<!-- Calculateur -->
	<div class="card mb-3">
		<div class="section-header">
			<span class="section-title">Ingrédients</span>
			<div style="display:flex;align-items:center;gap:8px">
				<button class="btn btn-ghost btn-sm" on:click={() => multiplicateur = Math.max(0.25, +(multiplicateur - 0.25).toFixed(2))}>−</button>
				<span style="font-weight:700;min-width:36px;text-align:center">×{multiplicateur}</span>
				<button class="btn btn-ghost btn-sm" on:click={() => multiplicateur = Math.min(10, +(multiplicateur + 0.25).toFixed(2))}>+</button>
			</div>
		</div>

		<div style="display:flex;flex-direction:column;gap:8px">
			{#each (recette.ingredients ?? []).sort((a,b) => a.ordre - b.ordre) as ing}
			{#if editingIngId === ing.id}
			<div style="display:flex;gap:6px;align-items:center">
				<input class="input" style="flex:2" bind:value={editIng.nom}>
				<input class="input" style="flex:1;width:60px" type="number" bind:value={editIng.quantite}>
				<input class="input" style="flex:1;width:50px" bind:value={editIng.unite}>
				<button class="btn btn-primary btn-sm" on:click={saveEditIng}>✓</button>
			</div>
			{:else}
			<div style="display:flex;justify-content:space-between;align-items:center;padding:6px 0;border-bottom:1px solid var(--color-border)">
				<span class="text-sm">{ing.nom}</span>
				<div style="display:flex;align-items:center;gap:8px">
					<span class="font-bold text-sm" style="color:var(--color-brand)">{calcQte(ing.quantite)} {ing.unite}</span>
					<button class="btn btn-ghost btn-sm" style="padding:2px 6px" on:click={() => startEditIng(ing)}>✏️</button>
					<button class="btn btn-ghost btn-sm" style="padding:2px 6px" on:click={() => deleteIngredient(id, ing.id)}>🗑</button>
				</div>
			</div>
			{/if}
			{/each}
		</div>
		<button class="btn btn-ghost btn-sm mt-3" on:click={handleAddIng}>+ Ajouter ingrédient</button>
	</div>

	<!-- Étapes -->
	{#if (recette.etapes ?? []).length}
	<div class="card mb-3">
		<div class="section-title mb-3">Étapes</div>
		<ol style="list-style:none;display:flex;flex-direction:column;gap:12px">
			{#each recette.etapes.sort((a,b) => a.ordre - b.ordre) as e}
			<li style="display:flex;gap:12px">
				<div style="width:24px;height:24px;border-radius:50%;background:var(--color-brand);color:#fff;font-size:0.72rem;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0">{e.ordre}</div>
				<p class="text-sm" style="line-height:1.5;padding-top:3px">{e.description}</p>
			</li>
			{/each}
		</ol>
	</div>
	{/if}

	<!-- Notes personnelles -->
	<div class="card mb-3">
		<div class="section-title mb-2">📝 Mes notes</div>
		<textarea class="input" rows="4" placeholder="Tes astuces, erreurs à éviter, variations..." bind:value={notes}></textarea>
		<p class="text-xs text-muted mt-2">Sauvegarde automatique</p>
	</div>

	<!-- Commentaires -->
	<div class="card mb-3">
		<div class="section-header">
			<span class="section-title">💬 Commentaires</span>
			<button class="btn btn-ghost btn-sm" on:click={() => showAddComment = !showAddComment}>+ Ajouter</button>
		</div>

		{#if showAddComment}
		<div style="margin-bottom:12px;padding:12px;background:var(--color-surface-2);border-radius:var(--radius-md)">
			<div class="filter-chips mb-2">
				{#each typeOptions as t}
				<button class="chip" class:active={newCommentType === t.id} on:click={() => newCommentType = t.id}>{t.label}</button>
				{/each}
			</div>
			<textarea class="input" rows="3" placeholder="Ton commentaire..." bind:value={newComment}></textarea>
			<div style="display:flex;gap:8px;margin-top:8px">
				<button class="btn btn-primary btn-sm" on:click={handleAddComment}>Ajouter</button>
				<button class="btn btn-ghost btn-sm" on:click={() => showAddComment = false}>Annuler</button>
			</div>
		</div>
		{/if}

		{#if recCommentaires.length === 0}
		<p class="text-sm text-muted">Aucun commentaire. Partage tes astuces !</p>
		{:else}
		{#each recCommentaires as c}
		<div style="padding:10px 0;border-bottom:1px solid var(--color-border)">
			<div style="display:flex;justify-content:space-between;align-items:flex-start">
				<div>
					<span style="font-size:1rem">{typeLabel[c.type]}</span>
					<p class="text-sm mt-1" style="line-height:1.5">{c.contenu}</p>
				</div>
				<button class="btn btn-ghost btn-sm" style="padding:2px 6px;color:var(--color-a-tester)" on:click={() => deleteCommentaire(id, c.id)}>×</button>
			</div>
		</div>
		{/each}
		{/if}
	</div>
</div>

{#if toast}
<div class="toast">{toast}</div>
{/if}
{/if}

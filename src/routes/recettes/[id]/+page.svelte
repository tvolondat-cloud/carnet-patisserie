<script>
import { page } from '$app/stores';
import { goto } from '$app/navigation';
import { onMount } from 'svelte';
import {
	recettes, commentaires,
	loadCommentaires, addCommentaire, deleteCommentaire,
	updateNotes, updateIngredient, addIngredient, deleteIngredient,
	updateRecetteField,
	recipePhotos, loadPhotos, uploadPhoto, deletePhoto, getPhotoUrl,
	submitSuggestion
} from '$lib/stores/recettes.js';
import { progression, updateProgression } from '$lib/stores/progression.js';
import { session } from '$lib/stores/auth.js';
import { events } from '$lib/analytics.js';
import { onDestroy } from 'svelte';

$: id = $page.params.id;
$: recette = $recettes.find(r => r.id === id);
$: p = $progression[id];
$: statut = p?.statut ?? 'a-tester';
$: recCommentaires = $commentaires[id] ?? [];
$: photos = $recipePhotos[id] ?? [];

let viewTracked = false;
$: if (recette && !viewTracked) { events.viewRecipe(recette); viewTracked = true; }

// ── Calculateur ────────────────────────────────────────────
let multiplicateur = 1;

// Masse totale en grammes (g, kg→×1000, ml→×1, cl→×10, L→×1000)
const UNIT_TO_G = { g: 1, kg: 1000, ml: 1, cl: 10, l: 1000, L: 1000 };

function unitToGrams(q, unite) {
	const u = (unite ?? '').toLowerCase().trim();
	return UNIT_TO_G[u] ? parseFloat(q) * UNIT_TO_G[u] : null;
}

$: masseTotale = (() => {
	const ings = recette?.ingredients ?? [];
	let total = 0;
	let hasMeasurable = false;
	for (const ing of ings) {
		const grams = unitToGrams(ing.quantite, ing.unite);
		if (grams !== null) { total += grams; hasMeasurable = true; }
	}
	return hasMeasurable ? total : null;
})();

$: masseTotaleAjustee = masseTotale !== null ? Math.round(masseTotale * multiplicateur) : null;

$: nbPieces = (recette?.nb_pieces_base && masseTotale !== null)
	? Math.round(recette.nb_pieces_base * multiplicateur)
	: null;

const MASS_UNITS = new Set(['g', 'kg', 'ml', 'cl', 'l']);

// Œuf entier → afficher en pce SEULEMENT si l'unité n'est pas déjà une masse/volume.
// Ex: "Œufs entiers" avec unite="g" → reste en g (300g ≠ 300 pce !)
function isOeufEntier(nom, unite) {
	const n = (nom ?? '').toLowerCase();
	const u = (unite ?? '').toLowerCase().trim();
	if (MASS_UNITS.has(u)) return false; // unité de masse → on respecte
	if ((n.includes('oeuf') || n.includes('œuf') || n.includes('egg'))
		&& !n.includes('blanc') && !n.includes('jaune')
		&& !n.includes('white') && !n.includes('yolk')) {
		return true;
	}
	return ['pce', 'pcs', 'u', 'unité', 'unité(s)', 'pc', 'piece', 'pièce'].includes(u);
}

// mult est passé explicitement pour que la déclaration $: ci-dessous
// référence multiplicateur directement → Svelte le trace comme dépendance.
function calcQte(q, nom, unite, mult) {
	const raw = parseFloat(q) * mult;
	if (isNaN(raw)) return String(q);
	if (isOeufEntier(nom, unite)) return Math.max(1, Math.round(raw)).toString();
	if (raw >= 100) return Math.round(raw).toString();
	if (raw >= 10) return (Math.round(raw * 10) / 10 % 1 === 0)
		? Math.round(raw).toString()
		: (Math.round(raw * 10) / 10).toFixed(1);
	return (Math.round(raw * 100) / 100).toString().replace(/\.?0+$/, '');
}

function getDisplayUnite(nom, unite) {
	const n = (nom ?? '').toLowerCase();
	if ((n.includes('blanc') || n.includes('jaune')) && (n.includes('oeuf') || n.includes('œuf'))) {
		return 'g';
	}
	if (isOeufEntier(nom, unite)) return 'pce';
	return unite;
}

// Recalculé chaque fois que multiplicateur OU les ingrédients changent.
// multiplicateur est référencé explicitement → Svelte le trace comme dépendance.
$: ingredientsDisplay = (recette?.ingredients ?? [])
	.slice()
	.sort((a, b) => (a.ordre ?? 0) - (b.ordre ?? 0))
	.map(ing => ({
		...ing,
		_qte: calcQte(ing.quantite, ing.nom, ing.unite, multiplicateur),
		_unite: getDisplayUnite(ing.nom, ing.unite)
	}));

// ── Nb pièces base (éditable) ──────────────────────────────
let editingNbPieces = false;
let nbPiecesEdit = '';
let nbPiecesTimer;

function startEditNbPieces() {
	nbPiecesEdit = String(recette?.nb_pieces_base ?? '');
	editingNbPieces = true;
}

async function saveNbPieces() {
	const val = parseInt(nbPiecesEdit);
	if (!isNaN(val) && val > 0) {
		await updateRecetteField(id, { nb_pieces_base: val });
	} else if (nbPiecesEdit === '') {
		await updateRecetteField(id, { nb_pieces_base: null });
	}
	editingNbPieces = false;
}

// ── Notes ──────────────────────────────────────────────────
let notes = '';
let notesTimer;
$: if (recette) notes = recette.notes ?? '';

$: if (recette && notes !== recette.notes) {
	clearTimeout(notesTimer);
	notesTimer = setTimeout(() => {
		updateNotes(id, notes);
		events.notesSaved(id);
	}, 800);
}

// ── Commentaires ───────────────────────────────────────────
let newComment = '';
let newCommentType = 'note';
let showAddComment = false;

async function handleAddComment() {
	if (!newComment.trim()) return;
	await addCommentaire(id, newComment.trim(), newCommentType);
	events.commentAdded(id, newCommentType);
	newComment = '';
	showAddComment = false;
	showToast('Commentaire ajouté ✅');
}

// ── Ingrédients ────────────────────────────────────────────
let editingIngId = null;
let editIng = {};

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

// ── Photos ─────────────────────────────────────────────────
let uploading = false;
let photoInput;

async function handlePhotoSelect(e) {
	const file = e.target.files?.[0];
	if (!file) return;
	uploading = true;
	try {
		await uploadPhoto(id, file);
		showToast('Photo ajoutée 📸');
	} catch (err) {
		showToast('Erreur upload : ' + err.message);
	} finally {
		uploading = false;
		photoInput.value = '';
	}
}

async function handleDeletePhoto(photo) {
	if (!confirm('Supprimer cette photo ?')) return;
	await deletePhoto(id, photo.id, photo.storage_path);
	showToast('Photo supprimée');
}

async function sharePhoto(photo) {
	const url = getPhotoUrl(photo.storage_path);
	if (navigator.share) {
		try {
			await navigator.share({
				title: recette?.nom,
				text: `Ma réalisation : ${recette?.nom} 🍰 #BrigadeSucrée`,
				url
			});
		} catch {}
	} else {
		showShareLinks(url);
	}
}

let shareUrl = '';
let showShare = false;

function showShareLinks(url) {
	shareUrl = url;
	showShare = true;
}

function copyLink() {
	navigator.clipboard.writeText(shareUrl).then(() => showToast('Lien copié !'));
}

// ── Suggestions ────────────────────────────────────────────
let showSuggestionModal = false;
let suggestionText = '';
let suggestionType = 'amelioration';
let suggestionLoading = false;

async function handleSuggestion() {
	if (suggestionText.trim().length < 10) return;
	suggestionLoading = true;
	try {
		await submitSuggestion(suggestionText.trim(), suggestionType);
		showToast('Suggestion envoyée ✅ Merci !');
		showSuggestionModal = false;
		suggestionText = '';
	} catch (err) {
		showToast('Erreur : ' + err.message);
	} finally {
		suggestionLoading = false;
	}
}

// ── Statut ─────────────────────────────────────────────────
let toast = '';
let toastTimer;

function showToast(msg) {
	toast = msg;
	clearTimeout(toastTimer);
	toastTimer = setTimeout(() => toast = '', 2500);
}

async function advanceStatut() {
	const order = ['a-tester', 'testee', 'validee', 'maitrisee'];
	const i = order.indexOf(statut);
	if (i < order.length - 1) {
		const newStatut = order[i + 1];
		await updateProgression(id, { statut: newStatut });
		if (newStatut === 'maitrisee' && recette) events.recipeMastered(recette);
		showToast('Statut mis à jour ! 🎉');
	}
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
const suggestionTypes = [
	{ id: 'amelioration', label: '✨ Amélioration' },
	{ id: 'bug', label: '🐛 Bug' },
	{ id: 'nouvelle-feature', label: '🚀 Nouvelle feature' },
	{ id: 'autre', label: '💬 Autre' },
];

onMount(async () => {
	if (recette) {
		await loadCommentaires(id);
		await loadPhotos(id);
	}
});
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

	<!-- ── Calculateur ── -->
	<div class="card mb-3">
		<div class="section-header">
			<span class="section-title">Ingrédients</span>
			<div class="mult-ctrl">
				<button class="btn btn-ghost btn-sm" on:click={() => multiplicateur = Math.max(0.25, +(multiplicateur - 0.25).toFixed(2))}>−</button>
				<span class="mult-val">×{multiplicateur}</span>
				<button class="btn btn-ghost btn-sm" on:click={() => multiplicateur = Math.min(10, +(multiplicateur + 0.25).toFixed(2))}>+</button>
			</div>
		</div>

		<div style="display:flex;flex-direction:column;gap:8px">
			{#each ingredientsDisplay as ing}
			{#if editingIngId === ing.id}
			<div style="display:flex;gap:6px;align-items:center">
				<input class="input" style="flex:2" bind:value={editIng.nom}>
				<input class="input" style="flex:1;width:60px" type="number" min="0" step="0.1" bind:value={editIng.quantite}>
				<input class="input" style="flex:1;width:50px" bind:value={editIng.unite}>
				<button class="btn btn-primary btn-sm" on:click={saveEditIng}>✓</button>
			</div>
			{:else}
			<div class="ing-row">
				<span class="ing-name">{ing.nom}</span>
				<div class="ing-right">
					<span class="ing-qte">{ing._qte}&nbsp;{ing._unite}</span>
					<button class="btn btn-ghost btn-sm" style="padding:2px 6px" on:click={() => startEditIng(ing)}>✏️</button>
					<button class="btn btn-ghost btn-sm" style="padding:2px 6px" on:click={() => deleteIngredient(id, ing.id)}>🗑</button>
				</div>
			</div>
			{/if}
			{/each}
		</div>

		<button class="btn btn-ghost btn-sm mt-3" on:click={handleAddIng}>+ Ajouter ingrédient</button>

		<!-- Masse totale + nb pièces -->
		{#if masseTotaleAjustee !== null || nbPieces !== null}
		<div class="masse-total-row">
			{#if masseTotaleAjustee !== null}
			<div class="masse-chip">
				⚖️ <strong>{masseTotaleAjustee} g</strong>
				{#if multiplicateur !== 1}<span class="text-muted text-xs"> (base {Math.round(masseTotale ?? 0)} g)</span>{/if}
			</div>
			{/if}
			{#if nbPieces !== null}
			<div class="masse-chip masse-chip-pieces">
				🔢 <strong>{nbPieces} pièce{nbPieces > 1 ? 's' : ''}</strong> réalisable{nbPieces > 1 ? 's' : ''}
			</div>
			{/if}
		</div>
		{/if}

		<!-- Édition nb pièces de base -->
		<div class="nb-pieces-edit">
			{#if editingNbPieces}
			<div style="display:flex;align-items:center;gap:8px">
				<label class="text-xs text-muted">Pièces pour ×1 :</label>
				<input class="input" style="width:70px" type="number" min="1" bind:value={nbPiecesEdit} on:keydown={e => e.key === 'Enter' && saveNbPieces()}>
				<button class="btn btn-primary btn-sm" on:click={saveNbPieces}>OK</button>
				<button class="btn btn-ghost btn-sm" on:click={() => editingNbPieces = false}>×</button>
			</div>
			{:else}
			<button class="btn btn-ghost btn-sm" style="font-size:0.72rem" on:click={startEditNbPieces}>
				{recette.nb_pieces_base ? `✏️ Modifier nb pièces (${recette.nb_pieces_base})` : '+ Définir nb pièces produites'}
			</button>
			{/if}
		</div>
	</div>

	<!-- ── Étapes ── -->
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

	<!-- ── Photos ── -->
	<div class="card mb-3">
		<div class="section-header">
			<span class="section-title">📸 Mes photos</span>
			<button class="btn btn-ghost btn-sm" on:click={() => photoInput.click()} disabled={uploading}>
				{uploading ? '⏳' : '+ Photo'}
			</button>
		</div>
		<input
			bind:this={photoInput}
			type="file"
			accept="image/*"
			capture="environment"
			style="display:none"
			on:change={handlePhotoSelect}
		/>

		{#if photos.length === 0}
		<p class="text-sm text-muted">Aucune photo. Immortalise ta réalisation ! 📷</p>
		{:else}
		<div class="photos-grid">
			{#each photos as photo}
			<div class="photo-thumb">
				<img src={getPhotoUrl(photo.storage_path)} alt="Réalisation" loading="lazy" />
				<div class="photo-actions">
					<button class="photo-btn" on:click={() => sharePhoto(photo)} title="Partager">🔗</button>
					<button class="photo-btn" on:click={() => handleDeletePhoto(photo)} title="Supprimer">🗑</button>
				</div>
			</div>
			{/each}
		</div>
		{/if}
	</div>

	<!-- ── Notes personnelles ── -->
	<div class="card mb-3">
		<div class="section-title mb-2">📝 Mes notes</div>
		<textarea class="input" rows="4" placeholder="Tes astuces, erreurs à éviter, variations..." bind:value={notes}></textarea>
		<p class="text-xs text-muted mt-2">Sauvegarde automatique</p>
	</div>

	<!-- ── Commentaires ── -->
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

	<!-- ── Suggestion amélioration ── -->
	<div style="text-align:center;margin-bottom:24px">
		<button class="btn btn-ghost btn-sm" on:click={() => showSuggestionModal = true} style="color:var(--color-text-3)">
			💡 Proposer une amélioration
		</button>
	</div>
</div>
{/if}

<!-- ── Modal suggestion ── -->
{#if showSuggestionModal}
<div class="modal-overlay" on:click={() => showSuggestionModal = false} on:keydown={e => e.key === 'Escape' && (showSuggestionModal = false)} role="dialog" aria-modal="true" aria-label="Proposer une amélioration">
	<div class="modal-box" on:click|stopPropagation>
		<div class="modal-header">
			<h2 class="modal-title">💡 Proposer une amélioration</h2>
			<button type="button" class="modal-close" on:click={() => showSuggestionModal = false}>×</button>
		</div>
		<div class="filter-chips mb-3">
			{#each suggestionTypes as t}
			<button class="chip" class:active={suggestionType === t.id} on:click={() => suggestionType = t.id}>{t.label}</button>
			{/each}
		</div>
		<textarea
			class="input"
			rows="5"
			placeholder="Décris ton idée ou le problème rencontré (min. 10 caractères)..."
			bind:value={suggestionText}
		></textarea>
		<div style="display:flex;gap:8px;margin-top:12px">
			<button
				class="btn btn-primary"
				style="flex:1"
				disabled={suggestionText.trim().length < 10 || suggestionLoading}
				on:click={handleSuggestion}
			>
				{suggestionLoading ? '⏳ Envoi...' : 'Envoyer'}
			</button>
			<button class="btn btn-ghost" on:click={() => showSuggestionModal = false}>Annuler</button>
		</div>
	</div>
</div>
{/if}

<!-- ── Modal partage photo ── -->
{#if showShare}
<div class="modal-overlay" on:click={() => showShare = false} on:keydown={e => e.key === 'Escape' && (showShare = false)} role="dialog" aria-modal="true" aria-label="Partager la photo">
	<div class="modal-box" on:click|stopPropagation>
		<div class="modal-header">
			<h2 class="modal-title">🔗 Partager</h2>
			<button type="button" class="modal-close" on:click={() => showShare = false}>×</button>
		</div>
		<div style="display:flex;flex-direction:column;gap:10px;margin-top:8px">
			<a
				href="https://wa.me/?text={encodeURIComponent('Ma réalisation : ' + (recette?.nom ?? '') + ' 🍰 ' + shareUrl)}"
				target="_blank"
				rel="noopener noreferrer"
				class="btn btn-secondary"
				style="justify-content:flex-start;gap:10px"
			>
				<span style="font-size:1.3rem">📱</span> WhatsApp
			</a>
			<a
				href="https://www.facebook.com/sharer/sharer.php?u={encodeURIComponent(shareUrl)}"
				target="_blank"
				rel="noopener noreferrer"
				class="btn btn-secondary"
				style="justify-content:flex-start;gap:10px"
			>
				<span style="font-size:1.3rem">📘</span> Facebook
			</a>
			<a
				href="https://twitter.com/intent/tweet?text={encodeURIComponent('Ma réalisation : ' + (recette?.nom ?? '') + ' 🍰 #BrigadeSucrée')}&url={encodeURIComponent(shareUrl)}"
				target="_blank"
				rel="noopener noreferrer"
				class="btn btn-secondary"
				style="justify-content:flex-start;gap:10px"
			>
				<span style="font-size:1.3rem">🐦</span> X / Twitter
			</a>
			<button class="btn btn-ghost" on:click={copyLink} style="justify-content:flex-start;gap:10px">
				<span style="font-size:1.3rem">📋</span> Copier le lien
			</button>
		</div>
	</div>
</div>
{/if}

{#if toast}
<div class="toast">{toast}</div>
{/if}

<style>
.ing-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 6px 0;
	border-bottom: 1px solid var(--color-border);
}
.ing-name { font-size: 0.9rem; color: var(--color-text); }
.ing-right { display: flex; align-items: center; gap: 6px; }
.ing-qte { font-weight: 700; font-size: 0.9rem; color: var(--color-brand); }

.mult-ctrl { display: flex; align-items: center; gap: 6px; }
.mult-val { font-weight: 700; min-width: 36px; text-align: center; font-size: 0.95rem; }

.masse-total-row {
	display: flex;
	gap: 8px;
	flex-wrap: wrap;
	margin-top: 14px;
	padding-top: 12px;
	border-top: 1px solid var(--color-border);
}
.masse-chip {
	background: var(--color-surface-2);
	border-radius: var(--radius-full);
	padding: 5px 12px;
	font-size: 0.82rem;
	color: var(--color-text);
	display: flex;
	align-items: center;
	gap: 4px;
}

.nb-pieces-edit {
	margin-top: 10px;
}

.photos-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
	gap: 8px;
	margin-top: 8px;
}
.photo-thumb {
	position: relative;
	aspect-ratio: 1;
	border-radius: var(--radius-md);
	overflow: hidden;
	background: var(--color-surface-2);
}
.photo-thumb img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}
.photo-actions {
	position: absolute;
	top: 4px;
	right: 4px;
	display: flex;
	gap: 4px;
	opacity: 0;
	transition: opacity 0.15s;
}
.photo-thumb:hover .photo-actions { opacity: 1; }
.photo-btn {
	background: rgba(0,0,0,0.55);
	border: none;
	border-radius: var(--radius-sm);
	color: #fff;
	font-size: 0.85rem;
	width: 28px;
	height: 28px;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
}

/* Modals */
.modal-overlay {
	position: fixed;
	inset: 0;
	background: rgba(0,0,0,0.5);
	display: flex;
	align-items: flex-end;
	justify-content: center;
	z-index: 600;
	padding: 0 0 var(--safe-bottom);
}
@media (min-width: 640px) {
	.modal-overlay { align-items: center; }
}
.modal-box {
	background: var(--color-surface);
	border-radius: var(--radius-lg) var(--radius-lg) 0 0;
	padding: 20px 16px;
	width: 100%;
	max-width: 480px;
	max-height: 85dvh;
	overflow-y: auto;
}
@media (min-width: 640px) {
	.modal-box { border-radius: var(--radius-lg); max-height: 70dvh; }
}
.modal-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 14px;
}
.modal-title { font-size: 1rem; font-weight: 700; margin: 0; }
.modal-close {
	background: none;
	border: none;
	font-size: 1.4rem;
	cursor: pointer;
	color: var(--color-text-3);
	line-height: 1;
	padding: 4px;
}
</style>

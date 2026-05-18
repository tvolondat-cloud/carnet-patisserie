<script>
import { recettes } from '$lib/stores/recettes.js';
import { progression } from '$lib/stores/progression.js';
import { isPro } from '$lib/stores/auth.js';
import { events } from '$lib/analytics.js';
import recipesData from '$lib/data/recipes.json';

const categories = recipesData.categories;

let filterCat = 'all';
let onlyMaitrisees = false;
let generating = false;

$: filtered = $recettes.filter(r => {
	if (filterCat !== 'all' && r.categorie !== filterCat) return false;
	if (onlyMaitrisees && $progression[r.id]?.statut !== 'maitrisee') return false;
	return true;
});

async function generatePDF() {
	generating = true;
	events.pdfExported(filtered.length, onlyMaitrisees);
	try {
		const { jsPDF } = await import('jspdf');
		const doc = new jsPDF({ unit: 'mm', format: 'a4', orientation: 'portrait' });

		const BERRY = [125, 35, 51];
		const BEIGE = [245, 240, 232];
		const MARGIN_L = 30;
		const PAGE_W = 210;
		const CONTENT_W = PAGE_W - MARGIN_L - 10;

		let y = 20;

		// Titre
		doc.setFillColor(...BERRY);
		doc.rect(0, 0, PAGE_W, 20, 'F');
		doc.setTextColor(255, 255, 255);
		doc.setFontSize(16);
		doc.setFont('helvetica', 'bold');
		doc.text('Carnet de Recettes CAP Pâtissier', PAGE_W / 2, 13, { align: 'center' });
		y = 28;

		for (const recette of filtered) {
			const ings = recette.ingredients ?? [];
			const estHeight = 32 + ings.length * 5 + 10;

			if (y + estHeight > 280) {
				doc.addPage();
				y = 15;
			}

			// Encart beige titre
			doc.setFillColor(...BEIGE);
			doc.roundedRect(MARGIN_L, y, CONTENT_W, 12, 2, 2, 'F');
			doc.setTextColor(...BERRY);
			doc.setFontSize(11);
			doc.setFont('helvetica', 'bold');
			doc.text(recette.nom, MARGIN_L + 4, y + 8);

			// EP + temps
			doc.setFontSize(8);
			doc.setTextColor(100, 100, 100);
			doc.setFont('helvetica', 'normal');
			doc.text(`${recette.ep} · ${recette.temps} min`, MARGIN_L + CONTENT_W - 4, y + 8, { align: 'right' });
			y += 14;

			// Ingrédients
			doc.setFontSize(8);
			doc.setTextColor(30, 41, 59);
			const cols = 3;
			const colW = CONTENT_W / cols;
			const ingChunks = [];
			for (let i = 0; i < ings.length; i += cols) ingChunks.push(ings.slice(i, i + cols));

			for (const chunk of ingChunks) {
				for (let ci = 0; ci < chunk.length; ci++) {
					const ing = chunk[ci];
					doc.text(`• ${ing.nom}: ${ing.quantite}${ing.unite}`, MARGIN_L + ci * colW, y);
				}
				y += 5;
			}

			// Notes
			if (recette.notes?.trim()) {
				doc.setTextColor(100, 100, 100);
				doc.setFontSize(7);
				const lines = doc.splitTextToSize(`📝 ${recette.notes}`, CONTENT_W);
				doc.text(lines.slice(0, 2), MARGIN_L, y);
				y += lines.slice(0, 2).length * 4;
			}

			y += 6;
		}

		doc.save(`carnet-patissier-${new Date().toLocaleDateString('fr-FR').replace(/\//g, '-')}.pdf`);
	} catch (e) {
		console.error(e);
		alert('Erreur lors de la génération du PDF');
	} finally {
		generating = false;
	}
}
</script>

<div class="page">
	<h1 class="page-title">📄 Carnet PDF</h1>
	<p class="page-subtitle">Exporte tes recettes au format A4 (classeur 3 trous)</p>

	{#if !$isPro}
	<!-- Paywall carnet PDF -->
	<div class="paywall-card">
		<div class="paywall-icon">📄</div>
		<div class="paywall-title">Carnet PDF · Fonctionnalité Pro</div>
		<p class="paywall-desc">
			Le carnet imprimable avec les 58 recettes CAP (format A4, Berry Jam, classeur 3 trous)
			est disponible avec le plan Pro.
		</p>
		<div class="paywall-features">
			<span>✓ 58 recettes CAP complètes</span>
			<span>✓ Format A4 · Marge 3 cm · Berry Jam</span>
			<span>✓ Filtres par catégorie</span>
		</div>
		<a href="/profil#plan" class="btn btn-primary btn-block" style="margin-top:16px">Passer au plan Pro →</a>
		<p class="paywall-note">7 jours d'essai gratuit · Annulable à tout moment</p>
	</div>
	{:else}
	<div class="card mb-3">
		<div class="section-title mb-3">Filtres</div>

		<div class="form-group">
			<label class="label">Catégorie</label>
			<select class="input" bind:value={filterCat}>
				<option value="all">Toutes les catégories</option>
				{#each categories as cat}
				<option value={cat.id}>{cat.emoji} {cat.label}</option>
				{/each}
			</select>
		</div>

		<label style="display:flex;align-items:center;gap:10px;cursor:pointer">
			<input type="checkbox" bind:checked={onlyMaitrisees} style="width:18px;height:18px;accent-color:var(--color-brand)">
			<span class="text-sm font-medium">Seulement les recettes maîtrisées</span>
		</label>
	</div>

	<div class="card mb-3" style="text-align:center;padding:20px">
		<div style="font-size:2rem;margin-bottom:8px">📄</div>
		<div style="font-size:1.3rem;font-weight:800;color:var(--color-brand)">{filtered.length}</div>
		<div class="text-sm text-muted">recettes à exporter</div>
	</div>

	<button
		class="btn btn-primary btn-block btn-lg"
		on:click={generatePDF}
		disabled={generating || filtered.length === 0}>
		{generating ? '⏳ Génération...' : '📥 Générer le PDF'}
	</button>

	<div class="card mt-3">
		<p class="text-sm text-muted">
			Le PDF est généré entièrement dans ton navigateur.
			Format A4, marge gauche 3cm pour perforation classeur 3 trous.
			Couleur catégories : Berry Jam.
		</p>
	</div>
	{/if}
</div>

<style>
.paywall-card {
	text-align: center;
	padding: 40px 24px;
	background: var(--color-surface);
	border: 2px dashed var(--color-border);
	border-radius: var(--radius-xl);
}
.paywall-icon { font-size: 2.8rem; margin-bottom: 12px; }
.paywall-title { font-size: 1.2rem; font-weight: 800; color: var(--color-text); margin-bottom: 10px; }
.paywall-desc { font-size: 0.9rem; color: var(--color-text-2); line-height: 1.55; margin: 0 0 16px; }
.paywall-features {
	display: flex;
	flex-direction: column;
	gap: 6px;
	font-size: 0.85rem;
	color: var(--color-text-2);
	text-align: left;
	max-width: 260px;
	margin: 0 auto;
}
.paywall-note {
	font-size: 0.78rem;
	color: var(--color-text-3);
	margin: 8px 0 0;
}
</style>

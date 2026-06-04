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

let pdfPaywallTracked = false;
$: if (!$isPro && !pdfPaywallTracked) { events.paywallViewed('carnet-pdf'); pdfPaywallTracked = true; }

$: filtered = $recettes.filter(r => {
	if (filterCat !== 'all' && r.categorie !== filterCat) return false;
	if (onlyMaitrisees && $progression[r.id]?.statut !== 'maitrisee') return false;
	return true;
});

// ─────────────────────────────────────────────────────────────
// PDF conforme arrêté du 3 oct 2022 (CAP Pâtissier) :
//   ✓ Titre + ingrédients + quantités (une seule version par ingrédient)
//   ✗ Aucune méthode, technique, température, conseil
// ─────────────────────────────────────────────────────────────

// Heuristique : trier les ingrédients selon leur 1ʳᵉ apparition dans
// les étapes (ordre d'utilisation = aide pédagogique pour l'étudiant).
function normalize(s) {
	return (s ?? '').toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '');
}
const STOPWORDS = new Set(['de','des','du','la','le','les','d','à','au','aux','et','en','un','une']);

function firstMention(text, name) {
	const words = normalize(name).replace(/[(),.%/]/g, ' ').split(/\s+/).filter((w) => w.length >= 3 && !STOPWORDS.has(w));
	let earliest = Infinity;
	for (const w of words) {
		const i = text.indexOf(w);
		if (i !== -1 && i < earliest) earliest = i;
	}
	return earliest === Infinity ? Number.MAX_SAFE_INTEGER : earliest;
}

function orderIngredientsByUse(ings, etapes) {
	if (!ings?.length || !etapes?.length) return ings ?? [];
	const sorted = [...etapes].sort((a, b) => (a.ordre || 0) - (b.ordre || 0));
	const text = sorted.map((s) => normalize(s.description || '')).join(' ');
	const withIdx = ings.map((ing, i) => ({ ing, originalIdx: i, hit: firstMention(text, ing.nom) }));
	withIdx.sort((a, b) => a.hit - b.hit || a.originalIdx - b.originalIdx);
	return withIdx.map((x) => x.ing);
}

// Conversion en grammes (ce qui peut entrer dans MASSE TOTALE).
function toRow(ing) {
	const unite = (ing.unite || '').toLowerCase();
	const nom = (ing.nom || '').toUpperCase();
	const qty = Number(ing.quantite) || 0;
	if (unite === 'g')  return { qty, unit: 'GR', name: nom, inTotal: true };
	if (unite === 'kg') return { qty: qty * 1000, unit: 'GR', name: nom, inTotal: true };
	// 1 œuf entier ≈ 50 g (normalisation classique CAP)
	if (unite === 'u' && /(œuf|oeuf)/i.test(nom)) {
		return { qty: qty * 50, unit: 'GR', name: nom, inTotal: true };
	}
	return { qty, unit: 'PC', name: nom, inTotal: false };
}

async function generatePDF() {
	generating = true;
	events.pdfExported(filtered.length, onlyMaitrisees);
	try {
		const { jsPDF } = await import('jspdf');
		const doc = new jsPDF({ unit: 'mm', format: 'a4', orientation: 'portrait' });

		// ── Couleurs (palette magenta de référence) ──
		const MAGENTA = [232, 38, 99];
		const TEXT_DARK = [25, 25, 25];
		const TEXT_GRAY = [120, 120, 120];
		const BORDER = [220, 220, 220];

		// ── Géométrie ──
		const PAGE_W = 210, PAGE_H = 297;
		const M_LEFT = 12, M_RIGHT = 12, M_TOP = 16, M_BOTTOM = 16;
		const CONTENT_W = PAGE_W - M_LEFT - M_RIGHT;
		const COL_GAP = 5;
		const ROW_GAP = 6;
		const COLS = 3;
		const CARD_W = (CONTENT_W - (COLS - 1) * COL_GAP) / COLS;

		// Dimensions d'une carte (hauteur dépend du nb d'ingrédients)
		const H_TITLE = 8;
		const H_SEP = 2;
		const H_ROW = 4.6;
		const H_TOTAL = 6;
		const cardHeight = (rows) => H_TITLE + H_SEP + rows * H_ROW + H_TOTAL + 1;

		// Texte ingrédient/total : 3 colonnes intra-carte
		const COL1_X = 1.5;  // qté (droite)
		const COL1_W = 9;
		const COL2_X = COL1_X + COL1_W + 1;  // unité
		const COL2_W = 6;
		const COL3_X = COL2_X + COL2_W + 1;  // nom

		// ── Page de garde ──
		function drawCover() {
			doc.setFont('helvetica', 'bold');
			doc.setFillColor(...MAGENTA);
			doc.rect(M_LEFT, 110, CONTENT_W, 22, 'F');
			doc.setTextColor(255, 255, 255);
			doc.setFontSize(22);
			doc.text('MON CARNET DE RECETTES', PAGE_W / 2, 124.5, { align: 'center' });

			doc.setTextColor(...TEXT_DARK);
			doc.setFont('helvetica', 'normal');
			doc.setFontSize(11);
			doc.text('CAP PÂTISSIER — CONFORME AU RÉFÉRENTIEL OFFICIEL', PAGE_W / 2, 142, { align: 'center' });

			doc.setFontSize(9);
			doc.setTextColor(...TEXT_GRAY);
			doc.setFont('helvetica', 'italic');
			doc.text("Ingrédients et quantités uniquement · Conforme à l'arrêté du 3 octobre 2022", PAGE_W / 2, 149, { align: 'center' });

			// Bloc compliance (4 cases)
			const blockX = M_LEFT + 30, blockY = 175, blockW = CONTENT_W - 60;
			const cellH = 10;
			doc.setDrawColor(...BORDER);
			doc.setLineWidth(0.2);
			doc.rect(blockX, blockY, blockW, cellH * 2);
			doc.line(blockX, blockY + cellH, blockX + blockW, blockY + cellH); // séparation horizontale
			doc.line(blockX + blockW / 2, blockY, blockX + blockW / 2, blockY + cellH * 2); // séparation verticale

			doc.setFont('helvetica', 'normal');
			doc.setFontSize(8.5);
			const ok = [16, 120, 60];      // vert
			const ko = [200, 35, 60];     // rouge
			const cells = [
				{ x: blockX + 3, y: blockY + 6.5, color: ok, label: '■ Titre de la recette' },
				{ x: blockX + blockW / 2 + 3, y: blockY + 6.5, color: ok, label: '■ Liste des ingrédients' },
				{ x: blockX + 3, y: blockY + cellH + 6.5, color: ok, label: '■ Quantités (une seule version)' },
				{ x: blockX + blockW / 2 + 3, y: blockY + cellH + 6.5, color: ko, label: '■ Aucune méthode ni technique' }
			];
			for (const c of cells) {
				doc.setTextColor(...c.color);
				doc.text(c.label, c.x, c.y);
			}
		}

		// ── Bandeau de catégorie ──
		function drawCategoryBand(label) {
			const y = M_TOP;
			const bandH = 9;
			doc.setFillColor(...MAGENTA);
			doc.rect(M_LEFT, y, CONTENT_W, bandH, 'F');
			doc.setTextColor(255, 255, 255);
			doc.setFont('helvetica', 'bold');
			doc.setFontSize(12);
			doc.text(`· ${label.toUpperCase()} ·`, PAGE_W / 2, y + 6.2, { align: 'center' });
			return y + bandH + 4; // y de départ pour la grille
		}

		// ── Carte recette ──
		function drawCard(recette, x, y) {
			const ordered = orderIngredientsByUse(recette.ingredients ?? [], recette.etapes ?? []);
			const rows = ordered.map(toRow);
			const total = rows.filter((r) => r.inTotal).reduce((s, r) => s + r.qty, 0);
			const totalRounded = Math.round(total);

			// Titre carte (header magenta)
			doc.setFillColor(...MAGENTA);
			doc.rect(x, y, CARD_W, H_TITLE, 'F');
			doc.setTextColor(255, 255, 255);
			doc.setFont('helvetica', 'bold');
			doc.setFontSize(8.5);
			const titre = recette.nom.toUpperCase();
			doc.text(titre, x + CARD_W / 2, y + 5.4, { align: 'center', maxWidth: CARD_W - 4 });

			// Bordure carte
			doc.setDrawColor(...BORDER);
			doc.setLineWidth(0.25);
			const cardH = cardHeight(rows.length);
			doc.rect(x, y, CARD_W, cardH);
			// ligne de séparation sous le header (le rect du fill a déjà couvert)
			doc.line(x, y + H_TITLE, x + CARD_W, y + H_TITLE);

			// Lignes ingrédients
			let rowY = y + H_TITLE + H_SEP + 3.6;
			for (const r of rows) {
				// Qty
				doc.setFont('helvetica', 'bold');
				doc.setFontSize(7.5);
				doc.setTextColor(...TEXT_DARK);
				const qStr = Number.isInteger(r.qty) ? String(r.qty) : r.qty.toFixed(1).replace(/\.0$/, '');
				doc.text(qStr, x + COL1_X + COL1_W, rowY, { align: 'right' });
				// Unit
				doc.setFont('helvetica', 'normal');
				doc.setFontSize(6.5);
				doc.setTextColor(...TEXT_GRAY);
				doc.text(r.unit, x + COL2_X, rowY);
				// Name
				doc.setFontSize(7);
				doc.setTextColor(...TEXT_DARK);
				doc.text(r.name, x + COL3_X, rowY, { maxWidth: CARD_W - COL3_X - 1.5 });
				rowY += H_ROW;
			}

			// Ligne de séparation totale
			doc.setDrawColor(...BORDER);
			doc.line(x + 1, rowY - H_ROW + H_ROW - 1.5, x + CARD_W - 1, rowY - H_ROW + H_ROW - 1.5);

			// Total
			rowY += 1.5;
			doc.setFont('helvetica', 'bold');
			doc.setFontSize(7.8);
			doc.setTextColor(...TEXT_DARK);
			doc.text(String(totalRounded), x + COL1_X + COL1_W, rowY, { align: 'right' });
			doc.setFontSize(6.8);
			doc.text('GR', x + COL2_X, rowY);
			doc.setFontSize(7.5);
			doc.text('MASSE TOTALE', x + COL3_X, rowY);

			return cardH;
		}

		// ── 1. Page de garde ──
		drawCover();

		// ── 2. Pages par catégorie ──
		// Grouper les recettes filtrées par catégorie, dans l'ordre des catégories
		// de recipes.json (catégories qui n'ont pas de recette filtrée sont sautées).
		const byCat = new Map();
		for (const r of filtered) {
			if (!byCat.has(r.categorie)) byCat.set(r.categorie, []);
			byCat.get(r.categorie).push(r);
		}

		for (const cat of categories) {
			const list = byCat.get(cat.id);
			if (!list?.length) continue;
			doc.addPage();
			let y = drawCategoryBand(cat.label);

			// Layout en grille 3 colonnes
			let col = 0;
			let rowMaxH = 0;
			let xRow = M_LEFT;

			for (const r of list) {
				const ordered = orderIngredientsByUse(r.ingredients ?? [], r.etapes ?? []);
				const projectedH = cardHeight(ordered.length);

				// Doit-on aller à la ligne suivante ?
				if (col === COLS) {
					y += rowMaxH + ROW_GAP;
					col = 0;
					xRow = M_LEFT;
					rowMaxH = 0;
				}

				// Doit-on changer de page ? (la carte projetée dépasse)
				if (y + projectedH > PAGE_H - M_BOTTOM) {
					doc.addPage();
					y = M_TOP; // pas de re-bandeau : continuation de la même catégorie
					col = 0;
					xRow = M_LEFT;
					rowMaxH = 0;
				}

				const x = M_LEFT + col * (CARD_W + COL_GAP);
				const h = drawCard(r, x, y);
				rowMaxH = Math.max(rowMaxH, h);
				col += 1;
			}
		}

		const date = new Date().toLocaleDateString('fr-FR').replace(/\//g, '-');
		doc.save(`carnet-cap-${date}.pdf`);
	} catch (e) {
		console.error(e);
		alert('Erreur lors de la génération du PDF');
	} finally {
		generating = false;
	}
}
</script>

<div class="page">
	<h1 class="page-title">📄 Mon carnet de recettes</h1>
	<p class="page-subtitle">Export PDF conforme arrêté du 3 octobre 2022 (CAP Pâtissier)</p>

	{#if !$isPro}
	<!-- Paywall carnet PDF -->
	<div class="paywall-card">
		<div class="paywall-icon">📄</div>
		<div class="paywall-title">Carnet PDF · Fonctionnalité Pro</div>
		<p class="paywall-desc">
			Le carnet imprimable conforme au référentiel CAP (format A4, autorisé en EP1/EP2)
			est disponible avec le plan Pro.
		</p>
		<div class="paywall-features">
			<span>✓ Conforme arrêté 3 oct 2022 (titre + ingrédients + quantités)</span>
			<span>✓ Ingrédients dans l'ordre d'utilisation</span>
			<span>✓ Format A4, 3 recettes par ligne</span>
		</div>
		<a href="/profil#plan" class="btn btn-primary btn-block" style="margin-top:16px" on:click={() => events.upgradeClicked('carnet-pdf-paywall')}>Voir le plan Pro →</a>
		<p class="paywall-note">Plan Pro bientôt disponible</p>
	</div>
	{:else}
	<div class="card mb-3 conformite">
		<div class="section-title mb-2">📋 Conformité examen</div>
		<ul class="conformite-list">
			<li><span class="ok">✓</span> Titre de la recette</li>
			<li><span class="ok">✓</span> Liste des ingrédients</li>
			<li><span class="ok">✓</span> Quantités (une seule version par ingrédient)</li>
			<li><span class="ko">✗</span> Aucune méthode, technique ou température</li>
		</ul>
		<p class="text-xs text-muted mt-2">
			Format autorisé en EP1 et EP2. Imprime, mets en classeur, c'est conforme à l'arrêté.
		</p>
	</div>

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
			Génération 100 % dans ton navigateur (aucune donnée n'est envoyée).
			Les <strong>ingrédients sont listés dans l'ordre d'utilisation</strong> dans la recette —
			plus facile à suivre les mains dans la pâte.
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
	max-width: 320px;
	margin: 0 auto;
}
.paywall-note {
	font-size: 0.78rem;
	color: var(--color-text-3);
	margin: 8px 0 0;
}

.conformite { background: rgba(16, 185, 129, 0.05); border-color: rgba(16, 185, 129, 0.25); }
.conformite-list {
	list-style: none;
	padding: 0;
	margin: 0;
	display: flex;
	flex-direction: column;
	gap: 4px;
	font-size: 0.85rem;
}
.conformite-list .ok { color: var(--color-maitrisee); font-weight: 800; margin-right: 6px; }
.conformite-list .ko { color: #ef4444; font-weight: 800; margin-right: 6px; }
</style>

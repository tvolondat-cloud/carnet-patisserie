<script>
import { onMount } from 'svelte';
import { recettes } from '$lib/stores/recettes.js';
import { progression } from '$lib/stores/progression.js';
import { slugify } from '$lib/utils/slugify.js';
import fichesData from '$lib/data/fiches-cap.json';
import questionsData from '$lib/data/questions-examen.json';
import { readScores, averagePct, gradeOn20 } from '$lib/utils/exam-scores.js';

const ficheCount = fichesData.fiches.length;
const questionCount = questionsData.questions.length;

const statutColor = {
	'a-tester': 'var(--color-a-tester)',
	testee: 'var(--color-testee)',
	validee: 'var(--color-validee)'
};

$: aTester  = $recettes.filter(r => !$progression[r.id] || $progression[r.id].statut === 'a-tester');
$: testees  = $recettes.filter(r => $progression[r.id]?.statut === 'testee');
$: validees = $recettes.filter(r => $progression[r.id]?.statut === 'validee');
$: allMastered = aTester.length === 0 && testees.length === 0 && validees.length === 0;

let examScores = {};
onMount(() => {
	examScores = readScores();
});
$: examCount = Object.keys(examScores).length;
$: examAvg   = averagePct(examScores);
</script>

<svelte:head>
	<title>Réviser — Brigade Sucrée</title>
</svelte:head>

<div class="page">
	<h1 class="page-title">📚 Réviser</h1>
	<p class="page-subtitle">Fiches, QCM et Mode Labo</p>

	<!-- Modules de révision -->
	<a href="/fiches" class="module-card">
		<span class="module-icon">📖</span>
		<div class="module-body">
			<div class="module-title">Fiches CAP</div>
			<div class="module-sub">{ficheCount} fiches · référentiel officiel</div>
		</div>
		<span class="module-chevron">›</span>
	</a>

	<a href="/reviser/examen" class="module-card">
		<span class="module-icon">🎯</span>
		<div class="module-body">
			<div class="module-title">Examen blanc</div>
			<div class="module-sub">{questionCount} QCM · entraînement par thème</div>
			{#if examCount > 0}
			<div class="module-score">Moyenne : {gradeOn20(examAvg)}/20 · {examCount} thème{examCount > 1 ? 's' : ''}</div>
			{/if}
		</div>
		<span class="module-chevron">›</span>
	</a>

	<!-- Mode Labo -->
	<div class="section-header" style="margin-top:24px;margin-bottom:12px">
		<span class="section-title">🧪 Mode Labo</span>
	</div>

	{#if allMastered}
	<div class="empty-state">
		<div class="empty-state-emoji">⭐</div>
		<div class="empty-state-title">Toutes maîtrisées !</div>
		<div class="empty-state-desc">Tu as maîtrisé toutes tes recettes. Excellent travail !</div>
	</div>
	{:else}
	{#each [['📋 À tester', aTester, 'a-tester'], ['🧪 À valider', testees, 'testee'], ['✅ À maîtriser', validees, 'validee']] as [label, recs, key]}
	{#if recs.length}
	<div class="card mb-3">
		<div class="section-title mb-2" style="color:{statutColor[key]}">{label} ({recs.length})</div>
		{#each recs as r}
		<div class="recipe-row">
			<div>
				<div style="font-size:0.9rem;font-weight:600">{r.nom}</div>
				<div class="text-xs text-muted">⏱ {r.temps} min · {r.ep}</div>
			</div>
			<a href="/laboratoire/{slugify(r.nom)}" class="btn btn-primary btn-sm">🧪 Labo</a>
		</div>
		{/each}
	</div>
	{/if}
	{/each}
	{/if}
</div>

<style>
.module-card {
	display: flex;
	align-items: center;
	gap: 16px;
	background: var(--color-surface);
	border: 1px solid var(--color-border);
	border-radius: var(--radius-lg);
	padding: 16px;
	text-decoration: none;
	color: inherit;
	margin-bottom: 12px;
	transition: border-color 0.15s, box-shadow 0.15s;
}
.module-card:hover {
	border-color: var(--color-brand);
	box-shadow: 0 4px 12px rgba(0,0,0,0.06);
}
.module-icon  { font-size: 2rem; line-height: 1; flex-shrink: 0; }
.module-body  { flex: 1; min-width: 0; }
.module-title { font-size: 1rem; font-weight: 700; margin-bottom: 2px; }
.module-sub   { font-size: 0.82rem; color: var(--color-text-2); }
.module-score { font-size: 0.8rem; color: var(--color-brand); font-weight: 600; margin-top: 3px; }
.module-chevron { font-size: 1.5rem; color: var(--color-text-3); flex-shrink: 0; }

.recipe-row {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 10px 0;
	border-bottom: 1px solid var(--color-border);
}
.recipe-row:last-child { border-bottom: none; }
</style>

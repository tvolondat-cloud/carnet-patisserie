<script>
import { onMount } from 'svelte';
import { recettes } from '$lib/stores/recettes.js';
import { stats, progression } from '$lib/stores/progression.js';
import recipesData from '$lib/data/recipes.json';
import { slugify } from '$lib/utils/slugify.js';
import { averagePct, gradeOn20, statusFor } from '$lib/utils/exam-scores.js';
import { examScores, loadExamScores } from '$lib/stores/exam.js';

const competences = recipesData.competences;

const statutLabel = { 'a-tester': 'À tester', testee: 'Testée', validee: 'Validée', maitrisee: 'Maîtrisée' };
const statutColor = { 'a-tester': 'var(--color-a-tester)', testee: 'var(--color-testee)', validee: 'var(--color-validee)', maitrisee: 'var(--color-maitrisee)' };

// Examen blanc — store Supabase (sync multi-device)
onMount(loadExamScores);
$: examCount  = Object.keys($examScores).length;
$: examAvg    = averagePct($examScores);          // % (peut être null)
$: examGrade  = examAvg == null ? null : gradeOn20(examAvg); // /20
$: examStatus = statusFor(examAvg);              // 'pending' | 'green' | 'orange' | 'red'
</script>

<div class="page">
	<h1 class="page-title">📊 Suivi</h1>
	<p class="page-subtitle">Ta progression CAP</p>

	<!-- Score global -->
	<div class="card" style="display:flex;align-items:center;gap:20px;margin-bottom:16px">
		<div class="score-ring" style="background:conic-gradient(var(--color-brand) {$stats.score * 3.6}deg, var(--color-surface-2) 0deg)">
			<div class="score-ring-inner">
				<div class="score-number">{$stats.score}<span style="font-size:1rem">%</span></div>
				<div class="score-label">maîtrisé</div>
			</div>
		</div>
		<div>
			<div style="font-size:0.85rem;font-weight:600;margin-bottom:8px">{$stats.maitrisees} / {$stats.total} recettes</div>
			{#each [['a-tester','📋'],['testee','🧪'],['validee','✅'],['maitrisee','⭐']] as [k, emoji]}
			<div style="display:flex;align-items:center;gap:6px;margin-bottom:4px">
				<span style="font-size:0.72rem;width:70px;color:{statutColor[k]};font-weight:500">{emoji} {statutLabel[k]}</span>
				<div class="progress-bar-container" style="flex:1;height:6px">
					<div class="progress-bar-fill" style="width:{$stats.total ? ($stats.byStatut[k]??0)/$stats.total*100 : 0}%;background:{statutColor[k]}"></div>
				</div>
				<span style="font-size:0.72rem;color:var(--color-text-2);width:16px;text-align:right">{$stats.byStatut[k]??0}</span>
			</div>
			{/each}
		</div>
	</div>

	<!-- Examen blanc -->
	<a href="/reviser/examen" class="card mb-3 exam-card exam-{examStatus}" aria-label="Examen blanc — voir détail">
		<div class="exam-head">
			<span class="exam-emoji" aria-hidden="true">🎯</span>
			<div class="exam-title">Examen blanc</div>
			{#if examGrade != null}
			<span class="exam-grade">{examGrade}<small>/20</small></span>
			{/if}
		</div>
		<div class="exam-meta">
			{#if examCount === 0}
				Aucun thème encore passé — teste tes connaissances.
			{:else}
				Moyenne sur {examCount} thème{examCount > 1 ? 's' : ''} complété{examCount > 1 ? 's' : ''} · {examAvg}%
			{/if}
		</div>
	</a>

	<!-- Compétences -->
	<div class="card mb-3">
		<div class="section-title mb-3">Compétences CAP</div>
		{#each competences as comp}
		{@const pct = $stats.competences[comp.id] ?? 0}
		<div class="skill-bar">
			<div class="skill-bar-label">
				<span>{comp.emoji} {comp.label}</span>
				<span style="color:{comp.color};font-weight:700">{pct}%</span>
			</div>
			<div class="skill-bar-track">
				<div class="skill-bar-fill" style="width:{pct}%;background:{comp.color}"></div>
			</div>
		</div>
		{/each}
	</div>

	<!-- Toutes les recettes par statut -->
	{#each ['maitrisee','validee','testee','a-tester'] as statut}
	{@const recs = $recettes.filter(r => ($progression[r.id]?.statut ?? 'a-tester') === statut)}
	{#if recs.length}
	<div class="card mb-3">
		<div class="section-title mb-2" style="color:{statutColor[statut]}">{statutLabel[statut]} ({recs.length})</div>
		{#each recs as r}
		<a href="/recettes/{slugify(r.nom)}" style="display:block;padding:8px 0;border-bottom:1px solid var(--color-border);font-size:0.9rem">
			{r.nom}
		</a>
		{/each}
	</div>
	{/if}
	{/each}
</div>

<style>
.exam-card {
	display: block;
	text-decoration: none;
	color: inherit;
	border-left: 4px solid var(--color-border);
	transition: border-color 0.15s, background 0.15s, transform 0.15s;
}
.exam-card:hover { transform: translateY(-1px); }
.exam-card.exam-green   { border-left-color: var(--color-maitrisee); background: rgba(16, 185, 129, 0.04); }
.exam-card.exam-orange  { border-left-color: var(--color-testee);    background: rgba(245, 158, 11, 0.05); }
.exam-card.exam-red     { border-left-color: #ef4444;                background: rgba(239, 68, 68, 0.04); }

.exam-head {
	display: flex;
	align-items: center;
	gap: 10px;
}
.exam-emoji { font-size: 1.3rem; flex-shrink: 0; }
.exam-title {
	flex: 1;
	font-size: 0.95rem;
	font-weight: 800;
	color: var(--color-text);
}
.exam-grade {
	font-size: 1.45rem;
	font-weight: 900;
	font-variant-numeric: tabular-nums;
	color: var(--color-text-2);
}
.exam-card.exam-green  .exam-grade { color: var(--color-maitrisee); }
.exam-card.exam-orange .exam-grade { color: var(--color-testee); }
.exam-card.exam-red    .exam-grade { color: #ef4444; }
.exam-grade small { font-size: 0.65em; font-weight: 700; opacity: 0.6; margin-left: 1px; }

.exam-meta {
	font-size: 0.82rem;
	color: var(--color-text-2);
	margin-top: 6px;
	line-height: 1.45;
}
</style>

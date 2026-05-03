<script>
import { page } from '$app/stores';
import { goto } from '$app/navigation';
import { recettes } from '$lib/stores/recettes.js';
import { progression, updateProgression } from '$lib/stores/progression.js';
import { events } from '$lib/analytics.js';
import { onMount, onDestroy } from 'svelte';

$: id = $page.params.id;
$: recette = $recettes.find(r => r.id === id);
$: p = $progression[id];

let labStartTracked = false;
$: if (recette && !labStartTracked) {
	events.labStarted(id);
	labStartTracked = true;
}

let step = 0; // 0=tester, 1=quiz, 2=chrono
let tested = false;

// Quiz
let quizAnswers = {};
let quizSubmitted = false;
let quizScore = 0;

// Chrono
let chronoRunning = false;
let chronoSeconds = 0;
let chronoInterval;
let chronoValidated = false;

$: questions = recette?.quiz_questions ?? [];
$: chronoCible = recette?.chrono_cible ?? 30;

$: quizPass = quizScore >= 75;
$: chronoPass = chronoSeconds > 0 && chronoSeconds <= chronoCible * 60 * 1.2;

$: allDone = tested && quizPass && chronoPass;

onDestroy(() => clearInterval(chronoInterval));

function startChrono() {
	chronoRunning = true;
	chronoInterval = setInterval(() => chronoSeconds++, 1000);
}

function stopChrono() {
	clearInterval(chronoInterval);
	chronoRunning = false;
	const cibleSec = chronoCible * 60;
	chronoValidated = chronoSeconds <= cibleSec * 1.2;
	updateProgression(id, { chrono_seconds: chronoSeconds, chrono_valide: chronoValidated });
	events.labChronoCompleted(id, chronoSeconds, chronoValidated);
}

function resetChrono() {
	clearInterval(chronoInterval);
	chronoRunning = false;
	chronoSeconds = 0;
	chronoValidated = false;
}

function submitQuiz() {
	let correct = 0;
	for (const q of questions) {
		if (quizAnswers[q.id] === q.bonne) correct++;
	}
	quizScore = questions.length ? Math.round((correct / questions.length) * 100) : 0;
	quizSubmitted = true;
	updateProgression(id, { quiz_score: quizScore });
	events.labQuizCompleted(id, quizScore, quizScore >= 75);
}

function markTested() {
	tested = true;
	updateProgression(id, { tested: true, statut: 'testee' });
	step = 1;
}

async function finishLab() {
	if (allDone) {
		await updateProgression(id, { statut: 'maitrisee' });
		if (recette) events.recipeMastered(recette);
	}
	goto(`/recettes/${id}`);
}

function fmt(s) {
	const m = Math.floor(s / 60);
	const sec = s % 60;
	return `${m}:${sec.toString().padStart(2, '0')}`;
}
</script>

{#if !recette}
<div class="page"><div class="spinner" style="margin-top:48px"></div></div>
{:else}
<div class="page">
	<div style="display:flex;align-items:center;gap:12px;margin-bottom:16px">
		<button class="btn btn-ghost btn-sm" on:click={() => goto(`/recettes/${id}`)}>← Retour</button>
	</div>

	<h1 class="page-title">🧪 Mode Labo</h1>
	<p class="page-subtitle">{recette.nom}</p>

	<!-- Stepper -->
	<div class="stepper">
		{#each ['Tester','Quiz','Chrono'] as label, i}
		<div class="step" class:active={step === i} class:done={step > i || (i === 0 && tested) || (i === 1 && quizSubmitted) || (i === 2 && chronoValidated)}>
			<div class="step-circle">
				{#if (i === 0 && tested) || (i === 1 && quizSubmitted && quizPass) || (i === 2 && chronoValidated)}✓
				{:else}{i + 1}{/if}
			</div>
			<span class="step-label">{label}</span>
		</div>
		{/each}
	</div>

	<!-- STEP 0 : TESTER -->
	{#if step === 0}
	<div class="card">
		<div class="section-title mb-3">Réalise la recette</div>
		<p class="text-sm text-muted mb-3">Suis les étapes de la recette et coche quand tu as terminé.</p>
		<ol style="list-style:none;display:flex;flex-direction:column;gap:12px;margin-bottom:20px">
			{#each (recette.etapes ?? []).sort((a,b) => a.ordre - b.ordre) as e}
			<li style="display:flex;gap:12px">
				<div style="width:24px;height:24px;border-radius:50%;background:var(--color-brand);color:#fff;font-size:0.72rem;font-weight:700;display:flex;align-items:center;justify-content:center;flex-shrink:0">{e.ordre}</div>
				<p class="text-sm" style="line-height:1.5;padding-top:3px">{e.description}</p>
			</li>
			{/each}
		</ol>
		<button class="btn btn-primary btn-block btn-lg" on:click={markTested}>
			✅ J'ai réalisé la recette → Passer au quiz
		</button>
	</div>

	<!-- STEP 1 : QUIZ -->
	{:else if step === 1}
	<div class="card">
		<div class="section-title mb-3">Quiz ({questions.length} questions)</div>

		{#if quizSubmitted}
		<div style="text-align:center;padding:20px 0">
			{#if quizPass}
			<div style="font-size:3rem;margin-bottom:12px">🎉</div>
			<div style="font-size:1.8rem;font-weight:800;color:var(--color-maitrisee)">{quizScore}%</div>
			<p class="text-sm mt-2" style="color:var(--color-maitrisee)">Excellent ! Tu maîtrises bien la théorie.</p>
			{:else}
			<div style="font-size:3rem;margin-bottom:12px">📚</div>
			<div style="font-size:1.8rem;font-weight:800;color:var(--color-testee)">{quizScore}%</div>
			<p class="text-sm mt-2" style="color:var(--color-text-2)">Continue à réviser — tu vas y arriver !</p>
			{/if}
			<button class="btn btn-secondary btn-block mt-3" on:click={() => { quizSubmitted = false; quizAnswers = {}; }}>Recommencer le quiz</button>
			<button class="btn btn-primary btn-block mt-2" on:click={() => step = 2}>Passer au Chrono →</button>
		</div>
		{:else}
		<div style="display:flex;flex-direction:column;gap:16px;margin-bottom:20px">
			{#each questions as q, qi}
			<div>
				<p class="font-bold text-sm mb-2">{qi + 1}. {q.question}</p>
				<div style="display:flex;flex-direction:column;gap:8px">
					{#each q.reponses as rep, ri}
					<button
						class="btn btn-secondary"
						style="text-align:left;justify-content:flex-start;{quizAnswers[q.id] === ri ? 'background:var(--color-brand);color:#fff;border-color:var(--color-brand)' : ''}"
						on:click={() => quizAnswers[q.id] = ri}>
						{rep}
					</button>
					{/each}
				</div>
			</div>
			{/each}
		</div>
		<button class="btn btn-primary btn-block" on:click={submitQuiz} disabled={Object.keys(quizAnswers).length < questions.length}>
			Valider le quiz
		</button>
		{/if}
	</div>

	<!-- STEP 2 : CHRONO -->
	{:else if step === 2}
	<div class="card" style="text-align:center">
		<div class="section-title mb-3">Chrono</div>
		<p class="text-sm text-muted mb-4">Objectif : {chronoCible} min (tolérance +20%)</p>

		<div style="font-size:3.5rem;font-weight:800;font-variant-numeric:tabular-nums;color:var(--color-brand);letter-spacing:-2px;margin-bottom:24px">
			{fmt(chronoSeconds)}
		</div>

		<div style="display:flex;gap:10px;justify-content:center;margin-bottom:20px">
			{#if !chronoRunning && chronoSeconds === 0}
			<button class="btn btn-primary btn-lg" on:click={startChrono}>▶ Démarrer</button>
			{:else if chronoRunning}
			<button class="btn btn-secondary" on:click={stopChrono}>⏸ Arrêter</button>
			{:else}
			<button class="btn btn-ghost" on:click={resetChrono}>↺ Réessayer</button>
			<button class="btn btn-primary" on:click={finishLab}>Terminer →</button>
			{/if}
		</div>

		{#if !chronoRunning && chronoSeconds > 0}
		{@const cibleSec = chronoCible * 60}
		{#if chronoSeconds <= cibleSec * 1.2}
		<div style="background:#d1fae5;color:#065f46;padding:12px;border-radius:var(--radius-md)">
			🎉 Dans les temps ! Chrono validé.
		</div>
		{:else}
		<div style="background:#fef3c7;color:#92400e;padding:12px;border-radius:var(--radius-md)">
			📚 Un peu plus lent, mais tu progresses ! Réessaie.
		</div>
		{/if}
		{/if}
	</div>

	<!-- Résumé final si tout fait -->
	{#if tested && quizSubmitted}
	<div class="card mt-3" style="text-align:center">
		{#if allDone}
		<div style="font-size:2.5rem;margin-bottom:8px">⭐</div>
		<div style="font-weight:800;font-size:1.1rem;color:var(--color-maitrisee)">Recette maîtrisée !</div>
		<p class="text-sm text-muted mt-1">Les 3 étapes sont validées. Bravo !</p>
		{:else}
		<p class="text-sm text-muted">Continue à t'entraîner pour maîtriser cette recette.</p>
		{/if}
		<button class="btn btn-primary btn-block mt-3" on:click={finishLab}>Terminer la session</button>
	</div>
	{/if}
	{/if}
</div>
{/if}

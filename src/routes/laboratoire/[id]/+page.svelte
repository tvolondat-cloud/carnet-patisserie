<script>
import { page } from '$app/stores';
import { goto } from '$app/navigation';
import { recettes } from '$lib/stores/recettes.js';
import { progression, updateProgression } from '$lib/stores/progression.js';
import { isPro, FREE_RECIPE_SLUGS } from '$lib/stores/auth.js';
import { events } from '$lib/analytics.js';
import { slugify } from '$lib/utils/slugify.js';

$: slug = $page.params.id;
$: recette = $recettes.find(r => slugify(r.nom) === slug);
$: id = recette?.id;
$: locked = !$isPro && !FREE_RECIPE_SLUGS.has(slug);
$: p = $progression[id];

let labStartTracked = false;
$: if (recette && !labStartTracked) {
	events.labStarted(id);
	labStartTracked = true;
}

let step = 0; // 0=tester, 1=quiz
let tested = false;

// Quiz
let quizAnswers = {};
let quizSubmitted = false;
let quizScore = 0;

$: questions = recette?.quiz_questions ?? [];
$: quizPass = quizScore >= 75;
$: allDone = tested && quizPass;

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
	goto(`/recettes/${slug}`);
}
</script>

{#if !recette}
<div class="page"><div class="spinner" style="margin-top:48px"></div></div>
{:else if locked}
<div class="page">
	<div style="margin-bottom:8px">
		<button class="btn btn-ghost btn-sm" on:click={() => goto(`/recettes/${slug}`)}>← Retour</button>
	</div>
	<div class="paywall-card">
		<div class="paywall-icon">🔒</div>
		<div class="paywall-title">Mode Labo · Recette Pro</div>
		<p class="paywall-desc">Le mode laboratoire pour cette recette est disponible avec le plan Pro (58 recettes CAP complètes).</p>
		<a href="/profil#plan" class="btn btn-primary btn-block" style="margin-top:12px">Passer au plan Pro →</a>
		<button class="btn btn-ghost btn-sm btn-block" style="margin-top:8px" on:click={() => goto('/recettes')}>← Voir les recettes gratuites</button>
	</div>
</div>
{:else}
<div class="page">
	<div style="display:flex;align-items:center;gap:12px;margin-bottom:16px">
		<button class="btn btn-ghost btn-sm" on:click={() => goto(`/recettes/${slug}`)}>← Retour</button>
	</div>

	<h1 class="page-title">🧪 Mode Labo</h1>
	<p class="page-subtitle">{recette.nom}</p>

	<!-- Stepper 2 étapes -->
	<div class="stepper">
		{#each ['Tester','Quiz'] as label, i}
		<div class="step"
			class:active={step === i}
			class:done={step > i || (i === 0 && tested) || (i === 1 && quizSubmitted && quizPass)}
		>
			<div class="step-circle">
				{#if (i === 0 && tested) || (i === 1 && quizSubmitted && quizPass)}✓
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
		<p class="text-sm text-muted mb-3">Suis les étapes et coche quand tu as terminé.</p>
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
			<button class="btn btn-primary btn-block mt-2" on:click={finishLab}>
				{allDone ? '⭐ Terminer — recette maîtrisée !' : 'Terminer la session'}
			</button>
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
	{/if}

	<!-- Résumé final -->
	{#if tested && quizSubmitted}
	<div class="card mt-3" style="text-align:center">
		{#if allDone}
		<div style="font-size:2.5rem;margin-bottom:8px">⭐</div>
		<div style="font-weight:800;font-size:1.1rem;color:var(--color-maitrisee)">Recette maîtrisée !</div>
		<p class="text-sm text-muted mt-1">Les 2 étapes sont validées. Bravo !</p>
		{:else}
		<p class="text-sm text-muted">Continue à t'entraîner pour maîtriser cette recette.</p>
		{/if}
		<button class="btn btn-primary btn-block mt-3" on:click={finishLab}>Terminer la session</button>
	</div>
	{/if}
</div>
{/if}

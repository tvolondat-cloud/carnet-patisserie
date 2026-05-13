<script>
import { onMount } from 'svelte';
import questionsData from '$lib/data/questions-examen.json';

const allQ = questionsData.questions;

const THEMES = [
	{ id: 'all',          label: 'Tout le programme',   emoji: '🎯' },
	{ id: 'cadre',        label: 'Cadre du diplôme',     emoji: '🎓' },
	{ id: 'ep1',          label: 'EP1 — Tour & voyage',  emoji: '🥐' },
	{ id: 'ep2',          label: 'EP2 — Entremets',      emoji: '🎂' },
	{ id: 'technologie',  label: 'Technologie',          emoji: '🧪' },
	{ id: 'techniques',   label: 'Techniques de base',   emoji: '🛠️' },
	{ id: 'hygiene',      label: 'Hygiène & sécurité',   emoji: '🧼' },
	{ id: 'organisation', label: 'Organisation',         emoji: '📋' },
	{ id: 'vocabulaire',  label: 'Vocabulaire',          emoji: '📚' },
	{ id: 'pieges',       label: 'Pièges fréquents',     emoji: '⚠️' },
];

let mode = 'start'; // 'start' | 'quiz' | 'result'
let selectedTheme = 'all';
let questions = [];
let idx = 0;
let answers = {};   // { [questionId]: choiceIndex }
let answered = false;

function themeCount(id) {
	return id === 'all' ? allQ.length : allQ.filter(q => q.theme === id).length;
}

function shuffle(arr) {
	const a = [...arr];
	for (let i = a.length - 1; i > 0; i--) {
		const j = Math.floor(Math.random() * (i + 1));
		[a[i], a[j]] = [a[j], a[i]];
	}
	return a;
}

function start() {
	const pool = selectedTheme === 'all' ? allQ : allQ.filter(q => q.theme === selectedTheme);
	questions = shuffle(pool);
	idx = 0;
	answers = {};
	answered = false;
	mode = 'quiz';
}

function pick(choice) {
	if (answered) return;
	answers[q.id] = choice;
	answered = true;
}

function next() {
	if (idx < questions.length - 1) {
		idx++;
		answered = false;
	} else {
		finish();
	}
}

function finish() {
	try {
		localStorage.setItem('bs_last_exam_score', JSON.stringify({
			score, total: questions.length, pct, date: new Date().toISOString()
		}));
	} catch {}
	mode = 'result';
}

function btnState(i) {
	if (!answered) return '';
	if (i === q.bonne) return 'correct';
	if (i === answers[q.id]) return 'wrong';
	return 'dimmed';
}

$: q           = questions[idx];
$: isCorrect   = answered && answers[q?.id] === q?.bonne;
$: score       = questions.filter(x => answers[x.id] === x.bonne).length;
$: pct         = questions.length ? Math.round(score / questions.length * 100) : 0;
$: passed      = pct >= 75;
$: wrong       = questions.filter(x => answers[x.id] !== undefined && answers[x.id] !== x.bonne);
$: progressPct = questions.length ? Math.round((idx + (answered ? 1 : 0)) / questions.length * 100) : 0;
</script>

<svelte:head>
	<title>Examen blanc — Brigade Sucrée</title>
</svelte:head>

<div class="page">

<!-- ══════════════════ START ══════════════════ -->
{#if mode === 'start'}

	<div style="margin-bottom:8px">
		<a href="/reviser" class="btn btn-ghost btn-sm">← Réviser</a>
	</div>
	<h1 class="page-title">🎯 Examen blanc</h1>
	<p class="page-subtitle">Choisis un thème et teste tes connaissances</p>

	<div class="theme-grid">
		{#each THEMES as t}
		{@const count = themeCount(t.id)}
		<button type="button" class="theme-btn" class:active={selectedTheme === t.id} on:click={() => selectedTheme = t.id}>
			<span class="theme-emoji">{t.emoji}</span>
			<span class="theme-label">{t.label}</span>
			<span class="theme-count">{count} Q</span>
		</button>
		{/each}
	</div>

	<button type="button" class="btn btn-primary btn-block btn-lg" style="margin-top:20px" on:click={start}>
		Commencer · {themeCount(selectedTheme)} questions →
	</button>

<!-- ══════════════════ QUIZ ══════════════════ -->
{:else if mode === 'quiz' && q}

	<div class="quiz-top">
		<button type="button" class="btn btn-ghost btn-sm quiz-quit" on:click={() => mode = 'start'} title="Quitter">✕</button>
		<div class="progress-bar"><div class="progress-fill" style="width:{progressPct}%"></div></div>
		<span class="quiz-counter">{idx + 1}<span class="quiz-counter-total">/{questions.length}</span></span>
	</div>

	<div class="quiz-body">
		<p class="question-text">{q.question}</p>

		<div class="choices">
			{#each q.reponses as rep, i}
			<button
				type="button"
				class="choice-btn choice-{btnState(i)}"
				on:click={() => pick(i)}
				disabled={answered}
			>
				<span class="choice-letter">{['A','B','C','D'][i]}</span>
				<span class="choice-text">{rep}</span>
				{#if answered && i === q.bonne}<span class="choice-icon">✓</span>
				{:else if answered && i === answers[q.id] && i !== q.bonne}<span class="choice-icon">✗</span>
				{/if}
			</button>
			{/each}
		</div>

		{#if answered}
		<div class="explication" class:explication-ok={isCorrect} class:explication-ko={!isCorrect}>
			<div class="explication-head">{isCorrect ? '✅ Bonne réponse !' : '📚 À retenir'}</div>
			<p class="explication-body">{q.explication}</p>
		</div>
		<button type="button" class="btn btn-primary btn-block btn-lg" on:click={next}>
			{idx < questions.length - 1 ? 'Question suivante →' : 'Voir les résultats →'}
		</button>
		{/if}
	</div>

<!-- ══════════════════ RESULT ══════════════════ -->
{:else if mode === 'result'}

	<div class="result-score" class:result-pass={passed} class:result-fail={!passed}>
		<div class="result-pct">{pct}%</div>
		<div class="result-fraction">{score} / {questions.length} bonnes réponses</div>
		<div class="result-verdict">{passed ? '🎉 Objectif atteint !' : '💪 Continue à réviser !'}</div>
		{#if passed}
		<div class="result-bar-wrap"><div class="result-bar" style="width:{pct}%;background:#10b981"></div></div>
		{:else}
		<div class="result-bar-wrap"><div class="result-bar" style="width:{pct}%;background:#f59e0b"></div></div>
		{/if}
	</div>

	{#if wrong.length === 0}
	<div class="empty-state" style="margin-top:20px">
		<div class="empty-state-emoji">🏆</div>
		<div class="empty-state-title">Score parfait !</div>
		<div class="empty-state-desc">Toutes les réponses sont justes. Impressionnant !</div>
	</div>
	{:else}
	<div class="section-title mb-3" style="margin-top:24px">❌ Points à retravailler ({wrong.length})</div>
	{#each wrong as wq}
	<div class="wrong-card">
		<div class="wrong-q">{wq.question}</div>
		<div class="wrong-answer">✓ {wq.reponses[wq.bonne]}</div>
		{#if wq.explication}
		<div class="wrong-tip">{wq.explication}</div>
		{/if}
	</div>
	{/each}
	{/if}

	<div class="result-actions">
		<button type="button" class="btn btn-secondary" on:click={() => mode = 'start'}>← Thèmes</button>
		<button type="button" class="btn btn-primary" on:click={start}>🔄 Recommencer</button>
	</div>

{/if}
</div>

<style>
/* ── Theme selector ─────────────────────────── */
.theme-grid { display: flex; flex-direction: column; gap: 8px; }

.theme-btn {
	display: flex;
	align-items: center;
	gap: 12px;
	width: 100%;
	padding: 12px 16px;
	background: var(--color-surface);
	border: 2px solid var(--color-border);
	border-radius: var(--radius-lg);
	cursor: pointer;
	text-align: left;
	transition: border-color 0.15s, background 0.15s;
}
.theme-btn:hover { border-color: var(--color-brand); }
.theme-btn.active {
	border-color: var(--color-brand);
	background: rgba(108, 99, 255, 0.07);
}
.theme-emoji { font-size: 1.2rem; flex-shrink: 0; }
.theme-label { flex: 1; font-size: 0.9rem; font-weight: 600; color: var(--color-text); }
.theme-count { font-size: 0.8rem; font-weight: 700; color: var(--color-text-3); }

/* ── Quiz top bar ───────────────────────────── */
.quiz-top {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 20px;
}
.quiz-quit { flex-shrink: 0; }
.progress-bar {
	flex: 1;
	height: 6px;
	background: var(--color-surface-2);
	border-radius: var(--radius-full);
	overflow: hidden;
}
.progress-fill {
	height: 100%;
	background: var(--color-brand);
	border-radius: var(--radius-full);
	transition: width 0.35s ease;
}
.quiz-counter {
	font-size: 0.85rem;
	font-weight: 800;
	color: var(--color-text);
	flex-shrink: 0;
}
.quiz-counter-total { font-weight: 400; color: var(--color-text-3); }

/* ── Question ───────────────────────────────── */
.quiz-body { display: flex; flex-direction: column; gap: 0; }
.question-text {
	font-size: 1.1rem;
	font-weight: 700;
	line-height: 1.55;
	margin: 0 0 20px;
	color: var(--color-text);
}

/* ── Choices ────────────────────────────────── */
.choices { display: flex; flex-direction: column; gap: 10px; margin-bottom: 18px; }

.choice-btn {
	display: flex;
	align-items: center;
	gap: 12px;
	width: 100%;
	padding: 14px 16px;
	background: var(--color-surface);
	border: 2px solid var(--color-border);
	border-radius: var(--radius-lg);
	text-align: left;
	cursor: pointer;
	font-size: 0.9rem;
	color: var(--color-text);
	transition: border-color 0.15s, background 0.15s, opacity 0.15s;
	min-height: 48px;
}
.choice-btn:not(:disabled):hover { border-color: var(--color-brand); }
.choice-btn:disabled { cursor: default; }

.choice-btn.choice-correct {
	border-color: var(--color-maitrisee);
	background: rgba(16, 185, 129, 0.09);
}
.choice-btn.choice-wrong {
	border-color: #ef4444;
	background: rgba(239, 68, 68, 0.09);
}
.choice-btn.choice-dimmed { opacity: 0.4; }

.choice-letter {
	width: 26px;
	height: 26px;
	border-radius: 50%;
	background: var(--color-surface-2);
	color: var(--color-text-2);
	font-size: 0.72rem;
	font-weight: 800;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
}
.choice-btn.choice-correct .choice-letter { background: var(--color-maitrisee); color: #fff; }
.choice-btn.choice-wrong   .choice-letter { background: #ef4444; color: #fff; }

.choice-text  { flex: 1; line-height: 1.4; }
.choice-icon  { font-weight: 800; font-size: 1rem; margin-left: auto; flex-shrink: 0; }

/* ── Explanation ────────────────────────────── */
.explication {
	padding: 14px 16px;
	border-radius: var(--radius-lg);
	border-left: 4px solid;
	margin-bottom: 16px;
}
.explication-ok { background: rgba(16, 185, 129, 0.08); border-color: var(--color-maitrisee); }
.explication-ko { background: rgba(245, 158, 11, 0.08); border-color: var(--color-testee); }

.explication-head { font-weight: 700; margin-bottom: 5px; font-size: 0.9rem; }
.explication-body { font-size: 0.85rem; color: var(--color-text-2); line-height: 1.55; margin: 0; }

/* ── Result ─────────────────────────────────── */
.result-score {
	text-align: center;
	padding: 28px 20px 20px;
	border-radius: var(--radius-xl);
	border: 2px solid;
}
.result-pass { border-color: var(--color-maitrisee); background: rgba(16, 185, 129, 0.07); }
.result-fail { border-color: var(--color-testee);    background: rgba(245, 158, 11, 0.07); }

.result-pct      { font-size: 3.5rem; font-weight: 900; line-height: 1; margin-bottom: 4px; }
.result-pass .result-pct { color: var(--color-maitrisee); }
.result-fail .result-pct { color: var(--color-testee); }

.result-fraction { font-size: 0.95rem; color: var(--color-text-2); margin-bottom: 6px; }
.result-verdict  { font-size: 1rem; font-weight: 700; margin-bottom: 14px; }

.result-bar-wrap {
	height: 6px;
	background: var(--color-surface-2);
	border-radius: var(--radius-full);
	overflow: hidden;
}
.result-bar {
	height: 100%;
	border-radius: var(--radius-full);
	transition: width 0.6s ease;
}

/* ── Wrong answers ──────────────────────────── */
.wrong-card {
	background: var(--color-surface);
	border: 1px solid var(--color-border);
	border-radius: var(--radius-lg);
	padding: 14px 16px;
	margin-bottom: 10px;
}
.wrong-q      { font-size: 0.9rem; font-weight: 600; color: var(--color-text); margin-bottom: 6px; }
.wrong-answer { font-size: 0.85rem; font-weight: 600; color: var(--color-maitrisee); margin-bottom: 0; }
.wrong-tip {
	font-size: 0.8rem;
	color: var(--color-text-2);
	line-height: 1.5;
	margin-top: 8px;
	padding-top: 8px;
	border-top: 1px solid var(--color-border);
}

.result-actions {
	display: flex;
	gap: 12px;
	margin-top: 24px;
}
.result-actions .btn { flex: 1; }
</style>

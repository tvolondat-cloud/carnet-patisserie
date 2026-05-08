<script>
import { session, profile, isAuthenticated, authLoading } from '$lib/stores/auth.js';
import { recettes } from '$lib/stores/recettes.js';
import { stats, progression } from '$lib/stores/progression.js';
import { onMount } from 'svelte';

// Lazy-load la Landing : on n'inclut son JS+CSS que pour les visiteurs
// anonymes. Les utilisateurs connectés ne paient pas le coût bundle
// (Landing ~80 KB d'images SVG + sections inline).
let LandingComponent = null;

onMount(async () => {
	if (!$isAuthenticated) {
		const mod = await import('$lib/components/Landing.svelte');
		LandingComponent = mod.default;
	}
});

$: if ($authLoading === false && !$isAuthenticated && !LandingComponent) {
	import('$lib/components/Landing.svelte').then((m) => (LandingComponent = m.default));
}

$: prenom = $profile?.full_name?.split(' ')[0] ?? $session?.user?.email?.split('@')[0] ?? 'toi';

$: examDate = $profile?.exam_date ? new Date($profile.exam_date) : null;
$: daysLeft = examDate ? Math.ceil((examDate - new Date()) / 86400000) : null;

$: recentsIds = Object.entries($progression)
	.sort((a, b) => new Date(b[1].updated_at) - new Date(a[1].updated_at))
	.slice(0, 3)
	.map(([id]) => id);
$: recentRecettes = $recettes.filter(r => recentsIds.includes(r.id));

$: pct = $stats.score;
$: progressStyle = `--pct: ${pct * 3.6}deg`;

const statutLabel = { 'a-tester': 'À tester', testee: 'Testée', validee: 'Validée', maitrisee: 'Maîtrisée' };
const statutColor = { 'a-tester': 'var(--color-a-tester)', testee: 'var(--color-testee)', validee: 'var(--color-validee)', maitrisee: 'var(--color-maitrisee)' };
</script>

{#if !$isAuthenticated}
	{#if LandingComponent}
		<svelte:component this={LandingComponent} />
	{:else}
		<div style="display:flex;align-items:center;justify-content:center;min-height:100dvh;background:#FAF1E2">
			<div class="spinner" role="status" aria-label="Chargement"></div>
		</div>
	{/if}
{:else}
<div class="page">
	<div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:20px">
		<div>
			<p class="text-muted text-sm">Bonjour 👋</p>
			<h1 style="font-size:1.4rem;font-weight:800">{prenom}</h1>
		</div>
		<a href="/profil" aria-label="Mon profil" style="width:40px;height:40px;border-radius:50%;background:var(--color-surface-2);display:flex;align-items:center;justify-content:center;font-size:1.2rem">👤</a>
	</div>

	<!-- Score ring + exam countdown -->
	<div class="card" style="display:flex;align-items:center;gap:20px;margin-bottom:16px">
		<div class="score-ring" style="background:conic-gradient(var(--color-brand) {pct * 3.6}deg, var(--color-surface-2) 0deg)">
			<div class="score-ring-inner">
				<div class="score-number">{pct}<span style="font-size:1rem">%</span></div>
				<div class="score-label">maîtrisé</div>
			</div>
		</div>
		<div style="flex:1">
			{#if daysLeft !== null}
			<div style="background:var(--color-brand);color:#fff;border-radius:var(--radius-md);padding:10px 14px;margin-bottom:10px">
				<div style="font-size:1.6rem;font-weight:800;line-height:1">{daysLeft}j</div>
				<div style="font-size:0.72rem;opacity:0.85">avant l'examen</div>
			</div>
			{/if}
			<div class="text-sm text-muted">{$stats.maitrisees} / {$stats.total} recettes maîtrisées</div>
		</div>
	</div>

	<!-- Stats rapides -->
	<div class="stat-grid">
		{#each [['a-tester','À tester','📋'],['testee','Testées','🧪'],['validee','Validées','✅'],['maitrisee','Maîtrisées','⭐']] as [key, label, emoji]}
		<div class="stat-card">
			<div class="stat-number" style="color:{statutColor[key]}">{$stats.byStatut[key] ?? 0}</div>
			<div class="stat-label">{emoji} {label}</div>
		</div>
		{/each}
	</div>

	<!-- Accès rapide -->
	<div class="section-header">
		<span class="section-title">Activité récente</span>
		<a href="/recettes" class="text-sm" style="color:var(--color-brand)">Voir tout →</a>
	</div>

	{#if recentRecettes.length === 0}
	<div class="empty-state">
		<div class="empty-state-emoji">🥐</div>
		<div class="empty-state-title">Commence ton carnet !</div>
		<div class="empty-state-desc">Va dans Recettes pour tester ta première recette.</div>
	</div>
	{:else}
	{#each recentRecettes as r}
	{@const p = $progression[r.id]}
	{@const statut = p?.statut ?? 'a-tester'}
	<a href="/recettes/{r.id}" class="recipe-card" style="margin-bottom:10px">
		<div class="recipe-card-title">{r.nom}</div>
		<div class="recipe-card-meta">
			<span class="badge badge-{statut}">{statutLabel[statut]}</span>
			<span class="text-xs text-muted">⏱ {r.temps} min</span>
		</div>
	</a>
	{/each}
	{/if}

	<!-- Accès Lab -->
	<div style="margin-top:20px">
		<div class="section-title mb-3">Entraîne-toi</div>
		<a href="/reviser" class="btn btn-primary btn-block btn-lg">
			🧪 Mode Laboratoire
		</a>
	</div>
</div>
{/if}

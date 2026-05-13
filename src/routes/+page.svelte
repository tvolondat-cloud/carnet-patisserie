<script>
import { session, profile, isAuthenticated, signOut } from '$lib/stores/auth.js';
import { recettes } from '$lib/stores/recettes.js';
import { stats, progression } from '$lib/stores/progression.js';
import { goto } from '$app/navigation';
import Landing from '$lib/components/Landing.svelte';

$: prenom = $profile?.full_name?.split(' ')[0] ?? $session?.user?.email?.split('@')[0] ?? 'toi';
$: initiales = (prenom || '?').charAt(0).toUpperCase();

$: examDate = $profile?.exam_date ? new Date($profile.exam_date) : null;
$: daysLeft = examDate ? Math.ceil((examDate - new Date()) / 86400000) : null;

$: recentsIds = Object.entries($progression)
	.sort((a, b) => new Date(b[1].updated_at) - new Date(a[1].updated_at))
	.slice(0, 3)
	.map(([id]) => id);
$: recentRecettes = $recettes.filter(r => recentsIds.includes(r.id));

$: pct = $stats.score;

const statutLabel = { 'a-tester': 'À tester', testee: 'Testée', validee: 'Validée', maitrisee: 'Maîtrisée' };
const statutColor = { 'a-tester': 'var(--color-a-tester)', testee: 'var(--color-testee)', validee: 'var(--color-validee)', maitrisee: 'var(--color-maitrisee)' };

let avatarOpen = false;

function toggleAvatar() { avatarOpen = !avatarOpen; }
function closeAvatar() { avatarOpen = false; }

async function handleSignOut() {
	avatarOpen = false;
	await signOut();
	goto('/');
}
</script>

<svelte:window on:click={closeAvatar} />

{#if !$isAuthenticated}
	<Landing />
{:else}
<div class="page">
	<!-- Header avec avatar dropdown -->
	<div class="home-header">
		<div>
			<p class="text-muted text-sm">Bonjour 👋</p>
			<h1 style="font-size:1.4rem;font-weight:800">{prenom}</h1>
		</div>
		<!-- Avatar + dropdown -->
		<div class="avatar-wrap" on:click|stopPropagation={toggleAvatar} on:keydown={e => e.key === 'Escape' && closeAvatar()}>
			<button
				type="button"
				class="avatar-btn"
				aria-label="Menu compte"
				aria-expanded={avatarOpen}
				aria-haspopup="true"
			>
				{initiales}
			</button>
			{#if avatarOpen}
			<div class="avatar-dropdown" role="menu">
				<a href="/profil" class="avatar-menu-item" on:click={closeAvatar} role="menuitem">
					👤 Mon profil
				</a>
				<hr class="avatar-menu-sep" />
				<button type="button" class="avatar-menu-item avatar-menu-signout" on:click={handleSignOut} role="menuitem">
					🚪 Se déconnecter
				</button>
			</div>
			{/if}
		</div>
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

<style>
.home-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 20px;
}

.avatar-wrap {
	position: relative;
}

.avatar-btn {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	background: var(--color-brand);
	color: #fff;
	font-size: 1rem;
	font-weight: 700;
	border: none;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	transition: opacity 0.15s;
}
.avatar-btn:hover { opacity: 0.85; }

.avatar-dropdown {
	position: absolute;
	top: calc(100% + 8px);
	right: 0;
	background: var(--color-surface);
	border: 1px solid var(--color-border);
	border-radius: var(--radius-md);
	box-shadow: 0 8px 24px rgba(0,0,0,0.12);
	min-width: 180px;
	z-index: 500;
	overflow: hidden;
}

.avatar-menu-item {
	display: flex;
	align-items: center;
	gap: 8px;
	padding: 12px 16px;
	font-size: 0.9rem;
	color: var(--color-text);
	text-decoration: none;
	background: none;
	border: none;
	width: 100%;
	text-align: left;
	cursor: pointer;
	transition: background 0.12s;
}
.avatar-menu-item:hover { background: var(--color-surface-2); }
.avatar-menu-signout { color: #ef4444; }
.avatar-menu-sep { margin: 0; border: none; border-top: 1px solid var(--color-border); }
</style>

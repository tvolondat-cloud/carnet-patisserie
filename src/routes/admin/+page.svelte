<script>
import { onMount } from 'svelte';
import { goto } from '$app/navigation';
import { supabase } from '$lib/supabase.js';
import { isAdmin, profile } from '$lib/stores/auth.js';

let users = [];
let usersLoading = false;
let search = '';
let searchTimer;

let kpiUsers = null;
let kpiRecipes = [];
let kpiFeatures = null;
let kpisLoading = false;
let error = '';
let toast = '';

// Gate côté client : redirection si pas admin (la vraie sécurité est SQL/RLS)
$: if ($profile !== null && !$isAdmin) goto('/');

async function loadKpis() {
	kpisLoading = true;
	error = '';
	try {
		const [u, r, f] = await Promise.all([
			supabase.rpc('admin_kpi_users'),
			supabase.rpc('admin_kpi_recipes', { top_n: 10 }),
			supabase.rpc('admin_kpi_features')
		]);
		if (u.error) throw u.error;
		if (r.error) throw r.error;
		if (f.error) throw f.error;
		kpiUsers = u.data;
		kpiRecipes = r.data ?? [];
		kpiFeatures = f.data;
	} catch (e) {
		error = e.message ?? 'Erreur chargement KPI';
	} finally {
		kpisLoading = false;
	}
}

async function loadUsers() {
	usersLoading = true;
	try {
		const { data, error: err } = await supabase.rpc('admin_list_users', {
			search: search || null,
			page_size: 100
		});
		if (err) throw err;
		users = data ?? [];
	} catch (e) {
		error = e.message ?? 'Erreur chargement utilisateurs';
	} finally {
		usersLoading = false;
	}
}

async function updatePlan(userId, newPlan, prevPlan) {
	const u = users.find((x) => x.id === userId);
	if (u) u.plan = newPlan; // optimistic
	users = users;
	try {
		const { error: err } = await supabase.rpc('admin_update_user_plan', {
			target_id: userId,
			new_plan: newPlan
		});
		if (err) throw err;
		flashToast(`Plan mis à jour → ${newPlan}`);
	} catch (e) {
		if (u) u.plan = prevPlan; // rollback
		users = users;
		error = e.message;
	}
}

function flashToast(msg) {
	toast = msg;
	setTimeout(() => (toast = ''), 2200);
}

function onSearchInput() {
	clearTimeout(searchTimer);
	searchTimer = setTimeout(loadUsers, 250);
}

onMount(async () => {
	if ($isAdmin) {
		await Promise.all([loadKpis(), loadUsers()]);
	}
});

const fmtDate = (d) => (d ? new Date(d).toLocaleDateString('fr-FR') : '—');
const planColor = (p) =>
	p === 'admin' ? 'var(--color-brand)' : p === 'pro' ? 'var(--color-maitrisee)' : 'var(--color-text-3)';
</script>

<svelte:head>
	<title>Admin — Brigade Sucrée</title>
	<meta name="robots" content="noindex, nofollow" />
</svelte:head>

{#if !$isAdmin}
	<div class="page">
		<div class="empty-state">
			<div class="empty-state-emoji">🔒</div>
			<div class="empty-state-title">Accès admin requis</div>
		</div>
	</div>
{:else}
<div class="page admin">
	<h1 class="page-title">🛠️ Admin</h1>
	<p class="page-subtitle">Dashboard — utilisateurs, KPI, modération</p>

	{#if error}
		<div class="card admin-error" role="alert">⚠️ {error}</div>
	{/if}

	<!-- KPI Utilisateurs -->
	<div class="section-title mb-2">👥 Utilisateurs</div>
	<div class="kpi-grid">
		<div class="kpi-card">
			<div class="kpi-num">{kpiUsers?.total ?? '—'}</div>
			<div class="kpi-label">Total inscrits</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num" style="color:var(--color-text-3)">{kpiUsers?.by_plan?.free ?? 0}</div>
			<div class="kpi-label">Free</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num" style="color:var(--color-maitrisee)">{kpiUsers?.by_plan?.pro ?? 0}</div>
			<div class="kpi-label">Pro</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num" style="color:var(--color-brand)">{kpiUsers?.by_plan?.admin ?? 0}</div>
			<div class="kpi-label">Admin</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num">{kpiUsers?.new_7d ?? '—'}</div>
			<div class="kpi-label">Inscrits 7j</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num">{kpiUsers?.new_30d ?? '—'}</div>
			<div class="kpi-label">Inscrits 30j</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num">{kpiUsers?.active_30d ?? '—'}</div>
			<div class="kpi-label">Actifs 30j</div>
		</div>
	</div>

	<!-- KPI Features -->
	<div class="section-title mb-2 mt-3">🧪 Utilisation features</div>
	<div class="kpi-grid">
		<div class="kpi-card">
			<div class="kpi-num">{kpiFeatures?.progression_entries ?? '—'}</div>
			<div class="kpi-label">Lignes progression</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num" style="color:var(--color-maitrisee)">{kpiFeatures?.recipes_mastered_total ?? '—'}</div>
			<div class="kpi-label">Recettes maîtrisées</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num" style="color:var(--color-validee)">{kpiFeatures?.recipes_validee_total ?? '—'}</div>
			<div class="kpi-label">Validées</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num" style="color:var(--color-testee)">{kpiFeatures?.recipes_testee_total ?? '—'}</div>
			<div class="kpi-label">Testées</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num">{kpiFeatures?.exam_scores_total ?? 0}</div>
			<div class="kpi-label">Examens passés</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num">{kpiFeatures?.notes_count ?? '—'}</div>
			<div class="kpi-label">Notes perso</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num">{kpiFeatures?.comments_count ?? '—'}</div>
			<div class="kpi-label">Commentaires</div>
		</div>
		<div class="kpi-card">
			<div class="kpi-num">{kpiFeatures?.photos_count ?? 0}</div>
			<div class="kpi-label">Photos</div>
		</div>
	</div>

	<!-- Top recettes -->
	<div class="section-title mb-2 mt-3">📖 Top recettes (testées / maîtrisées)</div>
	<div class="card">
		{#if kpisLoading}
			<div class="spinner"></div>
		{:else if kpiRecipes.length === 0}
			<div class="text-sm text-muted">Aucune donnée d'usage encore — personne n'a testé de recette.</div>
		{:else}
		<table class="admin-table">
			<thead>
				<tr><th>Recette</th><th>Testée</th><th>Maîtrisée</th><th>Users uniques</th></tr>
			</thead>
			<tbody>
				{#each kpiRecipes as r}
				<tr>
					<td>{r.recipe_name}</td>
					<td><strong>{r.tested_count}</strong></td>
					<td style="color:var(--color-maitrisee);font-weight:700">{r.mastered_count}</td>
					<td>{r.unique_users}</td>
				</tr>
				{/each}
			</tbody>
		</table>
		{/if}
	</div>

	<!-- Liste users avec MAJ plan -->
	<div class="section-header mt-3">
		<span class="section-title">👤 Utilisateurs</span>
		<button type="button" class="btn btn-ghost btn-sm" on:click={loadUsers}>↻ Rafraîchir</button>
	</div>
	<input
		type="search"
		class="input mb-2"
		placeholder="🔍 Rechercher (email, prénom)…"
		bind:value={search}
		on:input={onSearchInput}
	/>

	<div class="card admin-users">
		{#if usersLoading}
			<div class="spinner"></div>
		{:else if users.length === 0}
			<div class="text-sm text-muted">Aucun utilisateur.</div>
		{:else}
		<table class="admin-table">
			<thead>
				<tr>
					<th>Email</th>
					<th>Plan</th>
					<th>Prénom</th>
					<th>Profil</th>
					<th>Inscrit</th>
					<th>Dernière connexion</th>
				</tr>
			</thead>
			<tbody>
				{#each users as u (u.id)}
				<tr>
					<td><span class="cell-email">{u.email}</span></td>
					<td>
						<select
							class="plan-select"
							style="border-color:{planColor(u.plan)};color:{planColor(u.plan)}"
							value={u.plan}
							on:change={(e) => updatePlan(u.id, e.target.value, u.plan)}
							aria-label="Plan de {u.email}"
						>
							<option value="free">free</option>
							<option value="pro">pro</option>
							<option value="admin">admin</option>
						</select>
					</td>
					<td>{u.full_name ?? '—'}</td>
					<td class="text-xs">{u.profil_type ?? '—'}</td>
					<td class="text-xs">{fmtDate(u.created_at)}</td>
					<td class="text-xs">{fmtDate(u.last_sign_in_at)}</td>
				</tr>
				{/each}
			</tbody>
		</table>
		{/if}
	</div>
</div>
{/if}

{#if toast}
	<div class="toast" role="status" aria-live="polite">{toast}</div>
{/if}

<style>
.admin .mt-3 { margin-top: 24px; }
.admin-error {
	background: rgba(239, 68, 68, 0.08);
	border-color: #ef4444;
	color: #b91c1c;
	font-size: 0.9rem;
	padding: 12px 14px;
	margin-bottom: 12px;
}

.kpi-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
	gap: 10px;
}
.kpi-card {
	background: var(--color-surface);
	border: 1px solid var(--color-border);
	border-radius: var(--radius-md);
	padding: 12px 14px;
	text-align: center;
}
.kpi-num {
	font-size: 1.6rem;
	font-weight: 900;
	color: var(--color-text);
	line-height: 1;
	font-variant-numeric: tabular-nums;
}
.kpi-label {
	font-size: 0.72rem;
	color: var(--color-text-2);
	margin-top: 4px;
	letter-spacing: 0.02em;
}

.admin-table {
	width: 100%;
	border-collapse: collapse;
	font-size: 0.85rem;
}
.admin-table th {
	text-align: left;
	padding: 8px 8px;
	border-bottom: 1.5px solid var(--color-border);
	font-size: 0.72rem;
	font-weight: 800;
	letter-spacing: 0.06em;
	text-transform: uppercase;
	color: var(--color-text-3);
}
.admin-table td {
	padding: 8px 8px;
	border-bottom: 1px solid var(--color-border);
	vertical-align: middle;
}
.admin-table tr:last-child td { border-bottom: none; }

.cell-email { font-family: ui-monospace, monospace; font-size: 0.78rem; }

.plan-select {
	background: var(--color-surface);
	border: 1.5px solid var(--color-border);
	border-radius: var(--radius-sm);
	padding: 4px 6px;
	font-size: 0.78rem;
	font-weight: 700;
	cursor: pointer;
	font-family: ui-monospace, monospace;
}

.admin-users { overflow-x: auto; padding: 8px 12px; }

@media (max-width: 640px) {
	.admin-table { font-size: 0.78rem; }
	.admin-table th, .admin-table td { padding: 6px 4px; }
	.kpi-num { font-size: 1.35rem; }
}
</style>

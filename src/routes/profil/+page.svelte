<script>
import { goto } from '$app/navigation';
import { profile, session, signOut, updateProfile, isPro } from '$lib/stores/auth.js';
import { stats } from '$lib/stores/progression.js';
import { events, consentState, resetConsent } from '$lib/analytics.js';

let editMode = false;
let editFullName = '';
let editExamDate = '';
let editProfilType = 'cap';
let saving = false;
let toast = '';
let toastTimer;

$: if ($profile && !editMode) {
	editFullName = $profile.full_name ?? '';
	editExamDate = $profile.exam_date ?? '';
	editProfilType = $profile.profil_type ?? 'cap';
}

function showToast(msg) {
	toast = msg;
	clearTimeout(toastTimer);
	toastTimer = setTimeout(() => (toast = ''), 2500);
}

async function handleSave() {
	saving = true;
	try {
		await updateProfile({
			full_name: editFullName.trim() || null,
			exam_date: editExamDate || null,
			profil_type: editProfilType
		});
		editMode = false;
		events.profileUpdated();
		showToast('Profil mis à jour ✅');
	} catch (e) {
		showToast('Erreur : ' + e.message);
	} finally {
		saving = false;
	}
}

async function handleSignOut() {
	if (!confirm('Te déconnecter ?')) return;
	events.signOut();
	await signOut();
	goto('/auth');
}
</script>

<div class="page">
	<h1 class="page-title">👤 Profil</h1>
	<p class="page-subtitle">{$session?.user?.email ?? ''}</p>

	<!-- Stats globales -->
	<div class="card mb-3" style="display:flex;align-items:center;gap:16px">
		<div
			class="score-ring"
			style="background:conic-gradient(var(--color-brand) {$stats.score * 3.6}deg, var(--color-surface-2) 0deg);width:80px;height:80px"
			role="img"
			aria-label="{$stats.score}% de recettes maîtrisées"
		>
			<div class="score-ring-inner">
				<div class="score-number" style="font-size:1.2rem">{$stats.score}<span style="font-size:0.7rem">%</span></div>
			</div>
		</div>
		<div>
			<div class="font-bold">{$stats.maitrisees} / {$stats.total} recettes</div>
			<div class="text-xs text-muted">maîtrisées</div>
		</div>
	</div>

	<!-- Infos profil -->
	<div class="card mb-3">
		<div class="section-header">
			<span class="section-title">Mes informations</span>
			{#if !editMode}
				<button type="button" class="btn btn-ghost btn-sm" on:click={() => (editMode = true)}>
					✏️ Modifier
				</button>
			{/if}
		</div>

		{#if editMode}
			<div class="form-group">
				<label class="label" for="profil-nom">Prénom</label>
				<input id="profil-nom" class="input" type="text" bind:value={editFullName} autocomplete="given-name" />
			</div>

			<div class="form-group">
				<label class="label" for="profil-type">Profil</label>
				<select id="profil-type" class="input" bind:value={editProfilType}>
					<option value="cap">🎓 Étudiant CAP Pâtissier</option>
					<option value="particulier">🥐 Particulier passionné</option>
				</select>
			</div>

			{#if editProfilType === 'cap'}
				<div class="form-group">
					<label class="label" for="profil-exam">Date d'examen</label>
					<input id="profil-exam" class="input" type="date" bind:value={editExamDate} />
				</div>
			{/if}

			<div style="display:flex;gap:8px">
				<button type="button" class="btn btn-primary" style="flex:1" on:click={handleSave} disabled={saving}>
					{saving ? '⏳ Sauvegarde...' : '✅ Enregistrer'}
				</button>
				<button type="button" class="btn btn-ghost" on:click={() => (editMode = false)}>Annuler</button>
			</div>
		{:else}
			<dl style="display:flex;flex-direction:column;gap:12px;margin:0">
				<div>
					<dt class="text-xs text-muted">Prénom</dt>
					<dd class="font-medium">{$profile?.full_name ?? '—'}</dd>
				</div>
				<div>
					<dt class="text-xs text-muted">Profil</dt>
					<dd class="font-medium">
						{$profile?.profil_type === 'particulier' ? '🥐 Particulier' : '🎓 Étudiant CAP'}
					</dd>
				</div>
				{#if $profile?.profil_type === 'cap'}
					<div>
						<dt class="text-xs text-muted">Date d'examen</dt>
						<dd class="font-medium">
							{$profile?.exam_date ? new Date($profile.exam_date).toLocaleDateString('fr-FR', { day: '2-digit', month: 'long', year: 'numeric' }) : '—'}
						</dd>
					</div>
				{/if}
			</dl>
		{/if}
	</div>

	<!-- Outils -->
	<div class="card mb-3">
		<div class="section-title mb-3">Outils</div>
		<a href="/ordonnancement" class="btn btn-ghost btn-block" style="justify-content:flex-start;margin-bottom:8px">
			📋 Cours d'ordonnancement EP1/EP2
		</a>
		<a href="/carnet-pdf" class="btn btn-ghost btn-block" style="justify-content:flex-start">
			📄 Exporter mon carnet en PDF
		</a>
	</div>

	<!-- Plan freemium -->
	<div class="card mb-3" id="plan">
		<div class="section-title mb-2">Plan</div>
		{#if $isPro}
		<div style="display:flex;justify-content:space-between;align-items:center">
			<div>
				<div class="font-bold" style="color:var(--color-brand)">⭐ Pro</div>
				<div class="text-xs text-muted">58 recettes · Carnet PDF · Fiches</div>
			</div>
			<span class="badge badge-maitrisee">Actif</span>
		</div>
		{:else}
		<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px">
			<div>
				<div class="font-bold">Gratuit</div>
				<div class="text-xs text-muted">10 recettes · Mode Labo · Suivi</div>
			</div>
			<span class="badge badge-validee">Actif</span>
		</div>
		<div style="background:rgba(108,99,255,0.06);border-radius:var(--radius-md);padding:12px;border:1px solid var(--color-border)">
			<div class="text-sm font-medium mb-1">🚀 Passer au plan Pro</div>
			<div class="text-xs text-muted mb-2">58 recettes CAP · Carnet PDF · 50 fiches · 60 QCM</div>
			<div style="display:flex;gap:8px">
				<button class="btn btn-primary btn-sm" style="flex:1" disabled>4,99€/mois</button>
				<button class="btn btn-ghost btn-sm" style="flex:1" disabled>39€/an</button>
			</div>
			<p class="text-xs text-muted" style="margin-top:6px;text-align:center">Bientôt disponible</p>
		</div>
		{/if}
	</div>

	<!-- Confidentialité -->
	<div class="card mb-3">
		<div class="section-title mb-2">Confidentialité</div>
		<div style="display:flex;justify-content:space-between;align-items:center">
			<div>
				<div class="text-sm font-medium">Cookies analytics</div>
				<div class="text-xs text-muted">
					{$consentState === 'granted' ? 'Acceptés' : $consentState === 'denied' ? 'Refusés' : 'Non décidés'}
				</div>
			</div>
			<button type="button" class="btn btn-ghost btn-sm" on:click={resetConsent}>
				Re-paramétrer
			</button>
		</div>
	</div>

	<!-- Déconnexion -->
	<button type="button" class="btn btn-danger btn-block" on:click={handleSignOut}>
		🚪 Se déconnecter
	</button>

	<p class="text-xs text-muted text-center mt-3">Brigade Sucrée · v0.1.0</p>
</div>

{#if toast}
	<div class="toast" role="status" aria-live="polite">{toast}</div>
{/if}

<script>
import { goto } from '$app/navigation';
import { signInWithGoogle, signInWithEmail, signUpWithEmail, isAuthenticated } from '$lib/stores/auth.js';
import { events } from '$lib/analytics.js';

let mode = 'login';
let email = '';
let password = '';
let nom = '';
let errorMsg = '';
let loading = false;

$: if ($isAuthenticated) goto('/');

async function handleGoogle() {
	errorMsg = '';
	try {
		events.login('google');
		await signInWithGoogle();
	} catch (e) {
		errorMsg = e.message;
	}
}

async function handleSubmit() {
	errorMsg = '';
	loading = true;
	try {
		if (mode === 'login') {
			await signInWithEmail(email, password);
			events.login('email');
			goto('/');
		} else {
			await signUpWithEmail(email, password, nom);
			events.signUp('email');
			goto('/');
		}
	} catch (e) {
		errorMsg = e.message;
	} finally {
		loading = false;
	}
}

function toggleMode() {
	mode = mode === 'login' ? 'signup' : 'login';
	errorMsg = '';
}
</script>

<div style="min-height:100dvh;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:24px;background:var(--color-bg)">
	<div style="width:100%;max-width:380px">
		<div style="text-align:center;margin-bottom:32px">
			<div style="font-size:3rem;margin-bottom:12px" aria-hidden="true">🥐</div>
			<h1 style="font-size:1.8rem;font-weight:800;color:var(--color-text)">Brigade Sucrée</h1>
			<p style="color:var(--color-text-2);margin-top:6px">L'app des passionnés de pâtisserie</p>
		</div>

		<form class="card" on:submit|preventDefault={handleSubmit} novalidate>
			<button type="button" class="btn btn-secondary btn-block mb-3" on:click={handleGoogle} style="gap:10px">
				<img src="https://www.google.com/favicon.ico" alt="" aria-hidden="true" width="18" height="18" />
				Continuer avec Google
			</button>

			<div style="display:flex;align-items:center;gap:10px;margin-bottom:16px">
				<div class="divider" style="flex:1;margin:0"></div>
				<span class="text-xs text-muted">ou</span>
				<div class="divider" style="flex:1;margin:0"></div>
			</div>

			{#if mode === 'signup'}
				<div class="form-group">
					<label class="label" for="auth-nom">Ton prénom</label>
					<input id="auth-nom" class="input" type="text" placeholder="Léa" bind:value={nom} autocomplete="given-name" />
				</div>
			{/if}

			<div class="form-group">
				<label class="label" for="auth-email">Email</label>
				<input
					id="auth-email"
					class="input"
					type="email"
					placeholder="lea@example.com"
					bind:value={email}
					autocomplete="email"
					required
				/>
			</div>

			<div class="form-group">
				<label class="label" for="auth-password">Mot de passe</label>
				<input
					id="auth-password"
					class="input"
					type="password"
					placeholder="••••••••"
					bind:value={password}
					autocomplete={mode === 'login' ? 'current-password' : 'new-password'}
					required
					minlength="6"
				/>
			</div>

			{#if errorMsg}
				<div
					role="alert"
					style="background:#fee2e2;color:#dc2626;padding:10px 14px;border-radius:var(--radius-md);font-size:0.85rem;margin-bottom:12px"
				>
					{errorMsg}
				</div>
			{/if}

			<button type="submit" class="btn btn-primary btn-block" disabled={loading}>
				{loading ? '⏳ Connexion...' : mode === 'login' ? 'Se connecter' : 'Créer mon compte'}
			</button>

			<p class="text-center text-sm mt-3" style="color:var(--color-text-2)">
				{mode === 'login' ? 'Pas encore de compte ?' : 'Déjà un compte ?'}
				<button
					type="button"
					class="btn-ghost"
					style="color:var(--color-brand);font-weight:600;padding:0;background:none;border:none;cursor:pointer"
					on:click={toggleMode}
				>
					{mode === 'login' ? "S'inscrire" : 'Se connecter'}
				</button>
			</p>
		</form>
	</div>
</div>

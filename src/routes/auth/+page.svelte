<script>
import { goto } from '$app/navigation';
import { signInWithGoogle, signInWithEmail, signUpWithEmail, isAuthenticated } from '$lib/stores/auth.js';

let mode = 'login';
let email = '';
let password = '';
let nom = '';
let error = '';
let loading = false;

$: if ($isAuthenticated) goto('/');

async function handleGoogle() {
	try { await signInWithGoogle(); }
	catch (e) { error = e.message; }
}

async function handleSubmit() {
	error = '';
	loading = true;
	try {
		if (mode === 'login') {
			await signInWithEmail(email, password);
			goto('/');
		} else {
			await signUpWithEmail(email, password, nom);
			goto('/');
		}
	} catch (e) {
		error = e.message;
	} finally {
		loading = false;
	}
}
</script>

<div style="min-height:100dvh;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:24px;background:var(--color-bg)">
	<div style="width:100%;max-width:380px">
		<div style="text-align:center;margin-bottom:32px">
			<div style="font-size:3rem;margin-bottom:12px">🥐</div>
			<h1 style="font-size:1.8rem;font-weight:800;color:var(--color-text)">Carnet</h1>
			<p style="color:var(--color-text-2);margin-top:6px">Ton carnet CAP Pâtissier</p>
		</div>

		<div class="card">
			<button class="btn btn-secondary btn-block mb-3" on:click={handleGoogle} style="gap:10px">
				<img src="https://www.google.com/favicon.ico" alt="Google" width="18" height="18">
				Continuer avec Google
			</button>

			<div style="display:flex;align-items:center;gap:10px;margin-bottom:16px">
				<div class="divider" style="flex:1;margin:0"></div>
				<span class="text-xs text-muted">ou</span>
				<div class="divider" style="flex:1;margin:0"></div>
			</div>

			{#if mode === 'signup'}
			<div class="form-group">
				<label class="label">Ton prénom</label>
				<input class="input" type="text" placeholder="Léa" bind:value={nom}>
			</div>
			{/if}

			<div class="form-group">
				<label class="label">Email</label>
				<input class="input" type="email" placeholder="lea@example.com" bind:value={email}>
			</div>

			<div class="form-group">
				<label class="label">Mot de passe</label>
				<input class="input" type="password" placeholder="••••••••" bind:value={password}>
			</div>

			{#if error}
			<div style="background:#fee2e2;color:#dc2626;padding:10px 14px;border-radius:var(--radius-md);font-size:0.85rem;margin-bottom:12px">{error}</div>
			{/if}

			<button class="btn btn-primary btn-block" on:click={handleSubmit} disabled={loading}>
				{loading ? '⏳ Connexion...' : mode === 'login' ? 'Se connecter' : 'Créer mon compte'}
			</button>

			<p class="text-center text-sm mt-3" style="color:var(--color-text-2)">
				{mode === 'login' ? "Pas encore de compte ?" : "Déjà un compte ?"}
				<button class="btn-ghost" style="color:var(--color-brand);font-weight:600;padding:0" on:click={() => mode = mode === 'login' ? 'signup' : 'login'}>
					{mode === 'login' ? "S'inscrire" : "Se connecter"}
				</button>
			</p>
		</div>
	</div>
</div>

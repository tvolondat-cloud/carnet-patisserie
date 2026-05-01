<script>
import { onMount } from 'svelte';
import { goto } from '$app/navigation';
import { supabase } from '$lib/supabase.js';

let errorMsg = '';

onMount(async () => {
	const params = new URLSearchParams(window.location.search);
	const errParam = params.get('error_description') || params.get('error');
	if (errParam) {
		errorMsg = decodeURIComponent(errParam);
		return;
	}

	for (let i = 0; i < 30; i++) {
		const { data } = await supabase.auth.getSession();
		if (data.session) {
			goto('/');
			return;
		}
		await new Promise(r => setTimeout(r, 200));
	}

	errorMsg = 'Authentification expirée — réessaie.';
});
</script>

<div style="display:flex;flex-direction:column;align-items:center;justify-content:center;min-height:100dvh;padding:20px">
	{#if errorMsg}
		<div style="max-width:380px;text-align:center">
			<div style="font-size:2rem;margin-bottom:12px">⚠️</div>
			<p style="color:var(--color-text-2);margin-bottom:16px">{errorMsg}</p>
			<a href="/auth" class="btn btn-primary">Retour</a>
		</div>
	{:else}
		<div class="spinner"></div>
		<p style="color:var(--color-text-2);margin-top:12px;font-size:0.85rem">Connexion en cours...</p>
	{/if}
</div>

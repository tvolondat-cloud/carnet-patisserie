<script>
import { onMount } from 'svelte';
import { goto } from '$app/navigation';
import { supabase } from '$lib/supabase.js';

onMount(async () => {
	const { error } = await supabase.auth.exchangeCodeForSession(window.location.href);
	if (error) console.error(error);
	goto('/');
});
</script>

<div style="display:flex;align-items:center;justify-content:center;min-height:100dvh">
	<div class="spinner"></div>
</div>

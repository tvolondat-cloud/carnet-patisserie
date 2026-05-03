<script>
import { onMount } from 'svelte';
import { page } from '$app/stores';
import { goto } from '$app/navigation';
import { initAuth, isAuthenticated, authLoading } from '$lib/stores/auth.js';
import { loadRecettes } from '$lib/stores/recettes.js';
import { loadProgression } from '$lib/stores/progression.js';
import '../app.css';

const publicRoutes = ['/auth', '/auth/callback'];

let initialized = false;

onMount(async () => {
	await initAuth();
	initialized = true;
	if ($isAuthenticated) {
		await Promise.all([loadRecettes(), loadProgression()]);
	}
});

$: currentPath = $page.url.pathname;
$: isPublic = publicRoutes.some((r) => currentPath.startsWith(r));
$: shouldRender = isPublic || $isAuthenticated;

$: if (initialized && !$authLoading && !$isAuthenticated && !isPublic) {
	goto('/auth');
}

const navItems = [
	{ href: '/', icon: '🏠', label: 'Accueil' },
	{ href: '/recettes', icon: '📖', label: 'Recettes' },
	{ href: '/reviser', icon: '🧪', label: 'Réviser' },
	{ href: '/suivi', icon: '📊', label: 'Suivi' },
	{ href: '/profil', icon: '👤', label: 'Profil' }
];

function isActive(href) {
	if (href === '/') return currentPath === '/';
	return currentPath.startsWith(href);
}
</script>

{#if $authLoading || !initialized}
	<div style="display:flex;align-items:center;justify-content:center;min-height:100dvh">
		<div class="spinner" role="status" aria-label="Chargement"></div>
	</div>
{:else if shouldRender}
	<slot />

	{#if $isAuthenticated && !isPublic}
		<nav class="bottom-nav" aria-label="Navigation principale">
			{#each navItems as item (item.href)}
				<a
					href={item.href}
					class="nav-item"
					class:active={isActive(item.href)}
					aria-current={isActive(item.href) ? 'page' : undefined}
				>
					<span class="nav-icon" aria-hidden="true">{item.icon}</span>
					<span>{item.label}</span>
				</a>
			{/each}
		</nav>
	{/if}
{/if}

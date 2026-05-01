<script>
import { onMount } from 'svelte';
import { page } from '$app/stores';
import { goto } from '$app/navigation';
import { initAuth, isAuthenticated, authLoading } from '$lib/stores/auth.js';
import { loadRecettes } from '$lib/stores/recettes.js';
import { loadProgression } from '$lib/stores/progression.js';
import '../app.css';

const publicRoutes = ['/auth', '/auth/callback'];

onMount(async () => {
	await initAuth();
	if ($isAuthenticated) {
		await Promise.all([loadRecettes(), loadProgression()]);
	}
});

$: if (!$authLoading) {
	const isPublic = publicRoutes.some(r => $page.url.pathname.startsWith(r));
	if (!$isAuthenticated && !isPublic) goto('/auth');
}

const navItems = [
	{ href: '/',               icon: '🏠', label: 'Accueil' },
	{ href: '/recettes',       icon: '📖', label: 'Recettes' },
	{ href: '/suivi',          icon: '📊', label: 'Suivi' },
	{ href: '/ordonnancement', icon: '📋', label: 'Ordo' },
	{ href: '/carnet-pdf',     icon: '📄', label: 'Carnet' },
];

$: currentPath = $page.url.pathname;

function isActive(href) {
	if (href === '/') return currentPath === '/';
	return currentPath.startsWith(href);
}
</script>

{#if $authLoading}
<div style="display:flex;align-items:center;justify-content:center;min-height:100dvh;">
	<div class="spinner"></div>
</div>
{:else}
<slot />

{#if $isAuthenticated && !publicRoutes.some(r => currentPath.startsWith(r))}
<nav class="bottom-nav">
	{#each navItems as item}
	<a href={item.href} class="nav-item" class:active={isActive(item.href)}>
		<span class="nav-icon">{item.icon}</span>
		<span>{item.label}</span>
	</a>
	{/each}
</nav>
{/if}
{/if}

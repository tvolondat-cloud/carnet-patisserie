<script>
import { onMount } from 'svelte';
import { browser } from '$app/environment';
import { page } from '$app/stores';
import { goto } from '$app/navigation';
import { initAuth, isAuthenticated, authLoading } from '$lib/stores/auth.js';
import { loadRecettes } from '$lib/stores/recettes.js';
import { loadProgression } from '$lib/stores/progression.js';
import { initAnalytics, trackPageView } from '$lib/analytics.js';
import ConsentBanner from '$lib/components/ConsentBanner.svelte';
import '../app.css';

const publicRoutes = ['/auth', '/auth/callback', '/confidentialite', '/mentions-legales', '/cgu'];
const homeIsPublic = true;

let initialized = !browser;

onMount(async () => {
	initAnalytics();
	await initAuth();
	initialized = true;
	if ($isAuthenticated) {
		await Promise.all([loadRecettes(), loadProgression()]);
	}
});

$: currentPath = $page.url.pathname;
$: isPublic = publicRoutes.some((r) => currentPath.startsWith(r)) || (homeIsPublic && currentPath === '/');
$: shouldRender = isPublic || $isAuthenticated;

$: if (browser && initialized && currentPath) {
	trackPageView(currentPath);
}

$: if (browser && initialized && !$authLoading && !$isAuthenticated && !isPublic) {
	goto('/auth');
}

const navItems = [
	{ href: '/',          icon: '🏠', label: 'Accueil' },
	{ href: '/recettes',  icon: '📖', label: 'Recettes' },
	{ href: '/reviser',   icon: '🧪', label: 'Réviser' },
	{ href: '/suivi',     icon: '📊', label: 'Suivi' },
	{ href: '/profil',    icon: '👤', label: 'Profil' },
];

function isActive(href) {
	if (href === '/') return currentPath === '/';
	return currentPath.startsWith(href);
}
</script>

{#if shouldRender}
	<!-- Sidebar nav — desktop uniquement (affichée via CSS ≥ 1024px) -->
	{#if $isAuthenticated}
		<aside class="sidebar-nav" aria-label="Navigation principale">
			<div class="sidebar-brand">🍰 Brigade</div>
			{#each navItems as item (item.href)}
				<a
					href={item.href}
					class="sidebar-item"
					class:active={isActive(item.href)}
					aria-current={isActive(item.href) ? 'page' : undefined}
				>
					<span class="nav-icon" aria-hidden="true">{item.icon}</span>
					<span>{item.label}</span>
				</a>
			{/each}
		</aside>
	{/if}

	<slot />

	<!-- Bottom nav — mobile/tablette (cachée via CSS ≥ 1024px) -->
	{#if $isAuthenticated}
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

	<ConsentBanner />
{/if}

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

// Routes publiques :
// - /auth, /auth/callback : flux d'authentification
// - / : home publique (Landing pour anonymes, Dashboard pour authentifiés)
// - /confidentialite, /mentions-legales, /cgu : pages légales
const publicRoutes = ['/auth', '/auth/callback', '/confidentialite', '/mentions-legales', '/cgu'];
const homeIsPublic = true; // / accessible sans auth (Landing)

// Initialisé à true au SSR pour que le HTML prerendered contienne
// la Landing (SEO/GEO). Côté client, initAuth se déclenche dans onMount.
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

// Track page views (seulement côté client après initialisation)
$: if (browser && initialized && currentPath) {
	trackPageView(currentPath);
}

// Redirect uniquement côté client + après résolution de l'auth
$: if (browser && initialized && !$authLoading && !$isAuthenticated && !isPublic) {
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

<!--
  Pas de loading state au layout : on rend toujours la slot pour
  permettre le prerender SSR de la home (Landing avec SEO complet).
  Si l'user est sur une route protégée sans auth, le goto('/auth')
  côté client gère le redirect (juste un flash bref).
-->
{#if shouldRender}
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

	<ConsentBanner />
{/if}

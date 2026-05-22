<script>
import { onMount } from 'svelte';
import { events } from '$lib/analytics.js';

let scrolled = false;
let menuOpen = false;

onMount(() => {
	const onScroll = () => (scrolled = window.scrollY > 24);
	window.addEventListener('scroll', onScroll, { passive: true });
	onScroll();
	return () => window.removeEventListener('scroll', onScroll);
});

function trackCta(loc) {
	try {
		window.dataLayer?.push({ cta_location: loc });
	} catch {}
}
</script>

<header class="ld-header" class:scrolled>
	<div class="ld-container ld-header-inner">
		<a href="/" class="ld-logo" aria-label="Brigade Sucrée — Accueil">
			<img src="/logo.svg" alt="" class="ld-logo-img" width="40" height="40" />
			<span class="ld-logo-text">Brigade <span>Sucrée</span></span>
		</a>

		<nav class="ld-nav" aria-label="Navigation principale">
			<a href="#features" class="ld-nav-link">Fonctionnalités</a>
			<a href="#how" class="ld-nav-link">Comment ça marche</a>
			<a href="#pricing" class="ld-nav-link">Tarifs</a>
			<a href="#faq" class="ld-nav-link">FAQ</a>
		</nav>

		<div class="ld-header-cta">
			<a
				href="/auth"
				class="ld-btn ld-btn-ghost ld-header-login"
				data-track="cta:header-login"
				on:click={() => trackCta('header_login')}
			>
				Se connecter
			</a>
			<a
				href="/auth"
				class="ld-btn ld-btn-primary"
				data-track="cta:header-signup"
				on:click={() => trackCta('header_signup')}
			>
				Commencer
			</a>

			<button
				type="button"
				class="ld-burger"
				aria-label="Menu"
				aria-expanded={menuOpen}
				on:click={() => (menuOpen = !menuOpen)}
			>
				<span></span><span></span><span></span>
			</button>
		</div>
	</div>

	{#if menuOpen}
		<nav class="ld-mobile-menu" aria-label="Menu mobile">
			<a href="#features" on:click={() => (menuOpen = false)}>Fonctionnalités</a>
			<a href="#how" on:click={() => (menuOpen = false)}>Comment ça marche</a>
			<a href="#pricing" on:click={() => (menuOpen = false)}>Tarifs</a>
			<a href="#faq" on:click={() => (menuOpen = false)}>FAQ</a>
			<a href="/auth" class="mobile-cta">Commencer gratuit</a>
		</nav>
	{/if}
</header>

<style>
.ld-header {
	position: sticky;
	top: 0;
	z-index: 50;
	background: rgba(250, 241, 226, 0.6);
	backdrop-filter: blur(10px);
	-webkit-backdrop-filter: blur(10px);
	transition: background 0.2s, box-shadow 0.2s, border-color 0.2s;
	border-bottom: 1px solid transparent;
}
.ld-header.scrolled {
	background: rgba(250, 241, 226, 0.92);
	box-shadow: 0 4px 14px rgba(31, 77, 69, 0.06);
	border-bottom-color: rgba(31, 77, 69, 0.06);
}

.ld-header-inner {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 14px 24px;
	gap: 16px;
}

.ld-logo {
	display: flex;
	align-items: center;
	gap: 10px;
	text-decoration: none;
	color: var(--ld-deep);
	font-weight: 800;
}
.ld-logo-img {
	width: 40px;
	height: 40px;
	object-fit: contain;
	display: block;
	border-radius: 10px;
}
.ld-logo-text { font-size: 1.05rem; line-height: 1; }
.ld-logo-text span { color: var(--ld-orange); }

.ld-nav { display: flex; gap: 28px; }
.ld-nav-link {
	color: var(--ld-text-muted);
	text-decoration: none;
	font-size: 0.92rem;
	font-weight: 500;
	transition: color 0.15s;
}
.ld-nav-link:hover { color: var(--ld-deep); }

.ld-header-cta {
	display: flex;
	align-items: center;
	gap: 8px;
}

.ld-burger {
	display: none;
	flex-direction: column;
	gap: 5px;
	width: 36px;
	height: 36px;
	border: none;
	background: transparent;
	padding: 8px;
	cursor: pointer;
}
.ld-burger span {
	display: block;
	width: 100%;
	height: 2.5px;
	background: var(--ld-deep);
	border-radius: 2px;
}

.ld-mobile-menu {
	display: flex;
	flex-direction: column;
	background: var(--ld-cream);
	padding: 16px 24px;
	gap: 8px;
	border-top: 1px solid rgba(31, 77, 69, 0.08);
}
.ld-mobile-menu a {
	padding: 12px;
	border-radius: 10px;
	color: var(--ld-deep);
	text-decoration: none;
	font-weight: 600;
}
.ld-mobile-menu a:hover { background: var(--ld-cream-dark); }
.ld-mobile-menu a.mobile-cta {
	background: var(--ld-orange);
	color: var(--ld-white);
	text-align: center;
	margin-top: 8px;
}

@media (max-width: 920px) {
	.ld-nav { display: none; }
	.ld-header-login { display: none; }
	.ld-burger { display: flex; }
}
</style>

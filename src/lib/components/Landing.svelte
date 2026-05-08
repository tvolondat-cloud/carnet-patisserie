<script>
import LandingHeader from './landing/LandingHeader.svelte';
import LandingHero from './landing/LandingHero.svelte';
import LandingFeatures from './landing/LandingFeatures.svelte';
import LandingHowItWorks from './landing/LandingHowItWorks.svelte';
import LandingPersonas from './landing/LandingPersonas.svelte';
import LandingComparison from './landing/LandingComparison.svelte';
import LandingPricing from './landing/LandingPricing.svelte';
import LandingFAQ from './landing/LandingFAQ.svelte';
import LandingCTA from './landing/LandingCTA.svelte';
import LandingFooter from './landing/LandingFooter.svelte';
import './landing/landing.css';
</script>

<svelte:head>
	<title>Brigade Sucrée — Réussis ton CAP Pâtissier sans stress</title>
	<meta name="description" content="L'app des étudiants CAP Pâtissier et des passionnés : 17 recettes du référentiel, mode laboratoire (test + quiz + chrono), suivi de progression, carnet PDF. Bêta gratuite." />
	<meta property="og:title" content="Brigade Sucrée — Réussis ton CAP Pâtissier sans stress" />
	<meta property="og:description" content="L'app des étudiants CAP Pâtissier et des passionnés. 17 recettes, mode laboratoire, suivi de progression. Bêta gratuite." />
</svelte:head>

<div class="ld">
	<LandingHeader />
	<main>
		<LandingHero />
		<LandingFeatures />
		<LandingHowItWorks />
		<LandingPersonas />
		<LandingComparison />
		<LandingPricing />
		<LandingFAQ />
		<LandingCTA />
	</main>
	<LandingFooter />
</div>

<style>
.ld :global(html) { scroll-behavior: smooth; }
.ld :global(main) { display: block; }
</style>

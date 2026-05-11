<script>
import LandingSEO from './landing/LandingSEO.svelte';
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

<LandingSEO />

<div class="ld">
	<LandingHeader />
	<main id="main">
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

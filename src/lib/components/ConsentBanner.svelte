<script>
import { consentState, acceptConsent, denyConsent } from '$lib/analytics.js';

$: visible = $consentState === 'pending';
</script>

{#if visible}
	<div class="consent-banner" role="dialog" aria-labelledby="consent-title" aria-describedby="consent-desc">
		<div class="consent-content">
			<h2 id="consent-title" class="consent-title">🍪 Cookies & confidentialité</h2>
			<p id="consent-desc" class="consent-desc">
				Brigade Sucrée utilise des cookies de mesure d'audience (Google Analytics) pour comprendre comment l'app
				est utilisée et l'améliorer. Aucune donnée personnelle n'est revendue.
			</p>
			<div class="consent-actions">
				<button type="button" class="btn btn-ghost btn-sm" on:click={denyConsent}>
					Refuser
				</button>
				<button type="button" class="btn btn-primary btn-sm" on:click={acceptConsent}>
					Accepter
				</button>
			</div>
		</div>
	</div>
{/if}

<style>
.consent-banner {
	position: fixed;
	bottom: calc(var(--nav-h, 0px) + var(--safe-bottom, 0px) + 8px);
	left: 8px;
	right: 8px;
	background: var(--color-surface);
	border: 1px solid var(--color-border);
	border-radius: var(--radius-lg);
	padding: 16px;
	box-shadow: var(--shadow-lg);
	z-index: 1000;
	max-width: 480px;
	margin: 0 auto;
	animation: consent-in 0.3s ease;
}
@keyframes consent-in {
	from { transform: translateY(20px); opacity: 0; }
	to { transform: translateY(0); opacity: 1; }
}
.consent-title {
	font-size: 0.95rem;
	font-weight: 700;
	margin-bottom: 6px;
}
.consent-desc {
	font-size: 0.8rem;
	color: var(--color-text-2);
	line-height: 1.5;
	margin-bottom: 12px;
}
.consent-actions {
	display: flex;
	justify-content: flex-end;
	gap: 8px;
}
@media (prefers-reduced-motion: reduce) {
	.consent-banner { animation: none; }
}
</style>

<script>
import { consentState, acceptAllConsent, denyAllConsent } from '$lib/analytics.js';
import CookieDrawer from './CookieDrawer.svelte';

let drawerOpen = false;

$: visible = $consentState === 'pending';

function openDrawer() {
	drawerOpen = true;
}
</script>

{#if visible}
	<!-- Overlay subtil — pas de fermeture au clic outside (CNIL exige action explicite) -->
	<div class="consent-overlay" aria-hidden="true"></div>

	<div class="consent-wrapper">
		<div
			class="consent-card"
			role="dialog"
			aria-live="polite"
			aria-label="Préférences cookies"
			aria-modal="true"
		>
			<!-- Confetti décoratif top-right -->
			<span class="consent-sparkle" aria-hidden="true">✨</span>

			<div class="consent-header">
				<span class="consent-emoji" aria-hidden="true">🍪</span>
				<div class="consent-title-block">
					<h2 class="consent-title">
						Cookies, vraiment ?
						<span class="consent-title-accent">On te laisse choisir.</span>
					</h2>
					<p class="consent-desc">
						On en utilise pour mesurer ce qui marche sur l'app, pas de revente, pas de magie noire.
						Tu acceptes, tu refuses ou tu personnalises, c'est toi qui vois.
						<a href="/confidentialite" class="consent-link">En savoir plus</a>.
					</p>
				</div>
			</div>

			<div class="consent-actions">
				<button type="button" class="consent-btn consent-btn-secondary" on:click={denyAllConsent} data-track="consent:reject-all">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14" aria-hidden="true">
						<line x1="18" y1="6" x2="6" y2="18"></line>
						<line x1="6" y1="6" x2="18" y2="18"></line>
					</svg>
					Non merci
				</button>

				<button type="button" class="consent-btn consent-btn-secondary" on:click={openDrawer} data-track="consent:customize">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14" aria-hidden="true">
						<line x1="20" y1="7" x2="4" y2="7"></line>
						<line x1="9" y1="7" x2="9" y2="3"></line>
						<line x1="20" y1="17" x2="4" y2="17"></line>
						<line x1="15" y1="21" x2="15" y2="13"></line>
					</svg>
					Au choix
				</button>

				<button type="button" class="consent-btn consent-btn-primary" on:click={acceptAllConsent} data-track="consent:accept-all">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14" aria-hidden="true">
						<polyline points="20 6 9 17 4 12"></polyline>
					</svg>
					Allons-y
				</button>
			</div>
		</div>
	</div>
{/if}

{#if drawerOpen}
	<CookieDrawer on:close={() => (drawerOpen = false)} />
{/if}

<style>
.consent-overlay {
	position: fixed;
	inset: 0;
	z-index: 999;
	background: rgba(15, 23, 42, 0.4);
	backdrop-filter: blur(4px);
	-webkit-backdrop-filter: blur(4px);
	animation: consent-fade-in 0.3s ease;
}

.consent-wrapper {
	position: fixed;
	inset: 0;
	z-index: 1000;
	display: grid;
	place-items: center;
	pointer-events: none;
	padding: 16px;
	padding-bottom: calc(16px + var(--safe-bottom, 0px));
}

.consent-card {
	pointer-events: auto;
	position: relative;
	width: 100%;
	max-width: 28rem;
	border-radius: 18px;
	border: 2px solid color-mix(in srgb, var(--color-brand) 20%, transparent);
	background:
		linear-gradient(135deg,
			var(--color-surface) 0%,
			var(--color-surface) 50%,
			color-mix(in srgb, var(--color-brand) 5%, var(--color-surface)) 100%);
	box-shadow:
		0 24px 60px -12px color-mix(in srgb, var(--color-brand) 30%, transparent),
		0 0 0 1px rgba(0, 0, 0, 0.04);
	padding: 18px 20px;
	animation: consent-zoom-in 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.consent-sparkle {
	position: absolute;
	top: -10px;
	right: -10px;
	width: 28px;
	height: 28px;
	display: grid;
	place-items: center;
	border-radius: 50%;
	background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
	font-size: 0.95rem;
	box-shadow: 0 4px 12px rgba(245, 158, 11, 0.4);
	transform: rotate(12deg);
}

.consent-header {
	display: flex;
	gap: 12px;
	align-items: flex-start;
	margin-bottom: 14px;
}

.consent-emoji {
	flex-shrink: 0;
	width: 44px;
	height: 44px;
	display: grid;
	place-items: center;
	border-radius: 12px;
	background: linear-gradient(135deg,
		color-mix(in srgb, var(--color-brand) 18%, var(--color-surface-2)),
		color-mix(in srgb, var(--color-brand) 8%, var(--color-surface-2)));
	font-size: 1.6rem;
	animation: consent-cookie-wiggle 2s ease-in-out infinite;
}

.consent-title-block {
	min-width: 0;
}

.consent-title {
	font-size: 0.92rem;
	font-weight: 800;
	color: var(--color-text);
	line-height: 1.3;
	margin: 0;
}

.consent-title-accent {
	color: var(--color-brand);
}

.consent-desc {
	margin: 6px 0 0;
	font-size: 0.78rem;
	color: var(--color-text-2);
	line-height: 1.5;
}

.consent-link {
	font-weight: 600;
	color: var(--color-brand);
	text-decoration: underline;
	text-underline-offset: 2px;
}
.consent-link:hover { opacity: 0.8; }

.consent-actions {
	display: grid;
	grid-template-columns: 1fr 1fr 1fr;
	gap: 8px;
}

.consent-btn {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 6px;
	padding: 10px 12px;
	border-radius: 10px;
	font-size: 0.78rem;
	font-weight: 600;
	transition: all 0.15s ease;
	border: 1px solid var(--color-border);
	cursor: pointer;
	white-space: nowrap;
}

.consent-btn:active { transform: scale(0.97); }

.consent-btn-secondary {
	background: var(--color-surface);
	color: var(--color-text);
}
.consent-btn-secondary:hover {
	background: var(--color-surface-2);
	border-color: var(--color-text-3);
}

.consent-btn-primary {
	background: linear-gradient(135deg, var(--color-brand) 0%, var(--color-brand-dark) 100%);
	border-color: var(--color-brand);
	color: #fff;
	font-weight: 800;
	box-shadow: 0 4px 12px color-mix(in srgb, var(--color-brand) 30%, transparent);
}
.consent-btn-primary:hover {
	transform: translateY(-1px);
	box-shadow: 0 6px 18px color-mix(in srgb, var(--color-brand) 40%, transparent);
}
.consent-btn-primary:active { transform: translateY(0) scale(0.97); }

/* Sur très petit écran : empile les boutons */
@media (max-width: 360px) {
	.consent-actions {
		grid-template-columns: 1fr;
	}
}

@keyframes consent-fade-in {
	from { opacity: 0; }
	to { opacity: 1; }
}

@keyframes consent-zoom-in {
	from { opacity: 0; transform: scale(0.95); }
	to { opacity: 1; transform: scale(1); }
}

@keyframes consent-cookie-wiggle {
	0%, 100% { transform: rotate(0deg); }
	25% { transform: rotate(-8deg); }
	75% { transform: rotate(8deg); }
}

@media (prefers-reduced-motion: reduce) {
	.consent-overlay,
	.consent-card,
	.consent-emoji {
		animation: none !important;
	}
}
</style>

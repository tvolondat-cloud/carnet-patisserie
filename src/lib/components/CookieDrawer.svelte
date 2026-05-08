<script>
import { createEventDispatcher } from 'svelte';
import { saveCategoryConsent } from '$lib/analytics.js';

const dispatch = createEventDispatcher();

let analytics = false;
let marketing = false;

function close() {
	dispatch('close');
}

function save() {
	saveCategoryConsent({ analytics, marketing });
	close();
}

function handleKey(e) {
	if (e.key === 'Escape') close();
}
</script>

<svelte:window on:keydown={handleKey} />

<div class="drawer-overlay" on:click={close} aria-hidden="true"></div>

<div
	class="drawer"
	role="dialog"
	aria-label="Personnaliser les cookies"
	aria-modal="true"
>
	<div class="drawer-header">
		<div>
			<h2 class="drawer-title">⚙️ Personnaliser</h2>
			<p class="drawer-subtitle">Active uniquement ce qui te va.</p>
		</div>
		<button type="button" class="drawer-close" on:click={close} aria-label="Fermer">
			<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="20" height="20" aria-hidden="true">
				<line x1="18" y1="6" x2="6" y2="18"></line>
				<line x1="6" y1="6" x2="18" y2="18"></line>
			</svg>
		</button>
	</div>

	<div class="drawer-body">
		<!-- Catégorie : Nécessaires (lock on) -->
		<div class="cat cat-locked">
			<div class="cat-info">
				<div class="cat-name">🔒 Nécessaires <span class="cat-required">requis</span></div>
				<p class="cat-desc">
					Indispensables au fonctionnement de l'app : session, authentification, préférences.
					Toujours actifs.
				</p>
			</div>
			<div class="toggle toggle-on toggle-locked" aria-hidden="true">
				<div class="toggle-thumb"></div>
			</div>
		</div>

		<!-- Catégorie : Analytics -->
		<label class="cat">
			<div class="cat-info">
				<div class="cat-name">📊 Mesure d'audience</div>
				<p class="cat-desc">
					Google Analytics 4 — pour comprendre comment tu utilises l'app et l'améliorer.
					Anonymisé, pas de revente.
				</p>
			</div>
			<input type="checkbox" bind:checked={analytics} class="toggle-input" />
			<div class="toggle" class:toggle-on={analytics} aria-hidden="true">
				<div class="toggle-thumb"></div>
			</div>
		</label>

		<!-- Catégorie : Marketing -->
		<label class="cat">
			<div class="cat-info">
				<div class="cat-name">🎯 Marketing <span class="cat-soon">bientôt</span></div>
				<p class="cat-desc">
					Personnaliser les annonces et mesurer l'efficacité des campagnes.
					Aucun cookie marketing actuellement déployé.
				</p>
			</div>
			<input type="checkbox" bind:checked={marketing} class="toggle-input" />
			<div class="toggle" class:toggle-on={marketing} aria-hidden="true">
				<div class="toggle-thumb"></div>
			</div>
		</label>
	</div>

	<div class="drawer-footer">
		<a href="/confidentialite" class="drawer-link">📜 Politique de confidentialité</a>
		<button type="button" class="drawer-save" on:click={save} data-track="consent:save-custom">
			Enregistrer mes choix
		</button>
	</div>
</div>

<style>
.drawer-overlay {
	position: fixed;
	inset: 0;
	z-index: 1100;
	background: rgba(15, 23, 42, 0.55);
	backdrop-filter: blur(6px);
	-webkit-backdrop-filter: blur(6px);
	animation: drawer-overlay-in 0.25s ease;
}

.drawer {
	position: fixed;
	z-index: 1101;
	left: 50%;
	top: 50%;
	transform: translate(-50%, -50%);
	width: calc(100% - 32px);
	max-width: 30rem;
	max-height: calc(100dvh - 64px);
	display: flex;
	flex-direction: column;
	background: var(--color-surface);
	border-radius: 18px;
	box-shadow: 0 30px 80px rgba(0, 0, 0, 0.3);
	overflow: hidden;
	animation: drawer-in 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.drawer-header {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	gap: 12px;
	padding: 18px 20px 12px;
	border-bottom: 1px solid var(--color-border);
}

.drawer-title {
	font-size: 1.1rem;
	font-weight: 800;
	margin: 0;
}

.drawer-subtitle {
	font-size: 0.8rem;
	color: var(--color-text-2);
	margin: 4px 0 0;
}

.drawer-close {
	flex-shrink: 0;
	width: 32px;
	height: 32px;
	border-radius: 8px;
	border: none;
	background: var(--color-surface-2);
	color: var(--color-text-2);
	cursor: pointer;
	display: grid;
	place-items: center;
	transition: background 0.15s;
}
.drawer-close:hover { background: var(--color-border); }

.drawer-body {
	overflow-y: auto;
	padding: 12px 20px;
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.cat {
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 14px;
	border-radius: 12px;
	border: 1px solid var(--color-border);
	background: var(--color-surface);
	cursor: pointer;
	transition: border-color 0.15s, background 0.15s;
}
.cat:hover:not(.cat-locked) {
	border-color: var(--color-brand);
	background: color-mix(in srgb, var(--color-brand) 4%, var(--color-surface));
}
.cat-locked {
	cursor: default;
	background: var(--color-surface-2);
	opacity: 0.85;
}

.cat-info {
	flex: 1;
	min-width: 0;
}

.cat-name {
	font-size: 0.88rem;
	font-weight: 700;
	margin-bottom: 4px;
	display: flex;
	align-items: center;
	gap: 6px;
	flex-wrap: wrap;
}

.cat-required, .cat-soon {
	font-size: 0.65rem;
	font-weight: 600;
	padding: 2px 8px;
	border-radius: var(--radius-full);
	letter-spacing: 0.02em;
	text-transform: uppercase;
}
.cat-required {
	background: var(--color-surface);
	color: var(--color-text-3);
	border: 1px solid var(--color-border);
}
.cat-soon {
	background: #fef3c7;
	color: #92400e;
}

.cat-desc {
	font-size: 0.78rem;
	color: var(--color-text-2);
	line-height: 1.5;
	margin: 0;
}

/* Toggle */
.toggle-input {
	position: absolute;
	width: 1px;
	height: 1px;
	opacity: 0;
	pointer-events: none;
}

.toggle {
	flex-shrink: 0;
	width: 40px;
	height: 24px;
	border-radius: 12px;
	background: var(--color-border);
	position: relative;
	transition: background 0.2s;
}
.toggle-on {
	background: var(--color-brand);
}
.toggle-thumb {
	position: absolute;
	top: 2px;
	left: 2px;
	width: 20px;
	height: 20px;
	background: #fff;
	border-radius: 50%;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
	transition: transform 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}
.toggle-on .toggle-thumb { transform: translateX(16px); }
.toggle-locked { opacity: 0.7; }

.drawer-footer {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 12px;
	padding: 14px 20px;
	border-top: 1px solid var(--color-border);
	background: var(--color-surface-2);
	flex-wrap: wrap;
}

.drawer-link {
	font-size: 0.78rem;
	color: var(--color-text-2);
	text-decoration: underline;
	text-underline-offset: 2px;
}
.drawer-link:hover { color: var(--color-brand); }

.drawer-save {
	padding: 10px 18px;
	border-radius: 10px;
	background: linear-gradient(135deg, var(--color-brand) 0%, var(--color-brand-dark) 100%);
	color: #fff;
	font-weight: 800;
	font-size: 0.82rem;
	border: none;
	cursor: pointer;
	box-shadow: 0 4px 12px color-mix(in srgb, var(--color-brand) 30%, transparent);
	transition: transform 0.15s, box-shadow 0.15s;
}
.drawer-save:hover {
	transform: translateY(-1px);
	box-shadow: 0 6px 18px color-mix(in srgb, var(--color-brand) 40%, transparent);
}
.drawer-save:active { transform: scale(0.97); }

@keyframes drawer-overlay-in {
	from { opacity: 0; }
	to { opacity: 1; }
}

@keyframes drawer-in {
	from { opacity: 0; transform: translate(-50%, -45%) scale(0.95); }
	to { opacity: 1; transform: translate(-50%, -50%) scale(1); }
}

@media (prefers-reduced-motion: reduce) {
	.drawer-overlay, .drawer { animation: none !important; }
	.toggle, .toggle-thumb { transition: none !important; }
}
</style>

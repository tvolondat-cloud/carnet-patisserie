<script>
import { onMount } from 'svelte';
import { findTerm } from '$lib/data/glossaire.js';

/** Slug de l'entrée du glossaire (cf. src/lib/data/glossaire.js). */
export let key;

const entry = findTerm(key);
let open = false;
let node;

function toggle(e) {
	e?.stopPropagation();
	open = !open;
}
function close() { open = false; }
function onWinClick(e) { if (open && node && !node.contains(e.target)) close(); }
function onEsc(e) { if (open && e.key === 'Escape') close(); }

onMount(() => {
	window.addEventListener('click', onWinClick);
	window.addEventListener('keydown', onEsc);
	return () => {
		window.removeEventListener('click', onWinClick);
		window.removeEventListener('keydown', onEsc);
	};
});
</script>

<span class="g-term" bind:this={node}>
	<button
		type="button"
		class="g-trigger"
		on:click={toggle}
		aria-expanded={open}
		aria-describedby={open ? `g-${key}` : undefined}
		title={entry ? `${entry.term} — clique pour la définition` : key}
	>
		<slot>{entry?.term ?? key}</slot>
	</button>

	{#if open && entry}
	<span class="g-bubble" id="g-{key}" role="tooltip">
		<strong>{entry.term}</strong>
		<span class="g-short">{entry.short}</span>
		<a class="g-more" href="/glossaire#{key}" on:click={close}>Voir le glossaire →</a>
	</span>
	{/if}
</span>

<style>
.g-term { position: relative; display: inline-block; }
.g-trigger {
	background: none;
	border: none;
	padding: 0;
	margin: 0;
	font: inherit;
	color: inherit;
	border-bottom: 1px dotted currentColor;
	cursor: help;
	line-height: inherit;
}
.g-trigger:focus-visible {
	outline: 2px solid var(--color-brand);
	outline-offset: 2px;
	border-radius: 2px;
}
.g-bubble {
	position: absolute;
	top: calc(100% + 6px);
	left: 0;
	background: var(--color-text);
	color: #fff;
	padding: 10px 12px;
	border-radius: 10px;
	font-size: 0.78rem;
	font-weight: 400;
	line-height: 1.45;
	z-index: 100;
	min-width: 240px;
	max-width: min(320px, calc(100vw - 32px));
	display: flex;
	flex-direction: column;
	gap: 6px;
	box-shadow: 0 12px 28px rgba(0, 0, 0, 0.22);
	white-space: normal;
	text-align: left;
}
.g-bubble strong { font-size: 0.86rem; color: #fff; }
.g-short { color: rgba(255, 255, 255, 0.92); }
.g-more {
	color: var(--color-brand-light, #aab3ff);
	text-decoration: underline;
	font-size: 0.74rem;
	font-weight: 600;
	align-self: flex-start;
}
@media (max-width: 480px) {
	.g-bubble { left: auto; right: 0; }
}
</style>

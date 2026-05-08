<script>
/**
 * Gingerbread mascotte — SVG inline minimaliste, plusieurs poses.
 * Inspiré de la DA fournie : corps brun, sablé, chef hat, tablier vert sapin.
 *
 * Les SVG sont volontairement simples et stylisés (pas réalistes) pour
 * rester légers en kilooctets. Remplacer par les illustrations finales
 * une fois générées via Midjourney avec la DA.
 *
 * @typedef {'learning'|'baking'|'celebrating'|'thinking'|'default'} Pose
 */

/** @type {Pose} */
export let pose = 'default';

/** Taille en pixels (carré) */
export let size = 160;
</script>

<svg
	width={size}
	height={size}
	viewBox="0 0 200 200"
	xmlns="http://www.w3.org/2000/svg"
	role="img"
	aria-label="Mascotte Brigade Sucrée"
	class="gingerbread"
>
	<defs>
		<radialGradient id="bodyGradient" cx="50%" cy="40%" r="60%">
			<stop offset="0%" stop-color="#C8884E" />
			<stop offset="100%" stop-color="#A86D3D" />
		</radialGradient>
	</defs>

	<!-- Toque (plus grande pour learning/celebrating) -->
	{#if pose === 'celebrating'}
		<!-- Confetti -->
		<circle cx="40" cy="40" r="3" fill="#D2683D" />
		<circle cx="160" cy="50" r="3" fill="#1F4D45" />
		<rect x="155" y="30" width="6" height="3" fill="#E89855" transform="rotate(20 158 31)" />
		<rect x="35" y="20" width="6" height="3" fill="#1F4D45" transform="rotate(-30 38 21)" />
	{/if}

	<!-- Toque chef -->
	<ellipse cx="100" cy="35" rx="32" ry="22" fill="#FFFFFF" />
	<ellipse cx="100" cy="40" rx="40" ry="12" fill="#FFFFFF" />
	<rect x="75" y="42" width="50" height="8" fill="#F4E5D2" rx="2" />

	<!-- Corps gingerbread (sablé) -->
	<ellipse cx="100" cy="120" rx="50" ry="55" fill="url(#bodyGradient)" />

	<!-- Bras -->
	{#if pose === 'celebrating'}
		<!-- Bras en l'air -->
		<ellipse cx="55" cy="80" rx="12" ry="22" fill="url(#bodyGradient)" transform="rotate(-30 55 80)" />
		<ellipse cx="145" cy="80" rx="12" ry="22" fill="url(#bodyGradient)" transform="rotate(30 145 80)" />
	{:else if pose === 'thinking'}
		<!-- Main vers menton -->
		<ellipse cx="135" cy="100" rx="12" ry="20" fill="url(#bodyGradient)" transform="rotate(45 135 100)" />
		<ellipse cx="60" cy="120" rx="11" ry="22" fill="url(#bodyGradient)" />
	{:else}
		<!-- Bras neutres -->
		<ellipse cx="55" cy="125" rx="11" ry="22" fill="url(#bodyGradient)" transform="rotate(-15 55 125)" />
		<ellipse cx="145" cy="125" rx="11" ry="22" fill="url(#bodyGradient)" transform="rotate(15 145 125)" />
	{/if}

	<!-- Tablier vert sapin -->
	<path d="M 70 120 L 130 120 L 135 175 L 65 175 Z" fill="#1F4D45" />
	<rect x="68" y="120" width="64" height="3" fill="#1A4039" />

	<!-- Foulard cou -->
	<path d="M 78 95 Q 100 105 122 95 L 120 105 Q 100 113 80 105 Z" fill="#1F4D45" />

	<!-- Détails sablé (icing blanc sur le corps) -->
	<path d="M 75 165 Q 85 162 95 165 Q 105 162 115 165 Q 125 162 135 165" stroke="#FFFFFF" stroke-width="2" fill="none" stroke-linecap="round" />

	<!-- Visage -->
	<!-- Yeux -->
	<ellipse cx="85" cy="78" rx="3.5" ry="4" fill="#3D2817" />
	<ellipse cx="115" cy="78" rx="3.5" ry="4" fill="#3D2817" />
	<!-- Reflet yeux -->
	<circle cx="86" cy="76.5" r="1" fill="#FFFFFF" />
	<circle cx="116" cy="76.5" r="1" fill="#FFFFFF" />

	<!-- Bouche selon pose -->
	{#if pose === 'celebrating' || pose === 'baking'}
		<path d="M 88 90 Q 100 99 112 90" stroke="#3D2817" stroke-width="2.5" fill="none" stroke-linecap="round" />
		<path d="M 90 91 Q 100 96 110 91 Z" fill="#8B4040" opacity="0.6" />
	{:else if pose === 'thinking'}
		<ellipse cx="100" cy="91" rx="4" ry="3" fill="#3D2817" />
	{:else}
		<path d="M 90 89 Q 100 94 110 89" stroke="#3D2817" stroke-width="2" fill="none" stroke-linecap="round" />
	{/if}

	<!-- Joues roses -->
	<circle cx="73" cy="86" r="4" fill="#E89855" opacity="0.5" />
	<circle cx="127" cy="86" r="4" fill="#E89855" opacity="0.5" />

	<!-- Accessoire selon pose -->
	{#if pose === 'baking'}
		<!-- Fouet -->
		<line x1="60" y1="135" x2="40" y2="155" stroke="#3D2817" stroke-width="3" stroke-linecap="round" />
		<ellipse cx="35" cy="160" rx="9" ry="12" fill="none" stroke="#3D2817" stroke-width="1.5" />
		<line x1="35" y1="148" x2="35" y2="172" stroke="#3D2817" stroke-width="1" />
		<line x1="26" y1="158" x2="44" y2="158" stroke="#3D2817" stroke-width="1" />
	{:else if pose === 'learning'}
		<!-- Livre -->
		<rect x="30" y="135" width="40" height="30" fill="#1F4D45" rx="2" />
		<rect x="32" y="137" width="36" height="26" fill="#F4E5D2" rx="1" />
		<line x1="50" y1="138" x2="50" y2="162" stroke="#1F4D45" stroke-width="0.8" />
		<line x1="36" y1="143" x2="46" y2="143" stroke="#A86D3D" stroke-width="1" />
		<line x1="36" y1="148" x2="46" y2="148" stroke="#A86D3D" stroke-width="1" />
		<line x1="54" y1="143" x2="64" y2="143" stroke="#A86D3D" stroke-width="1" />
		<line x1="54" y1="148" x2="64" y2="148" stroke="#A86D3D" stroke-width="1" />
	{:else if pose === 'thinking'}
		<!-- Ampoule -->
		<circle cx="170" cy="40" r="8" fill="#FFD700" />
		<rect x="167" y="48" width="6" height="3" fill="#888" />
		<line x1="170" y1="25" x2="170" y2="22" stroke="#FFD700" stroke-width="1.5" />
		<line x1="183" y1="40" x2="186" y2="40" stroke="#FFD700" stroke-width="1.5" />
		<line x1="180" y1="30" x2="183" y2="27" stroke="#FFD700" stroke-width="1.5" />
	{/if}

	<!-- Boutons tablier -->
	<circle cx="90" cy="135" r="2.5" fill="#FFFFFF" />
	<circle cx="110" cy="135" r="2.5" fill="#FFFFFF" />

	<!-- Pieds -->
	<ellipse cx="80" cy="180" rx="13" ry="6" fill="#A86D3D" />
	<ellipse cx="120" cy="180" rx="13" ry="6" fill="#A86D3D" />
</svg>

<style>
.gingerbread {
	display: block;
	user-select: none;
}
</style>

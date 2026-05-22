import sharp from 'sharp';
import { writeFileSync, mkdirSync } from 'node:fs';

// Génère le jeu d'icônes (favicon, apple-touch, PWA 192/512, maskable)
// à partir de la marque fournie : scripts/favicon-source.png.
// Régénérer avec : npm run icons

mkdirSync('static', { recursive: true });

const SOURCE = 'scripts/favicon-source.png';
const CREAM = { r: 250, g: 241, b: 226, alpha: 1 }; // fond clair (iOS n'aime pas la transparence)
const TRANSPARENT = { r: 0, g: 0, b: 0, alpha: 0 };

/** Logo redimensionné (contain) centré sur un carré. */
async function squareIcon(size, { background = TRANSPARENT, scale = 1 } = {}) {
	const inner = Math.round(size * scale);
	const logo = await sharp(SOURCE)
		.resize(inner, inner, { fit: 'contain', background: TRANSPARENT })
		.toBuffer();
	const pad = Math.round((size - inner) / 2);
	return sharp({ create: { width: size, height: size, channels: 4, background } })
		.composite([{ input: logo, top: pad, left: pad }])
		.png()
		.toBuffer();
}

const tasks = [
	// Favicons / PWA : fond transparent
	{ name: 'favicon-32.png', buf: () => squareIcon(32) },
	{ name: 'icon-192.png', buf: () => squareIcon(192) },
	{ name: 'icon-512.png', buf: () => squareIcon(512) },
	// Apple touch : fond plein (iOS rend la transparence en noir)
	{ name: 'apple-touch-icon.png', buf: () => squareIcon(180, { background: CREAM, scale: 0.86 }) },
	// Maskable : zone de sécurité ~80 % sur fond plein
	{ name: 'icon-maskable-512.png', buf: () => squareIcon(512, { background: CREAM, scale: 0.8 }) }
];

for (const { name, buf } of tasks) {
	writeFileSync(`static/${name}`, await buf());
	console.log(`✓ static/${name}`);
}

// favicon.ico : on y écrit le PNG 32px (les navigateurs l'acceptent —
// même approche que la version précédente).
writeFileSync('static/favicon.ico', await squareIcon(32));
console.log('✓ static/favicon.ico');

console.log('\nIcônes générées depuis', SOURCE, '→ static/.');

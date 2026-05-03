import sharp from 'sharp';
import { writeFileSync, mkdirSync } from 'node:fs';

mkdirSync('static', { recursive: true });

const BRAND = '#6c63ff';
const BRAND_DARK = '#4c43df';

const baseSvg = (size, padding = 0) => {
	const inner = size - padding * 2;
	const fontSize = inner * 0.62;
	return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${size} ${size}">
  <defs>
    <linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="${BRAND}"/>
      <stop offset="100%" stop-color="${BRAND_DARK}"/>
    </linearGradient>
  </defs>
  <rect fill="url(#g)" width="${size}" height="${size}" rx="${size * 0.18}"/>
  <text x="${size / 2}" y="${size / 2 + fontSize * 0.36}" font-family="Arial, Helvetica, sans-serif" font-size="${fontSize}" font-weight="900" fill="white" text-anchor="middle">B</text>
</svg>`;
};

const maskableSvg = (size) => {
	const safeArea = size * 0.8;
	const offset = (size - safeArea) / 2;
	const fontSize = safeArea * 0.62;
	return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${size} ${size}">
  <defs>
    <linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="${BRAND}"/>
      <stop offset="100%" stop-color="${BRAND_DARK}"/>
    </linearGradient>
  </defs>
  <rect fill="url(#g)" width="${size}" height="${size}"/>
  <text x="${size / 2}" y="${offset + safeArea / 2 + fontSize * 0.36}" font-family="Arial, Helvetica, sans-serif" font-size="${fontSize}" font-weight="900" fill="white" text-anchor="middle">C</text>
</svg>`;
};

const tasks = [
	{ name: 'icon-192.png', size: 192, svg: baseSvg(192) },
	{ name: 'icon-512.png', size: 512, svg: baseSvg(512) },
	{ name: 'icon-maskable-512.png', size: 512, svg: maskableSvg(512) },
	{ name: 'apple-touch-icon.png', size: 180, svg: baseSvg(180) },
	{ name: 'favicon-32.png', size: 32, svg: baseSvg(32) }
];

for (const { name, svg } of tasks) {
	await sharp(Buffer.from(svg)).png().toFile(`static/${name}`);
	console.log(`✓ static/${name}`);
}

writeFileSync('static/icon.svg', baseSvg(512));
console.log('✓ static/icon.svg');

const ico = await sharp(Buffer.from(baseSvg(32))).resize(32, 32).png().toBuffer();
writeFileSync('static/favicon.ico', ico);
console.log('✓ static/favicon.ico');

console.log('\nIcônes PWA générées dans static/.');

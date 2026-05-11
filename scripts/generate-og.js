import sharp from 'sharp';
import { writeFileSync, mkdirSync } from 'node:fs';

mkdirSync('static', { recursive: true });

// OG image 1200x630 (ratio 1.91:1, standard Facebook/Twitter/LinkedIn)
const ogSvg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 630">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="#FAF1E2"/>
      <stop offset="100%" stop-color="#F4E5D2"/>
    </linearGradient>
    <linearGradient id="orange" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#E89855"/>
      <stop offset="100%" stop-color="#D2683D"/>
    </linearGradient>
    <linearGradient id="brown" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#C8884E"/>
      <stop offset="100%" stop-color="#A86D3D"/>
    </linearGradient>
  </defs>

  <!-- Background -->
  <rect width="1200" height="630" fill="url(#bg)"/>

  <!-- Glow décoratif -->
  <circle cx="1050" cy="200" r="260" fill="url(#orange)" opacity="0.15"/>
  <circle cx="180" cy="500" r="200" fill="#1F4D45" opacity="0.08"/>

  <!-- Mascotte gingerbread (à droite) -->
  <g transform="translate(820, 130)">
    <!-- Toque chef -->
    <ellipse cx="160" cy="60" rx="80" ry="55" fill="#FFFFFF"/>
    <ellipse cx="160" cy="80" rx="100" ry="30" fill="#FFFFFF"/>
    <rect x="100" y="85" width="120" height="20" fill="#F4E5D2" rx="4"/>

    <!-- Corps -->
    <ellipse cx="160" cy="270" rx="125" ry="135" fill="url(#brown)"/>

    <!-- Bras levés -->
    <ellipse cx="50" cy="180" rx="30" ry="55" fill="url(#brown)" transform="rotate(-30 50 180)"/>
    <ellipse cx="270" cy="180" rx="30" ry="55" fill="url(#brown)" transform="rotate(30 270 180)"/>

    <!-- Tablier vert sapin -->
    <path d="M 95 270 L 225 270 L 235 405 L 85 405 Z" fill="#1F4D45"/>

    <!-- Foulard cou -->
    <path d="M 110 215 Q 160 230 210 215 L 205 240 Q 160 252 115 240 Z" fill="#1F4D45"/>

    <!-- Visage -->
    <ellipse cx="135" cy="180" rx="9" ry="11" fill="#3D2817"/>
    <ellipse cx="185" cy="180" rx="9" ry="11" fill="#3D2817"/>
    <circle cx="138" cy="176" r="2.5" fill="#FFFFFF"/>
    <circle cx="188" cy="176" r="2.5" fill="#FFFFFF"/>

    <!-- Sourire -->
    <path d="M 130 210 Q 160 232 190 210" stroke="#3D2817" stroke-width="6" fill="none" stroke-linecap="round"/>

    <!-- Joues -->
    <circle cx="105" cy="200" r="10" fill="#E89855" opacity="0.5"/>
    <circle cx="215" cy="200" r="10" fill="#E89855" opacity="0.5"/>

    <!-- Boutons tablier -->
    <circle cx="135" cy="305" r="6" fill="#FFFFFF"/>
    <circle cx="185" cy="305" r="6" fill="#FFFFFF"/>

    <!-- Icing décoratif -->
    <path d="M 100 380 Q 120 374 140 380 Q 160 374 180 380 Q 200 374 220 380" stroke="#FFFFFF" stroke-width="5" fill="none" stroke-linecap="round"/>

    <!-- Confetti -->
    <circle cx="20" cy="50" r="6" fill="#D2683D"/>
    <circle cx="320" cy="100" r="6" fill="#1F4D45"/>
    <rect x="310" y="40" width="14" height="6" fill="#E89855" transform="rotate(20 317 43)"/>
  </g>

  <!-- Texte (à gauche) -->
  <g transform="translate(70, 120)">
    <!-- Eyebrow -->
    <rect x="0" y="0" width="320" height="38" rx="19" fill="rgba(210, 104, 61, 0.12)"/>
    <text x="20" y="25" font-family="Arial, sans-serif" font-size="16" font-weight="700" fill="#D2683D" letter-spacing="1.5">🍪 APP CAP PÂTISSIER</text>

    <!-- Title -->
    <text x="0" y="120" font-family="Arial, sans-serif" font-size="64" font-weight="900" fill="#1F4D45" letter-spacing="-1.5">Réussis ton CAP</text>
    <text x="0" y="195" font-family="Arial, sans-serif" font-size="64" font-weight="900" fill="#1F4D45" letter-spacing="-1.5">Pâtissier</text>
    <text x="0" y="270" font-family="Arial, sans-serif" font-size="64" font-weight="900" fill="#D2683D" letter-spacing="-1.5">sans stress.</text>

    <!-- Subtitle -->
    <text x="0" y="335" font-family="Arial, sans-serif" font-size="22" font-weight="500" fill="#4B5563">17 recettes du référentiel · Mode Labo · Suivi par</text>
    <text x="0" y="365" font-family="Arial, sans-serif" font-size="22" font-weight="500" fill="#4B5563">compétence · Carnet PDF · Bêta gratuite</text>

    <!-- URL pill -->
    <rect x="0" y="400" width="290" height="56" rx="14" fill="#1F4D45"/>
    <text x="145" y="436" font-family="Arial, sans-serif" font-size="22" font-weight="700" fill="#FAF1E2" text-anchor="middle">brigadesucree.app →</text>
  </g>
</svg>`;

await sharp(Buffer.from(ogSvg))
	.resize(1200, 630)
	.png({ quality: 90, compressionLevel: 9 })
	.toFile('static/og-image.png');
console.log('✓ static/og-image.png (1200×630)');

// Une variante carrée 1200x1200 pour Instagram, etc.
const ogSquareSvg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 1200">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="#FAF1E2"/>
      <stop offset="100%" stop-color="#F4E5D2"/>
    </linearGradient>
    <linearGradient id="brown" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#C8884E"/>
      <stop offset="100%" stop-color="#A86D3D"/>
    </linearGradient>
  </defs>
  <rect width="1200" height="1200" fill="url(#bg)"/>
  <circle cx="600" cy="500" r="380" fill="#E89855" opacity="0.15"/>

  <g transform="translate(420, 280)">
    <ellipse cx="180" cy="80" rx="90" ry="60" fill="#FFFFFF"/>
    <ellipse cx="180" cy="100" rx="120" ry="35" fill="#FFFFFF"/>
    <rect x="105" y="105" width="150" height="22" fill="#F4E5D2" rx="4"/>
    <ellipse cx="180" cy="320" rx="140" ry="155" fill="url(#brown)"/>
    <ellipse cx="60" cy="220" rx="32" ry="60" fill="url(#brown)" transform="rotate(-30 60 220)"/>
    <ellipse cx="300" cy="220" rx="32" ry="60" fill="url(#brown)" transform="rotate(30 300 220)"/>
    <path d="M 110 320 L 250 320 L 260 470 L 100 470 Z" fill="#1F4D45"/>
    <path d="M 125 255 Q 180 275 235 255 L 230 285 Q 180 297 130 285 Z" fill="#1F4D45"/>
    <ellipse cx="155" cy="220" rx="11" ry="13" fill="#3D2817"/>
    <ellipse cx="205" cy="220" rx="11" ry="13" fill="#3D2817"/>
    <path d="M 150 252 Q 180 278 210 252" stroke="#3D2817" stroke-width="7" fill="none" stroke-linecap="round"/>
  </g>

  <text x="600" y="900" font-family="Arial, sans-serif" font-size="80" font-weight="900" fill="#1F4D45" text-anchor="middle">Brigade Sucrée</text>
  <text x="600" y="970" font-family="Arial, sans-serif" font-size="32" font-weight="500" fill="#D2683D" text-anchor="middle">App CAP Pâtissier · Bêta gratuite</text>
  <text x="600" y="1080" font-family="Arial, sans-serif" font-size="24" font-weight="600" fill="#4B5563" text-anchor="middle">brigadesucree.app</text>
</svg>`;

await sharp(Buffer.from(ogSquareSvg))
	.resize(1200, 1200)
	.png({ quality: 90, compressionLevel: 9 })
	.toFile('static/og-square.png');
console.log('✓ static/og-square.png (1200×1200)');

console.log('\n📸 OG images générées');

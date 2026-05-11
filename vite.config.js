import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import { VitePWA } from 'vite-plugin-pwa';

export default defineConfig({
	plugins: [
		sveltekit(),
		VitePWA({
			// KILL-SWITCH temporaire : génère un Service Worker auto-destructeur
			// pour purger les SW zombies installés chez les visiteurs (qui servent
			// un index.html obsolète référençant des chunks 404).
			// Une fois la prod stabilisée (24-48h), repasser à false + redeploy.
			selfDestroying: true,
			registerType: 'autoUpdate',
			includeAssets: ['favicon.ico', 'apple-touch-icon.png'],
			manifest: {
				id: '/',
				name: 'Brigade Sucrée',
				short_name: 'Brigade',
				description: 'L\'app des étudiants CAP Pâtissier et des passionnés. Recettes, mode laboratoire, suivi de progression.',
				lang: 'fr',
				theme_color: '#6c63ff',
				background_color: '#ffffff',
				display: 'standalone',
				orientation: 'portrait',
				scope: '/',
				start_url: '/',
				categories: ['food', 'education', 'productivity'],
				icons: [
					{ src: 'icon-192.png', sizes: '192x192', type: 'image/png', purpose: 'any' },
					{ src: 'icon-512.png', sizes: '512x512', type: 'image/png', purpose: 'any' },
					{ src: 'icon-maskable-512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' }
				]
			},
			workbox: {
				skipWaiting: true,
				clientsClaim: true,
				cleanupOutdatedCaches: true,
				navigateFallback: null, // surtout pas servir HTML obsolète depuis cache
				// Retiré .html de la liste : on ne précache JAMAIS l'HTML (sinon ça
				// recrée le bug avec un mismatch HTML/chunks au prochain deploy)
				globPatterns: ['**/*.{js,css,ico,png,svg,woff2}'],
				runtimeCaching: [
					{
						urlPattern: /^https:\/\/.*\.supabase\.co\/.*/i,
						handler: 'NetworkFirst',
						options: {
							cacheName: 'supabase-cache',
							expiration: { maxEntries: 50, maxAgeSeconds: 86400 }
						}
					}
				]
			}
		})
	]
});

import adapter from '@sveltejs/adapter-static';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		adapter: adapter({
			// fallback: 200.html (et non index.html) sinon le fichier SPA
			// fallback ÉCRASE le prerender de la page / au build. Avec un
			// nom différent, index.html garde le contenu prerendered de la
			// landing (SEO + JSON-LD inclus) et 200.html sert de fallback
			// SPA pour les routes dynamiques inconnues.
			fallback: '200.html'
		}),
		// paths.relative=false force adapter-static à émettre des chemins
		// absolus (/_app/...) dans le HTML au lieu de relatifs (./_app/...).
		// Sinon, sur une route profonde comme /recettes/abc, le HTML cherche
		// /recettes/_app/... = 404. Cause connue de chunks 404 mélangés.
		paths: {
			relative: false
		},
		prerender: {
			handleHttpError: 'warn',
			handleMissingId: 'warn'
		}
	}
};

export default config;

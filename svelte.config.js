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
		prerender: {
			handleHttpError: 'warn',
			handleMissingId: 'warn'
		}
	}
};

export default config;

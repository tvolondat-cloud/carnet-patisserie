// Force le prerender SSR de la home page.
//
// Sans ça, adapter-static + fallback:'index.html' considère la page
// comme SPA-only et ne génère que le shell HTML générique. Les bots
// SEO/GEO ne voient ni le titre optimisé ni le JSON-LD de la Landing.
//
// Avec prerender=true, le crawler SvelteKit rend `/` au build time
// avec l'état initial (anonyme = !$isAuthenticated → Landing). Le
// HTML statique servi par Cloudflare contient alors toute la Landing
// avec son <svelte:head> (title, description, JSON-LD, meta).

export const prerender = true;
export const ssr = true;

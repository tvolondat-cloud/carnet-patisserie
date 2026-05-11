// ============================================================
// Polyfill WebSocket pour le SSR — DOIT être AVANT l'import Supabase
// ============================================================
// Au prerender côté Node 20, @supabase/realtime-js crashe au constructor
// avec "Node.js 20 detected without native WebSocket support". Cela
// empêche la génération de build/index.html, CF Pages garde l'ancien
// HTML qui référence des chunks supprimés → erreurs 404 chez l'user.
//
// Fix : polyfill no-op de WebSocket au SSR. Realtime ne fonctionnera
// pas côté serveur (on n'en a pas besoin au prerender de toute façon),
// mais createClient() ne crashe plus.
//
// Note : ce fix est inutile sur Node 22+ qui a WebSocket natif. Il
// peut être retiré le jour où CF Pages bouge à Node 22 par défaut.
if (typeof globalThis !== 'undefined' && typeof globalThis.WebSocket === 'undefined') {
	globalThis.WebSocket = class WebSocketStub {
		constructor() {}
		close() {}
		send() {}
		addEventListener() {}
		removeEventListener() {}
		get readyState() { return 3; /* CLOSED */ }
	};
}

import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
	throw new Error(
		'Variables d\'environnement Supabase manquantes. Copie .env.example en .env.local et renseigne VITE_SUPABASE_URL et VITE_SUPABASE_ANON_KEY.'
	);
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
	auth: {
		flowType: 'pkce',
		persistSession: true,
		autoRefreshToken: true,
		detectSessionInUrl: true
	}
});

/**
 * @typedef {'a-tester'|'testee'|'validee'|'maitrisee'} Statut
 * @typedef {'cuissons'|'textures'|'pesees'|'assemblages'|'organisation'|'techniques'} Competence
 * @typedef {'EP1'|'EP2'} EP
 * @typedef {'note'|'astuce'|'erreur'|'variation'} CommentaireType
 */

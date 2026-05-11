// Build marker (force hash refresh) : 2026-05-11-cf-fix
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

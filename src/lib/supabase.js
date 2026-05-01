import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
	auth: {
		persistSession: true,
		autoRefreshToken: true,
		detectSessionInUrl: true
	}
});

/**
 * @typedef {'a-tester'|'testee'|'validee'|'maitrisee'} Statut
 * @typedef {'cuissons'|'textures'|'pesees'|'assemblages'|'organisation'|'techniques'} Competence
 * @typedef {'EP1'|'EP2'} EP
 */

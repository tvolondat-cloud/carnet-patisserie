import { writable, get } from 'svelte/store';
import { supabase } from '$lib/supabase.js';
import { session } from './auth.js';
import { readLocal, writeLocal } from '$lib/utils/exam-scores.js';

/** Notes d'examen blanc : { [theme]: { score, total, pct, updated_at } } */
export const examScores = writable({});

function toMap(rows) {
	const m = {};
	for (const r of rows ?? []) {
		m[r.theme] = { score: r.score, total: r.total, pct: r.pct, updated_at: r.updated_at };
	}
	return m;
}

/**
 * Charge les notes depuis Supabase (source de vérité), avec :
 * - fallback cache local si hors-ligne / pas de session ;
 * - migration one-shot : si le serveur n'a aucune note mais que le cache
 *   local en contient (ancien stockage), on les pousse vers Supabase.
 */
export async function loadExamScores() {
	const s = get(session);
	if (!s) {
		examScores.set(readLocal());
		return;
	}

	const { data, error } = await supabase
		.from('exam_scores')
		.select('theme, score, total, pct, updated_at')
		.eq('user_id', s.user.id);

	if (error) {
		console.error('loadExamScores:', error);
		examScores.set(readLocal()); // offline / erreur → cache local
		return;
	}

	let map = toMap(data);

	// Migration des anciennes notes locales si le serveur est vide
	const local = readLocal();
	if (Object.keys(map).length === 0 && Object.keys(local).length > 0) {
		const rows = Object.entries(local).map(([theme, v]) => ({
			user_id: s.user.id, theme, score: v.score, total: v.total, pct: v.pct
		}));
		const { error: upErr } = await supabase
			.from('exam_scores')
			.upsert(rows, { onConflict: 'user_id,theme' });
		if (!upErr) map = local;
		else console.error('migration exam_scores:', upErr);
	}

	examScores.set(map);
	writeLocal(map); // miroir cache offline
}

/**
 * Enregistre la note d'un thème : optimistic + upsert Supabase + cache local,
 * rollback du store en cas d'erreur (le cache local garde quand même la note).
 */
export async function saveExamScore(theme, { score, total, pct }) {
	const s = get(session);
	const entry = { score, total, pct, updated_at: new Date().toISOString() };
	const next = { ...get(examScores), [theme]: entry };

	// On garde la note dans le store + cache local quoi qu'il arrive : c'est
	// le fallback si hors-ligne ou si la migration n'est pas encore appliquée.
	examScores.set(next);
	writeLocal(next);

	if (!s) return; // mode déconnecté : cache local seulement

	const { error } = await supabase
		.from('exam_scores')
		.upsert(
			{ user_id: s.user.id, theme, score, total, pct },
			{ onConflict: 'user_id,theme' }
		);

	if (error) console.error('saveExamScore (cache local conservé):', error);
}

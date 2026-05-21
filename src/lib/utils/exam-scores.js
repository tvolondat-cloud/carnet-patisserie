/**
 * Notes de l'examen blanc — persistance locale (par appareil).
 *
 * Structure : { [themeId]: { score, total, pct, date } }
 *
 * Choix `localStorage` (pas Supabase) :
 * - Donnée non critique, par appareil = OK pour un examen blanc.
 * - Pas de migration de schéma ni de RLS à gérer.
 * - Migration vers Supabase possible plus tard si on veut un suivi cross-device.
 */

const KEY = 'bs_exam_scores';

function isBrowser() {
	return typeof window !== 'undefined' && typeof window.localStorage !== 'undefined';
}

/** Lit toutes les notes stockées. */
export function readScores() {
	if (!isBrowser()) return {};
	try {
		return JSON.parse(localStorage.getItem(KEY) || '{}');
	} catch {
		return {};
	}
}

/** Écrit / écrase la note d'un thème. Retourne l'objet à jour. */
export function saveScore(themeId, { score, total, pct }) {
	if (!isBrowser()) return readScores();
	const all = readScores();
	all[themeId] = { score, total, pct, date: new Date().toISOString() };
	try {
		localStorage.setItem(KEY, JSON.stringify(all));
	} catch {}
	return all;
}

/** Moyenne (%) des notes enregistrées. `null` si aucune note. */
export function averagePct(scores) {
	const arr = Object.values(scores ?? {});
	if (!arr.length) return null;
	const sum = arr.reduce((s, r) => s + (r?.pct ?? 0), 0);
	return Math.round(sum / arr.length);
}

/** Convertit un pourcentage en note /20 (1 décimale, formatée FR). */
export function gradeOn20(pct) {
	if (pct == null) return null;
	const n = Math.round(pct * 0.2 * 10) / 10;
	return Number.isInteger(n) ? `${n}` : `${n}`.replace('.', ',');
}

/**
 * Statut colorimétrique d'un score.
 * - `green`  : ≥ 75 % — réussi
 * - `orange` : 50–74 % — moyenne
 * - `red`    : < 50 % — sous la moyenne
 * - `pending`: pas encore joué
 */
export function statusFor(pct) {
	if (pct == null) return 'pending';
	if (pct >= 75) return 'green';
	if (pct >= 50) return 'orange';
	return 'red';
}

/**
 * Helpers purs de l'examen blanc (note /20, statut couleur, moyenne)
 * + cache localStorage (fallback hors-ligne / migration).
 *
 * La SOURCE DE VÉRITÉ est désormais Supabase (table `exam_scores`),
 * orchestrée par `src/lib/stores/exam.js`. Le localStorage ne sert plus
 * que de cache offline et de réservoir de migration des anciennes notes.
 */

const KEY = 'bs_exam_scores';

function isBrowser() {
	return typeof window !== 'undefined' && typeof window.localStorage !== 'undefined';
}

/** Lit le cache local. */
export function readLocal() {
	if (!isBrowser()) return {};
	try {
		return JSON.parse(localStorage.getItem(KEY) || '{}');
	} catch {
		return {};
	}
}

/** Écrit le cache local (miroir de l'état Supabase). */
export function writeLocal(scores) {
	if (!isBrowser()) return;
	try {
		localStorage.setItem(KEY, JSON.stringify(scores ?? {}));
	} catch {}
}

/** Moyenne (%) des notes. `null` si aucune. */
export function averagePct(scores) {
	const arr = Object.values(scores ?? {});
	if (!arr.length) return null;
	const sum = arr.reduce((s, r) => s + (r?.pct ?? 0), 0);
	return Math.round(sum / arr.length);
}

/** Convertit un pourcentage en note /20 (1 décimale, format FR). */
export function gradeOn20(pct) {
	if (pct == null) return null;
	const n = Math.round(pct * 0.2 * 10) / 10;
	return `${n}`.replace('.', ',');
}

/**
 * Statut colorimétrique :
 * - `green`  ≥ 75 % (réussi) · `orange` 50–74 % (moyenne) · `red` < 50 % · `pending`
 */
export function statusFor(pct) {
	if (pct == null) return 'pending';
	if (pct >= 75) return 'green';
	if (pct >= 50) return 'orange';
	return 'red';
}

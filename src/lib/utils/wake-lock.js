import { browser } from '$app/environment';

/**
 * Action Svelte : maintient l'écran allumé tant que l'élément est monté.
 * Usage : <div use:wakeLock> … </div> (pages recette / labo — mains prises
 * en cuisine, l'écran ne doit pas s'éteindre pendant la réalisation).
 *
 * - Screen Wake Lock API (Chrome/Edge/Android, Safari iOS 16.4+).
 * - Le verrou saute quand l'onglet passe en arrière-plan → on le ré-acquiert
 *   au retour de visibilité.
 * - Dégradation silencieuse si l'API n'existe pas (pas d'erreur).
 */
export function wakeLock(node) {
	if (!browser || !('wakeLock' in navigator)) return {};

	let sentinel = null;
	let destroyed = false;

	async function acquire() {
		if (destroyed || sentinel) return;
		try {
			sentinel = await navigator.wakeLock.request('screen');
			sentinel.addEventListener('release', () => { sentinel = null; });
		} catch {
			// refus (batterie faible, onglet non visible…) → on réessaiera au focus
		}
	}

	function onVisibility() {
		if (document.visibilityState === 'visible') acquire();
	}

	acquire();
	document.addEventListener('visibilitychange', onVisibility);

	return {
		destroy() {
			destroyed = true;
			document.removeEventListener('visibilitychange', onVisibility);
			if (sentinel) {
				sentinel.release().catch(() => {});
				sentinel = null;
			}
		}
	};
}

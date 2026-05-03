// ============================================================
// Analytics — GTM + GA4 avec Consent Mode v2 (RGPD)
// ============================================================
//
// Stratégie :
// - GTM est chargé une seule fois (dans app.html), avec consent
//   par défaut = DENIED (RGPD : pas de tracking sans opt-in).
// - Tant que le user n'a pas donné son consentement, AUCUN cookie
//   analytics n'est posé (Consent Mode v2 envoie juste des "pings"
//   anonymes, pas de cookies).
// - Quand le user clique "Accepter" → on update consent → GA4
//   commence à tracker.
// - Si "Refuser" → on garde DENIED, aucun event ne part.
// - Le choix est stocké dans localStorage et persiste.

import { browser } from '$app/environment';
import { writable } from 'svelte/store';

const STORAGE_KEY = 'bs_analytics_consent';
const DEV = import.meta.env.DEV;

/**
 * @typedef {'granted'|'denied'|'pending'} ConsentState
 */

/** @type {import('svelte/store').Writable<ConsentState>} */
export const consentState = writable('pending');

/** Initialise au démarrage : lit localStorage et applique. */
export function initAnalytics() {
	if (!browser) return;

	const stored = localStorage.getItem(STORAGE_KEY);
	if (stored === 'granted') {
		consentState.set('granted');
		updateConsent(true);
	} else if (stored === 'denied') {
		consentState.set('denied');
		updateConsent(false);
	} else {
		consentState.set('pending');
		// Default est 'denied' (déjà set dans app.html avant le chargement de GTM).
	}
}

/** L'utilisateur accepte → on update Consent Mode + on stocke. */
export function acceptConsent() {
	if (!browser) return;
	localStorage.setItem(STORAGE_KEY, 'granted');
	consentState.set('granted');
	updateConsent(true);
	track('consent_granted');
}

/** L'utilisateur refuse → on update Consent Mode + on stocke. */
export function denyConsent() {
	if (!browser) return;
	localStorage.setItem(STORAGE_KEY, 'denied');
	consentState.set('denied');
	updateConsent(false);
}

/** Reset : permet de re-poser la question (lien "Gérer cookies"). */
export function resetConsent() {
	if (!browser) return;
	localStorage.removeItem(STORAGE_KEY);
	consentState.set('pending');
	updateConsent(false);
}

function updateConsent(granted) {
	if (!browser || !window.gtag) return;
	const status = granted ? 'granted' : 'denied';
	window.gtag('consent', 'update', {
		ad_storage: status,
		analytics_storage: status,
		ad_user_data: status,
		ad_personalization: status
	});
}

/**
 * Push un event dans le dataLayer GTM.
 * @param {string} event - Nom de l'event (snake_case)
 * @param {Record<string, any>} [params] - Paramètres
 */
export function track(event, params = {}) {
	if (!browser) return;

	if (DEV) {
		console.log('[analytics]', event, params);
		return;
	}

	if (!window.dataLayer) return;
	window.dataLayer.push({ event, ...params });
}

/** Track une page vue (à appeler à chaque navigation SvelteKit). */
export function trackPageView(pathname, title) {
	track('page_view', {
		page_path: pathname,
		page_title: title || (browser ? document.title : '')
	});
}

// ============================================================
// Helpers spécifiques métier
// ============================================================

export const events = {
	signUp: (method) => track('sign_up', { method }),
	login: (method) => track('login', { method }),
	signOut: () => track('logout'),
	viewRecipe: (recette) =>
		track('view_recipe', {
			recipe_id: recette.id,
			recipe_name: recette.nom,
			recipe_categorie: recette.categorie,
			recipe_ep: recette.ep,
			recipe_difficulte: recette.difficulte
		}),
	labStarted: (recetteId) => track('lab_started', { recipe_id: recetteId }),
	labQuizCompleted: (recetteId, score, passed) =>
		track('lab_quiz_completed', { recipe_id: recetteId, score, passed }),
	labChronoCompleted: (recetteId, seconds, passed) =>
		track('lab_chrono_completed', { recipe_id: recetteId, seconds, passed }),
	recipeMastered: (recette) =>
		track('recipe_mastered', { recipe_id: recette.id, recipe_name: recette.nom }),
	notesSaved: (recetteId) => track('notes_saved', { recipe_id: recetteId }),
	commentAdded: (recetteId, type) =>
		track('comment_added', { recipe_id: recetteId, comment_type: type }),
	pdfExported: (count, onlyMaitrisees) =>
		track('pdf_exported', { count, only_maitrisees: onlyMaitrisees }),
	profileUpdated: () => track('profile_updated')
};

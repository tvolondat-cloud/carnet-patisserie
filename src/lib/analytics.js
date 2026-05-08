// ============================================================
// Analytics — GTM + GA4 avec Consent Mode v2 (RGPD/CNIL)
// ============================================================
//
// Stratégie :
// - GTM est chargé une seule fois (dans app.html), avec consent
//   par défaut = DENIED (RGPD : pas de tracking sans opt-in).
// - Catégories supportées : necessary, analytics, marketing.
// - L'utilisateur choisit Tout accepter / Tout refuser / Personnaliser.
// - Conforme art. 82 LIL + reco CNIL : action explicite requise,
//   3 actions de poids visuel équivalent.
// - En dev : log dans la console, rien envoyé.

import { browser } from '$app/environment';
import { writable, derived } from 'svelte/store';

const STORAGE_KEY = 'bs_consent_v2';
const DEV = import.meta.env.DEV;

/**
 * @typedef {{ necessary: boolean, analytics: boolean, marketing: boolean, decided_at?: string }} ConsentChoices
 */

const DEFAULT_CHOICES = {
	necessary: true, // toujours activé (cookies de session, préférences)
	analytics: false,
	marketing: false
};

/** @type {import('svelte/store').Writable<ConsentChoices | null>} */
export const consentChoices = writable(null);

/** Dérive un statut simple : 'pending' | 'granted' (au moins analytics) | 'denied' (que necessary) */
export const consentState = derived(consentChoices, ($c) => {
	if (!$c) return 'pending';
	if ($c.analytics || $c.marketing) return 'granted';
	return 'denied';
});

/** Initialise au démarrage : lit localStorage et applique. */
export function initAnalytics() {
	if (!browser) return;

	try {
		const raw = localStorage.getItem(STORAGE_KEY);
		if (raw) {
			const stored = JSON.parse(raw);
			consentChoices.set({ ...DEFAULT_CHOICES, ...stored });
			applyConsent(stored);
			return;
		}
	} catch {
		// JSON corrompu, on reset
		localStorage.removeItem(STORAGE_KEY);
	}
	consentChoices.set(null); // pending
}

/** Accepter toutes les catégories. */
export function acceptAllConsent() {
	saveConsent({ necessary: true, analytics: true, marketing: true });
	track('consent_granted', { all: true });
}

/** Tout refuser sauf nécessaires. */
export function denyAllConsent() {
	saveConsent({ necessary: true, analytics: false, marketing: false });
	track('consent_denied');
}

/** Accepter des catégories spécifiques (depuis le drawer). */
export function saveCategoryConsent(choices) {
	const finalChoices = {
		necessary: true,
		analytics: !!choices.analytics,
		marketing: !!choices.marketing
	};
	saveConsent(finalChoices);
	track('consent_customized', finalChoices);
}

/** Reset : permet de re-poser la question (lien "Gérer cookies" depuis /profil). */
export function resetConsent() {
	if (!browser) return;
	localStorage.removeItem(STORAGE_KEY);
	consentChoices.set(null);
	applyConsent({ necessary: true, analytics: false, marketing: false });
}

function saveConsent(choices) {
	if (!browser) return;
	const enriched = { ...choices, decided_at: new Date().toISOString() };
	localStorage.setItem(STORAGE_KEY, JSON.stringify(enriched));
	consentChoices.set(enriched);
	applyConsent(enriched);
}

function applyConsent(choices) {
	if (!browser || !window.gtag) return;
	window.gtag('consent', 'update', {
		ad_storage: choices.marketing ? 'granted' : 'denied',
		ad_user_data: choices.marketing ? 'granted' : 'denied',
		ad_personalization: choices.marketing ? 'granted' : 'denied',
		analytics_storage: choices.analytics ? 'granted' : 'denied',
		functionality_storage: 'granted',
		security_storage: 'granted'
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

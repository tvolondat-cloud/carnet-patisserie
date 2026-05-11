import { writable, derived, get } from 'svelte/store';
import { supabase } from '$lib/supabase.js';
import { browser } from '$app/environment';
import { recettes, commentaires } from './recettes.js';
import { progression } from './progression.js';

export const session = writable(null);
export const profile = writable(null);

// authLoading initialisé à `true` côté client (jusqu'à résolution de initAuth)
// mais `false` au SSR : sinon le layout cache la Landing pendant le prerender
// avec un spinner, et les bots SEO/GEO ne voient pas le HTML optimisé.
// Au prerender, on considère que l'auth est "résolue" et que l'user est anonyme.
export const authLoading = writable(browser);

export const isAuthenticated = derived(session, ($s) => !!$s);

let seedingPromise = null;

export async function initAuth() {
	if (!browser) return;

	const { data } = await supabase.auth.getSession();
	session.set(data.session);
	if (data.session) {
		await loadProfile(data.session.user.id);
	}
	authLoading.set(false);

	supabase.auth.onAuthStateChange(async (event, newSession) => {
		if (event === 'TOKEN_REFRESHED') {
			session.set(newSession);
			return;
		}
		if (event === 'SIGNED_OUT') {
			session.set(null);
			profile.set(null);
			recettes.set([]);
			progression.set({});
			commentaires.set({});
			return;
		}
		if (event === 'SIGNED_IN' || event === 'INITIAL_SESSION' || event === 'USER_UPDATED') {
			session.set(newSession);
			if (newSession) {
				await loadProfile(newSession.user.id);
			}
		}
	});
}

async function loadProfile(userId) {
	const { data: profileData } = await supabase
		.from('profiles')
		.select('*')
		.eq('id', userId)
		.single();
	profile.set(profileData);

	if (!seedingPromise) {
		seedingPromise = (async () => {
			const { count } = await supabase
				.from('recettes')
				.select('*', { count: 'exact', head: true })
				.eq('user_id', userId);
			if (count === 0) {
				await supabase.rpc('seed_recettes_cap_safe', { p_user_id: userId });
			}
		})().catch((err) => {
			console.error('Seed error:', err);
		}).finally(() => {
			seedingPromise = null;
		});
	}
	await seedingPromise;
}

export async function signInWithGoogle() {
	const { error } = await supabase.auth.signInWithOAuth({
		provider: 'google',
		options: { redirectTo: `${window.location.origin}/auth/callback` }
	});
	if (error) throw error;
}

export async function signInWithEmail(email, password) {
	const { error } = await supabase.auth.signInWithPassword({ email, password });
	if (error) throw new Error(translateAuthError(error.message));
}

export async function signUpWithEmail(email, password, nom) {
	const { data, error } = await supabase.auth.signUp({
		email,
		password,
		options: { data: { full_name: nom } }
	});
	if (error) throw new Error(translateAuthError(error.message));
	return data;
}

export async function signOut() {
	await supabase.auth.signOut();
	recettes.set([]);
	progression.set({});
	commentaires.set({});
	profile.set(null);
}

export async function updateProfile(updates) {
	const s = get(session);
	if (!s) throw new Error('Non connecté');
	const { data, error } = await supabase
		.from('profiles')
		.update(updates)
		.eq('id', s.user.id)
		.select()
		.single();
	if (error) throw error;
	profile.set(data);
}

function translateAuthError(msg) {
	const m = msg.toLowerCase();
	if (m.includes('invalid login credentials')) return 'Email ou mot de passe incorrect.';
	if (m.includes('email not confirmed')) return 'Ton email n\'est pas encore confirmé. Vérifie ta boîte mail.';
	if (m.includes('user already registered')) return 'Un compte existe déjà avec cet email.';
	if (m.includes('password should be at least')) return 'Le mot de passe doit contenir au moins 6 caractères.';
	if (m.includes('rate limit')) return 'Trop de tentatives. Réessaie dans quelques minutes.';
	if (m.includes('unable to validate email')) return 'Email invalide.';
	return msg;
}

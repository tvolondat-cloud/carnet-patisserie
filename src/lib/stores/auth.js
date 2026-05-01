import { writable, derived } from 'svelte/store';
import { supabase } from '$lib/supabase.js';
import { browser } from '$app/environment';

export const session = writable(null);
export const profile = writable(null);
export const authLoading = writable(true);

export const isAuthenticated = derived(session, $s => !!$s);

export async function initAuth() {
	if (!browser) return;
	const { data } = await supabase.auth.getSession();
	session.set(data.session);
	if (data.session) await loadProfile(data.session.user.id);
	authLoading.set(false);

	supabase.auth.onAuthStateChange(async (event, newSession) => {
		session.set(newSession);
		if (newSession) {
			await loadProfile(newSession.user.id);
		} else {
			profile.set(null);
		}
	});
}

async function loadProfile(userId) {
	const { data } = await supabase
		.from('profiles')
		.select('*')
		.eq('id', userId)
		.single();
	profile.set(data);

	const { count } = await supabase
		.from('recettes')
		.select('*', { count: 'exact', head: true })
		.eq('user_id', userId);
	if (count === 0) {
		await supabase.rpc('seed_recettes_cap', { p_user_id: userId });
	}
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
	if (error) throw error;
}

export async function signUpWithEmail(email, password, nom) {
	const { data, error } = await supabase.auth.signUp({
		email,
		password,
		options: { data: { full_name: nom } }
	});
	if (error) throw error;
	return data;
}

export async function signOut() {
	await supabase.auth.signOut();
}

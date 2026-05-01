import { writable, get } from 'svelte/store';
import { supabase } from '$lib/supabase.js';
import { session } from './auth.js';
import recipesData from '$lib/data/recipes.json';

export const recettes = writable([]);
export const ingredients = writable({});
export const commentaires = writable({});
export const recettesLoading = writable(false);

export async function loadRecettes() {
	const s = get(session);
	if (!s) return;
	recettesLoading.set(true);
	const { data } = await supabase
		.from('recettes')
		.select('*, ingredients(*), quiz_questions(*)')
		.eq('user_id', s.user.id)
		.order('nom');
	recettes.set(data ?? []);
	recettesLoading.set(false);
}

export async function loadCommentaires(recetteId) {
	const s = get(session);
	if (!s) return;
	const { data } = await supabase
		.from('commentaires')
		.select('*')
		.eq('recette_id', recetteId)
		.eq('user_id', s.user.id)
		.order('created_at', { ascending: false });
	commentaires.update(c => ({ ...c, [recetteId]: data ?? [] }));
}

export async function addCommentaire(recetteId, contenu, type = 'note') {
	const s = get(session);
	const { data, error } = await supabase
		.from('commentaires')
		.insert({ recette_id: recetteId, user_id: s.user.id, contenu, type })
		.select()
		.single();
	if (error) throw error;
	commentaires.update(c => ({
		...c,
		[recetteId]: [data, ...(c[recetteId] ?? [])]
	}));
}

export async function deleteCommentaire(recetteId, id) {
	await supabase.from('commentaires').delete().eq('id', id);
	commentaires.update(c => ({
		...c,
		[recetteId]: (c[recetteId] ?? []).filter(x => x.id !== id)
	}));
}

export async function updateNotes(recetteId, notes) {
	const s = get(session);
	await supabase
		.from('recettes')
		.update({ notes })
		.eq('id', recetteId)
		.eq('user_id', s.user.id);
	recettes.update(list => list.map(r => r.id === recetteId ? { ...r, notes } : r));
}

export async function addIngredient(recetteId, ing) {
	const s = get(session);
	const { data, error } = await supabase
		.from('ingredients')
		.insert({ recette_id: recetteId, user_id: s.user.id, ...ing })
		.select()
		.single();
	if (error) throw error;
	recettes.update(list => list.map(r => {
		if (r.id !== recetteId) return r;
		return { ...r, ingredients: [...(r.ingredients ?? []), data] };
	}));
}

export async function updateIngredient(id, updates) {
	await supabase.from('ingredients').update(updates).eq('id', id);
	recettes.update(list => list.map(r => ({
		...r,
		ingredients: (r.ingredients ?? []).map(i => i.id === id ? { ...i, ...updates } : i)
	})));
}

export async function deleteIngredient(recetteId, id) {
	await supabase.from('ingredients').delete().eq('id', id);
	recettes.update(list => list.map(r => {
		if (r.id !== recetteId) return r;
		return { ...r, ingredients: (r.ingredients ?? []).filter(i => i.id !== id) };
	}));
}

export function getStaticRecipes() {
	return recipesData.recettes;
}

export function getCategories() {
	return recipesData.categories;
}

export function getCompetences() {
	return recipesData.competences;
}

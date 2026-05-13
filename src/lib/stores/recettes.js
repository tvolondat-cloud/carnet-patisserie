import { writable, get } from 'svelte/store';
import { supabase } from '$lib/supabase.js';
import { session } from './auth.js';
import recipesData from '$lib/data/recipes.json';

export const recettes = writable([]);
export const commentaires = writable({});
export const recettesLoading = writable(false);
export const recettesError = writable(null);

export async function loadRecettes() {
	const s = get(session);
	if (!s) return;
	recettesLoading.set(true);
	recettesError.set(null);
	try {
		const { data, error } = await supabase
			.from('recettes')
			.select('*, ingredients(*), quiz_questions(*)')
			.eq('user_id', s.user.id)
			.order('nom');
		if (error) throw error;
		recettes.set(data ?? []);
	} catch (err) {
		console.error('loadRecettes:', err);
		recettesError.set(err.message ?? 'Erreur de chargement');
	} finally {
		recettesLoading.set(false);
	}
}

const commentairesCache = new Map();

export async function loadCommentaires(recetteId) {
	const s = get(session);
	if (!s) return;
	const cachedAt = commentairesCache.get(recetteId);
	if (cachedAt && Date.now() - cachedAt < 60000) return;

	const { data, error } = await supabase
		.from('commentaires')
		.select('*')
		.eq('recette_id', recetteId)
		.eq('user_id', s.user.id)
		.order('created_at', { ascending: false });
	if (error) {
		console.error('loadCommentaires:', error);
		return;
	}
	commentairesCache.set(recetteId, Date.now());
	commentaires.update((c) => ({ ...c, [recetteId]: data ?? [] }));
}

export async function addCommentaire(recetteId, contenu, type = 'note') {
	const s = get(session);
	const previous = get(commentaires)[recetteId] ?? [];
	const optimistic = {
		id: `tmp-${Date.now()}`,
		recette_id: recetteId,
		user_id: s.user.id,
		contenu,
		type,
		created_at: new Date().toISOString(),
		_optimistic: true
	};
	commentaires.update((c) => ({ ...c, [recetteId]: [optimistic, ...previous] }));

	const { data, error } = await supabase
		.from('commentaires')
		.insert({ recette_id: recetteId, user_id: s.user.id, contenu, type })
		.select()
		.single();
	if (error) {
		commentaires.update((c) => ({ ...c, [recetteId]: previous }));
		throw error;
	}
	commentaires.update((c) => ({ ...c, [recetteId]: [data, ...previous] }));
}

export async function deleteCommentaire(recetteId, id) {
	const previous = get(commentaires)[recetteId] ?? [];
	commentaires.update((c) => ({
		...c,
		[recetteId]: previous.filter((x) => x.id !== id)
	}));
	const { error } = await supabase.from('commentaires').delete().eq('id', id);
	if (error) {
		commentaires.update((c) => ({ ...c, [recetteId]: previous }));
		throw error;
	}
}

export async function updateNotes(recetteId, notes) {
	const s = get(session);
	const previous = get(recettes);
	recettes.update((list) => list.map((r) => (r.id === recetteId ? { ...r, notes } : r)));
	const { error } = await supabase
		.from('recettes')
		.update({ notes })
		.eq('id', recetteId)
		.eq('user_id', s.user.id);
	if (error) {
		recettes.set(previous);
		throw error;
	}
}

export async function addIngredient(recetteId, ing) {
	const s = get(session);
	const { data, error } = await supabase
		.from('ingredients')
		.insert({ recette_id: recetteId, user_id: s.user.id, ...ing })
		.select()
		.single();
	if (error) throw error;
	recettes.update((list) =>
		list.map((r) => {
			if (r.id !== recetteId) return r;
			return { ...r, ingredients: [...(r.ingredients ?? []), data] };
		})
	);
}

export async function updateIngredient(id, updates) {
	const previous = get(recettes);
	recettes.update((list) =>
		list.map((r) => ({
			...r,
			ingredients: (r.ingredients ?? []).map((i) => (i.id === id ? { ...i, ...updates } : i))
		}))
	);
	const { error } = await supabase.from('ingredients').update(updates).eq('id', id);
	if (error) {
		recettes.set(previous);
		throw error;
	}
}

export async function deleteIngredient(recetteId, id) {
	const previous = get(recettes);
	recettes.update((list) =>
		list.map((r) => {
			if (r.id !== recetteId) return r;
			return { ...r, ingredients: (r.ingredients ?? []).filter((i) => i.id !== id) };
		})
	);
	const { error } = await supabase.from('ingredients').delete().eq('id', id);
	if (error) {
		recettes.set(previous);
		throw error;
	}
}

// ── Mise à jour champ recette (ex: nb_pieces_base) ───────────
export async function updateRecetteField(recetteId, updates) {
	const s = get(session);
	const previous = get(recettes);
	recettes.update((list) => list.map((r) => (r.id === recetteId ? { ...r, ...updates } : r)));
	const { error } = await supabase
		.from('recettes')
		.update(updates)
		.eq('id', recetteId)
		.eq('user_id', s.user.id);
	if (error) {
		recettes.set(previous);
		throw error;
	}
}

// ── Photos recette ────────────────────────────────────────────
export const recipePhotos = writable({});

export async function loadPhotos(recetteId) {
	const s = get(session);
	if (!s) return;
	const { data, error } = await supabase
		.from('recipe_photos')
		.select('*')
		.eq('recette_id', recetteId)
		.eq('user_id', s.user.id)
		.order('created_at', { ascending: false });
	if (error) { console.error('loadPhotos:', error); return; }
	recipePhotos.update((p) => ({ ...p, [recetteId]: data ?? [] }));
}

export async function uploadPhoto(recetteId, file) {
	const s = get(session);
	if (!s) throw new Error('Non connecté');
	const ext = file.name.split('.').pop() || 'jpg';
	const path = `${s.user.id}/${recetteId}/${Date.now()}.${ext}`;

	const { error: upErr } = await supabase.storage
		.from('recipe-photos')
		.upload(path, file, { cacheControl: '3600', upsert: false });
	if (upErr) throw upErr;

	const { data: urlData } = supabase.storage.from('recipe-photos').getPublicUrl(path);

	const { data, error: dbErr } = await supabase
		.from('recipe_photos')
		.insert({ recette_id: recetteId, user_id: s.user.id, storage_path: path })
		.select()
		.single();
	if (dbErr) throw dbErr;

	recipePhotos.update((p) => ({
		...p,
		[recetteId]: [{ ...data, publicUrl: urlData.publicUrl }, ...(p[recetteId] ?? [])]
	}));
	return urlData.publicUrl;
}

export async function deletePhoto(recetteId, photoId, storagePath) {
	const previous = get(recipePhotos);
	recipePhotos.update((p) => ({
		...p,
		[recetteId]: (p[recetteId] ?? []).filter((x) => x.id !== photoId)
	}));
	await supabase.storage.from('recipe-photos').remove([storagePath]);
	const { error } = await supabase.from('recipe_photos').delete().eq('id', photoId);
	if (error) {
		recipePhotos.set(previous);
		throw error;
	}
}

export function getPhotoUrl(path) {
	const { data } = supabase.storage.from('recipe-photos').getPublicUrl(path);
	return data.publicUrl;
}

// ── Suggestions utilisateur ───────────────────────────────────
export const suggestions = writable([]);

export async function submitSuggestion(contenu, type = 'amelioration') {
	const s = get(session);
	if (!s) throw new Error('Non connecté');
	const { data, error } = await supabase
		.from('suggestions')
		.insert({ user_id: s.user.id, contenu: contenu.trim(), type })
		.select()
		.single();
	if (error) throw error;
	suggestions.update((list) => [data, ...list]);
	return data;
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

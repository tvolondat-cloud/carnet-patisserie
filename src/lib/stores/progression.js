import { writable, derived, get } from 'svelte/store';
import { supabase } from '$lib/supabase.js';
import { session } from './auth.js';
import { recettes } from './recettes.js';

export const progression = writable({});

export async function loadProgression() {
	const s = get(session);
	if (!s) return;
	const { data } = await supabase
		.from('progression')
		.select('*')
		.eq('user_id', s.user.id);
	const map = {};
	for (const p of data ?? []) map[p.recette_id] = p;
	progression.set(map);
}

export async function updateProgression(recetteId, updates) {
	const s = get(session);
	const existing = get(progression)[recetteId];
	if (existing) {
		await supabase.from('progression').update(updates).eq('id', existing.id);
		progression.update(p => ({ ...p, [recetteId]: { ...existing, ...updates } }));
	} else {
		const { data } = await supabase
			.from('progression')
			.insert({ recette_id: recetteId, user_id: s.user.id, ...updates })
			.select()
			.single();
		progression.update(p => ({ ...p, [recetteId]: data }));
	}
}

export const stats = derived([recettes, progression], ([$recettes, $progression]) => {
	const total = $recettes.length;
	const byStatut = { 'a-tester': 0, testee: 0, validee: 0, maitrisee: 0 };
	const competenceScores = {};

	for (const r of $recettes) {
		const p = $progression[r.id];
		const statut = p?.statut ?? 'a-tester';
		byStatut[statut] = (byStatut[statut] ?? 0) + 1;

		const weight = statut === 'maitrisee' ? 1 : statut === 'validee' ? 0.66 : statut === 'testee' ? 0.33 : 0;
		for (const comp of r.competences ?? []) {
			if (!competenceScores[comp]) competenceScores[comp] = { sum: 0, count: 0 };
			competenceScores[comp].sum += weight;
			competenceScores[comp].count += 1;
		}
	}

	const maitrisees = byStatut.maitrisee;
	const score = total ? Math.round((maitrisees / total) * 100) : 0;

	const competences = {};
	for (const [k, v] of Object.entries(competenceScores)) {
		competences[k] = v.count ? Math.round((v.sum / v.count) * 100) : 0;
	}

	return { total, byStatut, score, maitrisees, competences };
});

import { browser } from '$app/environment';
import { get } from 'svelte/store';
import { supabase } from '$lib/supabase.js';
import { session } from './auth.js';
import { loadRecettes } from './recettes.js';
import { loadProgression } from './progression.js';
import { loadExamScores } from './exam.js';

/**
 * Supabase Realtime : synchronise les données en direct entre appareils.
 * Un changement Postgres sur une table de l'utilisateur déclenche un
 * rechargement (debouncé) des stores concernés — pas besoin de refocus.
 *
 * Prérequis SQL : tables ajoutées à la publication `supabase_realtime`
 * (voir migration 20260521_realtime.sql). Sans ça, l'abonnement ne reçoit
 * rien mais ne plante pas (le refetch au focus reste le filet de sécurité).
 */

let channel = null;
let timer = null;

function scheduleRefresh() {
	clearTimeout(timer);
	timer = setTimeout(() => {
		loadRecettes();
		loadProgression();
		loadExamScores();
	}, 300); // coalesce les rafales d'événements
}

export function startRealtime() {
	if (!browser || channel) return;
	const s = get(session);
	if (!s) return;

	const uid = s.user.id;
	const filter = `user_id=eq.${uid}`;
	const opts = (table) => ({ event: '*', schema: 'public', table, filter });

	channel = supabase
		.channel(`user-sync-${uid}`)
		.on('postgres_changes', opts('progression'), scheduleRefresh)
		.on('postgres_changes', opts('recettes'), scheduleRefresh)
		.on('postgres_changes', opts('ingredients'), scheduleRefresh)
		.on('postgres_changes', opts('exam_scores'), scheduleRefresh)
		.subscribe();
}

export function stopRealtime() {
	if (channel) {
		supabase.removeChannel(channel);
		channel = null;
	}
	clearTimeout(timer);
}

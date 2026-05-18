#!/usr/bin/env node
/**
 * Génère supabase/seed.sql à partir de src/lib/data/recipes.json.
 *
 * Usage : node scripts/generate-seed.js
 *
 * Le SQL produit définit deux fonctions :
 *  - seed_recettes_cap(p_user_id)        : insertion brute des 58 recettes
 *  - seed_recettes_cap_safe(p_user_id)   : wrapper idempotent (no-op si déjà seedé)
 */

import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, '..');
const recipes = JSON.parse(readFileSync(join(ROOT, 'src/lib/data/recipes.json'), 'utf8'));

function sqlString(s) {
	if (s === null || s === undefined) return 'NULL';
	return "'" + String(s).replace(/'/g, "''") + "'";
}

function sqlArray(arr) {
	return 'ARRAY[' + arr.map(sqlString).join(',') + ']';
}

function sqlJsonb(obj) {
	return sqlString(JSON.stringify(obj)) + '::jsonb';
}

const lines = [];
lines.push('-- ============================================================');
lines.push('-- CARNET CAP — Seed v3 (auto-généré)');
lines.push(`-- ${recipes.recettes.length} recettes CAP Pâtissier 2025-2026`);
lines.push('-- Généré depuis src/lib/data/recipes.json — NE PAS ÉDITER À LA MAIN');
lines.push('-- Régénérer avec : npm run seed:generate');
lines.push('-- Appel : SELECT seed_recettes_cap_safe(\'user-uuid\');');
lines.push('-- ============================================================');
lines.push('');
lines.push('CREATE OR REPLACE FUNCTION seed_recettes_cap(p_user_id UUID)');
lines.push('RETURNS void AS $$');
lines.push('DECLARE r_id UUID;');
lines.push('BEGIN');
lines.push('');

for (const r of recipes.recettes) {
	const etapes = (r.etapes ?? []).map((e) => ({ ordre: e.ordre, description: e.description }));
	lines.push(`-- ${r.nom}`);
	lines.push('INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)');
	lines.push(`VALUES (uuid_generate_v4(), p_user_id, ${sqlString(r.nom)}, ${sqlString(r.categorie)},`);
	lines.push(`        ${sqlArray(r.competences ?? [])}, ${r.temps ?? 0}, ${r.difficulte ?? 1}, ${sqlString(r.ep ?? 'EP1')}, ${r.chrono_cible ?? 0}, '', ${sqlJsonb(etapes)})`);
	lines.push('RETURNING id INTO r_id;');

	if ((r.ingredients ?? []).length) {
		lines.push('INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES');
		const ingLines = r.ingredients.map((ing, i) => {
			return `  (r_id, p_user_id, ${sqlString(ing.nom)}, ${ing.quantite}, ${sqlString(ing.unite)}, ${i + 1})`;
		});
		lines.push(ingLines.join(',\n') + ';');
	}

	if ((r.quiz ?? []).length) {
		lines.push('INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES');
		const qLines = r.quiz.map((q, i) => {
			return `  (r_id, p_user_id, ${sqlString(q.question)}, ${sqlArray(q.reponses)}, ${q.bonne}, ${i + 1})`;
		});
		lines.push(qLines.join(',\n') + ';');
	}
	lines.push('');
}

lines.push('END;');
lines.push('$$ LANGUAGE plpgsql SECURITY DEFINER;');
lines.push('');
lines.push('-- Wrapper idempotent : ne fait rien si l\'utilisateur a déjà des recettes');
lines.push('CREATE OR REPLACE FUNCTION seed_recettes_cap_safe(p_user_id UUID)');
lines.push('RETURNS void AS $$');
lines.push('BEGIN');
lines.push('  IF EXISTS (SELECT 1 FROM recettes WHERE user_id = p_user_id LIMIT 1) THEN');
lines.push('    RETURN;');
lines.push('  END IF;');
lines.push('  PERFORM seed_recettes_cap(p_user_id);');
lines.push('END;');
lines.push('$$ LANGUAGE plpgsql SECURITY DEFINER;');
lines.push('');

const out = lines.join('\n');
writeFileSync(join(ROOT, 'supabase/seed.sql'), out, 'utf8');
console.log(`✅ seed.sql généré : ${recipes.recettes.length} recettes`);

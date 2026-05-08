#!/usr/bin/env node
// ============================================================
// sync-docs.js
// Met à jour CHANGELOG.md à partir des commits récents.
// Lancé manuellement via `npm run docs:sync` ou automatiquement
// par le hook pre-push (.githooks/pre-push).
// ============================================================
//
// Logique :
// 1. Lit le SHA du dernier commit qui a touché CHANGELOG.md
// 2. Récupère tous les commits depuis ce SHA
// 3. Catégorise par préfixe conventional commit (feat/fix/docs/...)
// 4. Filtre les commits "docs(auto):" et "chore(release):" pour
//    éviter les boucles
// 5. Prepend les nouvelles entrées dans la section [Unreleased]
//    de CHANGELOG.md
// 6. Si CHANGELOG modifié et exécuté en mode --auto-stage,
//    le stage git pour qu'il soit inclus dans le push

import { execSync } from 'node:child_process';
import { readFileSync, writeFileSync, existsSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, '..');
const CHANGELOG = join(ROOT, 'CHANGELOG.md');

const args = new Set(process.argv.slice(2));
const AUTO_STAGE = args.has('--auto-stage');
const VERBOSE = args.has('--verbose') || args.has('-v');

const log = (...m) => console.log('[sync-docs]', ...m);
const vlog = (...m) => VERBOSE && log(...m);

const PREFIX_LABELS = {
	feat: '✨ Features',
	fix: '🐛 Bug Fixes',
	brand: '🎨 Branding',
	seo: '🔍 SEO',
	deploy: '🚀 Deploy',
	docs: '📝 Documentation',
	refactor: '♻️ Refactoring',
	perf: '⚡ Performance',
	style: '💄 Style',
	test: '✅ Tests',
	chore: '🧹 Chores'
};

const SKIP_PATTERNS = [
	/^docs\(auto\):/, // évite la boucle (commits faits par ce script)
	/^chore\(release\):/
];

function git(cmd) {
	return execSync(cmd, { cwd: ROOT, encoding: 'utf8' }).trim();
}

// Sépare sur le délimiteur '||' qu'on injecte dans --pretty
function parseCommit(line) {
	const [sha, msg] = line.split('||');
	if (!msg) return null;
	const match = msg.match(/^([a-z]+)(\(.+?\))?:\s*(.+)$/i);
	if (!match) return { sha, raw: msg, prefix: 'chore', subject: msg };
	const [, prefix, scope, subject] = match;
	return { sha, prefix: prefix.toLowerCase(), scope: scope || '', subject };
}

// Format pretty avec délimiteur '||' (évite les soucis d'échappement shell sur Windows)
const PRETTY = '--pretty=%H||%s';

function getLastChangelogCommit() {
	try {
		const log = git(`git log ${PRETTY} -n 50 -- CHANGELOG.md`);
		const lines = log.split('\n');
		for (const line of lines) {
			const [sha, subject = ''] = line.split('||');
			if (!sha) continue;
			if (!SKIP_PATTERNS.some((p) => p.test(subject))) {
				return sha;
			}
		}
	} catch {
		// pas d'historique
	}
	return null;
}

function getNewCommits(sinceSha) {
	const range = sinceSha ? `${sinceSha}..HEAD` : 'HEAD';
	let raw;
	try {
		raw = git(`git log ${range} ${PRETTY}`);
	} catch {
		return [];
	}
	if (!raw) return [];
	return raw
		.split('\n')
		.map(parseCommit)
		.filter(Boolean)
		.filter((c) => !SKIP_PATTERNS.some((p) => p.test(`${c.prefix}${c.scope}: ${c.subject}`)));
}

function groupByPrefix(commits) {
	const groups = {};
	for (const c of commits) {
		const key = PREFIX_LABELS[c.prefix] || PREFIX_LABELS.chore;
		(groups[key] ||= []).push(c);
	}
	return groups;
}

function buildEntries(groups) {
	const order = Object.values(PREFIX_LABELS);
	const lines = [];
	for (const label of order) {
		const items = groups[label];
		if (!items?.length) continue;
		lines.push(`### ${label}`, '');
		for (const c of items) {
			const scope = c.scope ? ` ${c.scope}` : '';
			lines.push(`- ${c.subject}${scope} (\`${c.sha.slice(0, 7)}\`)`);
		}
		lines.push('');
	}
	return lines.join('\n');
}

function updateChangelog(newEntries) {
	if (!existsSync(CHANGELOG)) {
		log('CHANGELOG.md introuvable, abort.');
		process.exit(0);
	}
	const content = readFileSync(CHANGELOG, 'utf8');
	const today = new Date().toISOString().slice(0, 10);

	const unreleasedRegex = /## \[Unreleased\]([\s\S]*?)(?=\n## |\n$)/;
	const match = content.match(unreleasedRegex);

	if (!match) {
		// Pas de section [Unreleased], on l'ajoute en haut
		const header = `# Changelog\n\n## [Unreleased]\n\n${newEntries}\n`;
		const rest = content.replace(/^# Changelog\n+/, '');
		writeFileSync(CHANGELOG, header + rest);
		log('Section [Unreleased] créée');
		return true;
	}

	// Marquer une signature pour éviter de re-prepend les mêmes lignes
	const signature = `<!-- sync-docs: ${today} -->`;
	if (content.includes(signature)) {
		vlog('CHANGELOG déjà synchronisé aujourd\'hui, skip.');
		return false;
	}

	const oldUnreleased = match[1].trim();
	const updated = `## [Unreleased]\n\n${signature}\n\n${newEntries}${oldUnreleased ? '\n' + oldUnreleased : ''}`;
	const newContent = content.replace(unreleasedRegex, updated);
	writeFileSync(CHANGELOG, newContent);
	return true;
}

function stageChangelog() {
	try {
		git('git add CHANGELOG.md');
		log('CHANGELOG.md ajouté au staging');
	} catch (e) {
		log('Échec git add :', e.message);
	}
}

// === MAIN ===
const lastSha = getLastChangelogCommit();
vlog('Last CHANGELOG commit:', lastSha || '(none)');

const commits = getNewCommits(lastSha);
if (!commits.length) {
	log('Aucun nouveau commit à intégrer.');
	process.exit(0);
}

log(`${commits.length} commit(s) à intégrer`);
const groups = groupByPrefix(commits);
const entries = buildEntries(groups);

if (!entries.trim()) {
	log('Rien à ajouter (commits filtrés).');
	process.exit(0);
}

const updated = updateChangelog(entries);
if (updated) {
	log('CHANGELOG.md mis à jour.');
	if (AUTO_STAGE) stageChangelog();
} else {
	log('CHANGELOG.md inchangé.');
}

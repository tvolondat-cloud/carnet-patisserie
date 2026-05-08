#!/usr/bin/env node
// ============================================================
// install-hooks.js
// Configure git pour utiliser .githooks/ (cross-platform).
// Lancé automatiquement par `npm install` via le script "prepare".
// ============================================================

import { execSync } from 'node:child_process';
import { existsSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, '..');
const GIT_DIR = join(ROOT, '.git');

// Si pas dans un repo git (ex: install dans un Dockerfile, CI sans .git), on skip silencieusement.
if (!existsSync(GIT_DIR)) {
	process.exit(0);
}

try {
	execSync('git config core.hooksPath .githooks', { cwd: ROOT, stdio: 'pipe' });
	console.log('[install-hooks] git hooks activés (.githooks/)');
} catch {
	// Si git non disponible, on skip silencieusement
	process.exit(0);
}

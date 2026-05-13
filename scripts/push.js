#!/usr/bin/env node
// ============================================================
// push.js — Push sécurisé via gh auth token (cross-platform)
//
// Contourne le bug Windows Credential Manager qui pointe vers
// googlepartner-debug au lieu de tvolondat-cloud.
//
// Usage (via npm scripts) :
//   npm run push:staging  → pousse la branche courante vers staging
//   npm run push:prod     → pousse main vers main (prod)
//
// Usage direct :
//   node scripts/push.js staging
//   node scripts/push.js main
// ============================================================

import { execSync } from 'node:child_process';

const REPO = 'tvolondat-cloud/carnet-patisserie';
const branch = process.argv[2] || 'staging';

if (!['staging', 'main'].includes(branch)) {
	console.error(`❌ Branche invalide: "${branch}". Utilise "staging" ou "main".`);
	process.exit(1);
}

// Récupère le token du compte actif gh
let token;
try {
	token = execSync('gh auth token', { stdio: ['pipe', 'pipe', 'pipe'] }).toString().trim();
} catch {
	console.error('❌ gh CLI non disponible ou non authentifié.');
	console.error('   Lance: gh auth login');
	process.exit(1);
}

// Vérifie le compte actif
try {
	const status = execSync('gh auth status 2>&1').toString();
	if (!status.includes('tvolondat-cloud') || !status.match(/tvolondat-cloud.*Active account: true/s)) {
		console.warn('⚠️  Compte gh actif ≠ tvolondat-cloud. Bascule automatique...');
		execSync('gh auth switch --user tvolondat-cloud', { stdio: 'inherit' });
		token = execSync('gh auth token', { stdio: ['pipe', 'pipe', 'pipe'] }).toString().trim();
	}
} catch {
	// Si la vérif échoue, on tente quand même le push
}

// Source branch = branche courante (sauf pour push:prod qui cible main→main)
const sourceBranch = branch === 'main'
	? 'main'
	: execSync('git rev-parse --abbrev-ref HEAD').toString().trim();

const remote = `https://x-access-token:${token}@github.com/${REPO}.git`;

console.log(`\n🚀 Push ${sourceBranch} → ${branch} ...`);

try {
	execSync(`git push "${remote}" ${sourceBranch}:${branch}`, { stdio: 'inherit' });
	console.log(`\n✅ Poussé sur ${branch}.`);

	if (branch === 'staging') {
		console.log(`\n🔗 Preview disponible dans ~90s :`);
		console.log(`   https://staging.brigade-sucree.pages.dev`);
		console.log(`\n   Si c'est OK → npm run push:prod`);
	} else {
		console.log(`\n🌐 Prod en déploiement → https://brigadesucree.app (~90s)`);
	}
} catch {
	console.error('\n❌ Push échoué. Vérifie git status et gh auth status.');
	process.exit(1);
}

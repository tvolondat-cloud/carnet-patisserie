#!/usr/bin/env node
// ============================================================
// security-scan.js — Scanner de sécurité Brigade Sucrée
//
// 1. Scan de secrets hardcodés dans les fichiers trackés par git
// 2. Audit npm (vulnérabilités connues des dépendances)
//
// Usage :
//   node scripts/security-scan.js            → scan complet
//   node scripts/security-scan.js --staged   → scan fichiers staged seulement
//   node scripts/security-scan.js --no-audit → scan secrets seulement (rapide)
//
// Exit codes :
//   0 → OK (ou seulement des vulns dans l'allowlist)
//   1 → Secret détecté OU nouvelle vuln critique
// ============================================================

import { execSync, spawnSync } from 'node:child_process';
import { readFileSync, existsSync } from 'node:fs';
import { resolve, extname } from 'node:path';

const ARGS = process.argv.slice(2);
const STAGED_ONLY = ARGS.includes('--staged');
const NO_AUDIT   = ARGS.includes('--no-audit');
const CI         = process.env.CI === 'true';

// ── Couleurs ────────────────────────────────────────────────
const RED    = CI ? '' : '\x1b[31m';
const YELLOW = CI ? '' : '\x1b[33m';
const GREEN  = CI ? '' : '\x1b[32m';
const CYAN   = CI ? '' : '\x1b[36m';
const BOLD   = CI ? '' : '\x1b[1m';
const RESET  = CI ? '' : '\x1b[0m';

// ── Vulnérabilités connues sans fix disponible ───────────────
// Format : { package: 'nom', severity: 'critical|high', reason: 'explication' }
// Ajouter ici quand npm audit --fix ne peut rien faire.
const AUDIT_ALLOWLIST = [
	{
		package: 'jspdf',
		severity: 'critical',
		reason: 'Pas de version corrigée disponible. Utilisé uniquement côté client pour export PDF. Surveiller les releases.'
	},
	{
		package: 'xlsx',
		severity: 'high',
		reason: 'SheetJS prototype pollution + ReDoS. Pas de fix upstream. Données traitées = exports locaux uniquement, pas de parsing fichiers tiers.'
	},
	{
		package: '@sveltejs/kit',
		severity: 'high',
		reason: 'Vuln transitive liée à une version de dépendance. Surveiller les releases SvelteKit.'
	},
	{
		package: 'svelte-hmr',
		severity: 'moderate',
		reason: 'Dépendance dev HMR uniquement, non incluse dans le build de production.'
	},
	{
		package: 'svelte',
		severity: 'moderate',
		reason: 'Lié à svelte-hmr (dev only), voir entrée svelte-hmr.'
	}
];

// ── Patterns de secrets à détecter ──────────────────────────
const SECRET_PATTERNS = [
	// Supabase service_role (INTERDIT côté client)
	{
		name: 'Supabase service_role key',
		severity: 'critical',
		pattern: /eyJhbGci[A-Za-z0-9+/=_-]{20,}.*service_role/,
		multiline: true,
		message: 'Clé service_role Supabase détectée. Ne jamais l\'exposer côté client.'
	},
	// JWT générique long (clé Supabase anon ou service_role)
	{
		name: 'JWT token (possible Supabase key)',
		severity: 'high',
		pattern: /eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9\.[A-Za-z0-9+/=_-]{100,}/,
		skipFiles: ['src/lib/supabase.js', '.env.example', 'CLAUDE.md', 'docs/'],
		message: 'JWT long hardcodé. Utiliser les variables d\'environnement.'
	},
	// GitHub PAT
	{
		name: 'GitHub Personal Access Token',
		severity: 'critical',
		pattern: /ghp_[A-Za-z0-9]{36}/,
		message: 'GitHub PAT détecté dans le code. Révoquer immédiatement sur github.com/settings/tokens.'
	},
	// GitHub OAuth token
	{
		name: 'GitHub OAuth token',
		severity: 'critical',
		pattern: /gho_[A-Za-z0-9]{36}/,
		message: 'GitHub OAuth token détecté. Ne jamais committer de tokens gh CLI.'
	},
	// OpenAI / Anthropic
	{
		name: 'OpenAI/Anthropic API key',
		severity: 'critical',
		pattern: /sk-[A-Za-z0-9]{32,}/,
		message: 'Clé API OpenAI/Anthropic détectée. Révoquer immédiatement.'
	},
	// Cloudflare API token
	{
		name: 'Cloudflare API token',
		severity: 'high',
		pattern: /[A-Za-z0-9_-]{37}(?=\s|"|'|$)/,
		skipFiles: [], // trop générique, appliqué seulement aux fichiers config
		onlyFiles: ['.env', 'wrangler.toml', '.cloudflare'],
		message: 'Token Cloudflare potentiellement hardcodé.'
	},
	// Clé privée PEM
	{
		name: 'Private key (PEM)',
		severity: 'critical',
		pattern: /-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----/,
		message: 'Clé privée PEM détectée. Ne jamais committer de clés privées.'
	},
	// Mot de passe hardcodé évident
	{
		name: 'Hardcoded password',
		severity: 'high',
		pattern: /password\s*[:=]\s*["'][^"']{8,}["']/i,
		skipFiles: ['CLAUDE.md', 'docs/', '.md'],
		message: 'Mot de passe potentiellement hardcodé.'
	},
	// URL avec credentials (exclut les template literals avec ${...})
	{
		name: 'URL with credentials',
		severity: 'high',
		pattern: /https?:\/\/[^:@\s$`]+:[^@\s$`{]{6,}@/,
		skipFiles: ['docs/', '.md', 'CLAUDE.md', 'scripts/push.js'],
		message: 'URL avec identifiants intégrés.'
	},
	// .env commité par accident
	{
		name: '.env file tracked by git',
		severity: 'critical',
		pattern: null, // check par nom de fichier
		filenamePattern: /^\.env(\.(local|prod|production|staging|dev))?$/,
		message: 'Fichier .env commité. Ajouter à .gitignore immédiatement.'
	}
];

// ── Extensions à scanner ─────────────────────────────────────
const SCAN_EXTENSIONS = new Set([
	'.js', '.ts', '.svelte', '.json', '.env', '.toml',
	'.yaml', '.yml', '.sh', '.bash', '.html', '.md'
]);

// ── Fichiers/dossiers à ignorer ──────────────────────────────
const IGNORE_PATHS = [
	'node_modules/', '.svelte-kit/', 'build/', '.git/',
	'package-lock.json', 'pnpm-lock.yaml', 'yarn.lock',
	// Fichiers de conf légitimes qui contiennent des patterns similaires
	'vite.config.js', 'svelte.config.js',
];

let exitCode = 0;
let totalFindings = 0;

// ──────────────────────────────────────────────────────────────
// 1. SCAN SECRETS
// ──────────────────────────────────────────────────────────────

console.log(`\n${BOLD}${CYAN}═══ 🔐 Brigade Sucrée — Security Scan ═══${RESET}\n`);

function getFilesToScan() {
	if (STAGED_ONLY) {
		const out = spawnSync('git', ['diff', '--cached', '--name-only', '--diff-filter=ACM'], { encoding: 'utf8' });
		return (out.stdout || '').trim().split('\n').filter(Boolean);
	}
	const out = spawnSync('git', ['ls-files'], { encoding: 'utf8' });
	return (out.stdout || '').trim().split('\n').filter(Boolean);
}

function shouldIgnore(filePath) {
	return IGNORE_PATHS.some(p => filePath.includes(p));
}

function shouldScan(filePath) {
	const ext = extname(filePath).toLowerCase();
	return SCAN_EXTENSIONS.has(ext) || filePath.startsWith('.env');
}

const files = getFilesToScan().filter(f => !shouldIgnore(f) && shouldScan(f));
const scanLabel = STAGED_ONLY ? 'fichiers staged' : 'fichiers trackés';
console.log(`${CYAN}[1/2] Scan secrets — ${files.length} ${scanLabel}${RESET}`);

const findings = [];

for (const filePath of files) {
	if (!existsSync(filePath)) continue;

	let content;
	try {
		content = readFileSync(filePath, 'utf8');
	} catch {
		continue;
	}

	for (const rule of SECRET_PATTERNS) {
		// Vérification par nom de fichier
		if (rule.filenamePattern) {
			const basename = filePath.split('/').pop().split('\\').pop();
			if (rule.filenamePattern.test(basename)) {
				findings.push({ file: filePath, rule, line: 0, match: basename });
			}
			continue;
		}

		// Fichiers "onlyFiles" — n'appliquer que sur ces fichiers
		if (rule.onlyFiles?.length && !rule.onlyFiles.some(p => filePath.includes(p))) {
			continue;
		}

		// Fichiers à ignorer pour cette règle
		if (rule.skipFiles?.some(p => filePath.includes(p))) {
			continue;
		}

		// Scan ligne par ligne (ignore les lignes avec // security-scan-ignore)
		const lines = content.split('\n');
		for (let i = 0; i < lines.length; i++) {
			if (lines[i].includes('security-scan-ignore')) continue;
			if (rule.pattern && rule.pattern.test(lines[i])) {
				findings.push({ file: filePath, rule, line: i + 1, match: lines[i].trim().slice(0, 80) });
			}
		}

		// Scan multiline si nécessaire
		if (rule.multiline && rule.pattern && rule.pattern.test(content)) {
			findings.push({ file: filePath, rule, line: '?', match: '(multiline match)' });
		}
	}
}

if (findings.length === 0) {
	console.log(`${GREEN}  ✅ Aucun secret détecté.${RESET}\n`);
} else {
	totalFindings += findings.length;
	exitCode = 1;
	console.log(`${RED}  ❌ ${findings.length} finding(s) :\n${RESET}`);
	for (const f of findings) {
		const sev = f.rule.severity === 'critical' ? `${RED}[CRITICAL]${RESET}` : `${YELLOW}[HIGH]${RESET}`;
		console.log(`  ${sev} ${BOLD}${f.file}${RESET}${f.line ? `:${f.line}` : ''}`);
		console.log(`       → ${f.rule.name}`);
		console.log(`       💬 ${f.rule.message}`);
		if (f.match && f.match !== f.file) {
			console.log(`       Preview: ${f.match.slice(0, 100)}`);
		}
		console.log('');
	}
}

// ──────────────────────────────────────────────────────────────
// 2. NPM AUDIT
// ──────────────────────────────────────────────────────────────

if (!NO_AUDIT) {
	console.log(`${CYAN}[2/2] npm audit — vulnérabilités dépendances${RESET}`);

	let auditData;
	try {
		const result = spawnSync('npm', ['audit', '--json', '--production'], {
			encoding: 'utf8',
			shell: true
		});
		auditData = JSON.parse(result.stdout || '{}');
	} catch {
		console.log(`${YELLOW}  ⚠️  npm audit non disponible (skip).${RESET}\n`);
	}

	if (auditData) {
		const vulns = Object.values(auditData.vulnerabilities || {});
		const critical = vulns.filter(v => v.severity === 'critical');
		const high     = vulns.filter(v => v.severity === 'high');
		const moderate = vulns.filter(v => v.severity === 'moderate');

		const isAllowlisted = (pkg) =>
			AUDIT_ALLOWLIST.some(a => a.package === pkg);

		const newCritical = critical.filter(v => !isAllowlisted(v.name));
		const newHigh     = high.filter(v => !isAllowlisted(v.name));

		// Résumé
		console.log(`\n  Résultats :`);
		console.log(`  ${critical.length} critical · ${high.length} high · ${moderate.length} moderate`);

		// Allowlist info
		const allowlisted = [...critical, ...high].filter(v => isAllowlisted(v.name));
		if (allowlisted.length > 0) {
			console.log(`\n  ${YELLOW}⚠️  Vulnérabilités connues dans l'allowlist (sans fix disponible) :${RESET}`);
			for (const v of allowlisted) {
				const a = AUDIT_ALLOWLIST.find(x => x.package === v.name);
				console.log(`     ${YELLOW}[${v.severity.toUpperCase()}]${RESET} ${v.name}`);
				console.log(`            Raison : ${a.reason}`);
			}
		}

		// Nouvelles vulnérabilités (hors allowlist)
		if (newCritical.length > 0 || newHigh.length > 0) {
			exitCode = 1;
			totalFindings += newCritical.length + newHigh.length;
			console.log(`\n  ${RED}❌ Nouvelles vulnérabilités (hors allowlist) :${RESET}`);
			for (const v of [...newCritical, ...newHigh]) {
				const sev = v.severity === 'critical' ? `${RED}[CRITICAL]${RESET}` : `${YELLOW}[HIGH]${RESET}`;
				console.log(`     ${sev} ${BOLD}${v.name}${RESET}`);
				const via = v.via?.filter(x => typeof x === 'object').map(x => x.title).join(', ');
				if (via) console.log(`            Via : ${via}`);
			}
			console.log(`\n  👉 Lance \`npm audit fix\` ou mets à jour la dépendance.`);
			console.log(`     Si pas de fix → ajoute à AUDIT_ALLOWLIST dans scripts/security-scan.js.\n`);
		} else {
			console.log(`\n  ${GREEN}  ✅ Aucune nouvelle vulnérabilité critique/haute.${RESET}\n`);
		}
	}
}

// ──────────────────────────────────────────────────────────────
// Résultat final
// ──────────────────────────────────────────────────────────────

console.log(`${BOLD}${CYAN}═══ Résultat ═══${RESET}`);

if (exitCode === 0) {
	console.log(`${GREEN}${BOLD}✅ Scan OK — aucun problème bloquant.${RESET}\n`);
} else {
	console.log(`${RED}${BOLD}❌ ${totalFindings} problème(s) bloquant(s) détecté(s).${RESET}`);
	console.log(`${YELLOW}   Corriger avant de pousser en prod.${RESET}\n`);
}

process.exit(exitCode);

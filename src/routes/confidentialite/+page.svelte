<script>
import { goto } from '$app/navigation';
import { resetConsent } from '$lib/analytics.js';

const lastUpdate = '4 mai 2026';

function reopenBanner() {
	resetConsent();
	goto('/');
}
</script>

<svelte:head>
	<title>Politique de confidentialité — Brigade Sucrée</title>
	<meta name="description" content="Politique de confidentialité de Brigade Sucrée — gestion des données personnelles, cookies, droits RGPD." />
</svelte:head>

<div class="page" style="max-width:680px">
	<button type="button" class="btn btn-ghost btn-sm" on:click={() => history.back()} style="margin-bottom:12px">← Retour</button>

	<h1 class="page-title">📜 Politique de confidentialité</h1>
	<p class="page-subtitle">Mise à jour : {lastUpdate}</p>

	<article class="legal">
		<section>
			<h2>1. Qui sommes-nous ?</h2>
			<p>
				<strong>Brigade Sucrée</strong> est une PWA mobile dédiée aux étudiants CAP Pâtissier
				et aux passionnés de pâtisserie. Le service est édité par <strong>Timothy Volondat</strong>,
				domicilié en France. Pour toute question relative au traitement de tes données :
				<a href="mailto:hello@brigadesucree.app">hello@brigadesucree.app</a>.
			</p>
		</section>

		<section>
			<h2>2. Données que nous collectons</h2>
			<p>Nous collectons strictement le minimum nécessaire au fonctionnement de l'app :</p>
			<ul>
				<li><strong>Compte</strong> : email, prénom, photo de profil (si Google), date d'examen, type de profil (CAP / particulier).</li>
				<li><strong>Contenu utilisateur</strong> : tes recettes, tes notes, tes commentaires, ta progression (statuts, scores, chronos).</li>
				<li><strong>Mesure d'audience</strong> : si tu acceptes, Google Analytics 4 (GA4) collecte des données anonymisées sur ton usage de l'app (pages visitées, événements clés). Aucune donnée personnelle identifiable n'est partagée avec GA4.</li>
				<li><strong>Cookies techniques</strong> : session d'authentification, préférences d'interface.</li>
			</ul>
		</section>

		<section>
			<h2>3. Pourquoi ces données ?</h2>
			<ul>
				<li><strong>Faire fonctionner l'app</strong> (auth, sauvegarde de tes recettes) — base légale : exécution du contrat (art. 6.1.b RGPD).</li>
				<li><strong>Améliorer le produit</strong> via la mesure d'audience anonymisée — base légale : consentement (art. 6.1.a RGPD), révocable à tout moment.</li>
				<li><strong>Te contacter</strong> en cas de problème de sécurité ou d'évolution majeure — base légale : intérêt légitime.</li>
			</ul>
		</section>

		<section>
			<h2>4. Avec qui partageons-nous ces données ?</h2>
			<p>Strictement avec nos sous-traitants techniques, sous contrat conforme RGPD :</p>
			<ul>
				<li><strong>Supabase</strong> (hébergement de la base de données, authentification) — serveurs UE.</li>
				<li><strong>Cloudflare</strong> (CDN, hébergement de l'app, DNS) — serveurs distribués.</li>
				<li><strong>Google</strong> (Analytics 4 + OAuth si tu utilises « Continuer avec Google ») — soumis au DPF (Data Privacy Framework UE-USA).</li>
			</ul>
			<p><strong>Aucune revente de tes données.</strong> Aucune publicité ciblée. Aucun profilage commercial.</p>
		</section>

		<section>
			<h2>5. Combien de temps gardons-nous tes données ?</h2>
			<ul>
				<li><strong>Compte actif</strong> : tant que tu utilises l'app.</li>
				<li><strong>Compte inactif</strong> : 3 ans après la dernière connexion, puis suppression automatique.</li>
				<li><strong>Mesure d'audience anonymisée</strong> : 14 mois (paramètre GA4 par défaut).</li>
				<li><strong>Logs techniques</strong> : 12 mois maximum.</li>
			</ul>
		</section>

		<section>
			<h2>6. Tes droits RGPD</h2>
			<p>Tu disposes des droits suivants :</p>
			<ul>
				<li><strong>Accès</strong> : obtenir une copie de tes données.</li>
				<li><strong>Rectification</strong> : corriger des informations inexactes.</li>
				<li><strong>Effacement</strong> : supprimer ton compte et toutes les données associées.</li>
				<li><strong>Limitation</strong> du traitement.</li>
				<li><strong>Portabilité</strong> : récupérer tes recettes au format JSON ou PDF.</li>
				<li><strong>Opposition</strong> au traitement basé sur l'intérêt légitime.</li>
				<li><strong>Retrait du consentement</strong> à tout moment pour la mesure d'audience.</li>
			</ul>
			<p>
				Pour exercer ces droits, écris-nous à <a href="mailto:hello@brigadesucree.app">hello@brigadesucree.app</a>.
				Réponse garantie sous 30 jours.
			</p>
			<p>
				En cas de désaccord, tu peux saisir la <strong>CNIL</strong> :
				<a href="https://www.cnil.fr/fr/plaintes" target="_blank" rel="noopener">cnil.fr/plaintes</a>.
			</p>
		</section>

		<section>
			<h2>7. Cookies</h2>
			<p>Brigade Sucrée utilise deux familles de cookies :</p>
			<ul>
				<li><strong>Nécessaires</strong> (toujours actifs) : session d'authentification Supabase, choix de consentement, préférences d'interface.</li>
				<li><strong>Mesure d'audience</strong> (sur consentement) : Google Analytics 4 (`G-XJMXR88JGC`) via Google Tag Manager (`GTM-KRKFJLVD`). Anonymisation IP activée. Pas de signaux marketing.</li>
			</ul>
			<p>
				<button type="button" class="btn btn-secondary btn-sm" on:click={reopenBanner}>
					🍪 Re-paramétrer mes choix
				</button>
			</p>
		</section>

		<section>
			<h2>8. Sécurité</h2>
			<p>
				Tes données sont protégées par : authentification PKCE OAuth 2.0, chiffrement HTTPS (TLS 1.3),
				Row Level Security PostgreSQL (chaque utilisateur ne voit que ses données),
				headers de sécurité (CSP, HSTS, X-Frame-Options, etc.), et serveurs en UE.
			</p>
		</section>

		<section>
			<h2>9. Évolutions</h2>
			<p>
				Cette politique peut évoluer. Toute modification substantielle te sera notifiée
				dans l'app et par email. Date de la dernière mise à jour : <strong>{lastUpdate}</strong>.
			</p>
		</section>
	</article>
</div>

<style>
.legal section { margin-bottom: 24px; }
.legal h2 {
	font-size: 1rem;
	font-weight: 700;
	margin-bottom: 8px;
	color: var(--color-brand);
}
.legal p, .legal ul {
	font-size: 0.88rem;
	line-height: 1.65;
	color: var(--color-text);
	margin-bottom: 8px;
}
.legal ul { padding-left: 22px; }
.legal li { margin-bottom: 4px; }
.legal a {
	color: var(--color-brand);
	text-decoration: underline;
	text-underline-offset: 2px;
}
</style>

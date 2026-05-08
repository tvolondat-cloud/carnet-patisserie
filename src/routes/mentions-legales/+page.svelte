<script>
const lastUpdate = '4 mai 2026';
</script>

<svelte:head>
	<title>Mentions légales — Brigade Sucrée</title>
</svelte:head>

<div class="page" style="max-width:680px">
	<button type="button" class="btn btn-ghost btn-sm" on:click={() => history.back()} style="margin-bottom:12px">← Retour</button>

	<h1 class="page-title">⚖️ Mentions légales</h1>
	<p class="page-subtitle">Mise à jour : {lastUpdate}</p>

	<article class="legal">
		<section>
			<h2>Éditeur</h2>
			<p>
				<strong>Brigade Sucrée</strong><br />
				Édité par Timothy Volondat<br />
				Email : <a href="mailto:hello@brigadesucree.app">hello@brigadesucree.app</a>
			</p>
		</section>

		<section>
			<h2>Hébergement</h2>
			<p>
				<strong>Cloudflare, Inc.</strong><br />
				101 Townsend Street, San Francisco, California 94107, USA<br />
				<a href="https://www.cloudflare.com" target="_blank" rel="noopener">cloudflare.com</a>
			</p>
			<p>
				<strong>Supabase</strong> (base de données et authentification)<br />
				Région : Europe (Paris)
			</p>
		</section>

		<section>
			<h2>Propriété intellectuelle</h2>
			<p>
				Le code source, le design et le contenu de Brigade Sucrée sont protégés par le droit
				d'auteur. Le contenu pédagogique (recettes, fiches, quiz) s'appuie sur le référentiel
				officiel CAP Pâtissier (RNCP 38765), domaine public. Toute reproduction non autorisée
				est interdite.
			</p>
		</section>

		<section>
			<h2>Contact</h2>
			<p>
				Pour toute question, signalement de bug ou demande RGPD :
				<a href="mailto:hello@brigadesucree.app">hello@brigadesucree.app</a>.
			</p>
		</section>

		<section>
			<h2>Liens</h2>
			<p>
				<a href="/confidentialite">📜 Politique de confidentialité</a><br />
				<a href="/cgu">📋 Conditions générales d'utilisation</a>
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
.legal p { font-size: 0.88rem; line-height: 1.65; margin-bottom: 8px; }
.legal a { color: var(--color-brand); text-decoration: underline; text-underline-offset: 2px; }
</style>

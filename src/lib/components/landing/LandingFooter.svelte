<script>
const year = new Date().getFullYear();
</script>

<footer class="ld-footer">
	<div class="ld-container">
		<div class="footer-grid">
			<div class="footer-brand">
				<div class="ld-logo">
					<span class="ld-logo-circle">🍪</span>
					<span class="ld-logo-text">Brigade <span>Sucrée</span></span>
				</div>
				<p class="footer-tagline">
					L'app des étudiants CAP Pâtissier et des passionnés.
					Made in France 🇫🇷
				</p>
			</div>

			<div class="footer-col">
				<h4>Produit</h4>
				<a href="#features">Fonctionnalités</a>
				<a href="#how">Comment ça marche</a>
				<a href="#pricing">Tarifs</a>
				<a href="#faq">FAQ</a>
				<a href="/auth">Se connecter</a>
			</div>

			<div class="footer-col">
				<h4>Légal</h4>
				<a href="/confidentialite">Confidentialité</a>
				<a href="/mentions-legales">Mentions légales</a>
				<a href="mailto:hello@brigadesucree.app">Nous contacter</a>
			</div>

			<div class="footer-col">
				<h4>Suivre</h4>
				<a href="https://instagram.com/brigadesucree" target="_blank" rel="noopener noreferrer">📷 Instagram</a>
				<a href="https://tiktok.com/@brigadesucree" target="_blank" rel="noopener noreferrer">🎵 TikTok</a>
				<a href="https://pinterest.com/brigadesucree" target="_blank" rel="noopener noreferrer">📌 Pinterest</a>
			</div>
		</div>

		<div class="footer-bottom">
			<p>© {year} Brigade Sucrée. Tous droits réservés.</p>
			<p class="footer-version">v0.4.0 · <a href="https://github.com/tvolondat-cloud/carnet-patisserie" target="_blank" rel="noopener">Open source</a></p>
		</div>
	</div>
</footer>

<style>
.ld-footer {
	background: var(--ld-deep-dark);
	color: rgba(244, 229, 210, 0.85);
	padding: 60px 0 32px;
}

.footer-grid {
	display: grid;
	grid-template-columns: 1.5fr 1fr 1fr 1fr;
	gap: 40px;
	margin-bottom: 40px;
}

.footer-brand .ld-logo { margin-bottom: 12px; }
.footer-brand .ld-logo-text { color: var(--ld-cream-light); }
.footer-brand .ld-logo-text span { color: var(--ld-orange-light); }

.footer-tagline {
	color: rgba(244, 229, 210, 0.6);
	font-size: 0.88rem;
	margin: 0;
	max-width: 260px;
}

.footer-col h4 {
	color: var(--ld-cream-light);
	font-size: 0.82rem;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: 0.08em;
	margin: 0 0 16px;
}

.footer-col {
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.footer-col a {
	color: rgba(244, 229, 210, 0.7);
	text-decoration: none;
	font-size: 0.9rem;
	transition: color 0.15s;
}
.footer-col a:hover { color: var(--ld-orange-light); }

.footer-bottom {
	padding-top: 32px;
	border-top: 1px solid rgba(244, 229, 210, 0.1);
	display: flex;
	justify-content: space-between;
	align-items: center;
	flex-wrap: wrap;
	gap: 12px;
	color: rgba(244, 229, 210, 0.5);
	font-size: 0.82rem;
}
.footer-bottom p { margin: 0; }
.footer-bottom a { color: rgba(244, 229, 210, 0.5); text-decoration: underline; }
.footer-bottom a:hover { color: var(--ld-orange-light); }

.footer-version { font-family: monospace; }

@media (max-width: 768px) {
	.footer-grid { grid-template-columns: 1fr 1fr; gap: 32px; }
	.footer-brand { grid-column: 1 / -1; }
}
</style>

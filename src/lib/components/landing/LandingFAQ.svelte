<script>
const faqs = [
	{
		q: 'Brigade Sucrée est-elle adaptée à un débutant complet ?',
		a: 'Oui. Chaque recette inclut les étapes détaillées, le vocabulaire technique expliqué, les pièges courants à éviter, et un quiz pour ancrer la théorie. Le mode Labo te guide pas à pas, avec des messages encourageants même si tu rates.'
	},
	{
		q: 'Combien coûte l\'app ?',
		a: '100% gratuit pendant la bêta — toutes les fonctionnalités incluses. Le plan Pro à 4,99€/mois (ou 39€/an) sortira après le Sprint 3 avec des features avancées (photos, partage, streak). La promesse : ce que tu utilises maintenant restera gratuit.'
	},
	{
		q: 'Le mode Laboratoire, c\'est concrètement quoi ?',
		a: 'Une méthode en 3 étapes : (1) Tester la recette en cuisine et la cocher. (2) Quiz théorique avec 4 questions, validé à 75%. (3) Chrono de réalisation, validé si tu es dans les temps + 20% de tolérance. Quand les 3 sont validées → recette "maîtrisée".'
	},
	{
		q: 'Est-ce que Brigade Sucrée remplace une école de pâtisserie ?',
		a: 'Non, c\'est un complément. L\'app structure ta révision et te fait gagner du temps, mais le geste se travaille en pratique. Pour les étudiants CAP en alternance, c\'est l\'outil idéal entre les sessions au CFA. Pour les particuliers, c\'est un guide structuré.'
	},
	{
		q: 'Sur quels appareils ça marche ?',
		a: 'Brigade Sucrée est une PWA (Progressive Web App) : ça tourne sur iOS, Android, desktop, peu importe le navigateur moderne. Tu peux l\'installer comme une app native (icône sur l\'écran d\'accueil) et l\'utiliser hors-ligne grâce au cache.'
	},
	{
		q: 'Mes données sont-elles privées ?',
		a: 'Oui. Tes recettes, notes et progression sont stockées en France (Supabase Paris) avec Row Level Security : seul ton compte y accède. Pas de revente, pas de pub. Les analytics sont opt-in (Consent Mode v2 RGPD), tu peux refuser depuis la bannière cookies.'
	},
	{
		q: 'Je peux exporter mes recettes ?',
		a: 'Oui : export PDF complet (format A4, marge 3 cm classeur, couleurs Berry Jam). Le PDF inclut les ingrédients, les étapes, tes notes personnelles. Filtres par catégorie ou option "uniquement les recettes maîtrisées".'
	},
	{
		q: 'Puis-je ajouter mes propres recettes ?',
		a: 'Pas encore : la bêta inclut les 17 recettes du référentiel CAP officiel. Les recettes personnelles arrivent au Sprint 2 (création, édition, photos). En attendant, tu peux modifier les ingrédients, les notes et les commentaires sur les recettes existantes.'
	}
];

let openIndex = 0;

function toggle(i) {
	openIndex = openIndex === i ? -1 : i;
}
</script>

<section class="ld-section faq" id="faq">
	<div class="ld-container">
		<div class="faq-header">
			<span class="ld-eyebrow">Questions fréquentes</span>
			<h2 class="ld-h2">On répond avant que tu demandes</h2>
		</div>

		<div class="faq-list">
			{#each faqs as faq, i}
				<details class="faq-item" open={openIndex === i}>
					<summary
						class="faq-question"
						on:click|preventDefault={() => toggle(i)}
					>
						<span>{faq.q}</span>
						<span class="faq-icon" aria-hidden="true">{openIndex === i ? '−' : '+'}</span>
					</summary>
					<div class="faq-answer">
						<p>{faq.a}</p>
					</div>
				</details>
			{/each}
		</div>

		<div class="faq-foot">
			<p>Une autre question ?</p>
			<a href="mailto:hello@brigadesucree.app" class="ld-btn ld-btn-secondary">
				✉️ hello@brigadesucree.app
			</a>
		</div>
	</div>
</section>

<style>
.faq-header {
	text-align: center;
	max-width: 640px;
	margin: 0 auto 48px;
}

.faq-list {
	max-width: 760px;
	margin: 0 auto;
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.faq-item {
	background: var(--ld-white);
	border-radius: 14px;
	border: 1px solid rgba(31, 77, 69, 0.08);
	overflow: hidden;
	transition: border-color 0.15s, box-shadow 0.15s;
}
.faq-item[open] {
	border-color: var(--ld-orange);
	box-shadow: 0 8px 24px rgba(210, 104, 61, 0.1);
}

.faq-question {
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 16px;
	padding: 20px 24px;
	cursor: pointer;
	font-size: 1rem;
	font-weight: 700;
	color: var(--ld-deep);
	list-style: none;
}
.faq-question::-webkit-details-marker { display: none; }

.faq-icon {
	flex-shrink: 0;
	width: 28px;
	height: 28px;
	border-radius: 50%;
	background: var(--ld-orange);
	color: var(--ld-white);
	display: grid;
	place-items: center;
	font-size: 1.2rem;
	font-weight: 800;
	line-height: 1;
	transition: transform 0.2s;
}

.faq-answer {
	padding: 0 24px 20px;
	color: var(--ld-text-muted);
	font-size: 0.92rem;
	line-height: 1.65;
}
.faq-answer p { margin: 0; }

.faq-foot {
	margin-top: 48px;
	text-align: center;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 12px;
}
.faq-foot p {
	color: var(--ld-text-muted);
	margin: 0;
	font-size: 0.9rem;
}
</style>

<script>
import { faqs } from '$lib/data/landing-faq.js';

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

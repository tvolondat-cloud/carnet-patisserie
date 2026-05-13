<script>
import { recettes } from '$lib/stores/recettes.js';
import { progression } from '$lib/stores/progression.js';
import { slugify } from '$lib/utils/slugify.js';

$: aTester = $recettes.filter(r => !$progression[r.id] || $progression[r.id].statut === 'a-tester');
$: testees  = $recettes.filter(r => $progression[r.id]?.statut === 'testee');
$: validees = $recettes.filter(r => $progression[r.id]?.statut === 'validee');

const statutColor = { 'a-tester': 'var(--color-a-tester)', testee: 'var(--color-testee)', validee: 'var(--color-validee)' };
</script>

<div class="page">
	<h1 class="page-title">📚 Réviser</h1>
	<p class="page-subtitle">Entraîne-toi sur les recettes à maîtriser</p>

	{#each [['À tester en priorité', aTester, 'a-tester', '📋'], ['À valider', testees, 'testee', '🧪'], ['À maîtriser', validees, 'validee', '✅']] as [title, recs, statut, emoji]}
	{#if recs.length}
	<div class="card mb-3">
		<div class="section-title mb-3" style="color:{statutColor[statut]}">{emoji} {title} ({recs.length})</div>
		{#each recs as r}
		<div style="display:flex;align-items:center;justify-content:space-between;padding:10px 0;border-bottom:1px solid var(--color-border)">
			<div>
				<div style="font-size:0.9rem;font-weight:600">{r.nom}</div>
				<div class="text-xs text-muted">⏱ {r.temps} min · {r.ep}</div>
			</div>
			<a href="/laboratoire/{slugify(r.nom)}" class="btn btn-primary btn-sm">🧪 Labo</a>
		</div>
		{/each}
	</div>
	{/if}
	{/each}

	{#if aTester.length === 0 && testees.length === 0 && validees.length === 0}
	<div class="empty-state">
		<div class="empty-state-emoji">⭐</div>
		<div class="empty-state-title">Toutes maîtrisées !</div>
		<div class="empty-state-desc">Tu as maîtrisé toutes tes recettes. Excellent travail !</div>
	</div>
	{/if}
</div>

<script>
import { recettes } from '$lib/stores/recettes.js';
import { stats, progression } from '$lib/stores/progression.js';
import recipesData from '$lib/data/recipes.json';

const competences = recipesData.competences;

const statutLabel = { 'a-tester': 'À tester', testee: 'Testée', validee: 'Validée', maitrisee: 'Maîtrisée' };
const statutColor = { 'a-tester': 'var(--color-a-tester)', testee: 'var(--color-testee)', validee: 'var(--color-validee)', maitrisee: 'var(--color-maitrisee)' };
</script>

<div class="page">
	<h1 class="page-title">📊 Suivi</h1>
	<p class="page-subtitle">Ta progression CAP</p>

	<!-- Score global -->
	<div class="card" style="display:flex;align-items:center;gap:20px;margin-bottom:16px">
		<div class="score-ring" style="background:conic-gradient(var(--color-brand) {$stats.score * 3.6}deg, var(--color-surface-2) 0deg)">
			<div class="score-ring-inner">
				<div class="score-number">{$stats.score}<span style="font-size:1rem">%</span></div>
				<div class="score-label">maîtrisé</div>
			</div>
		</div>
		<div>
			<div style="font-size:0.85rem;font-weight:600;margin-bottom:8px">{$stats.maitrisees} / {$stats.total} recettes</div>
			{#each [['a-tester','📋'],['testee','🧪'],['validee','✅'],['maitrisee','⭐']] as [k, emoji]}
			<div style="display:flex;align-items:center;gap:6px;margin-bottom:4px">
				<span style="font-size:0.72rem;width:70px;color:{statutColor[k]};font-weight:500">{emoji} {statutLabel[k]}</span>
				<div class="progress-bar-container" style="flex:1;height:6px">
					<div class="progress-bar-fill" style="width:{$stats.total ? ($stats.byStatut[k]??0)/$stats.total*100 : 0}%;background:{statutColor[k]}"></div>
				</div>
				<span style="font-size:0.72rem;color:var(--color-text-2);width:16px;text-align:right">{$stats.byStatut[k]??0}</span>
			</div>
			{/each}
		</div>
	</div>

	<!-- Compétences -->
	<div class="card mb-3">
		<div class="section-title mb-3">Compétences CAP</div>
		{#each competences as comp}
		{@const pct = $stats.competences[comp.id] ?? 0}
		<div class="skill-bar">
			<div class="skill-bar-label">
				<span>{comp.emoji} {comp.label}</span>
				<span style="color:{comp.color};font-weight:700">{pct}%</span>
			</div>
			<div class="skill-bar-track">
				<div class="skill-bar-fill" style="width:{pct}%;background:{comp.color}"></div>
			</div>
		</div>
		{/each}
	</div>

	<!-- Toutes les recettes par statut -->
	{#each ['maitrisee','validee','testee','a-tester'] as statut}
	{@const recs = $recettes.filter(r => ($progression[r.id]?.statut ?? 'a-tester') === statut)}
	{#if recs.length}
	<div class="card mb-3">
		<div class="section-title mb-2" style="color:{statutColor[statut]}">{statutLabel[statut]} ({recs.length})</div>
		{#each recs as r}
		<a href="/recettes/{r.id}" style="display:block;padding:8px 0;border-bottom:1px solid var(--color-border);font-size:0.9rem">
			{r.nom}
		</a>
		{/each}
	</div>
	{/if}
	{/each}
</div>

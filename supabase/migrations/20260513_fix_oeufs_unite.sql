-- Migration : normaliser les œufs entiers → unite='u', quantite en pièces
-- 1 œuf entier ≈ 50 g (standard CAP Pâtissier)
-- À exécuter dans Supabase SQL Editor.

-- Étape 1 : convertir les œufs entiers stockés en grammes
-- (ex: 300 g → 6 u, 250 g → 5 u, 200 g → 4 u, 50 g → 1 u)
UPDATE ingredients
SET
  quantite = ROUND(quantite / 50.0),
  unite    = 'u'
WHERE
  (nom ILIKE '%oeufs entiers%' OR nom ILIKE '%œufs entiers%'
   OR nom ILIKE '%oeuf entier%'  OR nom ILIKE '%œuf entier%')
  AND unite = 'g';

-- Étape 2 : normaliser 'pièces' → 'u' pour les œufs entiers
UPDATE ingredients
SET unite = 'u'
WHERE
  (nom ILIKE '%oeufs entiers%' OR nom ILIKE '%œufs entiers%'
   OR nom ILIKE '%oeuf entier%'  OR nom ILIKE '%œuf entier%')
  AND unite = 'pièces';

-- Vérification (à lancer après)
-- SELECT nom, quantite, unite FROM ingredients
-- WHERE nom ILIKE '%oeuf%' OR nom ILIKE '%œuf%'
-- ORDER BY nom;

-- ============================================================
-- Migration: Security hardening + indexes + constraints
-- À exécuter sur la base existante via SQL Editor Supabase
-- Idempotent : peut être ré-exécutée sans danger
-- ============================================================

-- ──────────────────────────────────────────────────────────────
-- 1. RLS — WITH CHECK + validation cross-table
-- ──────────────────────────────────────────────────────────────

-- profiles
DROP POLICY IF EXISTS "Profil visible par le propriétaire" ON profiles;
CREATE POLICY "profiles_owner" ON profiles
FOR ALL USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- recettes
DROP POLICY IF EXISTS "Recettes utilisateur" ON recettes;
CREATE POLICY "recettes_owner" ON recettes
FOR ALL USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- ingredients : valide aussi que recette_id appartient à l'user
DROP POLICY IF EXISTS "Ingrédients utilisateur" ON ingredients;
CREATE POLICY "ingredients_owner" ON ingredients
FOR ALL USING (auth.uid() = user_id)
WITH CHECK (
  auth.uid() = user_id
  AND EXISTS (SELECT 1 FROM recettes WHERE id = recette_id AND user_id = auth.uid())
);

-- quiz_questions : idem
DROP POLICY IF EXISTS "Questions utilisateur" ON quiz_questions;
CREATE POLICY "quiz_questions_owner" ON quiz_questions
FOR ALL USING (auth.uid() = user_id)
WITH CHECK (
  auth.uid() = user_id
  AND EXISTS (SELECT 1 FROM recettes WHERE id = recette_id AND user_id = auth.uid())
);

-- progression : idem
DROP POLICY IF EXISTS "Progression utilisateur" ON progression;
CREATE POLICY "progression_owner" ON progression
FOR ALL USING (auth.uid() = user_id)
WITH CHECK (
  auth.uid() = user_id
  AND EXISTS (SELECT 1 FROM recettes WHERE id = recette_id AND user_id = auth.uid())
);

-- commentaires : idem
DROP POLICY IF EXISTS "Commentaires utilisateur" ON commentaires;
CREATE POLICY "commentaires_owner" ON commentaires
FOR ALL USING (auth.uid() = user_id)
WITH CHECK (
  auth.uid() = user_id
  AND EXISTS (SELECT 1 FROM recettes WHERE id = recette_id AND user_id = auth.uid())
);

-- ──────────────────────────────────────────────────────────────
-- 2. Index secondaires (perf >100 rows)
-- ──────────────────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_recettes_user_id        ON recettes(user_id);
CREATE INDEX IF NOT EXISTS idx_ingredients_recette     ON ingredients(recette_id);
CREATE INDEX IF NOT EXISTS idx_ingredients_user        ON ingredients(user_id);
CREATE INDEX IF NOT EXISTS idx_quiz_questions_recette  ON quiz_questions(recette_id);
CREATE INDEX IF NOT EXISTS idx_progression_user        ON progression(user_id, statut);
CREATE INDEX IF NOT EXISTS idx_progression_recette     ON progression(recette_id);
CREATE INDEX IF NOT EXISTS idx_commentaires_recette    ON commentaires(recette_id, user_id);

-- ──────────────────────────────────────────────────────────────
-- 3. Trigger updated_at sur recettes + progression
-- ──────────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS recettes_updated_at ON recettes;
CREATE TRIGGER recettes_updated_at
  BEFORE UPDATE ON recettes
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS progression_updated_at ON progression;
CREATE TRIGGER progression_updated_at
  BEFORE UPDATE ON progression
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ──────────────────────────────────────────────────────────────
-- 4. Constraints — quiz_score, chrono_seconds, bonne
-- ──────────────────────────────────────────────────────────────

ALTER TABLE progression
  DROP CONSTRAINT IF EXISTS progression_quiz_score_range,
  ADD CONSTRAINT progression_quiz_score_range CHECK (quiz_score BETWEEN 0 AND 100);

ALTER TABLE progression
  DROP CONSTRAINT IF EXISTS progression_chrono_positive,
  ADD CONSTRAINT progression_chrono_positive CHECK (chrono_seconds >= 0);

ALTER TABLE quiz_questions
  DROP CONSTRAINT IF EXISTS quiz_questions_bonne_in_range,
  ADD CONSTRAINT quiz_questions_bonne_in_range
    CHECK (bonne >= 0 AND bonne < COALESCE(array_length(reponses, 1), 0));

ALTER TABLE recettes
  DROP CONSTRAINT IF EXISTS recettes_competences_valid,
  ADD CONSTRAINT recettes_competences_valid
    CHECK (competences <@ ARRAY['cuissons','textures','pesees','assemblages','organisation','techniques']::text[]);

-- ──────────────────────────────────────────────────────────────
-- 5. seed_recettes_cap — garde idempotente
-- ──────────────────────────────────────────────────────────────

-- On wrap la fonction existante pour ne PAS la dupliquer ici (longue).
-- À la place, on ajoute une fonction wrapper qui check l'idempotence.
CREATE OR REPLACE FUNCTION seed_recettes_cap_safe(p_user_id UUID)
RETURNS void AS $$
BEGIN
  IF (SELECT COUNT(*) FROM recettes WHERE user_id = p_user_id) > 0 THEN
    RETURN;
  END IF;
  PERFORM seed_recettes_cap(p_user_id);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- ──────────────────────────────────────────────────────────────
-- 6. RPC pour stats côté DB (perf future)
-- ──────────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION get_user_stats(p_user_id UUID)
RETURNS JSONB AS $$
DECLARE
  result JSONB;
BEGIN
  SELECT jsonb_build_object(
    'total', COUNT(*),
    'a_tester', COUNT(*) FILTER (WHERE COALESCE(p.statut, 'a-tester') = 'a-tester'),
    'testee', COUNT(*) FILTER (WHERE p.statut = 'testee'),
    'validee', COUNT(*) FILTER (WHERE p.statut = 'validee'),
    'maitrisee', COUNT(*) FILTER (WHERE p.statut = 'maitrisee')
  ) INTO result
  FROM recettes r
  LEFT JOIN progression p ON p.recette_id = r.id AND p.user_id = r.user_id
  WHERE r.user_id = p_user_id;
  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

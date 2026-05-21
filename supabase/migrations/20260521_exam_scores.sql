-- ============================================================
-- Migration : notes d'examen blanc (sync multi-device)
-- 2026-05-21
-- Remplace le stockage localStorage par une table Supabase
-- (1 ligne par user × thème). RLS calquée sur progression.
-- ============================================================

-- 1. Table
CREATE TABLE IF NOT EXISTS exam_scores (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  theme       TEXT NOT NULL,
  score       INT  NOT NULL CHECK (score >= 0),
  total       INT  NOT NULL CHECK (total > 0),
  pct         INT  NOT NULL CHECK (pct >= 0 AND pct <= 100),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, theme)
);

-- 2. RLS — un utilisateur ne voit/modifie que ses propres notes
ALTER TABLE exam_scores ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Notes examen utilisateur" ON exam_scores;
CREATE POLICY "Notes examen utilisateur" ON exam_scores
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- 3. Index
CREATE INDEX IF NOT EXISTS idx_exam_scores_user ON exam_scores(user_id);

-- 4. updated_at auto (réutilise la fonction set_updated_at si présente)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'set_updated_at') THEN
    DROP TRIGGER IF EXISTS trg_exam_scores_updated ON exam_scores;
    CREATE TRIGGER trg_exam_scores_updated
      BEFORE UPDATE ON exam_scores
      FOR EACH ROW EXECUTE FUNCTION set_updated_at();
  END IF;
END;
$$;

-- Vérification
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables WHERE table_name = 'exam_scores'
  ) THEN
    RAISE EXCEPTION 'Migration échouée : table exam_scores non créée';
  END IF;
  RAISE NOTICE '✅ Migration 20260521_exam_scores OK';
END;
$$;

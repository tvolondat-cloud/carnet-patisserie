-- ============================================================
-- Migration : ajout colonne plan + freemium gate
-- 2026-05-14
-- ============================================================

-- 1. Ajouter la colonne plan au profil
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS plan TEXT NOT NULL DEFAULT 'free'
    CHECK (plan IN ('free', 'pro', 'admin'));

-- 2. Index pour les requêtes filtrées par plan
CREATE INDEX IF NOT EXISTS idx_profiles_plan ON profiles(plan);

-- 3. Mettre les anciens utilisateurs sur free (déjà par défaut, sécurité)
UPDATE profiles SET plan = 'free' WHERE plan IS NULL;

-- 4. Politique : les utilisateurs peuvent lire leur propre plan
-- (déjà couvert par les RLS existants sur profiles)

-- Vérification
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'profiles' AND column_name = 'plan'
  ) THEN
    RAISE EXCEPTION 'Migration échouée : colonne plan non créée';
  END IF;
  RAISE NOTICE '✅ Migration 20260514_add_plan_freemium OK';
END;
$$;

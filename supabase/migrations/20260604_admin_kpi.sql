-- ============================================================
-- Migration : colonne `plan` + admin (helpers, RLS, RPC, KPI)
-- 2026-06-04
--
-- Idempotente. À exécuter une seule fois (ou ré-exécuter sans risque).
-- Cette migration regroupe :
--   1. Ajout de la colonne `plan` (cas où la migration 20260514 n'aurait
--      jamais tourné en prod)
--   2. Fonction `is_admin()` + RLS additionnelles
--   3. 5 RPC sécurisées appelées par la page /admin
--   4. Promotion de tvolondat@gmail.com en admin
-- ============================================================

-- 1. Colonne plan ------------------------------------------------
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS plan TEXT NOT NULL DEFAULT 'free'
    CHECK (plan IN ('free', 'pro', 'admin'));

CREATE INDEX IF NOT EXISTS idx_profiles_plan ON profiles(plan);
UPDATE profiles SET plan = 'free' WHERE plan IS NULL;

-- 2. Helper is_admin() (SECURITY DEFINER pour pouvoir lire profiles
--    sans déclencher la RLS du caller → évite la récursion). ------
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND plan = 'admin'
  );
$$;
GRANT EXECUTE ON FUNCTION is_admin() TO authenticated;

-- 3. RLS additionnelles : un admin peut voir/modifier tous les profils.
DROP POLICY IF EXISTS "Admins voient tous les profils" ON profiles;
CREATE POLICY "Admins voient tous les profils" ON profiles
  FOR SELECT USING (is_admin());

DROP POLICY IF EXISTS "Admins modifient tous les profils" ON profiles;
CREATE POLICY "Admins modifient tous les profils" ON profiles
  FOR UPDATE USING (is_admin()) WITH CHECK (is_admin());

-- 4. RPC sécurisées appelées depuis la page /admin --------------

-- 4.1 Liste des users (avec email + last_sign_in_at via auth.users)
CREATE OR REPLACE FUNCTION admin_list_users(
  search TEXT DEFAULT NULL,
  page_size INT DEFAULT 50
)
RETURNS TABLE(
  id UUID,
  email TEXT,
  plan TEXT,
  full_name TEXT,
  profil_type TEXT,
  exam_date DATE,
  created_at TIMESTAMPTZ,
  last_sign_in_at TIMESTAMPTZ
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Forbidden: admin only';
  END IF;

  RETURN QUERY
  SELECT p.id, u.email::TEXT, p.plan, p.full_name, p.profil_type,
         p.exam_date, u.created_at, u.last_sign_in_at
  FROM profiles p
  JOIN auth.users u ON u.id = p.id
  WHERE search IS NULL
     OR u.email ILIKE '%' || search || '%'
     OR COALESCE(p.full_name, '') ILIKE '%' || search || '%'
  ORDER BY u.created_at DESC
  LIMIT page_size;
END;
$$;
GRANT EXECUTE ON FUNCTION admin_list_users(TEXT, INT) TO authenticated;

-- 4.2 Modifier le plan d'un user
CREATE OR REPLACE FUNCTION admin_update_user_plan(
  target_id UUID,
  new_plan TEXT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Forbidden: admin only';
  END IF;
  IF new_plan NOT IN ('free', 'pro', 'admin') THEN
    RAISE EXCEPTION 'Invalid plan: %', new_plan;
  END IF;
  UPDATE profiles SET plan = new_plan WHERE id = target_id;
END;
$$;
GRANT EXECUTE ON FUNCTION admin_update_user_plan(UUID, TEXT) TO authenticated;

-- 4.3 KPI users (totaux + par plan + récents + actifs)
CREATE OR REPLACE FUNCTION admin_kpi_users()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE result JSONB;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Forbidden: admin only';
  END IF;

  SELECT jsonb_build_object(
    'total', (SELECT COUNT(*) FROM profiles),
    'by_plan', COALESCE(
      (SELECT jsonb_object_agg(plan, c)
       FROM (SELECT plan, COUNT(*)::INT AS c FROM profiles GROUP BY plan) s),
      '{}'::jsonb
    ),
    'new_7d', (SELECT COUNT(*) FROM auth.users WHERE created_at > now() - interval '7 days'),
    'new_30d', (SELECT COUNT(*) FROM auth.users WHERE created_at > now() - interval '30 days'),
    'active_30d', (SELECT COUNT(*) FROM auth.users WHERE last_sign_in_at > now() - interval '30 days')
  ) INTO result;

  RETURN result;
END;
$$;
GRANT EXECUTE ON FUNCTION admin_kpi_users() TO authenticated;

-- 4.4 KPI recettes : top N par nombre de tests / maîtrises
CREATE OR REPLACE FUNCTION admin_kpi_recipes(top_n INT DEFAULT 10)
RETURNS TABLE(
  recipe_name TEXT,
  tested_count BIGINT,
  mastered_count BIGINT,
  unique_users BIGINT
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Forbidden: admin only';
  END IF;

  RETURN QUERY
  SELECT r.nom::TEXT AS recipe_name,
         COUNT(p.id) FILTER (WHERE p.statut <> 'a-tester')::BIGINT AS tested_count,
         COUNT(p.id) FILTER (WHERE p.statut = 'maitrisee')::BIGINT AS mastered_count,
         COUNT(DISTINCT p.user_id) FILTER (WHERE p.statut <> 'a-tester')::BIGINT AS unique_users
  FROM recettes r
  LEFT JOIN progression p ON p.recette_id = r.id
  GROUP BY r.nom
  HAVING COUNT(p.id) FILTER (WHERE p.statut <> 'a-tester') > 0
  ORDER BY tested_count DESC NULLS LAST
  LIMIT top_n;
END;
$$;
GRANT EXECUTE ON FUNCTION admin_kpi_recipes(INT) TO authenticated;

-- 4.5 KPI features (usage agrégé, tolérant aux tables absentes)
CREATE OR REPLACE FUNCTION admin_kpi_features()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  result JSONB;
  exam_total BIGINT := 0;
  photos_total BIGINT := 0;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Forbidden: admin only';
  END IF;

  -- exam_scores et recipe_photos peuvent ne pas exister selon les
  -- migrations appliquées → on les rend optionnels.
  BEGIN
    SELECT COUNT(*) INTO exam_total FROM exam_scores;
  EXCEPTION WHEN undefined_table THEN
    exam_total := 0;
  END;
  BEGIN
    SELECT COUNT(*) INTO photos_total FROM recipe_photos;
  EXCEPTION WHEN undefined_table THEN
    photos_total := 0;
  END;

  SELECT jsonb_build_object(
    'progression_entries', (SELECT COUNT(*) FROM progression),
    'recipes_mastered_total', (SELECT COUNT(*) FROM progression WHERE statut = 'maitrisee'),
    'recipes_validee_total',  (SELECT COUNT(*) FROM progression WHERE statut = 'validee'),
    'recipes_testee_total',   (SELECT COUNT(*) FROM progression WHERE statut = 'testee'),
    'exam_scores_total', exam_total,
    'notes_count', (SELECT COUNT(*) FROM recettes WHERE notes IS NOT NULL AND notes <> ''),
    'comments_count', (SELECT COUNT(*) FROM commentaires),
    'photos_count', photos_total
  ) INTO result;

  RETURN result;
END;
$$;
GRANT EXECUTE ON FUNCTION admin_kpi_features() TO authenticated;

-- 5. Promotion de Timothy en admin -----------------------------
UPDATE profiles
SET plan = 'admin'
WHERE id = (SELECT id FROM auth.users WHERE email = 'tvolondat@gmail.com');

-- 6. Vérification -----------------------------------------------
DO $$
DECLARE
  cnt INT;
BEGIN
  SELECT COUNT(*) INTO cnt FROM profiles p
  JOIN auth.users u ON u.id = p.id
  WHERE u.email = 'tvolondat@gmail.com' AND p.plan = 'admin';
  IF cnt = 0 THEN
    RAISE NOTICE '⚠️ Pas de profil admin trouvé pour tvolondat@gmail.com (vérifier que tu t''es déjà connecté au moins une fois pour créer le profil).';
  ELSE
    RAISE NOTICE '✅ tvolondat@gmail.com est maintenant admin.';
  END IF;
  RAISE NOTICE '✅ Migration 20260604_admin_kpi OK';
END;
$$;

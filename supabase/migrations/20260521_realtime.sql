-- ============================================================
-- Migration : activer Supabase Realtime sur les tables utilisateur
-- 2026-05-21
-- Synchronisation live multi-device (recettes, ingredients,
-- progression, exam_scores). RLS déjà en place → un client ne reçoit
-- que ses propres changements.
-- À exécuter APRÈS 20260521_exam_scores.sql.
-- ============================================================

-- 1. Ajouter les tables à la publication realtime (idempotent)
DO $$
DECLARE t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY['recettes', 'ingredients', 'progression', 'exam_scores'] LOOP
    IF EXISTS (SELECT 1 FROM information_schema.tables
               WHERE table_schema = 'public' AND table_name = t)
       AND NOT EXISTS (
         SELECT 1 FROM pg_publication_tables
         WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = t
       ) THEN
      EXECUTE format('ALTER PUBLICATION supabase_realtime ADD TABLE public.%I', t);
      RAISE NOTICE 'Realtime activé sur %', t;
    END IF;
  END LOOP;
END;
$$;

-- 2. REPLICA IDENTITY FULL : permet de filtrer aussi les événements
--    UPDATE/DELETE par user_id (sinon seul l'INSERT serait filtrable).
--    Tables petites → coût négligeable.
ALTER TABLE recettes     REPLICA IDENTITY FULL;
ALTER TABLE ingredients  REPLICA IDENTITY FULL;
ALTER TABLE progression  REPLICA IDENTITY FULL;
ALTER TABLE exam_scores  REPLICA IDENTITY FULL;

DO $$
BEGIN
  RAISE NOTICE '✅ Migration 20260521_realtime OK';
END;
$$;

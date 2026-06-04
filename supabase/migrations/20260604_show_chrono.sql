-- ============================================================
-- Migration : préférence UI `show_chrono` sur le profil
-- 2026-06-04
-- Idempotente.
-- ============================================================

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS show_chrono BOOLEAN NOT NULL DEFAULT true;

DO $$
BEGIN
  RAISE NOTICE '✅ Migration 20260604_show_chrono OK';
END;
$$;

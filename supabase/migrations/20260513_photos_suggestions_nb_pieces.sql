-- ============================================================
-- Migration : photos, suggestions, nb_pieces_base
-- Date : 2026-05-13
-- ============================================================

-- ── 1. Champ nb_pieces_base sur recettes ─────────────────────
-- Nombre de pièces produites pour 1 recette de base.
-- Permet de calculer le nombre de produits fabriqués selon le
-- multiplicateur appliqué côté client.
ALTER TABLE recettes
  ADD COLUMN IF NOT EXISTS nb_pieces_base INT DEFAULT NULL;

-- ── 2. Table recipe_photos ────────────────────────────────────
-- Stocke les chemins des photos uploadées dans Supabase Storage
-- (bucket : recipe-photos, chemins : {user_id}/{recette_id}/{timestamp})
CREATE TABLE IF NOT EXISTS recipe_photos (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  recette_id   UUID NOT NULL REFERENCES recettes(id) ON DELETE CASCADE,
  user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  storage_path TEXT NOT NULL,           -- ex: "uuid-user/uuid-recette/1747123456789.jpg"
  created_at   TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE recipe_photos ENABLE ROW LEVEL SECURITY;

CREATE POLICY IF NOT EXISTS "photos_insert_own" ON recipe_photos
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "photos_select_own" ON recipe_photos
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "photos_delete_own" ON recipe_photos
  FOR DELETE TO authenticated
  USING (auth.uid() = user_id);

-- Index pour accès rapide par recette
CREATE INDEX IF NOT EXISTS idx_recipe_photos_recette ON recipe_photos(recette_id);

-- ── 3. Table suggestions ──────────────────────────────────────
-- Améliorations proposées par les utilisateurs.
-- Pour recevoir un email à chaque suggestion, configurer un
-- Database Webhook dans Supabase :
--   Dashboard → Database → Webhooks → New webhook
--   Table: suggestions | Event: INSERT
--   URL: votre endpoint (ex: https://api.resend.com/emails via un worker CF)
CREATE TABLE IF NOT EXISTS suggestions (
  id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  contenu    TEXT NOT NULL CHECK (length(contenu) >= 10),
  type       TEXT NOT NULL DEFAULT 'amelioration'
              CHECK (type IN ('amelioration', 'bug', 'nouvelle-feature', 'autre')),
  statut     TEXT NOT NULL DEFAULT 'nouveau'
              CHECK (statut IN ('nouveau', 'en-cours', 'fait', 'refuse')),
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE suggestions ENABLE ROW LEVEL SECURITY;

CREATE POLICY IF NOT EXISTS "suggestions_insert_own" ON suggestions
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "suggestions_select_own" ON suggestions
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

-- ── 4. Storage bucket recipe-photos (instructions manuelles) ──
-- Créer dans Supabase Dashboard → Storage → New bucket :
--   Nom : recipe-photos
--   Public : OUI (pour partage facile)
--   File size limit : 5 MB
--   Allowed mime types : image/jpeg,image/png,image/webp
--
-- Policies Storage à ajouter :
--   INSERT: (storage.foldername(name))[1] = auth.uid()::text
--   SELECT: bucket_id = 'recipe-photos'   (public)
--   DELETE: (storage.foldername(name))[1] = auth.uid()::text

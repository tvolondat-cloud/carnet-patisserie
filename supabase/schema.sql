-- ============================================================
-- CARNET CAP — Schéma complet
-- ============================================================

-- Extension UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ── PROFILES ────────────────────────────────────────────────
CREATE TABLE profiles (
  id          UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  full_name   TEXT,
  avatar_url  TEXT,
  profil_type TEXT DEFAULT 'cap' CHECK (profil_type IN ('cap','particulier')),
  exam_date   DATE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Profil visible par le propriétaire" ON profiles FOR ALL USING (auth.uid() = id);

-- Trigger création profil auto
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, full_name, avatar_url)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'avatar_url', NEW.raw_user_meta_data->>'picture')
  );
  RETURN NEW;
EXCEPTION WHEN OTHERS THEN
  RAISE WARNING 'handle_new_user error: %', SQLERRM;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ── RECETTES ─────────────────────────────────────────────────
CREATE TABLE recettes (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id       UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  nom           TEXT NOT NULL,
  categorie     TEXT NOT NULL,
  competences   TEXT[] DEFAULT '{}',
  temps         INTEGER DEFAULT 30,
  difficulte    INTEGER DEFAULT 2 CHECK (difficulte BETWEEN 1 AND 5),
  ep            TEXT DEFAULT 'EP1' CHECK (ep IN ('EP1','EP2')),
  chrono_cible  INTEGER DEFAULT 30,
  notes         TEXT DEFAULT '',
  etapes        JSONB DEFAULT '[]',
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE recettes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Recettes utilisateur" ON recettes FOR ALL USING (auth.uid() = user_id);

-- ── INGREDIENTS ──────────────────────────────────────────────
CREATE TABLE ingredients (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  recette_id  UUID REFERENCES recettes ON DELETE CASCADE NOT NULL,
  user_id     UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  nom         TEXT NOT NULL,
  quantite    NUMERIC DEFAULT 0,
  unite       TEXT DEFAULT 'g',
  ordre       INTEGER DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE ingredients ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Ingrédients utilisateur" ON ingredients FOR ALL USING (auth.uid() = user_id);

-- ── QUIZ QUESTIONS ───────────────────────────────────────────
CREATE TABLE quiz_questions (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  recette_id  UUID REFERENCES recettes ON DELETE CASCADE NOT NULL,
  user_id     UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  question    TEXT NOT NULL,
  reponses    TEXT[] NOT NULL,
  bonne       INTEGER NOT NULL DEFAULT 0,
  ordre       INTEGER DEFAULT 0
);

ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Questions utilisateur" ON quiz_questions FOR ALL USING (auth.uid() = user_id);

-- ── PROGRESSION ──────────────────────────────────────────────
CREATE TABLE progression (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id         UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  recette_id      UUID REFERENCES recettes ON DELETE CASCADE NOT NULL,
  statut          TEXT DEFAULT 'a-tester' CHECK (statut IN ('a-tester','testee','validee','maitrisee')),
  tested          BOOLEAN DEFAULT FALSE,
  quiz_score      INTEGER DEFAULT 0,
  chrono_seconds  INTEGER DEFAULT 0,
  chrono_valide   BOOLEAN DEFAULT FALSE,
  updated_at      TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, recette_id)
);

ALTER TABLE progression ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Progression utilisateur" ON progression FOR ALL USING (auth.uid() = user_id);

-- ── COMMENTAIRES ─────────────────────────────────────────────
CREATE TABLE commentaires (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  recette_id  UUID REFERENCES recettes ON DELETE CASCADE NOT NULL,
  contenu     TEXT NOT NULL,
  type        TEXT DEFAULT 'note' CHECK (type IN ('note','erreur','astuce','variation')),
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE commentaires ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Commentaires utilisateur" ON commentaires FOR ALL USING (auth.uid() = user_id);

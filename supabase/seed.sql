-- ============================================================
-- CARNET CAP — Seed v3 (auto-généré)
-- 58 recettes CAP Pâtissier 2025-2026
-- Généré depuis src/lib/data/recipes.json — NE PAS ÉDITER À LA MAIN
-- Régénérer avec : npm run seed:generate
-- Appel : SELECT seed_recettes_cap_safe('user-uuid');
-- ============================================================

CREATE OR REPLACE FUNCTION seed_recettes_cap(p_user_id UUID)
RETURNS void AS $$
DECLARE r_id UUID;
BEGIN

-- Crème pâtissière
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Crème pâtissière', 'cremes',
        ARRAY['cuissons','textures'], 25, 2, 'EP1', 20, '', '[{"ordre":1,"description":"Faire bouillir le lait avec la gousse de vanille fendue et grattée."},{"ordre":2,"description":"Blanchir les jaunes avec le sucre, incorporer la fécule tamisée."},{"ordre":3,"description":"Verser le lait bouillant sur les jaunes en fouettant, reverser dans la casserole."},{"ordre":4,"description":"Cuire à feu moyen en remuant jusqu''à pasteurisation (85°C, 1 min)."},{"ordre":5,"description":"Incorporer le beurre hors du feu, filmer au contact, refroidir rapidement."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Lait entier', 1000, 'g', 1),
  (r_id, p_user_id, 'Sucre', 200, 'g', 2),
  (r_id, p_user_id, 'Jaunes d''œufs', 160, 'g', 3),
  (r_id, p_user_id, 'Fécule de maïs', 80, 'g', 4),
  (r_id, p_user_id, 'Beurre', 60, 'g', 5),
  (r_id, p_user_id, 'Vanille', 1, 'gousse', 6);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'À quelle température pasteuriser la crème pâtissière ?', ARRAY['85°C pendant 1 min','70°C pendant 30 sec','100°C jusqu''à ébullition'], 0, 1),
  (r_id, p_user_id, 'Pourquoi filmer au contact ?', ARRAY['Éviter la formation d''une peau','Conserver plus longtemps','Accélérer le refroidissement'], 0, 2),
  (r_id, p_user_id, 'Rôle du beurre ajouté hors du feu ?', ARRAY['Brillance et onctuosité','Stopper la cuisson','Épaissir la crème'], 0, 3);

-- Crème anglaise
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Crème anglaise', 'cremes',
        ARRAY['cuissons','textures'], 20, 2, 'EP1', 18, '', '[{"ordre":1,"description":"Faire infuser la vanille dans le lait chaud 15 min."},{"ordre":2,"description":"Blanchir les jaunes avec le sucre."},{"ordre":3,"description":"Verser le lait sur les jaunes, reverser en casserole."},{"ordre":4,"description":"Cuire à 82–84°C en remuant jusqu''à la nappe (test spatule)."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Lait entier', 500, 'g', 1),
  (r_id, p_user_id, 'Sucre', 100, 'g', 2),
  (r_id, p_user_id, 'Jaunes d''œufs', 120, 'g', 3),
  (r_id, p_user_id, 'Vanille', 1, 'gousse', 4);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'La crème anglaise est cuite à quelle température ?', ARRAY['82–84°C','70°C','90°C'], 0, 1),
  (r_id, p_user_id, 'Comment vérifier la nappe sur la spatule ?', ARRAY['Passer le doigt, le trait reste net','La crème coule librement','Elle doit bouillir'], 0, 2);

-- Crème chantilly
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Crème chantilly', 'cremes',
        ARRAY['textures','techniques'], 10, 1, 'EP1', 8, '', '[{"ordre":1,"description":"Refroidir le bol et les fouets au congélateur 15 min."},{"ordre":2,"description":"Verser la crème très froide, monter progressivement."},{"ordre":3,"description":"Incorporer le sucre glace et la vanille en fin de montage."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Crème liquide 35% MG', 500, 'g', 1),
  (r_id, p_user_id, 'Sucre glace', 50, 'g', 2),
  (r_id, p_user_id, 'Vanille liquide', 5, 'g', 3);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi refroidir le bol avant de monter la chantilly ?', ARRAY['La crème froide monte mieux','Pour éviter l''oxydation','Par tradition'], 0, 1);

-- Crème mousseline
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Crème mousseline', 'cremes',
        ARRAY['textures','assemblages'], 15, 3, 'EP1', 12, '', '[{"ordre":1,"description":"Tempérer la crème pâtissière (même T° que le beurre)."},{"ordre":2,"description":"Crémer le beurre pommade au fouet jusqu''à blanchiment."},{"ordre":3,"description":"Incorporer la crème pâtissière en 3 fois en foisonnant."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Crème pâtissière', 500, 'g', 1),
  (r_id, p_user_id, 'Beurre pommade', 250, 'g', 2);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi tempérer la crème pâtissière avant incorporation ?', ARRAY['Éviter que le beurre se fige ou tranche','Pour la conserver','Pour l''aérer'], 0, 1);

-- Crème diplomate
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Crème diplomate', 'cremes',
        ARRAY['textures','assemblages'], 20, 3, 'EP2', 18, '', '[{"ordre":1,"description":"Réhydrater la gélatine dans l''eau froide 10 min."},{"ordre":2,"description":"Faire fondre la gélatine dans une petite portion de crème pâtissière chaude."},{"ordre":3,"description":"Incorporer dans le reste de crème pâtissière à 30°C."},{"ordre":4,"description":"Détendre avec 1/3 de crème montée, incorporer le reste délicatement."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Crème pâtissière', 500, 'g', 1),
  (r_id, p_user_id, 'Gélatine (2 feuilles)', 4, 'g', 2),
  (r_id, p_user_id, 'Crème montée souple', 300, 'g', 3);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Quel est l''intérêt de la gélatine dans la diplomate ?', ARRAY['Tenue après foisonnage','Allonger la conservation','Goûter plus sucré'], 0, 1);

-- Crème au beurre
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Crème au beurre', 'cremes',
        ARRAY['cuissons','techniques'], 25, 4, 'EP2', 22, '', '[{"ordre":1,"description":"Cuire le sirop sucre + eau jusqu''à 121°C."},{"ordre":2,"description":"Monter les blancs en neige souple."},{"ordre":3,"description":"Verser le sirop en filet sur les blancs, fouetter jusqu''au refroidissement."},{"ordre":4,"description":"Crémer le beurre pommade. Incorporer la meringue italienne progressivement."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Beurre pommade', 500, 'g', 1),
  (r_id, p_user_id, 'Sucre', 200, 'g', 2),
  (r_id, p_user_id, 'Eau', 60, 'g', 3),
  (r_id, p_user_id, 'Blancs d''œufs', 100, 'g', 4);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'À quelle température cuire le sirop pour la crème au beurre ?', ARRAY['121°C','100°C','140°C'], 0, 1),
  (r_id, p_user_id, 'Pourquoi la meringue doit-elle être froide avant d''ajouter le beurre ?', ARRAY['Sinon le beurre fond et la crème tranche','Pour gagner du temps','Pour la rendre plus aérée'], 0, 2);

-- Crème d'amandes
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Crème d''amandes', 'cremes',
        ARRAY['pesees','techniques'], 12, 2, 'EP1', 10, '', '[{"ordre":1,"description":"Crémer le beurre pommade avec le sucre glace."},{"ordre":2,"description":"Ajouter la poudre d''amandes, mélanger."},{"ordre":3,"description":"Incorporer les œufs un par un, puis la maïzena et le rhum."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Beurre pommade', 125, 'g', 1),
  (r_id, p_user_id, 'Sucre glace', 125, 'g', 2),
  (r_id, p_user_id, 'Poudre d''amandes', 125, 'g', 3),
  (r_id, p_user_id, 'Œufs entiers', 2, 'u', 4),
  (r_id, p_user_id, 'Maïzena', 15, 'g', 5),
  (r_id, p_user_id, 'Rhum ambré', 10, 'g', 6);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi ne pas trop foisonner la crème d''amandes ?', ARRAY['Elle gonflerait trop à la cuisson','Elle perdrait son goût','Elle changerait de couleur'], 0, 1);

-- Frangipane
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Frangipane', 'cremes',
        ARRAY['assemblages','pesees'], 8, 2, 'EP1', 6, '', '[{"ordre":1,"description":"Tempérer la crème pâtissière (sortir 30 min avant)."},{"ordre":2,"description":"Détendre la crème pâtissière au fouet."},{"ordre":3,"description":"Incorporer la crème d''amandes délicatement à la maryse."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Crème d''amandes', 300, 'g', 1),
  (r_id, p_user_id, 'Crème pâtissière', 150, 'g', 2);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Ratio classique crème d''amandes / crème pâtissière ?', ARRAY['2/3 amandes — 1/3 pâtissière','1/2 — 1/2','1/3 — 2/3'], 0, 1);

-- Ganache chocolat noir
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Ganache chocolat noir', 'cremes',
        ARRAY['cuissons','textures'], 15, 2, 'EP2', 12, '', '[{"ordre":1,"description":"Hacher le chocolat finement."},{"ordre":2,"description":"Porter la crème à ébullition."},{"ordre":3,"description":"Verser sur le chocolat en 3 fois en émulsionnant au centre."},{"ordre":4,"description":"Incorporer le beurre à 40°C au mixeur plongeant."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Chocolat noir 65%', 400, 'g', 1),
  (r_id, p_user_id, 'Crème liquide 35% MG', 400, 'g', 2),
  (r_id, p_user_id, 'Beurre', 40, 'g', 3);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi verser la crème en 3 fois sur le chocolat ?', ARRAY['Pour réussir l''émulsion','Pour refroidir progressivement','Pour éviter les grumeaux de cacao'], 0, 1);

-- Crème chiboust
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Crème chiboust', 'cremes',
        ARRAY['cuissons','textures','techniques'], 30, 4, 'EP2', 25, '', '[{"ordre":1,"description":"Réhydrater la gélatine, l''incorporer dans la crème pâtissière chaude."},{"ordre":2,"description":"Cuire le sirop sucre + eau à 121°C."},{"ordre":3,"description":"Monter les blancs et verser le sirop en filet : meringue italienne."},{"ordre":4,"description":"Incorporer 1/3 de meringue dans la pâtissière puis le reste délicatement."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Crème pâtissière', 500, 'g', 1),
  (r_id, p_user_id, 'Gélatine (3 feuilles)', 6, 'g', 2),
  (r_id, p_user_id, 'Blancs d''œufs', 150, 'g', 3),
  (r_id, p_user_id, 'Sucre', 300, 'g', 4),
  (r_id, p_user_id, 'Eau', 90, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Qu''est-ce qui distingue la chiboust de la diplomate ?', ARRAY['Meringue italienne au lieu de crème montée','Plus de gélatine','Pas de sucre'], 0, 1);

-- Pâte sablée
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Pâte sablée', 'pates',
        ARRAY['pesees','techniques'], 20, 2, 'EP1', 15, '', '[{"ordre":1,"description":"Sabler la farine avec le beurre froid en dés."},{"ordre":2,"description":"Ajouter sucre glace, poudre d''amandes et sel, mélanger."},{"ordre":3,"description":"Incorporer les œufs, fraser rapidement sans corser."},{"ordre":4,"description":"Bouler, filmer, reposer 30 min au froid."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T55', 500, 'g', 1),
  (r_id, p_user_id, 'Beurre froid', 250, 'g', 2),
  (r_id, p_user_id, 'Sucre glace', 200, 'g', 3),
  (r_id, p_user_id, 'Poudre d''amandes', 60, 'g', 4),
  (r_id, p_user_id, 'Œufs entiers', 2, 'u', 5),
  (r_id, p_user_id, 'Sel', 4, 'g', 6);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi sabler avant d''ajouter les œufs ?', ARRAY['Enrober le gluten et éviter l''élasticité','Homogénéiser la couleur','Gagner du temps'], 0, 1);

-- Pâte sucrée
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Pâte sucrée', 'pates',
        ARRAY['pesees','techniques'], 20, 2, 'EP1', 18, '', '[{"ordre":1,"description":"Crémer le beurre pommade avec le sucre glace, la vanille et le sel."},{"ordre":2,"description":"Incorporer les œufs, puis la poudre d''amandes."},{"ordre":3,"description":"Ajouter la farine en une seule fois, fraser."},{"ordre":4,"description":"Bouler, filmer, reposer 1h au froid."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T55', 500, 'g', 1),
  (r_id, p_user_id, 'Beurre pommade', 250, 'g', 2),
  (r_id, p_user_id, 'Sucre glace', 200, 'g', 3),
  (r_id, p_user_id, 'Poudre d''amandes', 60, 'g', 4),
  (r_id, p_user_id, 'Œufs entiers', 2, 'u', 5),
  (r_id, p_user_id, 'Sel', 4, 'g', 6),
  (r_id, p_user_id, 'Vanille', 5, 'g', 7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Quelle technique distingue la pâte sucrée de la sablée ?', ARRAY['Crémage du beurre pommade','Cuisson plus longue','Plus de sucre'], 0, 1);

-- Pâte à foncer
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Pâte à foncer', 'pates',
        ARRAY['pesees','techniques'], 18, 2, 'EP1', 15, '', '[{"ordre":1,"description":"Sabler rapidement la farine et le beurre froid."},{"ordre":2,"description":"Mélanger eau froide, œufs, sucre et sel."},{"ordre":3,"description":"Incorporer le liquide au sablage, fraser rapidement sans corps."},{"ordre":4,"description":"Filmer et reposer 30 min au froid."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T55', 500, 'g', 1),
  (r_id, p_user_id, 'Beurre froid', 250, 'g', 2),
  (r_id, p_user_id, 'Eau froide', 100, 'g', 3),
  (r_id, p_user_id, 'Sucre', 10, 'g', 4),
  (r_id, p_user_id, 'Sel', 10, 'g', 5),
  (r_id, p_user_id, 'Œufs', 2, 'u', 6);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pour quel type de tarte utilise-t-on la pâte à foncer ?', ARRAY['Tartes Tatin et tartes salées','Tartes au chocolat','Tartes meringuées'], 0, 1);

-- Pâte brisée
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Pâte brisée', 'pates',
        ARRAY['pesees','techniques'], 15, 1, 'EP1', 12, '', '[{"ordre":1,"description":"Sabler la farine avec le beurre froid en dés."},{"ordre":2,"description":"Dissoudre le sel dans l''eau froide."},{"ordre":3,"description":"Incorporer l''eau salée, fraser sans corser."},{"ordre":4,"description":"Bouler, filmer, reposer 30 min au froid."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T55', 500, 'g', 1),
  (r_id, p_user_id, 'Beurre froid', 250, 'g', 2),
  (r_id, p_user_id, 'Eau froide', 100, 'g', 3),
  (r_id, p_user_id, 'Sel', 10, 'g', 4);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi l''eau doit-elle être froide ?', ARRAY['Pour ne pas faire fondre le beurre','Pour gagner du temps','Pour la conservation'], 0, 1);

-- Pâte feuilletée
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Pâte feuilletée', 'pates',
        ARRAY['cuissons','techniques','organisation'], 180, 5, 'EP1', 150, '', '[{"ordre":1,"description":"Réaliser la détrempe (farine + eau + sel + beurre fondu). Reposer 30 min."},{"ordre":2,"description":"Abaisser la détrempe, enfermer le beurre de tourage (14–16°C)."},{"ordre":3,"description":"Donner 6 tours simples (ou 4 tours doubles)."},{"ordre":4,"description":"Reposer 20 min entre chaque double tour au froid."},{"ordre":5,"description":"Abaisser à 3 mm, piquer, détailler."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T55', 500, 'g', 1),
  (r_id, p_user_id, 'Eau froide', 250, 'g', 2),
  (r_id, p_user_id, 'Sel', 12, 'g', 3),
  (r_id, p_user_id, 'Beurre fondu (détrempe)', 50, 'g', 4),
  (r_id, p_user_id, 'Beurre sec de tourage', 350, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'À quelle température doit être le beurre de tourage ?', ARRAY['14–16°C','Sortie du frigo','Température ambiante'], 0, 1),
  (r_id, p_user_id, 'Combien de tours simples pour une feuilletée classique ?', ARRAY['6 tours simples','3 tours simples','10 tours'], 0, 2);

-- Meringue française
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Meringue française', 'bases-cap',
        ARRAY['cuissons','techniques'], 130, 1, 'EP1', 15, '', '[{"ordre":1,"description":"Monter les blancs à vitesse moyenne."},{"ordre":2,"description":"Serrer progressivement avec le sucre semoule."},{"ordre":3,"description":"Incorporer le sucre glace tamisé à la maryse."},{"ordre":4,"description":"Pocher et cuire 2h à 90°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Blancs d''œufs', 100, 'g', 1),
  (r_id, p_user_id, 'Sucre semoule', 100, 'g', 2),
  (r_id, p_user_id, 'Sucre glace', 100, 'g', 3);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'À quelle température cuire la meringue française ?', ARRAY['90°C pendant 2h','180°C pendant 20 min','120°C pendant 1h'], 0, 1);

-- Meringue suisse
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Meringue suisse', 'bases-cap',
        ARRAY['cuissons','techniques'], 25, 2, 'EP1', 20, '', '[{"ordre":1,"description":"Mélanger blancs et sucre dans un cul-de-poule."},{"ordre":2,"description":"Chauffer au bain-marie jusqu''à 50–55°C en fouettant."},{"ordre":3,"description":"Retirer du feu, monter au batteur jusqu''au refroidissement complet."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Blancs d''œufs', 100, 'g', 1),
  (r_id, p_user_id, 'Sucre', 200, 'g', 2);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Température cible au bain-marie pour la meringue suisse ?', ARRAY['50–55°C','80°C','30°C'], 0, 1);

-- Meringue italienne
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Meringue italienne', 'bases-cap',
        ARRAY['cuissons','techniques'], 20, 3, 'EP1', 18, '', '[{"ordre":1,"description":"Cuire sucre + eau jusqu''à 121°C."},{"ordre":2,"description":"Démarrer les blancs en neige souple en parallèle."},{"ordre":3,"description":"Verser le sirop en filet sur les blancs en mouvement."},{"ordre":4,"description":"Fouetter jusqu''au refroidissement complet."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Blancs d''œufs', 100, 'g', 1),
  (r_id, p_user_id, 'Sucre', 200, 'g', 2),
  (r_id, p_user_id, 'Eau', 60, 'g', 3);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Température du sirop pour la meringue italienne ?', ARRAY['121°C','100°C','140°C'], 0, 1);

-- Biscuit Joconde
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Biscuit Joconde', 'bases-cap',
        ARRAY['cuissons','techniques','assemblages'], 25, 3, 'EP2', 20, '', '[{"ordre":1,"description":"Monter les blancs avec le sucre (meringue française légère)."},{"ordre":2,"description":"Blanchir œufs entiers + sucre glace + poudre d''amande 5 min au fouet."},{"ordre":3,"description":"Incorporer la farine, puis les blancs montés délicatement."},{"ordre":4,"description":"Ajouter le beurre fondu tiède en dernier."},{"ordre":5,"description":"Étaler sur silpat, cuire 10–12 min à 200°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Œufs entiers', 6, 'u', 1),
  (r_id, p_user_id, 'Poudre d''amandes', 150, 'g', 2),
  (r_id, p_user_id, 'Sucre glace', 150, 'g', 3),
  (r_id, p_user_id, 'Farine T55', 40, 'g', 4),
  (r_id, p_user_id, 'Blancs d''œufs', 150, 'g', 5),
  (r_id, p_user_id, 'Sucre', 15, 'g', 6),
  (r_id, p_user_id, 'Beurre fondu', 30, 'g', 7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Comment incorporer les blancs montés ?', ARRAY['En soulevant de bas en haut','Au fouet électrique','Vigoureusement'], 0, 1);

-- Génoise
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Génoise', 'biscuits',
        ARRAY['cuissons','techniques'], 35, 3, 'EP2', 30, '', '[{"ordre":1,"description":"Monter œufs + sucre au bain-marie jusqu''à 50°C."},{"ordre":2,"description":"Foisonner hors du feu jusqu''au ruban complet."},{"ordre":3,"description":"Incorporer la farine tamisée par mouvements enveloppants."},{"ordre":4,"description":"Ajouter le beurre fondu tiède en dernier."},{"ordre":5,"description":"Cuire 20–25 min à 175°C dans un cercle beurré-fariné."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Œufs entiers', 6, 'u', 1),
  (r_id, p_user_id, 'Sucre', 180, 'g', 2),
  (r_id, p_user_id, 'Farine T55', 180, 'g', 3),
  (r_id, p_user_id, 'Beurre fondu', 50, 'g', 4);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Test du ruban : qu''observe-t-on ?', ARRAY['L''appareil retombe en ruban lisse et continu','Une mousse compacte','Un appareil liquide'], 0, 1);

-- Biscuit cuillère
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Biscuit cuillère', 'biscuits',
        ARRAY['cuissons','techniques'], 25, 3, 'EP2', 22, '', '[{"ordre":1,"description":"Blanchir les jaunes avec le sucre."},{"ordre":2,"description":"Monter les blancs en meringue française avec leur sucre."},{"ordre":3,"description":"Incorporer 1/3 de blancs aux jaunes, puis la farine tamisée."},{"ordre":4,"description":"Incorporer le reste des blancs délicatement."},{"ordre":5,"description":"Pocher à la douille 10 mm. Saupoudrer 2× de sucre glace. Cuire 10–12 min à 180°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Jaunes d''œufs', 120, 'g', 1),
  (r_id, p_user_id, 'Sucre (jaunes)', 70, 'g', 2),
  (r_id, p_user_id, 'Blancs d''œufs', 160, 'g', 3),
  (r_id, p_user_id, 'Sucre (blancs)', 70, 'g', 4),
  (r_id, p_user_id, 'Farine T55', 130, 'g', 5),
  (r_id, p_user_id, 'Sucre glace (finition)', 30, 'g', 6);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi saupoudrer 2× de sucre glace avant cuisson ?', ARRAY['Pour créer la croûte ''perlée'' typique','Pour sucrer davantage','Pour éviter qu''ils accrochent'], 0, 1);

-- Biscuit dacquoise
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Biscuit dacquoise', 'biscuits',
        ARRAY['cuissons','techniques'], 30, 3, 'EP2', 25, '', '[{"ordre":1,"description":"Monter les blancs avec le sucre en meringue ferme."},{"ordre":2,"description":"Tamiser amandes + sucre glace + farine ensemble."},{"ordre":3,"description":"Incorporer délicatement le sec dans les blancs."},{"ordre":4,"description":"Pocher ou étaler en disques. Cuire 20–25 min à 170°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Blancs d''œufs', 300, 'g', 1),
  (r_id, p_user_id, 'Sucre', 60, 'g', 2),
  (r_id, p_user_id, 'Poudre d''amandes', 240, 'g', 3),
  (r_id, p_user_id, 'Sucre glace', 240, 'g', 4),
  (r_id, p_user_id, 'Farine T55', 30, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Quelle est la particularité de la dacquoise ?', ARRAY['Sans jaunes, base poudre d''amandes','Sans farine du tout','À base de chocolat'], 0, 1);

-- Biscuit roulé
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Biscuit roulé', 'biscuits',
        ARRAY['cuissons','techniques','assemblages'], 25, 2, 'EP1', 20, '', '[{"ordre":1,"description":"Blanchir œufs et sucre au ruban."},{"ordre":2,"description":"Incorporer la farine tamisée délicatement."},{"ordre":3,"description":"Étaler sur silpat 4–5 mm. Cuire 8–10 min à 200°C."},{"ordre":4,"description":"Démouler chaud sur un torchon humide. Rouler immédiatement."},{"ordre":5,"description":"Refroidir, dérouler, garnir, rouler à nouveau."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Œufs entiers', 4, 'u', 1),
  (r_id, p_user_id, 'Sucre', 120, 'g', 2),
  (r_id, p_user_id, 'Farine T55', 120, 'g', 3);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi rouler le biscuit chaud ?', ARRAY['Pour qu''il prenne la forme sans craquer','Pour le faire cuire davantage','Pour le refroidir vite'], 0, 1);

-- Financier
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Financier', 'fours-secs',
        ARRAY['cuissons','pesees'], 30, 1, 'EP1', 25, '', '[{"ordre":1,"description":"Réaliser le beurre noisette, filtrer et laisser tiédir."},{"ordre":2,"description":"Mélanger sucre glace, poudre d''amande et farine tamisée."},{"ordre":3,"description":"Incorporer les blancs non montés, puis le beurre noisette tiède."},{"ordre":4,"description":"Couler dans les moules beurrés, cuire 12–14 min à 180°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Beurre noisette', 125, 'g', 1),
  (r_id, p_user_id, 'Sucre glace', 200, 'g', 2),
  (r_id, p_user_id, 'Poudre d''amandes', 75, 'g', 3),
  (r_id, p_user_id, 'Farine T55', 50, 'g', 4),
  (r_id, p_user_id, 'Blancs d''œufs', 150, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi le beurre noisette ?', ARRAY['Goût de noisette et moelleux','Conservation prolongée','Cuisson plus rapide'], 0, 1);

-- Madeleine
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Madeleine', 'fours-secs',
        ARRAY['cuissons','pesees'], 90, 1, 'EP1', 20, '', '[{"ordre":1,"description":"Mélanger tous les ingrédients (sauf beurre)."},{"ordre":2,"description":"Incorporer le beurre fondu tiède en dernier."},{"ordre":3,"description":"Reposer 1h au frais (choc thermique = bosse)."},{"ordre":4,"description":"Couler dans les moules, cuire 12–14 min à 200°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T55', 200, 'g', 1),
  (r_id, p_user_id, 'Sucre', 200, 'g', 2),
  (r_id, p_user_id, 'Beurre fondu', 200, 'g', 3),
  (r_id, p_user_id, 'Œufs entiers', 4, 'u', 4),
  (r_id, p_user_id, 'Levure chimique', 8, 'g', 5),
  (r_id, p_user_id, 'Miel', 20, 'g', 6),
  (r_id, p_user_id, 'Zeste de citron', 1, 'citron', 7),
  (r_id, p_user_id, 'Lait', 30, 'g', 8);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi reposer la pâte au froid ?', ARRAY['Choc thermique → bosse caractéristique','Pour la conservation','Pour la lever'], 0, 1);

-- Langue de chat
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Langue de chat', 'fours-secs',
        ARRAY['cuissons','pesees'], 25, 2, 'EP1', 22, '', '[{"ordre":1,"description":"Crémer beurre + sucre glace."},{"ordre":2,"description":"Incorporer les blancs progressivement."},{"ordre":3,"description":"Ajouter la farine tamisée et la vanille."},{"ordre":4,"description":"Pocher à la douille 5 mm en bâtonnets de 6 cm. Cuire 8–10 min à 170°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Beurre pommade', 100, 'g', 1),
  (r_id, p_user_id, 'Sucre glace', 100, 'g', 2),
  (r_id, p_user_id, 'Blancs d''œufs', 100, 'g', 3),
  (r_id, p_user_id, 'Farine T55', 100, 'g', 4),
  (r_id, p_user_id, 'Vanille', 5, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'À quelle douille pocher les langues de chat ?', ARRAY['5 mm unie','12 mm unie','Cannelée'], 0, 1);

-- Tuile aux amandes
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Tuile aux amandes', 'fours-secs',
        ARRAY['cuissons','techniques'], 25, 2, 'EP1', 22, '', '[{"ordre":1,"description":"Mélanger sucre glace + farine. Ajouter les blancs."},{"ordre":2,"description":"Incorporer le beurre fondu tiède, puis les amandes effilées."},{"ordre":3,"description":"Déposer en petits tas sur silpat, étaler en cercles."},{"ordre":4,"description":"Cuire 8–10 min à 170°C. Former sur rouleau chaud immédiatement."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Amandes effilées', 150, 'g', 1),
  (r_id, p_user_id, 'Sucre glace', 150, 'g', 2),
  (r_id, p_user_id, 'Blancs d''œufs', 60, 'g', 3),
  (r_id, p_user_id, 'Farine T55', 30, 'g', 4),
  (r_id, p_user_id, 'Beurre fondu', 30, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi former les tuiles à la sortie du four ?', ARRAY['Elles deviennent cassantes en refroidissant','Pour gagner du temps','Pour les saupoudrer'], 0, 1);

-- Rocher coco
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Rocher coco', 'fours-secs',
        ARRAY['cuissons','pesees'], 25, 1, 'EP1', 22, '', '[{"ordre":1,"description":"Mélanger tous les ingrédients."},{"ordre":2,"description":"Chauffer au bain-marie à 50°C en remuant."},{"ordre":3,"description":"Former des rochers à la cuillère ou à la poche."},{"ordre":4,"description":"Cuire 15 min à 160°C jusqu''à coloration dorée."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Noix de coco râpée', 200, 'g', 1),
  (r_id, p_user_id, 'Sucre', 150, 'g', 2),
  (r_id, p_user_id, 'Blancs d''œufs', 80, 'g', 3),
  (r_id, p_user_id, 'Vanille', 5, 'g', 4);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi chauffer le mélange à 50°C ?', ARRAY['Pour faire fondre le sucre et lier la coco','Pour pasteuriser','Pour gagner du temps'], 0, 1);

-- Cake citron
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Cake citron', 'gateaux-voyage',
        ARRAY['cuissons','pesees'], 60, 2, 'EP1', 50, '', '[{"ordre":1,"description":"Blanchir les œufs avec le sucre, incorporer zestes et jus de citron."},{"ordre":2,"description":"Ajouter farine et levure tamisées, puis le beurre fondu tiède."},{"ordre":3,"description":"Verser dans le moule beurré fariné aux 3/4."},{"ordre":4,"description":"Inciser au couteau beurré avant cuisson."},{"ordre":5,"description":"Cuire 45–50 min à 165°C. Test pointe couteau."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T55', 200, 'g', 1),
  (r_id, p_user_id, 'Sucre', 200, 'g', 2),
  (r_id, p_user_id, 'Beurre fondu', 150, 'g', 3),
  (r_id, p_user_id, 'Œufs entiers', 4, 'u', 4),
  (r_id, p_user_id, 'Levure chimique', 8, 'g', 5),
  (r_id, p_user_id, 'Zestes citron', 2, 'citrons', 6),
  (r_id, p_user_id, 'Jus de citron', 30, 'g', 7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi inciser le cake avant cuisson ?', ARRAY['Maîtriser la fissure','Décorer','Accélérer cuisson'], 0, 1);

-- Fondant au chocolat
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Fondant au chocolat', 'gateaux-voyage',
        ARRAY['cuissons','pesees','textures'], 32, 2, 'EP1', 25, '', '[{"ordre":1,"description":"Faire fondre chocolat + beurre au bain-marie. Laisser tiédir."},{"ordre":2,"description":"Blanchir œufs + sucre au ruban."},{"ordre":3,"description":"Incorporer chocolat-beurre, puis la farine tamisée."},{"ordre":4,"description":"Verser dans moules beurrés-farinés aux 3/4."},{"ordre":5,"description":"Cuire 10–12 min à 200°C. Cœur coulant. Démouler aussitôt."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Chocolat noir 70%', 200, 'g', 1),
  (r_id, p_user_id, 'Beurre', 120, 'g', 2),
  (r_id, p_user_id, 'Œufs entiers', 4, 'u', 3),
  (r_id, p_user_id, 'Sucre', 100, 'g', 4),
  (r_id, p_user_id, 'Farine T55', 40, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Comment savoir si le fondant est cuit à cœur coulant ?', ARRAY['Bords fermes, centre tremblotant','Cure-dent ressort propre','Surface complètement sèche'], 0, 1);

-- Cake marbré
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Cake marbré', 'gateaux-voyage',
        ARRAY['cuissons','pesees','techniques'], 65, 2, 'EP1', 55, '', '[{"ordre":1,"description":"Crémer beurre pommade et sucre."},{"ordre":2,"description":"Incorporer les œufs un par un, puis farine + levure."},{"ordre":3,"description":"Diviser la pâte en 2. Mélanger cacao + lait dans une moitié."},{"ordre":4,"description":"Alterner les deux pâtes dans le moule, marbrer à la pointe d''un couteau."},{"ordre":5,"description":"Cuire 45–50 min à 165°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Beurre pommade', 200, 'g', 1),
  (r_id, p_user_id, 'Sucre', 200, 'g', 2),
  (r_id, p_user_id, 'Œufs entiers', 4, 'u', 3),
  (r_id, p_user_id, 'Farine T55', 220, 'g', 4),
  (r_id, p_user_id, 'Levure chimique', 8, 'g', 5),
  (r_id, p_user_id, 'Cacao en poudre', 20, 'g', 6),
  (r_id, p_user_id, 'Lait', 40, 'g', 7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Comment créer le marbrage ?', ARRAY['Alterner les pâtes et tracer à la pointe','Mélanger légèrement','Cuire en 2 fois'], 0, 1);

-- Pâte à choux
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Pâte à choux', 'choux',
        ARRAY['cuissons','techniques','pesees'], 35, 3, 'EP1', 30, '', '[{"ordre":1,"description":"Porter à ébullition eau, lait, beurre, sel et sucre."},{"ordre":2,"description":"Ajouter la farine d''un coup hors du feu, mélanger."},{"ordre":3,"description":"Dessécher la panade sur le feu jusqu''à décollement des parois."},{"ordre":4,"description":"Incorporer les œufs un par un hors du feu, consistance ruban."},{"ordre":5,"description":"Pocher, dorer, cuire 28–32 min à 180°C sans ouvrir le four."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Eau', 125, 'g', 1),
  (r_id, p_user_id, 'Lait entier', 125, 'g', 2),
  (r_id, p_user_id, 'Beurre', 100, 'g', 3),
  (r_id, p_user_id, 'Farine T55', 150, 'g', 4),
  (r_id, p_user_id, 'Œufs entiers', 5, 'u', 5),
  (r_id, p_user_id, 'Sel', 4, 'g', 6),
  (r_id, p_user_id, 'Sucre', 5, 'g', 7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Comment savoir que la panade est desséchée ?', ARRAY['Elle forme une boule qui se décolle','Elle fume','Elle brille'], 0, 1),
  (r_id, p_user_id, 'Pourquoi ne pas ouvrir le four ?', ARRAY['Les choux retomberaient','Risque de brûlure','Bloque la porte'], 0, 2);

-- Éclair au café
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Éclair au café', 'choux',
        ARRAY['cuissons','techniques','assemblages'], 90, 4, 'EP1', 75, '', '[{"ordre":1,"description":"Pocher des éclairs à la douille cannelée n°12, 12 cm de long."},{"ordre":2,"description":"Dorer, cuire 28 min à 180°C sans ouvrir le four."},{"ordre":3,"description":"Parfumer la crème pâtissière à l''extrait de café."},{"ordre":4,"description":"Garnir les éclairs par le dessous à la douille fine."},{"ordre":5,"description":"Tiédir le fondant teinté café à 37°C max. Glacer le dessus."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte à choux', 400, 'g', 1),
  (r_id, p_user_id, 'Crème pâtissière', 400, 'g', 2),
  (r_id, p_user_id, 'Extrait de café', 20, 'g', 3),
  (r_id, p_user_id, 'Fondant blanc', 200, 'g', 4);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Température max du fondant ?', ARRAY['40°C (sinon perte de brillance)','60°C','30°C'], 0, 1);

-- Paris-Brest
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Paris-Brest', 'choux',
        ARRAY['cuissons','techniques','assemblages'], 85, 3, 'EP1', 70, '', '[{"ordre":1,"description":"Pocher la pâte à choux en couronne 22 cm (double rangée)."},{"ordre":2,"description":"Parsemer d''amandes effilées. Cuire 28–30 min à 180°C."},{"ordre":3,"description":"Préparer la mousseline pralinée : crémer beurre + crème pâtissière tempérée + pralin."},{"ordre":4,"description":"Couper la couronne en deux. Pocher la mousseline à la douille étoile."},{"ordre":5,"description":"Replacer le couvercle. Saupoudrer de sucre glace."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte à choux', 400, 'g', 1),
  (r_id, p_user_id, 'Crème pâtissière', 300, 'g', 2),
  (r_id, p_user_id, 'Beurre pommade', 150, 'g', 3),
  (r_id, p_user_id, 'Pralin en poudre', 80, 'g', 4),
  (r_id, p_user_id, 'Amandes effilées', 50, 'g', 5),
  (r_id, p_user_id, 'Sucre glace (déco)', 20, 'g', 6);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Crème utilisée pour le Paris-Brest ?', ARRAY['Mousseline pralinée','Chantilly','Anglaise'], 0, 1);

-- Religieuse
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Religieuse', 'choux',
        ARRAY['assemblages','techniques','cuissons'], 100, 4, 'EP1', 85, '', '[{"ordre":1,"description":"Pocher 2 tailles de choux (gros + petit). Cuire 25–30 min à 180°C."},{"ordre":2,"description":"Garnir tous les choux de crème pâtissière café."},{"ordre":3,"description":"Glacer le sommet de chaque chou au fondant café à 37°C."},{"ordre":4,"description":"Coller le petit sur le gros. Décorer avec crème au beurre à la douille cannelée."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte à choux', 400, 'g', 1),
  (r_id, p_user_id, 'Crème pâtissière café', 400, 'g', 2),
  (r_id, p_user_id, 'Fondant blanc teinté café', 200, 'g', 3),
  (r_id, p_user_id, 'Crème au beurre (décor)', 100, 'g', 4);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Combien de tailles de choux pour une religieuse ?', ARRAY['2 (gros + petit)','3 tailles','1 seule'], 0, 1);

-- Glands
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Glands', 'choux',
        ARRAY['cuissons','techniques','assemblages'], 70, 3, 'EP1', 60, '', '[{"ordre":1,"description":"Pocher la pâte à choux en forme de glands allongés."},{"ordre":2,"description":"Cuire 22–25 min à 180°C. Refroidir."},{"ordre":3,"description":"Garnir de crème pâtissière chocolat par le dessous."},{"ordre":4,"description":"Glacer la base avec le fondant chocolat tiédi à 37°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte à choux', 400, 'g', 1),
  (r_id, p_user_id, 'Crème pâtissière chocolat', 300, 'g', 2),
  (r_id, p_user_id, 'Fondant chocolat', 150, 'g', 3);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Forme du gland ?', ARRAY['Allongée façon gland','Ronde','Couronne'], 0, 1);

-- Mille-feuille
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Mille-feuille', 'feuilletage',
        ARRAY['cuissons','assemblages','techniques'], 95, 4, 'EP1', 80, '', '[{"ordre":1,"description":"Abaisser le feuilletage à 3 mm. Piquer. Sucrer."},{"ordre":2,"description":"Cuire entre deux plaques 30–35 min à 180°C jusqu''à caramélisation."},{"ordre":3,"description":"Découper 3 rectangles égaux. Monter : feuilletage / crème / feuilletage / crème / feuilletage."},{"ordre":4,"description":"Glacer le dessus au fondant à 37°C. Tracer des lignes de chocolat."},{"ordre":5,"description":"Marbrer au couteau perpendiculairement. Réserver au frais."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte feuilletée', 500, 'g', 1),
  (r_id, p_user_id, 'Crème pâtissière vanille', 500, 'g', 2),
  (r_id, p_user_id, 'Fondant blanc', 250, 'g', 3),
  (r_id, p_user_id, 'Chocolat noir fondu', 50, 'g', 4);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi cuire entre 2 plaques ?', ARRAY['Garder le feuilletage plat et régulier','Cuire plus vite','Gonfler davantage'], 0, 1);

-- Chausson aux pommes
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Chausson aux pommes', 'feuilletage',
        ARRAY['cuissons','techniques'], 50, 3, 'EP1', 40, '', '[{"ordre":1,"description":"Abaisser le feuilletage à 3 mm. Détailler disques de 15 cm."},{"ordre":2,"description":"Garnir un côté de compote, replier en chausson."},{"ordre":3,"description":"Souder les bords, dorer, chiqueter."},{"ordre":4,"description":"Rayer le dessus en arc de cercle. Cuire 20–25 min à 190°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte feuilletée', 400, 'g', 1),
  (r_id, p_user_id, 'Compote de pommes', 300, 'g', 2),
  (r_id, p_user_id, 'Dorure (jaunes+lait)', 2, 'jaunes', 3);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi chiqueter les bords ?', ARRAY['Souder + permettre le développement','Décorer seulement','Sécher la pâte'], 0, 1);

-- Saint-honoré
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Saint-honoré', 'feuilletage',
        ARRAY['assemblages','techniques','cuissons'], 150, 5, 'EP2', 130, '', '[{"ordre":1,"description":"Détailler un disque de feuilletage. Pocher une couronne de pâte à choux sur le bord."},{"ordre":2,"description":"Pocher des petits choux à part. Cuire le tout 25–30 min à 180°C."},{"ordre":3,"description":"Préparer la crème chiboust."},{"ordre":4,"description":"Caraméliser les petits choux (caramel ambré). Les coller sur la couronne."},{"ordre":5,"description":"Garnir le centre de chiboust à la douille Saint-honoré."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte feuilletée', 200, 'g', 1),
  (r_id, p_user_id, 'Pâte à choux', 300, 'g', 2),
  (r_id, p_user_id, 'Crème chiboust', 500, 'g', 3),
  (r_id, p_user_id, 'Sucre (caramel)', 200, 'g', 4),
  (r_id, p_user_id, 'Profiteroles', 10, 'u', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Crème utilisée pour le Saint-honoré ?', ARRAY['Chiboust','Diplomate','Anglaise'], 0, 1);

-- Tarte au citron meringuée
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Tarte au citron meringuée', 'tartes',
        ARRAY['cuissons','techniques','assemblages'], 70, 3, 'EP1', 60, '', '[{"ordre":1,"description":"Foncer le cercle, piquer, cuire à blanc 20 min à 170°C."},{"ordre":2,"description":"Préparer le curd : chauffer jus, zestes, sucre, œufs jusqu''à épaississement."},{"ordre":3,"description":"Incorporer le beurre froid hors du feu, mixer."},{"ordre":4,"description":"Garnir le fond cuit. Réfrigérer 30 min."},{"ordre":5,"description":"Pocher une meringue italienne. Brûler au chalumeau."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte sucrée', 250, 'g', 1),
  (r_id, p_user_id, 'Jus de citron', 150, 'g', 2),
  (r_id, p_user_id, 'Zestes de citron', 2, 'citrons', 3),
  (r_id, p_user_id, 'Œufs entiers', 3, 'u', 4),
  (r_id, p_user_id, 'Sucre', 150, 'g', 5),
  (r_id, p_user_id, 'Beurre', 80, 'g', 6),
  (r_id, p_user_id, 'Blancs (meringue)', 100, 'g', 7),
  (r_id, p_user_id, 'Sucre (meringue)', 180, 'g', 8);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Quand ajouter le beurre dans le curd ?', ARRAY['Hors du feu, à chaud','Pendant la cuisson','Une fois froid'], 0, 1);

-- Tarte Tatin
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Tarte Tatin', 'tartes',
        ARRAY['cuissons','techniques'], 75, 3, 'EP1', 60, '', '[{"ordre":1,"description":"Réaliser un caramel à sec, ajouter beurre + graines de vanille."},{"ordre":2,"description":"Disposer les quartiers de pommes serrés dans le moule."},{"ordre":3,"description":"Confire à feu moyen 15 min."},{"ordre":4,"description":"Couvrir avec la pâte brisée, rentrer les bords. Piquer."},{"ordre":5,"description":"Cuire 25–30 min à 190°C. Démouler tiède."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte brisée', 250, 'g', 1),
  (r_id, p_user_id, 'Pommes Golden', 1200, 'g', 2),
  (r_id, p_user_id, 'Sucre semoule', 150, 'g', 3),
  (r_id, p_user_id, 'Beurre', 80, 'g', 4),
  (r_id, p_user_id, 'Vanille', 1, 'gousse', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi démouler tiède ?', ARRAY['Caramel encore fluide','Plus facile à couper','Sécurité'], 0, 1);

-- Tarte aux pommes
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Tarte aux pommes', 'tartes',
        ARRAY['cuissons','assemblages'], 60, 2, 'EP1', 50, '', '[{"ordre":1,"description":"Foncer le cercle, piquer, cuire à blanc 10 min à 180°C."},{"ordre":2,"description":"Garnir de compote."},{"ordre":3,"description":"Disposer les lamelles de pommes en rosace."},{"ordre":4,"description":"Saupoudrer de sucre, parsemer de beurre. Cuire 25 min à 180°C."},{"ordre":5,"description":"Napper de nappage blond chaud à la sortie."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte à foncer', 250, 'g', 1),
  (r_id, p_user_id, 'Compote de pommes', 200, 'g', 2),
  (r_id, p_user_id, 'Pommes Golden', 600, 'g', 3),
  (r_id, p_user_id, 'Sucre', 50, 'g', 4),
  (r_id, p_user_id, 'Beurre', 30, 'g', 5),
  (r_id, p_user_id, 'Nappage blond', 50, 'g', 6);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi cuire à blanc avant ?', ARRAY['Éviter l''humidité dans le fond','Colorer la pâte','Gagner du temps'], 0, 1);

-- Tarte bourdaloue
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Tarte bourdaloue', 'tartes',
        ARRAY['cuissons','assemblages'], 60, 3, 'EP1', 50, '', '[{"ordre":1,"description":"Foncer le cercle avec la pâte sucrée."},{"ordre":2,"description":"Garnir de crème d''amandes."},{"ordre":3,"description":"Déposer les demi-poires égouttées en rosace."},{"ordre":4,"description":"Parsemer d''amandes effilées. Cuire 35 min à 175°C."},{"ordre":5,"description":"Napper chaud."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte sucrée', 250, 'g', 1),
  (r_id, p_user_id, 'Crème d''amandes', 300, 'g', 2),
  (r_id, p_user_id, 'Poires au sirop', 5, 'demi-poires', 3),
  (r_id, p_user_id, 'Amandes effilées', 30, 'g', 4),
  (r_id, p_user_id, 'Nappage blond', 50, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Fruit caractéristique de la bourdaloue ?', ARRAY['Poire','Pomme','Abricot'], 0, 1);

-- Tarte aux fruits frais
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Tarte aux fruits frais', 'tartes',
        ARRAY['assemblages','techniques'], 50, 2, 'EP2', 40, '', '[{"ordre":1,"description":"Foncer le cercle. Cuire à blanc 25 min à 170°C. Refroidir."},{"ordre":2,"description":"Garnir le fond cuit de crème pâtissière."},{"ordre":3,"description":"Disposer les fruits frais joliment."},{"ordre":4,"description":"Napper de nappage neutre tiède."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte sucrée', 250, 'g', 1),
  (r_id, p_user_id, 'Crème pâtissière', 300, 'g', 2),
  (r_id, p_user_id, 'Fruits de saison', 400, 'g', 3),
  (r_id, p_user_id, 'Nappage neutre', 100, 'g', 4);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi un nappage neutre sur les fruits ?', ARRAY['Brillance et conservation','Sucrer','Coller les fruits'], 0, 1);

-- Opéra
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Opéra', 'entremets',
        ARRAY['assemblages','techniques','cuissons'], 120, 5, 'EP2', 100, '', '[{"ordre":1,"description":"Préparer biscuit Joconde, crème au beurre café, ganache."},{"ordre":2,"description":"Détailler 3 rectangles de biscuit. Chablonner le premier au chocolat."},{"ordre":3,"description":"Monter : biscuit chablonné / crème au beurre / biscuit imbibé / ganache / biscuit imbibé / crème au beurre."},{"ordre":4,"description":"Bloquer au froid 2h. Lisser le dessus."},{"ordre":5,"description":"Napper de glaçage chocolat. Inscrire ''Opéra'' au cornet. Détailler à la lyre."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Biscuit Joconde', 1, 'plaque', 1),
  (r_id, p_user_id, 'Crème au beurre café', 300, 'g', 2),
  (r_id, p_user_id, 'Ganache chocolat', 250, 'g', 3),
  (r_id, p_user_id, 'Sirop café', 150, 'g', 4),
  (r_id, p_user_id, 'Glaçage chocolat', 150, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Combien de couches dans un opéra ?', ARRAY['3 biscuits, 2 CAB, 1 ganache, 1 nappage','2 biscuits, 1 crème','4 biscuits'], 0, 1);

-- Charlotte aux fraises
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Charlotte aux fraises', 'entremets',
        ARRAY['assemblages','textures','techniques'], 50, 3, 'EP2', 40, '', '[{"ordre":1,"description":"Chemiser le cercle avec les biscuits cuillère imbibés (sucre vers l''extérieur)."},{"ordre":2,"description":"Monter la crème chantilly avec le sucre glace."},{"ordre":3,"description":"Fondre la gélatine ramollie dans le coulis chaud. Incorporer à la chantilly."},{"ordre":4,"description":"Alterner mousse et fraises. Terminer par une couche de biscuits imbibés."},{"ordre":5,"description":"Réfrigérer 4h min. Décorer fraises fraîches + miroir de coulis."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Biscuits cuillère', 24, 'u', 1),
  (r_id, p_user_id, 'Fraises fraîches', 500, 'g', 2),
  (r_id, p_user_id, 'Crème liquide 35%', 400, 'g', 3),
  (r_id, p_user_id, 'Sucre glace', 60, 'g', 4),
  (r_id, p_user_id, 'Gélatine', 8, 'g', 5),
  (r_id, p_user_id, 'Coulis de fraises', 100, 'g', 6),
  (r_id, p_user_id, 'Sirop d''imbibage', 100, 'g', 7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Côté du biscuit cuillère contre le cercle ?', ARRAY['Côté sucre vers l''extérieur','Côté sucre intérieur','Peu importe'], 0, 1);

-- Fraisier
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Fraisier', 'entremets',
        ARRAY['assemblages','techniques','cuissons'], 130, 4, 'EP2', 115, '', '[{"ordre":1,"description":"Détailler 2 disques de génoise au diamètre du cercle."},{"ordre":2,"description":"Premier disque imbibé. Chemiser le cercle de demi-fraises coupées."},{"ordre":3,"description":"Pocher la mousseline entre les fraises et sur le disque."},{"ordre":4,"description":"Disposer les fraises au centre, recouvrir de mousseline."},{"ordre":5,"description":"Couvrir du 2e disque imbibé. Étaler la pâte d''amandes rose. Décorer."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Génoise', 2, 'disques 20cm', 1),
  (r_id, p_user_id, 'Crème mousseline', 500, 'g', 2),
  (r_id, p_user_id, 'Fraises fraîches', 500, 'g', 3),
  (r_id, p_user_id, 'Sirop d''imbibage', 150, 'g', 4),
  (r_id, p_user_id, 'Pâte d''amandes rose', 100, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Comment placer les demi-fraises ?', ARRAY['Coupées contre le cercle, pointe vers le haut','À plat','Entières'], 0, 1);

-- Forêt-noire
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Forêt-noire', 'entremets',
        ARRAY['assemblages','cuissons'], 110, 4, 'EP2', 95, '', '[{"ordre":1,"description":"Réaliser 3 disques de génoise au cacao."},{"ordre":2,"description":"Imbiber chaque disque de sirop kirsch."},{"ordre":3,"description":"Monter : disque / chantilly + cerises / disque / chantilly + cerises / disque."},{"ordre":4,"description":"Masquer entièrement de chantilly à la palette."},{"ordre":5,"description":"Décorer copeaux de chocolat + cerises sur le dessus."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Génoise chocolat', 3, 'disques', 1),
  (r_id, p_user_id, 'Crème chantilly', 600, 'g', 2),
  (r_id, p_user_id, 'Cerises griottines', 300, 'g', 3),
  (r_id, p_user_id, 'Kirsch', 30, 'g', 4),
  (r_id, p_user_id, 'Copeaux chocolat', 50, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Alcool d''imbibage de la forêt-noire ?', ARRAY['Kirsch','Rhum','Cognac'], 0, 1);

-- Moka
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Moka', 'entremets',
        ARRAY['assemblages','techniques'], 100, 4, 'EP2', 85, '', '[{"ordre":1,"description":"Détailler 3 disques de génoise. Imbiber au sirop café."},{"ordre":2,"description":"Monter : disque / CAB café / disque / CAB café / disque."},{"ordre":3,"description":"Masquer le dessus et les côtés de crème au beurre café."},{"ordre":4,"description":"Appliquer les amandes grillées sur les côtés."},{"ordre":5,"description":"Décorer rosaces à la douille + grains de café chocolat."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Génoise', 3, 'disques', 1),
  (r_id, p_user_id, 'Crème au beurre café', 500, 'g', 2),
  (r_id, p_user_id, 'Sirop café', 150, 'g', 3),
  (r_id, p_user_id, 'Amandes effilées grillées', 80, 'g', 4),
  (r_id, p_user_id, 'Grains café chocolat', 12, 'u', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Décor traditionnel du moka ?', ARRAY['Rosaces + grains café chocolat','Fruits frais','Glaçage miroir'], 0, 1);

-- Entremets chocolat
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Entremets chocolat', 'entremets',
        ARRAY['assemblages','textures'], 140, 4, 'EP2', 120, '', '[{"ordre":1,"description":"Détailler 2 disques de génoise chocolat, imbiber."},{"ordre":2,"description":"Monter en cercle : disque / ganache / disque / ganache."},{"ordre":3,"description":"Lisser et bloquer au congélateur 4h minimum."},{"ordre":4,"description":"Démouler congelé. Glacer au miroir chocolat à 35°C."},{"ordre":5,"description":"Décorer copeaux + feuille d''or éventuelle."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Génoise chocolat', 2, 'disques', 1),
  (r_id, p_user_id, 'Ganache montée', 500, 'g', 2),
  (r_id, p_user_id, 'Sirop cacao', 100, 'g', 3),
  (r_id, p_user_id, 'Glaçage miroir chocolat', 300, 'g', 4);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi glacer un entremets congelé ?', ARRAY['Le miroir prend immédiatement','Pour le conserver','Pour le démouler'], 0, 1);

-- Entremets fruits rouges
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Entremets fruits rouges', 'entremets',
        ARRAY['assemblages','textures'], 130, 4, 'EP2', 110, '', '[{"ordre":1,"description":"Détailler 2 disques de dacquoise."},{"ordre":2,"description":"Couler le coulis gélifié sur l''un, congeler en insert."},{"ordre":3,"description":"Monter : dacquoise / mousse / insert congelé / mousse / dacquoise."},{"ordre":4,"description":"Bloquer au congélateur 4h. Démouler."},{"ordre":5,"description":"Glacer au nappage miroir rouge à 35°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Dacquoise', 2, 'disques', 1),
  (r_id, p_user_id, 'Mousse fruits rouges', 500, 'g', 2),
  (r_id, p_user_id, 'Coulis gélifié', 200, 'g', 3),
  (r_id, p_user_id, 'Nappage miroir', 200, 'g', 4);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Rôle de l''insert congelé ?', ARRAY['Cœur de saveur intense','Tenir l''entremets','Décorer'], 0, 1);

-- Pâte levée feuilletée
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Pâte levée feuilletée', 'viennoiseries',
        ARRAY['cuissons','techniques','assemblages'], 180, 5, 'EP1', 150, '', '[{"ordre":1,"description":"Pétrir la détrempe sans le beurre de tourage. Pointer 30 min."},{"ordre":2,"description":"Abaisser, enfermer le beurre de tourage (14–16°C)."},{"ordre":3,"description":"Donner 3 tours simples avec repos 20 min entre chaque."},{"ordre":4,"description":"Abaisser à 3 mm, détailler, façonner, apprêter 1h30 à 26–28°C."},{"ordre":5,"description":"Dorer, cuire 18–22 min à 170°C four ventilé."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T45', 500, 'g', 1),
  (r_id, p_user_id, 'Lait', 250, 'g', 2),
  (r_id, p_user_id, 'Levure fraîche', 20, 'g', 3),
  (r_id, p_user_id, 'Sucre', 50, 'g', 4),
  (r_id, p_user_id, 'Sel', 10, 'g', 5),
  (r_id, p_user_id, 'Beurre de détrempe', 50, 'g', 6),
  (r_id, p_user_id, 'Beurre de tourage', 250, 'g', 7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Combien de tours pour la PLF ?', ARRAY['3 tours simples','6 tours simples','1 tour double'], 0, 1);

-- Brioche
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Brioche', 'viennoiseries',
        ARRAY['cuissons','techniques'], 180, 3, 'EP1', 160, '', '[{"ordre":1,"description":"Pétrir tous les ingrédients sauf beurre jusqu''au décollement."},{"ordre":2,"description":"Incorporer le beurre pommade progressivement."},{"ordre":3,"description":"Pointer 1h à température ambiante."},{"ordre":4,"description":"Rabattre, façonner, apprêter 1h30 à 26–28°C."},{"ordre":5,"description":"Dorer, cuire 25–30 min à 180°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T45', 500, 'g', 1),
  (r_id, p_user_id, 'Sucre', 50, 'g', 2),
  (r_id, p_user_id, 'Sel', 10, 'g', 3),
  (r_id, p_user_id, 'Levure fraîche', 20, 'g', 4),
  (r_id, p_user_id, 'Œufs entiers', 5, 'u', 5),
  (r_id, p_user_id, 'Lait', 60, 'g', 6),
  (r_id, p_user_id, 'Beurre', 250, 'g', 7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Quand incorporer le beurre ?', ARRAY['Après décollement de la pâte','Dès le début','À la fin du pointage'], 0, 1);

-- Pain au lait
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Pain au lait', 'viennoiseries',
        ARRAY['cuissons','techniques'], 150, 2, 'EP1', 130, '', '[{"ordre":1,"description":"Pétrir tous les ingrédients sauf beurre."},{"ordre":2,"description":"Incorporer le beurre progressivement."},{"ordre":3,"description":"Pointer 1h, rabattre."},{"ordre":4,"description":"Façonner en navettes. Apprêter 1h30."},{"ordre":5,"description":"Dorer, scarifier, cuire 12–15 min à 180°C."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T45', 500, 'g', 1),
  (r_id, p_user_id, 'Sucre', 50, 'g', 2),
  (r_id, p_user_id, 'Sel', 10, 'g', 3),
  (r_id, p_user_id, 'Levure fraîche', 20, 'g', 4),
  (r_id, p_user_id, 'Lait', 270, 'g', 5),
  (r_id, p_user_id, 'Beurre', 75, 'g', 6),
  (r_id, p_user_id, 'Œuf entier', 1, 'u', 7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi scarifier le pain au lait ?', ARRAY['Maîtriser le développement et décorer','Aérer','Cuire plus vite'], 0, 1);

-- Croissants
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Croissants', 'viennoiseries',
        ARRAY['cuissons','techniques','assemblages'], 200, 5, 'EP1', 180, '', '[{"ordre":1,"description":"Abaisser la PLF à 5 mm."},{"ordre":2,"description":"Détailler des triangles base 9 cm, hauteur 22 cm."},{"ordre":3,"description":"Inciser la base, étirer légèrement, rouler en partant de la base."},{"ordre":4,"description":"Disposer pointe dessous. Apprêter 1h30 à 26–28°C."},{"ordre":5,"description":"Dorer, cuire 18–22 min à 170°C four ventilé."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte levée feuilletée', 600, 'g', 1),
  (r_id, p_user_id, 'Dorure (œuf entier)', 1, 'u', 2);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Forme des triangles à détailler ?', ARRAY['Base 9 cm, hauteur 22 cm','Carrés 10 cm','Disques 12 cm'], 0, 1);

-- Pain au chocolat
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Pain au chocolat', 'viennoiseries',
        ARRAY['cuissons','techniques','assemblages'], 200, 4, 'EP1', 180, '', '[{"ordre":1,"description":"Abaisser la PLF à 5 mm."},{"ordre":2,"description":"Détailler des rectangles 8×12 cm."},{"ordre":3,"description":"Placer 2 bâtons de chocolat, rouler en serrant."},{"ordre":4,"description":"Disposer soudure dessous. Apprêter 1h30 à 26–28°C."},{"ordre":5,"description":"Dorer, cuire 18–22 min à 170°C four ventilé."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte levée feuilletée', 600, 'g', 1),
  (r_id, p_user_id, 'Bâtons de chocolat', 24, 'u', 2),
  (r_id, p_user_id, 'Dorure (œuf entier)', 1, 'u', 3);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Combien de bâtons de chocolat ?', ARRAY['2 par pain','1 par pain','3 par pain'], 0, 1);

-- Glaçage fondant
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Glaçage fondant', 'glacages',
        ARRAY['techniques','textures'], 10, 2, 'EP1', 8, '', '[{"ordre":1,"description":"Détendre le fondant avec un peu de sirop."},{"ordre":2,"description":"Chauffer doucement au bain-marie jusqu''à 37°C MAX."},{"ordre":3,"description":"Incorporer l''arôme ou le colorant."},{"ordre":4,"description":"Utiliser immédiatement sur les pièces à glacer."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Fondant blanc', 500, 'g', 1),
  (r_id, p_user_id, 'Sirop 30°B', 50, 'g', 2),
  (r_id, p_user_id, 'Colorant ou arôme', 5, 'g', 3);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Température maximale du fondant ?', ARRAY['37°C max (40°C absolu)','60°C','25°C'], 0, 1);

-- Glaçage miroir chocolat
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes, etapes)
VALUES (uuid_generate_v4(), p_user_id, 'Glaçage miroir chocolat', 'glacages',
        ARRAY['cuissons','techniques','textures'], 30, 3, 'EP2', 25, '', '[{"ordre":1,"description":"Réhydrater la gélatine dans l''eau froide."},{"ordre":2,"description":"Porter eau + sucre + crème à ébullition."},{"ordre":3,"description":"Ajouter le cacao, cuire 2 min en remuant."},{"ordre":4,"description":"Refroidir à 60°C, incorporer la gélatine essorée. Mixer sans bulles."},{"ordre":5,"description":"Utiliser à 35°C sur entremets congelé."}]'::jsonb)
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Eau', 125, 'g', 1),
  (r_id, p_user_id, 'Sucre', 225, 'g', 2),
  (r_id, p_user_id, 'Crème entière', 225, 'g', 3),
  (r_id, p_user_id, 'Cacao en poudre', 75, 'g', 4),
  (r_id, p_user_id, 'Gélatine (5 feuilles)', 10, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Température d''utilisation du miroir ?', ARRAY['35°C sur entremets congelé','60°C sur entremets froid','20°C sur entremets ambiant'], 0, 1);

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Wrapper idempotent : ne fait rien si l'utilisateur a déjà des recettes
CREATE OR REPLACE FUNCTION seed_recettes_cap_safe(p_user_id UUID)
RETURNS void AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM recettes WHERE user_id = p_user_id LIMIT 1) THEN
    RETURN;
  END IF;
  PERFORM seed_recettes_cap(p_user_id);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

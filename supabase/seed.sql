-- ============================================================
-- CARNET CAP — Seed v2
-- 18 recettes complètes : bases CAP + 8 nouvelles
-- Appeler via : SELECT seed_recettes_cap('user-uuid');
-- ============================================================

CREATE OR REPLACE FUNCTION seed_recettes_cap(p_user_id UUID)
RETURNS void AS $$
DECLARE r_id UUID;
BEGIN

-- ──────────────────────────────────────────────────────────────
-- CRÈMES DE BASE
-- ──────────────────────────────────────────────────────────────

-- Crème pâtissière
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Crème pâtissière', 'cremes',
        ARRAY['cuissons','textures'], 25, 2, 'EP1', 20, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Lait entier',     500, 'g',      1),
  (r_id, p_user_id, 'Sucre',           100, 'g',      2),
  (r_id, p_user_id, 'Jaunes d''œufs', 80,  'g',      3),
  (r_id, p_user_id, 'Fécule de maïs', 40,  'g',      4),
  (r_id, p_user_id, 'Beurre',          30,  'g',      5),
  (r_id, p_user_id, 'Vanille',         1,   'gousse', 6);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'À quelle température pasteuriser la crème pâtissière ?',
   ARRAY['85°C pendant 1 min','70°C pendant 30 sec','100°C jusqu''à ébullition'], 0, 1),
  (r_id, p_user_id, 'Pourquoi tamiser la fécule avant incorporation ?',
   ARRAY['Éviter les grumeaux','Aérer la préparation','Accélérer la cuisson'], 0, 2),
  (r_id, p_user_id, 'Comment éviter la formation d''une peau en refroidissant ?',
   ARRAY['Filmer au contact','Couvrir avec un torchon','Refroidir à l''air libre'], 0, 3),
  (r_id, p_user_id, 'Rôle du beurre ajouté hors du feu ?',
   ARRAY['Brillance et onctuosité','Stopper la cuisson','Épaissir la crème'], 0, 4);

-- Crème anglaise
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Crème anglaise', 'cremes',
        ARRAY['cuissons','textures'], 20, 2, 'EP1', 18, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Lait entier',    500, 'g',      1),
  (r_id, p_user_id, 'Sucre',          100, 'g',      2),
  (r_id, p_user_id, 'Jaunes d''œufs',120, 'g',      3),
  (r_id, p_user_id, 'Vanille',        1,   'gousse', 4);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'La crème anglaise est cuite à quelle température ?',
   ARRAY['82–84°C','70°C','90°C'], 0, 1),
  (r_id, p_user_id, 'Comment vérifier la nappe sur la spatule ?',
   ARRAY['Passer le doigt, le trait reste net','La crème coule librement','Elle doit bouillir'], 0, 2);

-- Crème chantilly
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Crème chantilly', 'cremes',
        ARRAY['textures','techniques'], 10, 1, 'EP1', 8, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Crème liquide 35%', 500, 'g', 1),
  (r_id, p_user_id, 'Sucre glace',        50,  'g', 2),
  (r_id, p_user_id, 'Vanille liquide',    5,   'g', 3);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi refroidir le bol avant de monter la chantilly ?',
   ARRAY['La crème froide monte mieux','Pour éviter l''oxydation','Par tradition'], 0, 1);

-- ──────────────────────────────────────────────────────────────
-- PÂTES DE BASE
-- ──────────────────────────────────────────────────────────────

-- Pâte à choux
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Pâte à choux', 'choux',
        ARRAY['cuissons','techniques','pesees'], 35, 3, 'EP1', 30, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Eau',          250, 'g', 1),
  (r_id, p_user_id, 'Beurre',       100, 'g', 2),
  (r_id, p_user_id, 'Farine T55',   150, 'g', 3),
  (r_id, p_user_id, 'Œufs entiers', 250, 'g', 4),
  (r_id, p_user_id, 'Sel',          4,   'g', 5),
  (r_id, p_user_id, 'Sucre',        5,   'g', 6);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Comment savoir que la panade est bien desséchée ?',
   ARRAY['Elle se décolle des parois et forme une boule','Elle est brillante','Elle fume abondamment'], 0, 1),
  (r_id, p_user_id, 'Pourquoi ne pas ouvrir le four pendant les 15 premières minutes ?',
   ARRAY['Les choux retomberaient','Risque de brûlure','La porte reste bloquée'], 0, 2),
  (r_id, p_user_id, 'La pâte à choux est prête quand elle forme…',
   ARRAY['Un ruban souple','Une boule ferme','Une masse liquide'], 0, 3);

-- Pâte sablée
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Pâte sablée', 'pates',
        ARRAY['pesees','techniques'], 20, 2, 'EP1', 15, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T55',    250, 'g', 1),
  (r_id, p_user_id, 'Beurre',        125, 'g', 2),
  (r_id, p_user_id, 'Sucre glace',   100, 'g', 3),
  (r_id, p_user_id, 'Œuf entier',    50,  'g', 4),
  (r_id, p_user_id, 'Poudre amande', 30,  'g', 5),
  (r_id, p_user_id, 'Sel',           2,   'g', 6);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi sabler la farine avec le beurre avant l''œuf ?',
   ARRAY['Pour enrober le gluten et éviter l''élasticité','Pour homogénéiser la couleur','Pour accélérer la préparation'], 0, 1);

-- Pâte levée feuilletée
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Pâte levée feuilletée', 'viennoiseries',
        ARRAY['cuissons','techniques','assemblages'], 180, 5, 'EP1', 150, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T45',         500, 'g', 1),
  (r_id, p_user_id, 'Lait entier',         250, 'g', 2),
  (r_id, p_user_id, 'Levure fraîche',      20,  'g', 3),
  (r_id, p_user_id, 'Sucre',              50,  'g', 4),
  (r_id, p_user_id, 'Sel',                10,  'g', 5),
  (r_id, p_user_id, 'Beurre de détrempe', 50,  'g', 6),
  (r_id, p_user_id, 'Beurre de tourage',  250, 'g', 7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Combien de tours simples pour une PLF classique ?',
   ARRAY['3 tours simples','5 tours simples','1 tour double uniquement'], 0, 1),
  (r_id, p_user_id, 'À quelle température doit être le beurre de tourage ?',
   ARRAY['14–16°C (même consistance que la détrempe)','Sortie du frigo direct','Température ambiante'], 0, 2);

-- ──────────────────────────────────────────────────────────────
-- BISCUITS & ENTREMETS
-- ──────────────────────────────────────────────────────────────

-- Financier
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Financier', 'fours-secs',
        ARRAY['cuissons','pesees'], 30, 1, 'EP1', 25, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Beurre noisette', 125, 'g', 1),
  (r_id, p_user_id, 'Sucre glace',     200, 'g', 2),
  (r_id, p_user_id, 'Poudre amande',   75,  'g', 3),
  (r_id, p_user_id, 'Farine T55',      50,  'g', 4),
  (r_id, p_user_id, 'Blancs d''œufs', 150, 'g', 5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi le beurre noisette est-il indispensable aux financiers ?',
   ARRAY['Il apporte le goût de noisette et la texture moelleuse','Il remplace le beurre ordinaire','Il permet la conservation'], 0, 1);

-- Biscuit Joconde
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Biscuit Joconde', 'bases-cap',
        ARRAY['cuissons','techniques','assemblages'], 25, 3, 'EP2', 20, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Œufs entiers',   300, 'g', 1),
  (r_id, p_user_id, 'Poudre amande',  150, 'g', 2),
  (r_id, p_user_id, 'Sucre glace',    150, 'g', 3),
  (r_id, p_user_id, 'Farine T55',     40,  'g', 4),
  (r_id, p_user_id, 'Blancs d''œufs',150, 'g', 5),
  (r_id, p_user_id, 'Sucre',          15,  'g', 6),
  (r_id, p_user_id, 'Beurre fondu',   30,  'g', 7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Comment incorporer les blancs montés pour ne pas les casser ?',
   ARRAY['En soulevant délicatement de bas en haut','Au fouet électrique','En remuant vigoureusement'], 0, 1);

-- Cake citron
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Cake citron', 'gateaux-voyage',
        ARRAY['cuissons','pesees'], 60, 2, 'EP1', 50, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Farine T55',      200, 'g',      1),
  (r_id, p_user_id, 'Sucre',           200, 'g',      2),
  (r_id, p_user_id, 'Beurre fondu',    150, 'g',      3),
  (r_id, p_user_id, 'Œufs entiers',    200, 'g',      4),
  (r_id, p_user_id, 'Levure chimique', 8,   'g',      5),
  (r_id, p_user_id, 'Zestes citron',   2,   'citrons',6),
  (r_id, p_user_id, 'Jus de citron',   30,  'g',      7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi inciser le cake en surface avant cuisson ?',
   ARRAY['Pour maîtriser la fissure et avoir un beau développement','Pour accélérer la cuisson','Pour décorer'], 0, 1);

-- ──────────────────────────────────────────────────────────────
-- 8 NOUVELLES RECETTES
-- ──────────────────────────────────────────────────────────────

-- Opéra
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Opéra', 'entremets',
        ARRAY['assemblages','techniques','cuissons'], 120, 5, 'EP2', 100, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Biscuit Joconde',       1,   'plaque', 1),
  (r_id, p_user_id, 'Crème au beurre café',  300, 'g',      2),
  (r_id, p_user_id, 'Ganache chocolat noir', 250, 'g',      3),
  (r_id, p_user_id, 'Sirop café',            150, 'g',      4),
  (r_id, p_user_id, 'Nappage chocolat',      150, 'g',      5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Combien de couches compte un opéra traditionnel ?',
   ARRAY['3 biscuits, 2 crèmes au beurre, 1 ganache, 1 nappage','2 biscuits, 1 crème, 1 glaçage','4 biscuits, 3 crèmes'], 0, 1);

-- Tarte au citron meringuée
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Tarte au citron meringuée', 'tartes',
        ARRAY['cuissons','techniques','assemblages'], 70, 3, 'EP1', 60, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte sucrée',             250, 'g',      1),
  (r_id, p_user_id, 'Citrons (jus + zeste)',   3,   'pièces', 2),
  (r_id, p_user_id, 'Œufs entiers',            3,   'pièces', 3),
  (r_id, p_user_id, 'Sucre semoule',           150, 'g',      4),
  (r_id, p_user_id, 'Beurre',                  80,  'g',      5),
  (r_id, p_user_id, 'Blancs d''œufs meringue',3,   'pièces', 6),
  (r_id, p_user_id, 'Sucre glace meringue',    180, 'g',      7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Le curd citron est prêt quand il…',
   ARRAY['Nappe la spatule','Bout vigoureusement','Devient transparent'], 0, 1),
  (r_id, p_user_id, 'Pourquoi cuire la pâte à blanc avant de garnir ?',
   ARRAY['Pour éviter que le fond soit humide','Pour colorer la pâte','Pour la faire gonfler'], 0, 2);

-- Éclair au café
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Éclair au café', 'choux',
        ARRAY['cuissons','techniques','assemblages'], 90, 4, 'EP1', 75, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Eau',             125, 'ml', 1),
  (r_id, p_user_id, 'Lait entier',     125, 'ml', 2),
  (r_id, p_user_id, 'Beurre',          110, 'g',  3),
  (r_id, p_user_id, 'Farine T55',      140, 'g',  4),
  (r_id, p_user_id, 'Œufs entiers',    4,   'pièces', 5),
  (r_id, p_user_id, 'Lait (crème)',    500, 'ml', 6),
  (r_id, p_user_id, 'Jaunes d''œufs', 4,   'pièces', 7),
  (r_id, p_user_id, 'Sucre semoule',   100, 'g',  8),
  (r_id, p_user_id, 'Maïzena',         40,  'g',  9),
  (r_id, p_user_id, 'Extrait de café', 20,  'ml', 10),
  (r_id, p_user_id, 'Fondant blanc',   200, 'g',  11);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'À quelle température tiédir le fondant pour le glaçage ?',
   ARRAY['37°C','50°C','60°C'], 0, 1),
  (r_id, p_user_id, 'Pourquoi ne jamais dépasser 40°C avec le fondant ?',
   ARRAY['Il perd sa brillance et blanchit','Il devient trop liquide','Il colle aux doigts'], 0, 2);

-- Mille-feuille
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Mille-feuille', 'feuilletage',
        ARRAY['cuissons','assemblages','techniques'], 95, 4, 'EP1', 80, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte feuilletée',     500, 'g',      1),
  (r_id, p_user_id, 'Lait entier',         500, 'ml',     2),
  (r_id, p_user_id, 'Jaunes d''œufs',     4,   'pièces', 3),
  (r_id, p_user_id, 'Sucre semoule',       100, 'g',      4),
  (r_id, p_user_id, 'Maïzena',             40,  'g',      5),
  (r_id, p_user_id, 'Vanille (gousse)',    1,   'pièce',  6),
  (r_id, p_user_id, 'Fondant blanc',       250, 'g',      7),
  (r_id, p_user_id, 'Chocolat noir fondu', 50,  'g',      8);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi cuire la pâte feuilletée entre deux plaques ?',
   ARRAY['Pour qu''elle reste plate et régulière','Pour qu''elle gonfle davantage','Pour qu''elle cuise plus vite'], 0, 1),
  (r_id, p_user_id, 'Comment réaliser le marbrage du mille-feuille ?',
   ARRAY['Tracer des lignes chocolat puis passer le couteau perpendiculairement','Étaler le chocolat en spirale','Projeter le chocolat avec un pinceau'], 0, 2);

-- Charlotte aux fraises
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Charlotte aux fraises', 'entremets',
        ARRAY['assemblages','textures','techniques'], 50, 3, 'EP2', 40, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Biscuits cuillère', 24,  'pièces', 1),
  (r_id, p_user_id, 'Fraises fraîches',  500, 'g',      2),
  (r_id, p_user_id, 'Crème liquide 35%', 400, 'ml',     3),
  (r_id, p_user_id, 'Sucre glace',       60,  'g',      4),
  (r_id, p_user_id, 'Gélatine',          4,   'feuilles',5),
  (r_id, p_user_id, 'Coulis de fraises', 100, 'ml',     6),
  (r_id, p_user_id, 'Sirop d''imbibage', 100, 'ml',     7);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'De quel côté les biscuits cuillère doivent-ils être placés contre le cercle ?',
   ARRAY['Côté sucre vers l''extérieur','Côté sucre vers l''intérieur','Peu importe'], 0, 1),
  (r_id, p_user_id, 'Pourquoi incorporer la gélatine dans le coulis chaud ?',
   ARRAY['Pour la faire fondre complètement','Pour refroidir plus vite','Pour sucrer davantage'], 0, 2);

-- Paris-Brest
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Paris-Brest', 'choux',
        ARRAY['cuissons','techniques','assemblages'], 85, 3, 'EP1', 70, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Eau',              125, 'ml',     1),
  (r_id, p_user_id, 'Lait entier',      125, 'ml',     2),
  (r_id, p_user_id, 'Beurre',           110, 'g',      3),
  (r_id, p_user_id, 'Farine T55',       140, 'g',      4),
  (r_id, p_user_id, 'Œufs entiers',     4,   'pièces', 5),
  (r_id, p_user_id, 'Amandes effilées', 50,  'g',      6),
  (r_id, p_user_id, 'Pralin en poudre', 80,  'g',      7),
  (r_id, p_user_id, 'Crème pâtissière', 300, 'g',      8),
  (r_id, p_user_id, 'Beurre pommade',   150, 'g',      9),
  (r_id, p_user_id, 'Sucre glace déco', 20,  'g',      10);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Qu''est-ce que la crème mousseline ?',
   ARRAY['Crème pâtissière + beurre pommade foisonnés','Crème chantilly + pralin','Crème anglaise montée'], 0, 1),
  (r_id, p_user_id, 'Pourquoi couper la couronne à l''horizontale avant de garnir ?',
   ARRAY['Pour garnir proprement à la douille','Pour retirer l''humidité','Pour vérifier la cuisson'], 0, 2);

-- Tarte Tatin
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Tarte Tatin', 'tartes',
        ARRAY['cuissons','techniques'], 75, 3, 'EP1', 60, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Pâte brisée',      250,  'g',      1),
  (r_id, p_user_id, 'Pommes Golden',    1200, 'g',      2),
  (r_id, p_user_id, 'Sucre semoule',    150,  'g',      3),
  (r_id, p_user_id, 'Beurre',           80,   'g',      4),
  (r_id, p_user_id, 'Vanille (gousse)', 1,    'pièce',  5);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Pourquoi démouler la Tatin tiède et non froide ?',
   ARRAY['Pour que le caramel s''écoule bien et ne reste pas figé','Pour éviter les brûlures','Pour que la pâte soit croustillante'], 0, 1),
  (r_id, p_user_id, 'Comment réaliser un caramel à sec ?',
   ARRAY['Faire fondre le sucre seul sans eau jusqu''à coloration ambrée','Mélanger sucre et eau puis cuire','Ajouter la crème directement dans le sucre'], 0, 2);

-- Fondant au chocolat
INSERT INTO recettes (id, user_id, nom, categorie, competences, temps, difficulte, ep, chrono_cible, notes)
VALUES (uuid_generate_v4(), p_user_id, 'Fondant au chocolat', 'biscuits',
        ARRAY['cuissons','pesees','textures'], 32, 2, 'EP1', 20, '')
RETURNING id INTO r_id;
INSERT INTO ingredients (recette_id, user_id, nom, quantite, unite, ordre) VALUES
  (r_id, p_user_id, 'Chocolat noir 70%', 200, 'g',      1),
  (r_id, p_user_id, 'Beurre',            120, 'g',      2),
  (r_id, p_user_id, 'Œufs entiers',      4,   'pièces', 3),
  (r_id, p_user_id, 'Sucre semoule',     100, 'g',      4),
  (r_id, p_user_id, 'Farine T55',        40,  'g',      5),
  (r_id, p_user_id, 'Sel fin',           1,   'pincée', 6);
INSERT INTO quiz_questions (recette_id, user_id, question, reponses, bonne, ordre) VALUES
  (r_id, p_user_id, 'Comment savoir si le fondant est bien cuit ?',
   ARRAY['Le cure-dent ressort humide mais pas liquide, les bords sont fermes','Le dessus est totalement sec','Le cure-dent ressort propre'], 0, 1),
  (r_id, p_user_id, 'Pourquoi faire fondre au bain-marie plutôt qu''au micro-ondes ?',
   ARRAY['Pour une chaleur douce et homogène sans brûler le chocolat','Par tradition','Le résultat est identique'], 0, 2);

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

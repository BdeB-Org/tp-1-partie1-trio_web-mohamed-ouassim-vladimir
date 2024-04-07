-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom: OUECHTATI MOHAMED AMINE                    Votre DA: 6258350
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--
-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
DESC outils_emprunt,outils_outil,outils_usager;
-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2
SELECT prenom || ' ' || nom_famille AS "Nom complet" 
FROM outils_usager;
-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2
SELECT DISTINCT ville 
FROM OUTILS_USAGER 
ORDER BY ville;
-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2
SELECT *
FROM outils_outil
ORDER BY nom, code_outil;
-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2
SELECT num_emprunt
FROM outils_emprunt
WHERE date_retour IS NULL;
-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3
SELECT num_emprunt
FROM outils_emprunt
WHERE EXTRACT(YEAR FROM date_emprunt) < 2014;
-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3
SELECT nom, code_outil , caracteristiques
FROM outils_outil
WHERE UPPER(caracteristiques) LIKE '%J%';
-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2
SELECT nom, code_outil ,fabricant
FROM outils_outil
WHERE fabricant LIKE '%Stanley%';
-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2
SELECT nom, fabricant
FROM outils_outil
WHERE annee BETWEEN 2006 AND 2008;
-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3
SELECT code_outil, nom , caracteristiques
FROM outils_outil
WHERE caracteristiques NOT LIKE '%20 volts%';
-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2
SELECT COUNT(*)
FROM outils_outil
WHERE fabricant <> 'Makita';
-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5
SELECT u.nom_famille || ' ' || u.prenom AS nom_complet,
      e.num_emprunt,
      e.date_retour - e.date_emprunt AS durée_emprunt,
      x.prix
FROM outils_emprunt e
JOIN outils_usager u ON e.num_usager = u.num_usager
JOIN outils_outil x ON e.code_outil = x.code_outil
WHERE u.ville IN ('Vancouver', 'Regina')
AND e.date_retour IS NOT NULL
AND x.prix IS NOT NULL;
-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4
SELECT x.nom, x.code_outil
FROM outils_outil x
JOIN outils_emprunt e ON x.code_outil = e.code_outil
WHERE e.date_retour IS NULL;
-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3
SELECT u.nom_famille || ' ' || u.prenom AS nom_complet,
      u.courriel
FROM outils_usager u
WHERE u.num_usager NOT IN (SELECT e.num_usager FROM outils_emprunt e);
-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4
SELECT x.code_outil, .prix
FROM outils_outil x
LEFT OUTER JOIN outils_emprunt e ON x.code_outil = e.code_outil
WHERE e.code_outil IS NULL;
-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4
SELECT nom , COALESCE(prix, (SELECT AVG(PRIX)))AS prix
FROM outils_outil
WHERE FABRICANT = 'Makita' AND PRIX > (SELECT AVG(PRIX) FROM OUTILS_OUTIL);
-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4
SELECT x.nom_famille, x.prenom, x.adresse, x.nom, x.code_outil
FROM outils_emprunt e
JOIN outils_usager u ON e.num_usager = u.num_usager
JOIN outils_outil x ON e.code_outil = x.code_outil
WHERE e.date_emprunt > TO_DATE('2014-01-01', 'YYYY-MM-DD')
ORDER BY u.nom_famille;
-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4
SELECT x.nom, x.prix
FROM outils_outil x
JOIN outils_emprunt e ON x.code_outil = e.code_outil
GROUP BY x.nom, x.prix
HAVING COUNT(e.num_emprunt) > 1;
-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6
--  Une jointure
SELECT x.nom_famille, x.adresse, x.ville
FROM outils_usager x
JOIN outils_emprunt a ON x.num_usager = a.num_usager;
--  IN
SELECT nom_famille, adresse, ville
FROM outils_usager
WHERE num_usager IN (SELECT num_usager FROM outils_emprunt);
--  EXISTS
SELECT u.nom_famille, u.adresse, u.ville
FROM outils_usager u
WHERE EXISTS (SELECT 1 FROM outils_emprunt e WHERE u.num_usager = e.num_usager);
-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3
SELECT fabricant, AVG(PRIX) AS "la moyenne du prix"    
FROM outils_outil  
GROUP BY fabricant;
-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4
SELECT u.ville, SUM(x.prix) AS total_prix
FROM outils_emprunt e
JOIN outils_usager u ON e.num_usager = u.num_usager
JOIN outils_outil x ON e.code_outil = x.code_outil
WHERE x.prix IS NOT NULL
GROUP BY u.ville
ORDER BY total_prix DESC;
-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2
INSERT INTO outils_outil (code_outil, nom, fabricant, caracteristiques,annee, prix)
VALUES ('XG456', 'tournevis', 'Stanley', 'un tournevise qui tourne rapidement', 1990, 45.00);
-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2
INSERT INTO OUTILS_OUTIL (code_outil,nom,annee)    
VALUES ('FG221', 'marteau', 1991);
-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2
DELETE
FROM outils_outil   
WHERE code_outil IN('XG456','FG221');
-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2
UPDATE outils_usager  
SET nom_famille = UPPER(nom_famille);
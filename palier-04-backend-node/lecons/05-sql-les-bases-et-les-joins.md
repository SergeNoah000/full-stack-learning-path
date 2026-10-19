# Leçon 05 — SQL : les bases, les agrégats, et les `JOIN`

> 🎯 **À la fin de cette leçon** : tu écris du SQL à la main, `JOIN` compris — la compétence la plus transférable de tout le parcours, et celle qui te servira identiquement avec Django et Laravel.
> ⏱️ 6 h, la leçon la plus longue du palier · **Prérequis** : leçons 01–04.
>
> ⚠️ **Les `JOIN` sont le point dur.** Prévois d'y revenir plusieurs fois, et de pratiquer sur un site d'exercices jusqu'à l'aisance. Ce n'est pas une leçon qu'on survole.

---

## De quoi on parle

Une **base de données relationnelle** stocke les données dans des **tables** : des lignes (les enregistrements) et des colonnes (les champs), avec un type par colonne. PostgreSQL, MySQL et SQLite en sont les plus courantes.

**SQL** (*Structured Query Language*) est le langage pour les interroger. Il est **déclaratif** : tu décris le résultat que tu veux, pas la façon de l'obtenir. Le moteur choisit comment s'y prendre.

```sql
SELECT categorie, SUM(montant) AS total
FROM depenses
WHERE date >= '2026-10-01'
GROUP BY categorie
ORDER BY total DESC;
```

Trois notions à poser. Une **clé primaire** identifie une ligne de façon unique. Une **clé étrangère** référence la clé primaire d'une autre table, et c'est ce qui relie les tables entre elles. Un **`JOIN`** croise deux tables sur cette relation.

---

## À quoi ça sert, concrètement

**Parce que c'est la compétence la plus durable du parcours.** Tu l'apprends ici en Node, tu la réutiliseras **telle quelle** avec Django (palier 5) et Laravel (palier 6). SQL a cinquante ans, il n'a pas changé dans ses fondements, et il sera encore là dans vingt ans. C'est l'investissement le plus rentable que tu feras — et c'est pour cela que cette leçon est la plus longue du palier.

**Parce qu'un ORM ne te dispense pas de le connaître.** Tu utiliseras Prisma à la leçon 07, et il écrira le SQL pour toi. Mais quand une page mettra huit secondes à charger, il faudra lire le SQL généré, comprendre pourquoi il fait deux mille requêtes, et le corriger. Un développeur qui ne sait pas lire du SQL est à la merci de son ORM.

**Parce que c'est le même raisonnement que `map`/`filter`/`reduce`.** `SELECT` est un `map`, `WHERE` est un `filter`, `GROUP BY` avec `SUM` est un `reduce`. Tu connais déjà ces opérations depuis le palier 1 — ce qui change, c'est **où** elles s'exécutent : dans la base, près des données, au lieu de ton serveur après un transfert réseau.

**Et parce que la question « où filtrer ? » est une vraie décision d'architecture.** Transférer dix mille lignes pour en garder trois est absurde. Ce choix, tu le prends à chaque requête.

---

## Où ça intervient dans le développement

SQL se place à la dernière couche de ton architecture, celle qui détient la vérité :

```
   CLIENT
     ▼
   API (Express)
     ▼
   SERVICES — la logique métier
     ▼
   DÉPÔTS — les requêtes SQL           ← cette leçon
     ▼
   BASE DE DONNÉES — LA VÉRITÉ
```

C'est un déplacement important à comprendre : jusqu'ici, tes données vivaient dans un fichier JSON (palier 1), puis dans `localStorage` (palier 2), puis en mémoire. Elles vivent maintenant dans un système conçu pour les conserver, les contraindre, les chercher et les protéger contre les accès simultanés.

Trois points structurants.

**La base est la dernière ligne de défense.** Après la validation du client (confort) et celle du serveur (sécurité), les **contraintes** de la base garantissent l'intégrité : une colonne `NOT NULL` ne peut pas être vide, une clé étrangère ne peut pas pointer vers une ligne inexistante, une colonne `UNIQUE` ne peut pas avoir de doublon. C'est le troisième niveau de la leçon 04.

**Et c'est la base qui doit filtrer.** Voici le réflexe à installer, et il est contre-intuitif pour qui vient du frontend :

```ts
// ❌ On transfère tout, puis on jette 99 % en JavaScript
const toutes = await depot.listerToutes();                 // 50 000 lignes sur le réseau
const food = toutes.filter(d => d.categorie === "food");    // il en reste 300

// ✅ La base filtre, on transfère ce dont on a besoin
const food = await depot.lister({ categorie: "food" });     // 300 lignes
```

**Enfin, SQL est aussi un outil de diagnostic.** Au palier 8, devant une application lente, tu ouvriras un client SQL pour regarder les requêtes et leurs plans d'exécution. C'est là que `EXPLAIN` (leçon 06) devient précieux.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas installer PostgreSQL, créer des tables, insérer des données à la main, et passer beaucoup de temps dans un client SQL. C'est normal et c'est la bonne façon d'apprendre : **écris du SQL avant de toucher un ORM**.

Les `JOIN` vont te résister. Le conseil le plus utile : **dessine les deux tables sur papier** et trace la ligne qui les relie. Le `JOIN` devient évident quand on voit la relation.

Fais **pgexercises.com** ou **sqlbolt.com** en parallèle : rien ne remplace la répétition sur des exercices corrigés.

### En équipe, en entreprise

**Tu liras du SQL tous les jours, même avec un ORM.** Dans les journaux, dans les outils de surveillance, dans les revues de code, et dans les migrations.

**Les requêtes lentes sont un sujet récurrent.** Une requête de huit secondes en production est un incident, et le diagnostic passe par `EXPLAIN` et les index (leçon 06).

**On te demandera d'écrire du SQL brut** pour les cas que l'ORM fait mal : un rapport avec plusieurs agrégats, une requête analytique, une migration de données.

**Et tu verras des bases mal conçues.** Des colonnes `varchar` pour des dates, des données dupliquées dans cinq tables, aucune clé étrangère, des champs `statut1`, `statut2`, `statut3`. Savoir reconnaître ces défauts est le sujet de la leçon 06.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`/`OFFSET`, `INSERT`, `UPDATE`, `DELETE`, `INNER JOIN`, `LEFT JOIN`, `COUNT`, `SUM`, `AVG`, `GROUP BY`, `HAVING`.

Régulièrement : les sous-requêtes, les CTE (`WITH`), `DISTINCT`, `COALESCE`, `CASE`, les jointures sur trois tables, `RETURNING` (spécifique à PostgreSQL, très pratique), `ON CONFLICT` (l'insertion-ou-mise-à-jour).

Rare, et hors sujet pour l'instant : les fonctions de fenêtrage (`OVER`, `PARTITION BY` — puissantes pour les rapports, mais pas au niveau débutant), les vues matérialisées, les triggers, les procédures stockées, les types JSON de PostgreSQL, la recherche plein texte, les types géographiques, le partitionnement, `RECURSIVE`. Tu rencontreras les fonctions de fenêtrage le jour où tu feras un classement ou un cumul — pas avant.

---

## La mécanique

### Installer et se connecter

```bash
# Debian/Ubuntu
sudo apt install postgresql postgresql-contrib
sudo -u postgres createuser --interactive --pwprompt depenses
sudo -u postgres createdb -O depenses depenses_dev

psql -U depenses -d depenses_dev -h localhost
```

Dans `psql` : `\dt` liste les tables, `\d depenses` décrit une table, `\q` quitte. Installe aussi un client graphique (DBeaver, TablePlus, ou l'extension PostgreSQL de VS Code) : voir les données aide énormément au début.

### Créer des tables

```sql
CREATE TABLE categories (
  id    SERIAL PRIMARY KEY,
  nom   VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE depenses (
  id            SERIAL PRIMARY KEY,
  montant       INTEGER NOT NULL CHECK (montant > 0),     -- en centimes (palier 1, leçon 01)
  description   VARCHAR(200) NOT NULL,
  date          DATE NOT NULL,
  categorie_id  INTEGER NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
  cree_le       TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

Chaque contrainte de ce schéma est une **garantie**, et c'est le troisième niveau de défense de la leçon 04. `NOT NULL` interdit le vide. `CHECK (montant > 0)` interdit un montant négatif même si ta validation Zod échouait. `REFERENCES` interdit une catégorie inexistante. `UNIQUE` interdit un doublon.

Note `ON DELETE RESTRICT` : il refuse la suppression d'une catégorie encore utilisée. Les autres options sont `CASCADE` (supprime les dépenses liées — dangereux) et `SET NULL`. C'est une décision métier, pas technique.

Et `TIMESTAMPTZ` plutôt que `TIMESTAMP` : il conserve le fuseau horaire. Oublier ce détail produit des bugs de décalage très désagréables.

### Interroger

```sql
SELECT * FROM depenses;                          -- ⚠️ jamais en production (voir plus bas)
SELECT id, montant, date FROM depenses;          -- ✅ seulement ce dont on a besoin

SELECT * FROM depenses WHERE montant > 100000;
SELECT * FROM depenses WHERE date BETWEEN '2026-10-01' AND '2026-10-31';
SELECT * FROM depenses WHERE description ILIKE '%taxi%';     -- ILIKE : insensible à la casse
SELECT * FROM depenses WHERE categorie_id IN (1, 3);
SELECT * FROM depenses WHERE note IS NULL;                    -- ⚠️ pas "= NULL"

SELECT * FROM depenses ORDER BY date DESC, montant DESC LIMIT 20 OFFSET 40;
```

Deux pièges classiques. `= NULL` ne fonctionne jamais : `NULL` signifie « inconnu », et l'égalité avec l'inconnu est inconnue. Il faut `IS NULL`. Et `SELECT *` transfère toutes les colonnes, y compris celles que tu n'utilises pas — en production, on nomme les colonnes.

### Modifier

```sql
INSERT INTO depenses (montant, description, date, categorie_id)
VALUES (150000, 'Déjeuner client', '2026-10-19', 1)
RETURNING *;                                      -- ⭐ PostgreSQL rend la ligne créée

UPDATE depenses SET montant = 160000 WHERE id = 42;
DELETE FROM depenses WHERE id = 42;
```

`RETURNING *` est très pratique : il te donne l'objet créé avec son `id` généré, ce qui correspond exactement à ce que ton API doit renvoyer en `201` (leçon 03).

> ⚠️ **Un `UPDATE` ou un `DELETE` sans `WHERE` affecte toute la table.** C'est l'accident de production le plus classique. Prends l'habitude d'écrire le `WHERE` **en premier**, ou de tester avec un `SELECT` avant de remplacer par `UPDATE`.

### Les agrégats

```sql
SELECT COUNT(*) FROM depenses;
SELECT SUM(montant), AVG(montant), MIN(montant), MAX(montant) FROM depenses;

-- Le GROUP BY : un reduce, par groupe
SELECT categorie_id, COUNT(*) AS nombre, SUM(montant) AS total
FROM depenses
WHERE date >= '2026-10-01'            -- filtre les LIGNES, avant regroupement
GROUP BY categorie_id
HAVING SUM(montant) > 500000           -- filtre les GROUPES, après regroupement
ORDER BY total DESC;
```

La distinction `WHERE` / `HAVING` est une question d'entretien fréquente : `WHERE` s'applique aux lignes **avant** le regroupement, `HAVING` aux groupes **après**. On ne peut donc pas utiliser un agrégat dans un `WHERE`.

Et la règle du `GROUP BY` : toute colonne du `SELECT` doit être soit dans le `GROUP BY`, soit dans un agrégat. PostgreSQL refuse le reste (MySQL l'acceptait historiquement, avec des résultats arbitraires).

### ⭐ Les `JOIN`

C'est le point dur. Prends le temps.

Le problème : tes dépenses ont un `categorie_id`, mais tu veux afficher le **nom** de la catégorie. Les deux informations sont dans deux tables.

```sql
-- INNER JOIN : seulement les lignes qui ont une correspondance DES DEUX CÔTÉS
SELECT d.id, d.montant, d.description, c.nom AS categorie
FROM depenses d
INNER JOIN categories c ON c.id = d.categorie_id
ORDER BY d.date DESC;
```

Visualise-le ainsi :

```
   depenses                      categories
   ┌────┬─────────┬──────────┐   ┌────┬───────────┐
   │ id │ montant │ cat_id   │   │ id │ nom       │
   ├────┼─────────┼──────────┤   ├────┼───────────┤
   │  1 │   1500  │    1 ────┼──▶│  1 │ food      │
   │  2 │   3000  │    2 ────┼──▶│  2 │ transport │
   │  3 │    500  │    1 ────┼──▶│  1 │ food      │
   └────┴─────────┴──────────┘   └────┴───────────┘
                   la clé étrangère pointe vers la clé primaire
```

Le `ON` dit **sur quelle colonne** les deux tables se correspondent. C'est tout le `JOIN`.

```sql
-- LEFT JOIN : TOUTES les lignes de gauche, avec NULL à droite s'il n'y a pas de correspondance
SELECT c.nom, COUNT(d.id) AS nombre
FROM categories c
LEFT JOIN depenses d ON d.categorie_id = c.id
GROUP BY c.nom;
```

**La différence est fondamentale**, et c'est elle qu'on te demandera. Avec `INNER JOIN`, une catégorie sans aucune dépense **disparaît** du résultat. Avec `LEFT JOIN`, elle apparaît avec un compte de zéro. La question à se poser : *est-ce que je veux voir les éléments sans correspondance ?*

C'est aussi le moyen de trouver les « orphelins » :

```sql
-- Les catégories jamais utilisées
SELECT c.* FROM categories c
LEFT JOIN depenses d ON d.categorie_id = c.id
WHERE d.id IS NULL;                      -- ⭐ l'idiome du "sans correspondance"
```

Et sur trois tables, le principe ne change pas — on enchaîne :

```sql
SELECT u.nom AS utilisateur, c.nom AS categorie, SUM(d.montant) AS total
FROM depenses d
INNER JOIN categories   c ON c.id = d.categorie_id
INNER JOIN utilisateurs u ON u.id = d.utilisateur_id
WHERE d.date >= '2026-10-01'
GROUP BY u.nom, c.nom
ORDER BY total DESC;
```

### Les sous-requêtes et les CTE

```sql
-- Sous-requête
SELECT * FROM depenses
WHERE montant > (SELECT AVG(montant) FROM depenses);

-- CTE : plus lisible dès que ça se complique
WITH totaux_par_categorie AS (
  SELECT categorie_id, SUM(montant) AS total
  FROM depenses
  GROUP BY categorie_id
)
SELECT c.nom, t.total
FROM totaux_par_categorie t
INNER JOIN categories c ON c.id = t.categorie_id
WHERE t.total > 500000;
```

Les CTE (`WITH`) se lisent de haut en bas, comme un enchaînement d'étapes nommées. C'est le même principe que « couper une chaîne trop longue en étapes nommées » du palier 1, leçon 06.

### Depuis Node : **toujours** des requêtes préparées

```bash
npm install pg
```

```ts
import { Pool } from "pg";
const pool = new Pool({ connectionString: config.DATABASE_URL });

// ❌ JAMAIS : injection SQL (leçon 09)
const r = await pool.query(`SELECT * FROM depenses WHERE id = ${id}`);

// ✅ TOUJOURS : requête paramétrée
const r = await pool.query("SELECT * FROM depenses WHERE id = $1", [id]);
```

C'est la règle absolue, et elle vaut dans les trois langages du parcours. Les paramètres sont envoyés **séparément** de la requête : la base ne les interprète jamais comme du code. Tu exploiteras la faille volontairement à la leçon 09 pour comprendre pourquoi l'échappement manuel ne suffit pas.

---

## Les problèmes que tu vas rencontrer

**`column "x" does not exist`.** Faute de frappe, ou nom en majuscules : PostgreSQL met les identifiants en minuscules sauf s'ils sont entre guillemets. Évite les majuscules dans les noms de colonnes.

**Ma requête `WHERE note = NULL` ne renvoie rien.** `IS NULL`.

**Mon `JOIN` renvoie plus de lignes que prévu.** C'est normal avec une relation un-à-plusieurs : une catégorie avec dix dépenses produit dix lignes. Si tu veux un résultat par catégorie, il faut `GROUP BY`.

**Mon `JOIN` renvoie moins de lignes que prévu.** `INNER JOIN` élimine les lignes sans correspondance. `LEFT JOIN`.

**`column must appear in the GROUP BY clause`.** Une colonne du `SELECT` n'est ni regroupée ni agrégée.

**Mon `COUNT(*)` avec `LEFT JOIN` compte 1 au lieu de 0.** `COUNT(*)` compte les lignes, et il y a une ligne avec des `NULL`. Utilise `COUNT(d.id)`, qui ignore les `NULL`.

**J'ai fait un `UPDATE` sans `WHERE`.** Toutes les lignes sont modifiées. S'il n'y avait pas de transaction, c'est irréversible — d'où les sauvegardes du palier 8.

**Ma requête met huit secondes.** Il manque probablement un index (leçon 06), ou tu transfères trop de colonnes, ou tu fais un `N+1` (leçon 07).

**Mes dates sont décalées d'une heure.** `TIMESTAMP` sans fuseau, ou une conversion côté application. Utilise `TIMESTAMPTZ`.

**Mes montants sont faux de quelques centimes.** Tu as utilisé `FLOAT` pour de l'argent. Entiers en centimes, ou `NUMERIC`.

---

## Ce qu'on te demandera

SQL est, avec HTTP, **le sujet le plus systématiquement vérifié** sur un développeur backend — et il l'est aussi sur un fullstack.

Les questions quasi certaines : **« explique la différence entre `INNER JOIN` et `LEFT JOIN` »** (et on attend un exemple où `LEFT` est indispensable), « différence entre `WHERE` et `HAVING` », « écris une requête qui donne le chiffre d'affaires par client ». Cette dernière est l'exercice de test technique le plus courant du métier, et tu l'as déjà rencontrée en JavaScript au palier 1, leçon 06 — c'est la même opération, exprimée dans l'autre langage.

Suivent : « qu'est-ce qu'une clé étrangère ? », « comment trouves-tu les lignes sans correspondance ? », « pourquoi des requêtes préparées ? ».

En **test technique**, on te donne un schéma de trois tables et trois à cinq requêtes à écrire. Sans ORM. C'est l'épreuve A2 de ton évaluation de palier.

---

## Ce qui te démarquera

**Savoir écrire du SQL sans ORM.** C'est devenu rare chez les juniors formés aux frameworks, et c'est immédiatement remarqué.

**Dessiner la relation avant d'écrire le `JOIN`.** Dire « attends, je dessine les deux tables » est une méthode, pas une faiblesse — et elle produit des requêtes justes du premier coup.

**Connaître l'idiome `LEFT JOIN … WHERE x IS NULL`** pour trouver les orphelins. C'est un classique que peu de gens connaissent et qui résout beaucoup de questions réelles.

**Filtrer dans la base.** Savoir dire « on ne transfère pas cinquante mille lignes pour en garder trois » est un raisonnement d'architecture, et c'est le même que celui de la leçon 12 du palier 1.

**Utiliser les CTE pour la lisibilité.** Une requête de quarante lignes découpée en trois étapes nommées se relit ; la même en sous-requêtes imbriquées, non.

**Et les contraintes au niveau de la base.** `NOT NULL`, `CHECK`, `UNIQUE`, `REFERENCES` : beaucoup de développeurs s'en remettent entièrement à la validation applicative. Les trois niveaux valent mieux qu'un.

---

## 📚 À lire / pratiquer

🎮 **sqlbolt.com** — interactif, une heure, du `SELECT` aux `JOIN`. **À faire en premier.**

🎮 **pgexercises.com** — la référence pour pratiquer sérieusement : des exercices progressifs sur une vraie base, avec corrections. **Fais au moins les sections *Basic*, *Joins and subqueries* et *Aggregates*** — c'est ce qui crée l'aisance, et c'est demandé dans ton épreuve de sortie.

**postgresqltutorial.com** pour les explications écrites, et la **documentation PostgreSQL** (chapitre *The SQL Language*) comme référence.

**use-the-index-luke.com** : à garder pour la leçon 06, c'est la meilleure ressource sur les index.

---

## 🤖 Le mini-projet à demander à l'IA

SQL s'apprend par la répétition sur un schéma réaliste, et par la correction immédiate.

> « Je suis en formation de développeur, palier 4. Je travaille SQL, en particulier les `JOIN` et les agrégats. Donne-moi **le schéma de création** (`CREATE TABLE`) d'une base réaliste à quatre tables — utilisateurs, catégories, dépenses, commentaires — avec clés primaires, clés étrangères et contraintes, **plus un jeu de données d'une centaine de lignes** en `INSERT`. Ensuite, pose-moi **20 questions métier en français** (pas en SQL), de la plus simple à la plus complexe : du simple filtre jusqu'à un rapport croisant trois tables avec agrégats et `HAVING`. Inclus au moins trois questions qui **exigent** un `LEFT JOIN` (les éléments sans correspondance). Je t'envoie mes requêtes une par une ; tu me dis si le résultat est juste, et si une formulation plus simple existe. **Ne me donne jamais la requête.** »

Les trois questions à `LEFT JOIN` sont le cœur de l'exercice : c'est là que la compréhension se joue.

Puis l'exercice de transfert, qui relie cette leçon au palier 1 :

> « Donne-moi 8 traitements que j'ai écrits en JavaScript au palier 1 avec `filter`, `map` et `reduce` (totaux par catégorie, top 5, moyenne, dédoublonnage, groupement, comptage conditionnel). Pour chacun, demande-moi d'écrire **l'équivalent SQL**, puis de me dire **lequel des deux est préférable et pourquoi** — en tenant compte du volume de données et du coût du transfert réseau. »

---

## 🛠️ À faire

> Fais **sqlbolt.com** en entier avant de commencer, et garde **pgexercises** ouvert pendant toute la leçon.

1. **Installe PostgreSQL**, crée une base et un utilisateur, connecte-toi avec `psql`.
2. **Crée le schéma** : `utilisateurs`, `categories`, `depenses` avec clés primaires, clés étrangères, `NOT NULL`, `CHECK` sur le montant, `UNIQUE` sur le nom de catégorie. Insère une trentaine de lignes à la main.
3. **Les bases** : filtre par montant, par plage de dates, par recherche textuelle insensible à la casse, tri sur deux colonnes, pagination avec `LIMIT`/`OFFSET`.
4. **Le piège `NULL`** : écris `WHERE note = NULL`, constate le vide, corrige avec `IS NULL`.
5. **Agrégats** : nombre et total par catégorie, avec un `WHERE` sur le mois et un `HAVING` sur le total.
6. **⭐ `INNER JOIN`** : la liste des dépenses avec le **nom** de leur catégorie.
7. **⭐ `LEFT JOIN`** : le nombre de dépenses par catégorie, **y compris les catégories à zéro**. Compare avec la version `INNER JOIN` et note la différence de nombre de lignes.
8. **Les orphelins** : trouve les catégories jamais utilisées avec `LEFT JOIN … WHERE … IS NULL`.
9. **Trois tables** : le total par utilisateur et par catégorie pour le mois en cours.
10. **CTE** : réécris une requête imbriquée avec `WITH`, et compare la lisibilité.
11. **Depuis Node** : connecte `pg`, écris trois requêtes **paramétrées** dans ta couche de dépôts, et utilise `RETURNING *` à l'insertion.
12. **⚠️ Le `WHERE` oublié** : sur une table de test, fais un `UPDATE` sans `WHERE` et constate les dégâts. Écris dans ton journal la règle que tu en tires.
13. **Mesure le filtrage** : charge dix mille lignes en JavaScript puis filtre, contre un filtre en SQL. Chronomètre les deux, et note la quantité de données transférées.

<details>
<summary>Corrections et points de contrôle</summary>

**7.** L'écart est la clé de l'exercice. Avec `INNER JOIN`, tu obtiens seulement les catégories **utilisées** ; avec `LEFT JOIN`, toutes, les inutilisées à zéro. Et attention au comptage :
```sql
SELECT c.nom, COUNT(d.id) AS nombre        -- ✅ COUNT(d.id) ignore les NULL
FROM categories c
LEFT JOIN depenses d ON d.categorie_id = c.id
GROUP BY c.nom;
```
Avec `COUNT(*)`, une catégorie vide compterait **1** (la ligne jointe avec des `NULL`) au lieu de 0. C'est un piège réel et fréquent.

**9.**
```sql
SELECT u.nom AS utilisateur, c.nom AS categorie, SUM(d.montant) AS total
FROM depenses d
INNER JOIN utilisateurs u ON u.id = d.utilisateur_id
INNER JOIN categories   c ON c.id = d.categorie_id
WHERE d.date >= date_trunc('month', CURRENT_DATE)
GROUP BY u.nom, c.nom
ORDER BY total DESC;
```
Les deux colonnes du `SELECT` qui ne sont pas agrégées doivent figurer dans le `GROUP BY` : c'est la règle, et PostgreSQL te le rappellera.

**12.** La règle à écrire : **on écrit toujours le `WHERE` avant le `SET`**, ou on teste d'abord avec un `SELECT` ayant exactement la même clause `WHERE`. Et en production, on travaille dans une transaction (`BEGIN` … `ROLLBACK` si le compte de lignes affectées est anormal). C'est l'accident le plus courant du métier, et il a déjà coûté des bases entières.

**13.** Les deux mesures à noter : le **temps** et le **volume transféré**. Dix mille lignes représentent plusieurs mégaoctets sur le réseau, pour en garder trois cents. Le filtrage SQL transfère trois cents lignes et utilise éventuellement un index (leçon 06). C'est le même raisonnement que « recherche répétée → index » de la leçon 12 du palier 1, appliqué à la couche données.
</details>

---

## ✅ Acquis si…

- [ ] J'écris `SELECT`, `WHERE`, `ORDER BY`, `LIMIT` sans hésiter.
- [ ] Je crée une table avec clés primaires, clés étrangères et contraintes.
- [ ] J'explique la différence entre `INNER JOIN` et `LEFT JOIN`, avec un cas où `LEFT` est indispensable.
- [ ] J'écris une jointure sur **trois** tables avec agrégats et `GROUP BY`.
- [ ] Je distingue `WHERE` et `HAVING`.
- [ ] Je connais l'idiome `LEFT JOIN … WHERE … IS NULL` pour les orphelins.
- [ ] Je sais pourquoi `COUNT(*)` et `COUNT(colonne)` diffèrent avec un `LEFT JOIN`.
- [ ] J'utilise **toujours** des requêtes paramétrées depuis Node.
- [ ] Je filtre dans la base, et j'ai **mesuré** la différence.
- [ ] J'ai fini sqlbolt et une bonne partie de pgexercises.

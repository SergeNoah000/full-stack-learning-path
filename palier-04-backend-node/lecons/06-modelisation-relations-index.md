# Leçon 06 — Modélisation relationnelle, relations N-N, index

> 🎯 **À la fin de cette leçon** : tu conçois un schéma de base de données qui ne te piégera pas dans six mois, et tu sais pourquoi une requête est lente.
> ⏱️ 5 h · **Prérequis** : leçon 05.

---

## De quoi on parle

La **modélisation** consiste à décider quelles tables existent, quelles colonnes elles portent, et comment elles se relient. C'est la décision la plus durable d'un projet : le code se réécrit en une semaine, un schéma de base avec des données en production se modifie avec précaution.

Trois types de **relations** couvrent presque tout. Le **un-à-plusieurs** (une catégorie a plusieurs dépenses) : la clé étrangère va du côté « plusieurs ». Le **plusieurs-à-plusieurs** (une dépense a plusieurs étiquettes, une étiquette concerne plusieurs dépenses) : il faut une **table de jointure**. Et le **un-à-un**, plus rare.

La **normalisation** est le principe qui consiste à ne stocker chaque information qu'une seule fois.

Un **index** est une structure annexe qui permet de retrouver des lignes sans parcourir toute la table — exactement comme l'index d'un livre.

---

## À quoi ça sert, concrètement

**Parce qu'une erreur de schéma coûte très cher.** Un mauvais nom de variable se renomme en dix secondes. Une colonne mal typée, une relation manquante ou une donnée dupliquée dans trois tables, sur une base qui contient déjà des données de production, demande une migration, une reprise de données, et du temps d'arrêt. C'est pour cette raison que la section « modèle de données » figure dans ton cahier des charges (fil rouge gestion de projet, palier 4).

**Parce que la duplication produit des incohérences.** Si le nom d'une catégorie est recopié dans chaque dépense, que se passe-t-il quand on le corrige ? Soit on met à jour mille lignes, soit on a deux orthographes dans la base. La normalisation n'est pas une élégance théorique : c'est ce qui garantit qu'une information a **une** valeur.

**Parce que les index font la différence entre une application utilisable et inutilisable.** C'est exactement le raisonnement de la leçon 12 du palier 1 : une recherche sans index est `O(n)`, avec index `O(log n)`. Sur cinquante mille lignes, c'est deux secondes contre deux millisecondes — et tu vas le mesurer.

**Et parce que les contraintes sont une protection que ton code ne peut pas contourner.** Même avec un bug dans ta validation, la base refusera une clé étrangère invalide.

---

## Où ça intervient dans le développement

Le schéma est le socle, et tout s'appuie dessus :

```
   CAHIER DES CHARGES — les entités du métier
        ▼
   MODÈLE DE DONNÉES — tables, relations, contraintes     ← cette leçon
        ▼
   MIGRATIONS — versionnées dans Git                      ← leçon 07
        ▼
   TYPES / SCHÉMAS — Zod, TypeScript (leçons 04, 07)
        ▼
   API — ressources REST (leçon 03)
```

Remarque l'ordre : **le modèle de données précède l'API**. Tes ressources REST correspondent généralement à tes tables principales, et tes relations se reflètent dans tes sous-ressources (`/depenses/42/commentaires`). Concevoir l'API avant le modèle conduit à des incohérences.

Trois points structurants.

**La modélisation est indépendante du langage.** Ce que tu apprends ici vaut identiquement pour Django (palier 5) et Laravel (palier 6). Les ORM changent, le schéma relationnel ne change pas. C'est, avec SQL, la connaissance la plus transférable du palier.

**Les index sont le premier outil de performance.** Au palier 7, quand tu parleras de scalabilité, et au palier 8, quand une page sera lente en production, c'est la première chose à vérifier.

**Et tu vas rencontrer le choix « normaliser ou dénormaliser ».** La règle de départ est de normaliser ; la dénormalisation est une optimisation que l'on introduit avec une raison mesurée. Nous y reviendrons au palier 7, mais le réflexe s'installe ici.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas dessiner ton schéma sur papier avant de l'écrire, et c'est la bonne méthode. Un schéma se discute mieux sur un dessin que dans du code.

Tu vas aussi mesurer l'effet d'un index avec `EXPLAIN ANALYZE`, et c'est un moment satisfaisant : voir un plan passer de `Seq Scan` à `Index Scan` et le temps chuter d'un facteur mille rend la notion concrète.

### En équipe, en entreprise

**Le schéma se relit à plusieurs.** Une revue de modèle de données avant écriture est une pratique courante, parce que le coût d'une erreur est élevé.

**Tu hériteras de schémas discutables.** Des colonnes `varchar` pour des dates, pas de clés étrangères, des champs `info1`, `info2`, des tables à soixante colonnes, des données dupliquées. Savoir diagnostiquer est utile ; savoir qu'on ne refait pas un schéma de production à la légère l'est autant.

**Les index sont un sujet d'exploitation.** Les outils de surveillance signalent les requêtes lentes, et l'ajout d'index est l'une des interventions les plus fréquentes. On parlera aussi des index **inutiles** : chaque index ralentit les écritures et occupe de l'espace.

**Et on te demandera des diagrammes.** Un schéma entité-relation accompagne la documentation d'un projet sérieux (ton `ARCHITECTURE.md`, et ton document d'architecture du palier 7).

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : les relations un-à-plusieurs, les clés étrangères, `NOT NULL`, les bons types de colonnes, et un index sur les colonnes de recherche et de jointure.

Régulièrement : les tables de jointure pour les relations plusieurs-à-plusieurs, les index composites, `UNIQUE` sur une combinaison de colonnes, `EXPLAIN ANALYZE`, les énumérations.

Rare, et hors sujet pour l'instant : les index partiels et fonctionnels, les index GIN pour la recherche plein texte ou le JSON, les formes normales au-delà de la troisième, l'héritage de tables, les colonnes générées, le partitionnement, les vues matérialisées. Et un sujet qu'on te présentera parfois comme essentiel et qui ne l'est pas à ton niveau : la théorie complète de la normalisation. Trois règles de bon sens suffisent, et elles sont ci-dessous.

---

## La mécanique

### Choisir ses types

```sql
CREATE TABLE depenses (
  id            SERIAL PRIMARY KEY,          -- ou BIGSERIAL si gros volume attendu
  montant       INTEGER NOT NULL,            -- centimes (jamais FLOAT pour de l'argent)
  description   VARCHAR(200) NOT NULL,
  date          DATE NOT NULL,               -- une date sans heure
  cree_le       TIMESTAMPTZ NOT NULL DEFAULT now(),   -- avec fuseau horaire
  est_payee     BOOLEAN NOT NULL DEFAULT false,
  note          TEXT                         -- longueur libre
);
```

Les erreurs de typage les plus coûteuses, par fréquence : **`FLOAT` pour de l'argent** (erreurs d'arrondi — palier 1, leçon 01), **`VARCHAR` pour une date** (tri et comparaisons impossibles, aucune validation), **`TIMESTAMP` sans fuseau** (décalages), et **`VARCHAR(255)` partout** sans réfléchir à la contrainte réelle.

### Un-à-plusieurs : la clé étrangère du côté « plusieurs »

```sql
CREATE TABLE categories (
  id  SERIAL PRIMARY KEY,
  nom VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE depenses (
  id           SERIAL PRIMARY KEY,
  categorie_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
  …
);
```

La règle est simple et ne souffre pas d'exception : **la clé étrangère va dans la table du côté « plusieurs »**. Une dépense a **une** catégorie, donc `depenses` porte `categorie_id`. L'inverse — stocker une liste de dépenses dans la catégorie — est impossible en relationnel, et c'est précisément ce que le modèle interdit.

Le choix du `ON DELETE` est **métier**, pas technique : `RESTRICT` refuse la suppression d'une catégorie utilisée, `CASCADE` supprime les dépenses liées (à manier avec précaution — on supprime rarement des données financières), `SET NULL` les orpheline.

### ⭐ Plusieurs-à-plusieurs : la table de jointure

Une dépense peut porter plusieurs étiquettes, et une étiquette concerne plusieurs dépenses. Aucune des deux tables ne peut porter la clé de l'autre :

```sql
CREATE TABLE etiquettes (
  id  SERIAL PRIMARY KEY,
  nom VARCHAR(30) NOT NULL UNIQUE
);

-- La table de jointure : elle ne contient que les deux clés
CREATE TABLE depense_etiquette (
  depense_id   INTEGER NOT NULL REFERENCES depenses(id)   ON DELETE CASCADE,
  etiquette_id INTEGER NOT NULL REFERENCES etiquettes(id) ON DELETE CASCADE,
  PRIMARY KEY (depense_id, etiquette_id)       -- ⭐ clé composite : pas de doublon possible
);
```

```
   depenses          depense_etiquette          etiquettes
   ┌────┐            ┌────────────┬──────────┐  ┌────┐
   │ 1  │◀───────────│     1      │    1     │─▶│ 1  │ urgent
   │ 1  │◀───────────│     1      │    2     │─▶│ 2  │ pro
   │ 2  │◀───────────│     2      │    1     │─▶│ 1  │ urgent
   └────┘            └────────────┴──────────┘  └────┘
```

La **clé primaire composite** est le détail qui compte : elle garantit qu'une même étiquette ne peut pas être associée deux fois à la même dépense. Sans elle, il faudrait vérifier dans le code — et ça finirait par rater.

Ici, `ON DELETE CASCADE` est justifié : si une dépense disparaît, ses associations n'ont plus de sens.

Et si la relation porte une information (une quantité, un prix, une date d'ajout), la table de jointure devient une **entité à part entière** :

```sql
CREATE TABLE lignes_commande (
  commande_id  INTEGER NOT NULL REFERENCES commandes(id) ON DELETE CASCADE,
  produit_id   INTEGER NOT NULL REFERENCES produits(id)  ON DELETE RESTRICT,
  quantite     INTEGER NOT NULL CHECK (quantite > 0),
  prix_unitaire INTEGER NOT NULL,          -- ⭐ copié : le prix du produit peut changer
  PRIMARY KEY (commande_id, produit_id)
);
```

Le `prix_unitaire` copié est un exemple de **dénormalisation justifiée** : on ne veut pas que le total d'une commande de l'an dernier change parce que le prix du produit a augmenté. L'information historique doit être figée.

### Les trois règles de normalisation qui suffisent

**Une information, un endroit.** Si le nom d'une catégorie apparaît dans mille lignes de dépenses, le corriger demande mille mises à jour. Stocke-le une fois, référence-le par son identifiant.

**Pas de colonnes numérotées.** `telephone1`, `telephone2`, `telephone3` est le signe qu'il manque une table. Avec une table `telephones` liée, il n'y a plus de limite arbitraire et plus de colonnes vides.

**Pas de liste dans une colonne.** `etiquettes VARCHAR(255)` contenant `"urgent,pro,2026"` empêche toute recherche fiable, tout comptage, toute contrainte. C'est une table de jointure.

> **L'exception assumée** : on dénormalise volontairement quand on veut **figer une information historique** (le prix au moment de la commande) ou quand une mesure de performance le justifie. La dénormalisation est une décision documentée, jamais un raccourci.

### ⭐ Les index

Sans index, une recherche parcourt toute la table — un `Seq Scan`. Avec index, le moteur va directement aux bonnes lignes.

```sql
-- Les colonnes qui méritent un index
CREATE INDEX idx_depenses_categorie ON depenses(categorie_id);     -- jointures et filtres
CREATE INDEX idx_depenses_date      ON depenses(date);              -- filtres et tris
CREATE INDEX idx_utilisateurs_email ON utilisateurs(email);         -- recherche de connexion

-- Index composite : l'ORDRE des colonnes compte
CREATE INDEX idx_depenses_util_date ON depenses(utilisateur_id, date DESC);
```

**Quelles colonnes indexer ?** Celles qui apparaissent dans un `WHERE`, un `JOIN` ou un `ORDER BY` fréquent. Les clés primaires sont indexées automatiquement ; les **clés étrangères ne le sont pas** dans PostgreSQL, et c'est une cause très fréquente de lenteur.

**Et ce qu'un index coûte.** De l'espace disque, et un ralentissement des écritures — chaque `INSERT` ou `UPDATE` doit mettre à jour tous les index concernés. D'où la règle : on indexe ce qui est **lu souvent**, pas tout.

Sur l'index composite, l'ordre suit le principe du **préfixe gauche** : un index sur `(utilisateur_id, date)` sert les requêtes qui filtrent sur `utilisateur_id` seul, ou sur les deux — mais pas celles qui filtrent sur `date` seule.

### Mesurer : `EXPLAIN ANALYZE`

```sql
EXPLAIN ANALYZE
SELECT * FROM depenses WHERE categorie_id = 3 AND date >= '2026-10-01';
```

Ce qu'il faut savoir lire, et c'est suffisant à ton niveau :

| Dans le plan | Signification |
|---|---|
| `Seq Scan` | parcours complet de la table — ⚠️ suspect sur une grosse table |
| `Index Scan` | ✅ l'index est utilisé |
| `Bitmap Heap Scan` | l'index est utilisé, pour beaucoup de lignes |
| `rows=…` | le nombre de lignes estimé puis réel |
| `actual time=…` | le temps réel |
| `Nested Loop` répété des milliers de fois | ⚠️ souvent un index manquant sur une jointure |

La méthode : exécute `EXPLAIN ANALYZE` **avant** de créer l'index, note le temps et le type de parcours, crée l'index, relance. C'est l'exercice central de la leçon, et c'est la démarche qu'on attend de toi en production.

### Le diagramme entité-relation

Dessine-le, toujours, avant d'écrire le SQL :

```
   utilisateurs ──1──┬──N── depenses ──N──┬──N── etiquettes
                     │          │ N        │
                     │          │          └─ (via depense_etiquette)
                     │          1
                     └──────── categories
```

Un dessin au crayon suffit. Des outils existent (dbdiagram.io, Mermaid), et un diagramme dans ton `ARCHITECTURE.md` est un livrable attendu.

---

## Les problèmes que tu vas rencontrer

**`violates foreign key constraint`.** Tu insères une dépense avec une `categorie_id` qui n'existe pas. C'est la contrainte qui fait son travail — et elle vient d'attraper un bug de ton code.

**`violates not-null constraint`.** Un champ obligatoire est absent. Même remarque : la base protège l'intégrité là où ta validation a laissé passer quelque chose.

**Je ne peux pas supprimer une catégorie.** `ON DELETE RESTRICT` : des dépenses la référencent. C'est voulu. Décide : refuser, réaffecter, ou archiver.

**Ma requête est lente et `EXPLAIN` montre un `Seq Scan`.** Index manquant — commence par les clés étrangères et les colonnes de filtre.

**J'ai créé un index et rien ne change.** Trois causes possibles : la table est trop petite (le parcours complet est alors plus rapide, et PostgreSQL a raison), ta clause `WHERE` applique une fonction sur la colonne (`WHERE LOWER(email) = …` n'utilise pas l'index sur `email`), ou l'ordre des colonnes de ton index composite ne correspond pas à la requête.

**Mes écritures sont devenues lentes.** Trop d'index. Chacun doit être mis à jour à chaque écriture.

**J'ai des doublons dans ma table de jointure.** Il manque la clé primaire composite.

**Mes montants sont faux de quelques centimes.** `FLOAT` au lieu d'entiers en centimes.

**Mes dates se décalent selon l'utilisateur.** `TIMESTAMP` sans fuseau.

**Mon historique change quand je modifie un prix.** Tu références le prix au lieu de l'avoir figé dans la ligne de commande.

---

## Ce qu'on te demandera

En **test technique backend**, l'exercice classique est : **« modélise cette situation métier »**. On te décrit un domaine en français et tu produis le schéma. Ce qu'on regarde : les relations correctes, la table de jointure quand il faut, les types adaptés, les contraintes, et l'absence de duplication.

En **entretien** : « comment modélises-tu une relation plusieurs-à-plusieurs ? » (quasi systématique), « à quoi sert un index et que coûte-t-il ? », « qu'est-ce qu'une clé étrangère ? », « pourquoi ne pas stocker de l'argent en nombre décimal ? », « comment diagnostiques-tu une requête lente ? ».

Une question plus fine, qui distingue : **« quand dénormaliserais-tu ? »** — la réponse mentionne l'historique à figer et la performance mesurée.

En **travail réel**, on attendra que tu proposes un schéma avant de coder, et que tu saches lire un `EXPLAIN`.

---

## Ce qui te démarquera

**Dessiner avant d'écrire.** Arriver avec un diagramme entité-relation, même au crayon, change la nature de la conversation : on discute du modèle au lieu de relire du SQL.

**Indexer les clés étrangères.** PostgreSQL ne le fait pas automatiquement, et c'est l'une des causes de lenteur les plus répandues. Le savoir est un vrai avantage.

**Savoir qu'un index coûte.** Dire « je n'indexe pas cette colonne, elle n'est jamais filtrée et la table est très écrite » est un raisonnement d'ingénieur.

**Mesurer avec `EXPLAIN ANALYZE` avant et après.** Pas « j'ai ajouté un index », mais « le plan est passé de `Seq Scan` à `Index Scan` et le temps de 2 100 ms à 3 ms ».

**Figer les données historiques.** Le prix unitaire copié dans la ligne de commande est un détail que beaucoup de débutants ratent, et dont les conséquences apparaissent un an plus tard dans la comptabilité.

**Et reconnaître une liste dans une colonne.** Voir `"urgent,pro"` dans un `VARCHAR` et dire « il manque une table de jointure » est un diagnostic immédiat.

---

## 📚 À lire

**use-the-index-luke.com** — **la lecture de référence sur les index**, gratuite et excellente. Lis au moins *Anatomy of an index* et *The Where Clause*. C'est elle qui explique le principe du préfixe gauche.

**postgresqltutorial.com** → les sections sur les contraintes, les clés étrangères et les index.

**Documentation PostgreSQL** → *Data Types* (pour choisir correctement) et *Indexes* (chapitre *Index Types*, en survol).

Pour la modélisation, le plus efficace est la pratique : **pgexercises.com** t'expose à un schéma bien conçu, et **dbdiagram.io** permet de dessiner rapidement. Si tu veux une référence écrite, les chapitres sur la normalisation de n'importe quel cours de bases de données suffisent — ne t'enfonce pas dans la théorie des formes normales.

---

## 🤖 Le mini-projet à demander à l'IA

La modélisation s'apprend en modélisant, puis en se faisant attaquer son schéma.

> « Je suis en formation de développeur, palier 4. Je travaille la modélisation relationnelle. Décris-moi **en langage métier uniquement**, sans aucune table ni colonne, le domaine d'une application de location de matériel : des clients, du matériel avec des catégories, des locations sur une période, des tarifs qui changent dans le temps, des accessoires optionnels par location, des états de matériel, et des factures. Ma mission : produire le schéma (tables, colonnes, types, relations, contraintes) **et le diagramme**. Ensuite, attaque mon schéma avec **10 questions pièges** : que se passe-t-il si un tarif change après une location ? si un client est supprimé ? si le même accessoire est ajouté deux fois ? si une location chevauche une autre pour le même matériel ? Ne me donne pas les solutions : laisse-moi corriger. »

Le tarif qui change et le chevauchement de périodes sont les deux cas qui révèlent le plus de défauts de conception — et ce sont des problèmes réels.

Puis l'exercice sur les index, qui doit être **mesuré** :

> « Donne-moi un script SQL qui crée une table de 200 000 lignes réalistes avec `generate_series`, et une liste de 6 requêtes typiques (filtre sur une colonne, jointure, tri paginé, recherche textuelle, agrégat par mois, filtre combiné). Pour chaque requête, ma mission : exécuter `EXPLAIN ANALYZE`, **noter le plan et le temps**, décider **quel index créer**, le créer, relancer, et te donner le gain. Confirme ou corrige mon choix d'index, et dis-moi si l'un d'eux est inutile. »

---

## 🛠️ À faire

1. **Dessine d'abord** : sur papier, le diagramme entité-relation de ton projet 4 — utilisateurs, catégories, dépenses, étiquettes, commentaires. Photographie-le dans ton journal.
2. **Écris le schéma** avec les bons types, les clés étrangères, `NOT NULL`, `CHECK` et `UNIQUE`.
3. **Teste tes contraintes** : essaie d'insérer une dépense avec une catégorie inexistante, un montant négatif, une description vide, une catégorie en doublon. Constate les quatre refus.
4. **⭐ Une relation plusieurs-à-plusieurs** : `etiquettes` et `depense_etiquette` avec clé primaire composite. Essaie d'insérer deux fois la même association et constate le refus.
5. **Une table de jointure avec données** : des lignes de commande avec quantité et prix unitaire **copié**. Change ensuite le prix du produit et vérifie que le total historique ne bouge pas.
6. **Les trois règles** : sur un schéma volontairement mauvais (colonnes `tel1`/`tel2`/`tel3`, une colonne `etiquettes` contenant une liste, le nom de catégorie dupliqué), corrige les trois défauts.
7. **⭐ Génère du volume** : 200 000 lignes avec `generate_series`.
8. **Mesure sans index** : `EXPLAIN ANALYZE` sur un filtre par catégorie et par date. Note le type de parcours et le temps.
9. **Crée l'index, remesure.** Note le gain. Écris les deux plans dans ton journal — c'est demandé dans l'épreuve de sortie.
10. **Un index composite** : sur `(utilisateur_id, date DESC)`. Teste une requête qui filtre sur les deux, puis une qui ne filtre que sur `date`, et explique la différence.
11. **L'index inutilisé** : écris `WHERE LOWER(email) = 'x'` avec un index sur `email`, constate le `Seq Scan`, et explique pourquoi.
12. **Le coût des écritures** : chronomètre l'insertion de 10 000 lignes sans index, puis avec cinq index. Note l'écart.
13. **Indexe tes clés étrangères** et vérifie l'effet sur une jointure.

<details>
<summary>Corrections et points de contrôle</summary>

**5.** C'est l'exercice le plus instructif de la leçon. Si tu références le prix via `produits.prix`, modifier ce prix change le total de **toutes** les commandes passées — y compris celles déjà facturées. En copiant `prix_unitaire` dans la ligne de commande, l'historique est figé. **C'est une dénormalisation volontaire et justifiée**, et c'est la réponse à la question d'entretien « quand dénormaliser ? ».

**6.** Les trois corrections : `tel1/tel2/tel3` devient une table `telephones(utilisateur_id, numero, type)` — plus de limite arbitraire, plus de colonnes vides. La colonne `etiquettes` contenant `"urgent,pro"` devient une table de jointure — on peut alors chercher, compter et contraindre. Le nom de catégorie dupliqué devient une clé étrangère — une seule orthographe possible.

**8 et 9.** Les ordres de grandeur attendus sur 200 000 lignes : un `Seq Scan` autour de 20 à 60 ms (plus si la table est large), un `Index Scan` autour de 0,1 à 2 ms. Sur une table plus grande ou une requête plus sélective, le rapport dépasse facilement 1 000. **Note les deux plans textuels** : c'est ce que tu montreras en entretien, et c'est plus convaincant que n'importe quelle affirmation.

**10.** L'index `(utilisateur_id, date DESC)` sert les requêtes qui filtrent sur `utilisateur_id` (seul ou avec `date`), mais **pas** celles qui ne filtrent que sur `date` — c'est le principe du **préfixe gauche** : l'index est trié d'abord par la première colonne. Pour filtrer sur `date` seule, il faut un index dédié.

**11.** Appliquer une fonction à la colonne empêche l'utilisation de l'index, qui contient les valeurs brutes et non transformées. Les solutions : un **index fonctionnel** (`CREATE INDEX … ON utilisateurs(LOWER(email))`), ou stocker l'email déjà normalisé en minuscules à l'insertion. C'est un piège très courant sur les recherches d'email insensibles à la casse.

**12.** Attends-toi à un ralentissement de 30 à 100 % des insertions avec cinq index. C'est l'argument qui justifie de ne pas indexer « au cas où » : chaque index est un compromis entre lecture rapide et écriture plus lente.
</details>

---

## ✅ Acquis si…

- [ ] Je dessine un diagramme entité-relation **avant** d'écrire le SQL.
- [ ] Je place la clé étrangère du bon côté dans une relation un-à-plusieurs.
- [ ] Je modélise une relation plusieurs-à-plusieurs avec une table de jointure et une clé composite.
- [ ] Je sais quand une table de jointure porte des données, et pourquoi copier un prix historique.
- [ ] Je choisis les bons types : entiers pour l'argent, `DATE`, `TIMESTAMPTZ`.
- [ ] Je connais les trois règles de normalisation et je sais les appliquer à un schéma défectueux.
- [ ] J'ai testé mes contraintes en essayant de les violer.
- [ ] Je lis un `EXPLAIN ANALYZE` et je distingue `Seq Scan` et `Index Scan`.
- [ ] J'ai **mesuré** le gain d'un index, avant et après.
- [ ] Je sais ce qu'un index coûte, et pourquoi on n'indexe pas tout.
- [ ] J'indexe mes clés étrangères.

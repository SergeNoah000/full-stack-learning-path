# Leçon 07 — ORM et migrations (Prisma)

> 🎯 **À la fin de cette leçon** : tu utilises un ORM sans en être prisonnier, tu versionnes ton schéma comme ton code, et tu sais diagnostiquer le problème de performance le plus fréquent du métier.
> ⏱️ 5 h · **Prérequis** : leçons 05–06 (le SQL d'abord, l'ORM ensuite — l'ordre n'est pas négociable).

---

## De quoi on parle

Un **ORM** (*Object-Relational Mapping*) est une couche qui traduit entre les **objets** de ton code et les **lignes** de ta base. Tu écris `prisma.depense.findMany({ where: { categorieId: 3 } })`, et il produit le `SELECT … WHERE …` correspondant.

Une **migration** est un fichier versionné qui décrit un changement de schéma : créer une table, ajouter une colonne, poser un index. C'est **l'historique Git de ta base de données**.

**Prisma** est l'ORM le plus répandu de l'écosystème TypeScript. Il a une particularité utile pour l'apprentissage : son schéma est déclaré dans un fichier dédié, et il **génère les types TypeScript** depuis ce schéma.

Et le **problème N+1** est le piège de performance caractéristique des ORM : une requête pour la liste, puis une requête **par élément** de cette liste.

---

## À quoi ça sert, concrètement

**Parce que écrire toutes ses requêtes à la main est long et répétitif.** Un CRUD complet en SQL brut, avec la gestion des paramètres, la conversion des types et le mapping vers des objets, représente beaucoup de code sans valeur métier. L'ORM le fait, et il le fait avec des requêtes paramétrées — donc sans risque d'injection (leçon 09).

**Parce que les migrations résolvent un vrai problème.** Sans elles, comment un collègue obtient-il le même schéma que toi ? Comment déploies-tu une modification de table en production sans tout casser ? Comment reviens-tu en arrière ? Les migrations versionnées répondent aux trois, et elles sont **indispensables** dès qu'il y a plus d'un développeur ou plus d'un environnement.

**Parce que les types générés suppriment une source d'erreur.** Prisma lit ton schéma et génère les types TypeScript correspondants. Tu ne peux plus te tromper sur un nom de colonne : le compilateur refuse. C'est le même bénéfice que `z.infer` à la leçon 04 — une seule source de vérité.

**Et parce qu'il faut connaître le piège.** Un ORM mal utilisé produit des applications lentes, et le N+1 est la cause la plus fréquente de lenteur en production dans tout l'écosystème web — Node, Django ou Laravel confondus. Savoir le détecter est une compétence directement monnayable.

---

## Où ça intervient dans le développement

L'ORM s'insère dans ta couche de dépôts, celle de la leçon 03 :

```
   SERVICES — la logique métier (ne connaît pas l'ORM)
        ▼
   DÉPÔTS — c'est ICI que vit Prisma                ← cette leçon
        ▼
   SQL généré
        ▼
   BASE DE DONNÉES
```

**Garde l'ORM dans les dépôts**, pas dans les services ni les contrôleurs. La raison est pratique : le jour où tu changes d'ORM, ou où une requête doit passer en SQL brut pour des raisons de performance, tu modifies un fichier et pas cinquante. C'est le même raisonnement que l'encapsulation de TanStack Query au palier 3.

Trois prolongements majeurs pour le parcours.

**Les migrations deviennent un sujet de déploiement.** Au palier 8, ton pipeline devra appliquer les migrations **avant** de démarrer la nouvelle version du code. L'ordre compte, et une migration qui échoue en production est un incident.

**Et tu vas rencontrer deux autres ORM, avec deux philosophies différentes.** Django ORM au palier 5 et Eloquent au palier 6 suivent le patron **Active Record** : l'objet sait se sauver lui-même (`depense.save()`). Prisma est plus proche du **Data Mapper** : un client traduit, et tes objets sont de simples données. C'est exactement le genre de comparaison que tu documenteras au palier 7 — et tu l'auras vécue au lieu de l'avoir lue.

**Enfin, le N+1 est un problème d'architecture**, pas un détail de bibliothèque. Tu le retrouveras identiquement avec Django (`select_related`) et Laravel (*eager loading*). Le reconnaître une fois suffit pour les trois.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire un CRUD en quinze minutes là où il t'en fallait une heure. C'est agréable, et c'est le but.

Tu vas aussi activer le journal des requêtes de Prisma, et c'est l'exercice le plus important de la leçon : **voir le SQL généré**. Un ORM utilisé sans jamais regarder ce qu'il produit est une boîte noire — et c'est ainsi qu'on livre des applications lentes.

### En équipe, en entreprise

**Les migrations sont dans le dépôt, et on ne les modifie jamais après coup.** Une migration appliquée en production est figée : on en écrit une nouvelle pour corriger. Modifier une migration déjà appliquée crée des divergences entre environnements, et c'est un incident classique.

**Le N+1 est surveillé.** Les outils de surveillance (Datadog, Sentry, ou le journal de l'ORM) le signalent, et c'est l'une des interventions de performance les plus courantes.

**Le SQL brut reste autorisé et parfois nécessaire.** Un rapport avec plusieurs agrégats, une requête analytique, une migration de données : on sort de l'ORM sans états d'âme. Prisma fournit `$queryRaw` pour ça.

**Et tu verras des débats sur les ORM.** Certaines équipes les évitent au profit de constructeurs de requêtes (Kysely, Drizzle) ou de SQL brut typé. L'argument est le contrôle ; le contre-argument est la productivité. Savoir exposer les deux est plus utile que de choisir un camp.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `findMany`, `findUnique`, `create`, `update`, `delete`, `where`, `select`, `include`, `orderBy`, `take`/`skip`, et `prisma migrate dev`.

Régulièrement : `count`, `groupBy`, `aggregate`, les transactions, `upsert`, les relations imbriquées, `prisma migrate deploy` en production, `prisma studio` pour inspecter les données.

Rare, et hors sujet pour l'instant : les extensions de client, le *middleware* Prisma, les vues, les transactions interactives complexes, le partitionnement, les migrations de données volumineuses, `$queryRaw` typé avancé, la réplication lecture/écriture. Et une chose à savoir : Prisma évolue vite, donc vérifie la version dans la documentation plutôt que de suivre un article de 2021.

---

## La mécanique

### Installer et déclarer le schéma

```bash
npm install prisma --save-dev
npm install @prisma/client
npx prisma init --datasource-provider postgresql
```

```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")          // ⭐ la variable validée de la leçon 04
}

model Categorie {
  id       Int       @id @default(autoincrement())
  nom      String    @unique @db.VarChar(50)
  depenses Depense[]                       // la relation, côté "un"
}

model Depense {
  id           Int        @id @default(autoincrement())
  montant      Int                          // centimes
  description  String     @db.VarChar(200)
  date         DateTime   @db.Date
  creeLe       DateTime   @default(now()) @map("cree_le")
  categorieId  Int        @map("categorie_id")
  categorie    Categorie  @relation(fields: [categorieId], references: [id])
  etiquettes   DepenseEtiquette[]

  @@index([categorieId])                    // ⭐ l'index de la leçon 06
  @@index([date])
  @@map("depenses")
}

model Etiquette {
  id       Int                @id @default(autoincrement())
  nom      String             @unique @db.VarChar(30)
  depenses DepenseEtiquette[]
}

model DepenseEtiquette {                    // la table de jointure de la leçon 06
  depenseId   Int       @map("depense_id")
  etiquetteId Int       @map("etiquette_id")
  depense     Depense   @relation(fields: [depenseId], references: [id], onDelete: Cascade)
  etiquette   Etiquette @relation(fields: [etiquetteId], references: [id], onDelete: Cascade)

  @@id([depenseId, etiquetteId])            // la clé composite
  @@map("depense_etiquette")
}
```

Observe que **tout ce que tu as appris à la leçon 06 se retrouve ici** : les relations, la table de jointure, la clé composite, les index, les contraintes d'unicité. L'ORM ne remplace pas la modélisation — il l'exprime dans une autre syntaxe. C'est pour cette raison que l'ordre des leçons est celui-là.

Les `@map` servent à garder des noms de colonnes en `snake_case` côté base (convention SQL) tout en ayant du `camelCase` côté TypeScript.

### Les migrations

```bash
npx prisma migrate dev --name creation_initiale    # en développement : crée et applique
npx prisma migrate deploy                           # en production : applique seulement
npx prisma migrate status                           # où en est-on ?
```

`migrate dev` génère un fichier SQL dans `prisma/migrations/`, l'applique, et régénère le client typé. **Ce fichier est commité** : c'est lui qui permet à un collègue, à l'intégration continue et à la production d'obtenir exactement le même schéma.

> ⚠️ **Ne modifie jamais une migration déjà appliquée ailleurs.** Si tu t'es trompé, écris une nouvelle migration qui corrige. Modifier l'historique crée une divergence entre ta base et celle des autres — et en production, c'est un incident. C'est exactement la même règle que pour un commit Git déjà poussé (palier 0, leçon 04).

### Interroger

```ts
// depots/depenses.ts — l'ORM vit ICI, et nulle part ailleurs
import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient({ log: ["query"] });     // ⭐ voir le SQL généré

export const depotDepenses = {
  lister: ({ categorieId, page, limite }: Filtres) =>
    prisma.depense.findMany({
      where: categorieId ? { categorieId } : undefined,
      orderBy: { date: "desc" },
      take: limite,
      skip: (page - 1) * limite,
      select: { id: true, montant: true, description: true, date: true },  // ⭐ pas SELECT *
    }),

  parId: (id: number) => prisma.depense.findUnique({ where: { id } }),

  creer: (donnees: NouvelleDepense) => prisma.depense.create({ data: donnees }),

  modifier: (id: number, champs: MiseAJourDepense) =>
    prisma.depense.update({ where: { id }, data: champs }),

  supprimer: (id: number) => prisma.depense.delete({ where: { id } }),
};
```

Le `log: ["query"]` est le réglage le plus important de la leçon : il affiche chaque requête SQL dans la console. Laisse-le actif en développement, toujours.

Et le `select` explicite évite de transférer des colonnes inutiles — c'est le `SELECT *` de la leçon 05, et le même raisonnement s'applique.

### ⭐ Le problème N+1

```ts
// ❌ 1 requête pour la liste, puis 1 PAR dépense = 101 requêtes pour 100 lignes
const depenses = await prisma.depense.findMany({ take: 100 });
for (const d of depenses) {
  const cat = await prisma.categorie.findUnique({ where: { id: d.categorieId } });
  console.log(d.description, cat.nom);
}

// ✅ 1 seule requête, avec la jointure
const depenses = await prisma.depense.findMany({
  take: 100,
  include: { categorie: true },         // ⭐ le chargement anticipé
});
depenses.forEach(d => console.log(d.description, d.categorie.nom));
```

**C'est le piège de performance le plus fréquent du développement web**, et il est insidieux pour deux raisons. D'abord, le code fautif est **parfaitement lisible** — une boucle qui va chercher une donnée paraît naturel. Ensuite, il **fonctionne très bien en développement** : avec dix lignes de test, onze requêtes sur une base locale prennent cinq millisecondes. Avec dix mille lignes en production et une base distante, c'est dix mille allers-retours réseau et une page qui ne charge plus.

La détection est simple **si tu as activé le journal** : tu vois défiler des dizaines de requêtes identiques. Sans le journal, tu ne vois rien.

Tu reconnaîtras d'ailleurs le motif : c'est le `find` dans une boucle de la leçon 12 du palier 1, transposé à la base de données. Même problème, même correction — on fait le travail en une fois au lieu de le répéter.

```ts
// Relations imbriquées : on charge tout ce dont on a besoin, en une requête
const depenses = await prisma.depense.findMany({
  include: {
    categorie: true,
    etiquettes: { include: { etiquette: true } },
  },
});
```

### Agrégats et groupements

```ts
// Le GROUP BY de la leçon 05
const totaux = await prisma.depense.groupBy({
  by: ["categorieId"],
  _sum: { montant: true },
  _count: true,
  where: { date: { gte: new Date("2026-10-01") } },
  having: { montant: { _sum: { gt: 500_000 } } },
});
```

### Les transactions

```ts
// Tout ou rien : les deux opérations réussissent, ou aucune
await prisma.$transaction([
  prisma.depense.create({ data: depense }),
  prisma.budget.update({ where: { id }, data: { restant: { decrement: depense.montant } } }),
]);
```

Une transaction garantit l'**atomicité** : si la seconde opération échoue, la première est annulée. C'est indispensable dès que deux écritures doivent rester cohérentes — débiter et créditer, créer une commande et décrémenter un stock. Tu reverras ce concept au palier 7 avec l'idempotence.

### Quand sortir de l'ORM

```ts
// Un rapport complexe : le SQL brut est plus clair et plus efficace
const rapport = await prisma.$queryRaw<LigneRapport[]>`
  SELECT c.nom, COUNT(*) AS nombre, SUM(d.montant) AS total
  FROM depenses d
  INNER JOIN categories c ON c.id = d.categorie_id
  WHERE d.date >= ${debut}
  GROUP BY c.nom
  ORDER BY total DESC
`;
```

Note la syntaxe à **gabarit balisé** (*tagged template*) : Prisma paramètre automatiquement les valeurs interpolées, donc il n'y a pas d'injection. Attention cependant : `$queryRawUnsafe` **ne le fait pas**, et son nom est un avertissement.

Savoir sortir de l'ORM quand il est inadapté est une marque de maturité, pas un échec.

### Les données de démarrage (*seeding*)

```ts
// prisma/seed.ts — des données de test reproductibles
await prisma.categorie.createMany({
  data: [{ nom: "food" }, { nom: "transport" }, { nom: "loyer" }],
  skipDuplicates: true,
});
```

Un script de *seed* permet à n'importe qui de disposer d'une base utilisable en une commande. C'est un livrable attendu dans un projet sérieux, et tu en auras besoin pour tes tests (leçon 10).

---

## Les problèmes que tu vas rencontrer

**Mon application est lente et je ne comprends pas pourquoi.** Active `log: ["query"]` et regarde. Dans la majorité des cas, c'est un N+1.

**`prisma migrate dev` veut réinitialiser ma base.** Ton schéma a divergé des migrations — souvent parce que tu as modifié la base à la main, ou une migration déjà appliquée. En développement, on accepte la réinitialisation ; **en production, jamais** (et `migrate deploy` ne le propose pas).

**Mes types ne correspondent pas après une modification du schéma.** Il faut régénérer le client : `npx prisma generate` (que `migrate dev` fait automatiquement).

**`Unique constraint failed`.** Une contrainte d'unicité est violée. C'est la base qui protège — traduis l'erreur en `409 Conflict` dans ton middleware (leçon 04).

**`Foreign key constraint failed`.** Tu référence une ligne inexistante, ou tu supprimes une ligne encore référencée.

**Mes dates sont décalées.** Prisma travaille en UTC. Le décalage apparaît si tu convertis mal côté application — c'est le même piège que `TIMESTAMPTZ` à la leçon 06.

**J'ai écrit du SQL brut avec une interpolation de chaîne.** Si tu as utilisé `$queryRawUnsafe` avec une concaténation, tu as créé une injection SQL. Utilise la forme à gabarit balisé.

**Ma migration passe en local et échoue en production.** Souvent une migration destructive sur une table contenant des données (ajouter une colonne `NOT NULL` sans valeur par défaut, par exemple). Il faut la décomposer en plusieurs étapes.

**Mon `include` charge trop de données.** `include` ramène **toutes** les colonnes de la relation. Utilise `select` imbriqué pour ne prendre que ce qu'il faut.

---

## Ce qu'on te demandera

En **entretien**, les questions quasi certaines : **« qu'est-ce qu'un problème N+1 et comment le détectes-tu ? »** (celle qui distingue le plus), « qu'est-ce qu'une migration et pourquoi la versionner ? », « qu'est-ce qu'un ORM, quels sont ses avantages et ses pièges ? ».

Une question plus fine, qui prépare le palier 7 : **« quelle différence entre Active Record et Data Mapper ? »**. Après les paliers 5 et 6, tu auras pratiqué les deux.

On te demandera aussi : « quand écris-tu du SQL brut malgré l'ORM ? », « à quoi sert une transaction ? ».

En **test technique**, un projet avec Prisma t'est souvent fourni, et on observe si tu produis des N+1.

---

## Ce qui te démarquera

**Avoir le journal des requêtes activé, toujours.** C'est l'habitude qui sépare ceux qui savent ce que fait leur ORM de ceux qui l'espèrent. Et c'est la condition pour repérer un N+1.

**Détecter un N+1 à la lecture.** Voir une boucle qui contient un appel à la base et dire « ça fera une requête par élément » est une compétence immédiatement utile, et valorisée.

**Garder l'ORM dans les dépôts.** Savoir expliquer que les services ne doivent pas en dépendre montre que tu penses en couches.

**Savoir en sortir.** Dire « ce rapport, je l'écris en SQL, l'ORM le ferait mal » est le signe que tu maîtrises l'outil au lieu de le subir.

**Ne jamais modifier une migration appliquée.** Et savoir pourquoi : c'est la même règle que pour un commit poussé.

**Et avoir un script de *seed*.** Détail d'équipe : il permet à n'importe qui de démarrer en une commande, et il rend tes tests reproductibles.

---

## 📚 À lire

**prisma.io/docs → *Getting Started*** puis ***Prisma Schema*** et ***Prisma Client → CRUD***. La documentation est bonne et à jour — préfère-la aux articles de blog, qui vieillissent vite sur cet outil.

**prisma.io/docs → *Relation queries*** : c'est la page qui traite d'`include` et donc du N+1. Lis-la attentivement.

**prisma.io/docs → *Migrate***, en particulier la distinction entre `migrate dev` et `migrate deploy` — tu en auras besoin au palier 8.

Et pour la culture : cherche **« N+1 query problem »** et lis une explication générale, indépendante de Prisma. Tu verras que le problème est décrit à l'identique dans les écosystèmes Django, Rails et Laravel — c'est ce qui en fait un concept d'architecture.

---

## 🤖 Le mini-projet à demander à l'IA

Le N+1 doit être **vu dans les journaux**, pas lu dans un article.

> « Je suis en formation de développeur, palier 4. J'utilise Prisma avec le journal des requêtes activé. Donne-moi **8 scénarios de code réalistes**, décrits en français **sans code**, où un débutant produit un problème N+1 (afficher une liste de dépenses avec le nom de leur catégorie, un tableau de bord avec le total par utilisateur, une liste de commandes avec leurs lignes, un export avec plusieurs relations imbriquées…). Pour chacun : je dois **prédire combien de requêtes SQL mon code va produire**, l'écrire, puis compter dans le journal. Si je me suis trompé, explique-moi pourquoi, et demande-moi comment corriger — **sans me donner la solution**. »

Prédire le nombre de requêtes avant de les compter est l'exercice qui installe définitivement ce réflexe.

Puis l'exercice sur les migrations, qui prépare le palier 8 :

> « Décris-moi **6 changements de schéma** qu'un projet réel doit subir après sa mise en production (ajouter une colonne obligatoire, renommer une colonne, changer un type, ajouter une contrainte d'unicité sur des données existantes qui contiennent des doublons, découper une table en deux, ajouter une relation). Pour chacun, demande-moi : **quelle migration j'écris**, dans quel ordre, et **ce qui se passe si la table contient déjà un million de lignes et que l'application tourne pendant la migration**. Corrige mon raisonnement. »

Ce second exercice touche un sujet que presque aucun junior n'a travaillé, et qui tombe régulièrement en entretien pour des postes backend.

---

## 🛠️ À faire

1. **Installe Prisma** et traduis le schéma de la leçon 06 en `schema.prisma` — relations, table de jointure avec clé composite, index, contraintes.
2. **Première migration** : `migrate dev`, puis **ouvre le fichier SQL généré** dans `prisma/migrations/` et vérifie qu'il correspond à ce que tu aurais écrit à la main.
3. **Active `log: ["query"]`** et laisse-le pour tout le reste de la leçon.
4. **Réécris ta couche de dépôts** avec Prisma. Compare avec ta version `pg` de la leçon 05 : lignes écrites, lisibilité, et SQL produit.
5. **⭐ Provoque un N+1** : affiche cent dépenses avec le nom de leur catégorie, en allant chercher la catégorie dans une boucle. **Compte les requêtes dans le journal.**
6. **Corrige avec `include`** et recompte. Note les deux nombres dans ton journal.
7. **Mesure l'impact réel** : chronomètre les deux versions sur mille lignes. Puis simule une base distante en ajoutant artificiellement 20 ms de latence par requête, et recalcule.
8. **`select` au lieu de tout charger** : compare le SQL généré avec et sans `select`.
9. **Agrégat** : le total par catégorie avec `groupBy`, et vérifie le SQL produit dans le journal.
10. **Une transaction** : créer une dépense et décrémenter un budget. Fais échouer la seconde opération et vérifie que la première est annulée.
11. **Une migration incrémentale** : ajoute une colonne `est_payee` avec une valeur par défaut, applique, et inspecte le SQL généré.
12. **⚠️ La migration impossible** : essaie d'ajouter une colonne `NOT NULL` **sans** valeur par défaut sur une table contenant des données. Lis l'erreur et explique comment procéder en production.
13. **SQL brut** : écris un rapport avec `$queryRaw`, en gabarit balisé. Vérifie dans le journal que les valeurs sont bien paramétrées.
14. **Script de *seed*** : des catégories et vingt dépenses, exécutable en une commande.

<details>
<summary>Corrections et points de contrôle</summary>

**5 et 6.** Les nombres attendus : **101 requêtes** avec la boucle (1 pour la liste + 100 pour les catégories), **1 requête** avec `include`. Si tu as activé le journal, tu verras défiler cent `SELECT … FROM categories WHERE id = $1` identiques — c'est le symptôme caractéristique, et il est impossible à manquer.

**7.** C'est le calcul qui fait comprendre l'enjeu. En local, cent requêtes à 0,3 ms font 30 ms : invisible. Avec une base distante à 20 ms de latence (ce qui est courant entre un serveur applicatif et une base managée), cent requêtes font **2 secondes**, contre 20 ms pour la version corrigée. **Le même code, cent fois plus lent en production qu'en développement** — et c'est exactement pour cette raison que le N+1 passe les tests et explose ensuite.

**10.** Avec `$transaction`, l'échec de la seconde opération annule la première : la dépense n'est pas créée. Sans transaction, tu obtiens une dépense créée et un budget non décrémenté — une incohérence durable dans tes données, du genre qu'on découvre trois mois plus tard dans un rapport qui ne tombe pas juste.

**12.** PostgreSQL refuse : il ne sait pas quelle valeur mettre dans les lignes existantes. La procédure en production se fait en trois étapes — ajouter la colonne **nullable**, remplir les lignes existantes par une mise à jour, puis poser la contrainte `NOT NULL`. Chaque étape est une migration séparée. C'est le type de raisonnement qu'on attend d'un développeur backend, et c'est directement lié au déploiement sans interruption du palier 8.

**13.** Dans le journal, tu dois voir la requête avec des placeholders (`$1`, `$2`) et les valeurs transmises séparément. Si tu vois les valeurs **dans** la chaîne SQL, tu as utilisé `$queryRawUnsafe` avec une concaténation — et tu viens de créer une injection SQL (leçon 09).
</details>

---

## ✅ Acquis si…

- [ ] J'ai traduit mon schéma relationnel en schéma Prisma, index et clés composites compris.
- [ ] Mes migrations sont versionnées dans Git, et je ne modifie jamais une migration appliquée.
- [ ] J'ai lu le SQL généré par ma première migration et il correspond à mes attentes.
- [ ] `log: ["query"]` est activé en développement, en permanence.
- [ ] J'ai **provoqué** un N+1, compté les requêtes, et corrigé avec `include`.
- [ ] J'ai calculé l'impact du N+1 avec une latence réseau réaliste.
- [ ] J'utilise `select` pour ne charger que les colonnes nécessaires.
- [ ] L'ORM vit dans mes dépôts, pas dans mes services.
- [ ] Je sais utiliser une transaction, et pourquoi.
- [ ] Je sais écrire du SQL brut paramétré quand l'ORM est inadapté.
- [ ] J'ai un script de *seed* qui rend ma base utilisable en une commande.

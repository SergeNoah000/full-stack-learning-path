# Leçon 06 — map, filter, reduce ⭐

> 🎯 **À la fin de cette leçon** : tu transformes, sélectionnes et agrèges des données sans écrire une seule boucle à la main — et tu reconnaîtras ces trois outils dans les quatre langages du parcours.
> ⏱️ 5 h (2 h de lecture, 3 h de pratique — c'est la pratique qui compte ici) · **Prérequis** : leçons 03 à 05, en particulier l'idée que **les fonctions sont des valeurs**.

---

## De quoi on parle

`map`, `filter` et `reduce` sont trois **méthodes de tableau** qui ont une particularité : au lieu de recevoir une valeur, elles reçoivent **une fonction**, et c'est elles qui l'appelleront, une fois par élément. On dit qu'elles sont « d'ordre supérieur », et la fonction qu'on leur confie s'appelle un *callback*.

Chacune répond à un besoin distinct :

`map` **transforme**. Tu lui donnes un tableau de dix dépenses et une règle de transformation, elle te rend un tableau de dix éléments transformés. Le nombre d'éléments ne change jamais.

`filter` **sélectionne**. Tu lui donnes une condition, elle te rend un nouveau tableau contenant uniquement les éléments qui la satisfont, **inchangés**. Le nombre d'éléments diminue (ou reste égal), le contenu de chacun ne bouge pas.

`reduce` **agrège**. Elle parcourt le tableau en transportant une valeur d'une itération à la suivante, et te rend cette valeur unique à la fin. Un total, une moyenne, un objet de statistiques, un index : tout ce qui consiste à faire « rentrer » une collection dans une seule valeur.

Les trois ont un point commun essentiel : **elles ne modifient jamais le tableau d'origine**, elles en retournent un nouveau (ou une nouvelle valeur). C'est le prolongement direct de la leçon 04.

---

## Pourquoi ça existe, et ce que ça change

Compare ces deux versions du même calcul.

```js
// Ce qu'on écrit quand on ne connaît que les boucles
const totaux = [];
for (let i = 0; i < depenses.length; i++) {
  if (depenses[i].categorie === "food") {
    totaux.push(depenses[i].montant * 1.1925);
  }
}

// Ce qu'on écrit après cette leçon
const totaux = depenses
  .filter(d => d.categorie === "food")
  .map(d => d.montant * 1.1925);
```

La seconde version ne fait pas que gagner quatre lignes. Elle **dit son intention** : `filter` annonce « je sélectionne », `map` annonce « je transforme ». Pour lire la première, tu dois simuler la boucle dans ta tête — initialiser le tableau, suivre le compteur, vérifier la condition d'arrêt. Pour lire la seconde, tu lis une phrase.

Et tu fais disparaître une famille entière de bugs. Dans la première version, tu peux te tromper sur l'initialisation de `i`, écrire `i <= length` et lire un élément qui n'existe pas, oublier le `push`, oublier de réinitialiser le tableau entre deux appels. Aucune de ces erreurs n'est possible dans la seconde : **le code qui n'existe pas ne peut pas être buggé**.

Un mot sur le vocabulaire, parce qu'il revient en revue de code : la première version est **impérative** (elle décrit *comment* faire, étape par étape), la seconde est **déclarative** (elle décrit *quoi* obtenir). C'est la même opposition qu'entre « prends un panier, va au rayon, vérifie chaque fruit, mets les rouges dedans » et « donne-moi les pommes rouges ».

Enfin, ça se **compose**. Chaque méthode rend un tableau, sur lequel on peut appeler la suivante. Tu assembles une chaîne de traitement, exactement comme tu enchaînes des commandes avec des pipes dans le terminal — c'est la même idée, et ce n'est pas un hasard : les deux viennent de la même tradition.

> **Ce ne sont pas des raffinements d'experts.** C'est le vocabulaire standard du traitement de données en JavaScript. Un développeur qui écrit encore toutes ses boucles à la main se repère immédiatement, et c'est la remarque la plus fréquente qu'on fait à un junior en revue de code.

---

## Où ça intervient dans le développement

Voilà la question la plus utile à se poser, et la réponse va te surprendre par son ampleur : **le travail d'un développeur d'application consiste, pour une bonne moitié, à déplacer et reformer des données**. Pas à inventer des algorithmes — à prendre des données d'un côté, leur donner la forme attendue de l'autre, et les afficher. `map`, `filter` et `reduce` sont les outils de ce travail. Tu les utiliseras tous les jours, à chaque couche de chaque application.

Déroule le trajet d'une donnée dans une application complète, celle que tu construiras au palier 4 :

**Entre la base de données et le serveur.** La base te rend des lignes brutes. Tu dois en extraire les champs utiles, convertir les dates, calculer des totaux. `map` et `reduce`.

**Entre le serveur et le réseau.** Avant d'envoyer une réponse d'API, tu retires les champs que le client ne doit jamais voir — le hash du mot de passe, les notes internes — et tu renommes les autres au format attendu. `map`, systématiquement. (Et c'est exactement ce que font les *serializers* de Django REST Framework au palier 5 et les *resources* de Laravel au palier 6 : ils automatisent ce `map`.)

**Entre la réponse d'API et l'écran.** L'API te rend une structure qui ne correspond jamais tout à fait à ce dont ton interface a besoin. Tu l'adaptes. Et au palier 3, **chaque liste affichée en React est un `map`** — c'est littéralement la syntaxe pour afficher une collection : `{depenses.map(d => <Ligne key={d.id} {...d} />)}`. Tu écriras ce `map` des centaines de fois.

**Dans le calcul métier.** Totaux, moyennes, pourcentages, regroupements par catégorie, détection de dépassement de budget : ce sont des `reduce`, et ce sont eux qui portent la valeur de ton application.

**Dans les rapports et les exports.** Un export CSV est un `map` qui produit des lignes, suivi d'un `join`.

Il y a enfin un point d'architecture à garder en tête dès maintenant. Ces trois opérations existent **aussi** dans le langage des bases de données, sous d'autres noms : `SELECT` est un `map`, `WHERE` est un `filter`, `SUM` et `GROUP BY` sont des `reduce`. La question « est-ce que je filtre dans la base ou dans mon code ? » a une réponse presque toujours identique : **dans la base**, parce qu'il est absurde de transférer dix mille lignes sur le réseau pour en garder trois. Tu reverras cette décision au palier 4, puis au palier 7 quand elle devient une question de performance. Retiens dès maintenant que ces opérations existent à deux endroits, et qu'il faut choisir lequel.

---

## Ce que tu verras quand tu travailleras

### Dans ton code, tous les jours

Trois usages couvrent l'immense majorité des cas réels, et tu les reconnaîtras très vite.

Le premier est l'**extraction d'un champ** : `depenses.map(d => d.montant)`. Tu as un tableau d'objets, tu veux un tableau de valeurs. Banal, constant.

Le deuxième est la **transformation d'objets en recréant** : `depenses.map(d => ({ ...d, montantTTC: d.montant * 1.1925 }))`. Note bien les parenthèses autour de l'accolade, et note surtout qu'on **recrée** l'objet au lieu de le modifier. C'est le geste que React exigera de toi au palier 3.

Le troisième est le **total par catégorie**, qui est la forme la plus utile de `reduce` et celle que tu écriras le plus souvent :

```js
const parCategorie = depenses.reduce((acc, d) => {
  acc[d.categorie] = (acc[d.categorie] ?? 0) + d.montant;
  return acc;
}, {});
// { food: 2000, transport: 3000 }
```

Apprends cette forme par cœur. Un tableau d'objets qui devient un objet de totaux : c'est le cœur de tout tableau de bord, de tout rapport, de toute facture.

### En équipe, en revue de code

Trois remarques reviennent, et les anticiper t'évitera de les recevoir.

« **Remplace cette boucle par un `filter`.** » Sur du code moderne, une boucle manuelle qui ne fait que sélectionner ou transformer est considérée comme du bruit.

« **Cette chaîne est trop longue, coupe-la.** » Et c'est juste. Six appels enchaînés sur quinze lignes sont aussi illisibles que la boucle qu'ils remplacent. La bonne pratique est de nommer les étapes intermédiaires : `const duMois = depenses.filter(...)` puis `const top5 = [...]`. **Le déclaratif n'est une qualité que s'il reste lisible** — c'est un point que beaucoup de débutants manquent après avoir découvert le chaînage.

« **Tu mutes dans un `map`.** » Si ton callback modifie l'objet reçu au lieu d'en créer un nouveau, tu as écrit un `forEach` déguisé, avec un effet de bord caché. En React, ce code ne réaffichera pas l'interface, et le bug sera très difficile à trouver.

### Ce qui sert tout le temps, et ce qui est rare

Tu utiliseras `map` et `filter` plusieurs fois par jour, `find` et `some` très souvent, `reduce` une à deux fois par fichier de logique métier. `every` revient pour les validations.

`flatMap` est utile mais occasionnel (aplatir un niveau de tableaux imbriqués, typiquement des tags). `reduceRight` ne te servira probablement jamais. `forEach`, enfin, mérite une mise au point : il n'est pas interdit, mais il est réservé aux **effets** — afficher, écrire, envoyer. Dès que tu produis une valeur, c'est `map`, `filter` ou `reduce`.

Et sois honnête sur les cas où une boucle `for...of` reste **meilleure** : quand tu as besoin de `break` pour sortir au milieu (`map` et `filter` parcourent toujours tout), quand tu fais de l'asynchrone séquentiel avec `await` (leçon 10), quand la logique par élément dépasse quelques lignes, et quand tu traites des volumes vraiment massifs. Choisir l'outil adapté est plus professionnel que d'appliquer une règle partout.

---

## La mécanique de `reduce`

`map` et `filter` se comprennent en une minute. `reduce` demande un effort, et c'est le seul passage de cette leçon qui réclame de l'attention. Sa signature :

```js
tableau.reduce((accumulateur, element, index, tableau) => nouvelAccumulateur, valeurInitiale)
```

L'**accumulateur** est la valeur transportée d'un tour à l'autre. À chaque itération, ton callback reçoit l'accumulateur actuel et l'élément courant, et doit **retourner le nouvel accumulateur**. Déroulons une somme, pas à pas :

```js
[1, 2, 3, 4].reduce((somme, n) => somme + n, 0);
// tour 1 : somme = 0 (la valeur initiale), n = 1  →  retourne 1
// tour 2 : somme = 1,                      n = 2  →  retourne 3
// tour 3 : somme = 3,                      n = 3  →  retourne 6
// tour 4 : somme = 6,                      n = 4  →  retourne 10
// résultat : 10
```

Le point qui débloque tout le monde : **l'accumulateur n'est pas forcément un nombre.** C'est ce qui fait la puissance de `reduce` et c'est ce qu'on ne comprend pas tout de suite. Il peut être un objet (pour des totaux par clé), un objet de tableaux (pour grouper), un tableau (pour dédoublonner), une chaîne, un booléen. Dès que tu veux « réduire une collection à une seule chose », quelle que soit la forme de cette chose, c'est `reduce`.

```js
// … un objet de tableaux : grouper
const groupees = depenses.reduce((acc, d) => {
  (acc[d.categorie] ??= []).push(d);
  return acc;
}, {});

// … un index par identifiant, pour un accès instantané ensuite
const parId = depenses.reduce((acc, d) => ({ ...acc, [d.id]: d }), {});

// … le maximum
const plusGrosse = depenses.reduce((max, d) => (d.montant > max.montant ? d : max));
```

**Fournis toujours la valeur initiale.** Sans elle, `reduce` prend le premier élément comme accumulateur de départ — ce qui casse silencieusement sur un tableau d'objets — **et lève une exception sur un tableau vide**. Un `reduce((a, b) => a + b)` sur `[]` plante. C'est un bug classique, et il se produit toujours en production, jamais sur tes données de test.

Un dernier réflexe, d'ordre d'exécution : **filtre avant de transformer**. `filter` puis `map` fait moins de travail que `map` puis `filter`, puisque tu transformes moins d'éléments. Sur cent mille lignes, la différence est mesurable.

---

## Les problèmes que tu vas rencontrer

**Ton `map` rend un tableau de `undefined`.** Tu as écrit des accolades sans `return` : `d => { d.montant * 2 }` est un corps de fonction qui ne retourne rien. Soit tu enlèves les accolades (`d => d.montant * 2`), soit tu ajoutes le `return`. C'est, de loin, l'erreur la plus fréquente de cette leçon.

**Ton `map` rend un tableau de `true`/`false`.** Tu voulais `filter`. Signe que tu as confondu « transformer selon une condition » et « sélectionner selon une condition ».

**Ton `reduce` plante avec un message sur un tableau vide.** Il manque la valeur initiale.

**Tu veux retourner un objet depuis une fléchée et ça ne compile pas.** `d => { id: d.id }` est interprété comme un bloc de code, pas comme un objet. Il faut des parenthèses : `d => ({ id: d.id })`.

**Ton `sort` a modifié le tableau d'origine.** `sort` n'appartient pas à cette famille : il **mute** et, par défaut, il compare les valeurs comme des **chaînes** (`[10, 9, 100].sort()` donne `[10, 100, 9]`). Travaille sur une copie et fournis un comparateur : `[...depenses].sort((a, b) => b.montant - a.montant)`.

**Ton code est devenu lent sans raison apparente.** Tu as probablement un `find` ou un `includes` **à l'intérieur** d'un `map` ou d'un `filter`. Pour chaque élément, tu reparcours un second tableau en entier : c'est quadratique, et ça s'écroule dès quelques milliers d'éléments. La parade est un index (`Map`), et c'est l'objet de la leçon 12.

---

## Ce qu'on te demandera

Autant le dire clairement : **c'est le sujet le plus testé sur un développeur junior.** Pas les closures, pas l'event loop — la transformation de tableaux.

En **test technique**, l'exercice le plus courant au monde ressemble à ceci : « voici un tableau de commandes avec un client, un montant et une date ; rends-moi le chiffre d'affaires par client, trié décroissant, pour le mois en cours ». C'est un `filter`, un `reduce`, un `Object.entries` et un `sort`. Si tu sais faire ça sans hésiter, tu passes la majorité des tests techniques juniors en frontend comme en backend.

En **entretien oral**, trois questions reviennent. « Quelle différence entre `map` et `forEach` ? » — l'une retourne un nouveau tableau, l'autre ne retourne rien et sert aux effets. « Pourquoi faut-il la valeur initiale de `reduce` ? » — pour ne pas prendre le premier élément comme accumulateur, et pour ne pas planter sur un tableau vide. Et parfois : « implémente `map` à la main » — d'où l'exercice 17 de cette leçon, qui n'est pas un caprice.

En **revue de code**, on regardera si tu sais t'arrêter : chaîner trois opérations est bien, en chaîner sept est illisible.

---

## Ce qui te démarquera

**Savoir t'arrêter.** Nommer les étapes intermédiaires au lieu de produire une chaîne de sept appels. C'est un signe de maturité que peu de juniors ont, parce qu'ils viennent de découvrir le chaînage et veulent s'en servir.

**Savoir que c'est du SQL.** Dire en entretien « ce regroupement, je le ferais plutôt dans la requête avec un `GROUP BY`, pour ne pas transférer toutes les lignes » te place dans une autre catégorie. Tu auras les moyens de cette remarque au palier 4.

**Avoir réimplémenté les trois à la main.** Pas pour le plaisir : parce que ça supprime définitivement l'impression de magie, et que ça te permet de répondre instantanément à des questions comme « pourquoi `reduce` plante-t-il sur un tableau vide ? ».

**Reconnaître le même outil dans les autres langages.** C'est l'investissement central de cette leçon et la raison de son étoile. Ce que tu apprends ici, tu le retrouveras sous d'autres noms, sans rien réapprendre : les *list comprehensions* et `sum()` en Python au palier 5, `array_map`, `array_filter` et `array_reduce` en PHP au palier 6, `.map()`, `.where()` et `.fold()` en Dart au palier 9. Quatre langages, un seul concept. C'est exactement ce que le parcours cherche à construire : des idées qui se transfèrent, au lieu de syntaxes qui s'oublient.

---

## 📚 À lire

La page **MDN de `reduce`** est à lire **en entier**, exemples compris. C'est le meilleur exercice de lecture de documentation du palier, et c'est une page que tu reliras plusieurs fois dans ta carrière. Fais de même, plus rapidement, pour `map` et `filter` — en te concentrant sur une seule question : *qu'est-ce que ça retourne ?*

Pour la pratique guidée, **The Odin Project → Foundations → Callbacks and Higher Order Functions**, puis la section *Array methods* de **javascript.info** (chapitre 5.5), dont le tableau récapitulatif final est un bon aide-mémoire à garder ouvert les premiers jours.

---

## 🤖 Le mini-projet à demander à l'IA

Cette leçon s'apprend par la répétition sur des données variées. L'IA est parfaite pour en fabriquer. Demande ceci :

> « Je suis en formation de développeur, palier 1 (JavaScript). Je travaille `map`, `filter` et `reduce`. Génère-moi un jeu de données réaliste de 20 commandes (`id`, `client`, `montant`, `date`, `statut`, `articles` qui est un tableau), puis donne-moi **12 questions progressives** à résoudre dessus, de la plus simple à la plus difficile, **sans les corrections**. Les trois dernières doivent nécessiter un `reduce` dont l'accumulateur est un objet. Je te donnerai mes réponses une par une : critique-les sur la lisibilité et les cas limites oubliés, mais ne les réécris pas à ma place. »

Puis, quand tu te sens à l'aise, le mini-projet qui ancre vraiment le concept :

> « Donne-moi le brief d'un petit projet en Node (sans bibliothèque externe) qui m'oblige à utiliser `map`, `filter` et `reduce` sur des données réelles : un script qui lit un fichier JSON de transactions et produit un rapport mensuel en texte dans le terminal (total, total par catégorie, top 3, pourcentages, moyenne). Donne-moi **uniquement les spécifications et les cas limites à gérer**, pas le code. »

Ce second exercice a un intérêt particulier : il produit quelque chose de **réutilisable** pour ton projet 1, et les cas limites qu'il te fera lister (fichier vide, catégorie absente, montant à zéro, division par zéro) sont précisément ceux qu'on oublie.

Garde en tête la règle du palier : à ce stade, **zéro code généré**. L'IA fabrique les énoncés et critique tes réponses ; elle n'écrit pas les solutions.

---

## 🛠️ À faire

> Utilise le jeu de 6 dépenses de la leçon 04. **Chaque exercice en une seule expression chaînée**, sans boucle `for`.

1. La liste des montants seuls.
2. Les descriptions en majuscules.
3. Les dépenses de la catégorie `"food"`.
4. Les dépenses de plus de 1 000, triées par montant décroissant.
5. Le total général.
6. Le total de la catégorie `"transport"`.
7. Un objet `{ categorie: total }` pour toutes les catégories.
8. Un objet `{ categorie: nombreDeDepenses }`.
9. La dépense la plus élevée (l'objet complet).
10. La moyenne des montants, arrondie, et `0` si le tableau est vide.
11. La liste des catégories sans doublon — deux façons : avec `reduce`, puis avec `Set`.
12. Un index `{ id: depense }`.
13. Les 3 plus grosses dépenses, formatées en `"description : 1 500 FCFA"`.
14. Le pourcentage que représente chaque catégorie dans le total.
15. `true` s'il existe au moins une dépense dépassant un budget donné.
16. **Réécris en chaîne** ce code impératif :
    ```js
    let resultat = [];
    for (let i = 0; i < depenses.length; i++) {
      if (depenses[i].montant > 0 && depenses[i].categorie !== "autre") {
        resultat.push(depenses[i].description + " (" + depenses[i].montant + ")");
      }
    }
    resultat.sort();
    ```
17. **L'exercice qui prouve que tu as compris** : implémente `monMap`, `monFilter` et `monReduce` à la main, avec une boucle `for`, sans utiliser les versions natives.
18. **L'exercice de test technique** : reprends le jeu de 20 commandes généré par l'IA et produis le chiffre d'affaires par client, trié décroissant, pour un mois donné. Chronomètre-toi : la cible est 15 minutes.

<details>
<summary>Corrections</summary>

```js
// 1
depenses.map(d => d.montant);
// 2
depenses.map(d => d.description.toUpperCase());
// 3
depenses.filter(d => d.categorie === "food");
// 4
depenses.filter(d => d.montant > 1000).sort((a, b) => b.montant - a.montant);
// 5
depenses.reduce((s, d) => s + d.montant, 0);
// 6
depenses.filter(d => d.categorie === "transport").reduce((s, d) => s + d.montant, 0);
// 7
depenses.reduce((acc, d) => { acc[d.categorie] = (acc[d.categorie] ?? 0) + d.montant; return acc; }, {});
// 8
depenses.reduce((acc, d) => { acc[d.categorie] = (acc[d.categorie] ?? 0) + 1; return acc; }, {});
// 9
depenses.reduce((max, d) => (d.montant > max.montant ? d : max));      // ⚠️ exception si vide
// 10
depenses.length === 0 ? 0 : Math.round(depenses.reduce((s, d) => s + d.montant, 0) / depenses.length);
// 11
depenses.reduce((acc, d) => (acc.includes(d.categorie) ? acc : [...acc, d.categorie]), []);
[...new Set(depenses.map(d => d.categorie))];                          // bien plus lisible
// 12
depenses.reduce((acc, d) => ({ ...acc, [d.id]: d }), {});
// 13
[...depenses].sort((a, b) => b.montant - a.montant).slice(0, 3)
  .map(d => `${d.description} : ${d.montant.toLocaleString("fr-FR")} FCFA`);
// 15
depenses.some(d => d.montant > budget);
// 16
depenses
  .filter(d => d.montant > 0 && d.categorie !== "autre")
  .map(d => `${d.description} (${d.montant})`)
  .sort();
```

**14 — et la leçon de lisibilité.** On peut tout écrire en une expression :
```js
(() => {
  const total = depenses.reduce((s, d) => s + d.montant, 0);
  return Object.entries(
    depenses.reduce((acc, d) => { acc[d.categorie] = (acc[d.categorie] ?? 0) + d.montant; return acc; }, {})
  ).map(([cat, montant]) => ({ cat, pct: Math.round((montant / total) * 100) }));
})();
```
Si cette expression te paraît tordue, c'est qu'elle l'est. **Voilà la version qu'on attend en revue de code :**
```js
const total = depenses.reduce((s, d) => s + d.montant, 0);
const totauxParCategorie = depenses.reduce((acc, d) => {
  acc[d.categorie] = (acc[d.categorie] ?? 0) + d.montant;
  return acc;
}, {});
const pourcentages = Object.entries(totauxParCategorie)
  .map(([categorie, montant]) => ({ categorie, pct: Math.round((montant / total) * 100) }));
```
Trois étapes nommées, chacune lisible seule et testable seule. **C'est ça, savoir s'arrêter.**

**17 — l'exercice clé.**
```js
function monMap(tableau, callback) {
  const resultat = [];
  for (let i = 0; i < tableau.length; i++) resultat.push(callback(tableau[i], i, tableau));
  return resultat;
}

function monFilter(tableau, callback) {
  const resultat = [];
  for (let i = 0; i < tableau.length; i++) {
    if (callback(tableau[i], i, tableau)) resultat.push(tableau[i]);
  }
  return resultat;
}

function monReduce(tableau, callback, valeurInitiale) {
  let acc = valeurInitiale;
  let debut = 0;
  if (acc === undefined) {                       // comportement natif : sans valeur initiale…
    if (tableau.length === 0) throw new TypeError("Reduce of empty array with no initial value");
    acc = tableau[0];                            // …on prend le premier élément
    debut = 1;
  }
  for (let i = debut; i < tableau.length; i++) acc = callback(acc, tableau[i], i, tableau);
  return acc;
}
```
Ce que tu viens de démontrer : il n'y a **aucune magie**. `map` est une boucle qui empile, `filter` une boucle qui empile sous condition, `reduce` une boucle avec une variable qui se transporte. Et tu viens de coder toi-même la raison pour laquelle `reduce` plante sur un tableau vide sans valeur initiale — tu ne l'oublieras plus.

**18 — le format test technique.**
```js
function chiffreAffairesParClient(commandes, mois) {      // mois au format "2026-10"
  const duMois = commandes.filter(c => c.date.startsWith(mois));
  const parClient = duMois.reduce((acc, c) => {
    acc[c.client] = (acc[c.client] ?? 0) + c.montant;
    return acc;
  }, {});
  return Object.entries(parClient)
    .map(([client, total]) => ({ client, total }))
    .sort((a, b) => b.total - a.total);
}
```
Si tu as mis plus de 25 minutes, refais l'exercice demain avec d'autres données. L'objectif n'est pas de trouver la solution : c'est de l'écrire **sans hésiter**.
</details>

---

## ✅ Acquis si…

- [ ] J'écris `map`, `filter` et `reduce` **sans consulter la documentation**.
- [ ] Je choisis entre les trois d'après le nombre d'éléments attendus en sortie.
- [ ] Je construis un objet de totaux par catégorie avec `reduce`, de tête.
- [ ] Je fournis toujours la valeur initiale de `reduce`, et je sais expliquer pourquoi.
- [ ] Je chaîne `filter` → `map` → `sort` → `slice`, et je sais pourquoi `filter` vient en premier.
- [ ] Je sais **couper une chaîne trop longue** en étapes nommées.
- [ ] J'ai réimplémenté les trois méthodes à la main (exercice 17).
- [ ] L'exercice de test technique (18) me prend moins de 20 minutes.
- [ ] Je sais citer les équivalents de ces trois outils en SQL, et dans au moins un autre langage.
- [ ] Je sais dans quels cas une boucle `for...of` reste le bon choix.

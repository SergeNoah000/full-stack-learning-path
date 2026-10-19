# Leçon 12 — Structures de données et complexité

> 🎯 **À la fin de cette leçon** : tu choisis la bonne structure de données et tu reconnais, à la lecture, un code qui ne passera pas l'échelle.
> ⏱️ 4 h · **Prérequis** : leçons 04 et 06. **Dernière leçon du palier.**

---

## De quoi on parle

Une **structure de données** est une façon d'organiser des données pour les manipuler efficacement. Tu en connais déjà quatre : le tableau, l'objet, la `Map` et le `Set` (leçon 04). On en ajoute deux, conceptuelles : la **pile** (*stack*, dernier entré premier sorti) et la **file** (*queue*, premier entré premier sorti).

La **complexité temporelle** décrit comment le temps d'exécution évolue quand la taille des données grandit. On l'exprime en **notation Big O** : `O(1)`, `O(n)`, `O(n²)`. C'est un **ordre de grandeur**, pas une mesure : `O(n)` ne dit pas « une seconde », il dit « si je double les données, je double le temps ».

Et la **mémoïsation** consiste à garder en cache les résultats déjà calculés — tu l'as écrite à la leçon 05.

---

## À quoi ça sert, concrètement

**Parce que du code qui « marche » peut être inutilisable.** C'est le point entier de la leçon. Regarde cette table :

| Complexité | Nom | 10 éléments | 1 000 | 1 000 000 | Exemple |
|------------|-----|-------------|-------|-----------|---------|
| `O(1)` | constante | 1 | 1 | 1 | `tableau[5]`, `map.get(cle)` |
| `O(log n)` | logarithmique | 3 | 10 | 20 | recherche dichotomique, index de base |
| `O(n)` | linéaire | 10 | 1 000 | 1 000 000 | `filter`, `includes`, une boucle |
| `O(n log n)` | — | 30 | 10 000 | 20 000 000 | `sort` |
| `O(n²)` | quadratique | 100 | 1 000 000 | **10¹²** 💀 | boucle dans une boucle |
| `O(2^n)` | exponentielle | 1 024 | 💀 | 💀 | fibonacci naïf |

*(Cette table est une référence : reviens-y, ne la mémorise pas.)*

Lis la colonne « 1 000 000 ». En `O(n)`, le traitement termine. En `O(n²)`, il ne terminera jamais. **Et les deux codes passent tes tests sur dix éléments.** C'est précisément ce qui rend ces bugs dangereux : ils n'apparaissent qu'en production, quand les données ont grandi.

**Parce que la correction est presque toujours la même.** Tu n'as pas besoin de théorie : tu as besoin de reconnaître **deux situations** et d'appliquer **une** correction. Les deux situations sont la boucle dans une boucle, et la recherche linéaire répétée. La correction est l'index.

---

## Où ça intervient dans le développement

Cette leçon prépare directement trois choses, et c'est pour ça qu'elle clôt le palier.

**Les index de base de données, au palier 4.** Un index SQL fait exactement ce que fait une `Map` : il paie de la mémoire et des écritures plus lentes pour rendre les recherches quasi instantanées. Quand tu écriras `CREATE INDEX`, tu sauras pourquoi. Et quand une requête sera lente, tu sauras quoi chercher.

**Les tests techniques d'entretien.** Les exercices d'algorithmie que tu rencontreras — et le rituel de katas que tu tiens depuis la leçon 01 — portent presque tous sur ce sujet. On ne te demandera pas de calculer une complexité, on te demandera d'écrire une solution qui n'est pas quadratique.

**L'architecture, au palier 7.** La scalabilité, le caching, la pagination découlent de la même question : qu'est-ce qui grandit, et à quelle vitesse ? La pagination existe parce qu'une réponse en `O(n)` sur une table qui grandit finit par saturer le réseau et le navigateur.

Et il y a un endroit où ça intervient dès maintenant, de façon invisible : **tes propres choix de structure**. Stocker tes dépenses dans un tableau et les chercher par identifiant avec `find` fonctionne parfaitement sur six éléments. Sur dix mille, c'est un problème. La décision se prend en écrivant, pas après.

> ⚠️ **Et le principe inverse, qui compte autant** : ne complique pas un code qui traite cinquante éléments. Un `O(n²)` sur cinquante éléments fait 2 500 opérations — invisible. L'optimisation prématurée est un défaut de conception, pas une qualité (c'est le principe YAGNI, palier 7). **Mesure d'abord** avec `console.time`, optimise ensuite.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas mesurer. C'est l'exercice principal de la leçon : construire un tableau de cent mille éléments, chronométrer deux approches, et constater un rapport de cent ou mille. Lire que « `find` est en `O(n)` » ne produit aucune conviction ; voir 2 400 ms devenir 3 ms en produit une définitive.

### En équipe, en entreprise

**On te parlera de performance en termes de symptômes, pas de complexité.** « Cette page met huit secondes à charger », « l'export plante au-delà de mille lignes », « ça rame quand on tape dans le champ de recherche ». Ton travail sera de remonter du symptôme à la cause — et la cause est très souvent dans cette leçon.

**Les deux coupables habituels** sont toujours les mêmes, et tu les reconnaîtras : une recherche dans une boucle (le `find` imbriqué), et un traitement non paginé sur un jeu de données qui a grandi.

**On ne te demandera pas de calculer des complexités.** Personne ne fait ça au quotidien. On attend de toi que tu **reconnaisses** le motif dangereux à la lecture, et que tu saches le corriger.

**Et tu rencontreras les files de tâches**, au palier 6 avec Laravel et au palier 7 en architecture. Ce sont les files de cette leçon, à l'échelle d'un système : on dépose un travail long, un ouvrier le traite plus tard.

### Ce qui sert tout le temps, et ce qui est rare

Au quotidien, même sans le nommer : choisir entre tableau et objet selon la façon dont on accède aux données, et construire un index quand on cherche souvent.

Régulièrement : reconnaître une boucle imbriquée, utiliser un `Set` pour tester l'appartenance ou dédoublonner, mémoïser un calcul coûteux, mesurer avec `console.time`.

Rare, et sans intérêt pour toi aujourd'hui : implémenter des arbres, des graphes, des tables de hachage ou des algorithmes de tri. C'est le contenu des cours d'informatique classiques, et c'est utile — mais un développeur d'applications ne les écrit pas : il utilise `sort`, `Map` et une base de données. **Les écrire pour les comprendre est un bon exercice ; les apprendre par cœur pour un entretien junior est une perte de temps.** Deux exceptions que tu feras ici : la pile et la file, parce qu'elles ont des usages quotidiens.

---

## La mécanique

### Le réflexe à installer : de la recherche à l'index

```js
// ❌ O(n × m) : pour chaque dépense, on reparcourt tout le tableau des catégories
depenses.map(d => ({
  ...d,
  nomCategorie: categories.find(c => c.id === d.categorieId)?.nom,
}));

// ✅ O(n + m) : on construit un index une fois, puis chaque accès est O(1)
const index = new Map(categories.map(c => [c.id, c.nom]));
depenses.map(d => ({ ...d, nomCategorie: index.get(d.categorieId) }));
```

Sur mille dépenses et cent catégories : cent mille opérations contre mille cent. **Cette transformation — recherche répétée vers index — est le gain de performance le plus fréquent de toute une carrière.** Apprends à la reconnaître, c'est l'essentiel de la leçon.

### Tableau, objet, Map, Set : comment choisir

La question n'est pas « quelle structure est la meilleure » mais « **comment vais-je accéder à ces données ?** ».

Un **tableau** donne l'accès par **position** en `O(1)` et se parcourt naturellement dans l'ordre. Mais chercher une valeur dedans est `O(n)`, et insérer ou supprimer au début ou au milieu est `O(n)` aussi, puisqu'il faut décaler tout le reste.

Un **objet** ou une **`Map`** donne l'accès par **clé** en `O(1)`, ainsi que l'insertion et la suppression. En revanche il n'y a pas d'ordre naturel de parcours (la `Map` préserve l'ordre d'insertion, l'objet à peu près).

Un **`Set`** teste l'appartenance en `O(1)` — contre `O(n)` pour `includes` sur un tableau — et garantit l'unicité.

**La règle pratique** : une **liste** qu'on parcourt → tableau. Un **annuaire** où l'on cherche par identifiant → objet ou `Map`. Un **ensemble** dont on teste l'appartenance → `Set`.

```js
// 10 000 dépenses, et on cherche souvent par id
const parId = new Map(depenses.map(d => [d.id, d]));
parId.get(4823);                      // O(1) — instantané
depenses.find(d => d.id === 4823);    // O(n) — jusqu'à 10 000 comparaisons
```

### Pile et file

```js
// PILE (LIFO) — dernier entré, premier sorti
const pile = [];
pile.push("page1"); pile.push("page2");
pile.pop();                             // "page2"
```

Usages réels, et ils sont partout : le bouton « retour » d'un navigateur, `Ctrl+Z`, **la pile d'appels** de la leçon 11, l'évaluation d'expressions, la vérification de parenthèses équilibrées (exercice 3), et le parcours en profondeur d'une arborescence.

```js
// FILE (FIFO) — premier entré, premier sorti
const file = [];
file.push("tache1"); file.push("tache2");
file.shift();                           // "tache1" — ⚠️ O(n) sur un tableau JS
```

Usages réels : les **files de tâches** (envois d'emails, exports — palier 6 et 7), l'event loop lui-même (leçon 11), les files d'impression, le traitement de requêtes dans l'ordre d'arrivée.

Note le `shift()` en `O(n)` : il décale tous les éléments d'un cran. Sur quelques milliers d'éléments c'est sans importance, mais sache **pourquoi** — c'est le genre de détail qu'on peut te demander, et la solution professionnelle est une liste chaînée ou un index de tête.

### La recherche dichotomique : `O(log n)`

```js
// Prérequis : le tableau doit être TRIÉ
function rechercheDichotomique(triee, cible) {
  let bas = 0, haut = triee.length - 1;
  while (bas <= haut) {
    const milieu = Math.floor((bas + haut) / 2);
    if (triee[milieu] === cible) return milieu;
    if (triee[milieu] < cible) bas = milieu + 1;
    else haut = milieu - 1;
  }
  return -1;
}
```

Sur un million d'éléments : **vingt comparaisons** au lieu d'un million. Et c'est le même principe que la devinette de la leçon 02, que `git bisect`, et que la méthode de débogage « couper le problème en deux » du [guide](../../guides/deboguer-methodiquement.md). **Un concept, quatre applications** — c'est exactement ce que ce parcours cherche à te faire voir.

C'est aussi ce que fait un **index de base de données** : il maintient les données triées pour pouvoir chercher par dichotomie au lieu de tout parcourir. Au palier 4, tu sauras donc ce que `CREATE INDEX` fabrique réellement.

### Mémoïsation : échanger de la mémoire contre du temps

```js
// fibonacci naïf : O(2^n) — fib(40) prend environ une minute
const fib = n => (n <= 1 ? n : fib(n - 1) + fib(n - 2));

// mémoïsé : O(n) — fib(40) est instantané
const cache = new Map();
function fibRapide(n) {
  if (n <= 1) return n;
  if (cache.has(n)) return cache.get(n);
  const r = fibRapide(n - 1) + fibRapide(n - 2);
  cache.set(n, r);
  return r;
}
```

Même idée que le cache de requêtes de la leçon 10, et que le caching du palier 7 : **ne jamais recalculer ce qu'on sait déjà**.

### Les motifs à reconnaître d'un coup d'œil

Une **boucle simple** sur `n` est `O(n)` : normal, c'est le prix de parcourir des données.

**Deux boucles imbriquées** sur `n` sont `O(n²)` : suspect dès quelques milliers d'éléments.

Un **`find`, `includes` ou `indexOf` à l'intérieur** d'une boucle, d'un `map` ou d'un `filter` est `O(n²)` déguisé — et c'est le cas le plus fréquent, parce qu'il **ne ressemble pas** à deux boucles imbriquées. C'est celui qu'il faut apprendre à voir.

`sort` est `O(n log n)` : acceptable, mais ne trie jamais **à l'intérieur** d'une boucle.

Deux boucles **successives** (pas imbriquées) restent `O(n)` : l'ordre de grandeur ignore les constantes, donc `O(2n)` est `O(n)`. C'est pour ça que chaîner `filter` puis `map` puis `reduce` ne pose aucun problème (leçon 06).

Et une **récursion** sur des sous-problèmes qui se répètent est exponentielle : il faut mémoïser.

---

## Les problèmes que tu vas rencontrer

**Ton code marche en test et rame en production.** C'est le symptôme caractéristique. Cherche une boucle imbriquée ou un `find` dans une boucle.

**Ton navigateur se fige en tapant dans un champ de recherche.** Tu refiltres un gros tableau à chaque frappe, de façon synchrone (leçon 11). Deux corrections cumulables : un *debounce* (leçon 05) et un index.

**Ta `Map` ne trouve rien alors que la clé « est la bonne ».** `Map` compare par identité : `map.get("5")` et `map.get(5)` sont deux clés différentes, et un objet comme clé ne fonctionne que si c'est **le même** objet (leçon 04 : la référence).

**Ton `Set` ne dédoublonne pas tes objets.** Même raison : deux objets au contenu identique sont deux valeurs distinctes. Pour dédoublonner des objets, il faut passer par une clé primitive : `new Map(items.map(i => [i.id, i]))`.

**Ton `shift()` ralentit avec le volume.** `O(n)`. Sur de grandes files, change de structure.

**Tu as « optimisé » un code qui n'en avait pas besoin, et il est devenu illisible.** C'est une vraie erreur, et elle est plus fréquente que l'inverse chez les gens qui viennent d'apprendre cette leçon. Mesure d'abord.

**Ton `JSON.parse` sur un gros fichier gèle tout.** C'est du synchrone (leçon 11). Pour de très gros volumes, il faut un traitement en flux — mais c'est un sujet de palier 4.

---

## Ce qu'on te demandera

En **test technique**, c'est systématique sans être nommé : on te donnera un problème dont la solution naïve est quadratique, et la solution attendue linéaire. L'exemple le plus connu est « trouve les deux nombres de ce tableau dont la somme vaut `n` » : la solution naïve est une double boucle, la solution attendue utilise une `Map`. Si tu reconnais le motif, tu la trouves ; sinon, tu rends la version lente.

En **entretien oral** : « que signifie `O(n²)` ? », « quelle différence de complexité entre chercher dans un tableau et dans une `Map` ? », « comment optimiserais-tu ce code ? », « à quoi sert un index de base de données ? » (et c'est la même réponse).

Les **katas** que tu fais depuis la leçon 01 portent presque tous là-dessus, et c'est pourquoi l'objectif de sortie du palier est un Codewars 7 kyu résolu seul.

---

## Ce qui te démarquera

**Reconnaître le `find` dans une boucle.** C'est **le** motif qu'il faut savoir voir, parce qu'il est invisible pour la plupart des juniors — il n'a pas l'air d'une double boucle. Le repérer en revue de code fait une excellente impression.

**Mesurer avant d'affirmer.** « J'ai chronométré : 2 400 ms avec `find`, 3 ms avec une `Map` » clôt n'importe quelle discussion.

**Savoir dire quand ça ne vaut pas la peine.** « On est sur cinquante éléments, la version simple est plus lisible, je la garde » est un jugement d'ingénieur, pas un manque de rigueur. Savoir **ne pas** optimiser est aussi recherché que savoir optimiser.

**Faire le lien avec la base de données.** Dire « c'est le même principe qu'un index SQL » montre que tu as compris le concept au-delà de JavaScript — et tu l'auras vérifié au palier 4.

**Connaître un usage réel de la pile et de la file.** Pas la définition : l'usage. « La pile, c'est le bouton retour et la pile d'appels ; la file, c'est l'envoi d'emails en arrière-plan. »

---

## 📚 À lire

**javascript.info** chapitres 5.4 (tableaux) et 7.1 (`Map` et `Set`) — les sections de comparaison avec les objets sont les plus utiles.

**MDN → `Map`** et **`Set`**, notamment les tableaux de comparaison des performances.

**bigocheatsheet.com** — à **survoler**, pas à mémoriser. Garde-le en favori comme référence.

Et un conseil plus efficace qu'une lecture : va voir une **animation d'algorithmes de tri** (VisuAlgo, ou n'importe quel *sorting visualizer*). Voir un tri à bulles ramer là où un tri rapide termine instantanément vaut dix explications écrites.

📌 Ce sujet revient au **palier 4** (index SQL) et au **palier 7** (scalabilité, caching, pagination). Ici, on installe l'intuition.

---

## 🤖 Le mini-projet à demander à l'IA

C'est la leçon où la **mesure** est l'exercice. Fais fabriquer le terrain :

> « Je suis en formation de développeur, palier 1 (JavaScript, Node). Je travaille la complexité. Donne-moi un script de génération de données (100 000 commandes avec `id`, `clientId`, `montant`) **et** une liste de **8 tâches** à réaliser dessus. Pour chaque tâche, je dois écrire **deux** versions — une naïve et une optimisée — puis chronométrer les deux avec `console.time` et noter le rapport. **Ne me donne aucun code**, seulement les énoncés, et dis-moi pour chacun quel rapport approximatif je devrais observer si je m'y prends bien. »

Le fait d'annoncer le rapport attendu est utile : si tu mesures un facteur 1,2 alors qu'on t'annonçait 300, c'est que ton optimisation n'en est pas une.

Puis l'entraînement au format entretien :

> « Pose-moi **10 problèmes de type test technique junior** dont la solution naïve est quadratique et la solution attendue linéaire (deux sommes, doublons, intersection de deux listes, premier caractère non répété, groupements…). Donne-moi l'énoncé seul. Quand je te soumets ma solution, dis-moi **sa complexité** et, si elle est quadratique, pose-moi une question qui m'oriente vers l'index — sans me donner la solution. »

---

## 🛠️ À faire

1. **Mesure l'écart** : crée un tableau de 100 000 dépenses, puis cherche 1 000 identifiants (a) avec `find` sur le tableau, (b) via une `Map`. Chronomètre les deux et note le rapport dans ton journal.
2. Écris `dedoublonner(tableau)` de deux façons : avec `filter` + `indexOf`, puis avec un `Set`. Donne la complexité de chacune et mesure sur 50 000 éléments.
3. Implémente une **pile** (`empiler`, `depiler`, `sommet`, `estVide`), puis utilise-la pour écrire `parenthesesEquilibrees("({[]})")` → `true`, `"(]"` → `false`.
4. Implémente une **file** avec deux piles (exercice d'entretien classique).
5. `fibonacci` naïf contre mémoïsé : mesure `fib(35)` dans les deux versions et note l'écart.
6. Écris `rechercheDichotomique` et vérifie-la sur un million d'entiers. **Ajoute un compteur** et affiche le nombre réel d'itérations.
7. **Trouve et corrige le `O(n²)`** :
   ```js
   function enrichir(depenses, categories) {
     return depenses.map(d => ({
       ...d,
       nomCategorie: categories.find(c => c.id === d.categorieId)?.nom ?? "inconnue",
     }));
   }
   ```
8. **Analyse** : donne la complexité de chaque extrait et **justifie**.
   ```js
   // a
   for (const d of depenses) total += d.montant;
   // b
   for (const a of depenses) for (const b of depenses) if (a.id !== b.id && a.montant === b.montant) doublons.push([a, b]);
   // c
   depenses.filter(d => d.montant > 0).map(d => d.montant).reduce((s, m) => s + m, 0);
   // d
   const uniques = depenses.filter((d, i) => depenses.findIndex(x => x.id === d.id) === i);
   ```
9. **Le classique d'entretien** : écris `deuxSommes(nombres, cible)` qui retourne les index des deux nombres dont la somme vaut `cible`. D'abord la version naïve, puis la version `O(n)`. Mesure les deux sur 50 000 éléments.
10. **L'exercice de jugement** : prends le code de l'exercice 7 et suppose qu'il ne traitera **jamais** plus de trente catégories et cinquante dépenses. Faut-il l'optimiser ? Justifie ta réponse par écrit.

<details>
<summary>Corrections</summary>

**1.** Attends-toi à un rapport de l'ordre de cent à mille fois. C'est **exactement** ce que fait un index de base de données : on paie une construction et un peu de mémoire pour rendre les recherches instantanées. Garde ce chiffre en tête, il te servira en entretien.

**2.** `filter` + `indexOf` est `O(n²)` (un parcours dans un parcours). La version `Set` est `O(n)` : `[...new Set(tableau)]`. Sur 50 000 éléments, la première prend plusieurs secondes, la seconde quelques millisecondes.

**3.**
```js
function parenthesesEquilibrees(chaine) {
  const paires = { ")": "(", "]": "[", "}": "{" };
  const pile = [];
  for (const c of chaine) {
    if ("([{".includes(c)) pile.push(c);
    else if (c in paires) {
      if (pile.pop() !== paires[c]) return false;    // mauvaise fermeture
    }
  }
  return pile.length === 0;                           // tout a été refermé
}
```
C'est l'usage emblématique d'une pile — et exactement ce que fait ton éditeur pour colorer les paires de parenthèses.

**7.**
```js
function enrichir(depenses, categories) {
  const index = new Map(categories.map(c => [c.id, c.nom]));      // O(m), une seule fois
  return depenses.map(d => ({ ...d, nomCategorie: index.get(d.categorieId) ?? "inconnue" }));
}                                                                  // O(n + m)
```

**8.** (a) `O(n)` — une seule boucle. (b) `O(n²)` — boucles imbriquées ; sur 10 000 dépenses, cent millions de comparaisons. La version linéaire regroupe par montant dans une `Map`. (c) `O(n)` — trois parcours **successifs**, donc `O(3n)` = `O(n)` : l'ordre de grandeur ignore les constantes. (d) `O(n²)` — `findIndex` **dans** un `filter` : le piège classique, et il ne ressemble pas à une double boucle. Préfère `[...new Map(depenses.map(d => [d.id, d])).values()]`, qui est `O(n)`.

**9.**
```js
// naïf : O(n²)
function deuxSommesNaif(nombres, cible) {
  for (let i = 0; i < nombres.length; i++)
    for (let j = i + 1; j < nombres.length; j++)
      if (nombres[i] + nombres[j] === cible) return [i, j];
  return null;
}

// optimisé : O(n) — un seul parcours, avec un index des valeurs déjà vues
function deuxSommes(nombres, cible) {
  const vus = new Map();                     // valeur → index
  for (let i = 0; i < nombres.length; i++) {
    const complement = cible - nombres[i];
    if (vus.has(complement)) return [vus.get(complement), i];
    vus.set(nombres[i], i);
  }
  return null;
}
```
C'est **le** problème d'entretien le plus posé au monde, et son idée centrale est celle de toute la leçon : au lieu de rechercher, on **se souvient** de ce qu'on a déjà vu.

**10.** La réponse attendue est **non**. Trente fois cinquante font 1 500 opérations : rigoureusement invisible. L'ajout d'un index ici n'apporte aucun gain mesurable et ajoute une ligne à comprendre. La bonne réponse complète est : « je ne l'optimise pas, mais je note que si le volume change d'ordre de grandeur, c'est le premier endroit à regarder ». Savoir **ne pas** optimiser, et savoir dire pourquoi, est un signe de maturité technique — c'est le principe YAGNI du palier 7.
</details>

---

## ✅ Acquis si…

- [ ] J'explique `O(1)`, `O(n)` et `O(n²)` avec un exemple de **mon** code pour chacune.
- [ ] Je repère un `find` ou un `includes` **à l'intérieur** d'une boucle ou d'un `map`.
- [ ] Je transforme une recherche répétée en index (`Map`/`Set`), et j'ai **mesuré** le gain.
- [ ] Je choisis entre tableau, objet, `Map` et `Set` en justifiant par la façon dont j'accède aux données.
- [ ] J'implémente une pile et une file, et je cite un usage réel de chacune.
- [ ] J'ai mémoïsé une fonction récursive et mesuré l'écart.
- [ ] J'ai résolu « deux sommes » en `O(n)`.
- [ ] Je sais pourquoi on **ne doit pas** optimiser un traitement de cinquante éléments.
- [ ] Je sais faire le lien entre une `Map` et un index de base de données.
- [ ] 🚦 **Je suis prêt pour l'[épreuve de sortie du palier](../evaluation.md).**

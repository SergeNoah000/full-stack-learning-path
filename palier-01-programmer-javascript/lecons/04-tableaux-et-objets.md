# Leçon 04 — Tableaux et objets

> 🎯 **À la fin de cette leçon** : tu modélises des données réelles et tu les manipules sans les corrompre — ce qui veut dire que tu auras compris la différence entre valeur et référence, la cause des bugs les plus déroutants du débutant.
> ⏱️ 5 h · **Prérequis** : leçons 01–03.

---

## De quoi on parle

Un **tableau** est une liste **ordonnée**, indexée à partir de zéro. Un **objet** est un ensemble de paires **clé → valeur**, sans ordre significatif. Une **propriété** est l'une de ces paires ; une **méthode** est une propriété dont la valeur est une fonction.

Trois notions vont dominer la leçon, et ce sont elles qui comptent vraiment.

La **référence** : contrairement aux nombres et aux chaînes, les objets et les tableaux ne sont pas copiés quand on les affecte. La variable contient l'**adresse** de la structure, pas la structure elle-même. Deux variables peuvent donc désigner le même objet.

La **mutation** : modifier une structure existante (`push`, `splice`, `sort`) au lieu d'en créer une nouvelle.

La **copie superficielle ou profonde** : copier seulement le premier niveau, ou copier récursivement tous les niveaux imbriqués.

Et autour, le **JSON**, format texte d'échange : `JSON.stringify` pour sérialiser, `JSON.parse` pour désérialiser.

---

## À quoi ça sert, concrètement

**Parce que c'est la forme de toutes tes données.** Un tableau d'objets est ce que te renvoie une API, ce que te renvoie une base de données, ce que tu affiches dans une liste, ce que tu enregistres dans un fichier. Ce n'est pas une structure parmi d'autres : c'est **la** structure du développement d'applications.

```js
const depenses = [
  { id: 1, montant: 1500, categorie: "food", description: "déjeuner", date: "2026-10-17" },
  { id: 2, montant: 3000, categorie: "transport", description: "taxi", date: "2026-10-17" },
];
```

**Parce que la référence est la cause de bugs que tu ne sauras pas expliquer.** « J'ai modifié ma copie et l'original a changé » est l'incompréhension la plus classique du débutant, et elle vient du fait qu'il n'y avait pas de copie. Comprendre ce mécanisme une fois t'évite des heures de perplexité, et pas seulement en JavaScript : Python, PHP et Dart ont le même comportement.

**Parce que la décision « muter ou pas » devient obligatoire au palier 3.** En React, muter l'état ne provoque **aucun réaffichage** : l'interface se désynchronise des données, silencieusement, et c'est un bug très difficile à diagnostiquer quand on n'a pas compris la référence. Ce que tu apprends ici est un prérequis strict.

---

## Où ça intervient dans le développement

Deux endroits précis, et ils structurent tout ce qui suit.

**Le modèle de données, c'est-à-dire la forme de ton application.** Décider si une dépense a un `id`, si la catégorie est une chaîne ou un objet, si les dates sont des chaînes ou des `Date` : ces choix se font ici, et ils se propagent partout. Au palier 4, tu les traduiras en tables de base de données ; au palier 3, en types TypeScript. Un modèle mal choisi se paie à chaque couche.

**La frontière entre structures en mémoire et données persistées.** Voici le trajet, et il explique pourquoi `JSON` est dans cette leçon :

```
   objets et tableaux          JSON.stringify          texte
   en mémoire          ────────────────────────▶   (fichier, réseau, base)
   (ce que ton code      ◀────────────────────────
    manipule)                 JSON.parse
```

Chaque fois que tes données **sortent** de ton programme — vers un fichier (ton projet 1), vers le réseau (palier 2 et 4), vers `localStorage` (palier 2) — elles passent par ce goulot et perdent tout ce que JSON ne connaît pas : les fonctions, les `Date` (qui redeviennent des chaînes), `undefined`. C'est une frontière, au sens de la leçon 01, et c'est là qu'il faut convertir et valider.

Et une remarque qui prépare le palier 12 : le **choix** entre tableau et objet est une décision de performance. Un tableau se parcourt (`O(n)`), un objet ou une `Map` se consulte par clé (`O(1)`). Sur dix éléments, aucune importance ; sur dix mille, c'est la différence entre instantané et inutilisable.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas construire ton jeu de données de dépenses, et il va te servir pour toutes les leçons suivantes et pour ton projet 1. Soigne-le : donne un `id` à chaque élément, choisis le format de date `YYYY-MM-DD` (parce qu'il se trie correctement comme une chaîne — c'est une astuce que tu réutiliseras souvent), garde les montants en centimes entiers (leçon 01).

Tu vas aussi rencontrer le bug de la référence, probablement sans comprendre tout de suite. Les exercices sont faits pour te le faire provoquer volontairement.

### En équipe, en entreprise

Trois choses t'attendent.

**L'immuabilité est une norme, pas une préférence.** Dans la plupart des bases de code modernes, on évite de muter : on recrée. Non par dogme, mais parce qu'une structure qui ne change pas sous tes pieds est une structure dont on peut raisonner — et parce que React, Redux et les outils de gestion d'état en dépendent. Tu verras des linters qui interdisent `push` dans certains contextes.

**Le modèle de données se discute avant le code.** « On met la catégorie comme chaîne ou comme référence vers une table ? » est une question qu'on tranche en réunion, parce que la réponse engage tout le reste. C'est le fil rouge gestion de projet, et c'est pour ça que ton cahier des charges du palier 4 contiendra une section « modèle de données ».

**`structuredClone` et les copies profondes sont un sujet récurrent.** Le fameux `JSON.parse(JSON.stringify(obj))` traîne partout dans les anciens tutoriels : il fonctionne, mais il détruit les dates et les fonctions. `structuredClone` est la réponse moderne.

### Ce qui sert tout le temps, et ce qui est rare

Au quotidien : l'accès par index et par clé, `length`, `push`, le spread (`[...t]`, `{...o}`), `find`, `includes`, `Object.keys/values/entries`, `JSON.stringify/parse`.

Régulièrement : `slice`, `at(-1)`, `sort` avec comparateur, `some`, `every`, le chaînage optionnel, `Set` pour dédoublonner.

Rare, et à ignorer pour l'instant : `Object.freeze`, `Object.assign` (remplacé par le spread), `reduceRight`, les `WeakMap`, les prototypes et l'héritage, `Symbol.iterator`. Et un conseil : `Map` est utile mais tu peux commencer avec de simples objets — ne t'encombre pas avant d'avoir rencontré le besoin.

---

## La mécanique

### Choisir sa structure

La question à se poser est toujours la même : **comment vais-je accéder à ces données ?**

Une **liste** d'éléments du même genre, qu'on parcourt dans l'ordre → un **tableau**. Décrire **une** chose par ses attributs → un **objet**. Retrouver rapidement par identifiant → un **objet ou une `Map`** (`depensesParId[42]`). Un ensemble de valeurs uniques dont on teste l'appartenance → un **`Set`**.

### ⚠️ Valeur et référence : le cœur de la leçon

```js
// PRIMITIFS : copiés par VALEUR
let a = 5;
let b = a;
b = 10;
console.log(a);          // 5 — a est intact

// OBJETS ET TABLEAUX : copiés par RÉFÉRENCE
const liste1 = [1, 2, 3];
const liste2 = liste1;    // ⚠️ PAS une copie : les deux noms désignent LE MÊME tableau
liste2.push(4);
console.log(liste1);      // [1, 2, 3, 4]  😱
```

Il n'y a jamais eu de copie. `liste1` et `liste2` sont deux étiquettes sur la même boîte — exactement comme une branche Git est une étiquette sur un commit (palier 0, leçon 03). L'image est utile : tu peux coller autant d'étiquettes que tu veux, il n'y a toujours qu'une boîte.

```js
// Copier VRAIMENT (le premier niveau)
const copie = [...liste1];                  // tableau
const copieObjet = { ...depense };          // objet
const copie2 = liste1.slice();              // équivalent pour un tableau

// ⚠️ Mais ce n'est que le premier niveau
const utilisateur = { nom: "Serge", adresse: { ville: "Douala" } };
const copieUtilisateur = { ...utilisateur };
copieUtilisateur.adresse.ville = "Yaoundé";
console.log(utilisateur.adresse.ville);     // "Yaoundé" 😱 — l'objet imbriqué est partagé

// Copie PROFONDE
const copieProfonde = structuredClone(utilisateur);              // moderne, recommandé
const ancienneAstuce = JSON.parse(JSON.stringify(utilisateur));  // perd dates et fonctions
```

> **La règle de travail qui évite 90 % de ces bugs** : préfère les opérations qui **retournent** une nouvelle structure (`map`, `filter`, spread) à celles qui **modifient** l'existante (`push`, `splice`, `sort`). Ce n'est pas du purisme : du code qui ne mute pas est du code dont on peut raisonner.

### Tableaux : muter ou retourner

| Intention | **Mute** l'original | **Retourne** du neuf |
|-----------|---------------------|----------------------|
| Ajouter à la fin | `push(x)` | `[...t, x]` |
| Retirer à la fin | `pop()` | `t.slice(0, -1)` |
| Ajouter au début | `unshift(x)` | `[x, ...t]` |
| Supprimer au milieu | `splice(i, 1)` | `t.filter((_, idx) => idx !== i)` |
| Trier | `sort()` ⚠️ | `[...t].sort()` ou `t.toSorted()` |
| Inverser | `reverse()` ⚠️ | `[...t].reverse()` |

*(Ce tableau est une référence : reviens-y, ne le mémorise pas.)*

Et une mise en garde qui mérite son paragraphe, parce que c'est **le piège de tableau le plus fréquent de toute une carrière** :

```js
[10, 9, 100].sort()                    // [10, 100, 9]  😱 ordre alphabétique !
[10, 9, 100].sort((a, b) => a - b)     // [9, 10, 100]  ✅
[...depenses].sort((a, b) => b.montant - a.montant)   // décroissant, sans muter
```

`sort` fait **deux** choses inattendues : il modifie le tableau d'origine, et il compare les éléments comme des **chaînes** par défaut. Les deux surprennent, et les deux cassent du code en production.

### Parcourir et chercher

```js
depenses.forEach(d => console.log(d.montant));        // pour chaque (ne retourne rien)
depenses.find(d => d.id === 2)                         // le PREMIER qui correspond (ou undefined)
depenses.findIndex(d => d.id === 2)                    // son index (ou -1)
depenses.some(d => d.montant > 10000)                  // au moins un ? → booléen
depenses.every(d => d.montant > 0)                     // tous ? → booléen
depenses.filter(d => d.categorie === "food")           // tous ceux qui correspondent (leçon 06)
```

### Objets

```js
const depense = { id: 1, montant: 1500, categorie: "food" };

depense.montant                  // notation pointée
depense["montant"]               // notation crochets (quand la clé est dans une variable)
const cle = "categorie";
depense[cle]                     // "food"

depense.paye = true;             // ajouter
delete depense.paye;             // supprimer
"montant" in depense             // true
depense.inexistant               // undefined — pas une erreur
depense.a?.b?.c                  // undefined au lieu d'une erreur

Object.keys(depense)             // ["id", "montant", "categorie"]
Object.values(depense)           // [1, 1500, "food"]
Object.entries(depense)          // [["id",1], ["montant",1500], ["categorie","food"]]

for (const [cle, valeur] of Object.entries(depense)) {
  console.log(`${cle} = ${valeur}`);
}
```

`Object.entries` combiné au destructuring (leçon 07) est l'idiome standard pour parcourir un objet, et tu l'utiliseras énormément à la leçon 06 pour afficher des totaux par catégorie.

### Raccourcis utiles

```js
const montant = 1500, categorie = "food";
const d = { montant, categorie };                  // propriétés abrégées
const champ = "montant";
const filtre = { [champ]: 1500 };                  // clé dynamique
const fusion = { ...valeursParDefaut, ...valeursFournies };  // les dernières écrasent
```

### Grouper à la main

```js
const parCategorie = {};
for (const d of depenses) {
  (parCategorie[d.categorie] ??= []).push(d);     // ??= crée le tableau s'il est absent
}
// { food: [...], transport: [...] }
```

Fais-le à la main une fois : tu le refais en trois lignes avec `reduce` à la leçon 06, et tu comprendras mieux ce que `reduce` t'économise.

### JSON : la persistance de ton projet 1

```js
const texte = JSON.stringify(depenses, null, 2);   // en texte, indenté
const objets = JSON.parse(texte);                   // depuis du texte

// ⚠️ JSON ne connaît ni Date, ni fonctions, ni undefined
JSON.parse(JSON.stringify({ d: new Date() }));      // la date devient une CHAÎNE
// ⚠️ JSON.parse lève une exception sur du texte invalide → try/catch (leçon 08)
```

### `Map` et `Set`

```js
const vues = new Set([1, 2, 2, 3]);        // valeurs uniques
vues.has(2); vues.add(4); vues.size;        // 3
[...new Set(tableau)];                      // dédoublonner, en une expression

const cache = new Map();                    // clés de n'importe quel type, ordre préservé
cache.set("a", 1);
cache.get("a");                             // 1
```

Préfère `Map` à un objet quand les clés ne sont pas des chaînes, quand l'ordre d'insertion compte, ou quand tu ajoutes et supprimes beaucoup. Et `Set` dès que tu testes l'appartenance souvent (leçon 12).

---

## Les problèmes que tu vas rencontrer

**« J'ai modifié ma copie et l'original a changé. »** Il n'y avait pas de copie : `const b = a` sur un objet ou un tableau ne copie rien. Utilise le spread, et pour un tableau d'objets que tu vas modifier, `map(d => ({...d}))` ou `structuredClone`.

**Ton tri a modifié les données affichées ailleurs.** `sort` mute. Travaille sur `[...tableau]`.

**Ton tri de nombres donne un ordre absurde.** Comparateur manquant.

**`Cannot read properties of undefined (reading 'x')`.** Tu accèdes à une propriété d'un élément qui n'existe pas : tableau vide, `find` qui n'a rien trouvé, réponse d'API différente de l'attendu. Le `?.` évite le plantage, mais la vraie question est : **pourquoi est-ce absent ?**

**Ton `JSON.parse` plante avec `Unexpected token <`.** Tu parses du HTML : typiquement une page d'erreur renvoyée par un serveur, que tu as traitée comme du JSON. Tu rencontreras ça au palier 2.

**Tes dates sont devenues des chaînes après un aller-retour JSON.** C'est normal, JSON ne connaît pas les dates. Reconvertis explicitement (`new Date(chaine)`) à la lecture.

**Deux objets identiques ne sont pas égaux.** `{a:1} === {a:1}` vaut `false` : la comparaison porte sur la référence. Pour comparer par contenu, il faut comparer les champs un à un.

**Ton objet « liste » est devenu un objet après un aller-retour JSON.** Cas vicieux : un tableau avec des trous ou des clés non numériques peut être sérialisé en objet. Vérifie avec `Array.isArray()` après un `JSON.parse` (et c'est exactement ce que fait la correction de l'exercice 7).

---

## Ce qu'on te demandera

En **entretien**, les questions de cette leçon sont parmi les plus discriminantes : « différence entre valeur et référence », « comment copies-tu un objet ? et s'il est imbriqué ? », « que renvoie `[10, 9, 100].sort()` et pourquoi », « quelles méthodes de tableau mutent ? », « pourquoi ne faut-il pas muter l'état en React ».

En **test technique**, on te donnera presque certainement un tableau d'objets à manipuler (c'est le sujet de la leçon 06). Ce qu'on observe : si tu mutes l'entrée (mauvais signe), et si tu traites le tableau vide.

En **revue de code**, on te reprendra sur les mutations : `push` dans une fonction qui reçoit un tableau en paramètre est un effet de bord qu'un relecteur attentif refusera.

---

## Ce qui te démarquera

**Ne jamais muter les arguments reçus.** Une fonction qui reçoit un tableau et le modifie trahit la confiance de l'appelant. Retourner du neuf est une habitude qui se remarque immédiatement.

**Savoir expliquer la copie superficielle.** Beaucoup de développeurs utilisent `{...obj}` sans savoir qu'elle ne couvre qu'un niveau. Le savoir — et savoir quand `structuredClone` est nécessaire — te place au-dessus.

**Choisir ta structure en pensant à l'accès.** Dire « comme je vais chercher par identifiant des milliers de fois, je construis un index » est un raisonnement de performance que tu peux déjà avoir (leçon 12).

**Choisir le format de date `YYYY-MM-DD`.** Petit détail, grand effet : il se trie correctement comme texte, il est sans ambiguïté culturelle, et c'est le format des bases de données. C'est le genre de choix qui montre de l'expérience.

**Traiter le tableau vide partout.** C'est le cas limite oublié par défaut, et celui qui provoque les erreurs en production.

---

## 📚 À lire

**The Odin Project → Foundations**, sections *Arrays and Loops* puis *Objects and Object Constructors*.

**javascript.info** : chapitres 4.1 à 4.3 (objets, **références**, méthodes) et 5.4 à 5.5 (tableaux). Le chapitre sur les références est le plus important de la leçon.

Et **lis la page MDN de `Array.prototype.sort` en entier** : c'est l'exercice de lecture de documentation du jour, et tu y découvriras au moins deux comportements surprenants.

---

## 🤖 Le mini-projet à demander à l'IA

Le bug de la référence se comprend en le provoquant. Fais-t'en fabriquer une série :

> « Je suis en formation de développeur, palier 1 (JavaScript). Je travaille les tableaux, les objets, et la différence valeur/référence. Donne-moi **10 petits extraits de code** qui affichent chacun un résultat **surprenant** lié à la référence, à la mutation ou à la copie superficielle (y compris avec des objets imbriqués, des tableaux d'objets, `sort`, et un aller-retour `JSON.parse(JSON.stringify())`). Présente-les **un par un** : je prédis la sortie, tu me dis si j'ai juste et tu expliques la règle en une phrase. Ne me donne pas la liste d'avance. »

Puis le modèle de données, qui est l'autre moitié de la leçon :

> « Décris-moi, en langage naturel, les besoins d'une petite application de suivi de dépenses partagées entre colocataires (plusieurs personnes, des dépenses, des catégories, qui a payé, qui doit rembourser). Ne me donne pas de structure de données. Ma mission : proposer le modèle en JSON. Ensuite, critique mon modèle : qu'est-ce qui sera difficile à faire avec cette forme ? Qu'est-ce que j'ai dupliqué inutilement ? Qu'est-ce qui manquera quand il y aura 10 000 dépenses ? »

Ce second exercice est une préparation directe au palier 4 : concevoir un modèle est exactement ce que tu feras avant de créer des tables.

---

## 🛠️ À faire

1. Modélise un **tableau de six dépenses** avec `id`, `montant` (centimes), `categorie`, `description`, `date` (format `YYYY-MM-DD`). **Ce jeu de données servira à toutes les leçons suivantes** — soigne-le.
2. Écris, **sans muter** le tableau d'origine : `ajouter(depenses, nouvelle)`, `supprimer(depenses, id)`, `modifier(depenses, id, champs)`.
3. **Démontre le piège de la référence** : écris un exemple où tu « copies » un tableau d'objets, modifies la copie, et constates que l'original a changé. Puis corrige. Note la leçon dans ton journal.
4. Trie les dépenses par montant décroissant **sans modifier l'original**, puis par date croissante.
5. Groupe les dépenses par catégorie dans un objet `{ food: [...], transport: [...] }` avec une boucle.
6. **Copie profonde** : crée un objet avec deux niveaux d'imbrication, copie-le avec `{...}`, modifie le niveau 2, observe. Refais avec `structuredClone`.
7. Sauvegarde tes dépenses dans `depenses.json` avec le module `fs` de Node, puis relis-les. Gère **le fichier absent** et **le fichier corrompu**.
8. Construis un index `{ id: depense }` à partir du tableau, puis mesure la différence avec `console.time` entre chercher 1 000 fois par `find` et 1 000 fois par l'index (sur un tableau de 10 000 éléments généré avec une boucle).

<details>
<summary>Corrections</summary>

**2.**
```js
const ajouter = (depenses, nouvelle) => [...depenses, nouvelle];

const supprimer = (depenses, id) => depenses.filter(d => d.id !== id);

const modifier = (depenses, id, champs) =>
  depenses.map(d => (d.id === id ? { ...d, ...champs } : d));
```
Remarque `{ ...d, ...champs }` : on recrée l'objet avec ses anciennes valeurs, puis on écrase celles fournies. **C'est exactement le geste que tu feras en React au palier 3**, où muter l'état empêche le réaffichage.

**3.**
```js
const original = [{ montant: 100 }];
const fausseCopie = original;              // ❌ même référence
fausseCopie[0].montant = 999;
console.log(original[0].montant);           // 999

const presqueCopie = [...original];         // nouveau TABLEAU…
presqueCopie[0].montant = 777;
console.log(original[0].montant);           // 777 😱 …mais les objets sont partagés

const vraieCopie = original.map(d => ({ ...d }));   // ✅ nouveau tableau ET nouveaux objets
```
La deuxième étape est celle qui surprend le plus : `[...original]` crée bien un nouveau tableau, mais il contient les **mêmes** objets. Pour un tableau d'objets qu'on va modifier, il faut `map(d => ({...d}))` ou `structuredClone`.

**4.** `[...depenses].sort((a, b) => b.montant - a.montant)` · par date : `[...depenses].sort((a, b) => a.date.localeCompare(b.date))`. Et voilà pourquoi on choisit le format `YYYY-MM-DD` : les dates se comparent correctement **comme des chaînes**, sans conversion.

**7.**
```js
import { writeFileSync, readFileSync, existsSync } from "node:fs";

function sauvegarder(depenses, chemin = "depenses.json") {
  writeFileSync(chemin, JSON.stringify(depenses, null, 2), "utf8");
}

function charger(chemin = "depenses.json") {
  if (!existsSync(chemin)) return [];           // le cas du premier lancement
  try {
    const donnees = JSON.parse(readFileSync(chemin, "utf8"));
    if (!Array.isArray(donnees)) return [];      // le fichier ne contient pas ce qu'on croit
    return donnees;
  } catch {
    console.error("Fichier corrompu, on repart d'une liste vide");
    return [];
  }
}
```
Les trois cas traités ici — fichier absent, JSON invalide, contenu inattendu — sont **exactement** ceux qui feront planter ton projet 1 si tu les ignores. Et ils se produiront : au premier lancement, et le jour où tu modifieras le fichier à la main.

**8.** Attends-toi à un rapport de l'ordre de cent à mille fois. C'est la même idée qu'un **index de base de données** (palier 4) : on paie une construction et un peu de mémoire pour rendre les recherches instantanées. Leçon 12.
</details>

---

## ✅ Acquis si…

- [ ] J'explique valeur contre référence, et je sais montrer le bug de la « fausse copie ».
- [ ] Je sais que `[...tableau]` ne copie pas les objets qu'il contient.
- [ ] Je cite trois méthodes qui mutent et leur équivalent non mutant.
- [ ] Je sais pourquoi `[10, 9, 100].sort()` donne `[10, 100, 9]` et comment y remédier.
- [ ] Je copie correctement un objet imbriqué, et je sais pourquoi `{...}` ne suffit pas.
- [ ] Je parcours un objet avec `Object.entries()`.
- [ ] Je lis et j'écris un fichier JSON en traitant fichier absent, fichier corrompu et contenu inattendu.
- [ ] Je choisis entre tableau, objet, `Map` et `Set` en justifiant par la façon dont j'accède aux données.
- [ ] Mes dates sont au format `YYYY-MM-DD` et je sais pourquoi.

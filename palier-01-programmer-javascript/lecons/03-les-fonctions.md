# Leçon 03 — Les fonctions

> 🎯 **À la fin de cette leçon** : tu découpes un problème en fonctions courtes, nommées et testables — la compétence la plus transférable de tout le parcours.
> ⏱️ 4 h · **Prérequis** : leçons 01–02.

---

## De quoi on parle

Une **fonction** est un bloc de code nommé qui prend des **paramètres** et **retourne** une valeur. Tu l'écris une fois, tu l'appelles autant que tu veux.

Quelques termes à distinguer, parce qu'on les confond souvent : un **paramètre** est le nom déclaré dans la définition (`function f(x)`), un **argument** est la valeur passée à l'appel (`f(5)`). La **signature** est le nom plus les paramètres : c'est ce qu'il faut savoir pour appeler la fonction sans lire son contenu.

Deux notions vont structurer toute la leçon. Un **effet de bord** est tout ce que la fonction fait **en dehors** de son retour : afficher, écrire un fichier, appeler le réseau, modifier une variable extérieure. Et une fonction **pure** est une fonction qui, pour les mêmes entrées, retourne toujours la même sortie, **sans aucun effet de bord**.

Enfin, une chose qu'on ne dit pas assez tôt aux débutants : **en JavaScript, les fonctions sont des valeurs**. On peut les stocker dans une variable, les passer en argument, les retourner. C'est ce qui rend possible tout ce qui suit dans ce palier — et c'est la clé de la leçon 06.

---

## À quoi ça sert, concrètement

**À nommer, donc à comprendre.** Extraire dix lignes dans `calculerTotalParCategorie()` documente ton code mieux que n'importe quel commentaire, et ce nom devient une partie du vocabulaire de ton projet. Quand tu discuteras de ton application avec quelqu'un, tu parleras de « calculer le total par catégorie » — pas de « la boucle qui additionne ».

**À pouvoir tester.** On ne teste pas « un programme », on teste des **fonctions**. Au palier 4, tu écriras des tests, et ce sont les fonctions — surtout les pures — qui les rendent possibles. `calculerTotal([{montant: 100}]) === 100` est un test d'une ligne. Une logique noyée au milieu d'un script de 200 lignes n'est pas testable, et c'est pour ça qu'elle finit par contenir des bugs qu'on ne voit pas.

**À pouvoir déboguer.** Un bug dans une fonction de huit lignes se trouve. Dans un fichier de 300 lignes, il se cherche.

**À réutiliser sans copier.** Le jour où la règle change, elle change à un seul endroit.

**Et parce que c'est la même notion partout.** `def` en Python, `function` en PHP, les méthodes en Dart. Tu n'apprendras cette leçon qu'une seule fois.

---

## Où ça intervient dans le développement

C'est ici que cette leçon dépasse la syntaxe, parce que le découpage en fonctions **est** le premier geste d'architecture.

Voici le principe à retenir, et tu le retrouveras à chaque palier sous un nom différent : **regroupe les calculs dans des fonctions pures, et isole les effets dans un petit nombre de fonctions impures**.

```js
// PURE : calcule et retourne. Testable en une ligne, réutilisable partout.
function calculerTotal(depenses) {
  return depenses.reduce((somme, d) => somme + d.montant, 0);
}

// IMPURE : affiche (effet de bord), ne retourne rien.
function afficherTotal(depenses) {
  console.log(`Total : ${calculerTotal(depenses)}`);
}
```

Pourquoi ça compte autant ? Parce que c'est exactement ce découpage que les frameworks vont t'imposer plus tard, et que tu le comprendras au lieu de le subir :

```
   fonctions pures (le calcul, les règles)        fonctions impures (les effets)
   ───────────────────────────────────────        ──────────────────────────────
   palier 1 : calculerTotal, filtrer…             afficher, lire/écrire un fichier
   palier 2 : la logique, dans son fichier        le DOM, dans un autre fichier
   palier 3 : hors des composants React           les composants, les effets
   palier 4 : la couche "services"                les contrôleurs (HTTP), la base
   palier 7 : le "domaine"                        l'"infrastructure"
```

Le fil rouge architecture commence au palier 2 avec « séparer les responsabilités », et culmine au palier 7 avec SOLID. **Ce découpage-là en est la première marche**, et tu la montes aujourd'hui. Ton projet 1 devra la respecter : la logique de calcul d'un côté, l'affichage en ligne de commande de l'autre.

Une conséquence immédiate et très concrète : au palier 3, cette séparation te permettra de **réutiliser ta logique métier** entre le web et le mobile. Au palier 9, ton application Flutter appellera la même API que ton site — et la logique sera du côté serveur, dans des fonctions pures, écrites une seule fois.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas d'abord écrire des scripts linéaires, puis découvrir qu'ils deviennent impossibles à relire au bout de cent lignes. Le découpage en fonctions n'est pas une consigne arbitraire : c'est la réponse à une gêne que tu vas ressentir.

Tu vas aussi écrire tes premières fonctions trop longues, et c'est l'occasion d'installer le repère : **si ta fonction dépasse une vingtaine de lignes, ou si son nom contient « et », découpe-la**.

### En équipe, en entreprise

La taille et la responsabilité des fonctions sont les **premiers** sujets de revue de code, avant même la performance ou l'élégance. Les remarques récurrentes :

« **Cette fonction fait trois choses.** » Elle valide, elle calcule et elle affiche. Il faut trois fonctions.

« **Cette fonction est impossible à tester.** » Parce qu'elle lit un fichier, appelle le réseau et affiche, tout en calculant. Pour la tester, il faudrait simuler la moitié du système. La version découpée se teste sans rien installer.

« **Trop de paramètres.** » Au-delà de trois, l'appel devient illisible et l'ordre des arguments devient un piège. On passe un objet.

« **Ce nom ne dit rien.** » `traiter`, `gerer`, `faire`, `process`, `data`. Si tu ne sais pas nommer une fonction, c'est généralement qu'elle fait trop de choses.

Tu verras aussi que les fonctions pures sont **recherchées** : dans une base de code professionnelle, on essaie de concentrer les effets de bord dans peu d'endroits bien identifiés, parce que ce sont eux qui rendent le reste imprévisible.

### Ce qui sert tout le temps, et ce qui est rare

Au quotidien : les déclarations de fonctions, les fonctions fléchées, les paramètres par défaut, le retour d'objets, les callbacks, et le découpage par responsabilité.

Régulièrement : passer un objet en paramètre et le déstructurer (leçon 07), les paramètres `...rest`, les fonctions qui retournent des fonctions (leçon 05).

Rare, et hors sujet maintenant : les générateurs (`function*`), `this` et son contexte dynamique (tu le rencontreras au palier 3 avec les classes et au palier 6 avec PHP), `call`/`apply`/`bind`, la curryfication, la récursivité profonde. La récursivité en particulier : tu dois savoir ce que c'est et en écrire une simple, mais dans le développement web ordinaire tu en écriras très peu — sauf pour parcourir des structures arborescentes (un menu, un système de commentaires imbriqués).

---

## La mécanique

### Les trois formes

```js
// 1. Déclaration — hissée : utilisable avant sa ligne de définition
function additionner(a, b) {
  return a + b;
}

// 2. Expression de fonction — assignée à une variable, non hissée
const additionner2 = function (a, b) { return a + b; };

// 3. Fonction fléchée — la forme moderne et concise (détails en leçon 05)
const additionner3 = (a, b) => a + b;        // retour implicite, sans accolades
const doubler = n => n * 2;                   // un seul paramètre : parenthèses optionnelles
const creerObjet = n => ({ valeur: n });      // ⚠️ parenthèses obligatoires pour un objet
```

### Les paramètres

```js
// Valeurs par défaut
function formater(montant, devise = "FCFA", decimales = 0) {
  return `${montant.toFixed(decimales)} ${devise}`;
}
formater(1500);              // "1500 FCFA"
formater(1500, "€", 2);      // "1500.00 €"

// Un objet en paramètre dès qu'il y en a plus de trois : l'appel redevient lisible
function creerDepense({ montant, categorie, description = "", date = new Date() }) {
  return { id: Date.now(), montant, categorie, description, date };
}
creerDepense({ montant: 5000, categorie: "transport" });   // on voit ce qu'on passe

// Nombre variable d'arguments
function somme(...nombres) {
  return nombres.reduce((t, n) => t + n, 0);
}
somme(1, 2, 3, 4);   // 10
```

Compare `creerDepense(5000, "transport", "", true, false)` et `creerDepense({ montant: 5000, categorie: "transport" })`. Dans le premier cas, personne ne sait ce que valent `true` et `false` sans aller lire la signature, et inverser deux arguments passe inaperçu. **C'est pour ça qu'on passe un objet au-delà de trois paramètres**, et tu retrouveras cette convention dans toutes les bibliothèques modernes.

### Le retour

```js
function diviser(a, b) {
  if (b === 0) return null;       // un cas d'erreur explicite, traité d'abord
  return a / b;                   // le code après un return n'est jamais atteint
}

// Retourner plusieurs valeurs : via un objet
function analyser(depenses) {
  return { total: calculerTotal(depenses), nombre: depenses.length };
}
const { total, nombre } = analyser(mesDepenses);    // destructuring, leçon 07
```

### Les fonctions sont des valeurs

C'est le point le plus important de la leçon pour la suite du palier.

```js
// On peut les passer en argument : c'est un "callback"
function appliquerDeuxFois(f, valeur) {
  return f(f(valeur));
}
appliquerDeuxFois(n => n * 2, 5);     // 20

// On peut les retourner
function creerMultiplicateur(facteur) {
  return n => n * facteur;             // closure, leçon 05
}
const tripler = creerMultiplicateur(3);
tripler(5);                            // 15

// On peut les stocker dans un objet — ta future table de commandes CLI
const commandes = {
  add: args => ajouterDepense(args),
  list: () => listerDepenses(),
};
```

**Si ce paragraphe est clair, la leçon 06 sera facile.** `map`, `filter` et `reduce` ne sont rien d'autre que des fonctions qui prennent une fonction en argument. Et c'est aussi le mécanisme des gestionnaires d'événements (palier 2), des middlewares (palier 4) et des hooks React (palier 3). Une seule idée, quatre applications.

---

## Les problèmes que tu vas rencontrer

**Ta fonction renvoie `undefined`.** Tu as oublié le `return`. C'est l'erreur numéro un, et son symptôme est `undefined` qui s'affiche partout. Attention au cas vicieux de la fléchée : `n => { n * 2 }` a des accolades donc un corps de fonction, et ne retourne rien. Soit `n => n * 2`, soit `n => { return n * 2; }`.

**`f is not a function`.** Soit une faute de frappe, soit un import manquant, soit tu confonds `f` et `f()`. Retiens la distinction : `f` **est** la fonction, `f()` est **son résultat**. En passant `f()` à `map`, tu passes une valeur, pas une fonction — et c'est une erreur fréquente.

**Ta fonction modifie son argument.** `function ajouter(liste, x) { liste.push(x) }` modifie le tableau de l'appelant : c'est un effet de bord caché, et la source de bugs très désagréables (leçon 04). Retourne un nouveau tableau.

**Ta fonction dépend d'une variable globale.** Elle marche dans ton script et nulle part ailleurs, elle est intestable, et son comportement change selon l'ordre d'exécution. Passe la valeur en paramètre.

**Ta fonction est devenue impossible à nommer.** Signal fiable : elle fait trop de choses. Découpe-la, et les noms viendront d'eux-mêmes.

**Tu ne sais plus ce qu'elle retourne.** Si tu dois lire le corps d'une fonction pour savoir ce qu'elle rend, c'est que son nom ou sa signature est à revoir.

---

## Ce qu'on te demandera

En **test technique**, on ne te demandera pas « écris une fonction » — on te donnera un problème, et la qualité de ton **découpage** sera évaluée au moins autant que la justesse du résultat. Un candidat qui rend une seule fonction de 60 lignes et un candidat qui rend quatre fonctions nommées de 10 lignes n'obtiennent pas la même appréciation, même avec le même résultat.

En **entretien oral**, les questions récurrentes : « qu'est-ce qu'une fonction pure et pourquoi c'est utile », « qu'est-ce qu'un effet de bord », « comment testerais-tu cette fonction » (et si la réponse est « je ne pourrais pas », c'est que le découpage est mauvais), « combien de paramètres au maximum ».

En **revue de code**, c'est le sujet le plus commenté sur du code de débutant : taille, responsabilité unique, nommage.

---

## Ce qui te démarquera

**Séparer le calcul de l'affichage, spontanément.** C'est le marqueur le plus visible d'un développeur qui pense en termes de conception et pas seulement de résultat. Et c'est exactement ce que le référent regardera dans ton projet 1.

**Écrire des fonctions qu'on peut tester sans rien installer.** Si tu peux dire « cette fonction se teste en une ligne, sans base de données ni réseau », tu as compris l'essentiel du palier 4 avant de l'aborder.

**Traiter les cas limites en début de fonction.** Tableau vide, division par zéro, valeur absente. Dans l'ordre : les gardes d'abord, le cas normal ensuite.

**Des noms qui sont des verbes précis.** `calculerTotal`, `filtrerParCategorie`, `formaterMontant` — et non `total`, `traiter`, `data2`.

**Savoir dire pourquoi une fonction longue est un problème**, sans réciter une règle : parce qu'elle est illisible, intestable, et qu'elle a plusieurs raisons de changer. Cette dernière formulation est le principe de responsabilité unique de SOLID, que tu verras au palier 7 — tu peux déjà l'exprimer.

---

## 📚 À lire

**The Odin Project → Foundations → Functions**, et surtout la section ***Problem Solving*** : elle enseigne le découpage d'un problème avant le code, qui est le vrai sujet de cette leçon.

**javascript.info** chapitre 2.16 (fonctions), 6.1 (récursion) et 6.3 (paramètres `rest` et `spread`).

Et la page MDN *Functions*, notamment la section sur les paramètres par défaut.

---

## 🤖 Le mini-projet à demander à l'IA

Le découpage s'apprend en refactorisant du code mal découpé. Demande-en :

> « Je suis en formation de développeur, palier 1 (JavaScript). Je travaille le découpage en fonctions. Écris-moi un **script de 60 à 80 lignes volontairement monolithique** : un petit programme Node qui lit un tableau de commandes codé en dur, calcule des totaux, applique des remises selon des règles, formate un rapport et l'affiche — **le tout dans un seul bloc**, avec des noms de variables médiocres. Ne me dis pas comment le découper. Ma mission : le réécrire en fonctions, dont **au moins quatre pures**, sans changer la sortie. Ensuite, compare mon découpage au tien et dis-moi ce que j'aurais pu séparer autrement, et **pourquoi**. »

Puis, pour vérifier que la notion de pureté est acquise :

> « Donne-moi 10 petites fonctions JavaScript, certaines pures, certaines impures (certaines de façon subtile : modification d'un argument, lecture de `Date.now()`, lecture d'une variable globale). Demande-moi pour chacune si elle est pure et pourquoi, une par une, et corrige-moi. »

Le second exercice est plus utile qu'il n'y paraît : les impuretés **subtiles** (`Date.now()`, `Math.random()`, la mutation d'un argument) sont celles qui rendent les tests instables en entreprise.

---

## 🛠️ À faire

1. Écris et teste ces **fonctions pures** :
   - `calculerTotal(depenses)` → la somme des montants
   - `filtrerParCategorie(depenses, categorie)` → un **nouveau** tableau
   - `trouverPlusGrosse(depenses)` → la dépense au montant le plus élevé, ou `null` si vide
   - `moyenneParDepense(depenses)` → arrondie à deux décimales, `0` si vide
2. Écris `formaterMontant(centimes, devise = "FCFA")` et vérifie-la sur 0, 5, 1500 et 123456789.
3. **Découpage** : prends ce script et découpe-le en quatre fonctions, dont trois pures.
   ```js
   const depenses = [{montant: 1500, cat: "food"}, {montant: 3000, cat: "transport"}, {montant: 500, cat: "food"}];
   let total = 0;
   for (const d of depenses) total += d.montant;
   console.log("Total: " + total);
   let totalFood = 0;
   for (const d of depenses) if (d.cat === "food") totalFood += d.montant;
   console.log("Food: " + totalFood + " (" + Math.round(totalFood/total*100) + "%)");
   ```
4. **Récursivité** : `factorielle(n)` puis `fibonacci(n)`. Mesure le temps de `fibonacci(35)` avec `console.time()`. Pourquoi est-ce si lent ? *(réponse en leçon 12)*
5. Écris `composer(f, g)` qui retourne une fonction appliquant `g` puis `f`. Vérifie : `composer(n => n + 1, n => n * 2)(5)` doit donner `11`.
6. Écris `appliquerAuxDeux(f, a, b)` et appelle-la avec trois fonctions différentes, dont une fléchée écrite sur place.
7. **L'exercice de pureté** : prends `function enregistrer(depense) { depenses.push(depense); console.log("ajouté"); return depenses.length; }` et sépare-la en deux fonctions, l'une pure, l'autre impure. Explique ce que tu gagnes.
8. Écris une fonction dont la signature prend **un objet** en paramètre avec deux valeurs par défaut, et appelle-la de trois façons différentes.

<details>
<summary>Corrections</summary>

**1.**
```js
const calculerTotal = depenses => depenses.reduce((s, d) => s + d.montant, 0);

const filtrerParCategorie = (depenses, categorie) =>
  depenses.filter(d => d.categorie === categorie);

function trouverPlusGrosse(depenses) {
  if (depenses.length === 0) return null;        // le cas limite d'abord
  return depenses.reduce((max, d) => (d.montant > max.montant ? d : max));
}

function moyenneParDepense(depenses) {
  if (depenses.length === 0) return 0;            // sinon : division par zéro → NaN
  return Math.round((calculerTotal(depenses) / depenses.length) * 100) / 100;
}
```
Les deux fonctions avec un cas limite explicite sont celles qui comptent. Le tableau vide est toujours le test oublié — et c'est toujours celui qui casse en production.

**3.**
```js
const calculerTotal = ds => ds.reduce((s, d) => s + d.montant, 0);              // pure
const filtrerParCat = (ds, cat) => ds.filter(d => d.cat === cat);               // pure
const pourcentage = (partie, tout) => (tout === 0 ? 0 : Math.round(partie / tout * 100)); // pure
function afficherRapport(ds) {                                                  // impure
  const total = calculerTotal(ds);
  const food = calculerTotal(filtrerParCat(ds, "food"));
  console.log(`Total: ${total}`);
  console.log(`Food: ${food} (${pourcentage(food, total)}%)`);
}
```
Regarde ce que tu as gagné : les trois fonctions pures se testent sans rien exécuter d'autre, et `pourcentage` gère maintenant la division par zéro — un bug que le script initial contenait silencieusement.

**4.** `fibonacci(35)` naïf fait environ trente millions d'appels : l'arbre d'appels recalcule les mêmes valeurs des milliers de fois. C'est une complexité **exponentielle**. Avec une mémoïsation (leçon 05), on passe à une complexité linéaire et c'est instantané.

**5.**
```js
const composer = (f, g) => x => f(g(x));
composer(n => n + 1, n => n * 2)(5);     // g(5)=10 puis f(10)=11 ✅
```
Tu viens d'écrire une fonction qui prend deux fonctions et retourne une fonction. Si ça te paraît naturel, tu es prêt pour la leçon 06.

**7.**
```js
const ajouterDepense = (depenses, depense) => [...depenses, depense];   // pure
function enregistrerEtAfficher(depenses, depense) {                      // impure
  const nouvelles = ajouterDepense(depenses, depense);
  console.log("ajouté");
  return nouvelles;
}
```
Ce que tu gagnes : `ajouterDepense` se teste en une ligne, ne touche à aucune variable extérieure, et peut être réutilisée partout — y compris dans un contexte où tu ne veux rien afficher (une API, par exemple, au palier 4).
</details>

---

## ✅ Acquis si…

- [ ] J'écris une fonction pure et j'explique en quoi elle diffère d'une impure.
- [ ] Je sépare systématiquement le calcul de l'affichage.
- [ ] Aucune de mes fonctions ne dépasse vingt lignes ni ne fait deux choses.
- [ ] Je passe un objet en paramètre au-delà de trois arguments, et je sais pourquoi.
- [ ] Je traite les cas limites **en début** de fonction.
- [ ] Je passe une fonction en argument d'une autre fonction sans hésiter.
- [ ] Je distingue `f` de `f()`.
- [ ] Mes noms de fonctions sont des **verbes** précis.
- [ ] Je sais dire ce que je gagne, concrètement, en découpant une fonction.

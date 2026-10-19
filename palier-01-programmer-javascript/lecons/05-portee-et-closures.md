# Leçon 05 — Portée, fonctions fléchées, closures

> 🎯 **À la fin de cette leçon** : tu sais où vivent tes variables, et tu comprends les closures — le concept qui fait échouer la plupart des entretiens juniors, et celui qui rendra React compréhensible au palier 3.
> ⏱️ 4 h · **Prérequis** : leçons 01–04.

---

## De quoi on parle

La **portée** (*scope*) est la zone du code où un nom est visible. JavaScript en a trois : la portée **globale** (visible partout), la portée **de fonction** (visible dans la fonction), et la portée **de bloc** (visible dans les accolades) — cette dernière étant celle de `let` et `const`.

La **chaîne des portées** est la façon dont un nom est résolu : le moteur cherche dans la portée courante, puis dans la portée parente, et ainsi de suite jusqu'au global. S'il ne trouve pas, c'est `ReferenceError`.

Une **closure** (ou *fermeture*) est une fonction **plus l'environnement de variables dans lequel elle a été créée** — environnement qu'elle conserve même après que celui-ci a fini de s'exécuter.

Et une **fonction fléchée** est la syntaxe `() => {}`, dont la différence essentielle avec `function` n'est pas la concision mais l'absence de `this` propre.

---

## À quoi ça sert, concrètement

**La portée sert à isoler.** Imagine que toute variable soit visible partout : deux fonctions écrites à six mois d'intervalle, utilisant toutes deux `i` ou `total`, se détruiraient mutuellement. La portée donne à chaque fonction sa bulle. D'où la règle de travail : **déclare chaque variable dans la portée la plus étroite possible**.

**Les closures servent à garder un état privé.** C'est la façon historique — et toujours valide — de créer des données inaccessibles de l'extérieur en JavaScript. Un compteur, un cache, une configuration : tout ce qui doit persister entre deux appels sans être exposé.

**Et surtout : les closures sont le mécanisme de tout ce qui est asynchrone.** À chaque fois que tu passes une fonction à `setTimeout`, à `map`, à un gestionnaire d'événement ou à un `.then`, cette fonction **emporte avec elle** le contexte où tu l'as écrite. Sans closures, rien de tout ça ne fonctionnerait. C'est pourquoi cette leçon vient avant l'asynchrone.

---

## Où ça intervient dans le développement

Trois endroits, du plus immédiat au plus déterminant.

**Dans les callbacks, en permanence.** Dès la leçon 06, tes fonctions passées à `map` ou `filter` utiliseront des variables de l'extérieur. Ça te paraîtra naturel — c'est une closure.

**Dans les gestionnaires d'événements, au palier 2.** Tu écriras `bouton.addEventListener("click", () => supprimer(depense.id))`, et ce `depense.id` sera capturé. Le bug classique de ce palier — tous les boutons agissent sur le dernier élément — est exactement le piège de boucle expliqué plus bas.

**Dans React, au palier 3, et c'est le point décisif.** `useState` **est** une closure. Chaque rendu d'un composant crée un nouvel environnement, et les fonctions définies dedans capturent les valeurs de **ce** rendu. C'est l'origine du bug le plus déroutant de React — la « valeur périmée » (*stale closure*) : un gestionnaire d'événement ou un `setTimeout` qui affiche l'ancienne valeur d'un état.

```
   leçon 05 : closure
        ├── leçon 06 : les callbacks de map/filter/reduce
        ├── leçons 09-10 : les callbacks asynchrones
        ├── palier 2 : les gestionnaires d'événements du DOM
        ├── palier 3 : useState, useEffect, les custom hooks     ← ici ça devient critique
        └── palier 4 : les middlewares qui capturent une config
```

Autrement dit : **ce que tu ne comprends pas aujourd'hui, tu le paieras au palier 3**, sous forme d'un bug que tu ne saurais pas nommer. C'est la raison d'être de cette leçon.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

La portée se manifestera surtout en négatif : des `ReferenceError` parce que tu utilises une variable hors de sa zone, ou des variables qui ne contiennent pas ce que tu crois.

Les closures, elles, tu les utiliseras **sans le savoir** dès la leçon 06. Puis tu les utiliseras volontairement pour créer un compteur ou un cache (exercices de cette leçon et de la leçon 10).

### En équipe, en entreprise

**`var` n'existe plus.** Tu le verras dans du vieux code et dans des tutoriels périmés, et tu sauras alors que le code est ancien. Les linters l'interdisent.

**Les fonctions fléchées sont le défaut** pour les callbacks et les petites fonctions. Mais tu verras aussi des `function` pour les méthodes d'objet, et c'est délibéré : question de `this`.

**Les closures apparaissent dans toutes les conversations React.** « C'est une stale closure » est une phrase qu'on entend régulièrement en revue de code front-end, et savoir ce qu'elle désigne te fera gagner du temps et du crédit.

**Les variables globales sont bannies.** Dans un projet professionnel, tout vit dans des modules ; une variable globale est une faute de conception. Tu apprendras les modules au palier 2.

### Ce qui sert tout le temps, et ce qui est rare

Au quotidien : la portée de bloc avec `let`/`const`, les fonctions fléchées, et les closures — utilisées sans y penser.

Régulièrement : créer volontairement une closure pour un état privé ou un cache, et savoir reconnaître le piège de capture dans une boucle.

Rare, et hors sujet maintenant : `this` dans tous ses états, `call`/`apply`/`bind`, les IIFE (`(function(){})()` — tu les verras dans du code ancien), le *hoisting* de `var`, la *temporal dead zone* dans ses détails, les modules comme mécanisme de portée (palier 2). Et tout ce qui touche à l'héritage prototypal : ce n'est pas du niveau débutant, et tu peux travailler des années sans l'écrire à la main.

---

## La mécanique

### Les poupées russes

```js
const global = "je suis partout";

function externe() {
  const dansExterne = "visible dans externe et ses enfants";

  function interne() {
    const dansInterne = "visible ici seulement";
    console.log(global, dansExterne, dansInterne);   // ✅ les trois
  }

  interne();
  // console.log(dansInterne);    // ❌ ReferenceError
}
```

Le regard va **de l'intérieur vers l'extérieur**, jamais l'inverse. Une fonction voit ce qui l'entoure ; l'extérieur ne voit pas dedans.

### La portée de bloc : pourquoi `var` est abandonné

```js
if (true) {
  var ancien = "fuit du bloc";
  let moderne = "reste dans le bloc";
}
console.log(ancien);     // "fuit du bloc" 😱
console.log(moderne);    // ❌ ReferenceError — le comportement souhaitable
```

`var` n'a pas de portée de bloc : il fuit dans toute la fonction. C'est contre-intuitif, source de collisions, et c'est pour ça qu'on ne l'utilise plus.

### La closure, expliquée simplement

Une fonction **se souvient de l'endroit où elle a été écrite**, pas de l'endroit où elle est appelée.

```js
function creerCompteur() {
  let compte = 0;                 // variable locale… qui devrait disparaître
  return function () {
    compte++;                      // …mais la fonction retournée la garde en vie
    return compte;
  };
}

const compteur = creerCompteur();
compteur();   // 1
compteur();   // 2
compteur();   // 3
// `compte` est INACCESSIBLE de l'extérieur : c'est une variable privée.

const autre = creerCompteur();
autre();      // 1 — chaque appel crée son propre environnement
```

L'image utile est celle du **sac à dos** : quand la fonction est créée, elle emporte dans son sac les variables qui l'entouraient. Où qu'elle aille ensuite — dans un `setTimeout`, dans un gestionnaire d'événement, dans un tableau —, elle a son sac.

Le deuxième point de l'exemple compte autant que le premier : `creerCompteur()` appelé deux fois crée **deux environnements indépendants**. Cela signifie qu'une closure est un moyen de fabriquer des instances isolées — et c'est exactement ce que fait React avec l'état de chaque composant.

### Le piège de la boucle : la question d'entretien

```js
// Avec var : les 3 callbacks partagent LA MÊME variable i
for (var i = 0; i < 3; i++) {
  setTimeout(() => console.log(i), 100);
}
// → 3, 3, 3   (quand les callbacks s'exécutent, la boucle est finie et i vaut 3)

// Avec let : une NOUVELLE liaison de i par itération, chacune capturée séparément
for (let i = 0; i < 3; i++) {
  setTimeout(() => console.log(i), 100);
}
// → 0, 1, 2  ✅
```

**Si tu comprends ces six lignes, tu comprends les closures.** C'est la question la plus posée sur le sujet, et c'est aussi le bug que tu rencontreras pour de vrai au palier 2 quand tu attacheras des gestionnaires de clic dans une boucle.

### Les fonctions fléchées

```js
const f1 = function (a, b) { return a + b; };
const f2 = (a, b) => a + b;              // retour implicite
const f3 = a => a * 2;                    // un paramètre : parenthèses optionnelles
const f4 = () => ({ ok: true });          // ⚠️ parenthèses autour de l'objet retourné
```

La différence qui compte n'est pas la concision : c'est que **la fléchée n'a pas son propre `this`** — elle hérite de celui de l'environnement où elle est écrite. Conséquence pratique :

```js
const compteur = {
  valeur: 0,
  incrementerKO: () => { this.valeur++; },        // ❌ `this` n'est pas `compteur`
  incrementerOK() { this.valeur++; },             // ✅ méthode abrégée
};
```

La règle de travail pour l'instant : **fléchée pour les callbacks** (`map`, `filter`, `setTimeout`, les gestionnaires d'événements) et les petites fonctions ; `function` ou la forme abrégée **pour les méthodes d'objet**. Tu reverras `this` sérieusement au palier 3 (classes et composants) et au palier 6 (PHP, où `$this` est omniprésent).

Autres différences, moins importantes : la fléchée n'a pas `arguments` (utilise `...rest`), et elle n'est pas hissée.

### Les variables privées par closure : le pattern module

```js
function creerPortefeuille(soldeInitial = 0) {
  let solde = soldeInitial;                       // inaccessible de l'extérieur

  return {
    deposer(montant) {
      if (montant <= 0) return false;
      solde += montant;
      return true;
    },
    lire() { return solde; },
  };
}

const p = creerPortefeuille(1000);
p.deposer(500);
p.lire();        // 1500
p.solde;         // undefined — impossible de tricher
```

Tu viens d'écrire un **module** : un état privé, une interface publique, et des règles qui ne peuvent pas être contournées. Le concept reviendra sous d'autres formes au palier 2 (organisation des fichiers), au palier 4 (les services) et au palier 7 (l'encapsulation, dans SOLID).

---

## Les problèmes que tu vas rencontrer

**`ReferenceError: x is not defined`.** La variable n'existe pas dans cette portée. Soit une faute de frappe, soit tu es hors de sa zone, soit un import manquant.

**`Cannot access 'x' before initialization`.** Tu utilises un `let`/`const` avant sa ligne de déclaration. C'est la *temporal dead zone* : la variable existe dès l'entrée dans la portée mais est inutilisable avant son initialisation. Avec `var`, tu aurais eu `undefined` — plus trompeur encore.

**Tous tes boutons agissent sur le dernier élément.** Le piège de capture dans une boucle. Avec `let` (ou avec `forEach`/`map`, qui créent une portée par itération), c'est réglé.

**Ton `this` est `undefined` ou pointe ailleurs.** Tu as utilisé une fléchée comme méthode d'objet, ou tu as détaché une méthode de son objet. Pour l'instant, retiens la règle de choix ; tu approfondiras au palier 3.

**Ta variable ne se met pas à jour comme prévu dans un callback.** Tu lis une valeur capturée à un moment antérieur. C'est l'ancêtre du bug de *stale closure* de React — et la solution est généralement de passer par une fonction de mise à jour plutôt que de lire la valeur capturée.

**Une variable globale « mystérieuse ».** Si tu oublies `let`/`const` dans une affectation (`x = 5` sans déclaration), JavaScript crée une variable globale sans prévenir. Le mode strict (`"use strict"`, actif par défaut dans les modules) l'interdit — raison supplémentaire de travailler en modules.

---

## Ce qu'on te demandera

« **Qu'est-ce qu'une closure ?** » est l'une des trois questions les plus posées en entretien JavaScript junior, toutes entreprises confondues. Et le piège est que la définition seule ne suffit pas : on attend que tu donnes un **exemple** et un **cas d'usage**.

Suivent très souvent : « explique la différence entre `var`, `let` et `const` », « pourquoi ce code affiche-t-il `3, 3, 3` ? » (le piège de la boucle, parfois donné à corriger), « comment créerais-tu une variable privée en JavaScript ? », « quelle différence entre une fonction fléchée et une fonction classique ? ».

En **test technique**, les closures apparaissent indirectement : on te demandera d'écrire une fonction qui en retourne une autre (un *memoize*, un *debounce*, un limiteur d'appels). Ces trois exercices sont des classiques, et tu en fais deux dans cette leçon.

En **revue de code front-end**, on te parlera de *stale closure* dès que tu travailleras sur React.

---

## Ce qui te démarquera

**Avoir une analogie personnelle pour expliquer les closures.** Le sac à dos, la photo de l'environnement, la boîte à souvenirs — peu importe, mais avoir **ta** formulation prouve que tu as compris plutôt que mémorisé. C'est précisément ce qu'un intervieweur cherche à savoir.

**Savoir expliquer le piège de la boucle de deux façons.** Avec `let`, et avec la capture explicite dans une fonction appelée immédiatement — la technique de l'époque pré-2015, que tu croiseras dans du code ancien.

**Utiliser une closure pour un cache ou un état privé**, volontairement et avec une raison. Tu le feras à la leçon 10 avec un cache de requêtes, et c'est un pattern qu'on retrouve dans toutes les bibliothèques.

**Comprendre l'avance que ça te donne sur React.** Arriver au palier 3 en sachant que `useState` est une closure, et que chaque rendu capture ses propres valeurs, te fait économiser les semaines de confusion que vivent la plupart des débutants en React.

---

## 📚 À lire

**javascript.info chapitre 6.3, *Variable scope, closure*** — c'est la meilleure explication disponible, avec des schémas d'environnements lexicaux. **Si tu ne lis qu'une seule page de tout le palier, c'est celle-là.**

**The Odin Project → Foundations → Scope and Closures** pour une approche plus guidée.

Et la page MDN *Arrow function expressions*, en particulier la section *No separate this* — courte, et elle règle la question du choix entre les deux syntaxes.

---

## 🤖 Le mini-projet à demander à l'IA

Les closures se comprennent par la **prédiction**. Voici l'exercice le plus efficace :

> « Je suis en formation de développeur, palier 1 (JavaScript). Je travaille la portée et les closures. Donne-moi **12 extraits de code** à prédire, un par un, de plus en plus subtils : portée de bloc, `var` contre `let`, temporal dead zone, capture dans une boucle avec `setTimeout`, fonction qui retourne une fonction, deux closures indépendantes créées depuis la même fabrique, et un cas de valeur capturée périmée. Je prédis la sortie, tu me dis si j'ai juste et **tu expliques l'environnement capturé** — sans me donner la liste d'avance. »

Puis les trois exercices classiques d'entretien, que tu auras ainsi déjà faits :

> « Fais-moi écrire, un par un et sans me donner le code, les trois classiques des closures en entretien : `memoize(f)` qui met les résultats en cache, `debounce(f, ms)` qui n'exécute qu'après un délai sans nouvel appel, et `once(f)` qui n'exécute qu'une seule fois. Pour chacun, donne-moi seulement la spécification et deux cas de test. Ensuite, critique ma solution sur la façon dont j'ai utilisé la closure. »

`debounce` en particulier te servira pour de vrai au palier 2 (un champ de recherche qui ne lance pas une requête à chaque frappe).

---

## 🛠️ À faire

1. **Prédis la sortie, puis vérifie** :
   ```js
   let x = "global";
   function test() {
     console.log(x);          // (a)
     let x = "local";
     console.log(x);          // (b)
   }
   test();
   ```
2. Écris `creerCompteur()` qui retourne `{ incrementer, decrementer, lire, reinitialiser }` avec un compte **privé**. Vérifie qu'on ne peut pas y accéder directement.
3. Reproduis le **piège de la boucle** avec `var`, constate `3,3,3`, puis corrige avec `let`. Explique **par écrit** dans ton journal pourquoi ça change.
4. **Question d'entretien** — prédis la sortie, puis explique, puis propose **deux** corrections différentes :
   ```js
   const fonctions = [];
   for (var i = 0; i < 3; i++) fonctions.push(() => i);
   console.log(fonctions.map(f => f()));
   ```
5. Écris `creerLimiteur(max)` qui retourne une fonction autorisant seulement `max` appels (`true`, puis `false` ensuite).
6. Écris `memoise(f)` : retourne une version de `f` qui garde ses résultats en cache dans une closure. Teste sur `fibonacci` (leçon 03) et mesure l'écart avec `console.time()`.
7. Crée **deux** compteurs depuis la même fabrique et démontre qu'ils sont indépendants. Explique pourquoi c'est le même mécanisme que l'état d'un composant React.
8. Écris le pattern module : `creerPanier()` avec un tableau d'articles **privé**, et les méthodes `ajouter`, `retirer`, `total`, `lister` (qui doit retourner une **copie**, pas la référence interne — leçon 04).

<details>
<summary>Corrections</summary>

**1.** La ligne (a) lève une **`ReferenceError: Cannot access 'x' before initialization`** — pas `"global"`, pas `undefined`. C'est la *temporal dead zone* : `let x` existe dès l'entrée dans la fonction (il « masque » le `x` global), mais il est inutilisable avant sa ligne d'initialisation. Avec `var`, (a) aurait affiché `undefined`, ce qui est plus trompeur — une raison de plus d'abandonner `var`.

**2.**
```js
function creerCompteur(depart = 0) {
  let compte = depart;
  return {
    incrementer: () => ++compte,
    decrementer: () => --compte,
    lire: () => compte,
    reinitialiser: () => { compte = depart; },
  };
}
```

**4.** Affiche `[3, 3, 3]`. Avec `var`, il n'existe **qu'une seule** variable `i`, partagée par les trois fonctions ; au moment de l'appel, la boucle est terminée et `i` vaut 3.

Correction 1, avec `let` — une nouvelle liaison par itération :
```js
for (let i = 0; i < 3; i++) fonctions.push(() => i);     // [0, 1, 2]
```
Correction 2, en capturant la valeur dans une fonction appelée immédiatement :
```js
for (var i = 0; i < 3; i++) fonctions.push(((v) => () => v)(i));
```
La seconde est la technique d'avant 2015. Savoir la **lire** te servira en mission de maintenance sur du code ancien.

**6.**
```js
function memoise(f) {
  const cache = new Map();                 // vit dans la closure, invisible de l'extérieur
  return function (n) {
    if (cache.has(n)) return cache.get(n);
    const resultat = f(n);
    cache.set(n, resultat);
    return resultat;
  };
}
```
Attention à un détail : pour que `fibonacci` profite vraiment du cache, il faut que **les appels récursifs** passent par la version mémoïsée :
```js
const fib = memoise(n => (n <= 1 ? n : fib(n - 1) + fib(n - 2)));
```
`fib(35)` devient instantané : on passe d'environ trente millions d'appels à trente-six. Tu viens de transformer une complexité exponentielle en complexité linéaire (leçon 12).

**7.** Chaque appel à la fabrique crée **un nouvel environnement**, donc un `compte` distinct. C'est exactement le mécanisme de l'état d'un composant React : deux instances du même composant ont chacune leur propre état, parce que chacune a son propre environnement capturé.

**8.** Le point important est le `lister` :
```js
lister: () => [...articles],      // ✅ une copie : l'extérieur ne peut pas muter l'intérieur
// lister: () => articles,        // ❌ on rend la référence : l'encapsulation est cassée
```
Retourner la référence interne annule tout l'intérêt du pattern — n'importe qui pourrait faire `panier.lister().push(...)`. C'est la leçon 04 et la leçon 05 qui se rejoignent.
</details>

---

## ✅ Acquis si…

- [ ] J'explique la portée de bloc et pourquoi `var` est abandonné.
- [ ] Je définis une closure en une phrase, **avec ma propre analogie**.
- [ ] J'explique le piège de capture dans une boucle, et je le corrige de deux façons.
- [ ] Je crée une variable privée avec une closure, et je sais ne pas en fuiter la référence.
- [ ] Je sais quand une fonction fléchée est inadaptée (méthode d'objet, à cause de `this`).
- [ ] J'ai écrit `memoise` et mesuré son effet.
- [ ] Je sais pourquoi deux closures créées par la même fabrique sont indépendantes.
- [ ] Je sais pourquoi cette leçon est un prérequis de React.

# Leçon 01 — Variables, types et opérateurs

> 🎯 **À la fin de cette leçon** : tu manipules des valeurs sans tomber dans les conversions de types qui piègent tous les débutants en JavaScript — et tu sais à quel endroit précis de ton code ces pièges se déclenchent.
> ⏱️ 3 h (1 h de lecture, 2 h de pratique) · **Prérequis** : [épreuve du palier 0](../../palier-00-fondations/evaluation.md) réussie.

---

## De quoi on parle

Une **variable** est un nom qui désigne une valeur en mémoire. Tu la **déclares** (`const total`), tu lui **affectes** une valeur (`= 1500`), et tu la réutilises par son nom.

Un **type** est la nature de cette valeur : du texte, un nombre, un booléen, un objet. JavaScript distingue les **primitifs** — `string`, `number`, `boolean`, `null`, `undefined` — des **objets**, catégorie qui englobe les objets littéraux, les tableaux, les fonctions et les dates.

Un **opérateur** est un symbole qui calcule ou compare : `+`, `-`, `===`, `&&`, `??`.

Et une notion de vocabulaire qui revient souvent : une **expression** est un morceau de code qui **produit une valeur** (`2 + 3`, `age >= 18`), tandis qu'une **instruction** est un morceau de code qui **fait quelque chose** (`let x = 1;`). La distinction compte dès la leçon 03 : une fonction retourne une expression, pas une instruction.

Enfin, le point qui définit JavaScript : il est **dynamiquement typé**. Le type est attaché à la **valeur**, pas à la variable. Une même variable peut contenir un texte puis un nombre, et rien ne t'en empêche. C'est souple, et c'est la source des bugs les plus déroutants du langage.

---

## À quoi ça sert, concrètement

C'est le vocabulaire de base : sans variables ni types, il n'y a pas de programme. Mais ce n'est pas pour ça que cette leçon mérite trois heures.

Elle les mérite parce que **JavaScript convertit silencieusement les types** quand il peut, et que cette commodité produit des résultats absurdes. `"5" + 3` donne `"53"`. `0 == ""` est vrai. `[] + {}` donne une chaîne. Tu ne mémoriseras pas ces cas — personne ne le fait — mais tu dois connaître les **deux ou trois règles** qui te mettent à l'abri de toute la famille.

Et elle les mérite parce que les décisions prises ici se répètent des milliers de fois : `const` ou `let`, `===` ou `==`, `||` ou `??`. Prises correctement dès le début, ces habitudes t'épargnent des heures de débogage sur dix-huit mois.

---

## Où ça intervient dans le développement

Voici la réponse utile, et elle est plus précise qu'« partout ».

Les bugs de type n'apparaissent pas au milieu de ton code : ils apparaissent **aux frontières**, là où des données entrent dans ton programme. Et à ces frontières, les données arrivent presque toujours sous forme de **texte**.

```
   ┌─────────────────────────────────────────────────────────┐
   │  LES FRONTIÈRES — tout arrive en texte ou en JSON       │
   │                                                          │
   │  un formulaire HTML        → TOUJOURS des chaînes        │  palier 2
   │  une query string (?id=5)  → TOUJOURS des chaînes        │  palier 4
   │  une réponse d'API (JSON)  → types déclarés, non garantis│  paliers 1, 3
   │  un fichier lu sur disque  → une chaîne                  │  palier 1
   │  une variable d'environnement → TOUJOURS une chaîne      │  palier 4
   │  une colonne de base       → selon le pilote             │  palier 4
   └─────────────────────────┬───────────────────────────────┘
                             │  ← c'est ICI qu'on convertit, explicitement
                             ▼
                     le cœur de ton programme
                     (où les types sont propres et sûrs)
```

Un exemple que tu vivras au palier 2 : l'utilisateur tape `1250` dans un champ de montant. Tu récupères `input.value`, qui vaut la **chaîne** `"1250"`. Tu fais `montant + 100` et tu obtiens `"1250100"` au lieu de `1350`. Le bug n'est pas dans ton addition : il est à la frontière, où tu n'as pas converti.

D'où la règle d'architecture qui découle de cette leçon : **convertis et valide explicitement tout ce qui entre, au point d'entrée**, puis travaille avec des types propres à l'intérieur. C'est exactement ce que font Zod au palier 4, Pydantic au palier 5 et les règles de validation de Laravel au palier 6. Tu construis maintenant l'intuition qui rendra ces outils évidents.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire beaucoup de petits scripts et les exécuter avec `node fichier.js`. Tu passeras ton temps à afficher des valeurs pour voir ce qu'elles contiennent, et tu découvriras que `console.log` est ton principal instrument de mesure.

Tu vas aussi te tromper souvent sur les types, et c'est l'objectif : les exercices de cette leçon sont conçus pour te faire rencontrer les conversions bizarres **maintenant**, dans un fichier de test, plutôt que dans trois mois au milieu d'un projet.

### En équipe, en entreprise

Trois choses t'attendent.

D'abord, **`const` est la norme**. Dans la plupart des équipes, un linter (ESLint) refusera un `let` qui n'est jamais réaffecté, et `var` sera purement interdit. Ce n'est pas du zèle : une variable qui ne peut pas changer est une variable dont on peut raisonner.

Ensuite, **`==` est interdit par le linter**, partout. Tu ne verras jamais `==` dans du code professionnel récent, sauf exception documentée.

Enfin, tu rencontreras **TypeScript** au palier 3, et ce sera un soulagement : il vérifie les types **avant** l'exécution et attrape précisément les bugs de cette leçon. Mais attention à un contresens fréquent : TypeScript disparaît à la compilation, donc il ne valide **rien** à l'exécution. Les données venant d'une API resteront à vérifier à la main. Les frontières restent des frontières.

### Ce qui sert tout le temps, et ce qui est rare

Au quotidien : `const`, `let`, les chaînes et leurs méthodes courantes, les nombres, les booléens, `===`, `&&`, `||`, `??`, `?.`, le ternaire, et les gabarits de chaîne (`` `${}` ``).

Régulièrement : `typeof`, `Number()`, `Number.isNaN()`, `toFixed`, `parseInt`.

Rare, et à ignorer : `Symbol`, `BigInt`, les conversions implicites exotiques (`valueOf`, `Symbol.toPrimitive`), `with`, `eval`, l'opérateur virgule, les opérateurs binaires (`&`, `|`, `<<`). Tu peux faire toute une carrière de développeur web sans écrire un seul `Symbol`. Si un tutoriel insiste dessus au niveau débutant, passe.

---

## La mécanique

### Déclarer : `const` par défaut

```js
const PI = 3.14159;        // ne sera jamais réaffecté
let compteur = 0;          // va changer
compteur += 1;
```

La règle est simple et elle ne souffre pas d'exception : **`const` par défaut, `let` seulement si la variable doit vraiment changer, `var` jamais**. `const` documente ton intention et le moteur t'avertit si tu te contredis.

Un piège classique qu'il faut avoir compris une fois pour toutes :

```js
const liste = [1, 2];
liste.push(3);     // ✅ autorisé
// liste = [4];    // ❌ TypeError
```

`const` empêche la **réaffectation du nom**, pas la **modification du contenu**. C'est une question d'entretien fréquente, et c'est la base de la leçon 04.

### Nommer : ça compte autant que le code

```js
// ❌                          // ✅
let x = 1500;                  const montantTotal = 1500;
let d = [];                    const depenses = [];
let flag = true;               const estConnecte = true;
function proc(a) {}            function calculerTotal(depenses) {}
```

Conventions JavaScript : `camelCase` pour les variables et fonctions, `PascalCase` pour les classes et les composants React, `MAJUSCULES_AVEC_UNDERSCORES` pour les vraies constantes globales. Les booléens commencent par `est`, `a`, `is`, `has`. Et **en anglais** autant que possible, comme le reste de ton code et de tes commits.

Ce n'est pas de la cosmétique : au palier 7, tu découvriras que nommer correctement est l'une des principales techniques de conception. Un nom juste remplace un commentaire.

### Les types, et comment les reconnaître

```js
typeof "texte"     // "string"
typeof 42          // "number"    — un seul type pour entiers et décimaux
typeof true        // "boolean"
typeof undefined   // "undefined" — déclaré, sans valeur
typeof null        // "object"    ⚠️ bug historique du langage, conservé par compatibilité
typeof {}          // "object"
typeof []          // "object"    ⚠️ pour un tableau : Array.isArray([]) → true
typeof function(){}// "function"
```

`null` et `undefined` se distinguent par **qui les a mis** : `undefined` veut dire « pas encore de valeur » (c'est le langage qui l'a mis), `null` veut dire « volontairement vide » (c'est toi qui l'as mis). La convention compte : renvoyer `null` quand on ne trouve rien est un choix explicite, renvoyer `undefined` est souvent un oubli.

### Les chaînes

```js
const prenom = "Serge";
const complet = `${prenom} Noah`;         // gabarit de chaîne, à privilégier

complet.length                             // 10
complet.toUpperCase()                      // "SERGE NOAH"
complet.includes("Noah")                   // true
complet.split(" ")                         // ["Serge", "Noah"]
"  espace  ".trim()                         // "espace"
complet.slice(0, 5)                         // "Serge"
complet.replace("Serge", "S.")              // "S. Noah"
```

Point capital : **les chaînes sont immuables**. `toUpperCase()` ne modifie pas `complet`, elle **retourne une nouvelle chaîne**. Écrire `maChaine.trim()` sans réaffecter le résultat est l'une des erreurs les plus universelles du débutant. C'est aussi une application directe du réflexe de la leçon « lire la documentation » du palier 0 : *qu'est-ce que ça retourne ?*

### Les nombres

```js
10 / 3            // 3.3333333333333335  — pas de division entière
Math.floor(10/3)  // 3
10 % 3            // 1   (modulo : le reste — parité, cycles, formatage)
2 ** 10           // 1024

0.1 + 0.2         // 0.30000000000000004  ⚠️
Number("42")      // 42
Number("abc")     // NaN
Number.isNaN(Number("abc"))   // true — la bonne façon de tester
```

`0.1 + 0.2 !== 0.3` n'est pas un défaut de JavaScript : c'est la représentation binaire des décimaux, et c'est vrai dans Python, en PHP, en Java, partout. La conséquence pratique est importante, et c'est le genre de détail qui te fera remarquer : **ne stocke jamais de l'argent en nombre décimal**. L'usage professionnel est de stocker les **centimes en entier** (`1500` pour 15,00 €) et de ne formater qu'à l'affichage. Note-le : tu y repenseras au palier 4 quand tu créeras une colonne de base de données pour des montants.

### Les booléens et les six valeurs fausses

```js
// Valeurs FALSY — il n'y en a que six, et il faut les connaître :
false, 0, "", null, undefined, NaN
// TOUT le reste est truthy, y compris : "0", "false", [], {}
```

Que `[]` et `{}` soient vrais surprend tout le monde une fois. D'où l'idiome correct pour tester un tableau vide : `if (depenses.length)`, et non `if (depenses)` qui est toujours vrai.

### Les opérateurs à connaître

```js
// Comparaison — TOUJOURS ===
5 === 5        // true
5 === "5"      // false     et c'est exactement ce qu'on veut
5 !== "5"      // true

// Logique
true && false  // false
true || false  // true
!true          // false

// Valeur par défaut : la différence qui compte
const nom1 = nomFourni || "Anonyme";       // si falsy → défaut
const nom2 = nomFourni ?? "Anonyme";       // ⭐ seulement si null ou undefined

// Chaînage optionnel
utilisateur?.adresse?.ville    // undefined au lieu d'une erreur si adresse est absente

// Ternaire : une expression conditionnelle
const statut = age >= 18 ? "majeur" : "mineur";
```

> ### La règle `===`
> **N'utilise jamais `==`.** `==` compare après conversion, et produit des résultats que personne ne peut prédire de mémoire : `"5" == 5` est vrai, `0 == ""` est vrai, `null == undefined` est vrai, `[] == false` est vrai. `===` compare valeur **et** type, sans surprise. Cette seule règle élimine une famille entière de bugs.

Et la distinction `||` / `??` mérite d'être comprise maintenant, parce qu'elle produit un bug silencieux très courant : `const quantite = saisie || 1` remplace un `0` légitime par `1`, puisque `0` est falsy. Avec `??`, le `0` est conservé. **`??` pour les valeurs par défaut, `||` seulement quand tu veux réellement écarter tout ce qui est falsy.**

---

## Les problèmes que tu vas rencontrer

**`NaN` apparaît quelque part dans ton affichage.** Tu as fait une opération arithmétique sur une valeur non numérique — souvent une chaîne venue d'un formulaire, ou une propriété absente d'un objet. Remonte à la frontière : d'où vient cette valeur, et l'as-tu convertie ?

**Deux nombres se concatènent au lieu de s'additionner.** `"5" + 3` donne `"53"`. Le `+` est le seul opérateur ambigu de JavaScript : dès qu'une chaîne est présente, il concatène. Les autres (`-`, `*`, `/`) convertissent en nombre. C'est pour ça que `"5" - 3` donne bien `2` — et cette incohérence surprend tout le monde.

**`undefined` s'affiche partout.** Soit une faute de frappe dans un nom de propriété (`depense.montantt`), soit tu accèdes à une donnée qui n'est pas encore arrivée (typique de l'asynchrone, leçon 09).

**`Cannot read properties of undefined`.** L'objet sur lequel tu accèdes n'existe pas. Le `?.` évite le plantage, mais ne règle pas la cause : demande-toi pourquoi il est absent.

**Un `0` ou une chaîne vide légitime disparaît.** Tu as utilisé `||` au lieu de `??`, ou `if (valeur)` au lieu de `if (valeur !== undefined)`.

**Un total est faux de quelques centimes.** Les décimaux flottants. Passe en centimes entiers.

**`toFixed(2)` casse un calcul suivant.** `toFixed` retourne une **chaîne**, pas un nombre. Si tu recalcules ensuite, repasse par `Number()`.

---

## Ce qu'on te demandera

Les questions de cette leçon sont les plus posées de tout l'entretien JavaScript junior, parce qu'elles vérifient en trente secondes si le candidat comprend le langage ou s'il l'imite.

Les classiques : « différence entre `let`, `const` et `var` », « pourquoi `===` plutôt que `==` », « cite les valeurs falsy », « que vaut `typeof null` », « pourquoi `0.1 + 0.2 !== 0.3` », « différence entre `null` et `undefined` », « pourquoi `const tableau = []` permet-il quand même `push` ».

On te donnera aussi des **expressions à prédire** : « que vaut `"5" + 3` ? et `"5" - 3` ? et `[] == false` ? ». Ce n'est pas un piège gratuit : celui qui répond correctement a compris la conversion implicite, et celui qui bafouille l'a subie sans jamais l'étudier.

En **revue de code**, on te reprendra sur les noms de variables avant toute autre chose. C'est la remarque la plus fréquente faite à un junior, toutes technologies confondues.

---

## Ce qui te démarquera

**Convertir explicitement aux frontières.** Écrire `const montant = Number(saisie); if (Number.isNaN(montant)) { ... }` au lieu de laisser JavaScript deviner. C'est une habitude d'ingénieur, et elle se remarque immédiatement dans une revue.

**Stocker l'argent en centimes entiers.** Peu de juniors y pensent, et c'est une erreur qu'on retrouve dans des applications en production. En parler te range du côté de ceux qui ont réfléchi au domaine, pas seulement au code.

**Utiliser `??` à bon escient.** Savoir expliquer *pourquoi* `||` est un bug sur un `0` montre une précision de raisonnement rare à ce niveau.

**Nommer juste.** `const depensesNonPayees` au lieu de `const d2`. Cela paraît trivial et c'est ce qui distingue le plus nettement un code lisible d'un code qu'il faut déchiffrer.

**Savoir que `typeof null` est un bug historique.** Petit détail, mais il montre que tu as lu sur le langage au lieu de seulement l'utiliser.

---

## 📚 À lire

**The Odin Project → Foundations → JavaScript Basics** (sections *Variables and Operators* puis *Data Types and Conditionals*) est ta ressource principale : progressive et orientée pratique.

**javascript.info**, chapitres 2.4 à 2.12, pour approfondir un point précis — c'est le meilleur livre JavaScript en ligne, et il est gratuit.

Et lis **une fois** la page MDN *Equality comparisons and sameness* : elle est aride, mais après elle tu ne te poseras plus jamais la question de `==`.

---

## 🤖 Le mini-projet à demander à l'IA

Les conversions de types s'apprennent en les **prédisant** puis en vérifiant. Demande-toi d'être interrogé :

> « Je suis en formation de développeur, palier 1 (JavaScript). Je travaille les types et les conversions. Donne-moi **25 expressions** JavaScript à évaluer de tête, mélangeant concaténation, comparaisons, valeurs falsy, `||` contre `??`, `typeof` et `NaN`. Présente-les **une par une**, attends ma réponse, et après chacune dis-moi si j'ai juste et **explique la règle** en une phrase — sans me donner la liste complète d'avance. Commence facile et monte en difficulté. »

Puis l'exercice qui fait le lien avec le vrai métier :

> « Écris-moi l'énoncé d'un petit exercice Node où je reçois des données "sales" comme si elles venaient d'un formulaire web : un objet dont tous les champs sont des chaînes, avec des valeurs limites (chaîne vide, `"0"`, `"abc"`, espaces en trop, `"-5"`, un nombre très grand). Ma mission sera d'écrire une fonction qui les convertit et les valide proprement. **Donne-moi seulement les données et la liste des cas à gérer, pas la solution.** Ensuite, critique ma fonction : quels cas ai-je oubliés ? »

Ce second exercice est exactement ce que tu feras au palier 4 avec Zod. Le faire à la main maintenant te fera comprendre à quoi sert un outil de validation.

---

## 🛠️ À faire

> Crée `~/dev/exos-palier1/` et un fichier par exercice. Exécute avec `node fichier.js`. **Tape tout, ne colle rien** — c'est la règle du palier.

1. Déclare les variables décrivant une dépense (montant en centimes, catégorie, description, date, payée ou non) avec le bon type et le bon mot-clé pour chacune, puis affiche une phrase récapitulative avec un gabarit de chaîne.
2. **Prédis puis vérifie** chacune de ces expressions. Note celles où tu t'es trompé : ce sont tes vraies lacunes.
   ```js
   "5" + 3 ;  "5" - 3 ;  5 + true ;  [] + {} ;  "abc" * 2
   0 === -0 ;  NaN === NaN ;  null === undefined ;  null == undefined
   Boolean("") ;  Boolean("0") ;  Boolean([]) ;  Boolean({})
   ```
3. Écris un convertisseur : depuis un montant en centimes, affiche `"15,00 €"`. Vérifie sur 5, 50, 500 et 123456.
4. Soit `const prix = "1250"` (une chaîne, comme en viendrait d'un formulaire). Calcule une TVA de 19,25 % et affiche le total à deux décimales. Où est le piège, et que se passerait-il avec `prix + 100` ?
5. Teste la différence entre `||` et `??` avec les valeurs `0`, `""`, `null` et `undefined`. Dans quel cas `||` produit-il un bug ?
6. Écris une fonction `convertirSaisie(valeur)` qui prend une chaîne et retourne soit un nombre valide, soit `null`. Fais-la passer sur `"42"`, `"0"`, `""`, `"  7 "`, `"abc"`, `"-3"`, `"3.5"`.
7. **Le piège de l'immuabilité** : prends `let nom = "  serge  "`, applique `trim()` et `toUpperCase()` **sans réaffecter**, affiche `nom`, et explique ce que tu observes.

<details>
<summary>Corrections</summary>

**2.** `"5" + 3` → `"53"` (le `+` concatène dès qu'une chaîne est présente) · `"5" - 3` → `2` (le `-` n'existe pas pour les chaînes, donc conversion numérique) · `5 + true` → `6` (`true` vaut 1) · `[] + {}` → `"[object Object]"` · `"abc" * 2` → `NaN` · `0 === -0` → `true` · `NaN === NaN` → **`false`** (seule valeur différente d'elle-même, d'où `Number.isNaN()`) · `null === undefined` → `false` · `null == undefined` → `true` (toute la raison d'être de `===`) · `Boolean("")` → `false` · `Boolean("0")` → **`true`** (chaîne non vide !) · `Boolean([])` → **`true`** · `Boolean({})` → `true`.

**3.**
```js
function formaterCentimes(centimes) {
  const euros = Math.floor(centimes / 100);
  const reste = String(centimes % 100).padStart(2, "0");
  return `${euros},${reste} €`;
}
```
`5` → `"0,05 €"`, `123456` → `"1234,56 €"`. On pourrait écrire `(centimes/100).toFixed(2)` — ça marche ici, mais on réintroduit le flottant, et sur des calculs répétés l'erreur s'accumule.

**4.** `prix * 1.1925` fonctionne (conversion implicite par `*`), mais `prix + 100` donnerait `"1250100"`. La bonne pratique :
```js
const prix = Number("1250");
if (Number.isNaN(prix)) throw new Error("prix invalide");
const total = (prix * 1.1925).toFixed(2);     // "1490.63" — c'est une CHAÎNE
```
Deuxième piège : `toFixed` retourne une chaîne. Si tu recalcules derrière, repasse par `Number()`.

**5.** `0 || "défaut"` → `"défaut"` ❌ alors que `0` est une valeur légitime (un montant nul, un compteur à zéro). `0 ?? "défaut"` → `0` ✅. Même chose pour `""`.

**6.**
```js
function convertirSaisie(valeur) {
  if (typeof valeur !== "string") return null;
  const nettoyee = valeur.trim();
  if (nettoyee === "") return null;              // le cas que tout le monde oublie
  const nombre = Number(nettoyee);
  return Number.isNaN(nombre) ? null : nombre;
}
```
Attention à un piège : `Number("")` vaut **`0`**, pas `NaN`. Sans le test de chaîne vide, un champ laissé vide deviendrait silencieusement un montant de zéro. C'est un vrai bug de production, et c'est exactement le genre de cas qu'un outil de validation gère pour toi au palier 4.

**7.** `nom` vaut toujours `"  serge  "`. Les méthodes de chaîne **retournent** une nouvelle chaîne sans modifier l'originale. Il faut `nom = nom.trim().toUpperCase();`. Pose-toi désormais systématiquement la question : *est-ce que ça modifie, ou est-ce que ça retourne ?*
</details>

---

## ✅ Acquis si…

- [ ] J'utilise `const` par défaut et je sais justifier chaque `let`.
- [ ] J'explique pourquoi `const liste = []` permet quand même `liste.push(1)`.
- [ ] J'utilise `===` systématiquement et je sais dire ce que `==` fait de travers.
- [ ] Je cite les six valeurs falsy de mémoire.
- [ ] Je distingue `||` de `??` et je donne un cas où `||` est un bug.
- [ ] Je convertis explicitement toute donnée venue de l'extérieur, et je teste `NaN` correctement.
- [ ] Je sais pourquoi l'argent se stocke en centimes entiers.
- [ ] Je sais que les méthodes de chaîne **retournent** au lieu de modifier.
- [ ] Mes noms de variables sont explicites, en anglais, en camelCase.

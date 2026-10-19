# Leçon 02 — Conditions et boucles

> 🎯 **À la fin de cette leçon** : tu contrôles le déroulement d'un programme, tu choisis la bonne boucle sans hésiter, et tu écris des conditions qui restent lisibles quand elles se compliquent.
> ⏱️ 4 h (1 h de lecture, 3 h de pratique) · **Prérequis** : leçon 01.

---

## De quoi on parle

Une **condition** exécute un bloc de code si une expression est vraie. Une **boucle** répète un bloc, soit tant qu'une condition reste vraie, soit pour chaque élément d'une collection. Ensemble, on les appelle les **structures de contrôle**, parce qu'elles contrôlent l'ordre d'exécution.

Autour d'elles, quelques termes qui reviendront : une **itération** est un tour de boucle ; un **compteur** est la variable qui suit l'avancement (`i`, par convention) ; `break` sort de la boucle, `continue` passe au tour suivant ; et une **boucle infinie** est une boucle dont la condition ne devient jamais fausse — le programme se bloque, et on l'arrête avec `Ctrl+C`.

---

## À quoi ça sert, concrètement

Un programme qui exécute ses lignes de haut en bas, une seule fois, ne sert à rien. **Tout programme réel décide et répète.**

Mais il y a une idée plus intéressante derrière, et elle vaut la peine d'être posée dès maintenant : **une condition exprime une règle métier**. `if (montant > budget)` n'est pas une acrobatie technique, c'est une règle de ton domaine écrite en code. `if (utilisateur.role !== "admin")` est une règle de sécurité. `if (stock === 0)` est une règle commerciale.

Cette façon de voir change deux choses. D'une part, la lisibilité devient un enjeu sérieux : une condition qu'on ne comprend pas est une règle métier qu'on ne peut pas vérifier — et c'est ainsi qu'on livre un bug de facturation. D'autre part, c'est dans tes conditions que vit la valeur de ton application, ce qui explique pourquoi elles doivent être testées en priorité (palier 4).

---

## Où ça intervient dans le développement

Les conditions et les boucles sont le tissu même du code, mais elles interviennent de façon caractéristique à certains endroits.

**En entrée de fonction**, pour éliminer les cas invalides — c'est le réflexe des clauses de garde, expliqué plus bas, et tu le réappliqueras dans les quatre langages du parcours.

**Dans les règles d'autorisation**, au palier 4 : « cet utilisateur a-t-il le droit de voir cette ressource ? ». Une condition mal écrite ici n'est pas un bug d'affichage, c'est une faille de sécurité.

**Dans le rendu d'interface**, aux paliers 2 et 3 : afficher un message si la liste est vide, un indicateur de chargement pendant l'attente, une erreur si l'appel a échoué. Tu découvriras au palier 3 que React utilise le **ternaire** et le `&&` précisément parce qu'il a besoin d'**expressions** et non d'instructions — et la distinction de la leçon 01 prendra tout son sens.

**Dans les boucles de traitement de données**, où tu découvriras à la leçon 06 que les boucles manuelles sont le plus souvent remplaçables par `map`, `filter` et `reduce`. C'est important de le savoir dès maintenant : **cette leçon t'apprend les boucles pour que tu comprennes ce que la leçon 06 automatise**. Tu écriras moins de `for` que tu ne l'imagines — mais tu dois savoir en écrire.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire beaucoup de `if` et de boucles, et tu vas les écrire **mal** au début : imbriqués sur trois niveaux, avec des conditions illisibles. C'est normal, et cette leçon existe pour installer les deux habitudes qui corrigent ça — les clauses de garde et les conditions nommées.

Tu vas aussi écrire ta première boucle infinie, et bloquer ton terminal. C'est un rite de passage : `Ctrl+C`, et tu regardes pourquoi ta condition ne devenait jamais fausse.

### En équipe, en entreprise

Trois remarques reviennent systématiquement en revue de code, et les anticiper te fera gagner du crédit.

« **Trop d'imbrication.** » Au-delà de deux niveaux de `if` imbriqués, un relecteur demande un refactoring. La solution est presque toujours les clauses de garde.

« **Cette condition est illisible, extrais-la.** » `if (u && (u.actif || u.invite) && !u.banni && u.age >= 18)` doit devenir `if (peutAcceder(u))` ou au minimum `const peutAcceder = ...` sur une ligne nommée. Le code devient alors auto-documenté.

« **Utilise `map`/`filter` plutôt qu'une boucle.** » Dès que ta boucle ne fait que transformer ou sélectionner (leçon 06).

Tu verras aussi que les équipes aiment les **retours anticipés** : une fonction qui sort dès que possible plutôt qu'une fonction avec un seul `return` à la fin et six niveaux de `else`.

### Ce qui sert tout le temps, et ce qui est rare

Au quotidien : `if`/`else if`/`else`, le ternaire, `for...of`, et les clauses de garde.

Régulièrement : `while` (quand le nombre de tours est inconnu), `break` et `continue`, le `for` classique avec index (quand tu as vraiment besoin de l'index), `switch` ou son remplacement par un objet de correspondance.

Rare, et sans intérêt pour l'instant : `do...while`, les étiquettes de boucle (`label:`), `for...in` sur des tableaux (c'est même une erreur), les boucles imbriquées sur trois niveaux (c'est le signe d'un problème de conception). Et `switch` lui-même est moins fréquent qu'on ne le croit en JavaScript moderne : on le remplace souvent par un objet.

---

## La mécanique

### Les conditions

```js
if (montant <= 0) {
  console.log("Montant invalide");
} else if (montant > budget) {
  console.log("Dépassement de budget");
} else {
  console.log("OK");
}
```

Rien de surprenant. L'intérêt est ailleurs : dans la manière de les organiser.

### Les clauses de garde : l'habitude la plus rentable de la leçon

```js
// ❌ L'escalier : illisible dès trois niveaux, et le "vrai code" est perdu au fond
function ajouter(depense) {
  if (depense) {
    if (depense.montant > 0) {
      if (depense.categorie) {
        // le vrai code, à trois niveaux de profondeur
      }
    }
  }
}

// ✅ On élimine les cas invalides d'abord, le cas normal reste à plat
function ajouter(depense) {
  if (!depense) return "dépense manquante";
  if (depense.montant <= 0) return "montant invalide";
  if (!depense.categorie) return "catégorie manquante";
  // le vrai code, au premier niveau
}
```

Les deux versions font la même chose. La seconde se lit d'un coup d'œil, chaque règle est visible sur sa ligne, et ajouter une quatrième condition ne déforme rien. **C'est l'un des refactorings les plus utiles du métier**, et tu le réappliqueras en Python, en PHP et en Dart. Prends l'habitude maintenant.

### Extraire les conditions complexes

```js
// ❌ Que vérifie-t-on, au fait ?
if (u && (u.actif || u.invite) && !u.banni && u.age >= 18) { ... }

// ✅ Le nom remplace le commentaire
const estMajeur = u.age >= 18;
const aUnAcces = u.actif || u.invite;
const peutAcceder = u && aUnAcces && !u.banni && estMajeur;
if (peutAcceder) { ... }
```

Le gain n'est pas esthétique : il est que la **règle métier devient nommée**, donc discutable avec un non-technicien, et testable isolément.

### `switch`, et son remplaçant

```js
switch (commande) {
  case "add":
    ajouter(); break;             // ⚠️ sans break, l'exécution CONTINUE au cas suivant
  case "list":
  case "ls":                       // plusieurs étiquettes, un seul traitement
    lister(); break;
  default:
    console.log("Commande inconnue");
}
```

`switch` compare avec `===`. C'est utile pour une variable à quelques valeurs discrètes — par exemple les commandes de ton projet 1. Mais au-delà de cinq ou six cas, un **objet de correspondance** est plus propre et plus souple :

```js
const actions = { add: ajouter, list: lister, del: supprimer };
(actions[commande] ?? afficherAide)();
```

Cette forme est celle que tu retrouveras dans les routeurs (palier 4, 5, 6) : une table qui associe une clé à un comportement. Ce n'est pas un hasard — un routeur **est** un `switch` qu'on a sorti du code.

### Les boucles, et comment choisir

```js
// for...of : POUR CHAQUE élément — le plus lisible, à privilégier
for (const depense of depenses) {
  console.log(depense.montant);
}

// for classique : quand tu as besoin de l'index
for (let i = 0; i < depenses.length; i++) {
  console.log(i, depenses[i]);
}

// for...in : pour les CLÉS d'un objet (⚠️ jamais pour un tableau)
for (const cle in config) {
  console.log(cle, config[cle]);
}

// while : nombre de tours inconnu
let reponse = demander();
while (reponse !== "quit") {
  traiter(reponse);
  reponse = demander();
}
```

Le choix se fait sur l'**intention**, pas par habitude. Pour chaque élément → `for...of`. Besoin de l'index → `for` classique. Jusqu'à ce qu'une condition change → `while`. Transformer une collection → `map` (leçon 06). Sélectionner → `filter`. Agréger → `reduce`.

Un débutant écrit tout avec `for (let i = 0; ...)`. Un développeur choisit l'outil qui **dit** son intention : c'est la différence entre du code qui marche et du code qui se lit.

### `break` et `continue`

```js
for (const d of depenses) {
  if (d.montant <= 0) continue;      // ignorer celle-ci, passer à la suivante
  if (d.categorie === "stop") break;  // quitter la boucle entièrement
  total += d.montant;
}
```

Retiens une chose qui servira à la leçon 06 : **`break` est la raison pour laquelle on garde parfois une boucle classique**. `map` et `filter` parcourent toujours l'intégralité du tableau ; ils n'ont pas de sortie anticipée.

---

## Les problèmes que tu vas rencontrer

**Ta boucle ne s'arrête pas.** Ta condition ne devient jamais fausse, en général parce que tu as oublié d'incrémenter le compteur, ou parce que la variable testée est modifiée ailleurs que tu ne crois. `Ctrl+C`, puis relis la ligne qui doit faire évoluer la condition.

**`if (x = 5)` au lieu de `if (x === 5)`.** Un seul `=` affecte au lieu de comparer, et le résultat est toujours vrai. Un linter l'attrape ; sans linter, c'est un bug très difficile à voir à l'œil.

**Ton `switch` exécute plusieurs cas.** Un `break` manquant. L'exécution « tombe » dans le cas suivant, et c'est un comportement volontaire du langage — rarement ce que tu voulais.

**Tu modifies un tableau en le parcourant.** `splice` ou `push` à l'intérieur d'un `for` sur ce même tableau décale les index : des éléments sont sautés, ou la boucle ne finit jamais. La bonne pratique est de construire un **nouveau** tableau (leçon 04 et 06).

**`for...in` sur un tableau te donne des chaînes.** Les index arrivent sous forme de `"0"`, `"1"`, `"2"`, et l'ordre n'est pas garanti sur tous les objets. `for...in` est pour les objets, `for...of` pour les tableaux.

**Ta condition compare des objets et c'est toujours faux.** `{a:1} === {a:1}` vaut `false` : deux objets distincts sont comparés par **référence**, pas par contenu (leçon 04).

**Le cas combiné ne se déclenche jamais.** Classique de FizzBuzz : dans un `if/else if`, **le cas le plus spécifique doit passer en premier**. Si tu testes « multiple de 3 » avant « multiple de 3 et de 5 », le second ne sera jamais atteint.

---

## Ce qu'on te demandera

En **test technique junior**, on te donnera presque certainement un exercice qui se résout avec des conditions et des boucles — **FizzBuzz** reste l'exemple canonique, et il est encore utilisé, précisément parce qu'il élimine les candidats qui ne savent pas programmer du tout. On te demandera aussi de vérifier si un nombre est premier, de compter des occurrences, de trouver un maximum.

Ce qu'on **regarde** dans ces exercices n'est pas seulement le résultat : c'est si tu as pensé aux **cas limites** (tableau vide, zéro, valeurs négatives), si tes conditions sont lisibles, et si tu as nommé tes variables.

En **revue de code**, on te reprendra sur l'imbrication et sur les conditions complexes non extraites. Ce sont les deux remarques les plus fréquentes sur du code de débutant, après le nommage.

En **entretien oral**, on peut te demander la différence entre `for`, `for...of` et `for...in`, ou pourquoi les clauses de garde sont préférables à l'imbrication.

---

## Ce qui te démarquera

**Écrire les clauses de garde par réflexe.** Un code à plat, où chaque règle est visible sur une ligne, est immédiatement reconnaissable — et beaucoup de développeurs confirmés ne le font toujours pas.

**Nommer tes conditions.** `const peutEtreSupprimee = ...` au lieu d'une expression de quarante caractères dans le `if`. C'est la technique la plus simple pour rendre une règle métier compréhensible.

**Penser aux cas limites spontanément.** Tableau vide, division par zéro, valeur absente, nombre négatif. Dans un test technique, le candidat qui dit « et si la liste est vide ? » **avant** d'écrire le code se distingue en une phrase.

**Choisir la boucle qui exprime l'intention.** Et savoir dire pourquoi : « ici j'ai besoin de `break`, donc je garde un `for...of` plutôt qu'un `filter` ».

---

## 📚 À lire

**The Odin Project → Foundations**, sections *Data Types and Conditionals* puis ***Problem Solving*** — cette dernière est la plus importante de la leçon : elle t'apprend à décomposer un problème avant de coder, et c'est une compétence qui pèse plus que la syntaxe.

**javascript.info** chapitres 2.13 à 2.17 (conditions, opérateurs logiques, boucles, `switch`) pour la référence précise.

Et la page MDN *Loops and iteration* contient un tableau comparatif des boucles qui vaut la lecture une fois.

---

## 🤖 Le mini-projet à demander à l'IA

Les conditions et les boucles s'apprennent en résolvant des petits problèmes, et c'est exactement ce que l'IA fabrique bien :

> « Je suis en formation de développeur, palier 1 (JavaScript). Je travaille les conditions et les boucles. Donne-moi **10 problèmes progressifs** à résoudre, du niveau FizzBuzz jusqu'à un problème demandant deux boucles imbriquées et une sortie anticipée. Pour chaque problème, précise **les cas limites que je dois gérer** (sans me dire comment). **Ne donne aucune solution.** Je te soumettrai mon code et tu le critiqueras sur trois points seulement : les cas limites oubliés, la lisibilité des conditions, et le choix de la boucle. »

Puis l'exercice de refactoring, qui est celui qui fait vraiment progresser :

> « Écris-moi une fonction JavaScript de 25 lignes **volontairement mal écrite** : conditions imbriquées sur quatre niveaux, une condition complexe non nommée, un `switch` sans `break`, et un cas limite non traité. Ne me dis pas où sont les défauts. Ma mission : les trouver et la réécrire sans changer son comportement. Ensuite, compare ma version à ce que tu attendais. »

---

## 🛠️ À faire

1. **FizzBuzz** : de 1 à 100, affiche le nombre, mais `"Fizz"` si multiple de 3, `"Buzz"` si multiple de 5, `"FizzBuzz"` si les deux. Puis **inverse l'ordre de tes tests** et observe ce qui casse : la leçon est là.
2. Écris `estPremier(n)`. Optimise ensuite pour ne tester que jusqu'à la racine carrée de `n`, et **explique pourquoi c'est suffisant**.
3. **Catégoriseur de dépenses** : à partir d'un tableau de dépenses `{montant, categorie}`, affiche pour chacune `"OK"`, `"Grosse dépense"` (> 50 000) ou `"Montant invalide"` (≤ 0). Utilise des clauses de garde.
4. **Refactorise** cette fonction avec des clauses de garde, sans changer son comportement :
   ```js
   function valider(u) {
     if (u) { if (u.email) { if (u.email.includes("@")) { if (u.age >= 18) { return "valide"; }
     else { return "mineur"; } } else { return "email invalide"; } } else { return "email manquant"; } }
     else { return "utilisateur manquant"; }
   }
   ```
5. Extrais la condition complexe suivante en variables nommées, puis réécris le `if` :
   ```js
   if (cmd && cmd.statut !== "annulee" && (cmd.payee || cmd.client.vip) && cmd.lignes.length > 0) { ... }
   ```
6. Table de multiplication de 1 à 9, alignée, avec deux boucles imbriquées.
7. **Devinette dichotomique** : un nombre secret entre 1 et 100 ; simule des tentatives qui divisent l'intervalle par deux à chaque fois. Affiche chaque tentative. Combien en faut-il **au maximum**, et pourquoi ?
8. Écris une boucle qui parcourt un tableau de commandes et s'arrête **dès** qu'elle trouve une commande non payée, en affichant son identifiant. Pourquoi une boucle ici plutôt qu'un `filter` ?

<details>
<summary>Corrections</summary>

**1.** L'ordre est tout :
```js
for (let i = 1; i <= 100; i++) {
  let sortie = "";
  if (i % 3 === 0) sortie += "Fizz";
  if (i % 5 === 0) sortie += "Buzz";
  console.log(sortie || i);        // le court-circuit remplace un if/else
}
```
Cette version évite le problème d'ordre en **composant** la sortie. Avec un `if/else if`, il faut impérativement tester le cas `i % 15 === 0` en premier — sinon 15 affiche `"Fizz"`. Retiens la règle : **dans un `if/else if`, le cas le plus spécifique passe en premier.**

**2.**
```js
function estPremier(n) {
  if (!Number.isInteger(n) || n < 2) return false;   // les cas limites d'abord
  if (n % 2 === 0) return n === 2;
  for (let i = 3; i * i <= n; i += 2) {
    if (n % i === 0) return false;
  }
  return true;
}
```
Pourquoi la racine suffit : si `n = a × b`, alors l'un des deux facteurs est forcément inférieur ou égal à `√n`. Chercher au-delà revient à retrouver les mêmes paires dans l'autre sens. On écrit `i * i <= n` plutôt que `i <= Math.sqrt(n)` pour éviter de recalculer une racine à chaque tour.

**4.**
```js
function valider(u) {
  if (!u) return "utilisateur manquant";
  if (!u.email) return "email manquant";
  if (!u.email.includes("@")) return "email invalide";
  if (u.age < 18) return "mineur";
  return "valide";
}
```
Même comportement, cinq lignes à plat, chaque règle lisible d'un coup d'œil. Compare le temps qu'il te faut pour comprendre chaque version.

**5.**
```js
const estActive = cmd.statut !== "annulee";
const estFacturable = cmd.payee || cmd.client.vip;
const aDesLignes = cmd.lignes.length > 0;
if (cmd && estActive && estFacturable && aDesLignes) { ... }
```
Trois noms, et la règle métier devient discutable avec le client. C'est ça, l'enjeu.

**7.** Sept tentatives suffisent toujours, parce que chaque essai divise l'intervalle par deux et que 2⁷ = 128 > 100. C'est la **recherche dichotomique**, en complexité logarithmique (leçon 12). Et c'est **le même principe** que la technique de débogage « couper le problème en deux » du [guide de débogage](../../guides/deboguer-methodiquement.md) et que `git bisect`. Un concept, trois applications — c'est exactement ce que le parcours cherche à te faire voir.

**8.** Parce que tu veux **t'arrêter** dès que tu as trouvé. `filter` parcourrait tout le tableau inutilement. En réalité, pour « trouver le premier qui correspond », JavaScript a `find` (leçon 06) — mais si tu as besoin de faire autre chose au moment de l'arrêt, `for...of` + `break` reste le bon outil. L'important est de pouvoir justifier ton choix.
</details>

---

## ✅ Acquis si…

- [ ] J'écris FizzBuzz sans aide en moins de cinq minutes, et j'explique le piège de l'ordre des tests.
- [ ] J'utilise des clauses de garde au lieu d'imbriquer, par réflexe.
- [ ] J'extrais les conditions complexes dans des variables nommées.
- [ ] Je choisis entre `for`, `for...of`, `for...in` et `while` en justifiant mon choix.
- [ ] Je sais pourquoi `for...in` ne doit pas servir à parcourir un tableau.
- [ ] Je pense aux cas limites (vide, zéro, négatif) **avant** d'écrire le code.
- [ ] J'ai déjà écrit, puis interrompu, une boucle infinie — et je sais pourquoi elle l'était.
- [ ] Je sais dans quel cas `break` justifie de garder une boucle classique.

# Leçon 08 — Erreurs et débogage

> 🎯 **À la fin de cette leçon** : tu lis une stack trace calmement, tu gères les erreurs au lieu de les subir, et tu utilises un débogueur plutôt que de deviner.
> ⏱️ 3 h · **Prérequis** : leçons 01–07.
> 🧭 La **méthode générale** (les 7 étapes, quand s'arrêter) est dans [deboguer-methodiquement.md](../../guides/deboguer-methodiquement.md). Ici : les mécanismes JavaScript.
>
> **C'est après cette leçon que tu peux commencer le [projet 1](../projet.md).**

---

## De quoi on parle

Une **exception** est une erreur qui **interrompt** le flux normal d'exécution. On la **lève** avec `throw`, et on peut l'**intercepter** avec `try/catch`. Si personne ne l'intercepte, le programme s'arrête.

La **stack trace** est la pile des appels de fonction au moment de l'erreur : elle raconte *comment* on est arrivé là.

Et il faut distinguer trois familles d'erreurs, parce qu'elles se traitent différemment. Une erreur de **syntaxe** empêche le code de démarrer. Une erreur d'**exécution** survient pendant le fonctionnement, sur une valeur inattendue. Une erreur de **logique** ne provoque aucun message : le programme tourne et le résultat est faux.

---

## À quoi ça sert, concrètement

**Parce que tu vas passer plus de temps à déboguer qu'à écrire.** C'est une réalité du métier que personne ne dit aux débutants : la part d'une journée consacrée à comprendre pourquoi quelque chose ne marche pas dépasse largement celle consacrée à produire du code neuf. Rendre ce temps efficace est donc l'investissement le plus rentable de tout le palier.

**Parce qu'un message d'erreur est une information, pas une punition.** Il a été écrit par quelqu'un qui savait exactement ce qui n'allait pas. Dans la grande majorité des cas, **la réponse est dans le message** — qui n'a simplement pas été lu.

**Parce que gérer les erreurs est ce qui sépare un script d'un logiciel.** Un script plante à la première donnée inattendue. Un logiciel affiche un message clair et continue. Entre les deux, il y a cette leçon — et c'est un critère explicite de ton projet 1 : « entrée invalide = message clair, jamais un plantage ».

---

## Où ça intervient dans le développement

Les erreurs interviennent exactement là où ton programme **touche le monde extérieur**, et c'est une bonne nouvelle : la zone à surveiller est délimitée.

```
   zone sûre (tes calculs)        │  zone à risque (le monde extérieur)
   ─────────────────────────       │  ───────────────────────────────────
   fonctions pures                 │  lire un fichier       → absent ? illisible ?
   transformations de données      │  appeler le réseau     → coupé ? 500 ? lent ?
   calculs                         │  JSON.parse            → texte invalide ?
                                   │  saisie utilisateur    → vide ? aberrante ?
                                   │  base de données       → indisponible ?
                                   └── c'est ICI qu'on met les try/catch
```

Le principe d'architecture qui en découle, et que tu appliqueras à chaque palier : **n'entoure de `try/catch` que ce qui peut échouer pour des raisons extérieures**. Un `try` géant autour de cinquante lignes ne dit plus ce qui a échoué ; un `try` ciblé autour d'un `JSON.parse` est précis et utile.

Et il y a une progression à connaître d'avance. Au palier 1, une erreur fait planter ton script. Au palier 2, elle casse l'affichage d'une page. Au palier 4, elle doit devenir un **code HTTP** (`400` pour une saisie invalide, `500` pour un plantage — leçon 07 du palier 0), et tu mettras en place un gestionnaire d'erreurs centralisé. Au palier 8, elle devra être **journalisée** pour être retrouvée en production, parce que tu ne seras pas devant l'écran quand elle se produira.

> Le réflexe le plus important, et il vaut dès maintenant : **échouer tôt et clairement**. Plus une erreur est détectée près de sa cause, moins elle coûte. Une donnée invalide acceptée en entrée réapparaît trois fonctions plus loin sous une forme incompréhensible — et tu débogues au mauvais endroit.

```js
// ❌ L'erreur se propage et explosera plus tard, loin de sa cause
function ajouterDepense(montant) {
  depenses.push({ montant });              // montant === undefined ? on accepte
}

// ✅ On refuse l'invalide à l'entrée : l'erreur dit où et pourquoi
function ajouterDepense(montant) {
  if (typeof montant !== "number" || Number.isNaN(montant)) {
    throw new TypeError(`montant doit être un nombre, reçu : ${typeof montant}`);
  }
  if (montant <= 0) throw new RangeError(`montant doit être positif, reçu : ${montant}`);
  depenses.push({ montant });
}
```

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas voir beaucoup de stack traces, et ta première réaction sera de les survoler. L'exercice de cette leçon est d'apprendre à les **lire** : trois lignes suffisent, à condition de savoir lesquelles.

Tu vas aussi découvrir le débogueur de VS Code, et c'est le moment de le faire. La plupart des développeurs n'utilisent jamais autre chose que `console.log`, et s'en portent mal : dix minutes d'apprentissage ici t'épargnent des heures sur dix-huit mois.

### En équipe, en entreprise

Trois constats t'attendent.

**Les erreurs silencieuses sont le vrai danger.** Un `catch` vide (`catch (e) {}`) est considéré comme une faute professionnelle : il transforme un bug bruyant en bug invisible, qui se manifestera trois mois plus tard sous une forme incompréhensible. Les linters signalent cette construction.

**Les messages d'erreur sont destinés à deux publics différents.** L'utilisateur doit recevoir un message compréhensible et sans détail technique ; le développeur doit recevoir la trace complète dans les journaux. Mélanger les deux est une erreur de conception — et exposer la trace à l'utilisateur est une faille de sécurité (tu verras pourquoi au palier 5 avec `DEBUG = True`).

**On attend de toi que tu lises avant de demander.** La première réponse d'un collègue à « ça marche pas » est « qu'est-ce que dit l'erreur ? ». Arriver avec le message exact et ce que tu as déjà vérifié change complètement la conversation — c'est d'ailleurs la [règle des 3](../../methode-et-referent.md) de ce parcours.

### Ce qui sert tout le temps, et ce qui est rare

Au quotidien : lire une stack trace, `console.log` étiqueté, `try/catch` ciblé, les messages d'erreur de l'onglet Console.

Régulièrement : lever ses propres erreurs avec un type (`TypeError`, `RangeError`), `console.table`, les points d'arrêt du débogueur, `finally`.

Rare, et hors sujet pour l'instant : les classes d'erreur personnalisées élaborées avec hiérarchie, `Error.cause`, `AggregateError`, les gestionnaires globaux (`process.on("uncaughtException")`), les traces asynchrones détaillées. Tu écriras **une** classe d'erreur personnalisée dans cette leçon, et ce sera suffisant pour longtemps.

---

## La mécanique

### Lire une stack trace

```
TypeError: Cannot read properties of undefined (reading 'montant')
    at calculerTotal (/home/sergeo/dev/depenses/src/calculs.js:12:28)   ← TON CODE : commence ici
    at afficherRapport (/home/sergeo/dev/depenses/src/cli.js:45:17)     ← qui l'a appelée
    at main (/home/sergeo/dev/depenses/index.js:8:3)
    at node:internal/modules/run_main:122:12                            ← interne : ignore
```

Lis dans cet ordre : le **type** (`TypeError` → une valeur n'est pas du type attendu), le **message** (on a fait `.montant` sur `undefined`), puis **la première ligne qui pointe vers un de tes fichiers**. Les lignes au-dessus, dans `node_modules` ou dans les modules internes, se sautent.

Et pose-toi ensuite la seule question qui compte : **pourquoi cette valeur est-elle `undefined` ?** L'erreur n'est presque jamais à la ligne 12 — elle y est seulement **révélée**. La cause est dans ce qui a produit la valeur, souvent plusieurs fonctions en amont. C'est pour ça que la liste des appels est utile : elle te dit avec quelles données tu es arrivé là.

### Les erreurs JavaScript les plus fréquentes

`Cannot read properties of undefined (reading 'x')` : l'objet n'existe pas. Tableau vide, `find` qui n'a rien trouvé, clé mal orthographiée, réponse d'API différente de l'attendu.

`x is not a function` : faute de frappe, import manquant, ou tu appelles un résultat au lieu d'une fonction (leçon 03).

`x is not defined` : variable non déclarée, hors de portée, ou import oublié.

`Unexpected token` : erreur de **syntaxe**. Une parenthèse, une accolade ou une virgule — et souvent **avant** la ligne indiquée.

`Cannot access 'x' before initialization` : usage d'un `let`/`const` avant sa déclaration (leçon 05).

`Maximum call stack size exceeded` : récursion sans condition d'arrêt.

`Unexpected token < in JSON` : tu as fait `JSON.parse` sur du HTML — typiquement une page d'erreur renvoyée par un serveur. Tu rencontreras ça au palier 2, et tu sauras alors que ton API a répondu autre chose que ce que tu croyais.

### `try / catch / finally`

```js
try {
  const contenu = readFileSync("depenses.json", "utf8");
  return JSON.parse(contenu);
} catch (erreur) {
  console.error("Lecture impossible :", erreur.message);
  return [];                                      // une valeur de repli sensée
} finally {
  console.log("Tentative de lecture terminée");   // exécuté dans tous les cas
}
```

Deux anti-patterns à ne jamais écrire :

```js
try { faireQuelqueChose(); } catch (e) {}        // ❌ avaler l'erreur en silence
try { /* 50 lignes */ } catch (e) { … }           // ❌ on ne sait plus ce qui a échoué
```

Un `catch` doit faire quelque chose d'utile : journaliser, replier sur une valeur par défaut, ou **relancer**. Relancer une erreur qu'on ne sait pas traiter n'est pas un échec, c'est la bonne attitude.

### Lever et typer ses erreurs

```js
throw new Error("message générique");
throw new TypeError("montant doit être un nombre");       // mauvais type
throw new RangeError("montant doit être positif");         // valeur hors limites

// Erreur personnalisée : utile dès que l'appelant doit distinguer les cas
class ErreurValidation extends Error {
  constructor(champ, message) {
    super(message);
    this.name = "ErreurValidation";
    this.champ = champ;                   // information exploitable par l'appelant
  }
}

try {
  valider(donnees);
} catch (e) {
  if (e instanceof ErreurValidation) {
    console.error(`Champ ${e.champ} : ${e.message}`);    // erreur attendue → message utilisateur
  } else {
    throw e;                                             // inattendue → on ne la cache pas
  }
}
```

Le `throw e` du `else` est le point important : distinguer les erreurs **attendues** (une saisie invalide, c'est prévu) des erreurs **inattendues** (un bug). Les premières deviennent des messages ; les secondes doivent remonter. Au palier 4, cette distinction deviendra un `400` contre un `500`.

### Les outils

```js
console.log(">>> depenses =", depenses);     // étiqueté et préfixé, pour les retrouver
console.table(depenses);                      // tableau lisible de données tabulaires
console.error("…");                           // va sur la sortie d'erreur
console.time("calcul"); /* … */ console.timeEnd("calcul");   // mesurer une durée
console.trace();                              // d'où vient cet appel ?
```

Le préfixe `>>>` n'est pas une coquetterie : il te permet de retrouver et de supprimer tous tes logs temporaires avec un `grep`. Rien n'est plus révélateur qu'un `console.log` oublié dans une PR.

### Le débogueur, et pourquoi l'adopter maintenant

Dans VS Code : clique dans la marge à gauche d'une ligne — un point rouge apparaît, c'est un **point d'arrêt**. Appuie sur `F5`, choisis *Node.js*, et le programme s'arrête **sur** cette ligne. Le panneau *Variables* montre alors tout l'état réel à cet instant : plus besoin de deviner. Ensuite, `F10` passe à la ligne suivante, `F11` entre dans la fonction appelée, `F5` reprend l'exécution.

La différence avec `console.log` est de nature : `console.log` répond à « que vaut cette variable ici ? », le débogueur répond à « que se passe-t-il **exactement** ? ». Sur un bug qui implique plusieurs fonctions, il fait gagner un temps considérable.

```js
node --inspect-brk index.js     // alternative sans configuration, puis chrome://inspect
```

---

## Les problèmes que tu vas rencontrer

**Tu ne lis pas le message et tu modifies au hasard.** C'est le piège principal, et il coûte des heures. Discipline : **lire en entier, à voix haute si besoin, avant de toucher au code**.

**L'erreur pointe une ligne où il n'y a rien d'anormal.** Pour les erreurs de syntaxe, le vrai problème est souvent **au-dessus** (accolade non fermée). Pour les erreurs d'exécution, la ligne est le lieu de la révélation, pas de la cause.

**Ton `catch` ne s'exécute pas.** L'erreur se produit dans du code **asynchrone** lancé depuis le `try` mais exécuté plus tard : un `try/catch` synchrone ne l'attrape pas. C'est l'un des sujets des leçons 09 et 10.

**Tu as un `undefined` et aucune erreur.** C'est une erreur de **logique** : JavaScript accepte volontiers `undefined` dans beaucoup d'opérations. Remonte à la source : qui était censé produire cette valeur ?

**Ton message d'erreur ne t'apprend rien.** Parce que tu as écrit `throw new Error("erreur")`. Un bon message dit **quoi**, **où** et **avec quelle valeur** : `` throw new TypeError(`montant invalide : ${montant}`) ``.

**Tu débogues depuis trois heures un code non commité.** Tu ne peux plus revenir à l'état qui marchait. Commite avant de tenter (palier 0, leçon 03).

**Tu débogues à minuit.** Le coût réel est multiplié par trois. La meilleure technique de débogage du métier reste de dormir et de relire à froid.

---

## Ce qu'on te demandera

En **entretien**, les questions sont surtout méthodologiques : « comment t'y prends-tu quand tu as un bug ? », « que fais-tu devant une stack trace ? », « as-tu déjà utilisé un débogueur ? ». La réponse attendue à la première est une **démarche** — lire le message, reproduire, formuler une hypothèse, vérifier — et non « je cherche sur Google ».

On te montrera parfois un extrait de code avec une erreur et on te demandera de la trouver **par la lecture**. C'est l'épreuve A4 de ton évaluation de palier, et c'est un bon test : il distingue ceux qui comprennent le code de ceux qui l'exécutent pour voir.

En **test technique**, la gestion des cas d'erreur est notée même quand on ne la demande pas explicitement. Un candidat qui traite le fichier absent et la saisie invalide rend un travail de niveau professionnel.

En **travail réel**, on attendra que tes messages d'erreur soient exploitables par quelqu'un d'autre que toi.

---

## Ce qui te démarquera

**Lire le message en entier avant d'agir.** Cela paraît dérisoire, et c'est le comportement qui sépare le plus nettement un développeur méthodique d'un débutant. Observe autour de toi : presque personne ne le fait.

**Utiliser des points d'arrêt.** Peu de juniors savent se servir d'un débogueur. Le faire devant quelqu'un produit toujours un petit effet.

**Écrire des messages d'erreur utiles.** Avec le nom du champ, la valeur reçue, et ce qui était attendu. C'est de l'empathie pour le prochain développeur — qui sera souvent toi, dans trois mois.

**Distinguer erreur attendue et bug.** Savoir dire « ça, c'est une entrée invalide, je la traite ; ça, c'est un bug, je le laisse remonter » est un raisonnement de conception, et c'est exactement ce que tu formaliseras au palier 4 avec les codes HTTP.

**Noter la cause, pas seulement la correction.** Un bug corrigé sans explication reviendra. Écrire une phrase dans ton journal — « le fichier n'existait pas au premier lancement, et `readFile` levait une exception non traitée » — t'évite les vingt prochains bugs de la même famille.

---

## 📚 À lire

**MDN → *What went wrong? Troubleshooting JavaScript*** pour la démarche, et la page **`Error`** pour la liste des types d'erreur standard.

**javascript.info** chapitres 10.1 (*Error handling, try...catch*) et 10.2 (*Custom errors*).

La **documentation VS Code → *Node.js debugging*** : configure `launch.json` une fois, et tu l'auras pour tous tes projets.

Et le [guide de débogage](../../guides/deboguer-methodiquement.md) du parcours, qui contient la méthode en 7 étapes et le tableau de décodage des erreurs.

---

## 🤖 Le mini-projet à demander à l'IA

Le débogage s'apprend sur du code cassé, et l'IA en fabrique à volonté :

> « Je suis en formation de développeur, palier 1 (JavaScript). Je travaille le débogage. Écris-moi un petit programme Node de 60 à 80 lignes (un gestionnaire de dépenses en ligne de commande) contenant **exactement 6 bugs** : deux erreurs d'exécution, deux erreurs de **logique** (le programme tourne mais le résultat est faux), un cas limite non traité, et un `catch` qui avale une erreur. **Ne me dis pas où ils sont ni combien de chaque type.** Ma méthode : je vais d'abord les chercher **par la lecture seule** et te dire ce que je trouve, puis j'exécuterai. À la fin, dis-moi ceux que j'ai manqués et **pourquoi ils étaient difficiles à voir**. »

L'ordre imposé — lecture d'abord, exécution ensuite — est ce qui rend l'exercice formateur. Les erreurs de logique en particulier ne se révèlent pas à l'exécution : il faut les raisonner.

Et pour les stack traces :

> « Donne-moi 8 stack traces Node réalistes, une par une, sans le code correspondant. Pour chacune, demande-moi : quel est le type d'erreur, quelle ligne de mon code regarder, et quelles sont les **trois causes les plus probables**. Corrige mon raisonnement. »

---

## 🛠️ À faire

1. **Provoque et lis** chacune de ces six erreurs. Pour chacune, note dans ton journal : le type, le message, la ligne fautive et la **cause réelle**.
   ```js
   const t = [];  t[0].montant;                 // a
   const f = 5;   f();                           // b
   console.log(inexistante);                     // c
   const c = 1;   c = 2;                          // d
   JSON.parse("<html>");                          // e
   function r(n) { return r(n + 1); }  r(1);     // f
   ```
2. Écris `chargerDepenses(chemin)` qui gère **trois** cas : fichier absent (→ `[]`), JSON invalide (→ message + `[]`), lecture réussie (→ les données). Teste les trois pour de vrai, en créant et en corrompant le fichier.
3. Écris `validerDepense(depense)` qui lève une `ErreurValidation` nommant le champ fautif pour : montant absent, montant non numérique, montant ≤ 0, catégorie manquante. Écris ensuite l'appelant qui attrape et affiche un message utilisateur propre — **sans jamais afficher la stack trace à l'utilisateur**.
4. **Erreur de logique** : ce code ne plante pas mais se trompe. Trouve les bugs **sans l'exécuter**, puis vérifie.
   ```js
   function moyenne(nombres) {
     let somme = 0;
     for (let i = 1; i <= nombres.length; i++) somme += nombres[i];
     return somme / nombres.length;
   }
   ```
5. Pose un point d'arrêt dans une de tes fonctions de la leçon 06 et inspecte l'accumulateur du `reduce` à chaque tour. Note ce que tu as vu que `console.log` ne t'aurait pas montré aussi facilement.
6. Prends ta `calculerTotal` de la leçon 03 et rends-la robuste : argument non tableau, éléments sans `montant`, montants non numériques. **Décide** pour chaque cas : lever une exception, ou ignorer l'élément ? Justifie en commentaire.
7. Reprends un bug réel que tu as eu cette semaine et écris-en le compte rendu en quatre lignes : symptôme, hypothèse, vérification, **cause**.

<details>
<summary>Corrections</summary>

**1.** (a) `TypeError: Cannot read properties of undefined (reading 'montant')` — `t[0]` est `undefined` car le tableau est vide. **La cause n'est pas la ligne : c'est l'absence de vérification du vide.** (b) `TypeError: f is not a function`. (c) `ReferenceError: inexistante is not defined`. (d) `TypeError: Assignment to constant variable`. (e) `SyntaxError: Unexpected token '<'` — le cas réel : une API a renvoyé une page HTML d'erreur et tu l'as parsée comme du JSON. Tu rencontreras **exactement** ça au palier 2. (f) `RangeError: Maximum call stack size exceeded`.

**2.**
```js
import { readFileSync } from "node:fs";

function chargerDepenses(chemin = "depenses.json") {
  let contenu;
  try {
    contenu = readFileSync(chemin, "utf8");
  } catch (e) {
    if (e.code === "ENOENT") return [];                  // premier lancement : attendu
    throw e;                                              // droits, disque… → anormal
  }
  try {
    const donnees = JSON.parse(contenu);
    if (!Array.isArray(donnees)) throw new TypeError("le fichier ne contient pas un tableau");
    return donnees;
  } catch (e) {
    console.error(`Fichier corrompu (${e.message}) — on repart d'une liste vide`);
    return [];
  }
}
```
Deux `try` séparés : chacun sait **ce** qui a échoué. Et on distingue `ENOENT` (attendu) du reste (anormal, donc relancé). C'est cette distinction qui fait la différence entre un script et un logiciel.

**4.** Deux bugs, et un troisième défaut. La boucle commence à `i = 1` : le premier élément est ignoré. Elle va jusqu'à `i <= length` : elle lit `nombres[length]`, qui vaut `undefined`, donc `somme` devient `NaN`. Et la division par zéro n'est pas traitée si le tableau est vide.
```js
function moyenne(nombres) {
  if (!Array.isArray(nombres) || nombres.length === 0) return 0;
  return nombres.reduce((s, n) => s + n, 0) / nombres.length;
}
```
Remarque au passage un argument en faveur de `reduce` : il supprime **toute** la classe des bugs d'index. C'est un argument de fiabilité, pas d'élégance.

**6.** Les deux réponses sont défendables, mais il faut **choisir** et savoir dire pourquoi. Lever une exception si une donnée invalide signale un bug ailleurs — mieux vaut échouer fort et vite. Ignorer l'élément si les données viennent d'une source peu fiable (un fichier modifié à la main) et que le calcul doit rester possible. Dans les deux cas, **journalise**. Un total silencieusement faux est le pire des trois résultats.
</details>

---

## ✅ Acquis si…

- [ ] Devant une erreur, je lis le message **en entier** avant de modifier le code.
- [ ] Je lis une stack trace et j'y repère la première ligne de mon code.
- [ ] Je cite cinq erreurs JavaScript courantes et leur cause typique.
- [ ] J'utilise `try/catch` **ciblé**, avec une action utile dans le `catch`.
- [ ] Je ne laisse jamais un `catch` vide.
- [ ] Je lève des erreurs typées avec des messages qui disent quoi, où et avec quelle valeur.
- [ ] Je distingue une erreur attendue d'un bug, et je les traite différemment.
- [ ] Je sais poser un point d'arrêt et inspecter l'état dans VS Code.
- [ ] J'ai trouvé une erreur de **logique** par la lecture, sans exécuter le code.

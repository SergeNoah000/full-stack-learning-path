# Leçon 07 — Destructuring, spread, template literals

> 🎯 **À la fin de cette leçon** : tu écris et tu **lis** le JavaScript moderne — celui de toute la documentation récente et de tout le code React que tu verras au palier 3.
> ⏱️ 3 h · **Prérequis** : leçons 01–06.

---

## De quoi on parle

Le **destructuring** extrait des valeurs d'un objet ou d'un tableau en les affectant à des variables, en une seule ligne.

Le **spread** (`...` à droite) « étale » les éléments d'un tableau ou les propriétés d'un objet. Le **rest** (`...` à gauche, ou dans des paramètres) fait l'inverse : il regroupe « tout le reste ».

Les **template literals** sont les chaînes entre accents graves, avec interpolation `${}` et sauts de ligne autorisés.

S'y ajoutent deux raccourcis : les **propriétés abrégées** (`{ montant }` au lieu de `{ montant: montant }`) et les **valeurs par défaut**, utilisées quand la valeur extraite est `undefined`.

Un repère pour ne pas confondre les deux usages de `...` : **à droite d'une affectation, il étale ; à gauche ou dans des paramètres, il regroupe.** C'est le même symbole, deux rôles opposés, et c'est la seule chose à mémoriser.

---

## À quoi ça sert, concrètement

**À supprimer le bruit.** Compare :

```js
// Avant
function afficher(depense) {
  const montant = depense.montant;
  const categorie = depense.categorie;
  const description = depense.description;
  console.log(description + " : " + montant + " (" + categorie + ")");
}

// Après
function afficher({ montant, categorie, description }) {
  console.log(`${description} : ${montant} (${categorie})`);
}
```

Trois bénéfices concrets. La **signature documente** : on voit immédiatement de quels champs la fonction a besoin, sans lire son corps. Les lignes mécaniques disparaissent, donc les endroits où se tromper aussi. Et la concaténation devient lisible.

**Mais la vraie raison d'apprendre cette leçon est la lecture.** Cette syntaxe est le dialecte standard : toute la documentation de React, de Node, de TypeScript, tous les exemples de Stack Overflow récents sont écrits comme ça. Si tu ne la lis pas couramment, tu ralentis sur **chaque** page que tu consultes. Ce n'est pas du confort d'écriture, c'est une condition d'autonomie.

---

## Où ça intervient dans le développement

À trois endroits précis, et tu les rencontreras très vite.

**Dans les signatures de fonctions**, dès que tu as plus de deux paramètres (leçon 03). C'est l'usage le plus fréquent, et il deviendra automatique.

**Dans les props React, au palier 3**, où c'est littéralement la norme. Tout composant React s'écrit `function Carte({ titre, montant, onSupprimer })`. Si cette ligne te paraît naturelle aujourd'hui, React te paraîtra familier.

**Dans la mise à jour immuable d'un état.** C'est le point d'architecture de cette leçon :

```js
const modifiee = { ...depense, montant: 2000 };          // "modifier" sans muter
const sansMotDePasse = (({ motDePasse, ...reste }) => reste)(utilisateur);
```

La première forme est celle que React exige (leçon 04 : muter n'entraîne aucun réaffichage). La seconde — retirer un champ par rest — est l'idiome standard pour **ne jamais renvoyer un hash de mot de passe dans une réponse d'API**, et tu l'appliqueras au palier 4.

Un quatrième usage, moins visible : le destructuring des **réponses de fonctions**. Au palier 3, `const [valeur, setValeur] = useState(0)` est un destructuring de tableau, et `const { data, isLoading, error } = useQuery(...)` est un destructuring d'objet. Comprendre la syntaxe t'évite de croire qu'il s'agit de magie propre à React.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas d'abord trouver cette syntaxe étrange, puis tu ne pourras plus écrire autrement. L'étape à ne pas sauter est de la **taper** : lire du destructuring ne suffit pas à l'écrire.

Le piège que tu rencontreras immanquablement : oublier les parenthèses autour d'un objet retourné par une fléchée (`d => ({ id: d.id })`).

### En équipe, en entreprise

Cette syntaxe n'est pas discutée : elle est **attendue**. Du code qui écrit `const montant = depense.montant;` sur cinq lignes consécutives sera repris en revue, non par élitisme mais parce qu'il est plus long à lire.

Tu verras aussi les deux usages avancés qui reviennent souvent : le rest pour **retirer un champ** d'un objet (très fréquent côté API), et le destructuring avec valeur par défaut sur un paramètre objet (`function f({ a = 1 } = {})`), dont le `= {}` final déroute tout le monde la première fois — et qu'on t'expliquera rarement.

### Ce qui sert tout le temps, et ce qui est rare

Au quotidien : le destructuring d'objet dans les signatures et sur les retours de fonctions, le spread pour copier et fusionner, les template literals.

Régulièrement : le destructuring de tableau (surtout avec `Object.entries` et les hooks React), le rest pour retirer un champ ou accepter un nombre variable d'arguments, les valeurs par défaut.

Rare, et à ignorer pour l'instant : le destructuring imbriqué sur trois niveaux (illisible — préfère deux étapes), le renommage combiné à une valeur par défaut imbriquée, les *tagged template literals* (`` tag`...` ``, utilisés par certaines bibliothèques de style), le spread sur des itérables exotiques. Et un conseil de lisibilité : **le destructuring profond est une mauvaise idée**. `const { a: { b: { c } } } = obj` est techniquement valide et personne ne veut le lire.

---

## La mécanique

### Destructuring d'objet

```js
const depense = { id: 1, montant: 1500, categorie: "food", description: "déjeuner" };

const { montant, categorie } = depense;              // extraire
const { montant: valeur } = depense;                 // extraire en renommant → `valeur`
const { devise = "FCFA" } = depense;                 // valeur par défaut si absent
const { id, ...autresChamps } = depense;             // rest : le reste dans un objet

// Imbriqué (à utiliser avec modération)
const utilisateur = { nom: "Serge", adresse: { ville: "Douala", pays: "CM" } };
const { adresse: { ville } } = utilisateur;          // ville === "Douala"
```

Un détail qui a son importance : la valeur par défaut ne s'applique que si la propriété est **`undefined`**, pas si elle est `null`, `0` ou `""`. C'est la même logique que `??` (leçon 01), et c'est généralement ce qu'on veut.

### Destructuring de tableau

```js
const couleurs = ["rouge", "vert", "bleu"];
const [premier, deuxieme] = couleurs;
const [, , troisieme] = couleurs;                    // ignorer des positions
const [tete, ...queue] = couleurs;                   // tete="rouge", queue=["vert","bleu"]
const [a = "défaut"] = [];                           // a === "défaut"

// L'échange sans variable temporaire
let x = 1, y = 2;
[x, y] = [y, x];
```

La différence entre les deux formes : l'objet se déstructure **par nom**, le tableau **par position**. C'est pour ça que `useState` retourne un tableau (tu nommes librement : `[compte, setCompte]`) alors qu'une réponse de requête retourne un objet (les noms sont imposés : `{ data, error }`).

### Dans les paramètres : l'usage principal

```js
function creerDepense({ montant, categorie, description = "", date = new Date() }) {
  return { id: Date.now(), montant, categorie, description, date };   // propriétés abrégées
}
creerDepense({ montant: 1500, categorie: "food" });

// Avec un objet entier optionnel
function configurer({ devise = "FCFA", decimales = 0 } = {}) { … }
configurer();                      // ✅ fonctionne grâce au `= {}`

// Dans les callbacks — tu verras ça partout
depenses.map(({ montant }) => montant * 2);
Object.entries(totaux).map(([categorie, total]) => `${categorie}: ${total}`);
```

Le `= {}` de la deuxième forme mérite une explication, parce que c'est une source de bugs : sans lui, appeler `configurer()` sans argument tente de déstructurer `undefined`, ce qui lève une `TypeError`. **Mets toujours `= {}` sur un paramètre objet optionnel.**

La dernière ligne combine les deux formes de destructuring : `Object.entries` renvoie un tableau de paires, donc on déstructure un **tableau** (`[categorie, total]`) dans le callback. C'est l'idiome que tu utiliseras le plus souvent à la leçon 06.

### Spread

```js
// Tableaux
const a = [1, 2], b = [3, 4];
const fusion = [...a, ...b];                 // [1, 2, 3, 4]
const copie = [...a];                        // copie superficielle
const avecAjout = [...a, 5];                 // ajouter sans muter (leçon 04)
Math.max(...[3, 1, 4]);                      // 4 — étaler en arguments

// Objets
const defauts = { devise: "FCFA", decimales: 0 };
const options = { ...defauts, decimales: 2 };   // les dernières clés écrasent
const modifiee = { ...depense, montant: 2000 }; // "modifier" sans muter

[..."abc"];                                  // ["a", "b", "c"]
```

L'ordre compte : dans `{ ...defauts, ...fournies }`, ce sont les valeurs **fournies** qui gagnent. C'est le mécanisme de toute configuration par défaut, et tu le retrouveras dans chaque bibliothèque.

Rappel de la leçon 04 : le spread est **superficiel**. Les objets imbriqués restent partagés.

### Rest

```js
function somme(...nombres) {                 // nombre variable d'arguments
  return nombres.reduce((t, n) => t + n, 0);
}

const { motDePasse, ...utilisateurPublic } = utilisateur;   // retirer un champ proprement
```

Cette dernière ligne est un idiome à connaître absolument : c'est ainsi qu'on **ne renvoie jamais le hash d'un mot de passe** dans une réponse d'API. Tu l'écriras au palier 4, et on te le demandera peut-être en entretien.

### Template literals

```js
const nom = "Serge", total = 1500;

`Bonjour ${nom}, total : ${total} FCFA`
`Calcul : ${total * 2}`                       // toute expression est permise
`Statut : ${total > 1000 ? "élevé" : "normal"}`

// Multi-lignes, sans \n
const rapport = `
Rapport du ${new Date().toLocaleDateString("fr-FR")}
----------------------------------
Total : ${total.toLocaleString("fr-FR")} FCFA
`;
```

Les template literals produiront tes rapports en ligne de commande (projet 1), tes gabarits HTML (palier 2) et tes messages d'erreur partout.

> ⚠️ **Une mise en garde qui vaut pour toute ta carrière** : n'utilise **jamais** un template literal pour construire une requête SQL. `` `SELECT * FROM depenses WHERE id = ${id}` `` est une **injection SQL**, c'est-à-dire la faille de sécurité la plus répandue du web. On utilise des requêtes préparées — tu verras ça en détail au palier 4, et tu exploiteras la faille sur ton propre code pour la comprendre. Prends le réflexe dès maintenant : du texte interpolé ne doit jamais devenir du code.

---

## Les problèmes que tu vas rencontrer

**`TypeError: Cannot destructure property 'x' of 'undefined'`.** Tu déstructures `null` ou `undefined`. Cas typique : une fonction appelée sans argument alors que son paramètre est un objet. La parade est le `= {}`.

**Ta fléchée ne retourne rien.** `d => { id: d.id }` est interprété comme un bloc de code avec une étiquette, pas comme un objet. Il faut des parenthèses : `d => ({ id: d.id })`.

**Ta valeur par défaut ne s'applique pas.** Elle ne couvre que `undefined`. Si ta donnée vaut `null` (ce qui arrive souvent avec des réponses de base de données), elle passe. Utilise `??` en complément.

**Tu as renommé sans le vouloir.** `const { montant: m }` crée `m`, pas `montant`. La syntaxe se lit « la propriété `montant`, mise dans `m` » — et l'ordre surprend quand on vient d'un autre langage.

**Ta « copie » partage encore des données.** Le spread est superficiel (leçon 04).

**Ton destructuring de tableau donne `undefined`.** Le tableau est plus court que prévu, ou tu t'es trompé de position. Le destructuring d'objet est plus robuste que celui de tableau, précisément parce qu'il ne dépend pas de l'ordre.

---

## Ce qu'on te demandera

On ne te posera pas de question « sur le destructuring » : on **attendra** que tu l'écrives. Cette syntaxe est devenue le niveau de base, et son absence dans un test technique se remarque comme une faute d'orthographe.

Quelques questions précises reviennent tout de même : « comment retires-tu une propriété d'un objet sans le muter ? » (réponse : le rest), « quelle différence entre spread et rest ? », « pourquoi faut-il `= {}` sur ce paramètre ? », « pourquoi des parenthèses autour de cet objet ? ».

Et une question de sécurité qui est en réalité une question sur les template literals : « comment construis-tu une requête SQL avec une valeur venant de l'utilisateur ? ». La seule bonne réponse est : avec une requête préparée, jamais par interpolation.

---

## Ce qui te démarquera

**Écrire des signatures qui documentent.** `function creerFacture({ client, lignes, remise = 0 })` dit tout ce qu'il faut savoir en une ligne. C'est de la conception d'interface, pas de la syntaxe.

**Savoir retirer un champ sensible par rest.** C'est un réflexe de sécurité, et il te distinguera au palier 4 — beaucoup de juniors renvoient l'objet utilisateur complet, hash de mot de passe inclus.

**Savoir s'arrêter.** Ne pas déstructurer sur trois niveaux, ne pas enchaîner cinq spreads. Le code moderne mal dosé est aussi illisible que le code ancien.

**Comprendre que `useState` n'a rien de magique.** Arriver au palier 3 en sachant que `const [x, setX] = useState(0)` est un simple destructuring de tableau change complètement le rapport à React.

---

## 📚 À lire

**javascript.info** : chapitre 9.1 (*Destructuring assignment*) et 6.3 (*Rest parameters and spread syntax*). Le premier est à lire en entier, il est court et complet.

**MDN** → *Destructuring assignment* et *Spread syntax*, dont les sections d'exemples suffisent.

Et si tu veux voir cette syntaxe en situation réelle, ouvre la documentation de **react.dev** : chaque exemple en contient. C'est le meilleur argument pour l'apprendre maintenant.

---

## 🤖 Le mini-projet à demander à l'IA

Cette syntaxe s'acquiert par la **traduction** : prendre du code ancien et le moderniser.

> « Je suis en formation de développeur, palier 1 (JavaScript). Je travaille le destructuring, le spread et les template literals. Écris-moi **8 fonctions JavaScript volontairement écrites à l'ancienne** : accès répétés par `objet.propriete`, concaténations avec `+`, `Object.assign`, copies manuelles de tableaux, paramètres positionnels nombreux, suppression de propriété par `delete`. **Ne les modernise pas** : ma mission est de les réécrire. Présente-les une par une, et après chacune, compare ma version à la tienne et dis-moi ce que j'aurais pu simplifier davantage — **ou au contraire ce que j'ai rendu moins lisible à force de condenser**. »

Ce dernier point est volontaire : la tentation, quand on découvre cette syntaxe, est d'en mettre partout. Se faire corriger dans les deux sens est plus utile.

Et un exercice de lecture, qui est l'enjeu principal :

> « Donne-moi 6 extraits de code issus de documentations réelles (React, Express, Node) qui utilisent du destructuring dense dans leurs signatures. Pour chacun, demande-moi d'expliquer **en français** ce que la signature reçoit et ce qu'elle retourne, avant de me confirmer. »

---

## 🛠️ À faire

1. À partir d'un objet dépense : extrais `montant` et `categorie` en une ligne ; extrais `description` en la renommant `libelle` ; extrais `devise` avec `"FCFA"` par défaut.
2. Réécris cette fonction avec destructuring dans la signature et un template literal :
   ```js
   function resumer(d) {
     return d.description + " : " + d.montant + " " + (d.devise || "FCFA");
   }
   ```
3. Écris `retirerChamp(objet, champ)` qui retourne une copie **sans** ce champ, sans utiliser `delete`.
4. Écris `fusionnerConfig(defauts, fournis)` et montre quel objet gagne en cas de conflit.
5. Échange deux variables sans variable temporaire.
6. Avec `Object.entries` et un destructuring de tableau dans le callback, affiche le tableau de totaux par catégorie (leçon 06) sous la forme `"food : 2 000 FCFA"`.
7. Écris `genererRapport(depenses)` qui retourne une chaîne multi-lignes : un en-tête avec la date, une ligne par dépense alignée en colonnes, un total. Un seul template literal pour le squelette.
8. **Pièges** : prédis puis vérifie.
   ```js
   const { a } = null;                    // (a)
   function f({ x } = {}) { return x; }  f();   // (b)
   function g({ x }) { return x; }      g();    // (c)
   const [p, q] = [1];                    // (d)
   const o1 = { x: 1 }, o2 = { ...o1 };  o2.x = 9;  o1.x;   // (e)
   const n1 = { a: { b: 1 } }, n2 = { ...n1 };  n2.a.b = 9;  n1.a.b;  // (f)
   const { z = 5 } = { z: null };         // (g)
   ```
9. **Sécurité** : prends un objet utilisateur contenant `id`, `email` et `motDePasseHash`, et écris la fonction qui produit la version « publique » de cet objet. Explique pourquoi elle doit exister.

<details>
<summary>Corrections</summary>

**2.**
```js
const resumer = ({ description, montant, devise = "FCFA" }) =>
  `${description} : ${montant} ${devise}`;
```
Note une différence de comportement : `d.devise || "FCFA"` remplacerait aussi une chaîne vide, alors que la valeur par défaut du destructuring ne s'applique qu'à `undefined`. C'est généralement préférable.

**3.**
```js
const retirerChamp = (objet, champ) => {
  const { [champ]: _, ...reste } = objet;      // clé dynamique + rest
  return reste;
};
```
Aucune mutation, contrairement à `delete`.

**6.**
```js
Object.entries(totauxParCategorie)
  .map(([categorie, total]) => `${categorie} : ${total.toLocaleString("fr-FR")} FCFA`)
  .forEach(ligne => console.log(ligne));
```

**7.**
```js
function genererRapport(depenses) {
  const total = depenses.reduce((s, d) => s + d.montant, 0);
  const lignes = depenses
    .map(({ description, montant }) => `  - ${description.padEnd(20)} ${String(montant).padStart(8)}`)
    .join("\n");
  return `
Rapport du ${new Date().toLocaleDateString("fr-FR")}
${"=".repeat(40)}
${lignes}
${"=".repeat(40)}
  TOTAL : ${total.toLocaleString("fr-FR")} FCFA
`.trim();
}
```
`padEnd` et `padStart` alignent les colonnes : ton projet 1 en ligne de commande en aura besoin.

**8.** (a) **TypeError** — on ne peut pas déstructurer `null`. (b) `undefined`, sans erreur : le `= {}` sauve l'appel sans argument. (c) **TypeError** : sans valeur par défaut, on tente de déstructurer `undefined`. **D'où l'habitude du `= {}`.** (d) `p === 1`, `q === undefined`. (e) `o1.x === 1` ✅. (f) `n1.a.b === 9` 😱 — spread superficiel. (g) `z === null` : la valeur par défaut **ne s'applique pas** à `null`, seulement à `undefined`. C'est le piège le plus subtil de la liste, et il se produit tout le temps avec des données venant d'une base.

**9.**
```js
const versionPublique = ({ motDePasseHash, ...reste }) => reste;
```
Pourquoi elle doit exister : parce que l'objet complet circule à l'intérieur de ton serveur (tu as besoin du hash pour vérifier un mot de passe), mais qu'il ne doit **jamais** franchir la frontière HTTP. Si tu renvoies l'objet entier, le hash se retrouve dans la réponse, visible dans l'onglet Réseau de n'importe quel navigateur. C'est une fuite de données, et c'est une erreur très courante — tu la rencontreras au palier 4, et tu sauras déjà quoi faire.
</details>

---

## ✅ Acquis si…

- [ ] Je déstructure objets et tableaux, avec renommage et valeurs par défaut.
- [ ] J'écris mes fonctions avec un objet déstructuré en paramètre.
- [ ] J'utilise le spread pour copier et fusionner sans muter.
- [ ] J'utilise le rest pour retirer un champ d'un objet, et je sais pourquoi c'est un réflexe de sécurité.
- [ ] Je sais pourquoi `= {}` est nécessaire sur un paramètre objet optionnel.
- [ ] Je sais pourquoi une fléchée qui retourne un objet a besoin de parenthèses.
- [ ] Je sais que la valeur par défaut ne couvre que `undefined`, pas `null`.
- [ ] Mes concaténations sont écrites en template literals — **sauf pour du SQL**, jamais.
- [ ] Je **lis** couramment une signature dense dans une documentation.

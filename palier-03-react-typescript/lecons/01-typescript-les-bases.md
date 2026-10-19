# Leçon 01 — TypeScript : types de base, inférence, `strict`

> 🎯 **À la fin de cette leçon** : tu types du code existant, tu comprends ce que TypeScript vérifie et surtout ce qu'il **ne vérifie pas**, et tu sais pourquoi `strict` se met dès le premier jour.
> ⏱️ 4 h · **Prérequis** : [épreuve du palier 2](../../palier-02-frontend-web/evaluation.md) réussie.

---

## TypeScript, c'est quoi

TypeScript est **JavaScript avec des annotations de types**, plus un vérificateur qui les contrôle **avant** l'exécution. Tout JavaScript valide est du TypeScript valide : il n'y a pas de nouveau langage à apprendre, seulement une couche de vérification à ajouter.

```ts
function calculerTotal(depenses: Depense[]): number {
  return depenses.reduce((somme, d) => somme + d.montant, 0);
}
```

Le point qu'il faut absolument comprendre, et que beaucoup de gens n'ont jamais clarifié : **TypeScript disparaît à la compilation**. Le navigateur ne reçoit que du JavaScript ordinaire, sans une seule annotation. Il n'y a **aucune vérification à l'exécution** — les types servent au moment où tu écris, pas au moment où ton code tourne.

Cette caractéristique a une conséquence immédiate et souvent mal comprise : si une API te renvoie des données qui ne correspondent pas à ce que tu as déclaré, TypeScript ne s'en apercevra pas. Tu auras menti au compilateur, et il t'aura cru. On y revient plus bas, parce que c'est la source d'un faux sentiment de sécurité.

Deux notions à poser tout de suite. L'**inférence** : TypeScript devine le type quand il peut, et il peut très souvent — tu annoteras donc beaucoup moins que tu ne l'imagines. Et le mode **`strict`** : un ensemble de vérifications strictes, dont la plus utile vérifie que tu ne peux pas accéder à une valeur potentiellement `null`.

---

## À quoi ça sert, concrètement

**À attraper les bugs du palier 1 avant qu'ils arrivent.** Rappelle-toi les erreurs que tu as rencontrées : `Cannot read properties of undefined`, une faute de frappe dans un nom de propriété, une fonction appelée avec les arguments dans le mauvais ordre, un `Number()` oublié sur une saisie. TypeScript attrape **toutes** ces familles-là, dans l'éditeur, pendant que tu tapes. C'est la raison pour laquelle il a été adopté massivement : pas par élégance, par économie de temps.

**À avoir une documentation qui ne peut pas être fausse.** Une signature comme `creerDepense(donnees: NouvelleDepense): Depense` te dit ce qu'il faut passer et ce que tu obtiens, sans lire le corps de la fonction ni un commentaire qui a pu devenir obsolète.

**À pouvoir modifier sans peur.** C'est le bénéfice qui se révèle sur la durée : si tu renommes un champ dans un type, le compilateur te liste **tous** les endroits à corriger. Sans types, tu fais une recherche textuelle et tu espères.

**Et parce que c'est devenu le standard.** La majorité des offres frontend demandent TypeScript. Ce n'est plus une option de niche.

---

## Où ça intervient dans le développement

TypeScript intervient **au moment de l'écriture et de la compilation**, jamais à l'exécution. Visualise-le ainsi :

```
   tu écris  →  ton éditeur vérifie en direct (erreurs soulignées)
                      │
                      ▼
   tu compiles (tsc / Vite)  →  TypeScript vérifie TOUT le projet
                      │              ↳ erreur = le build échoue
                      ▼
   JavaScript pur  →  le navigateur exécute (aucun type, aucune vérification)
```

Et voici le point d'architecture qui compte vraiment, parce qu'il relie cette leçon à tout ce que tu as appris :

```
   LES FRONTIÈRES — TypeScript n'y garantit RIEN
   ├── réponse d'API          → tu déclares le type, personne ne le vérifie
   ├── localStorage           → tu parses du JSON, tu affirmes sa forme
   ├── saisie de formulaire   → toujours des chaînes
   └── variables d'env        → toujours des chaînes
            │
            │  ← ICI il faut une validation à l'EXÉCUTION (Zod, palier 4)
            ▼
   LE CŒUR DE TON CODE — TypeScript y est fiable et très utile
```

Autrement dit : TypeScript sécurise l'**intérieur** de ton programme, pas ses entrées. C'est exactement la même frontière que celle de la leçon 01 du palier 1, et c'est pourquoi tu rencontreras **Zod** au palier 4 : un outil qui valide à l'exécution *et* qui en déduit le type TypeScript. Les deux sont complémentaires, pas concurrents.

Deux prolongements dans le parcours. Au **palier 5**, Python te proposera la même idée avec les *type hints* et `mypy` — et Pydantic jouera le rôle de Zod. Au **palier 9**, Dart aura un typage, lui, réellement vérifié à l'exécution. Tu verras ainsi trois positions différentes sur la même question, ce qui est précisément le genre de comparaison qui construit un jugement d'architecte.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas passer par trois phases, et il est utile de les connaître d'avance. D'abord l'agacement : le compilateur refuse du code qui « marche ». Ensuite la compréhension : il refusait du code qui marchait *dans le cas où tu testais*. Enfin le confort : tu ne veux plus t'en passer, et le JavaScript non typé te paraît inconfortable.

L'exercice de transfert du palier — **retyper ton projet 1** — est conçu pour accélérer ce passage. Typer du code existant que tu connais par cœur est bien plus instructif que de partir de zéro.

### En équipe, en entreprise

**`strict` est activé partout.** Tu ne verras presque jamais un projet TypeScript moderne sans. Et une base de code sans `strict` est généralement une base en cours de migration depuis JavaScript.

**`any` est interdit, ou au moins signalé.** Le linter le refuse souvent, parce qu'il annule toute vérification et se propage silencieusement. Tu rencontreras pourtant des `any` dans du code existant : ce sont des zones où quelqu'un a renoncé, et souvent des zones à bugs.

**Le build échoue sur une erreur de type.** Dans le pipeline (palier 8), `tsc --noEmit` tourne avant les tests. Une erreur de type bloque la livraison, exactement comme un test rouge.

**Et tu verras les deux cultures.** Des équipes qui typent tout précisément, et des équipes qui écrivent `any` dès que c'est pénible. La seconde approche coûte plus cher qu'elle ne rapporte, et tu seras bien placé pour le dire après cette leçon.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : les types primitifs, les tableaux, les objets, les fonctions typées, l'inférence (que tu laisses travailler), `interface`/`type` (leçon 02), les unions simples, `strict`, et `unknown` à la place d'`any`.

Régulièrement : les types optionnels (`?`), `readonly`, les types littéraux (`"ok" | "erreur"`), `as const`, les types utilitaires courants (`Partial`, `Pick`, `Omit`, `Record`).

Rare, et sans intérêt pour toi aujourd'hui : les types conditionnels, les types mappés, `infer`, les *template literal types*, les surcharges de fonction, les décorateurs, les espaces de noms, les types récursifs. C'est de la « programmation au niveau des types » — impressionnant, utile pour écrire des bibliothèques, et parfaitement inutile pour une application. Si tu te retrouves à écrire un type de douze lignes, tu es probablement en train de résoudre le mauvais problème.

---

## La mécanique

### Les types de base, et l'inférence

```ts
// Annotation explicite
let nom: string = "Serge";
let montant: number = 1500;
let paye: boolean = false;

// ✅ Mais le plus souvent, laisse l'inférence travailler
let nom2 = "Serge";          // TypeScript sait déjà : string
const montants = [1, 2, 3];  // number[]
```

**N'annote pas ce que TypeScript devine.** Écrire `const nom: string = "Serge"` est du bruit. On annote là où l'inférence ne peut pas deviner : les **paramètres de fonction**, et les valeurs qui viennent de l'extérieur.

```ts
// Tableaux
const montants: number[] = [1500, 3000];
const matrice: number[][] = [[1, 2], [3, 4]];

// Objets
type Depense = {
  id: number;
  montant: number;
  categorie: string;
  description?: string;        // optionnel : string | undefined
  readonly creeLe: string;     // ne peut plus être réassigné après création
};

// Fonctions
function calculerTotal(depenses: Depense[]): number {
  return depenses.reduce((s, d) => s + d.montant, 0);
}

const doubler = (n: number): number => n * 2;

function afficher(message: string): void {   // void : ne retourne rien
  console.log(message);
}
```

### `strict` : à activer tout de suite

```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "noEmit": true
  }
}
```

`strict` regroupe plusieurs vérifications, dont la plus importante de loin est **`strictNullChecks`** :

```ts
function trouverDepense(depenses: Depense[], id: number): Depense | undefined {
  return depenses.find(d => d.id === id);
}

const d = trouverDepense(mesDepenses, 42);
// console.log(d.montant);     // ❌ ERREUR : 'd' est peut-être undefined

if (d) {
  console.log(d.montant);       // ✅ ici TypeScript sait que d existe
}
console.log(d?.montant);        // ✅ ou le chaînage optionnel
```

Observe ce qui vient de se passer : TypeScript t'a **forcé** à traiter le cas « non trouvé ». C'est précisément le `Cannot read properties of undefined` du palier 1, attrapé avant l'exécution. À lui seul, `strictNullChecks` élimine la famille de bugs la plus fréquente de JavaScript.

Et pourquoi dès le premier jour ? Parce que l'activer sur un projet existant produit **des centaines d'erreurs d'un coup**, et que personne ne les corrige jamais. C'est une décision qui ne se rattrape pas.

### `any` contre `unknown`

```ts
// ❌ any : désactive toute vérification, et se propage
let donnees: any = await reponse.json();
donnees.nimporte.quoi.sans.erreur;      // TypeScript ne dit rien. Ça plantera à l'exécution.

// ✅ unknown : force à vérifier avant d'utiliser
let donnees2: unknown = await reponse.json();
// donnees2.montant;                     // ❌ erreur : il faut d'abord savoir ce que c'est
if (typeof donnees2 === "object" && donnees2 !== null && "montant" in donnees2) {
  // ici on peut commencer à l'utiliser
}
```

`any` dit « fais-moi confiance ». `unknown` dit « je ne sais pas encore, oblige-moi à vérifier ». Le second est presque toujours le bon choix pour une donnée entrante — et quand les vérifications deviennent pénibles à écrire à la main, c'est le signe qu'il faut un validateur (Zod, palier 4).

### Le resserrement de type (*narrowing*)

TypeScript suit ton raisonnement. C'est l'une de ses mécaniques les plus agréables :

```ts
function formater(valeur: string | number): string {
  if (typeof valeur === "number") {
    return valeur.toFixed(2);        // ici TypeScript SAIT que c'est un number
  }
  return valeur.toUpperCase();        // et ici, forcément un string
}
```

Ce resserrement fonctionne avec `typeof`, `Array.isArray`, `in`, `instanceof`, et avec une comparaison de valeur littérale — c'est le fondement des unions discriminées de la leçon 02.

### Typer du JavaScript existant

La méthode la plus efficace, et c'est l'exercice du palier :

1. Renomme `.js` en `.ts`. Compte les erreurs (il y en aura).
2. Définis d'abord les **types de données** (`Depense`, `Categorie`) : c'est eux qui propagent l'information partout.
3. Annote les **paramètres** et les **retours** des fonctions.
4. Traite les erreurs `strictNullChecks` en ajoutant les vérifications manquantes — **ne les contourne pas avec `!`**, c'est là que tu trouveras de vrais bugs.
5. `tsc --noEmit` jusqu'à zéro erreur, jamais de `any`.

> ⚠️ L'opérateur `!` (`d!.montant`) dit « fais-moi confiance, ce n'est pas nul ». Il **désactive** la vérification que tu venais d'obtenir. Il a des usages légitimes et rares ; au stade de l'apprentissage, considère chaque `!` comme un aveu et cherche la vraie correction.

---

## Les problèmes que tu vas rencontrer

**`Object is possibly 'undefined'`.** C'est `strictNullChecks` qui fait son travail. Ce n'est pas un faux positif : la valeur **peut** être absente. Ajoute une vérification, un `?.`, ou une valeur par défaut avec `??`.

**`Type 'string' is not assignable to type 'number'`.** Tu passes une donnée de formulaire sans la convertir. C'est le bug du palier 1 attrapé plus tôt — et c'est la démonstration de l'utilité de l'outil.

**`Property 'x' does not exist on type 'y'`.** Soit une faute de frappe, soit ton type ne correspond pas à la réalité des données. Vérifie la **vraie** réponse de l'API dans l'onglet Réseau avant d'accuser TypeScript.

**Mon code compile mais plante à l'exécution.** Tu as déclaré un type qui ne correspond pas aux données réelles. TypeScript t'a cru. C'est **la** limite à retenir : il vérifie la cohérence de tes affirmations, pas leur vérité.

**J'ai mis `any` partout et ça compile.** Oui, et tu as désactivé l'outil. Autant écrire du JavaScript.

**Mes erreurs sont illisibles**, sur quinze lignes avec des types imbriqués. C'est un vrai défaut de TypeScript. Lis la **première** ligne et la **dernière** : le reste est le déroulé du raisonnement.

**`tsc` est lent sur un gros projet.** Normal. Vite transpile sans vérifier (c'est rapide), et `tsc --noEmit` vérifie séparément, en parallèle ou dans le pipeline. D'où la configuration `noEmit` ci-dessus.

**Mon éditeur ne voit pas les erreurs.** Il n'utilise pas la version de TypeScript du projet. Dans VS Code : *TypeScript: Select TypeScript Version → Use Workspace Version*.

---

## Ce qu'on te demandera

En **entretien**, trois questions reviennent presque toujours : « qu'apporte TypeScript, et que n'apporte-t-il **pas** à l'exécution ? » (la seconde moitié est celle qui distingue), « pourquoi éviter `any`, et que mettre à la place ? », « qu'est-ce que `strict` et pourquoi dès le début ? ».

On peut aussi te demander : « comment valides-tu des données venant d'une API, puisque TypeScript ne le fait pas ? ». La bonne réponse mentionne une validation à l'exécution — et tu auras l'outil au palier 4.

En **test technique**, on te donnera souvent du code à typer, ou un projet déjà en TypeScript où l'on observera si tu ajoutes des `any` pour faire taire le compilateur.

En **revue de code**, les remarques fréquentes : un `any`, un `!` non justifié, des annotations redondantes que l'inférence aurait fournies.

---

## Ce qui te démarquera

**Savoir exactement ce que TypeScript ne fait pas.** Beaucoup de développeurs croient que leurs types protègent leurs données d'API. Pouvoir dire « TypeScript s'efface à la compilation, donc il faut valider à l'exécution aux frontières » te place au-dessus, immédiatement.

**Laisser l'inférence travailler.** Un code sur-annoté est aussi pénible qu'un code non typé. Savoir où annoter — les paramètres, les frontières — et où se taire est une marque de pratique.

**Préférer `unknown` à `any`.** Et savoir expliquer la différence.

**Traiter les erreurs `strictNullChecks` au lieu de les contourner.** Chaque `!` évité est souvent un bug trouvé.

**Typer son projet existant plutôt que de lire un tutoriel.** C'est la méthode, et c'est ce que l'épreuve de sortie te demandera.

---

## 📚 À lire

**typescriptlang.org → *TypeScript for JavaScript Programmers*** : trente minutes, écrit exactement pour ta situation. À lire en premier.

**Le *TypeScript Handbook*** ensuite, mais seulement les chapitres *Everyday Types*, *Narrowing* et *tsconfig*. Le reste du manuel traite de sujets avancés dont tu n'as pas besoin.

**Total TypeScript** (totaltypescript.com) propose des exercices gratuits de Matt Pocock — le format par petits défis est très efficace pour ancrer les notions.

Et garde en tête le **playground** (typescriptlang.org/play) : il montre le JavaScript généré à côté de ton TypeScript. Le voir une fois rend concret le fait que les types disparaissent.

---

## 🤖 Le mini-projet à demander à l'IA

Le typage s'apprend sur du code qu'on connaît déjà — d'où l'exercice de transfert.

> « Je suis en formation de développeur, palier 3. Je découvre TypeScript, et je vais typer mon propre projet existant (un gestionnaire de dépenses en JavaScript). Ne me donne aucun code. Donne-moi **la méthode en étapes ordonnées** pour typer un projet JavaScript existant en mode `strict`, puis la liste des **10 catégories d'erreurs** que je vais probablement rencontrer, formulées comme les messages réels du compilateur — **sans les solutions**. Quand je te montrerai une erreur et ma correction, dis-moi si ma correction est la bonne ou si je viens de masquer un vrai bug (typiquement avec `!` ou `any`). »

Puis la démonstration qui installe la bonne compréhension, et qui vaut dix explications :

> « Montre-moi un exemple court où du code TypeScript **compile sans erreur** et **plante quand même à l'exécution**, parce que la réponse d'une API ne correspond pas au type déclaré. Ne m'explique pas la solution. Demande-moi ensuite ce qu'il faudrait ajouter, et où précisément dans mon code il faudrait l'ajouter. »

---

## 🛠️ À faire

1. Installe un projet minimal : `npm create vite@latest` avec le modèle *Vanilla TS*. Ouvre le `tsconfig.json` et vérifie que `strict` est actif.
2. **Prédis puis vérifie** : écris ces lignes et note celles que TypeScript refuse, et pourquoi.
   ```ts
   let a: number = "5";
   const t: number[] = [1, 2, "3"];
   function f(x: string) { return x.toUpperCase(); }   f(42);
   const o = { nom: "Serge" };   o.age = 30;
   const d = [1,2,3].find(n => n > 5);   d.toFixed(2);
   ```
3. Définis les types `Depense` et `Categorie` de ton projet 1, avec un champ optionnel et un champ `readonly`.
4. **Le transfert** : retype entièrement ton projet 1 (le gestionnaire de dépenses en ligne de commande) en `strict`. Objectif : `tsc --noEmit` sans erreur, **zéro `any`**, **zéro `!`**.
5. Note dans ton journal **chaque vrai bug** que TypeScript t'a révélé pendant l'exercice 4. Il y en aura — c'est le but.
6. **`any` contre `unknown`** : écris une fonction qui reçoit une réponse d'API en `any`, puis la même en `unknown`. Constate ce que le compilateur t'oblige à faire dans le second cas.
7. **Le resserrement** : écris `formater(valeur: string | number | Date): string` et laisse TypeScript te guider dans les trois branches.
8. **La démonstration de la limite** : déclare un type `Meteo` avec un champ `temperature: number`, appelle une API qui renvoie en réalité une chaîne, et constate que ça compile et plante. Écris la conclusion dans ton journal.
9. Ouvre le **playground** et colle une de tes fonctions typées. Regarde le JavaScript produit à droite : les types ont disparu.
10. Essaie de contourner une erreur avec `!`, puis trouve la correction réelle. Compare les deux approches.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** Toutes sont refusées, pour cinq raisons différentes : `string` n'est pas assignable à `number` · l'élément `"3"` n'est pas un `number` · `f` attend un `string` · l'objet inféré n'a pas de propriété `age` (il faudrait déclarer le type, ou utiliser une annotation plus large) · et la dernière est la plus intéressante — `find` retourne `number | undefined`, donc `d.toFixed()` est refusé par `strictNullChecks`. **C'est exactement le bug que tu as eu au palier 1.**

**4 et 5.** Les vrais bugs que tu vas trouver, par fréquence : un `find` dont tu n'avais pas traité le cas « non trouvé » ; une fonction appelée avec un argument manquant ; une valeur de formulaire ou de `JSON.parse` utilisée comme nombre sans conversion ; un champ optionnel accédé sans vérification ; une faute de frappe dans un nom de propriété que JavaScript acceptait en silence (`depense.montan` valait `undefined`). **Note-les tous : c'est la meilleure justification de TypeScript que tu pourras donner en entretien, parce qu'elle vient de ton code.**

**6.** Avec `any`, tout passe et rien n'est vérifié. Avec `unknown`, le compilateur refuse tout accès avant que tu aies prouvé la forme de la donnée — ce qui est pénible à la main, et c'est précisément l'argument en faveur de Zod au palier 4.

**8.**
```ts
type Meteo = { temperature: number };
const r = await fetch(url);
const meteo = await r.json() as Meteo;        // ⚠️ "as" = une AFFIRMATION, pas une vérification
console.log(meteo.temperature.toFixed(1));     // compile… et plante si l'API renvoie "29"
```
`as` ne convertit rien et ne vérifie rien : il dit au compilateur « crois-moi ». La conclusion à écrire : **TypeScript vérifie la cohérence de mes affirmations, pas leur vérité. Aux frontières, il faut une validation à l'exécution.**

**10.** `d!.montant` fait taire l'erreur et laisse le plantage possible. La correction réelle est `if (d) { … }` ou `d?.montant` ou `?? valeurParDefaut` — c'est-à-dire **décider** de ce qui se passe quand la valeur est absente. C'est une décision de conception, et TypeScript t'a forcé à la prendre. C'est son principal service.
</details>

---

## ✅ Acquis si…

- [ ] J'explique ce que TypeScript apporte, **et ce qu'il n'apporte pas à l'exécution**.
- [ ] J'active `strict` dès la création d'un projet, et je sais pourquoi pas plus tard.
- [ ] Je laisse l'inférence travailler et j'annote les paramètres et les frontières.
- [ ] Je préfère `unknown` à `any`, et je n'écris pas `any`.
- [ ] Je traite les erreurs `strictNullChecks` au lieu de les contourner avec `!`.
- [ ] J'ai retypé mon projet 1 en `strict`, sans `any` ni `!`.
- [ ] J'ai noté les vrais bugs que TypeScript m'a révélés.
- [ ] Je sais que `as` est une affirmation, pas une vérification.
- [ ] Je sais pourquoi une validation à l'exécution reste nécessaire aux frontières.

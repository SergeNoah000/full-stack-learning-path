# Leçon 02 — TypeScript : `interface`/`type`, unions, génériques

> 🎯 **À la fin de cette leçon** : tu modélises tes données avec des types qui rendent les états impossibles réellement impossibles, et tu écris une fonction générique sans que ce mot te fasse peur.
> ⏱️ 4 h · **Prérequis** : leçon 01.

---

## De quoi on parle

Une **`interface`** et un **`type`** décrivent tous deux la forme d'une valeur. Ils sont presque interchangeables ; on verra la règle de choix, qui tient en deux lignes.

Une **union** est un type qui accepte plusieurs possibilités : `string | number`. Une **union discriminée** est une union d'objets qui partagent un champ littéral servant d'étiquette — et c'est, de loin, l'outil le plus utile de cette leçon.

Un **générique** est un type paramétré : une fonction ou un type qui fonctionne pour n'importe quel type tout en **conservant l'information**. `premierOuNull<T>(liste: T[]): T | null` rend un `string` quand on lui donne un `string[]`.

Et les **types utilitaires** sont des outils fournis par TypeScript pour dériver un type d'un autre : `Partial`, `Pick`, `Omit`, `Record`.

---

## À quoi ça sert, concrètement

**À rendre les états impossibles inexprimables.** C'est l'idée la plus puissante de la leçon, et elle change la façon de concevoir. Compare :

```ts
// ❌ Quatre booléens = seize combinaisons, dont douze absurdes
type Etat = {
  enChargement: boolean;
  aErreur: boolean;
  estVide: boolean;
  donnees: Depense[] | null;
};
// rien n'empêche { enChargement: true, aErreur: true, donnees: [...] }

// ✅ Union discriminée = quatre états, et seulement quatre
type Etat =
  | { statut: "vide" }
  | { statut: "chargement" }
  | { statut: "erreur"; message: string }
  | { statut: "donnees"; donnees: Depense[] };
```

Tu reconnais les quatre états de la leçon 09 du palier 2. Tu les avais gérés par discipline, avec un champ `statut` et un `switch`. TypeScript te permet maintenant de les rendre **vérifiés par le compilateur** : impossible d'accéder à `message` dans l'état `donnees`, impossible d'oublier une branche du `switch`.

**À ne pas te répéter.** Ton type `Depense` a huit champs. Le formulaire de création n'en envoie que cinq (pas d'`id`, pas de date de création). Plutôt que de redéclarer, tu dérives : `Omit<Depense, "id" | "creeLe">`. Quand `Depense` change, le reste suit automatiquement.

**À écrire du code réutilisable sans perdre les types.** C'est le rôle des génériques, et ce n'est pas un sujet d'expert : dès que tu écris une fonction utilitaire qui marche sur plusieurs types, tu en as besoin.

---

## Où ça intervient dans le développement

Les types de données sont le **squelette** de ton application, et ils voyagent d'une couche à l'autre :

```
   BASE DE DONNÉES (palier 4)
        │   le schéma définit la vérité
        ▼
   API — contrat de réponse
        │   ← ici une VALIDATION à l'exécution (Zod) produit le type
        ▼
   TYPES PARTAGÉS   ← cette leçon
        ├── les props de tes composants React    (leçons 03-06)
        ├── l'état de ton application            (leçon 04)
        └── les retours de tes fonctions métier  (palier 1)
```

Trois choses à retenir pour la suite.

**Les props React sont un type d'objet.** C'est tout. `function Carte({ titre, montant }: ProprietesCarte)` est la signature de la leçon 03, et tu sais déjà l'écrire après cette leçon.

**Les unions discriminées sont partout dans React.** L'état d'un chargement, le résultat d'une requête, la variante d'un composant (`type: "primaire" | "secondaire" | "danger"`). TanStack Query (leçon 08) expose exactement ce modèle.

**Et au palier 4, tes types seront générés depuis la validation.** Avec Zod, tu écriras le schéma de validation une fois et tu en déduiras le type : plus de duplication entre « ce que je vérifie » et « ce que je déclare ». C'est l'aboutissement de la frontière décrite à la leçon 01.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas d'abord écrire des types plats et répétitifs, puis découvrir `Omit` et `Pick` et les factoriser. C'est la progression normale.

Le moment où ça devient intéressant est celui où tu écris ta première union discriminée et où tu constates que le compilateur **t'oblige** à traiter chaque cas. Tu auras remplacé une discipline par une garantie.

### En équipe, en entreprise

**Les types partagés sont un objet de négociation.** Dans un projet avec frontend et backend séparés, « où vit le type `Utilisateur` ? » est une vraie question d'organisation : dans un paquet commun, généré depuis l'API, ou dupliqué. Tu rencontreras les trois.

**On te demandera des unions discriminées** sans forcément les nommer : « fais en sorte qu'on ne puisse pas avoir un état de chargement avec des données ».

**Les génériques, tu en liras plus que tu n'en écriras.** Toutes les bibliothèques en sont faites (`useState<T>`, `Array<T>`, `Promise<T>`). Savoir les **lire** est indispensable ; en écrire de complexes ne l'est pas.

**Et tu verras de la sur-ingénierie de types.** Des types de quarante lignes avec des conditionnels imbriqués, écrits par quelqu'un qui s'amusait. C'est un vrai défaut de culture dans l'écosystème TypeScript : la lisibilité d'un type compte autant que celle du code.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : les types d'objet, les unions de littéraux (`"primaire" | "secondaire"`), les unions discriminées, `Partial`, `Pick`, `Omit`, `Record`, et la lecture de signatures génériques.

Régulièrement : écrire une fonction générique simple, `as const`, `keyof`, les types de retour dérivés (`ReturnType`), et l'extension d'interface.

Rare, et à éviter à ce stade : les types conditionnels (`T extends U ? A : B`), les types mappés, `infer`, les *template literal types*, les contraintes génériques multiples, `satisfies` (utile, mais tu peux t'en passer). Règle de prudence qui t'évitera de perdre du temps : **si tu ne comprends pas ton propre type en le relisant demain, simplifie-le.**

---

## La mécanique

### `interface` ou `type` : la règle en deux lignes

```ts
interface Depense {
  id: number;
  montant: number;
}

type Depense2 = {
  id: number;
  montant: number;
};
```

Les deux font la même chose ici. La règle pratique : **`interface` pour décrire la forme d'un objet** (elle peut s'étendre, et ses messages d'erreur sont plus lisibles), **`type` pour tout le reste** — unions, intersections, alias de primitives, types dérivés.

```ts
interface Depense { id: number; montant: number; }
interface DepenseRecurrente extends Depense { periode: "mois" | "an"; }   // extension

type Statut = "brouillon" | "validee" | "payee";          // union : il FAUT type
type DepenseAvecCategorie = Depense & { categorie: Categorie };   // intersection
```

Ne passe pas de temps sur ce choix : les deux sont acceptables, et aucune équipe ne te reprochera l'un ou l'autre.

### Les unions de littéraux : mieux qu'une chaîne

```ts
// ❌ n'importe quelle chaîne passe, les fautes de frappe aussi
function filtrer(statut: string) { … }
filtrer("payee");  filtrer("payée");  filtrer("nimportequoi");   // tout compile

// ✅ seules trois valeurs sont acceptées, et l'éditeur les propose
type Statut = "brouillon" | "validee" | "payee";
function filtrer(statut: Statut) { … }
filtrer("payée");   // ❌ erreur, immédiatement
```

C'est l'un des gains les plus rentables de TypeScript, et le plus simple : remplacer `string` par la liste des valeurs réellement possibles. Tu l'utiliseras pour les variantes de composants, les filtres, les rôles, les statuts.

### ⭐ Les unions discriminées

```ts
type EtatRequete<T> =
  | { statut: "vide" }
  | { statut: "chargement" }
  | { statut: "erreur"; message: string }
  | { statut: "donnees"; donnees: T };

function rendre(etat: EtatRequete<Depense[]>) {
  switch (etat.statut) {
    case "vide":       return "Choisis une catégorie.";
    case "chargement": return "Chargement…";
    case "erreur":     return etat.message;              // ✅ TypeScript sait que message existe
    case "donnees":    return `${etat.donnees.length} dépenses`;  // ✅ et ici, donnees
  }
}
```

Le champ `statut` est le **discriminant** : sa valeur littérale permet à TypeScript de savoir, dans chaque branche, exactement quelle variante il manipule. Accéder à `etat.message` dans la branche `donnees` est une erreur de compilation.

Et il y a un bonus très utile — la **vérification d'exhaustivité** :

```ts
function rendre(etat: EtatRequete<Depense[]>): string {
  switch (etat.statut) {
    case "vide":       return "…";
    case "chargement": return "…";
    case "erreur":     return etat.message;
    case "donnees":    return "…";
    default: {
      const _impossible: never = etat;        // ⭐ si tu ajoutes un état, ceci échoue
      return _impossible;
    }
  }
}
```

Le jour où tu ajoutes un cinquième état à ton union, **le compilateur te signale tous les `switch` à compléter**. C'est exactement la garantie qui manque en JavaScript, où l'oubli est silencieux.

### Les génériques, sans mystère

Un générique est un **paramètre de type**. Compare les deux approches :

```ts
// ❌ Sans générique : on perd l'information
function premierOuNull(liste: unknown[]): unknown | null {
  return liste.length > 0 ? liste[0] : null;
}
const d = premierOuNull(depenses);     // unknown — inutilisable sans vérification

// ✅ Avec générique : le type entre et ressort
function premierOuNull<T>(liste: T[]): T | null {
  return liste.length > 0 ? liste[0] : null;
}
const d = premierOuNull(depenses);     // Depense | null — exactement ce qu'il faut
```

`<T>` se lit « pour n'importe quel type `T` ». Tu n'as rien à préciser à l'appel : TypeScript le **déduit** de l'argument.

Avec une **contrainte**, quand ta fonction a besoin d'une garantie :

```ts
function indexerParId<T extends { id: number }>(elements: T[]): Map<number, T> {
  return new Map(elements.map(e => [e.id, e]));
}
```

`T extends { id: number }` signifie : « n'importe quel type, à condition qu'il ait un champ `id` numérique ». Tu reconnais l'index de la leçon 12 du palier 1 — et il est maintenant typé pour n'importe quelle entité.

Et un usage que tu rencontreras constamment en React :

```ts
type Reponse<T> = { donnees: T; total: number; page: number };
type ReponseDepenses = Reponse<Depense[]>;
```

### Les types utilitaires qui servent vraiment

```ts
interface Depense {
  id: number;
  montant: number;
  categorie: string;
  description: string;
  creeLe: string;
}

Partial<Depense>                          // tous les champs optionnels — pour une mise à jour
Pick<Depense, "montant" | "categorie">    // seulement ces champs
Omit<Depense, "id" | "creeLe">            // tout sauf ceux-là — pour une création
Required<Partial<Depense>>                // l'inverse de Partial
Record<string, number>                    // { [cle: string]: number } — pour des totaux
Record<Statut, string>                    // ⭐ une entrée OBLIGATOIRE par statut
```

Deux usages à retenir, parce qu'ils reviennent dans tous les projets :

```ts
type NouvelleDepense = Omit<Depense, "id" | "creeLe">;   // ce que le formulaire envoie
type MiseAJourDepense = Partial<NouvelleDepense>;         // ce qu'une modification envoie
```

Et le `Record` indexé par une union est une petite merveille : il **force** à couvrir toutes les valeurs.

```ts
const libelles: Record<Statut, string> = {
  brouillon: "Brouillon",
  validee: "Validée",
  // ❌ erreur : la propriété 'payee' est manquante
};
```

### `as const` : figer les valeurs

```ts
const statuts = ["brouillon", "validee", "payee"];              // string[]
const statuts2 = ["brouillon", "validee", "payee"] as const;    // readonly ["brouillon", …]

type Statut = typeof statuts2[number];     // ⭐ "brouillon" | "validee" | "payee"
```

Cette dernière ligne est un idiome très pratique : tu déclares la liste **une seule fois**, et tu en dérives le type. Plus de risque de désynchronisation entre un tableau de valeurs et une union écrite à la main.

---

## Les problèmes que tu vas rencontrer

**`Property 'message' does not exist on type …`** dans une union. Tu accèdes à un champ sans avoir resserré le type. Passe par le discriminant (`if (etat.statut === "erreur")` ou un `switch`).

**Mon union ne se resserre pas.** Il manque un champ discriminant **littéral** commun. Une union de `{ a: string }` et `{ b: number }` ne se discrimine pas sur un `if` simple — il faut un champ comme `type` ou `statut` avec une valeur littérale.

**`Type 'string' is not assignable to type '"brouillon" | …'`.** Tu passes une chaîne venue de l'extérieur à une union de littéraux. C'est **correct** : la donnée doit être validée d'abord. C'est encore la frontière.

**Mon générique rend `unknown`.** Tu as probablement écrit `<T>` sans l'utiliser dans les paramètres, donc TypeScript n'a rien pour le déduire.

**Mon type utilitaire ne fait pas ce que je crois.** `Partial` ne rend pas les champs **nullables** mais **optionnels** (`string | undefined`, et la clé peut être absente). La distinction compte quand tu construis un objet.

**Mes messages d'erreur sont illisibles** avec les génériques. Lis la première et la dernière ligne, et simplifie ton type.

**J'ai écrit un type que je ne comprends plus.** Simplifie. Un type dupliqué mais lisible vaut mieux qu'un type dérivé incompréhensible.

---

## Ce qu'on te demandera

En **entretien** : « `interface` ou `type` ? » (la question la plus posée, et la réponse « presque équivalents, `interface` pour les objets » suffit), « qu'est-ce qu'une union discriminée et quel problème résout-elle ? » (celle qui distingue vraiment), « à quoi sert un générique ? », « connais-tu `Omit` et `Partial` ? ».

En **test technique**, on te donnera un modèle de données à typer, et on regardera si tu utilises des unions de littéraux plutôt que `string`, et si tu dérives tes types au lieu de les dupliquer.

En **revue de code**, les remarques fréquentes : `string` là où une union de littéraux était possible, des types dupliqués au lieu d'être dérivés, et à l'inverse de la sur-ingénierie de types.

---

## Ce qui te démarquera

**Rendre les états impossibles inexprimables.** C'est le raisonnement de conception le plus marquant de cette leçon. Dire « je modélise avec une union discriminée pour qu'on ne puisse pas avoir chargement et données en même temps » est une phrase de développeur expérimenté.

**La vérification d'exhaustivité avec `never`.** Très peu de gens la connaissent, et elle transforme un oubli silencieux en erreur de compilation.

**Remplacer `string` par la liste des valeurs réelles.** Le gain le plus simple et le plus rentable du typage.

**Dériver au lieu de dupliquer.** `Omit<Depense, "id">` pour une création — et ton type reste cohérent quand le modèle évolue.

**Savoir s'arrêter.** La sur-ingénierie de types est un travers répandu. Préférer un type lisible à un type astucieux est un jugement, et il se remarque.

---

## 📚 À lire

**TypeScript Handbook** → *Everyday Types*, *Narrowing* (la section *Discriminated unions* en particulier), *Object Types*, et *Generics* — sans aller plus loin.

**typescriptlang.org → Utility Types** : la page de référence de `Partial`, `Pick`, `Omit`, `Record`. À garder en favori, personne ne les retient tous.

**Total TypeScript** : les exercices sur les unions discriminées et les génériques sont les plus utiles de la collection gratuite.

Et un article qui résume la philosophie de la leçon : *« Make impossible states impossible »* — on le trouve sous plusieurs formes, le concept vient d'Elm et il est devenu un standard du typage appliqué.

---

## 🤖 Le mini-projet à demander à l'IA

La modélisation s'apprend sur des cas où un mauvais type autorise un bug.

> « Je suis en formation de développeur, palier 3. Je travaille les unions discriminées, les génériques et les types utilitaires en TypeScript. Donne-moi **8 modèles de données décrits en langage naturel** (un panier de commande avec ses états, un paiement, un formulaire multi-étapes, une notification de plusieurs sortes, un utilisateur avec plusieurs rôles aux droits différents…). Pour chacun, **n'écris aucun type** : ma mission est de les modéliser. Ensuite, critique mon modèle sur une seule question : **quels états incohérents mon type autorise-t-il encore ?** Donne-moi un exemple concret de valeur absurde que je pourrais construire sans que le compilateur se plaigne. »

C'est le bon critère d'évaluation : un type n'est pas bon parce qu'il compile, il est bon parce qu'il **interdit** ce qui ne doit pas exister.

Puis l'exercice sur les génériques, qui enlève la peur du mot :

> « Donne-moi 6 fonctions utilitaires à écrire, décrites en français, qui **exigent** un générique pour conserver l'information de type (premier élément, grouper par clé, indexer par identifiant, fusionner deux objets, retirer les valeurs nulles d'un tableau, mémoïser une fonction). Donne-moi seulement la description et deux exemples d'appel avec le type attendu en retour. Je les écris, tu me dis si ma signature est la plus simple possible. »

---

## 🛠️ À faire

1. Modélise le domaine de ton projet 1 : `Depense`, `Categorie`, et un type `Statut` en union de littéraux. Dérive `NouvelleDepense` avec `Omit` et `MiseAJourDepense` avec `Partial`.
2. **L'union discriminée** : écris `EtatRequete<T>` avec les quatre états, et une fonction de rendu avec un `switch`. Essaie d'accéder à `message` dans la branche `donnees` et observe l'erreur.
3. **La vérification d'exhaustivité** : ajoute le `default` avec `never`, puis ajoute un cinquième état à ton union et constate que le compilateur te signale le `switch` incomplet.
4. **Démontre le problème des booléens** : écris la version à quatre booléens, et construis une valeur absurde (`chargement` et `erreur` à `true` avec des données). Constate que ça compile. Écris la conclusion dans ton journal.
5. Écris `premierOuNull<T>`, `grouperPar<T>` et `indexerParId<T extends { id: number }>`. Vérifie dans l'éditeur que les types de retour sont corrects (survole les appels).
6. **`Record` sur une union** : crée `Record<Statut, string>` pour les libellés d'affichage, puis retire une clé et observe l'erreur.
7. **`as const`** : déclare la liste des catégories une seule fois et dérive l'union de types avec `typeof … [number]`.
8. Remplace tous les `string` de ton modèle par des unions de littéraux là où les valeurs sont connues. Compte combien de fautes de frappe potentielles tu viens d'éliminer.
9. Écris un type `Reponse<T>` paginé (`donnees`, `total`, `page`) et utilise-le pour deux entités différentes.
10. **L'exercice de retenue** : prends le type le plus compliqué que tu as écrit aujourd'hui, et réécris-le en deux types simples. Compare la lisibilité.

<details>
<summary>Corrections et points de contrôle</summary>

**1.**
```ts
type Statut = "brouillon" | "validee" | "payee";

interface Depense {
  readonly id: number;
  montant: number;              // en centimes (palier 1, leçon 01)
  categorie: Categorie;
  description: string;
  statut: Statut;
  readonly creeLe: string;      // format YYYY-MM-DD (palier 1, leçon 04)
}

type NouvelleDepense = Omit<Depense, "id" | "creeLe" | "statut">;
type MiseAJourDepense = Partial<NouvelleDepense>;
```
Les deux `readonly` traduisent une règle métier : un identifiant et une date de création ne se modifient pas. Le type documente la règle.

**3.** Le bloc `default` avec `const _impossible: never = etat;` échoue à la compilation dès qu'une variante n'est pas traitée, parce qu'il reste alors un type assignable à `etat` qui n'est pas `never`. C'est le mécanisme qui transforme un oubli en erreur — et il est particulièrement précieux quand le `switch` est à six endroits différents du projet.

**4.** La valeur absurde : `{ enChargement: true, aErreur: true, estVide: true, donnees: [{…}] }`. Elle compile parfaitement, et pourtant elle ne veut rien dire. Ton code d'affichage devra alors trancher par ordre de priorité des `if`, ce qui est une convention fragile. **Conclusion à écrire : quatre booléens décrivent seize états dont douze sont impossibles ; une union discriminée en décrit exactement quatre.**

**5.**
```ts
function grouperPar<T, C extends string | number>(
  elements: T[],
  obtenirCle: (e: T) => C
): Record<C, T[]> {
  return elements.reduce((acc, e) => {
    const cle = obtenirCle(e);
    (acc[cle] ??= []).push(e);
    return acc;
  }, {} as Record<C, T[]>);
}
```
C'est le `reduce` de groupement du palier 1, leçon 06, désormais générique et typé. Le survol dans l'éditeur doit montrer le bon type de retour pour n'importe quelle entité.

**8.** Compte les champs que tu as convertis : chaque `string` remplacé par une union élimine **toutes** les fautes de frappe possibles sur ce champ, et fait apparaître l'autocomplétion dans l'éditeur. C'est le meilleur rapport effort/bénéfice de TypeScript.

**10.** Si ta réécriture en deux types est plus facile à lire, garde-la. Un type n'est pas un exercice de virtuosité : c'est de la documentation exécutable, et la documentation illisible ne sert personne.
</details>

---

## ✅ Acquis si…

- [ ] Je choisis entre `interface` et `type` sans y réfléchir longtemps.
- [ ] Je remplace `string` par une union de littéraux quand les valeurs sont connues.
- [ ] J'écris une **union discriminée** et j'explique le problème qu'elle résout.
- [ ] J'ai construit un état absurde avec des booléens, puis démontré que l'union l'interdit.
- [ ] J'utilise la vérification d'exhaustivité avec `never`.
- [ ] J'écris une fonction générique simple, avec contrainte si nécessaire.
- [ ] J'utilise `Omit`, `Partial`, `Pick` et `Record` pour dériver au lieu de dupliquer.
- [ ] Je sais dériver une union depuis un tableau avec `as const`.
- [ ] Je préfère un type lisible à un type astucieux.

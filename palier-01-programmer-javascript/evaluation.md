# ✅ Épreuve de sortie — Palier 1

> **Le palier le plus important du parcours**, donc l'épreuve la plus exigeante. Tout ce qui est validé ici sera réutilisé en TypeScript, Python, PHP et Dart. Un trou laissé ouvert maintenant devient un mur au palier 4.
>
> **Conditions** : seul, **sans IA, sans tutoriel, sans tes anciennes solutions**. La doc officielle (MDN) est autorisée en parties A et C, interdite en partie B.
> **Durée** : ~4 h, en une seule session si possible (hors projet).
> **Seuil de réussite** : les 5 épreuves pratiques (A) réussies · **24/30** au quiz (B) · le défi chronométré (C) réussi · le projet 1 livré (D).
> **En cas d'échec** : note précisément ce qui a manqué, retravaille **uniquement** les leçons concernées, repasse une semaine plus tard. Ce palier mérite deux semaines de plus ; il ne mérite pas d'être franchi en trichant.

---

## Partie A — Épreuves pratiques

> Un fichier par épreuve, dans un repo `eval-palier-1`. Pousse-le sur GitHub : il fait partie du livrable.

### A1 — Fonctions pures et tableaux (40 min)
À partir d'un tableau de dépenses `{ id, montant, categorie, description, date }` que tu construis toi-même (8 éléments, au moins 3 catégories), écris **sans boucle `for`** :
1. `total(depenses)`
2. `totauxParCategorie(depenses)` → `{ food: 2000, transport: 3000 }`
3. `topN(depenses, n)` → les n plus grosses, triées, **sans muter** l'original
4. `moyenne(depenses)` → arrondie, `0` sur tableau vide
5. `categoriesUniques(depenses)`
6. `ajouter / supprimer / modifier` → chacune retourne un **nouveau** tableau
7. `pourcentageParCategorie(depenses)` → `{ food: 40, transport: 60 }`

✅ **Réussi si** : les 7 fonctions sont pures, aucune ne mute son argument, chacune gère le tableau vide, et aucune boucle `for` n'apparaît.

### A2 — Closures (20 min)
1. `creerCompteur()` → `{ incrementer, decrementer, lire, reinitialiser }`, compte **privé** (impossible d'y accéder de l'extérieur).
2. `creerLimiteur(max)` → autorise `max` appels puis refuse.
3. `memoise(f)` → cache dans une closure ; démontre le gain sur `fibonacci(35)` avec `console.time`.

✅ **Réussi si** : l'état est réellement inaccessible, et le gain de mémoïsation est mesuré et affiché.

### A3 — Asynchrone (40 min)
1. `recupererPokemon(nom)` → `{ nom, poids, types }`, avec vérification de `r.ok`, gestion du 404 et de l'erreur réseau.
2. Récupère **5** Pokémon en séquentiel puis avec `Promise.all` ; chronomètre les deux et affiche le rapport.
3. `recupererAvecReessais(url, essais)` avec attente exponentielle.
4. `avecTimeout(promesse, ms)` via `Promise.race`.
5. Corrige le piège : fais échouer volontairement une version `forEach(async …)`, puis donne les deux corrections.

✅ **Réussi si** : tout fonctionne, `r.ok` est vérifié partout, et l'écart séquentiel/parallèle est mesuré.

### A4 — Débogage (20 min)
On te donne ce code. **Trouve les 5 bugs par la lecture seule** (écris-les avant d'exécuter), puis corrige :

```js
function analyser(depenses) {
  let total = 0;
  for (let i = 1; i <= depenses.length; i++) {
    total += depenses[i].montant;
  }
  const moyenne = total / depenses.length;
  const cheres = depenses.map(d => d.montant > moyenne);
  const triees = depenses.sort();
  return { total, moyenne: moyenne.toFixed(2), cheres, premiere: triees[0] };
}
```

✅ **Réussi si** : les 5 bugs sont identifiés **avant** exécution. *(Il y en a un de plus que les 5 attendus : le trouver est un bonus.)*

### A5 — Complexité (20 min)
1. Trouve et corrige le `O(n²)` :
   ```js
   const enrichies = depenses.map(d => ({ ...d, cat: categories.find(c => c.id === d.catId)?.nom }));
   ```
2. Mesure l'écart `find` vs `Map` sur 100 000 éléments et 1 000 recherches.
3. Donne la complexité de 4 extraits qu'on te propose (reprends l'exercice 8 de la leçon 12) et **justifie** chaque réponse.

✅ **Réussi si** : la correction est en `O(n + m)`, l'écart est mesuré, les 4 justifications sont exactes.

---

## Partie B — Quiz (30 questions, sans aide, sans doc)

> Réponds **par écrit** avant de dérouler les corrections. 1 point par question. Seuil : **24/30**.

**Bases**
1. Différence entre `let`, `const` et `var` ? Lequel n'utilises-tu jamais, et pourquoi ?
2. Pourquoi `const liste = []` permet-il `liste.push(1)` ?
3. Pourquoi `===` et jamais `==` ? Donne deux exemples où `==` surprend.
4. Cite les 6 valeurs falsy.
5. Différence entre `||` et `??` ? Donne un cas où `||` produit un bug.
6. Que vaut `typeof null` et pourquoi est-ce ainsi ?
7. Pourquoi `0.1 + 0.2 !== 0.3` ? Comment stocke-t-on de l'argent correctement ?

**Fonctions et portée**
8. Qu'est-ce qu'une fonction **pure** ? Donne un avantage concret.
9. Qu'est-ce qu'un effet de bord ? Cite-en trois.
10. Qu'est-ce qu'une closure ? Explique avec ta propre analogie.
11. Pourquoi `for (var i …)` + `setTimeout` affiche-t-il `3,3,3` ? Deux corrections.
12. Quand une fonction fléchée est-elle un mauvais choix ?
13. Au-delà de combien de paramètres passe-t-on un objet, et pourquoi ?

**Données**
14. Valeur vs référence : montre le bug de la « fausse copie ».
15. Pourquoi `{...objet}` ne suffit-il pas pour un objet imbriqué ? Que faire ?
16. Que renvoie `[10, 9, 100].sort()` et pourquoi ?
17. Cite 3 méthodes qui mutent un tableau et leur équivalent non mutant.
18. `map`, `filter`, `reduce` : comment choisis-tu ? (La question en une phrase.)
19. Pourquoi faut-il toujours fournir la valeur initiale de `reduce` ?
20. Écris `totauxParCategorie` avec `reduce`, de tête.
21. Pourquoi `filter` avant `map` et pas l'inverse ?

**Asynchrone**
22. Pourquoi l'asynchrone existe-t-il ? (Le fil unique, l'attente d'I/O.)
23. Les 3 états d'une promesse. Peuvent-ils changer après coup ?
24. Que se passe-t-il si on oublie `return` dans un `.then` ?
25. `fetch` rejette-t-il sur un 404 ? Quelle conséquence pratique ?
26. Quand utiliser `Promise.all` plutôt que des `await` successifs ?
27. Pourquoi `forEach(async …)` ne fonctionne-t-il pas comme attendu ? Deux corrections.
28. Ordre de sortie et explication :
    ```js
    console.log("A"); setTimeout(() => console.log("B"), 0);
    Promise.resolve().then(() => console.log("C")); console.log("D");
    ```

**Complexité**
29. Que signifie `O(n²)` ? Donne un motif de code qui la produit et sa correction.
30. Tableau ou `Map` : lequel pour chercher 10 000 fois par identifiant, et pourquoi ?

<details>
<summary>Corrections</summary>

1. `let` (portée de bloc, réassignable), `const` (portée de bloc, non réassignable), `var` (portée de **fonction**, hissée, fuit des blocs). Jamais `var`.
2. `const` empêche la **réaffectation** du nom, pas la **mutation** du contenu.
3. `==` convertit avant de comparer. `"5" == 5` → `true`, `0 == ""` → `true`, `null == undefined` → `true`.
4. `false`, `0`, `""`, `null`, `undefined`, `NaN`.
5. `||` remplace tout falsy ; `??` seulement `null`/`undefined`. Bug : `0 || 10` → `10`, alors que 0 était un montant légitime.
6. `"object"` : un bug historique conservé par compatibilité.
7. La base 2 ne représente pas exactement 0,1 ni 0,2 (vrai dans tous les langages). L'argent se stocke **en entier** (centimes).
8. Même entrée → même sortie, aucun effet de bord. Avantage : testable en une ligne, sans contexte à préparer.
9. Tout ce qui sort du retour : afficher, écrire un fichier, appeler le réseau, modifier une variable extérieure ou un paramètre.
10. Une fonction + l'environnement de variables où elle a été créée, qu'elle conserve ensuite (« le sac à dos »).
11. Avec `var`, une seule variable partagée par les 3 callbacks ; au moment de leur exécution, la boucle est finie et `i` vaut 3. Corrections : `let`, ou capturer la valeur dans une fonction appelée immédiatement.
12. Comme **méthode d'objet** : elle n'a pas de `this` propre et n'accède donc pas à l'objet.
13. Au-delà de 3 : l'appel devient illisible et l'ordre des arguments devient un piège.
14. `const b = a` sur un tableau ne copie rien : `b.push(1)` modifie aussi `a`.
15. Spread est **superficiel** : les objets imbriqués restent partagés. → `structuredClone`.
16. `[10, 100, 9]` : `sort` convertit en chaînes par défaut. → `sort((a,b) => a-b)`.
17. `push`/`[...t, x]` · `splice`/`filter` · `sort`/`[...t].sort()` (ou `toSorted`).
18. **Combien d'éléments en sortie ?** Autant → `map`. Moins → `filter`. Un seul → `reduce`.
19. Sans elle, le premier élément devient l'accumulateur (ce qui casse sur des objets) et un tableau vide lève une `TypeError`.
20. `depenses.reduce((acc, d) => { acc[d.categorie] = (acc[d.categorie] ?? 0) + d.montant; return acc; }, {})`
21. Pour transformer moins d'éléments : filtrer d'abord réduit le travail de `map`.
22. Un seul fil d'exécution ; les opérations lentes (réseau, disque) sont de l'**attente**, pas du calcul. Les déléguer évite de geler le programme.
23. `pending` → `fulfilled` ou `rejected`. L'état est **définitif**.
24. Le `.then` suivant reçoit `undefined`.
25. **Non.** `fetch` ne rejette que si la requête n'aboutit pas (réseau, DNS, CORS). Il faut donc tester `r.ok` soi-même.
26. Quand les appels sont **indépendants** : on gagne le temps de tous sauf le plus lent.
27. `forEach` ignore la promesse retournée par son callback. → `for...of` avec `await`, ou `Promise.all(ids.map(…))`.
28. `A`, `D`, `C`, `B` : le synchrone d'abord, puis les **microtâches** (promesses), puis les **macrotâches** (timers).
29. Le temps croît comme le carré de `n`. Motif : `find`/`includes` **dans** une boucle. Correction : construire un index `Map`/`Set` → `O(n + m)`.
30. `Map` : accès par clé en `O(1)` contre `O(n)` pour un `find` sur tableau.

**Score** : ____ /30
</details>

---

## Partie C — Le défi chronométré

### C1 — Kata Codewars **7 kyu**, seul, en moins de 30 minutes
Sans IA, sans solution lue. Note le nom du kata, le temps, et la solution dans ton journal.

✅ **Réussi si** : résolu seul, en moins de 30 min, tests au vert.

### C2 — L'explication orale (au référent, ou enregistrée)
Sans notes, 2 minutes chacun :
1. « Explique-moi `async/await` avec tes propres mots. »
2. « Qu'est-ce qu'une closure, et à quoi ça sert ? »
3. « Pourquoi `map`/`filter`/`reduce` plutôt que des boucles ? »

✅ **Réussi si** : les trois sont expliqués sans notes, avec un exemple de ton propre code.

---

## Partie D — Le projet

[🛠️ Projet 1 — Gestionnaire de dépenses en CLI](projet.md)

- [ ] Les 5 fonctionnalités **must** fonctionnent
- [ ] Persistance JSON robuste (fichier absent, fichier corrompu)
- [ ] Logique **séparée** de l'affichage (fonctions pures d'un côté, affichage de l'autre)
- [ ] Aucune fonction de plus de 20 lignes, noms explicites
- [ ] Entrée invalide = message clair, **jamais** de plantage
- [ ] Repo GitHub dédié, commits réguliers, README utilisable par un inconnu
- [ ] Démontré au référent

---

## Résultat

| Partie | Seuil | Résultat |
|--------|-------|----------|
| A — Pratique | 5/5 épreuves | ⬜ |
| B — Quiz | 24/30 | ⬜ ___/30 |
| C — Défi (kata 7 kyu + oral) | 2/2 | ⬜ |
| D — Projet 1 livré | tout coché | ⬜ |

**Date de passage** : ______ · **Verdict** : ⬜ validé ⬜ à repasser le ______

- [ ] Palier passé à ✅ dans [../progression.md](../progression.md)
- [ ] [Rétrospective](../templates/retrospective-palier.md) rédigée et relue avec le référent

> 🚦 **Barrière** : le palier 2 reste fermé tant que cette page n'est pas entièrement validée.
> C'est le palier où la tentation de « passer vite au joli visuel » est la plus forte. Résiste : HTML et CSS s'apprennent en quelques semaines quand on sait programmer, et jamais bien quand on ne sait pas.

# Leçon 11 — L'event loop

> 🎯 **À la fin de cette leçon** : tu sais *comment* JavaScript fait de l'asynchrone avec un seul fil d'exécution, et tu prédis l'ordre d'un code mêlant timers et promesses.
> ⏱️ 2 h · **Prérequis** : leçons 09–10.
> **L'objectif est l'intuition, pas l'exhaustivité.** On ne cherche pas à mémoriser une spécification, mais à construire un modèle mental qui te servira toute ta carrière.

---

## De quoi on parle

La **pile d'appels** (*call stack*) est la pile des fonctions en cours d'exécution : `main()` appelle `a()` qui appelle `b()`, et les trois sont empilées. Quand `b()` retourne, elle est dépilée.

JavaScript est **mono-thread** : une seule pile, donc **une seule chose à la fois**.

Les **API de l'environnement** sont tout ce qui n'est **pas** le moteur JavaScript : les timers, le réseau, l'accès aux fichiers. Elles sont fournies par le navigateur ou par Node (via une bibliothèque appelée libuv), et elles travaillent **en dehors** du fil JavaScript.

Les callbacks terminés attendent ensuite dans deux files. La file des **macrotâches** reçoit les callbacks de `setTimeout`, `setInterval`, des événements et des I/O. La file des **microtâches** reçoit ceux des promesses (`.then`, la reprise après un `await`) et de `queueMicrotask`.

Et l'**event loop** est la boucle qui, quand la pile est vide, prend la tâche suivante et l'exécute.

---

## À quoi ça sert, concrètement

**Pour répondre au paradoxe.** JavaScript n'a qu'un seul fil. Comment peut-il attendre une requête de deux secondes *et* rester réactif ? La réponse — et c'est tout le sujet — est qu'**il n'attend pas**. L'attente est déléguée à l'extérieur du moteur.

**Pour comprendre pourquoi une page gèle.** C'est la conséquence pratique la plus importante, et tu la rencontreras aux paliers 2 et 3. Un calcul long gèle l'interface ; un appel réseau long ne gèle rien. Savoir pourquoi te permet de diagnostiquer une interface qui ne répond plus.

**Pour prédire l'ordre d'exécution.** Les deux règles de cette leçon suffisent à expliquer n'importe quelle sortie bizarre, et c'est une question d'entretien classique.

**Et pour comprendre la différence avec PHP.** Au palier 6, tu découvriras un modèle radicalement différent : un processus par requête, où tout meurt à la fin. Au palier 7, tu compareras les deux. Cette leçon est ce qui rendra la comparaison possible.

---

## Où ça intervient dans le développement

Trois endroits où ce modèle a des conséquences réelles.

**Dans le navigateur** (paliers 2 et 3). Le fil qui exécute ton JavaScript est **le même** qui dessine la page et traite les clics. Si tu le monopolises, rien ne s'affiche plus. Un filtre sur dix mille éléments à chaque frappe de clavier, une boucle de calcul, un `JSON.parse` sur un fichier de dix mégaoctets : tout ça gèle l'interface. Les solutions sont de découper le travail, de le différer, ou de le déplacer dans un *Web Worker* (un vrai second fil).

**Dans Node, côté serveur** (palier 4). C'est plus grave encore : un calcul lourd bloque **toutes** les requêtes de tous les utilisateurs, parce qu'ils partagent le même processus. Une seule requête mal écrite peut rendre ton API insensible pour tout le monde. C'est le prix du modèle de Node, et c'est pour ça qu'on y délègue les traitements lourds à des files de tâches (palier 7).

**Dans la comparaison des stacks** (paliers 6 et 7). PHP fonctionne à l'inverse : un processus par requête, chacun isolé. Un calcul long y pénalise un seul utilisateur. En échange, PHP ne peut pas garder d'état en mémoire entre deux requêtes. Ce sont deux compromis différents, et tu devras savoir les exposer — c'est une question d'architecture, et elle revient en entretien.

```
   NODE                                  PHP
   ────                                  ───
   1 processus, 1 fil                    1 processus par requête
   des milliers de connexions            une connexion par processus
   calcul long = tout le monde bloqué    calcul long = un seul utilisateur pénalisé
   état possible en mémoire              tout meurt à la fin de la requête
```

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas surtout **prédire des sorties**, et te tromper au début. C'est l'exercice.

Tu vas aussi, si tu fais l'exercice 4, geler volontairement un programme avec une boucle de calcul. Le vivre une fois rend la notion définitive.

### En équipe, en entreprise

**Tu entendras « tu bloques l'event loop ».** C'est une remarque de revue de code courante côté Node, et elle désigne un traitement synchrone trop long : une lecture de fichier avec `readFileSync` dans une route, une boucle sur un gros tableau, un hachage de mot de passe en version synchrone.

**Tu verras des interfaces qui « sautent ».** Un clic qui ne répond pas, une animation qui se bloque une demi-seconde : presque toujours un travail synchrone trop long sur le fil principal.

**On te posera la question en entretien**, parce qu'elle sépare bien ceux qui comprennent JavaScript de ceux qui l'utilisent.

### Ce qui sert tout le temps, et ce qui est rare

Ce qui sert vraiment : les **deux règles** ci-dessous, et le réflexe « si l'interface gèle, c'est du calcul synchrone ».

Ce qui est utile occasionnellement : savoir que les promesses passent avant les timers, et savoir découper un traitement long.

Rare, et à ne pas apprendre aujourd'hui : les phases détaillées de l'event loop de Node (timers, pending callbacks, poll, check, close), `process.nextTick` et sa priorité particulière, `setImmediate`, les subtilités de l'ordonnancement du rendu dans le navigateur (`requestAnimationFrame`, `requestIdleCallback`), les *Web Workers*. Tu les découvriras par besoin — et la plupart, jamais.

---

## La mécanique

### Le schéma

```
  ┌──────────────────┐
  │   CALL STACK     │  ← le moteur JS : UNE seule chose à la fois
  │  ┌────────────┐  │
  │  │   b()      │  │
  │  │   a()      │  │
  │  │   main()   │  │
  │  └────────────┘  │
  └────────┬─────────┘
           │ setTimeout / fetch / readFile  →  délégué à l'extérieur
           ▼
  ┌──────────────────────────────────┐
  │  APIs de l'environnement         │  ← navigateur ou Node : le chronomètre et le
  │  (timers, réseau, disque)        │     réseau travaillent ICI, hors du fil JS
  └────────┬─────────────────────────┘
           │ quand c'est prêt, le callback est mis en file
           ▼
  ┌─────────────────┐   ┌──────────────────────┐
  │  MICROTÂCHES    │   │     MACROTÂCHES      │
  │  (promesses)    │   │ (setTimeout, I/O…)   │
  └────────┬────────┘   └──────────┬───────────┘
           └──────────┬────────────┘
                      ▼
              ┌───────────────┐
              │  EVENT LOOP   │  « la pile est-elle vide ? alors je dépile une tâche »
              └───────────────┘
```

### Les deux règles qui expliquent tout

> **Règle 1 — L'event loop ne prend une tâche que si la pile d'appels est VIDE.**
> Donc : **tout le code synchrone s'exécute d'abord, jusqu'au bout.** Un `setTimeout(…, 0)` ne s'exécute pas « après 0 ms » : il s'exécute « dès que possible après la fin du code en cours ». C'est pourquoi les délais ne sont jamais garantis — ce sont des minimums.

> **Règle 2 — Les microtâches sont entièrement vidées avant la macrotâche suivante.**
> Les promesses passent **toujours** avant les timers.

C'est tout. Ces deux règles suffisent à prédire n'importe quel ordre d'exécution, et c'est pour ça que cette leçon est courte.

### L'exemple canonique

```js
console.log("1 — synchrone");

setTimeout(() => console.log("2 — macrotâche (timer)"), 0);

Promise.resolve().then(() => console.log("3 — microtâche (promesse)"));

queueMicrotask(() => console.log("4 — microtâche"));

console.log("5 — synchrone");

// Sortie :  1, 5, 3, 4, 2
```

Déroulé : `1` et `5` sont synchrones, dans l'ordre. La pile se vide. L'event loop vide **toute** la file des microtâches — `3`, puis `4`. Seulement ensuite, la macrotâche : `2`.

### Pourquoi un calcul long gèle tout

```js
// Dans un navigateur : la page ne répond plus pendant toute cette boucle
for (let i = 0; i < 5_000_000_000; i++) { /* … */ }
```

La pile n'est jamais vide, donc l'event loop ne tourne pas, donc aucun clic n'est traité, aucune animation ne progresse, aucun timer ne se déclenche.

**« JavaScript n'est pas bloquant » est donc une formule trompeuse** : les **I/O** ne bloquent pas, le **calcul** bloque. C'est une nuance que beaucoup de développeurs ne font jamais, et elle explique la majorité des interfaces qui saccadent.

### `await` est une microtâche

```js
async function f() {
  console.log("A");           // SYNCHRONE : s'exécute à l'appel
  await null;                 // ← ici la fonction SUSPEND, le reste part en microtâche
  console.log("B");
}
f();
console.log("C");
// Sortie : A, C, B
```

**Le corps d'une fonction `async` s'exécute de façon synchrone jusqu'au premier `await`.** C'est la subtilité qui déroute le plus, et une question d'entretien classique (tu l'as déjà vue à l'exercice 10 de la leçon 10).

### Dans Node : quelques files de plus

Node ajoute des phases et une microtâche prioritaire, `process.nextTick`, qui passe **avant** les promesses :

```js
setTimeout(() => console.log("timeout"), 0);
setImmediate(() => console.log("immediate"));
process.nextTick(() => console.log("nextTick"));
Promise.resolve().then(() => console.log("promise"));
// → nextTick, promise, timeout, immediate
```

Ne mémorise pas ce détail. Retiens seulement que **les microtâches passent avant les macrotâches**, et que Node a quelques nuances que tu reverras si besoin au palier 4.

---

## Les problèmes que tu vas rencontrer

**Ton `setTimeout(fn, 1000)` se déclenche après bien plus d'une seconde.** C'est normal : le délai est un **minimum**. Si le fil est occupé, le callback attend. Ne construis jamais une logique qui dépend de la précision d'un timer.

**Ton interface gèle pendant un traitement.** Un calcul synchrone trop long. Solutions : découper le travail en morceaux rendus à l'event loop, ou déplacer le calcul dans un *Web Worker*.

**Ton serveur Node devient insensible sous charge.** Un traitement synchrone lourd dans une route — souvent `readFileSync`, un `JSON.parse` géant, ou une boucle sur un gros jeu de données. Cherche le synchrone dans le chemin critique.

**Ton `console.log` s'affiche « au mauvais endroit ».** Il s'affiche exactement où il doit : c'est ta lecture qui suppose un ordre synchrone.

**Une boucle d'attente active ne finit jamais.** Le cas de l'exercice 6, et c'est le plus instructif de la leçon : en JavaScript, attendre par une boucle `while` est un interblocage garanti.

**Un `setInterval` s'empile.** Si le travail à l'intérieur prend plus de temps que l'intervalle, les exécutions s'accumulent. Préfère un `setTimeout` relancé à la fin du traitement.

---

## Ce qu'on te demandera

« **Explique l'event loop** » est une question d'entretien très fréquente, y compris en junior, et elle est appréciée parce qu'elle a plusieurs niveaux de réponse. Une bonne réponse courte : « JavaScript a un seul fil, donc il délègue les opérations lentes à l'environnement, et l'event loop exécute leurs callbacks quand la pile est vide — en vidant d'abord les microtâches, qui sont les promesses. »

On te donnera aussi un **code à prédire** (les exercices 1 et 2 de cette leçon), et on te demandera parfois « pourquoi une page gèle-t-elle pendant un calcul alors qu'elle ne gèle pas pendant un appel réseau ? ».

Au palier 7 et en entretien d'architecture, on te demandera la **différence entre Node et PHP** sur ce point. C'est une question qui distingue nettement, et tu auras pratiqué les deux.

---

## Ce qui te démarquera

**Savoir dessiner le schéma.** Pile, API de l'environnement, les deux files, la boucle. Peu de juniors en sont capables, et ça rend la réponse incontestable.

**Faire la distinction I/O / calcul.** « Les entrées-sorties ne bloquent pas, le calcul bloque » est une formulation précise qui montre que tu as compris le modèle au lieu de répéter « JavaScript est non bloquant ».

**Repérer un blocage dans du code.** Voir un `readFileSync` dans une route d'API et dire « ça bloque le fil, il faut la version promesse » est une remarque de revue de code que peu de juniors savent faire.

**Savoir comparer avec un autre modèle.** Pouvoir expliquer en trois phrases la différence entre le fil unique de Node et le processus par requête de PHP te place au niveau d'une discussion d'architecture.

---

## 📚 À lire / regarder

🎥 ***« What the heck is the event loop anyway? »*** — Philip Roberts, JSConf EU, 26 minutes. **La ressource la plus rentable du palier.** Il montre la pile et les files en animation, en direct. À regarder en entier, maintenant.

🛠️ **latentflip.com/loupe** — le visualiseur interactif du même auteur : colle ton code, et regarde la pile et les files bouger. Fais-le avec les exemples de cette leçon : c'est ce qui transforme l'explication en intuition.

🎥 ***« In The Loop »*** — Jake Archibald (35 min), pour le détail des micro et macrotâches, si tu veux aller plus loin.

**MDN → *The event loop*** et **javascript.info 12.2** pour la référence écrite.

---

## 🤖 Le mini-projet à demander à l'IA

Cette leçon s'évalue par la prédiction, et l'IA est parfaite pour ça :

> « Je suis en formation de développeur, palier 1 (JavaScript). Je travaille l'event loop. Donne-moi **12 extraits de code** à prédire, **un par un**, de plus en plus difficiles : `console.log` synchrones, `setTimeout` à 0, promesses, `queueMicrotask`, un `await` au milieu d'une fonction, des `.then` chaînés qui mettent en file de nouvelles microtâches, et un `setTimeout` dans un `.then`. Je prédis l'ordre exact, tu me dis si j'ai juste et **tu expliques en te référant aux deux règles** (pile vide d'abord, microtâches avant macrotâches). Ne me donne pas la liste d'avance. »

Puis l'exercice qui rend la notion physique :

> « Donne-moi le brief d'une petite page HTML (sans code) qui **démontre visuellement** le blocage de l'event loop : un bouton qui lance un calcul synchrone de trois secondes, un compteur qui s'incrémente avec `setInterval`, et une animation CSS. Je dois constater ce qui s'arrête et ce qui continue. Ensuite, demande-moi d'expliquer **pourquoi** l'animation CSS continue alors que le compteur s'arrête. »

La réponse à cette dernière question est subtile et vraiment instructive : les animations CSS sont souvent gérées par le compositeur du navigateur, hors du fil JavaScript, alors que `setInterval` dépend de l'event loop. C'est exactement le genre de nuance qui fait comprendre l'architecture d'un navigateur.

---

## 🛠️ À faire

1. **Prédis puis vérifie** — le test de la leçon :
   ```js
   console.log("A");
   setTimeout(() => console.log("B"), 0);
   Promise.resolve().then(() => console.log("C")).then(() => console.log("D"));
   setTimeout(() => console.log("E"), 0);
   queueMicrotask(() => console.log("F"));
   console.log("G");
   ```
2. Même exercice avec une fonction `async` :
   ```js
   async function f() { console.log("1"); await null; console.log("2"); }
   console.log("3"); f(); console.log("4");
   Promise.resolve().then(() => console.log("5"));
   ```
3. Passe ces deux exemples dans **loupe** (latentflip.com/loupe) et observe la pile se remplir et se vider.
4. **Démontre le gel** : écris une boucle de calcul de trois secondes, avec un `setTimeout(…, 100)` programmé **avant**. Constate que le callback n'est appelé qu'après la boucle, et **mesure le retard réel**.
5. **Explique à voix haute**, en deux minutes et sans notes : « comment JavaScript gère-t-il mille requêtes simultanées avec un seul fil ? »
6. Pourquoi ce code n'affiche-t-il **jamais** `"fini"` ?
   ```js
   let pret = false;
   setTimeout(() => { pret = true; }, 100);
   while (!pret) { /* on attend… */ }
   console.log("fini");
   ```
7. Écris une version **non bloquante** d'un traitement long : découpe une boucle d'un million d'itérations en lots de dix mille, en rendant la main à l'event loop entre chaque lot. Vérifie qu'un `setInterval` continue de s'exécuter pendant le traitement.

<details>
<summary>Corrections</summary>

**1.** `A`, `G`, `C`, `F`, `D`, `B`, `E`.
Déroulé : le synchrone d'abord (`A`, `G`). Puis les microtâches **dans leur ordre de mise en file** : `C` d'abord, puis `F` (mis en file avant que `C` ne s'exécute), puis `D` — car le second `.then` n'a été mis en file qu'**après** l'exécution de `C`. Enfin les macrotâches dans l'ordre : `B`, `E`.
Ce point est le plus subtil : une microtâche peut en créer d'autres, et l'event loop vide la file **entièrement**, y compris les nouvelles venues.

**2.** `3`, `1`, `4`, `2`, `5`.
`console.log("3")` · `f()` exécute son corps jusqu'au `await` → `1` · retour au code appelant → `4` · puis les microtâches : la reprise de `f` avait été mise en file **avant** le `.then`, donc `2` puis `5`.

**4.** Le callback programmé à 100 ms ne s'exécute qu'après les trois secondes de boucle : le retard mesuré est d'environ 2 900 ms. **Les délais de `setTimeout` sont un minimum, jamais une garantie.**

**5.** Réponse attendue : parce qu'il **n'attend pas**. Chaque requête est déléguée aux API de l'environnement (réseau, disque), qui travaillent hors du fil JavaScript. Le fil ne fait que démarrer des opérations et traiter les callbacks de celles qui sont terminées, un par un, quand la pile est vide. Le fil unique n'est donc jamais immobilisé par l'attente — seulement par du **calcul**.

**6.** C'est un **interblocage par famine**. La boucle `while` ne rend jamais la main : la pile n'est jamais vide, donc l'event loop ne tourne jamais, donc le callback du `setTimeout` — même prêt depuis longtemps — ne peut **jamais** s'exécuter, donc `pret` ne passe jamais à `true`.
La leçon : **on n'attend jamais par une boucle d'attente active en JavaScript.** On attend par `await` ou par callback. Dans un langage multi-thread, ce code finirait par fonctionner — c'est précisément la différence de modèle, et c'est ce qui rend l'exemple si instructif.

**7.**
```js
async function traiterParLots(elements, tailleLot = 10_000) {
  for (let i = 0; i < elements.length; i += tailleLot) {
    const lot = elements.slice(i, i + tailleLot);
    lot.forEach(traiter);
    await new Promise(r => setTimeout(r, 0));   // ⭐ on rend la main à l'event loop
  }
}
```
Le `await setTimeout(0)` au milieu est ce qui change tout : il permet à l'event loop de traiter les clics, les timers et le rendu entre deux lots. C'est la technique de base pour un traitement long dans un navigateur — et une alternative existe pour les cas lourds : le *Web Worker*, qui offre un vrai second fil.
</details>

---

## ✅ Acquis si…

- [ ] Je dessine pile d'appels, API de l'environnement, les deux files et l'event loop.
- [ ] J'énonce les deux règles : pile vide d'abord, microtâches avant macrotâches.
- [ ] Je prédis correctement les exercices 1 et 2.
- [ ] J'explique pourquoi un calcul long gèle une page, alors qu'un appel réseau non.
- [ ] Je sais que le corps d'une fonction `async` démarre de façon synchrone.
- [ ] J'explique l'exercice 6 — la boucle d'attente qui ne finit jamais.
- [ ] Je sais rendre la main à l'event loop pour ne pas bloquer un traitement long.
- [ ] Je peux comparer en trois phrases le modèle de Node et celui de PHP.

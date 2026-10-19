# Leçon 09 — L'asynchrone (1) : callbacks et promesses

> 🎯 **À la fin de cette leçon** : tu comprends *pourquoi* l'asynchrone existe, tu lis du code à base de promesses, et tu sais quand paralléliser.
> ⏱️ 5 h · **Prérequis** : leçons 03 et 05 (les fonctions sont des valeurs ; les closures).
>
> ⚠️ **C'est le cap difficile du palier, et galérer ici est normal.** Tout le monde galère ; ceux qui prétendent le contraire ont sauté l'étape. Prends le temps : une fois franchi, ce cap ne se repasse jamais, et le concept est identique en Python (`async def`), en Dart (`Future`) et en PHP moderne.

---

## De quoi on parle

Un programme **synchrone** exécute ses instructions l'une après l'autre : chacune attend que la précédente soit terminée. Un programme **asynchrone** lance une opération longue et **continue** ; il sera notifié quand le résultat arrivera.

Une opération **bloquante** immobilise le programme pendant son exécution. Les opérations lentes du développement web sont des **I/O** (*input/output*) : réseau, disque, base de données. Et le point essentiel est qu'elles ne sont pas lentes parce qu'elles calculent — elles sont lentes parce qu'elles **attendent**.

Un **callback** est une fonction passée en argument pour être appelée « quand ce sera prêt ». Une **promesse** (*Promise*) est un objet qui représente **un résultat futur**, avec trois états : `pending` (en attente), puis `fulfilled` (tenue) ou `rejected` (rompue). On réagit avec `.then()`, `.catch()` et `.finally()`, et on **chaîne** ces appels.

---

## À quoi ça sert, concrètement

**Parce que JavaScript n'a qu'un seul fil d'exécution.** Une seule chose à la fois. Alors que se passerait-il pendant un appel réseau de deux secondes, s'il était bloquant ?

```js
// Si c'était synchrone (imaginaire) :
const meteo = telechargerMeteo();     // 2 secondes… PENDANT LESQUELLES RIEN NE RÉPOND
afficher(meteo);                       // dans un navigateur : page gelée, clics ignorés
```

Dans un navigateur, la page serait figée : pas de défilement, pas de clic, pas d'animation. Sur un serveur, les requêtes des autres utilisateurs attendraient leur tour. Le modèle asynchrone est la réponse : **lance l'opération, continue à travailler, et reviens-y quand le résultat arrive.**

```js
console.log("1");
setTimeout(() => console.log("2"), 1000);   // on programme pour plus tard
console.log("3");
// Sortie : 1, 3, 2
```

**Cette sortie `1, 3, 2` est toute la leçon.** Le code ne se lit plus de haut en bas dans l'ordre d'exécution. C'est déstabilisant, et c'est le prix d'une interface qui ne gèle pas et d'un serveur qui traite mille requêtes simultanées avec un seul fil.

---

## Où ça intervient dans le développement

Partout où ton programme sort de lui-même. Autrement dit : à chaque frontière, celles que tu connais depuis la leçon 01.

```
   SYNCHRONE (instantané)          │  ASYNCHRONE (il faut attendre)
   ──────────────────────           │  ───────────────────────────────
   calculs, boucles                 │  appel réseau (fetch)      paliers 1, 2, 3, 9
   map / filter / reduce            │  lecture/écriture fichier  palier 1
   JSON.parse                       │  requête base de données   palier 4
   manipulation d'objets            │  timers                    partout
                                    │  événements utilisateur    palier 2
```

Deux conséquences qui vont structurer tout le reste de ton parcours.

**Côté client**, l'asynchrone est ce qui permet à l'interface de rester vivante. Au palier 2 et 3, tu devras afficher un indicateur de chargement pendant l'attente — et tu comprendras que les « trois états d'écran » (chargement, erreur, données) qu'on t'imposera partout découlent directement de cette leçon. Au palier 9, les quatre états d'une application mobile viennent du même endroit.

**Côté serveur**, c'est ce qui permet à Node de servir des milliers de clients avec un seul processus : pendant qu'une requête attend sa base de données, le fil traite les autres. C'est le modèle de Node, et c'est précisément ce qui le distingue de PHP (palier 6), où chaque requête a son propre processus. Tu comparerais les deux au palier 7 — et cette leçon est ce qui te permettra de comprendre la comparaison.

Une dernière chose, importante : **l'asynchrone n'est pas du parallélisme**. JavaScript ne fait pas deux choses en même temps ; il **attend** plusieurs choses en même temps. La distinction a une conséquence pratique majeure, et c'est la leçon 11 qui l'explique : un calcul long bloque tout, un appel réseau long ne bloque rien.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire ton premier code qui ne s'exécute pas dans l'ordre où il est écrit, et tu vas afficher `undefined` plusieurs fois avant de comprendre pourquoi : tu lis une donnée qui n'est pas encore arrivée.

Tu vas aussi découvrir que le débogage change de nature. `console.log` dans un callback s'affiche après le reste, et la stack trace d'une erreur asynchrone est souvent moins parlante. C'est pour ça que la leçon 08 vient avant.

### En équipe, en entreprise

**Tu liras surtout du `async/await`** (leçon 10), mais tu rencontreras les trois styles. Les callbacks dans du code ancien et dans certaines API de Node, les promesses avec `.then()` dans du code des années 2016-2019, et `async/await` partout ailleurs. **Savoir lire les trois n'est pas optionnel** : une mission de maintenance ne te laisse pas choisir l'âge du code.

**On te parlera de performance en ces termes** : « pourquoi ces trois appels sont-ils en série ? ». Enchaîner des appels indépendants au lieu de les lancer ensemble est la gaffe de performance la plus fréquente, et la plus facile à corriger. Tu la mesureras dans les exercices.

**Les rejets non gérés sont surveillés.** Une promesse rejetée que personne n'attrape produit un `UnhandledPromiseRejection` qui, dans Node moderne, **arrête le processus**. En production, ça veut dire : le serveur tombe. Les linters imposent donc un `catch` ou un `await` sur chaque promesse.

### Ce qui sert tout le temps, et ce qui est rare

Au quotidien : comprendre qu'une valeur arrive plus tard, `.then()`/`.catch()` à la lecture, et surtout `async/await` à l'écriture (leçon 10).

Régulièrement : `Promise.all` pour paralléliser, `Promise.allSettled` quand certains appels peuvent échouer, et créer une promesse pour envelopper une API à callback.

Rare, et à ignorer pour l'instant : `Promise.any`, `Promise.race` (sauf pour un timeout, que tu écriras en exercice), les générateurs asynchrones, `for await...of`, les flux (*streams*), l'annulation avec `AbortController` (utile, mais plus tard). Et une chose dont tu n'auras probablement jamais besoin : construire manuellement une chaîne de callbacks imbriqués — mais tu dois savoir la reconnaître, parce que tu en liras.

---

## La mécanique

### L'évolution historique, et pourquoi la connaître

Les trois étapes répondent au **même** besoin, chacune corrigeant un défaut de la précédente. Tu les apprends dans l'ordre pour comprendre ce que chacune a résolu.

```js
// ① CALLBACKS (2009) — ça marche, mais ça s'imbrique
lireFichier("a.json", (err, a) => {
  if (err) return gererErreur(err);
  lireFichier("b.json", (err, b) => {              // niveau 2
    if (err) return gererErreur(err);
    envoyer(a, b, (err, res) => {                  // niveau 3
      if (err) return gererErreur(err);
      console.log(res);                            // 😱 "callback hell"
    });
  });
});
```

Trois défauts : l'imbrication en escalier, la gestion d'erreur répétée à chaque niveau, et l'impossibilité de composer.

```js
// ② PROMESSES (2015) — la chaîne reste à plat, une seule gestion d'erreur
lireFichier("a.json")
  .then(a => lireFichier("b.json").then(b => ({ a, b })))
  .then(({ a, b }) => envoyer(a, b))
  .then(res => console.log(res))
  .catch(gererErreur);                   // ⭐ un seul catch pour toute la chaîne
```

```js
// ③ ASYNC/AWAIT (2017) — l'asynchrone qui se lit comme du synchrone (leçon 10)
try {
  const a = await lireFichier("a.json");
  const b = await lireFichier("b.json");
  console.log(await envoyer(a, b));
} catch (e) { gererErreur(e); }
```

> **`async/await` n'est pas une alternative aux promesses : c'est une syntaxe par-dessus elles.** Une fonction `async` retourne une promesse ; `await` attend une promesse. Il n'existe aucun moyen de comprendre `await` sans comprendre les promesses — et c'est précisément pourquoi cette leçon vient avant.

### Les trois états

```
       ┌──────────────┐
       │   pending    │  (en attente)
       └──────┬───────┘
         ┌────┴────┐
         ▼         ▼
   ┌──────────┐ ┌──────────┐
   │ fulfilled│ │ rejected │   ← état FINAL : une promesse ne change plus jamais d'état
   │ (valeur) │ │ (erreur) │
   └──────────┘ └──────────┘
```

Le caractère **définitif** de l'état a une conséquence pratique : une promesse déjà résolue peut être consommée plusieurs fois, et elle garde son résultat. Et une promesse déjà lancée **ne s'annule pas** : elle s'exécutera même si tu décides de ne pas attendre son résultat.

### Consommer une promesse

```js
fetch("https://api.exemple.com/meteo")
  .then(reponse => reponse.json())        // ce que retourne un .then devient l'entrée du suivant
  .then(donnees => {
    console.log(donnees.temperature);
    return donnees.temperature;
  })
  .then(temp => console.log(`Il fait ${temp}°`))
  .catch(erreur => console.error("Échec :", erreur.message))   // attrape TOUT ce qui précède
  .finally(() => console.log("Terminé"));                       // succès ou échec
```

Trois règles gouvernent le chaînage, et elles suffisent à tout comprendre :

Ce que **retourne** un `.then` est passé au `.then` suivant. Si tu retournes **une promesse**, le `.then` suivant attend sa résolution — c'est le mécanisme clé, celui qui permet d'enchaîner sans imbriquer. Et une erreur à n'importe quelle étape saute directement au premier `.catch`.

> ⚠️ **L'erreur numéro un du débutant : oublier le `return` dans un `.then`.**
> ```js
> .then(r => { r.json(); })        // ❌ rien n'est retourné → le then suivant reçoit undefined
> .then(r => r.json())             // ✅
> ```
> C'est la même erreur que dans un `map` (leçon 06) : des accolades créent un corps de fonction, qui a besoin d'un `return` explicite.

### Créer une promesse

```js
const attendre = ms => new Promise(resolve => setTimeout(resolve, ms));

// Convertir une API à callback en promesse
function lireFichier(chemin) {
  return new Promise((resolve, reject) => {
    readFile(chemin, "utf8", (err, donnees) => {
      if (err) reject(err);        // → .catch
      else resolve(donnees);       // → .then
    });
  });
}
```

En pratique tu en créeras rarement : les API modernes retournent déjà des promesses (`fetch`, `node:fs/promises`). Mais comprendre `new Promise(resolve, reject)` démystifie tout le reste — et tu en auras besoin le jour où tu devras envelopper une vieille bibliothèque.

### Combiner : la décision de performance

```js
// EN PARALLÈLE : tout démarre en même temps, on attend le plus lent
const [villes, meteo, taux] = await Promise.all([
  fetch(urlVilles).then(r => r.json()),
  fetch(urlMeteo).then(r => r.json()),
  fetch(urlTaux).then(r => r.json()),
]);
// ⚠️ Promise.all échoue dès qu'UNE SEULE échoue

// Tolérant aux échecs : on obtient le statut de chacune
const resultats = await Promise.allSettled([p1, p2, p3]);
// [{status:"fulfilled", value:…}, {status:"rejected", reason:…}, …]

// La première qui répond gagne — utile pour un timeout
const gagnante = await Promise.race([requete, attendre(5000)]);
```

> 💡 **Trois appels indépendants exécutés l'un après l'autre prennent la somme de leurs durées ; avec `Promise.all`, la durée du plus lent.** Trois fois 300 ms font 900 ms en série contre 300 ms en parallèle. C'est le gain de performance le plus facile du métier, et c'est une question d'entretien fréquente. Tu le mesureras à l'exercice 5.
>
> La règle de décision est simple : **on enchaîne seulement quand l'appel suivant a besoin du résultat du précédent.** Sinon, on parallélise.

---

## Les problèmes que tu vas rencontrer

**Tu affiches une valeur et tu obtiens `undefined`.** Tu lis le résultat avant qu'il soit arrivé. C'est **le** symptôme de l'asynchrone mal compris : la ligne suivante s'exécute sans attendre.

**Ton `.then` suivant reçoit `undefined`.** Tu as oublié le `return`.

**Tu as recréé l'enfer des callbacks avec des promesses.** Tu imbriques des `.then` les uns dans les autres au lieu de **retourner** la promesse pour continuer la chaîne à plat. Le signe : plus de deux niveaux d'indentation.

**Tu obtiens `UnhandledPromiseRejection` et le processus s'arrête.** Il manque un `.catch` (ou un `try/catch` avec `await`). En production, c'est un serveur qui tombe : les linters l'interdisent pour cette raison.

**Ton `try/catch` n'attrape rien.** Tu as entouré d'un `try` synchrone un code dont l'erreur survient **plus tard**. Avec des promesses, il faut `.catch` ; avec `await`, le `try/catch` fonctionne (leçon 10).

**Ton code est trois fois plus lent que nécessaire.** Tu as enchaîné des appels indépendants. `Promise.all`.

**Tu as un `console.log` qui s'affiche avant la chaîne.** C'est normal et c'est la leçon : le code synchrone s'exécute d'abord, intégralement (leçon 11).

**Une promesse que tu as cessé d'attendre s'exécute quand même.** Les promesses ne s'annulent pas. Si tu as besoin d'annuler, il faut `AbortController` — et c'est un sujet du palier 2 et 3, quand un utilisateur quitte une page pendant un chargement.

---

## Ce qu'on te demandera

L'asynchrone est, avec les closures, **le sujet le plus discriminant** d'un entretien JavaScript junior. Et il est discriminant parce qu'il n'y a pas de bluff possible : soit on a le modèle, soit on ne l'a pas.

Les questions récurrentes : « pourquoi l'asynchrone existe-t-il ? », « quels sont les trois états d'une promesse ? », « différence entre callbacks, promesses et async/await ? », « quand utiliserais-tu `Promise.all` ? », « que se passe-t-il si une promesse est rejetée sans `catch` ? ».

Et il y a l'exercice de **prédiction d'ordre** : on te donne un code mêlant `console.log`, `setTimeout` et `.then`, et on te demande la sortie. C'est l'exercice 1 de cette leçon, et la réponse complète relève de la leçon 11.

En **test technique**, on te demandera presque certainement de consommer une API : récupérer des données, gérer l'erreur, afficher un état de chargement. C'est le projet 2 du parcours, en miniature.

---

## Ce qui te démarquera

**Savoir paralléliser, et savoir le mesurer.** Dire « ces trois appels sont indépendants, je les passe en `Promise.all`, on gagne 600 ms » avec un chiffre à l'appui est une remarque de performance concrète, rare chez un junior.

**Mettre un `catch` partout, par réflexe.** Et savoir expliquer ce qui se passe sans lui : un processus qui s'arrête en production.

**Traiter l'échec comme un cas normal.** Un réseau coupé, un serveur en panne, une réponse lente ne sont pas des exceptions : ce sont des situations ordinaires. Prévoir un message et un bouton « réessayer » dès la première version est un réflexe de professionnel — et ce sera un critère d'évaluation au palier 9.

**Savoir lire les trois générations de syntaxe.** Le code que tu maintiendras en mission ne sera pas écrit dans le style que tu préfères.

**Savoir que l'asynchrone n'est pas du parallélisme.** Cette précision de vocabulaire, bien expliquée, montre que tu as compris le modèle et pas seulement la recette.

---

## 📚 À lire / regarder

**javascript.info** est la meilleure ressource sur le sujet, dans cet ordre : 11.1 (*Introduction: callbacks*), 11.2 (*Promise*), 11.3 (*Promises chaining*), 11.5 (*Promise API*). Lis-les dans l'ordre, elles sont conçues pour.

**MDN → *Using promises*** : lis-la **deux fois**, une avant les exercices et une après. Elle prend un sens différent la seconde fois.

**The Odin Project → Foundations → Asynchronous JavaScript** pour la pratique guidée.

Et la vidéo ***« What the heck is the event loop anyway? »*** (Philip Roberts, 26 min) : regarde-la **maintenant ou à la leçon 11**, mais pas plus tard. C'est la ressource la plus rentable du palier.

---

## 🤖 Le mini-projet à demander à l'IA

L'asynchrone se comprend par la **prédiction d'ordre**, puis par la mesure.

> « Je suis en formation de développeur, palier 1 (JavaScript). J'apprends les promesses. Donne-moi **10 extraits de code** mêlant `console.log`, `setTimeout`, `Promise.resolve().then()` et des fonctions qui retournent des promesses. Présente-les **un par un** : je prédis l'ordre exact de la sortie, tu me dis si j'ai juste et tu expliques **pourquoi**, en parlant de la pile et des files d'attente. Monte progressivement en difficulté. Ne me donne pas la liste d'avance. »

Puis l'exercice qui ancre la notion de parallélisme :

> « Fabrique-moi un énoncé d'exercice en Node, **sans me donner le code** : je dois écrire un script qui récupère des données sur une API publique gratuite (PokéAPI), d'abord en série puis en parallèle, chronomètre les deux, et affiche le rapport. Donne-moi les spécifications, les cas d'erreur à gérer (nom inexistant, réseau coupé, réponse lente) et **une question à laquelle je devrai répondre à la fin** : pourquoi l'écart mesuré n'est-il pas exactement de trois ? »

Cette dernière question est volontairement subtile — la réponse implique la latence réseau, les limites de connexions simultanées du navigateur ou de Node, et la variabilité des mesures. C'est le genre de nuance qui fait progresser.

---

## 🛠️ À faire

1. **Prédis l'ordre de sortie**, puis vérifie :
   ```js
   console.log("A");
   setTimeout(() => console.log("B"), 0);
   Promise.resolve().then(() => console.log("C"));
   console.log("D");
   ```
2. Écris `attendre(ms)` qui retourne une promesse, puis utilise-la pour afficher `"1"`, `"2"`, `"3"` à une seconde d'intervalle — **avec des `.then` chaînés** (pas d'`await` : c'est l'exercice).
3. Écris `lireJson(chemin)` qui retourne une promesse résolue avec l'objet, rejetée si le fichier est absent ou invalide. Teste les deux cas avec `.then`/`.catch`.
4. Avec `fetch` et des `.then` uniquement, récupère `https://pokeapi.co/api/v2/pokemon/pikachu` et affiche son nom et son poids. Gère l'erreur réseau.
5. **Mesure le gain** : récupère trois Pokémon, d'abord en chaîne, puis avec `Promise.all`. Chronomètre les deux avec `console.time`. Note l'écart dans ton journal.
6. Avec `Promise.allSettled`, récupère trois URL dont **une volontairement invalide**, et affiche un rapport succès/échecs.
7. Écris `avecTimeout(promesse, ms)` qui rejette si la promesse n'a pas abouti dans le délai (indice : `Promise.race`).
8. **Provoque un rejet non géré** : lance une promesse rejetée sans `.catch` et observe ce que fait Node. Puis corrige.
9. **Corrige ce code** — il contient trois erreurs :
   ```js
   function recupererUtilisateur(id) {
     fetch(`https://api.exemple.com/users/${id}`)
       .then(r => { r.json(); })
       .then(u => console.log(u.name));
   }
   const u = recupererUtilisateur(1);
   console.log(u.name);
   ```

<details>
<summary>Corrections</summary>

**1.** `A`, `D`, `C`, `B`. Le code synchrone d'abord (`A`, `D`), puis les **microtâches** (les promesses → `C`), puis les **macrotâches** (les timers → `B`). Retiens pour l'instant : **les promesses passent avant les `setTimeout`, même à 0 ms.** L'explication complète est la leçon 11.

**2.**
```js
const attendre = ms => new Promise(resolve => setTimeout(resolve, ms));

attendre(1000)
  .then(() => { console.log("1"); return attendre(1000); })    // ⭐ return : le then suivant attend
  .then(() => { console.log("2"); return attendre(1000); })
  .then(() => console.log("3"));
```
Sans les `return`, les trois s'affichent presque en même temps. C'est l'exercice : le `return` d'une promesse est ce qui crée la séquence.

**5.**
```js
console.time("serie");
await fetch(u1).then(r => r.json());
await fetch(u2).then(r => r.json());
await fetch(u3).then(r => r.json());
console.timeEnd("serie");

console.time("parallele");
await Promise.all([u1, u2, u3].map(u => fetch(u).then(r => r.json())));
console.timeEnd("parallele");
```
Tu devrais mesurer un rapport proche de trois. Pas exactement trois : la latence varie, et les connexions simultanées sont limitées.

**7.**
```js
const avecTimeout = (promesse, ms) =>
  Promise.race([
    promesse,
    new Promise((_, reject) => setTimeout(() => reject(new Error(`Timeout après ${ms}ms`)), ms)),
  ]);
```
Note une limite : la promesse d'origine **continue** de s'exécuter, on cesse simplement de l'attendre. Pour l'annuler vraiment, il faut `AbortController`.

**9.** Les trois erreurs :
1. `.then(r => { r.json(); })` — accolades sans `return` : le `then` suivant reçoit `undefined`. → `.then(r => r.json())`
2. Pas de `.catch` : une erreur réseau devient un rejet non géré.
3. La fonction ne **retourne** pas la promesse, donc `recupererUtilisateur(1)` vaut `undefined` et `console.log(u.name)` plante. **Une fonction asynchrone doit retourner sa promesse** pour que l'appelant puisse l'attendre.
```js
function recupererUtilisateur(id) {
  return fetch(`https://api.exemple.com/users/${id}`)
    .then(r => {
      if (!r.ok) throw new Error(`HTTP ${r.status}`);    // fetch ne rejette PAS sur 404 ! (leçon 10)
      return r.json();
    });
}
recupererUtilisateur(1)
  .then(u => console.log(u.name))
  .catch(e => console.error("Échec :", e.message));
```
</details>

---

## ✅ Acquis si…

- [ ] J'explique **pourquoi** l'asynchrone existe : un seul fil, et des opérations qui attendent.
- [ ] Je prédis correctement la sortie de l'exercice 1 et je sais l'expliquer.
- [ ] Je cite les trois états d'une promesse et je sais qu'ils sont définitifs.
- [ ] Je chaîne des `.then` en **retournant** des promesses, sans les imbriquer.
- [ ] Je place un `.catch` sur toutes mes chaînes, et je sais ce qui arrive sans lui.
- [ ] Je sais quand utiliser `Promise.all` plutôt qu'un enchaînement, et j'ai **mesuré** l'écart.
- [ ] Je sais que l'asynchrone n'est pas du parallélisme.
- [ ] J'ai corrigé les trois erreurs de l'exercice 9 sans regarder la correction.

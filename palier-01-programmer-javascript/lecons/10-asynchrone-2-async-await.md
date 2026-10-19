# Leçon 10 — L'asynchrone (2) : async/await et fetch

> 🎯 **À la fin de cette leçon** : tu écris du code asynchrone qui se lit comme du synchrone, et tu consommes une vraie API en gérant tous les cas d'échec.
> ⏱️ 5 h · **Prérequis** : leçon 09 — obligatoire, `await` n'a aucun sens sans les promesses.

---

## De quoi on parle

`async` placé devant une fonction fait deux choses : elle **retourne toujours une promesse**, et elle autorise `await` à l'intérieur.

`await` signifie « attends la résolution de cette promesse et donne-moi sa valeur ». Il ne « bloque » que la fonction `async` qui l'entoure ; le reste du programme continue.

`fetch` est l'API standard pour faire des requêtes HTTP — dans le navigateur **et** dans Node depuis la version 18. Elle retourne une promesse résolue avec un objet **`Response`**, qui porte `status`, `ok`, `headers`, et les méthodes `.json()` et `.text()`.

---

## À quoi ça sert, concrètement

`async/await` est du **sucre syntaxique** sur les promesses : même mécanisme, écriture linéaire. Compare :

```js
// Avec des promesses
function chargerMeteo(ville) {
  return fetch(`${API}/weather?q=${ville}`)
    .then(r => r.json())
    .then(d => ({ ville: d.name, temp: d.main.temp }))
    .catch(e => { console.error(e); return null; });
}

// Avec async/await — même chose, lisible de haut en bas
async function chargerMeteo(ville) {
  try {
    const reponse = await fetch(`${API}/weather?q=${ville}`);
    const donnees = await reponse.json();
    return { ville: donnees.name, temp: donnees.main.temp };
  } catch (e) {
    console.error(e);
    return null;
  }
}
```

Ce que tu gagnes est considérable en pratique : les variables intermédiaires sont **nommées**, les conditions et les boucles redeviennent naturelles (essaie d'écrire une boucle avec des `.then`…), le `try/catch` ordinaire fonctionne, et le débogueur s'arrête ligne par ligne comme sur du code normal.

**Et c'est devenu la façon normale d'écrire.** Tu écriras `async/await` dans 95 % des cas ; les `.then` te serviront surtout à **lire** du code existant.

---

## Où ça intervient dans le développement

C'est la syntaxe de **toutes tes frontières**, dans les quatre langages du parcours.

```
   palier 1  : lire/écrire un fichier, consommer une API publique
   palier 2  : fetch dans le navigateur → les 3 états d'écran
   palier 3  : TanStack Query (qui enveloppe tout ça pour toi)
   palier 4  : chaque requête de base de données, chaque appel de service externe
   palier 5  : `async def` en Python — exactement le même concept
   palier 9  : `Future` et `await` en Dart — exactement le même concept
```

Deux points d'architecture à retenir dès maintenant.

**Une fonction `async` retourne une promesse, donc l'asynchronie « remonte ».** Si une fonction appelle une fonction asynchrone et doit attendre son résultat, elle devient elle-même asynchrone. C'est ce qu'on appelle parfois la « coloration » des fonctions : l'asynchronie se propage vers le haut jusqu'au point d'entrée. Ce n'est pas un défaut, mais ça explique pourquoi, dans un projet réel, presque toute la couche qui touche aux données est `async`.

**La décision parallèle ou séquentielle est une décision de conception.** Elle n'est pas automatique, personne ne la prendra pour toi, et c'est l'un des rares endroits où un junior peut améliorer la performance d'une application de façon spectaculaire en changeant trois lignes.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas consommer de vraies API et découvrir que le monde extérieur est imprévisible : un nom qui n'existe pas, une réponse dont la forme n'est pas celle attendue, un réseau qui coupe. Les exercices sont construits pour te faire rencontrer chaque cas.

Tu vas aussi rencontrer **le piège le plus coûteux de cette leçon** : `fetch` ne rejette pas sur un 404. Il est détaillé plus bas, et il te mordra au palier 2 si tu l'oublies.

### En équipe, en entreprise

**Tout le code qui touche aux données est `async`.** Les routes d'API, les accès base, les appels de services. C'est tellement systématique que tu finiras par écrire `async` par réflexe.

**On te reprendra sur trois choses.** Les `await` en série alors qu'ils pourraient être parallèles. L'absence de vérification de `r.ok`. Et l'absence de gestion de l'échec : « qu'est-ce qui s'affiche si l'API est en panne ? » est une question que tout relecteur posera.

**Tu rencontreras `forEach` + `async`**, qui ne fait pas ce qu'on croit, dans du code d'autrui comme dans le tien. C'est l'un des bugs asynchrones les plus fréquents du métier.

**Et tu découvriras au palier 3 que des bibliothèques font tout ça pour toi.** TanStack Query gère le chargement, les erreurs, le cache, les nouvelles tentatives et l'invalidation. Mais il ne te dispense pas de comprendre : il te dispense de réécrire deux cents lignes que tu aurais buguées.

### Ce qui sert tout le temps, et ce qui est rare

Au quotidien : `async`/`await`, `try/catch`, `fetch` avec vérification de `r.ok`, `Promise.all`.

Régulièrement : `for...of` avec `await` quand la séquence compte, un timeout sur une requête, des nouvelles tentatives avec attente croissante.

Rare, et hors sujet maintenant : le *top-level await* (utilisable dans les modules), `for await...of` et les itérateurs asynchrones, les flux, `AbortController` (utile dès le palier 2 pour annuler un chargement), les files de tâches. Et une chose que tu ne feras probablement jamais : écrire manuellement un pool de concurrence — même si tu rencontreras le besoin de limiter les appels simultanés, et qu'une bibliothèque le fera pour toi.

---

## La mécanique

### La forme de base

```js
async function principal() {
  const donnees = await chargerDonnees();     // on attend ici, sans bloquer le programme
  console.log(donnees);
}

// Toutes les formes
const f1 = async () => { … };
const obj = { async methode() { … } };

// Appeler une fonction async
principal();                                     // ⚠️ retourne une promesse non attendue
await principal();                               // dans un module ES, ou dans une autre async
principal().catch(e => console.error(e));        // ⭐ au minimum, attrape l'erreur
```

Deux équivalences à garder en tête : `const x = maFonctionAsync()` donne une **promesse**, pas la valeur — il faut `await`. Et `return 5` dans une fonction `async` retourne en réalité une promesse résolue avec `5`.

### Gérer les erreurs

```js
async function charger() {
  try {
    const r = await fetch(url);
    if (!r.ok) throw new Error(`HTTP ${r.status} ${r.statusText}`);   // ⚠️ voir ci-dessous
    return await r.json();
  } catch (e) {
    if (e instanceof TypeError) console.error("Problème réseau :", e.message);
    else console.error("Problème applicatif :", e.message);
    throw e;                                 // relancer si l'appelant doit savoir
  } finally {
    masquerLeChargement();
  }
}
```

Note la distinction dans le `catch` : `fetch` rejette avec une `TypeError` quand la requête **n'a pas pu aboutir** (pas de réseau, DNS, CORS), alors que les autres erreurs viennent de ton propre `throw`. Les deux cas méritent des messages différents pour l'utilisateur : « vérifiez votre connexion » n'est pas « le service est indisponible ».

> ### ⚠️ Le piège le plus important de `fetch`
> **`fetch` ne rejette PAS sur un 404 ou un 500.** Pour lui, « le serveur a répondu » est un succès — même si la réponse est une erreur.
> ```js
> const r = await fetch("https://api.github.com/nexistepas");
> console.log(r.ok);        // false
> console.log(r.status);    // 404
> await r.json();           // tu obtiens le corps d'erreur, pas une exception
> ```
> **Donc : vérifie toujours `r.ok` toi-même.** C'est le bug numéro un des débutants avec `fetch`, et son symptôme est particulièrement trompeur — ton code « marche », et tu affiches des données d'erreur comme si c'étaient des données valides. Axios, lui, rejette sur un 4xx/5xx : d'où la confusion fréquente entre les deux bibliothèques.

### `fetch` en détail

```js
// GET
const r = await fetch("https://api.github.com/users/torvalds");
if (!r.ok) throw new Error(`HTTP ${r.status}`);
const utilisateur = await r.json();

// POST avec du JSON
const r2 = await fetch("https://httpbin.org/post", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ montant: 1500, categorie: "food" }),   // ⚠️ une CHAÎNE, pas un objet
});

// L'objet Response
r.ok               // true si le statut est dans 200–299
r.status           // 200, 404, 500…
r.headers.get("content-type")
await r.json()     // ⚠️ lève une exception si le corps n'est pas du JSON
await r.text()     // utile pour déboguer : affiche ce que le serveur a VRAIMENT renvoyé

// Imposer un délai maximum
const r3 = await fetch(url, { signal: AbortSignal.timeout(5000) });
```

L'astuce `await r.text()` mérite d'être retenue : quand `r.json()` plante avec `Unexpected token <`, remplace-le temporairement par `r.text()` et affiche le résultat. Tu verras la page HTML d'erreur que le serveur t'a réellement envoyée, et tu sauras immédiatement ce qui se passe.

### Parallèle ou séquentiel : la décision qui compte

```js
// ❌ SÉQUENTIEL inutile : 3 × 300 ms = 900 ms
const a = await fetch(u1);
const b = await fetch(u2);
const c = await fetch(u3);

// ✅ PARALLÈLE : ~300 ms
const [a, b, c] = await Promise.all([fetch(u1), fetch(u2), fetch(u3)]);

// ✅ SÉQUENTIEL justifié : la 2e requête a besoin du résultat de la 1re
const utilisateur = await (await fetch(`/users/${id}`)).json();
const repos = await (await fetch(utilisateur.repos_url)).json();
```

La règle : **`await` d'affilée seulement quand il y a une dépendance de données.** Sinon, `Promise.all`.

### `await` dans une boucle

```js
// Séquentiel (chaque tour attend le précédent) — parfois voulu : respecter une limite de débit, garantir l'ordre
for (const id of ids) {
  const d = await charger(id);
  console.log(d);
}

// ⚠️ PIÈGE : forEach n'attend pas les callbacks async
ids.forEach(async id => { await charger(id); });     // ❌ se termine immédiatement
console.log("fini");                                  // s'affiche AVANT les données

// Parallèle, la bonne version
const resultats = await Promise.all(ids.map(id => charger(id)));
```

**`forEach` + `async` est l'un des bugs asynchrones les plus fréquents du métier.** La raison est simple : `forEach` **ignore** la valeur retournée par son callback, donc il ignore la promesse. Il lance les trois appels et rend la main immédiatement. Avec `for...of`, `await` fonctionne comme attendu ; avec `map` + `Promise.all`, tu obtiens le parallélisme.

### Node : lire et écrire des fichiers

```js
import { readFile, writeFile } from "node:fs/promises";     // ⭐ la version promesses

async function charger(chemin) {
  try {
    return JSON.parse(await readFile(chemin, "utf8"));
  } catch (e) {
    if (e.code === "ENOENT") return [];
    throw e;
  }
}

await writeFile(chemin, JSON.stringify(donnees, null, 2), "utf8");
```

Pour utiliser `import`, ton `package.json` doit contenir `"type": "module"` ; sinon, c'est `require`. Ces deux mondes (ESM et CommonJS) cohabitent dans l'écosystème Node et c'est une source de confusion classique — retiens simplement qu'ils existent, tu les démêleras au palier 4.

---

## Les problèmes que tu vas rencontrer

**Ton code affiche `Promise { <pending> }`.** Tu as oublié un `await`, ou tu as appelé une fonction `async` sans l'attendre.

**Ton `await` est refusé avec une erreur de syntaxe.** Tu l'utilises hors d'une fonction `async` (et hors d'un module ES).

**Tu affiches des données d'erreur comme si elles étaient valides.** `r.ok` non vérifié.

**`Unexpected token < in JSON`.** Le serveur a renvoyé du HTML. Remplace `r.json()` par `r.text()` pour voir ce que c'est — en général une page d'erreur, une redirection vers une page de connexion, ou une mauvaise URL.

**Ton `forEach` se termine avant les données.** Le piège expliqué ci-dessus.

**Ton `try/catch` n'attrape pas l'erreur.** Soit l'erreur survient dans une promesse que tu n'attends pas (pas de `await`), soit tu as mis le `await` hors du `try`.

**Ton POST arrive vide côté serveur.** Trois causes : pas de `Content-Type: application/json`, un objet passé au lieu de `JSON.stringify(...)`, ou un serveur sans middleware de lecture du corps (palier 4).

**Ton application reste bloquée sur « chargement… ».** Tu n'as pas traité le cas d'échec : une promesse rejetée laisse ton indicateur de chargement allumé pour toujours. D'où le `finally`.

---

## Ce qu'on te demandera

En **entretien**, les questions les plus fréquentes : « explique `async/await` avec tes propres mots », « que retourne une fonction `async` ? », « `fetch` rejette-t-il sur un 404 ? » (la bonne réponse élimine beaucoup de candidats), « quand utiliserais-tu `Promise.all` ? », « pourquoi `forEach` avec `async` ne marche-t-il pas ? ».

L'épreuve orale de ton palier te demande d'expliquer `async/await` **avec tes propres mots**, sans réciter : c'est exactement ce qu'on attend en entretien.

En **test technique**, consommer une API en gérant chargement, erreur et cas vide est l'exercice standard du frontend junior. Et on regardera si tu as traité l'échec — la plupart des candidats ne le font pas.

En **travail réel**, on attendra que tu saches dire ce que voit l'utilisateur quand le serveur est en panne.

---

## Ce qui te démarquera

**Vérifier `r.ok` systématiquement.** C'est un marqueur immédiat : celui qui le fait a déjà été mordu, donc a de l'expérience.

**Traiter les quatre états.** Chargement, erreur (avec un bouton pour réessayer), vide, données. C'est l'exigence qu'on t'imposera au palier 9, et l'avoir dès le palier 1 est très en avance.

**Mesurer plutôt qu'affirmer.** « J'ai chronométré : en série 900 ms, en parallèle 310 ms » vaut mieux que « c'est plus rapide en parallèle ».

**Savoir écrire une nouvelle tentative avec attente croissante.** Tu le fais en exercice ici, et c'est un mécanisme qu'on retrouve dans tous les clients HTTP professionnels et dans les files de tâches du palier 7.

**Penser au cache.** « Ces données changent une fois par jour, inutile de les redemander à chaque affichage » est un raisonnement que tu peux déjà avoir, et il prépare le palier 7.

---

## 📚 À lire

**javascript.info chapitre 11.8 (*Async/await*)**, puis **relis 11.3** sur le chaînage : tu verras la correspondance exacte entre les deux écritures, et c'est ce qui consolide la compréhension.

**MDN → *Using the Fetch API*** et la page **`Response`**. Lis la section sur `ok` : c'est le piège du jour.

**MDN → *Asynchronous JavaScript***, en révision de l'ensemble.

Pour pratiquer, des API publiques gratuites et sans clé : **PokéAPI** (pokeapi.co), **Open-Meteo** (open-meteo.com), **REST Countries**, **JSONPlaceholder**, **httpbin.org**.

---

## 🤖 Le mini-projet à demander à l'IA

C'est la leçon où un vrai petit projet a le plus de valeur, parce qu'il prépare directement ton projet 2.

> « Je suis en formation de développeur, palier 1 (JavaScript, Node). Je viens d'apprendre `async/await` et `fetch`. Donne-moi le **brief d'un petit projet en ligne de commande**, sans aucun code : un script qui interroge l'API Open-Meteo (gratuite, sans clé) pour une ville passée en argument, affiche la température actuelle et les trois prochains jours, met les réponses en cache dans un fichier pour ne pas rappeler l'API deux fois dans l'heure, et **gère tous les cas d'échec**. Donne-moi : les spécifications, la liste **exhaustive** des cas d'erreur à traiter, et les critères qui feront que c'est "fini". Ensuite, quand je te montrerai mon code, critique-le uniquement sur : la gestion des erreurs, la parallélisation, et ce qui s'affiche quand ça rate. »

Ce projet te sert deux fois : c'est l'entraînement de cette leçon, et c'est la version en ligne de commande de ton **projet 2** (l'application météo du palier 2). Tu auras déjà réglé la partie données quand tu attaqueras l'interface.

Et pour le piège le plus coûteux :

> « Donne-moi 6 situations réelles où `fetch` se comporte autrement qu'un débutant ne s'y attend (404, 500, réponse HTML au lieu de JSON, réseau coupé, CORS, redirection). Pour chacune, demande-moi : que vaut `r.ok` ? que lève `fetch` ? qu'est-ce qui s'affiche à l'utilisateur si je n'ai rien prévu ? Corrige mes réponses. »

---

## 🛠️ À faire

1. Réécris en `async/await` tous les exercices de la leçon 09 que tu avais faits en `.then`. Compare la lisibilité.
2. Écris `recupererPokemon(nom)` qui retourne `{ nom, poids, types }`. Gère : nom inexistant (404) et absence de réseau. **Vérifie `r.ok`.**
3. **Mesure** : récupère cinq Pokémon en séquentiel puis avec `Promise.all`, chronomètre, note l'écart dans ton journal.
4. **Reproduis le piège `forEach`** : affiche cinq noms avec `forEach(async …)` puis `console.log("fini")`. Constate que `"fini"` s'affiche avant. Corrige de deux façons (`for...of` et `Promise.all`).
5. **Météo réelle** (préparation directe du projet 2) : avec Open-Meteo, affiche la température actuelle de Douala, puis les trois jours à venir.
   ```
   https://api.open-meteo.com/v1/forecast?latitude=4.05&longitude=9.70&current=temperature_2m
   &daily=temperature_2m_max&timezone=auto
   ```
6. Écris `recupererAvecReessais(url, essais = 3)` : réessaie en cas d'échec, avec une attente qui double à chaque fois (1 s, 2 s, 4 s).
7. **Cache** : écris `recupererAvecCache(url)` qui mémorise les réponses dans une `Map` (closure, leçon 05) et ne refait pas un appel déjà fait. Vérifie avec `console.time`.
8. **Débogue un `r.json()` qui plante** : appelle volontairement une URL qui renvoie du HTML (par exemple la page d'accueil de GitHub), constate l'erreur, puis utilise `r.text()` pour comprendre.
9. **Projet 1** : implémente la persistance du gestionnaire de dépenses avec `node:fs/promises` — chargement au démarrage, sauvegarde après chaque modification, gestion du fichier absent et du JSON corrompu.
10. Prédis la sortie :
    ```js
    async function f() { console.log("2"); return "3"; }
    console.log("1");
    f().then(v => console.log(v));
    console.log("4");
    ```

<details>
<summary>Corrections</summary>

**2.**
```js
async function recupererPokemon(nom) {
  const r = await fetch(`https://pokeapi.co/api/v2/pokemon/${nom.toLowerCase()}`);
  if (r.status === 404) throw new Error(`Pokémon « ${nom} » introuvable`);
  if (!r.ok) throw new Error(`Erreur HTTP ${r.status}`);
  const d = await r.json();
  return { nom: d.name, poids: d.weight, types: d.types.map(t => t.type.name) };
}

try {
  console.log(await recupererPokemon("pikachu"));
} catch (e) {
  console.error(e.message);          // réseau (TypeError) ou applicatif (notre Error)
}
```
Note qu'on traite le 404 **séparément** : c'est une erreur attendue (l'utilisateur s'est trompé), qui mérite un message clair, pas la même chose qu'un 500.

**4.**
```js
// ❌ le piège
noms.forEach(async n => console.log((await recupererPokemon(n)).nom));
console.log("fini");                     // s'affiche EN PREMIER

// ✅ séquentiel, ordre garanti
for (const n of noms) console.log((await recupererPokemon(n)).nom);

// ✅ parallèle, ordre du tableau préservé par Promise.all
const pokemons = await Promise.all(noms.map(recupererPokemon));
pokemons.forEach(p => console.log(p.nom));
```
Un détail qui surprend souvent : `Promise.all` **préserve l'ordre du tableau** dans ses résultats, même si les réponses arrivent dans un ordre différent.

**6.**
```js
const attendre = ms => new Promise(r => setTimeout(r, ms));

async function recupererAvecReessais(url, essais = 3, delai = 1000) {
  for (let i = 1; i <= essais; i++) {
    try {
      const r = await fetch(url);
      if (!r.ok) throw new Error(`HTTP ${r.status}`);
      return await r.json();
    } catch (e) {
      if (i === essais) throw e;                       // dernier essai : on propage
      console.warn(`Essai ${i} échoué (${e.message}), nouvelle tentative dans ${delai}ms`);
      await attendre(delai);
      delai *= 2;                                       // attente exponentielle
    }
  }
}
```
Tu viens d'écrire un mécanisme présent dans tous les clients HTTP professionnels. Une nuance de métier : on ne réessaie **pas** une erreur 4xx (la requête est fautive, la rejouer ne changera rien) — seulement les erreurs réseau et les 5xx. Améliore ta version dans ce sens.

**7.**
```js
const recupererAvecCache = (() => {
  const cache = new Map();                              // vit dans la closure
  return async url => {
    if (cache.has(url)) return cache.get(url);
    const r = await fetch(url);
    if (!r.ok) throw new Error(`HTTP ${r.status}`);
    const donnees = await r.json();
    cache.set(url, donnees);
    return donnees;
  };
})();
```
Le second appel est instantané. C'est le concept du **cache**, que tu retrouveras côté HTTP (palier 2), applicatif (palier 4) et architecture (palier 7). Et tu peux déjà en voir la difficulté : à quel moment ce cache devient-il faux ? C'est le vrai problème du cache — l'invalidation.

**10.** `1`, `2`, `4`, `3`. L'appel `f()` exécute son corps **de façon synchrone** jusqu'au premier `await` (ici il n'y en a aucun), donc `2` s'affiche immédiatement. Le `.then` est une microtâche : elle attend que tout le code synchrone soit fini, donc après `4`. **`async` ne rend pas l'exécution différée ; seul `await` suspend.** C'est une subtilité qui revient en entretien.
</details>

---

## ✅ Acquis si…

- [ ] J'explique `async/await` **avec mes propres mots** (test : l'expliquer au référent).
- [ ] Je sais qu'une fonction `async` retourne toujours une promesse.
- [ ] Je vérifie `r.ok` après chaque `fetch`, et je sais pourquoi `fetch` ne rejette pas sur un 404.
- [ ] Je choisis entre séquentiel et `Promise.all` selon la dépendance des données, et j'ai **mesuré** l'écart.
- [ ] Je connais le piège `forEach` + `async` et ses deux corrections.
- [ ] Je sais utiliser `r.text()` pour déboguer un `r.json()` qui plante.
- [ ] J'ai consommé une vraie API et traité : succès, 404, réseau coupé, réponse inattendue.
- [ ] La persistance du projet 1 fonctionne en asynchrone, cas limites gérés.

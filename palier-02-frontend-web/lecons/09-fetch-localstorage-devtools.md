# Leçon 09 — `fetch` dans le navigateur, `localStorage`, DevTools

> 🎯 **À la fin de cette leçon** : tu affiches des données venues d'une API dans une page, en traitant tous les états — et les outils de développement sont devenus ton instrument de travail.
> ⏱️ 4 h · **Prérequis** : leçons 07–08, et les leçons 09–10 du palier 1 (l'asynchrone).
>
> **Dernière leçon du palier. Après elle, tu as tout ce qu'il faut pour le [projet 2](../projet.md).**

---

## De quoi on parle

`fetch` est l'API du navigateur pour faire des requêtes HTTP. Tu l'as apprise au palier 1 en Node ; c'est **exactement la même** ici, et c'est l'un des bénéfices d'avoir appris l'asynchrone avant le navigateur.

`localStorage` est un espace de stockage clé/valeur persistant **dans le navigateur de l'utilisateur**. Quelques mégaoctets, uniquement des chaînes, conservés entre les sessions.

Les **DevTools** (`F12`) sont la boîte à outils intégrée au navigateur : inspecter le DOM et le CSS, lire la console, observer le réseau, examiner le stockage, déboguer pas à pas, mesurer les performances, simuler un téléphone ou une connexion lente.

Et le mot qui structure la leçon : les **états d'affichage**. Une donnée distante n'est pas « là ou pas là » — elle est en cours de chargement, ou en erreur, ou vide, ou présente. Quatre états, et chacun doit avoir son affichage.

---

## À quoi ça sert, concrètement

**Parce qu'une page sans données distantes n'est qu'un document.** Tout ce qui rend une application utile vient d'ailleurs : la météo, les produits, les messages, le solde. `fetch` est le seul chemin.

**Parce que les quatre états sont ce qui distingue une interface professionnelle.** Un débutant écrit le cas où tout fonctionne. Un professionnel écrit les quatre, parce que les trois autres sont **la réalité** : réseau lent, serveur en panne, première utilisation sans données. Une page qui reste blanche pendant trois secondes puis affiche une erreur dans la console n'est pas « presque finie » — elle est inutilisable.

**Parce que `localStorage` permet de retenir sans serveur.** Un thème choisi, une ville favorite, un brouillon en cours : au palier 2 tu n'as pas de backend, et c'est ce qui rend ton application personnelle plutôt que générique.

**Et parce que les DevTools sont l'outil que tu utiliseras le plus.** Plus que ton éditeur, probablement. Les maîtriser maintenant change la vitesse à laquelle tu progresses sur tout le reste du parcours.

---

## Où ça intervient dans le développement

Cette leçon te place exactement à la frontière réseau, du côté client :

```
   TON PAGE (navigateur)                        API (ailleurs)
   ─────────────────────                        ──────────────
   fetch  ──────── requête HTTP ───────────────▶
          ◀─────── JSON + code de statut ───────
      │
      ├── état de CHARGEMENT  pendant l'attente
      ├── état d'ERREUR       si ça rate
      ├── état VIDE           si la réponse ne contient rien
      └── état DONNÉES        le cas heureux
      │
      ▼
   localStorage  ← ce qui doit survivre au rechargement, sur CET appareil
```

Trois points structurants pour la suite.

**La contrainte des clés d'API.** Tout ce que tu envoies au navigateur est public (palier 0, leçon 08) : une clé dans ton JavaScript est une clé publiée. C'est pour cette raison que le projet 2 utilise **Open-Meteo**, qui n'en demande pas. Et c'est l'une des raisons d'être du palier 4 : dès que tu auras un backend, c'est lui qui détiendra les clés et relaiera les appels.

**CORS va te mordre.** Le navigateur bloque les requêtes vers une autre origine si le serveur ne l'autorise pas explicitement. Tu l'as vu en théorie au palier 0 ; tu vas le vivre ici. Et le point important est qu'il n'y a **rien à corriger côté client** : la solution est côté serveur, et tu la mettras en place au palier 4.

**`localStorage` a des limites qu'il faut connaître maintenant** pour comprendre pourquoi le palier 4 existe : un seul navigateur, un seul appareil, pas de partage, effaçable, et synchrone (donc bloquant — leçon 11 du palier 1). C'est parfait pour une préférence, inadapté pour des données qui comptent.

Et au **palier 3**, TanStack Query fera tout ça pour toi : chargement, erreurs, cache, nouvelles tentatives, rechargement en arrière-plan. Tu l'apprécieras d'autant plus que tu auras écrit les quatre états à la main ici.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas passer beaucoup de temps dans l'onglet **Réseau**, et c'est le réflexe à prendre : devant un problème de données, on regarde si la requête est partie, où elle est allée, ce qu'elle a répondu. La réponse est presque toujours là.

Tu vas aussi rencontrer les trois classiques : une clé d'API visible dans ton code, une erreur CORS incompréhensible, et un `r.json()` qui plante parce que le serveur a renvoyé du HTML.

### En équipe, en entreprise

**Les quatre états sont un critère de revue.** « Qu'est-ce qui s'affiche pendant le chargement ? Et si l'API tombe ? » sont les deux premières questions d'un relecteur sur une page qui consomme des données.

**On n'écrit plus `fetch` à la main très longtemps.** Les équipes utilisent une bibliothèque (axios) ou un gestionnaire d'état serveur (TanStack Query). Mais la connaissance de `fetch` reste nécessaire : c'est ce qu'il y a dessous, et c'est ce que tu dois savoir déboguer.

**Le stockage navigateur est encadré.** `localStorage` pour les préférences ; pour un jeton d'authentification, les équipes préfèrent un cookie `httpOnly` (palier 4), précisément parce que `localStorage` est lisible par n'importe quel script injecté — c'est le lien direct avec la XSS de la leçon 07.

**Et les DevTools sont un savoir-faire implicite.** Personne ne te les enseignera, et on suppose que tu sais t'en servir.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `fetch` avec `await`, la vérification de `r.ok`, `try/catch/finally`, les quatre états, `localStorage.getItem`/`setItem` avec `JSON.parse`/`stringify`, et les onglets Console, Réseau et Éléments.

Régulièrement : `AbortSignal.timeout()`, le mode hors ligne et le bridage de débit dans l'onglet Réseau, l'onglet Application pour inspecter le stockage, les points d'arrêt dans l'onglet Sources, le mode responsive.

Rare, et hors sujet pour l'instant : `sessionStorage` (même API, effacé à la fermeture de l'onglet), IndexedDB (pour de gros volumes structurés — tu le croiseras au palier 9 pour le hors-ligne), les *service workers* et les applications web installables, l'API Cache, `navigator.onLine`, les WebSockets, `EventSource`. Et l'onglet Performance : tu l'as effleuré à la leçon 06, tu y reviendras au palier 8.

---

## La mécanique

### `fetch` avec les quatre états

```js
// api.js — ne fait QUE parler au réseau
export async function recupererMeteo(latitude, longitude) {
  const url = `https://api.open-meteo.com/v1/forecast`
            + `?latitude=${latitude}&longitude=${longitude}&current=temperature_2m`;

  const reponse = await fetch(url, { signal: AbortSignal.timeout(8000) });
  if (!reponse.ok) throw new Error(`Le service météo a répondu ${reponse.status}`);
  return reponse.json();
}
```

```js
// app.js — orchestre les états
const etat = { statut: "vide", donnees: null, erreur: null };

async function chargerMeteo(ville) {
  etat.statut = "chargement";
  rendre();                                   // ⭐ on affiche le chargement AVANT d'attendre

  try {
    etat.donnees = await recupererMeteo(ville.lat, ville.lon);
    etat.statut = "donnees";
  } catch (e) {
    etat.erreur = messageUtilisateur(e);      // un message pour l'humain
    etat.statut = "erreur";
    console.error(e);                          // la trace technique pour toi
  } finally {
    rendre();                                  // dans TOUS les cas
  }
}

function messageUtilisateur(e) {
  if (e.name === "TimeoutError") return "Le service met trop de temps à répondre.";
  if (e instanceof TypeError)     return "Pas de connexion. Vérifie ton réseau.";
  return e.message;
}
```

```js
// ui.js — ne fait QUE de l'affichage
export function rendreMeteo(etat, conteneur) {
  conteneur.textContent = "";
  switch (etat.statut) {
    case "chargement": conteneur.append(creerChargement()); break;
    case "erreur":     conteneur.append(creerErreur(etat.erreur, "Réessayer")); break;
    case "vide":       conteneur.append(creerMessage("Choisis une ville.")); break;
    case "donnees":    conteneur.append(creerCarte(etat.donnees)); break;
  }
}
```

Observe la structure : **un champ `statut`, un `switch`, quatre affichages**. C'est plus simple que trois booléens (`enChargement`, `aErreur`, `estVide`) qui peuvent entrer en combinaisons impossibles. Et c'est exactement l'« union discriminée » que tu formaliseras en TypeScript au palier 3 — tu en construis l'intuition ici.

Deux détails qui comptent. Le `rendre()` **avant** l'attente : sinon l'utilisateur ne voit rien pendant deux secondes. Et le message d'erreur **pour l'humain**, distinct de la trace pour le développeur : « Pas de connexion » et non `TypeError: Failed to fetch`.

### Les deux pièges de `fetch`, rappelés

**`fetch` ne rejette pas sur un 404 ni sur un 500.** Il ne rejette que si la requête n'aboutit pas. Donc `if (!r.ok) throw …` est obligatoire — sinon tu affiches des données d'erreur comme si elles étaient valides.

**`r.json()` plante si le corps n'est pas du JSON.** Le message `Unexpected token <` signifie que tu as reçu du HTML : une page d'erreur, une redirection vers une page de connexion, ou une mauvaise URL. Le réflexe de diagnostic est de remplacer temporairement `r.json()` par `r.text()` et d'afficher le résultat.

### CORS, vu du client

```
Access to fetch at 'https://api.exemple.com/data' from origin 'http://localhost:3000'
has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present.
```

Ce que ça dit : le navigateur a bien envoyé la requête, le serveur a bien répondu, mais il n'a pas déclaré autoriser ton origine, donc le navigateur **refuse de te donner la réponse**. C'est une protection, pas un bug.

Ce qu'il faut comprendre, et qui évite des heures perdues : **tu ne peux rien corriger dans ton code client**. Ni un en-tête à ajouter, ni une option de `fetch`. Les seules vraies solutions sont côté serveur (autoriser ton origine — palier 4), ou passer par un intermédiaire que tu contrôles. Et pour vérifier que l'API fonctionne malgré tout : `curl` n'applique pas CORS, donc une requête qui marche en `curl` et échoue dans le navigateur est, à coup sûr, un problème de CORS.

### `localStorage`

```js
// Écrire — uniquement des CHAÎNES
localStorage.setItem("theme", "sombre");
localStorage.setItem("villes", JSON.stringify(villes));   // un objet doit être sérialisé

// Lire
const theme = localStorage.getItem("theme");              // null si absent
const villes = JSON.parse(localStorage.getItem("villes") ?? "[]");

localStorage.removeItem("theme");
```

Et la version robuste, parce que `localStorage` peut échouer — navigation privée, quota dépassé, stockage désactivé :

```js
export function lire(cle, valeurParDefaut) {
  try {
    const brut = localStorage.getItem(cle);
    return brut === null ? valeurParDefaut : JSON.parse(brut);
  } catch {
    return valeurParDefaut;        // données corrompues ou accès refusé
  }
}

export function ecrire(cle, valeur) {
  try {
    localStorage.setItem(cle, JSON.stringify(valeur));
  } catch (e) {
    console.warn("Stockage indisponible :", e.message);   // on continue sans planter
  }
}
```

Ce `try/catch` n'est pas de la précaution excessive : un utilisateur en navigation privée sur certains navigateurs provoque une exception au premier `setItem`, et une application qui plante là est une application qui plante pour de vrai.

### Les DevTools, onglet par onglet

**Éléments** — le DOM tel qu'il est maintenant, et les règles CSS appliquées (avec les barrées, leçon 03). Tu peux modifier en direct pour tester.

**Console** — les erreurs et tes `console.log`. Tu peux y taper du JavaScript dans le contexte de la page : `document.querySelectorAll(".carte").length` est une vérification instantanée.

**Réseau** — **l'onglet le plus important de cette leçon**. Chaque requête, son URL exacte, sa méthode, son code de statut, ses en-têtes, sa réponse, sa durée. Deux outils dedans changent tout : le filtre **Fetch/XHR** (pour ne voir que tes appels) et la liste déroulante de **bridage** (*throttling*), qui simule une 3G lente ou le mode hors ligne.

**Application** — le contenu de `localStorage`, des cookies, du cache. Tu y lis et effaces tes propres données.

**Sources** — les points d'arrêt (palier 1, leçon 08), désormais dans le navigateur.

**Lighthouse** — un audit automatique : performance, accessibilité, bonnes pratiques. À lancer sur tes trois intégrations imposées.

Et le **mode responsive** (`Ctrl+Shift+M`), que tu utilises depuis la leçon 05.

### Tester la réalité, pas le cas heureux

C'est l'habitude la plus utile de la leçon :

| Pour tester | Dans les DevTools |
|---|---|
| Un réseau lent | Réseau → bridage → *Slow 3G* |
| Une panne réseau | Réseau → bridage → *Offline* |
| Une erreur serveur | change l'URL pour une qui n'existe pas |
| Une réponse vide | demande une ville inconnue |
| Un stockage indisponible | Application → effacer le stockage, ou navigation privée |

Lance ta page en *Slow 3G* une fois : tu verras ton indicateur de chargement pour de vrai, et tu comprendras pourquoi il est indispensable.

---

## Les problèmes que tu vas rencontrer

**Ma page reste blanche et il n'y a rien dans la console.** Tu n'as pas d'état de chargement ni d'erreur affichée. C'est le symptôme du « cas heureux seulement ».

**`Failed to fetch`.** Message générique : pas de réseau, URL fausse, serveur injoignable, ou CORS. L'onglet Réseau distingue les quatre en deux secondes.

**Une erreur CORS.** Côté serveur. Vérifie avec `curl` que l'API répond bien.

**`Unexpected token < in JSON`.** Tu as reçu du HTML. `r.text()` pour voir quoi.

**J'affiche des données d'erreur comme si elles étaient bonnes.** `r.ok` non vérifié.

**Mon indicateur de chargement ne s'arrête jamais.** Il manque le `finally`.

**Ma clé d'API est visible.** Elle l'est nécessairement. Utilise une API sans clé, ou une clé restreinte par domaine, ou attends le palier 4.

**`localStorage` me rend `"[object Object]"`.** Tu as stocké un objet sans `JSON.stringify`.

**`JSON.parse` plante au chargement.** Données corrompues en stockage (un format changé entre deux versions de ton code). D'où le `try/catch`.

**Ça marche chez moi et pas chez un autre.** Des données en `localStorage` que l'autre n'a pas. C'est la limite fondamentale : `localStorage` est **par navigateur et par appareil**.

**Mon application est très lente au démarrage.** Tu lis beaucoup de `localStorage` de façon synchrone : ça bloque le fil principal (palier 1, leçon 11).

---

## Ce qu'on te demandera

En **test technique frontend**, « consomme cette API et affiche les résultats » est l'exercice le plus courant, et **les quatre états sont la grille de notation**. On coupera le réseau pour voir ce qui se passe. C'est l'épreuve A4 de ton évaluation de palier.

En **entretien** : « `fetch` rejette-t-il sur un 404 ? » (la question qui élimine), « qu'est-ce que CORS et de quel côté se corrige-t-il ? », « quelles sont les limites de `localStorage` ? », « où stockerais-tu un jeton d'authentification ? » (et la bonne réponse mentionne le cookie `httpOnly`), « comment déboguerais-tu une requête qui échoue ? ».

En **travail réel**, on attendra que tu saches lire l'onglet Réseau avant de poser une question, et que tu testes en mode hors ligne avant de dire que c'est fini.

---

## Ce qui te démarquera

**Les quatre états, systématiquement.** C'est le marqueur le plus visible d'un frontend sérieux, et l'immense majorité des juniors n'en traite qu'un.

**Tester en *Slow 3G* et hors ligne.** Trente secondes, et ça change la qualité de ce que tu livres. Dans un contexte où la connectivité est variable, c'est un argument professionnel direct.

**Distinguer le message utilisateur de la trace développeur.** « Pas de connexion, réessaie » pour l'humain, `console.error(e)` pour toi.

**Un bouton « Réessayer » dans l'état d'erreur.** Presque personne n'y pense, et c'est ce qui fait la différence entre une impasse et une application utilisable.

**Savoir diagnostiquer dans l'onglet Réseau.** Dire « la requête part bien, elle renvoie 403, donc c'est l'authentification » est une phrase qui situe immédiatement ton niveau.

**Savoir que `localStorage` n'est pas une base de données**, et pouvoir l'expliquer. C'est la compréhension qui justifie tout le palier 4.

---

## 📚 À lire

**MDN → *Using the Fetch API*** et la page **`Response`** (section `ok`), si tu ne les as pas relues au palier 1.

**MDN → *Cross-Origin Resource Sharing (CORS)*** : la section d'introduction suffit, et elle t'épargnera des heures de confusion.

**MDN → *Using the Web Storage API*** pour `localStorage`, avec ses limites.

**Documentation Chrome DevTools** : parcours ***Network features reference*** et ***Inspect and manage storage***. Ce sont les deux onglets de cette leçon.

**The Odin Project → JavaScript → Working with APIs** et **Async JavaScript** pour la pratique guidée.

Et pour le projet 2 : la documentation d'**Open-Meteo** (open-meteo.com/en/docs), qui est courte, gratuite et sans clé.

---

## 🤖 Le mini-projet à demander à l'IA

C'est la leçon du projet 2 : autant t'entraîner dessus.

> « Je suis en formation de développeur, palier 2 (frontend, sans framework). Je viens d'apprendre `fetch` dans le navigateur, `localStorage` et les DevTools. Donne-moi le **cahier des charges** d'une petite application météo, **sans aucun code** : recherche de ville, affichage de la météo actuelle et de trois jours, mémorisation des villes favorites, et un thème clair/sombre persistant. Impose-moi : trois fichiers (api/ui/app), **les quatre états d'affichage** traités visuellement, un bouton "Réessayer" dans l'état d'erreur, un `debounce` sur la recherche, et aucune clé d'API dans le code. Donne-moi la liste **exhaustive** des cas d'échec à gérer. Quand je t'enverrai mon code, critique uniquement : les états manquants, la séparation des responsabilités, la robustesse du stockage, et ce qui s'affiche quand le réseau est coupé. **N'écris pas le code.** »

Puis l'exercice de diagnostic, le plus proche du travail réel :

> « Décris-moi **8 pannes** d'une application qui consomme une API, **du point de vue de l'utilisateur** (page blanche, chargement infini, données qui ne se mettent pas à jour, message d'erreur technique affiché, données d'un autre utilisateur, ça marche chez moi mais pas chez le client…). Pour chacune, demande-moi : **dans quel onglet des DevTools je regarde d'abord**, ce que je m'attends à y voir, et quelles sont les trois causes les plus probables. Corrige mon raisonnement sans donner la réponse d'emblée. »

---

## 🛠️ À faire

1. **Les quatre états** : une page qui affiche la météo de Douala avec Open-Meteo, et qui traite visuellement chargement, erreur, vide et données. Structure en `switch` sur un champ `statut`.
2. **Teste chaque état pour de vrai** : bride en *Slow 3G* pour voir le chargement, passe en *Offline* pour l'erreur, mets une mauvaise URL pour un 404, charge la page sans ville choisie pour l'état vide.
3. **Bouton « Réessayer »** dans l'état d'erreur, qui relance l'appel.
4. **Sépare en trois fichiers** : `api.js` (réseau), `ui.js` (DOM), `app.js` (orchestration). Vérifie qu'aucun `fetch` n'est dans `ui.js` et aucun `querySelector` dans `api.js`.
5. **Démontre le piège `r.ok`** : appelle une URL qui renvoie un 404, sans vérifier `r.ok`, et observe ce qui s'affiche. Puis corrige.
6. **Démontre le piège `r.json()`** : appelle une URL qui renvoie du HTML (la page d'accueil de GitHub), constate l'erreur, et diagnostique avec `r.text()`.
7. **Provoque une erreur CORS** : appelle une API qui ne l'autorise pas depuis ton `localhost`. Lis le message en entier. Vérifie ensuite avec `curl` que l'API fonctionne — tu viens de prouver que le problème est le navigateur, pas l'API.
8. **`localStorage`** : mémorise la dernière ville consultée et le thème choisi. Recharge la page et vérifie. Puis ouvre l'onglet **Application** et observe tes données.
9. **Robustesse du stockage** : écris les fonctions `lire`/`ecrire` avec `try/catch`, puis corromps volontairement une valeur dans l'onglet Application (mets `{{{` ) et vérifie que ton application ne plante pas.
10. **Timeout** : ajoute `AbortSignal.timeout(5000)` et teste-le en bridant très fortement le réseau.
11. **Lighthouse** : lance un audit complet sur ta page. Corrige jusqu'à 90 en Performance et 100 en Accessibilité.
12. **Teste sur ton téléphone**, sur le même réseau Wi-Fi, en 4G puis en coupant les données.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** La structure attendue est celle de la mécanique : **un** champ `statut` prenant une valeur parmi quatre, et un `switch` dans la fonction de rendu. Si tu as utilisé trois booléens, tu peux atteindre des états incohérents (`enChargement` et `aErreur` tous deux à `true`) — c'est exactement le problème que l'union discriminée supprime, et tu la retrouveras en TypeScript au palier 3.

**2.** En *Slow 3G*, ton indicateur de chargement s'affiche pendant plusieurs secondes : c'est la première fois que tu le vois réellement, et c'est ce qui prouve son utilité. En *Offline*, `fetch` rejette avec une `TypeError` — d'où la distinction dans `messageUtilisateur`.

**5.** Sans `r.ok`, `r.json()` réussit (la réponse d'erreur est souvent du JSON valide) et tu affiches `undefined` partout, ou tu plantes sur un champ absent — sans jamais savoir que le serveur avait répondu 404. **C'est pour ça que la vérification est obligatoire.**

**7.** Le message indique que l'en-tête `Access-Control-Allow-Origin` est absent. La requête **est partie** et le serveur **a répondu** — tu peux le voir dans l'onglet Réseau — mais le navigateur refuse de livrer la réponse à ton code. Le même appel en `curl` réussit, parce que `curl` n'applique pas la politique d'origine. Conclusion à écrire dans ton journal : **CORS est une protection du navigateur, et elle se règle côté serveur.**

**9.** Avec `JSON.parse` sans protection, une valeur corrompue lève une exception au chargement et ton application ne démarre pas du tout — c'est le pire moment pour une erreur. Le `try/catch` la fait retomber sur la valeur par défaut. Ce cas se produit réellement : il suffit que tu changes le format de tes données entre deux versions de ton code, et tous tes utilisateurs ont du stockage « corrompu ».

**12.** Les différences habituelles avec le simulateur : la latence réelle (bien plus visible), la barre d'adresse qui réduit la hauteur, le clavier virtuel, et le comportement quand les données sont coupées en pleine requête. C'est ce test qui valide vraiment tes quatre états.
</details>

---

## ✅ Acquis si…

- [ ] Je traite les **quatre états** (chargement, erreur, vide, données) dans une page qui consomme une API.
- [ ] J'ai testé chaque état pour de vrai avec le bridage réseau des DevTools.
- [ ] Mon état d'erreur propose un bouton « Réessayer ».
- [ ] Je vérifie `r.ok` après chaque `fetch`, et je sais ce qui arrive sans.
- [ ] Je sais diagnostiquer un `r.json()` qui plante avec `r.text()`.
- [ ] J'explique CORS et je sais que ça se corrige côté serveur.
- [ ] Je distingue le message destiné à l'utilisateur de la trace destinée au développeur.
- [ ] Mon code est séparé en api / ui / app, sans mélange.
- [ ] J'utilise `localStorage` avec `JSON` **et** un `try/catch`, et je connais ses limites.
- [ ] Je me sers des onglets Éléments, Console, Réseau et Application sans hésiter.
- [ ] 🚦 **Je suis prêt pour le [projet 2](../projet.md) et l'[épreuve de sortie](../evaluation.md).**

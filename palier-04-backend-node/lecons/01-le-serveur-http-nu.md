# Leçon 01 — Le serveur HTTP nu : comprendre avant le framework

> 🎯 **À la fin de cette leçon** : tu as écrit un serveur HTTP sans aucune bibliothèque, et tu peux nommer précisément ce qu'un framework apporte — parce que tu l'auras construit à la main.
> ⏱️ 4 h · **Prérequis** : [épreuve du palier 3](../../palier-03-react-typescript/evaluation.md) réussie, et la leçon 07 du palier 0 (HTTP).

---

## De quoi on parle

Un **serveur HTTP** est un programme qui écoute sur un port, reçoit des requêtes et renvoie des réponses. Node.js en fournit un dans sa bibliothèque standard, avec le module `node:http`.

```js
import { createServer } from "node:http";

const serveur = createServer((requete, reponse) => {
  reponse.writeHead(200, { "Content-Type": "application/json" });
  reponse.end(JSON.stringify({ message: "bonjour" }));
});

serveur.listen(3000);
```

C'est tout. Quinze lignes, aucune dépendance, et tu as un serveur web.

Deux objets structurent le travail. La **requête** (`req`) est un flux lisible qui porte l'URL, la méthode, les en-têtes et le corps. La **réponse** (`res`) est un flux inscriptible sur lequel tu écris le code de statut, les en-têtes puis le contenu.

Et deux notions que tu vas devoir construire toi-même : le **routage** (associer une URL et une méthode à du code) et le **parsing du corps** (reconstituer les données envoyées).

---

## À quoi ça sert, concrètement

**Parce que c'est le seul moyen de savoir ce qu'un framework fait.** Tu vas utiliser Express à la leçon 02, Flask au palier 5, Laravel au palier 6. Si tu ne commences pas par le serveur nu, ces outils resteront des boîtes noires dont tu apprendras les incantations. Après cette leçon, tu sauras que `app.get("/users/:id")` est une table de correspondance et une expression régulière, et que `req.body` est un flux qu'on a assemblé pour toi.

**Parce que tu vas refaire exactement cet exercice deux fois.** Au palier 5 avec WSGI en Python, au palier 6 avec PHP et `.htaccess`. **Même leçon, trois langages** — et c'est ce qui te permettra, au palier 7, de comparer les trois écosystèmes au lieu de réciter des arguments lus sur internet.

**Parce que ça démystifie définitivement le backend.** Un débutant croit qu'un serveur est une chose compliquée et magique. C'est une fonction qui reçoit du texte et renvoie du texte. Le reste est de l'organisation.

**Et parce que le constat que tu vas faire est le vrai contenu de la leçon** : « gérer les routes, le corps, les erreurs et les en-têtes à la main, c'est pénible ». Ce n'est pas un échec de l'exercice, c'est son objectif. Cette pénibilité **est** la valeur d'un framework, et tu pourras désormais la chiffrer.

---

## Où ça intervient dans le développement

Tu changes de côté de la frontière. Jusqu'ici tu étais le client ; tu deviens le serveur.

```
   CLIENT (paliers 2-3)                     SERVEUR (ce palier)
   ────────────────────                     ───────────────────
   fetch("/api/depenses")  ─── HTTP ───▶   écoute sur un port
                                            lit la méthode et l'URL
                                            route vers du code
                                            lit le corps
                           ◀──────────      écrit statut + en-têtes + corps
```

Et voici la place exacte de cette leçon dans la pile que tu vas construire :

```
   ton code métier
        ▲
   le FRAMEWORK (Express)        ← leçon 02 : il automatise ce qui suit
        ▲
   node:http                     ← CETTE LEÇON : routage, corps, en-têtes, erreurs
        ▲
   TCP / le système d'exploitation
```

Trois choses à savoir dès maintenant, parce qu'elles reviendront.

**Un serveur est un processus qui tourne en permanence.** C'est la grande différence avec ce que tu as fait jusqu'ici : ton code n'est plus exécuté puis terminé, il attend. Cela a des conséquences — une fuite mémoire s'accumule, une variable globale survit entre les requêtes, un plantage arrête le service pour tout le monde. C'est aussi ce qui rend l'hébergement payant (palier 2, leçon 08 : statique contre dynamique).

**Tout est partagé entre les requêtes.** Avec un seul processus et un seul fil (palier 1, leçon 11), un calcul long bloque **toutes** les requêtes de tous les utilisateurs. Tu le vérifieras en exercice, et c'est le point de comparaison central avec PHP au palier 6.

**Et le corps d'une requête arrive par morceaux.** C'est la découverte la plus instructive de la leçon : il n'existe pas de `req.body`. Il faut assembler un flux. C'est pour cette raison que les frameworks ont des *middlewares* dédiés — et que ton `POST` arrivera vide si tu les oublies (palier 2, leçon 09).

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire un serveur en quinze minutes, et te sentir très puissant. Puis tu vas ajouter une deuxième route, un paramètre d'URL, un corps JSON, une gestion d'erreur — et ton fichier va atteindre deux cents lignes de plomberie pour trois fonctionnalités. C'est le parcours prévu.

Tu vas aussi découvrir `curl` et un client d'API (Bruno, Postman) comme outils de travail : sans interface, c'est par là que tu testes.

### En équipe, en entreprise

**Tu n'écriras jamais de serveur avec `node:http`.** Personne ne le fait, et c'est très bien : tout le monde utilise un framework. La connaissance acquise ici sert à **comprendre** et à **déboguer**, pas à produire.

**Mais elle sert vraiment à déboguer.** Quand une requête n'arrive pas, quand un en-tête manque, quand un corps est vide, quand une réponse est tronquée — savoir ce qui se passe réellement sous le framework fait la différence entre chercher au hasard et savoir où regarder.

**Et tu rencontreras les notions de cette leçon en production.** Les flux (pour un gros téléchargement), les en-têtes (cache, CORS, sécurité), les codes de statut, le processus qui tourne et qu'il faut relancer, le port qu'il faut configurer. Tout cela est visible au palier 8.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon, ce qui reste utile au quotidien : savoir qu'il y a un processus qui écoute un port, comprendre un code de statut et un en-tête, savoir que le corps est un flux, et savoir qu'un calcul synchrone bloque tout.

Ce que tu ne refais jamais : le routage à la main, le parsing de corps à la main, l'écriture d'en-têtes un par un.

Rare et hors sujet pour l'instant : les flux en profondeur (`pipe`, `Transform`), `cluster` et les processus de travail, HTTP/2, les WebSockets, les connexions persistantes, les *timeouts* fins du serveur, `http2` et `https` natifs (en production, c'est le reverse proxy qui s'en charge — palier 8). Tu croiseras ces sujets, mais pas à ce stade.

---

## La mécanique

### Le serveur minimal

```js
// serveur.js
import { createServer } from "node:http";

const serveur = createServer((req, res) => {
  console.log(`${req.method} ${req.url}`);              // le journal, dès le début
  res.writeHead(200, { "Content-Type": "text/plain; charset=utf-8" });
  res.end("Bonjour depuis Node\n");
});

serveur.listen(3000, () => console.log("écoute sur http://localhost:3000"));
```

```bash
node serveur.js
curl -i http://localhost:3000        # le -i affiche les en-têtes (palier 0, leçon 07)
```

### Lire l'URL et la méthode

```js
const serveur = createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);
  const chemin = url.pathname;                 // "/depenses"
  const categorie = url.searchParams.get("categorie");   // la query string

  if (req.method === "GET" && chemin === "/depenses") {
    return envoyerJson(res, 200, listerDepenses(categorie));
  }

  envoyerJson(res, 404, { erreur: "Route introuvable" });
});

function envoyerJson(res, statut, donnees) {
  res.writeHead(statut, { "Content-Type": "application/json; charset=utf-8" });
  res.end(JSON.stringify(donnees));
}
```

Remarque la fonction `envoyerJson` : tu viens d'écrire ton premier morceau de framework. Sans elle, tu répéterais les deux lignes d'en-tête à chaque réponse.

### ⭐ Lire le corps : la découverte de la leçon

```js
function lireCorps(req) {
  return new Promise((resolve, reject) => {
    let brut = "";
    req.on("data", morceau => { brut += morceau; });      // ⭐ ça arrive par MORCEAUX
    req.on("end", () => resolve(brut));
    req.on("error", reject);
  });
}

// Usage
if (req.method === "POST" && chemin === "/depenses") {
  const brut = await lireCorps(req);
  let donnees;
  try {
    donnees = JSON.parse(brut);
  } catch {
    return envoyerJson(res, 400, { erreur: "JSON invalide" });
  }
  // … et maintenant il faut VALIDER le contenu
}
```

Voilà ce que personne ne t'avait dit : **le corps d'une requête n'est pas une propriété, c'est un flux**. Les données arrivent en paquets, et il faut les accumuler. C'est logique — un envoi de fichier de 500 Mo ne peut pas être une chaîne en mémoire — mais c'est contre-intuitif quand on a toujours vu `req.body`.

Tu viens aussi de découvrir pourquoi, au palier 2, ton `POST` arrivait parfois vide côté serveur : le framework fournit un *middleware* qui fait exactement ce travail, et sans lui `req.body` est `undefined`.

Et note le `try/catch` autour de `JSON.parse` : le corps vient du client, donc il peut être n'importe quoi. C'est la frontière, encore une fois (palier 1, leçon 01).

### Un routeur maison

Avec trois routes, les `if` suffisent. Avec dix, et des paramètres d'URL, il faut une table :

```js
const routes = [
  { methode: "GET",    motif: /^\/depenses$/,            action: listerDepenses },
  { methode: "POST",   motif: /^\/depenses$/,            action: creerDepense },
  { methode: "GET",    motif: /^\/depenses\/(\d+)$/,     action: lireDepense },
  { methode: "DELETE", motif: /^\/depenses\/(\d+)$/,     action: supprimerDepense },
];

async function router(req, res) {
  const url = new URL(req.url, `http://${req.headers.host}`);

  for (const route of routes) {
    const correspondance = url.pathname.match(route.motif);
    if (correspondance && route.methode === req.method) {
      const parametres = correspondance.slice(1);         // les groupes capturés
      return route.action(req, res, parametres, url.searchParams);
    }
  }
  envoyerJson(res, 404, { erreur: "Route introuvable" });
}
```

**Tu viens d'écrire un routeur.** C'est exactement ce que fait `app.get("/depenses/:id")` : une table de motifs, une correspondance par expression régulière, et l'extraction des paramètres. Retiens cette structure : tu la réécriras en Python (palier 5, leçon 05) et en PHP (palier 6, leçon 08), et tu reconnaîtras alors les frameworks au lieu de les subir.

### Servir un fichier statique

```js
import { readFile } from "node:fs/promises";
import { extname, join } from "node:path";

const TYPES = { ".html": "text/html", ".css": "text/css", ".js": "text/javascript" };

async function servirFichier(res, chemin) {
  try {
    const sur = join("public", chemin.replace(/^\/+/, ""));   // ⚠️ voir ci-dessous
    const contenu = await readFile(sur);
    res.writeHead(200, { "Content-Type": TYPES[extname(sur)] ?? "application/octet-stream" });
    res.end(contenu);
  } catch {
    envoyerJson(res, 404, { erreur: "Fichier introuvable" });
  }
}
```

> ⚠️ **La faille de traversée de répertoire.** Si tu concatènes naïvement le chemin demandé, une requête vers `/../../etc/passwd` sort de ton dossier et lit des fichiers du système. C'est une vulnérabilité classique, et tu l'exploiteras en exercice. La parade : normaliser le chemin et vérifier qu'il reste **à l'intérieur** du dossier autorisé. C'est l'une des choses qu'un framework fait correctement pour toi.

### Gérer les erreurs

```js
const serveur = createServer(async (req, res) => {
  try {
    await router(req, res);
  } catch (e) {
    console.error(e);                                   // la trace pour toi
    if (!res.headersSent) {
      envoyerJson(res, 500, { erreur: "Erreur interne" });   // un message neutre pour le client
    }
  }
});
```

Deux détails qui comptent. Le `if (!res.headersSent)` : si la réponse a déjà commencé, tu ne peux plus changer le statut — c'est une erreur fréquente. Et le message **neutre** : on ne renvoie jamais la trace technique au client (fuite d'information ; tu verras la même règle au palier 5 avec `DEBUG = False`).

---

## Les problèmes que tu vas rencontrer

**`EADDRINUSE: address already in use`.** Un serveur tourne déjà sur ce port — souvent le tien, oublié dans un autre terminal. `lsof -i :3000` l'identifie.

**Ma requête reste en attente et finit en timeout.** Tu n'as pas appelé `res.end()` dans un cas. **Chaque chemin d'exécution doit terminer la réponse** — c'est l'erreur n°1 du serveur à la main.

**`Cannot set headers after they are sent`.** Tu as appelé `writeHead` ou `end` deux fois. Souvent un `return` manquant avant une réponse d'erreur.

**Mon `POST` arrive vide.** Tu n'as pas lu le flux. Il n'y a pas de `req.body` en Node nu.

**Mes accents sont cassés.** Il manque `charset=utf-8` dans le `Content-Type`.

**Mon serveur ne répond plus à personne.** Un calcul synchrone bloque l'event loop (palier 1, leçon 11). Avec un seul processus, c'est tout le service qui s'arrête.

**Le navigateur bloque mes appels depuis mon application React.** CORS. Tu l'as vu du côté client au palier 2 ; tu vas maintenant le corriger du côté serveur, et c'est le seul côté qui peut le faire.

**Mon serveur plante et ne redémarre pas.** Une exception non capturée arrête le processus. En développement, `node --watch serveur.js` relance automatiquement ; en production, c'est le rôle de `systemd` ou de Docker (palier 8).

---

## Ce qu'on te demandera

En **entretien**, la question qui revient est : **« qu'est-ce qu'un framework web t'apporte ? »**. Après cette leçon, tu peux répondre par une liste précise — routage, parsing du corps, en-têtes, gestion centralisée des erreurs, fichiers statiques, sécurité par défaut — au lieu de « ça simplifie les choses ». C'est exactement la question B1 de ton épreuve de sortie.

On peut aussi te demander : « comment fonctionne un serveur HTTP ? », « que se passe-t-il entre le `listen` et la réponse ? », « pourquoi un calcul long est-il un problème en Node ? ».

En **travail réel**, cette connaissance sert au débogage : savoir que le corps est un flux, qu'un en-tête ne peut plus changer après l'envoi, qu'un processus unique partage tout.

---

## Ce qui te démarquera

**Pouvoir énumérer ce qu'un framework automatise.** C'est rare chez un junior, et c'est immédiatement crédible parce que ça vient de l'expérience et pas d'un article.

**Savoir que le corps est un flux.** Cela explique une quantité de comportements, du `POST` vide aux limites de taille d'upload.

**Comprendre le modèle à un seul processus.** Et pouvoir dire « ici un calcul lourd bloquerait tout le monde, il faut le sortir de la requête » — c'est un raisonnement d'architecture que tu formaliseras au palier 7.

**Avoir vu la faille de traversée de répertoire.** L'avoir exploitée une fois sur son propre serveur vaut tous les articles de sécurité.

**Et avoir écrit un routeur.** Quand tu arriveras à Express, Flask et Laravel, tu reconnaîtras la même structure trois fois. C'est l'intention de tout le parcours : des concepts qui se transfèrent au lieu de syntaxes qui s'oublient.

---

## 📚 À lire

**nodejs.org → *HTTP*** (la documentation du module) : parcours `createServer`, `IncomingMessage` et `ServerResponse`. Tu n'as pas besoin de tout lire — repère ce qui existe.

**nodejs.org → *Anatomy of an HTTP Transaction*** : c'est **la** lecture de cette leçon. Un guide officiel qui explique précisément ce que tu es en train de construire.

**MDN → *HTTP response status codes*** à garder ouvert : tu vas commencer à les **émettre** et non plus seulement à les lire.

Et relis la leçon 07 du palier 0 : elle prend un sens différent quand c'est toi qui écris les réponses.

---

## 🤖 Le mini-projet à demander à l'IA

Tout l'intérêt est de ressentir la pénibilité, donc l'IA doit **ajouter des exigences** sans donner de solution.

> « Je suis en formation de développeur, palier 4. Je construis un serveur HTTP **uniquement avec `node:http`**, sans aucune dépendance, pour comprendre ce qu'un framework automatise. Donne-moi un cahier des charges **progressif en 8 étapes**, sans aucun code : chaque étape ajoute une exigence qui rend mon fichier plus lourd (une deuxième route, un paramètre d'URL, un corps JSON, la validation, les codes de statut corrects, CORS, les fichiers statiques, la gestion centralisée des erreurs). Après chaque étape, demande-moi **combien de lignes de "plomberie" j'ai écrites par rapport aux lignes de logique métier**. À la fin, demande-moi de dresser la liste de tout ce qu'un framework devra faire à ma place. »

Cette dernière question est l'objectif de la leçon : la liste que tu produiras est ta réponse à la question d'entretien.

Puis la démonstration du modèle à processus unique, qui marque durablement :

> « Donne-moi un protocole d'expérience, sans code, pour démontrer sur mon propre serveur Node qu'un calcul synchrone long bloque **toutes** les requêtes, y compris celles d'autres clients. Dis-moi quelles requêtes lancer, dans quel ordre, et ce que je devrais observer. Ensuite demande-moi d'expliquer pourquoi, et ce qui se passerait différemment en PHP. »

---

## 🛠️ À faire

1. **Le serveur minimal** : quinze lignes, une réponse texte, testé avec `curl -i`. Observe les en-têtes renvoyés.
2. **Deux routes** avec des `if` sur la méthode et le chemin, plus un 404 pour le reste.
3. **Query string** : lis un paramètre `?categorie=food` avec `new URL`.
4. **⭐ Lire un corps JSON** : écris `lireCorps(req)` avec les événements du flux. Teste avec `curl -X POST -d '{"montant":1500}'`. Puis envoie du JSON invalide et renvoie un 400.
5. **Le routeur** : remplace tes `if` par une table de routes avec motifs et paramètres. Ajoute `GET /depenses/:id`.
6. **Les bons codes** : `201` à la création avec un en-tête `Location`, `204` à la suppression, `400` sur données invalides, `404` sur ressource absente.
7. **CORS** : appelle ton serveur depuis une page React sur un autre port, constate le blocage, puis ajoute l'en-tête `Access-Control-Allow-Origin` et la réponse à la requête `OPTIONS`.
8. **Fichiers statiques** : sers un dossier `public/`. Puis **exploite la faille** avec `curl "http://localhost:3000/../serveur.js"` et corrige.
9. **⚠️ Démontre le blocage** : ajoute une route qui fait une boucle synchrone de cinq secondes. Appelle-la, puis appelle une autre route **depuis un second terminal** pendant ce temps. Note le résultat dans ton journal.
10. **Gestion centralisée des erreurs** : un `try/catch` autour du routeur, avec un message neutre et la trace journalisée.
11. **Le bilan** : compte les lignes de ton serveur, et sépare-les en deux colonnes — « plomberie HTTP » et « logique métier ». Écris le ratio dans ton journal, puis la liste de ce qu'un framework devra reprendre.

<details>
<summary>Corrections et points de contrôle</summary>

**4.** Les trois événements à gérer : `data` (accumuler), `end` (résoudre), `error` (rejeter). Oublier `error` laisse une promesse en attente pour toujours si la connexion se coupe. Et il faut aussi penser à une **limite de taille** : sans elle, un client peut envoyer un corps de plusieurs gigaoctets et saturer la mémoire de ton serveur. C'est l'une des protections qu'un framework applique par défaut.

**7.** Le serveur doit répondre aux requêtes `OPTIONS` (la « pré-vérification » que le navigateur envoie avant certains appels) avec les en-têtes `Access-Control-Allow-Origin`, `Allow-Methods` et `Allow-Headers`. Tu viens de corriger, côté serveur, le problème que tu subissais côté client au palier 2 — et de vérifier qu'il **ne pouvait pas** être corrigé ailleurs.

**8.** `curl --path-as-is "http://localhost:3000/../serveur.js"` peut te renvoyer ton propre code source. La correction :
```js
import { resolve, sep } from "node:path";
const racine = resolve("public");
const sur = resolve(racine, "." + chemin);
if (!sur.startsWith(racine + sep)) return envoyerJson(res, 403, { erreur: "Interdit" });
```
On résout le chemin absolu et on **vérifie qu'il est bien sous la racine**. Note que servir des fichiers statiques depuis Node est de toute façon déconseillé en production : c'est le travail du reverse proxy (palier 8).

**9.** Toutes les requêtes attendent la fin de la boucle, y compris celles venant d'autres clients. Un seul processus, un seul fil, une seule pile d'appels (palier 1, leçon 11). **En PHP, chaque requête a son propre processus : seul l'utilisateur qui a déclenché le calcul attend.** C'est exactement la comparaison que tu feras au palier 6 et que tu formaliseras au palier 7 — et tu viens de la mesurer au lieu de la lire.

**11.** Le ratio typique est écrasant : environ 80 % de plomberie pour 20 % de logique. La liste attendue : routage et extraction des paramètres, parsing du corps (JSON, formulaires, fichiers), limites de taille, en-têtes et types de contenu, codes de statut, gestion centralisée des erreurs, fichiers statiques sécurisés, CORS, journalisation, et une organisation du code en couches. **C'est le cahier des charges d'Express — et c'est ta réponse en entretien.**
</details>

---

## ✅ Acquis si…

- [ ] J'écris un serveur HTTP avec `node:http`, sans aucune dépendance.
- [ ] Je sais que le corps d'une requête est un **flux** à assembler, et pas une propriété.
- [ ] J'ai écrit un routeur à base de table de motifs et de paramètres.
- [ ] J'émets les bons codes de statut, avec les bons en-têtes.
- [ ] J'ai corrigé CORS **côté serveur**, après l'avoir subi côté client.
- [ ] J'ai exploité puis corrigé une faille de traversée de répertoire.
- [ ] J'ai démontré qu'un calcul synchrone bloque **toutes** les requêtes.
- [ ] Je peux énumérer, de mémoire, ce qu'un framework web automatise.
- [ ] J'ai écrit le ratio plomberie / logique métier de mon serveur dans mon journal.

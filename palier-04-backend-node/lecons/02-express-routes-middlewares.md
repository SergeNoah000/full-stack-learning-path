# Leçon 02 — Express : routes, paramètres, middlewares

> 🎯 **À la fin de cette leçon** : tu structures une API avec Express, et tu comprends les middlewares — le concept qui explique l'ordre d'exécution de tout serveur web.
> ⏱️ 5 h · **Prérequis** : leçon 01 (le serveur nu).

---

## De quoi on parle

**Express** est un framework minimaliste pour Node. Il ne t'impose pas d'architecture : il fournit exactement ce que tu as écrit à la main à la leçon 01 — un routeur, le parsing du corps, une abstraction de requête et de réponse — et il ajoute le concept de middleware.

```js
import express from "express";
const app = express();

app.use(express.json());                                 // un middleware
app.get("/depenses", (req, res) => res.json(depenses));  // une route

app.listen(3000);
```

Un **middleware** est une fonction qui s'exécute **entre** la réception de la requête et l'envoi de la réponse. Elle reçoit `(req, res, next)` et peut : lire ou enrichir la requête, interrompre le traitement en répondant, ou passer la main au suivant avec `next()`.

C'est le concept central de la leçon, et il dépasse Express : tu le retrouveras sous le même nom en Python (palier 5), en PHP (palier 6, les middlewares Laravel), et dans ton reverse proxy (palier 8).

---

## À quoi ça sert, concrètement

**Parce que tu viens de constater la pénibilité.** À la leçon 01, ton serveur faisait 80 % de plomberie. Express reprend cette plomberie, et ton code redevient de la logique métier. La comparaison est frappante quand on l'a vécue — c'est le but de l'ordre des deux leçons.

**Parce que les middlewares résolvent un problème transversal.** Journaliser chaque requête, vérifier un jeton d'authentification, limiter le débit, ajouter des en-têtes de sécurité, gérer les erreurs : ces besoins concernent **toutes** les routes. Sans mécanisme dédié, tu copierais le même code dans chaque fonction. Le middleware permet de l'écrire une fois et de l'appliquer en amont.

**Parce que la chaîne de middlewares explique l'ordre d'exécution.** C'est ce qui permet de répondre à « pourquoi mon authentification ne protège-t-elle pas cette route ? » — parce qu'elle est déclarée après. Comprendre cette chaîne évite une classe entière de bugs déroutants.

**Et parce que c'est encore le framework Node le plus répandu.** Il existe des alternatives modernes (Fastify, Hono), mais Express reste majoritaire dans l'existant et dans les offres d'emploi, et ses concepts sont transférables.

---

## Où ça intervient dans le développement

Express occupe la couche que tu as construite à la main, et il laisse au-dessus la place de ton architecture :

```
   ton code métier            ← tu l'organiseras en couches (leçon 03)
        ▲
   EXPRESS                    ← cette leçon : routeur, corps, middlewares
        ▲
   node:http                  ← leçon 01
```

Et la chaîne de middlewares forme un **pipeline** qu'il faut visualiser, parce que l'ordre y est tout :

```
   requête
     │
     ├─▶ journalisation        (log la méthode et l'URL)
     ├─▶ CORS                   (autorise l'origine)
     ├─▶ express.json()         (assemble le corps — leçon 01)
     ├─▶ authentification       (vérifie le jeton, ou répond 401)   ← leçon 08
     ├─▶ validation             (vérifie les données, ou répond 400) ← leçon 04
     ├─▶ LA ROUTE               (ta logique)
     │
     └─▶ gestion des erreurs    (en dernier, toujours)
   réponse
```

Deux prolongements importants pour le parcours.

**Ce pipeline est un patron universel.** Au palier 6, les middlewares Laravel sont exactement ça. Au palier 8, ton reverse proxy Nginx est un middleware devant ton application. Au palier 7, tu reconnaîtras le patron *Chain of Responsibility*. Une idée, quatre endroits.

**Et c'est ici que tu prépares le découpage en couches.** Express te laisse écrire toute ta logique dans les fonctions de route — et c'est précisément ce qu'il faut éviter. La leçon 03 posera le découpage routes → contrôleurs → services → données, qui est le fil rouge architecture niveau 3.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas réécrire ton serveur de la leçon 01 en Express, en un tiers des lignes. C'est un moment agréable, et c'est le meilleur argument pédagogique du parcours.

Tu vas aussi, presque certainement, oublier `next()` dans un middleware et voir ta requête rester en attente sans erreur. C'est le piège de la leçon.

Installe **Bruno** ou **Postman** maintenant : tester une API sans interface demande un client HTTP, et une collection de requêtes versionnée dans ton dépôt est une pratique professionnelle.

### En équipe, en entreprise

**L'organisation des fichiers est conventionnelle, pas imposée.** Express ne dit rien sur la structure, donc chaque équipe a la sienne. Tu verras des `routes/`, `controllers/`, `services/`, `middlewares/` — et parfois un fichier de 2 000 lignes. La leçon 03 te donnera une structure défendable.

**Les middlewares d'infrastructure sont standards.** `helmet` pour les en-têtes de sécurité, `cors`, `morgan` ou `pino` pour la journalisation, `express-rate-limit` pour la limitation de débit, `compression`. On ne réécrit pas ces briques.

**On te reprendra sur l'ordre des middlewares** et sur les erreurs non capturées dans du code asynchrone — le piège détaillé plus bas, qui est le défaut le plus connu d'Express 4.

**Et tu entendras parler d'alternatives.** Fastify (plus rapide, validation intégrée), Hono (moderne, multi-runtime), NestJS (structuré, inspiré d'Angular). Savoir qu'elles existent et ce qu'elles apportent est utile ; Express reste le bon choix pour apprendre, parce que rien n'y est caché.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `app.get/post/put/patch/delete`, les paramètres de route, `req.params`, `req.query`, `req.body`, `res.json`, `res.status`, `express.json()`, les routeurs modulaires, et le middleware d'erreurs.

Régulièrement : les middlewares maison (authentification, validation), `express.Router()`, les routes imbriquées, `helmet`, `cors`, la journalisation, les variables d'environnement.

Rare, et hors sujet pour l'instant : les moteurs de templates côté serveur (tu fais une API, le rendu est en React — mais tu rencontreras le rendu serveur aux paliers 5 et 6), `res.sendFile` et les fichiers statiques en production (c'est le proxy qui s'en occupe), les sessions côté Express (leçon 08), les sous-applications montées, `app.locals`, les paramètres de route avec expressions régulières complexes. Et une chose à savoir : Express 5 règle le piège des erreurs asynchrones, mais beaucoup de projets sont encore en version 4.

---

## La mécanique

### Le squelette

```bash
npm init -y
npm install express
npm install -D typescript tsx @types/express @types/node
```

```ts
// src/serveur.ts
import express from "express";

const app = express();

app.use(express.json());                     // ⭐ sans ça, req.body est undefined

app.get("/sante", (_req, res) => res.json({ statut: "ok" }));

const PORT = Number(process.env.PORT ?? 3000);
app.listen(PORT, () => console.log(`API sur http://localhost:${PORT}`));
```

`express.json()` est le middleware qui fait ce que tu as écrit à la main à la leçon 01 : accumuler le flux, le parser, le poser dans `req.body`, et gérer les limites de taille. L'oublier est l'erreur la plus fréquente avec Express, et son symptôme est un `req.body` vide.

### Les routes et leurs données

```ts
// Paramètre de route
app.get("/depenses/:id", (req, res) => {
  const id = Number(req.params.id);          // ⚠️ TOUJOURS une chaîne au départ
  if (!Number.isInteger(id)) return res.status(400).json({ erreur: "id invalide" });
  const depense = trouver(id);
  if (!depense) return res.status(404).json({ erreur: "Dépense introuvable" });
  res.json(depense);
});

// Query string
app.get("/depenses", (req, res) => {
  const categorie = typeof req.query.categorie === "string" ? req.query.categorie : undefined;
  res.json(lister({ categorie }));
});

// Corps JSON
app.post("/depenses", (req, res) => {
  const creee = creer(req.body);             // ⚠️ req.body n'est PAS validé (leçon 04)
  res.status(201).location(`/depenses/${creee.id}`).json(creee);
});
```

Trois points d'attention qui reviennent sans cesse.

**`req.params` et `req.query` sont toujours des chaînes.** C'est la frontière de la leçon 01 du palier 1, troisième rencontre. `Number(req.params.id)` et une vérification sont obligatoires.

**`req.query` peut être un tableau.** `?categorie=a&categorie=b` donne un tableau, pas une chaîne. D'où le `typeof` — et c'est une source de plantage réelle.

**`req.body` n'est pas validé.** Express le parse, il ne le vérifie pas. C'est tout l'objet de la leçon 04.

### ⭐ Les middlewares

```ts
// Un middleware maison : journalisation
app.use((req, res, next) => {
  const debut = Date.now();
  res.on("finish", () => {
    console.log(`${req.method} ${req.originalUrl} ${res.statusCode} ${Date.now() - debut}ms`);
  });
  next();                                    // ⭐ sans next(), la requête reste en attente
});

// Un middleware qui peut INTERROMPRE
function exigeAuth(req: Request, res: Response, next: NextFunction) {
  const entete = req.headers.authorization;
  if (!entete?.startsWith("Bearer ")) {
    return res.status(401).json({ erreur: "Authentification requise" });   // on arrête ici
  }
  next();                                     // ou on continue
}

// Appliqué globalement
app.use(exigeAuth);

// Ou sur une route précise
app.post("/depenses", exigeAuth, (req, res) => { … });

// Ou sur un préfixe
app.use("/admin", exigeAuth);
```

**L'ordre de déclaration est l'ordre d'exécution.** C'est la règle qui explique le plus de bugs :

```ts
app.get("/depenses", listerDepenses);        // déclarée AVANT
app.use(exigeAuth);                           // ne protégera PAS la route ci-dessus
```

Pose-toi toujours la question : *mon middleware est-il déclaré avant les routes qu'il doit couvrir ?*

### Les routeurs modulaires

Avec vingt routes, un seul fichier devient illisible :

```ts
// src/routes/depenses.ts
import { Router } from "express";
const routeur = Router();

routeur.get("/", listerDepenses);
routeur.get("/:id", lireDepense);
routeur.post("/", creerDepense);

export default routeur;

// src/serveur.ts
import depensesRouteur from "./routes/depenses.js";
app.use("/depenses", depensesRouteur);        // le préfixe est ici, une seule fois
```

C'est la première étape du découpage de la leçon 03 : les URL d'un côté, la logique de l'autre.

### ⭐ Le middleware d'erreurs

```ts
// TOUJOURS déclaré en DERNIER, et il a QUATRE paramètres
app.use((erreur: unknown, _req: Request, res: Response, _next: NextFunction) => {
  console.error(erreur);                                   // la trace pour nous

  if (erreur instanceof ErreurValidation) {
    return res.status(400).json({ erreur: erreur.message, champ: erreur.champ });
  }
  if (erreur instanceof ErreurIntrouvable) {
    return res.status(404).json({ erreur: erreur.message });
  }
  res.status(500).json({ erreur: "Erreur interne" });       // neutre pour le client
});
```

Express reconnaît un middleware d'erreurs par son **nombre de paramètres** : quatre au lieu de trois. C'est une bizarrerie de l'API, et c'est la cause d'un bug classique — un middleware d'erreurs écrit avec trois paramètres n'est jamais appelé.

Tu reconnais la distinction de la leçon 08 du palier 1 : les erreurs **attendues** (validation, ressource absente) deviennent des `4xx` avec un message utile ; les erreurs **inattendues** deviennent un `500` avec un message neutre et la trace journalisée.

### ⚠️ Le piège des erreurs asynchrones

```ts
// ❌ En Express 4, cette erreur n'est PAS attrapée : la requête reste en attente
app.get("/depenses", async (req, res) => {
  const d = await chargerDepenses();         // si ça rejette… personne n'écoute
  res.json(d);
});

// ✅ Un try/catch avec passage au middleware d'erreurs
app.get("/depenses", async (req, res, next) => {
  try {
    res.json(await chargerDepenses());
  } catch (e) { next(e); }
});

// ✅ Ou une enveloppe, pour ne pas répéter le try/catch partout
const asyncHandler = (fn: RequestHandler): RequestHandler =>
  (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);

app.get("/depenses", asyncHandler(async (req, res) => {
  res.json(await chargerDepenses());
}));
```

C'est **le défaut le plus connu d'Express 4** : il ne capture pas les rejets de promesses dans les gestionnaires. Le symptôme est une requête qui ne répond jamais, sans message. Express 5 le corrige ; en attendant, l'enveloppe `asyncHandler` est la solution standard, et tu la verras dans beaucoup de projets.

### Les middlewares d'infrastructure à installer

```ts
import helmet from "helmet";
import cors from "cors";

app.use(helmet());                                         // en-têtes de sécurité
app.use(cors({ origin: process.env.ORIGINE_AUTORISEE }));  // CORS, côté serveur
app.use(express.json({ limit: "100kb" }));                 // ⭐ une limite de taille
```

La limite de taille n'est pas un détail : sans elle, un client peut envoyer un corps énorme et saturer la mémoire de ton serveur. C'est l'une des protections que tu avais oubliée à la leçon 01.

---

## Les problèmes que tu vas rencontrer

**`req.body` est `undefined`.** Il manque `express.json()`, ou il est déclaré **après** la route, ou le client n'a pas envoyé `Content-Type: application/json`.

**Ma requête reste en attente, sans erreur.** Trois causes : un `next()` oublié dans un middleware, un chemin de code qui ne répond pas, ou une promesse rejetée non capturée (Express 4).

**Mon middleware d'authentification ne protège rien.** Il est déclaré après les routes.

**Mon middleware d'erreurs n'est jamais appelé.** Il n'a pas quatre paramètres, ou il n'est pas déclaré en dernier.

**`Cannot set headers after they are sent`.** Tu réponds deux fois — souvent un `return` manquant avant un `res.status(...).json(...)`.

**Mon `:id` me donne `NaN`.** `req.params` est une chaîne : convertis et vérifie.

**Mon code plante sur `req.query.x.toLowerCase()`.** La query peut être absente ou être un tableau.

**CORS bloque toujours.** Le middleware `cors` est après les routes, ou tu n'autorises pas la bonne origine, ou tu ne réponds pas à la requête `OPTIONS` de pré-vérification.

**Mon serveur plante sur une erreur et s'arrête.** Une exception hors du cycle de requête. En production, c'est au superviseur de redémarrer (palier 8).

---

## Ce qu'on te demandera

En **entretien Node**, la question quasi certaine est : **« qu'est-ce qu'un middleware ? »** — et la bonne réponse mentionne la chaîne, `next()`, et la possibilité d'interrompre. Suit souvent : « pourquoi l'ordre des middlewares compte-t-il ? ».

Autres questions : « comment gères-tu les erreurs dans Express ? », « différence entre `req.params`, `req.query` et `req.body` ? », « qu'est-ce qu'Express ne fait pas pour toi ? » (validation, authentification, architecture — et c'est une bonne question).

En **test technique**, on te demandera une petite API. On regarde l'organisation des fichiers, les codes de statut, la gestion d'erreurs centralisée, et la validation.

En **revue de code**, l'ordre des middlewares et les erreurs asynchrones non capturées sont les deux remarques récurrentes.

---

## Ce qui te démarquera

**Savoir expliquer la chaîne de middlewares comme un pipeline**, et faire le lien avec Laravel, Nginx et le patron *Chain of Responsibility*. Ce transfert montre que tu as compris un concept, pas appris une API.

**Un middleware d'erreurs propre**, qui distingue les erreurs attendues des bugs et ne fuite jamais de trace technique au client.

**Connaître le piège des erreurs asynchrones d'Express 4** et la solution. C'est précis, c'est réel, et peu de juniors le connaissent.

**Mettre une limite de taille sur le corps**, et savoir pourquoi.

**Installer `helmet` et configurer CORS correctement** — c'est-à-dire pas `origin: "*"` sur une API authentifiée.

**Et ne pas mettre la logique métier dans les fonctions de route.** C'est la leçon suivante, et l'anticiper se remarque immédiatement.

---

## 📚 À lire

**expressjs.com → *Guide*** : les pages *Routing*, *Using middleware* et *Error handling*. La documentation est courte et suffisante — Express est un petit framework.

**expressjs.com → *Production best practices: security*** : à lire maintenant, elle liste exactement les middlewares d'infrastructure et les pièges.

**MDN → *Express/Node introduction*** pour une présentation pédagogique, si tu veux une seconde formulation.

Et garde la page des **codes de statut HTTP** ouverte : tu les émets désormais, et le choix du bon code fait partie de la conception d'API (leçon 03).

---

## 🤖 Le mini-projet à demander à l'IA

La comparaison avec la leçon 01 est l'essentiel : c'est elle qui donne la valeur du framework.

> « Je suis en formation de développeur, palier 4. J'ai écrit un serveur HTTP à la main avec `node:http` (routeur maison, lecture du corps en flux, en-têtes manuels), et je le réécris en Express. Ne me donne aucun code. Pose-moi **8 questions** qui me font constater, point par point, ce qu'Express reprend à ma charge, et **ce qu'il ne fait toujours pas** (validation, authentification, architecture, accès aux données). Pour chaque point, demande-moi combien de lignes j'avais écrites et combien il m'en reste. »

Puis l'exercice sur les middlewares, qui est le cœur de la leçon :

> « Donne-moi **10 scénarios de bugs réalistes** liés à la chaîne de middlewares Express, décrits **par le symptôme observé** (la requête ne répond jamais, l'authentification ne protège pas une route, `req.body` est vide, le middleware d'erreurs n'est jamais appelé, CORS bloque encore, une erreur asynchrone fait un timeout…). Ne me dis pas la cause. Pour chacun, je dois diagnostiquer, expliquer **à quel endroit de la chaîne le problème se situe**, et corriger. »

---

## 🛠️ À faire

1. **Réécris en Express** ton serveur de la leçon 01, à l'identique fonctionnellement. **Compte les lignes avant et après**, et note le ratio dans ton journal.
2. **Les trois sources de données** : une route qui lit un `:id` (params), une qui lit un filtre (query), une qui lit un corps JSON. Convertis et vérifie chaque fois.
3. **Le piège `express.json()`** : retire-le, envoie un `POST`, constate `req.body` vide. Remets-le **après** la route et constate que c'est toujours vide. Puis remets-le avant.
4. **Middleware de journalisation** : méthode, URL, statut et durée de chaque requête.
5. **Middleware d'interruption** : `exigeAuth` qui renvoie 401 si l'en-tête `Authorization` est absent. Applique-le à une seule route, puis à un préfixe.
6. **⚠️ L'ordre** : déclare `exigeAuth` **après** une route protégée, constate qu'elle n'est pas protégée, puis corrige. Écris la règle dans ton journal.
7. **Le `next()` oublié** : écris un middleware sans `next()`, observe la requête en attente, et explique pourquoi il n'y a aucune erreur.
8. **Routeurs modulaires** : découpe tes routes en `routes/depenses.ts` avec `express.Router()`.
9. **Middleware d'erreurs** : avec quatre paramètres, distinguant validation (400), ressource absente (404) et le reste (500 neutre). Écris-le d'abord avec **trois** paramètres et constate qu'il n'est jamais appelé.
10. **⚠️ L'erreur asynchrone** : écris une route `async` qui rejette, constate le timeout, puis corrige avec `try/catch` + `next(e)`, puis avec une enveloppe `asyncHandler`.
11. **Infrastructure** : ajoute `helmet`, `cors` configuré sur une origine précise, et une limite de 100 ko sur le corps. Teste la limite avec un gros envoi.
12. **Collection d'API** : crée une collection Bruno (ou Postman) couvrant toutes tes routes, et commite-la dans ton dépôt.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Attends-toi à passer d'environ 200 lignes à 60 ou 70, et surtout à voir la **proportion** s'inverser : la plomberie disparaît, la logique métier reste. C'est la démonstration que les deux leçons cherchaient à produire, et c'est ta réponse à « qu'apporte un framework ? ».

**3.** Déclaré **après** la route, `express.json()` ne s'exécute pas avant elle : la chaîne est séquentielle. C'est la démonstration la plus simple de la règle de l'ordre, et c'est aussi le diagnostic du bug « mon POST arrive vide » que tu avais rencontré côté client au palier 2.

**6.** La règle à écrire : **un middleware ne couvre que les routes déclarées après lui.** C'est la cause la plus fréquente d'une protection qui ne protège pas — et c'est une faille de sécurité, pas un simple bug.

**7.** Sans `next()` et sans réponse, Express n'a aucune raison de continuer : le traitement s'arrête là, la connexion reste ouverte, et le client attend jusqu'à son propre timeout. Aucune erreur n'est levée parce que, du point de vue d'Express, rien d'anormal ne s'est produit — un middleware a simplement choisi de ne rien faire.

**9.** Avec trois paramètres, Express considère ta fonction comme un middleware **ordinaire** : il la place dans la chaîne normale, et elle ne reçoit jamais les erreurs. C'est l'arité (le nombre de paramètres) qui distingue les deux, ce qui est une bizarrerie d'API — mais il faut la connaître.

**10.** Sans capture, le rejet devient un `unhandledRejection` : le gestionnaire s'arrête, aucune réponse n'est envoyée, et le client attend. Avec Node moderne, un rejet non géré peut même **arrêter le processus** — donc faire tomber le serveur pour tous les utilisateurs. C'est pour cette raison que l'enveloppe `asyncHandler` est devenue un standard de l'écosystème Express.
</details>

---

## ✅ Acquis si…

- [ ] J'ai réécrit mon serveur nu en Express et **mesuré** la différence.
- [ ] J'explique ce qu'est un middleware, avec `next()` et la possibilité d'interrompre.
- [ ] Je sais que **l'ordre de déclaration est l'ordre d'exécution**, et j'ai provoqué le bug.
- [ ] Je distingue `req.params`, `req.query` et `req.body`, et je convertis et vérifie chacun.
- [ ] Mon middleware d'erreurs a **quatre** paramètres et est déclaré en dernier.
- [ ] Je distingue erreurs attendues (4xx) et bugs (500 neutre).
- [ ] Je connais le piège des erreurs asynchrones d'Express 4 et sa solution.
- [ ] Mes routes sont découpées en routeurs modulaires.
- [ ] J'ai `helmet`, un CORS configuré, et une limite de taille sur le corps.
- [ ] Ma collection d'API est versionnée dans le dépôt.

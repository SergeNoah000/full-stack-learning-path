# Leçon 03 — Concevoir une API REST : ressources, verbes, codes

> 🎯 **À la fin de cette leçon** : tu conçois une API qu'un autre développeur peut utiliser sans te poser de question, et tu organises ton code en couches.
> ⏱️ 4 h · **Prérequis** : leçons 01–02.

---

## De quoi on parle

**REST** est un style de conception d'API, pas une technologie. Son idée centrale : on expose des **ressources** (des choses, nommées par des noms) et on agit sur elles avec les **verbes HTTP** (des actions, déjà définies par le protocole).

```
GET    /depenses          lister
POST   /depenses          créer
GET    /depenses/42       lire une
PATCH  /depenses/42       modifier partiellement
DELETE /depenses/42       supprimer
```

L'URL dit **quoi**, la méthode dit **quelle action**. C'est tout le principe, et il a une conséquence immédiate : `/creerDepense` ou `/getDepenses` ne sont pas des URL REST, parce qu'elles mettent le verbe dans le nom.

À cela s'ajoute le **contrat** : la forme des données envoyées et reçues, les codes de statut possibles, la structure des erreurs. Et le **découpage en couches** côté serveur : routes → contrôleurs → services → accès aux données.

---

## À quoi ça sert, concrètement

**Parce qu'une API est une interface entre deux équipes.** Dès qu'un frontend et un backend sont séparés — ce qui est ton cas depuis le palier 3 —, l'API devient un **contrat**. Un contrat prévisible permet au développeur frontend de travailler sans demander « et pour supprimer, c'est quelle URL ? ». Un contrat incohérent produit une réunion par jour.

**Parce que la convention fait gagner du temps.** Si ton API suit REST, n'importe quel développeur devine les URL sans documentation. S'il voit `GET /depenses/42`, il sait qu'il existe probablement `DELETE /depenses/42`. Cette prévisibilité est la véritable valeur du style.

**Parce que les codes de statut sont une information exploitable par les machines.** TanStack Query (palier 3, leçon 08) sait réessayer un 503 et pas un 400. Un navigateur sait mettre en cache un 200. Un outil de surveillance compte les 5xx. Renvoyer `200 OK` avec `{"erreur": "..."}` dans le corps casse tous ces mécanismes — et c'est une erreur très répandue.

**Et parce que le découpage en couches est ce qui rend une API maintenable.** Toute ta logique dans les fonctions de route fonctionne jusqu'à environ cinq cents lignes, puis devient impossible à tester et à faire évoluer.

---

## Où ça intervient dans le développement

Cette leçon est le pivot du palier : elle définit **le contrat** avec le client, et **l'organisation** du serveur.

```
   CLIENT (palier 3)
     │  GET /depenses?categorie=food
     ▼
   ┌──────────────────────────────────────────────────────┐
   │ ROUTES         déclarent les URL, délèguent          │
   │   ▼                                                   │
   │ CONTRÔLEURS    lisent la requête, valident,          │
   │                appellent un service, forment la réponse│
   │   ▼            (connaissent HTTP — et c'est tout)     │
   │ SERVICES       LA LOGIQUE MÉTIER                      │
   │   ▼            (ne connaissent PAS HTTP)              │
   │ ACCÈS DONNÉES  les requêtes                           │
   └──────────────────┬───────────────────────────────────┘
                      ▼
                 BASE DE DONNÉES (leçons 05-07)
```

La règle du découpage tient en une phrase par couche. Un **contrôleur** connaît HTTP et rien du métier. Un **service** connaît le métier et rien de HTTP. Une couche d'**accès aux données** connaît les requêtes et rien du métier.

Le test qui vérifie que c'est juste : *mon service pourrait-il être appelé depuis une ligne de commande, sans serveur web ?* Si oui, le découpage est bon. S'il a besoin de `req` et `res`, la logique est coincée dans HTTP.

Deux prolongements majeurs.

**Ce découpage est exactement ce que Django et Laravel imposent** aux paliers 5 et 6 — sous les noms MVT et MVC. En l'écrivant à la main ici, tu comprendras **pourquoi** ils sont faits ainsi au lieu de suivre leurs conventions sans les interroger. C'est l'objet du fil rouge architecture niveau 3, et le `ARCHITECTURE.md` demandé dans ton projet 4.

**Et le contrat de cette leçon sera formalisé au palier 5** : FastAPI génère une documentation OpenAPI automatiquement, et tu réaliseras alors que ce que tu écris ici à la main peut être produit depuis le code. C'est la « spécification d'API » du fil rouge gestion de projet.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas concevoir ton API **avant** de l'écrire : les ressources, les URL, les codes. C'est inhabituel et c'est le bon ordre — on ne découvre pas son contrat en codant.

Tu vas aussi découper ton code en trois couches et trouver ça excessif pour une petite API. Garde-le quand même : ton projet 4 va grossir, et c'est le dernier moment où le découpage est facile.

### En équipe, en entreprise

**Le contrat se négocie avant le code.** Dans une équipe avec un frontend et un backend séparés, on se met d'accord sur les URL, les champs et les codes **avant** de développer, souvent dans un document ou un fichier OpenAPI. Le frontend peut alors travailler avec des données simulées.

**La cohérence vaut mieux que la perfection.** Tu verras des API qui violent REST sur un point précis mais le font **partout de la même façon** — c'est utilisable. Une API qui mélange trois conventions ne l'est pas.

**Les erreurs ont un format unique.** Les équipes définissent une structure de réponse d'erreur (`{ erreur, code, champs }`) et s'y tiennent, pour que le client puisse la traiter sans cas particulier.

**Et tu entendras parler de versionnage.** `/api/v1/...` ou un en-tête dédié. Dès qu'une API a des clients qu'on ne contrôle pas (une application mobile installée chez les gens — ton palier 9), on ne peut plus casser le contrat : il faut une nouvelle version.

**Tu croiseras aussi GraphQL et tRPC.** Ce sont des alternatives à REST, avec d'autres compromis. REST reste majoritaire, et c'est le bon point de départ.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : les ressources au pluriel, les cinq verbes, les codes `200`/`201`/`204`/`400`/`401`/`403`/`404`/`422`/`500`, la pagination, le filtrage par query string, un format d'erreur unique, et le découpage en couches.

Régulièrement : les sous-ressources (`/depenses/42/commentaires`), le tri et la recherche, le versionnage, les en-têtes `Location` et `Cache-Control`, l'idempotence sur les écritures sensibles.

Rare, et hors sujet pour l'instant : HATEOAS (les liens hypermédia — la définition stricte de REST, que presque personne n'applique), la négociation de contenu, les requêtes conditionnelles avec ETag, `PATCH` au format JSON Patch, les réponses partielles, la pagination par curseur (utile à grande échelle). Tu peux concevoir d'excellentes API sans aucune de ces notions.

---

## La mécanique

### Nommer les ressources

```
✅ /depenses                  un NOM, au PLURIEL
✅ /depenses/42
✅ /depenses/42/commentaires  une sous-ressource
✅ /utilisateurs/7/depenses

❌ /getDepenses               le verbe est déjà dans la méthode HTTP
❌ /depense                   le singulier pour une collection
❌ /creerDepense              un verbe dans l'URL
❌ /api/depenses/supprimer/42 une action dans l'URL
```

Conventions pratiques : pluriel partout, minuscules, tirets plutôt que `camelCase` dans les URL (`/notes-de-frais`), pas d'extension (`.json`), pas de barre oblique finale.

### Associer verbe, code et réponse

| Action | Méthode et URL | Succès | Corps de la réponse | Erreurs possibles |
|---|---|---|---|---|
| Lister | `GET /depenses` | `200` | un tableau (ou un objet paginé) | `401` |
| Lire | `GET /depenses/42` | `200` | l'objet | `404`, `401`, `403` |
| Créer | `POST /depenses` | **`201`** + `Location` | l'objet créé, avec son `id` | `400`, `422`, `401` |
| Remplacer | `PUT /depenses/42` | `200` | l'objet | `400`, `404` |
| Modifier | `PATCH /depenses/42` | `200` | l'objet | `400`, `404` |
| Supprimer | `DELETE /depenses/42` | **`204`** | **vide** | `404`, `403`, `409` |

*(Table de référence — à consulter, pas à mémoriser, mais les deux cases en gras sont celles qu'on rate le plus souvent.)*

```ts
// Création : 201 + Location, et on renvoie l'objet créé avec son id
res.status(201).location(`/depenses/${creee.id}`).json(creee);

// Suppression : 204, sans corps
res.status(204).end();
```

Pourquoi renvoyer l'objet créé ? Parce que le serveur a ajouté des champs que le client ne connaît pas (l'identifiant, la date de création, des valeurs par défaut). Sans ça, le client doit refaire un `GET`.

### `PUT` ou `PATCH`

`PUT` **remplace** la ressource entière : les champs absents du corps sont effacés, et l'opération est idempotente. `PATCH` applique une **modification partielle** : seuls les champs fournis changent.

En pratique, `PATCH` est presque toujours ce qu'on veut, parce qu'un client qui modifie un seul champ ne devrait pas avoir à renvoyer l'objet complet.

### Un format d'erreur unique

```ts
// Une seule forme, pour TOUTES les erreurs de l'API
{
  "erreur": "Les données envoyées sont invalides",
  "code": "VALIDATION",
  "champs": {
    "montant": "doit être un nombre positif",
    "categorie": "est obligatoire"
  }
}
```

Le client peut alors écrire **un** traitement d'erreur, et afficher les messages sous les bons champs (palier 3, leçon 06). Si chaque route a son format, le frontend multiplie les cas particuliers.

> ⚠️ **Le code de statut porte l'erreur, pas le corps.** Renvoyer `200 OK` avec `{"succes": false}` est une faute : les bibliothèques HTTP, les caches et la surveillance se fient au statut. C'est aussi pour cette raison que `fetch` ne rejette pas sur un 404 (palier 2, leçon 09) — il te laisse lire le statut.

### La pagination, dès le début

```
GET /depenses?page=2&limite=20
```

```json
{
  "donnees": [ … ],
  "total": 134,
  "page": 2,
  "limite": 20
}
```

**Pagine dès la première version.** Une route qui renvoie « toutes les dépenses » fonctionne avec cinquante enregistrements et s'écroule avec cinquante mille : la réponse grossit linéairement, le réseau sature, et le navigateur rame. C'est le genre de décision qu'on ne peut plus changer facilement une fois que des clients consomment l'API.

Prévois aussi une **limite maximale** côté serveur : sans elle, un client peut demander `?limite=1000000`.

### Le filtrage et le tri

```
GET /depenses?categorie=food&statut=payee&tri=-montant&recherche=taxi
```

Conventions courantes : un paramètre par filtre, un `tri` avec un préfixe `-` pour l'ordre décroissant, et une `recherche` textuelle. Reste cohérent : la convention importe plus que son choix.

### ⭐ Le découpage en couches

```ts
// ── routes/depenses.ts : déclare les URL, délègue
const routeur = Router();
routeur.get("/", asyncHandler(controleurDepenses.lister));
routeur.post("/", asyncHandler(controleurDepenses.creer));
export default routeur;
```

```ts
// ── controleurs/depenses.ts : connaît HTTP, pas le métier
export const controleurDepenses = {
  async lister(req: Request, res: Response) {
    const { page, limite } = lirePagination(req.query);       // lecture HTTP
    const resultat = await serviceDepenses.lister({ page, limite });
    res.json(resultat);                                        // forme la réponse
  },

  async creer(req: Request, res: Response) {
    const donnees = schemaCreation.parse(req.body);            // validation (leçon 04)
    const creee = await serviceDepenses.creer(donnees);
    res.status(201).location(`/depenses/${creee.id}`).json(creee);
  },
};
```

```ts
// ── services/depenses.ts : LA LOGIQUE MÉTIER, aucune trace de HTTP
export const serviceDepenses = {
  async creer(donnees: NouvelleDepense): Promise<Depense> {
    const budget = await depotBudgets.pourCategorie(donnees.categorie);
    if (budget && donnees.montant > budget.restant) {
      throw new ErreurMetier("Le budget de cette catégorie est dépassé");   // pas de code HTTP
    }
    return depotDepenses.inserer({ ...donnees, creeLe: new Date() });
  },
};
```

```ts
// ── depots/depenses.ts : les requêtes, rien d'autre
export const depotDepenses = {
  async inserer(depense: NouvelleDepense): Promise<Depense> { … },
  async lister(filtres: Filtres): Promise<Depense[]> { … },
};
```

Trois observations sur ce code.

**Le service lève une erreur métier sans code HTTP.** C'est le contrôleur ou le middleware d'erreurs qui traduira `ErreurMetier` en `422`. Ainsi le service reste réutilisable depuis une ligne de commande ou une tâche planifiée.

**Le contrôleur ne contient aucune règle.** Il lit, délègue, répond. S'il contient un `if` métier, la règle est au mauvais endroit.

**Et chaque couche ne connaît que la suivante.** Un contrôleur n'appelle jamais directement la base.

### Documenter le contrat

Au minimum, un fichier `docs/api.md` : pour chaque route, la méthode, l'URL, les paramètres, un exemple de corps, un exemple de réponse, et les codes possibles. Au palier 5, FastAPI te montrera qu'on peut générer ce document depuis le code — et tu apprécieras la différence.

---

## Les problèmes que tu vas rencontrer

**Mon frontend ne sait pas quelle URL appeler.** Le contrat n'est pas écrit. C'est un problème de communication, pas de code.

**Je renvoie `200` avec un message d'erreur.** Le client ne peut plus distinguer succès et échec sans lire le corps, et les outils ne fonctionnent plus.

**Ma route de création ne renvoie pas l'identifiant.** Le client doit refaire un appel. Renvoie l'objet créé.

**Mon `DELETE` renvoie un corps.** Ce n'est pas faux, mais `204` sans corps est la convention — et un `204` **avec** un corps est, lui, incorrect.

**Ma liste met dix secondes à charger.** Pas de pagination. Et avec cinquante mille enregistrements, ça ne chargera plus du tout.

**Un client demande `?limite=999999`.** Pas de plafond côté serveur.

**Ma logique métier est dans le contrôleur et je ne peux pas la tester.** C'est la raison du découpage : un contrôleur a besoin de `req` et `res` pour être appelé.

**Je dois changer un champ et j'ai déjà une application mobile en production.** Il faut versionner. Les clients installés ne se mettent pas à jour en même temps.

**Mes URL sont incohérentes** (`/depenses`, `/depense/42`, `/getCategories`). Chaque incohérence est une question que le consommateur devra poser.

---

## Ce qu'on te demandera

C'est l'exercice de **test technique backend** le plus courant : **« conçois les routes de cette ressource »**. On attend les cinq verbes, les bons codes, la pagination, et une cohérence de nommage. C'est l'épreuve B3 de ton évaluation de palier.

En **entretien** : « qu'est-ce que REST ? », « quels codes renvoies-tu pour une création, une suppression, une validation échouée ? », « différence entre `PUT` et `PATCH` ? », « différence entre `401` et `403` ? » (encore), « comment structures-tu une API Express ? », « pourquoi ne pas mettre la logique dans le contrôleur ? ».

Et une question qui distingue : **« comment fais-tu évoluer une API qui a déjà des clients ? »** — la réponse mentionne le versionnage et la compatibilité.

En **revue de code**, le mélange des couches et les codes de statut incorrects sont les deux remarques principales.

---

## Ce qui te démarquera

**Concevoir le contrat avant de coder.** Arriver avec un tableau des routes, des codes et des formats est une démarche d'ingénieur, et c'est ce que le référent verra dans ton cahier des charges du projet 4.

**Les bons codes de statut, systématiquement.** `201` avec `Location`, `204` sans corps, `422` pour une validation métier. Ce sont des détails, et ce sont précisément ceux qu'on remarque.

**Un format d'erreur unique**, documenté, que le client peut traiter sans cas particulier.

**Paginer dès le premier jour.** Et prévoir un plafond. C'est un réflexe d'échelle que peu de juniors ont.

**Le test « mon service est-il appelable sans serveur web ? »**. Cette formulation du découpage est plus parlante que n'importe quelle règle, et elle montre que tu as compris l'enjeu : la testabilité.

**Et savoir qu'une API publique ne se casse pas.** Évoquer le versionnage quand on te parle d'évolution montre que tu penses au cycle de vie, pas seulement à la livraison.

---

## 📚 À lire

**MDN → *HTTP response status codes*** à garder ouvert — tu les choisis désormais.

**Microsoft → *REST API design guidelines*** (ou les *Google API design guidelines*) : ce sont les documents que les équipes utilisent réellement pour trancher les questions de nommage et de codes. Parcours les sections sur les ressources, la pagination et les erreurs.

**restfulapi.net** pour une présentation courte des principes.

Et pour le découpage en couches : **Martin Fowler, *Patterns of Enterprise Application Architecture*** (les fiches *Service Layer* et *Repository* en ligne suffisent). Tu rencontreras ces patrons nommés au palier 7 ; les voir une fois ici rend la lecture facile plus tard.

---

## 🤖 Le mini-projet à demander à l'IA

La conception d'API s'apprend en concevant, puis en se faisant challenger comme le ferait un consommateur.

> « Je suis en formation de développeur, palier 4. Je conçois une API REST. Décris-moi **en langage métier seulement**, sans aucune URL ni code, les besoins d'une application de gestion de notes de frais : des employés, des notes de frais avec des lignes, des catégories, un circuit de validation par un responsable, des pièces jointes, des rapports mensuels. Ma mission : concevoir **le contrat complet** — ressources, URL, verbes, codes de statut, format des erreurs, pagination, filtres. Ensuite, joue le rôle du **développeur frontend** qui va consommer mon API : pose-moi toutes les questions que mon contrat laisse sans réponse, et signale-moi les incohérences. **Ne propose pas de solution** : laisse-moi corriger. »

Faire jouer le consommateur est le meilleur test d'un contrat : chaque question posée est une ambiguïté que tu n'avais pas vue.

Puis l'exercice sur les couches :

> « Donne-moi un fichier de routes Express de 120 lignes **où tout est mélangé** : validation, règles métier, requêtes SQL et formation de la réponse dans les fonctions de route. Ne commente pas. Ma mission : le découper en routes / contrôleurs / services / dépôts. Ensuite, vérifie une seule chose et dis-moi où j'ai échoué : **mes services contiennent-ils encore une trace de HTTP** (un code de statut, un objet `req`, un `res`) ? »

---

## 🛠️ À faire

1. **Conçois avant de coder** : pour la ressource `depenses`, écris dans `docs/api.md` le tableau complet — méthode, URL, paramètres, corps attendu, réponse, codes possibles. **Avant** toute ligne de code.
2. **Implémente les cinq routes** avec les bons codes : `201` + `Location` à la création, `204` sans corps à la suppression.
3. **Un format d'erreur unique** : définis-le, documente-le, et applique-le partout via ton middleware d'erreurs.
4. **Pagination** : `?page=&limite=`, avec une réponse enveloppée (`donnees`, `total`, `page`, `limite`) et un **plafond** côté serveur. Teste `?limite=999999`.
5. **Filtrage et tri** : `?categorie=`, `?statut=`, `?tri=-montant`. Reste cohérent.
6. **Une sous-ressource** : `GET /depenses/42/commentaires` et `POST /depenses/42/commentaires`.
7. **⭐ Découpe en quatre couches** : `routes/`, `controleurs/`, `services/`, `depots/`. Déplace la logique métier dans les services.
8. **Le test du découpage** : écris un petit script en ligne de commande qui **appelle ton service directement**, sans démarrer Express. S'il faut `req` ou `res`, le découpage est à revoir.
9. **Démontre l'erreur du `200`** : écris une route qui renvoie `200` avec `{"succes": false}`, consomme-la depuis ton application React, et constate que `r.ok` vaut `true` — donc que ton code client traite une erreur comme un succès. Puis corrige.
10. **`ARCHITECTURE.md`** : écris le document de ton projet 4 avec un schéma des couches et la règle de chacune. C'est un livrable de l'épreuve de sortie.
11. **Versionnage** : préfixe tes routes par `/api/v1` et explique dans ton journal dans quel cas tu créerais une `v2`.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Le contrat attendu, en résumé : `GET /api/v1/depenses` (200, paginé), `POST` (201 + `Location`, 400/422), `GET /:id` (200, 404), `PATCH /:id` (200, 400, 404), `DELETE /:id` (204, 404). Les champs du corps de création : `montant` (entier, centimes), `categorie`, `description`, `date`. Les champs ajoutés par le serveur : `id`, `creeLe`, `statut`.

**4.** Le plafond s'écrit côté serveur :
```ts
const limite = Math.min(Number(req.query.limite ?? 20), 100);
```
Sans lui, `?limite=999999` charge toute la table en mémoire : c'est à la fois un problème de performance et un vecteur de déni de service. C'est le genre de détail qu'un audit relève.

**8.** C'est **le** test du découpage :
```ts
// scripts/rapport.ts — aucun Express, aucun HTTP
import { serviceDepenses } from "../src/services/depenses.js";
const resultat = await serviceDepenses.lister({ page: 1, limite: 50 });
console.log(resultat.total);
```
Si ce script fonctionne, tes services sont indépendants du web — donc testables, réutilisables dans une tâche planifiée, et portables. S'il ne fonctionne pas, ta logique est prisonnière de HTTP. C'est exactement ce que Django et Laravel t'imposeront aux paliers suivants.

**9.** `fetch` ne regarde que le statut : un `200` est un succès, quel que soit le corps. Ton code client entre donc dans la branche « données » avec un corps d'erreur, et plante plus loin sur un champ absent — loin de la cause. C'est la démonstration que **le code de statut est une donnée structurelle**, pas une décoration (palier 2, leçon 09).

**11.** Les cas qui justifient une `v2` : retirer ou renommer un champ, changer le type d'un champ, modifier le sens d'un code de statut, rendre obligatoire un paramètre qui était optionnel. Les cas qui ne la justifient pas : **ajouter** un champ optionnel, ajouter une route, ajouter un filtre. La règle : on peut ajouter, on ne peut pas retirer ni changer — c'est la compatibilité ascendante, et elle devient critique au palier 9 quand des applications mobiles installées consomment ton API.
</details>

---

## ✅ Acquis si…

- [ ] Je conçois les routes d'une ressource avec les bons verbes et les bons codes, de mémoire.
- [ ] J'écris le contrat **avant** le code.
- [ ] `201` + `Location` à la création, `204` sans corps à la suppression.
- [ ] Je n'utilise **jamais** `200` pour signaler une erreur, et j'ai démontré pourquoi.
- [ ] Mon API a un format d'erreur **unique** et documenté.
- [ ] Je pagine dès la première version, avec un plafond côté serveur.
- [ ] Mon code est découpé en routes / contrôleurs / services / dépôts.
- [ ] Mes services ne contiennent **aucune** trace de HTTP, et je l'ai vérifié par un script.
- [ ] J'ai écrit `ARCHITECTURE.md` avec le schéma des couches.
- [ ] Je sais ce qui casse un contrat d'API et quand versionner.

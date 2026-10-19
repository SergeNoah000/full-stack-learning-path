# Leçon 02 — Assembler un produit multi-clients : web + mobile + API

> 🎯 **À la fin de cette leçon** : tu assembles une seule API (paliers 4-6) servant à la fois un front web (palier 3) et une app mobile (palier 9), déployée (palier 8) — la démonstration vivante que tout ton parcours forme un tout cohérent.
> ⏱️ 6 h · **Prérequis** : la leçon 01 (cadrage), et les paliers 3 (web), 4-6 (API), 7 (archi), 8 (déploiement), 9 (mobile).

---

## De quoi on parle

C'est le moment où tout se rejoint. Jusqu'ici, tu as construit des morceaux séparés : une API (paliers 4, 5 ou 6), un front web React (palier 3), une app mobile Flutter (palier 9), et tu sais déployer (palier 8). Cette leçon les **assemble** en un seul produit : **une API** qui sert **plusieurs clients** (le web et le mobile), avec une base de données partagée, le tout déployé et fonctionnel.

L'architecture cible :

```
            ┌──────────────┐     ┌──────────────┐
            │  Front web    │     │  App mobile   │
            │  (React, p.3) │     │ (Flutter, p.9)│
            └──────┬───────┘     └──────┬───────┘
                   └────────┬────────────┘
                            ▼ (HTTP/JSON, la MÊME API)
                      ┌───────────┐
                      │    API     │ (Node/Python/PHP, p.4-6)
                      └─────┬─────┘
                            ▼
                       base de données
```

Le point clé : **une seule API, plusieurs clients**. Le web et le mobile consomment les **mêmes** endpoints. C'est l'architecture de la quasi-totalité des produits réels — et ta meilleure preuve que les paliers n'étaient pas des silos, mais les pièces d'un même ensemble.

---

## À quoi ça sert, concrètement

**Parce que c'est l'architecture du monde réel.** Presque tout produit sérieux a plusieurs clients : un site web, une app iOS, une app Android, parfois des partenaires via API — tous branchés sur **une** API centrale. Savoir concevoir et assembler ça est exactement ce que font les équipes en entreprise. Ton projet final le démontre concrètement.

**Parce que l'API est le contrat partagé.** Quand plusieurs clients consomment la même API, celle-ci devient un **contrat** : si tu changes un endpoint, tu casses le web **et** le mobile. Cela impose de la rigueur (versionnement, cohérence, documentation) — et te fait comprendre pourquoi les API sont conçues avec soin. C'est le REST des paliers 4-6, vu depuis sa responsabilité réelle.

**Parce que ça prouve la cohérence de ton parcours.** Un recruteur qui voit « une API que je consomme depuis un front web ET une app mobile, déployée » comprend immédiatement que tu maîtrises la chaîne complète — pas juste un bout. C'est la démonstration la plus convaincante de ta polyvalence fullstack. C'est le projet qui raconte tout le parcours (leçon 04).

**Et parce que l'assemblage révèle les vraies questions.** Authentification partagée entre clients, CORS pour le web, format JSON commun, gestion des erreurs cohérente, déploiement coordonné : ces questions n'apparaissent que quand on assemble. Les affronter maintenant, sur ton projet, te prépare aux vrais sujets d'équipe.

---

## Où ça intervient dans le développement

L'assemblage relie tous les paliers en un produit déployé :

```
   CADRAGE (leçon 01) : le must-have décide quels clients, quels endpoints
        ▼
   API (paliers 4-6) : la source de vérité, REST, auth, base — le CONTRAT
        ├──▶ consommée par le FRONT WEB (React + TanStack Query, palier 3)
        └──▶ consommée par le MOBILE (Flutter + dio, palier 9, leçon 08)
        ▼
   DÉPLOIEMENT (palier 8) : API + web en ligne, HTTPS, mobile distribué
        ▼
   ARCHITECTURE (palier 7) : monolithe modulaire, stateless, cache si besoin
```

Trois ancrages.

**L'API est celle des paliers 4-6, désormais partagée.** Tu l'as construite pour un client ; ici, elle en sert plusieurs. Les mêmes endpoints REST (palier 4, leçon 06), la même auth (palier 4/6), la même couche Repository. Rien à réécrire — à **exposer proprement** pour plusieurs consommateurs.

**Les clients sont tes paliers 3 et 9.** Le front web (React, TanStack Query, palier 3) et l'app mobile (Flutter, dio, sérialisation, états d'écran, palier 9 leçon 08) consomment la même API. Tu réutilises ce que tu as construit, branché sur la même source.

**Et le tout se déploie avec le palier 8.** L'API et le web sont mis en ligne (Docker/Compose, Nginx, HTTPS, CI/CD — palier 8), l'app mobile est compilée et distribuée. L'architecture (palier 7 : stateless, cache) garantit que ça tient. Le projet final **est** l'assemblage de tous les paliers.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas prendre ton API (paliers 4-6), la préparer pour servir plusieurs clients (CORS pour le web, auth par jeton utilisable par les deux, format JSON cohérent), brancher ton front web (palier 3) et ton app mobile (palier 9) dessus, et déployer l'ensemble (palier 8). Tu vérifieras qu'une donnée créée sur le web apparaît sur le mobile — preuve que la source est partagée.

### En équipe, en entreprise

**L'API-centric est la norme.** Les équipes construisent une API (souvent une équipe backend) que plusieurs équipes clientes (web, iOS, Android) consomment. L'API est pensée comme un **produit** en soi, avec sa documentation, son versionnement, ses contrats. Comprendre ce découpage te situe dans n'importe quelle organisation.

**Le contrat d'API est sacré.** Changer un endpoint peut casser plusieurs clients en production. D'où le versionnement (`/v1/`, `/v2/`), la rétrocompatibilité, la communication entre équipes. Une modification d'API est un acte qui engage, pas un détail.

**L'authentification partagée demande de la réflexion.** Web et mobile s'authentifient sur la même API, mais différemment (cookies de session pour le web, jetons pour le mobile, souvent du JWT pour les deux). Concevoir une auth qui sert tous les clients est un vrai sujet (palier 4, leçon 08).

**La documentation d'API devient essentielle.** Avec plusieurs clients, une doc d'API (OpenAPI/Swagger) qui décrit chaque endpoint n'est plus un luxe : c'est le moyen pour les équipes clientes de savoir quoi consommer. On la génère et on la maintient.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : consommer une API depuis un client, respecter son contrat, gérer l'auth et les erreurs de façon cohérente entre clients.

Régulièrement : configurer CORS, concevoir des endpoints réutilisables par plusieurs clients, documenter l'API, versionner, coordonner un déploiement API + clients.

Rare au début : le *API gateway*, le GraphQL (une alternative à REST pour des clients aux besoins variés), le *Backend for Frontend* (une API par client), les contrats formels (OpenAPI avec génération de code client). À connaître de nom ; selon le contexte.

---

## La mécanique

### Une API, le contrat central

```
L'API expose des endpoints REST (palier 4, leçon 06), indépendants du client :
  GET  /depenses        → liste (consommée par web ET mobile)
  POST /depenses        → créer
  GET  /depenses/{id}   → détail
  POST /auth/login      → authentification (jeton)
Le format est le MÊME pour tous : JSON. Les clients ne savent rien de la base ;
ils connaissent le CONTRAT (les endpoints, les formats). C'est la frontière.
```

L'API est la source de vérité unique. Elle ne sait pas (et ne doit pas savoir) si celui qui l'appelle est un navigateur ou un téléphone : elle expose un contrat (endpoints + formats JSON), identique pour tous. C'est ce qui permet de brancher autant de clients qu'on veut sans rien changer côté serveur.

### ⭐ CORS : autoriser le front web

```
Le front web (React, palier 3) tourne sur un autre domaine que l'API.
Par sécurité, le navigateur BLOQUE les appels cross-origin par défaut.
→ L'API doit autoriser explicitement le domaine du front web (en-têtes CORS).
(L'app mobile, elle, n'est pas soumise au CORS — c'est une spécificité du navigateur.)
```

Le **CORS** (*Cross-Origin Resource Sharing*) est la première surprise de l'assemblage web : le navigateur empêche, par sécurité, une page d'un domaine d'appeler une API d'un autre domaine, sauf si l'API l'autorise explicitement (via des en-têtes). C'est une protection du navigateur (donc le mobile n'y est pas soumis). Configurer le CORS pour autoriser ton front web est une étape obligée — et une incompréhension classique (« ça marche avec curl et Postman mais pas depuis mon React »).

### ⭐ L'authentification partagée

```
Web et mobile s'authentifient sur la MÊME API, mais le canal diffère :
  - web    : souvent un cookie (session ou JWT en cookie httpOnly) — sûr contre le XSS
  - mobile : un jeton (JWT) stocké sur l'appareil, envoyé dans l'en-tête Authorization
L'API vérifie le jeton/la session et sait QUI fait la requête, quel que soit le client.
→ Une seule logique d'auth côté serveur, plusieurs façons de transporter l'identité.
```

L'auth (palier 4, leçon 08 ; palier 6, leçon 10) se conçoit pour servir tous les clients. Le plus courant : des jetons (JWT) que chaque client obtient à la connexion et renvoie à chaque requête. Le web peut les stocker en cookie (plus sûr côté navigateur, lien CSRF du palier 6), le mobile dans son stockage sécurisé (palier 9, leçon 09). Côté serveur, **une** logique vérifie l'identité, quel que soit le canal.

### Un format cohérent, des erreurs cohérentes

```
Tous les clients reçoivent le MÊME format :
  - succès : un JSON cohérent (mêmes noms de champs partout)
  - erreur : un format d'erreur uniforme + le bon code HTTP (palier 4, leçon 06)
    { "erreur": "Montant invalide", "champ": "montant" }  avec un 400
→ Le web et le mobile gèrent les erreurs de la même façon (états d'écran, palier 9 leçon 08).
```

Un format JSON et un format d'erreur **cohérents** permettent aux clients de traiter les réponses de la même manière. Les codes HTTP (palier 4, leçon 06) sont le langage commun : un `401` déclenche la reconnexion sur le web comme sur le mobile, un `400` affiche l'erreur de validation partout pareil. Cohérence = clients plus simples.

### Déployer l'ensemble (palier 8)

```
API + base + front web : déployés sur ton serveur (Docker/Compose, Nginx, HTTPS — palier 8).
  - l'API derrière Nginx, en HTTPS (leçon 09 du palier 8)
  - le front web servi (fichiers statiques derrière Nginx, ou hébergement dédié)
  - CORS configuré pour le domaine du front
App mobile : compilée, installée sur ton téléphone (et, pour aller plus loin, distribuée).
→ Tout EN LIGNE : c'est ce qui rend le projet démontrable (leçon 04).
```

L'assemblage n'est réel qu'une fois **en ligne**. On déploie l'API et le web avec le palier 8 (conteneurs, reverse proxy, HTTPS, CI/CD), on compile l'app mobile. Un produit déployé, avec une URL qu'on peut partager et une app qu'on peut montrer, est infiniment plus convaincant qu'un projet qui tourne « sur ma machine » (leçon 04).

### ⭐ La preuve que la source est partagée

```
Le test qui démontre l'assemblage :
  1. crée une dépense depuis le FRONT WEB
  2. ouvre l'APP MOBILE → la dépense y est
→ Les deux clients voient la même donnée parce qu'ils partagent la MÊME API et base.
C'est la démonstration vivante que ton parcours forme un tout cohérent.
```

Ce petit test est la preuve concrète de l'assemblage : une donnée créée par un client apparaît chez l'autre, car tous deux s'appuient sur la même source de vérité. C'est aussi une démo d'entretien très parlante (leçon 05).

---

## Les problèmes que tu vas rencontrer

**« Mon front web n'arrive pas à appeler l'API (erreur CORS), alors que curl marche. »** Le CORS : le navigateur bloque l'appel cross-origin. Configure l'API pour autoriser le domaine du front. C'est la surprise numéro un de l'assemblage web (et ça n'affecte pas le mobile).

**« L'auth marche sur le web mais pas sur le mobile (ou l'inverse). »** Les canaux diffèrent (cookie vs en-tête `Authorization`). Vérifie que l'API accepte le mode d'auth de chaque client, et que le client envoie bien son jeton/cookie.

**« Je change un endpoint et un client casse. »** L'API est un contrat partagé. Une modification casse tous les clients qui en dépendent. Versionne (`/v1/`), ou change les clients en même temps, ou garde la rétrocompatibilité.

**« Les formats diffèrent entre endpoints et je gère les réponses différemment partout. »** Incohérence. Uniformise le format JSON (mêmes noms de champs) et le format d'erreur (+ codes HTTP cohérents). Les clients en deviennent plus simples.

**« Ça marche en local mais pas déployé. »** Problèmes classiques du palier 8 : URL d'API en dur (`localhost`) dans les clients, CORS pour le mauvais domaine, HTTPS manquant, variables d'environnement. Reprends la check-list du palier 8.

**« Le mobile vise `localhost` et ne trouve pas l'API. »** Comme au palier 9 (leçon 08), le téléphone n'a pas le même `localhost` que ta machine. Utilise l'URL de l'API déployée (palier 8). C'est pourquoi déployer l'API tôt simplifie l'assemblage.

---

## Ce qu'on te demandera

En **entretien**, l'architecture multi-clients est un sujet qui impressionne quand tu l'as vécu : « décris l'architecture de ton projet », « comment une même API sert-elle le web et le mobile ? », « comment gères-tu l'authentification entre les deux ? », « qu'est-ce que le CORS et pourquoi ? ». Pouvoir dessiner le schéma API-centric et expliquer le contrat partagé montre une vraie compréhension système.

On peut demander : « que se passe-t-il si tu changes un endpoint ? » (le contrat, le versionnement), « pourquoi le mobile n'est pas soumis au CORS ? », « comment déploies-tu tout ça ? » (palier 8).

En **mission**, consommer et respecter le contrat d'une API, gérer CORS et auth, coordonner API et clients sont des gestes quotidiens dans toute équipe produit.

---

## Ce qui te démarquera

**Avoir réellement assemblé web + mobile + API déployés.** C'est rare chez un junior, et extrêmement convaincant. Un produit où le web et le mobile partagent la même API en ligne prouve, mieux que n'importe quel discours, que tu maîtrises la chaîne fullstack complète. C'est le projet qui résume tout ton parcours.

**Comprendre l'API comme un contrat.** Savoir qu'une API partagée engage, qu'elle se versionne, qu'elle se documente, montre une maturité système que beaucoup découvrent seulement en entreprise. Tu l'auras vécue.

**Maîtriser le CORS et l'auth multi-clients.** Ces deux sujets piègent la plupart des débutants à l'assemblage. Les comprendre et les résoudre te distingue nettement.

**Et raconter la cohérence du parcours.** Dire « voici une API que je consomme depuis un front React et une app Flutter, déployée en HTTPS avec CI/CD » relie les paliers 3, 4-6, 7, 8 et 9 en une phrase. C'est la démonstration vivante que tu es fullstack polyglotte — exactement ce que le parcours visait.

---

## 📚 À lire

**MDN → *CORS*** : l'explication de référence du CORS, pourquoi le navigateur bloque, comment l'API autorise.

**La doc REST de ton palier backend (4, 5 ou 6)** et **le concept d'API-centric / client-serveur** : relis comment ton API est structurée, maintenant vue comme contrat partagé.

**OpenAPI / Swagger (introduction)** : documenter une API pour plusieurs clients — utile dès qu'il y a plus d'un consommateur.

**JWT (jwt.io, introduction)** : le jeton d'authentification couramment utilisé pour servir web et mobile depuis une même API.

Relis le palier 4 leçon 06 (REST, codes HTTP) et leçon 08 (auth), le palier 3 (consommation d'API côté web), le palier 9 leçon 08 (consommation côté mobile), et le palier 8 (déploiement). Cette leçon les assemble tous.

---

## 🤖 Le mini-projet à demander à l'IA

Assembler ton produit multi-clients :

> « Je suis en formation de développeur, palier 10 (projet final). J'ai construit séparément une API (paliers 4-6), un front web React (palier 3) et une app mobile Flutter (palier 9), et je sais déployer (palier 8). Je veux les ASSEMBLER : une seule API servant le web ET le mobile. Sans coder à ma place, guide-moi : préparer mon API pour plusieurs clients (format JSON cohérent, format d'erreur uniforme avec codes HTTP), configurer le CORS pour autoriser mon front web (et m'expliquer pourquoi le navigateur bloque et pourquoi le mobile n'est pas concerné), et concevoir une auth par jeton utilisable par les deux clients. »

Puis le déploiement et la preuve :

> « Aide-moi à déployer l'ensemble (API + base + front web) avec ce que j'ai appris au palier 8 (Docker/Compose, Nginx, HTTPS), et à faire pointer mon app mobile sur l'API DÉPLOYÉE (pas localhost). Puis guide-moi pour LA démonstration : créer une donnée depuis le web et vérifier qu'elle apparaît sur le mobile, prouvant qu'ils partagent la même source. Explique-moi pourquoi une API est un "contrat" et ce qui se passe si je change un endpoint sans prévenir les clients. »

---

## 🛠️ À faire

1. **Le schéma** : dessine l'architecture de ton produit — une API au centre, le web et le mobile comme clients, la base derrière. Identifie le **contrat** (les endpoints partagés).
2. **⭐ Préparer l'API** : reprends ton API (paliers 4-6) et assure un format JSON **cohérent** et un format d'erreur **uniforme** (avec les bons codes HTTP, palier 4 leçon 06) pour tous les clients.
3. **⭐ CORS** : configure l'API pour autoriser ton front web. Reproduis d'abord l'erreur CORS (appel depuis React bloqué), puis corrige. Vérifie que le mobile, lui, n'est pas concerné.
4. **Brancher le web** : connecte ton front React (palier 3, TanStack Query) à l'API. Vérifie qu'il liste, crée, affiche les données.
5. **Brancher le mobile** : connecte ton app Flutter (palier 9, leçon 08, dio) à la **même** API. Gère les quatre états d'écran (palier 9).
6. **⭐ Auth partagée** : mets en place une auth par jeton utilisable par les deux clients. Connecte-toi depuis le web **et** depuis le mobile sur le même compte.
7. **Déployer** : mets l'API et le front web en ligne (palier 8 : Docker/Compose, Nginx, HTTPS), et fais pointer le mobile sur l'URL déployée (plus de `localhost`).
8. **⭐ La preuve** : crée une dépense depuis le web, ouvre le mobile, et vérifie qu'elle y apparaît. Note cette démo — elle servira en entretien (leçon 05).
9. **Le contrat** : change (prudemment) un endpoint et observe l'effet sur les deux clients. Comprends pourquoi une API est un contrat, et comment on versionne.
10. **Le lien** : dans ton journal, relie chaque partie du produit au palier qui l'a enseignée (3 web, 4-6 API, 7 archi, 8 déploiement, 9 mobile). C'est la preuve que ton parcours forme un tout.

<details>
<summary>Corrections et points de contrôle</summary>

**2 + 9.** L'API est le **contrat** partagé : dès que plusieurs clients la consomment, ses endpoints et ses formats deviennent un engagement. Un format JSON cohérent (mêmes noms de champs partout) et un format d'erreur uniforme (+ codes HTTP, palier 4 leçon 06) rendent les clients plus simples : un `401` déclenche la reconnexion partout, un `400` affiche l'erreur de validation partout pareil. Et changer un endpoint casse **tous** les clients qui en dépendent — d'où le versionnement (`/v1/`), la rétrocompatibilité, la coordination. C'est le REST des paliers 4-6 vu depuis sa vraie responsabilité.

**3.** Le CORS est la surprise classique de l'assemblage web. Le navigateur bloque, par sécurité, les appels d'une page vers une API d'un **autre domaine**, sauf si l'API l'autorise explicitement (en-têtes CORS). C'est pourquoi « ça marche avec curl/Postman mais pas depuis mon React » : curl n'est pas un navigateur. Le mobile non plus — le CORS est une protection **du navigateur**, donc l'app Flutter n'y est pas soumise. Configurer le CORS pour le domaine du front est une étape obligée.

**6.** L'auth partagée : une seule logique côté serveur (vérifier qui fait la requête), plusieurs canaux de transport. Le plus courant est le jeton (JWT), obtenu à la connexion et renvoyé à chaque requête — le web peut le stocker en cookie (plus sûr côté navigateur, lien CSRF palier 6), le mobile dans son stockage sécurisé (palier 9 leçon 09). L'API vérifie l'identité quel que soit le client. C'est l'auth des paliers 4/6, conçue pour plusieurs consommateurs.

**8 + 10.** La preuve vivante : une dépense créée sur le web apparaît sur le mobile, car les deux partagent la **même** API et la même base. Ce petit test démontre, mieux qu'un long discours, que ton produit est réellement multi-clients — et que les paliers n'étaient pas des silos. Relier chaque partie à son palier (web/p.3, API/p.4-6, archi/p.7, déploiement/p.8, mobile/p.9) est la narration de ton parcours entier : tu es fullstack polyglotte, et ce produit en est la démonstration concrète, en ligne, démontrable (leçon 04) et racontable en entretien (leçon 05).
</details>

---

## ✅ Acquis si…

- [ ] Je dessine une architecture API-centric : une API, plusieurs clients, une base partagée.
- [ ] Je prépare mon API pour plusieurs clients (format JSON et format d'erreur cohérents).
- [ ] Je configure le CORS pour mon front web et je sais pourquoi le mobile n'y est pas soumis.
- [ ] Je branche mon front web (palier 3) et mon app mobile (palier 9) sur la même API.
- [ ] Je mets en place une authentification par jeton utilisable par les deux clients.
- [ ] Je déploie l'API et le web (palier 8) et je fais pointer le mobile sur l'URL déployée.
- [ ] Je démontre le partage de source (donnée créée sur le web, visible sur le mobile).
- [ ] Je comprends l'API comme un contrat, et je relie chaque partie au palier qui l'a enseignée.

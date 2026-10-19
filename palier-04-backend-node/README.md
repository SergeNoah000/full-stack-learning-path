# Palier 4 — Backend #1 : Node.js/TypeScript + SQL

> 🎯 **Objectif** : apprendre LES CONCEPTS du backend une fois pour toutes, dans un langage déjà maîtrisé. Tout ce palier se transfère à Python (palier 5) et PHP (palier 6). C'est ici que tu deviens fullstack.
> ⏱️ **Volume indicatif** : 8 à 12 semaines (80–120 h). *Le checkpoint est la mesure, pas le calendrier.*
> 📍 **Prérequis** : [épreuve du palier 3](../palier-03-react-typescript/evaluation.md) réussie.

## 🎓 Ce que tu sauras faire à la fin

1. Écrire un serveur HTTP sans framework, et nommer ce qu'un framework apporte.
2. Construire une API Express structurée avec middlewares et gestion d'erreurs centralisée.
3. Concevoir une API **REST** : ressources, verbes, codes de statut.
4. Valider toute entrée côté serveur et gérer la configuration par variables d'environnement.
5. Écrire du **SQL à la main**, `JOIN` compris, et modéliser des relations 1-N et N-N.
6. Créer et versionner des **migrations**, utiliser un ORM sans en être prisonnier.
7. Implémenter une authentification complète (hachage, sessions **et** JWT) et une autorisation par rôle.
8. Démontrer puis corriger une injection SQL et une XSS sur ton propre code.
9. Écrire des tests unitaires et d'intégration, et justifier ce que tu ne testes pas.
10. Découper une application en couches : routes → contrôleurs → services → données.
11. Déployer une API avec sa base de données managée.

## 📘 Les leçons

👉 **[Plan détaillé et conseils de travail](lecons/README.md)** — les 10 leçons sont rédigées.

| # | Leçon | Volume |
|---|-------|--------|
| 01 | [Le serveur HTTP nu : comprendre avant le framework](lecons/01-le-serveur-http-nu.md) | 4 h |
| 02 | [Express : routes, paramètres, middlewares](lecons/02-express-routes-middlewares.md) | 5 h |
| 03 | [Concevoir une API REST : ressources, verbes, codes](lecons/03-concevoir-une-api-rest.md) | 4 h |
| 04 | [Validation (Zod), erreurs centralisées, configuration et secrets](lecons/04-validation-erreurs-configuration.md) | 4 h |
| 05 | [SQL : les bases, les agrégats, et les `JOIN`](lecons/05-sql-les-bases-et-les-joins.md) | 6 h |
| 06 | [Modélisation relationnelle, relations N-N, index](lecons/06-modelisation-relations-index.md) | 5 h |
| 07 | [ORM et migrations (Prisma)](lecons/07-orm-et-migrations.md) | 5 h |
| 08 | [Authentification : sessions, JWT, hachage des mots de passe](lecons/08-authentification.md) | 5 h |
| 09 | [Sécurité : l'OWASP Top 10 en pratique](lecons/09-securite-owasp.md) | 5 h |
| 10 | [Tests unitaires et d'intégration (Vitest + Supertest)](lecons/10-tests.md) | 4 h |

## Module 1 : Le serveur HTTP nu (comprendre avant le framework)

- [ ] Créer un serveur avec le module natif `node:http` : parser l'URL à la main, router avec un `if/else`, renvoyer du JSON.
- [ ] Constat à faire toi-même : « gérer les routes, le corps de requête, les erreurs à la main, c'est pénible » → **c'est exactement ce qu'un framework résout**. (Tu referas ce même exercice en Python et en PHP — même leçon, trois langages.)

## Module 2 : Express — l'API structurée

- [ ] Routes, paramètres (`:id`), query string, corps JSON.
- [ ] **Middlewares** : le concept clé (logging, auth, erreurs) — comprendre l'ordre d'exécution.
- [ ] Conception **REST** : ressources, verbes HTTP, codes de statut, nommage des endpoints.
- [ ] Validation des entrées avec **Zod** ; gestion d'erreurs centralisée ; variables d'environnement (`.env` + `.gitignore` — **les secrets ne vont jamais dans Git, à vie**).
- [ ] Tester ses endpoints avec **Bruno** ou Postman.

## Module 3 : SQL & bases de données — le socle commun à tous les backends

- [ ] Installer **PostgreSQL** (localement ou Docker si le référent le suggère).
- [ ] SQL sérieusement : `SELECT`, `WHERE`, `ORDER BY`, `INSERT/UPDATE/DELETE`, **`JOIN`** (le point dur — insister), `GROUP BY` + agrégats, index, clés étrangères.
- [ ] Pratique dédiée : **pgexercises.com** ou SQLBolt — jusqu'à l'aisance.
- [ ] Modélisation : entités, relations 1-N et N-N (table de jointure), normalisation (l'intuition).
- [ ] ORM : **Prisma** — schéma, **migrations**, requêtes, relations. Retiens les *concepts* (ORM, migration) : tu les retrouveras sous d'autres noms (Django ORM, Eloquent).
- [ ] Aperçu NoSQL : quand Redis ou MongoDB ont du sens (et quand non).
- ⚠️ *Le SQL appris ici servira tel quel avec Django et Laravel. C'est l'investissement le plus rentable du palier.*

## Module 4 : Authentification & sécurité — concepts universels

- [ ] Sessions vs **JWT** : les deux modèles, leurs compromis.
- [ ] Hachage de mots de passe (**bcrypt** ou argon2) — jamais de mot de passe en clair, jamais.
- [ ] Cookies httpOnly, CORS (comprendre l'erreur que tu vas forcément rencontrer).
- [ ] **OWASP Top 10** en pratique : injection SQL (démontre-la sur ton propre code non protégé !), XSS, CSRF.
- [ ] Autorisation : rôles, middleware de protection de routes.

## Module 5 : Tests

- [ ] Unitaires (logique métier) et intégration (routes) : **Vitest** + Supertest.
- [ ] Quoi tester en priorité : la logique métier et les routes critiques (auth, paiement). Pas 100% de couverture — du jugement.

## Module 6 : 🛠️ Projet 4 — Application fullstack complète

Voir [projet.md](projet.md). Premier **cahier des charges complet**, estimation d'effort, déploiement sur **Render**.

## 🏗️ Fil rouge Architecture — niveau 3 : les couches

- **Routes → contrôleurs → services → accès aux données.** Applique ce découpage au projet 4 et documente-le dans un `ARCHITECTURE.md` (schéma inclus).
- *Ce découpage est exactement ce que Django (MVT) et Laravel (MVC) t'imposeront aux paliers suivants — tu comprendras POURQUOI ils sont faits ainsi, et tu le construiras toi-même à la main en PHP.*

## 📋 Fil rouge Gestion de projet

- Nouveautés : **cahier des charges complet** (modèle dans [../gestion-de-projet.md](../gestion-de-projet.md)), jalons, **estimation d'effort par tâche + mesure du réel** (ta première donnée de vélocité), journal des risques.

## 🤖 Fil rouge IA — niveau 4 : le binôme

- Claude Code (ou équivalent) en pair programming : tu décris la fonctionnalité, vous discutez de l'approche, **TU** décides, l'IA aide à implémenter, TU relis tout.
- Nouveau réflexe : faire **générer les tests** par l'IA, puis les lire, les comprendre et les compléter.

## 🧑‍🏫 Référent

- **Revue de code sérieuse du projet 4** — ta première vraie code review, moment clé du parcours. Accueille les critiques : c'est le format du métier.
- Lui présenter ton cahier des charges et ton estimation AVANT de coder ; comparer ensemble estimé vs réel APRÈS.

## ✅ Checkpoint de sortie

- [ ] Je crée une API REST avec auth et BDD **de zéro, sans tutoriel**.
- [ ] J'écris du SQL de base (JOIN inclus) **sans ORM**.
- [ ] Je peux expliquer sessions vs JWT et montrer une injection SQL (et sa parade).
- [ ] Projet 4 déployé sur **Render**, testé, documenté (README + ARCHITECTURE.md), revu par le référent.

### 🚦 [Passer l'épreuve de sortie →](evaluation.md)

> Les objectifs ci-dessus sont **vérifiés** par l'épreuve, pas auto-déclarés. Tant qu'elle n'est pas réussie, le palier suivant reste fermé.

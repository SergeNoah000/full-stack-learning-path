# Palier 4 — Backend #1 : Node.js/TypeScript + SQL

> 🎯 **Objectif** : apprendre LES CONCEPTS du backend une fois pour toutes, dans un langage déjà maîtrisé. Tout ce palier se transfère à Python (palier 5) et PHP (palier 6). C'est ici que tu deviens fullstack.

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

# Palier 6 — Backend #3 : PHP (natif + Apache/.htaccess → MVC maison → Laravel)

> 🎯 **Objectif** : le langage le plus présent sur le web en volume (WordPress, Laravel, des millions de sites sur mesure) — très demandé en missions freelance et projets locaux. **Ici encore : le natif d'abord.** Tu vivras toute l'expérience PHP — Apache, `.htaccess`, superglobales, PDO — et tu construiras un MVC complet à la main (router, modèles, vues) AVANT de toucher Laravel.

## Module 1 : L'environnement PHP réel — Apache & le modèle d'exécution

- [ ] Installer une stack **LAMP** locale (Linux + Apache + MySQL/MariaDB + PHP) — pas un outil tout-en-un : chaque brique à la main, pour comprendre.
- [ ] **Le modèle d'exécution PHP** : un processus par requête, tout meurt à la fin de la requête — radicalement différent de Node (processus persistant). Comprendre cette différence est un vrai apprentissage d'architecture (état, connexions BDD, variables globales…).
- [ ] Apache : VirtualHosts, `DocumentRoot`, logs d'erreurs (`/var/log/apache2/`), mod_php vs **php-fpm**.
- [ ] **`.htaccess`** — à maîtriser, c'est partout dans le monde PHP :
  - `RewriteEngine` / `RewriteRule` : la réécriture d'URL (`/article/42` → `index.php?id=42`) ;
  - **le pattern front controller** : tout rediriger vers un unique `index.php` (la base de TOUS les frameworks PHP) ;
  - interdire l'accès à un dossier (`Deny from all` / `Require all denied`), pages d'erreur personnalisées, redirections 301.
- 📚 php.net (la référence, commentaires inclus) ; doc Apache mod_rewrite.

## Module 2 : Le langage PHP moderne (≥ 8.x)

- [ ] Oublie la mauvaise réputation : PHP 8 est un bon langage (typage, `match`, arrow functions, enums, attributs).
- [ ] Syntaxe, **tableaux associatifs** (le couteau suisse PHP), fonctions (`array_map`/`array_filter` = tes `map`/`filter`), classes, interfaces, namespaces.
- [ ] Les **superglobales** : `$_GET`, `$_POST`, `$_SERVER`, `$_SESSION`, `$_COOKIE`, `$_FILES` — c'est l'API brute du web, sans intermédiaire.
- [ ] Sessions et cookies à la main ; upload de fichiers (et ses pièges de sécurité).
- [ ] **PDO** + requêtes préparées (jamais de concaténation SQL — tu sais pourquoi depuis le palier 4).
- [ ] **Composer** : dépendances (ton `npm`/`pip`) et **autoloading PSR-4**.
- [ ] 🧩 Les katas passent en PHP.

## Module 3 : 🛠️ Projet 6a — L'app MVC construite à la main

> Le cœur du palier : une application native mais STRUCTURÉE — front controller, router, contrôleurs, modèles, vues — écrite par toi. Détail complet dans [projet.md](projet.md).

Progression de construction :
1. [ ] **Version « à l'ancienne » d'abord** (un fichier PHP par page, HTML mélangé au SQL) sur un livre d'or — pour ressentir le problème. Des milliers de sites existants sont écrits comme ça : les missions de maintenance, c'est ça.
2. [ ] **Front controller** : `.htaccess` qui redirige tout vers `public/index.php`.
3. [ ] **Router maison** : parser `REQUEST_URI`, table de routes (méthode + motif + action), paramètres d'URL.
4. [ ] **Contrôleurs** : une classe par ressource, une méthode par action.
5. [ ] **Modèles** : classes d'accès aux données via PDO (pattern Repository simple).
6. [ ] **Vues** : templates PHP (`extract()` + include), layout commun, échappement systématique (`htmlspecialchars` — anti-XSS).
7. [ ] **Auth maison** : inscription, connexion, sessions, protection CSRF (token en formulaire).
8. [ ] Autoloader PSR-4 (d'abord écrit à la main, puis via Composer).

Bilan écrit : « qu'ai-je construit ? » → router, ORM naissant, moteur de vues, auth, CSRF… **c'est un framework.** Laravel n'aura plus rien de magique.

## Module 4 : Laravel — le framework roi de PHP

- [ ] Routing, contrôleurs, middleware — *tu viens de les écrire, tu les reconnais.*
- [ ] **Eloquent** (ORM, pattern Active Record — compare à Prisma et Django ORM : 3 philosophies), migrations, seeders.
- [ ] **Blade** (templates), validation, auth (**Breeze**), autorisation (policies).
- [ ] **Artisan** (CLI) : générateurs, `tinker` ; files d'attente (queues) et tâches planifiées — concepts nouveaux, note-les pour le palier architecture.
- [ ] 🛠️ Exercice de mesure : **réimplémenter le projet 6a en Laravel** — chronomètre la différence. C'est ça, la valeur d'un framework, et tu sauras désormais la chiffrer (utile pour les devis !).
- 📚 laravel.com/docs (excellente) ; Laracasts (des séries gratuites).

## Module 5 : 🛠️ Projet 6b — Application métier livrable + posture client

Voir [projet.md](projet.md) : une app de qualité « je pourrais la vendre », avec **devis** et **le référent dans le rôle du client**. Déploiement sur **hébergement mutualisé (cPanel) ou VPS Apache** — accès via le référent : le monde réel de PHP (SFTP, phpMyAdmin, `.htaccess` actif).

## Module 6 : Aperçu WordPress (optionnel mais lucratif)

- [ ] Comprendre l'écosystème : thèmes, plugins, hooks (actions/filtres) — pas pour en faire ta spécialité, mais une part énorme des missions freelance locales passe par là. Avec ton PHP natif, tu apprendras sur le tas si une mission se présente.

## 🏗️ Fil rouge Architecture — la synthèse des trois stacks

- Complète ton comparatif : **Express vs Django vs Laravel** (+ tes 2 frameworks maison) — injection de dépendances, 3 philosophies d'ORM (Data Mapper vs Active Record), templates vs API+SPA, convention vs configuration, modèle d'exécution (processus persistant vs par requête).
- Tu peux désormais répondre à LA question d'architecte : *« pour ce projet précis, quelle stack et pourquoi ? »* (prototype rapide → Laravel/Django ; API temps réel → Node ; data/IA → Python ; équipe existante → leur stack).

## 📋 Fil rouge Gestion de projet — la posture client

- Nouveautés sur le projet 6b : **devis** (jours × taux + hébergement + domaine + marge 20%), **proposition commerciale** (2 pages), gestion du **changement de périmètre** — le référent, en client, changera d'avis en cours de route : c'est l'exercice.
- Méthode de chiffrage dans [../gestion-de-projet.md](../gestion-de-projet.md).

## 🤖 Fil rouge IA

- Plein régime « accélérateur de langages » : « l'équivalent idiomatique en PHP 8 / Laravel de ce que je fais en JS/Python ».
- Garde-fou : l'IA n'écrit ni ton router maison ni ton auth maison (modules 2–3) — c'est là que se joue la compréhension.

## 🧑‍🏫 Référent

- Revue du **projet 6a** (le MVC maison) : le livrable le plus révélateur du palier.
- **Jouer le client** du projet 6b : exigences floues au départ, changement d'avis en cours de route, négociation du devis.
- Fournir l'accès à l'hébergement Apache (mutualisé ou VPS) le moment venu.

## ✅ Checkpoint de sortie

- [ ] J'explique le modèle d'exécution PHP vs Node, et je sais écrire une règle `.htaccess` (rewrite + protection de dossier) sans copier-coller.
- [ ] Mon MVC maison fonctionne : router, contrôleurs, modèles PDO, vues échappées, auth avec CSRF — et je peux en expliquer chaque ligne.
- [ ] CRUD Laravel complet avec auth, sans tutoriel.
- [ ] Projet 6b déployé sur un hébergement Apache réel, devis rédigé et défendu face au « client ».
- [ ] Comparatif des 3 stacks (+ 2 frameworks maison) rédigé.

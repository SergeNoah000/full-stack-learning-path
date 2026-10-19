# Palier 2 — Frontend : HTML, CSS, JavaScript navigateur

> 🎯 **Objectif** : construire des pages web complètes, belles et interactives, à la main. Quel que soit le backend plus tard (Node, Python ou PHP), le frontend, c'est TOUJOURS ça.
> ⏱️ **Volume indicatif** : 5 à 8 semaines (50–80 h). *Le checkpoint est la mesure, pas le calendrier.*
> 📍 **Prérequis** : [épreuve du palier 1](../palier-01-programmer-javascript/evaluation.md) réussie — tu sais programmer.

## 🎓 Ce que tu sauras faire à la fin

1. Écrire du HTML **sémantique** et accessible, validé sans erreur.
2. Construire un formulaire complet avec validation native et JS, utilisable au clavier.
3. Maîtriser le box model, la spécificité et les unités CSS.
4. Mettre en page avec **Flexbox** et **Grid**, et savoir lequel choisir.
5. Rendre une page **responsive mobile-first** de 320 px à 1920 px.
6. Reproduire une maquette depuis une capture d'écran, sans framework CSS ni tutoriel.
7. Manipuler le DOM : sélectionner, créer, modifier, supprimer.
8. Gérer les événements, dont la **délégation**, et les formulaires côté client.
9. Consommer une API dans le navigateur en traitant les états chargement / erreur / données.
10. Persister des préférences avec `localStorage`, et connaître ses limites.
11. Séparer les responsabilités : appels réseau, DOM, logique, dans des fichiers distincts.
12. Déployer un site statique et en donner l'URL publique.

## 📘 Les leçons

👉 **[Plan des 9 leçons du palier](lecons/README.md)** — ⏳ leçons en cours de rédaction ; en attendant, travaille les modules ci-dessous avec les [ressources du palier](../ressources.md) et prépare l'[épreuve de sortie](evaluation.md), qui est complète.

## Module 1 : HTML

- [ ] HTML **sémantique** : `header`, `nav`, `main`, `section`, `article`, `footer` — pas des `div` partout.
- [ ] Formulaires : `input` (tous types), `select`, `textarea`, `label`, validation native.
- [ ] Images, liens, tableaux, listes.
- [ ] Accessibilité de base : `alt`, labels reliés, hiérarchie des titres (un seul `h1`).
- 📚 *The Odin Project → HTML Foundations* ; MDN pour chaque balise.

## Module 2 : CSS

- [ ] Modèle de boîte (box model), sélecteurs, spécificité, unités (`rem`, `%`, `vh/vw`).
- [ ] **Flexbox** puis **Grid** — pratiquer avec Flexbox Froggy et Grid Garden.
- [ ] Responsive **mobile-first** : media queries.
- [ ] Transitions, transformations, animations simples.
- [ ] 🛠️ **3 intégrations imposées** (sans framework CSS) : une landing page, un formulaire de connexion, une grille de cartes produits — chacune reproduite depuis une capture d'écran d'un vrai site, chacune dans un repo.
- 📚 *The Odin Project → CSS* ; css-tricks.com (guides Flexbox/Grid).

## Module 3 : JavaScript dans le navigateur

- [ ] DOM : sélectionner (`querySelector`), créer/modifier/supprimer des éléments.
- [ ] Événements : `click`, `submit`, `input`, délégation d'événements.
- [ ] Formulaires : lire les valeurs, valider côté client, afficher les erreurs.
- [ ] `localStorage` : persister des préférences.
- [ ] `fetch` + affichage dynamique de données d'API dans la page (tu l'as fait en Node au palier 1 — même chose, dans le navigateur).
- [ ] DevTools : onglets Éléments, Console, Réseau — tes outils quotidiens désormais.

## Module 4 : 🛠️ Projet 2 — Application météo

Voir [projet.md](projet.md). **Première apparition du fil rouge gestion de projet** (mini-cadrage 1 page) et **premier déploiement** (GitHub Pages).

## 🏗️ Fil rouge Architecture — niveau 1 : séparer les responsabilités

- Dans le projet 2 : un fichier pour les appels API, un pour la manipulation du DOM, un pour la logique.
- Question réflexe à te poser désormais sur tout code : *« si je change l'API, combien de fichiers je dois toucher ? »*

## 📋 Fil rouge Gestion de projet — introduction

- Avant de coder le projet 2 : **mini-cadrage d'1 page** (objectif, utilisateurs, fonctionnalités must/nice-to-have, maquette papier) + un `TODO.md` de suivi.
- Détail dans [../gestion-de-projet.md](../gestion-de-projet.md).

## 🤖 Fil rouge IA — niveau 2 : le relecteur

- Nouveau droit : demander une **code review** à l'IA (« lisibilité, bugs, bonnes pratiques ») — **après** avoir fini, jamais avant.
- Autorisé aussi : générer des jeux de données de test (villes fictives, faux produits).
- Toujours interdit : lui faire produire le code.

## 🧑‍🏫 Référent

- Revue rapide du projet 2 : structure des fichiers, nommage, HTML sémantique.
- Lui montrer ton mini-cadrage : 5 min de feedback d'un senior sur un cadrage t'apprendra plus que 3 articles.

## ✅ Checkpoint de sortie

- [ ] J'intègre une maquette simple (capture d'écran → page responsive) sans tutoriel.
- [ ] Flexbox et Grid sans documentation pour les cas courants.
- [ ] Projet 2 **en ligne sur GitHub Pages**, URL dans mon profil GitHub.
- [ ] Mini-cadrage rédigé AVANT le code (vérifiable dans l'historique Git).

### 🚦 [Passer l'épreuve de sortie →](evaluation.md)

> Les objectifs ci-dessus sont **vérifiés** par l'épreuve, pas auto-déclarés. Tant qu'elle n'est pas réussie, le palier suivant reste fermé.

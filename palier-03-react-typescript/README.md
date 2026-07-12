# Palier 3 — Frontend moderne : React + TypeScript

> 🎯 **Objectif** : maîtriser l'outil frontend le plus demandé du marché. Il servira de client à TOUS tes backends (Node, Python, PHP).

## Module 1 : TypeScript d'abord

- [ ] Types de base, `interface` / `type`, unions, optionnels, génériques (l'intuition).
- [ ] `tsconfig.json` de base, compilation, `strict: true` dès le début.
- [ ] 🛠️ Exercice de transfert : **refactoriser le projet 1** (CLI dépenses) en TypeScript — typer un code existant est le meilleur apprentissage du typage.
- 📚 Doc officielle TypeScript (*Handbook*) ; totaltypescript.com (tutoriels gratuits).

## Module 2 : React fondamentaux

- [ ] Créer un projet avec **Vite** (pas Create React App, obsolète).
- [ ] Composants, props, JSX, rendu conditionnel, listes et clés.
- [ ] État : `useState`, remontée d'état (*lifting state up*).
- [ ] Effets : `useEffect` — et surtout **quand ne pas l'utiliser** (calculs dérivés = pas d'effet).
- [ ] Formulaires contrôlés, composition de composants (`children`).
- 📚 **react.dev** (le nouveau tutoriel officiel est excellent) ; *The Odin Project → React*.

## Module 3 : React intermédiaire

- [ ] **React Router** : navigation multi-pages, paramètres d'URL.
- [ ] Context API : quand (thème, utilisateur connecté) et quand pas (tout le reste).
- [ ] Custom hooks : extraire la logique réutilisable.
- [ ] **TanStack Query** : données serveur, cache, états loading/error.
- [ ] **Tailwind CSS** : le standard actuel du styling en entreprise.

## Module 4 : 🛠️ Projet 3 — Clone d'une app connue

Voir [projet.md](projet.md). Gestion de projet enrichie (user stories, Figma, kanban) et déploiement sur **Vercel**.

## 🏗️ Fil rouge Architecture — niveau 2

- Structure de dossiers **par feature** (pas par type de fichier).
- Composants « présentation » vs « conteneur » ; la logique métier vit HORS des composants (fonctions pures importées).

## 📋 Fil rouge Gestion de projet

- Nouveautés sur le projet 3 : **user stories** (« en tant que… je veux… afin de… »), **maquette Figma** simple, **kanban GitHub Projects**, tâches découpées à < 2h.
- Détail dans [../gestion-de-projet.md](../gestion-de-projet.md).

## 🤖 Fil rouge IA — niveau 3 : l'autocomplétion entre en jeu

- **Maintenant** (pas avant) : activer **GitHub Copilot** — gratuit via le **GitHub Student Developer Pack** avec ton email universitaire : demande-le dès aujourd'hui (education.github.com). Ou Claude Code en mode assisté.
- Règle : l'IA complète le *boilerplate* (répétitif), TOI tu écris la logique.
- Suggestion acceptée non comprise = supprimée, puis expliquée, puis retapée.

## 🧑‍🏫 Référent

- Revue du projet 3 : découpage des composants, gestion de l'état (« pourquoi cet état est ici et pas là ? »).
- Lui montrer ton kanban : un senior repère en 1 min des tâches mal découpées.

## ✅ Checkpoint de sortie

- [ ] Je crée une app React multi-pages avec appels API **sans tutoriel**.
- [ ] TypeScript strict sur tout nouveau code, sans exception.
- [ ] Je sais expliquer `useState` vs `useEffect` vs TanStack Query (quel outil pour quel problème).
- [ ] Projet 3 déployé sur **Vercel**, kanban terminé, user stories toutes livrées ou explicitement abandonnées.

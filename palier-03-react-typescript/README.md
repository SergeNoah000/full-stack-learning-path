# Palier 3 — Frontend moderne : React + TypeScript

> 🎯 **Objectif** : maîtriser l'outil frontend le plus demandé du marché. Il servira de client à TOUS tes backends (Node, Python, PHP).
> ⏱️ **Volume indicatif** : 5 à 8 semaines (50–80 h). *Le checkpoint est la mesure, pas le calendrier.*
> 📍 **Prérequis** : [épreuve du palier 2](../palier-02-frontend-web/evaluation.md) réussie — HTML, CSS et DOM maîtrisés.

## 🎓 Ce que tu sauras faire à la fin

1. Typer du code existant en TypeScript `strict`, sans aucun `any`.
2. Utiliser interfaces, unions discriminées et génériques à bon escient.
3. Construire des composants React avec props et composition.
4. Placer l'état au bon niveau (`useState`, remontée d'état) et ne jamais le muter.
5. Utiliser `useEffect` correctement — et savoir les cas où il ne faut pas l'utiliser.
6. Gérer listes, clés et formulaires contrôlés.
7. Naviguer avec React Router, utiliser Context là où c'est justifié, extraire des custom hooks.
8. Gérer l'état serveur avec TanStack Query et styliser avec Tailwind.
9. Organiser un projet **par feature**, logique métier hors des composants.
10. Livrer et déployer une SPA multi-pages consommant une API.

## 📘 Les leçons

👉 **[Plan détaillé et conseils de travail](lecons/README.md)** — les 8 leçons sont rédigées.

| # | Leçon | Volume |
|---|-------|--------|
| 01 | [TypeScript : types de base, inférence, `strict`](lecons/01-typescript-les-bases.md) | 4 h |
| 02 | [TypeScript : `interface`/`type`, unions, génériques](lecons/02-typescript-interfaces-unions-generiques.md) | 4 h |
| 03 | [React : composants, JSX, props](lecons/03-react-composants-jsx-props.md) | 4 h |
| 04 | [L'état : `useState` et remontée d'état](lecons/04-etat-usestate.md) | 5 h |
| 05 | [Les effets : `useEffect`, et quand ne pas l'utiliser](lecons/05-effets-useeffect.md) | 4 h |
| 06 | [Listes, clés, rendu conditionnel, formulaires contrôlés](lecons/06-listes-cles-formulaires.md) | 4 h |
| 07 | [React Router, Context, custom hooks](lecons/07-router-context-hooks.md) | 5 h |
| 08 | [TanStack Query et Tailwind CSS](lecons/08-tanstack-query-tailwind.md) | 5 h |

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

### 🚦 [Passer l'épreuve de sortie →](evaluation.md)

> Les objectifs ci-dessus sont **vérifiés** par l'épreuve, pas auto-déclarés. Tant qu'elle n'est pas réussie, le palier suivant reste fermé.

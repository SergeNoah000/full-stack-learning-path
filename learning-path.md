# 🛤️ Learning Path — Vue d'ensemble

> **Profil** : débutant total → développeur fullstack polyglotte
> **Stack** : JavaScript/TypeScript · Python (natif → Flask, FastAPI, Django) · PHP (natif + Apache/.htaccess → Laravel) · Flutter/Dart · Architecture · DevOps · IA · Gestion de projet
> **Méthode** : autodidacte + IA + web + référent senior — voir [methode-et-referent.md](methode-et-referent.md)
> **Progression** : par paliers validés par checkpoints. Le temps n'est pas la mesure ; le checkpoint l'est.

## La logique du parcours

1. **Les concepts d'abord, les langages ensuite.** HTTP, SQL, l'authentification, le MVC sont les mêmes partout. Appris une fois en profondeur (paliers 1–4), chaque nouveau langage devient une question de syntaxe et d'écosystème.
2. **Un langage à fond avant d'élargir.** JavaScript en premier (seul langage du navigateur, donc incontournable), puis Python, PHP et Dart s'ajoutent SUR ces fondations.
3. **Le natif avant le framework.** Pour Python et PHP, tu construiras d'abord sans framework (WSGI maison, PHP natif + .htaccess, MVC fait main avec router/modèles/vues) pour comprendre exactement ce que Flask, Django et Laravel automatisent. Un dev qui connaît le dessous des frameworks débogue ce que les autres subissent.
4. **Chaque projet se déploie**, sur une plateforme différente à chaque fois (GitHub Pages → Vercel → Render → AWS free tier → VPS du référent) — voir [deploiements.md](deploiements.md).
5. **La gestion de projet grandit avec toi** : d'une page d'objectifs (palier 2) à un cycle complet conception → cahier des charges → devis → suivi → recette (palier 10) — voir [gestion-de-projet.md](gestion-de-projet.md).

## Les paliers

| # | Palier | Contenu clé | Projet jalon | Déploiement |
|---|--------|-------------|--------------|-------------|
| 0 | [Fondations](palier-00-fondations/README.md) | Machine, terminal, Git, comment le web fonctionne | — | — |
| 1 | [Programmer (JS)](palier-01-programmer-javascript/README.md) | Logique, algo, asynchrone | CLI dépenses | GitHub (code) |
| 2 | [Frontend web](palier-02-frontend-web/README.md) | HTML, CSS, JS navigateur | App météo | **GitHub Pages** |
| 3 | [React + TypeScript](palier-03-react-typescript/README.md) | SPA moderne | Clone d'app connue | **Vercel** |
| 4 | [Backend #1 : Node.js](palier-04-backend-node/README.md) | REST, SQL, auth, sécurité, tests — les concepts, une fois pour toutes | App fullstack | **Render** |
| 5 | [Backend #2 : Python](palier-05-backend-python/README.md) | Le langage → WSGI/mini-framework maison → Flask → FastAPI → Django | App de gestion Django | **AWS free tier** |
| 6 | [Backend #3 : PHP](palier-06-backend-php/README.md) | PHP natif + Apache/.htaccess → MVC maison (router, modèles, vues) → Laravel | MVC maison **et** app métier Laravel | **Mutualisé/VPS Apache** (référent) |
| 7 | [Architecture](palier-07-architecture/README.md) | SOLID, patterns, system design, comparatif des 3 stacks | Document d'architecture | — |
| 8 | [DevOps](palier-08-devops/README.md) | Linux, Docker, CI/CD, monitoring, coûts d'infra | Les 3 backends dockerisés + pipeline | **VPS** (référent) |
| 9 | [Mobile Flutter](palier-09-mobile-flutter/README.md) | Dart, widgets, état, hors-ligne | App mobile sur ton backend | APK / Play Store |
| 10 | [Projet final & emploi](palier-10-projet-final-emploi/README.md) | Produit complet + portfolio + entretiens | Produit avec vrais utilisateurs | **VPS + domaine** |

**Pourquoi cet ordre pour les backends ?** Node d'abord : tu connais déjà JS, tu apprends donc les *concepts* backend sans apprendre un langage en même temps. Python ensuite : écart de syntaxe faible, écosystème énorme (web + data + IA). PHP en dernier : avec deux backends en poche il s'apprend vite — et il reste massivement demandé (WordPress ~40% du web, missions freelance et projets locaux en pagaille).

## Les fils rouges (transversaux, présents dans chaque palier)

- 🤖 **IA** — d'abord tuteur, puis relecteur, autocomplétion, binôme, accélérateur de langages, sparring partner, et enfin brique de tes produits. Tableau complet dans [methode-et-referent.md](methode-et-referent.md).
- 🏗️ **Architecture** — de "séparer les responsabilités" (palier 2) au comparatif Express vs Django vs Laravel (palier 6) jusqu'au system design (palier 7).
- 📋 **Gestion de projet** — introduite au palier 2, enrichie à chaque projet : voir [gestion-de-projet.md](gestion-de-projet.md).
- 🧩 **Algo** — 2 katas de 30 min/semaine dès le palier 1 ; change de langage à chaque nouveau palier linguistique (JS → TS → Python → PHP → Dart).
- 📝 **Anglais technique** — doc, erreurs, commits.

## ⚠️ Les 6 pièges qui font échouer ce genre de parcours

1. **L'enfer des tutoriels** : regarder sans construire. Antidote : "1 tuto → 1 variation personnelle".
2. **Le zapping de langages** : commencer Python avant de valider le checkpoint JS. Antidote : l'ordre des paliers n'est pas négociable jusqu'au palier 4.
3. **Le syndrome du comparateur** : débattre "Django vs Laravel" au lieu de coder. Antidote : tu les apprendras TOUS, dans l'ordre prévu.
4. **Le projet parfait** : s'éterniser. Antidote : timeboxer, livrer, itérer.
5. **L'IA-béquille** : générer sans comprendre. Antidote : le fil rouge IA gradué.
6. **L'isolement** : le référent + les communautés (GDG, Discords) dès le début — et le point "juste pour parler" quand ça flanche.

---
*v3 — structure en dossiers, natif avant framework, gestion de projet et déploiements variés intégrés.*

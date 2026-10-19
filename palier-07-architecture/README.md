# Palier 7 — Architecture logicielle

> 🎯 **Objectif** : passer de « ça marche » à « c'est bien conçu ». Ton profil trilingue backend + tes deux frameworks construits à la main rendent ce palier concret : tu as déjà VU trois réponses différentes aux mêmes problèmes.
> ⏱️ **Volume indicatif** : 3 à 4 semaines (30–40 h). *Le checkpoint est la mesure, pas le calendrier.*
> 📍 **Prérequis** : [épreuve du palier 6](../palier-06-backend-php/evaluation.md) réussie — tu as **trois** backends derrière toi.

## 🎓 Ce que tu sauras faire à la fin

1. Appliquer SOLID (S, O, D en priorité) à **ton** code, pas à des exemples abstraits.
2. Reconnaître le « mauvais DRY » et savoir quand ne pas factoriser.
3. Refactoriser du code existant **sans changer son comportement**, par petits commits testés.
4. Identifier les patterns que tu utilises déjà (Repository, Active Record, Observer, Strategy).
5. Justifier le choix d'un monolithe modulaire — et nommer ce que les microservices coûtent.
6. Concevoir le caching, la pagination, le rate limiting et l'idempotence d'un système.
7. Expliquer le *statelessness* et la scalabilité horizontale.
8. Rédiger un **document d'architecture** et le **défendre à l'oral**, schéma au tableau.
9. Comparer Express, Django et Laravel sur des critères, pas des goûts.

## 📘 Les leçons

👉 **[Plan détaillé et conseils de travail](lecons/README.md)** — les 7 leçons sont rédigées.

| # | Leçon | Volume |
|---|-------|--------|
| 01 | [SOLID appliqué à ton propre code](lecons/01-solid.md) | 5 h |
| 02 | [DRY, KISS, YAGNI — et leurs limites](lecons/02-dry-kiss-yagni.md) | 3 h |
| 03 | [Refactoring guidé : reprendre le projet 4 sans changer son comportement](lecons/03-refactoring-guide.md) | 6 h |
| 04 | [Design patterns du quotidien : Repository, Factory, Strategy, Observer](lecons/04-design-patterns.md) | 5 h |
| 05 | [Monolithe modulaire, microservices, files et événements](lecons/05-monolithe-microservices-evenements.md) | 4 h |
| 06 | [Caching, pagination, rate limiting, idempotence](lecons/06-cache-pagination-ratelimit-idempotence.md) | 4 h |
| 07 | [Scalabilité : vertical/horizontal, load balancer, statelessness](lecons/07-scalabilite.md) | 4 h |

## Module 1 : Principes de conception

- [ ] **SOLID** — au minimum S (responsabilité unique), O (ouvert/fermé) et D (inversion de dépendances), illustrés dans TON code, pas dans des exemples de chat/chien.
- [ ] DRY, KISS, YAGNI — et leurs limites (le mauvais DRY qui couple tout).
- [ ] 🛠️ **Refactoring guidé — l'exercice le plus formateur du parcours** : reprends le projet 4 (Node) avec tes yeux d'aujourd'hui. Liste les défauts, refactorise par petits commits, sans changer le comportement (les tests le prouvent).
- [ ] Design patterns du quotidien : **Repository, Factory, Strategy, Observer** — comprendre le *problème* que chacun résout. Tu les as déjà croisés sans le savoir : Eloquent = Active Record, Prisma = Data Mapper, tes modèles PDO = Repository, les événements Laravel = Observer.
- 📚 refactoring.guru (patterns + refactoring, visuel et gratuit).

## Module 2 : Architecture de systèmes

- [ ] Monolithe vs microservices — et pourquoi on commence (presque) toujours par un **monolithe modulaire**.
- [ ] Communication : REST vs **files d'attente / événements** (tu as vu les queues Laravel — généralise : découplage, asynchrone, retry).
- [ ] **Caching** : où (navigateur, CDN, applicatif, BDD), quoi, et le vrai problème — l'invalidation.
- [ ] Pagination, rate limiting, idempotence (pourquoi rejouer un paiement ne doit rien casser).
- [ ] Scalabilité : verticale vs horizontale, load balancer, **statelessness** (repense au modèle PHP « tout meurt à chaque requête » — il est stateless par construction !).
- [ ] Schéma de référence à savoir dessiner et défendre : client → LB → API ×N → cache → BDD (+ file de tâches).
- 📚 *System Design Primer* (GitHub) — les sections de base ; chaîne **ByteByteGo**.

## Module 3 : 🛠️ Exercice de synthèse — le document d'architecture

- [ ] Rédige le document d'architecture d'un système réel de ton contexte, au choix :
  - un système de **paiement mobile money** (intégration MTN MoMo / Orange Money),
  - une **plateforme de résultats d'examens** (pic de charge extrême le jour J — cas d'école),
  - une plateforme de commande/livraison locale.
- [ ] Contenu : contexte et contraintes, schéma, **choix de stack justifié parmi tes trois** (+ pourquoi pas les deux autres), modèle de données, points de défaillance et parades, plan d'évolution (10 → 10 000 utilisateurs).
- [ ] Passe-le au double crible : l'IA en interviewer system design, puis le référent en comité d'architecture.

## 🛠️ Livrables du palier

Voir [projet.md](projet.md) — ce palier n'a pas d'application à coder, mais **deux livrables de métier** :
1. **Le refactoring du projet 4** — l'exercice le plus formateur du parcours.
2. **Le document d'architecture**, rédigé puis **défendu** face au référent en comité d'architecture ([template](../templates/document-architecture.md)).

## 🏗️ Le comparatif final des stacks

Consolide en un document unique (il resservira en entretien) :

| Axe | Express/Node | Django/Python | Laravel/PHP |
|-----|--------------|---------------|-------------|
| Philosophie (opinionated ?) | | | |
| ORM et son pattern | | | |
| Modèle d'exécution | | | |
| Forces / cas d'usage idéal | | | |
| Quand je le déconseille | | | |

*(à remplir toi-même — c'est l'exercice)*

## 📋 Fil rouge Gestion de projet

- Le document d'architecture EST un livrable de gestion de projet : il chiffre aussi (coûts d'infra estimés du système conçu — préparation du palier 8).

## 🤖 Fil rouge IA — le sparring partner

- « Joue l'interviewer system design : pose-moi des questions sur mon document, cherche les failles. »
- « Mon système tombe le jour des résultats : fais-moi dérouler le diagnostic. »

## 🧑‍🏫 Référent

- Challenger le document d'architecture en jouant le comité d'architecture (30 min de questions).
- Lui demander de raconter UNE vraie décision d'architecture de sa carrière — le contexte, les contraintes, ce qu'il referait autrement. Ça vaut un livre.

## ✅ Checkpoint de sortie

- [ ] Je justifie chaque choix technique de mes projets 4, 5 et 6 (et j'admets ce que je referais autrement).
- [ ] Le refactoring du projet 4 est commité, tests au vert.
- [ ] Je dessine et défends l'architecture d'une app web classique sans notes.
- [ ] Document d'architecture rédigé et challengé (IA + référent).

### 🚦 [Passer l'épreuve de sortie →](evaluation.md)

> Les objectifs ci-dessus sont **vérifiés** par l'épreuve, pas auto-déclarés. Tant qu'elle n'est pas réussie, le palier suivant reste fermé.

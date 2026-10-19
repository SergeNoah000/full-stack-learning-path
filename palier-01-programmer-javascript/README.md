# Palier 1 — Apprendre à programmer, avec JavaScript

> 🎯 **Objectif** : savoir PROGRAMMER (résoudre des problèmes), pas juste connaître une syntaxe. **Le palier le plus important du parcours** — c'est lui qui rendra Python, PHP et Dart faciles. Ne le précipite pas.
> ⏱️ **Volume indicatif** : 6 à 10 semaines (60–100 h). *Le plus long du début de parcours, et c'est normal.*
> 📍 **Prérequis** : [épreuve du palier 0](../palier-00-fondations/evaluation.md) réussie — terminal, Git/GitHub, HTTP.

## 🎓 Ce que tu sauras faire à la fin

1. Déclarer et manipuler des données sans tomber dans les pièges de conversion de type.
2. Contrôler le déroulement d'un programme, et choisir la bonne boucle en justifiant.
3. Découper un problème en fonctions courtes, pures et testables.
4. Modéliser des données réelles (tableaux d'objets) et les manipuler **sans les corrompre**.
5. Transformer, filtrer et agréger des collections avec `map`/`filter`/`reduce`, sans boucle manuelle.
6. Expliquer et utiliser les closures.
7. Lire une stack trace, gérer les erreurs, utiliser un débogueur.
8. Écrire du code asynchrone (promesses puis `async/await`) et consommer une vraie API.
9. Expliquer l'event loop et prédire un ordre d'exécution.
10. Choisir la bonne structure de données et reconnaître un code qui ne passera pas l'échelle.
11. Livrer une application CLI complète, persistante et robuste.

## 📘 Les leçons

👉 **[Plan détaillé et conseils de travail](lecons/README.md)**

| # | Leçon | Volume |
|---|-------|--------|
| 01 | [Variables, types et opérateurs](lecons/01-variables-types-operateurs.md) | 3 h |
| 02 | [Conditions et boucles](lecons/02-conditions-et-boucles.md) | 4 h |
| 03 | [Les fonctions](lecons/03-les-fonctions.md) | 4 h |
| 04 | [Tableaux et objets](lecons/04-tableaux-et-objets.md) | 5 h |
| 05 | [Portée, fonctions fléchées, closures](lecons/05-portee-et-closures.md) | 4 h |
| 06 | ⭐ [**map, filter, reduce**](lecons/06-map-filter-reduce.md) | 5 h |
| 07 | [Destructuring, spread, template literals](lecons/07-syntaxe-moderne.md) | 3 h |
| 08 | [Erreurs et débogage](lecons/08-erreurs-et-debogage.md) | 3 h |
| 09 | [L'asynchrone (1) : callbacks et promesses](lecons/09-asynchrone-1-promesses.md) | 5 h |
| 10 | [L'asynchrone (2) : async/await et fetch](lecons/10-asynchrone-2-async-await.md) | 5 h |
| 11 | [L'event loop](lecons/11-event-loop.md) | 2 h |
| 12 | [Structures de données et complexité](lecons/12-structures-et-complexite.md) | 4 h |

**Repères de parcours** :
- ⭐ **Leçon 06** est la plus rentable du palier : ces trois outils existent dans les quatre langages du parcours.
- ⚠️ **Leçons 09–11 (l'asynchrone)** sont le cap difficile. Galérer est normal, tout le monde galère. Le point « juste pour parler » avec le référent existe pour ça.
- 🛠️ **Le projet 1 se commence après la leçon 08** et se termine après la leçon 10.

## 🧩 Rituel algo — démarre maintenant

**2 katas de 30 min par semaine**, dès la leçon 01, jusqu'à la fin du parcours. Exercism (piste JavaScript, mentorat gratuit) ou Codewars 8 kyu → objectif **7 kyu** à la sortie du palier.
Méthode, objectifs et registre : **[../katas.md](../katas.md)**.

## 🛠️ Projet du palier

[**Projet 1 — Gestionnaire de dépenses en CLI**](projet.md)

Ce projet se réécrira en TypeScript (palier 3), Python (palier 5) et Dart (palier 9) — c'est ton **étalon de comparaison entre langages**. Soigne-le.

## 📚 Ressources du palier

Détail dans [../ressources.md](../ressources.md#palier-1--programmer-avec-javascript) :
*The Odin Project → Foundations (JavaScript)* (colonne vertébrale) · **javascript.info** (approfondissement ciblé) · 🎥 *« What the heck is the event loop anyway? »* (Philip Roberts) · Exercism + Codewars.

## 🤖 Fil rouge IA — niveau 1 : le débogueur socratique

- Bloqué > 30 min → demande **un indice, pas la réponse** : « donne-moi une piste sans écrire le code ».
- Après chaque exercice réussi : « critique ma solution — lisibilité, cas limites oubliés ».
- Toujours **zéro code généré. Tu tapes tout**, y compris les exemples de ces leçons.
- Usage type bien calibré : « pose-moi 5 exercices progressifs sur `reduce`, **sans les corrections** ».
- Méthode : [../guides/prompter-une-ia.md](../guides/prompter-une-ia.md).

## 🧑‍🏫 Référent

- Point régulier : montrer 2–3 katas et le projet 1 en cours. Lui demander de regarder tes **habitudes** (nommage, commits, découpage) plus que ton code.
- C'est le palier du découragement classique (l'asynchrone !) — le point « juste pour parler » existe pour ça.
- En fin de palier : lui faire passer l'**épreuve C2** (expliquer `async/await`, les closures et `map/filter/reduce` à l'oral).

## ✅ Checkpoint de sortie

Chaque objectif est **vérifié** par l'[épreuve de sortie](evaluation.md), pas auto-déclaré.

- [ ] **Les 12 leçons** cochées (tous les critères « Acquis si… » vrais).
- [ ] Je résous un Codewars **7 kyu** seul, sans aide, en moins de 30 min. *(épreuve C1)*
- [ ] `map`/`filter`/`reduce` sans regarder la doc, y compris un groupement avec `reduce`. *(épreuve A1)*
- [ ] J'explique `async/await` et les closures avec mes propres mots. *(épreuve C2)*
- [ ] Je gère les erreurs et je sais lire une stack trace. *(épreuve A4)*
- [ ] Je repère un `O(n²)` et je le corrige avec un index. *(épreuve A5)*
- [ ] Quiz de sortie : **≥ 24/30**. *(partie B)*
- [ ] Projet 1 sur GitHub : fonctions propres, logique séparée de l'affichage, README, commits réguliers. *(partie D)*
- [ ] Rituel katas tenu (≥ 80 % des semaines), registre à jour dans [../katas.md](../katas.md).
- [ ] `journal.md` rempli et [rétrospective](../templates/retrospective-palier.md) rédigée.

### 🚦 [Passer l'épreuve de sortie →](evaluation.md)

> La tentation, ici, est de filer vers le palier 2 pour « enfin faire du visuel ». Résiste : HTML et CSS s'apprennent en quelques semaines quand on sait programmer — et ne s'apprennent jamais bien quand on ne sait pas.

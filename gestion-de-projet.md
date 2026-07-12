# 📋 Fil rouge — Gestion de projet

> Un développeur qui sait cadrer, chiffrer et suivre un projet vaut beaucoup plus qu'un développeur qui sait seulement coder — surtout en freelance et dans les petites structures. Ces compétences s'introduisent petit à petit, un ingrédient nouveau par projet, et se pratiquent sur TES projets jalons (jamais en théorie pure).

## La progression : un ingrédient nouveau par projet

| Palier | Projet | Nouveaux livrables de gestion | Acquis cumulés |
|--------|--------|-------------------------------|----------------|
| 2 | App météo | **Mini-cadrage (1 page)** : objectif, utilisateurs cibles, fonctionnalités must/nice-to-have, maquette papier. **Suivi** : simple `TODO.md` | Savoir dire ce qu'on construit AVANT de coder |
| 3 | Clone React | **User stories** ("en tant que… je veux… afin de…"), **maquette Figma** simple, **kanban** GitHub Projects (À faire / En cours / Fait), découpage en tâches < 2h | Découper un besoin en unités de travail |
| 4 | App fullstack Node | **Cahier des charges complet** (modèle ci-dessous), **jalons**, **estimation d'effort** par tâche + mesure du réel (ta vélocité), **journal des risques** (3 lignes) | Estimer, se tromper, mesurer, recalibrer |
| 5 | App Django | **Spécification d'API** (contrat OpenAPI — FastAPI te l'a fait découvrir), **cahier de recette** (scénarios de test utilisateur : étapes → résultat attendu) | Spécifier et vérifier formellement |
| 6 | App Laravel (posture client) | **Devis** : estimation des coûts — jours × taux journalier + hébergement + domaine + marge d'imprévu (20%), **proposition commerciale** (2 pages), gestion du **changement de périmètre** (le référent joue le client qui change d'avis !) | Chiffrer et défendre un prix ; dire non à un périmètre qui gonfle |
| 8 | DevOps | **Évaluation des coûts d'infrastructure** : comparer VPS vs PaaS vs cloud sur 1 an (TCO), budget mensuel de fonctionnement d'une app | Le coût ne s'arrête pas à la livraison |
| 9 | App mobile | **Suivi des retours utilisateurs** : collecte, priorisation (impact × effort), itérations | Le produit vit après la v1 |
| 10 | Projet final | **Cycle complet de A à Z** : conception → cahier des charges → chiffrage → planification → suivi hebdo → recette → bilan (estimé vs réel). Le référent joue le client du cadrage à la recette | Dérouler seul un projet professionnel |

## 📄 Modèle de cahier des charges (introduit au palier 4, réutilisé ensuite)

```markdown
# Cahier des charges — [Nom du projet]

## 1. Contexte & objectif
Quel problème, pour qui, pourquoi maintenant. (5 lignes max)

## 2. Périmètre
- Inclus : …
- EXCLU (aussi important !) : …

## 3. Utilisateurs & rôles
Qui utilise quoi (visiteur, membre, admin…).

## 4. Exigences fonctionnelles
Sous forme de user stories, priorisées MoSCoW (Must/Should/Could/Won't).

## 5. Exigences non fonctionnelles
Performance, sécurité, hors-ligne, langues, compatibilité mobile…

## 6. Contraintes techniques
Stack imposée ou choisie (et POURQUOI), hébergement, budget.

## 7. Livrables & jalons
Quoi, dans quel ordre. Jalon = démontrable.

## 8. Risques
3 à 5 lignes : quoi peut mal tourner, plan B.

## 9. Critères d'acceptation
Comment on saura que c'est fini (base du cahier de recette).
```

## 💰 Méthode d'estimation des coûts (introduite au palier 6, mûrie aux paliers 8 et 10)

1. **Découper** le projet en tâches de moins d'une journée.
2. **Estimer** chaque tâche en heures — puis ×1,5 (les débutants sous-estiment toujours ; mesure ton coefficient réel au fil des projets, c'est TA donnée la plus précieuse).
3. **Chiffrer le temps** : total heures → jours → × taux journalier (renseigne-toi sur les taux locaux et freelance avec le référent).
4. **Ajouter les coûts récurrents** : hébergement (VPS ~5 €/mois, PaaS variable), domaine (~12 €/an), services tiers (API, emails), maintenance (forfait mensuel ou taux réduit).
5. **Marge d'imprévu** : +20% minimum.
6. **Après le projet : le bilan.** Estimé vs réel, ligne par ligne. C'est le bilan qui t'apprend à estimer, pas l'estimation.

## 🛠️ Outils (rester simple)

- Cadrage & specs : fichiers Markdown dans le repo du projet (`docs/`).
- Maquettes : papier d'abord, puis **Figma** (gratuit) à partir du palier 3.
- Suivi : **GitHub Projects** (kanban lié aux issues) — un seul outil, celui du métier.
- Recette : tableau Markdown (scénario | étapes | attendu | résultat | ✅/❌).

## Règles d'or

- **Pas une ligne de code avant le cadrage** (même 1 page). C'est le cadrage qui tue le "projet parfait jamais fini" : quand le must-have est livré, le projet est fini.
- **Le périmètre exclu s'écrit noir sur blanc.** La plupart des projets meurent de ce qu'on a accepté d'ajouter.
- **Toute estimation se confronte au réel.** Sinon ce n'est pas de l'estimation, c'est de la divination.

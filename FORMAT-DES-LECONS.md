# 🧱 Comment une leçon est construite

> Ce document fixe le format des leçons du parcours. Il sert à deux choses : savoir **ce que tu vas trouver** quand tu ouvres une leçon, et garantir que toutes les leçons à venir se ressemblent.

## Le principe

Une leçon n'est pas une fiche de référence. **C'est un guide d'orientation** : on la lit pour comprendre *de quoi il s'agit, à quoi ça sert, où ça intervient dans le développement, ce qu'on va réellement rencontrer sur le terrain, et ce qui va être testé*. La syntaxe, elle, est dans la documentation officielle — et la leçon dit où la lire.

Trois règles d'écriture en découlent :

1. **Du texte suivi, pas des listes à puces en cascade.** Un tableau est acceptable quand il est vraiment une référence (des codes de statut, une matrice de comparaison), jamais comme colonne vertébrale de l'explication.
2. **L'utilité avant l'exhaustivité.** On explique longuement les 20 % qui servent tous les jours, on mentionne en une phrase ce qui est rare, et on dit explicitement que c'est rare.
3. **Le lecteur doit finir en sachant les enjeux.** Pas seulement « comment on écrit un `map` », mais « où ça intervient, ce qu'on me demandera, ce qui me fera repérer comme débutant, ce qui me démarquera ».

## Le squelette

```markdown
# Leçon NN — Titre

> 🎯 Ce que tu sauras faire à la fin
> ⏱️ Volume · Prérequis

## [Le sujet], c'est quoi
Une définition en prose. On nomme, on distingue des notions voisines
qu'on confond (Git/GitHub, map/forEach), on donne l'image mentale juste.

## À quoi ça sert, concrètement
Les usages réels, pas la théorie. Chaque usage en un paragraphe.

## Où ça intervient dans le développement
À quel moment du cycle, dans quelle couche du logiciel, qui s'en sert.
Un schéma de placement quand c'est éclairant. On relie explicitement
aux paliers suivants qui s'y brancheront.

## Ce que tu verras quand tu travailleras
### Aujourd'hui, en solo
### En équipe, en entreprise
### Ce qui sert tous les jours, et ce qui est rare

## La mécanique / Comment on s'y branche
Le cœur technique : l'essentiel donné en propre, en prose commentée,
avec du code minimal et exécutable. On ne recopie pas la doc.

## Les problèmes que tu vas rencontrer
Les vrais, par symptôme : « ton map rend un tableau de undefined » →
cause → quoi faire. C'est la section la plus relue d'une leçon.

## Ce qu'on te demandera
Test technique, entretien, premier jour dans une équipe, revue de code.

## Ce qui te démarquera
Le « plus » : ce que peu de juniors font et qui ne coûte presque rien.

## 📚 À lire
Ressources précises (page, section, durée), et pourquoi celle-là.

## 🤖 Le mini-projet à demander à l'IA
Un ou deux prompts prêts à coller, qui font **fabriquer l'exercice**
par l'IA — jamais la solution. Avec le rappel du niveau du fil rouge IA.

## 🛠️ À faire
Les exercices, du plus simple au plus proche d'un test technique réel.
Corrections dans un bloc <details>, avec l'explication du piège,
pas seulement le code juste.

## ✅ Acquis si…
Des critères vérifiables, à cocher. On ne coche que si c'est vrai.
```

## Les deux leçons de référence

Quand tu rédiges (ou fais rédiger) une leçon, prends ces deux-là comme modèles :

- **Une leçon d'outillage** : [palier 0, leçon 04 — GitHub et le travail à distance](palier-00-fondations/lecons/04-github-et-le-distant.md)
- **Une leçon de code** : [palier 1, leçon 06 — map, filter, reduce](palier-01-programmer-javascript/lecons/06-map-filter-reduce.md)

## Ce qu'une leçon ne fait pas

- Elle ne recopie pas la documentation officielle (elle y envoie).
- Elle ne liste pas toutes les options d'une commande ou toutes les méthodes d'une API.
- Elle ne donne pas de code à copier-coller : aux paliers 0 à 2, **tout se tape à la main**.
- Elle ne se termine pas sans critères d'acquisition vérifiables.

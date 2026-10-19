# 📘 Guide — Lire la documentation

> 🎯 **À la fin de ce guide** : la doc devient ton premier réflexe au lieu du dernier recours, et tu sais lire une page de référence sans la lire en entier.
> ⏱️ Lecture 12 min · à appliquer dès le palier 0.

## 1. Le principe

Un développeur professionnel ne connaît pas son langage par cœur : il sait **où trouver** en 30 secondes. La doc n'est pas un pensum pour quand on est bloqué, c'est l'outil de travail principal.

Pourquoi la préférer aux tutoriels :

| | Tutoriel | Documentation |
|---|----------|---------------|
| Te donne | **un** chemin, celui de l'auteur | **tous** les chemins, et les limites |
| Date | souvent périmée | à jour, versionnée |
| Dit les cas limites | presque jamais | oui (c'est là que sont les bugs) |
| Après lecture | tu sais refaire la même chose | tu sais faire **autre chose** |

Le piège du débutant : « la doc est trop sèche ». Elle l'est — parce qu'elle est une **référence**, pas un cours. Il faut donc apprendre à la lire comme un dictionnaire, pas comme un roman.

## 2. Les 3 types de pages, à ne pas confondre

| Type | À quoi ça sert | Exemples |
|------|----------------|----------|
| **Tutorial / Getting started** | la première prise en main, à faire une fois, en entier, clavier en main | *Writing your first Django app*, *Learn React* |
| **Guide / How-to** | résoudre un besoin précis | *Flask § Sessions*, *Laravel § File Uploads* |
| **Reference / API** | la fiche technique exhaustive d'une fonction | MDN `Array.prototype.reduce`, `php.net/array_map` |

> Erreur classique : chercher à apprendre un sujet dans la **référence** (trop sec, trop exhaustif), ou chercher un détail technique dans le **tutoriel** (il n'y est pas).

## 3. La méthode : lire une page de référence en 2 minutes

Prends MDN `Array.prototype.filter` et lis **dans cet ordre** :

1. **La phrase de résumé** (1 ligne) — ce que ça fait.
2. **La syntaxe / signature** — ce que ça prend, ce que ça rend. C'est le cœur.
3. **La valeur de retour** — la question la plus souvent oubliée. Un **nouveau** tableau ? le même modifié ? `undefined` ?
4. **Les exemples** — saute directement au plus proche de ton besoin.
5. **Les notes / avertissements** — les cas limites, les pièges, les versions.
6. ⚠️ **Compatibilité / version** — « depuis quelle version ? » En PHP et Python, un détail de version coûte des heures.

Ce que tu **ne lis pas** : les paragraphes d'introduction, la théorie, les sections non liées à ton besoin.

### Lire une signature

```
filter(callbackFn)
filter(callbackFn, thisArg)

callbackFn: (element, index, array) => boolean
Retour: un NOUVEAU tableau avec les éléments où callbackFn a renvoyé true
```

Les trois questions à se poser systématiquement devant une signature :
1. **Qu'est-ce que ça prend ?** (types, obligatoire ou optionnel)
2. **Qu'est-ce que ça rend ?** (et surtout : est-ce que ça **modifie** l'entrée ?)
3. **Qu'est-ce qui peut échouer ?** (exception ? valeur nulle ? comportement si vide ?)

## 4. Les conventions de notation

| Notation | Signification |
|----------|---------------|
| `[ ]` autour d'un paramètre | optionnel : `slice(début[, fin])` |
| `...args` | nombre variable d'arguments |
| `?` après un nom (TS) | propriété optionnelle |
| `|` entre deux types | l'un **ou** l'autre : `string \| null` |
| `-> bool` (Python) | type de retour |
| `mixed`, `iterable` (PHP) | plusieurs types acceptés |
| ⚠️ **Deprecated** | ça marche encore mais ne l'utilise pas |
| 🧪 **Experimental** | peut disparaître ; pas en production |
| **Baseline / Browser compatibility** (MDN) | supporté partout ? |

## 5. Les bons réflexes

- **Chercher dans la doc, pas sur Google** : `Ctrl+K` sur MDN, react.dev, laravel.com, docs.djangoproject.com — toutes ont une recherche interne meilleure que Google pour leur propre contenu.
- **Vérifier la version** affichée en haut de page. Un exemple Laravel 8 sur un projet Laravel 11, c'est 2 h perdues.
- **En anglais, toujours.** Les traductions sont incomplètes et en retard. Note le vocabulaire inconnu dans [glossaire.md](../glossaire.md) ; au bout de 200 mots, l'anglais technique n'est plus un obstacle.
- **Garder un onglet épinglé** sur la doc du palier en cours.
- **Lire la doc AVANT de chercher un tutoriel** : souvent, le *Getting started* officiel est le meilleur tutoriel disponible (React, FastAPI, Laravel, Flutter).
- **La doc est hors ligne aussi** : `git help`, `man ls`, `python -m pydoc list`, `php -r 'echo "...";'`, `node --help`.

## 6. Quand la doc ne suffit pas

Dans cet ordre, et pas avant d'avoir essayé le précédent :

1. **Les exemples officiels** : dépôt GitHub du projet, dossier `examples/`.
2. **Les issues GitHub du projet** : cherche ton message d'erreur dedans. Souvent, c'est un bug connu avec une solution.
3. **Stack Overflow** : le message d'erreur **exact entre guillemets**. Regarde la date et la version avant de copier.
4. **Le code source de la bibliothèque** : intimidant au début, décisif ensuite. À partir du palier 4, ouvre le code de ce que tu utilises — c'est permis et instructif.
5. **L'IA** : utile pour *traduire* une doc sèche en exemple sur ton cas, mais sa connaissance a une date de péremption et elle invente des options qui n'existent pas. **Vérifie toujours dans la doc l'option qu'elle te donne.**

## 7. 🛠️ À faire
1. **Exercice du « sans tutoriel »** : lis `Array.prototype.reduce` sur MDN et écris 3 usages différents **sans aucun tutoriel ni IA**. Note le temps que ça te prend.
2. Prends une fonction que tu crois connaître (`sort`, `splice`, `slice`) et lis sa page en entier. Tu y découvriras au moins un comportement surprenant (indice : `sort` compare des **chaînes** par défaut, et modifie le tableau d'origine).
3. Mets en favori les 5 docs du parcours : MDN, docs.python.org, php.net, laravel.com/docs, docs.flutter.dev.
4. Dans la doc d'une bibliothèque de ton choix, trouve **en moins de 2 minutes** : la valeur de retour d'une fonction, et depuis quelle version elle existe.

## ✅ Acquis si…
- [ ] Devant un besoin nouveau, mon premier onglet est la doc officielle, pas YouTube.
- [ ] Je lis une page de référence en moins de 2 min en ciblant signature + retour + exemple.
- [ ] Je vérifie systématiquement la **version** de la doc que je lis.
- [ ] Je lis la doc en anglais sans traduire.
- [ ] J'ai déjà résolu un problème en lisant une **issue GitHub** du projet concerné.

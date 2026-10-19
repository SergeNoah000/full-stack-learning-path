# Leçon 07 — Le DOM : sélectionner, créer, modifier

> 🎯 **À la fin de cette leçon** : tu manipules le contenu d'une page depuis JavaScript, et tu sais pourquoi la façon de le faire décide de la performance et de la sécurité de ton application.
> ⏱️ 4 h · **Prérequis** : palier 1 complet (surtout les leçons 04 et 06), et les leçons 01 à 06 de ce palier.

---

## Le DOM, c'est quoi

Le **DOM** (*Document Object Model*) est la représentation **en mémoire** de ta page, sous forme d'arbre d'objets. Quand le navigateur reçoit ton HTML, il le lit et construit cet arbre ; ce que tu vois à l'écran est la peinture de cet arbre.

Le point à bien saisir, parce qu'il est contre-intuitif : **le DOM n'est pas ton fichier HTML**. Ton fichier est du texte, lu une fois au chargement. Le DOM est un objet vivant que tu peux inspecter et modifier à tout moment — et dès que tu le modifies, l'écran suit. Ouvre l'inspecteur sur n'importe quel site et modifie un texte : tu modifies le DOM, pas le fichier du serveur, et un rechargement efface tout.

Quelques termes qui reviendront : un **nœud** est n'importe quel élément de l'arbre (une balise, mais aussi un texte ou un commentaire) ; un **élément** est un nœud de type balise ; les **attributs** sont les propriétés déclarées dans le HTML (`id`, `class`, `src`) ; et les **propriétés** sont celles de l'objet JavaScript correspondant — les deux sont liés mais pas identiques.

---

## À quoi ça sert, concrètement

**Parce que c'est la seule façon de rendre une page vivante.** Tout ce qui change après le chargement — un compteur qui s'incrémente, une liste qui se filtre, un message d'erreur qui apparaît, des données d'API qui s'affichent — passe par le DOM. Sans lui, une page est un document figé.

**Parce que c'est le point de jonction entre tes deux moitiés de compétences.** Tu as appris à programmer au palier 1 : manipuler des tableaux d'objets, filtrer, transformer. Tu as appris à structurer et styler aux leçons 01 à 06. Le DOM est l'endroit où les deux se rencontrent : un `filter` sur un tableau devient une liste qui se réduit à l'écran.

**Parce que c'est le mécanisme que React remplacera — et qu'il faut l'avoir vécu.** Au palier 3, tu ne toucheras presque plus au DOM directement : tu décriras un état, et React se chargera de synchroniser l'affichage. Mais tu ne comprendras **pourquoi** React existe que si tu as d'abord écrit à la main la synchronisation entre des données et un affichage. C'est le but de cette leçon et de ton projet 2.

---

## Où ça intervient dans le développement

Le DOM est la couche de **comportement**, et sa place dans ton architecture est un enjeu dès maintenant.

```
   données (un tableau d'objets)      ← ce que tu sais faire depuis le palier 1
         │
         │   ← C'EST ICI QUE TOUT SE JOUE : comment je synchronise les deux ?
         ▼
   DOM (ce qui est affiché)
```

La question « comment garder l'affichage cohérent avec les données ? » est **le** problème central du développement frontend. Il y a deux stratégies, et tu vas rencontrer les deux :

**Modifier chirurgicalement** — « l'utilisateur a supprimé la ligne 3, je retire ce `<li>` ». Rapide, mais il faut gérer chaque cas de changement, et les oublis produisent un affichage désynchronisé des données. C'est la source de bugs n°1 des applications écrites à la main.

**Tout redessiner depuis les données** — « les données ont changé, je reconstruis la liste entière ». Beaucoup plus simple à raisonner : une seule fonction `afficher(donnees)`, appelée après chaque changement. Le coût est de refaire du travail inutile, acceptable sur de petites listes.

C'est cette seconde approche que tu adopteras au palier 2, et c'est **exactement le modèle de React** — à ceci près que React optimise la reconstruction pour toi. Tu auras donc construit l'intuition avant l'outil.

Deuxième point d'architecture, et il est imposé par ton projet 2 : **sépare les trois responsabilités en trois fichiers**. `api.js` parle au réseau, `ui.js` parle au DOM, `app.js` orchestre. La règle de vérification : *si je change d'API, combien de fichiers je touche ?* Si la réponse est « un », ton découpage est bon.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire ta première interface réellement interactive, et c'est un moment agréable du parcours : ce que tu tapes se voit.

Tu vas aussi commettre les deux erreurs classiques — modifier le DOM avant qu'il existe (script placé trop haut), et construire du HTML avec `innerHTML` et des données utilisateur (une faille XSS). Les deux sont traitées plus bas ; les rencontrer maintenant est utile.

### En équipe, en entreprise

**Tu toucheras rarement au DOM directement.** Dans un projet React, Vue ou Angular, manipuler le DOM à la main est même un signal d'alarme : ça court-circuite le framework et crée des incohérences. Les rares cas légitimes existent (intégrer une bibliothèque de carte, gérer le focus), et on les encadre.

**Mais tu liras du code qui le fait.** Les projets antérieurs aux frameworks, les widgets intégrés, les scripts de suivi, le code jQuery — il y en a énormément en production, et les missions de maintenance en sont pleines. Savoir lire `document.querySelector` et `innerHTML` n'est pas une compétence du passé.

**Et la sécurité est surveillée.** `innerHTML` avec des données venant de l'utilisateur est l'une des vulnérabilités les plus recherchées lors d'un audit. Les linters la signalent, et au palier 4 tu apprendras à l'exploiter sur ton propre code pour comprendre.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `querySelector`, `querySelectorAll`, `textContent`, `classList`, `addEventListener` (leçon 08), `createElement`, `append`, et `dataset`.

Régulièrement : `innerHTML` (avec prudence), `closest`, `setAttribute`, `remove`, `cloneNode` avec `<template>`, `insertAdjacentHTML`.

Rare, et hors sujet pour l'instant : `getElementById` et `getElementsByClassName` (les anciennes méthodes — `querySelector` les remplace toutes), `childNodes` et la navigation nœud par nœud, `DocumentFragment` (une optimisation), `MutationObserver`, le *Shadow DOM* et les Web Components, `document.write` (à ne jamais utiliser). Et un repère de lecture : si un tutoriel t'apprend `document.getElementById` partout et `$()`, il date d'avant 2015 — ce n'est pas faux, c'est daté.

---

## La mécanique

### Sélectionner

```js
document.querySelector(".carte")          // le PREMIER élément correspondant (ou null)
document.querySelectorAll(".carte")       // TOUS : une NodeList (pas un vrai tableau)
document.querySelector("#total")
document.querySelector('[data-id="42"]')
element.querySelector(".titre")           // chercher DANS un élément — à privilégier
```

Deux choses à savoir tout de suite.

`querySelector` prend **n'importe quel sélecteur CSS** — tout ce que tu as appris à la leçon 03 fonctionne ici. Une seule méthode à retenir au lieu de cinq.

Et `querySelectorAll` retourne une **NodeList**, pas un tableau : elle a `forEach` mais ni `map`, ni `filter`, ni `reduce`. D'où l'idiome à prendre :

```js
const cartes = [...document.querySelectorAll(".carte")];   // un vrai tableau
const titres = cartes.map(c => c.textContent);             // et toutes tes méthodes du palier 1
```

### Modifier le contenu

```js
element.textContent = "29 °C";            // ✅ du TEXTE, sûr, rapide
element.innerHTML = "<strong>29</strong> °C";   // ⚠️ interprète le HTML — danger
```

> ### ⚠️ La règle de sécurité de la leçon
> **N'injecte jamais de données venant de l'utilisateur ou d'une API dans `innerHTML`.**
> ```js
> // ❌ FAILLE XSS
> commentaire.innerHTML = reponseUtilisateur;
> // si reponseUtilisateur vaut <img src=x onerror="alert(document.cookie)">,
> // ce code s'exécute dans ta page, avec les droits de ton utilisateur
>
> // ✅ Sûr : textContent n'interprète rien
> commentaire.textContent = reponseUtilisateur;
> ```
> C'est une **XSS** (*cross-site scripting*), l'une des failles les plus répandues du web. Le réflexe : `textContent` par défaut, `innerHTML` seulement avec du HTML que **tu** as écrit. Tu exploiteras cette faille volontairement au palier 4 pour bien la comprendre.

### Modifier les classes et les attributs

```js
element.classList.add("actif");
element.classList.remove("actif");
element.classList.toggle("actif");            // ajoute ou retire
element.classList.contains("actif");          // → booléen

element.setAttribute("aria-expanded", "true");
element.dataset.id = "42";                     // ↔ attribut data-id="42"
console.log(element.dataset.id);               // "42"
```

**La bonne pratique à installer : pilote l'apparence par des classes, pas par du style en ligne.**

```js
// ❌ le style part dans le JavaScript, et la présentation se disperse
element.style.display = "none";
element.style.backgroundColor = "red";

// ✅ le CSS reste dans le CSS, le JS ne fait que changer d'état
element.classList.add("cache");
element.classList.add("en-erreur");
```

C'est une application directe du fil rouge architecture : le JavaScript décide **de l'état**, le CSS décide **de l'apparence de cet état**. Et l'attribut `dataset` est le pont propre entre les deux : il permet de stocker un identifiant sur un élément sans polluer ses classes.

### Créer et insérer

```js
const li = document.createElement("li");
li.className = "depense";
li.textContent = "Déjeuner — 1 500 FCFA";
liste.append(li);                  // à la fin
liste.prepend(li);                 // au début
element.remove();                  // se supprimer soi-même
```

Pour une structure plus riche, la méthode professionnelle est le `<template>` : tu écris le balisage dans le HTML, et tu le clones.

```html
<template id="modele-depense">
  <li class="depense">
    <span class="description"></span>
    <span class="montant"></span>
    <button class="supprimer" type="button">Supprimer</button>
  </li>
</template>
```

```js
const modele = document.querySelector("#modele-depense");

function creerLigne(depense) {
  const ligne = modele.content.cloneNode(true);
  ligne.querySelector(".description").textContent = depense.description;  // sûr
  ligne.querySelector(".montant").textContent = formater(depense.montant);
  ligne.querySelector(".supprimer").dataset.id = depense.id;
  return ligne;
}
```

Cette approche a trois avantages réels : le balisage reste dans le HTML (donc lisible, et visible par les outils), tout passe par `textContent` (donc aucune XSS possible), et la fonction reste courte.

### ⭐ Le modèle « redessiner depuis les données »

C'est le cœur de la leçon et la structure de ton projet 2.

```js
// ui.js — ne fait QUE de l'affichage, ne décide rien
export function afficherDepenses(depenses, conteneur) {
  conteneur.textContent = "";                      // on vide
  if (depenses.length === 0) {                     // l'état vide, TOUJOURS traité
    conteneur.append(creerMessageVide());
    return;
  }
  const lignes = depenses.map(creerLigne);         // ton map du palier 1 !
  conteneur.append(...lignes);                     // une seule insertion
}

// app.js — orchestre
let etat = { depenses: [], filtre: "tout" };

function rendre() {
  afficherDepenses(filtrer(etat.depenses, etat.filtre), conteneur);
  afficherTotal(calculerTotal(etat.depenses), zoneTotal);
}

function ajouter(depense) {
  etat.depenses = [...etat.depenses, depense];     // sans muter (palier 1, leçon 04)
  rendre();                                        // une seule fonction à appeler
}
```

Observe la discipline : **une seule fonction `rendre()`**, appelée après chaque changement d'état. Tu n'as jamais à te demander « ai-je pensé à mettre à jour le total ? » — c'est structurellement impossible de l'oublier.

Et tu viens d'écrire, à la main, le principe que React automatise : *l'interface est une fonction de l'état*. Quand tu arriveras au palier 3, cette phrase ne sera pas une formule, ce sera du code que tu as écrit.

Un seul point d'attention sur la performance : `conteneur.append(...lignes)` insère tout en une fois, alors qu'un `append` dans une boucle provoque un recalcul à chaque tour. Sur mille lignes, la différence est visible.

---

## Les problèmes que tu vas rencontrer

**`Cannot read properties of null`.** Ton `querySelector` n'a rien trouvé, et tu accèdes à une propriété de `null`. Deux causes : une faute dans le sélecteur (le point ou le dièse oublié — `querySelector("carte")` cherche une balise `<carte>`), ou ton script s'exécute **avant** que l'élément existe.

**Mon script ne trouve rien alors que l'élément est là.** C'est le second cas : un `<script>` dans le `<head>` s'exécute avant que le `<body>` soit construit. Les solutions : mettre le script juste avant `</body>`, ou utiliser `<script defer>` — c'est la pratique recommandée aujourd'hui.

**`querySelectorAll(...).map is not a function`.** Une NodeList n'est pas un tableau. `[...nodeList]`.

**Mon affichage ne correspond plus à mes données.** Tu as modifié le DOM sans mettre à jour l'état (ou l'inverse). C'est précisément le problème que le modèle « redessiner depuis les données » supprime.

**Mes boutons créés dynamiquement ne réagissent plus.** Tu as attaché un écouteur à des éléments, puis tu les as remplacés en redessinant. C'est le sujet de la délégation d'événements, leçon 08.

**Ma page rame avec beaucoup d'éléments.** Tu insères dans une boucle. Construis tout, puis insère une fois.

**Du HTML s'affiche en texte brut.** Tu as utilisé `textContent` avec du HTML — et c'est souvent le bon comportement, mais si tu voulais vraiment du balisage, c'est `innerHTML` (avec les précautions ci-dessus).

**Mon `dataset` ne récupère pas la bonne valeur.** Les tirets deviennent du camelCase : `data-user-id` se lit `dataset.userId`.

---

## Ce qu'on te demandera

En **test technique frontend**, l'exercice le plus courant au monde est une **liste de tâches** : ajouter, cocher, supprimer, filtrer, persister. Il teste exactement cette leçon et la suivante. C'est l'épreuve A3 de ton évaluation de palier, et ce n'est pas un hasard.

En **entretien** : « qu'est-ce que le DOM ? », « différence entre `textContent` et `innerHTML`, et laquelle utiliser ? » (la question de sécurité — la plus discriminante du lot), « comment créerais-tu une liste à partir d'un tableau de données ? », « pourquoi `querySelectorAll` ne renvoie-t-il pas un tableau ? ».

En **travail réel**, on attendra que tu ne mettes pas de style dans le JavaScript, et que tu n'injectes jamais de données utilisateur en HTML.

---

## Ce qui te démarquera

**Adopter le modèle « une fonction `rendre()` ».** La plupart des débutants modifient le DOM chirurgicalement à vingt endroits, et passent ensuite des heures sur des affichages désynchronisés. Structurer autour d'un état et d'un rendu unique est ce qui distingue le plus nettement, et c'est ce que le référent regardera dans ton projet 2.

**`textContent` par défaut.** Et savoir expliquer la XSS en deux phrases. C'est une question de sécurité posée très souvent, à laquelle beaucoup de candidats répondent mal.

**Piloter par des classes, pas par `element.style`.** Le CSS reste dans le CSS. C'est une remarque de revue de code fréquente, et l'anticiper montre que tu penses en couches.

**Utiliser `<template>`.** Peu de développeurs juniors le connaissent, et il règle élégamment la question du balisage dans le JavaScript.

**Traiter l'état vide.** « Aucune dépense pour le moment » est le cas que tout le monde oublie et que tout utilisateur rencontre au premier usage. Le prévoir d'emblée est un réflexe de produit, pas seulement de code.

---

## 📚 À lire

**The Odin Project → JavaScript → DOM Manipulation** : la ressource principale, avec des exercices.

**MDN → *Manipulating documents*** et ***Introduction to the DOM***. Et lis la page **`Element.innerHTML`** jusqu'à sa section *Security considerations* : elle explique la XSS mieux que n'importe quel article.

**javascript.info** chapitres 1.2 à 1.6 (navigation, recherche, modification) si tu veux le détail méthodique.

**web.dev → *Learn HTML → Template, slot, and shadow***, pour la partie `<template>` uniquement.

---

## 🤖 Le mini-projet à demander à l'IA

Le DOM s'apprend en construisant une interface complète, et c'est exactement la préparation de ton projet 2.

> « Je suis en formation de développeur, palier 2 (frontend). Je travaille la manipulation du DOM. Donne-moi le **cahier des charges** d'une petite application sans framework, **sans aucun code** : un gestionnaire de dépenses en page web (ajouter via un formulaire, lister, supprimer, filtrer par catégorie, afficher un total et un total par catégorie). Impose-moi trois contraintes d'architecture : trois fichiers séparés (api/ui/app), **une seule fonction `rendre()`** appelée après chaque changement d'état, et aucune donnée utilisateur passée à `innerHTML`. Donne-moi aussi la liste des **états d'affichage à traiter** (vide, filtré sans résultat, erreur de saisie). Quand je t'enverrai mon code, critique uniquement : la séparation des responsabilités, la synchronisation état/affichage, la sécurité, et les états oubliés. **N'écris pas le code à ma place.** »

Puis la démonstration de sécurité, qui marque durablement :

> « Donne-moi le code d'une mini-zone de commentaires **volontairement vulnérable à la XSS** (en utilisant `innerHTML` sur la saisie), et trois charges utiles réalistes que je pourrais y injecter pour le prouver. Explique-moi ce que chacune ferait sur un vrai site. Ensuite, laisse-moi corriger moi-même et dis-moi si ma correction est complète. »

Tu exploiteras ta propre faille, et cette expérience vaut dix lectures.

---

## 🛠️ À faire

1. **Sélection** : sur une page existante, récupère un élément par classe, par identifiant, par attribut, et tous les éléments d'une classe. Transforme la NodeList en tableau et fais un `map` dessus.
2. **Le piège du script trop tôt** : mets ton `<script>` dans le `<head>` sans `defer`, constate l'erreur `null`, puis corrige de deux façons (déplacer le script, puis `defer`).
3. **Compteur** : deux boutons et un affichage. L'état dans une variable, une fonction `rendre()`, aucun style dans le JavaScript.
4. **⚠️ Démontre la XSS** : un champ de saisie et une zone d'affichage. Affiche d'abord la saisie avec `innerHTML`, injecte `<img src=x onerror="alert('piraté')">`, constate. Corrige avec `textContent`. **Écris dans ton journal ce que ça t'apprend.**
5. **Liste depuis des données** : à partir de ton tableau de six dépenses (palier 1, leçon 04), génère la liste dans le DOM avec `createElement`, puis refais-le avec un `<template>`.
6. **Le modèle `rendre()`** : ajoute un filtre par catégorie et un total. Vérifie que tu n'as **qu'une seule** fonction qui touche au DOM pour la liste.
7. **L'état vide** : affiche « Aucune dépense » quand la liste est vide, et « Aucun résultat pour ce filtre » quand le filtre ne renvoie rien. Ce sont deux messages différents.
8. **Mesure la performance** : insère mille éléments dans une boucle avec `append` à chaque tour, puis en une seule fois. Chronomètre avec `console.time`.
9. **Pilotage par classes** : un bouton qui bascule un thème sombre en ajoutant une classe sur `<body>`, avec les couleurs définies en CSS (variables, leçon 03).
10. Utilise `dataset` pour stocker l'identifiant d'une dépense sur son bouton de suppression, et retrouve-le au clic.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** Dans le `<head>` sans `defer`, le script s'exécute avant que le `<body>` existe : `querySelector` renvoie `null`. Les deux corrections : placer le `<script>` juste avant `</body>`, ou écrire `<script src="app.js" defer></script>` dans le `<head>` — `defer` demande au navigateur d'exécuter le script après la construction du DOM. **C'est la pratique recommandée** : le script est téléchargé en parallèle du HTML, sans bloquer l'affichage.

**4.** Avec `innerHTML`, la balise `<img>` est créée, son chargement échoue, et `onerror` s'exécute : tu viens de faire exécuter du code arbitraire dans ta propre page. Sur un vrai site avec des comptes utilisateurs, cette charge pourrait voler le cookie de session et permettre une usurpation d'identité. Avec `textContent`, la chaîne s'affiche telle quelle, inoffensive. **La leçon à écrire : toute donnée qui ne vient pas de moi est du texte, pas du HTML.**

**6.** Le contrôle à faire sur ton propre code : cherche toutes les lignes qui touchent au DOM pour la liste. S'il y en a plus d'une (une pour l'ajout, une pour la suppression, une pour le filtre), tu es en mode « chirurgical » et tu auras des désynchronisations. Une seule fonction `rendre()` appelée trois fois, c'est le bon modèle.

**8.** Attends-toi à un facteur de dix ou plus. Chaque `append` dans la boucle peut provoquer un recalcul de mise en page ; une insertion unique n'en provoque qu'un. C'est le même raisonnement que la leçon 12 du palier 1 : on sort le travail répété de la boucle.

**10.**
```js
bouton.dataset.id = depense.id;          // écriture : data-id="42"
// au clic :
const id = Number(evenement.target.dataset.id);   // ⚠️ dataset rend TOUJOURS une chaîne
```
Le `Number()` est important : `dataset` retourne toujours des chaînes, et comparer `"42" === 42` est faux (palier 1, leçon 01). C'est un bug classique de cette leçon.
</details>

---

## ✅ Acquis si…

- [ ] J'utilise `querySelector` avec n'importe quel sélecteur CSS.
- [ ] Je convertis une NodeList en tableau pour utiliser `map` et `filter`.
- [ ] J'utilise `textContent` par défaut, et je sais expliquer la XSS que `innerHTML` permet.
- [ ] J'ai exploité une XSS sur mon propre code, puis l'ai corrigée.
- [ ] Je pilote l'apparence par des **classes**, jamais par `element.style`.
- [ ] Je structure mon code autour d'un état et d'une **seule fonction `rendre()`**.
- [ ] Je traite l'état vide, et je distingue « rien à afficher » de « aucun résultat ».
- [ ] Mes fichiers séparent api / ui / app.
- [ ] Je sais pourquoi `defer` est la bonne façon de charger un script.
- [ ] Je construis puis j'insère en une fois, et j'ai **mesuré** la différence.

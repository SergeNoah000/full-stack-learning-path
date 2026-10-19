# Leçon 08 — Événements, délégation, formulaires côté client

> 🎯 **À la fin de cette leçon** : tu fais réagir une page aux actions de l'utilisateur, avec un seul écouteur là où les débutants en mettent cinquante.
> ⏱️ 4 h · **Prérequis** : leçon 07, et les closures du palier 1 (leçon 05).

---

## De quoi on parle

Un **événement** est une notification émise par le navigateur quand quelque chose se produit : un clic, une frappe au clavier, la soumission d'un formulaire, le chargement d'une image, un défilement. Tu ne provoques pas ces événements : tu **t'abonnes** à ceux qui t'intéressent.

```js
bouton.addEventListener("click", (evenement) => { … });
```

La fonction que tu fournis est un **écouteur** (ou *handler*). Elle reçoit un objet **événement** qui décrit ce qui s'est passé : sur quel élément (`target`), quelle touche, quelles coordonnées.

Deux mécanismes structurent tout le reste. La **propagation** : un clic sur un bouton déclenche aussi l'événement sur son parent, puis sur le parent du parent, jusqu'à `document` — on dit qu'il « remonte » (*bubbling*). Et le **comportement par défaut** : certains événements déclenchent une action native du navigateur (un lien navigue, un formulaire s'envoie et recharge la page), qu'on peut annuler avec `preventDefault()`.

La **délégation** est la technique qui découle de la propagation : au lieu d'écouter chaque enfant, on écoute le **parent** et on identifie la cible.

---

## À quoi ça sert, concrètement

**Parce que c'est la moitié manquante de la leçon 07.** Tu sais modifier le DOM ; les événements sont ce qui te dit **quand** le faire. Les deux ensemble font une interface.

**Parce que la délégation règle un problème que tu vas forcément rencontrer.** Dès que tu génères une liste depuis des données (leçon 07) et que tu la redessines après chaque changement, les écouteurs attachés aux anciens éléments disparaissent avec eux. Les boutons cessent de répondre, sans erreur, sans message. La délégation supprime le problème à la racine : un seul écouteur sur le conteneur, qui survit à tous les redessinages.

**Parce que la gestion du formulaire côté client décide de la qualité perçue.** Valider pendant la saisie plutôt qu'après l'envoi, afficher l'erreur sous le bon champ, désactiver le bouton pendant l'envoi pour éviter la double soumission : ce sont des détails qui séparent une interface agréable d'une interface frustrante.

---

## Où ça intervient dans le développement

Les événements sont le **point d'entrée de toute interaction**, et ils se placent exactement ici dans ta boucle :

```
   ÉVÉNEMENT (clic, saisie, soumission)     ← cette leçon
         │
         ▼
   on met à jour l'ÉTAT  (le tableau de données)
         │
         ▼
   rendre()  →  le DOM reflète l'état        ← leçon 07
```

Cette boucle — *événement → état → rendu* — est l'architecture de toute application frontend, et tu viens d'en écrire les trois morceaux. Au palier 3, React la formalisera avec exactement les mêmes mots (`onClick` → `setState` → nouveau rendu). Au palier 9, Flutter fera de même. Tu auras construit le modèle avant de rencontrer les outils qui l'imposent.

Un piège d'architecture à éviter dès maintenant : **l'écouteur ne doit pas manipuler le DOM directement**. Il met à jour l'état et appelle `rendre()`. Sinon tu retombes dans la modification chirurgicale, et l'affichage se désynchronise.

Et deux prolongements à connaître. Au **palier 4**, tu retrouveras la même idée côté serveur sous un autre nom : les *middlewares* d'Express forment une chaîne où chacun peut interrompre le traitement — c'est conceptuellement proche de la propagation et de `preventDefault`. Au **palier 7**, le patron *Observer* que tu étudieras **est** le mécanisme des événements : tu l'auras pratiqué deux ans avant de lui donner un nom.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire ton premier formulaire qui ne recharge pas la page, et découvrir `preventDefault()`. Tu vas aussi, presque certainement, attacher des écouteurs dans une boucle, redessiner ta liste, et constater que tout a cessé de fonctionner. C'est le moment où la délégation devient évidente.

### En équipe, en entreprise

**La délégation est la norme pour les listes.** Dans n'importe quelle base de code sérieuse, un tableau de cent lignes a un écouteur, pas cent.

**On te parlera de fuites mémoire.** Un écouteur attaché et jamais retiré sur un élément supprimé empêche le ramasse-miettes de libérer la mémoire. Sur une application à page unique utilisée pendant des heures, ça s'accumule. C'est une des raisons pour lesquelles React gère le cycle de vie à ta place.

**Tu rencontreras `debounce` partout.** Un champ de recherche qui déclenche une requête à chaque frappe envoie quinze requêtes pour un mot. On attend que l'utilisateur ait fini de taper. C'est une closure (palier 1, leçon 05) et c'est l'un des outils les plus réutilisés du frontend.

**Et tu verras encore beaucoup de `onclick` dans le HTML** (`<button onclick="faire()">`). Ça fonctionne, c'est daté, ça mélange comportement et structure, et ça ne permet qu'un seul écouteur. On ne l'écrit plus.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `addEventListener` sur `click`, `submit`, `input`, `change`, plus `preventDefault()`, `event.target` et la délégation avec `closest()`.

Régulièrement : `keydown` (pour `Escape` et `Entrée`), `focus`/`blur`, `removeEventListener`, l'option `{ once: true }`, `FormData` pour lire un formulaire entier, et `debounce`.

Rare, et hors sujet pour l'instant : la phase de capture (le troisième argument `true`), `stopPropagation` (à n'utiliser qu'en connaissance de cause — il casse la délégation des autres), les événements personnalisés (`CustomEvent`), les événements de pointeur et de toucher, `IntersectionObserver` (très utile pour le défilement, mais plus tard), `AbortController` pour retirer plusieurs écouteurs d'un coup, `passive: true` (une optimisation de défilement). Et deux choses à ne pas faire : les attributs `onclick` dans le HTML, et `stopPropagation()` « pour que ça marche » sans comprendre.

---

## La mécanique

### S'abonner

```js
bouton.addEventListener("click", (e) => {
  console.log("cliqué sur", e.target);
});

// Options utiles
bouton.addEventListener("click", gerer, { once: true });   // une seule fois, puis se retire
bouton.removeEventListener("click", gerer);                 // ⚠️ exige la MÊME référence
```

Le `removeEventListener` mérite une précision qui piège tout le monde : il faut lui passer **exactement la même fonction**. Une fonction fléchée écrite sur place crée une nouvelle référence à chaque appel, donc elle ne peut pas être retirée. Si tu dois retirer un écouteur, nomme la fonction.

### Les événements qui comptent

```js
formulaire.addEventListener("submit", e => { e.preventDefault(); … });  // envoi
champ.addEventListener("input", e => { … });      // à CHAQUE frappe
select.addEventListener("change", e => { … });    // quand la valeur est validée
document.addEventListener("keydown", e => {
  if (e.key === "Escape") fermerPanneau();
});
```

La distinction `input` / `change` revient souvent : `input` se déclenche à chaque caractère tapé (pour une recherche en direct, un compteur de caractères), `change` se déclenche quand la valeur est **confirmée** — à la perte de focus pour un champ texte, immédiatement pour une case ou un menu déroulant.

### `preventDefault` : reprendre la main

```js
formulaire.addEventListener("submit", (e) => {
  e.preventDefault();          // ⭐ sans ça, la page se recharge et tout est perdu
  const donnees = new FormData(formulaire);
  ajouterDepense({
    description: donnees.get("description"),
    montant: Number(donnees.get("montant")),
  });
  formulaire.reset();
});
```

`FormData` lit tous les champs d'un coup, par leur attribut `name` — et c'est la raison pour laquelle `name` était obligatoire à la leçon 02. Note aussi le `Number()` : un champ de formulaire rend **toujours une chaîne**, même en `type="number"`. C'est la frontière de la leçon 01 du palier 1, et c'est exactement là qu'elle se situe.

### ⭐ La délégation d'événements

Voici le problème, puis la solution.

```js
// ❌ Le piège : un écouteur par bouton
document.querySelectorAll(".supprimer").forEach(b => {
  b.addEventListener("click", () => supprimer(b.dataset.id));
});
rendre();   // on redessine la liste… et tous ces écouteurs sont perdus avec les anciens boutons
```

```js
// ✅ Un seul écouteur sur le conteneur, qui survit à tous les redessinages
liste.addEventListener("click", (e) => {
  const bouton = e.target.closest(".supprimer");   // la cible exacte, ou un de ses parents
  if (!bouton) return;                              // le clic était ailleurs : on sort
  supprimer(Number(bouton.dataset.id));
});
```

Trois choses expliquent pourquoi cette version est supérieure.

Elle **fonctionne avec les éléments futurs** : tu peux ajouter mille lignes, l'écouteur du parent les couvre toutes, puisque leurs clics remontent jusqu'à lui.

Elle **ne coûte qu'un écouteur** au lieu de mille — moins de mémoire, pas de fuite.

Et le `closest()` est le détail qui la rend fiable : si ton bouton contient une icône, `e.target` sera l'icône, pas le bouton. `closest(".supprimer")` remonte depuis la cible jusqu'au premier ancêtre correspondant. Sans lui, un clic sur l'icône ne ferait rien — et c'est un bug très fréquent.

### Validation de formulaire côté client

```js
const champ = document.querySelector("#montant");
const erreur = document.querySelector("#erreur-montant");

champ.addEventListener("input", () => {
  const valeur = Number(champ.value);
  if (champ.value.trim() === "") {
    afficherErreur("Le montant est obligatoire");
  } else if (Number.isNaN(valeur) || valeur <= 0) {
    afficherErreur("Le montant doit être un nombre positif");
  } else {
    effacerErreur();
  }
});

function afficherErreur(message) {
  erreur.textContent = message;                  // textContent : jamais innerHTML
  champ.setAttribute("aria-invalid", "true");
  champ.classList.add("en-erreur");              // l'apparence reste au CSS
}
```

Trois points de méthode. Le message d'erreur est du **texte relié au champ** (leçon 02, `aria-describedby`), pas seulement une bordure rouge. L'apparence passe par une **classe**, pas par `element.style`. Et on valide pendant la saisie **sans** agresser : afficher l'erreur dès le premier caractère tapé dans un champ vide est désagréable — beaucoup d'interfaces n'affichent l'erreur qu'à la perte de focus (`blur`) ou après la première tentative d'envoi.

Et le rappel qui vaut pour tout le parcours : **cette validation est du confort**. Celle qui protège est côté serveur (palier 4).

### `debounce` : ne pas réagir à chaque frappe

```js
function debounce(fn, delai = 300) {
  let minuteur;                                   // vit dans la closure (palier 1, leçon 05)
  return (...args) => {
    clearTimeout(minuteur);
    minuteur = setTimeout(() => fn(...args), delai);
  };
}

recherche.addEventListener("input", debounce((e) => {
  filtrer(e.target.value);
}, 300));
```

Sans `debounce`, taper « douala » déclenche six filtrages — et six requêtes réseau à la leçon 09. Avec, un seul, trois cents millisecondes après la dernière frappe. C'est l'une des fonctions les plus réutilisées du métier, et c'est une closure : tu l'as écrite au palier 1 sans savoir à quoi elle servirait.

### Éviter la double soumission

```js
formulaire.addEventListener("submit", async (e) => {
  e.preventDefault();
  const bouton = formulaire.querySelector("button[type=submit]");
  bouton.disabled = true;                         // ⭐ pendant l'envoi
  bouton.textContent = "Envoi…";
  try {
    await envoyer(new FormData(formulaire));
  } finally {
    bouton.disabled = false;                      // dans TOUS les cas
    bouton.textContent = "Envoyer";
  }
});
```

Le `finally` est indispensable : sans lui, une erreur réseau laisse le bouton désactivé pour toujours et l'utilisateur est bloqué. C'est le même raisonnement que l'indicateur de chargement qui ne s'arrête jamais (palier 1, leçon 10).

---

## Les problèmes que tu vas rencontrer

**Ma page se recharge quand je soumets le formulaire.** `preventDefault()` manque. C'est l'erreur n°1 de cette leçon.

**Mes boutons cessent de fonctionner après une mise à jour de la liste.** Tu as attaché les écouteurs aux éléments, et tu les as remplacés. Délégation.

**Mon clic ne fait rien quand je clique sur l'icône du bouton.** `e.target` est l'icône. Utilise `closest()`.

**Mon écouteur se déclenche plusieurs fois pour un seul clic.** Tu l'as attaché plusieurs fois — typiquement, `addEventListener` dans une fonction appelée à chaque rendu. Attache les écouteurs **une seule fois**, à l'initialisation, et c'est précisément ce que la délégation rend facile.

**`removeEventListener` ne retire rien.** Tu as passé une fonction fléchée écrite sur place : ce n'est pas la même référence.

**Mon `Number(champ.value)` vaut 0 alors que le champ est vide.** `Number("")` vaut `0`, pas `NaN` (palier 1, leçon 01). Teste la chaîne vide **avant** de convertir.

**Ma recherche envoie une requête par caractère.** `debounce`.

**L'utilisateur clique deux fois et je crée deux enregistrements.** Désactive le bouton pendant l'envoi.

**Mon `Escape` ne fonctionne pas.** L'écouteur est sur un élément qui n'a pas le focus. Pour les raccourcis globaux, écoute sur `document`.

**J'ai mis `stopPropagation()` et maintenant autre chose est cassé.** Tu as interrompu la remontée, donc les écouteurs délégués des parents ne reçoivent plus rien. À n'utiliser qu'en sachant précisément ce qu'on bloque.

---

## Ce qu'on te demandera

En **test technique**, la liste de tâches interactive est l'exercice canonique, et la **délégation** est ce qu'on regarde. Un candidat qui attache un écouteur par ligne a un code qui casse dès qu'on ajoute un élément — le correcteur le testera.

En **entretien** : « qu'est-ce que la délégation d'événements et quel problème résout-elle ? » (très fréquente), « à quoi sert `preventDefault` ? », « différence entre `input` et `change` ? », « qu'est-ce qu'un `debounce` et comment l'écrirais-tu ? » (on peut te demander de le coder — c'est un classique des closures), « différence entre `e.target` et `e.currentTarget` ? ».

En **travail réel**, on attendra que tes formulaires ne se soumettent pas deux fois et que tes messages d'erreur soient exploitables.

---

## Ce qui te démarquera

**Déléguer par réflexe.** C'est le marqueur technique le plus net de cette leçon, et il se voit en trois lignes de code.

**Utiliser `closest()`.** Beaucoup de gens écrivent `e.target.classList.contains(...)` et se demandent pourquoi ça échoue sur les boutons avec icône.

**Savoir écrire `debounce` sans le chercher.** Trois lignes, une closure, et un gain immédiat sur toute recherche.

**Désactiver le bouton pendant l'envoi, avec un `finally`.** Presque personne ne le fait au palier junior, et c'est un vrai problème en production (doubles paiements, doublons en base).

**Respecter la boucle événement → état → rendu.** Ne pas manipuler le DOM dans l'écouteur. C'est ce qui rendra ton projet 2 maintenable, et ce que le référent cherchera.

**Penser au clavier.** Gérer `Escape` pour fermer, `Entrée` pour valider. Et savoir qu'un `<div>` avec un `onclick` n'est pas atteignable au clavier — le lien avec la leçon 01 est direct.

---

## 📚 À lire

**The Odin Project → JavaScript → DOM Manipulation and Events**.

**MDN → *Introduction to events*** pour le modèle, puis ***Event bubbling and capture*** — c'est la page qui rend la délégation évidente.

**javascript.info** chapitres 2.1 à 2.5 (introduction, bubbling, délégation, actions par défaut). Le chapitre **2.3 sur la délégation** est le plus rentable de la leçon.

**MDN → `FormData`** pour la lecture des formulaires, et la page sur `KeyboardEvent.key` quand tu gèreras les raccourcis.

---

## 🤖 Le mini-projet à demander à l'IA

Les événements s'apprennent en construisant une interface qui réagit, et en rencontrant les pièges.

> « Je suis en formation de développeur, palier 2 (frontend). Je travaille les événements, la délégation et les formulaires. Donne-moi le cahier des charges d'une **liste de tâches sans framework**, **sans aucun code** : ajout par formulaire, cocher, supprimer, filtrer (toutes / à faire / faites), compteur de tâches restantes, tout persisté. Impose-moi quatre contraintes : **un seul écouteur** pour toute la liste (délégation), la boucle événement → état → rendu, un `debounce` sur le champ de recherche, et un bouton désactivé pendant les opérations. Donne-moi aussi la liste des cas d'erreur de saisie à traiter. Quand je t'envoie mon code, vérifie seulement : la délégation, la séparation état/DOM, la gestion clavier (Escape, Entrée), et les doubles soumissions possibles. **N'écris pas le code.** »

Puis le diagnostic, qui est la partie formatrice :

> « Donne-moi 6 extraits de code JavaScript où la gestion d'événements est **subtilement cassée** : un écouteur attaché dans la fonction de rendu (donc dupliqué à chaque appel), un `removeEventListener` qui ne retire rien, un clic qui échoue parce que la cible est une icône, un `preventDefault` manquant, un `stopPropagation` qui casse une délégation voisine, et une recherche sans `debounce`. Ne me dis pas où est le problème. Je diagnostique, j'explique **le symptôme que verrait l'utilisateur**, puis je corrige. »

Le détour par « le symptôme que verrait l'utilisateur » est volontaire : c'est ainsi que les bugs te seront rapportés en entreprise.

---

## 🛠️ À faire

1. **Formulaire sans rechargement** : un champ, un bouton, et l'ajout d'un élément à une liste. Constate d'abord le rechargement **sans** `preventDefault`, puis corrige.
2. Lis tout le formulaire avec **`FormData`** plutôt que champ par champ.
3. **Démontre le piège** : attache un écouteur à chaque bouton de suppression dans une boucle, puis redessine la liste et constate que plus rien ne répond. **Corrige par délégation.**
4. **Le piège de l'icône** : mets une icône (`<span>✕</span>`) dans ton bouton de suppression, clique dessus avec une délégation sans `closest()`, constate l'échec, corrige.
5. **L'écouteur dupliqué** : attache un écouteur à l'intérieur de ta fonction `rendre()`, appelle-la trois fois, et compte combien de fois un seul clic se déclenche. Explique dans ton journal.
6. **Validation en direct** : un champ montant avec message d'erreur sous le champ, relié par `aria-describedby`, classe CSS pour l'apparence. Traite : vide, non numérique, négatif, zéro.
7. **Écris `debounce`** de mémoire et applique-le à un champ de recherche qui filtre ta liste. Compte les appels avec et sans, dans la console.
8. **Double soumission** : simule un envoi lent (`await new Promise(r => setTimeout(r, 2000))`), clique trois fois rapidement, constate. Corrige avec `disabled` et `finally`.
9. **Clavier** : `Escape` ferme un panneau, `Entrée` valide un champ. L'écouteur global sur `document`.
10. **La boucle complète** : reprends ton gestionnaire de dépenses de la leçon 07 et branche tous les événements. Vérifie que **aucun écouteur ne touche directement au DOM** — ils modifient l'état et appellent `rendre()`.

<details>
<summary>Corrections et points de contrôle</summary>

**3.** Après `rendre()`, les anciens boutons ont été détruits et remplacés par de nouveaux, qui n'ont jamais reçu d'écouteur. Rien dans la console, aucune erreur : c'est ce qui rend ce bug déroutant. La délégation sur le conteneur le supprime définitivement, puisque le conteneur, lui, n'est jamais remplacé.

**5.** Trois appels à `rendre()` attachent trois écouteurs au même élément, donc un clic déclenche l'action **trois fois**. Sur un bouton « supprimer », ça supprime trois éléments ; sur un paiement, c'est plus grave. **Règle : les écouteurs s'attachent une seule fois, à l'initialisation, hors de la fonction de rendu.** La délégation rend cette règle naturelle.

**6.** L'ordre des tests compte :
```js
if (champ.value.trim() === "") { … }              // le vide D'ABORD
else if (Number.isNaN(Number(champ.value))) { … } // puis le format
else if (Number(champ.value) <= 0) { … }          // puis la valeur
```
Si tu testes `Number(champ.value) <= 0` en premier, un champ vide donne `Number("") === 0` et affiche « doit être positif » au lieu de « obligatoire » — un message faux, et c'est le genre de détail qui se remarque à l'usage.

**7.**
```js
function debounce(fn, delai = 300) {
  let minuteur;
  return (...args) => {
    clearTimeout(minuteur);
    minuteur = setTimeout(() => fn(...args), delai);
  };
}
```
Ce qui fait fonctionner cette fonction, c'est que `minuteur` **survit** entre deux appels : c'est la closure du palier 1, leçon 05. Sans elle, chaque appel aurait son propre minuteur et rien ne serait annulé.

**8.** Sans protection, trois clics envoient trois requêtes et créent trois enregistrements. Le `finally` est indispensable : si l'envoi échoue, le bouton doit redevenir actif, sinon l'utilisateur ne peut plus rien faire sans recharger la page.

**10.** Le contrôle : cherche dans tes écouteurs toute ligne contenant `querySelector`, `textContent`, `append` ou `classList` **en dehors** de ta fonction de rendu. S'il y en a, tu mélanges les responsabilités, et c'est là que les désynchronisations apparaîtront.
</details>

---

## ✅ Acquis si…

- [ ] J'utilise `addEventListener`, jamais les attributs `onclick` du HTML.
- [ ] Mes formulaires appellent `preventDefault()` et lisent leurs données avec `FormData`.
- [ ] J'utilise la **délégation** pour toute liste dynamique, avec `closest()`.
- [ ] J'explique le problème que la délégation résout, et je l'ai provoqué volontairement.
- [ ] Mes écouteurs sont attachés **une seule fois**, hors de la fonction de rendu.
- [ ] Mes écouteurs modifient l'état et appellent `rendre()` — ils ne touchent pas au DOM.
- [ ] J'écris `debounce` de mémoire et je sais pourquoi c'est une closure.
- [ ] Mes boutons sont désactivés pendant un envoi, avec un `finally`.
- [ ] Mes messages d'erreur sont du texte relié au champ, et l'ordre de mes tests est correct.
- [ ] Je gère `Escape` et `Entrée`.

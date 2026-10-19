# Leçon 03 — CSS : sélecteurs, spécificité, box model, unités

> 🎯 **À la fin de cette leçon** : tu sais pourquoi une règle CSS s'applique ou non, et tu maîtrises le modèle qui décide de la taille de chaque élément.
> ⏱️ 4 h · **Prérequis** : leçons 01–02.

---

## Le CSS, c'est quoi

Le CSS est un langage de **présentation**. Il ne décrit pas ce qu'est un contenu (c'est le rôle du HTML) mais comment il doit apparaître : taille, couleur, espacement, position.

Sa forme est simple : un **sélecteur** désigne des éléments, un bloc de **déclarations** leur applique des valeurs.

```css
.carte h2 {          /* sélecteur */
  font-size: 1.5rem;  /* propriété : valeur */
  margin-bottom: 1rem;
}
```

Les trois mots qui donnent leur nom au langage — *Cascading Style Sheets* — désignent le vrai sujet de cette leçon : la **cascade**. Quand plusieurs règles visent le même élément, il faut un arbitrage. Cet arbitrage repose sur trois mécanismes : l'**origine** de la règle, sa **spécificité**, et son **ordre** d'apparition. Comprendre cet arbitrage, c'est cesser de subir le CSS.

Le second pilier est le **box model** : tout élément est une boîte, composée du contenu, d'un `padding` (espace intérieur), d'une `border`, et d'un `margin` (espace extérieur).

---

## À quoi ça sert, concrètement

**Parce que le CSS est la source de frustration n°1 des débutants**, et que cette frustration a deux causes précises, toutes deux traitées ici : « ma règle ne s'applique pas » (c'est la spécificité) et « mon élément n'a pas la taille que je demande » (c'est le box model). Un développeur qui comprend ces deux mécanismes cesse d'ajouter des `!important` au hasard.

**Parce que c'est 40 % du travail d'un frontend.** On imagine que le métier consiste à écrire de la logique ; en réalité, une grande partie du temps passe à faire tenir une interface sur tous les écrans. Autant comprendre les règles du jeu.

**Parce que le CSS mal maîtrisé devient ingérable très vite.** Une feuille de style sans discipline de sélecteurs produit, au bout de quelques mois, un fichier où plus personne n'ose rien modifier de peur de casser une page inconnue. C'est le problème que les méthodologies (BEM) et les outils (Tailwind, au palier 3) cherchent à résoudre — et tu comprendras pourquoi ils existent.

---

## Où ça intervient dans le développement

Le CSS est la couche de présentation, et elle doit rester **séparée** des deux autres. Cette séparation est le premier niveau du fil rouge architecture, et elle se vérifie à une question : *si je change le design, combien de fichiers je touche ?*

```
   HTML  → le sens          (leçons 01-02)
   CSS   → l'apparence      ← cette leçon, et 04 à 06
   JS    → le comportement  (leçons 07-09)
```

Trois choses à savoir pour la suite du parcours.

**Au palier 3, tu rencontreras Tailwind**, qui prend le contre-pied : au lieu d'écrire des classes sémantiques dans une feuille séparée, on compose des classes utilitaires directement dans le balisage (`class="flex items-center gap-4"`). C'est aujourd'hui le standard en entreprise, et son intérêt n'est compréhensible que si tu as connu le problème qu'il résout : la difficulté de nommer, et la peur de supprimer une règle. **Écris du CSS à la main pendant ce palier** ; tu apprécieras l'outil ensuite au lieu de le subir.

**Aux paliers 5 et 6, le CSS sera servi par ton serveur** et devra être mis en cache correctement. Les « fichiers statiques » dont parlent Django et Laravel, c'est lui.

**Au palier 8, sa taille deviendra un sujet de performance.** Un CSS de 400 Ko bloque l'affichage de la page, parce que le navigateur ne peut rien peindre avant de l'avoir lu — c'est une ressource dite « bloquante ».

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas passer un temps considérable dans l'**inspecteur** des outils de développement, et c'est normal : c'est l'outil principal du CSS. Il te montre quelles règles s'appliquent, lesquelles sont barrées (donc écrasées), et le box model de l'élément sélectionné en couleurs. Tu peux y modifier les valeurs en direct.

Prends ce réflexe tout de suite : **ne devine jamais pourquoi une règle ne s'applique pas — inspecte**. La réponse est toujours affichée.

### En équipe, en entreprise

**Tu liras plus de CSS que tu n'en écriras.** Arriver sur une feuille de style de 3 000 lignes écrite par quatre personnes est le cas normal. La compétence recherchée est de savoir **où** intervenir sans rien casser.

**`!important` est un signal d'alarme.** Dans une revue de code, il faut le justifier. Sa présence signale presque toujours qu'on n'a pas compris la spécificité, ou qu'un autre CSS est trop spécifique — et la vraie correction est là.

**Tu rencontreras des conventions de nommage.** BEM (`.carte__titre--grand`) est la plus répandue dans le CSS classique. Son but est d'obtenir une spécificité **plate** : toutes les règles au même niveau, donc arbitrées par l'ordre, prévisibles.

**Et tu rencontreras des bases de code sans aucune convention.** Des sélecteurs à cinq niveaux (`.page .contenu .carte ul li a`), du `!important` partout, des règles mortes dont personne n'ose se débarrasser. C'est là que la compréhension de la cascade cesse d'être théorique.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : les sélecteurs de **classe** (l'immense majorité de ce que tu écriras), le sélecteur de descendant, `box-sizing`, `margin`/`padding`, `display`, les couleurs, `font-size`, `rem`, les variables CSS, `:hover` et `:focus-visible`.

Régulièrement : les pseudo-classes (`:first-child`, `:not()`, `:nth-child()`), les pseudo-éléments (`::before`, `::after`), les sélecteurs d'attribut, `inherit`/`initial`, les media queries (leçon 05).

Rare, et sans intérêt pour toi aujourd'hui : les sélecteurs d'adjacence complexes (`+`, `~`), `:has()` (puissant mais récent), les couches en cascade (`@layer`), le `@scope`, les propriétés personnalisées enregistrées (`@property`), les sélecteurs de type (`div`, `p`) utilisés pour styler — on leur préfère presque toujours des classes, sauf pour une base typographique. Et deux choses qu'on utilisait avant et qu'on ne fait plus : `float` pour la mise en page (remplacé par Flexbox et Grid) et les positionnements absolus pour tout placer.

---

## La mécanique

### Les sélecteurs qui comptent

```css
.carte            { }   /* classe — 95 % de ce que tu écriras */
#entete           { }   /* identifiant — à éviter pour styler (voir spécificité) */
h2                { }   /* type — pour une base typographique */
.carte h2         { }   /* descendant : les h2 DANS .carte */
.carte > h2       { }   /* enfant direct seulement */
.carte:hover      { }   /* état */
a:focus-visible   { }   /* focus clavier — jamais le supprimer */
li:first-child    { }   /* position */
input:not([type="hidden"]) { }   /* négation */
[data-etat="ok"]  { }   /* attribut — pratique pour lier CSS et JS */
.carte::before    { }   /* pseudo-élément : un faux élément décoratif */
```

Une recommandation pratique qui vaut pour tout le parcours : **style avec des classes**, presque exclusivement. Les classes sont réutilisables, portent une intention, et ont toutes la même spécificité — ce qui rend la cascade prévisible.

### La spécificité : pourquoi ta règle ne s'applique pas

Quand deux règles visent le même élément, le navigateur arbitre dans cet ordre :

1. **L'origine et l'importance.** `!important` écrase tout le reste (et c'est pourquoi on l'évite : il casse l'arbitrage).
2. **La spécificité**, calculée comme un triplet *(identifiants, classes, types)* :

| Sélecteur | Poids | |
|---|---|---|
| `style="…"` en ligne | le plus fort | à éviter |
| `#entete` | (1,0,0) | très fort |
| `.carte`, `:hover`, `[type]` | (0,1,0) | **la bonne zone** |
| `h2`, `::before` | (0,0,1) | faible |
| `*` | (0,0,0) | nul |

3. **L'ordre d'apparition** : à spécificité égale, **la dernière règle gagne**.

```css
#contenu .carte h2 { color: red; }    /* (1,1,1) → gagne */
.carte h2          { color: blue; }   /* (0,1,1) */
```

Ce qu'il faut en retenir, pratiquement : **garde tes sélecteurs plats et à base de classes**. Un sélecteur très spécifique crée une dette — pour l'écraser plus tard, il faudra être encore plus spécifique, puis encore plus, et on finit par le `!important` qui rend tout imprévisible. Un identifiant dans une feuille de style est presque toujours une mauvaise idée : il est dix fois plus fort qu'une classe et ne peut servir qu'une fois.

### Le box model : pourquoi ton élément n'a pas la bonne taille

```
   ┌─────────────── margin (espace EXTÉRIEUR, transparent) ───────────────┐
   │  ┌──────────── border ─────────────────────────────────────────────┐ │
   │  │  ┌───────── padding (espace INTÉRIEUR, prend le fond) ───────┐ │ │
   │  │  │                     contenu                               │ │ │
   │  │  └───────────────────────────────────────────────────────────┘ │ │
   │  └────────────────────────────────────────────────────────────────┘ │
   └─────────────────────────────────────────────────────────────────────┘
```

Le piège historique : par défaut, `width: 300px` fixe la largeur du **contenu seul**. Avec un `padding: 20px` et une `border: 2px`, l'élément occupe en réalité 344 pixels. D'où la règle que **tout projet moderne met en première ligne de sa feuille de style** :

```css
*, *::before, *::after {
  box-sizing: border-box;   /* width inclut désormais padding et border */
}
```

Avec `border-box`, `width: 300px` signifie « cet élément fait 300 pixels », ce qui est le comportement que tout le monde attend. **Mets cette règle au début de chaque projet**, et la moitié de tes problèmes de dimension disparaît.

Deux autres comportements à connaître, parce qu'ils surprennent. Les **marges verticales fusionnent** (*margin collapse*) : deux éléments avec 20 pixels de marge en dessous et au-dessus sont séparés de 20 pixels, pas de 40. Et un **élément en ligne** (`span`, `a`) ignore `width`, `height` et les marges verticales — il faut le passer en `inline-block` ou `block`.

### `display` : la propriété qui décide de tout

```css
display: block;         /* occupe toute la largeur, respecte width/height */
display: inline;        /* dans le flux du texte, ignore width/height */
display: inline-block;  /* dans le flux, mais dimensionnable */
display: flex;          /* mise en page sur un axe (leçon 04) */
display: grid;          /* mise en page sur deux axes (leçon 05) */
display: none;          /* retiré du flux ET de l'accessibilité */
```

### Les unités : laquelle quand

```css
font-size: 1.125rem;   /* rem : relatif à la racine — pour les POLICES et les espacements */
padding: 0.5em;        /* em : relatif au parent — pour un composant qui s'adapte à sa taille */
width: 50%;            /* % : relatif au conteneur */
height: 100vh;         /* vh/vw : relatif à la fenêtre (⚠️ sur mobile, voir plus bas) */
border: 1px solid;     /* px : pour ce qui ne doit pas grandir (bordures, ombres) */
width: min(90%, 60ch); /* fonctions modernes : très utiles */
```

La règle de choix, et la raison derrière : **`rem` pour les tailles de police et les espacements**, parce que `rem` respecte le réglage de taille de police du navigateur de l'utilisateur. Quelqu'un qui a agrandi sa police système pour des raisons de vue verra ton site s'adapter — avec des `px`, il ne verra rien changer. C'est un enjeu d'accessibilité, pas de goût.

Et une astuce de métier : `60ch` vaut environ soixante caractères, ce qui est la largeur de lecture confortable. `max-width: 65ch` sur un paragraphe est l'un des réglages typographiques les plus rentables qui existent.

### Les variables CSS

```css
:root {
  --couleur-principale: #0b6e4f;
  --espace: 1rem;
  --rayon: 8px;
}

.carte {
  background: var(--couleur-principale);
  padding: var(--espace);
  border-radius: var(--rayon);
}
```

Elles sont lisibles par le JavaScript, modifiables à l'exécution, et héritées. C'est avec elles qu'on fait un **mode sombre** en quelques lignes, et c'est la base de tout système de design. Prends l'habitude de définir tes couleurs et tes espacements en variables dès ton premier projet.

---

## Les problèmes que tu vas rencontrer

**Ma règle ne s'applique pas.** Dans l'ordre : inspecte l'élément (la règle est-elle listée ? barrée ?) · vérifie la spécificité de ce qui gagne · vérifie que le sélecteur correspond vraiment (une faute de frappe dans un nom de classe est muette) · vérifie que le fichier CSS est bien chargé · vérifie l'ordre des fichiers.

**Mon élément dépasse son conteneur.** Presque toujours le box model. Ajoute la règle `border-box` globale.

**Mes marges ne s'additionnent pas.** La fusion des marges verticales. Si tu veux un contrôle exact, utilise `gap` (avec Flexbox ou Grid) plutôt que des marges — c'est l'approche moderne.

**`width` ne fait rien sur mon `<span>`.** C'est un élément en ligne.

**`100vh` crée un défilement indésirable sur mobile.** La barre d'adresse des navigateurs mobiles rend `100vh` plus grand que la zone visible. Utilise `100dvh` (hauteur dynamique), bien mieux supporté aujourd'hui.

**J'ai mis `!important` et maintenant je ne peux plus rien écraser.** C'est exactement le problème : tu as cassé l'arbitrage. Retire-le et corrige la spécificité en amont.

**Ma couleur de fond ne couvre pas tout l'élément.** Le `margin` est transparent par construction : c'est le `padding` qui prend le fond.

**Mon CSS marche en local et pas en ligne.** Chemin relatif incorrect, ou cache du navigateur. `Ctrl+Shift+R` force le rechargement.

---

## Ce qu'on te demandera

En **entretien frontend**, les trois questions quasi certaines : « explique le box model et ce que change `border-box` », « comment se calcule la spécificité ? », « différence entre `rem`, `em` et `px`, et quand utilises-tu chacun ? ».

Suivent souvent : « pourquoi éviter `!important` ? », « différence entre `display: none`, `visibility: hidden` et `opacity: 0` ? », « qu'est-ce que la fusion des marges ? ».

En **test technique**, on regarde ton CSS autant que ton rendu : des sélecteurs plats, des classes nommées par intention, des variables pour les valeurs répétées, aucun `!important`, aucun style en ligne.

En **revue de code**, les remarques fréquentes portent sur les sélecteurs trop spécifiques, les valeurs magiques répétées (`margin-left: 23px` à six endroits), et les `px` sur les tailles de police.

---

## Ce qui te démarquera

**Diagnostiquer dans l'inspecteur au lieu de deviner.** C'est la compétence la plus utile de cette leçon, et elle se voit immédiatement quand on travaille à côté de quelqu'un.

**Garder une spécificité plate.** Un CSS où toutes les règles sont au même niveau est un CSS dans lequel on peut intervenir sans peur. Savoir dire « je ne vais pas surcharger, je vais corriger le sélecteur trop spécifique » est un réflexe de professionnel.

**Utiliser des variables CSS dès le début.** Couleurs, espacements, rayons. Le jour où le client veut changer la couleur principale, c'est une ligne.

**Penser en `rem` pour la typographie.** Et savoir expliquer pourquoi : l'utilisateur qui a agrandi sa police système.

**Connaître `max-width: 65ch`.** Un réglage, un gain de lisibilité immédiat, et presque personne ne le connaît.

---

## 📚 À lire

**The Odin Project → CSS Foundations** puis **Intermediate CSS** : la ressource principale, dans l'ordre.

**MDN → *CSS building blocks***, en particulier ***The box model*** et ***Cascade, specificity, and inheritance***. Cette dernière page est **la** lecture de la leçon : prends le temps, c'est elle qui te fera cesser de subir la cascade.

**web.dev/learn/css** : moderne, court, avec des démonstrations interactives. Les chapitres *Box model*, *Specificity* et *Sizing units* correspondent exactement à cette leçon.

Et garde **MDN** ouvert sur chaque propriété que tu utilises pour la première fois : la section « Valeurs » t'évitera beaucoup de tâtonnement.

---

## 🤖 Le mini-projet à demander à l'IA

Le CSS s'apprend en diagnostiquant, pas en lisant des listes de propriétés.

> « Je suis en formation de développeur, palier 2 (frontend). Je travaille la cascade, la spécificité et le box model. Donne-moi **8 situations de débogage CSS**, une par une : à chaque fois, du HTML et du CSS courts où **une règle ne s'applique pas** ou **un élément n'a pas la taille attendue**, pour une raison différente chaque fois (spécificité, ordre, box model, fusion de marges, élément en ligne, faute de frappe dans une classe, héritage, `!important`). Ne me dis pas la cause. Je dois diagnostiquer, expliquer **pourquoi**, puis corriger — et je dois te dire ce que j'ai vu dans l'inspecteur. Confirme ou corrige mon raisonnement. »

C'est l'exercice le plus proche du travail réel : en entreprise, on passe plus de temps à comprendre pourquoi un style ne s'applique pas qu'à en écrire de nouveaux.

Puis un exercice de structure :

> « Donne-moi une feuille de style de 60 lignes **telle qu'on en trouve dans un projet mal entretenu** : sélecteurs à quatre niveaux, deux identifiants, trois `!important`, des `px` partout pour les polices, des valeurs répétées sans variables. Ne commente pas. Ma mission : la réécrire à spécificité plate, avec des variables, sans changer le rendu. Ensuite, dis-moi ce que j'ai laissé passer. »

---

## 🛠️ À faire

1. Mets en place la base de tout projet : `box-sizing: border-box` global, des variables de couleurs et d'espacements dans `:root`, une typographie de base.
2. **Démontre le box model** : deux boîtes identiques de `width: 300px`, `padding: 20px`, `border: 2px`, l'une en `content-box` et l'autre en `border-box`. Mesure-les dans l'inspecteur.
3. **Démontre la spécificité** : un même élément visé par cinq règles de couleur différentes (type, classe, deux classes, identifiant, style en ligne). Prédis la couleur gagnante **avant** d'ouvrir le navigateur, puis vérifie dans l'inspecteur.
4. **Démontre la fusion des marges** : deux paragraphes avec `margin: 20px 0`. Mesure l'écart réel entre eux. Puis supprime la fusion avec `display: flex` et `gap` sur le parent.
5. Style les états d'un bouton : normal, `:hover`, `:active`, `:focus-visible`, `:disabled`. Le focus doit rester visible.
6. **L'exercice des unités** : une page avec des tailles en `px` et une avec les mêmes en `rem`. Change la taille de police par défaut de ton navigateur (réglages → apparence → taille de police : très grande) et compare. Note ce que tu observes dans ton journal.
7. Applique `max-width: 65ch` à un long paragraphe et compare la lisibilité avec la pleine largeur.
8. Fais un **mode sombre** en redéfinissant seulement tes variables dans `@media (prefers-color-scheme: dark)`.
9. Prends une page d'un vrai site, ouvre l'inspecteur, et trouve : une règle barrée (écrasée), un `!important`, et le box model d'un élément. Explique chacun.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** En `content-box`, la boîte occupe 300 + 40 + 4 = **344 pixels**. En `border-box`, elle occupe **300 pixels** et le contenu se réduit à 256. L'inspecteur montre les deux dans son schéma coloré. C'est la démonstration de la règle à mettre en tête de projet.

**3.** Ordre de victoire : style en ligne > identifiant > deux classes > une classe > type. Si tu t'es trompé, l'inspecteur te montre exactement quelles règles sont barrées et laquelle gagne — c'est le réflexe à prendre.

**4.** L'écart réel est de **20 pixels**, pas 40 : les marges verticales adjacentes fusionnent et seule la plus grande s'applique. Avec `display: flex; flex-direction: column; gap: 20px` sur le parent, il n'y a plus de fusion et l'espacement est exactement celui demandé. C'est l'une des raisons pour lesquelles `gap` a largement remplacé les marges dans le CSS moderne.

**6.** La page en `rem` grandit avec le réglage de l'utilisateur ; la page en `px` ne bouge pas. Ce que tu viens de constater concerne réellement des gens : c'est pour ça que les tailles de police s'écrivent en `rem`.

**8.**
```css
:root {
  --fond: #ffffff;
  --texte: #1a1a1a;
}
@media (prefers-color-scheme: dark) {
  :root {
    --fond: #121212;
    --texte: #e8e8e8;
  }
}
body { background: var(--fond); color: var(--texte); }
```
Si tu as utilisé des variables partout depuis le début, le mode sombre coûte dix lignes. Sinon, il coûte une réécriture — c'est l'argument le plus concret en faveur des variables.
</details>

---

## ✅ Acquis si…

- [ ] J'explique le box model et ce que change `border-box`, de mémoire.
- [ ] Je mets `box-sizing: border-box` au début de chaque projet.
- [ ] Je calcule la spécificité de deux sélecteurs et je dis lequel gagne.
- [ ] Je diagnostique « ma règle ne s'applique pas » **dans l'inspecteur**, sans deviner.
- [ ] Je n'utilise pas `!important`, et je sais expliquer pourquoi.
- [ ] Je style avec des classes, à spécificité plate.
- [ ] J'utilise `rem` pour les polices et les espacements, et je sais pourquoi.
- [ ] Je définis mes couleurs et espacements en variables CSS.
- [ ] Je connais la fusion des marges verticales et comment l'éviter.
- [ ] Mes états de focus restent toujours visibles.

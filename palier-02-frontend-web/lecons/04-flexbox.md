# Leçon 04 — Flexbox

> 🎯 **À la fin de cette leçon** : tu alignes et distribues des éléments sans tâtonner, et tu sais reconnaître d'un coup d'œil les mises en page qui relèvent de Flexbox.
> ⏱️ 4 h · **Prérequis** : leçon 03.

---

## Flexbox, c'est quoi

Flexbox est un **système de mise en page sur un seul axe** : une rangée, ou une colonne. Tu le déclares sur un conteneur, et ses enfants directs deviennent des « éléments flexibles » qui savent se répartir l'espace disponible.

```css
.barre { display: flex; }     /* les enfants de .barre s'alignent en rangée */
```

Deux notions suffisent à tout comprendre, et il faut les poser proprement parce que c'est là que les gens se perdent.

L'**axe principal** est la direction dans laquelle les éléments s'enchaînent — horizontale par défaut, verticale si tu passes en `flex-direction: column`. L'**axe transversal** est perpendiculaire.

Et c'est tout le piège du langage : `justify-content` agit **toujours sur l'axe principal**, `align-items` **toujours sur l'axe transversal**. Donc en `row`, `justify-content` est horizontal ; en `column`, il devient vertical. Si tu retiens ça, tu ne confondras plus jamais les deux propriétés — et c'est la confusion n°1 de tous les débutants.

---

## À quoi ça sert, concrètement

**Parce que centrer et aligner était un problème non résolu du web pendant quinze ans.** Avant Flexbox, centrer verticalement un élément demandait des astuces (tableaux, positionnement absolu avec des décalages négatifs, `line-height` détourné). Aujourd'hui c'est trois lignes, et ces trois lignes sont les plus utilisées de tout le CSS :

```css
.centre { display: flex; justify-content: center; align-items: center; }
```

**Parce que ça répond exactement au besoin quotidien.** Une barre de navigation, une carte avec une image à gauche et du texte à droite, un pied de page avec trois colonnes, un bouton avec une icône et un libellé, une liste d'étiquettes qui passe à la ligne : ce sont tous des cas Flexbox.

**Parce que c'est adaptatif par construction.** Les éléments flexibles **se répartissent** l'espace : ils grandissent, rétrécissent et peuvent passer à la ligne sans que tu calcules des pourcentages. C'est ce qui rend le responsive beaucoup moins pénible qu'avant.

---

## Où ça intervient dans le développement

Flexbox est l'outil de la mise en page **des composants** ; Grid (leçon 05) est l'outil de la mise en page **des pages**. C'est la distinction la plus utile à installer :

```
   GRID  → la structure générale : en-tête / barre latérale / contenu / pied
     └── FLEXBOX → à l'intérieur de chaque bloc : aligner, espacer, répartir
```

Autrement dit : une page type utilise Grid pour poser ses grandes zones, et Flexbox des dizaines de fois à l'intérieur. Les deux ne sont pas concurrents, ils travaillent à des échelles différentes.

Trois prolongements dans le parcours.

**Au palier 3, tu écriras ces mêmes propriétés via Tailwind** : `class="flex items-center justify-between gap-4"`. Les noms des classes sont ceux des propriétés CSS — si tu connais Flexbox, tu connais déjà cette partie de Tailwind.

**Au palier 9, Flutter reprend exactement le même modèle.** `Row` et `Column` avec `mainAxisAlignment` et `crossAxisAlignment` sont la transposition littérale de `flex-direction`, `justify-content` et `align-items`. Les concepts de cette leçon sont ceux de ton application mobile — et c'est encore un cas où une idée apprise une fois sert dans deux écosystèmes.

**Et il y a un point d'accessibilité à connaître dès maintenant** : les propriétés `order` et `row-reverse` changent l'ordre **visuel** sans changer l'ordre du **document**. Un lecteur d'écran et la touche `Tab` suivent le document. Réordonner visuellement crée donc un décalage qui peut rendre une page déroutante — à utiliser avec parcimonie et en connaissance de cause.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas beaucoup tâtonner au début, puis d'un coup ça va devenir évident. L'accélérateur le plus efficace est **Flexbox Froggy** : un jeu de vingt-quatre niveaux, trente minutes, et les propriétés rentrent définitivement. Fais-le avant les exercices, pas après.

Tu vas aussi découvrir que l'inspecteur du navigateur a un **outil Flexbox dédié** : un petit badge « flex » à côté de l'élément, qui affiche les axes et les zones d'espacement en surimpression. Il transforme le débogage de mise en page.

### En équipe, en entreprise

**Tu utiliseras Flexbox tous les jours**, souvent via un système de design ou Tailwind. C'est l'outil le plus courant du frontend moderne.

**Tu verras `gap` partout.** C'est la façon moderne d'espacer : plus de marges sur les enfants, plus de `:last-child { margin-right: 0 }`. Un seul `gap` sur le conteneur, et l'espacement est exact (pas de fusion de marges, leçon 03).

**Tu rencontreras les trois pièges classiques** dans du code existant : un `flex: 1` qui écrase les tailles qu'on voulait fixes, un élément qui refuse de rétrécir à cause de `min-width: auto`, et du texte qui déborde de son conteneur flexible pour la même raison. Ils sont traités plus bas — les connaître fait gagner des heures.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien, **six propriétés** couvrent 95 % des cas : `display: flex`, `flex-direction`, `justify-content`, `align-items`, `gap`, et `flex: 1`.

Régulièrement : `flex-wrap`, `flex-shrink: 0` (pour empêcher un élément de rétrécir), `align-self`, `margin-left: auto` (l'astuce pour pousser un élément à droite), `flex-basis`.

Rare, et sans intérêt pour l'instant : `align-content` (qui n'agit qu'avec `wrap` sur plusieurs lignes), `order`, `flex-flow`, les valeurs `space-around` et `space-evenly` (utiles mais peu demandées), la notation complète `flex: 0 1 auto` qu'on n'écrit presque jamais en entier. Et ce qu'on ne fait **plus** : `float` et `display: inline-block` avec des espaces blancs à compenser — si un tutoriel te propose ça pour une mise en page, il a plus de dix ans.

---

## La mécanique

### Sur le conteneur

```css
.conteneur {
  display: flex;

  flex-direction: row;         /* row (défaut) | column | row-reverse | column-reverse */

  justify-content: flex-start; /* AXE PRINCIPAL : flex-start | center | flex-end
                                  | space-between | space-around | space-evenly */

  align-items: stretch;        /* AXE TRANSVERSAL : stretch (défaut) | flex-start
                                  | center | flex-end | baseline */

  gap: 1rem;                   /* espacement entre les éléments — à préférer aux marges */

  flex-wrap: nowrap;           /* nowrap (défaut) | wrap : passer à la ligne si ça déborde */
}
```

Les valeurs de `justify-content` à connaître vraiment : `center` (tout au milieu), `space-between` (le premier collé au début, le dernier à la fin, l'espace réparti entre) — c'est **la** valeur d'une barre de navigation avec un logo à gauche et des liens à droite.

Et `align-items: stretch` est la valeur par défaut, ce qui explique un comportement surprenant : dans une rangée, les éléments prennent tous la **hauteur du plus grand**. C'est généralement ce qu'on veut (des cartes de même hauteur), et c'est parfois la cause d'un élément qui s'étire bizarrement — il suffit alors de passer à `flex-start`.

### Sur les éléments

```css
.element {
  flex: 1;              /* prend tout l'espace disponible, à parts égales avec les autres flex:1 */
  flex: 0 0 200px;      /* taille fixe : ne grandit pas, ne rétrécit pas, fait 200px */
  flex-shrink: 0;       /* interdit de rétrécir — très utile */
  align-self: center;   /* écrase align-items pour CET élément */
  margin-left: auto;    /* astuce : pousse cet élément (et les suivants) à droite */
}
```

`flex: 1` est le raccourci le plus utile : il signifie « prends l'espace restant ». Deux éléments en `flex: 1` se partagent l'espace à égalité ; un en `flex: 2` et un en `flex: 1` se le partagent en deux tiers / un tiers.

Le `margin-left: auto` mérite d'être retenu : dans un conteneur flexible, une marge automatique absorbe tout l'espace disponible. C'est la façon la plus simple de dire « ce bouton va à l'extrême droite », sans toucher au `justify-content` de la barre.

### Les cinq recettes qui couvrent l'essentiel

```css
/* 1. Centrer parfaitement, horizontalement et verticalement */
.centre { display: flex; justify-content: center; align-items: center; }

/* 2. Barre de navigation : logo à gauche, liens à droite */
.nav { display: flex; justify-content: space-between; align-items: center; }

/* 3. Carte : image de taille fixe, texte qui prend le reste */
.carte { display: flex; gap: 1rem; align-items: flex-start; }
.carte img { flex: 0 0 120px; }
.carte .contenu { flex: 1; }

/* 4. Liste d'étiquettes qui passe à la ligne */
.etiquettes { display: flex; flex-wrap: wrap; gap: 0.5rem; }

/* 5. Pied de page collé en bas, même si le contenu est court */
body { min-height: 100dvh; display: flex; flex-direction: column; }
main { flex: 1; }
```

Ces cinq-là, tu les écriras des centaines de fois. La cinquième — le pied de page collant — est un problème qui a occupé le web pendant une décennie et qui se règle maintenant en trois lignes.

### Le piège de l'axe, à visualiser une fois pour toutes

```css
/* En row (par défaut) */
.a { display: flex; justify-content: center; }  /* centre HORIZONTALEMENT */
.a { display: flex; align-items: center; }      /* centre VERTICALEMENT */

/* En column — tout s'inverse */
.b { display: flex; flex-direction: column; justify-content: center; } /* centre VERTICALEMENT */
.b { display: flex; flex-direction: column; align-items: center; }     /* centre HORIZONTALEMENT */
```

**C'est la source d'erreur numéro un.** La formulation qui règle le problème : `justify-content` suit la direction du flux, `align-items` est perpendiculaire. Dis-le à voix haute une fois, et vérifie dans l'inspecteur chaque fois que tu doutes — il dessine les deux axes.

---

## Les problèmes que tu vas rencontrer

**Mon texte déborde du conteneur, ou mon élément refuse de rétrécir.** C'est le piège le plus déroutant de Flexbox : un élément flexible a implicitement `min-width: auto`, donc il ne peut pas devenir plus petit que son contenu. Un long mot ou un bloc de texte sans espace le fait déborder. La correction est `min-width: 0` sur l'élément (et souvent `overflow: hidden` ou `overflow-wrap: break-word` en complément). Retiens-la : elle revient régulièrement et elle est impossible à deviner.

**`flex: 1` a écrasé la taille que je voulais fixe.** `flex: 1` autorise à grandir **et** à rétrécir. Pour une taille fixe, c'est `flex: 0 0 200px` ou `flex-shrink: 0`.

**`justify-content` ne fait rien.** Il n'y a pas d'espace libre sur l'axe principal — les éléments remplissent déjà tout. Vérifie aussi que tu ne confonds pas avec `align-items`.

**`align-items: center` ne centre rien.** Le conteneur a exactement la hauteur de son contenu : il n'y a rien à centrer dans. Donne-lui une hauteur, ou centre sur l'autre axe.

**Mes éléments s'étirent bizarrement en hauteur.** C'est `align-items: stretch`, la valeur par défaut. Passe à `flex-start`.

**`gap` ne fonctionne pas.** Soit tu es sur un très ancien navigateur, soit tu l'as mis sur l'élément au lieu du conteneur.

**Flexbox ne s'applique qu'au premier niveau.** `display: flex` n'agit que sur les **enfants directs**. Les petits-enfants ne sont pas concernés — il faut déclarer `flex` à chaque niveau où tu en as besoin.

**Mon ordre de tabulation est incohérent.** Tu as utilisé `order` ou `row-reverse`. L'ordre visuel et l'ordre du document ont divergé.

---

## Ce qu'on te demandera

En **test technique frontend**, Flexbox est l'outil que tu utiliseras pour la plus grande partie de l'intégration demandée. On ne te demandera pas « utilise Flexbox » : on te donnera une maquette, et c'est à toi de reconnaître les cas.

En **entretien** : « quelle différence entre Flexbox et Grid, et comment choisis-tu ? » (la question la plus fréquente sur le sujet), « comment centres-tu un élément horizontalement et verticalement ? », « que fait `flex: 1` ? », « différence entre `justify-content` et `align-items` ? ».

On peut aussi te demander de coder une barre de navigation ou un pied de page collant au tableau, sans ordinateur. Les cinq recettes ci-dessus suffisent.

---

## Ce qui te démarquera

**Choisir le bon outil, et savoir le dire.** « Ici c'est une mise en page sur un axe, donc Flexbox ; la structure de la page, je la fais en Grid » est une phrase qui situe immédiatement ton niveau.

**Connaître le piège `min-width: auto`.** Très peu de développeurs juniors le connaissent, et c'est la cause d'une bonne partie des débordements inexpliqués. Le diagnostiquer en revue de code produit un effet certain.

**Utiliser `gap` plutôt que des marges.** C'est plus simple, plus exact, et ça évite les `:last-child` correctifs.

**Ne pas abuser de `order`.** Savoir dire « je préfère ne pas réordonner visuellement, ça désynchroniserait l'ordre de tabulation » montre que tu penses à l'accessibilité sans qu'on te le demande.

**Utiliser l'inspecteur Flexbox du navigateur.** Beaucoup de gens tâtonnent là où l'outil affiche directement les axes et l'espace libre.

---

## 📚 À lire / pratiquer

🎮 **Flexbox Froggy** (flexboxfroggy.com) — vingt-quatre niveaux, trente minutes, **à faire avant les exercices**. C'est de loin la ressource la plus efficace de la leçon.

📖 **css-tricks.com → *A Complete Guide to Flexbox*** — la référence visuelle à garder en favori. Tu y reviendras pendant des années ; personne ne retient toutes les valeurs.

**The Odin Project → CSS → Flexbox** pour la pratique guidée, et **web.dev/learn/css/flexbox** pour une présentation moderne et concise.

**MDN → *Basic concepts of flexbox*** si tu veux le modèle complet, notamment la section sur `flex-basis` et le dimensionnement.

---

## 🤖 Le mini-projet à demander à l'IA

Flexbox s'apprend en reproduisant des mises en page décrites, pas en lisant des propriétés.

> « Je suis en formation de développeur, palier 2 (frontend). Je travaille Flexbox. Décris-moi **12 mises en page**, une par une, **uniquement en mots** (jamais de code) : barre de navigation avec logo à gauche et menu à droite, carte horizontale avec vignette fixe et texte extensible, liste d'étiquettes qui passe à la ligne, pied de page collé en bas avec contenu court, formulaire en ligne avec champ extensible et bouton fixe, barre d'outils avec deux groupes séparés, etc. Pour chacune, je t'envoie mon HTML et mon CSS ; tu me dis si mon choix de propriétés est le plus simple possible, et **si une autre combinaison serait plus robuste au redimensionnement** — sans me donner le code. Monte progressivement en difficulté. »

Le critère « robuste au redimensionnement » est le bon : une mise en page Flexbox qui casse quand on réduit la fenêtre est généralement un `flex-shrink` ou un `min-width` oublié.

Puis l'exercice de diagnostic :

> « Donne-moi 6 cas où une mise en page Flexbox se comporte mal : un texte qui déborde à cause de `min-width: auto`, un élément qui refuse de garder sa taille, un `justify-content` sans effet, un `align-items: center` qui ne centre rien, des éléments qui s'étirent à cause de `stretch`, et un `gap` mis au mauvais endroit. Ne me dis pas la cause. Je diagnostique, j'explique, je corrige. »

---

## 🛠️ À faire

> Fais **Flexbox Froggy en entier** avant de commencer.

1. **Centrer** : une boîte parfaitement centrée dans la fenêtre, horizontalement et verticalement.
2. **Barre de navigation** : logo à gauche, liens à droite, tout aligné verticalement. Puis ajoute un bouton « Connexion » à l'extrême droite avec `margin-left: auto`.
3. **Carte horizontale** : vignette de 120 pixels à gauche (taille fixe), titre et texte à droite qui prennent le reste. Vérifie qu'elle tient à 320 pixels de large.
4. **Liste d'étiquettes** : une quinzaine d'étiquettes qui passent à la ligne proprement avec `gap`.
5. **Pied de page collant** : il reste en bas de l'écran même avec un contenu de deux lignes, et se décale normalement avec un contenu long.
6. **Démontre le piège `min-width`** : une carte flexible contenant un très long mot sans espace (`anticonstitutionnellementetcetera`). Observe le débordement, puis corrige avec `min-width: 0`.
7. **Démontre le piège de l'axe** : la même structure centrée en `row` puis en `column`, et constate que `justify-content` et `align-items` échangent leurs effets.
8. **Trois répartitions** : la même rangée de cinq éléments en `space-between`, `space-around` et `space-evenly`. Note la différence dans ton journal — on confond toujours les deux dernières.
9. Reproduis la barre d'outils d'un vrai logiciel (deux groupes de boutons séparés, un à gauche, un à droite) en une seule ligne de Flexbox.
10. Utilise l'**inspecteur Flexbox** du navigateur sur l'un de tes exercices : clique le badge « flex », observe les axes et l'espace libre.

<details>
<summary>Corrections et points de contrôle</summary>

**1.**
```css
.page { min-height: 100dvh; display: flex; justify-content: center; align-items: center; }
```
`100dvh` plutôt que `100vh` : sur mobile, la barre d'adresse rend `100vh` trop grand (leçon 03).

**3.**
```css
.carte { display: flex; gap: 1rem; align-items: flex-start; }
.carte img      { flex: 0 0 120px; }   /* ne grandit pas, ne rétrécit pas */
.carte .contenu { flex: 1; min-width: 0; }   /* prend le reste, et peut rétrécir */
```
Le `min-width: 0` est le détail qui fait que la carte tient à 320 pixels : sans lui, le contenu refuse de descendre sous sa largeur naturelle.

**5.**
```css
body { min-height: 100dvh; display: flex; flex-direction: column; }
main { flex: 1; }
```
`main` absorbe tout l'espace restant, donc le `footer` est poussé en bas. Avec un contenu long, `main` dépasse et la page défile normalement.

**6.** Sans correction, le long mot force l'élément à rester large et la carte déborde de son conteneur. Avec `min-width: 0` sur l'élément flexible, il peut rétrécir ; ajoute `overflow-wrap: break-word` pour que le mot se coupe. **C'est le piège Flexbox le plus utile à connaître.**

**7.** En `row` : `justify-content` est horizontal, `align-items` vertical. En `column` : exactement l'inverse. Si tu as vécu la confusion ici, tu ne la referas plus.

**8.** `space-between` : rien avant le premier, rien après le dernier. `space-around` : les éléments ont un demi-espace de chaque côté, donc les bords semblent deux fois plus petits que les écarts intérieurs. `space-evenly` : tous les espaces sont égaux, bords compris. C'est `space-evenly` qu'on veut généralement quand on choisit `space-around` par erreur.
</details>

---

## ✅ Acquis si…

- [ ] J'ai fini Flexbox Froggy.
- [ ] Je centre un élément sur les deux axes sans consulter de documentation.
- [ ] J'explique la différence entre `justify-content` et `align-items`, et ce qui change en `column`.
- [ ] Je sais ce que fait `flex: 1` et comment imposer une taille fixe.
- [ ] J'utilise `gap` plutôt que des marges sur les enfants.
- [ ] Je connais le piège `min-width: auto` et je sais le corriger.
- [ ] Je réalise les cinq recettes (centrer, nav, carte, étiquettes, pied collant) de mémoire.
- [ ] Je sais dire pourquoi je choisis Flexbox plutôt que Grid pour une mise en page donnée.
- [ ] Je sais que `order` désynchronise l'ordre visuel et l'ordre de tabulation.

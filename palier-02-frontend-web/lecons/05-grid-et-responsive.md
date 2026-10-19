# Leçon 05 — Grid et responsive mobile-first

> 🎯 **À la fin de cette leçon** : tu structures une page en deux dimensions, et tu rends n'importe quelle interface utilisable de 320 à 1920 pixels sans multiplier les correctifs.
> ⏱️ 4 h · **Prérequis** : leçons 03–04.

---

## De quoi on parle

**Grid** est un système de mise en page **sur deux axes simultanément** : tu définis des colonnes et des lignes, puis tu y places les éléments. Là où Flexbox distribue le long d'une direction, Grid pose une trame.

```css
.page {
  display: grid;
  grid-template-columns: 250px 1fr;   /* une colonne fixe, une qui prend le reste */
  gap: 1.5rem;
}
```

L'unité `fr` est propre à Grid : elle représente une **fraction de l'espace disponible**. `1fr 1fr` donne deux colonnes égales ; `2fr 1fr` donne deux tiers / un tiers.

Le **responsive** désigne le fait qu'une interface s'adapte à la taille de l'écran. Son outil principal est la **media query**, une règle conditionnelle :

```css
@media (min-width: 48rem) { /* appliqué seulement au-delà de 768 px */ }
```

Et **mobile-first** est une méthode : on écrit le style du petit écran **par défaut**, puis on **ajoute** pour les écrans plus larges avec `min-width`. L'inverse (`max-width`, en partant du grand écran) s'appelle *desktop-first* et produit, en pratique, des feuilles de style en couches de surcharges.

---

## À quoi ça sert, concrètement

**Parce que la majorité de tes utilisateurs sont sur téléphone.** Dans la plupart des pays, et particulièrement en Afrique, le trafic mobile dépasse largement le trafic sur ordinateur. Un site qui ne tient pas sur un écran de 360 pixels de large n'est pas « imparfait » : il est inutilisable pour la majorité des gens qui le visitent.

**Parce que Grid a réglé le problème de la structure de page.** Une mise en page en-tête / barre latérale / contenu / pied de page demandait autrefois des `float`, des conteneurs supplémentaires et des hauteurs calculées. Avec Grid, c'est une déclaration de six lignes, et elle se réorganise en une media query.

**Parce que `auto-fit` supprime les media queries.** C'est le gain le plus spectaculaire de la leçon : une grille de cartes qui passe toute seule de une à quatre colonnes selon la place, sans une seule condition de largeur. Quand on peut écrire une mise en page qui s'adapte **sans point de rupture**, on le fait.

---

## Où ça intervient dans le développement

La distinction posée à la leçon 04 se complète ici :

```
   GRID    → la structure de la PAGE : les grandes zones, en deux dimensions
     └── FLEXBOX → l'intérieur des composants : aligner sur un axe
```

Et le responsive, lui, n'est pas une couche qu'on ajoute à la fin : c'est une **méthode de travail**. C'est la différence entre « je ferai le mobile après » (et on ne le fait jamais correctement) et « j'écris le mobile d'abord, le reste est un enrichissement ».

Trois prolongements.

**Au palier 3, Tailwind reprend exactement ce modèle** avec ses préfixes de point de rupture : `class="grid grid-cols-1 md:grid-cols-3"` signifie « une colonne par défaut, trois au-delà du point md ». C'est du mobile-first imposé par la syntaxe — tu le comprendras immédiatement si tu l'as pratiqué à la main.

**Au palier 9, le responsive devient l'adaptation aux tailles d'écran mobiles** et à l'orientation. Les concepts sont les mêmes, les outils changent (`LayoutBuilder`, `MediaQuery`).

**Et au palier 8, la performance mobile deviendra mesurable.** Un site responsive mais qui télécharge une image de 2 Mo sur un téléphone en 3G n'est pas adapté — le responsive concerne aussi le **poids**, pas seulement la largeur. C'est pourquoi `srcset` est mentionné plus bas.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas travailler avec le **mode responsive** des outils de développement (`Ctrl+Shift+M`) en permanence : il simule les tailles d'écran et te permet de tester sans redimensionner la fenêtre. Prends l'habitude de garder la largeur à **320 pixels** pendant que tu développes : si ça tient là, ça tient partout.

Comme pour Flexbox, il existe un jeu : **Grid Garden**, vingt-huit niveaux, trente minutes. Fais-le d'abord.

Tu vas aussi découvrir l'**inspecteur Grid** du navigateur, qui superpose la trame et numérote les lignes. Sans lui, Grid est pénible à déboguer ; avec lui, c'est immédiat.

### En équipe, en entreprise

**Les points de rupture sont imposés par le système de design**, pas choisis au cas par cas. Tailwind en propose quatre (`sm` 640, `md` 768, `lg` 1024, `xl` 1280 pixels) et la plupart des équipes s'y tiennent.

**On te demandera de tester sur de vrais appareils**, pas seulement dans le simulateur — qui ne reproduit ni le clavier virtuel, ni la barre d'adresse mobile, ni la performance réelle.

**Tu entendras parler de « container queries ».** C'est l'évolution récente : adapter un composant à la largeur de **son conteneur** plutôt qu'à celle de l'écran. C'est la bonne réponse conceptuelle pour un composant réutilisable, et c'est désormais utilisable. Tu peux t'en passer au palier 2, mais sache que ça existe.

**Et tu verras encore beaucoup de desktop-first** dans les projets existants, avec des cascades de `max-width` qui se surchargent. Savoir lire les deux approches est nécessaire.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `display: grid`, `grid-template-columns`, `gap`, `1fr`, `repeat()`, `minmax()`, `auto-fit`, et les media queries en `min-width`.

Régulièrement : `grid-column: span 2` (faire occuper plusieurs colonnes), `place-items: center`, `grid-template-areas` (pour une structure de page nommée, très lisible), `aspect-ratio`, `clamp()` pour la typographie fluide.

Rare, et hors sujet pour l'instant : les lignes nommées, `grid-auto-flow: dense`, `subgrid`, les media queries sur l'orientation ou le pointeur, `@container` (à connaître de nom), `object-fit` sur les images (utile mais ponctuel). Et deux choses à ne plus faire : les frameworks de grille à 12 colonnes avec des classes `col-md-4` (c'était l'ère Bootstrap, Grid les a rendus inutiles), et les tableaux HTML pour la mise en page.

---

## La mécanique

### Grid : les trois formes à connaître

```css
/* 1. Colonnes explicites — pour une structure de page */
.page {
  display: grid;
  grid-template-columns: 250px 1fr;     /* barre latérale fixe + contenu extensible */
  gap: 1.5rem;
}

/* 2. Colonnes égales */
.trois {
  display: grid;
  grid-template-columns: repeat(3, 1fr);   /* = 1fr 1fr 1fr */
  gap: 1rem;
}

/* 3. ⭐ La grille qui s'adapte SANS media query */
.cartes {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1rem;
}
```

La troisième mérite d'être décortiquée, parce que c'est la plus utile du CSS moderne. `minmax(280px, 1fr)` dit : « chaque colonne fait au minimum 280 pixels, au maximum une fraction de l'espace ». `auto-fit` dit : « mets-en autant que ça rentre ». Résultat : sur un téléphone, une colonne ; sur une tablette, deux ; sur un grand écran, quatre — **et tu n'as écrit aucune media query**. Apprends cette ligne par cœur, tu l'utiliseras constamment.

### Placer les éléments

```css
.element-large { grid-column: span 2; }        /* occupe 2 colonnes */
.element       { grid-column: 1 / 3; }          /* de la ligne 1 à la ligne 3 */
.conteneur     { place-items: center; }         /* centre tout, sur les 2 axes, en une ligne */
```

`place-items: center` est le raccourci de `align-items` + `justify-items`. Pour centrer un seul élément dans une zone, c'est plus court que l'équivalent Flexbox.

### Les zones nommées : la structure de page lisible

```css
.app {
  display: grid;
  grid-template-areas:
    "entete  entete"
    "menu    contenu"
    "pied    pied";
  grid-template-columns: 250px 1fr;
  grid-template-rows: auto 1fr auto;
  min-height: 100dvh;
}
.entete  { grid-area: entete; }
.menu    { grid-area: menu; }
.contenu { grid-area: contenu; }
.pied    { grid-area: pied; }
```

L'intérêt est la lisibilité : la structure de la page se **voit** dans le CSS. Et sa réorganisation en mobile devient évidente :

```css
@media (max-width: 48rem) {
  .app {
    grid-template-areas: "entete" "contenu" "menu" "pied";
    grid-template-columns: 1fr;
  }
}
```

Note qu'on a déplacé le menu **après** le contenu en mobile. Attention : ici l'ordre visuel change, mais pas l'ordre du document — même remarque d'accessibilité qu'avec `order` en Flexbox.

### Mobile-first : la méthode

```css
/* Par défaut = MOBILE. Pas de media query. */
.cartes {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
  padding: 1rem;
}

/* On AJOUTE pour les écrans plus larges */
@media (min-width: 48rem) {        /* 768 px */
  .cartes { grid-template-columns: repeat(2, 1fr); padding: 2rem; }
}

@media (min-width: 64rem) {        /* 1024 px */
  .cartes { grid-template-columns: repeat(3, 1fr); }
}
```

Pourquoi partir du mobile plutôt que de l'inverse ? Trois raisons concrètes. Le mobile est le cas le plus **contraint** : si ça tient là, l'élargir est facile ; l'inverse demande de retirer, et on retire mal. Le style par défaut est **le plus simple** (une colonne), donc le CSS reste lisible. Et un téléphone ne télécharge pas les règles destinées aux grands écrans qu'il devrait ensuite surcharger.

Les points de rupture se choisissent **là où la mise en page casse**, pas en fonction d'appareils précis. Et on les écrit en `rem` pour qu'ils respectent le réglage de police de l'utilisateur.

### La typographie fluide avec `clamp()`

```css
h1 { font-size: clamp(1.75rem, 5vw, 3rem); }
```

« Au minimum 1,75 rem, idéalement 5 % de la largeur de la fenêtre, au maximum 3 rem. » Un titre qui grandit progressivement, sans aucun point de rupture. `clamp()` s'utilise aussi pour les espacements, et c'est l'une des fonctions les plus rentables du CSS moderne.

### Les images responsives

```css
img { max-width: 100%; height: auto; }     /* la règle de base, à mettre partout */
```

Ces deux déclarations évitent la grande majorité des débordements horizontaux. Et pour le **poids**, pas seulement la taille :

```html
<img src="photo-800.jpg"
     srcset="photo-400.jpg 400w, photo-800.jpg 800w, photo-1600.jpg 1600w"
     sizes="(max-width: 48rem) 100vw, 50vw"
     alt="…">
```

Le navigateur choisit le fichier adapté à l'écran. Sur un téléphone en 3G, c'est la différence entre une page qui s'affiche et une page qu'on abandonne.

---

## Les problèmes que tu vas rencontrer

**Ma page défile horizontalement sur mobile.** C'est le problème responsive numéro un. Les causes, par ordre de fréquence : une image sans `max-width: 100%`, une largeur fixe en pixels supérieure à l'écran, un `white-space: nowrap` sur un texte long, un tableau trop large, un élément en position absolue qui dépasse. Pour le trouver : réduis à 320 pixels et ajoute temporairement `* { outline: 1px solid red; }` — le coupable apparaît.

**Ma mise en page est minuscule sur téléphone.** La balise `viewport` manque dans le `<head>` (leçon 01). Sans elle, tout le reste est annulé.

**`100vh` provoque un défilement sur mobile.** La barre d'adresse. Utilise `100dvh`.

**Mes media queries ne s'appliquent pas.** Vérifie l'ordre : en mobile-first, les `min-width` doivent aller **du plus petit au plus grand**, sinon les plus petites écrasent les plus grandes. Vérifie aussi la syntaxe (`@media (min-width: 48rem)` — les parenthèses sont obligatoires).

**Mes colonnes Grid débordent.** Même piège qu'en Flexbox : une piste `1fr` a un minimum implicite lié à son contenu. Utilise `minmax(0, 1fr)` au lieu de `1fr` quand le contenu peut être large.

**`auto-fit` laisse une seule colonne étirée.** Ton `minmax` a un minimum trop grand pour l'espace disponible. Réduis-le.

**Ça marche dans le simulateur et pas sur mon téléphone.** Le simulateur ne reproduit ni le clavier virtuel (qui réduit la hauteur visible), ni la barre d'adresse, ni les performances. Teste sur un vrai appareil — connecte-le en USB et ouvre `chrome://inspect`.

**Mon texte est illisible sur mobile** alors qu'il passe sur ordinateur. Taille de police en dessous de 16 pixels (ce qui fait aussi zoomer automatiquement les champs sur iOS), ou interlignage trop serré, ou lignes trop longues (`max-width: 65ch`, leçon 03).

---

## Ce qu'on te demandera

En **test technique**, « rends cette maquette responsive » est une consigne quasi systématique, et la première vérification du correcteur est de réduire la fenêtre à 320 pixels. Un débordement horizontal est éliminatoire — c'est l'épreuve A1 de ton évaluation de palier.

En **entretien** : « quelle différence entre Flexbox et Grid ? » (encore), « qu'est-ce que mobile-first et pourquoi ? », « comment ferais-tu une grille de cartes adaptative ? » (la réponse `auto-fit` + `minmax` est celle qu'on espère), « comment choisis-tu tes points de rupture ? ».

En **travail réel**, on attendra que tu testes sur mobile **avant** de dire que c'est fini, et que tu saches diagnostiquer un défilement horizontal.

---

## Ce qui te démarquera

**Écrire une grille adaptative sans media query.** `repeat(auto-fit, minmax(280px, 1fr))` produit toujours un effet : c'est court, c'est robuste, et beaucoup de développeurs plus expérimentés ne le connaissent pas.

**Développer à 320 pixels.** Garder le mode responsive ouvert à la plus petite largeur pendant tout le développement, au lieu de vérifier à la fin. C'est un changement d'habitude, pas de compétence, et il supprime presque tous les problèmes responsive.

**Choisir ses points de rupture d'après le contenu.** Dire « j'ai mis la rupture à 52rem parce que c'est là que les cartes deviennent trop étroites » vaut mieux que « j'ai pris les tailles d'un iPad ».

**Penser au poids, pas seulement à la largeur.** Mentionner `srcset` ou le format AVIF/WebP montre que tu as en tête l'utilisateur réel sur un réseau lent — c'est un argument fort dans un contexte où la connectivité est variable.

**Utiliser `clamp()` pour la typographie.** Un titre fluide sans point de rupture, et personne ne sait comment tu l'as fait.

---

## 📚 À lire / pratiquer

🎮 **Grid Garden** (cssgridgarden.com) — vingt-huit niveaux, trente minutes, **avant les exercices**.

📖 **css-tricks.com → *A Complete Guide to Grid*** — la référence visuelle, à garder en favori à côté de celle de Flexbox.

**web.dev/learn/design** est le meilleur parcours sur le responsive moderne (et il explique les container queries). **The Odin Project → CSS → Grid** et **Responsive Design** pour la pratique guidée.

**MDN → *Responsive design*** pour la vue d'ensemble, et la page sur `srcset` si tu veux aller jusqu'au poids des images.

---

## 🤖 Le mini-projet à demander à l'IA

Le responsive s'apprend en cherchant ce qui casse.

> « Je suis en formation de développeur, palier 2 (frontend). Je travaille Grid et le responsive mobile-first. Décris-moi **en mots seulement** (jamais de code) la structure de 6 pages à réaliser : un tableau de bord avec barre latérale, une grille de produits, une page d'article avec sommaire latéral, une galerie en mosaïque, un formulaire sur deux colonnes qui passe à une, et une page d'accueil avec bandeau et trois blocs. Pour chacune, précise **le comportement attendu en mobile, en tablette et en grand écran**. Je t'envoie mon HTML et mon CSS ; tu vérifies trois choses : que c'est bien écrit en mobile-first, que j'ai utilisé Grid et Flexbox chacun à sa place, et **si j'aurais pu éviter une media query** avec `auto-fit` ou `clamp()`. Ne me donne pas de code. »

La troisième vérification est la plus formatrice : la bonne mise en page moderne est souvent celle qui n'a **pas** besoin de point de rupture.

Puis la chasse aux débordements :

> « Donne-moi une page HTML/CSS de 80 lignes qui s'affiche correctement en 1200 px mais qui **déborde horizontalement en 320 px**, avec 5 causes différentes et réalistes (image sans max-width, largeur fixe, nowrap, tableau, position absolue). Ne me dis pas lesquelles. Je dois les trouver avec les DevTools, expliquer chaque cause, et corriger. »

---

## 🛠️ À faire

> Fais **Grid Garden en entier** avant de commencer. Et garde le mode responsive ouvert à **320 pixels** pendant tous les exercices.

1. **Structure de page en Grid** : en-tête, barre latérale de 250 pixels, contenu, pied de page, sur toute la hauteur de l'écran. Utilise `grid-template-areas`.
2. Réorganise-la en mobile : tout en une colonne, le menu après le contenu.
3. **⭐ La grille adaptative** : une douzaine de cartes avec `repeat(auto-fit, minmax(280px, 1fr))`. Redimensionne la fenêtre lentement et compte les colonnes. **Zéro media query.**
4. Refais la même grille **avec** des media queries (1 colonne, puis 2, puis 3). Compare les deux CSS et note dans ton journal lequel tu préfères maintenir.
5. **Typographie fluide** : un titre en `clamp(1.75rem, 5vw, 3rem)`. Redimensionne et observe.
6. **Les trois intégrations imposées du palier** (landing page, formulaire de connexion, grille de cartes produits) : reprends-les et rends-les parfaitement responsives de 320 à 1920 pixels.
7. **Chasse au débordement** : prends une de tes pages, réduis à 320 pixels, ajoute `* { outline: 1px solid red }` et trouve ce qui dépasse.
8. **Test sur un vrai téléphone** : lance un serveur local (`python3 -m http.server`), trouve l'adresse IP locale de ta machine (`ip addr`), et ouvre la page depuis ton téléphone sur le même réseau Wi-Fi. Note les trois différences avec le simulateur.
9. Mets `max-width: 100%; height: auto` sur toutes tes images et vérifie qu'aucune ne déborde plus.
10. Utilise l'**inspecteur Grid** du navigateur : clique le badge « grid », affiche les numéros de ligne et les noms de zones.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Voir la section « zones nommées » de la mécanique. Les deux détails qui comptent : `min-height: 100dvh` sur le conteneur, et `grid-template-rows: auto 1fr auto` pour que le contenu absorbe l'espace restant et pousse le pied de page en bas.

**3.** Tu devrais voir les colonnes passer de 1 à 2, 3, puis 4 sans aucune condition de largeur. Si une seule colonne reste étirée sur un écran large, ton minimum (`280px`) est trop grand par rapport à l'espace — ou tu as écrit `auto-fill` au lieu de `auto-fit` (`auto-fill` garde des colonnes vides, `auto-fit` les replie).

**4.** La version `auto-fit` fait trois lignes, la version avec media queries une quinzaine, et elle a des points de rupture arbitraires qui ne correspondent pas forcément à la largeur réelle du conteneur. C'est l'argument de la leçon : **la meilleure media query est celle qu'on n'écrit pas.**

**7.** Les coupables habituels, par fréquence : une image sans `max-width: 100%`, un `width: 500px` en dur, un `white-space: nowrap`, un tableau, un bloc en `position: absolute`. L'astuce `outline` les rend visibles immédiatement parce qu'un contour, contrairement à une bordure, ne modifie pas la mise en page.

**8.** Les trois différences habituelles : la barre d'adresse mangeant de la hauteur (`100vh` contre `100dvh`), le clavier virtuel qui réduit la zone visible dans les formulaires, et la performance réelle (polices et images qui tardent). Le simulateur ne reproduit aucune des trois — c'est pourquoi un test réel est demandé dans l'épreuve de sortie.
</details>

---

## ✅ Acquis si…

- [ ] J'ai fini Grid Garden.
- [ ] Je structure une page complète en Grid, avec `grid-template-areas`.
- [ ] J'écris une grille adaptative avec `repeat(auto-fit, minmax(…, 1fr))` de mémoire.
- [ ] Je travaille en **mobile-first**, avec des `min-width`, et je sais expliquer pourquoi.
- [ ] Je choisis mes points de rupture là où la mise en page casse, pas d'après des appareils.
- [ ] Aucune de mes pages ne défile horizontalement à 320 pixels.
- [ ] Je sais diagnostiquer un débordement horizontal avec les DevTools.
- [ ] J'ai testé sur un vrai téléphone, et je connais trois limites du simulateur.
- [ ] Je sais dire quand utiliser Grid et quand utiliser Flexbox.
- [ ] Je sais que le responsive concerne aussi le **poids** des images, pas seulement la largeur.

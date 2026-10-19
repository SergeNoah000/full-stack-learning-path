# Leçon 04 — Widgets de mise en page : Scaffold, Column, Row, Stack, ListView

> 🎯 **À la fin de cette leçon** : tu construis la mise en page d'un écran — structure, colonnes, lignes, superpositions, listes défilantes — avec les widgets de disposition de Flutter, qui transposent ce que tu sais du CSS Flexbox (palier 2).
> ⏱️ 5 h · **Prérequis** : leçon 03 (tout est widget), et Flexbox/CSS (palier 2).

---

## De quoi on parle

La mise en page, en Flutter, se fait aussi avec des widgets — des widgets dont le rôle est d'**arranger** d'autres widgets dans l'espace. Les plus importants :

- **`Scaffold`** : la structure d'un écran standard (barre de titre, corps, bouton flottant, menu bas) ;
- **`Column`** et **`Row`** : empiler des widgets verticalement / horizontalement — c'est le **Flexbox** du palier 2 ;
- **`Stack`** : superposer des widgets (l'un par-dessus l'autre) ;
- **`ListView`** : une liste **défilante**, essentielle dès qu'il y a plus d'éléments que l'écran ;
- et les widgets d'espacement et de contrainte (`Padding`, `SizedBox`, `Expanded`, `Container`).

Bonne nouvelle : tu connais déjà le modèle. `Column`/`Row` avec `mainAxisAlignment`/`crossAxisAlignment`, c'est **Flexbox** (palier 2) avec d'autres noms. Tu ne réapprends pas la disposition en deux axes ; tu la transposes du CSS vers des widgets.

---

## À quoi ça sert, concrètement

**Parce que disposer les éléments est la moitié du travail d'interface.** Une fois qu'on sait créer des widgets (leçon 03), il faut les **placer** : côte à côte, l'un sous l'autre, centrés, espacés, dans une liste qui défile. Ces widgets de mise en page sont ce qu'on utilise à chaque écran, en permanence.

**Parce que le modèle à deux axes (Flexbox) est universel.** Column/Row reposent sur un axe principal et un axe transversal, avec des alignements — exactement Flexbox (palier 2). Ce modèle, tu le connais ; le retrouver en Flutter te fait gagner un temps considérable, et le comprendre une fois sert sur le web **et** le mobile.

**Parce que `ListView` et le défilement performant sont incontournables en mobile.** Un écran mobile est petit ; presque toute liste dépasse. `ListView` gère le défilement, et sa variante `ListView.builder` ne construit que les éléments visibles — crucial pour une longue liste (des milliers d'items) sans ralentir. C'est un réflexe de performance mobile de base.

**Et parce que le `Scaffold` donne la structure attendue d'une app.** Barre de titre en haut, corps au milieu, bouton d'action flottant, menu en bas : le `Scaffold` fournit cette structure standard du *Material Design*, celle que les utilisateurs d'Android (et la cohérence visuelle) attendent. On part de lui pour chaque écran.

---

## Où ça intervient dans le développement

Ces widgets forment le squelette de chaque écran :

```
   Scaffold                         ← structure de l'écran
     ├─ appBar: AppBar               ← barre de titre
     ├─ body: Column                 ← empilement vertical (Flexbox)
     │    ├─ Padding > Text           ← titre espacé
     │    ├─ Row                      ← ligne horizontale (Flexbox)
     │    │   ├─ Expanded > Text       ← prend l'espace disponible
     │    │   └─ Icon
     │    └─ Expanded > ListView      ← la liste défilante prend le reste
     │         .builder(...)           ← ne construit que le visible
     └─ floatingActionButton: ...     ← bouton d'ajout flottant
```

Trois ancrages.

**`Column`/`Row`, c'est Flexbox (palier 2).** `mainAxisAlignment` = `justify-content`, `crossAxisAlignment` = `align-items`, `Expanded` = `flex: 1`. L'axe principal/transversal, les alignements, l'étirement : c'est le CSS Flexbox que tu as appris, en widgets. Tu transposes un modèle connu.

**Ils reçoivent les données transformées (leçon 02) pour les afficher.** La `ListView` affiche la liste de dépenses que tu as filtrée/transformée avec `map`/`where` (leçon 02). La mise en page est le point où les données deviennent visibles.

**Et ils préparent l'affichage de l'état (leçons 05, 08).** Ces structures accueilleront l'état local (une case cochée, leçon 05) et les états d'écran (chargement/erreur/vide/données, leçon 08). Ici, on pose le contenant ; les leçons suivantes y mettent la réactivité.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas construire la mise en page d'un écran de liste de dépenses : un `Scaffold` avec barre de titre et bouton flottant, un `body` en `Column`, des `Row` pour les lignes, une `ListView.builder` défilante, et les widgets d'espacement (`Padding`, `SizedBox`) et d'étirement (`Expanded`). Tout sur ton vrai téléphone, avec hot reload.

### En équipe, en entreprise

**Ces widgets composent 90 % des écrans.** `Scaffold`, `Column`, `Row`, `ListView`, `Padding`, `Expanded` : c'est le vocabulaire quotidien. On les enchaîne pour bâtir n'importe quelle disposition. Les maîtriser rend productif immédiatement.

**`ListView.builder` est la norme pour les listes.** On n'utilise jamais une `Column` pour une longue liste (elle construirait tout d'un coup) : on utilise `ListView.builder`, qui ne construit que les éléments visibles. Confondre les deux cause des ralentissements signalés en revue.

**La gestion des débordements est un sujet récurrent.** Le fameux « RenderFlex overflow » (bande jaune et noire) arrive quand le contenu dépasse l'espace. Savoir le résoudre (avec `Expanded`, `Flexible`, un défilement) est un geste courant. On en reparle plus bas.

**On vise la cohérence avec le Material Design.** Les widgets Flutter suivent les conventions Material (espacements, élévations, composants). S'y conformer donne une app qui paraît native et soignée sans tout redessiner.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : `Scaffold`, `AppBar`, `Column`, `Row`, `Text`, `Padding`, `SizedBox`, `Expanded`, `ListView.builder`, `Center`, `Container`.

Régulièrement : `Stack`/`Positioned` (superposition), `Flexible`, `Spacer`, `Wrap` (retour à la ligne), `GridView`, les `mainAxisAlignment`/`crossAxisAlignment`, `FloatingActionButton`.

Rare ou avancé : `CustomScrollView`/`Sliver` (défilements complexes), `LayoutBuilder`, `IntrinsicHeight`, `CustomMultiChildLayout`, les contraintes de rendu fines. À connaître de nom ; tu les creuseras au besoin.

---

## La mécanique

### Le `Scaffold` : la structure d'un écran

```dart
Scaffold(
  appBar: AppBar(title: const Text("Mes dépenses")),   // barre de titre
  body: /* le contenu de l'écran */,
  floatingActionButton: FloatingActionButton(          // bouton d'action flottant
    onPressed: () { /* ajouter une dépense */ },
    child: const Icon(Icons.add),
  ),
)
```

`Scaffold` fournit l'ossature Material d'un écran : `appBar` (titre en haut), `body` (le contenu), `floatingActionButton` (bouton flottant), et d'autres emplacements (menu bas, tiroir). On part de lui pour chaque écran — il place les éléments standards à leur endroit attendu.

### ⭐ `Column` et `Row` : Flexbox en widgets

```dart
Column(                                     // empile VERTICALEMENT (axe principal = vertical)
  mainAxisAlignment: MainAxisAlignment.center,      // = justify-content (axe principal)
  crossAxisAlignment: CrossAxisAlignment.start,     // = align-items (axe transversal)
  children: [
    const Text("Total"),
    const Text("45 €"),
  ],
)

Row(                                        // aligne HORIZONTALEMENT (axe principal = horizontal)
  children: [
    const Text("Café"),
    const Spacer(),                         // pousse les éléments aux extrémités
    const Text("3,50 €"),
  ],
)
```

C'est **Flexbox** (palier 2). `Column` a l'axe principal vertical, `Row` l'axe principal horizontal. `mainAxisAlignment` aligne sur l'axe principal (comme `justify-content`), `crossAxisAlignment` sur l'axe transversal (comme `align-items`). `children` est la liste des widgets à disposer. Tu connais ce modèle à deux axes — seuls les noms changent.

### ⭐ `Expanded` et `Flexible` : partager l'espace (`flex`)

```dart
Row(
  children: [
    Expanded(child: Text(description)),     // prend TOUT l'espace restant (= flex: 1)
    Text(montant),                          // prend juste sa taille
  ],
)
```

`Expanded` fait prendre à un widget tout l'espace disponible sur l'axe principal — c'est le `flex: 1` de Flexbox (palier 2). Avec plusieurs `Expanded`, l'espace se partage proportionnellement. C'est la clé pour des mises en page qui s'adaptent à toutes les tailles d'écran, et la solution la plus fréquente aux débordements.

### Espacement : `Padding`, `SizedBox`

```dart
Padding(
  padding: const EdgeInsets.all(16),        // marge intérieure de 16 partout (= padding CSS)
  child: Text("Espacé"),
)
const SizedBox(height: 12)                  // un espace vide de 12 de haut (entre deux widgets)
```

En Flutter, l'espacement est aussi un widget : `Padding` ajoute une marge intérieure (comme `padding` en CSS), `SizedBox` crée un espace fixe (souvent entre deux éléments d'une `Column`/`Row`). `EdgeInsets` décrit les marges (`.all`, `.symmetric`, `.only`).

### ⭐ `ListView.builder` : une liste défilante et performante

```dart
ListView.builder(
  itemCount: depenses.length,               // combien d'éléments
  itemBuilder: (context, index) {           // appelée POUR CHAQUE élément visible
    final d = depenses[index];
    return ListTile(
      title: Text(d.description),
      trailing: Text("${d.montant} €"),
    );
  },
)
```

`ListView` défile automatiquement quand le contenu dépasse l'écran. `ListView.builder` est la version **performante** : `itemBuilder` n'est appelée que pour les éléments **visibles** à l'écran (et un peu autour), pas pour les milliers d'items de la liste. C'est essentiel en mobile : une liste de 10 000 dépenses ne construit que la dizaine visible. `ListTile` est un widget prêt à l'emploi pour une ligne de liste.

> ⚠️ Pour une **longue** liste, utilise toujours `ListView.builder`, jamais une `Column` dans un `SingleChildScrollView` (qui construirait tous les éléments d'un coup et ramerait).

### `Stack` : superposer

```dart
Stack(
  children: [
    Image.network(url),                     // le fond
    Positioned(                             // placé par-dessus, en bas à droite
      bottom: 8, right: 8,
      child: Icon(Icons.favorite),
    ),
  ],
)
```

`Stack` superpose ses enfants (le premier en dessous, les suivants par-dessus), et `Positioned` place précisément un enfant. Utile pour un badge sur une image, un bouton par-dessus une photo, une étiquette en coin — l'équivalent de `position: absolute` en CSS.

### Le piège du débordement (overflow)

```
Bande jaune et noire + "RenderFlex overflowed" : le contenu dépasse l'espace disponible.
Causes et solutions :
  - un Text trop long dans une Row → entoure-le d'Expanded (ou Flexible)
  - trop d'éléments dans une Column qui dépasse l'écran → mets-les dans un ListView (défilement)
  - une taille fixe trop grande → utilise Expanded/Flexible pour s'adapter
```

Le débordement est le problème de mise en page le plus fréquent en Flutter. Sa cause est toujours la même — le contenu demande plus de place qu'il n'y en a — et ses solutions tournent autour de `Expanded`/`Flexible` (partager l'espace) ou du défilement (`ListView`). Le reconnaître et le résoudre vite est un réflexe à acquérir.

---

## Les problèmes que tu vas rencontrer

**« RenderFlex overflowed by X pixels » (bande jaune et noire).** Le contenu dépasse. Dans une `Row`, entoure le widget flexible d'`Expanded`/`Flexible`. Dans une `Column` trop longue, passe à une `ListView`. C'est le bug numéro un.

**Ma longue liste rame / consomme trop.** Tu utilises une `Column` (tout construit d'un coup) au lieu de `ListView.builder` (seulement le visible). Passe à `ListView.builder`.

**Mes alignements ne font rien.** `mainAxisAlignment` agit sur l'axe principal, `crossAxisAlignment` sur l'axe transversal — vérifie que tu agis sur le bon axe (vertical pour `Column`, horizontal pour `Row`). C'est le piège classique de Flexbox (palier 2) aussi.

**Mon `Expanded` provoque une erreur.** `Expanded` ne s'utilise **que** directement dans une `Column`, une `Row` ou un `Flex`. Hors de ce contexte, il échoue. Mets-le comme enfant direct d'une `Row`/`Column`.

**Ma `ListView` dans une `Column` ne s'affiche pas / erreur de hauteur.** Une `ListView` veut une hauteur bornée ; dans une `Column`, entoure-la d'`Expanded` pour qu'elle prenne l'espace restant.

**Mon `Stack` ne superpose pas comme prévu.** L'ordre compte (le premier enfant est en dessous), et sans `Positioned`, les enfants s'alignent selon `alignment`. Utilise `Positioned` pour placer précisément.

---

## Ce qu'on te demandera

En **entretien/test Flutter**, la mise en page est testée concrètement : « comment places-tu deux éléments côte à côte / l'un sous l'autre ? » (`Row`/`Column`), « comment fais-tu une liste défilante performante ? » (`ListView.builder`), « comment résous-tu un overflow ? » (`Expanded`/`Flexible`/défilement). On peut te demander de reproduire une maquette simple.

On peut demander : « différence entre `Column` et `ListView` ? » (une n'a pas de défilement et construit tout), « que fait `Expanded` ? », « à quoi sert le `Scaffold` ? », « d'où te vient le modèle à deux axes ? » (Flexbox, palier 2).

En **mission**, construire et ajuster des mises en page avec ces widgets est le pain quotidien du développement Flutter.

---

## Ce qui te démarquera

**Le transfert de Flexbox.** Dire « `Column`/`Row`, c'est Flexbox du palier 2 : `mainAxisAlignment` = `justify-content`, `Expanded` = `flex: 1` » montre que tu réutilises un modèle maîtrisé — tu disposes vite et juste, sans tâtonner.

**`ListView.builder` par réflexe.** Savoir que les listes se font avec `.builder` (seulement le visible construit) et jamais avec une `Column` pour de longues listes est un réflexe de performance mobile qui te distingue immédiatement.

**Résoudre un overflow sereinement.** Reconnaître la bande jaune et noire, en identifier la cause (contenu > espace) et appliquer la bonne solution (`Expanded`, `Flexible`, défilement) sans paniquer est exactement l'aisance qu'on attend.

**Et penser adaptatif.** Utiliser `Expanded`/`Flexible` pour des mises en page qui s'adaptent à toutes les tailles d'écran (comme le responsive du web, palier 2), plutôt que des tailles fixes fragiles, montre une maturité de conception d'interface.

---

## 📚 À lire

**flutter.dev → *Layouts in Flutter*** et ***Building layouts* (tutorial)** : la référence, avec `Column`, `Row`, `Expanded`, et un exemple pas à pas.

**flutter.dev → *Lists* (ListView, ListView.builder)** : comment faire des listes, y compris la version performante.

**flutter.dev → *Dealing with box constraints* et le *Flutter Widget of the Week* (vidéos courtes)** : pour comprendre les contraintes et résoudre les débordements.

Relis le palier 2 (CSS Flexbox) : `Column`/`Row`/`Expanded` en sont la transposition directe. Le modèle à deux axes est le même.

---

## 🤖 Le mini-projet à demander à l'IA

Transposer Flexbox et construire un écran de liste :

> « Je suis en formation de développeur, palier 9 (Flutter). Je connais bien le CSS Flexbox (palier 2). On me dit que Column/Row de Flutter, c'est Flexbox. Sans tout me réexpliquer, aide-moi à transposer : donne-moi les correspondances (mainAxisAlignment ↔ justify-content, crossAxisAlignment ↔ align-items, Expanded ↔ flex) et fais-moi construire la mise en page d'un écran de liste de dépenses : un Scaffold avec AppBar et bouton flottant, un body en Column, des Row pour les lignes (description à gauche via Expanded, montant à droite). »

Puis les listes et les débordements :

> « Aide-moi à afficher une longue liste de dépenses avec ListView.builder, et explique-moi pourquoi on ne construit que les éléments visibles (performance) et pourquoi je ne dois pas utiliser une Column pour ça. Ensuite, provoque exprès un débordement (RenderFlex overflow) avec un texte trop long dans une Row, et fais-moi trouver la cause et la solution (Expanded/Flexible). Fais le lien avec les débordements que je connais en CSS. »

---

## 🛠️ À faire

> Sur ton vrai téléphone, avec hot reload.

1. **Le Scaffold** : construis un écran avec `Scaffold`, un `AppBar` (titre) et un `FloatingActionButton` (icône +). Vérifie que chaque élément est à sa place standard.
2. **⭐ Column et Row** : empile des widgets dans une `Column`, et mets deux widgets côte à côte dans une `Row`. Joue avec `mainAxisAlignment` et `crossAxisAlignment`, et note l'équivalent CSS de chacun.
3. **⭐ Expanded** : dans une `Row`, mets une description à gauche (dans `Expanded`) et un montant à droite. Vérifie que la description prend l'espace restant et que le montant reste à droite.
4. **Espacement** : ajoute du `Padding` autour d'un bloc et des `SizedBox` entre les éléments d'une `Column`. Compare avec `padding`/marges en CSS.
5. **⭐ ListView.builder** : affiche une liste de dépenses (transformée avec `map`/`where`, leçon 02) dans une `ListView.builder` avec des `ListTile`. Fais-la défiler sur ton téléphone.
6. **Le piège de la Column** : essaie d'afficher une longue liste dans une `Column` et observe le problème (pas de défilement / débordement). Passe à `ListView.builder` et constate la différence.
7. **⭐ Résoudre un overflow** : provoque un « RenderFlex overflowed » (un texte trop long dans une `Row`), identifie la cause, et corrige avec `Expanded`/`Flexible`.
8. **Stack** : superpose un badge (`Positioned`) sur une image ou un bloc avec `Stack`.
9. **La ListView dans une Column** : mets une `ListView` dans une `Column` (au-dessus, un titre), et règle l'erreur de hauteur avec `Expanded`.
10. **Le lien** : dans ton journal, dresse les correspondances Flutter ↔ CSS Flexbox (axes, alignements, `Expanded`/`flex`), et note le réflexe « longue liste = `ListView.builder` ».

<details>
<summary>Corrections et points de contrôle</summary>

**2-3.** `Column`/`Row` sont Flexbox (palier 2). `Column` : axe principal vertical ; `Row` : axe principal horizontal. `mainAxisAlignment` aligne sur l'axe principal (= `justify-content`), `crossAxisAlignment` sur l'axe transversal (= `align-items`). `Expanded` = `flex: 1` : le widget prend l'espace restant sur l'axe principal. C'est le modèle à deux axes que tu connais déjà ; seuls les noms changent. Rappel : `Expanded` ne s'utilise que comme enfant direct d'une `Row`/`Column`/`Flex`.

**5-6.** `ListView.builder` est le bon outil pour toute liste un peu longue : `itemBuilder` n'est appelée que pour les éléments **visibles** à l'écran, pas pour les milliers d'items. Une `Column` (ou une `ListView` non-builder avec une grande liste) construit **tout** d'un coup — lent et gourmand en mémoire. Réflexe mobile : longue liste = `ListView.builder`. Et une `ListView` dans une `Column` a besoin d'une hauteur bornée → `Expanded`.

**7.** Le « RenderFlex overflowed » (bande jaune et noire) signifie : le contenu demande plus de place que disponible sur l'axe principal. Cause unique, solutions ciblées : un texte trop long dans une `Row` → l'entourer d'`Expanded`/`Flexible` (il prend l'espace disponible et se tronque/retourne à la ligne au lieu de déborder) ; trop d'éléments empilés → passer au défilement (`ListView`). C'est le bug de mise en page le plus fréquent ; le reconnaître et appliquer `Expanded`/défilement est un réflexe rapide à acquérir, cousin des débordements CSS du palier 2.
</details>

---

## ✅ Acquis si…

- [ ] Je structure un écran avec `Scaffold` (`appBar`, `body`, `floatingActionButton`).
- [ ] J'empile avec `Column` et j'aligne avec `Row`, en reconnaissant Flexbox (palier 2).
- [ ] J'utilise `mainAxisAlignment`/`crossAxisAlignment` sur le bon axe.
- [ ] Je partage l'espace avec `Expanded`/`Flexible` (= `flex`).
- [ ] J'espace avec `Padding` et `SizedBox`.
- [ ] J'affiche une longue liste avec `ListView.builder` (seulement le visible construit).
- [ ] Je reconnais et je résous un « RenderFlex overflow ».
- [ ] Je superpose avec `Stack`/`Positioned` quand c'est utile.

# Leçon 03 — Flutter : tout est widget, l'UI est une fonction de l'état

> 🎯 **À la fin de cette leçon** : tu comprends le modèle mental de Flutter — tout est widget, et l'interface est une **fonction de l'état** — un modèle que tu connais déjà, car c'est celui de React (palier 3).
> ⏱️ 4 h · **Prérequis** : leçons 01-02, et React (palier 3, le modèle `UI = f(état)`).

---

## De quoi on parle

Flutter construit des interfaces avec une seule brique : le **widget**. Un texte est un widget, un bouton est un widget, un espacement est un widget, la mise en page (colonne, ligne) est un widget, l'écran entier est un widget. On compose des widgets dans des widgets pour décrire toute l'interface — un **arbre** de widgets.

Et le principe directeur : **l'interface est une fonction de l'état**. Tu ne manipules pas l'interface à la main (« change ce texte », « cache ce bouton ») ; tu décris à quoi l'interface doit ressembler **pour un état donné**, et quand l'état change, Flutter reconstruit l'interface pour toi.

```
   état (des données)  ──▶  build()  ──▶  arbre de widgets  ──▶  pixels à l'écran
   l'état change       ──▶  Flutter rappelle build()  ──▶  nouvel arbre  ──▶  écran mis à jour
```

Si ça te semble familier, c'est normal : **c'est exactement le modèle de React** (palier 3). `UI = f(état)`, composition de composants, reconstruction sur changement d'état. Flutter applique la même idée aux applications mobiles natives, avec des widgets au lieu de composants JSX. Ton palier 3 est ta meilleure préparation.

---

## À quoi ça sert, concrètement

**Parce que « tout est widget » unifie toute l'interface.** Pas de distinction entre « éléments », « conteneurs », « styles », « animations » : tout est widget, tout se compose de la même façon. Une fois compris le principe de composition, tu peux construire n'importe quelle interface en assemblant des widgets. C'est un modèle simple et puissant.

**Parce que « l'UI est une fonction de l'état » élimine une classe entière de bugs.** Dans l'ancien modèle (manipuler l'interface à la main, comme le DOM impératif du palier 2), on oublie toujours de mettre à jour un endroit quand l'état change — l'interface et les données se désynchronisent. En décrivant l'interface **à partir** de l'état, cette désynchronisation devient impossible : l'interface est toujours le reflet exact de l'état courant. C'est la grande leçon de React (palier 3), rejouée.

**Parce que c'est le modèle mental à acquérir avant tout le reste.** Les widgets de mise en page (leçon 04), l'état local (leçon 05), la gestion d'état (leçon 07) n'ont de sens qu'une fois ce principe intégré. Tant qu'on pense « je modifie l'interface », on lutte contre Flutter. Dès qu'on pense « je modifie l'état, Flutter reconstruit », tout devient naturel.

**Et parce que ton expérience React te donne une avance considérable.** Là où un débutant doit assimiler ce changement de paradigme (souvent le plus dur), tu l'as déjà vécu au palier 3. Tu reconnais le modèle ; tu apprends surtout une nouvelle syntaxe et un nouveau vocabulaire.

---

## Où ça intervient dans le développement

Le modèle « tout est widget / UI = f(état) » est le fondement de toute application Flutter :

```
   ÉTAT (données : liste de dépenses, utilisateur connecté, écran courant...)
        ▼  tu décris l'interface EN FONCTION de cet état
   build() renvoie un ARBRE de widgets :
     MaterialApp
       └─ Scaffold (structure d'écran, leçon 04)
            ├─ AppBar (le titre)
            └─ Column
                 ├─ Text("Total : 45 €")       ← dépend de l'état
                 └─ ListView (les dépenses)     ← dépend de l'état
        ▼  l'état change → Flutter rappelle build() → nouvel arbre → écran à jour
```

Trois ancrages.

**C'est le modèle de React (palier 3), transposé.** `UI = f(état)`, la composition, la reconstruction sur changement d'état : identiques. Un widget Flutter est un composant React ; `build()` est la fonction de rendu ; l'arbre de widgets est l'arbre de composants. Tu retrouves ton palier 3 avec une autre syntaxe.

**Il prépare tous les widgets suivants (leçons 04-06).** La mise en page (leçon 04), l'état local avec `setState` (leçon 05), la navigation (leçon 06) sont tous des widgets qui s'insèrent dans cet arbre. Comprendre le modèle rend ces leçons évidentes.

**Et il mène à la gestion d'état (leçon 07).** « Quand l'état change, l'interface se reconstruit » pose la question : **où** vit l'état, et comment le partager entre widgets ? C'est tout le sujet de la gestion d'état (leçon 07), exactement comme en React l'état local menait à un gestionnaire d'état.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas créer ta première app Flutter, lire son arbre de widgets, modifier des widgets et voir le résultat (sur ton **vrai téléphone**, pas un émulateur — c'est plus rapide et réaliste), comprendre le *hot reload* (voir tes changements en une seconde), et distinguer widgets `const` (figés) et widgets qui dépendent de l'état.

### En équipe, en entreprise

**Le code Flutter est une composition de widgets.** Lire une app, c'est lire un arbre de widgets imbriqués. Les projets extraient des widgets réutilisables (comme on extrait des composants React) pour garder le code lisible — un arbre trop profond dans un seul fichier est un défaut relevé en revue.

**Le hot reload change le rythme de développement.** Modifier le code et voir le résultat en moins d'une seconde, sans perdre l'état de l'app, est un confort majeur. On itère sur l'interface très vite — comme avec le rechargement à chaud du web (palier 2-3).

**`const` est une optimisation qu'on applique systématiquement.** Un widget `const` (qui ne dépend d'aucun état) n'est **pas reconstruit** quand l'état change : Flutter le réutilise. Mettre `const` partout où c'est possible est une bonne pratique de performance que l'analyseur suggère.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : composer des widgets, lire un arbre de widgets, `build()`, le hot reload, `const` sur les widgets statiques, extraire un widget pour la lisibilité.

Régulièrement : distinguer widgets avec/sans état (leçon 05), passer des données en paramètres (constructeurs nommés, leçon 01), les widgets de base (`Text`, `Icon`, `Image`, `Container`).

Rare au début : les widgets personnalisés complexes, le `CustomPaint` (dessin), les `RenderObject`, le cycle de rendu détaillé (build/layout/paint). À connaître de nom ; tu les creuseras au besoin.

---

## La mécanique

### Tout est widget, et on compose

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MonApp());

class MonApp extends StatelessWidget {       // un widget SANS état (leçon 05 pour l'autre type)
  const MonApp({super.key});

  @override
  Widget build(BuildContext context) {       // build() décrit l'interface
    return MaterialApp(
      home: Scaffold(                         // structure d'un écran (leçon 04)
        appBar: AppBar(title: const Text("Mes dépenses")),
        body: const Center(
          child: Text("Bonjour Flutter"),     // un widget Text, dans un Center, dans un Scaffold...
        ),
      ),
    );
  }
}
```

Lis l'imbrication : `MaterialApp` contient un `Scaffold`, qui contient un `AppBar` et un `body`, qui contient un `Center`, qui contient un `Text`. **Chaque élément est un widget**, et l'interface entière est cet arbre. `build()` est la fonction qui renvoie l'arbre — c'est l'équivalent exact du `return` d'un composant React (palier 3). Note `const` sur les widgets qui ne dépendent de rien.

### ⭐ L'interface est une fonction de l'état (le modèle de React)

```
Tu NE fais PAS :  "quand on clique, change le texte du compteur à la main"
Tu fais :         "le texte affiche la valeur du compteur" (une fonction de l'état)
                  + "quand on clique, incrémente le compteur" (tu changes l'ÉTAT)
                  → Flutter rappelle build() et reconstruit le texte avec la nouvelle valeur.
```

C'est le principe central, identique à React (palier 3). Tu décris l'interface **à partir** de l'état (`Text("Compteur : $compteur")`), et tu ne touches jamais à l'interface directement. Pour changer l'affichage, tu changes **l'état**, et Flutter s'occupe de reconstruire. L'interface ne peut donc jamais être en désaccord avec l'état — le bug de désynchronisation du DOM impératif (palier 2) disparaît.

(Le *comment* on change l'état et déclenche la reconstruction — `setState` — est la leçon 05. Ici, on ancre le **principe**.)

### `build()` : la fonction de rendu

```
build(context) renvoie un arbre de widgets, en fonction de l'état courant.
Flutter appelle build() :
  - une première fois pour afficher,
  - puis À CHAQUE FOIS que l'état dont dépend le widget change.
build() doit être "pur" : il DÉCRIT l'interface, il ne fait pas d'effets de bord
  (pas d'appel réseau dedans, pas de modification d'état) — comme le rendu React.
```

`build()` est l'équivalent du corps d'un composant React : il traduit l'état courant en arbre de widgets. Il peut être rappelé souvent (à chaque changement d'état, à chaque image d'une animation), donc il doit rester rapide et sans effet de bord — on y **décrit**, on n'y **agit** pas.

### Les deux types de widgets (aperçu, détaillé leçon 05)

```
StatelessWidget : un widget qui ne change pas tout seul. Son apparence dépend
                  seulement de ce qu'on lui passe (ses paramètres). Ex. : un Text, une icône.
StatefulWidget  : un widget qui a un ÉTAT INTERNE pouvant changer dans le temps
                  (un compteur, une case à cocher). → leçon 05.
```

Pour l'instant, retiens la distinction : certains widgets sont de pures descriptions figées (Stateless), d'autres portent un état qui évolue (Stateful, leçon 05). C'est l'écho des composants React sans état vs avec `useState` (palier 3).

### ⭐ `const` : les widgets qui ne se reconstruisent pas

```dart
const Text("Titre fixe")          // ce widget ne dépend d'aucun état :
                                  // Flutter le marque const et NE le reconstruit PAS.
Text("Total : $total")            // celui-ci dépend de l'état (total) : reconstruit au besoin.
```

Un widget `const` est figé à la compilation (leçon 01) : comme il ne peut pas changer, Flutter le réutilise sans le reconstruire, ce qui économise du travail. La règle : mets `const` sur tout widget qui ne dépend d'aucun état. L'analyseur Dart te le suggère. C'est l'optimisation de base, gratuite.

### Le hot reload : voir ses changements en une seconde

```
Modifie le code → sauvegarde → l'app se met à jour en < 1 s, EN GARDANT son état.
C'est ce qui rend le développement d'interface en Flutter si rapide.
(hot RESTART, lui, repart de zéro en perdant l'état.)
```

Le *hot reload* applique tes changements de code à l'app déjà en cours, presque instantanément. C'est le même confort que le rechargement à chaud du web (paliers 2-3), et ce qui rend l'itération sur l'interface très agréable. On l'utilise en continu.

---

## Les problèmes que tu vas rencontrer

**« J'essaie de changer un widget directement et rien ne se passe. »** Tu penses encore « impératif » (palier 2). En Flutter, on ne modifie pas un widget : on change l'**état**, et Flutter reconstruit. Rappelle-toi `UI = f(état)`.

**Mon arbre de widgets est un mur illisible.** Trop d'imbrication dans un seul `build()`. Extrais des sous-widgets (comme on extrait des composants React) pour aérer. Un `build()` géant est un signal de refactoring.

**L'analyseur me dit « prefer const ».** Un widget ne dépend d'aucun état mais n'est pas marqué `const`. Ajoute `const` : c'est l'optimisation gratuite. Suis la suggestion.

**Mon `build()` fait un appel réseau et c'est le chaos.** `build()` peut être rappelé très souvent ; y mettre un effet de bord (appel réseau, modification d'état) provoque des boucles et des bugs. `build()` **décrit** seulement. Les effets vont ailleurs (leçons 05, 07, 08).

**Je teste sur un émulateur et c'est lent.** Teste sur ton **vrai téléphone** (mode développeur + câble USB), dès le début : plus rapide, plus réaliste (vrais gestes, vraie performance, vraie connexion). C'est le conseil explicite du palier.

**Je ne sais pas si mon widget doit être Stateless ou Stateful.** Pour l'instant : s'il ne change pas tout seul, Stateless. S'il a un état interne qui évolue, Stateful (leçon 05). Dans le doute, commence Stateless.

---

## Ce qu'on te demandera

En **entretien Flutter**, le modèle mental est la première chose vérifiée : « qu'est-ce qu'un widget ? », « que veut dire "tout est widget" ? », **« comment met-on à jour l'interface en Flutter ? »** (on change l'état, Flutter reconstruit — on ne touche pas l'interface directement). On apprécie que tu fasses le lien avec React.

On peut demander : « à quoi sert `const` sur un widget ? », « que fait `build()` et que ne doit-il pas faire ? », « différence Stateless/Stateful ? ».

En **mission**, on attend que tu composes des widgets proprement, que tu penses en termes d'état, et que tu mettes `const` par réflexe — le modèle doit être intégré.

---

## Ce qui te démarquera

**Arriver avec le modèle déjà acquis.** Dire « c'est `UI = f(état)`, comme React : je ne manipule pas l'interface, je change l'état et Flutter reconstruit » montre que tu as transféré le concept le plus difficile du mobile depuis le web. C'est une avance énorme sur un débutant pur.

**Penser déclaratif, pas impératif.** Ne jamais chercher à « modifier un widget », mais toujours à « changer l'état », est le réflexe qui sépare ceux qui luttent contre Flutter de ceux qui coulent avec. Tu l'as déjà au palier 3.

**`const` et l'extraction de widgets.** Mettre `const` systématiquement et extraire des sous-widgets pour la lisibilité sont des marques de maturité immédiatement visibles.

**Et le `build()` pur.** Savoir que `build()` décrit sans agir (pas d'effets de bord), exactement comme le rendu React, évite les bugs les plus déroutants et montre une vraie compréhension du cycle.

---

## 📚 À lire

**flutter.dev → *Introduction to widgets*** et ***Flutter architectural overview*** : le modèle « tout est widget » et l'arbre de widgets, par la source.

**flutter.dev → *Start thinking declaratively*** : la page qui explique `UI = f(état)` — et qui compare explicitement avec le mode impératif. Essentielle, et courte.

**flutter.dev → *Get started / write your first app*** : pour créer ta première app et découvrir le hot reload.

Relis le palier 3 (React : `UI = f(état)`, composition de composants, rendu) : c'est **le même modèle**. Et le palier 2 (DOM impératif) pour le contraste avec ce que Flutter remplace.

---

## 🤖 Le mini-projet à demander à l'IA

Transférer le modèle de React vers Flutter :

> « Je suis en formation de développeur, palier 9 (Flutter). Je connais bien React (palier 3) et son modèle UI = fonction de l'état. On me dit que Flutter suit le même modèle avec des widgets. Sans tout me réexpliquer, aide-moi à faire le pont : montre-moi un composant React simple et son équivalent Flutter côte à côte, et fais-moi repérer les correspondances (composant↔widget, JSX↔arbre de widgets, rendu↔build, props↔paramètres de constructeur). Fais-moi écrire mon premier arbre de widgets (un Scaffold avec un titre et un texte centré). »

Puis le principe déclaratif :

> « Aide-moi à ancrer "l'interface est une fonction de l'état". Donne-moi un petit affichage (un total de dépenses) et fais-moi exprimer le texte EN FONCTION de l'état, sans jamais toucher le widget directement. Explique-moi ce que build() doit faire (décrire) et ne jamais faire (effets de bord, appels réseau). Puis fais-moi repérer, dans un bout de code, les widgets qui devraient être const parce qu'ils ne dépendent d'aucun état. Relie tout ça à ce que je sais de React. »

---

## 🛠️ À faire

> Installe Flutter, et teste sur ton **vrai téléphone** (mode développeur + USB) dès le départ.

1. **Première app** : crée une app Flutter et lance-la sur ton téléphone. Lis l'arbre de widgets de l'exemple généré et identifie l'imbrication (`MaterialApp` → `Scaffold` → ...).
2. **⭐ Composer** : construis un écran simple — un `Scaffold` avec un `AppBar` (titre) et un `body` contenant un texte centré. Ajoute un deuxième widget. Ressens que « tout est widget ».
3. **Le hot reload** : modifie un texte, sauvegarde, et observe la mise à jour en moins d'une seconde sans redémarrer. Note la différence avec un hot *restart*.
4. **⭐ UI = f(état)** : affiche une valeur (un total codé en dur pour l'instant) via `Text("Total : $total")`. Comprends que le texte **dépend** de la variable : si elle change, l'affichage changera (le *comment* est la leçon 05).
5. **Le piège impératif** : essaie de « changer le texte directement » et constate que ce n'est pas comme ça qu'on fait. Formule par écrit la bonne façon (changer l'état, Flutter reconstruit).
6. **`const`** : mets `const` sur les widgets qui ne dépendent de rien, et laisse sans `const` ceux qui dépendent d'une variable. Écoute les suggestions de l'analyseur.
7. **Extraire un widget** : quand ton `build()` grossit, extrais une partie dans un widget séparé (comme un composant React). Vérifie que l'arbre reste lisible.
8. **`build()` pur** : note par écrit pourquoi on ne met pas d'appel réseau dans `build()` (il est rappelé souvent).
9. **Le lien** : dans ton journal, dresse les correspondances Flutter ↔ React (widget↔composant, build↔rendu, arbre de widgets↔arbre de composants, `UI = f(état)` identique).

<details>
<summary>Corrections et points de contrôle</summary>

**2.** « Tout est widget » : le texte, le centrage, la barre de titre, la structure de l'écran — chaque élément est un widget, et l'interface entière est l'arbre formé par leur imbrication. Composer = imbriquer des widgets dans des widgets. C'est le même principe que composer des composants React (palier 3), avec `build()` à la place du `return` JSX.

**4-5.** Le cœur de la leçon, et le concept le plus important du mobile. L'interface est une **fonction de l'état** : tu décris ce que l'écran affiche **pour un état donné** (`Text("Total : $total")`), et tu ne manipules jamais l'interface directement. Pour changer l'affichage, tu changes l'**état**, et Flutter rappelle `build()` pour reconstruire. Conséquence : l'interface ne peut jamais être désynchronisée de l'état — le bug typique du DOM impératif (palier 2) disparaît. C'est exactement `UI = f(état)` de React (palier 3) ; ton avance, c'est de l'avoir déjà vécu.

**6.** `const` sur un widget qui ne dépend d'aucun état : Flutter le fige et ne le reconstruit pas quand l'état change (il le réutilise tel quel). C'est une optimisation gratuite et systématique, suggérée par l'analyseur. Un `Text("Titre fixe")` est `const` ; un `Text("Total : $total")` ne peut pas l'être (il dépend de `total`). La distinction prolonge directement le `const` de la leçon 01.

**8.** `build()` peut être rappelé très souvent — à chaque changement d'état, à chaque image d'une animation. Il doit donc être rapide et **sans effet de bord** : il **décrit** l'interface, il n'**agit** pas. Un appel réseau dans `build()` serait relancé à chaque reconstruction (boucles, surcharge). Les actions (appels réseau, modifications d'état) vont ailleurs (leçons 05, 07, 08). C'est la même règle que le rendu pur de React (palier 3).
</details>

---

## ✅ Acquis si…

- [ ] Je comprends que tout, en Flutter, est un widget, et que l'interface est un arbre de widgets.
- [ ] Je compose des widgets en les imbriquant, et j'extrais des sous-widgets pour la lisibilité.
- [ ] Je pense « UI = fonction de l'état » : je change l'état, Flutter reconstruit l'interface.
- [ ] Je ne cherche jamais à modifier un widget directement (pas de pensée impérative).
- [ ] Je sais que `build()` décrit l'interface et ne fait pas d'effets de bord.
- [ ] Je mets `const` sur les widgets qui ne dépendent d'aucun état.
- [ ] J'utilise le hot reload pour itérer rapidement, sur mon vrai téléphone.
- [ ] Je fais le lien explicite entre le modèle de Flutter et celui de React (palier 3).

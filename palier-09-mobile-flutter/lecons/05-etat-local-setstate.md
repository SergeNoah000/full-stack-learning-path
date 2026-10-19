# Leçon 05 — État local : StatefulWidget, setState, cycle de vie

> 🎯 **À la fin de cette leçon** : tu gères l'état interne d'un widget avec `StatefulWidget` et `setState` — le `useState` de React (palier 3) en Flutter — et tu connais le cycle de vie (`initState`/`dispose`).
> ⏱️ 4 h · **Prérequis** : leçon 03 (UI = f(état)), et le `useState`/cycle de vie de React (palier 3).

---

## De quoi on parle

À la leçon 03, tu as posé le principe : l'interface est une fonction de l'état, et quand l'état change, Flutter reconstruit. Cette leçon répond au **comment** : comment un widget détient un état qui évolue, et comment déclencher la reconstruction.

- un **`StatefulWidget`** est un widget qui possède un **état interne** modifiable (un compteur, une case cochée, le texte d'un champ) ;
- **`setState`** est la fonction qu'on appelle pour modifier cet état **et** demander à Flutter de reconstruire (`build()`) ;
- le **cycle de vie** décrit les moments clés : `initState` (à la création, pour initialiser), `dispose` (à la destruction, pour nettoyer).

C'est **exactement** le `useState` de React (palier 3) : un état local, une fonction qui le change et redéclenche le rendu. `initState`/`dispose` sont les `useEffect` de montage/démontage. Ton palier 3 est, encore, ta meilleure préparation — tu transposes un modèle connu.

---

## À quoi ça sert, concrètement

**Parce que presque toute interface a un état qui change.** Une case qu'on coche, un champ qu'on remplit, un onglet sélectionné, un compteur, un menu ouvert/fermé : ce sont des états **internes** à un widget. Sans état local, l'interface serait figée. `StatefulWidget` + `setState` est l'outil de base de l'interactivité.

**Parce que `setState` est ce qui relie l'interaction à l'affichage.** L'utilisateur agit (clic, saisie) → tu modifies l'état dans `setState` → Flutter reconstruit l'interface avec le nouvel état. C'est la boucle fondamentale de toute app interactive, et `setState` en est le pivot. Oublier `setState` (changer l'état sans lui) est le bug numéro un : l'état change mais l'écran ne bouge pas.

**Parce que le cycle de vie évite les fuites et les bugs.** `initState` initialise ce qu'il faut à la création (un contrôleur de champ, un abonnement). `dispose` nettoie à la destruction (libérer le contrôleur, annuler l'abonnement à un Stream, leçon 02). Oublier `dispose` provoque des fuites de mémoire — un problème réel en mobile où les ressources sont comptées.

**Et parce que ressentir les limites de `setState` prépare la leçon 07.** `setState` gère l'état **local** à un widget. Dès que plusieurs écrans doivent partager le même état (l'utilisateur connecté, le panier), `setState` ne suffit plus — il faudrait « remonter » l'état et le faire redescendre péniblement. Cette limite, que tu vas sentir ici, est exactement ce qui justifie un gestionnaire d'état (Riverpod, leçon 07) — comme en React le `useState` menait à un gestionnaire global.

---

## Où ça intervient dans le développement

L'état local vit **dans** un widget, et pilote sa reconstruction :

```
   StatefulWidget
     └─ State (l'objet qui DÉTIENT l'état)
          ├─ initState()   ← à la création : initialiser (contrôleurs, abonnements)
          ├─ une variable d'état (ex. int _compteur = 0)
          ├─ build()       ← décrit l'UI EN FONCTION de _compteur (leçon 03)
          │     interaction → setState(() => _compteur++)  ← change l'état + reconstruit
          └─ dispose()     ← à la destruction : nettoyer (libérer, désabonner)
```

Trois ancrages.

**C'est le `useState` de React (palier 3).** Une variable d'état + une fonction qui la change et redéclenche le rendu : `setState` EST `useState`. Et `initState`/`dispose` sont les effets de montage/démontage (`useEffect` avec `[]`) de React. Tu transposes.

**Il s'appuie sur `UI = f(état)` (leçon 03).** `setState` ne « met pas à jour l'interface » : il modifie l'état et laisse Flutter reconstruire selon le principe de la leçon 03. On reste déclaratif — `setState` est juste le déclencheur officiel du changement d'état.

**Et sa limite mène à Riverpod (leçon 07).** L'état local ne se partage pas facilement entre widgets éloignés. Quand tu voudras un état global (utilisateur, thème, données partagées), tu sentiras que `setState` ne suffit pas — et la leçon 07 apportera la réponse. Cette leçon prépare le terrain en te faisant **vivre** la limite.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas convertir un `StatelessWidget` en `StatefulWidget`, détenir une variable d'état, la modifier avec `setState` et voir l'interface se reconstruire, gérer un champ de texte avec un `TextEditingController` (créé dans `initState`, libéré dans `dispose`), et ressentir la limite de `setState` quand tu voudras partager un état entre deux écrans.

### En équipe, en entreprise

**`setState` reste l'outil de l'état vraiment local.** Même avec un gestionnaire d'état global (leçon 07), beaucoup d'états restent locaux à un widget (un champ, une animation, un état d'ouverture) et se gèrent très bien avec `setState`. On ne met pas tout dans le global — l'état local a sa place.

**`dispose` est une exigence, pas une option.** Tout contrôleur (`TextEditingController`, `AnimationController`), tout abonnement à un Stream (leçon 02) doit être libéré dans `dispose`. L'oublier fuit de la mémoire. L'analyseur et les revues le vérifient.

**On évite les `setState` trop larges.** Appeler `setState` reconstruit **tout** le widget et ses enfants. Un `setState` sur un widget énorme est coûteux ; on isole l'état dans le plus petit widget possible. C'est une question de performance courante.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : `StatefulWidget`/`State`, les variables d'état, `setState`, `initState`, `dispose`, `TextEditingController` pour les champs.

Régulièrement : le cycle de vie complet (`didUpdateWidget`, `didChangeDependencies`), les `AnimationController`, isoler l'état dans un petit widget pour limiter les reconstructions.

Rare ou avancé : les `GlobalKey`, l'accès à l'état d'un enfant, les `InheritedWidget` à la main (remplacés par Riverpod, leçon 07), les subtilités du cycle de rendu. À connaître de nom ; tu les creuseras au besoin.

---

## La mécanique

### `StatelessWidget` vs `StatefulWidget`

```
StatelessWidget : apparence figée, dépend seulement de ses paramètres. (leçons 03-04)
StatefulWidget  : possède un ÉTAT INTERNE qui peut changer dans le temps,
                  et dont le changement reconstruit le widget.
Règle : commence Stateless ; passe Stateful seulement quand un état interne doit évoluer.
```

### ⭐ Un StatefulWidget avec setState (le useState de React)

```dart
class Compteur extends StatefulWidget {
  const Compteur({super.key});
  @override
  State<Compteur> createState() => _CompteurState();
}

class _CompteurState extends State<Compteur> {
  int _compteur = 0;                         // ⭐ l'ÉTAT interne

  void _incrementer() {
    setState(() {                            // ⭐ modifier l'état DANS setState
      _compteur++;                           // → Flutter rappelle build() ensuite
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Compteur : $_compteur"),       // l'UI dépend de l'état (leçon 03)
        ElevatedButton(
          onPressed: _incrementer,           // l'interaction change l'état
          child: const Text("+1"),
        ),
      ],
    );
  }
}
```

Lis la boucle : l'état `_compteur` vit dans l'objet `State` ; l'utilisateur appuie sur le bouton → `_incrementer` appelle `setState` qui modifie `_compteur` **et** signale à Flutter de reconstruire → `build()` est rappelée, et le `Text` affiche la nouvelle valeur. C'est **exactement** `useState` de React (palier 3) : `_compteur` est l'état, `setState(() => _compteur++)` est le `setCompteur(c => c+1)`. La structure en deux classes (le widget + son `State`) est une particularité Dart, mais le concept est identique.

### ⭐ Le point crucial : modifier l'état TOUJOURS dans setState

```dart
// ❌ change l'état mais ne reconstruit PAS : l'écran reste figé
_compteur++;

// ✅ change l'état ET reconstruit
setState(() { _compteur++; });
```

C'est le piège numéro un. Modifier une variable d'état **hors** de `setState` change bien la valeur, mais Flutter ne le sait pas et ne reconstruit pas : l'affichage reste figé, et on croit à un bug mystérieux. **Tout changement d'état passe par `setState`.** (En React, muter sans `setState` a le même effet : rien ne se met à jour.)

### Le cycle de vie : initState et dispose

```dart
class _ChampRecherche extends State<ChampRecherche> {
  late final TextEditingController _controleur;

  @override
  void initState() {                         // ⭐ à la CRÉATION : initialiser
    super.initState();
    _controleur = TextEditingController();
  }

  @override
  void dispose() {                           // ⭐ à la DESTRUCTION : nettoyer
    _controleur.dispose();                   // libérer le contrôleur (évite une fuite)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controleur);
  }
}
```

`initState` s'exécute une fois, à la création du widget : on y initialise ce qui doit l'être (un contrôleur, un abonnement à un Stream — leçon 02). `dispose` s'exécute à la destruction : on y **libère** ces ressources. Oublier `dispose` sur un contrôleur ou un abonnement provoque une **fuite de mémoire**. C'est l'équivalent exact du `useEffect(() => { ...; return () => cleanup() }, [])` de React (palier 3) : effet au montage, nettoyage au démontage.

### Isoler l'état pour limiter les reconstructions

```
setState reconstruit TOUT le widget (et ses enfants).
Donc : place l'état dans le PLUS PETIT widget qui en a besoin.
Un compteur dans son propre petit widget → seul ce petit widget se reconstruit,
pas tout l'écran. (Performance.)
```

Comme `setState` reconstruit tout le sous-arbre du widget, on isole un état changeant dans un petit widget dédié, pour que la reconstruction reste locale. C'est une bonne pratique de performance, et une raison de plus de bien découper (leçon 03).

### ⭐ La limite de setState (ce qui mène à la leçon 07)

```
setState gère l'état LOCAL à un widget. Mais si DEUX écrans ont besoin du même état
(l'utilisateur connecté, le panier, les dépenses partagées) :
  - avec setState, il faut remonter l'état dans un ancêtre commun et le faire redescendre
    en paramètres à travers tous les widgets intermédiaires → pénible, fragile ("prop drilling").
  → C'est la limite. La réponse est un gestionnaire d'état (Riverpod, leçon 07).
```

`setState` est parfait pour un état confiné à un widget. Dès que plusieurs widgets éloignés doivent lire et modifier le **même** état, il faut le « remonter » dans un ancêtre commun et le repasser en paramètres à chaque niveau — le *prop drilling* fastidieux que tu as peut-être connu en React (palier 3). Cette douleur est **le signal** qu'il faut un gestionnaire d'état. On la fera vivre en exercice, et la leçon 07 apportera Riverpod.

---

## Les problèmes que tu vas rencontrer

**« Je change l'état mais l'écran ne bouge pas. »** Le piège numéro un : tu as modifié la variable **hors** de `setState`. Enveloppe le changement dans `setState(() { ... })`.

**« setState() called after dispose(). »** Tu appelles `setState` sur un widget déjà détruit (souvent après un `await` : le widget a été retiré pendant l'attente). Vérifie `if (mounted)` avant le `setState` qui suit un `await`.

**Mon app fuit de la mémoire / devient lente avec le temps.** Un contrôleur ou un abonnement non libéré dans `dispose`. Libère tout ce que tu crées dans `initState`, dans `dispose`.

**Mon `TextEditingController` provoque une erreur.** Tu l'as recréé dans `build()` (rappelé souvent) au lieu d'`initState`. Crée-le une fois dans `initState`, libère-le dans `dispose`.

**Tout mon écran se reconstruit pour un petit changement.** `setState` reconstruit tout le widget. Isole l'état changeant dans un plus petit widget dédié.

**Je galère à partager un état entre deux écrans avec setState.** C'est **normal** : c'est la limite de `setState`. Ne t'acharne pas à remonter l'état partout — c'est le signal qu'il faut Riverpod (leçon 07).

---

## Ce qu'on te demandera

En **entretien Flutter**, l'état local est fondamental : « différence entre `StatelessWidget` et `StatefulWidget` ? », **« à quoi sert `setState` ? »** (modifier l'état et déclencher la reconstruction), « que se passe-t-il si tu changes l'état sans `setState` ? » (rien ne se met à jour), « à quoi servent `initState` et `dispose` ? ».

On peut demander : « pourquoi libérer un contrôleur dans `dispose` ? » (fuite mémoire), « quelle est la limite de `setState` ? » (l'état partagé entre widgets → gestionnaire d'état), « fais le lien avec React » (`setState`≈`useState`).

En **mission**, gérer l'état local avec `setState`, initialiser/nettoyer dans `initState`/`dispose`, et savoir quand passer au global (leçon 07) sont des gestes quotidiens.

---

## Ce qui te démarquera

**Le transfert depuis React.** Dire « `setState`, c'est `useState` ; `initState`/`dispose`, c'est `useEffect` de montage/démontage » montre que tu transposes un modèle maîtrisé — tu gères l'état sans tâtonner.

**Le réflexe `setState` systématique.** Ne jamais modifier un état hors de `setState`, et comprendre pourquoi (sinon rien ne se reconstruit), t'évite le bug le plus fréquent et montre que tu as compris la boucle.

**La discipline du `dispose`.** Libérer systématiquement contrôleurs et abonnements dans `dispose` montre que tu penses aux ressources — crucial en mobile, et souvent négligé par les débutants.

**Et savoir reconnaître la limite.** Dire « ici, l'état est local, `setState` suffit ; là, il est partagé entre écrans, il faut un gestionnaire d'état » prouve que tu choisis le bon outil au bon niveau — exactement la maturité que la leçon 07 va récompenser.

---

## 📚 À lire

**flutter.dev → *State management / Start thinking declaratively* et *Adding interactivity to your Flutter app*** : le tutoriel officiel sur `StatefulWidget` et `setState`.

**flutter.dev → *StatefulWidget* et *State* (doc des classes)** : le cycle de vie (`initState`, `dispose`, `setState`) expliqué.

**flutter.dev → *TextField* et *Retrieve the value of a text field*** : l'usage du `TextEditingController` avec `initState`/`dispose`.

Relis le palier 3 (React : `useState`, `useEffect` de montage/démontage, le *prop drilling*) : `setState`/`initState`/`dispose` en sont la transposition, et la limite de `setState` est la même qu'en React.

---

## 🤖 Le mini-projet à demander à l'IA

Transposer useState, et ressentir la limite :

> « Je suis en formation de développeur, palier 9 (Flutter). Je connais bien useState et useEffect de React (palier 3). On me dit que setState de Flutter, c'est useState. Sans tout me réexpliquer, aide-moi à transposer : fais-moi convertir un StatelessWidget en StatefulWidget, détenir une variable d'état, et la modifier avec setState. Insiste sur LE piège : modifier l'état hors de setState ne reconstruit pas. Puis fais-moi gérer un champ de texte avec un TextEditingController créé dans initState et libéré dans dispose, et explique le lien avec le useEffect de montage/démontage. »

Puis la limite qui mène à Riverpod :

> « Maintenant, fais-moi RESSENTIR la limite de setState : donne-moi un scénario où deux écrans différents doivent lire et modifier le MÊME état (par ex. l'utilisateur connecté, ou la liste de dépenses). Fais-moi essayer de le résoudre avec setState seul, pour que je vive la douleur de devoir remonter l'état et le faire redescendre partout (prop drilling). Ne me donne pas encore la solution : aide-moi juste à comprendre pourquoi c'est pénible, car c'est ce qui justifiera un gestionnaire d'état à la leçon 07. »

---

## 🛠️ À faire

> Sur ton vrai téléphone, avec hot reload.

1. **Stateless → Stateful** : prends un widget `Stateless` et convertis-le en `Stateful`. Comprends la structure en deux classes (le widget + son `State`).
2. **⭐ setState** : crée un compteur : une variable d'état `_compteur`, un bouton qui appelle `setState(() => _compteur++)`, un `Text` qui l'affiche. Vérifie que l'affichage se met à jour.
3. **⭐ Le piège** : modifie `_compteur` **sans** `setState` et observe que l'écran ne bouge pas, alors que la valeur a changé. Comprends pourquoi, puis corrige. C'est le bug à ne plus jamais faire.
4. **Le transfert** : écris en commentaire l'équivalent React de ton compteur (`useState`, `setCompteur`). Note que c'est le même concept.
5. **⭐ Cycle de vie** : ajoute un champ de texte avec un `TextEditingController`. Crée-le dans `initState`, libère-le dans `dispose`. Note le parallèle avec `useEffect` de montage/démontage.
6. **La fuite** : enlève le `dispose` du contrôleur et comprends (par écrit) pourquoi c'est une fuite de mémoire. Remets-le.
7. **`mounted`** : fais un `setState` après un `await` (une opération asynchrone), et protège-le avec `if (mounted)` pour éviter l'erreur « setState after dispose ».
8. **Isoler l'état** : mets un état changeant dans un petit widget dédié, et observe que seul ce petit widget se reconstruit, pas tout l'écran.
9. **⭐ La limite** : essaie de partager un même état (par ex. un total) entre deux écrans en utilisant seulement `setState`. Vis la difficulté de remonter l'état. Note dans ton journal pourquoi c'est pénible — c'est le besoin que Riverpod (leçon 07) comblera.

<details>
<summary>Corrections et points de contrôle</summary>

**2-4.** `setState` EST le `useState` de React (palier 3) : une variable d'état interne, et une fonction qui la modifie **et** redéclenche le rendu (`build()`). La boucle : interaction → `setState(() => état changé)` → Flutter rappelle `build()` → l'UI reflète le nouvel état. La structure en deux classes (`StatefulWidget` + `State`) est propre à Dart, mais le concept est identique à React. Tu transposes, tu ne réapprends pas.

**3.** Le piège numéro un, à vivre une fois pour ne plus jamais le refaire. Modifier une variable d'état **hors** de `setState` change bien la valeur en mémoire, mais Flutter n'en est pas informé et ne reconstruit pas : l'écran reste figé, et on cherche un bug fantôme. **Tout changement d'état passe par `setState`.** C'est le pendant de « muter sans `setState`/`setValue` ne met rien à jour » en React.

**5-6.** `initState` (création) et `dispose` (destruction) sont l'effet de montage/démontage de React (`useEffect(..., [])` avec sa fonction de nettoyage). On initialise dans `initState` ce qui doit vivre pendant le widget (contrôleurs, abonnements à un Stream — leçon 02), et on le **libère** dans `dispose`. Oublier `dispose` = fuite de mémoire, un problème concret en mobile. Et un contrôleur se crée dans `initState`, jamais dans `build()` (rappelé trop souvent).

**9.** La limite, et le cœur de la pédagogie « ressentir avant d'outiller ». `setState` est parfait pour un état confiné à un widget. Mais partager le même état entre deux écrans éloignés oblige à le remonter dans un ancêtre commun et à le repasser en paramètres à chaque niveau intermédiaire — le *prop drilling* pénible et fragile (connu de React, palier 3). Cette douleur **n'est pas** un échec : c'est le signal précis qu'il faut un gestionnaire d'état. L'avoir vécue rend la leçon 07 (Riverpod) évidente et désirée, au lieu d'un outil tombé du ciel.
</details>

---

## ✅ Acquis si…

- [ ] Je distingue `StatelessWidget` et `StatefulWidget` et je choisis le bon.
- [ ] Je détiens un état interne et je le modifie **toujours** dans `setState`.
- [ ] Je sais que modifier l'état hors de `setState` ne reconstruit pas l'interface.
- [ ] J'initialise dans `initState` et je libère (contrôleurs, abonnements) dans `dispose`.
- [ ] Je sais pourquoi oublier `dispose` provoque une fuite de mémoire.
- [ ] Je protège un `setState` après `await` avec `if (mounted)`.
- [ ] J'isole l'état changeant dans un petit widget pour limiter les reconstructions.
- [ ] Je reconnais la limite de `setState` (état partagé entre écrans) et je fais le lien avec React.

# Leçon 06 — Navigation : routes, passage de données, retour de résultat

> 🎯 **À la fin de cette leçon** : tu fais passer l'utilisateur d'un écran à l'autre, tu transmets des données à l'écran suivant, et tu récupères un résultat au retour — la navigation mobile, cousine du routing web (palier 3).
> ⏱️ 3 h · **Prérequis** : leçons 03-05, et le routing de React (palier 3).

---

## De quoi on parle

Une application a plusieurs écrans : la liste des dépenses, le détail d'une dépense, le formulaire d'ajout, les réglages. La **navigation** est ce qui fait passer de l'un à l'autre. En Flutter :

- on **empile** et **dépile** des écrans : ouvrir un écran le **pousse** sur une pile (`push`), le fermer le **retire** (`pop`) et revient au précédent — c'est le modèle naturel du bouton « retour » mobile ;
- on **passe des données** à l'écran qu'on ouvre (l'id de la dépense à afficher) ;
- on **récupère un résultat** quand l'écran se ferme (le formulaire renvoie la dépense créée).

Tu connais le concept : c'est le **routing** du web (React Router, palier 3), adapté au mobile. La différence majeure est le modèle en **pile** (lié au bouton retour physique/geste d'Android et iOS) et le passage de données **typé** entre écrans. On verra l'approche de base (`Navigator`) et on mentionnera les routeurs déclaratifs modernes (`go_router`).

---

## À quoi ça sert, concrètement

**Parce qu'une app sans navigation est un seul écran.** Dès qu'il y a plus d'un écran — et c'est toujours le cas —, il faut naviguer. Lister puis voir le détail, ouvrir un formulaire, aller aux réglages : la navigation structure le parcours de l'utilisateur. C'est un besoin universel.

**Parce que le modèle en pile correspond au geste « retour ».** Sur mobile, l'utilisateur attend que « retour » (bouton Android, geste iOS) le ramène à l'écran précédent. La pile de navigation (`push`/`pop`) implémente exactement ce comportement : chaque écran ouvert s'empile, retour dépile. Respecter ce modèle, c'est respecter l'attente de l'utilisateur.

**Parce que passer des données proprement évite des bugs et du couplage.** L'écran de détail a besoin de savoir **quelle** dépense afficher. On lui passe la donnée (ou son id) à l'ouverture, de façon typée — pas via un état global bricolé. Et le formulaire d'ajout **renvoie** la nouvelle dépense à l'écran précédent, qui l'ajoute à sa liste. Ce flux aller-retour est le motif le plus courant.

**Et parce que c'est une question d'entretien et un point de maquette fréquent.** « Comment navigues-tu entre écrans ? », « comment passes-tu une donnée à l'écran suivant ? », « comment récupères-tu un résultat ? » reviennent souvent, et tout test pratique en a besoin.

---

## Où ça intervient dans le développement

La navigation relie les écrans, chacun étant un widget (leçon 03) :

```
   Écran Liste
     │ tap sur une dépense → push(ÉcranDétail(depense))   ← passe la donnée
     ▼
   Écran Détail (empilé par-dessus)
     │ bouton retour → pop()                              ← revient à Liste
     ▼
   Écran Liste
     │ tap sur "+" → push(ÉcranFormulaire)
     ▼  ... l'utilisateur remplit ...
   Écran Formulaire
     │ valider → pop(nouvelleDepense)                     ← RENVOIE un résultat
     ▼
   Écran Liste  ← reçoit nouvelleDepense (via await) et l'ajoute à sa liste
```

Trois ancrages.

**C'est le routing du web (palier 3), en pile.** React Router faisait passer d'une « page » à l'autre ; `Navigator` fait passer d'un écran à l'autre. Le concept — plusieurs vues, une qui s'affiche — est le même. La spécificité mobile est la **pile** (empiler/dépiler) alignée sur le bouton retour.

**Le passage de données utilise les constructeurs typés (leçon 01).** On ouvre `EcranDetail(depense: d)` : la donnée passe par le **constructeur** de l'écran, typé et null-safe (leçon 01). Pas de magie, pas de variable globale — un simple paramètre.

**Le retour de résultat utilise les Futures (leçon 02).** `push` renvoie un `Future` qui se résout quand l'écran se ferme, avec la valeur passée à `pop`. On l'attend avec `await` — l'async de la leçon 02, appliqué à la navigation.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas naviguer d'un écran de liste vers un écran de détail en lui passant une dépense, revenir avec le bouton retour, ouvrir un formulaire et récupérer la dépense créée au retour pour l'ajouter à la liste. Tu testeras le geste « retour » sur ton vrai téléphone.

### En équipe, en entreprise

**`go_router` est le standard moderne.** Pour les apps réelles, on utilise un routeur déclaratif comme `go_router` (soutenu par l'équipe Flutter) : il centralise les routes (comme le fichier de routes du web), gère les URL (utile pour le web et les liens profonds), et simplifie les cas complexes. Le `Navigator` de base reste dessous ; comprendre `push`/`pop` est le prérequis.

**Les liens profonds (*deep links*) comptent.** Ouvrir l'app directement sur un écran précis depuis une notification ou un lien (`monapp://depense/42`) est une attente courante. Les routeurs déclaratifs (`go_router`) gèrent ça. On n'en a pas besoin au début, mais on sait que ça existe.

**Le passage de données se fait par constructeur typé, pas par variable globale.** Mettre la donnée à afficher dans un état global « pour la retrouver dans l'écran suivant » est une mauvaise pratique (couplage, bugs). On passe la donnée en paramètre de l'écran. En revanche, l'état **partagé** (utilisateur connecté) relève du gestionnaire d'état (leçon 07), pas de la navigation.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : `Navigator.push`/`pop`, passer une donnée par le constructeur de l'écran, récupérer un résultat avec `await` sur le `push`.

Régulièrement : `go_router` et les routes nommées, `pushReplacement` (remplacer l'écran courant, ex. après connexion), passer plusieurs écrans d'un coup, la barre de navigation basse (`BottomNavigationBar`) et les onglets.

Rare ou avancé : les liens profonds, les transitions personnalisées, les routes imbriquées, la gestion fine de la pile. À connaître de nom ; tu les creuseras au besoin.

---

## La mécanique

### Ouvrir un écran : `push`

```dart
// depuis l'écran Liste, ouvrir l'écran Détail en lui PASSANT une dépense
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EcranDetail(depense: d),   // ⭐ donnée passée par le constructeur
  ),
);
```

`push` empile un nouvel écran par-dessus l'actuel. L'écran s'ouvre avec une transition (glissement) et un bouton retour apparaît automatiquement dans son `AppBar`. La donnée (`depense: d`) passe par le **constructeur** de l'écran — typé et null-safe (leçon 01), sans variable globale.

### Recevoir la donnée dans l'écran ouvert

```dart
class EcranDetail extends StatelessWidget {
  final Depense depense;                       // ⭐ reçue par le constructeur
  const EcranDetail({super.key, required this.depense});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(depense.description)),   // retour auto dans l'AppBar
      body: Text("Montant : ${depense.montant} €"),
    );
  }
}
```

L'écran de détail est un widget (leçon 03) qui reçoit sa donnée en paramètre `required` (leçon 01). Il l'utilise comme n'importe quelle propriété. C'est propre, typé, et explicite : on voit exactement ce dont l'écran a besoin pour s'afficher.

### Revenir en arrière : `pop`

```dart
Navigator.pop(context);          // ferme l'écran courant, revient au précédent
```

`pop` retire l'écran du sommet de la pile et revient au précédent. Le bouton retour de l'`AppBar` et le geste/bouton retour du système le font automatiquement — mais on peut aussi l'appeler soi-même (après avoir validé un formulaire, par exemple).

### ⭐ Récupérer un résultat au retour (avec un Future)

```dart
// depuis l'écran Liste : ouvrir le formulaire et ATTENDRE son résultat
Future<void> _ajouter() async {
  final nouvelle = await Navigator.push<Depense>(    // push renvoie un Future
    context,
    MaterialPageRoute(builder: (_) => const EcranFormulaire()),
  );
  if (nouvelle != null) {                            // null si l'utilisateur a annulé (retour)
    setState(() => _depenses.add(nouvelle));         // on l'ajoute à la liste (leçon 05)
  }
}
```

```dart
// dans l'écran Formulaire : renvoyer la dépense créée via pop
Navigator.pop(context, depenseCreee);                // ⭐ la valeur passée à pop est le résultat
```

C'est le motif le plus utile. `push` renvoie un **Future** (leçon 02) qui se résout quand l'écran se ferme, avec la valeur passée à `pop`. L'écran de liste `await` ce résultat : si l'utilisateur a validé, il reçoit la dépense créée et l'ajoute (via `setState`, leçon 05) ; s'il a annulé (retour), le résultat est `null` (d'où la vérification, null safety de la leçon 01). Ce flux relie trois leçons : navigation + Future + état local.

### Les routeurs déclaratifs : `go_router` (à connaître)

```
Navigator.push direct convient pour commencer et pour des cas simples.
Pour une vraie app, on centralise les routes avec go_router :
  - toutes les routes déclarées à un endroit (comme un fichier de routes web)
  - navigation par chemin : context.go('/depenses/42')
  - gère les URL (web) et les liens profonds (ouvrir l'app sur un écran précis)
Le Navigator reste dessous ; push/pop restent le modèle mental.
```

Pour les projets réels, `go_router` offre une déclaration centralisée des routes (qui rappelle le fichier de routes du web, palier 4/6) et gère les cas avancés. On commence avec `Navigator.push`/`pop` pour comprendre le modèle en pile, puis on adopte `go_router` quand l'app grandit.

---

## Les problèmes que tu vas rencontrer

**« Mon écran de détail ne reçoit pas la donnée. »** Tu ne l'as pas passée au constructeur, ou le paramètre n'est pas `required`. Passe la donnée dans `EcranDetail(depense: d)` et déclare-la `required` (leçon 01).

**« Le résultat de mon formulaire est toujours null. »** Tu as fermé l'écran avec `pop(context)` sans valeur, ou l'utilisateur est revenu en arrière (annulation). Pour renvoyer un résultat, utilise `pop(context, valeur)`. Et vérifie le `null` au retour (annulation légitime).

**« setState after dispose après une navigation. »** Tu fais `setState` après l'`await` d'un `push`, mais le widget a pu être retiré entre-temps. Vérifie `if (mounted)` (leçon 05) avant le `setState` qui suit l'`await`.

**Le bouton retour ne fait rien / revient trop loin.** Tu as peut-être utilisé `pushReplacement` (qui remplace au lieu d'empiler) là où il fallait `push`, ou vidé la pile. Comprends si tu veux empiler (`push`) ou remplacer (`pushReplacement`, ex. après connexion pour qu'on ne revienne pas à l'écran de login).

**Je passe la donnée par un état global « pour simplifier ».** Mauvaise pratique : la donnée à afficher dans un écran passe par son constructeur, pas par un état global. L'état global est pour l'état **partagé** (utilisateur, leçon 07), pas pour transmettre un paramètre d'écran.

**Mon app grossit et la navigation devient un plat de spaghettis.** C'est le signal pour passer à `go_router` : centraliser les routes au lieu de `push` dispersés partout.

---

## Ce qu'on te demandera

En **entretien/test Flutter**, la navigation est quasi systématique : « comment navigues-tu entre deux écrans ? » (`Navigator.push`/`pop`), **« comment passes-tu une donnée à l'écran suivant ? »** (par le constructeur), « comment récupères-tu un résultat au retour ? » (`await` sur `push`, `pop(valeur)`). On peut te demander d'implémenter un flux liste → détail → retour.

On peut demander : « pourquoi le modèle en pile ? » (le bouton retour), « différence `push`/`pushReplacement` ? », « connais-tu `go_router` et pourquoi on l'utilise ? », « d'où vient ce concept pour toi ? » (le routing web, palier 3).

En **mission**, construire des flux de navigation (passage de données, retour de résultat) et, sur les vrais projets, utiliser `go_router` sont des gestes courants.

---

## Ce qui te démarquera

**Le flux aller-retour maîtrisé.** Savoir ouvrir un formulaire, récupérer son résultat avec `await`, gérer l'annulation (`null`) et ajouter le résultat à la liste (`setState`) montre que tu relies navigation, Future et état — une vraie compréhension, pas une recette.

**Le passage de données par constructeur.** Transmettre la donnée en paramètre typé (pas par un état global bricolé) montre une conception propre et découplée — une maturité que beaucoup de débutants n'ont pas.

**Connaître `go_router` et savoir quand l'adopter.** Dire « je commence avec `Navigator` pour comprendre la pile, et je passe à `go_router` quand l'app grandit (routes centralisées, liens profonds) » montre que tu connais l'outillage réel et son bon moment.

**Et le transfert depuis le web.** Relier la navigation mobile au routing web (palier 3), en notant la spécificité de la pile et du bouton retour, prouve que tu vois le concept commun derrière les plateformes.

---

## 📚 À lire

**flutter.dev → *Navigation and routing* (Navigate to a new screen and back, Send data to a new screen, Return data from a screen)** : les trois tutoriels officiels correspondant exactement à cette leçon.

**pub.dev → *go_router* (documentation)** : le routeur déclaratif de référence, pour quand ton app grandit. Lis l'introduction pour comprendre ce qu'il apporte.

**flutter.dev → *Deep linking*** : pour découvrir les liens profonds (ouvrir l'app sur un écran précis), quand tu en auras besoin.

Relis le palier 3 (routing React) : le concept de navigation entre vues est le même ; la pile et le bouton retour sont la spécificité mobile. Et les leçons 01 (constructeurs typés), 02 (Future) et 05 (`setState`), qui se combinent ici.

---

## 🤖 Le mini-projet à demander à l'IA

Construire un flux liste → détail → formulaire :

> « Je suis en formation de développeur, palier 9 (Flutter). Je connais le routing du web (React, palier 3). En Flutter, la navigation est une pile (push/pop). Sans coder à ma place, guide-moi pour construire un flux : depuis un écran Liste, ouvrir un écran Détail en lui PASSANT une dépense par son constructeur (typé, leçon 01), puis revenir avec pop. Explique-moi pourquoi on passe la donnée par le constructeur et pas par un état global, et pourquoi le modèle en pile correspond au bouton retour du mobile. »

Puis le retour de résultat :

> « Aide-moi sur le motif le plus utile : ouvrir un écran Formulaire et RÉCUPÉRER la dépense créée au retour. Explique-moi que push renvoie un Future (leçon 02) que j'attends avec await, que le formulaire renvoie sa valeur avec pop(valeur), et que le résultat est null si l'utilisateur annule (retour) — à gérer avec la null safety (leçon 01). Puis fais-moi ajouter la dépense reçue à ma liste avec setState (leçon 05), en pensant à vérifier if (mounted) après l'await. Enfin, explique-moi quand je devrais passer à go_router. »

---

## 🛠️ À faire

> Sur ton vrai téléphone : teste le geste/bouton « retour ».

1. **⭐ Liste → Détail** : depuis un écran de liste, ouvre un écran de détail avec `Navigator.push`, en passant une dépense par le **constructeur** de l'écran. Affiche ses données dans le détail.
2. **Retour** : reviens à la liste avec le bouton retour de l'`AppBar`, puis avec le geste/bouton système du téléphone. Vérifie que les deux dépilent l'écran.
3. **Le passage propre** : vérifie que ta donnée passe bien par un paramètre `required` du constructeur (leçon 01), et non par une variable globale. Note pourquoi c'est mieux.
4. **⭐ Formulaire → résultat** : ouvre un écran de formulaire, et récupère la dépense créée au retour avec `await Navigator.push<Depense>(...)`. Dans le formulaire, renvoie-la avec `pop(context, depenseCreee)`.
5. **L'annulation** : reviens du formulaire **sans** valider (bouton retour) et vérifie que le résultat est `null`. Gère ce cas (ne rien ajouter) avec la null safety.
6. **Ajouter à la liste** : quand le formulaire renvoie une dépense, ajoute-la à ta liste avec `setState` (leçon 05). Vérifie `if (mounted)` après l'`await`.
7. **push vs pushReplacement** : note la différence, et un cas où `pushReplacement` est le bon choix (après connexion, pour ne pas revenir à l'écran de login).
8. **go_router (découverte)** : lis l'introduction de `go_router` et note, par écrit, ce qu'il apporte par rapport à `Navigator.push` et quand tu l'adopterais.
9. **Le lien** : dans ton journal, relie la navigation mobile au routing web (palier 3), et note comment cette leçon combine les leçons 01 (constructeur typé), 02 (Future) et 05 (`setState`).

<details>
<summary>Corrections et points de contrôle</summary>

**1-3.** `Navigator.push` empile un écran, `pop` le dépile — le modèle en pile qui correspond exactement au bouton/geste « retour » du mobile. La donnée à afficher passe par le **constructeur** de l'écran (`EcranDetail(depense: d)`), typé et `required` (leçon 01) : c'est explicite (on voit ce dont l'écran a besoin), typé (le compilateur vérifie) et découplé (pas de variable globale). Passer la donnée par un état global « pour simplifier » est une mauvaise pratique — l'état global est réservé à l'état **partagé** (utilisateur connecté, leçon 07), pas au passage d'un paramètre d'écran.

**4-6.** Le motif le plus utile, et celui qui relie trois leçons. `push` renvoie un **Future** (leçon 02) qui se résout à la fermeture de l'écran avec la valeur passée à `pop(context, valeur)`. L'écran appelant `await` ce résultat : validé → il reçoit la dépense créée ; annulé (retour) → il reçoit `null` (à gérer, null safety de la leçon 01). Puis il l'ajoute à sa liste avec `setState` (leçon 05). Attention au piège : après l'`await`, le widget a pu être détruit → vérifie `if (mounted)` avant le `setState` (leçon 05). Navigation + Future + état local se combinent ici.

**7.** `push` empile (on pourra revenir) ; `pushReplacement` **remplace** l'écran courant (on ne pourra pas y revenir). Le cas typique de `pushReplacement` : après une connexion réussie, on remplace l'écran de login par l'écran principal, pour que le bouton retour ne ramène pas au formulaire de login. Choisir entre les deux, c'est décider de ce que fait le bouton retour.

**8-9.** `go_router` centralise les routes (comme un fichier de routes web, palier 4/6), navigue par chemin, et gère URL et liens profonds. On commence avec `Navigator.push`/`pop` pour comprendre la pile (le modèle mental), puis on adopte `go_router` quand l'app grandit et que les `push` dispersés deviennent difficiles à suivre. Le concept de navigation entre vues est celui du routing web (palier 3) ; la spécificité mobile est la pile alignée sur le bouton retour.
</details>

---

## ✅ Acquis si…

- [ ] J'ouvre un écran avec `Navigator.push` et je reviens avec `pop`.
- [ ] Je comprends le modèle en pile et son lien avec le bouton/geste retour du mobile.
- [ ] Je passe une donnée à l'écran suivant par son constructeur typé (pas par un état global).
- [ ] Je récupère un résultat au retour avec `await` sur `push` et `pop(valeur)`.
- [ ] Je gère l'annulation (résultat `null`) avec la null safety.
- [ ] J'ajoute le résultat à ma liste avec `setState`, en vérifiant `if (mounted)` après l'`await`.
- [ ] Je connais la différence `push`/`pushReplacement` et un cas d'usage de chacun.
- [ ] Je sais ce qu'apporte `go_router` et quand l'adopter, et je fais le lien avec le routing web.

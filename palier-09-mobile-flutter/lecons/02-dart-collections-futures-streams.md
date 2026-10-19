# Leçon 02 — Dart : collections, Futures, Streams

> 🎯 **À la fin de cette leçon** : tu transformes des collections avec `map`/`where`/`fold` (que tu connais déjà), tu manipules des `Future` (l'async que tu connais déjà), et tu découvres le seul vrai point neuf : les `Stream`, des valeurs qui arrivent dans le temps.
> ⏱️ 4 h · **Prérequis** : leçon 01, et `map`/`filter`/`reduce` (palier 1, leçon 06) + `async`/`await` (palier 4).

---

## De quoi on parle

Encore du transfert, et un point neuf. Trois sujets :

- les **collections** : `map`, `where` (le `filter` de Dart), `fold` (le `reduce` de Dart), sur les `List` — exactement ce que tu as appris au palier 1 ;
- les **Futures** : une valeur qui arrivera plus tard, manipulée avec `async`/`await` — exactement la `Promise` que tu connais depuis le palier 4 ;
- les **Streams** : une **suite** de valeurs qui arrivent dans le temps (pas une seule, comme un Future, mais plusieurs). C'est le vrai concept neuf, et il est central dans Flutter.

La ligne directrice : collections et Futures sont des retrouvailles (tu les as déjà, avec d'autres noms) ; concentre ton énergie sur les Streams, qui n'ont pas d'équivalent direct dans ce que tu as fait et qui structurent la réactivité de Flutter (leçon 07).

---

## À quoi ça sert, concrètement

**Parce que transformer des collections est le geste le plus fréquent.** Afficher une liste de dépenses, filtrer par catégorie, calculer un total : c'est `map`/`where`/`fold`, exactement comme en JS (palier 1). Tu construis une interface à partir de données, et ces données passent par ces transformations en permanence.

**Parce que tout ce qui touche au réseau et au disque est asynchrone.** Charger des données depuis une API (leçon 08), lire un fichier, interroger la base locale (leçon 09) : tout renvoie un `Future`. L'`async`/`await` que tu maîtrises (palier 4) s'applique tel quel. Sans async, l'interface se figerait pendant chaque appel.

**Parce que les Streams sont la façon dont Flutter « réagit » aux changements.** Beaucoup de choses en mobile sont des flux : la position GPS qui bouge, les messages qui arrivent, l'état d'une connexion, les résultats d'une recherche au fil de la frappe. Un Stream modélise « des valeurs qui continuent d'arriver », et Flutter sait reconstruire l'interface à chaque nouvelle valeur. C'est la base de la gestion d'état réactive (leçon 07).

**Et parce que distinguer Future et Stream est une question d'entretien.** « Un Future, c'est une valeur future unique ; un Stream, c'est plusieurs valeurs dans le temps » : cette distinction simple est souvent demandée, et comprise de travers par les débutants.

---

## Où ça intervient dans le développement

Ces trois outils irriguent tout le code Flutter :

```
   Données (liste)  ──map/where/fold──▶  données transformées  ──▶  affichées (leçon 04)
   API / disque     ──Future──▶ await ──▶  une valeur, plus tard (leçon 08-09)
   GPS / recherche / état  ──Stream──▶  valeurs successives  ──▶  UI qui se reconstruit (leçon 07)
```

Trois ancrages.

**Les collections, c'est le palier 1 en Dart.** `map`, `where`, `fold` sont `map`, `filter`, `reduce` (palier 1, leçon 06) avec deux noms changés (`where` pour `filter`, `fold` pour `reduce`). L'immuabilité (ne pas muter, produire une nouvelle liste) que tu as apprise s'applique à l'identique.

**Les Futures, c'est l'async du palier 4.** Une `Promise` JS est un `Future` Dart ; `async`/`await` est **identique**. Ce que tu as appris sur l'asynchrone (ne pas bloquer, attendre un résultat, gérer les erreurs avec `try/catch`) transfère sans changement.

**Les Streams préparent la gestion d'état (leçon 07).** La réactivité de Flutter — « quand une valeur change, l'interface se met à jour » — repose sur l'idée de flux. Riverpod (leçon 07) et beaucoup de sources de données (leçon 09) exposent des Streams. Cette leçon pose le concept.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas transformer des listes avec `map`/`where`/`fold`, écrire et attendre des `Future` avec `async`/`await`, gérer leurs erreurs, puis créer et écouter un `Stream` pour comprendre « plusieurs valeurs dans le temps ». Tu feras le parallèle avec le palier 1 (collections) et le palier 4 (async).

### En équipe, en entreprise

**Les transformations de collections sont partout.** Préparer les données avant de les afficher est un geste constant. Un code lisible enchaîne `where` puis `map` plutôt que des boucles manuelles — comme en JS.

**L'async se gère proprement, avec les erreurs.** Un `await` sans `try/catch` autour d'un appel réseau qui échoue fait planter. Gérer les erreurs des Futures (réseau coupé, timeout) est une exigence — d'autant plus en mobile où la connexion est instable (leçon 09).

**Les Streams, on les consomme plus qu'on ne les crée.** Les bibliothèques (localisation, base de données, websockets) exposent des Streams ; ton rôle est surtout de les **écouter** et d'en reconstruire l'interface (via `StreamBuilder` ou Riverpod, leçon 07). Créer ses propres Streams est plus rare au début.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : `map`, `where`, `fold`/`reduce`, `toList`, `async`/`await`, `try/catch` sur un Future.

Régulièrement : `firstWhere`, `any`, `every`, `sort`, le *spread* (`...`) et les *collection-if/for* (très pratiques en Flutter pour construire des listes de widgets), écouter un Stream.

Rare ou avancé : créer ses propres Streams (`StreamController`, `async*`/`yield`), les Streams *broadcast*, les transformations de Streams, `Isolate` (parallélisme). À connaître de nom ; tu les creuseras au besoin.

---

## La mécanique

### Les collections : `map`, `where`, `fold` (le palier 1 en Dart)

```dart
final depenses = [
  {"desc": "Café", "montant": 3.5, "cat": "sorties"},
  {"desc": "Train", "montant": 24.0, "cat": "transport"},
  {"desc": "Resto", "montant": 18.0, "cat": "sorties"},
];

// where = filter (palier 1)
final sorties = depenses.where((d) => d["cat"] == "sorties").toList();

// map = map (palier 1)
final descriptions = depenses.map((d) => d["desc"] as String).toList();

// fold = reduce (palier 1) : accumuler vers une seule valeur
final total = depenses.fold<double>(0, (somme, d) => somme + (d["montant"] as double));

// on enchaîne, comme en JS
final totalSorties = depenses
    .where((d) => d["cat"] == "sorties")
    .fold<double>(0, (s, d) => s + (d["montant"] as double));
```

C'est **exactement** le palier 1 (leçon 06), avec deux renommages : `where` au lieu de `filter`, `fold` au lieu de `reduce`. Noter le `.toList()` : `map`/`where` renvoient un itérable « paresseux » qu'on matérialise en liste avec `toList()`. L'enchaînement (`where` puis `fold`) et l'immuabilité (on produit une nouvelle liste, on ne mute pas l'originale) sont identiques à JS. Tu ne réapprends rien — tu renommes.

### Les *spread* et *collection-if/for* (très utiles en Flutter)

```dart
final base = [1, 2, 3];
final etendu = [0, ...base, 4];              // spread, comme en JS : [0,1,2,3,4]

final afficherBouton = true;
final widgets = [
  Texte("Titre"),
  if (afficherBouton) Bouton("OK"),          // collection-if : inclure sous condition
  for (final d in depenses) Ligne(d),        // collection-for : une entrée par élément
];
```

Ces constructions, qu'on retrouvera partout en Flutter pour bâtir des listes de widgets, permettent d'insérer conditionnellement (`if`) ou de répéter (`for`) **à l'intérieur** d'un littéral de liste. C'est plus lisible que de construire la liste à part. Le *spread* `...` est celui de JS.

### Les Futures : l'async du palier 4, à l'identique

```dart
// une fonction asynchrone renvoie un Future (≈ une Promise JS)
Future<double> chargerTotal() async {
  await Future.delayed(Duration(seconds: 1));   // simule une attente (réseau...)
  return 45.5;
}

// on l'attend avec await, dans une fonction async
Future<void> afficher() async {
  try {
    final total = await chargerTotal();          // await, comme en JS
    print("Total : $total");
  } catch (e) {
    print("Erreur : $e");                        // try/catch, comme en JS
  }
}
```

Si tu connais `async`/`await` (palier 4), tu connais les Futures : c'est le **même** mécanisme. `Future<T>` est la `Promise<T>` de JS. `await` attend la valeur, `try/catch` gère l'erreur. La seule différence est le nom (`Future` au lieu de `Promise`). Tout appel réseau (leçon 08) ou disque (leçon 09) renvoie un Future.

### ⭐ Les Streams : plusieurs valeurs dans le temps (le point neuf)

```dart
// Un Future = UNE valeur future.    Un Stream = PLUSIEURS valeurs, au fil du temps.

// exemple : un compteur qui émet une valeur par seconde
Stream<int> compteur() async* {           // async* : une fonction qui PRODUIT un stream
  int n = 0;
  while (n < 5) {
    await Future.delayed(Duration(seconds: 1));
    yield n;                              // yield : ÉMET une valeur dans le stream
    n++;
  }
}

// on ÉCOUTE le stream : le code réagit à CHAQUE valeur émise
Future<void> ecouter() async {
  await for (final valeur in compteur()) {   // await for : boucle sur les valeurs qui arrivent
    print("Reçu : $valeur");                 // s'exécute 5 fois, une par seconde
  }
}
```

Voilà le concept neuf. Un **Future** livre **une** valeur, une fois. Un **Stream** livre **une suite** de valeurs, espacées dans le temps — et le code **réagit** à chacune. Pense à : la position GPS qui change, les messages d'un chat qui arrivent, les résultats d'une recherche qui s'affinent à chaque frappe, l'état d'une connexion. `async*` + `yield` produit un stream ; `await for` l'écoute.

En Flutter, c'est fondamental : l'interface peut **s'abonner** à un Stream et se reconstruire à chaque nouvelle valeur. C'est le mécanisme de réactivité que Riverpod (leçon 07) généralise. L'analogie la plus proche dans ton parcours : un Stream est comme une source d'événements qu'on écoute en continu (les événements du DOM, palier 2) — mais typée et intégrée à l'async.

### Future ou Stream ? La question à se poser

```
« Combien de valeurs vais-je recevoir ? »
   UNE seule, plus tard     → Future   (charger le profil, envoyer un formulaire)
   PLUSIEURS, dans le temps → Stream   (position GPS, messages, recherche en direct)
```

C'est la distinction à garder. La plupart des appels (charger, envoyer) sont des Futures (une réponse). Les Streams servent quand la donnée **continue d'évoluer**.

---

## Les problèmes que tu vas rencontrer

**`map`/`where` ne renvoient pas une liste.** Ils renvoient un `Iterable` paresseux. Ajoute `.toList()` pour obtenir une `List` (sinon Flutter, qui attend souvent une `List`, se plaint).

**Mon `await` ne compile pas.** `await` ne s'utilise que dans une fonction marquée `async`. Marque la fonction `async` (comme en JS).

**Mon appel réseau plante l'app au lieu d'afficher une erreur.** Un `Future` qui échoue sans `try/catch` propage l'exception. Entoure l'`await` d'un `try/catch` — crucial en mobile (connexion instable, leçon 09).

**Je confonds Future et Stream.** Un Future = une valeur unique ; un Stream = plusieurs dans le temps. Si tu n'attends qu'une réponse, c'est un Future ; si la donnée continue d'arriver, c'est un Stream.

**Mon Stream ne s'arrête jamais / fuit.** Un Stream qu'on écoute doit souvent être **fermé** (ou l'abonnement annulé) quand on n'en a plus besoin, sinon il continue de consommer des ressources. En Flutter, `StreamBuilder` et Riverpod (leçon 07) gèrent ça pour toi — raison de plus pour les utiliser.

**Je veux muter la liste d'origine.** Comme au palier 1, `map`/`where` ne mutent pas : ils produisent une nouvelle collection. Garde l'immuabilité ; c'est ce que Flutter attend.

---

## Ce qu'on te demandera

En **entretien Flutter/Dart**, la distinction est quasi certaine : **« différence entre un Future et un Stream ? »** — une valeur future unique vs plusieurs valeurs dans le temps. « Comment transformes-tu une liste ? » (`map`/`where`/`fold`). « Comment gères-tu une erreur asynchrone ? » (`try/catch` sur l'`await`).

On peut demander : « donne un exemple où tu utiliserais un Stream » (GPS, chat, recherche en direct), « que fait `.toList()` ? », « d'où viennent `map`/`where` pour toi ? » (le palier 1).

En **mission**, transformer des collections et gérer l'async proprement sont des gestes quotidiens ; consommer des Streams vient avec la gestion d'état (leçon 07).

---

## Ce qui te démarquera

**Le transfert immédiat des collections et de l'async.** Dire « `where`/`fold`, c'est `filter`/`reduce` du palier 1 ; `Future`, c'est `Promise` du palier 4 » montre que tu réutilises au lieu de repartir de zéro — et ça impressionne par la vitesse.

**La distinction Future/Stream claire.** La formuler nettement (une vs plusieurs valeurs dans le temps) et donner un bon exemple de Stream te distingue des débutants qui les confondent.

**Gérer les erreurs async en mobile.** Savoir qu'un appel réseau peut échouer (connexion mobile instable) et l'entourer de `try/catch` systématiquement montre que tu penses aux conditions réelles du mobile — ce qui mène droit aux états d'écran (leçon 08) et au hors-ligne (leçon 09).

**Et voir le Stream comme la base de la réactivité.** Comprendre qu'un Stream (plusieurs valeurs) est ce qui permet à l'interface de « réagir » aux changements prépare parfaitement la gestion d'état (leçon 07) — tu arriveras à Riverpod en terrain connu.

---

## 📚 À lire

**dart.dev → *Collections*** et ***Iterable* (la doc de `map`, `where`, `fold`, `toList`…)** : court quand on connaît déjà `map`/`filter`/`reduce`.

**dart.dev → *Asynchronous programming: futures, async, await*** : le rappel de l'async, identique à ce que tu connais, avec le vocabulaire Dart.

**dart.dev → *Asynchronous programming: streams*** : la référence sur les Streams — la lecture clé de la leçon, car c'est le point neuf.

Relis le palier 1, leçon 06 (`map`/`filter`/`reduce`) et le palier 4 (async/await) : les deux tiers de cette leçon y sont déjà, sous d'autres noms.

---

## 🤖 Le mini-projet à demander à l'IA

Transférer collections et async, puis apprivoiser les Streams :

> « Je suis en formation de développeur, palier 9 (Flutter). Je connais déjà map/filter/reduce (palier 1) et async/await avec les Promises (palier 4). En Dart, ce sont map/where/fold et les Futures. Sans tout me réexpliquer, fais-moi juste transposer : donne-moi des transformations de liste à écrire en Dart (filtrer des dépenses, en extraire les montants, calculer un total) et corrige mon usage de where/fold/toList. Puis fais-moi écrire une fonction async qui renvoie un Future et que j'attends avec await + try/catch. »

Puis les Streams, le point neuf :

> « Maintenant le concept qui est vraiment nouveau pour moi : les Streams. Explique-moi la différence entre un Future (une valeur future) et un Stream (plusieurs valeurs dans le temps) avec des exemples mobiles concrets (position GPS, messages d'un chat, recherche au fil de la frappe). Fais-moi écrire un petit Stream (un compteur qui émet une valeur par seconde) et l'écouter avec await for. Pose-moi la question "combien de valeurs vais-je recevoir ?" pour m'entraîner à choisir entre Future et Stream. »

---

## 🛠️ À faire

> Dans DartPad ou en local. Fais le parallèle avec le palier 1 (collections) et le palier 4 (async).

1. **⭐ Collections** : à partir d'une liste de dépenses, écris en Dart : filtrer par catégorie (`where`), extraire les descriptions (`map`), calculer le total (`fold`). Enchaîne `where` puis `fold`. N'oublie pas `.toList()`.
2. **Le transfert** : écris en commentaire, à côté de chaque opération, son équivalent du palier 1 (`where`=`filter`, `map`=`map`, `fold`=`reduce`).
3. **Spread et collection-if/for** : construis une liste en utilisant le *spread* (`...`), un `if` conditionnel et un `for` à l'intérieur du littéral. Observe comme c'est lisible (ça servira pour les widgets, leçon 04).
4. **⭐ Un Future** : écris une fonction `async` qui renvoie un `Future<double>` après un délai simulé, et attends-la avec `await`. Entoure l'`await` d'un `try/catch` et provoque une erreur pour voir la branche `catch`.
5. **L'async transféré** : note par écrit ce qui est **identique** entre un `Future` Dart et une `Promise` JS (réponse : tout, sauf le nom).
6. **⭐ Un Stream** : écris un Stream (un compteur qui émet un entier par seconde avec `async*`/`yield`) et écoute-le avec `await for`. Observe qu'il émet **plusieurs** valeurs, espacées dans le temps.
7. **Future ou Stream ?** : pour 5 situations (charger un profil, suivre la position GPS, envoyer un formulaire, recevoir des messages de chat, chercher au fil de la frappe), décide s'il faut un Future ou un Stream, en te posant « combien de valeurs ? ».
8. **Le lien** : dans ton journal, explique la différence Future/Stream en une phrase, et note que le Stream est le concept sur lequel reposera la réactivité (leçon 07).

<details>
<summary>Corrections et points de contrôle</summary>

**1-2.** Pur transfert du palier 1 : `where` = `filter`, `map` = `map`, `fold` = `reduce`. Deux points d'attention propres à Dart : `.toList()` matérialise l'itérable paresseux en liste (Flutter attend souvent une `List`), et `fold<double>(0, ...)` précise le type de l'accumulateur et sa valeur initiale. L'immuabilité (produire une nouvelle liste, ne pas muter) est identique à JS. Tu ne réapprends pas, tu renommes.

**4-5.** Un `Future<T>` est une `Promise<T>` : même mécanisme, même `async`/`await`, même `try/catch` pour les erreurs — seul le nom change. Le `try/catch` est vital en mobile : la connexion est instable, un appel réseau échoue souvent, et un Future non protégé fait planter l'app. Cette gestion d'erreur mène directement aux états d'écran (leçon 08) et au hors-ligne (leçon 09).

**6-7.** Le point neuf. Future = **une** valeur, une fois. Stream = **plusieurs** valeurs, dans le temps, auxquelles le code réagit. La question « combien de valeurs vais-je recevoir ? » tranche : charger un profil ou envoyer un formulaire = une réponse = Future ; suivre le GPS, recevoir des messages, chercher au fil de la frappe = un flux = Stream. En Flutter, l'interface peut s'abonner à un Stream et se reconstruire à chaque valeur — c'est le fondement de la réactivité que Riverpod (leçon 07) généralisera. L'analogie dans ton parcours : écouter un Stream ressemble à écouter des événements du DOM en continu (palier 2), mais typé et intégré à l'asynchrone.
</details>

---

## ✅ Acquis si…

- [ ] Je transforme des listes avec `map`, `where`, `fold`, en reconnaissant `filter`/`reduce` du palier 1.
- [ ] J'utilise `.toList()` pour matérialiser un itérable, et je garde l'immuabilité.
- [ ] J'utilise le *spread* et les *collection-if/for* dans un littéral de liste.
- [ ] J'écris et j'attends un `Future` avec `async`/`await`, et je gère ses erreurs avec `try/catch`.
- [ ] Je sais qu'un `Future` Dart est une `Promise` JS, à l'identique.
- [ ] J'écris et j'écoute un `Stream`, et je comprends « plusieurs valeurs dans le temps ».
- [ ] Je choisis entre Future et Stream selon le nombre de valeurs attendues.
- [ ] Je vois le Stream comme la base de la réactivité (préparation à la leçon 07).

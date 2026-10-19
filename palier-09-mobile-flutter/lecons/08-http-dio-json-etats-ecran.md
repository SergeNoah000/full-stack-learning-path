# Leçon 08 — HTTP avec dio, sérialisation JSON ↔ classes, états d'écran

> 🎯 **À la fin de cette leçon** : ton app parle à ton API (celle des paliers 4-6), convertit le JSON en objets Dart typés, et affiche **systématiquement** les quatre états d'écran : chargement, erreur, vide, données — l'un des deux points que le référent regarde.
> ⏱️ 5 h · **Prérequis** : leçons 01-02 (null safety, Future), 07 (Riverpod), et `fetch`/TanStack Query (paliers 2-3), l'API (paliers 4-6).

---

## De quoi on parle

Jusqu'ici, ton app vivait avec des données en dur. Maintenant, elle **parle au réseau** : elle appelle ton API (celle que tu as construite aux paliers 4, 5 ou 6), reçoit du JSON, et l'affiche. Trois sujets :

- **dio** : le client HTTP de Flutter (une alternative plus riche au paquet `http`) — c'est le `fetch`/`axios` du mobile ;
- la **sérialisation JSON ↔ classes** : convertir le JSON reçu en objets Dart typés (`Depense`), et inversement pour l'envoi — le `JSON.parse`/`stringify` du web, mais **typé** ;
- les **états d'écran** : une requête réseau a toujours quatre issues possibles à l'affichage — **chargement** (ça charge), **erreur** (ça a échoué), **vide** (ça a réussi mais il n'y a rien), **données** (ça a réussi avec du contenu). Il faut gérer les **quatre**, toujours.

Les états d'écran sont le premier des deux points que le référent regarde (avec le hors-ligne, leçon 09), parce que c'est là que les apps de débutants craquent : elles affichent un écran blanc pendant le chargement, plantent sur erreur, ou montrent une liste vide sans explication. Tu connais déjà ce sujet : ce sont les états de **TanStack Query** (palier 3, `isLoading`/`isError`/données) — ton avantage.

---

## À quoi ça sert, concrètement

**Parce qu'une app mobile sans réseau ne sert à rien (ou presque).** Les données réelles viennent d'un serveur : la liste des dépenses, le profil, le catalogue. Appeler l'API est ce qui relie ton app Flutter à tout le travail backend des paliers 4-6. C'est le point où le mobile rejoint le reste de ton parcours.

**Parce que la sérialisation typée évite une classe entière de bugs.** Recevoir du JSON brut (`Map<String, dynamic>`) et piocher dedans à la main (`data["montant"]`) est fragile : une faute de frappe, un champ manquant, et ça plante à l'exécution. Convertir le JSON en classe `Depense` typée (avec null safety, leçon 01) fait que le compilateur vérifie tes accès — les erreurs sont attrapées avant l'exécution.

**Parce que les états d'écran font la différence entre une app amateur et une app pro.** Le réseau est **lent** et **faillible**, surtout en mobile (connexion qui varie). Pendant qu'une requête charge, l'utilisateur doit voir un indicateur, pas un écran blanc. Si elle échoue, un message clair avec un bouton « réessayer », pas un plantage. Si c'est vide, une explication, pas une page morte. Gérer ces quatre états **systématiquement** est ce qui rend une app crédible — et c'est ce que le référent vérifiera en priorité.

**Et parce que c'est exactement ce que tu as appris avec TanStack Query (palier 3).** `isLoading`, `isError`, les données, le vide : tu as déjà géré ces états côté web. Le mobile a les mêmes, en plus critiques (connexion mobile). Tu transposes un savoir-faire, tu ne le découvres pas.

---

## Où ça intervient dans le développement

Cette leçon relie l'app au backend et structure l'affichage réseau :

```
   ÉCRAN
     │ affiche selon l'ÉTAT de la requête :
     ├─ chargement → indicateur (spinner)
     ├─ erreur     → message + bouton "réessayer"
     ├─ vide       → "aucune dépense pour l'instant"
     └─ données    → la liste (ListView, leçon 04)
          ▲ via un provider ASYNCHRONE (Riverpod, leçon 07)
   PROVIDER (FutureProvider) : appelle le dépôt
          ▼
   DÉPÔT (Repository) : dio → GET /depenses → JSON → List<Depense> (sérialisation)
          ▼
   TON API (paliers 4-6)
```

Trois ancrages.

**C'est ton API des paliers 4-6, consommée depuis le mobile.** Les endpoints REST que tu as construits (Node, Python, PHP) sont appelés ici. Le mobile est un **client** de plus de ton backend — après le navigateur (fetch, palier 2) et React (palier 3). Boucle bouclée : tu consommes ta propre API.

**La sérialisation, c'est le JSON du web, typé.** `JSON.parse` devient une conversion `Map → Depense` ; `JSON.stringify` devient `Depense → Map`. La null safety (leçon 01) rend ça sûr. Et le dépôt (Repository) qui encapsule dio est le **même pattern Repository** qu'aux paliers 4-6 (palier 7, leçon 04).

**Les états d'écran, c'est TanStack Query (palier 3), via Riverpod (leçon 07).** Un `FutureProvider` Riverpod expose directement les états chargement/erreur/données (`AsyncValue`), exactement comme `isLoading`/`isError` de TanStack Query. Tu branches la réactivité de la leçon 07 sur l'async de la leçon 02.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas configurer dio, écrire un dépôt qui appelle ton API et convertit le JSON en objets `Depense` typés, exposer ça via un `FutureProvider` Riverpod, et surtout construire un écran qui gère les **quatre** états (chargement/erreur/vide/données) avec un bouton « réessayer » sur l'erreur. Tu testeras en coupant la connexion pour voir l'état d'erreur.

### En équipe, en entreprise

**Les quatre états d'écran sont une exigence non négociable.** Toute vue qui charge des données doit les gérer. Une vue qui ne montre rien pendant le chargement, ou qui plante sur erreur, est refusée en revue. C'est le b.a.-ba de la qualité perçue d'une app.

**La sérialisation est souvent générée.** Pour éviter d'écrire à la main les conversions JSON ↔ classes (répétitif et source d'erreurs), on utilise des générateurs de code (`json_serializable`, `freezed`). On écrit la classe, l'outil génère le `fromJson`/`toJson`. On fait à la main une fois pour comprendre, puis on génère.

**dio apporte des fonctionnalités réelles.** Intercepteurs (ajouter le jeton d'authentification à chaque requête, leçon palier 4), timeouts, gestion centralisée des erreurs, logs : dio gère ça mieux que le paquet `http` de base. C'est pourquoi il est courant en entreprise.

**Les erreurs réseau sont catégorisées.** Pas de connexion, timeout, 401 (non authentifié), 404, 500 : chaque cas appelle un message différent. Une bonne app distingue « pas de réseau » (réessaie) de « tu n'es pas connecté » (reconnecte-toi) de « erreur serveur ». C'est le lien avec les codes HTTP (palier 4, leçon 06).

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : dio (`get`/`post`), la sérialisation `fromJson`/`toJson`, le `FutureProvider` Riverpod, et l'affichage des quatre états d'écran.

Régulièrement : les intercepteurs dio (jeton d'auth, logs), la gestion fine des erreurs par code HTTP, le *pull to refresh*, la pagination (palier 7, leçon 06), les générateurs de sérialisation.

Rare ou avancé : les requêtes annulables, le téléchargement/upload de fichiers avec progression, la configuration TLS avancée, le cache HTTP. À connaître de nom ; tu les creuseras au besoin.

---

## La mécanique

### Configurer dio

```dart
final dio = Dio(BaseOptions(
  baseUrl: "https://api.monsite.fr",           // l'URL de TON API (paliers 4-6)
  connectTimeout: const Duration(seconds: 5),   // ne pas attendre indéfiniment
  receiveTimeout: const Duration(seconds: 5),
));
```

dio est le client HTTP. On le configure une fois avec l'URL de base et des **timeouts** (crucial en mobile : une connexion lente ne doit pas faire attendre l'utilisateur à l'infini). C'est l'équivalent configuré de `fetch`/`axios` (palier 2).

### ⭐ La sérialisation JSON ↔ classe (typée)

```dart
class Depense {
  final String id;
  final String description;
  final double montant;
  final DateTime date;

  Depense({required this.id, required this.description,
           required this.montant, required this.date});

  // JSON → objet Dart (à la réception)
  factory Depense.fromJson(Map<String, dynamic> json) => Depense(
    id: json["id"] as String,
    description: json["description"] as String,
    montant: (json["montant"] as num).toDouble(),
    date: DateTime.parse(json["date"] as String),
  );

  // objet Dart → JSON (à l'envoi)
  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "montant": montant,
    "date": date.toIso8601String(),
  };
}
```

`fromJson` convertit le `Map` reçu (du JSON décodé) en objet `Depense` **typé** ; `toJson` fait l'inverse pour l'envoi. C'est `JSON.parse`/`stringify` du web (palier 2), mais **typé** : une fois converti, tu manipules `depense.montant` (vérifié par le compilateur, leçon 01) au lieu de `data["montant"]` (fragile). En entreprise, on **génère** ces méthodes (`json_serializable`) ; ici, on les écrit pour comprendre ce que le générateur fait.

### Le dépôt (Repository) avec dio

```dart
class DepenseRepository {
  final Dio dio;
  DepenseRepository(this.dio);

  Future<List<Depense>> lister() async {
    final reponse = await dio.get("/depenses");            // appel API (Future, leçon 02)
    final liste = reponse.data as List;
    return liste.map((j) => Depense.fromJson(j)).toList();  // JSON → objets (map, leçon 02)
  }

  Future<Depense> creer(Depense d) async {
    final reponse = await dio.post("/depenses", data: d.toJson());
    return Depense.fromJson(reponse.data);
  }
}
```

Le dépôt encapsule dio et la sérialisation : le reste de l'app appelle `lister()` et reçoit des `List<Depense>` typées, sans voir le HTTP ni le JSON. C'est **le même pattern Repository** qu'aux paliers 4-6 (palier 7, leçon 04), côté client cette fois. Note `map(...fromJson...)` : les collections de la leçon 02 à l'œuvre.

### ⭐ Exposer via un FutureProvider (Riverpod, leçon 07)

```dart
final depensesProvider = FutureProvider<List<Depense>>((ref) async {
  final repo = ref.read(repositoryProvider);
  return repo.lister();                        // renvoie un Future → Riverpod gère les états
});
```

Un `FutureProvider` expose une donnée **asynchrone**. Riverpod en tire automatiquement un `AsyncValue` avec trois états : en cours de chargement, en erreur, ou avec les données. C'est exactement ce que fait TanStack Query (palier 3) côté web — Riverpod (leçon 07) te le donne ici.

### ⭐⭐ Les quatre états d'écran (LE point à ne jamais rater)

```dart
class EcranListe extends ConsumerWidget {
  const EcranListe({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(depensesProvider);

    return Scaffold(
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),   // 1. CHARGEMENT
        error: (e, _) => Center(                                           // 2. ERREUR
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text("Impossible de charger les dépenses."),
            ElevatedButton(
              onPressed: () => ref.invalidate(depensesProvider),           // bouton RÉESSAYER
              child: const Text("Réessayer"),
            ),
          ]),
        ),
        data: (depenses) => depenses.isEmpty
          ? const Center(child: Text("Aucune dépense pour l'instant."))    // 3. VIDE
          : ListView.builder(                                             // 4. DONNÉES
              itemCount: depenses.length,
              itemBuilder: (_, i) => ListTile(title: Text(depenses[i].description)),
            ),
      ),
    );
  }
}
```

**C'est le cœur de la leçon.** `async.when(...)` force à traiter les trois branches de l'`AsyncValue` — `loading`, `error`, `data` — et dans `data`, on distingue encore **vide** et **données**. Les quatre états :

1. **chargement** : un indicateur (`CircularProgressIndicator`), pas un écran blanc ;
2. **erreur** : un message clair **et un bouton réessayer** (`ref.invalidate` relance la requête, leçon 07) — pas un plantage ;
3. **vide** : « aucune dépense pour l'instant », une explication — pas une page morte ;
4. **données** : la liste (`ListView.builder`, leçon 04).

Gérer les **quatre**, systématiquement, sur chaque écran qui charge des données, est la marque d'une app professionnelle. `async.when` t'y **oblige** par sa structure — c'est pourquoi Riverpod aide ici. C'est exactement `isLoading`/`isError`/`data` + le cas vide de TanStack Query (palier 3).

### Gérer les erreurs par catégorie

```
Une erreur réseau n'est pas l'autre (lien codes HTTP, palier 4) :
  - pas de connexion / timeout → "Vérifie ta connexion" + réessayer
  - 401 non authentifié        → "Reconnecte-toi"
  - 404                        → "Introuvable"
  - 500 erreur serveur         → "Un problème est survenu, réessaie plus tard"
dio expose le type d'erreur et le code HTTP : adapte le message.
```

Une bonne app ne dit pas « erreur » pour tout : elle distingue « pas de réseau » (l'utilisateur peut réessayer) de « tu n'es pas connecté » (il doit se reconnecter). C'est la sémantique HTTP (palier 4, leçon 06) au service de l'expérience utilisateur.

---

## Les problèmes que tu vas rencontrer

**Écran blanc pendant le chargement.** Tu n'as pas géré l'état `loading`. Affiche un indicateur. C'est le défaut d'app amateur numéro un, et le premier que le référent verra.

**L'app plante quand l'API ne répond pas.** Tu n'as pas géré l'état `error` (ou pas de `try/catch`, leçon 02). Affiche un message et un bouton réessayer — surtout en mobile, où le réseau tombe souvent.

**Liste vide sans explication (page morte).** Tu as géré `data` mais pas le cas `isEmpty`. Distingue « vide » (message explicatif) de « données » (la liste).

**`type 'Null' is not a subtype of type 'String'` à la désérialisation.** Un champ du JSON est absent ou `null`, mais ta classe le déclare non-nullable. Aligne la null safety (leçon 01) sur la réalité de l'API : si un champ peut manquer, déclare-le `String?` et gère-le.

**`data["montant"]` plante ou donne un mauvais type.** Tu manipules le JSON brut au lieu d'une classe typée. Convertis en `Depense` avec `fromJson` : le compilateur vérifiera ensuite tes accès.

**Ça marche sur l'émulateur mais `localhost` ne répond pas sur le téléphone.** Le téléphone n'a pas le même `localhost` que ta machine. Utilise l'IP de ta machine sur le réseau local (ou l'API déployée du palier 8). Teste sur ton vrai téléphone (conseil du palier).

**Toutes mes erreurs disent « erreur ».** Tu ne catégorises pas. Distingue au moins « pas de connexion » des erreurs serveur, en lisant le type/code de l'erreur dio (palier 4, codes HTTP).

---

## Ce qu'on te demandera

En **entretien/test Flutter**, les états d'écran sont LA question : **« quels états gères-tu quand tu charges des données ? »** — chargement, erreur (avec réessayer), vide, données, les quatre. « Comment convertis-tu le JSON en objets ? » (sérialisation typée `fromJson`). « Comment appelles-tu une API ? » (dio, dans un dépôt). On vérifie que tu ne laisses jamais un écran blanc ou un plantage.

On peut demander : « pourquoi typer le JSON plutôt que manipuler la Map brute ? », « comment distingues-tu une erreur réseau d'une erreur serveur ? » (codes HTTP), « d'où te viennent ces états ? » (TanStack Query, palier 3).

En **mission**, consommer une API avec un dépôt typé et gérer les quatre états sur chaque écran de données sont des exigences de base.

---

## Ce qui te démarquera

**Les quatre états, systématiquement.** Gérer chargement + erreur (avec réessayer) + vide + données sur **chaque** écran de données est exactement ce que le référent (et tout employeur) regarde en premier. C'est ce qui sépare une app qui « marche en démo » d'une app utilisable. Le faire par réflexe te distingue immédiatement.

**La sérialisation typée.** Convertir le JSON en classes `Depense` (plutôt que trimballer des `Map` brutes) montre que tu exploites la null safety (leçon 01) et que tu écris du code sûr. Savoir qu'on génère ça en entreprise (`json_serializable`) montre que tu connais la pratique réelle.

**Le dépôt côté client.** Encapsuler dio et la sérialisation dans un Repository (comme aux paliers 4-6) montre une architecture propre et le transfert d'un pattern connu (palier 7).

**Et le transfert de TanStack Query.** Dire « les états d'écran, c'est `isLoading`/`isError`/data de TanStack Query (palier 3), en mobile où le réseau est encore plus faillible » prouve que tu relies web et mobile — et que tu sais pourquoi ces états comptent encore plus ici.

---

## 📚 À lire

**pub.dev → *dio* (documentation)** : la configuration, les requêtes, les intercepteurs, la gestion d'erreurs.

**dart.dev → *JSON and serialization*** : la sérialisation à la main (`fromJson`/`toJson`) et les générateurs (`json_serializable`) — pour comprendre puis automatiser.

**riverpod.dev → *FutureProvider* et *AsyncValue* (`when`)** : comment exposer de l'async et gérer les trois états — la base des états d'écran.

Relis le palier 3 (TanStack Query : `isLoading`/`isError`/données) : les états d'écran en sont la transposition. Les paliers 4-6 (ton API, le pattern Repository), le palier 2 (`fetch`, JSON), et les leçons 01 (null safety), 02 (Future, `map`), 07 (Riverpod) se combinent tous ici.

---

## 🤖 Le mini-projet à demander à l'IA

Connecter l'app à ton API, avec sérialisation typée :

> « Je suis en formation de développeur, palier 9 (Flutter). J'ai une API REST (paliers 4-6) et je veux la consommer depuis mon app. Je connais fetch/JSON (palier 2) et le pattern Repository. Sans coder à ma place, guide-moi : configurer dio (URL de base, timeouts), écrire une classe Depense avec fromJson/toJson typés (en exploitant la null safety de la leçon 01), et un DepenseRepository qui appelle l'API et renvoie des List<Depense> typées. Explique-moi pourquoi typer le JSON vaut mieux que manipuler une Map brute, et dis-moi comment on génère ça (json_serializable) en vrai. »

Puis les quatre états d'écran (le point clé) :

> « Aide-moi maintenant sur LE point que mon référent regardera : les quatre états d'écran. Je connais isLoading/isError/data de TanStack Query (palier 3). Fais-moi exposer mes dépenses via un FutureProvider Riverpod et construire un écran qui gère async.when avec : chargement (indicateur), erreur (message + bouton réessayer), vide (message explicatif), données (la liste). Mets-moi au défi : coupe mentalement la connexion, vide la liste, fais échouer l'API — et vérifie que je n'affiche jamais un écran blanc ni un plantage. Aide-moi aussi à catégoriser les erreurs (pas de réseau vs 401 vs 500). »

---

## 🛠️ À faire

> Teste sur ton vrai téléphone, avec ton API (déployée au palier 8, ou l'IP locale de ta machine).

1. **dio** : configure dio avec l'URL de base de ton API (paliers 4-6) et des timeouts. Fais un premier `GET` et affiche la réponse brute.
2. **⭐ Sérialisation** : écris une classe `Depense` avec `fromJson` et `toJson` typés. Convertis la réponse JSON en `List<Depense>` avec `map` (leçon 02). Vérifie que tu manipules `depense.montant` (typé), plus `data["montant"]`.
3. **La null safety à la désérialisation** : rends un champ optionnel côté API, et aligne ta classe (`String?`) pour éviter le plantage « Null is not a subtype ». Note le lien avec la leçon 01.
4. **Le dépôt** : encapsule dio et la sérialisation dans un `DepenseRepository` (`lister`, `creer`). Vérifie que le reste de l'app ne voit ni HTTP ni JSON — même pattern qu'aux paliers 4-6.
5. **⭐ FutureProvider** : expose `lister()` via un `FutureProvider` Riverpod (leçon 07).
6. **⭐⭐ Les quatre états** : construis l'écran avec `async.when` : chargement (indicateur), erreur (message + **bouton réessayer** via `ref.invalidate`), vide (message), données (`ListView.builder`, leçon 04). Gère les **quatre**.
7. **Tester chaque état** : provoque chaque état — coupe la connexion (erreur), vide la base (vide), rallume (données), observe le chargement. Vérifie qu'aucun n'affiche un écran blanc ni ne plante.
8. **Catégoriser les erreurs** : distingue « pas de connexion » d'une erreur serveur (lis le type/code dio), et affiche un message adapté (lien codes HTTP, palier 4).
9. **Créer via l'API** : envoie une nouvelle dépense avec `toJson` + `dio.post`, et rafraîchis la liste (`ref.invalidate`).
10. **Le lien** : dans ton journal, relie les quatre états à `isLoading`/`isError`/data de TanStack Query (palier 3), et note pourquoi ils comptent encore plus en mobile (réseau faillible).

<details>
<summary>Corrections et points de contrôle</summary>

**2-3.** La sérialisation typée est la différence entre du code fragile et du code sûr. Manipuler la `Map` brute (`data["montant"]`) n'est pas vérifié : une faute de frappe ou un champ manquant plante à l'exécution. Convertir en `Depense` avec `fromJson` fait que, ensuite, `depense.montant` est vérifié par le compilateur (leçon 01). Et la null safety doit **coller à la réalité de l'API** : si un champ peut manquer, déclare-le `String?` et gère-le — sinon « Null is not a subtype » à la désérialisation. En entreprise on génère `fromJson`/`toJson` (`json_serializable`) ; les écrire à la main une fois fait comprendre ce que le générateur produit.

**4.** Le pattern Repository, côté client cette fois : le dépôt encapsule dio et la sérialisation, et expose des méthodes métier (`lister`, `creer`) renvoyant des objets typés. Le reste de l'app ne voit ni URL, ni HTTP, ni JSON — exactement comme ta couche d'accès aux données des paliers 4-6 (palier 7, leçon 04). Le jour où tu changes de client HTTP ou d'API, tu modifies le dépôt, pas les écrans.

**6-7.** LE cœur de la leçon, et le premier point que le référent regarde. Une requête réseau a quatre issues à l'affichage, et il faut les gérer **toutes** : **chargement** (indicateur, jamais d'écran blanc), **erreur** (message clair + bouton réessayer, jamais de plantage), **vide** (message explicatif, jamais de page morte), **données** (le contenu). `async.when` de Riverpod t'**oblige** à traiter loading/error/data par sa structure, et tu distingues vide/données dans la branche `data`. Tester chaque état en conditions réelles (couper la connexion, vider la base) est le seul moyen de s'assurer qu'aucun n'est oublié. C'est ce qui sépare une app pro d'une app de démo.

**10.** Les quatre états sont `isLoading`/`isError`/données + le cas vide de TanStack Query (palier 3), transposés. Ils comptent **encore plus** en mobile : la connexion y est intrinsèquement instable (réseau cellulaire, tunnels, métro), donc le chargement est plus visible et l'erreur plus fréquente qu'en web. C'est ce qui fait le pont vers le hors-ligne (leçon 09) : que se passe-t-il quand il n'y a **pas du tout** de réseau ? C'est le second point que le référent regarde.
</details>

---

## ✅ Acquis si…

- [ ] Je configure dio (URL de base, timeouts) et j'appelle mon API des paliers 4-6.
- [ ] Je convertis le JSON en objets Dart typés avec `fromJson`/`toJson` (et je sais qu'on génère ça).
- [ ] J'aligne la null safety de mes classes sur la réalité de l'API.
- [ ] J'encapsule dio et la sérialisation dans un dépôt (pattern Repository).
- [ ] J'expose les données via un `FutureProvider` Riverpod.
- [ ] Je gère les **quatre** états d'écran : chargement, erreur (avec réessayer), vide, données.
- [ ] Je teste chaque état en conditions réelles et je n'affiche jamais un écran blanc ni un plantage.
- [ ] Je catégorise les erreurs (réseau vs serveur) et je fais le lien avec TanStack Query (palier 3).

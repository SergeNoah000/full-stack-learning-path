# Leçon 07 — Gestion d'état : Riverpod

> 🎯 **À la fin de cette leçon** : tu partages un état entre tous les écrans de ton app avec Riverpod, après avoir ressenti pourquoi `setState` ne suffisait plus — exactement l'arc « natif d'abord » du parcours.
> ⏱️ 5 h · **Prérequis** : leçon 05 (et sa limite ressentie), et la gestion d'état de React (palier 3).

---

## De quoi on parle

À la leçon 05, tu as rencontré la limite de `setState` : il gère l'état **local** à un widget, mais dès que plusieurs écrans doivent partager le même état (l'utilisateur connecté, la liste de dépenses, le thème), le remonter et le faire redescendre partout devient pénible (*prop drilling*). La **gestion d'état** résout ça : un endroit où l'état **partagé** vit, que n'importe quel widget peut lire et modifier, et qui reconstruit automatiquement ceux qui l'écoutent.

**Riverpod** est la solution de gestion d'état la plus recommandée aujourd'hui en Flutter. Ses idées :

- un **provider** expose un état (ou une donnée dérivée) à toute l'application ;
- un widget **lit** ce provider ; quand l'état change, seuls les widgets qui l'écoutent se reconstruisent ;
- c'est **découplé** : le provider ne sait pas qui l'écoute, et l'état est accessible de n'importe où, sans le passer en paramètre à travers l'arbre.

C'est le pendant, en Flutter, d'un gestionnaire d'état comme Redux/Zustand ou du Context de React (palier 3) : un état global, réactif, découplé. Le parcours t'a fait **vivre la limite** de l'état local (leçon 05) avant de te donner l'outil — tu ne découvres pas Riverpod comme une magie, mais comme la réponse à un problème que tu as senti.

---

## À quoi ça sert, concrètement

**Parce que l'état partagé est partout dans une vraie app.** L'utilisateur connecté (connu de tous les écrans), le panier (modifié depuis le catalogue, lu depuis la page de paiement), le thème clair/sombre, les données chargées une fois et réutilisées : tout ça est de l'état **partagé**. `setState` ne peut pas le gérer proprement. Un gestionnaire d'état est indispensable dès qu'une app dépasse quelques écrans.

**Parce qu'il supprime le *prop drilling*.** Sans gestionnaire, pour qu'un écran profond accède à l'utilisateur connecté, il faut passer la donnée de parent en enfant à travers tous les widgets intermédiaires — même ceux qui ne s'en servent pas. Riverpod rend l'état accessible **directement** là où on en a besoin, sans ce tunnel de paramètres. C'est la douleur de la leçon 05, résolue.

**Parce que la reconstruction ciblée est performante.** Quand l'état change, seuls les widgets qui **écoutent** précisément cette partie se reconstruisent — pas tout l'écran (contrairement à un `setState` large, leçon 05). Riverpod reconstruit le strict nécessaire, ce qui garde l'app fluide.

**Et parce que c'est testable et découplé.** La logique d'état vit dans les providers, séparée de l'interface. On peut la tester sans widget, la remplacer, la composer. C'est la séparation des responsabilités (palier 7, SOLID) appliquée à l'état — et ce qui rend une app Flutter maintenable.

---

## Où ça intervient dans le développement

Riverpod est la couche d'état partagé, au-dessus des widgets :

```
   PROVIDERS (l'état partagé vit ici, hors de l'arbre de widgets)
     ├─ utilisateurProvider      (qui est connecté)
     ├─ depensesProvider         (la liste, chargée depuis l'API — leçon 08)
     └─ totalProvider            (DÉRIVÉ de depensesProvider : la somme)
          ▲ lisent / écoutent        │ quand l'état change, les écouteurs se reconstruisent
   WIDGETS (n'importe où dans l'arbre)
     ├─ ÉcranListe   → écoute depensesProvider
     ├─ ÉcranTotal   → écoute totalProvider
     └─ ÉcranProfil  → écoute utilisateurProvider
```

Trois ancrages.

**C'est la réponse à la limite de `setState` (leçon 05).** Là où `setState` confinait l'état à un widget, Riverpod le sort dans un provider accessible de partout. L'arc pédagogique est complet : limite ressentie (leçon 05) → outil qui la lève (ici).

**C'est le gestionnaire d'état global de React (palier 3), en Flutter.** Context, Redux, Zustand : un état global, réactif, découplé, avec reconstruction ciblée des abonnés. Riverpod est le même concept. Tu transposes un modèle connu.

**Il repose sur les Streams et les Futures (leçon 02).** Riverpod sait exposer un état **asynchrone** : un provider peut livrer un `Future` (données chargées, leçon 08) ou un `Stream` (données qui évoluent, leçon 02), avec les états chargement/erreur/données gérés — ce qui prépare directement la leçon 08.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas installer Riverpod, créer un provider pour un état partagé (la liste de dépenses), le lire depuis plusieurs écrans, le modifier depuis l'un et voir les autres se mettre à jour, créer un provider **dérivé** (le total), et comparer avec la douleur de la leçon 05 — pour mesurer ce que Riverpod t'apporte.

### En équipe, en entreprise

**Un gestionnaire d'état est un choix d'architecture du projet.** Riverpod, Bloc, Provider : le projet en a un, documenté, et tout le monde le suit. Riverpod est aujourd'hui le plus recommandé pour les nouveaux projets. Savoir s'y retrouver est attendu.

**On ne met pas tout dans le global.** L'état vraiment local (un champ, une animation, l'ouverture d'un menu) reste en `setState` (leçon 05) ; seul l'état **partagé** va dans les providers. Tout mettre en global est une erreur de conception (couplage, complexité). Le discernement local/global est une compétence.

**Les providers dérivés évitent la duplication.** Le total se **calcule** à partir de la liste (un provider dérivé) ; on ne le stocke pas séparément (sinon il faut penser à le recalculer à chaque changement — source de bugs). C'est le DRY (palier 7) appliqué à l'état : une seule source de vérité, le reste dérivé.

**Riverpod gère l'async proprement.** Les données chargées depuis une API (leçon 08) sont exposées par un provider asynchrone qui donne les états chargement/erreur/données — ce qui mène directement aux « états d'écran » que le référent regardera (leçon 08).

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : créer un provider, le lire dans un widget (`ref.watch`), le modifier, les providers dérivés.

Régulièrement : les providers asynchrones (`FutureProvider`, pour les données chargées, leçon 08), `ref.read` pour une action ponctuelle, invalider/rafraîchir un provider, la famille de providers (paramétrés).

Rare ou avancé : les providers avec cycle de vie fin, la composition complexe, le code généré (`riverpod_generator`), les tests de providers avancés. À connaître de nom ; tu les creuseras au besoin.

---

## La mécanique

### Le rappel de la limite (leçon 05)

```
setState : l'état vit DANS un widget. Pour le partager entre écrans → le remonter et le
           faire redescendre en paramètres partout (prop drilling). Pénible et fragile.
Riverpod : l'état vit dans un PROVIDER, hors de l'arbre. N'importe quel widget y accède
           DIRECTEMENT, sans tunnel de paramètres. Les écouteurs se reconstruisent seuls.
```

### Installer et envelopper l'app

```dart
// l'app est enveloppée d'un ProviderScope (une seule fois, à la racine)
void main() => runApp(const ProviderScope(child: MonApp()));
```

`ProviderScope` est le conteneur où vivent les providers. On enveloppe l'app une fois avec, à la racine — comme le `Provider` racine du Context de React (palier 3).

### ⭐ Créer un provider d'état

```dart
// un provider qui expose une liste de dépenses modifiable (Notifier)
class DepensesNotifier extends Notifier<List<Depense>> {
  @override
  List<Depense> build() => [];            // état initial

  void ajouter(Depense d) {
    state = [...state, d];                // ⭐ on REMPLACE l'état (immuable, comme React)
  }
  void supprimer(String id) {
    state = state.where((d) => d.id != id).toList();
  }
}

final depensesProvider = NotifierProvider<DepensesNotifier, List<Depense>>(
  DepensesNotifier.new,
);
```

Le provider expose un état (ici une `List<Depense>`) et des méthodes pour le modifier. Point clé : on **remplace** l'état (`state = [...state, d]`) au lieu de le muter — l'**immuabilité**, comme en React (palier 3) et comme `map`/`where` (leçon 02). C'est ce qui permet à Riverpod de détecter le changement et de reconstruire les écouteurs.

### ⭐ Lire et écouter un provider dans un widget

```dart
class EcranListe extends ConsumerWidget {       // ConsumerWidget : peut lire des providers
  const EcranListe({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depenses = ref.watch(depensesProvider);   // ⭐ ÉCOUTE : reconstruit si ça change

    return Scaffold(
      body: ListView.builder(                       // leçon 04
        itemCount: depenses.length,
        itemBuilder: (_, i) => ListTile(title: Text(depenses[i].description)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ref.read pour une ACTION ponctuelle (pas d'écoute)
          ref.read(depensesProvider.notifier).ajouter(nouvelle);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

Deux gestes essentiels. `ref.watch(provider)` **écoute** l'état : le widget se reconstruit automatiquement quand il change (c'est le `UI = f(état)` de la leçon 03, mais pour un état **partagé**). `ref.read(provider.notifier)` accède au provider pour une **action ponctuelle** (ajouter), sans écouter. Règle : `watch` pour afficher, `read` pour agir.

### ⭐ Un provider dérivé (le total, calculé)

```dart
// le total est CALCULÉ à partir de la liste, pas stocké séparément
final totalProvider = Provider<double>((ref) {
  final depenses = ref.watch(depensesProvider);        // écoute la liste
  return depenses.fold<double>(0, (s, d) => s + d.montant);   // fold, leçon 02
});
```

Un provider **dérivé** calcule une valeur à partir d'un autre. Le total n'est pas stocké (ce qui obligerait à le recalculer à chaque ajout, au risque d'oublier) : il est **dérivé** de la liste, et se recalcule tout seul quand la liste change. C'est le DRY (palier 7) et l'immuabilité réunis : une seule source de vérité (la liste), le reste dérivé. Un écran affichant le total écoute `totalProvider` et se met à jour automatiquement.

### La reconstruction ciblée

```
Quand depensesProvider change :
  - les widgets qui font ref.watch(depensesProvider) se reconstruisent,
  - ceux qui écoutent un AUTRE provider ne bougent pas.
Contrairement à un setState large (leçon 05) qui reconstruit tout un sous-arbre,
Riverpod ne reconstruit que les écouteurs concernés. → performant.
```

C'est l'avantage de performance majeur : la mise à jour est **chirurgicale**. Seuls les widgets qui écoutent précisément l'état modifié se reconstruisent. On peut avoir un état global sans sacrifier la fluidité.

### `watch` vs `read` (à ne pas confondre)

```
ref.watch(provider)  → dans build() : ÉCOUTE, reconstruit quand l'état change. (pour AFFICHER)
ref.read(provider)   → dans un callback (onPressed) : lit UNE fois, sans écouter. (pour AGIR)
```

Le piège classique : `watch` dans un `onPressed` (inutile et parfois buggé) ou `read` dans `build()` (l'écran ne se mettra pas à jour). Mémorise : **watch pour afficher, read pour agir**.

---

## Les problèmes que tu vas rencontrer

**« Je modifie l'état mais l'écran ne se met pas à jour. »** Soit tu as **muté** l'état au lieu de le remplacer (`state.add(x)` au lieu de `state = [...state, x]`) — Riverpod ne détecte pas la mutation ; soit tu utilises `ref.read` dans `build()` au lieu de `ref.watch`. Remplace l'état (immuable) et utilise `watch` pour afficher.

**« `ref` n'est pas disponible. »** Ton widget est un `StatelessWidget` ordinaire. Pour lire des providers, c'est un `ConsumerWidget` (avec `ref` dans `build`) ou un `Consumer`.

**Tout mon écran se reconstruit à chaque petit changement.** Tu écoutes (`watch`) un provider trop large, ou au mauvais niveau. Écoute au plus près de là où la donnée est affichée, et crée des providers dérivés ciblés.

**Je mets tout mon état dans Riverpod, même l'état local.** Sur-ingénierie. L'état vraiment local (un champ, une animation) reste en `setState` (leçon 05). Seul l'état **partagé** va dans les providers. Garde le discernement local/global.

**Je stocke une valeur dérivée (le total) séparément et je dois la recalculer à la main.** Mauvaise pratique. Fais-en un provider **dérivé** : une seule source de vérité, le reste calculé. Tu n'oublieras jamais de « mettre à jour le total ».

**Je confonds `watch` et `read`.** `watch` dans `build()` pour afficher (écoute) ; `read` dans un callback pour agir (une fois). Les inverser cause des écrans qui ne se mettent pas à jour ou des reconstructions inutiles.

---

## Ce qu'on te demandera

En **entretien Flutter**, la gestion d'état est un sujet majeur : « comment gères-tu l'état partagé entre écrans ? », **« quelle est la limite de `setState` et pourquoi un gestionnaire d'état ? »**, « différence entre `ref.watch` et `ref.read` ? », « pourquoi l'immuabilité dans les providers ? ». On apprécie que tu saches quand rester local (`setState`) et quand passer au global.

On peut demander : « qu'est-ce qu'un provider dérivé ? », « comment la reconstruction reste-t-elle performante ? » (ciblée sur les écouteurs), « fais le lien avec React » (gestionnaire d'état global).

En **mission**, créer et consommer des providers, choisir local/global, et exposer des données asynchrones (leçon 08) via Riverpod sont des gestes quotidiens.

---

## Ce qui te démarquera

**Avoir ressenti la limite avant l'outil.** Dire « j'ai vécu le *prop drilling* avec `setState` (leçon 05), donc je sais exactement quel problème Riverpod résout » montre une compréhension profonde, pas une adoption par mode. C'est l'arc « natif d'abord » du parcours, et il impressionne.

**Le discernement local/global.** Savoir que l'état local reste en `setState` et que seul le partagé va dans Riverpod — et le justifier — te distingue de celui qui met tout en global (sur-ingénierie) ou rien (prop drilling partout).

**Les providers dérivés.** Dériver le total de la liste plutôt que de le stocker (une seule source de vérité) montre que tu appliques le DRY et l'immuabilité à l'état — une maturité d'architecte (palier 7).

**Et le transfert depuis React.** Relier Riverpod au gestionnaire d'état global de React (Context/Redux/Zustand), avec l'immuabilité et la reconstruction ciblée, prouve que tu vois le concept commun derrière les plateformes — exactement ce que le parcours polyglotte construit.

---

## 📚 À lire

**riverpod.dev → *Getting started* et *Reading a provider* (watch/read)** : la référence officielle, claire, avec la distinction `watch`/`read` et les types de providers.

**riverpod.dev → *Combining providers*** : les providers dérivés (calculer une valeur à partir d'autres).

**flutter.dev → *List of state management approaches*** : le panorama officiel (Riverpod, Bloc, Provider…) pour situer Riverpod parmi les options.

Relis la leçon 05 (la limite de `setState`, que Riverpod lève), la leçon 02 (immuabilité, Future/Stream exposés par les providers), et le palier 3 (gestionnaire d'état global de React) : Riverpod en est la transposition.

---

## 🤖 Le mini-projet à demander à l'IA

Lever la limite de setState avec Riverpod :

> « Je suis en formation de développeur, palier 9 (Flutter). À la leçon 05, j'ai VÉCU la limite de setState : partager un état entre deux écrans oblige au prop drilling. Je connais aussi les gestionnaires d'état global de React (palier 3). Aide-moi à résoudre ce problème avec Riverpod, sans coder à ma place : créer un provider pour ma liste de dépenses partagée, le lire depuis plusieurs écrans avec ref.watch, et le modifier depuis l'un pour voir les autres se mettre à jour. Insiste sur l'immuabilité (remplacer l'état, pas le muter) et la distinction ref.watch (afficher) / ref.read (agir). »

Puis les providers dérivés et le discernement :

> « Aide-moi à créer un provider DÉRIVÉ : le total des dépenses, calculé à partir de la liste (pas stocké séparément), qui se recalcule tout seul quand la liste change. Explique-moi pourquoi c'est mieux que stocker le total (une seule source de vérité, DRY). Ensuite, mets-moi au défi sur le discernement : donne-moi plusieurs états (un champ de texte, l'utilisateur connecté, l'ouverture d'un menu, la liste de dépenses) et fais-moi décider, pour chacun, s'il doit rester en setState (local) ou passer dans un provider (partagé). »

---

## 🛠️ À faire

> Sur ton vrai téléphone. Pars de la douleur ressentie à la leçon 05.

1. **Le rappel de la limite** : reprends le cas de la leçon 05 où tu peinais à partager un état entre deux écrans. Note précisément la douleur (prop drilling).
2. **Installer** : ajoute Riverpod et enveloppe ton app d'un `ProviderScope`.
3. **⭐ Un provider d'état** : crée un provider pour ta liste de dépenses partagée, avec des méthodes `ajouter`/`supprimer`. **Remplace** l'état (immuable), ne le mute pas.
4. **⭐ Lire depuis plusieurs écrans** : affiche la liste dans un écran avec `ref.watch`, et un compte/total dans un autre écran. Vérifie que les deux voient le même état.
5. **Modifier et voir la propagation** : ajoute une dépense depuis un écran (`ref.read(...).ajouter(...)`), et vérifie que l'autre écran se met à jour **automatiquement**. Compare avec la douleur de la leçon 05.
6. **⭐ Un provider dérivé** : crée `totalProvider` qui calcule la somme à partir de la liste (`fold`, leçon 02). Vérifie qu'il se recalcule tout seul à chaque ajout, sans que tu aies à le mettre à jour.
7. **watch vs read** : utilise `watch` dans `build()` (affichage) et `read` dans un `onPressed` (action). Inverse-les volontairement et observe les problèmes (écran figé / reconstruction inutile).
8. **Le discernement** : pour 4 états (champ de texte, utilisateur connecté, menu ouvert, liste partagée), décide local (`setState`) ou global (provider), et justifie.
9. **Le lien** : dans ton journal, explique comment Riverpod lève la limite de `setState` (leçon 05), et fais le parallèle avec le gestionnaire d'état global de React (palier 3).

<details>
<summary>Corrections et points de contrôle</summary>

**1 + 5.** L'arc pédagogique complet, et le cœur du « natif d'abord ». À la leçon 05, partager un état entre écrans imposait de le remonter et de le faire redescendre en paramètres (prop drilling) — pénible et fragile. Riverpod le résout : l'état vit dans un provider accessible de partout, et modifier l'état depuis un écran met à jour **automatiquement** tous les écrans qui l'écoutent. En comparant directement avec la douleur de la leçon 05, tu mesures ce que l'outil apporte — et tu l'adoptes pour une raison comprise, pas par mode.

**3 + 5.** L'immuabilité est la clé du fonctionnement. On **remplace** l'état (`state = [...state, d]`), on ne le mute pas (`state.add(d)`). Riverpod détecte un changement en comparant l'ancienne et la nouvelle référence ; une mutation sur place ne change pas la référence, donc Riverpod ne reconstruit pas les écouteurs (écran figé). C'est la même immuabilité qu'en React (palier 3) et que `map`/`where` (leçon 02).

**6.** Le provider dérivé applique le DRY (palier 7) à l'état : le total est **calculé** à partir de la liste (une seule source de vérité), jamais stocké séparément. S'il était stocké, il faudrait penser à le recalculer à chaque ajout/suppression — un oubli garanti tôt ou tard, et le total afficherait une valeur fausse. Dérivé, il se recalcule automatiquement quand la liste change. Une source de vérité, le reste dérivé.

**7.** `ref.watch` **écoute** (reconstruit quand l'état change) → à utiliser dans `build()` pour **afficher**. `ref.read` **lit une fois** sans écouter → à utiliser dans un callback (`onPressed`) pour **agir**. Les inverser casse : `read` dans `build()` → l'écran ne se met pas à jour (pas d'écoute) ; `watch` dans un callback → écoute inutile, parfois buggée. Mnémotechnique : **watch pour afficher, read pour agir**.

**8-9.** Le discernement local/global est une compétence d'architecte. Champ de texte, menu ouvert, animation → **local** (`setState`, leçon 05) : confinés à un widget, pas besoin de les partager. Utilisateur connecté, liste de dépenses partagée, thème → **global** (provider) : lus et modifiés depuis plusieurs écrans. Tout mettre en global est de la sur-ingénierie (couplage, complexité, palier 7) ; tout garder local ramène le prop drilling. Riverpod est le gestionnaire d'état global de React (Context/Redux/Zustand, palier 3) transposé : état partagé, réactif, découplé, immuable, avec reconstruction ciblée des abonnés.
</details>

---

## ✅ Acquis si…

- [ ] J'explique la limite de `setState` et pourquoi un gestionnaire d'état la lève.
- [ ] J'enveloppe mon app d'un `ProviderScope` et je crée un provider d'état partagé.
- [ ] Je modifie l'état en le **remplaçant** (immuable), jamais en le mutant.
- [ ] Je lis un état avec `ref.watch` (afficher) et j'agis avec `ref.read` (action).
- [ ] Je vois plusieurs écrans se mettre à jour automatiquement quand l'état partagé change.
- [ ] Je crée un provider **dérivé** (le total) plutôt que de stocker une valeur recalculable.
- [ ] Je distingue l'état local (`setState`) de l'état partagé (provider) et je choisis le bon.
- [ ] Je fais le lien entre Riverpod et le gestionnaire d'état global de React.

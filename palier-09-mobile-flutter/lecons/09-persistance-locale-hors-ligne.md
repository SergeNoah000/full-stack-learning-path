# Leçon 09 — Persistance locale et mode hors-ligne

> 🎯 **À la fin de cette leçon** : ton app garde des données sur le téléphone, fonctionne **sans connexion**, et se resynchronise au retour du réseau — le second des deux points que le référent regarde, et ce qui distingue vraiment une app mobile d'un site web.
> ⏱️ 6 h · **Prérequis** : toutes les leçons du palier, surtout 08 (HTTP, états d'écran).

---

## De quoi on parle

Une app mobile vit dans la poche : métro, ascenseur, campagne, avion. La connexion **disparaît** régulièrement. Un site web suppose le réseau ; une bonne app mobile fonctionne **quand même**. C'est la différence fondamentale, et le second point que le référent vérifie (avec les états d'écran, leçon 08).

Deux outils de persistance locale :

- **`shared_preferences`** : un petit stockage clé-valeur, pour des réglages simples (thème choisi, utilisateur connecté, préférence) — l'équivalent du `localStorage` du web (palier 2) ;
- **`drift`** : une vraie base de données locale (SQLite) sur le téléphone, pour stocker des données structurées (la liste des dépenses) — le SQL que tu connais (paliers 4-6), embarqué dans l'app.

Et le **mode hors-ligne** : la stratégie qui combine réseau et stockage local pour que l'app reste utilisable sans connexion. Le motif de référence est **cache-first** (ou *offline-first*) : afficher d'abord les données locales (instantané, même hors-ligne), puis se synchroniser avec le serveur quand le réseau est là.

---

## À quoi ça sert, concrètement

**Parce que la connexion n'est jamais garantie en mobile.** Contrairement à un serveur (toujours connecté) ou un ordinateur de bureau (souvent câblé), un téléphone perd le réseau constamment. Une app qui affiche « pas de connexion » et ne fait rien d'autre est inutilisable dans la moitié des situations réelles. Le hors-ligne n'est pas un bonus : c'est une exigence de base du mobile.

**Parce que le local rend l'app instantanée.** Lire les données depuis le téléphone est immédiat ; attendre le réseau est lent. Afficher d'abord les données locales (cache-first), puis rafraîchir en arrière-plan, donne une app qui répond **tout de suite** — même avec une bonne connexion. C'est un gain de réactivité, pas seulement de robustesse.

**Parce que c'est ce qui distingue une vraie app d'un site web emballé.** Beaucoup d'« apps » ne sont qu'un site web dans une coque : elles ne marchent pas hors-ligne, ne gardent rien localement. Une app qui persiste ses données et fonctionne sans réseau est perçue comme « native », fiable, professionnelle. C'est exactement ce que le référent regarde — et ce que les débutants ratent.

**Et parce que tu connais déjà toutes les briques.** `shared_preferences`, c'est le `localStorage` (palier 2). `drift`, c'est le SQL (paliers 4-6) embarqué. Le cache et l'invalidation, c'est le palier 7 (leçon 06). La synchro, c'est de l'async (leçon 02). Tu assembles du connu pour résoudre un problème propre au mobile.

---

## Où ça intervient dans le développement

La persistance locale s'intercale entre l'app et le réseau, et devient la source principale :

```
   ÉCRAN
     ▲ lit D'ABORD le local (instantané, marche hors-ligne)
   STOCKAGE LOCAL
     ├─ shared_preferences : réglages (thème, utilisateur) — clé/valeur
     └─ drift (SQLite) : données structurées (les dépenses)
     ▲ │ synchronisation quand le réseau est là
     │ ▼
   RÉSEAU (dio, leçon 08) ──▶ TON API (paliers 4-6)
     │ hors-ligne : les modifications sont mises en FILE, envoyées au retour du réseau
```

Trois ancrages.

**`shared_preferences`, c'est le `localStorage` du web (palier 2).** Stocker une préférence (thème, dernier utilisateur) en clé-valeur : même concept, même usage (petites données simples, pas de grosses listes). Tu transposes directement.

**`drift`, c'est le SQL des paliers 4-6, embarqué.** `drift` est SQLite sur le téléphone, avec le SQL (`SELECT`, `WHERE`, `INSERT`) que tu connais (palier 4, leçon 05), et un pattern Repository (palier 7, leçon 04). Tu ne réapprends pas les bases de données ; tu les mets dans ton app.

**Le cache-first, c'est le caching du palier 7 (leçon 06), appliqué au mobile.** Lire le local d'abord, rafraîchir depuis le serveur ensuite, invalider/mettre à jour le cache : c'est la logique de cache de la leçon 06 du palier 7, avec le local comme cache. Et ça se branche sur les états d'écran (leçon 08) et Riverpod (leçon 07).

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas stocker un réglage avec `shared_preferences`, créer une base locale `drift` pour tes dépenses, mettre en place le motif cache-first (afficher le local, puis synchroniser), tester ton app **en mode avion** pour vérifier qu'elle marche hors-ligne, et gérer les modifications faites hors-ligne (mises en file, envoyées au retour du réseau).

### En équipe, en entreprise

**Le offline-first est une architecture, pas une rustine.** Les apps sérieuses sont conçues dès le départ pour que le local soit la **source d'affichage**, et le réseau un moyen de synchroniser. On ne « rajoute pas le hors-ligne à la fin » — c'est une décision de conception initiale.

**La synchronisation est le vrai défi.** Afficher le local est facile ; **réconcilier** local et serveur est difficile : que faire si la donnée a changé des deux côtés (conflit) ? Les stratégies (dernière écriture gagne, horodatage, numéro de version) rappellent les compromis de cohérence distribuée (palier 7, leçon 05). Au début, on vise simple (le serveur fait foi, ou le local en attente d'envoi).

**L'indicateur d'état réseau rassure l'utilisateur.** Une bonne app montre discrètement « hors-ligne » (et « synchronisation… » au retour), pour que l'utilisateur sache que ses données locales seront envoyées. Le silence inquiète ; l'indication rassure.

**drift génère du code typé.** Comme la sérialisation (leçon 08), `drift` génère des classes et des requêtes typées à partir de ta définition de tables — tu écris le schéma, l'outil génère le code d'accès sûr. Même esprit « écris la structure, génère le reste ».

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : `shared_preferences` pour les réglages, lire/écrire la base locale `drift`, afficher le local (cache-first).

Régulièrement : détecter l'état de la connexion (`connectivity_plus`), synchroniser au retour du réseau, mettre en file les modifications hors-ligne, l'indicateur hors-ligne.

Rare ou avancé : la résolution de conflits complexe, la synchronisation bidirectionnelle temps réel, le chiffrement du stockage local, les migrations de schéma `drift`. À connaître de nom ; tu les creuseras au besoin.

---

## La mécanique

### `shared_preferences` : les réglages (le localStorage du web)

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString("theme", "sombre");         // écrire
await prefs.setBool("premier_lancement", false);
final theme = prefs.getString("theme") ?? "clair"; // lire, avec repli (null safety, leçon 01)
```

`shared_preferences` stocke de petites valeurs clé-valeur de façon persistante (elles survivent à la fermeture de l'app). Usage : le thème choisi, si l'utilisateur a vu l'écran d'accueil, le dernier onglet. C'est le `localStorage` du web (palier 2), avec une API asynchrone. **Pas** pour de grosses données structurées (pour ça, `drift`).

### ⭐ `drift` : une base SQLite locale (le SQL des paliers 4-6)

```dart
// on définit une table (drift génère le code d'accès typé)
class Depenses extends Table {
  TextColumn get id => text()();
  TextColumn get description => text()();
  RealColumn get montant => real()();
  DateTimeColumn get date => dateTime()();
}

// usage (via le dépôt local généré) : du SQL que tu connais (palier 4)
Future<List<Depense>> toutes() => select(depenses).get();          // SELECT *
Future<void> ajouter(Depense d) => into(depenses).insert(d);        // INSERT
Future<void> vider() => delete(depenses).go();                      // DELETE
```

`drift` est SQLite **dans** ton app : une vraie base de données locale, avec le SQL que tu maîtrises (paliers 4-6). On définit les tables, `drift` génère les classes et requêtes typées (comme la sérialisation génère `fromJson`, leçon 08). Les données survivent à la fermeture de l'app et sont disponibles **hors-ligne**. C'est là qu'on stocke les données structurées (la liste des dépenses), pas dans `shared_preferences`.

### ⭐⭐ Le motif cache-first (offline-first)

```
À l'ouverture de l'écran des dépenses :
  1. LIRE LE LOCAL (drift) et l'afficher IMMÉDIATEMENT → instantané, marche hors-ligne.
  2. SI le réseau est là : appeler l'API (dio, leçon 08) en arrière-plan,
     mettre à jour le local (drift), et rafraîchir l'affichage.
  3. SI pas de réseau : rester sur le local, afficher un discret "hors-ligne".
→ L'app est TOUJOURS utilisable ; le réseau améliore, il n'est pas requis.
```

C'est le motif central du hors-ligne, et l'application directe du cache-first du palier 7 (leçon 06), avec le local comme cache. L'écran n'attend **jamais** le réseau pour afficher quelque chose : il montre le local tout de suite, puis se met à jour si le réseau répond. L'utilisateur voit ses dépenses même en mode avion. Le réseau devient un moyen de **synchroniser**, pas une condition d'affichage.

### Détecter l'état du réseau

```dart
// connectivity_plus : savoir si on est en ligne, et réagir aux changements (un Stream, leçon 02)
final resultat = await Connectivity().checkConnectivity();
final enLigne = !resultat.contains(ConnectivityResult.none);
// on peut aussi ÉCOUTER les changements (Stream) pour synchroniser au retour du réseau
```

Savoir si on est en ligne permet d'adapter le comportement (afficher « hors-ligne », déclencher une synchro au retour). Noter que les changements de connectivité sont un **Stream** (leçon 02) : plusieurs valeurs dans le temps (en ligne → hors-ligne → en ligne), auxquelles l'app réagit — un cas d'usage parfait du concept de la leçon 02.

### ⭐ Les modifications faites hors-ligne

```
L'utilisateur ajoute une dépense SANS réseau. Que faire ?
  1. L'enregistrer DANS LE LOCAL tout de suite (elle apparaît à l'écran) + la marquer "à envoyer".
  2. Quand le réseau revient : envoyer les modifications "à envoyer" à l'API (dio),
     puis les marquer "synchronisées".
→ L'utilisateur n'est jamais bloqué ; ses actions sont mises en FILE et envoyées plus tard.
```

Le hors-ligne n'est pas que de la lecture : l'utilisateur doit pouvoir **agir** sans réseau. On enregistre sa modification localement (elle est visible immédiatement), marquée « en attente d'envoi », et une **file** l'envoie au serveur dès que la connexion revient. C'est l'idée de la file de messages (palier 7, leçon 05), à l'échelle de l'app : découpler l'action de son envoi. Attention à l'**idempotence** (palier 7, leçon 06) : si l'envoi est rejoué, il ne faut pas créer deux fois la dépense.

### L'indicateur hors-ligne

```
Afficher discrètement l'état :
  - "hors-ligne" quand il n'y a pas de réseau (l'utilisateur sait que ses actions attendent),
  - "synchronisation…" au retour (ses données partent),
  - rien quand tout est à jour.
→ Rassure l'utilisateur : il comprend que ses données ne sont pas perdues.
```

Un petit bandeau ou une icône évite l'inquiétude : l'utilisateur sait que l'app fonctionne hors-ligne **exprès**, et que ses modifications seront envoyées. C'est une question d'expérience utilisateur qui fait paraître l'app fiable.

---

## Les problèmes que tu vas rencontrer

**Mon app affiche « pas de connexion » et ne fait rien d'autre.** C'est le défaut que cette leçon existe pour corriger. Affiche le **local** (drift) : l'app doit rester utilisable hors-ligne. Le réseau améliore, il n'est pas requis.

**Les données disparaissent quand je ferme l'app.** Tu les gardais seulement en mémoire (ou en état Riverpod non persisté). Stocke-les dans `drift` (ou `shared_preferences` pour les réglages) pour qu'elles survivent.

**Je mets de grosses listes dans `shared_preferences`.** Mauvais outil : `shared_preferences` est pour de petites valeurs clé-valeur (réglages). Les données structurées (listes, relations) vont dans `drift` (SQLite).

**Une dépense ajoutée hors-ligne est perdue.** Tu ne l'as pas enregistrée localement avant d'essayer de l'envoyer. Enregistre d'abord dans le local (marquée « à envoyer »), envoie ensuite quand le réseau revient.

**Une dépense ajoutée hors-ligne est envoyée en double au retour.** Problème d'idempotence (palier 7, leçon 06) : l'envoi a été rejoué. Marque chaque modification en attente avec un identifiant, et assure-toi que l'API ne la crée qu'une fois.

**Conflit : la donnée a changé localement ET sur le serveur.** Le vrai défi de la synchro. Au début, choisis une règle simple (le serveur fait foi, ou le local en attente l'emporte jusqu'à envoi), et sache que c'est le compromis de cohérence du palier 7 (leçon 05). Ne te lance pas dans une résolution complexe trop tôt.

**Je teste sur l'émulateur avec le wifi et je crois que ça marche.** Le seul vrai test du hors-ligne est le **mode avion sur un vrai téléphone**. Coupe tout le réseau et vérifie que l'app reste utilisable. C'est le conseil du palier.

---

## Ce qu'on te demandera

En **entretien/test Flutter**, le hors-ligne est un marqueur de sérieux : **« comment ton app fonctionne-t-elle sans connexion ? »**, « où stockes-tu les données localement ? » (`shared_preferences` pour les réglages, `drift`/SQLite pour les données), « qu'est-ce que le cache-first / offline-first ? », « que fais-tu d'une modification faite hors-ligne ? » (local + file d'envoi).

On peut demander : « différence entre `shared_preferences` et une base locale ? », « comment gères-tu un conflit de synchronisation ? » (règle simple d'abord), « comment détectes-tu le retour du réseau ? » (connectivité, un Stream).

En **mission**, concevoir une app qui reste utilisable hors-ligne, choisir le bon stockage, et synchroniser proprement sont des compétences très recherchées — et rares chez les débutants.

---

## Ce qui te démarquera

**Le offline-first par conception.** Penser « le local est la source d'affichage, le réseau synchronise » dès le départ — pas « j'ajoute le hors-ligne à la fin » — montre une maturité d'architecture mobile que peu de débutants ont. C'est exactement ce que le référent regarde.

**Tester en mode avion.** Vérifier le hors-ligne sur un vrai téléphone en mode avion, et pas seulement sur l'émulateur, prouve que tu testes les conditions réelles du mobile. C'est le conseil du palier appliqué.

**Gérer les modifications hors-ligne proprement.** Enregistrer localement + file d'envoi + idempotence (palier 7, leçon 06) au retour montre que tu relies persistance, async et robustesse — une vraie compréhension, pas une recette.

**Et assembler tout ton parcours.** Dire « `shared_preferences`, c'est le `localStorage` (palier 2) ; `drift`, c'est le SQL (paliers 4-6) embarqué ; le cache-first, c'est le caching (palier 7) ; la file d'envoi, c'est la file de messages (palier 7) ; la synchro, c'est l'async (leçon 02) » prouve que le hors-ligne n'est pas un sujet isolé mais l'assemblage de tout ce que tu sais — la synthèse qui conclut le palier mobile.

---

## 📚 À lire

**pub.dev → *shared_preferences*** : le stockage clé-valeur simple, pour les réglages.

**drift.simonbinder.eu (documentation drift)** : la base SQLite locale typée — définition des tables, requêtes, code généré.

**pub.dev → *connectivity_plus*** : détecter l'état du réseau et réagir à ses changements (un Stream, leçon 02).

**flutter.dev / articles sur *offline-first*** : les stratégies cache-first, la synchronisation, la gestion des conflits.

Relis le palier 2 (`localStorage` ≈ `shared_preferences`), les paliers 4-6 (SQL ≈ `drift`), le palier 7 leçon 06 (caching/idempotence) et leçon 05 (file de messages), et la leçon 02 (async, Stream) : le hors-ligne les assemble tous.

---

## 🤖 Le mini-projet à demander à l'IA

Rendre ton app utilisable hors-ligne :

> « Je suis en formation de développeur, palier 9 (Flutter). Mon app consomme une API (leçon 08), mais elle ne marche pas sans connexion. Je veux la rendre offline-first. Je connais localStorage (palier 2), le SQL (paliers 4-6), le caching et l'idempotence (palier 7). Sans coder à ma place, guide-moi : stocker un réglage avec shared_preferences (le localStorage du mobile), créer une base locale drift (SQLite) pour mes dépenses, et mettre en place le motif cache-first : afficher le local D'ABORD, puis synchroniser avec l'API quand le réseau est là. Explique-moi pourquoi le local doit être la source d'affichage, pas le réseau. »

Puis les modifications hors-ligne et le test :

> « Aide-moi sur le point difficile : les modifications faites SANS réseau. Fais-moi concevoir le flux : enregistrer la dépense dans le local tout de suite (marquée "à envoyer"), détecter le retour du réseau (connectivity, un Stream de la leçon 02), puis envoyer les modifications en attente à l'API — en pensant à l'idempotence (palier 7) pour ne pas créer de doublon. Explique-moi la gestion simple des conflits (le serveur fait foi, pour commencer). Enfin, rappelle-moi de tester en MODE AVION sur un vrai téléphone, car c'est le seul vrai test du hors-ligne. »

---

## 🛠️ À faire

> Teste en **mode avion** sur ton **vrai téléphone** — c'est le seul vrai test du hors-ligne.

1. **shared_preferences** : stocke un réglage (le thème, ou « premier lancement vu ») et relis-le au démarrage. Vérifie qu'il survit à la fermeture de l'app. Note le parallèle avec `localStorage` (palier 2).
2. **⭐ drift** : crée une base locale `drift` avec une table `depenses`. Insère, lis et supprime des dépenses en SQL. Vérifie que les données survivent à la fermeture. Note le lien avec le SQL des paliers 4-6.
3. **Le bon outil** : écris, dans ton journal, ce qui va dans `shared_preferences` (réglages) et ce qui va dans `drift` (données structurées), et pourquoi.
4. **⭐⭐ Cache-first** : à l'ouverture de l'écran, affiche **d'abord** les dépenses locales (drift), puis, si le réseau est là, appelle l'API (dio, leçon 08) et mets à jour le local. Vérifie que l'écran affiche quelque chose **immédiatement**.
5. **⭐ Mode avion** : passe ton téléphone en mode avion et vérifie que l'app **marche** : elle affiche les dépenses locales, sans écran blanc ni plantage.
6. **Détecter le réseau** : utilise `connectivity_plus` pour savoir si tu es en ligne, et affiche un discret indicateur « hors-ligne ». Note que les changements de connectivité sont un Stream (leçon 02).
7. **⭐ Modifier hors-ligne** : en mode avion, ajoute une dépense. Enregistre-la dans le local (marquée « à envoyer ») et vérifie qu'elle apparaît tout de suite à l'écran.
8. **Synchroniser au retour** : coupe le mode avion et envoie les modifications en attente à l'API. Vérifie qu'elles ne sont **pas** créées en double (idempotence, palier 7, leçon 06).
9. **Conflit simple** : réfléchis à ce qui se passe si une dépense a changé localement et sur le serveur, et choisis une règle simple (le serveur fait foi). Note le lien avec la cohérence (palier 7, leçon 05).
10. **Le lien** : dans ton journal, montre comment le hors-ligne assemble tout ton parcours — `localStorage` (palier 2), SQL (paliers 4-6), caching et file et idempotence (palier 7), async et Stream (leçon 02).

<details>
<summary>Corrections et points de contrôle</summary>

**1-3.** Le bon outil pour le bon besoin : `shared_preferences` (le `localStorage` du web, palier 2) pour de **petites** valeurs clé-valeur (réglages : thème, dernier onglet, utilisateur) ; `drift` (SQLite, le SQL des paliers 4-6 embarqué) pour les **données structurées** (listes, relations : les dépenses). Mettre une grosse liste dans `shared_preferences` est un contre-emploi. Dans les deux cas, les données **survivent à la fermeture** de l'app et sont disponibles hors-ligne — c'est tout l'intérêt.

**4-5.** Le cœur du hors-ligne, et le second point que le référent regarde. Le motif cache-first : l'écran lit et affiche le **local d'abord** (instantané, disponible sans réseau), puis synchronise avec le serveur **si** le réseau est là. Conséquence : l'app affiche **toujours** quelque chose, même en mode avion — le réseau améliore, il n'est jamais une condition d'affichage. C'est le cache-first du palier 7 (leçon 06) avec le local comme cache. Le seul vrai test : le **mode avion sur un vrai téléphone**, pas l'émulateur avec le wifi.

**7-8.** Le hors-ligne n'est pas que de la lecture : l'utilisateur doit pouvoir **agir** sans réseau. On enregistre sa modification dans le local immédiatement (elle apparaît, marquée « à envoyer »), et une **file** l'envoie au serveur quand la connexion revient — l'idée de la file de messages du palier 7 (leçon 05), à l'échelle de l'app : découpler l'action de son envoi. Piège crucial : l'**idempotence** (palier 7, leçon 06). Si l'envoi est rejoué (reconnexion, relance), il ne faut pas créer deux fois la dépense — on marque chaque modification avec un identifiant pour que l'API la traite une seule fois.

**9-10.** La synchronisation est le vrai défi : si une donnée a changé **des deux côtés** (local et serveur), c'est un conflit — exactement le compromis de cohérence distribuée du palier 7 (leçon 05). Au début, une règle simple suffit (le serveur fait foi, ou le local en attente l'emporte jusqu'à son envoi) ; la résolution fine viendra avec l'expérience. Et le grand enseignement du palier : le hors-ligne n'est pas un sujet isolé, c'est l'**assemblage** de tout ton parcours — `localStorage` (palier 2), SQL (paliers 4-6), caching/file/idempotence (palier 7), async/Stream (leçon 02). C'est la synthèse qui conclut le palier mobile, et ce qui distingue une vraie app d'un site web emballé.
</details>

---

## ✅ Acquis si…

- [ ] Je stocke des réglages avec `shared_preferences` (le `localStorage` du mobile).
- [ ] Je stocke des données structurées dans une base locale `drift` (SQLite), et je sais quand utiliser quoi.
- [ ] J'applique le motif cache-first : afficher le local d'abord, synchroniser ensuite.
- [ ] Mon app reste utilisable en mode avion (testé sur un vrai téléphone), sans écran blanc ni plantage.
- [ ] Je détecte l'état du réseau et j'affiche un indicateur hors-ligne.
- [ ] J'enregistre les modifications hors-ligne localement et je les envoie au retour du réseau.
- [ ] J'assure l'idempotence pour ne pas créer de doublon à la synchronisation.
- [ ] Je fais le lien entre le hors-ligne et tout mon parcours (localStorage, SQL, caching, file, async).

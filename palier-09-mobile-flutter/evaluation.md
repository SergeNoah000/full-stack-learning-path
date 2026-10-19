# ✅ Épreuve de sortie — Palier 9

> **Conditions** : seul, sans tutoriel. IA autorisée (niveau 9 : elle entre dans tes produits), mais la **stratégie** d'état et de hors-ligne doit être la tienne, et défendue.
> **Durée** : ~4 h hors projet. **Seuil** : 4/4 épreuves · **13/18** au quiz · projet 7 installé chez ≥ 3 utilisateurs réels.

---

## Partie A — Épreuves pratiques

### A1 — Dart (45 min)
Réécris en Dart l'étalon du parcours — le gestionnaire de dépenses en CLI :
- classes avec constructeurs nommés, `final` partout où c'est possible
- **null safety** strict : aucun `!` non justifié, usage de `?`, `??`, `late` à bon escient
- `map`/`where`/`fold` au lieu de boucles
- persistance dans un fichier JSON
- `dart analyze` sans avertissement

✅ **Réussi si** : le CLI fonctionne, l'analyse est propre, et tu expliques 3 différences entre la null safety de Dart et le typage de TypeScript.

### A2 — Interface Flutter sans tutoriel (90 min)
Reproduis un écran d'une app connue de ton contexte (WhatsApp, MTN MoMo…), de mémoire, à partir d'une capture :
- mise en page avec `Column`/`Row`/`Stack`/`ListView`, pas de valeurs magiques partout
- thème centralisé, **mode sombre** fonctionnel
- liste défilante avec séparateurs et état vide géré
- fonctionne en **portrait et paysage**, sans débordement

✅ **Réussi si** : visuellement fidèle, aucun avertissement de débordement, mode sombre correct.

### A3 — État et données (60 min)
Un écran connecté à **ton** backend déployé (projet 4, 5 ou 6) :
- authentification (jeton stocké de façon sûre)
- liste + détail + création
- gestion d'état avec **Riverpod**
- **les quatre états d'écran** traités visuellement : chargement, erreur (avec bouton « réessayer »), vide, données
- sérialisation JSON ↔ classes Dart

✅ **Réussi si** : couper le réseau ou le serveur produit un message clair et un moyen de réessayer, **jamais** un écran blanc ni un plantage.

### A4 — Hors-ligne (45 min)
- cache local des données (SQLite via `drift`, ou équivalent)
- l'app **démarre et affiche des données** sans réseau
- les écritures faites hors-ligne sont **mises en file** et synchronisées au retour du réseau
- un conflit possible est identifié, et ta stratégie de résolution est écrite

✅ **Réussi si** : tu démontres le scénario complet — mode avion, consultation, création, retour du réseau, synchronisation.

---

## Partie B — Quiz (18 questions)

**Dart**
1. Qu'est-ce que la null safety ? À quoi servent `?`, `!` et `late` ?
2. Pourquoi `!` est-il un risque ? Quand est-il légitime ?
3. `final` vs `const` en Dart ?
4. `Future` vs `Stream` : quand utiliser l'un ou l'autre ?
5. Donne les équivalents Dart de `map`, `filter` et `reduce`.

**Flutter**
6. « Tout est widget » : qu'est-ce que ça change dans la façon de construire une interface ?
7. `StatelessWidget` vs `StatefulWidget` : comment choisis-tu ?
8. Que fait `setState` exactement ? Pourquoi ne suffit-il pas à grande échelle ?
9. Pourquoi `const` devant un widget améliore-t-il les performances ?
10. Quelle est la limite de `setState` qui justifie Riverpod ? (Décris le problème **avant** l'outil.)
11. Comment passe-t-on des données à un écran, et comment en récupère-t-on un résultat ?
12. Pourquoi faut-il **toujours** traiter les quatre états d'écran ?

**Données & architecture**
13. Où vit la logique métier dans une app Flutter bien structurée ? Pourquoi pas dans les widgets ?
14. Qu'est-ce qu'un repository, et quel problème résout-il ici ? (Lien avec les paliers 5 à 7.)
15. Comment stocke-t-on un jeton d'authentification sur mobile ? Qu'est-ce qu'il ne faut pas faire ?
16. Décris ta stratégie hors-ligne, et un cas de conflit qu'elle doit gérer.
17. Pourquoi la clé d'API IA doit-elle passer par **ton** backend et jamais vivre dans l'app ? (Que peut faire quelqu'un avec un APK ?)
18. APK vs AAB ? Qu'est-ce que la signature d'application, et pourquoi la clé est-elle critique ?

<details>
<summary>Corrections — points clés</summary>

1. Le système de types distingue ce qui peut être nul de ce qui ne peut pas l'être. `?` : le type accepte `null`. `!` : « fais-moi confiance, ce n'est pas nul » (assertion). `late` : initialisé plus tard, avant le premier usage.
2. `!` **désactive** la garantie : si la valeur est nulle, l'app plante à l'exécution. Légitime quand l'initialisation est garantie par le cycle de vie du framework et vérifiée — sinon, préfère `?.`, `??` ou une vérification explicite.
3. `final` : assigné une seule fois, valeur connue à l'exécution. `const` : valeur connue à la **compilation**, l'objet est canonisé (partagé en mémoire).
4. `Future` : **une** valeur asynchrone (une requête HTTP). `Stream` : **plusieurs** valeurs dans le temps (position GPS, état de connectivité, messages entrants).
5. `.map()`, `.where()`, `.fold()` (ou `.reduce()` sans valeur initiale). Les mêmes concepts qu'au palier 1, le quatrième langage.
6. L'interface est un **arbre déclaratif** reconstruit à partir de l'état, au lieu d'être mutée élément par élément. On ne « modifie » pas un bouton : on change l'état et on redécrit l'interface — exactement l'idée de React.
7. `Stateless` quand l'affichage dépend uniquement des paramètres reçus. `Stateful` quand le widget possède un état local qui évolue (champ de saisie, animation, onglet sélectionné).
8. Il marque le widget comme « sale » : Flutter rappellera `build` et comparera l'arbre. Il ne suffit pas à grande échelle car l'état n'est accessible qu'à ce widget et à ses enfants : le partager impose de le remonter très haut et de le faire descendre à travers des couches entières (l'équivalent du props-drilling de React).
9. Un widget `const` est instancié une seule fois et réutilisé : Flutter peut sauter sa reconstruction et sa comparaison.
10. Le partage d'état entre branches éloignées de l'arbre, et la séparation de l'état serveur de l'état d'interface. Riverpod fournit un accès à l'état **hors** de l'arbre de widgets, avec cache, invalidation et testabilité.
11. Par le constructeur de l'écran (via les arguments de route) ; le résultat revient par le `Future` retourné à la navigation (`Navigator.pop(context, resultat)`).
12. Parce que les trois états « non heureux » sont **la réalité** : réseau lent, serveur en panne, première utilisation sans données. Les ignorer, c'est livrer une app qui affiche un écran blanc ou plante chez l'utilisateur — exactement ce qui se voit en premier.
13. Dans des classes/fonctions **pures**, hors des widgets, appelées par eux. Parce que la logique dans un widget n'est ni testable sans interface, ni réutilisable sur un autre écran — et c'est le même principe qu'au palier 1 (fonctions pures) et au palier 4 (couche service).
14. Une couche qui expose les données au reste de l'app sans dire d'où elles viennent (réseau ou cache local). Elle permet de changer la stratégie (cache d'abord, réseau d'abord) sans toucher à l'interface. **Même pattern que tes modèles PDO et ta couche modèles Python.**
15. Dans le stockage sécurisé de la plateforme (`flutter_secure_storage` → Keychain/Keystore). Pas dans `shared_preferences` en clair, pas dans un fichier, et jamais journalisé.
16. Typiquement : lecture **cache-first** (afficher le local, rafraîchir en arrière-plan) et écritures mises en file avec un identifiant local, rejouées au retour du réseau. Conflit à gérer : une donnée modifiée hors-ligne et modifiée aussi côté serveur — il faut une règle (dernier écrivain gagne, versionnage, ou résolution manuelle par l'utilisateur).
17. Un APK se décompile trivialement : toute clé embarquée est publique. Quelqu'un peut l'extraire et consommer ton quota (donc ton argent) ou agir en ton nom. L'appel doit donc passer par **ton** backend, qui détient la clé et peut authentifier, limiter et journaliser.
18. APK : paquet installable directement (distribution hors store, très courante localement). AAB : format du Play Store, qui génère des APK optimisés par appareil. La signature prouve l'origine de l'app : **si tu perds la clé, tu ne peux plus publier de mise à jour** de la même application.

**Score** : ____ /18
</details>

---

## Partie C — Livrables

- [ ] [Projet 7](projet.md) installé sur ton téléphone **et sur ceux de ≥ 3 personnes** de ton entourage.
- [ ] L'app parle à **ton** backend déployé (authentification incluse) et **survit à une coupure réseau**.
- [ ] Une **fonctionnalité IA** en service, dont l'appel passe par ton backend (jamais la clé dans l'app).
- [ ] **Retours utilisateurs collectés** (formulaire ou WhatsApp), priorisés **impact × effort**, et au moins une itération livrée en réponse.
- [ ] Stratégie de gestion d'état et stratégie hors-ligne **écrites et justifiées** (section ajoutée à ton comparatif d'architecture).
- [ ] APK signé, procédure de build documentée (et fiche Play Store préparée si le budget suit).
- [ ] Les katas passent en Dart (≥ 5) · `journal.md` · [rétrospective](../templates/retrospective-palier.md).
- [ ] 🧑‍🏫 Référent : il installe l'app et la teste en **utilisateur exigeant** ; revue des états d'écran et du hors-ligne.

---

## Résultat

| Partie | Seuil | Résultat |
|--------|-------|----------|
| A — Pratique | 4/4 | ⬜ |
| B — Quiz | 13/18 | ⬜ ___/18 |
| C — Livrables | tout coché | ⬜ |

**Date** : ______ · **Verdict** : ⬜ validé ⬜ à repasser le ______ · [ ] reporté dans [../progression.md](../progression.md)

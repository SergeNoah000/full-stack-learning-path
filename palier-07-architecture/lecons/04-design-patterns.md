# Leçon 04 — Design patterns du quotidien : Repository, Factory, Strategy, Observer

> 🎯 **À la fin de cette leçon** : tu reconnais et nommes quatre patrons que tu as déjà croisés (voire écrits), et tu sais qu'un patron est une réponse éprouvée à un problème récurrent — pas une incantation à placer partout.
> ⏱️ 5 h · **Prérequis** : leçons 01-03, et tes trois backends.

---

## De quoi on parle

Un **design pattern** (patron de conception) est une solution type, nommée, à un problème de conception qui revient souvent. Ce n'est pas du code à copier : c'est une **forme** reconnue, un vocabulaire partagé. Dire « ici j'utilise un Repository » transmet à toute l'équipe une structure entière en un mot.

On se concentre sur quatre patrons que tu rencontres vraiment au quotidien — et que, pour trois d'entre eux, tu as **déjà utilisés** sans les nommer :

- **Repository** : isoler l'accès aux données derrière une interface métier. *Tu l'as écrit trois fois (paliers 4-6).*
- **Factory** : déléguer la création d'objets à un endroit dédié, pour ne pas disperser les `new`.
- **Strategy** : rendre un comportement interchangeable en l'encapsulant dans des classes. *C'est le O de SOLID (leçon 01).*
- **Observer** : notifier automatiquement des objets intéressés quand quelque chose change. *Tu l'as vu dans les événements du DOM (palier 2) et l'état de React (palier 3).*

Le livre fondateur (le « Gang of Four ») en recense 23. La plupart sont rares ou datés. Ces quatre-là couvrent l'essentiel de ce qui sert, et surtout : tu les connais déjà de l'intérieur. Cette leçon te donne les noms.

---

## À quoi ça sert, concrètement

**Parce que c'est le vocabulaire de l'architecture.** « Fais une Factory », « c'est un Observer », « mets une Strategy » : en une phrase, un développeur communique une structure entière. Sans ce vocabulaire, il faut décrire dix lignes à chaque fois. Les patrons sont le dictionnaire partagé des concepteurs.

**Parce que tu les lis dans tous les frameworks.** React est truffé d'Observer (l'état notifie les composants). Les ORM sont des Repository (Eloquent, Prisma). Les systèmes de paiement, d'export, de notification sont des Strategy. Nommer le patron en lisant du code de framework te le rend immédiatement compréhensible.

**Parce que les avoir déjà écrits les ancre pour de bon.** Tu n'apprends pas le Repository dans l'abstrait : tu l'as construit en PDO, en sqlite3, en pg. Tu ne découvres pas l'Observer : tu as écrit des `addEventListener` (palier 2) et vu React re-rendre sur changement d'état (palier 3). Mettre un nom sur du vécu est bien plus solide que mémoriser une définition.

**Et parce qu'il faut savoir ne PAS les surutiliser.** Le piège classique : apprendre les patrons et vouloir en coller partout. Un patron résout un problème **réel** ; sans ce problème, il n'ajoute que de la complexité (retour à KISS et YAGNI, leçon 02). Reconnaître quand un patron n'est pas nécessaire est aussi important que le connaître.

---

## Où ça intervient dans le développement

Les patrons structurent des points précis de ton application :

```
   Contrôleur
        ▼
   Service  ──uses──▶  Strategy   (comportement interchangeable : paiement, export)
        │
        ├──uses──▶     Repository (accès aux données, derrière une interface)
        │
        └──emits──▶    Observer   (événement : "commande créée" → e-mail, log, stock)

   Factory : appelée là où des objets complexes doivent être créés de façon cohérente
```

Quatre ancrages dans ton vécu.

**Repository : tes trois couches d'accès.** `DepotDepenses` en PDO (palier 6), en sqlite3 (palier 5), avec Prisma/pg (palier 4). Tu as écrit ce patron trois fois. Son but : le reste du code ne sait pas d'où viennent les données. C'est aussi le D de SOLID (leçon 01).

**Strategy : le O de SOLID, nommé.** La cascade de `if` sur un moyen de paiement transformée en classes (leçon 01) **est** le patron Strategy. Tu l'as déjà rencontré en architecture ; ici tu lui donnes son nom officiel.

**Observer : les événements que tu connais depuis le palier 2.** `addEventListener` (DOM, palier 2), le re-rendu de React quand l'état change (palier 3), les événements de Laravel (palier 6) : tous sont des Observer. Un sujet notifie des observateurs abonnés, sans les connaître en détail.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas relire tes backends pour **y retrouver** les patrons déjà présents (Repository, Observer), puis en **ajouter** deux là où ils apportent vraiment quelque chose : une Strategy pour un comportement qui varie, une Factory pour une création d'objet dispersée. Et tu vas identifier un endroit où un patron serait de trop.

### En équipe, en entreprise

**On nomme les patrons en conception et en revue.** « Ce serait plus propre avec une Strategy » est une remarque courante. Comprendre immédiatement de quoi on parle te fait participer.

**Les frameworks imposent des patrons.** React (Observer, et les hooks), les ORM (Repository), l'injection de dépendances (souvent une Factory sous le capot) : tu ne les choisis pas, tu les utilises. Les reconnaître éclaire le framework.

**La surutilisation est un anti-pattern connu.** On se moque (gentiment) du code « enterprise » bardé de `AbstractSingletonProxyFactoryBean`. Un patron mal placé est pire que pas de patron. Les équipes mûres appliquent les patrons avec parcimonie, quand le problème est là.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours (en les utilisant, souvent via framework) : Repository et Observer. Tu les manipules sans y penser.

Régulièrement (en les écrivant) : Strategy, quand un comportement doit varier proprement ; Factory, quand la création d'un objet devient complexe ou doit être centralisée.

Plus rares, et à connaître de nom seulement pour l'instant : Singleton (souvent un anti-pattern, à éviter), Decorator, Adapter, Facade. Tu les croiseras ; inutile de les forcer. Les 23 patrons du Gang of Four ne sont pas tous d'actualité.

---

## La mécanique — les quatre patrons

### Repository : l'accès aux données derrière une interface (tu le connais)

```php
interface DepotDepenses {
    public function lister(): array;
    public function parId(int $id): ?array;
    public function creer(array $d): array;
}
// PdoDepot implements DepotDepenses   (palier 6)
// SqliteDepot implements DepotDepenses (palier 5, transposé)
// DepotEnMemoire implements DepotDepenses (pour les tests)
```

Le service dépend de l'interface, pas de la base. Résultat : on change MySQL → SQLite, ou on teste avec un dépôt en mémoire, **sans toucher le service**. C'est ce que tu as construit trois fois. Le nom officiel de ce que tu faisais : Repository.

### Strategy : un comportement interchangeable (le O de SOLID)

```php
interface MoyenPaiement { public function payer(float $montant): Recu; }
class Carte  implements MoyenPaiement { /* ... */ }
class Paypal implements MoyenPaiement { /* ... */ }

class Caisse {
    public function encaisser(MoyenPaiement $moyen, float $montant): Recu {
        return $moyen->payer($montant);   // la Caisse ignore QUEL moyen c'est
    }
}
```

La Caisse reçoit une stratégie et l'exécute, sans savoir laquelle. Ajouter Stripe = une nouvelle classe, sans toucher la Caisse (Open/Closed, leçon 01). Le signal qu'une Strategy s'impose : une cascade de `if/switch` sur un type qui grossit.

### Factory : centraliser une création complexe

```php
// AVANT — des `new` dispersés, avec la même logique de construction répétée
$notif = new NotificationEmail($config->smtp, $gabarit, $traducteur, $logger);
// ...répété dans cinq fichiers, avec le risque d'oublier un paramètre

// APRÈS — une Factory qui sait construire correctement, à un seul endroit
class FabriqueNotification {
    public function creer(string $type): Notification { /* assemble tout */ }
}
$notif = $fabrique->creer('email');
```

Quand créer un objet demande plusieurs étapes ou dépendances, disperser les `new` répand cette complexité partout. La Factory la concentre : un seul endroit sait assembler l'objet correctement. Le signal : le même `new` compliqué copié à plusieurs endroits.

### Observer : notifier des abonnés sur événement (tu le connais depuis le palier 2)

```
Sujet : "une commande a été créée".
Observateurs abonnés : envoyer l'e-mail de confirmation, décrémenter le stock,
                       écrire dans le journal, prévenir la comptabilité.
Le sujet émet l'événement ; chaque observateur réagit, sans que le sujet
les connaisse individuellement. On en AJOUTE un sans toucher le sujet.
```

C'est **exactement** `addEventListener('click', ...)` du DOM (palier 2) : le bouton (sujet) émet `click`, tes écouteurs (observateurs) réagissent, le bouton ne les connaît pas. C'est le re-rendu de React quand l'état change (palier 3). C'est ce qui découple « il s'est passé quelque chose » de « voici tout ce qu'on fait en réaction ». Les systèmes d'événements et de files (leçon 05) en sont la version distribuée.

### ⭐ Le méta-point : un patron résout un problème réel

```
Un patron répond à une QUESTION :
  Repository : « comment ne pas coupler mon métier à la base ? »
  Strategy   : « comment faire varier un comportement sans cascade de if ? »
  Factory    : « comment centraliser une création complexe ? »
  Observer   : « comment réagir à un événement sans coupler l'émetteur aux réactions ? »
Pas de question → pas de patron. Le coller sans problème = complexité gratuite.
```

C'est la clé de toute la leçon. Un patron n'est pas une décoration : c'est la réponse à une question précise. Si tu ne peux pas énoncer la question, tu n'as pas besoin du patron (KISS, YAGNI — leçon 02).

---

## Les problèmes que tu vas rencontrer

**« J'ai mis des patrons partout et c'est illisible. »** Surutilisation. Chaque patron doit répondre à une question réelle. Enlève ceux qui n'en résolvent aucune.

**« Je ne vois pas la différence entre Strategy et une simple fonction. »** Pour deux comportements figés, une fonction suffit (KISS). La Strategy se justifie quand les comportements se multiplient, portent un état, ou doivent être ajoutés sans modifier l'appelant.

**« Ma Factory ne fait qu'un `new`. »** Alors elle est inutile (YAGNI). La Factory se justifie quand la création est complexe ou répétée. Un simple `new` n'a pas besoin d'elle.

**« Mon Observer rend le flux impossible à suivre. »** Le revers de l'Observer : le découplage rend le « qui réagit à quoi » moins visible. Documente les abonnements, et ne l'utilise que quand le découplage vaut cette perte de lisibilité directe.

**« Singleton, c'est bien ? »** Méfiance : le Singleton (une seule instance globale) est souvent un anti-pattern — un état global déguisé, difficile à tester. Préfère l'injection de dépendances (leçon 01).

---

## Ce qu'on te demandera

En **entretien**, les patrons sont un classique : « cite des design patterns que tu as utilisés », « explique le patron Strategy / Repository / Observer », « différence entre Factory et Strategy ? ». Ta force : répondre avec **tes** usages réels (« j'ai écrit un Repository dans mes trois backends », « l'Observer, c'est les événements du DOM que j'utilisais au palier 2 »).

On peut demander : « quand NE PAS utiliser un patron ? » — la bonne réponse parle de problème réel et de surutilisation (KISS/YAGNI).

En **mission**, on attend surtout que tu **reconnaisses** les patrons dans le code existant et le framework, pour t'y retrouver vite.

---

## Ce qui te démarquera

**Reconnaître les patrons que tu as déjà écrits.** Dire « mon Repository des paliers 4-6, ma Strategy qui est le O de SOLID, l'Observer qui est `addEventListener` » prouve que tu as compris les patrons de l'intérieur, pas récité un catalogue.

**Énoncer la question avant le patron.** « J'utilise une Strategy parce que mon comportement de paiement doit varier sans cascade de `if` » — relier chaque patron à son problème est la marque de quelqu'un qui conçoit, pas qui décore.

**Savoir refuser un patron.** Dire « ici, une fonction suffit, un patron serait de la sur-ingénierie » te distingue nettement de celui qui vient d'apprendre les patrons et veut tous les placer.

**Et voir les patrons dans les frameworks.** « React, c'est de l'Observer ; les ORM sont des Repository » : relier les patrons à ce que tu utilises tous les jours montre une compréhension d'architecture transversale.

---

## 📚 À lire

**refactoring.guru → *Design Patterns*** : la meilleure ressource en ligne, illustrée, avec le problème que chaque patron résout et des exemples dans plusieurs langages. Lis en priorité Repository (via *Data Mapper*), Factory Method, Strategy, Observer.

**Head First Design Patterns** : si tu veux un livre, celui-ci est le plus pédagogique — il part toujours du problème, jamais de la solution.

**Le « Gang of Four » (*Design Patterns*, 1994)** : la source historique, pour culture. Dense ; à consulter, pas à lire d'un trait.

Relis **ton** code : tes Repository (paliers 4-6), tes `addEventListener` (palier 2), l'état de React (palier 3), la Strategy de la leçon 01. Les patrons y sont déjà.

---

## 🤖 Le mini-projet à demander à l'IA

Retrouver les patrons dans ton code, puis en placer un à bon escient :

> « Je suis en formation de développeur, palier 7 (architecture). Je veux comprendre les design patterns à partir de MON code, pas d'exemples abstraits. Sans conclure à ma place, aide-moi à retrouver, dans mes trois backends et mon frontend : où j'ai déjà un Repository, où j'ai un Observer (indice : mes addEventListener du DOM, l'état de React), et où une cascade de if serait une Strategy. Pour chaque patron, fais-moi d'abord énoncer la QUESTION qu'il résout. »

Puis le discernement :

> « Montre-moi trois situations de mon code et, pour chacune, demande-moi si un patron (Strategy, Factory, Observer) est justifié ou si une solution simple suffit (KISS/YAGNI). Fais-moi énoncer la question à résoudre avant de décider. Puis aide-moi à introduire proprement UN patron là où il est vraiment utile, par petits pas (comme un refactoring, leçon 03). »

---

## 🛠️ À faire

1. **⭐ Chasse aux patrons existants** : relis tes backends et ton frontend, et liste où tu as déjà, sans le nommer : un Repository, un Observer. Écris, pour chacun, la question qu'il résout.
2. **Strategy** : reprends la cascade de `if` sur un type (moyen de paiement, format d'export) de la leçon 01 et nomme-la : c'est une Strategy. Vérifie qu'ajouter un cas ne touche pas l'appelant.
3. **Factory** : trouve dans ton code un `new` complexe (plusieurs dépendances) répété à plusieurs endroits, et centralise-le dans une Factory. Vérifie qu'on ne peut plus oublier un paramètre.
4. **Observer** : décris, pour un événement de ton domaine (« dépense créée », « utilisateur inscrit »), les observateurs qui devraient réagir (e-mail, log, statistiques). Relie-le explicitement à `addEventListener` (palier 2) et à React (palier 3).
5. **⭐ Le refus** : trouve un endroit où tu serais tenté de mettre un patron, énonce la question, et constate qu'il n'y en a pas (ou qu'une fonction suffit). Décide de **ne pas** mettre le patron, et justifie (KISS/YAGNI, leçon 02).
6. **Dans le framework** : ouvre React (ou Laravel) et identifie un patron à l'œuvre (Observer dans l'état/les événements, Repository dans l'ORM). Note comment le framework te l'impose.
7. **Le lien** : dans ton journal, dresse pour chaque patron (Repository, Factory, Strategy, Observer) la question qu'il résout **et** un endroit réel, dans ton code ou un framework, où tu l'as vu.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Le but de la leçon : tu n'apprends pas ces patrons, tu les **reconnais**. Repository = tes `DepotDepenses` des paliers 4-6 (question : « comment ne pas coupler mon métier à la base ? »). Observer = tes `addEventListener` du DOM au palier 2 et le re-rendu de React au palier 3 (question : « comment réagir à un événement sans que l'émetteur connaisse les réactions ? »). Mettre un nom sur du vécu ancre bien mieux qu'une définition apprise à vide.

**2.** La Strategy EST le O de SOLID (leçon 01) : des classes qui implémentent une même interface, choisies à l'exécution, ajoutables sans modifier l'appelant. Le signal qui l'appelle : une cascade de `if`/`switch` sur un type qui grandit. Si le comportement ne varie pas (ou jamais plus que deux cas figés), une fonction suffit — n'introduis pas la Strategy par réflexe.

**5.** Le cœur du discernement, et ce qui te distingue : un patron sans problème à résoudre est de la complexité gratuite. Avant tout patron, énonce la question qu'il résout. Si tu n'as pas de question, tu n'as pas besoin du patron. C'est KISS et YAGNI (leçon 02) appliqués aux patrons — et c'est exactement ce qui sépare l'architecte du débutant qui vient de lire le catalogue.

**7.** La synthèse : chaque patron est une réponse à une question. Repository → découpler de la base. Strategy → faire varier un comportement sans cascade de `if`. Factory → centraliser une création complexe. Observer → découpler un événement de ses réactions. Les relier à un usage réel (ton code ou un framework) transforme un catalogue abstrait en outils que tu sais quand sortir.
</details>

---

## ✅ Acquis si…

- [ ] Je définis un design pattern comme une réponse éprouvée à un problème récurrent.
- [ ] Je reconnais le Repository dans mes couches d'accès des paliers 4 à 6.
- [ ] Je reconnais l'Observer dans `addEventListener` (palier 2) et l'état de React (palier 3).
- [ ] J'identifie une Strategy (le O de SOLID) là où une cascade de `if` grossit.
- [ ] Je centralise une création complexe et répétée dans une Factory.
- [ ] J'énonce la question qu'un patron résout avant de l'introduire.
- [ ] Je sais refuser un patron quand une solution simple suffit (KISS/YAGNI).
- [ ] Je repère un patron à l'œuvre dans un framework que j'utilise.

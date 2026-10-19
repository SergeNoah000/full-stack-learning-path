# Leçon 01 — SOLID appliqué à ton propre code

> 🎯 **À la fin de cette leçon** : tu reconnais les cinq principes SOLID dans le code que tu as déjà écrit (paliers 4 à 6), et tu sais lesquels améliorent vraiment un projet — S, O et D en priorité.
> ⏱️ 5 h · **Prérequis** : les paliers 4, 5 et 6 (tu as trois backends à relire).

---

## De quoi on parle

**SOLID** est un acronyme de cinq principes de conception orientée objet, popularisés par Robert C. Martin. Ils visent un même but : du code qui se **modifie sans casser le reste**.

- **S** — *Single Responsibility* : une classe a une seule raison de changer.
- **O** — *Open/Closed* : ouvert à l'extension, fermé à la modification.
- **L** — *Liskov Substitution* : un sous-type doit pouvoir remplacer son type parent sans surprise.
- **I** — *Interface Segregation* : mieux vaut plusieurs petites interfaces qu'une grosse.
- **D** — *Dependency Inversion* : dépendre d'abstractions, pas d'implémentations concrètes.

Le piège, avec SOLID, c'est de l'apprendre sur des exemples abstraits (des `Animal`, des `Shape`) qui ne parlent pas. **Ici, on fait l'inverse** : tu as écrit trois backends (Node au palier 4, Python au palier 5, PHP au palier 6), avec des contrôleurs, des services, des couches Repository. Chaque principe va s'illustrer dans **ton** code. Tu as déjà appliqué plusieurs de ces principes sans le savoir — le Repository, l'injection de dépendances — et cette leçon te donne le vocabulaire pour les nommer et les pousser plus loin.

---

## À quoi ça sert, concrètement

**Parce que le code vit en changeant.** Un projet qu'on ne touche plus est mort. SOLID n'optimise pas la vitesse ni la beauté : il optimise la **facilité de changement**. Une classe à une seule responsabilité se modifie sans effet de bord ; une dépendance inversée se remplace sans réécrire ce qui l'utilise.

**Parce que c'est le vocabulaire partagé des revues de code.** « Cette classe viole le SRP », « inverse cette dépendance pour pouvoir tester » : en équipe, ces phrases sont des raccourcis que tout le monde comprend. Les connaître te fait participer aux discussions d'architecture.

**Parce que trois principes font 80 % de la valeur.** S (responsabilité unique), O (extension sans modification) et D (inversion des dépendances) transforment vraiment un code. L et I sont plus subtils, utiles surtout dans des hiérarchies de types complexes que tu rencontreras moins au début. On priorise S, O, D — et on dit honnêtement que L et I attendront des cas concrets.

**Et parce que tu as de quoi les illustrer.** Avoir trois backends à relire est un luxe : tu vois les mêmes principes appliqués (ou violés) dans trois langages. C'est ton avantage sur quelqu'un qui n'a qu'un projet — tu généralises, au lieu de mémoriser un cas.

---

## Où ça intervient dans le développement

SOLID est un filtre qu'on applique à la conception des classes et des modules, à toutes les couches :

```
   Contrôleur     ← une responsabilité : traduire HTTP ↔ métier (S)
        ▼ dépend d'une ABSTRACTION de service, pas du concret (D)
   Service        ← une responsabilité : la logique métier (S)
        ▼ dépend d'une ABSTRACTION de dépôt (D)
   Repository     ← une responsabilité : l'accès aux données (S)
                  ← on peut en AJOUTER un (SQLite, Postgres) sans toucher le service (O)
```

Trois ancrages dans ton code existant.

**Le Repository, c'est déjà du SOLID.** Aux paliers 4, 5 et 6, tu as isolé l'accès aux données dans une couche dédiée. C'est le **S** (une seule responsabilité : parler à la base) et la base du **D** (le service dépend du dépôt, pas de la base directement). Tu as fait du SOLID sans le nommer.

**L'injection de dépendances, c'est le D.** Quand tu passais la connexion PDO (palier 6) ou le pool (palier 4) au constructeur du Repository, tu inversais la dépendance : la classe ne crée pas ce dont elle a besoin, on le lui donne. C'est exactement le **D** de SOLID, et ce qui rend le test possible (on injecte un faux dépôt).

**Et la séparation contrôleur/service/modèle, c'est le S.** Le « contrôleur fin » du palier 6 (leçon 09) est une application directe du *Single Responsibility* : le contrôleur traduit HTTP, le service décide, le modèle persiste. Chacun a une seule raison de changer.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas relire tes trois backends et y chercher les principes : où as-tu respecté le SRP ? Où une classe fait-elle trop de choses ? Où une dépendance est-elle codée en dur (violation du D) ? Tu vas refactorer un ou deux endroits pour appliquer S, O et D — sur ton code réel, pas sur un exemple.

### En équipe, en entreprise

**SOLID est le langage des discussions de conception.** En revue, en conception, on raisonne en ces termes. On ne cite pas les principes pédantement, mais on les a en tête : « si je mets ça ici, la classe aura deux raisons de changer ».

**Le D est roi pour les tests.** L'inversion des dépendances est ce qui rend un code testable : on injecte un faux (*mock*) à la place de la vraie base, du vrai service d'e-mail. Tu l'as vu au palier 4 (tests) : un code non inversé est un code non testable.

**Le dogmatisme est un défaut.** Appliquer SOLID à l'extrême produit une sur-ingénierie illisible (des interfaces pour tout, des abstractions inutiles). L'équilibre — assez de SOLID pour pouvoir changer, pas plus — est ce qu'on attend d'un bon développeur. On en reparle au palier suivant (DRY/KISS/YAGNI).

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : le **S** (ne pas entasser les responsabilités) et le **D** (injecter les dépendances, dépendre d'abstractions). Ce sont les deux réflexes qui changent la vie.

Régulièrement : le **O** quand tu ajoutes une variante (un nouveau moyen de paiement, un nouveau format d'export) sans modifier l'existant — souvent via Strategy (leçon 04).

Plus rare au début : le **L** et le **I**, qui brillent dans des hiérarchies de types et des interfaces riches. Tu les rencontreras en lisant du code de framework ; inutile de forcer leur application tant que le cas ne se présente pas.

---

## La mécanique — chaque principe dans ton code

### S — Single Responsibility : une seule raison de changer

```
❌ Un UserController qui : valide la requête, hache le mot de passe,
   écrit en base, envoie l'e-mail de bienvenue, et génère le PDF de facture.
   → cinq raisons de changer, cinq sources de bugs.

✅ Le contrôleur traduit HTTP. Un UserService décide. Un Repository persiste.
   Un Mailer envoie. Chacun change pour UNE raison.
```

C'est le « contrôleur fin » du palier 6, généralisé. Le test : « si je change la façon d'envoyer les e-mails, combien de classes dois-je toucher ? ». Avec le SRP : une seule (le Mailer). Sans : le contrôleur, partout où il envoie.

### O — Open/Closed : étendre sans modifier

```php
// ❌ Fermé à l'extension : chaque nouveau moyen force à MODIFIER la méthode
function payer(string $moyen, float $montant) {
    if ($moyen === 'carte')      { /* ... */ }
    elseif ($moyen === 'paypal') { /* ... */ }
    // ajouter Stripe = rouvrir et modifier cette fonction (risque de régression)
}

// ✅ Ouvert à l'extension : on AJOUTE une classe, sans toucher l'existant
interface MoyenPaiement { public function payer(float $montant): void; }
class Carte  implements MoyenPaiement { /* ... */ }
class Paypal implements MoyenPaiement { /* ... */ }
class Stripe implements MoyenPaiement { /* ... */ }   // ajout SANS modification
```

Ajouter Stripe ne touche pas au code qui marchait : on ajoute une classe. Moins on modifie du code éprouvé, moins on introduit de régressions. C'est le patron Strategy (leçon 04), et c'est le principe derrière les systèmes de plugins.

### D — Dependency Inversion : dépendre d'abstractions

```php
// ❌ Le service crée lui-même sa dépendance concrète : couplé, intestable
class DepenseService {
    private PdoDepot $depot;
    public function __construct() { $this->depot = new PdoDepot(/* ... */); }
    // impossible de remplacer le dépôt par un faux pour tester
}

// ✅ On INJECTE une abstraction : découplé, testable
interface DepotDepenses { public function lister(): array; /* ... */ }
class DepenseService {
    public function __construct(private DepotDepenses $depot) {}   // on reçoit, on ne crée pas
}
// En production : new DepenseService(new PdoDepot($pdo));
// En test :       new DepenseService(new DepotEnMemoire());
```

C'est **exactement** ce que tu faisais en passant le dépôt au constructeur (paliers 4-6) — mais ici tu dépends de l'**interface** `DepotDepenses`, pas de la classe concrète. Le service ne sait plus si les données viennent de MySQL, de SQLite ou d'un tableau en mémoire. C'est ce qui rend le test trivial et le changement de base indolore.

### L — Liskov (plus subtil) : pas de mauvaise surprise au remplacement

```
Si FichierLectureSeule hérite de Fichier mais lève une exception sur ecrire(),
alors remplacer un Fichier par un FichierLectureSeule casse le code appelant.
→ le sous-type ne respecte pas le contrat du parent.
```

En pratique : une sous-classe ne doit pas retirer ce que la classe parente promettait. Tu le rencontreras en construisant des hiérarchies ; au début, c'est surtout une alarme à connaître (« cette classe fille désobéit au contrat »).

### I — Interface Segregation (plus subtil) : des interfaces fines

```
❌ Une interface Depot avec lister(), creer(), supprimer(), exporterPdf(),
   envoyerParMail()... que peu de classes peuvent toutes implémenter honnêtement.
✅ Des interfaces ciblées : Lisible, Inscriptible, Exportable.
   Une classe implémente celles dont elle a vraiment le rôle.
```

Mieux vaut plusieurs petites interfaces que les classes composent selon leurs besoins. Comme L, tu l'appliqueras quand tes interfaces grossiront — pas avant.

---

## Les problèmes que tu vas rencontrer

**« Ma classe grossit, je ne sais plus ce qu'elle fait. »** Violation du SRP. Liste ses responsabilités : si tu dis « elle fait X **et** Y **et** Z », sépare.

**« Je ne peux pas tester sans vraie base de données. »** Violation du D. La classe crée ou appelle directement sa dépendance. Injecte une abstraction, et teste avec un faux.

**« Chaque nouveau cas m'oblige à rouvrir la même grosse fonction. »** Violation du O. La cascade de `if/elseif` sur un type est le signal. Passe à des classes qui implémentent une interface commune (Strategy).

**« J'ai mis des interfaces partout et c'est illisible. »** Sur-ingénierie. SOLID sert à pouvoir changer, pas à multiplier les abstractions. Si une abstraction n'a qu'une seule implémentation et le restera, elle est prématurée (YAGNI, leçon 02).

**« Je ne vois pas la différence entre O et D. »** Normal, ils collaborent : D (dépendre d'une interface) rend le O (ajouter une implémentation) possible. Le Strategy utilise les deux.

---

## Ce qu'on te demandera

En **entretien**, SOLID est un classique : « cite les principes SOLID », « donne un exemple de violation du SRP », « qu'est-ce que l'inversion de dépendances et à quoi sert-elle ? ». Pouvoir répondre **avec un exemple tiré de ton propre code** (« dans mon backend, mon service dépendait d'une interface Repository, ce qui m'a permis de tester avec un dépôt en mémoire ») vaut dix fois mieux que réciter l'acronyme.

On peut demander : « SOLID, est-ce toujours à appliquer ? » — la bonne réponse mentionne l'équilibre, le risque de sur-ingénierie.

En **mission**, on attend que tu écrives des classes à responsabilité claire et que tu injectes tes dépendances — sans le dire, mais en le faisant.

---

## Ce qui te démarquera

**Illustrer chaque principe par ton code.** C'est ton atout unique : tu as trois backends. « Voici le SRP dans mon contrôleur PHP, le D dans mon service Node, le O là où j'ai ajouté un format d'export » — concret, vécu, convaincant.

**Prioriser S, O, D et l'assumer.** Dire « je me concentre sur la responsabilité unique, l'ouverture à l'extension et l'inversion des dépendances, car ce sont les trois qui changent vraiment un projet ; L et I, je les applique quand mes hiérarchies le justifient » montre du discernement, pas du bachotage.

**Connaître la limite.** Savoir que SOLID poussé à l'extrême devient de la sur-ingénierie, et citer YAGNI (leçon 02), te distingue de celui qui applique les principes mécaniquement.

**Et relier SOLID aux tests.** Comprendre que l'inversion des dépendances est ce qui rend un code testable relie l'architecture (ce palier) à la qualité (palier 4) — une vision d'ensemble que peu ont.

---

## 📚 À lire

**Robert C. Martin — les articles d'origine sur SOLID** (résumés partout en ligne) : la source, principe par principe.

**refactoring.guru → *Design Principles*** : des explications claires et visuelles, avec de bons exemples.

**Martin Fowler → *Dependency Injection*** : l'article de référence sur le D, le plus utile des cinq au quotidien.

Relis **ton** code des paliers 4, 5 et 6 : tes couches Repository et tes injections de dépendances **sont** du SOLID. C'est la meilleure lecture.

---

## 🤖 Le mini-projet à demander à l'IA

Analyser ton propre code à la lumière de SOLID :

> « Je suis en formation de développeur, palier 7 (architecture). J'ai écrit trois backends (Node, Python, PHP) avec des contrôleurs, des services et des couches Repository. Je veux comprendre SOLID sur MON code, pas sur des exemples abstraits. Sans réécrire à ma place, pose-moi des questions pour que je trouve moi-même : où ai-je respecté le Single Responsibility ? Où une classe a-t-elle plusieurs raisons de changer ? Où ai-je déjà fait de l'inversion de dépendances sans le nommer (en injectant mon dépôt) ? Concentre-toi sur S, O et D. »

Puis le refactoring guidé d'un cas :

> « Voici une de mes classes qui fait trop de choses [colle-la]. Aide-moi, par questions, à identifier ses responsabilités et à la découper, puis à inverser sa dépendance à la base de données derrière une interface pour la rendre testable. Ne me donne pas la solution d'un coup : fais-moi la trouver étape par étape, et montre-moi comment un test avec un faux dépôt devient alors possible. »

---

## 🛠️ À faire

1. **L'inventaire** : relis tes trois backends et dresse la liste des endroits où tu as (sans le savoir) appliqué le SRP et l'inversion de dépendances. Nomme-les.
2. **⭐ Chasse au SRP** : trouve, dans ton code, une classe qui a plusieurs raisons de changer. Liste ses responsabilités et découpe-la.
3. **⭐ Inverse une dépendance** : prends un service qui crée ou appelle directement sa base, extrais une interface `Depot`, et injecte-la. Écris un test qui utilise un dépôt en mémoire à la place de la vraie base.
4. **Ouvre à l'extension** : trouve (ou crée) une cascade de `if/elseif` sur un type (moyen de paiement, format d'export), et remplace-la par des classes qui implémentent une interface commune. Ajoute une nouvelle variante **sans** modifier l'existant.
5. **Le contre-exemple** : écris volontairement une petite classe qui viole le SRP et le D, puis note pourquoi elle sera pénible à tester et à modifier.
6. **La limite** : trouve dans ton code (ou imagine) une abstraction que tu serais tenté d'ajouter « au cas où », et décide si elle est justifiée ou si c'est de la sur-ingénierie (relie à YAGNI, leçon 02).
7. **Le lien** : note dans ton journal un exemple de chacun des trois principes prioritaires (S, O, D), tiré d'un langage différent (un en Node, un en Python, un en PHP).

<details>
<summary>Corrections et points de contrôle</summary>

**2.** Le test du SRP : énonce ce que fait la classe avec des « et ». « Elle valide **et** persiste **et** envoie l'e-mail » = trois responsabilités = trois raisons de changer = découpe. Après découpe, chaque classe se décrit sans « et ». C'est le « contrôleur fin » du palier 6, généralisé à toutes les couches.

**3.** Le cœur de la leçon et le principe le plus rentable. Avant : le service fait `new PdoDepot(...)`, il est soudé à MySQL, intestable sans base. Après : il reçoit une interface `Depot` par le constructeur. En production tu injectes `PdoDepot`, en test un `DepotEnMemoire`. **L'inversion de dépendances est ce qui rend le test possible** — c'est le lien direct entre ce palier (architecture) et le palier 4 (tests). Et tu le faisais déjà à moitié : tu injectais ton dépôt ; il te manquait juste de dépendre de l'**interface**, pas de la classe concrète.

**4.** Le passage d'une cascade de `if` à des classes-stratégies est l'illustration conjointe de O (on ajoute sans modifier) et de D (on dépend de l'interface commune). C'est le patron Strategy (leçon 04). Le bénéfice concret : ajouter un cas ne risque pas de casser les cas existants, car on ne touche pas à leur code.

**6.** La contrepartie honnête : une interface qui n'aura jamais qu'une seule implémentation est une abstraction prématurée. SOLID sert à pouvoir **changer** ; s'il n'y a rien à faire varier, l'abstraction est un coût sans bénéfice. Ce discernement (assez de SOLID, pas trop) est exactement ce qui distingue l'architecte du dogmatique — et c'est le sujet de la leçon 02.
</details>

---

## ✅ Acquis si…

- [ ] Je cite les cinq principes SOLID et je sais que S, O et D sont les plus rentables.
- [ ] Je repère une classe qui viole le SRP (plusieurs raisons de changer) et je la découpe.
- [ ] J'inverse une dépendance derrière une interface et je teste avec un faux (mock).
- [ ] Je remplace une cascade de `if` sur un type par des classes-stratégies (O + D).
- [ ] Je comprends que l'inversion des dépendances est ce qui rend un code testable.
- [ ] Je sais reconnaître la sur-ingénierie (abstraction prématurée) et je l'évite.
- [ ] J'illustre chaque principe prioritaire par un exemple tiré de mon propre code.

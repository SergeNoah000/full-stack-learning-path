# Leçon 03 — PHP 8 moderne : typage, `match`, enums, classes, namespaces

> 🎯 **À la fin de cette leçon** : tu écris du PHP 8 propre et typé, et tu as oublié la mauvaise réputation du langage — parce que tu transfères, encore, ce que tu connais déjà.
> ⏱️ 5 h · **Prérequis** : leçons 01–02, et les paliers 1, 4 et 5 pour les concepts transférés.

---

## De quoi on parle

PHP 8 est un **bon langage moderne**, à des années-lumière du PHP de 2005 qui lui a valu sa réputation. Il a le typage (paramètres, retours, propriétés), les enums, `match`, les arrow functions, les attributs, les propriétés en constructeur — bref, l'outillage qu'on attend d'un langage actuel.

C'est ton **troisième langage**, et comme pour Python (palier 5), tu l'abordes en **transférant** : tu sais programmer, tu connais les concepts backend (palier 4), tu maîtrises deux autres langages. PHP est une syntaxe de plus pour des idées que tu possèdes.

Quelques spécificités : les variables commencent par **`$`** (`$montant`), les **tableaux associatifs** servent à la fois de liste et de dictionnaire, `$this` désigne l'instance (le `self` de Python, le `this` de JavaScript), et les **namespaces** organisent le code (les modules de Python, les imports de JavaScript).

---

## À quoi ça sert, concrètement

**Parce que PHP fait tourner une part énorme du web, et recrute.** WordPress (environ 40 % des sites), Laravel, des millions de sites sur mesure : le volume de travail en PHP est considérable, et les missions (maintenance, freelance, projets locaux) sont accessibles. C'est un argument direct pour le palier 10. Mais pour en profiter, il faut connaître le PHP **moderne**, pas celui des vieux tutoriels.

**Parce que le transfert rend l'apprentissage rapide.** Comme Python, PHP s'apprend vite quand on connaît déjà deux langages : `array_map` est ton `map`, les classes sont celles de Python, `match` est un `switch` amélioré. Tu ne réapprends pas la programmation — tu apprends une syntaxe.

**Parce que le typage de PHP 8 change tout.** Le PHP non typé d'autrefois était source de bugs silencieux. PHP 8 permet de typer les paramètres, les retours et les propriétés — et tu viens de TypeScript et des type hints Python, donc tu sais pourquoi c'est précieux. Un code PHP typé n'a plus grand-chose à voir avec la réputation du langage.

**Et parce que distinguer le PHP moderne du PHP ancien est une compétence.** En mission, tu verras les deux : du code PHP 8 propre, et du code de 2008 avec des `mysql_query` et du HTML mêlé au PHP. Savoir reconnaître et écrire le moderne, tout en sachant lire l'ancien, est exactement ce que demandent les missions de maintenance.

---

## Où ça intervient dans le développement

Le langage est le socle de tout le palier : le MVC maison (leçons 07-10) et Laravel (leçon 11) s'écrivent en PHP 8.

```
   LE LANGAGE PHP 8          ← cette leçon
        ▼
   l'environnement web (superglobales, sessions, PDO)   ← leçons 04-06
        ▼
   le MVC maison (front controller, routeur, modèles)   ← leçons 07-10
        ▼
   Laravel                   ← leçon 11
```

Trois points de transfert.

**Les concepts viennent des paliers précédents.** Les tableaux et leurs fonctions (`array_map`, `array_filter`) sont tes `map`/`filter` du palier 1. Les classes et `$this` sont celles de Python (palier 5, `self`) et de JavaScript (palier 3, `this`). Le typage est celui de TypeScript (palier 3) et des type hints Python (palier 5). Cette leçon est, comme pour Python, une **table de traduction**.

**Le typage prépare un code propre.** Tu as pris le réflexe de typer en TypeScript et en Python ; tu le gardes en PHP 8. C'est ce qui distingue ton code de maintenance (propre, typé) du code ancien que tu croiseras.

**Et `$this` boucle la boucle des trois langages.** JavaScript avait `this` (avec ses pièges, palier 3), Python a `self` (explicite, palier 5), PHP a `$this` (implicite dans les méthodes). Les trois désignent l'instance courante ; les comparer est le genre de synthèse que le parcours construit.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas aller vite, comme pour Python : tu reconnais tout. Les pièges seront les spécificités — le `$` devant chaque variable, l'opérateur de concaténation `.` (et non `+`), les tableaux associatifs qui mélangent liste et dictionnaire.

Tu vas aussi être agréablement surpris : `match`, les enums, le typage, les propriétés en constructeur rendent le PHP 8 bien plus propre que sa réputation.

### En équipe, en entreprise

**Le PHP moderne est typé et outillé.** Les projets sérieux utilisent le typage strict, un formateur (PHP-CS-Fixer), un analyseur statique (PHPStan ou Psalm — l'équivalent de `mypy` et `tsc`), et suivent les standards **PSR** (les conventions de la communauté PHP).

**Tu rencontreras beaucoup de code ancien.** En maintenance, du PHP 5 non typé, du `mysql_query` (déprécié et dangereux), du HTML mêlé au SQL. Savoir le lire **et** le moderniser prudemment est le cœur de ces missions.

**Composer est universel.** La gestion de dépendances (leçon 06) et l'autoloading PSR-4 sont partout. Le PHP sans Composer, c'est l'ancien monde.

**Et le PHP 8 a de vraies performances.** Le JIT, OPcache, les améliorations de la version 8 en font un langage rapide. L'argument « PHP est lent » appartient au passé.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : les variables `$`, les tableaux associatifs et leurs fonctions (`array_map`, `array_filter`, `array_reduce`), les classes typées, `match`, l'opérateur `?->` (chaînage optionnel), `??` (coalescence).

Régulièrement : les enums, les propriétés en constructeur, les namespaces, les interfaces, les arrow functions, `??=`, le *spread* `...`.

Rare, et hors sujet pour l'instant : les traits, les attributs (que tu verras dans Laravel sans en écrire), les générateurs, la réflexion, les closures liées (`bindTo`), les types union/intersection complexes, les fibres (l'async de PHP). Tu les croiseras par besoin.

---

## La mécanique

### Les variables et les types de base

```php
<?php
$nom = "Serge";                    // ⚠️ $ devant chaque variable
$montant = 1500;                   // int
$prix = 15.99;                     // float
$paye = true;                      // bool (minuscule, contrairement à Python)
$rien = null;

// Concaténation : avec le POINT, pas le +
$message = "Total : " . $montant . " FCFA";
// Ou interpolation dans une chaîne à guillemets DOUBLES
$message = "Total : $montant FCFA";
$message = "Total : {$depense['montant']} FCFA";   // accolades pour les expressions
```

Le piège venant de JavaScript et Python : **la concaténation utilise `.`, pas `+`**. En PHP, `+` est réservé à l'addition numérique (`"5" + 3` donne `8`, contrairement à JavaScript). Et l'interpolation ne marche que dans les guillemets **doubles**, pas les simples.

### Les tableaux associatifs : le couteau suisse

```php
<?php
// Un tableau peut être une LISTE...
$montants = [1500, 3000, 500];
$montants[] = 2000;                // ajouter (le push de JS, l'append de Python)
count($montants);                  // 4

// ...ou un DICTIONNAIRE (tableau associatif)
$depense = ["montant" => 1500, "categorie" => "food"];
$depense["montant"];               // 1500
$depense["paye"] = true;           // ajouter
isset($depense["note"]);           // false (teste l'existence)
$depense["note"] ?? "aucune";      // valeur par défaut (?? comme en JS/Python)
```

En PHP, **le même type (`array`) sert de liste et de dictionnaire**. C'est pratique — une seule structure — et piégeux : un tableau « liste » et un tableau « associatif » sont le même type, et `json_encode` les sérialise différemment (tableau JSON ou objet JSON) selon leurs clés. C'est une spécificité à connaître.

### Les fonctions de tableau : tes map/filter/reduce

```php
<?php
// array_map : transformer (⚠️ callback en PREMIER, tableau en SECOND)
$doubles = array_map(fn($n) => $n * 2, $nombres);

// array_filter : sélectionner
$positifs = array_filter($nombres, fn($n) => $n > 0);

// array_reduce : agréger
$total = array_reduce($depenses, fn($acc, $d) => $acc + $d["montant"], 0);

// Somme simple
$total = array_sum(array_column($depenses, "montant"));   // array_column extrait une colonne
```

Tu reconnais le palier 1 (leçon 06) : `array_map` = `map`, `array_filter` = `filter`, `array_reduce` = `reduce`. Deux pièges par rapport à JavaScript : l'ordre des arguments (`array_map(callback, tableau)` — le callback d'abord), et le fait que `array_filter` **conserve les clés** (ce qui peut surprendre). La fonction `fn($x) => ...` est l'arrow function de PHP (l'équivalent des fonctions fléchées du palier 1).

### `match` : le switch amélioré

```php
<?php
// match : comme un switch, mais c'est une EXPRESSION et il compare avec ===
$libelle = match($statut) {
    "brouillon" => "Brouillon",
    "validee", "payee" => "Validée",        // plusieurs valeurs
    default => "Inconnu",
};
```

`match` est le `switch` de JavaScript, en mieux : il retourne une valeur (c'est une expression), il compare avec `===` (pas de conversion), et il n'a pas besoin de `break` (pas de chute dans le cas suivant, le piège du `switch` au palier 1). À utiliser à la place de `switch` dès que possible.

### Les classes typées

```php
<?php
class Portefeuille
{
    public function __construct(
        private int $solde = 0,          // ⭐ propriété promue : déclarée ET assignée
    ) {}

    public function deposer(int $montant): bool
    {
        if ($montant <= 0) {
            return false;
        }
        $this->solde += $montant;        // $this, comme self (Python) / this (JS)
        return true;
    }

    public function lire(): int
    {
        return $this->solde;
    }
}

$p = new Portefeuille(1000);
$p->deposer(500);                        // -> pour accéder aux membres (pas .)
echo $p->lire();                         // 1500
```

Trois points. Les **propriétés promues** (`private int $solde` dans le constructeur) déclarent et assignent en une fois — l'équivalent des dataclasses de Python (palier 5), en plus concis. Le **typage** (`int $montant`, `: bool`) est celui de TypeScript et Python. Et `$this->solde` utilise `->` pour accéder aux membres — là où JavaScript et Python utilisent `.`. `$this` est l'instance courante : le `self` de Python, le `this` de JavaScript.

### Les enums

```php
<?php
enum Statut: string
{
    case Brouillon = "brouillon";
    case Validee = "validee";
    case Payee = "payee";
}

function filtrer(Statut $statut): array { ... }   // ⭐ typé par l'enum
filtrer(Statut::Payee);
```

Les enums de PHP 8 sont l'équivalent des unions de littéraux de TypeScript (palier 3) et des enums Python (palier 5) : un ensemble fermé de valeurs, vérifié par le typage. `filtrer(Statut $statut)` n'accepte que les valeurs de l'enum — plus de faute de frappe sur une chaîne de statut.

### Les namespaces

```php
<?php
// Dans App/Services/DepenseService.php
namespace App\Services;

use App\Models\Depense;              // importer une classe (comme import en JS/Python)

class DepenseService { ... }
```

Les namespaces organisent le code et évitent les conflits de noms. `namespace App\Services` est l'équivalent d'un module Python ou d'un chemin de fichier. `use` importe une classe. Et la correspondance `namespace` ↔ dossier est ce que l'autoloading PSR-4 (leçon 06) exploite pour charger les classes automatiquement.

### Le typage strict et les outils

```php
<?php
declare(strict_types=1);             // ⭐ en TÊTE de fichier : typage strict

function calculer_total(array $depenses): int
{
    return array_sum(array_column($depenses, "montant"));
}
```

```bash
composer require --dev phpstan/phpstan     # l'analyseur statique (comme mypy, tsc)
vendor/bin/phpstan analyse src
```

`declare(strict_types=1)` en tête de fichier active le typage strict : PHP refuse alors de convertir silencieusement (passer une chaîne là où un `int` est attendu lève une erreur). **Mets-le dans chaque fichier** — c'est le réflexe du palier 3 et 5. Et **PHPStan** est l'analyseur statique, l'équivalent de `mypy` (Python) et `tsc` (TypeScript) : il attrape les erreurs de type avant l'exécution.

---

## Les problèmes que tu vas rencontrer

**`+` ne concatène pas mes chaînes.** En PHP, la concaténation est `.` (le point). `+` est l'addition numérique. C'est le piège n°1 venant de JavaScript.

**Mon interpolation `"$montant"` n'affiche pas la valeur.** Tu as utilisé des guillemets **simples** (`'$montant'` affiche littéralement `$montant`). L'interpolation ne marche qu'avec les guillemets doubles.

**`array_map` a inversé mes arguments.** En PHP, c'est `array_map($callback, $tableau)` — le callback d'abord, l'inverse de JavaScript. Et `array_filter($tableau, $callback)` — le tableau d'abord. Les ordres ne sont pas cohérents entre les fonctions de tableau, c'est une bizarrerie de PHP.

**`array_filter` a gardé des clés bizarres.** `array_filter` conserve les clés d'origine, donc le résultat peut avoir des index non consécutifs (`[0 => ..., 2 => ...]`). Utilise `array_values()` pour réindexer si besoin.

**`Undefined array key`.** Tu accèdes à une clé qui n'existe pas. Utilise `isset()` ou `$tableau["cle"] ?? defaut` — comme le `.get()` de Python et le `??` de JavaScript.

**Mon typage ne bloque pas une mauvaise valeur.** Il manque `declare(strict_types=1)` en tête de fichier. Sans lui, PHP convertit silencieusement.

**`->` ou `.` ?** En PHP, on accède aux membres d'objet avec `->` (`$objet->methode()`), pas `.` (qui est la concaténation). C'est déroutant venant de JavaScript et Python.

**Mon namespace ne correspond pas à mon dossier.** L'autoloading PSR-4 (leçon 06) exige que le namespace reflète l'arborescence. Un décalage empêche le chargement de la classe.

---

## Ce qu'on te demandera

En **entretien PHP**, on vérifie que tu connais le PHP **moderne** : « qu'est-ce que `match` apporte par rapport à `switch` ? », « qu'est-ce qu'une propriété promue ? », « à quoi servent les enums ? », « qu'est-ce que `declare(strict_types=1)` ? ». Ces questions distinguent ceux qui connaissent le PHP 8 de ceux qui en sont restés au PHP 5.

Pour ton profil, la question qui porte : **« tu connais JavaScript et Python — qu'est-ce qui te surprend en PHP ? »**. Une bonne réponse parle des spécificités (`$`, `.` pour concaténer, les tableaux qui mélangent liste et dictionnaire, l'ordre des arguments de `array_map`) et reconnaît que les concepts sont les mêmes.

En **test technique**, du PHP 8 typé et propre (avec `match`, enums, strict_types) est valorisé face à du PHP non typé.

---

## Ce qui te démarquera

**Écrire du PHP 8 typé avec `strict_types` et PHPStan.** Venant de TypeScript et Python, c'est un réflexe naturel pour toi, et il te distingue de beaucoup de développeurs PHP qui ne typent pas.

**Utiliser `match` plutôt que `switch`.** C'est le marqueur d'un développeur à jour sur PHP 8.

**Reconnaître que tu transfères.** « `array_map` c'est mon `map`, `$this` c'est le `self` de Python, les enums ce sont les unions de TypeScript » montre une vraie compréhension transversale.

**Savoir lire l'ancien et écrire le moderne.** En maintenance, pouvoir dire « ce `mysql_query` est déprécié et vulnérable, je le remplace par PDO » est exactement ce qu'on attend.

**Et défendre PHP avec des arguments.** Pas « PHP c'est bien », mais « PHP 8 a le typage, les enums, le JIT, et Laravel est un excellent framework — la réputation vient du PHP de 2005 ».

---

## 📚 À lire

**php.net** : la référence absolue, et ses commentaires d'utilisateurs sont précieux. Consulte chaque fonction que tu utilises.

**phptherightway.com** : **à lire en priorité**. C'est le guide qui montre ce qu'est le PHP moderne, contre les vieux tutoriels. Il te fera gagner un temps considérable.

**php.net → *Language Reference*** pour les enums, `match`, les propriétés promues, les namespaces.

**Les standards PSR** (php-fig.org), notamment PSR-12 (style de code) : les conventions de la communauté, que ton formateur applique.

Et la documentation de **PHPStan** pour l'analyse statique.

---

## 🤖 Le mini-projet à demander à l'IA

Le transfert, comme pour Python :

> « Je suis en formation de développeur, palier 6. Je connais bien JavaScript, TypeScript et Python, et j'apprends PHP 8. Donne-moi une **table de traduction** sous forme de quiz : montre-moi 15 constructions que j'utilise couramment (déclaration de variable, concaténation, map/filter/reduce, classe, typage, enum, switch, chaînage optionnel, valeur par défaut, module/import), et je dois écrire l'équivalent PHP 8. Corrige en pointant les pièges spécifiques à PHP (le `.` pour concaténer, le `$`, l'ordre des arguments de array_map, le `->`, les guillemets pour l'interpolation) et ce qui n'est **pas** du PHP moderne (du PHP 5 déguisé). »

Puis la modernisation, qui prépare les missions de maintenance :

> « Donne-moi un script PHP écrit à l'ancienne (PHP 5 : pas de typage, `mysql_query`, concaténation partout, HTML mêlé au code, pas de classes). Sans me donner la solution, demande-moi de le moderniser en PHP 8 (typage strict, `match`, PDO, séparation du HTML). Ensuite, compare ma version à ce que tu attendais et dis-moi ce qui n'est pas encore idiomatique. »

---

## 🛠️ À faire

1. **Les bases** : variables, concaténation avec `.`, interpolation dans des guillemets doubles. Teste `"5" + 3` et constate que PHP additionne (contrairement à JavaScript).
2. **Tableaux associatifs** : crée une liste de dépenses (tableaux associatifs), accède aux clés, ajoute un élément, teste l'existence avec `isset` et `??`.
3. **Le transfert map/filter/reduce** : réécris en PHP, avec `array_map`, `array_filter`, `array_reduce`, des fonctions que tu as faites au palier 1 et 5. Attention à l'ordre des arguments.
4. **Le piège de `array_filter`** : filtre un tableau, constate que les clés ne sont pas réindexées, et corrige avec `array_values`.
5. **`match`** : écris un `match` qui transforme un statut en libellé, avec plusieurs valeurs par cas. Compare avec le `switch` (et son piège du `break`) du palier 1.
6. **Une classe typée** : `Portefeuille` avec propriété promue, typage, et `$this`. Note la correspondance `$this` / `self` / `this`.
7. **Un enum** : `Statut` avec trois valeurs, utilisé pour typer une fonction. Compare avec les unions de TypeScript et les enums Python.
8. **Namespaces** : organise deux classes dans des namespaces (`App\Models`, `App\Services`), et importe l'une dans l'autre avec `use`.
9. **Typage strict** : ajoute `declare(strict_types=1)`, passe une chaîne à une fonction attendant un `int`, et constate l'erreur. Installe PHPStan et analyse ton code.
10. **La comparaison** : note dans ton journal les trois spécificités PHP qui t'ont le plus surpris, et la correspondance des concepts avec JS/Python/TS.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** `"5" + 3` donne `8` en PHP (conversion numérique pour l'addition), là où JavaScript donnait `"53"` (concaténation). En PHP, la concaténation est **toujours** `.`, jamais `+`. C'est le piège le plus fréquent venant de JavaScript, et il est sournois parce que le code « marche » mais donne un mauvais résultat.

**3.** Les pièges : `array_map(fn($x) => ..., $tableau)` a le callback **en premier**, mais `array_filter($tableau, fn($x) => ...)` a le tableau en premier — les ordres sont incohérents, c'est une bizarrerie historique de PHP. Et `array_reduce($tableau, $callback, $initial)` prend la valeur initiale en troisième. Garde php.net ouvert pour vérifier l'ordre.

**4.** `array_filter` conserve les clés d'origine : filtrer `[0=>1, 1=>2, 2=>3]` pour garder les pairs donne `[1=>2]` — avec la clé `1`, pas `0`. Si tu as besoin d'un tableau réindexé (par exemple pour `json_encode` qui produirait sinon un objet au lieu d'un tableau), utilise `array_values(array_filter(...))`. C'est un piège subtil et fréquent.

**9.** Sans `declare(strict_types=1)`, PHP convertit silencieusement une chaîne `"5"` en `int` 5 — le bug silencieux de l'ancien PHP. Avec, il lève une `TypeError`. **Mets `declare(strict_types=1)` dans chaque fichier** : c'est le réflexe du typage que tu as pris en TypeScript et Python, et il transforme PHP en langage sûr. PHPStan va plus loin en analysant tout ton code avant l'exécution, comme `mypy` et `tsc`.
</details>

---

## ✅ Acquis si…

- [ ] J'écris du PHP 8 avec variables `$`, concaténation `.`, et interpolation dans les guillemets doubles.
- [ ] Je sais que `"5" + 3` additionne en PHP, contrairement à JavaScript.
- [ ] Je manipule les tableaux associatifs (liste ET dictionnaire), avec `isset` et `??`.
- [ ] J'utilise `array_map`, `array_filter`, `array_reduce`, en connaissant leurs pièges d'arguments.
- [ ] J'utilise `match` plutôt que `switch`, et je sais pourquoi.
- [ ] J'écris des classes typées avec propriétés promues et `$this`.
- [ ] J'utilise les enums pour les ensembles fermés de valeurs.
- [ ] J'organise mon code en namespaces avec `use`.
- [ ] Je mets `declare(strict_types=1)` partout, et j'utilise PHPStan.
- [ ] Je reconnais les concepts transférés de JS, TS et Python, et les spécificités de PHP.

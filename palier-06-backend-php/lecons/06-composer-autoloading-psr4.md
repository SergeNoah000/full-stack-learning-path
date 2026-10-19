# Leçon 06 — Composer et l'autoloading PSR-4

> 🎯 **À la fin de cette leçon** : tu gères les dépendances PHP avec Composer et tu charges tes classes automatiquement en PSR-4 — le `npm` et les `import` de PHP, que tu connais déjà par transfert.
> ⏱️ 3 h · **Prérequis** : leçon 03 (classes, namespaces), et le palier 4 leçon 02 (npm).

---

## De quoi on parle

**Composer** est le gestionnaire de dépendances de PHP. C'est le `npm` de PHP (palier 4, leçon 02) : un fichier `composer.json` qui déclare les paquets dont ton projet a besoin, une commande `composer install` qui les télécharge dans `vendor/`, un `composer.lock` qui fige les versions exactes.

```bash
composer require monolog/monolog      # ajoute une dépendance
composer install                       # installe tout ce que composer.json déclare
```

**L'autoloading PSR-4** est le mécanisme qui charge automatiquement tes classes quand tu les utilises, sans écrire un seul `require`. Tu déclares une correspondance entre un namespace (`App\`) et un dossier (`src/`), et PHP trouve `App\Models\DepotDepenses` dans `src/Models/DepotDepenses.php` tout seul.

C'est l'équivalent des `import` automatiques de Node et des modules Python (palier 5, leçon 03) : un fichier = une classe, trouvée par son nom.

---

## À quoi ça sert, concrètement

**Parce que personne ne réécrit tout à la main.** Avant Composer (jusque vers 2012), on téléchargeait les bibliothèques manuellement et on les chargeait avec des dizaines de `require`. Composer a transformé PHP : aujourd'hui, tout projet sérieux (Laravel compris) repose dessus. Sans Composer, pas de PHP moderne.

**Parce que l'autoloading rend ton code organisable.** Sans PSR-4, chaque fichier devrait charger manuellement toutes les classes qu'il utilise — un enfer de `require` en cascade. Avec PSR-4, tu écris `use App\Models\DepotDepenses;` et c'est tout. C'est ce qui rend ton MVC maison (leçons 07-10) propre et modulaire.

**Parce que c'est la norme partagée.** PSR-4 est un standard (*PHP Standard Recommendation*) suivi par tout l'écosystème. Un développeur PHP qui arrive sur ton projet sait immédiatement où trouver la classe `App\Controllers\DepensesController` : dans `src/Controllers/DepensesController.php`. La convention remplace la documentation.

**Et parce que `composer.lock` garantit la reproductibilité.** Comme `package-lock.json` (palier 4) et `requirements.txt`/`poetry.lock` (palier 5), le `.lock` fige les versions exactes pour que tous les environnements (ta machine, celle d'un collègue, le serveur) aient exactement les mêmes.

---

## Où ça intervient dans le développement

Composer est l'infrastructure sur laquelle repose ton projet PHP :

```
   composer.json        ← ce dont ton projet a besoin (toi)
        ▼
   composer install
        ▼
   vendor/              ← les dépendances téléchargées (jamais versionné)
   vendor/autoload.php  ← LE fichier à inclure une fois, en tête
        ▼
   autoloading PSR-4    ← tes classes + celles des dépendances, chargées à la demande
```

Trois transferts directs.

**C'est le npm du palier 4.** `composer.json` ↔ `package.json`, `composer install` ↔ `npm install`, `vendor/` ↔ `node_modules/`, `composer.lock` ↔ `package-lock.json`. Les versions sémantiques (`^3.0`) sont les mêmes. Tu ne réapprends pas la gestion de dépendances — tu la retrouves avec d'autres noms.

**C'est les imports du palier 5.** L'autoloading PSR-4 remplit le rôle des `import` Python (palier 5, leçon 03) et des `import`/`require` Node : charger du code d'un autre fichier par son nom. La différence, c'est qu'en PHP c'est **automatique** une fois PSR-4 configuré — tu n'écris pas d'`import`, juste `use`.

**Et c'est le socle de tes leçons 07-11.** Ton front controller (leçon 07), ton routeur (leçon 08), tes contrôleurs (leçon 09) seront des classes chargées par PSR-4. Laravel (leçon 11) est entièrement construit sur Composer et PSR-4. Cette leçon prépare tout le reste du palier.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas initialiser un projet avec `composer init`, configurer l'autoloading PSR-4 pour ton namespace `App\`, inclure `vendor/autoload.php` une seule fois, et constater que tes classes se chargent sans aucun `require`. Tu ajouteras une vraie dépendance (par exemple une bibliothèque de logs) pour voir le cycle complet.

### En équipe, en entreprise

**Tout projet PHP a un `composer.json`.** C'est la première chose que tu regardes en arrivant : quelles dépendances, quelle version de PHP, quel namespace. `composer install` est la première commande que tu lances.

**`vendor/` n'est jamais versionné.** Comme `node_modules/`, il est dans le `.gitignore` (palier 0, leçon 04). On versionne `composer.json` et `composer.lock`, jamais les dépendances elles-mêmes — on les réinstalle avec `composer install`.

**`composer install` vs `composer update`.** `install` respecte le `.lock` (versions figées) — c'est ce qu'on fait au déploiement et en arrivant sur un projet. `update` recalcule les versions et met à jour le `.lock` — c'est une décision, pas une routine. Confondre les deux casse la reproductibilité.

**Packagist est le registre.** Comme npmjs.com, packagist.org liste les paquets PHP disponibles. `composer require vendor/paquet` y pioche.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : `composer require`, `composer install`, la configuration `autoload` PSR-4, `use` pour importer une classe, `require 'vendor/autoload.php'` une fois en tête.

Régulièrement : `composer update` (avec prudence), `composer dump-autoload` (régénérer l'autoloader après avoir ajouté des classes), les scripts Composer, les dépendances de développement (`require-dev`).

Rare : créer et publier son propre paquet sur Packagist, les dépôts privés, les plugins Composer, l'autoloading classmap. Tu les verras par besoin.

---

## La mécanique

### Initialiser un projet

```bash
composer init        # répond aux questions : nom, description, dépendances...
```

Cela crée un `composer.json` :

```json
{
    "name": "moi/gestion-depenses",
    "require": {
        "php": ">=8.1"
    },
    "autoload": {
        "psr-4": {
            "App\\": "src/"
        }
    }
}
```

Le bloc clé est `autoload` : il dit « le namespace `App\` correspond au dossier `src/` ». Note le double antislash `App\\` (échappement JSON) et le slash final `src/`.

### ⭐ Générer et inclure l'autoloader

```bash
composer dump-autoload        # génère vendor/autoload.php à partir de la config
```

```php
<?php
require __DIR__ . '/vendor/autoload.php';    // UNE SEULE FOIS, en tête du point d'entrée

use App\Models\DepotDepenses;

$depot = new DepotDepenses($pdo);             // la classe est trouvée et chargée toute seule
```

Une seule ligne, dans ton point d'entrée (`public/index.php`, leçon 07), charge l'autoloader. Ensuite, toute classe `App\...` est trouvée automatiquement : `App\Models\DepotDepenses` → `src/Models/DepotDepenses.php`. Tu n'écris plus jamais `require` pour tes propres classes.

### La correspondance PSR-4, concrètement

```
Namespace                          Fichier
App\Models\DepotDepenses       →   src/Models/DepotDepenses.php
App\Controllers\HomeController →   src/Controllers/HomeController.php
App\Core\Routeur               →   src/Core/Routeur.php
```

La règle : le préfixe `App\` est remplacé par `src/`, chaque `\` devient `/`, et on ajoute `.php`. Le nom du fichier doit correspondre **exactement** au nom de la classe, casse comprise. C'est pour ça qu'on nomme une classe par fichier, avec le même nom.

### Ajouter une dépendance

```bash
composer require monolog/monolog        # ajoute à composer.json ET installe
```

```php
<?php
require __DIR__ . '/vendor/autoload.php';

use Monolog\Logger;
use Monolog\Handler\StreamHandler;

$log = new Logger('app');
$log->pushHandler(new StreamHandler('app.log'));
$log->warning('Quelque chose à signaler');
```

`composer require` ajoute la ligne dans `composer.json`, télécharge le paquet dans `vendor/`, et met à jour `composer.lock`. La classe `Monolog\Logger` est immédiatement disponible par le même autoloader — les dépendances suivent aussi PSR-4.

### Dépendances de développement

```bash
composer require --dev phpunit/phpunit       # seulement pour développer/tester
```

Les outils qui ne servent qu'en développement (PHPUnit pour les tests, outils d'analyse) vont dans `require-dev`. En production, on fait `composer install --no-dev` pour ne pas les installer — comme les `devDependencies` de npm (palier 4).

### Le `.gitignore`

```gitignore
/vendor/
```

`vendor/` ne se versionne jamais (il peut peser des centaines de Mo et se reconstruit avec `composer install`). On versionne `composer.json` (ce qu'on veut) et `composer.lock` (les versions exactes). C'est le même principe que `node_modules/` au palier 4.

---

## Les problèmes que tu vas rencontrer

**`Class "App\Models\DepotDepenses" not found`.** Le cas numéro un. Causes possibles : tu n'as pas inclus `vendor/autoload.php` ; le nom du fichier ne correspond pas exactement à la classe (casse !) ; le namespace déclaré dans le fichier ne correspond pas à son emplacement ; tu as ajouté une classe sans refaire `composer dump-autoload`.

**J'ai ajouté une classe et elle n'est pas trouvée.** Lance `composer dump-autoload` pour régénérer l'autoloader. (En développement, l'autoloader PSR-4 trouve souvent les nouvelles classes sans ça, mais en cas de doute, régénère.)

**La casse du nom de fichier.** Sur Windows/Mac le système de fichiers ignore souvent la casse, mais le serveur Linux de production ne pardonne pas : `depotdepenses.php` ≠ `DepotDepenses.php`. Ça « marche sur ma machine » et casse en production. Nomme toujours le fichier exactement comme la classe.

**`composer: command not found`.** Composer n'est pas installé globalement. Installe-le (getcomposer.org) ou utilise le `composer.phar` local.

**Conflit de versions.** Deux dépendances exigent des versions incompatibles d'une troisième. Composer refuse et explique. Comme au palier 4, c'est le prix de l'écosystème ; lis le message, il indique le conflit.

**J'ai fait `composer update` et tout a bougé.** `update` met à jour toutes les versions dans les limites de `composer.json` et réécrit le `.lock`. Si tu voulais juste installer, c'était `composer install`. En équipe, `update` est une décision.

---

## Ce qu'on te demandera

En **entretien PHP**, on vérifie que tu connais Composer : « à quoi sert `composer.json` ? », « différence entre `install` et `update` ? », « qu'est-ce que l'autoloading PSR-4 ? », « versionne-t-on `vendor/` ? ». Les réponses sont le transfert direct de npm (palier 4).

On peut demander : « comment une classe est-elle trouvée sans `require` ? » — la correspondance namespace→dossier de PSR-4.

En **mission**, savoir lire un `composer.json` pour comprendre les dépendances et la version de PHP d'un projet existant est un réflexe quotidien.

---

## Ce qui te démarquera

**Faire le lien avec npm et pip.** Dire « Composer, c'est npm pour PHP ; `vendor/` c'est `node_modules/` ; le `.lock` fige les versions comme `package-lock.json` » montre que tu as compris le concept de gestionnaire de dépendances, universel, pas un outil isolé.

**Configurer PSR-4 proprement.** Un namespace racine `App\` → `src/`, une classe par fichier nommé exactement, est la base d'un projet PHP organisé. Beaucoup de projets anciens ne l'ont pas et sont illisibles.

**Distinguer `install` et `update`.** Savoir qu'on ne lance jamais `composer update` à la légère en équipe, et qu'on déploie avec `composer install --no-dev`, montre une compréhension de la reproductibilité et du déploiement.

**Et comprendre que PSR-4 est une convention partagée.** Pouvoir trouver n'importe quelle classe par son nom, sans documentation, parce que tout l'écosystème suit le même standard — c'est ce qui rend PHP moderne lisible.

---

## 📚 À lire

**getcomposer.org → *Getting Started*** et ***Basic usage*** : la référence officielle, claire et courte.

**php-fig.org → *PSR-4: Autoloader*** : le standard lui-même, étonnamment lisible — la règle de correspondance namespace→fichier en une page.

**packagist.org** : parcours le registre pour voir ce qui existe (logs, dates, HTTP, tests).

Relis le palier 4, leçon 02 (npm) : tout se transfère, seuls les noms changent.

---

## 🤖 Le mini-projet à demander à l'IA

Le transfert depuis npm, et la configuration PSR-4 :

> « Je suis en formation de développeur, palier 6. Je connais npm (package.json, node_modules, package-lock.json) depuis le palier 4. Je découvre Composer en PHP. Sans me donner les commandes toutes faites, guide-moi par questions pour que je fasse le parallèle moi-même : qu'est-ce qui correspond à package.json ? à node_modules ? à package-lock.json ? Puis aide-moi à configurer l'autoloading PSR-4 pour un namespace App\\ pointant sur src/, et explique-moi la règle de correspondance entre le nom d'une classe et son fichier. »

Puis, pour ancrer PSR-4 :

> « Donne-moi 5 noms de classes avec namespace (comme App\\Controllers\\HomeController) et demande-moi, pour chacune, dans quel fichier PSR-4 ira la chercher. Corrige-moi. Puis fais l'inverse : donne-moi des chemins de fichiers et demande-moi le nom complet de la classe attendue. »

---

## 🛠️ À faire

1. **Installe Composer** (globalement, via getcomposer.org) et vérifie avec `composer --version`.
2. **`composer init`** : crée un projet `gestion-depenses`, exige PHP >= 8.1.
3. **⭐ Configure PSR-4** : ajoute le bloc `autoload` avec `App\\` → `src/`, puis `composer dump-autoload`.
4. **Une classe chargée automatiquement** : crée `src/Models/DepotDepenses.php` avec `namespace App\Models;` et la classe `DepotDepenses`. Dans un `index.php`, inclus `vendor/autoload.php`, fais `use App\Models\DepotDepenses;` et instancie-la — sans aucun `require` de ta classe.
5. **Casse volontairement la correspondance** : renomme le fichier en `depotdepenses.php` (minuscule) ou change le namespace, et observe l'erreur « Class not found ». Comprends pourquoi, puis répare.
6. **Ajoute une vraie dépendance** : `composer require monolog/monolog`, et écris une ligne de log. Observe qu'elle est aussi chargée par PSR-4.
7. **Une dépendance de dev** : `composer require --dev phpunit/phpunit`, et constate la section `require-dev` séparée.
8. **Le `.gitignore`** : ajoute `/vendor/`, et vérifie avec `git status` que `vendor/` est ignoré mais que `composer.json` et `composer.lock` sont suivis.
9. **Le lien** : note dans ton journal les correspondances Composer ↔ npm ↔ pip, dépendance par dépendance.

<details>
<summary>Corrections et points de contrôle</summary>

**3-4.** Le cœur de la leçon : une fois PSR-4 configuré et `vendor/autoload.php` inclus **une seule fois**, toute classe `App\...` est trouvée par la correspondance namespace→dossier. Tu n'écris plus jamais `require` pour tes classes. C'est exactement ce qui rend ton MVC maison (leçons 07-10) propre — chaque contrôleur, modèle, vue est une classe trouvée par son nom.

**5.** L'erreur « Class not found » vient presque toujours d'une des trois causes : fichier mal nommé (casse !), namespace qui ne correspond pas à l'emplacement, ou `vendor/autoload.php` non inclus. La casse est le piège vicieux : ça marche sur Mac/Windows et casse sur le serveur Linux. **Nomme toujours le fichier exactement comme la classe.**

**8.** `vendor/` ne se versionne jamais — comme `node_modules/`. On versionne `composer.json` (l'intention) et `composer.lock` (les versions exactes), et on reconstruit `vendor/` avec `composer install`. C'est le même modèle qu'au palier 4.

**9.** Les correspondances : `composer.json` ↔ `package.json` ↔ `pyproject.toml`/`requirements.txt` ; `vendor/` ↔ `node_modules/` ↔ `.venv`/`site-packages` ; `composer.lock` ↔ `package-lock.json` ↔ `poetry.lock` ; `composer require` ↔ `npm install` ↔ `pip install`. **La gestion de dépendances est un concept universel** — tu l'as rencontré dans trois écosystèmes, et c'est un excellent point à faire en entretien.
</details>

---

## ✅ Acquis si…

- [ ] J'initialise un projet avec `composer init` et je lis un `composer.json`.
- [ ] Je configure l'autoloading PSR-4 (`App\` → `src/`).
- [ ] J'inclus `vendor/autoload.php` une seule fois et mes classes se chargent sans `require`.
- [ ] Je sais que le fichier doit être nommé exactement comme la classe (casse comprise).
- [ ] J'ajoute une dépendance avec `composer require` et une dépendance de dev avec `--dev`.
- [ ] Je ne versionne jamais `vendor/`, mais je versionne `composer.json` et `composer.lock`.
- [ ] Je connais la différence entre `composer install` et `composer update`.
- [ ] Je fais le lien entre Composer, npm et pip : même concept, noms différents.

# Leçon 09 — Contrôleurs, modèles, vues et échappement systématique

> 🎯 **À la fin de cette leçon** : tu assembles ton MVC maison — le routeur appelle un contrôleur, qui parle à un modèle et rend une vue — et tu échappes **toute** sortie HTML, pour la troisième fois du parcours (XSS).
> ⏱️ 6 h · **Prérequis** : leçons 05 (PDO), 06 (autoload), 08 (routeur), et le palier 4 leçon 09 (XSS).

---

## De quoi on parle

**MVC** (*Modèle-Vue-Contrôleur*) est le patron qui sépare une application web en trois responsabilités :

- le **modèle** parle à la base de données (ton `DepotDepenses` en PDO, leçon 05) ;
- la **vue** produit le HTML envoyé au navigateur ;
- le **contrôleur** reçoit la requête (via le routeur, leçon 08), appelle le modèle, choisit la vue et lui passe les données.

```
   Routeur → Contrôleur → Modèle (PDO) → base
                 │
                 └──→ Vue (HTML, données ÉCHAPPÉES)
```

Et l'**échappement** est la règle de sécurité de cette leçon : **toute** donnée affichée dans le HTML doit passer par `htmlspecialchars()`, sinon c'est une faille XSS (palier 4, leçon 09). C'est le même principe que `textContent` du DOM (palier 2) et l'échappement automatique de React (palier 3) : une donnée affichée n'est jamais du code.

C'est l'aboutissement du module : tu assembles tout ce que tu as construit (PDO, autoload, routeur) en une architecture propre — celle que Laravel (leçon 11) te donnera toute faite.

---

## À quoi ça sert, concrètement

**Parce que mélanger SQL, logique et HTML est ingérable.** Le point d'attention de ce palier le disait : le module commence par un livre d'or « à l'ancienne », un fichier avec le SQL, la logique et le HTML entremêlés. Ça marche à cinq lignes et devient un cauchemar à cinquante. MVC sépare les trois : chaque partie a un seul rôle, se lit seule, se teste seule.

**Parce que c'est l'architecture universelle du web.** MVC (ou ses variantes) structure Rails, Django, Laravel, Spring, ASP.NET. Tu l'as déjà vu en pièces détachées : routes + contrôleurs (palier 4), couche Repository (paliers 4 et 5), templates (Flask/Jinja, palier 5). Ici, tu assembles l'ensemble. Le reconnaître partout est une compétence de fond.

**Parce que l'échappement est non négociable.** Afficher une donnée utilisateur sans l'échapper, c'est ouvrir une faille XSS — la troisième fois que tu rencontres ce principe (DOM au palier 2, React au palier 3, OWASP au palier 4). En PHP, rien n'échappe automatiquement : c'est **à toi** de le faire, systématiquement. C'est la différence la plus dangereuse avec React, qui échappe par défaut.

**Et parce que la séparation rend le code testable et évolutif.** Un contrôleur fin, un modèle isolé, une vue sans logique : chaque couche se remplace sans toucher les autres. Passer de ton moteur de vues maison à Blade (leçon 11), ou de PDO à Eloquent, ne casse pas le reste.

---

## Où ça intervient dans le développement

MVC est l'ossature de toute l'application, et le point de convergence du module :

```
   Routeur (leçon 08)
        ▼
   CONTRÔLEUR  ← reçoit la requête, orchestre (fin !)
    ├──→ MODÈLE / Repository (PDO, leçon 05) ──→ base
    └──→ VUE  ← produit le HTML, ÉCHAPPE tout  ──→ navigateur
```

Tout ce que tu as construit converge ici.

**Le modèle, c'est ta leçon 05.** Le `DepotDepenses` en PDO, pattern Repository, est le M de MVC. Tu l'as déjà écrit ; ici, tu le branches au contrôleur. Même couche qu'aux paliers 4 et 5.

**Le contrôleur, c'est l'action appelée par le routeur (leçon 08).** `[DepensesController::class, 'show']` : le routeur instancie ce contrôleur et appelle `show($params)`. Le contrôleur orchestre — il ne contient ni SQL (c'est le modèle) ni HTML (c'est la vue).

**La vue, c'est le template de Flask (palier 5), échappement en plus.** Tu as rendu des templates Jinja au palier 5 ; ici, tu fais pareil avec du PHP (`<?= ... ?>`), mais **sans** l'échappement automatique de Jinja — tu dois appeler `htmlspecialchars` toi-même. Et l'échappement est celui des paliers 2 (DOM) et 3 (React), troisième passage.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire un contrôleur (`index`, `show`, `store`), le brancher au routeur et au modèle PDO, créer un petit moteur de vues (une fonction qui charge un fichier de template en lui passant des données), et surtout **échapper systématiquement** toute donnée affichée. Tu reproduiras, en cadre défensif, une XSS sur une vue non échappée, puis tu la fermeras.

### En équipe, en entreprise

**MVC est l'architecture attendue.** Un projet PHP professionnel sépare contrôleurs, modèles et vues (souvent via Laravel). Un contrôleur qui contient du SQL ou du HTML est signalé en revue. On attend des contrôleurs **fins** : ils orchestrent, ils ne font pas le travail.

**L'échappement est audité.** Toute sortie non échappée est une faille XSS potentielle, repérée en revue et par les analyseurs. Les frameworks modernes (Blade, Twig) échappent par défaut — mais en PHP natif et sur les vieux sites, c'est manuel, et c'est là que les failles se logent.

**Tu verras surtout des vues de framework.** Blade (Laravel), Twig (Symfony) : la logique est la même que ton moteur maison, avec l'échappement automatique et une syntaxe dédiée. L'avoir fait à la main te rend ces moteurs immédiatement lisibles.

**Et tu feras de la maintenance de sites non-MVC.** Le gros des missions PHP : des sites « à l'ancienne » à comprendre, corriger, parfois migrer vers une structure MVC. Savoir ce qu'est le bon modèle te permet de diagnostiquer le mauvais.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : la séparation contrôleur/modèle/vue, le contrôleur fin, le passage de données à la vue, et — tous les jours, sans exception — `htmlspecialchars` sur chaque sortie.

Régulièrement : les layouts (une page maîtresse avec un contenu inséré), les vues partielles, les données partagées à toutes les vues, la redirection après POST (*PRG*, Post-Redirect-Get).

Rare, car le framework s'en charge : écrire son propre moteur de vues avec héritage de templates, la compilation de templates, le cache de vues. Tu le fais en version minimale ici, pour comprendre Blade ensuite.

---

## La mécanique

### Le contrôleur : fin, il orchestre

```php
<?php
namespace App\Controllers;

use App\Models\DepotDepenses;
use App\Core\Vue;

class DepensesController
{
    public function __construct(private DepotDepenses $depot) {}

    public function index(array $params): void
    {
        $depenses = $this->depot->lister();          // le MODÈLE fait le travail
        Vue::rendre('depenses/index', ['depenses' => $depenses]);  // la VUE affiche
    }

    public function show(array $params): void
    {
        $depense = $this->depot->parId((int) $params['id']);
        if ($depense === null) {
            http_response_code(404);
            Vue::rendre('erreurs/404');
            return;
        }
        Vue::rendre('depenses/show', ['depense' => $depense]);
    }

    public function store(array $params): void
    {
        // validation des entrées (voir plus bas), puis :
        $this->depot->creer($_POST);
        header('Location: /depenses');                 // PRG : on redirige après POST
        exit;
    }
}
```

Regarde comme le contrôleur est **court** : il ne contient aucun SQL (délégué au modèle) ni aucun HTML (délégué à la vue). Il orchestre — prend la requête, appelle le modèle, choisit la vue. C'est la définition du « contrôleur fin » (*thin controller*). Le `store` finit par une **redirection** (PRG) : après un POST réussi, on redirige en GET pour qu'un rafraîchissement ne re-soumette pas le formulaire.

### Le modèle : c'est la leçon 05

```php
<?php
// src/Models/DepotDepenses.php  — déjà écrit à la leçon 05
// Pattern Repository, PDO, requêtes PRÉPARÉES. Le M de MVC.
```

Le modèle est le `DepotDepenses` de la leçon 05 : toutes les requêtes, préparées, à un seul endroit. Le contrôleur l'appelle sans voir une ligne de SQL. Rien de neuf — juste le branchement.

### Un moteur de vues minimal

```php
<?php
namespace App\Core;

class Vue
{
    public static function rendre(string $nom, array $donnees = []): void
    {
        extract($donnees);                           // $donnees['depenses'] → $depenses
        require __DIR__ . "/../Views/{$nom}.php";    // on exécute le template
    }
}
```

Le moteur est une dizaine de lignes : `extract` transforme le tableau de données en variables (`['depenses' => ...]` devient `$depenses`), puis `require` exécute le fichier de template, qui a accès à ces variables. C'est, en minuscule, ce que font Blade et Twig.

### ⭐ La vue : du HTML, et l'échappement de TOUTE donnée

```php
<?php // src/Views/depenses/index.php ?>
<h1>Mes dépenses</h1>
<ul>
<?php foreach ($depenses as $d): ?>
    <li>
        <?= htmlspecialchars($d['description']) ?> —
        <?= htmlspecialchars($d['montant']) ?> €
        (<?= htmlspecialchars($d['categorie']) ?>)
    </li>
<?php endforeach; ?>
</ul>
```

Le point de sécurité central : **chaque** donnée affichée passe par `htmlspecialchars()`. Si `description` contient `<script>...`, `htmlspecialchars` le transforme en texte inoffensif (`&lt;script&gt;...`) au lieu de l'exécuter. Sans ça, c'est une faille XSS — exactement celle du palier 4 (leçon 09).

Pour s'en souvenir et ne jamais l'oublier, on se donne un raccourci :

```php
<?php
function e(string $v): string { return htmlspecialchars($v, ENT_QUOTES, 'UTF-8'); }
// Puis dans les vues : <?= e($d['description']) ?>
```

`ENT_QUOTES` échappe aussi les apostrophes et guillemets (important dans les attributs HTML), et `'UTF-8'` fixe l'encodage. Un helper `e()` court rend l'échappement systématique indolore — il n'y a plus d'excuse pour l'oublier.

### Le contraste : la vue dangereuse

```php
<?php // ❌ NE JAMAIS FAIRE : donnée affichée telle quelle ?>
<li><?= $d['description'] ?></li>
```

Si `description` vaut `<script>document.location='...'</script>`, ce script **s'exécute** dans le navigateur de chaque visiteur. C'est une XSS stockée. La différence avec la version sûre est un seul appel de fonction — mais c'est toute la différence entre un site sain et un site vulnérable.

### Un layout (page maîtresse)

```php
<?php // src/Views/layout.php ?>
<!DOCTYPE html>
<html lang="fr">
<head><meta charset="utf-8"><title><?= e($titre ?? 'App') ?></title></head>
<body>
    <?= $contenu ?>      <!-- le contenu déjà rendu, HTML voulu -->
</body>
</html>
```

Un layout évite de répéter l'en-tête HTML dans chaque vue : la vue produit son contenu, le layout l'enveloppe. Ici `$contenu` est du HTML déjà construit (pas une donnée brute), donc il n'est pas échappé — mais tout ce qui vient de l'utilisateur, dans la vue qui a produit `$contenu`, l'était.

### La validation des entrées (avant d'écrire)

```php
<?php
// dans store(), avant d'appeler le modèle
$erreurs = [];
$montant = filter_input(INPUT_POST, 'montant', FILTER_VALIDATE_FLOAT);
if ($montant === false || $montant <= 0) {
    $erreurs['montant'] = 'Montant invalide';
}
if (trim($_POST['description'] ?? '') === '') {
    $erreurs['description'] = 'Description obligatoire';
}
if ($erreurs) {
    Vue::rendre('depenses/nouveau', ['erreurs' => $erreurs, 'ancien' => $_POST]);
    return;
}
```

Valider **en entrée** (côté serveur, jamais seulement côté client — palier 4, leçon 09) complète l'échappement **en sortie**. Les deux sont nécessaires : la validation refuse les données aberrantes à l'arrivée, l'échappement neutralise ce qui est affiché. Deux portes, deux rôles.

---

## Les problèmes que tu vas rencontrer

**Mon `<script>` saisi s'exécute.** Tu as oublié d'échapper une sortie. Toute donnée affichée doit passer par `htmlspecialchars`/`e()`. C'est une XSS — corrige immédiatement.

**Mes accents s'affichent en `Ã©`.** Problème d'encodage : passe `'UTF-8'` à `htmlspecialchars`, et vérifie que la page déclare `<meta charset="utf-8">` et que la base est en `utf8mb4` (leçon 05).

**Mon contrôleur grossit démesurément.** Il fait le travail du modèle (SQL) ou de la vue (HTML). Déplace le SQL dans le modèle, le HTML dans la vue. Le contrôleur doit rester court.

**Un rafraîchissement re-soumet mon formulaire.** Tu as affiché la vue directement après le POST au lieu de rediriger. Applique PRG : `header('Location: ...'); exit;` après un POST réussi.

**`Undefined variable` dans une vue.** La vue attend une variable que le contrôleur ne lui a pas passée. Vérifie le tableau de données passé à `Vue::rendre`, et donne des valeurs par défaut (`$titre ?? 'App'`).

**`headers already sent`.** Une vue (ou un espace avant `<?php`) a envoyé de la sortie avant un `header('Location: ...')`. Les redirections doivent partir **avant** tout HTML — d'où l'intérêt de rediriger dans le contrôleur, pas dans la vue.

**J'échappe du HTML que je veux garder.** Si tu échappes `$contenu` (du HTML déjà construit par une vue) dans le layout, il s'affiche en texte. Échappe les **données**, pas le HTML que tu as toi-même produit et maîtrisé.

---

## Ce qu'on te demandera

En **entretien PHP**, MVC et XSS sont deux sujets quasi certains. « Explique le rôle du modèle, de la vue, du contrôleur » ; « que met-on dans un contrôleur, et qu'est-ce qui n'y va pas ? » ; et, côté sécurité : **« comment préviens-tu les failles XSS en PHP ? »** — la réponse « j'échappe toute sortie avec `htmlspecialchars`, car PHP n'échappe rien automatiquement » est le réflexe des paliers 2, 3 et 4.

On peut demander : « pourquoi rediriger après un POST ? » (PRG), « différence entre valider en entrée et échapper en sortie ? », « pourquoi un contrôleur doit-il être fin ? ».

En **mission**, on te demandera d'ajouter une action (contrôleur + vue) dans une structure existante, ou de corriger une XSS sur un site qui n'échappe pas — une tâche de sécurité fréquente.

---

## Ce qui te démarquera

**Le contrôleur fin.** Garder le contrôleur court — orchestration seulement, SQL dans le modèle, HTML dans la vue — est la marque d'un code propre. Beaucoup de projets ont des contrôleurs obèses ; le tien, non.

**L'échappement par réflexe, et savoir que PHP n'échappe pas.** Pouvoir dire « React échappe par défaut, PHP natif non, donc en PHP j'échappe systématiquement avec un helper `e()` » montre que tu comprends la XSS comme un principe (paliers 2, 3, 4), pas comme une recette d'un langage.

**Les deux portes : validation en entrée, échappement en sortie.** Savoir que ce sont deux défenses complémentaires, pas interchangeables, est exactement ce qu'on attend d'un développeur conscient de la sécurité (palier 4, leçon 09).

**Le PRG.** Rediriger après un POST pour éviter la re-soumission est un détail d'expérience que peu d'autodidactes connaissent.

**Et voir le MVC partout.** « C'est l'architecture de Django, Rails, Laravel ; mon modèle c'est ma couche Repository des paliers 4 et 5 ; ma vue c'est mon template Flask » : relier ton MVC maison à tout ce que tu as vu prouve une compréhension d'architecture, pas de syntaxe.

---

## 📚 À lire

**php.net → *htmlspecialchars*** : l'argument `ENT_QUOTES`, l'encodage. La fonction la plus importante de cette leçon.

**OWASP → *Cross Site Scripting Prevention Cheat Sheet*** : la référence défensive, la même qu'au palier 4 — où échapper, selon le contexte (HTML, attribut, JS).

**phptherightway.com → *Templating*** et ***Security → Data Filtering*** : la bonne façon de séparer vues et logique, et de filtrer/échapper.

**Documentation Laravel → *Blade Templates*** : lis-la après avoir écrit ta vue maison. Tu verras que `{{ $var }}` de Blade **échappe automatiquement** — exactement ce que tu fais à la main, rendu par défaut.

Relis le palier 2 (DOM, `textContent`), le palier 3 (échappement React) et le palier 4, leçon 09 (XSS) : même principe, quatrième contexte.

---

## 🤖 Le mini-projet à demander à l'IA

Assembler le MVC, et verrouiller l'échappement :

> « Je suis en formation de développeur, palier 6. J'ai un routeur maison, une couche modèle en PDO avec requêtes préparées, et je veux assembler un MVC complet. Sans écrire le code à ma place, guide-moi par questions : qu'est-ce qui va dans le contrôleur et qu'est-ce qui n'y va pas, comment un petit moteur de vues passe des données à un template, et pourquoi je redirige après un POST (PRG). Quand je te montre mon contrôleur, vérifie qu'il ne contient ni SQL ni HTML. »

Puis la sécurité XSS, en cadre défensif :

> « Je sais que PHP n'échappe rien automatiquement, contrairement à React. Aide-moi à mettre en place un helper e() et à vérifier que TOUTE donnée affichée dans mes vues passe par lui. Montre-moi une vue qui affiche une donnée non échappée et demande-moi d'identifier pourquoi c'est une faille XSS et comment la corriger — sans me donner de charge d'attaque, juste le principe : une donnée affichée n'est jamais du code. Puis fais-moi distinguer "valider en entrée" et "échapper en sortie". »

---

## 🛠️ À faire

1. **Le contrôleur** : écris `DepensesController` avec `index`, `show`, `store`. Branche-le au routeur (leçon 08) et injecte le modèle PDO (leçon 05). Vérifie qu'il ne contient **aucun** SQL ni HTML.
2. **Le moteur de vues** : écris la classe `Vue` (`extract` + `require`). Fais rendre une première vue avec des données passées par le contrôleur.
3. **⭐ L'échappement** : crée le helper `e()` (`htmlspecialchars` + `ENT_QUOTES` + `UTF-8`) et affiche une liste de dépenses en échappant **chaque** donnée.
4. **⭐ Démontre la XSS** : en cadre défensif sur ta base de test, enregistre une dépense dont la description contient une balise `<script>` ou `<b>`. Affiche-la d'abord **sans** échappement (constate que la balise est interprétée), puis **avec** `e()` (constate qu'elle s'affiche en texte). Comprends que la frontière donnée/code a été rétablie.
5. **Le layout** : crée une page maîtresse qui enveloppe le contenu, et fais-y passer un titre (échappé).
6. **PRG** : dans `store`, redirige après un POST réussi (`header('Location: /depenses'); exit;`). Soumets, rafraîchis, et vérifie que le formulaire n'est pas re-soumis.
7. **La validation en entrée** : valide `montant` et `description` dans `store`. En cas d'erreur, réaffiche le formulaire avec les messages et les anciennes valeurs (échappées).
8. **Le 404 métier** : fais renvoyer `show` un 404 propre quand l'`id` n'existe pas (modèle qui renvoie `null`).
9. **Le contraste** : regarde le livre d'or « à l'ancienne » du début de module, et note dans ton journal où sont le modèle, la vue et le contrôleur dans ta version — et pourquoi la séparation vaut mieux.
10. **Le lien** : note la correspondance entre ton MVC et Django/Flask (palier 5), Express+Repository (palier 4), et ce que Blade/Eloquent (leçon 11) automatiseront.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Le test du contrôleur fin : s'il contient un `SELECT` ou une balise HTML, il fait le travail d'une autre couche. Le SQL va dans le modèle (leçon 05), le HTML dans la vue. Un bon contrôleur se lit en quelques lignes : prendre la requête, appeler le modèle, choisir la vue. **C'est la séparation des responsabilités, cœur de MVC.**

**3-4.** Le point de sécurité, pour la quatrième fois du parcours. `htmlspecialchars` transforme `<script>` en `&lt;script&gt;` : le navigateur l'affiche comme texte au lieu de l'exécuter. C'est exactement `textContent` du DOM (palier 2) et l'échappement automatique de React (palier 3). **La différence cruciale : PHP n'échappe RIEN automatiquement.** En React tu dois faire un effort pour être vulnérable (`dangerouslySetInnerHTML`) ; en PHP natif tu dois faire un effort pour être sûr (`e()` partout). D'où le helper `e()`, pour que l'effort soit minimal et systématique.

**6.** PRG (*Post-Redirect-Get*) : après un POST qui modifie des données, on **redirige** (réponse 302 vers une URL en GET) au lieu d'afficher directement. Ainsi, un rafraîchissement du navigateur recharge la page de destination (GET) au lieu de re-soumettre le POST — plus de double enregistrement accidentel. C'est un réflexe professionnel.

**7.** Les deux portes : la **validation en entrée** refuse les données aberrantes (montant négatif, description vide) à l'arrivée ; l'**échappement en sortie** neutralise ce qui est affiché. Elles ne se remplacent pas : une donnée peut être valide (une description légitime) tout en contenant des caractères à échapper (`<`, `&`). **Valide toujours en entrée ET échappe toujours en sortie.**

**10.** La correspondance : ton Contrôleur ↔ les vues Django / les routes Flask / les contrôleurs Express ; ton Modèle ↔ ta couche Repository des paliers 4 et 5 ; ta Vue ↔ les templates Jinja (Flask) / JSX (React). Et Laravel (leçon 11) te donnera tout ça tout fait, avec Blade (qui échappe par défaut) et Eloquent. **Tu as construit à la main l'architecture que tous les frameworks fournissent** — tu sauras exactement ce qu'ils font.
</details>

---

## ✅ Acquis si…

- [ ] Je sépare clairement contrôleur, modèle et vue.
- [ ] Mon contrôleur est fin : il orchestre, sans SQL ni HTML.
- [ ] Mon modèle (leçon 05) regroupe les requêtes préparées ; ma vue produit le HTML.
- [ ] J'échappe **toute** donnée affichée avec `htmlspecialchars`/`e()`.
- [ ] Je sais que PHP n'échappe rien automatiquement, contrairement à React.
- [ ] J'ai reproduit puis fermé une XSS, pour la quatrième fois du parcours.
- [ ] Je valide en entrée ET j'échappe en sortie, en sachant que ce sont deux défenses distinctes.
- [ ] J'applique PRG : je redirige après un POST réussi.
- [ ] Je renvoie un 404 propre quand une ressource n'existe pas.
- [ ] Je fais le lien entre mon MVC et ceux de Django, Flask, Express — et ce que Laravel automatise.

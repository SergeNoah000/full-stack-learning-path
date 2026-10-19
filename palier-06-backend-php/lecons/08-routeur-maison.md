# Leçon 08 — Un routeur maison

> 🎯 **À la fin de cette leçon** : tu construis à la main l'aiguillage qui, à partir d'une méthode et d'une URL, choisit le bon bout de code à exécuter — le routeur que tous les frameworks te donnent tout fait.
> ⏱️ 5 h · **Prérequis** : leçon 07 (front controller), et le palier 4 leçon 03 (routing Express).

---

## De quoi on parle

Un **routeur** est le composant qui associe une requête (une méthode HTTP + un chemin d'URL) au code qui doit la traiter. Il tient une **table de routes** — « `GET /depenses` → telle action », « `POST /depenses` → telle autre » — et, pour chaque requête reçue par le front controller (leçon 07), il cherche la route correspondante et l'exécute.

```php
$routeur->get('/depenses', [DepensesController::class, 'index']);
$routeur->get('/depenses/{id}', [DepensesController::class, 'show']);
$routeur->post('/depenses', [DepensesController::class, 'store']);
```

Tu connais déjà ça : c'est le routing d'Express (palier 4, leçon 03, `app.get('/users/:id', ...)`) et de Flask (palier 5, `@app.route`). Ici, tu le **construis** au lieu de l'utiliser — natif d'abord. Quand tu ouvriras Laravel (leçon 11), son `Route::get` ne sera plus de la magie : tu sauras ce qu'il y a dedans.

---

## À quoi ça sert, concrètement

**Parce que le front controller reçoit tout, mais ne sait pas quoi en faire.** La leçon 07 a fait arriver chaque requête à `index.php`. Le routeur est ce qui décide : « ce `GET /depenses/42`, c'est l'action `show` du contrôleur des dépenses, avec `id = 42` ». Sans routeur, le front controller serait une cascade de `if` sur l'URL.

**Parce que c'est ce qui permet les URL propres et les paramètres.** `/depenses/42` au lieu de `/depenses.php?id=42` : le routeur extrait le `42` du chemin et te le donne. Les segments dynamiques (`{id}`) sont ce qui rend les URL REST (palier 4, leçon 06) possibles.

**Parce que c'est le cœur de l'architecture web.** Tout framework web, dans tout langage, a un routeur : Express, Flask, FastAPI, Django, Laravel, Symfony. C'est un concept universel. Le construire une fois, c'est comprendre la couche la plus centrale de n'importe quel framework.

**Et parce que construire le sien révèle les cas limites.** Méthode non autorisée (405 vs 404), ordre des routes, extraction des paramètres, route par défaut (404) : en codant le routeur, tu rencontres tous les détails que les frameworks gèrent silencieusement — et tu comprends pourquoi ils existent.

---

## Où ça intervient dans le développement

Le routeur est l'aiguillage entre le point d'entrée et le code métier :

```
   public/index.php (front controller)        ← leçon 07
        ▼  (méthode + chemin)
   ROUTEUR : cherche dans sa table de routes   ← CETTE LEÇON
        ▼  (route trouvée + paramètres extraits)
   Contrôleur → Modèle → Vue                    ← leçon 09
        │
        └─ aucune route ? → 404
```

Trois connexions.

**Il est alimenté par le front controller (leçon 07).** Le `index.php` lui passe `$methode` et `$chemin` (extrait avec `parse_url`). Le routeur part de là. C'est pourquoi la leçon 07 insistait sur la normalisation de la requête — un chemin mal extrait casse le routage.

**Il appelle les contrôleurs (leçon 09).** Une route pointe vers une action de contrôleur (`[DepensesController::class, 'show']`). Le routeur instancie le contrôleur et appelle la méthode, en lui passant les paramètres extraits. La leçon 09 construira ces contrôleurs.

**Et c'est le routing d'Express et Flask, construit à la main.** `app.get('/users/:id')` (Express, palier 4), `@app.route('/users/<id>')` (Flask, palier 5), `$routeur->get('/users/{id}')` (ici) : exactement le même concept. Tu ne découvres pas le routing — tu l'implémentes.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire une classe `Routeur` : une table de routes (une entrée par méthode + motif), des méthodes `get`/`post`/`put`/`delete` pour enregistrer les routes, et une méthode `traiter` qui reçoit la requête, trouve la route, extrait les paramètres dynamiques et appelle l'action. Tu géreras le 404 (aucune route) et le 405 (bon chemin, mauvaise méthode).

### En équipe, en entreprise

**Tu n'écriras presque jamais ton propre routeur** — les frameworks en fournissent un, mieux testé que le tien. Mais tu **définiras des routes** tous les jours : c'est le fichier `routes/web.php` de Laravel, les décorateurs de FastAPI, le `Router` d'Express. Comprendre le mécanisme te rend immédiatement à l'aise avec n'importe lequel.

**Les routes racontent l'application.** Lire le fichier de routes d'un projet est la façon la plus rapide de comprendre ce qu'il fait : toutes les URL, toutes les actions, en un endroit. C'est le premier fichier qu'on ouvre en arrivant.

**L'ordre et la spécificité comptent.** `/depenses/nouveau` doit être déclaré avant `/depenses/{id}`, sinon `nouveau` est capturé comme un `{id}`. Ce genre de piège existe dans tous les routeurs ; l'avoir rencontré à la main te le fait anticiper.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : le concept de table de routes, les segments dynamiques (`{id}`), la correspondance méthode + chemin, le 404 et le 405, le passage des paramètres au contrôleur.

Régulièrement (via framework) : les groupes de routes, les middlewares attachés aux routes (auth, leçon 10), les routes nommées, les contraintes sur les paramètres (`{id}` numérique seulement).

Rare, car le framework s'en charge : écrire soi-même la correspondance par expressions régulières, l'optimiser, gérer le cache de routes. Tu le fais une fois ici, pour comprendre.

---

## La mécanique

### La table de routes

```php
<?php
namespace App\Core;

class Routeur
{
    private array $routes = [];

    public function get(string $motif, callable|array $action): void
    {
        $this->ajouter('GET', $motif, $action);
    }
    public function post(string $motif, callable|array $action): void
    {
        $this->ajouter('POST', $motif, $action);
    }
    // put, delete, patch : même principe

    private function ajouter(string $methode, string $motif, callable|array $action): void
    {
        $this->routes[] = compact('methode', 'motif', 'action');
    }
}
```

La table est un simple tableau de routes, chacune avec sa méthode, son motif d'URL et son action. Les méthodes `get`/`post`/… ne sont que des raccourcis vers `ajouter`. C'est exactement la forme des `app.get`/`app.post` d'Express.

### ⭐ Transformer un motif en expression régulière

```php
<?php
// "/depenses/{id}"  →  une regex qui capture le segment, et la liste des noms de paramètres
private function compiler(string $motif): array
{
    $noms = [];
    $regex = preg_replace_callback('#\{(\w+)\}#', function ($m) use (&$noms) {
        $noms[] = $m[1];              // on retient le nom du paramètre ("id")
        return '([^/]+)';             // et on capture tout sauf un slash
    }, $motif);
    return ['#^' . $regex . '$#', $noms];
}
```

C'est le cœur technique. Un motif comme `/depenses/{id}` devient la regex `#^/depenses/([^/]+)$#`, et on retient que le premier groupe capturé s'appelle `id`. `[^/]+` veut dire « un ou plusieurs caractères qui ne sont pas un slash » — un seul segment d'URL. Les frameworks font exactement ça (en plus sophistiqué).

### Traiter la requête

```php
<?php
public function traiter(string $methode, string $chemin): void
{
    $cheminTrouve = false;

    foreach ($this->routes as $route) {
        [$regex, $noms] = $this->compiler($route['motif']);

        if (preg_match($regex, $chemin, $correspondances)) {
            $cheminTrouve = true;                       // le chemin existe...

            if ($route['methode'] === $methode) {       // ...et la méthode correspond
                array_shift($correspondances);          // on jette la correspondance complète
                $params = array_combine($noms, $correspondances);  // ['id' => '42']
                $this->appeler($route['action'], $params);
                return;
            }
        }
    }

    // On a parcouru toute la table sans exécuter :
    if ($cheminTrouve) {
        http_response_code(405);    // le chemin existe, mais pas pour cette méthode
        echo '405 — Méthode non autorisée';
    } else {
        http_response_code(404);    // aucun chemin ne correspond
        echo '404 — Page non trouvée';
    }
}
```

Lis la logique : pour chaque route, on teste si le chemin correspond. S'il correspond **et** que la méthode est bonne, on extrait les paramètres (`['id' => '42']`) et on exécute. Si on finit la boucle sans exécuter, on distingue deux cas : le chemin existait mais pas pour cette méthode (**405**), ou aucun chemin ne correspondait (**404**). Cette distinction 404/405 est exactement celle du palier 4 (leçon 06, codes HTTP) — un vrai routeur la fait.

### Appeler l'action

```php
<?php
private function appeler(callable|array $action, array $params): void
{
    if (is_array($action)) {
        // [DepensesController::class, 'show']  →  on instancie et on appelle
        [$classe, $methode] = $action;
        $controleur = new $classe();
        $controleur->$methode($params);
    } else {
        // une simple fonction
        $action($params);
    }
}
```

L'action peut être une fonction anonyme (pour les cas simples) ou un couple `[Classe, 'méthode']` qui désigne une action de contrôleur. Dans le second cas, le routeur instancie le contrôleur et appelle la méthode avec les paramètres extraits. C'est ici que le routeur (leçon 08) rencontre les contrôleurs (leçon 09).

### Le branchement dans le front controller

```php
<?php
// public/index.php, après l'amorçage (leçon 07)
$routeur = new App\Core\Routeur();

require __DIR__ . '/../src/Core/routes.php';   // on y déclare toutes les routes

$routeur->traiter($methode, $chemin);           // et on exécute
```

```php
<?php
// src/Core/routes.php  — le fichier qui RACONTE l'application
use App\Controllers\DepensesController;

$routeur->get('/depenses', [DepensesController::class, 'index']);
$routeur->get('/depenses/{id}', [DepensesController::class, 'show']);
$routeur->post('/depenses', [DepensesController::class, 'store']);
```

Les routes vivent dans leur propre fichier, chargé par le front controller. C'est le `routes/web.php` de Laravel, en plus petit : un endroit unique qui liste toute l'application. Note l'ordre — on y revient juste en dessous.

---

## Les problèmes que tu vas rencontrer

**`/depenses/nouveau` est capturé par `/depenses/{id}`.** L'ordre des routes. `{id}` accepte n'importe quel segment, donc `nouveau` correspond. Déclare les routes **spécifiques avant** les génériques : `/depenses/nouveau` avant `/depenses/{id}`.

**Tout renvoie 404.** Soit le chemin reçu contient la query string (tu as oublié `parse_url`, leçon 07), soit ta regex a un souci (un slash final qui diffère), soit les routes ne sont pas chargées avant `traiter`.

**405 au lieu de 404, ou l'inverse.** Tu ne distingues pas « chemin inexistant » de « chemin existant, mauvaise méthode ». Un `POST` sur une route déclarée seulement en `GET` doit renvoyer 405, pas 404.

**Le slash final.** `/depenses` et `/depenses/` sont deux chemins différents pour une regex stricte. Décide d'une politique (normaliser en enlevant le slash final) et applique-la à l'entrée.

**Mes paramètres sont décalés.** `array_combine` échoue si le nombre de noms ne correspond pas au nombre de captures — souvent parce que tu as oublié `array_shift` (la correspondance complète est en position 0). Jette-la avant de combiner.

**Deux routes identiques.** Si tu déclares deux fois le même motif + méthode, la première gagne (la boucle `return` à la première correspondance). Les frameworks avertissent ; ton routeur, non — sois attentif.

---

## Ce qu'on te demandera

En **entretien PHP**, le routage est un sujet d'architecture : « comment une URL est-elle associée à du code ? », « comment gères-tu les paramètres d'URL comme `{id}` ? », « différence entre un 404 et un 405 ? ». Avoir écrit un routeur te permet de répondre avec précision, pas en récitant.

On peut demander : « pourquoi l'ordre des routes compte-t-il ? » — le piège `/nouveau` vs `/{id}`.

En **mission**, on te demandera surtout de **lire et d'ajouter des routes** dans le fichier de routes d'un framework. Avoir construit le mécanisme te rend immédiatement à l'aise.

---

## Ce qui te démarquera

**Savoir qu'un routeur n'est pas magique.** Pouvoir dire « c'est une table de motifs transformés en regex, parcourue jusqu'à la première correspondance » démystifie tous les frameworks d'un coup. L'intervieweur voit que tu comprends la couche, pas que tu l'invoques.

**La distinction 404/405.** Beaucoup de routeurs maison (et de développeurs) renvoient 404 pour tout. Distinguer « n'existe pas » de « pas pour cette méthode » montre que tu connais la sémantique HTTP (palier 4, leçon 06) jusque dans le routage.

**Anticiper l'ordre des routes.** Savoir que le spécifique passe avant le générique est le genre de détail qui révèle l'expérience — tu l'as rencontré en le construisant.

**Et le lien universel.** « Ce routeur, c'est `app.get` d'Express, `@app.route` de Flask, `Route::get` de Laravel » : montrer que tu vois le même concept à travers quatre technologies est exactement ce que le parcours construit.

---

## 📚 À lire

**php.net → *preg_match*, *preg_replace_callback*** : les fonctions d'expressions régulières que ton routeur utilise. Les regex elles-mêmes ont été vues au fil du parcours ; ici, un usage ciblé suffit.

**Documentation Laravel → *Routing*** : lis-la **après** avoir écrit ton routeur. Tu reconnaîtras chaque idée (routes, paramètres, méthodes, groupes) et tu verras ce que Laravel ajoute (routes nommées, contraintes, middlewares).

Relis le palier 4, leçon 03 (routing Express) et leçon 06 (REST, codes HTTP) : ton routeur est leur mise en œuvre.

---

## 🤖 Le mini-projet à demander à l'IA

Construire le routeur, pas à pas, en découvrant les cas limites :

> « Je suis en formation de développeur, palier 6. Je construis un routeur PHP maison, natif d'abord, avant Laravel. Je connais déjà le routing d'Express (app.get('/users/:id')) et de Flask (@app.route). Sans écrire le code à ma place, guide-moi par questions : comment stocker une table de routes, comment transformer un motif comme /depenses/{id} en expression régulière qui capture l'id, comment distinguer un 404 (chemin inexistant) d'un 405 (mauvaise méthode), et comment appeler l'action en lui passant les paramètres extraits. »

Puis les cas limites, pour durcir le routeur :

> « Donne-moi une liste de requêtes à tester contre mon routeur, y compris les pièges : /depenses/nouveau face à /depenses/{id}, un POST sur une route GET, un slash final, une query string. Pour chacune, demande-moi quel comportement j'attends (quelle action ou quel code HTTP) et aide-moi à vérifier que mon routeur le produit. »

---

## 🛠️ À faire

1. **La classe `Routeur`** : une table de routes et les méthodes `get`, `post`, `put`, `delete` qui y ajoutent une entrée (méthode, motif, action).
2. **⭐ La compilation** : écris la fonction qui transforme `/depenses/{id}` en regex `#^/depenses/([^/]+)$#` et retient le nom `id`. Teste-la sur plusieurs motifs.
3. **`traiter`** : parcourt la table, trouve la route par regex **et** méthode, extrait les paramètres, et appelle l'action. Branche-la dans le front controller (leçon 07).
4. **Les paramètres** : fais afficher à une action l'`id` reçu pour `/depenses/42`. Vérifie que `$params['id']` vaut `42`.
5. **⭐ 404 et 405** : vérifie qu'un chemin inexistant renvoie 404, et qu'un `POST` sur une route déclarée seulement en `GET` renvoie 405 (pas 404).
6. **Le piège de l'ordre** : déclare `/depenses/{id}` puis `/depenses/nouveau`, et constate que `/depenses/nouveau` est capturé par `{id}`. Corrige en inversant l'ordre.
7. **Le slash final** : décide d'une politique (normaliser) et applique-la, puis vérifie que `/depenses` et `/depenses/` se comportent pareil.
8. **Le fichier de routes** : sors toutes tes routes dans `src/Core/routes.php`, chargé par le front controller. Relis-le : il doit raconter ton application.
9. **Le lien** : note dans ton journal la correspondance entre ton routeur et `app.get` (Express), `@app.route` (Flask), `Route::get` (Laravel) — même concept, quatre technologies.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** La transformation motif→regex est le cœur du routeur. `/depenses/{id}` devient `#^/depenses/([^/]+)$#` : les `{...}` deviennent des groupes de capture `([^/]+)` (un segment, sans slash), et on retient l'ordre des noms pour reconstruire `['id' => '42']` après la correspondance. Les `^` et `$` garantissent que la regex matche **tout** le chemin, pas juste un bout.

**5.** La distinction 404/405 est le signe d'un vrai routeur. Si tu parcours toute la table et qu'**un chemin correspondait mais pas la méthode**, c'est 405 (Méthode non autorisée) ; si **aucun chemin** ne correspondait, c'est 404. C'est la sémantique HTTP du palier 4 (leçon 06), appliquée au routage. Un routeur qui renvoie 404 pour tout perd cette information.

**6.** Le piège de l'ordre : `{id}` capture n'importe quel segment, donc `/depenses/nouveau` correspond à `/depenses/{id}` avec `id = "nouveau"`. La boucle s'arrête à la **première** correspondance, donc la route déclarée en premier gagne. **Déclare toujours le spécifique (`/depenses/nouveau`) avant le générique (`/depenses/{id}`).** Ce piège existe dans tous les routeurs.

**9.** La correspondance : ton `$routeur->get('/users/{id}', ...)` ↔ `app.get('/users/:id', ...)` (Express) ↔ `@app.route('/users/<id>')` (Flask) ↔ `Route::get('/users/{id}', ...)` (Laravel). **Le routeur est un concept universel du développement web.** Tu viens de l'implémenter — quand tu ouvriras le routeur de Laravel (leçon 11), tu sauras exactement ce qu'il fait.
</details>

---

## ✅ Acquis si…

- [ ] Je tiens une table de routes (méthode + motif + action) avec `get`/`post`/`put`/`delete`.
- [ ] Je transforme un motif `{id}` en regex qui capture le segment.
- [ ] J'extrais les paramètres dynamiques et je les passe à l'action.
- [ ] J'appelle une action de contrôleur (`[Classe::class, 'méthode']`) ou une fonction.
- [ ] Je distingue un 404 (chemin inexistant) d'un 405 (mauvaise méthode).
- [ ] Je sais pourquoi les routes spécifiques doivent précéder les génériques.
- [ ] Je gère le slash final par une politique explicite.
- [ ] Mes routes vivent dans un fichier qui raconte l'application.
- [ ] Je fais le lien entre mon routeur et ceux d'Express, Flask et Laravel.

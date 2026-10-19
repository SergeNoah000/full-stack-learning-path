# Leçon 11 — Laravel : routing, Eloquent, Blade, validation, Breeze, Artisan

> 🎯 **À la fin de cette leçon** : tu construis avec Laravel ce que tu viens de bâtir à la main — et chaque fonctionnalité te paraît évidente, parce que tu sais déjà ce qu'elle remplace.
> ⏱️ 12 h · **Prérequis** : tout le palier 6 (ton MVC maison), et le palier 4 (frameworks, ORM).

---

## De quoi on parle

**Laravel** est le framework PHP dominant. Il fournit, prêt à l'emploi et soigneusement intégré, tout ce que tu as construit à la main dans ce palier : un routeur (`Route::get`), un ORM (**Eloquent**), un moteur de vues (**Blade**, qui échappe par défaut), la validation, l'authentification (**Breeze**), et un outil en ligne de commande (**Artisan**) qui génère et gère tout ça.

```php
Route::get('/depenses', [DepenseController::class, 'index']);   // ton routeur, leçon 08

class Depense extends Model {}                                   // ton modèle PDO, leçon 05

// Dans une vue Blade : {{ $depense->description }}              // ton échappement, leçon 09
```

C'est l'aboutissement du parcours « natif d'abord ». Tu n'apprends pas Laravel comme une boîte noire : tu **reconnais**, dans chacun de ses composants, celui que tu as écrit toi-même. Le front controller (leçon 07) ? C'est son `public/index.php`. Le routeur (leçon 08) ? C'est `Route::`. Le MVC (leçon 09) ? C'est son architecture. L'auth et le CSRF (leçon 10) ? C'est Breeze et `@csrf`. Rien n'est magique — tout a un équivalent que tu connais.

---

## À quoi ça sert, concrètement

**Parce que c'est ce qu'utilisent les entreprises PHP.** La grande majorité des offres PHP modernes demandent Laravel (ou Symfony). Ton MVC maison t'a appris les fondations ; Laravel est l'outil du marché. Les deux sont nécessaires : les fondations pour comprendre, le framework pour produire.

**Parce qu'il supprime le code répétitif que tu viens d'écrire.** Routeur, ORM, moteur de vues, validation, auth : tu les as construits, tu sais ce qu'ils coûtent. Laravel les fournit testés, sécurisés, documentés. Tu te concentres sur le métier, pas sur la plomberie.

**Parce que ses défauts sont des bons défauts.** Blade échappe automatiquement (plus de XSS par oubli, contrairement au PHP natif de la leçon 09). Eloquent paramètre les requêtes (plus d'injection SQL). `@csrf` protège les formulaires. Le framework rend sûr par défaut ce que tu devais sécuriser manuellement — et tu comprends exactement pourquoi, parce que tu as vécu le manuel.

**Et parce que tu le liras avec une longueur d'avance.** Là où un débutant découvre `Route::get`, `Model`, `{{ }}`, `@csrf` comme des incantations, toi tu sais ce qu'il y a dessous. La documentation Laravel te sera limpide — tu y reconnaîtras ton propre code.

---

## Où ça intervient dans le développement

Laravel est la synthèse de tout le palier, et l'outil réel du métier :

```
   public/index.php (front controller)   ← tu l'as écrit, leçon 07
        ▼
   routes/web.php : Route::get(...)       ← ton routeur, leçon 08
        ▼
   Contrôleur (php artisan make:controller)   ← leçon 09
    ├──→ Eloquent (Model)                  ← ton Repository PDO, leçons 05 + 09
    └──→ Blade ({{ }} échappe tout seul)   ← ta vue + échappement, leçon 09
   + Breeze : auth + @csrf                 ← ton auth maison, leçon 10
   + Artisan : génère, migre, sert
```

Chaque flèche est un transfert.

**Eloquent, c'est ton Repository PDO — et Prisma (palier 4).** `Depense::all()`, `Depense::find($id)`, `$depense->save()` : un ORM qui paramètre les requêtes automatiquement. C'est ta couche modèle (leçons 05 et 09), et c'est Prisma du palier 4 (leçon 07) dans un autre langage. Les migrations Laravel sont les migrations Prisma. Tu ne découvres pas l'ORM — tu en vois un troisième.

**Blade, c'est ta vue — avec l'échappement rendu automatique.** `{{ $var }}` échappe par défaut (exactement ton helper `e()` de la leçon 09, mais gratuit), `{!! $var !!}` affiche sans échapper (le choix explicite et rare). Les layouts, les composants : ton moteur de vues maison, en plus complet.

**Breeze, c'est ton auth de la leçon 10.** Une commande (`php artisan breeze:install`) met en place inscription, connexion, réinitialisation, et la protection CSRF via `@csrf` — tout ce que tu as bâti à la main. Tu sais exactement ce qu'elle génère.

**Et la validation, c'est tes règles de la leçon 09 — déclaratives.** `$request->validate([...])` remplace tes `if` de validation, avec les messages d'erreur et le renvoi au formulaire gérés.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas créer un projet Laravel, refaire ton gestionnaire de dépenses avec les outils du framework (routes, contrôleurs, Eloquent, Blade, validation), installer Breeze pour l'auth, et utiliser Artisan pour tout générer. À chaque étape, tu feras consciemment le lien avec ton code maison : « ça, c'est mon routeur » ; « ça, c'est mon échappement, mais automatique ».

### En équipe, en entreprise

**Laravel structure le projet pour toute l'équipe.** Conventions de nommage, organisation des dossiers, façon de faire les choses : tout le monde suit la « manière Laravel ». Un développeur qui arrive sait où tout se trouve. C'est la valeur d'un framework partagé.

**Artisan rythme le quotidien.** `php artisan make:model`, `make:controller`, `migrate`, `serve`, `tinker` : tu génères, tu migres, tu testes avec. C'est l'outil de ligne de commande que tu utiliseras chaque jour.

**Eloquent est au cœur du travail.** Relations (`hasMany`, `belongsTo`), requêtes fluides, chargement anticipé (*eager loading*) contre le problème N+1 : c'est là que se passe l'essentiel du développement. Le problème N+1 (une requête par élément d'une liste) est le piège de performance classique des ORM — tu le rencontreras.

**Et la communauté est énorme.** Documentation excellente, paquets pour presque tout, Laracasts pour apprendre. L'écosystème est une raison majeure du choix de Laravel en entreprise.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : les routes, les contrôleurs générés, Eloquent (CRUD, relations), Blade (`{{ }}`, layouts, `@if`/`@foreach`), la validation, Breeze pour l'auth, Artisan pour générer et migrer.

Régulièrement : les relations Eloquent et l'eager loading, les *form requests* (validation dans une classe dédiée), les middlewares, les ressources d'API, les *seeders* et *factories* pour les données de test, la *queue* pour les tâches asynchrones.

Rare au début : les événements et *listeners*, les *service providers* et le conteneur de services, les *policies* d'autorisation fines, Octane, les *packages* maison. Tu les aborderas avec l'expérience — et le palier 7 (architecture) t'y préparera.

---

## La mécanique

### Créer un projet et servir

```bash
composer create-project laravel/laravel gestion-depenses    # Composer, leçon 06
cd gestion-depenses
php artisan serve                                            # serveur de dev local
```

Laravel est un projet Composer (leçon 06). Sa structure t'est familière : `public/index.php` (ton front controller, leçon 07), `app/` (ton `src/`), `routes/web.php` (ton fichier de routes, leçon 08), `.env` (tes secrets hors du code, leçon 04).

### Les routes : ton routeur, en `Route::`

```php
<?php
// routes/web.php
use App\Http\Controllers\DepenseController;

Route::get('/depenses', [DepenseController::class, 'index']);
Route::get('/depenses/{id}', [DepenseController::class, 'show']);
Route::post('/depenses', [DepenseController::class, 'store']);
Route::resource('/depenses', DepenseController::class);   // ...ou les 7 routes REST d'un coup
```

C'est **exactement** ton routeur de la leçon 08 : méthode + motif + action, segments dynamiques `{id}`. `Route::resource` déclare d'un coup les sept routes REST (index, create, store, show, edit, update, destroy) — le CRUD du palier 4 (leçon 06), tout prêt.

### Eloquent : ton Repository PDO, en ORM

```bash
php artisan make:model Depense -m        # crée le modèle ET sa migration
```

```php
<?php
// Le modèle : quasiment vide, Eloquent fait le reste
class Depense extends Model
{
    protected $fillable = ['montant', 'categorie', 'description', 'date'];
}

// Dans un contrôleur — compare à ta couche PDO de la leçon 05 :
$depenses = Depense::all();                          // SELECT * (requête paramétrée)
$depense  = Depense::findOrFail($id);                // SELECT ... WHERE id = ? (ou 404)
$depense  = Depense::create($request->validated());  // INSERT, données validées
$depense->update(['montant' => 10]);                 // UPDATE
$depense->delete();                                  // DELETE
```

Compare ligne à ligne avec ta couche PDO (leçon 05) : Eloquent écrit les requêtes **préparées** pour toi. `findOrFail` fait le `parId` + 404 de ton contrôleur (leçon 09) en un appel. C'est Prisma (palier 4, leçon 07) dans un troisième langage — même idée d'ORM, même protection contre l'injection, gratuite.

```bash
php artisan make:migration create_depenses_table      # une migration, comme Prisma
php artisan migrate                                    # applique le schéma à la base
```

Les migrations versionnent le schéma (palier 4, leçon 06) : le schéma vit dans le code, s'applique avec `migrate`, se partage avec l'équipe.

### Blade : ta vue, échappement automatique

```blade
{{-- resources/views/depenses/index.blade.php --}}
@extends('layout')

@section('contenu')
    <h1>Mes dépenses</h1>
    <ul>
    @foreach ($depenses as $d)
        <li>{{ $d->description }} — {{ $d->montant }} € ({{ $d->categorie }})</li>
    @endforeach
    </ul>
@endsection
```

Le point clé, à faire consciemment : **`{{ $d->description }}` échappe automatiquement.** C'est ton helper `e()` de la leçon 09, mais appliqué par défaut, partout, sans que tu y penses. Pour afficher du HTML volontaire (rare), il faut l'écrire explicitement : `{!! $html !!}`. Laravel a inversé la charge par rapport au PHP natif : sûr par défaut, dangereux sur demande — l'inverse exact du PHP de la leçon 09, et pour une bonne raison que tu connais maintenant.

`@extends`/`@section` sont tes layouts (leçon 09), `@foreach`/`@if` tes structures de contrôle. Rien de neuf, une syntaxe dédiée.

### La validation : tes `if`, en déclaratif

```php
<?php
public function store(Request $request)
{
    $donnees = $request->validate([
        'montant'     => 'required|numeric|min:0.01',
        'description' => 'required|string|max:255',
        'categorie'   => 'required|string',
    ]);

    Depense::create($donnees);
    return redirect('/depenses');          // PRG (leçon 09), tout prêt
}
```

`$request->validate` remplace tes `if` de validation (leçon 09) : les règles sont déclaratives, l'échec renvoie automatiquement au formulaire avec les messages et les anciennes valeurs. Et `redirect()` applique le PRG de la leçon 09. Ce que tu codais à la main est une ligne.

### Breeze : ton auth de la leçon 10, en une commande

```bash
composer require laravel/breeze --dev
php artisan breeze:install        # génère inscription, connexion, profil, mot de passe oublié
php artisan migrate
```

Breeze génère **tout** ce que tu as construit à la leçon 10 : inscription, connexion, déconnexion, réinitialisation de mot de passe, le hachage (`Hash::make`, ton `password_hash`), les routes protégées (middleware `auth`, ton garde), et le CSRF. Chaque formulaire Blade contient `@csrf` — ton jeton de la leçon 10, automatique. Tu sais exactement ce que cette commande met en place, ligne par ligne.

### ⭐ Pourquoi tu es sûr par défaut, maintenant

Mets en regard ton palier et Laravel, sur les trois failles du parcours :

- **XSS** : en PHP natif (leçon 09), tu devais appeler `e()` partout, un oubli = une faille. Blade échappe par défaut (`{{ }}`). *Tu dois faire un effort pour être vulnérable.*
- **Injection SQL** : en PDO (leçon 05), tu devais préparer chaque requête. Eloquent les prépare toutes. *Plus d'injection par concaténation possible.*
- **CSRF** : tu devais poser et vérifier le jeton (leçon 10). Breeze/Blade le font via `@csrf` et le middleware. *Protégé par défaut.*

C'est l'enseignement central : **le framework rend sûr par défaut ce que tu devais sécuriser à la main**. Et parce que tu l'as fait à la main, tu sais exactement ce que le framework te protège — et tu sauras le désactiver à bon escient (`{!! !!}`) sans te tromper.

---

## Les problèmes que tu vas rencontrer

**`419 Page Expired` sur un formulaire.** Le jeton CSRF manque : ajoute `@csrf` dans le `<form>` (c'est le 419 de ta leçon 10, côté Laravel). Ou la session a expiré.

**`Mass assignment` / un champ ne s'enregistre pas.** Le champ n'est pas dans `$fillable` du modèle. Eloquent protège contre l'assignation de masse ; déclare les champs autorisés.

**Le problème N+1.** Afficher une liste avec une relation déclenche une requête par élément (1 + N). Utilise l'eager loading (`Depense::with('categorie')->get()`). C'est le piège de performance classique des ORM — à surveiller dès que tu affiches des relations en boucle.

**`SQLSTATE... no such table`.** Tu n'as pas lancé `php artisan migrate`, ou la base `.env` est mal configurée. Les migrations créent les tables (leçon 05, palier 4).

**Une variable est `undefined` dans une vue Blade.** Le contrôleur ne l'a pas passée (`return view('...', ['x' => $x])`). Comme ton moteur de vues (leçon 09), Blade n'a que ce qu'on lui donne.

**`.env` non pris en compte.** Après modification du `.env`, lance `php artisan config:clear`. Laravel met la config en cache.

**Mon HTML voulu s'affiche en texte.** Blade échappe par défaut (`{{ }}`). Pour du HTML maîtrisé, utilise `{!! !!}` — mais seulement sur du contenu que tu contrôles, jamais sur une donnée utilisateur (sinon XSS, leçon 09).

---

## Ce qu'on te demandera

En **entretien PHP**, Laravel est souvent le cœur de l'entretien. « As-tu utilisé Laravel ? Eloquent ? Blade ? » ; « comment fais-tu une relation `hasMany` ? » ; « qu'est-ce que le problème N+1 et comment l'éviter ? » ; « comment Laravel protège-t-il du CSRF, de la XSS, de l'injection ? ». Tes réponses porteront la marque de quelqu'un qui sait ce qu'il y a dessous.

On peut demander : « différence entre `{{ }}` et `{!! !!}` ? », « à quoi sert `$fillable` ? », « qu'est-ce qu'une migration ? », « qu'est-ce qu'Artisan ? ».

En **test technique**, on te fera souvent construire un petit CRUD Laravel avec auth — exactement ce que tu refais dans cette leçon.

---

## Ce qui te démarquera

**Savoir ce que Laravel fait à ta place.** C'est ta plus grande force, et elle est rare. Pouvoir dire « Blade, c'est mon `htmlspecialchars` automatique ; Eloquent, c'est mes requêtes préparées ; Breeze, c'est mon auth maison ; `Route::` c'est mon routeur » prouve une compréhension des fondations que presque aucun développeur « Laravel seulement » n'a. Tu n'es pas prisonnier du framework.

**Reconnaître quand ne pas tout déléguer.** Savoir que `{!! !!}` désactive l'échappement et quand c'est légitime, que l'eager loading évite le N+1, que `$fillable` protège l'assignation de masse : ces choix éclairés viennent de ta compréhension du dessous.

**Faire le pont entre les écosystèmes.** « Eloquent, c'est Prisma du palier 4 ; les migrations sont les mêmes ; le routing, c'est Express et Flask » : relier Laravel aux frameworks des autres langages montre une maturité d'architecte, pas d'utilisateur d'un seul outil.

**Et la sécurité par défaut, comprise.** Expliquer pourquoi Laravel inverse la charge (sûr par défaut) par rapport au PHP natif, parce que tu as vécu les deux, est exactement le genre de recul qu'on cherche chez un développeur qu'on veut garder.

---

## 📚 À lire

**laravel.com/docs** : la documentation officielle, excellente. Lis dans l'ordre *Routing*, *Eloquent: Getting Started*, *Blade Templates*, *Validation*, *Starter Kits (Breeze)*, *Artisan Console*. À chaque page, demande-toi « qu'est-ce que ça remplace dans mon code maison ? ».

**Laracasts → *Laravel From Scratch*** : la référence vidéo pour apprendre Laravel, gratuite pour une bonne partie.

**laravel.com/docs → *Eloquent: Relationships*** et ***Database: Query Builder*** : le cœur du travail quotidien, et l'eager loading contre le N+1.

Relis **tout ton palier 6** : chaque leçon a son équivalent Laravel, et c'est en les mettant côte à côte que cette leçon prend tout son sens. Et le palier 4 (leçon 07, Prisma) : Eloquent en est le cousin.

---

## 🤖 Le mini-projet à demander à l'IA

Refaire ton projet avec Laravel, en traçant chaque transfert :

> « Je suis en formation de développeur, palier 6. Je viens de construire à la main, en PHP natif, un MVC complet : front controller, routeur, couche modèle PDO avec requêtes préparées, moteur de vues avec échappement manuel, et une auth avec sessions et CSRF. Je refais maintenant le même gestionnaire de dépenses avec Laravel. Sans écrire le code à ma place, guide-moi par questions et, pour CHAQUE fonctionnalité Laravel (Route, Eloquent, Blade, validation, Breeze, Artisan), demande-moi d'abord à quoi elle correspond dans mon code maison avant de me montrer comment Laravel la fait. Je veux reconnaître, pas découvrir. »

Puis la sécurité par défaut :

> « Aide-moi à vérifier, sur mon projet Laravel, les trois protections que j'avais dû coder à la main : que Blade échappe bien mes sorties ({{ }}), qu'Eloquent paramètre bien mes requêtes, et que mes formulaires ont @csrf. Explique-moi en quoi Laravel a "inversé la charge" par rapport au PHP natif (sûr par défaut au lieu de dangereux par défaut), et quand il est légitime d'utiliser {!! !!} pour désactiver l'échappement. »

---

## 🛠️ À faire

1. **Crée le projet** : `composer create-project laravel/laravel gestion-depenses`, puis `php artisan serve`. Repère `public/index.php`, `routes/web.php`, `app/`, `.env` — et nomme à voix haute leur équivalent dans ton code maison.
2. **Les routes** : déclare les routes REST des dépenses, d'abord à la main (`Route::get/post`), puis avec `Route::resource`. Compare à ton routeur (leçon 08).
3. **Eloquent** : `php artisan make:model Depense -m`, écris la migration, `php artisan migrate`. Fais un CRUD complet (`all`, `findOrFail`, `create`, `update`, `delete`) et compare chaque appel à ta couche PDO (leçon 05).
4. **Blade** : crée un layout et les vues index/show/formulaire. **Vérifie consciemment** que `{{ $d->description }}` échappe (saisis une description avec `<b>` et constate qu'elle s'affiche en texte). Compare à ton `e()` (leçon 09).
5. **La validation** : utilise `$request->validate([...])` et constate le renvoi automatique au formulaire avec messages et anciennes valeurs. Compare à tes `if` (leçon 09).
6. **Breeze** : `php artisan breeze:install`, `migrate`. Explore le code généré et retrouve, dedans, chaque brique de ta leçon 10 : hachage, connexion, middleware `auth`, `@csrf`.
7. **⭐ Les trois sécurités** : vérifie sur ce projet que la XSS (Blade échappe), l'injection (Eloquent prépare) et le CSRF (`@csrf`) sont fermées **par défaut**. Écris dans ton journal en quoi c'est l'inverse du PHP natif.
8. **Le N+1** : crée une relation (une catégorie a plusieurs dépenses), affiche une liste, observe les requêtes (Laravel Debugbar ou les logs), constate le N+1, puis corrige avec `with()`.
9. **Artisan** : utilise `make:controller`, `make:model`, `migrate`, `tinker` (pour manipuler Eloquent en interactif). Note les commandes que tu utiliseras tous les jours.
10. **Le grand tableau** : dans ton journal, dresse la correspondance complète — pour chaque leçon du palier 6 (07 front controller, 08 routeur, 05+09 modèle, 09 vue/échappement, 09 validation, 10 auth/CSRF), écris son équivalent Laravel. C'est la synthèse du palier.

<details>
<summary>Corrections et points de contrôle</summary>

**3.** Eloquent EST ta couche modèle de la leçon 05, en ORM : `Depense::all()` ↔ ton `lister()`, `Depense::findOrFail($id)` ↔ ton `parId()` + 404 du contrôleur, `Depense::create()` ↔ ton `creer()`. La différence : Eloquent écrit les requêtes **préparées** pour toi — plus d'injection possible. C'est Prisma (palier 4) dans un troisième langage. **Tu reconnais l'ORM, tu ne le découvres pas.**

**4 + 7.** Le cœur de la leçon : `{{ }}` de Blade échappe **par défaut**, là où le PHP natif (leçon 09) n'échappait rien et t'obligeait à appeler `e()` partout. Laravel a **inversé la charge** : en natif, un oubli = une faille (dangereux par défaut) ; en Blade, il faut écrire explicitement `{!! !!}` pour désactiver l'échappement (sûr par défaut). Même logique pour l'injection (Eloquent prépare tout) et le CSRF (`@csrf` + middleware). **Le framework rend sûr par défaut ce que tu devais sécuriser à la main — et tu sais exactement quoi, parce que tu l'as fait.**

**8.** Le N+1 : afficher 50 dépenses avec leur catégorie déclenche 1 requête pour la liste + 50 pour les catégories = 51 requêtes. `Depense::with('categorie')->get()` (eager loading) les charge en 2 requêtes. C'est le piège de performance numéro un des ORM — dans Eloquent comme dans Prisma (palier 4). Le reconnaître dès maintenant t'évitera des applications lentes.

**10.** La correspondance complète, ta synthèse du palier : front controller (leçon 07) → `public/index.php` de Laravel ; routeur (leçon 08) → `Route::` ; modèle PDO (leçons 05+09) → Eloquent ; vue + échappement (leçon 09) → Blade `{{ }}` ; validation (leçon 09) → `$request->validate` ; auth + CSRF (leçon 10) → Breeze + `@csrf`. **Tu n'as pas appris Laravel comme une boîte noire : tu as reconnu, dans chaque composant, celui que tu avais écrit.** C'est exactement l'objectif « natif d'abord » du palier — et ta plus grande force face à un développeur qui ne connaît que le framework.
</details>

---

## ✅ Acquis si…

- [ ] Je crée un projet Laravel et je situe `public/index.php`, `routes/web.php`, `app/`, `.env`.
- [ ] Je déclare des routes (`Route::get`, `Route::resource`) et je les relie à mon routeur maison.
- [ ] J'utilise Eloquent pour un CRUD complet et je le relie à ma couche PDO et à Prisma.
- [ ] J'écris des vues Blade et je sais que `{{ }}` échappe par défaut, `{!! !!}` non.
- [ ] Je valide avec `$request->validate` et j'obtiens le renvoi au formulaire gratuitement.
- [ ] J'installe Breeze et je retrouve, dans le code généré, chaque brique de mon auth maison.
- [ ] Je sais que Laravel ferme XSS, injection et CSRF **par défaut**, et pourquoi c'est l'inverse du PHP natif.
- [ ] Je reconnais et corrige le problème N+1 avec l'eager loading.
- [ ] J'utilise Artisan (`make:*`, `migrate`, `tinker`) dans mon quotidien.
- [ ] Je peux dresser la correspondance complète entre mon MVC maison et Laravel.

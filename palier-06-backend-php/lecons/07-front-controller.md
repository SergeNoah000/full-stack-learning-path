# Leçon 07 — Le pattern front controller

> 🎯 **À la fin de cette leçon** : tu fais passer toutes les requêtes par un seul point d'entrée, `public/index.php` — le point de bascule entre le vieux PHP (un fichier par page) et tout framework moderne.
> ⏱️ 3 h · **Prérequis** : leçons 01-02 (Apache, `.htaccess`, réécriture), 06 (autoloading).

---

## De quoi on parle

Le **front controller** (contrôleur frontal) est un patron d'architecture où **toutes** les requêtes HTTP d'une application passent par un **seul** fichier PHP, en général `public/index.php`. Ce fichier unique reçoit tout, puis décide quoi faire (quel code exécuter, quelle page renvoyer).

C'est l'opposé du PHP « à l'ancienne », où chaque URL correspond à un fichier physique : `/contact.php`, `/produits.php`, `/panier/ajouter.php`. Là, l'URL **est** le chemin du fichier. Avec un front controller, l'URL est une **information** que le point d'entrée interprète.

```
  Ancien monde              Front controller
  /contact.php        →     tout → public/index.php → (interprète "/contact")
  /produits.php       →     tout → public/index.php → (interprète "/produits")
  /panier/ajouter.php →     tout → public/index.php → (interprète "/panier/ajouter")
```

C'est le mécanisme que tu as rendu possible à la leçon 02 (réécriture `.htaccess`), et le fondement de ton routeur (leçon 08) et de tout framework (Express au palier 4, Flask au palier 5, Laravel à la leçon 11).

---

## À quoi ça sert, concrètement

**Parce que c'est le seul endroit où centraliser ce qui concerne tout le monde.** Charger l'autoloader (leçon 06), démarrer la session, se connecter à la base, définir la gestion d'erreurs, lire la configuration : tout ce qui doit arriver à **chaque** requête se fait une fois, au front controller. Dans l'ancien modèle, chaque fichier devait répéter tout ça (ou l'oublier).

**Parce que c'est ce qui rend les URL propres possibles.** Tu veux `/depenses/42` et non `/depenses.php?id=42`. Pour ça, il faut que `/depenses/42` arrive à un code qui l'interprète — c'est le front controller, alimenté par la réécriture `.htaccess` (leçon 02).

**Parce que c'est la frontière de sécurité.** Avec un front controller, un seul dossier (`public/`) est exposé au web. Tout le reste — ton code, ta config, tes dépendances — est **au-dessus** de la racine web, inaccessible par URL. Dans l'ancien modèle où chaque `.php` est atteignable, un fichier mal placé (un `config.php` avec les mots de passe) peut être servi en clair.

**Et parce que c'est le pas de bascule vers les frameworks.** Express, Flask, FastAPI, Laravel : tous reposent sur un point d'entrée unique qui reçoit tout et route. Comprendre le front controller à la main, c'est comprendre ce que fait tout framework avant même de l'ouvrir.

---

## Où ça intervient dans le développement

Le front controller est la porte d'entrée de toute l'application :

```
   Navigateur → /depenses/42
        ▼
   Apache + .htaccess (réécriture : tout → index.php)   ← leçon 02
        ▼
   public/index.php   ← LE FRONT CONTROLLER (cette leçon)
   ├── require vendor/autoload.php      (leçon 06)
   ├── démarre la session                (leçon 04)
   ├── connecte PDO                      (leçon 05)
   ├── configure la gestion d'erreurs
   └── passe la requête au ROUTEUR       (leçon 08)
        ▼
   contrôleur → modèle → vue             (leçon 09)
```

Trois branchements.

**Il s'appuie sur la réécriture de la leçon 02.** Sans la règle `.htaccess` qui envoie toute URL inexistante vers `index.php`, le front controller ne reçoit rien. La leçon 02 a construit le tuyau ; cette leçon construit ce qui est au bout.

**Il prépare le routeur de la leçon 08.** Le front controller reçoit la requête et la confie au routeur, qui décidera quel contrôleur appeler. Ici, on pose le point d'entrée ; à la leçon 08, on pose l'aiguillage.

**Et c'est la structure de tout framework.** Le `public/index.php` de Laravel (leçon 11) fait exactement ça : charger l'autoloader, amorcer l'application, passer la requête au noyau. Tu construis à la main ce que Laravel te donnera tout fait — et tu sauras ce qu'il y a dedans.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas créer la structure `public/` (exposé au web) et `src/` (ton code, hors de portée du web), écrire un `public/index.php` qui charge l'autoloader et démarre la session, et configurer Apache pour que tout arrive là. Tu constateras qu'une URL comme `/nimportequoi` arrive bien à `index.php`.

Tu éprouveras aussi, par contraste, le modèle ancien que tu as peut-être vu à la leçon 09 du module 3 : un fichier par page, code dupliqué, config exposée.

### En équipe, en entreprise

**Toute application PHP moderne a cette structure.** `public/` comme racine web, le reste au-dessus. C'est la première chose qu'un développeur PHP reconnaît : « où est le `public/index.php` ? ».

**La racine web pointe sur `public/`.** En configuration serveur (leçon 01, `DocumentRoot`), on pointe sur le dossier `public/`, jamais sur la racine du projet. C'est ce qui protège `src/`, `vendor/`, `.env`, `composer.json` d'un accès direct.

**Les vieux sites n'ont pas ça.** En maintenance (le cœur des missions PHP), tu trouveras des sites « un fichier par page », avec du `config.php` dans la racine web et du SQL mêlé au HTML. Reconnaître ce modèle et savoir pourquoi le front controller est mieux fait partie du métier.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : la structure `public/` vs `src/`, le `public/index.php` qui amorce tout (autoload, session, base, erreurs), le passage de la requête au routeur.

Régulièrement : la configuration d'environnement chargée au point d'entrée, la gestion centralisée des erreurs et exceptions, les en-têtes communs (sécurité, type de contenu).

Rare, car les frameworks s'en chargent : écrire soi-même tout l'amorçage. Mais l'avoir fait une fois éclaire définitivement ce que fait un framework.

---

## La mécanique

### La structure du projet

```
gestion-depenses/
├── public/              ← SEUL dossier exposé au web (DocumentRoot)
│   ├── index.php        ← le front controller
│   ├── .htaccess        ← la réécriture (leçon 02)
│   └── assets/          ← css, js, images publics
├── src/                 ← ton code (hors du web)
│   ├── Controllers/
│   ├── Models/
│   ├── Core/
│   └── Views/
├── vendor/              ← dépendances (leçon 06)
├── .env                 ← secrets (hors du web)
└── composer.json
```

Le point crucial : **seul `public/` est accessible par URL**. Le `DocumentRoot` d'Apache (leçon 01) pointe sur `public/`. Ainsi, `/depenses` cherche `public/depenses` (qui n'existe pas), la réécriture l'envoie à `index.php`, et `src/`, `.env`, `vendor/` sont inatteignables depuis le web.

### ⭐ Le `.htaccess` qui envoie tout vers le front controller

```apache
# public/.htaccess
RewriteEngine On

# Si le fichier/dossier demandé existe vraiment (assets), on le sert tel quel
RewriteCond %{REQUEST_FILENAME} -f [OR]
RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^ - [L]

# Sinon, tout passe par index.php
RewriteRule ^ index.php [QSA,L]
```

C'est la règle de la leçon 02, dans sa forme canonique. Les deux premières conditions disent « si on demande un vrai fichier (une image, un CSS) ou un vrai dossier, sers-le directement ». Sinon, **tout** va à `index.php`. Les assets restent servis par Apache (rapide) ; tout le reste devient une requête applicative.

### Le front controller lui-même

```php
<?php
// public/index.php

// 1. L'autoloader : toutes les classes App\... deviennent disponibles (leçon 06)
require __DIR__ . '/../vendor/autoload.php';

// 2. La gestion d'erreurs : afficher en dev, logger en prod
error_reporting(E_ALL);
ini_set('display_errors', $_ENV['APP_ENV'] === 'dev' ? '1' : '0');

// 3. La session : démarrée une fois, pour toute l'application (leçon 04)
session_start();

// 4. La configuration et la connexion à la base (leçon 05)
$pdo = require __DIR__ . '/../src/Core/connexion.php';

// 5. La requête entrante, normalisée
$methode = $_SERVER['REQUEST_METHOD'];
$chemin  = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// 6. On confie tout au routeur (leçon 08)
$routeur = new App\Core\Routeur();
// ... chargement des routes ...
$routeur->traiter($methode, $chemin);
```

Lis-le de haut en bas : c'est l'amorçage de l'application, qui arrive à **chaque** requête, une seule fois. Autoloader, erreurs, session, base : tout le « setup » commun est ici, et nulle part ailleurs. Puis la requête est normalisée (`REQUEST_METHOD`, chemin extrait de `REQUEST_URI` avec `parse_url` — sans la *query string*) et confiée au routeur.

À la leçon 08, on remplira `$routeur` ; ici, l'essentiel est de comprendre que **ce fichier reçoit tout**.

### Le contraste : le modèle ancien

```php
<?php
// contact.php  — l'ancien monde : un fichier par page
session_start();                          // répété dans CHAQUE fichier
$pdo = new PDO(...);                        // dupliqué partout
// ... html mêlé au php ...
```

Dans l'ancien modèle, `session_start()`, la connexion, la config sont répétés (ou oubliés) dans chaque fichier. Pire : `config.php` avec les identifiants est dans la racine web, donc potentiellement servi en clair. Le front controller supprime la répétition et sort le code sensible du web.

---

## Les problèmes que tu vas rencontrer

**Mes assets (CSS, images) ne se chargent plus.** La règle de réécriture envoie tout vers `index.php`, y compris les assets, si tu as oublié les conditions `-f`/`-d`. Ajoute-les : « si c'est un vrai fichier, sers-le ».

**`/depenses` renvoie 404.** La réécriture n'est pas active (`mod_rewrite` désactivé, ou `AllowOverride None` — leçon 02), ou le `DocumentRoot` ne pointe pas sur `public/`. Vérifie la config Apache.

**La query string disparaît.** Sans le flag `[QSA]` (*Query String Append*), les paramètres `?page=2` sont perdus à la réécriture. Ajoute `[QSA,L]`.

**Mon chemin contient la query string.** `$_SERVER['REQUEST_URI']` inclut `?...`. Utilise `parse_url($uri, PHP_URL_PATH)` pour n'obtenir que le chemin, sinon ton routage comparera `/depenses?page=2` au lieu de `/depenses`.

**Mes fichiers `src/` sont accessibles par URL.** Le `DocumentRoot` pointe sur la racine du projet, pas sur `public/`. Repointe-le. C'est un vrai risque : `.env` ou `config.php` servis en clair.

**`session_start()` déclenche un avertissement « headers already sent ».** Quelque chose a été envoyé (un espace, un `echo`) avant `session_start()`. Le front controller doit démarrer la session **avant** toute sortie (leçon 04).

---

## Ce qu'on te demandera

En **entretien PHP**, le front controller est une question d'architecture classique : « qu'est-ce qu'un front controller ? », « pourquoi toutes les requêtes passent-elles par `index.php` ? », « pourquoi `public/` est-il le seul dossier exposé ? ». La réponse — centralisation de l'amorçage + sécurité (sortir le code du web) + URL propres — montre que tu comprends l'architecture, pas juste la syntaxe.

On peut demander : « différence avec le modèle un-fichier-par-page ? », « où mets-tu ton `.env` et pourquoi ? ».

En **mission**, savoir reconnaître si un projet a un front controller (moderne) ou pas (à migrer) oriente tout le diagnostic.

---

## Ce qui te démarquera

**Comprendre que c'est la frontière de sécurité.** Pouvoir expliquer que `public/` est la seule porte, et que sortir `src/`, `.env`, `vendor/` du `DocumentRoot` empêche de servir du code ou des secrets en clair, montre une maturité que beaucoup de développeurs PHP autodidactes n'ont pas.

**Faire le lien avec les frameworks.** « Le `public/index.php` de Laravel fait exactement ça : charger, amorcer, router » prouve que tu vois la continuité entre ton code maison et les outils professionnels.

**Savoir normaliser la requête.** Extraire proprement le chemin (`parse_url`) et la méthode, sans traîner la query string, est le détail qui fait que ton routeur fonctionnera du premier coup.

**Et éprouver le contraste.** Avoir vécu le modèle « un fichier par page » et pouvoir dire précisément ce que le front controller résout (répétition, sécurité, URL) te rend crédible en maintenance — là où sont les missions PHP.

---

## 📚 À lire

**php.net → *$_SERVER*** pour `REQUEST_URI`, `REQUEST_METHOD`, `SCRIPT_NAME` — les variables que lit le front controller.

**Documentation d'un framework (Laravel, Symfony) → section *Directory Structure* / *public directory*** : regarde comment ils organisent `public/` vs le reste. Tu reconnaîtras ta propre structure.

**Le patron *Front Controller*** (Martin Fowler, *Patterns of Enterprise Application Architecture*, résumés en ligne) : la définition de référence du patron.

Relis la leçon 02 (réécriture `.htaccess`) : c'est le tuyau qui alimente le front controller.

---

## 🤖 Le mini-projet à demander à l'IA

Construire le point d'entrée, et comprendre le contraste :

> « Je suis en formation de développeur, palier 6. Je construis un MVC PHP maison, natif d'abord, avant Laravel. Je veux mettre en place un front controller. Sans écrire le code à ma place, guide-moi par questions : quelle structure de dossiers (public/ vs src/) et pourquoi, quelle règle .htaccess pour envoyer toutes les requêtes vers public/index.php tout en servant les assets réels, et qu'est-ce que index.php doit amorcer à chaque requête. Quand je te montre mon index.php, vérifie que l'ordre (autoload, erreurs, session avant toute sortie, base) est correct. »

Puis le contraste, pour ancrer le pourquoi :

> « Montre-moi à quoi ressemble un petit site PHP "à l'ancienne" (un fichier .php par page, avec session_start et la connexion répétés dans chacun, et un config.php dans la racine web). Demande-moi d'identifier les trois problèmes que le front controller résout. Puis aide-moi à décrire comment je migrerais ce site vers un point d'entrée unique. »

---

## 🛠️ À faire

1. **La structure** : crée `public/`, `src/` (avec `Controllers/`, `Models/`, `Core/`, `Views/`), et place `composer.json`, `.env` à la racine (hors de `public/`).
2. **Pointe le `DocumentRoot` sur `public/`** (via VirtualHost, leçon 01, ou la config de ton serveur local). Vérifie qu'une URL ne peut pas atteindre `src/` ni `.env`.
3. **⭐ Le `.htaccess`** : dans `public/`, écris la règle qui sert les vrais fichiers/dossiers et envoie tout le reste vers `index.php` (avec `-f`, `-d`, `[QSA,L]`).
4. **Le front controller** : écris `public/index.php` qui, dans l'ordre : inclut `vendor/autoload.php`, configure la gestion d'erreurs selon `APP_ENV`, démarre la session, connecte PDO, puis extrait méthode et chemin.
5. **Reçois tout** : fais afficher à `index.php` la méthode et le chemin demandés. Navigue vers `/`, `/depenses`, `/depenses/42`, `/nimportequoi` et constate que **tout** arrive à `index.php` avec le bon chemin.
6. **Les assets** : place un CSS dans `public/assets/`, lie-le dans une page, et vérifie qu'il est servi directement (pas passé par `index.php`).
7. **Le piège de la query string** : navigue vers `/depenses?categorie=courses` et vérifie que ton chemin extrait est bien `/depenses` (grâce à `parse_url`), pas `/depenses?categorie=courses`.
8. **Le contraste** : écris (ou lis) un mini-site « à l'ancienne » et liste par écrit, dans ton journal, les trois problèmes que ton front controller résout.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** Le point de sécurité central : si le `DocumentRoot` pointe sur la racine du projet, alors `/.env`, `/composer.json`, `/src/Core/connexion.php` sont **servis par URL** — tes secrets et ton code en clair. En pointant sur `public/`, seul ce dossier est atteignable ; tout le reste est au-dessus, invisible du web. **C'est la raison d'être de la séparation `public/` / `src/`.**

**3-5.** Le cœur de la leçon : les conditions `-f`/`-d` servent les vrais fichiers (assets), et tout le reste est envoyé à `index.php`, qui reçoit **chaque** requête applicative. L'amorçage (autoload, erreurs, session, base) se fait là, une fois — pas répété dans chaque page comme dans l'ancien modèle.

**7.** `REQUEST_URI` contient la query string (`/depenses?categorie=courses`). Si tu routes là-dessus directement, `/depenses?categorie=courses` ne correspondra à aucune route. `parse_url($uri, PHP_URL_PATH)` isole `/depenses`. **C'est le bug numéro un des routeurs maison** — tu l'évites dès maintenant, et ça servira à la leçon 08.

**8.** Les trois problèmes que le front controller résout : (1) la **répétition** — `session_start`, connexion, config dupliqués dans chaque fichier ; (2) la **sécurité** — dans l'ancien modèle, config et code sont dans la racine web, donc exposés ; (3) les **URL** — un fichier par page force des URL comme `/produits.php?id=4` au lieu de `/produits/4`. Garde cette liste : c'est l'argument que tu donneras en entretien et en mission.
</details>

---

## ✅ Acquis si…

- [ ] Je sépare `public/` (exposé au web) du reste du projet (`src/`, `.env`, `vendor/`).
- [ ] Je pointe le `DocumentRoot` sur `public/` et je vérifie que `src/` et `.env` sont inaccessibles par URL.
- [ ] J'écris un `.htaccess` qui sert les assets réels et envoie tout le reste vers `index.php`.
- [ ] Mon `public/index.php` amorce l'application (autoload, erreurs, session, base) une fois par requête.
- [ ] Je démarre la session avant toute sortie.
- [ ] J'extrais le chemin avec `parse_url` sans traîner la query string.
- [ ] Je sais expliquer les trois problèmes que le front controller résout.
- [ ] Je fais le lien entre mon `index.php` et le point d'entrée d'un framework.

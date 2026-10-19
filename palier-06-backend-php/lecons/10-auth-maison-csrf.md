# Leçon 10 — Auth maison : inscription, connexion, sessions, jeton CSRF

> 🎯 **À la fin de cette leçon** : tu construis une authentification complète à la main — mots de passe hachés, sessions, protection CSRF — pour comprendre ce que Breeze te donnera tout fait, et reconnaître ce qui cloche sur un site existant.
> ⏱️ 5 h · **Prérequis** : leçons 04 (sessions), 05 (PDO), 09 (MVC, échappement), et le palier 4 leçon 08 (auth).

---

## De quoi on parle

L'**authentification** répond à « qui es-tu ? » : inscription (créer un compte), connexion (prouver son identité), et maintien de l'état connecté d'une requête à l'autre via la **session** (leçon 04). Trois briques de sécurité l'accompagnent :

- le **hachage des mots de passe** : on ne stocke jamais un mot de passe en clair, mais son empreinte via `password_hash()` (bcrypt/argon2) ;
- la **régénération de session** à la connexion, contre la fixation de session ;
- le **jeton CSRF** (*Cross-Site Request Forgery*), qui protège les formulaires contre les requêtes forgées depuis un autre site.

Tu connais déjà l'authentification par le palier 4 (leçon 08) : hachage, cookies de session, le principe. La grande différence ici : au palier 4, tu avais une API avec des jetons ; en PHP web classique, l'état connecté vit dans la **session serveur** (leçon 04), et les formulaires HTML introduisent un risque propre, le **CSRF**, que les API à jeton n'ont pas de la même façon.

Cette leçon est **défensive** : on construit une auth correcte, on apprend à reconnaître et corriger les erreurs classiques sur son propre code. Pas de recette d'attaque — le but est de savoir faire bien et de repérer ce qui est mal fait.

---

## À quoi ça sert, concrètement

**Parce que presque toute application a des comptes.** Dès qu'il y a « mon espace », « mes données », il faut authentifier. C'est une fonctionnalité que tu retrouveras dans chaque projet.

**Parce que c'est l'endroit le plus sensible du code.** Une erreur d'auth expose les comptes de tous les utilisateurs. Les erreurs classiques — mots de passe en clair ou mal hachés, pas de régénération de session, formulaires sans protection CSRF — sont exactement ce que tu dois savoir reconnaître et corriger, sur ton code comme en maintenance.

**Parce que le CSRF est spécifique au web à formulaires.** Au palier 4, ton API utilisait des jetons dans les en-têtes, naturellement moins exposés au CSRF. En PHP web classique, la session est portée par un cookie envoyé automatiquement par le navigateur — ce qui ouvre le CSRF, et impose le jeton anti-CSRF dans chaque formulaire. C'est une notion neuve et importante du palier.

**Et parce que construire l'auth à la main éclaire Breeze.** Laravel Breeze (leçon 11) te donne inscription, connexion, réinitialisation de mot de passe et protection CSRF en une commande. Après l'avoir fait à la main, tu sauras exactement ce qu'il met en place — et pourquoi.

---

## Où ça intervient dans le développement

L'auth s'appuie sur tout le module et ajoute une couche transversale :

```
   Formulaire (vue, leçon 09) + jeton CSRF caché
        ▼
   Contrôleur Auth (leçon 09)
    ├── inscription : password_hash → modèle PDO (leçon 05)
    ├── connexion   : password_verify + session_regenerate_id (leçon 04)
    └── vérifie le jeton CSRF à chaque POST
        ▼
   Session serveur = état connecté (leçon 04)
        ▼
   Middleware "connecté ?" devant les routes protégées (leçon 08)
```

Tout converge.

**C'est l'auth du palier 4, en session plutôt qu'en jeton d'API.** Le hachage (`password_hash`/`password_verify`), la validation, le principe « ne jamais stocker en clair » : identiques au palier 4 (leçon 08). Ce qui change, c'est le maintien de l'état — session serveur (leçon 04) au lieu de jeton renvoyé au client — et l'apparition du CSRF.

**Elle utilise les sessions de la leçon 04.** L'état connecté, c'est une donnée en session (`$_SESSION['user_id']`), avec les cookies sécurisés (httponly, secure, samesite) et la régénération d'identifiant vus à la leçon 04. Cette leçon en est l'application directe.

**Et elle se branche sur le routeur (leçon 08) via un middleware.** Les routes protégées passent d'abord par une vérification « connecté ? » — le middleware d'auth, concept vu au palier 4 (leçon 08). Ton routeur appelle ce garde avant le contrôleur.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas construire l'inscription (valider, hacher, enregistrer), la connexion (vérifier, régénérer la session, mémoriser l'utilisateur), la déconnexion (détruire la session), un garde pour les routes protégées, et la protection CSRF de tes formulaires. Tu examineras, en cadre défensif, ce qui rend une auth vulnérable — pour le corriger sur ton propre code.

### En équipe, en entreprise

**On n'écrit presque jamais l'auth à la main en production** — on utilise Breeze, Fortify (Laravel), ou un fournisseur d'identité. Écrire la sienne est risqué. Mais comprendre ses rouages est indispensable pour configurer ces outils, et surtout pour **auditer** du code existant.

**La maintenance de sites PHP, c'est souvent corriger l'auth.** Mots de passe stockés en MD5 ou en clair, pas de CSRF, sessions non régénérées : ce sont les failles les plus courantes des vieux sites PHP. Savoir les reconnaître et les corriger est une compétence directement monnayable.

**Le CSRF est attendu sur tout formulaire.** Les frameworks l'ajoutent automatiquement (`@csrf` dans Blade). Un formulaire POST sans jeton CSRF est signalé en revue.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : `password_hash`/`password_verify`, l'état connecté en session, la régénération de session à la connexion, le garde de routes, le jeton CSRF dans les formulaires.

Régulièrement : la réinitialisation de mot de passe par e-mail, le « se souvenir de moi », les rôles et permissions (autorisation), la limitation des tentatives de connexion.

Rare, et délégué : l'authentification à deux facteurs, OAuth/OpenID (« se connecter avec Google »), le SSO. Tu les rencontreras via des bibliothèques dédiées, jamais à la main.

---

## La mécanique

### L'inscription : valider, hacher, enregistrer

```php
<?php
public function inscrire(): void
{
    $email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
    $mdp   = $_POST['mot_de_passe'] ?? '';

    $erreurs = [];
    if (!$email) $erreurs['email'] = 'Email invalide';
    if (strlen($mdp) < 12) $erreurs['mot_de_passe'] = '12 caractères minimum';
    if ($this->utilisateurs->parEmail($email)) $erreurs['email'] = 'Déjà inscrit';

    if ($erreurs) {
        Vue::rendre('auth/inscription', ['erreurs' => $erreurs]);
        return;
    }

    // ⭐ On ne stocke JAMAIS le mot de passe en clair : on stocke son empreinte
    $empreinte = password_hash($mdp, PASSWORD_DEFAULT);
    $this->utilisateurs->creer($email, $empreinte);

    header('Location: /connexion');     // PRG (leçon 09)
    exit;
}
```

Le point crucial : `password_hash` transforme le mot de passe en une empreinte irréversible (bcrypt ou argon2 selon `PASSWORD_DEFAULT`), avec un sel aléatoire intégré. C'est ce qu'on stocke en base — **jamais** le mot de passe lui-même. C'est le réflexe du palier 4 (leçon 08), dans un deuxième langage. La colonne doit être assez longue (255) pour l'empreinte.

### La connexion : vérifier, puis régénérer la session

```php
<?php
public function connecter(): void
{
    $email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
    $mdp   = $_POST['mot_de_passe'] ?? '';

    $user = $this->utilisateurs->parEmail($email);

    // ⭐ password_verify compare le mot de passe fourni à l'empreinte stockée
    if ($user === null || !password_verify($mdp, $user['mot_de_passe'])) {
        // Message identique dans les deux cas : on ne révèle pas si l'email existe
        Vue::rendre('auth/connexion', ['erreur' => 'Identifiants incorrects']);
        return;
    }

    // ⭐ Régénérer l'ID de session à la connexion (anti-fixation, leçon 04)
    session_regenerate_id(true);
    $_SESSION['user_id'] = $user['id'];

    header('Location: /depenses');
    exit;
}
```

Trois points. `password_verify` compare le mot de passe fourni à l'empreinte stockée, sans jamais la déchiffrer (c'est impossible, et c'est voulu). Le **message d'erreur est identique** que l'email existe ou non — ne pas révéler quels comptes existent. Et `session_regenerate_id(true)` donne un **nouvel** identifiant de session à la connexion : c'est la protection contre la fixation de session vue à la leçon 04 — sans elle, un identifiant connu avant la connexion resterait valide après.

### La déconnexion

```php
<?php
public function deconnecter(): void
{
    $_SESSION = [];
    session_destroy();                   // on détruit la session serveur
    header('Location: /');
    exit;
}
```

Déconnexion = vider et détruire la session. L'utilisateur n'est plus reconnu à la requête suivante.

### Le garde des routes protégées (middleware)

```php
<?php
namespace App\Core;

class Garde
{
    public static function connecte(): void
    {
        if (empty($_SESSION['user_id'])) {
            header('Location: /connexion');
            exit;
        }
    }
}

// Au début d'une action protégée (ou dans le routeur, avant le contrôleur) :
Garde::connecte();
```

Le garde vérifie l'état connecté avant de laisser passer. C'est le middleware d'authentification du palier 4 (leçon 08) : une barrière devant les routes privées. On peut l'appeler en tête des actions protégées, ou l'attacher aux routes dans le routeur (leçon 08).

### ⭐ La protection CSRF

Le CSRF est **la** notion de sécurité neuve de ce palier. Le principe, en défensif : comme le navigateur envoie **automatiquement** le cookie de session avec chaque requête vers ton site, un autre site pourrait soumettre un formulaire vers le tien en profitant de ce cookie. La parade : exiger, dans chaque formulaire, un **jeton secret** que seul ton site connaît et qu'un site tiers ne peut pas deviner.

```php
<?php
// 1. On génère un jeton par session (une fois)
function jeton_csrf(): string
{
    if (empty($_SESSION['csrf'])) {
        $_SESSION['csrf'] = bin2hex(random_bytes(32));   // aléatoire imprévisible
    }
    return $_SESSION['csrf'];
}

// 2. On vérifie le jeton reçu à chaque POST, en comparaison à temps constant
function verifier_csrf(): void
{
    $recu = $_POST['csrf'] ?? '';
    if (empty($_SESSION['csrf']) || !hash_equals($_SESSION['csrf'], $recu)) {
        http_response_code(419);
        exit('Jeton CSRF invalide');
    }
}
```

```php
<?php // Dans CHAQUE formulaire (vue, leçon 09) : ?>
<form method="post" action="/depenses">
    <input type="hidden" name="csrf" value="<?= e(jeton_csrf()) ?>">
    <!-- ... les autres champs ... -->
</form>
```

```php
<?php // Au début de CHAQUE action POST : ?>
verifier_csrf();
```

Lis la logique : un jeton aléatoire imprévisible (`random_bytes`) est stocké en session et inséré, caché, dans chaque formulaire. À la réception d'un POST, on vérifie que le jeton reçu correspond à celui de la session, avec `hash_equals` (comparaison à temps constant, qui ne fuit pas d'information par sa durée). Un formulaire forgé par un autre site ne peut pas contenir le bon jeton — il est rejeté. C'est exactement ce que fait `@csrf` dans Blade (leçon 11), automatiquement.

### Le hachage, ce n'est pas le chiffrement

Un point à bien ancrer : `password_hash` **hache**, il ne **chiffre** pas. Un hachage est irréversible — on ne peut pas retrouver le mot de passe à partir de l'empreinte, et c'est précisément le but. On ne « déchiffre » jamais un mot de passe : on re-hache celui qu'on reçoit et on compare (`password_verify`). Confondre hachage et chiffrement est une erreur de débutant que tu ne feras pas.

---

## Les problèmes que tu vas rencontrer

**Je stocke le mot de passe, il est en clair en base.** La faute grave. Utilise `password_hash` ; la base ne doit contenir que l'empreinte. Si tu vois un mot de passe lisible en base, c'est à corriger de toute urgence.

**`password_verify` renvoie toujours `false`.** La colonne est trop courte et tronque l'empreinte (mets 255), ou tu compares à la mauvaise valeur, ou tu as re-haché avant de comparer (ne hache pas à la connexion — `password_verify` s'en charge).

**Mon formulaire renvoie « Jeton CSRF invalide ».** Le champ caché `csrf` manque dans le formulaire, ou la session a expiré, ou tu as régénéré le jeton entre l'affichage et l'envoi. Vérifie que chaque formulaire inclut le jeton et que tu ne le régénères pas à tort.

**Je reste « connecté » même après la déconnexion.** `session_destroy` seul ne vide pas `$_SESSION` dans la requête en cours ; vide aussi `$_SESSION = []`. Et vérifie que le cookie de session est bien invalidé.

**Mon message d'erreur révèle que l'email existe.** « Email inconnu » puis « Mauvais mot de passe » permet d'énumérer les comptes. Donne le **même** message dans les deux cas.

**Après connexion, l'identifiant de session n'a pas changé.** Tu as oublié `session_regenerate_id(true)`. Sans lui, la session reste vulnérable à la fixation (leçon 04).

**`headers already sent` sur mes redirections.** Une sortie (HTML, espace) est partie avant `header('Location')`. Les redirections d'auth doivent précéder tout affichage — fais-les dans le contrôleur, avant la vue (leçon 09).

---

## Ce qu'on te demandera

En **entretien PHP**, l'auth et la sécurité sont des sujets de prédilection. « Comment stockes-tu un mot de passe ? » (haché, jamais en clair, `password_hash`) ; **« qu'est-ce que le CSRF et comment t'en protèges-tu ? »** (jeton secret par session dans chaque formulaire) ; « pourquoi régénérer la session à la connexion ? » (fixation) ; « différence entre hachage et chiffrement ? » (irréversible vs réversible).

On peut demander : « pourquoi un même message d'erreur pour email inconnu et mauvais mot de passe ? », « différence entre authentification et autorisation ? ».

En **mission**, on te confiera l'audit ou la correction d'une auth existante — reconnaître les mots de passe mal stockés, ajouter le CSRF manquant — bien plus souvent qu'écrire une auth de zéro.

---

## Ce qui te démarquera

**Savoir que l'auth maison est à éviter en production.** Dire « je sais la construire, donc je sais ce que Breeze fait et je peux l'auditer, mais en production j'utilise un outil éprouvé » est une réponse mature. Réinventer l'auth est une source de failles.

**Maîtriser le CSRF.** C'est la notion que beaucoup d'autodidactes ignorent. Pouvoir expliquer pourquoi le web à cookies y est exposé (le cookie part automatiquement) et comment le jeton le ferme te distingue nettement.

**Le réflexe « haché, jamais en clair, jamais déchiffré ».** Comprendre qu'un mot de passe ne se déchiffre pas — qu'on re-hache et compare — montre que tu as compris la cryptographie de base, pas récité une fonction.

**Les petits détails de sécurité.** Message d'erreur neutre, régénération de session, comparaison à temps constant (`hash_equals`) : ces détails, invisibles pour un débutant, signalent un développeur conscient des enjeux.

**Et reconnaître une mauvaise auth.** En maintenance, pouvoir dire « ces mots de passe sont en MD5, il n'y a pas de CSRF, les sessions ne sont pas régénérées — voici le plan de correction » est exactement la valeur qu'on attend.

---

## 📚 À lire

**php.net → *password_hash*, *password_verify*, *password_needs_rehash*** : la façon correcte et moderne de gérer les mots de passe en PHP.

**OWASP → *Password Storage Cheat Sheet*** et ***Cross-Site Request Forgery Prevention Cheat Sheet*** : les deux références défensives de cette leçon — comment stocker, comment protéger les formulaires.

**php.net → *session_regenerate_id*, *random_bytes*, *hash_equals*** : les fonctions de sécurité utilisées ici, et pourquoi (anti-fixation, aléa imprévisible, comparaison à temps constant).

**Documentation Laravel → *Authentication*, *CSRF Protection*, *Starter Kits (Breeze)*** : lis-la après avoir tout construit. Tu reconnaîtras chaque brique — et tu verras qu'une commande Breeze met en place ce que tu as fait à la main.

Relis le palier 4, leçon 08 (auth) et leçon 09 (OWASP) : même sécurité, contexte session + CSRF en plus.

---

## 🤖 Le mini-projet à demander à l'IA

Construire une auth correcte, et apprendre à repérer ce qui cloche (défensif) :

> « Je suis en formation de développeur, palier 6. Je construis une authentification PHP maison (inscription, connexion, déconnexion, sessions) pour comprendre ce que fait Laravel Breeze avant de l'utiliser. Je connais déjà le hachage de mot de passe du palier 4. Sans écrire le code à ma place, guide-moi par questions : comment hacher et vérifier un mot de passe avec password_hash/password_verify, pourquoi je régénère la session à la connexion, et comment un garde protège les routes privées. Quand je te montre mon code, vérifie que je ne stocke jamais de mot de passe en clair et que mes messages d'erreur ne révèlent pas quels comptes existent. »

Puis le CSRF, en cadre défensif :

> « Explique-moi le CSRF comme un principe : pourquoi un site web qui s'appuie sur un cookie de session y est exposé (le navigateur envoie le cookie automatiquement), et comment un jeton secret par session dans chaque formulaire ferme le problème. Sans me donner de scénario d'attaque exploitable, aide-moi à vérifier que CHACUN de mes formulaires POST inclut le jeton et que chaque action POST le vérifie avec hash_equals. Puis montre-moi à quoi ressemble un formulaire ou un site "à l'ancienne" sans CSRF et demande-moi d'identifier ce qui manque et comment le corriger. »

---

## 🛠️ À faire

1. **La table `utilisateurs`** : `id`, `email` (unique), `mot_de_passe` (255), `cree_le`. Contraintes comprises (leçon 05, palier 4).
2. **⭐ L'inscription** : valide l'email et la longueur du mot de passe, refuse les doublons, **hache** avec `password_hash`, enregistre. Vérifie en base que c'est bien une empreinte, pas le mot de passe.
3. **⭐ La connexion** : vérifie avec `password_verify`, affiche un message **identique** en cas d'email inconnu ou de mauvais mot de passe, puis `session_regenerate_id(true)` et mémorise `user_id`.
4. **La déconnexion** : vide et détruit la session, et vérifie qu'on n'est plus reconnu.
5. **Le garde** : protège `/depenses` ; un visiteur non connecté est redirigé vers `/connexion`. Un connecté passe.
6. **⭐ Le CSRF** : génère un jeton par session, insère-le (caché) dans **chaque** formulaire, et vérifie-le avec `hash_equals` au début de **chaque** action POST. Soumets un formulaire sans le jeton et constate le rejet (419).
7. **Les détails de sécurité** : confirme que l'ID de session change à la connexion, que le message d'erreur est neutre, que la comparaison CSRF utilise `hash_equals`.
8. **Audit défensif** : sur une copie de test, introduis puis corrige trois erreurs classiques — mot de passe stocké en clair, pas de régénération de session, formulaire sans CSRF. Pour chacune, note le symptôme et la correction.
9. **Le lien** : note dans ton journal ce que Breeze (leçon 11) fera automatiquement, brique par brique, par rapport à ton code.
10. **Hachage ≠ chiffrement** : écris dans ton journal, en une phrase, pourquoi un mot de passe ne se déchiffre pas.

<details>
<summary>Corrections et points de contrôle</summary>

**2-3.** Les deux réflexes d'or. `password_hash($mdp, PASSWORD_DEFAULT)` produit une empreinte irréversible avec sel intégré ; c'est elle qu'on stocke. `password_verify($mdp, $empreinte)` compare sans jamais déchiffrer. **Jamais de mot de passe en clair en base.** C'est exactement le palier 4 (leçon 08), dans un deuxième langage — la preuve que la sécurité se transfère.

**3 (message neutre).** « Email inconnu » puis « Mauvais mot de passe » permet à un tiers d'énumérer les comptes existants (une fuite d'information). Un **message identique** dans les deux cas (« Identifiants incorrects ») ferme cette fuite. Détail invisible pour un débutant, réflexe attendu d'un pro.

**3 (régénération).** `session_regenerate_id(true)` donne un nouvel identifiant de session à la connexion. Sans lui, un identifiant obtenu avant la connexion resterait valide après — la fixation de session (leçon 04). Régénère **à chaque** élévation de privilège (connexion notamment).

**6.** Le CSRF est la notion neuve du palier. Le web à cookies y est exposé parce que le navigateur envoie le cookie de session **automatiquement** avec toute requête vers ton domaine, y compris une requête déclenchée par un autre site. Le jeton secret par session, imprévisible (`random_bytes`) et vérifié à temps constant (`hash_equals`), ne peut pas être reproduit par un site tiers : le formulaire forgé est rejeté. **C'est exactement ce que `@csrf` de Blade met en place automatiquement.** Ton API du palier 4, elle, utilisait des jetons dans les en-têtes — moins exposés de la même façon ; d'où une notion propre au web à formulaires.

**10.** Hachage ≠ chiffrement : le chiffrement est **réversible** (avec la clé, on retrouve le message) ; le hachage est **irréversible** (on ne retrouve jamais le mot de passe depuis l'empreinte). On ne déchiffre jamais un mot de passe — on re-hache celui qu'on reçoit et on compare. C'est voulu : même en cas de fuite de la base, les mots de passe ne sont pas récupérables. **Confondre les deux est l'erreur de débutant que tu ne feras pas.**
</details>

---

## ✅ Acquis si…

- [ ] Je hache les mots de passe avec `password_hash` et je vérifie avec `password_verify`.
- [ ] Je ne stocke jamais de mot de passe en clair, et je sais qu'un hachage ne se déchiffre pas.
- [ ] Je régénère l'identifiant de session à la connexion (anti-fixation).
- [ ] Je donne un message d'erreur identique pour email inconnu et mauvais mot de passe.
- [ ] Je protège les routes privées par un garde (middleware « connecté ? »).
- [ ] J'insère un jeton CSRF dans **chaque** formulaire et je le vérifie à **chaque** POST avec `hash_equals`.
- [ ] Je sais expliquer pourquoi le web à cookies est exposé au CSRF.
- [ ] Je sais reconnaître et corriger une auth vulnérable (clair, pas de CSRF, pas de régénération).
- [ ] Je sais que l'auth maison s'évite en production, et je fais le lien avec Breeze.

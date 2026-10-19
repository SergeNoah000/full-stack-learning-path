# Leçon 04 — Superglobales, sessions, cookies, upload de fichiers

> 🎯 **À la fin de cette leçon** : tu manipules l'API web brute de PHP, tu maintiens une session malgré le modèle « tout meurt à la fin », et tu connais les pièges de sécurité des uploads.
> ⏱️ 4 h · **Prérequis** : leçons 01–03, et la leçon 07 du palier 0 (HTTP sans état).

---

## De quoi on parle

Les **superglobales** sont des tableaux que PHP remplit automatiquement pour chaque requête, et qui donnent accès direct à l'API du web : `$_GET` (la query string), `$_POST` (les données de formulaire), `$_SERVER` (les informations de la requête et du serveur), `$_SESSION` (les données de session), `$_COOKIE` (les cookies), `$_FILES` (les fichiers uploadés).

C'est **l'API brute du web, sans intermédiaire**. Là où Express te donnait `req.body` et FastAPI un modèle typé, PHP te donne directement `$_POST["montant"]`. C'est simple et direct — et dangereux, parce que ces données viennent du client : ce sont des **frontières** (palier 1, leçon 01), suspectes par nature.

Les **sessions** résolvent le problème du modèle d'exécution (leçon 01) : comme tout meurt à la fin de la requête, PHP stocke les données de session sur le **serveur** (par défaut, dans des fichiers) et pose un cookie d'identifiant pour les retrouver à la requête suivante. Et les **uploads de fichiers** (`$_FILES`) ont des pièges de sécurité spécifiques qu'il faut connaître.

---

## À quoi ça sert, concrètement

**Parce que c'est ainsi que PHP reçoit les données.** Tout formulaire, toute requête, tout fichier uploadé arrive par une superglobale. Les connaître est la base de tout traitement en PHP natif. Et les voir « à nu » te fait comprendre ce que les frameworks (et ton MVC maison des leçons 07-10) enveloppent.

**Parce que les sessions sont la réponse au modèle d'exécution.** Tu as vu à la leçon 01 que rien ne survit entre deux requêtes. Pourtant, un utilisateur reste « connecté » d'une page à l'autre. La session est ce qui rend ça possible : elle rétablit la continuité par-dessus HTTP sans état (palier 0, leçon 07), exactement comme les sessions du palier 4 (leçon 08) et de Flask (palier 5). PHP l'a intégrée nativement.

**Parce que les superglobales sont dangereuses, et qu'il faut le savoir.** Elles contiennent des données **entièrement contrôlées par le client** — y compris une partie de `$_SERVER`. Toute donnée qui en sort doit être validée et échappée (leçon 09). C'est la frontière du palier 1, et c'est là que les failles du palier 4 (injection, XSS) se préparent ou se préviennent.

**Et parce que les uploads sont un vecteur d'attaque classique.** Un fichier uploadé peut mentir sur son type, contenir du code exécutable, ou écraser un fichier existant. Connaître ces pièges est une compétence de sécurité directe, et c'est précisément ce qui manque dans beaucoup de sites PHP en maintenance.

---

## Où ça intervient dans le développement

Les superglobales sont le point d'entrée des données dans ton application PHP :

```
   NAVIGATEUR
     │  formulaire, query string, fichier, cookie
     ▼
   SUPERGLOBALES ($_GET, $_POST, $_FILES, $_COOKIE)   ← CETTE LEÇON : l'API brute
     │  ⚠️ données du client = suspectes (frontière, palier 1)
     ▼
   validation + échappement (leçon 09)
     ▼
   ton code

   $_SESSION ←──── cookie d'identifiant ──── maintient la continuité (modèle d'exécution, leçon 01)
```

Trois points structurants.

**Les superglobales sont la Request brute.** Au palier 4, Express te donnait `req.body`, `req.query`, `req.params` ; au palier 5, tu as construit une classe `Request` qui enveloppait `environ`. Ici, PHP te donne directement `$_POST`, `$_GET`, `$_SERVER`. Dans ton MVC maison (leçon 09), tu les envelopperas dans ta propre classe Request — refaisant ce que tu as fait au palier 5.

**Les sessions relient le modèle d'exécution à l'authentification.** Parce que tout meurt à la fin de la requête (leçon 01), la session sur disque est la seule façon de garder un utilisateur connecté. Tu l'utiliseras pour l'auth de ton MVC maison (leçon 10), avec le jeton CSRF — exactement le mécanisme du palier 4 (leçon 08).

**Et les uploads préparent une fonctionnalité réelle.** Ton projet 6b (une app métier) aura probablement des uploads (justificatifs, images). Les pièges de sécurité que tu vois ici y seront directement applicables.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas manipuler les superglobales directement, et sentir à quel point c'est « brut » comparé à Express ou FastAPI. C'est volontaire : voir l'API nue te fait comprendre ce que les frameworks abstraient.

Tu vas aussi démarrer ta première session et constater qu'un utilisateur reste identifié d'une page à l'autre — malgré le « tout meurt à la fin » de la leçon 01. Le cookie de session est ce qui rend ça possible.

### En équipe, en entreprise

**On n'accède pas directement aux superglobales dans du code moderne.** Les frameworks (et ton MVC maison) les enveloppent dans des objets Request, pour centraliser la validation et faciliter les tests. Mais en maintenance, tu verras du code qui lit `$_POST` partout — avec les failles que ça implique.

**Les sessions sont souvent déplacées hors des fichiers.** Par défaut, PHP stocke les sessions dans des fichiers sur le serveur. En production, avec plusieurs serveurs (palier 7, scalabilité), on les déplace dans Redis ou une base — parce qu'un fichier sur un serveur n'est pas vu par les autres. C'est le même problème que `express-session` en mémoire au palier 4.

**Les uploads sont une source fréquente de failles.** Beaucoup de sites PHP acceptent des uploads sans vérifier le type réel ni empêcher l'exécution. C'est un vecteur d'attaque classique, et savoir le sécuriser est un argument en maintenance.

**Et tu verras des sessions mal gérées.** Pas de régénération d'identifiant à la connexion (fixation de session), pas d'expiration, cookies sans les bons attributs. Ce sont des failles que tu sauras éviter.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : `$_GET`, `$_POST`, `$_SERVER`, `$_SESSION`, `$_COOKIE`, `$_FILES`, et les attributs de cookie sécurisés.

Rare, et hors sujet pour l'instant : les gestionnaires de session personnalisés, `$_ENV` et `getenv` (pour la configuration), les sessions en base/Redis (palier 7/8), les uploads multiples et le streaming de gros fichiers, les en-têtes de cache fins. Tu les rencontreras par besoin.

---

## La mécanique

### Les superglobales

```php
<?php
// $_GET : la query string (/recherche?q=taxi&page=2)
$recherche = $_GET["q"] ?? "";            // ?? : valeur par défaut (palier 3/5)
$page = (int) ($_GET["page"] ?? 1);        // ⚠️ TOUJOURS une chaîne : on convertit

// $_POST : les données de formulaire (méthode POST)
$montant = (int) ($_POST["montant"] ?? 0);
$description = $_POST["description"] ?? "";

// $_SERVER : les informations de la requête
$methode = $_SERVER["REQUEST_METHOD"];     // "GET", "POST"
$uri = $_SERVER["REQUEST_URI"];            // le chemin (leçon 02)
$ip = $_SERVER["REMOTE_ADDR"];             // ⚠️ falsifiable derrière un proxy
```

Toute donnée d'une superglobale est **une chaîne** (ou un tableau de chaînes), et vient du **client**. C'est la frontière du palier 1 (leçon 01) : on convertit (`(int)`), on vérifie, on ne fait jamais confiance. Et `??` donne une valeur par défaut quand la clé est absente — le réflexe du palier 3 et 5.

> ⚠️ `$_SERVER` contient des valeurs fournies par le serveur (fiables) **et** par le client (falsifiables). `$_SERVER["REMOTE_ADDR"]` (l'IP) est fiable, mais `$_SERVER["HTTP_USER_AGENT"]` ou `$_SERVER["HTTP_REFERER"]` sont contrôlés par le client. Ne base jamais une décision de sécurité sur une valeur falsifiable.

### ⭐ Les sessions : la continuité malgré le modèle d'exécution

```php
<?php
session_start();                          // ⭐ au tout début, AVANT toute sortie

// Écrire dans la session
$_SESSION["utilisateur_id"] = 42;

// Lire (à la requête SUIVANTE, le modèle d'exécution a tout détruit entre les deux)
$uid = $_SESSION["utilisateur_id"] ?? null;
if ($uid === null) {
    // non connecté
}

// Détruire la session (déconnexion)
session_destroy();
```

Voici ce qui résout le problème de la leçon 01 : entre deux requêtes, **tout meurt** — sauf la session, que PHP stocke sur le **serveur** (dans un fichier par défaut) et retrouve grâce à un **cookie d'identifiant** (`PHPSESSID`). `session_start()` lit ce cookie, charge les données correspondantes dans `$_SESSION`, et à la fin de la requête, PHP les sauvegarde sur disque.

C'est exactement le mécanisme de session du palier 4 (leçon 08) et de Flask (palier 5) : un cookie rétablit la continuité par-dessus HTTP sans état (palier 0, leçon 07). PHP l'a intégré nativement, parce que son modèle d'exécution l'exige.

> ⚠️ `session_start()` doit être appelé **avant toute sortie** (tout `echo`, tout HTML, tout espace avant `<?php`), car il envoie un en-tête `Set-Cookie`. L'erreur « headers already sent » vient de là, et c'est un piège classique de PHP.

### Les cookies sécurisés

```php
<?php
// Poser un cookie avec les bons attributs de sécurité
setcookie("preference", "sombre", [
    "httponly" => true,                   // ⭐ inaccessible au JavaScript (anti-XSS)
    "secure" => true,                     // ⭐ HTTPS uniquement
    "samesite" => "Lax",                  // ⭐ anti-CSRF
    "expires" => time() + 86400 * 7,
]);

$pref = $_COOKIE["preference"] ?? "clair";
```

Les trois attributs sont ceux du palier 4 (leçon 08) : `httponly` empêche le vol par XSS, `secure` impose HTTPS, `samesite` limite la CSRF. Et pour la session elle-même, on configure ces attributs avec `session_set_cookie_params()` **avant** `session_start()`.

### La sécurité des sessions

```php
<?php
// À la CONNEXION : régénérer l'identifiant (anti-fixation de session)
session_start();
// ... vérifier l'utilisateur ...
session_regenerate_id(true);              // ⭐ nouvel identifiant après authentification
$_SESSION["utilisateur_id"] = $utilisateur->id;
```

`session_regenerate_id()` à la connexion empêche la **fixation de session** : une attaque où l'attaquant impose un identifiant de session à la victime, puis le réutilise une fois qu'elle s'est connectée. En régénérant l'identifiant après l'authentification, l'ancien devient inutile. C'est un détail de sécurité que beaucoup de sites oublient.

### ⭐ Les uploads de fichiers et leurs pièges

```php
<?php
if (isset($_FILES["justificatif"])) {
    $fichier = $_FILES["justificatif"];

    // 1. Vérifier qu'il n'y a pas eu d'erreur
    if ($fichier["error"] !== UPLOAD_ERR_OK) { /* gérer l'erreur */ }

    // 2. ⚠️ Vérifier le type RÉEL, pas celui déclaré par le client
    $finfo = new finfo(FILEINFO_MIME_TYPE);
    $typeReel = $finfo->file($fichier["tmp_name"]);
    if (!in_array($typeReel, ["image/jpeg", "image/png", "application/pdf"])) {
        /* refuser */
    }

    // 3. ⚠️ Générer un nom SÛR, ne jamais utiliser le nom fourni par le client
    $extension = match($typeReel) {
        "image/jpeg" => "jpg", "image/png" => "png", "application/pdf" => "pdf",
    };
    $nomSur = bin2hex(random_bytes(16)) . "." . $extension;

    // 4. ⚠️ Stocker HORS du dossier web exécutable
    move_uploaded_file($fichier["tmp_name"], "/var/uploads/" . $nomSur);
}
```

Les quatre pièges de sécurité, et c'est le cœur de cette partie :

**Le type déclaré ment.** `$fichier["type"]` est fourni par le client et falsifiable : un attaquant peut envoyer un script PHP en prétendant que c'est une image. Il faut vérifier le type **réel** du contenu avec `finfo`.

**Le nom fourni est dangereux.** Utiliser `$fichier["name"]` tel quel permet une traversée de répertoire (`../../`, le piège du palier 4, leçon 01) ou l'écrasement d'un fichier existant. Génère **toujours** un nom aléatoire.

**L'emplacement compte.** Si tu stockes les uploads dans le dossier web avec leur extension d'origine, un fichier `.php` uploadé pourrait être **exécuté** en le visitant. Stocke hors du `DocumentRoot` (le `public/` de la leçon 01), ou dans un dossier où l'exécution PHP est désactivée (par `.htaccess`, leçon 02).

**La taille doit être limitée.** Sans limite, un gros fichier sature le serveur. PHP a des limites (`upload_max_filesize`), et tu dois les vérifier aussi côté application.

---

## Les problèmes que tu vas rencontrer

**`Warning: headers already sent`.** Tu as appelé `session_start()` ou `setcookie()` **après** une sortie (un `echo`, du HTML, un espace avant `<?php`). Ces fonctions envoient des en-têtes, qui doivent partir avant tout contenu. Place `session_start()` en toute première ligne.

**Ma session ne persiste pas entre les pages.** Tu as oublié `session_start()` sur l'une des pages, ou les cookies sont bloqués, ou `secure => true` en local sans HTTPS empêche l'envoi.

**`$_POST` est vide alors que j'ai soumis un formulaire.** Le formulaire n'est pas en `method="post"`, ou il manque `enctype="multipart/form-data"` pour un upload, ou la requête n'a pas le bon `Content-Type`.

**Mon `$_GET["page"]` est une chaîne.** Toute superglobale est une chaîne. `(int)` pour convertir, et vérifie la valeur (frontière du palier 1).

**Un utilisateur a uploadé un fichier `.php` qui s'est exécuté.** Tu as stocké l'upload dans le dossier web avec son nom d'origine. C'est une faille grave : type réel non vérifié, nom non assaini, emplacement exécutable. Applique les quatre règles.

**Ma session fonctionne en local mais pas en production multi-serveurs.** Les sessions en fichiers ne sont pas partagées entre serveurs. Déplace-les dans Redis ou une base (palier 7/8) — le même problème qu'`express-session` en mémoire au palier 4.

**Je base une vérification sur `$_SERVER["HTTP_REFERER"]`.** C'est falsifiable (fourni par le client). Ne l'utilise jamais pour une décision de sécurité.

---

## Ce qu'on te demandera

En **entretien PHP**, les questions portent sur les sessions et la sécurité : **« comment fonctionne une session en PHP, vu que tout meurt à la fin de la requête ? »** (la réponse relie le modèle d'exécution et le cookie d'identifiant), « quels attributs mets-tu sur un cookie de session ? », « quels sont les pièges d'un upload de fichier ? ».

La question qui distingue : **« pourquoi ne faut-il pas faire confiance au type d'un fichier uploadé ? »** — parce qu'il est déclaré par le client et falsifiable.

En **test technique** ou en maintenance, on peut te demander de sécuriser un upload existant, ou de corriger une gestion de session défaillante.

---

## Ce qui te démarquera

**Relier la session au modèle d'exécution.** « Comme tout meurt à la fin de la requête en PHP, la session vit sur le serveur et un cookie la retrouve » est une réponse qui montre que tu as compris l'architecture de PHP (leçon 01).

**Les quatre règles de sécurité des uploads.** Type réel, nom assaini, emplacement non exécutable, taille limitée. C'est précis, c'est une faille réelle et fréquente, et peu de développeurs PHP les connaissent toutes.

**La régénération d'identifiant à la connexion.** Connaître la fixation de session et sa parade (`session_regenerate_id`) est un détail de sécurité rare à ce niveau.

**Les attributs de cookie.** `httponly`, `secure`, `samesite` : les mêmes qu'au palier 4, signe que tu transfères tes réflexes de sécurité d'un langage à l'autre.

**Et savoir que les superglobales sont une frontière.** Dire « ce sont des données du client, donc suspectes, à valider et échapper » relie cette leçon au palier 1 et prépare la sécurité de la leçon 09.

---

## 📚 À lire

**php.net → *Superglobals*** et les pages de `$_GET`, `$_POST`, `$_SERVER`, `$_SESSION`, `$_FILES`. La référence, avec des commentaires utiles.

**php.net → *Sessions*** : le fonctionnement, `session_start`, la configuration des cookies de session, `session_regenerate_id`.

**php.net → *Handling file uploads*** et **OWASP → *File Upload Cheat Sheet*** : la référence sur la sécurité des uploads. Lis-la — les pièges y sont tous décrits.

**OWASP → *Session Management Cheat Sheet*** pour les bonnes pratiques de session.

Relis le palier 4, leçon 08 (sessions, cookies) : le mécanisme est le même, PHP l'a juste intégré.

---

## 🤖 Le mini-projet à demander à l'IA

La sécurité des uploads et des sessions, en cadre défensif :

> « Je suis en formation de développeur, palier 6. Je veux sécuriser la gestion des uploads et des sessions dans mon code PHP. Agis comme un relecteur de sécurité qui m'aide à auditer MON code. Pour les uploads, pose-moi des questions pour vérifier les quatre points (type réel vérifié, nom assaini, emplacement non exécutable, taille limitée). Pour les sessions, vérifie les attributs de cookie, la régénération d'identifiant à la connexion, et l'expiration. Ne me donne pas les solutions : pose la question, je montre mon code, tu dis si c'est sûr. »

Puis le lien avec le modèle d'exécution :

> « Explique-moi, sans code, comment une session PHP maintient un utilisateur connecté alors que, comme tu me l'as fait découvrir à la leçon 01, tout meurt à la fin de chaque requête. Pose-moi des questions pour que je reconstruise le mécanisme : où sont stockées les données, comment PHP les retrouve, quel est le rôle du cookie. Puis compare avec les sessions du palier 4 (Express) et de Flask. »

---

## 🛠️ À faire

1. **Les superglobales** : un formulaire qui envoie des données en POST, et un script qui lit `$_POST`, `$_GET`, et quelques clés de `$_SERVER`. Convertis et vérifie chaque valeur (frontière).
2. **Le piège de la chaîne** : récupère `$_GET["page"]`, constate que c'est une chaîne, convertis avec `(int)`.
3. **⭐ Une session** : `session_start()`, écris une valeur, et vérifie sur une **autre** page qu'elle persiste — malgré le modèle d'exécution de la leçon 01. Écris dans ton journal pourquoi ça marche.
4. **Le piège `headers already sent`** : mets un `echo` avant `session_start()`, constate l'erreur, puis corrige en plaçant `session_start()` en première ligne.
5. **Les cookies sécurisés** : pose un cookie avec `httponly`, `secure`, `samesite`. Essaie de le lire avec `document.cookie` dans le navigateur et constate l'échec (grâce à `httponly`).
6. **La régénération d'identifiant** : simule une connexion avec `session_regenerate_id(true)`, et note pourquoi ça protège de la fixation de session.
7. **⭐ Un upload sécurisé** : un formulaire d'upload (`enctype="multipart/form-data"`), et un script qui applique les quatre règles (type réel, nom aléatoire, emplacement sûr, taille limitée).
8. **Démontre le piège** : en cadre défensif sur ta machine, essaie d'uploader un fichier `.php` en le renommant en `.jpg`, et vérifie que ta vérification du type réel le refuse. Puis vérifie que même accepté, il ne serait pas exécutable là où tu le stockes.
9. **Les sessions en production** : note dans ton journal pourquoi les sessions en fichiers posent problème avec plusieurs serveurs, et quelle est la solution (lien avec le palier 4 et le palier 7).

<details>
<summary>Corrections et points de contrôle</summary>

**3.** La session persiste parce que PHP stocke les données sur le **serveur** (dans un fichier) et pose un cookie `PHPSESSID` chez le client. À la requête suivante, `session_start()` lit ce cookie, retrouve le fichier, et recharge `$_SESSION`. **C'est la réponse au modèle d'exécution de la leçon 01** : tout meurt, sauf ce qui est explicitement persisté (session ou base). C'est le même mécanisme qu'au palier 4 (Express) et Flask — le cookie rétablit la continuité par-dessus HTTP sans état.

**4.** `session_start()` envoie un en-tête `Set-Cookie`. Or les en-têtes HTTP doivent partir **avant** tout contenu (c'est la structure d'une réponse HTTP, palier 0, leçon 07). Un `echo` avant `session_start()` envoie du contenu, donc les en-têtes sont « déjà envoyés » et PHP refuse. La règle : `session_start()` (et tout `setcookie`, toute redirection) en **premier**, avant toute sortie. Attention aussi aux espaces ou lignes vides avant `<?php`.

**8.** C'est la démonstration de sécurité de la leçon. Le type déclaré par le client (`$_FILES["x"]["type"]`) peut dire « image/jpeg » alors que le fichier est un script PHP. Seule la vérification du **contenu réel** avec `finfo` le détecte. Et même si un fichier malveillant passait, le stocker hors du dossier web exécutable (ou dans un dossier où PHP est désactivé) l'empêche d'être exécuté en le visitant. **Les quatre règles sont cumulatives** : chacune ferme un vecteur d'attaque. C'est exactement le genre de faille qu'on trouve dans les sites PHP en maintenance, et savoir la corriger est un argument direct.
</details>

---

## ✅ Acquis si…

- [ ] Je lis `$_GET`, `$_POST`, `$_SERVER`, et je convertis/vérifie chaque valeur (frontière).
- [ ] Je sais que les superglobales contiennent des données du client, donc suspectes.
- [ ] J'utilise les sessions, et j'explique comment elles survivent au modèle d'exécution.
- [ ] Je place `session_start()` avant toute sortie, et je sais pourquoi.
- [ ] Je pose des cookies avec `httponly`, `secure`, `samesite`.
- [ ] Je régénère l'identifiant de session à la connexion (anti-fixation).
- [ ] Je sécurise un upload : type réel, nom aléatoire, emplacement non exécutable, taille limitée.
- [ ] Je sais pourquoi on ne fait jamais confiance au type déclaré d'un fichier.
- [ ] Je sais pourquoi les sessions en fichiers posent problème en multi-serveurs.

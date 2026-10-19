# Leçon 02 — `.htaccess` : réécriture d'URL, protection de dossier, redirections

> 🎯 **À la fin de cette leçon** : tu écris des règles `.htaccess` sans copier-coller, et tu comprends le pattern qui est à la base de **tous** les frameworks PHP : le front controller.
> ⏱️ 4 h · **Prérequis** : leçon 01 (Apache).

---

## De quoi on parle

Un **`.htaccess`** est un fichier de configuration d'Apache placé dans un dossier, qui s'applique à ce dossier et à ses sous-dossiers. Il permet de modifier le comportement du serveur **sans toucher à sa configuration globale** — ce qui est précieux sur l'hébergement mutualisé, où tu n'as pas accès à la configuration d'Apache.

Son usage central est la **réécriture d'URL** (*rewriting*) : transformer une URL propre (`/article/42`) en un appel réel (`index.php?id=42`), de façon invisible pour le visiteur. Le module d'Apache qui fait ça s'appelle **mod_rewrite**.

De la réécriture découle le **front controller** : une règle qui redirige **toutes** les requêtes vers un unique fichier `index.php`. C'est le fondement de tous les frameworks PHP, et tu le construiras à la leçon 07.

Le `.htaccess` sert aussi à **protéger des dossiers**, faire des **redirections** (301, 302), et définir des **pages d'erreur** personnalisées.

---

## À quoi ça sert, concrètement

**Parce que c'est partout dans le monde PHP.** WordPress, Laravel, les sites sur mesure : tous utilisent un `.htaccess` pour le front controller et les URL propres. En mission de maintenance PHP, tu en rencontreras constamment, et savoir les lire et les modifier est indispensable.

**Parce que c'est le seul moyen de configurer Apache en mutualisé.** Sur l'hébergement partagé (le plus courant pour PHP, et là où tu déploieras ton projet 6b), tu n'as pas accès à la configuration globale d'Apache. Le `.htaccess` est ta seule prise sur le serveur : réécriture, protection, redirections, tout passe par lui.

**Parce que le front controller est le concept le plus important de la leçon.** Rediriger toutes les requêtes vers `index.php` est ce qui permet d'avoir un routeur (leçon 08), des URL propres, et une application structurée. C'est exactement ce que fait le routeur WSGI que tu as construit au palier 5 — mais ici, c'est Apache qui achemine tout vers ton point d'entrée unique.

**Et parce que les URL propres comptent.** `/article/mon-titre` est meilleur que `/index.php?id=42` pour le référencement, pour les utilisateurs, et pour la maintenance. La réécriture d'URL est ce qui les rend possibles.

---

## Où ça intervient dans le développement

Le `.htaccess` est la couche entre Apache et ton code PHP :

```
   NAVIGATEUR
     │  GET /depenses/42
     ▼
   APACHE + .htaccess                       ← CETTE LEÇON
     │  réécrit /depenses/42 → index.php     (front controller)
     ▼
   public/index.php                          ← le point d'entrée unique
     │  → le routeur (leçon 08)
     ▼
   ton code PHP
```

Trois points structurants.

**Le front controller est le routeur WSGI de Python, côté Apache.** Au palier 5, tu as construit un routeur qui recevait toutes les requêtes et les dispatchait. Ici, c'est Apache qui envoie toutes les requêtes à `index.php`, où ton routeur (leçon 08) prend le relais. Le concept — un point d'entrée unique qui route — est identique ; ce qui change, c'est qu'Apache fait l'acheminement.

**Tous les frameworks PHP reposent dessus.** Le `.htaccess` de Laravel (palier 6, leçon 11), de WordPress, de Symfony font tous la même chose : rediriger vers `index.php`. En le construisant à la main, tu comprends ce que ces frameworks configurent automatiquement.

**Et la protection de dossier est une sécurité concrète.** Mettre ta configuration (mots de passe de base, clés) hors du dossier web, ou protéger un dossier sensible, est une défense directe — la version PHP du « les secrets hors du code » du palier 4 (leçon 04).

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire ta première règle de réécriture et la voir échouer plusieurs fois — mod_rewrite est puissant mais sa syntaxe déroute. Le conseil : construis les règles pas à pas, et teste chaque ligne. Et surtout, **comprends** chaque directive plutôt que de copier un `.htaccess` trouvé en ligne.

Tu vas aussi écrire le front controller, et avoir le déclic : « c'est donc ça que Laravel fait ».

### En équipe, en entreprise

**Tu liras plus de `.htaccess` que tu n'en écriras.** Ceux de WordPress et Laravel sont fournis ; tu les modifieras rarement, mais tu dois savoir ce qu'ils font — notamment quand une règle casse une URL.

**Les règles sont souvent copiées sans être comprises**, ce qui crée des bugs mystérieux (redirections en boucle, URL qui ne répondent plus). Savoir lire une règle `RewriteRule` te distingue immédiatement.

**La protection de dossier est une pratique de sécurité standard**, surtout en mutualisé où le code et la configuration cohabitent dans l'arborescence web.

**Et tu entendras que `.htaccess` est lent.** C'est vrai : Apache le relit à chaque requête. Sur un serveur qu'on contrôle, on met les règles dans la configuration globale (plus rapide). Mais en mutualisé, le `.htaccess` est la seule option — et c'est le cas le plus fréquent.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : la réécriture vers le front controller, la protection de dossier, les redirections 301, et les pages d'erreur personnalisées.

Rare, et hors sujet pour l'instant : les règles de réécriture complexes avec conditions multiples, les flags avancés de `RewriteRule`, la compression et le cache via `.htaccess`, l'authentification HTTP basique (`.htpasswd`), les règles de réécriture basées sur les en-têtes. Tu les rencontreras par besoin, et la documentation de mod_rewrite est là pour ça.

---

## La mécanique

### Activer mod_rewrite

```bash
sudo a2enmod rewrite
sudo systemctl restart apache2
```

Et dans le VirtualHost (leçon 01), `AllowOverride All` doit être présent, sinon le `.htaccess` est ignoré.

### ⭐ Le front controller : la règle fondamentale

```apache
# public/.htaccess
RewriteEngine On

# Si le fichier demandé n'existe pas physiquement...
RewriteCond %{REQUEST_FILENAME} !-f
# ...et que ce n'est pas un dossier existant...
RewriteCond %{REQUEST_FILENAME} !-d
# ...alors envoie tout vers index.php
RewriteRule ^ index.php [L]
```

C'est **la** règle à comprendre, et c'est le cœur de tous les frameworks PHP. Décortiquons-la :

- `RewriteEngine On` active la réécriture.
- `RewriteCond %{REQUEST_FILENAME} !-f` : condition — « si le fichier demandé n'existe pas » (`!-f` = pas un fichier). Cela laisse passer les vraies ressources (une image, un CSS existant).
- `RewriteCond %{REQUEST_FILENAME} !-d` : « et ce n'est pas un dossier existant ».
- `RewriteRule ^ index.php [L]` : « alors réécris vers `index.php` ». Le `^` correspond à n'importe quel chemin, `[L]` signifie « dernière règle, arrête-toi là ».

Résultat : toute URL qui ne correspond pas à un fichier réel (donc `/depenses`, `/depenses/42`, `/connexion`...) est envoyée à `index.php`, qui devient le **point d'entrée unique** de ton application. C'est exactement ce qu'Apache fait pour Laravel, et c'est ce que ton routeur WSGI faisait au palier 5.

### Récupérer l'URL demandée dans PHP

```php
<?php
// public/index.php reçoit TOUTES les requêtes
$uri = $_SERVER["REQUEST_URI"];         // "/depenses/42?tri=date"
$chemin = parse_url($uri, PHP_URL_PATH); // "/depenses/42"
$methode = $_SERVER["REQUEST_METHOD"];   // "GET"

echo "Méthode : $methode, Chemin : $chemin";
```

`$_SERVER["REQUEST_URI"]` contient l'URL originale demandée par le visiteur, **avant** réécriture. C'est à partir de là que ton routeur (leçon 08) décidera quoi faire — exactement comme `PATH_INFO` dans `environ` au palier 5 (WSGI).

### La réécriture classique (sans framework)

Avant le front controller, on réécrivait route par route :

```apache
# /article/42 devient index.php?id=42
RewriteRule ^article/([0-9]+)$ index.php?id=$1 [L]
```

`([0-9]+)` capture un ou plusieurs chiffres, et `$1` les réinjecte. C'est le même principe de capture par regex que ton routeur du palier 5 (leçon 05) — mais côté Apache. Tu verras cette forme dans de vieux sites ; le front controller l'a remplacée (on route dans PHP, pas dans Apache).

### Protéger un dossier

```apache
# config/.htaccess — interdire TOUT accès web à ce dossier
Require all denied
```

```apache
# Interdire l'accès à un type de fichier
<FilesMatch "\.(env|ini|log|sql)$">
    Require all denied
</FilesMatch>
```

Mettre `Require all denied` dans un dossier `config/` empêche quiconque d'y accéder par le web — même en devinant l'URL. C'est une défense directe pour protéger les fichiers sensibles (configuration, secrets), surtout en mutualisé où tout est dans l'arborescence web. C'est la version PHP du « les secrets ne sont pas accessibles » du palier 4.

> ⚠️ La meilleure protection reste de mettre les fichiers sensibles **hors du `DocumentRoot`** (c'est pourquoi la racine web pointe sur `public/`, leçon 01). Le `.htaccess` est une défense supplémentaire, pas la seule.

### Les redirections

```apache
# Redirection permanente (301) : l'ancienne URL vers la nouvelle
Redirect 301 /ancienne-page /nouvelle-page

# Rediriger tout le trafic HTTP vers HTTPS (production)
RewriteCond %{HTTPS} off
RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
```

La **301** est une redirection permanente : les moteurs de recherche transfèrent le référencement de l'ancienne URL vers la nouvelle (palier 0, leçon 07). C'est important quand tu changes la structure d'un site. La **302** serait temporaire. La redirection HTTP → HTTPS est un classique de production (palier 8).

### Les pages d'erreur personnalisées

```apache
ErrorDocument 404 /erreurs/404.html
ErrorDocument 500 /erreurs/500.html
```

Au lieu de la page d'erreur brute d'Apache, tu sers ta propre page. C'est du confort utilisateur, et ça évite de révéler des informations sur ton serveur.

---

## Les problèmes que tu vas rencontrer

**Mon `.htaccess` est totalement ignoré.** `AllowOverride All` manque dans le VirtualHost (leçon 01), ou mod_rewrite n'est pas activé (`a2enmod rewrite`). C'est la cause n°1.

**`500 Internal Server Error` après avoir modifié le `.htaccess`.** Une erreur de syntaxe dans le fichier. Regarde `/var/log/apache2/error.log` (le réflexe du palier 1). Une directive mal écrite fait planter Apache pour ce dossier.

**Redirection en boucle.** Ta règle de réécriture renvoie vers une URL qui déclenche à nouveau la règle. C'est fréquent avec la redirection HTTPS mal écrite, ou un front controller sans les conditions `!-f`/`!-d`.

**Mes images et CSS ne se chargent plus.** Ton front controller envoie **tout** vers `index.php`, y compris les ressources. Les conditions `RewriteCond %{REQUEST_FILENAME} !-f` sont là précisément pour laisser passer les fichiers réels — vérifie-les.

**`$_SERVER["REQUEST_URI"]` contient la query string.** `/depenses?tri=date` inclut le `?tri=date`. Utilise `parse_url(..., PHP_URL_PATH)` pour n'avoir que le chemin.

**Ma règle de capture ne marche pas.** La syntaxe des regex d'Apache diffère légèrement de celle de PHP/JavaScript. Teste pas à pas, et n'oublie pas les ancres `^` et `$`.

**Mon `.htaccess` marche en local mais pas en mutualisé (ou l'inverse).** Les hébergeurs ont des configurations différentes (certaines directives interdites). Lis la documentation de ton hébergeur.

---

## Ce qu'on te demandera

En **entretien PHP**, le `.htaccess` et le front controller sont des questions fréquentes : **« qu'est-ce qu'un front controller et à quoi sert-il ? »** (et la bonne réponse est « rediriger toutes les requêtes vers un point d'entrée unique, c'est la base de tous les frameworks »), « comment fais-tu des URL propres en PHP ? », « comment protèges-tu un dossier de configuration ? ».

En **test technique** ou en mission, on peut te demander d'écrire ou de déboguer une règle de réécriture — c'est exactement l'épreuve A1 de ton évaluation de palier.

En **travail réel**, surtout en maintenance, lire et modifier un `.htaccess` est un geste courant.

---

## Ce qui te démarquera

**Comprendre le front controller.** Savoir que « tout vers `index.php` » est le fondement de Laravel et WordPress, et pouvoir écrire la règle sans la copier, te place au-dessus de beaucoup de développeurs PHP qui la copient sans la comprendre.

**Écrire une règle `RewriteRule` et l'expliquer.** Décortiquer `RewriteCond %{REQUEST_FILENAME} !-f` ligne par ligne montre que tu maîtrises mod_rewrite, pas que tu l'as copié.

**La protection par `Require all denied` et le `public/`.** Savoir que la vraie défense est de mettre le code hors du `DocumentRoot`, avec le `.htaccess` en complément, est un réflexe de sécurité.

**Diagnostiquer une boucle de redirection.** C'est un bug classique et déroutant ; savoir qu'il vient d'une règle qui se redéclenche te fait gagner du temps.

**Et faire le lien avec le routeur WSGI.** Dire « le front controller, c'est Apache qui joue le rôle de mon routeur WSGI du palier 5 : un point d'entrée unique qui dispatche » prouve un transfert de concept.

---

## 📚 À lire

**Documentation Apache → *mod_rewrite*** : la référence. Lis l'introduction et les exemples de base — pas besoin des cas avancés.

**Documentation Apache → *RewriteRule* et *RewriteCond*** pour la syntaxe précise des directives.

**php.net → `$_SERVER`** pour comprendre `REQUEST_URI`, `REQUEST_METHOD`, et les autres variables serveur.

Et regarde le `.htaccess` de **Laravel** (dans le dossier `public/` d'un projet Laravel, ou dans la documentation) : tu y reconnaîtras exactement le front controller que tu construis. C'est le meilleur exemple réel.

---

## 🤖 Le mini-projet à demander à l'IA

Le front controller se comprend en le construisant et en le reliant au palier 5.

> « Je suis en formation de développeur, palier 6. J'ai construit un routeur WSGI en Python au palier 5 (un point d'entrée qui reçoit toutes les requêtes et les dispatche). Je découvre le front controller PHP via `.htaccess`. Sans me donner le fichier complet, explique-moi, ligne par ligne, ce que fait la règle de réécriture qui envoie tout vers `index.php`, et pose-moi des questions pour vérifier que je comprends chaque directive (`RewriteEngine`, `RewriteCond !-f`, `RewriteRule ^ index.php [L]`). Puis fais le lien : en quoi ce front controller joue-t-il le même rôle que mon routeur WSGI, et qu'est-ce qui change (c'est Apache qui achemine, pas mon code) ? »

Puis le débogage, qui est l'autre moitié de la leçon :

> « Donne-moi 6 `.htaccess` défectueux réalistes (front controller sans les conditions !-f/!-d donc les images cassées, redirection HTTPS en boucle, AllowOverride oublié, erreur de syntaxe qui fait un 500, capture regex incorrecte, chemin de ErrorDocument faux). Ne me dis pas le problème. Pour chacun, je dois diagnostiquer — en me rappelant de regarder les logs Apache — expliquer le symptôme pour l'utilisateur, et corriger. »

---

## 🛠️ À faire

1. **Active mod_rewrite** et vérifie que `AllowOverride All` est dans ton VirtualHost (leçon 01).
2. **⭐ Le front controller** : écris le `.htaccess` qui envoie tout vers `index.php`, avec les conditions `!-f`/`!-d`. Vérifie que `/depenses`, `/depenses/42` et `/nimporte/quoi` arrivent tous à `index.php`.
3. **Récupère l'URL** : dans `index.php`, affiche la méthode et le chemin avec `$_SERVER["REQUEST_URI"]` et `parse_url`.
4. **Le piège des ressources** : enlève les conditions `!-f`/`!-d`, constate qu'une image est cassée (envoyée à `index.php`), puis remets-les.
5. **La réécriture classique** : écris une règle qui transforme `/article/42` en `index.php?id=42`, et récupère `$_GET["id"]`. Compare avec le front controller.
6. **Protection de dossier** : crée un dossier `config/` avec `Require all denied`, et vérifie qu'il est inaccessible par le web.
7. **Redirection 301** : redirige une ancienne URL vers une nouvelle, et constate le code 301 avec `curl -I`.
8. **Page d'erreur 404** : configure une page 404 personnalisée et vérifie qu'elle s'affiche.
9. **Le piège de la boucle** : écris une redirection HTTPS incorrecte qui boucle, constate (le navigateur signale « trop de redirections »), et corrige.
10. **Lire Laravel** : trouve le `.htaccess` d'un projet Laravel (ou dans sa documentation) et identifie le front controller que tu viens de construire.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** La règle complète est celle de la section mécanique. Le point à vérifier : les URL inexistantes (`/depenses/42`) arrivent à `index.php`, mais un fichier réel (si tu en déposes un) est servi directement. C'est exactement le comportement du routeur WSGI du palier 5 — un point d'entrée unique — mais avec Apache comme aiguilleur.

**4.** Sans les conditions `!-f`/`!-d`, **tout** est envoyé à `index.php`, y compris `style.css` et `logo.png` : les ressources sont « avalées » et la page s'affiche sans style ni images. Les deux `RewriteCond` sont précisément là pour laisser passer les fichiers et dossiers qui existent réellement. C'est un bug classique quand on copie un front controller incomplet.

**9.** Une redirection HTTPS mal écrite (sans la condition `%{HTTPS} off`, ou qui réécrit même quand on est déjà en HTTPS) renvoie en boucle vers elle-même : le navigateur finit par afficher « ERR_TOO_MANY_REDIRECTS ». La correction est la condition `RewriteCond %{HTTPS} off` qui ne déclenche la redirection que si on n'est **pas déjà** en HTTPS. C'est le piège le plus fréquent de la réécriture, et le diagnostic passe par les logs Apache.

**10.** Le `.htaccess` de Laravel contient exactement le front controller : `RewriteCond` sur `!-f`/`!-d` et `RewriteRule` vers `index.php`. Tu viens de construire ce que Laravel configure pour toi — et quand tu l'utiliseras à la leçon 11, tu sauras ce que fait cette ligne au lieu de la subir. C'est tout l'intérêt du module « natif d'abord ».
</details>

---

## ✅ Acquis si…

- [ ] J'active mod_rewrite et je sais qu'`AllowOverride All` est nécessaire.
- [ ] J'écris le front controller (tout vers `index.php`) et j'explique chaque directive.
- [ ] Je comprends que le front controller est le fondement de tous les frameworks PHP.
- [ ] Je récupère le chemin demandé avec `REQUEST_URI` et `parse_url`.
- [ ] Je sais pourquoi les conditions `!-f`/`!-d` laissent passer les ressources réelles.
- [ ] J'écris une règle de réécriture avec capture par regex.
- [ ] Je protège un dossier avec `Require all denied`, et je sais que le `public/` est la vraie défense.
- [ ] Je fais une redirection 301 et je sais la différence avec une 302.
- [ ] Je diagnostique une boucle de redirection en regardant les logs.
- [ ] Je fais le lien entre le front controller et mon routeur WSGI du palier 5.

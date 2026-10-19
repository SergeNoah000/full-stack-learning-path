# Leçon 01 — Apache, VirtualHosts, et le modèle d'exécution PHP

> 🎯 **À la fin de cette leçon** : tu comprends le modèle d'exécution de PHP — un processus par requête, tout meurt à la fin — et pourquoi c'est une différence d'architecture majeure avec Node et Python.
> ⏱️ 4 h · **Prérequis** : [épreuve du palier 5](../../palier-05-backend-python/evaluation.md) réussie.

---

## De quoi on parle

PHP est le **troisième langage backend** du parcours, et le plus présent sur le web en volume (WordPress, d'innombrables sites sur mesure, Laravel). Mais avant le langage lui-même (leçon 03), il faut comprendre son **environnement d'exécution**, parce qu'il est radicalement différent de ce que tu connais.

**Apache** est le serveur web historique du monde PHP. Il reçoit les requêtes HTTP et, pour chaque requête vers un fichier `.php`, démarre l'interpréteur PHP, exécute le script, récupère la sortie, et la renvoie.

Le point central — **le modèle d'exécution de PHP** — est là : **un processus (ou presque) par requête, et tout meurt à la fin de la requête**. Chaque requête repart de zéro : aucune variable, aucune connexion, aucun état ne survit d'une requête à l'autre. C'est l'opposé de Node (un processus persistant, palier 4) et du WSGI/gunicorn de Python (processus persistants, palier 5).

Un **VirtualHost** est la configuration qui permet à Apache de servir plusieurs sites sur une même machine. Et **mod_php** contre **php-fpm** sont les deux façons de brancher PHP sur le serveur.

---

## À quoi ça sert, concrètement

**Parce que ce modèle explique tout le reste de PHP.** Pourquoi les sessions sont stockées sur disque, pourquoi il n'y a pas de « serveur qui tourne » à démarrer, pourquoi une fuite mémoire ne s'accumule pas, pourquoi un calcul long ne bloque qu'un seul utilisateur : tout découle du « un processus par requête ». Comprendre ce modèle d'abord évite de plaquer sur PHP les réflexes de Node.

**Parce que c'est un vrai apprentissage d'architecture.** Tu as vu deux modèles (Node persistant, Python persistant) ; PHP en montre un troisième. Pouvoir comparer les trois est exactement ce que tu formaliseras au palier 7. Et ce n'est pas théorique : le modèle d'exécution décide de la façon de gérer l'état, les connexions, la scalabilité.

**Parce que c'est l'environnement de 90 % des sites PHP existants.** Apache, `.htaccess`, FTP, MySQL via phpMyAdmin : c'est le quotidien des missions de maintenance PHP, très nombreuses et accessibles en freelance (palier 10). Connaître cet environnement réel est un argument d'embauche direct.

**Et parce que ce modèle a un avantage que Node n'a pas.** Comme chaque requête est isolée, un plantage ou un calcul long n'affecte qu'un utilisateur, pas tout le serveur. Et comme tout meurt à la fin, PHP est **stateless par construction** — une propriété précieuse pour la scalabilité (palier 7).

---

## Où ça intervient dans le développement

Le modèle d'exécution est le décor de tout le palier 6 :

```
   TROIS MODÈLES D'EXÉCUTION (comparatif du palier 7)
   ──────────────────────────────────────────────────
   Node (palier 4)    →  1 processus persistant, 1 fil, event loop
   Python (palier 5)  →  processus persistants (gunicorn workers)
   PHP (ce palier)    →  1 processus PAR REQUÊTE, tout meurt à la fin
```

Trois conséquences qui structurent le palier, et qu'il faut poser maintenant.

**L'état ne survit pas.** En Node, une variable globale persiste entre les requêtes (et c'est parfois un piège). En PHP, c'est impossible : chaque requête repart de zéro. D'où les **sessions sur disque** (leçon 04) pour maintenir la continuité par-dessus HTTP sans état (palier 0, leçon 07). C'est contre-intuitif quand on vient de Node, et c'est fondamental.

**Les connexions se rouvrent à chaque requête.** Pas de pool de connexions applicatif persistant comme en Node : chaque requête ouvre sa connexion à la base (leçon 05). Cela a un coût, géré différemment (connexions persistantes côté serveur de base, ou php-fpm).

**Et le blocage est local.** Au palier 4 (leçon 01), tu as démontré qu'un calcul long en Node bloque **tous** les utilisateurs. En PHP, il ne bloque que **l'utilisateur** qui l'a déclenché, parce que chaque requête a son propre processus. C'est l'un des points de comparaison les plus nets du palier 7.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas installer une stack LAMP (Linux, Apache, MySQL, PHP) brique par brique — pas un outil tout-en-un, pour comprendre chaque pièce. Tu vas configurer un VirtualHost, et découvrir qu'un script PHP n'a pas besoin de « serveur à lancer » : tu déposes un `.php`, tu visites l'URL, Apache l'exécute.

Tu vas aussi faire l'expérience marquante de la leçon : démontrer qu'un calcul long ne bloque qu'une seule requête, contrairement à Node.

### En équipe, en entreprise

**L'hébergement mutualisé est roi.** Une grande partie des sites PHP tournent sur de l'hébergement partagé avec cPanel, FTP et phpMyAdmin — pas sur des serveurs qu'on administre. C'est l'environnement des missions de maintenance, et tu y déploieras ton projet 6b (avec l'accès fourni par le référent).

**php-fpm a remplacé mod_php.** Les configurations modernes utilisent php-fpm (un pool de processus PHP séparé) avec Nginx ou Apache. Tu verras les deux ; le modèle d'exécution reste « un processus par requête » dans les deux cas.

**Les logs sont dans `/var/log/apache2/`.** Devant une erreur PHP (la fameuse page blanche), c'est là qu'on regarde — le réflexe du palier 0 (leçon 02). Beaucoup de débutants PHP ne savent pas où sont les logs et cherchent à l'aveugle.

**Et tu entendras du mépris pour PHP.** Souvent de gens qui connaissent le PHP d'il y a quinze ans. Le PHP moderne (8.x, leçon 03) est un bon langage, et le volume de travail qu'il représente est énorme. Savoir le défendre avec des arguments est utile.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : comprendre le modèle d'exécution, savoir configurer un VirtualHost, savoir où sont les logs, et distinguer mod_php de php-fpm.

Rare, et hors sujet pour l'instant : l'optimisation fine d'Apache, le réglage de php-fpm (nombre de workers), les modules Apache avancés, la mise en cache OPcache en détail, HTTP/2 côté Apache. Tu les rencontreras au palier 8 (DevOps) ou par besoin.

---

## La mécanique

### La stack LAMP, brique par brique

```bash
# Debian/Ubuntu
sudo apt install apache2                      # le serveur web
sudo apt install php libapache2-mod-php       # PHP + le module Apache
sudo apt install mariadb-server              # la base (MySQL/MariaDB)
sudo apt install php-mysql php-mbstring       # extensions PHP

php --version                                 # 8.x attendu
sudo systemctl status apache2                 # Apache tourne ? (systemd, palier 0)
```

On installe chaque brique séparément — Linux, Apache, MySQL/MariaDB, PHP — plutôt qu'un outil tout-en-un (XAMPP, Laragon). L'objectif est de comprendre ce que chaque pièce fait, exactement comme tu as installé Node par `nvm` au palier 0 plutôt que par un installateur opaque.

### Le modèle d'exécution, en pratique

```php
<?php
// test.php — déposé dans le dossier web, visité à http://localhost/test.php
$compteur = ($compteur ?? 0) + 1;   // ⚠️ $compteur repart TOUJOURS de 0
echo "Compteur : $compteur";         // affiche TOUJOURS 1, à chaque rechargement
```

Recharge la page dix fois : le compteur affiche **toujours 1**. En Node, une variable au niveau du module aurait persisté entre les requêtes. En PHP, **chaque requête repart de zéro** : le script est exécuté intégralement, produit sa sortie, et tout est détruit. C'est le modèle d'exécution, et c'est la chose la plus importante à intégrer.

```
   UNE REQUÊTE PHP
   ───────────────
   1. Apache reçoit GET /test.php
   2. Apache démarre l'interpréteur PHP
   3. PHP exécute le script du début à la fin
   4. PHP renvoie la sortie à Apache
   5. TOUT est détruit : variables, connexions, état
   6. La requête suivante recommence à l'étape 1, de zéro
```

### Les VirtualHosts

```apache
# /etc/apache2/sites-available/monsite.conf
<VirtualHost *:80>
    ServerName monsite.test
    DocumentRoot /var/www/monsite/public      # ⭐ la racine web pointe sur public/
    <Directory /var/www/monsite/public>
        AllowOverride All                      # autorise les .htaccess (leçon 02)
        Require all granted
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/monsite_error.log
</VirtualHost>
```

```bash
sudo a2ensite monsite.conf                    # active le site
sudo systemctl reload apache2
echo "127.0.0.1 monsite.test" | sudo tee -a /etc/hosts   # le /etc/hosts du palier 0 !
```

Un VirtualHost permet à Apache de servir plusieurs sites selon le nom de domaine demandé (l'en-tête `Host`, palier 0, leçon 07). Note `DocumentRoot` qui pointe sur `public/` : c'est une bonne pratique de sécurité que tu appliqueras avec le front controller (leçon 07) — seul le dossier `public/` est exposé, le reste du code est à l'abri.

Et le `/etc/hosts` que tu ajoutes est exactement celui de la leçon 06 du palier 0 : il fait pointer `monsite.test` vers ta machine, pour travailler sur un vrai nom de domaine en local.

### mod_php contre php-fpm

**mod_php** intègre l'interpréteur PHP dans Apache : chaque processus Apache peut exécuter du PHP. Simple, mais couplé (chaque processus Apache embarque PHP, même pour servir une image).

**php-fpm** (*FastCGI Process Manager*) est un pool de processus PHP **séparé** d'Apache. Apache (ou Nginx) lui transmet les requêtes PHP. C'est le standard moderne : meilleur contrôle des ressources, et ça fonctionne avec Nginx.

Dans les deux cas, le modèle reste « un processus (worker) par requête » : la différence est organisationnelle, pas conceptuelle. Pour cette leçon, mod_php suffit ; au palier 8, tu verras php-fpm.

### Trouver les erreurs

```bash
sudo tail -f /var/log/apache2/error.log       # les erreurs Apache et PHP, en direct
```

```php
<?php
// En DÉVELOPPEMENT seulement : afficher les erreurs à l'écran
ini_set('display_errors', '1');
error_reporting(E_ALL);
```

> ⚠️ `display_errors` affiche les erreurs PHP dans la page — pratique en développement, **faille en production** (ça révèle les chemins, la structure, parfois des requêtes SQL). C'est le `DEBUG=True` de Django (palier 5) et les traces du palier 4 (leçon 04) : en production, les erreurs vont dans les **logs**, jamais à l'écran. Le réflexe « page blanche → regarder les logs » est celui du palier 0.

---

## Les problèmes que tu vas rencontrer

**Une page blanche, sans message.** C'est l'erreur PHP la plus déroutante pour un débutant : une erreur fatale avec `display_errors` désactivé ne montre rien. Le réflexe : `tail -f /var/log/apache2/error.log`. C'est là que tout est écrit.

**Mon `.php` se télécharge au lieu de s'exécuter.** PHP n'est pas branché sur Apache (`mod_php` absent ou non activé), ou le fichier n'est pas dans le `DocumentRoot`.

**Mon VirtualHost n'est pas pris en compte.** Tu as oublié `a2ensite`, le `reload` d'Apache, ou l'entrée dans `/etc/hosts`.

**Mon `.htaccess` est ignoré.** `AllowOverride All` manque dans la configuration du VirtualHost (leçon 02).

**Ma variable ne garde pas sa valeur entre deux requêtes.** C'est le modèle d'exécution : tout meurt à la fin de la requête. Pour persister, il faut une session (leçon 04) ou la base de données. C'est la différence fondamentale avec Node.

**`Permission denied` dans les logs Apache.** Apache tourne sous un utilisateur dédié (`www-data`) qui doit pouvoir lire tes fichiers. C'est une question de permissions (palier 0, leçon 02), fréquente au déploiement.

**Mes modifications ne s'affichent pas.** Le cache du navigateur, ou OPcache (le cache de code de PHP) en environnement de production.

---

## Ce qu'on te demandera

En **entretien PHP**, la question qui distingue : **« quelle différence entre le modèle d'exécution de PHP et celui de Node ? »**. Pouvoir répondre « PHP démarre un processus par requête et tout meurt à la fin, alors que Node a un processus persistant avec un event loop » montre que tu comprends l'architecture, pas seulement la syntaxe.

On peut demander : « où vont les logs d'erreur Apache ? », « qu'est-ce qu'un VirtualHost ? », « mod_php ou php-fpm ? », « pourquoi PHP stocke-t-il les sessions sur disque ? » (parce que la mémoire ne survit pas).

En **travail réel**, surtout en maintenance, on attendra que tu saches configurer Apache, lire les logs, et comprendre pourquoi un comportement diffère de Node.

---

## Ce qui te démarquera

**Expliquer le modèle d'exécution et ses conséquences.** « Tout meurt à la fin de la requête, donc les sessions sont sur disque, les connexions se rouvrent, et un calcul long ne bloque qu'un utilisateur » est une réponse d'architecte, et elle prépare le palier 7.

**Savoir où sont les logs.** Le réflexe `tail -f /var/log/apache2/error.log` devant une page blanche te distingue immédiatement d'un débutant PHP qui cherche à l'aveugle.

**Comprendre que PHP est stateless par construction.** C'est une propriété précieuse pour la scalabilité (palier 7), et peu de gens savent l'exprimer.

**Défendre le PHP moderne.** Savoir dire « le PHP 8 n'a rien à voir avec le PHP de 2005 » avec des arguments (typage, performance, Laravel) montre que tu juges sur pièces.

**Et faire le lien avec les deux autres modèles.** Pouvoir comparer Node (persistant), Python (persistant) et PHP (par requête) est exactement le comparatif du palier 7.

---

## 📚 À lire

**php.net** → la section sur l'installation et la configuration d'Apache. php.net est la référence, et ses commentaires d'utilisateurs sont une mine.

**Documentation Apache → *Virtual Hosts*** pour la configuration des VirtualHosts.

**DigitalOcean Community** → les tutoriels « How to install LAMP » sont parmi les meilleurs guides pas à pas pour monter la stack (gratuits, à jour).

**php.net → *Using PHP → Runtime Configuration*** pour comprendre `display_errors`, `error_log`, et la configuration PHP.

Et relis la leçon 01 du palier 4 (le modèle d'exécution de Node) : la comparaison est le cœur de cette leçon.

---

## 🤖 Le mini-projet à demander à l'IA

Le modèle d'exécution se comprend par la comparaison et l'expérience.

> « Je suis en formation de développeur, palier 6. Je connais le modèle d'exécution de Node (processus persistant, event loop) et de Python (gunicorn, processus persistants). Je découvre PHP. Sans me donner de code, explique-moi le modèle "un processus par requête" de PHP en le comparant point par point à Node : que devient une variable globale ? une connexion à la base ? un calcul long ? une fuite mémoire ? Pour chaque point, pose-moi d'abord la question "qu'est-ce qui se passe en Node ?", puis "et en PHP ?". Enfin, aide-moi à concevoir une petite expérience qui démontre, sur ma propre stack LAMP, qu'un calcul long en PHP ne bloque qu'une seule requête (contrairement à Node). »

Puis la mise en place :

> « Guide-moi pour installer une stack LAMP brique par brique sur Ubuntu (pas un outil tout-en-un), configurer un VirtualHost pour monsite.test, et vérifier que PHP s'exécute. À chaque étape, dis-moi comment vérifier que la brique fonctionne, et où regarder si ça échoue. Ne me donne pas tout d'un bloc : une étape à la fois, et je te dis le résultat. »

---

## 🛠️ À faire

1. **Monte la stack LAMP** brique par brique : Apache, PHP, MariaDB, extensions. Vérifie chaque brique (`apache2 status`, `php --version`).
2. **Le premier script** : dépose un `test.php` qui affiche `phpinfo()`, visite l'URL, et constate qu'aucun « serveur » n'est à lancer.
3. **⭐ Le modèle d'exécution** : écris le script compteur, recharge dix fois, et constate qu'il affiche toujours 1. Écris dans ton journal pourquoi, et ce qui serait différent en Node.
4. **Le VirtualHost** : configure `monsite.test` avec `DocumentRoot` sur un dossier `public/`, active-le, ajoute l'entrée `/etc/hosts`, et visite le site.
5. **Les logs** : provoque une erreur PHP (une fonction inexistante), constate la page blanche, puis trouve l'erreur dans `/var/log/apache2/error.log`.
6. **`display_errors`** : active-le en développement, constate que l'erreur s'affiche, puis note pourquoi il faut le désactiver en production.
7. **⭐ Le blocage local** : écris un script PHP avec un `sleep(5)`, appelle-le, puis appelle un autre script en parallèle depuis un autre onglet. Constate que le second répond immédiatement — contrairement à ce que tu avais démontré en Node (palier 4, leçon 01). Écris la conclusion.
8. **Les permissions** : vérifie sous quel utilisateur tourne Apache (`www-data`), et assure-toi qu'il peut lire tes fichiers.
9. **La comparaison** : remplis dans ton journal un tableau Node / Python / PHP sur le modèle d'exécution (persistance de l'état, connexions, blocage, scalabilité).

<details>
<summary>Corrections et points de contrôle</summary>

**3.** Le compteur affiche toujours 1 parce que `$compteur` est recréé à chaque requête : le script s'exécute du début à la fin, puis tout est détruit. En Node, une variable au niveau du module (`let compteur = 0`) aurait persisté entre les requêtes, puisque le processus reste en vie. **C'est la différence fondamentale**, et elle explique pourquoi PHP a besoin de sessions sur disque (leçon 04) pour toute continuité.

**7.** C'est l'expérience la plus marquante du palier. En Node (palier 4, leçon 01), un `sleep` synchrone de 5 secondes bloquait **toutes** les requêtes, parce qu'un seul processus et un seul fil traitaient tout le monde. En PHP, le `sleep(5)` ne bloque que **le processus de cette requête** : les autres requêtes ont leur propre processus et répondent normalement. **Conclusion : le modèle par requête isole les utilisateurs les uns des autres.** C'est un avantage de PHP (un calcul lent ne fait pas tomber le site) et une contrainte (pas d'état partagé en mémoire). C'est exactement le genre de comparaison qui distingue un architecte au palier 7.

**9.** Le tableau attendu : **état en mémoire** — Node et Python le gardent entre requêtes (parfois un piège), PHP non (tout meurt). **Connexions base** — Node/Python peuvent avoir un pool persistant, PHP rouvre (ou s'appuie sur php-fpm). **Blocage d'un calcul long** — Node bloque tout le monde, PHP un seul utilisateur. **Scalabilité horizontale** — PHP est stateless par construction (facile à répliquer), Node/Python doivent discipliner leur état. C'est le document d'architecture du palier 7 qui commence.
</details>

---

## ✅ Acquis si…

- [ ] J'ai monté une stack LAMP brique par brique et je sais vérifier chaque pièce.
- [ ] J'explique le modèle « un processus par requête, tout meurt à la fin ».
- [ ] J'ai démontré qu'une variable ne survit pas entre deux requêtes, et je sais pourquoi.
- [ ] Je configure un VirtualHost avec `DocumentRoot` sur `public/` et une entrée `/etc/hosts`.
- [ ] Je sais que les logs sont dans `/var/log/apache2/` et j'y cherche devant une page blanche.
- [ ] Je sais pourquoi `display_errors` est une faille en production.
- [ ] J'ai démontré qu'un calcul long ne bloque qu'un utilisateur, contrairement à Node.
- [ ] Je distingue mod_php et php-fpm.
- [ ] Je sais pourquoi PHP est stateless par construction, et ce que ça implique.
- [ ] Je peux comparer les modèles d'exécution de Node, Python et PHP.

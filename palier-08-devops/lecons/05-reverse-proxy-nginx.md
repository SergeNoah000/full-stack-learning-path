# Leçon 05 — Reverse proxy : Nginx devant une application

> 🎯 **À la fin de cette leçon** : tu places Nginx devant ton application — il reçoit le trafic du monde sur 80/443 et le transmet à ton app sur son port interne — et tu comprends pourquoi presque toute application web a un proxy devant elle.
> ⏱️ 4 h · **Prérequis** : leçons 01-04 (Linux, systemd, réseau, ports), et Apache (palier 6, leçon 01) pour le contraste.

---

## De quoi on parle

Un **reverse proxy** (proxy inverse) est un serveur placé **devant** ton application, qui reçoit toutes les requêtes du monde extérieur et les **transmet** à l'application, puis renvoie sa réponse au client. Le client ne parle jamais directement à l'application : il parle au proxy, qui fait l'intermédiaire.

**Nginx** (prononcé « engine-X ») est le reverse proxy le plus répandu. (Caddy est une alternative moderne, plus simple, avec HTTPS automatique — on la mentionne.)

```
   Monde ──▶ Nginx (ports 80/443, public)  ──▶  ton app (port 3000, interne)
                     │                              Node / gunicorn / php-fpm
                     ├── termine le TLS (HTTPS)
                     ├── sert les fichiers statiques (images, CSS)
                     └── peut router vers PLUSIEURS apps selon le domaine/chemin
```

Tu as vu Apache au palier 6 (leçon 01), qui jouait un rôle proche pour PHP. Nginx en reverse proxy est l'approche standard pour les applications Node, Python et aussi PHP moderne (devant php-fpm). C'est la pièce qui relie le réseau (leçon 04) à ton application, et le préalable au HTTPS (leçon 09).

---

## À quoi ça sert, concrètement

**Parce que ton application ne doit pas être exposée directement.** Un serveur d'application (Node sur 3000, gunicorn sur 8000) n'est pas fait pour affronter Internet en direct : il gère mal les connexions lentes, les attaques, le TLS, les fichiers statiques. Nginx, lui, est conçu pour ça — robuste, rapide, éprouvé sous des millions de requêtes. Il absorbe le monde et protège ton app.

**Parce qu'il centralise ce qui est commun à tout le trafic.** Le HTTPS (terminaison TLS), la compression, les en-têtes de sécurité, la limitation de débit, le service des fichiers statiques : Nginx le fait une fois, pour toutes les requêtes, sans que ton application ait à s'en occuper. L'app se concentre sur le métier ; le proxy gère l'infrastructure HTTP.

**Parce qu'il permet de faire cohabiter plusieurs applications.** Un seul serveur, une seule IP, mais `api.monsite.fr` → app Node, `blog.monsite.fr` → WordPress, `/` → React : Nginx route selon le domaine et le chemin. Sans lui, impossible de partager proprement un serveur entre plusieurs services.

**Et parce que c'est le point d'entrée où se branche le HTTPS.** Le certificat TLS (leçon 04) se pose sur Nginx, qui déchiffre et transmet en clair à l'app sur le réseau local (sûr). C'est ce qui rend la mise en HTTPS (leçon 09) simple : un seul endroit à configurer.

---

## Où ça intervient dans le développement

Nginx est la porte d'entrée publique, entre le réseau et ton application :

```
   DNS → IP (leçon 04)
        ▼  ports 80/443
   NGINX (reverse proxy, service systemd — leçon 02)
        ├── TLS / HTTPS (certificat, leçon 09)
        ├── fichiers statiques servis directement (rapide)
        └── proxy_pass ──▶ ton app sur 127.0.0.1:3000 (port INTERNE, non exposé)
                             app = service systemd (leçon 02), utilisateur dédié (leçon 01)
```

Trois ancrages.

**Il écoute sur les ports publics de la leçon 04.** Nginx prend 80 (HTTP) et 443 (HTTPS) ; ton application écoute sur un port **interne** (3000, 8000…) accessible seulement en local. Le pare-feu (leçon 09) n'ouvre que 80/443 au monde. C'est l'application concrète de la discipline « n'exposer que le nécessaire ».

**Il tourne comme un service systemd (leçon 02).** `systemctl status/restart nginx`, logs via `journalctl` ou `/var/log/nginx/`. Tout ce que tu as appris sur les services s'applique à Nginx.

**Il contraste avec Apache (palier 6).** Au palier 6, Apache exécutait PHP directement (un module). Ici, Nginx **ne connaît pas** ton langage : il transmet la requête à un serveur d'application (Node, gunicorn, php-fpm) qui, lui, exécute le code. Cette séparation proxy/app est l'architecture moderne, valable pour tous les langages — y compris PHP (Nginx + php-fpm).

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas installer Nginx, écrire un *server block* qui reçoit un domaine et le transmet (`proxy_pass`) à un de tes backends tournant sur un port interne, servir des fichiers statiques directement, et vérifier ta config avant de la recharger. Tu feras cohabiter deux applications sur le même serveur via deux domaines.

### En équipe, en entreprise

**Presque toute app a un Nginx (ou équivalent) devant.** C'est si standard que l'absence de reverse proxy est l'exception. Savoir lire et modifier une configuration Nginx est une compétence attendue.

**On teste la config avant de recharger.** `nginx -t` vérifie la syntaxe ; `systemctl reload nginx` applique **sans couper** le service. Recharger une config cassée couperait le site — d'où le `nginx -t` systématique avant.

**Les logs Nginx sont une mine.** `access.log` (chaque requête) et `error.log` (les problèmes) de Nginx disent qui vient, quelles URL, quels codes de retour. Un `502 Bad Gateway` dans `error.log` pointe une app qui ne répond pas — diagnostic courant.

**Caddy gagne du terrain pour les cas simples.** Sa configuration est plus concise et il gère le HTTPS tout seul. On le rencontre de plus en plus ; les concepts (reverse proxy) sont identiques.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours (en exploitation) : lire une config Nginx, `nginx -t`, `systemctl reload nginx`, consulter `access.log`/`error.log`.

Régulièrement : écrire un *server block* avec `proxy_pass`, servir du statique, ajouter une redirection HTTP→HTTPS, régler les en-têtes transmis (`X-Forwarded-For`…).

Rare ou avancé : l'équilibrage de charge entre plusieurs *upstreams* (lien avec la scalabilité, palier 7), le cache Nginx, la limitation de débit fine, les WebSockets, les configurations TLS pointues. À connaître de nom ; tu les creuseras à l'échelle.

---

## La mécanique

### Le server block : recevoir et transmettre

```nginx
# /etc/nginx/sites-available/monsite
server {
    listen 80;
    server_name monsite.fr www.monsite.fr;      # ce domaine

    location / {
        proxy_pass http://127.0.0.1:3000;        # ⭐ transmettre à l'app interne
        proxy_set_header Host $host;             # transmettre le vrai domaine
        proxy_set_header X-Forwarded-For $remote_addr;   # et l'IP du client
        proxy_set_header X-Forwarded-Proto $scheme;      # http ou https
    }
}
```

Le cœur est `proxy_pass` : « tout ce qui arrive ici, envoie-le à l'application qui écoute sur `127.0.0.1:3000` ». Les `proxy_set_header` transmettent à l'app des informations qu'elle perdrait sinon : le vrai domaine demandé, l'IP réelle du client (sans quoi l'app ne verrait que l'IP de Nginx), et si l'échange d'origine était en HTTPS. Ces en-têtes sont importants — une app qui logge l'IP du client a besoin de `X-Forwarded-For`.

### Servir les fichiers statiques directement

```nginx
    location /assets/ {
        root /opt/monapp/public;      # Nginx sert ces fichiers LUI-MÊME
        expires 30d;                  # et dit au navigateur de les garder en cache
    }
```

Les fichiers statiques (images, CSS, JS compilé) n'ont pas besoin de passer par l'application : Nginx les sert directement, bien plus vite, et décharge l'app. C'est un gain de performance gratuit, et le `expires` ajoute du cache navigateur (lien avec la leçon 06 du palier 7).

### Activer un site et tester AVANT de recharger

```bash
# lier le site dans sites-enabled (convention Debian/Ubuntu)
sudo ln -s /etc/nginx/sites-available/monsite /etc/nginx/sites-enabled/
sudo nginx -t                    # ⭐ TESTER la syntaxe de la config
sudo systemctl reload nginx      # appliquer SANS couper le service
```

La discipline : **toujours `nginx -t` avant `reload`**. `nginx -t` vérifie que la configuration est valide ; si elle ne l'est pas, tu corriges avant d'appliquer. `reload` recharge en douceur (les connexions en cours ne sont pas coupées), contrairement à `restart` qui redémarre le service. Recharger une config cassée sans l'avoir testée couperait le site.

### ⭐ Faire cohabiter plusieurs applications

```nginx
server { listen 80; server_name api.monsite.fr;
    location / { proxy_pass http://127.0.0.1:3000; } }    # app Node

server { listen 80; server_name blog.monsite.fr;
    location / { proxy_pass http://127.0.0.1:8000; } }    # app Python
```

Un *server block* par domaine : Nginx regarde le `server_name` demandé et route vers la bonne application. Un seul serveur, une seule IP, plusieurs services proprement séparés. C'est ce qui rend un serveur partageable — et c'est le même principe que les VirtualHosts d'Apache (palier 6, leçon 01), appliqué en mode proxy.

### Le cas PHP : Nginx + php-fpm

```nginx
    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;    # transmettre à php-fpm
        include fastcgi_params;
    }
```

Même ton Laravel du palier 6 se sert, en production, derrière Nginx qui transmet les requêtes PHP à **php-fpm** (le processus qui exécute PHP). Contrairement à Apache+mod_php (palier 6), ici Nginx et l'exécuteur PHP sont séparés — la même architecture proxy/app que pour Node et Python. Tes trois backends suivent donc le même modèle en production.

### Lire les logs Nginx

```bash
sudo tail -f /var/log/nginx/access.log    # chaque requête reçue
sudo tail -f /var/log/nginx/error.log     # les erreurs (502, config, upstream)
```

`access.log` enregistre chaque requête (IP, URL, code de statut, taille) ; `error.log` enregistre les problèmes. Un `502 Bad Gateway` signifie que Nginx n'a pas pu joindre ton application (elle est arrêtée, mauvais port) : `error.log` le confirme, et tu vérifies le service de l'app (`systemctl status`, leçon 02).

---

## Les problèmes que tu vas rencontrer

**`502 Bad Gateway`.** Le classique. Nginx fonctionne mais ne joint pas ton app : elle est arrêtée (`systemctl status monapp`), écoute sur un autre port que le `proxy_pass`, ou a crashé (`journalctl`, leçon 02). Le proxy marche, l'app derrière non.

**`nginx -t` échoue.** Erreur de syntaxe dans la config (un `;` manquant, une accolade). `nginx -t` indique le fichier et la ligne. Corrige avant de recharger — d'où l'intérêt de tester.

**Mon app voit l'IP de Nginx, pas celle du client.** Tu n'as pas transmis `X-Forwarded-For`. Ajoute les `proxy_set_header`. L'app doit lire cet en-tête pour connaître le vrai client.

**Le site affiche la page par défaut de Nginx.** Ton *server block* n'est pas activé (lien `sites-enabled` manquant), le `server_name` ne correspond pas au domaine demandé, ou tu n'as pas rechargé.

**Les fichiers statiques renvoient 404.** Le `root` ou le chemin du `location` est faux, ou Nginx (son utilisateur) n'a pas le droit de lire les fichiers (permissions, leçon 01).

**J'ai rechargé une config cassée et le site est tombé.** Tu as sauté le `nginx -t`. Teste **toujours** avant de recharger. (Et `reload` ne coupe pas les connexions en cours, contrairement à `restart` — préfère `reload`.)

---

## Ce qu'on te demandera

En **test DevOps**, le reverse proxy est un incontournable : « à quoi sert un reverse proxy / Nginx devant une app ? », « que fait `proxy_pass` ? », « comment fais-tu cohabiter deux apps sur un serveur ? », « que signifie un `502 Bad Gateway` ? ». On attend que tu saches lire une config et tester avant de recharger.

On peut demander : « pourquoi ne pas exposer l'app directement ? » (TLS, robustesse, statique, sécurité), « où mets-tu le certificat HTTPS ? » (sur Nginx), « différence avec Apache+mod_php du palier 6 ? ».

En **mission**, modifier une config Nginx (ajouter un site, une redirection, un chemin) et diagnostiquer un `502` sont des gestes courants.

---

## Ce qui te démarquera

**Comprendre pourquoi le proxy existe.** Expliquer que Nginx protège l'app, termine le TLS, sert le statique et permet la cohabitation — pas juste « on met Nginx parce que c'est comme ça » — montre une vraie compréhension de l'architecture web.

**La discipline `nginx -t` avant `reload`.** Ce réflexe, qui évite de couper un site en production avec une config cassée, est exactement le genre de prudence qu'on veut voir chez quelqu'un qui touche à de la prod.

**Diagnostiquer un 502 méthodiquement.** Savoir que `502` = « le proxy va bien, l'app derrière ne répond pas » et dérouler `systemctl status` + `journalctl` (leçon 02) te rend efficace là où d'autres paniquent.

**Et voir le modèle unifié.** Comprendre que tes trois backends (Node, gunicorn, php-fpm) suivent en production **la même** architecture proxy/app derrière Nginx, c'est exactement le genre de transfert que le parcours construit — et ça impressionne.

---

## 📚 À lire

**Documentation Nginx → *Beginner's Guide* et *Reverse Proxy*** : la référence officielle, avec les directives `server`, `location`, `proxy_pass`.

**Digital Ocean → *How to set up Nginx as a reverse proxy*** : tutoriels pas à pas, orientés cas réels (Node, gunicorn, php-fpm).

**Documentation Caddy** : pour voir l'alternative moderne (HTTPS automatique, config concise) — même concept, moins de configuration.

Relis le palier 6, leçon 01 (Apache, modèle d'exécution PHP) : compare Apache+mod_php (exécution directe) et Nginx+php-fpm (proxy + exécuteur séparé). Et la leçon 04 (ports) : Nginx incarne la discipline « n'exposer que 80/443 ».

---

## 🤖 Le mini-projet à demander à l'IA

Mettre Nginx devant un de tes backends :

> « Je suis en formation de développeur, palier 8 (DevOps). J'ai un backend (Node, gunicorn ou php-fpm) qui tourne sur un port interne. Je veux mettre Nginx devant comme reverse proxy. Sans me donner une config à copier sans comprendre, guide-moi directive par directive : écrire un server block qui écoute sur 80, transmettre à mon app avec proxy_pass, et transmettre les bons en-têtes (Host, X-Forwarded-For, X-Forwarded-Proto) — explique-moi pourquoi chacun compte. Insiste sur la discipline nginx -t AVANT systemctl reload. »

Puis la cohabitation et le diagnostic :

> « Aide-moi à faire cohabiter deux de mes applications sur le même serveur via deux server blocks (api.monsite.fr et blog.monsite.fr). Puis entraîne-moi au diagnostic : donne-moi des scénarios (502 Bad Gateway, page par défaut de Nginx, statique en 404) et fais-moi trouver la cause en reliant Nginx (error.log) et l'état de mon app (systemctl status, journalctl de la leçon 02). Ne me donne pas la réponse d'emblée. »

---

## 🛠️ À faire

> Sur le VPS du référent. Teste chaque config avec `nginx -t` avant de recharger.

1. **Installer et piloter** : installe Nginx, et pilote-le comme un service systemd (leçon 02) : `status`, `reload`. Visite l'IP du serveur et vois la page par défaut.
2. **⭐ Le proxy** : lance un de tes backends sur un port interne (3000/8000), puis écris un *server block* qui transmet le trafic du domaine vers lui avec `proxy_pass`. Transmets `Host`, `X-Forwarded-For`, `X-Forwarded-Proto`.
3. **Tester avant de recharger** : fais exprès une erreur de syntaxe, lance `nginx -t`, lis l'erreur, corrige, puis `reload`. Intègre le réflexe « test d'abord ».
4. **Vérifier l'IP du client** : dans ton app, logge l'IP vue. Sans `X-Forwarded-For`, tu vois celle de Nginx ; avec, celle du vrai client. Constate la différence.
5. **Le statique** : sers un dossier d'assets directement par Nginx (`location /assets/`), et vérifie (avec `curl -I`, leçon 04) que ces fichiers ne passent pas par l'app.
6. **⭐ Deux apps** : fais cohabiter deux backends via deux *server blocks* (deux `server_name`). Vérifie que chaque domaine atteint la bonne app.
7. **⭐ Diagnostiquer un 502** : arrête ton app (`systemctl stop`), recharge la page, obtiens un `502 Bad Gateway`, confirme-le dans `error.log`, puis relance l'app et vérifie que ça remarche.
8. **Le cas PHP** : si tu as ton Laravel du palier 6, mets-le derrière Nginx + php-fpm, et compare avec Apache+mod_php (palier 6) : où s'exécute le PHP dans chaque cas ?
9. **Le lien** : dans ton journal, explique pourquoi l'app ne doit pas être exposée directement, ce que Nginx apporte, et pourquoi tes trois backends suivent la même architecture proxy/app en production.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** `proxy_pass http://127.0.0.1:3000` est le cœur du reverse proxy : Nginx reçoit sur le port public (80) et transmet à l'app sur son port **interne** (3000), accessible seulement en local. Les `proxy_set_header` sont essentiels : sans eux, l'app perd des informations — elle ne verrait que l'IP de Nginx (pas celle du client, d'où `X-Forwarded-For`), et ne saurait pas quel domaine a été demandé (`Host`) ni si l'origine était en HTTPS (`X-Forwarded-Proto`, crucial une fois le HTTPS en place leçon 09).

**3.** `nginx -t` avant `reload` est la discipline qui protège la production. Une config invalide rechargée sans test couperait le site ; `nginx -t` l'attrape avant. Et `reload` (rechargement en douceur, sans couper les connexions en cours) est préférable à `restart` (redémarrage brutal) pour appliquer un changement. Teste, puis recharge en douceur.

**7.** `502 Bad Gateway` a une signification précise : **Nginx fonctionne, mais n'a pas réussi à joindre l'application** derrière. Causes : app arrêtée, mauvais port dans `proxy_pass`, app crashée. Le diagnostic relie les deux leçons : `error.log` de Nginx confirme le 502, et `systemctl status monapp` + `journalctl -u monapp` (leçon 02) disent pourquoi l'app ne répond pas. Distinguer « le proxy est en cause » de « l'app est en cause » fait gagner un temps précieux.

**8-9.** Le modèle unifié, et le contraste avec le palier 6. Avec Apache+mod_php (palier 6), le serveur web **exécutait** PHP lui-même (un module intégré). Avec Nginx, le proxy n'exécute aucun code : il **transmet** à un serveur d'application — php-fpm pour PHP, le processus Node pour Node, gunicorn pour Python. Cette séparation proxy/exécuteur est l'architecture moderne commune à tes trois backends : Nginx devant, l'app (quel que soit son langage) derrière, sur un port interne. Comprendre ça unifie tout ce que tu as déployé.
</details>

---

## ✅ Acquis si…

- [ ] J'explique pourquoi une application n'est pas exposée directement, mais derrière un proxy.
- [ ] J'écris un *server block* qui transmet le trafic à mon app avec `proxy_pass`.
- [ ] Je transmets les en-têtes utiles (`Host`, `X-Forwarded-For`, `X-Forwarded-Proto`).
- [ ] Je sers les fichiers statiques directement par Nginx.
- [ ] Je teste toujours avec `nginx -t` avant `systemctl reload`.
- [ ] Je fais cohabiter plusieurs applications via plusieurs *server blocks*.
- [ ] Je diagnostique un `502 Bad Gateway` en reliant Nginx et l'état de l'app.
- [ ] Je comprends que mes trois backends suivent la même architecture proxy/app en production.

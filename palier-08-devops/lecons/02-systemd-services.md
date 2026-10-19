# Leçon 02 — systemd : services, systemctl, journalctl

> 🎯 **À la fin de cette leçon** : tu fais tourner ton application comme un **service** qui démarre au boot, redémarre après un crash, et dont tu lis les logs d'une commande — au lieu d'un `node app.js` lancé à la main qui meurt dès que tu fermes le terminal.
> ⏱️ 3 h · **Prérequis** : leçon 01 (Linux, processus).

> ⚠️ Rappel du garde-fou : un service mal configuré peut boucler en redémarrages ou masquer une erreur. Comprends chaque directive de ton fichier de service avant de l'activer.

---

## De quoi on parle

**systemd** est le gestionnaire de services de la quasi-totalité des Linux modernes. C'est lui qui démarre, arrête, surveille et redémarre les programmes de fond (les **services**, aussi appelés *daemons*) : le serveur web, la base de données — et ton application.

- `systemctl` est la commande pour piloter les services : démarrer, arrêter, activer au boot, voir l'état.
- `journalctl` est la commande pour lire leurs **logs**, centralisés par systemd.
- Un **fichier de service** (`.service`) décrit comment lancer ton application : quelle commande, sous quel utilisateur, que faire si elle crashe.

Le problème que ça résout : quand tu lances `node app.js` ou `gunicorn` à la main dans un terminal, le programme meurt dès que tu te déconnectes, ne redémarre pas s'il crashe, et ne démarre pas tout seul quand le serveur redémarre. systemd transforme ta commande en un service **permanent et surveillé**. C'est ainsi qu'une application tourne réellement en production (quand on n'utilise pas Docker, leçon 06 — les deux coexistent).

---

## À quoi ça sert, concrètement

**Parce qu'une application lancée à la main ne tient pas.** Fermer le terminal la tue. Un crash l'arrête définitivement. Un redémarrage du serveur ne la relance pas. En production, c'est inacceptable : l'application doit survivre à tout ça. systemd est ce qui l'y fait survivre.

**Parce que le redémarrage automatique est un filet de sécurité essentiel.** Une application peut crasher (bug, mémoire, dépendance indisponible). Avec `Restart=always`, systemd la relance aussitôt — le service se « répare » seul le temps que tu diagnostiques. Sans ça, le moindre crash est une panne jusqu'à intervention humaine.

**Parce que les logs centralisés changent la vie du diagnostic.** `journalctl -u monapp` te donne tout l'historique d'un service : ses démarrages, ses erreurs, ses sorties. Plus besoin de chercher dans quel fichier l'app écrit : systemd capture tout. C'est l'outil de diagnostic numéro un sur un serveur (leçon 10).

**Et parce que c'est le standard que tu croiseras partout.** Nginx, PostgreSQL, Docker lui-même : tout est géré par systemd. `systemctl status nginx`, `systemctl restart postgresql` sont des gestes quotidiens. Même si tu déploies avec Docker, tu croiseras systemd sur chaque serveur.

---

## Où ça intervient dans le développement

systemd est le chef d'orchestre des programmes du serveur :

```
   Démarrage du serveur
        ▼
   systemd lance les services activés :
        ├── nginx.service       (le reverse proxy, leçon 05)
        ├── postgresql.service  (la base)
        └── monapp.service      ← TON application (cette leçon)
                │ si elle crashe → systemd la redémarre (Restart=always)
                │ ses logs → journalctl -u monapp
```

Trois ancrages.

**C'est la suite directe de la leçon 01.** Un service est un processus (leçon 01) géré par systemd : lancé sous un utilisateur dédié (le moindre privilège !), surveillé, journalisé. Tu passes de « lancer un processus à la main » à « déclarer un service permanent ».

**C'est ainsi que tourneront tes backends (paliers 4-6).** Ton app Node (`node server.js`), ton app Python (`gunicorn`), ton app PHP (`php-fpm`) deviennent chacune un service systemd. La commande que tu lançais en développement devient une directive `ExecStart` dans un fichier de service.

**Et c'est l'alternative/complément de Docker (leçon 06).** Deux façons de faire tourner une app en production : un service systemd (classique, direct sur le serveur) ou un conteneur Docker. Tu verras les deux ; Docker lui-même est souvent lancé par systemd. Comprendre systemd éclaire ce que Docker automatise.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas piloter des services existants (`systemctl status/start/stop/restart`), lire leurs logs (`journalctl`), puis écrire **ton propre** fichier `.service` pour faire tourner un de tes backends comme un service : démarrage au boot, redémarrage sur crash, logs centralisés, sous un utilisateur dédié.

### En équipe, en entreprise

**`systemctl status` est le premier geste de diagnostic.** « Le site est down » → `systemctl status monapp` : actif ? en échec ? depuis quand ? Suivi de `journalctl -u monapp` pour voir pourquoi. Ce réflexe est quotidien.

**On n'édite jamais un service sans `daemon-reload`.** Après avoir modifié un fichier `.service`, il faut dire à systemd de relire sa configuration (`systemctl daemon-reload`). L'oublier est une erreur classique : « j'ai modifié le fichier mais rien ne change ».

**Les services ont des dépendances.** Ton app a besoin que la base soit démarrée avant elle. systemd gère l'ordre (`After=`, `Requires=`). Comprendre ces dépendances évite les « l'app démarre avant la base et plante ».

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : `systemctl status/start/stop/restart <service>`, `systemctl enable` (démarrer au boot), `journalctl -u <service>` (lire les logs).

Régulièrement : écrire ou ajuster un fichier `.service`, `daemon-reload` après modification, `journalctl -f` (suivre en direct), `journalctl --since` (filtrer par date).

Rare ou avancé : les *timers* systemd (alternative à cron), les cibles (*targets*), les *sockets*, les limites de ressources par service (`MemoryLimit`), les services utilisateur. À connaître de nom ; tu les creuseras au besoin.

---

## La mécanique

### Piloter un service existant

```bash
systemctl status nginx       # état : actif/inactif/échec, PID, dernières lignes de log
sudo systemctl start nginx   # démarrer
sudo systemctl stop nginx    # arrêter
sudo systemctl restart nginx # redémarrer
sudo systemctl reload nginx  # recharger la config SANS couper le service (si supporté)
sudo systemctl enable nginx  # démarrer AUTOMATIQUEMENT au boot
sudo systemctl disable nginx # ne plus démarrer au boot
```

`status` est celui que tu taperas le plus : il dit en un coup d'œil si le service tourne, depuis quand, et montre ses dernières lignes de log. Note la distinction **start** (maintenant, une fois) / **enable** (à chaque démarrage du serveur) : un service peut être démarré sans être activé au boot, et inversement.

### ⭐ Écrire un fichier de service

```ini
# /etc/systemd/system/monapp.service
[Unit]
Description=Mon application Node
After=network.target postgresql.service   # démarrer APRÈS le réseau et la base

[Service]
Type=simple
User=monapp                               # ⭐ utilisateur dédié, PAS root (leçon 01)
WorkingDirectory=/opt/monapp
ExecStart=/usr/bin/node server.js          # la commande qui lance l'app
Restart=always                            # ⭐ redémarrer si elle crashe
RestartSec=3                              # attendre 3 s entre deux tentatives
Environment=NODE_ENV=production            # variables d'environnement
EnvironmentFile=/opt/monapp/.env           # ...ou depuis un fichier (secrets, palier 4)

[Install]
WantedBy=multi-user.target                # pour l'activation au boot
```

Lis-le section par section. `[Unit]` décrit le service et ses dépendances (`After=` : l'ordre de démarrage). `[Service]` est le cœur : **sous quel utilisateur** (`User=monapp`, le moindre privilège de la leçon 01), **quelle commande** (`ExecStart`), et **quoi faire au crash** (`Restart=always`). `[Install]` gère l'activation au boot. Chaque ligne est une décision — comprends-la avant de l'écrire.

### Activer et vérifier

```bash
sudo systemctl daemon-reload       # ⭐ relire les fichiers de service après modification
sudo systemctl enable --now monapp # activer au boot ET démarrer maintenant
systemctl status monapp            # vérifier qu'il tourne
```

`daemon-reload` est l'étape qu'on oublie : sans elle, systemd ignore tes modifications du fichier. `enable --now` combine l'activation au boot et le démarrage immédiat. Puis `status` confirme.

### ⭐ Lire les logs avec journalctl

```bash
journalctl -u monapp               # tous les logs du service monapp
journalctl -u monapp -f            # les suivre EN DIRECT (comme tail -f, leçon 01)
journalctl -u monapp --since "10 min ago"   # seulement les 10 dernières minutes
journalctl -u monapp -n 50         # les 50 dernières lignes
journalctl -u monapp -p err        # seulement les erreurs
```

systemd capture **tout** ce que le service écrit (sa sortie standard et ses erreurs) et le rend interrogeable. `-u` cible un service, `-f` suit en direct (pour regarder pendant un test), `--since` et `-p err` filtrent. C'est l'outil de diagnostic central : quand un service est en échec, `journalctl -u <service> -n 50` montre presque toujours la cause.

### Le cycle de diagnostic d'un service

```
systemctl status monapp     → en échec ? depuis quand ?
journalctl -u monapp -n 50  → pourquoi ? (le message d'erreur)
# corriger (le code, le fichier .service, les permissions...)
sudo systemctl daemon-reload   # si on a touché le .service
sudo systemctl restart monapp
systemctl status monapp     → de nouveau actif ?
```

Ce cycle — état, logs, correction, redémarrage, vérification — est le geste de base de l'exploitation d'un serveur. Tu le répéteras des centaines de fois.

---

## Les problèmes que tu vas rencontrer

**« J'ai modifié le fichier .service mais rien ne change. »** Tu as oublié `systemctl daemon-reload`. systemd lit une version en cache ; recharge-la, puis redémarre le service.

**Le service est en `failed` / boucle en redémarrages.** L'application crashe au démarrage. `journalctl -u monapp -n 50` donne la raison (chemin faux, port déjà pris, variable manquante, permission). Avec `Restart=always`, systemd réessaie en boucle — d'où l'importance de lire les logs pour casser la boucle.

**`ExecStart` échoue avec « No such file or directory ».** Le chemin de la commande n'est pas absolu (`node` au lieu de `/usr/bin/node`), ou le `WorkingDirectory` est faux. systemd ne connaît pas ton `PATH` d'utilisateur ; donne des chemins absolus.

**Le service tourne en `root` alors qu'il ne devrait pas.** Tu as oublié `User=`. Ajoute un utilisateur dédié (leçon 01) : un service compromis en `root` est une catastrophe.

**L'app démarre avant la base et plante.** Dépendance manquante. Ajoute `After=postgresql.service` dans `[Unit]`.

**Permission denied sur les fichiers de l'app.** L'utilisateur du service (`User=monapp`) n'a pas les droits sur `WorkingDirectory` ou les fichiers. C'est le problème de permissions de la leçon 01 : ajuste la propriété des fichiers vers cet utilisateur.

---

## Ce qu'on te demandera

En **test DevOps**, on vérifie que tu sais exploiter un service : « comment fais-tu tourner une application en permanence sur un serveur ? », « comment vois-tu si un service tourne et pourquoi il a planté ? », « comment fais-tu redémarrer une app automatiquement après un crash ? ». La réponse — un service systemd avec `Restart=always` et `journalctl` pour les logs — est attendue.

On peut demander : « différence entre `start` et `enable` ? », « pourquoi `daemon-reload` ? », « sous quel utilisateur fais-tu tourner l'app et pourquoi ? ».

En **mission**, piloter et diagnostiquer des services systemd est un geste quotidien dès qu'on touche à un serveur.

---

## Ce qui te démarquera

**Transformer ton app en vrai service.** Savoir écrire un fichier `.service` propre — utilisateur dédié, `Restart=always`, dépendances, logs — montre que tu sais déployer pour de vrai, pas juste lancer une commande.

**Le réflexe status → journalctl.** Face à « le site est down », dérouler `systemctl status` puis `journalctl -u … -n 50` au lieu de tâtonner est exactement la méthode qu'on attend. C'est rapide et ça trouve la cause.

**Ne pas oublier `daemon-reload`.** Ce petit détail distingue celui qui a compris le fonctionnement de systemd de celui qui bricole. L'intervieweur le remarque.

**Et relier systemd et Docker.** Comprendre que systemd et Docker (leçon 06) sont deux façons de faire tourner une app en permanence, et que Docker lui-même est lancé par systemd, montre une vision claire de l'exploitation.

---

## 📚 À lire

**La documentation Ubuntu/Debian → *systemd* et *managing services*** : l'introduction pratique, adaptée au serveur que tu utilises.

**`man systemd.service`** : la référence de toutes les directives d'un fichier de service (`ExecStart`, `Restart`, `User`, `After`…). Dense mais complète ; consulte-la quand tu écris un service.

**Digital Ocean → tutoriels *systemctl* et *journalctl*** : clairs, orientés cas réels, parfaits pour débuter.

Relis la leçon 01 : un service est un processus géré, sous un utilisateur dédié, avec ses permissions. Tout s'enchaîne.

---

## 🤖 Le mini-projet à demander à l'IA

Faire tourner un de tes backends comme un service systemd :

> « Je suis en formation de développeur, palier 8 (DevOps). J'ai des backends (Node, Python/gunicorn, PHP) que je lançais à la main en développement. Je veux en faire tourner un comme un vrai service systemd. Sans me donner un fichier tout fait à copier sans comprendre, guide-moi directive par directive pour écrire mon fichier .service : explique-moi à quoi sert chaque ligne (Description, After, User, WorkingDirectory, ExecStart, Restart, EnvironmentFile) et ce qui se passe si je la mets mal. Insiste sur l'utilisateur dédié (pas root) et sur Restart=always. »

Puis le diagnostic :

> « Aide-moi à m'entraîner au cycle de diagnostic d'un service : donne-moi des scénarios de panne (service en failed, boucle de redémarrage, ExecStart qui échoue, app qui démarre avant la base) et, pour chacun, fais-moi dérouler systemctl status puis journalctl pour trouver la cause, corriger, faire daemon-reload si besoin, et vérifier. Ne me donne pas la réponse d'emblée : fais-moi lire les logs et raisonner. »

---

## 🛠️ À faire

> Sur le VPS du référent ou une VM/conteneur jetable. Comprends chaque directive avant de l'activer.

1. **Piloter l'existant** : sur un service déjà présent (par ex. `nginx` ou `ssh`), fais `systemctl status`, et lis : actif ? depuis quand ? son PID ? Puis `restart` et re-vérifie.
2. **start vs enable** : explique par écrit la différence, puis vérifie avec `systemctl is-enabled <service>` si un service démarre au boot.
3. **⭐ Écrire un service** : écris un fichier `.service` pour un de tes backends, avec un **utilisateur dédié** (leçon 01), `ExecStart` en chemin absolu, `Restart=always`, et les variables d'environnement via `EnvironmentFile`.
4. **Activer** : `daemon-reload`, `enable --now`, puis `status` pour confirmer qu'il tourne.
5. **⭐ Tester le redémarrage automatique** : trouve le PID de ton app et `kill`-le (leçon 01). Vérifie avec `status` que systemd l'a **relancée** toute seule grâce à `Restart=always`.
6. **Lire les logs** : affiche les logs de ton service avec `journalctl -u`, suis-les en direct avec `-f` pendant que tu fais une requête, et filtre les erreurs avec `-p err`.
7. **Provoquer une panne** : introduis une erreur (mauvais chemin dans `ExecStart`, variable manquante), observe le service en `failed`, trouve la cause dans `journalctl`, corrige, `daemon-reload`, `restart`.
8. **L'oubli classique** : modifie une directive du `.service` SANS faire `daemon-reload`, constate que rien ne change, puis fais `daemon-reload` et vois la différence.
9. **La dépendance** : ajoute `After=` pour que ton app démarre après sa base de données, et explique pourquoi l'ordre compte.
10. **Le lien** : note dans ton journal comment la commande que tu lançais à la main (palier 4/5/6) est devenue une directive `ExecStart`, et ce que systemd ajoute par-dessus (permanence, redémarrage, logs).

<details>
<summary>Corrections et points de contrôle</summary>

**2.** `start` démarre le service **maintenant**, pour cette fois. `enable` le marque pour démarrer **automatiquement à chaque boot** du serveur. Les deux sont indépendants : un service peut être démarré sans être activé au boot (il ne reviendra pas après un redémarrage), ou activé sans être démarré (il attendra le prochain boot). `enable --now` fait les deux. En production, un service applicatif est presque toujours `enable` : il doit revenir seul après un redémarrage du serveur.

**5.** Le test le plus parlant : `Restart=always` fait que systemd relance le service dès qu'il meurt. Quand tu `kill` ton app, `systemctl status` montre qu'elle est **repartie** (nouveau PID, redémarrée il y a quelques secondes). C'est le filet de sécurité de la production : un crash ponctuel ne devient pas une panne. Attention toutefois : si l'app crashe **au démarrage** (erreur de config), `Restart=always` la fait boucler — d'où `journalctl` pour casser la boucle en trouvant la cause.

**7-8.** Les deux erreurs les plus fréquentes du palier. (7) Un service en `failed` a presque toujours sa cause dans `journalctl -u <service> -n 50` : chemin faux, port pris, variable manquante, permission. On ne devine pas, on **lit les logs**. (8) `daemon-reload` : systemd met les fichiers de service en cache ; sans recharger, tes modifications sont ignorées. « J'ai modifié le fichier mais rien ne change » = `daemon-reload` oublié, à chaque fois.

**10.** Le lien conceptuel du palier : en développement tu lançais `node server.js` ou `gunicorn` dans un terminal, et ça mourait à la fermeture. systemd prend cette même commande (`ExecStart`), et l'enveloppe de tout ce qui fait une exécution de production : elle tourne sous un utilisateur dédié, survit à ta déconnexion, redémarre après un crash, démarre au boot, et journalise tout. C'est le passage du « ça tourne pendant que je regarde » au « ça tourne, point ». Docker (leçon 06) offre une autre voie vers le même but — et les deux se complètent.
</details>

---

## ✅ Acquis si…

- [ ] Je pilote un service avec `systemctl status/start/stop/restart`.
- [ ] Je distingue `start` (maintenant) de `enable` (au boot).
- [ ] J'écris un fichier `.service` avec un utilisateur dédié, `ExecStart` absolu et `Restart=always`.
- [ ] Je fais `daemon-reload` après chaque modification du fichier de service.
- [ ] Je vérifie qu'un service redémarre seul après un crash.
- [ ] Je lis et filtre les logs d'un service avec `journalctl` (`-u`, `-f`, `-n`, `-p err`).
- [ ] Je déroule le cycle status → journalctl → correction → restart face à une panne.
- [ ] Je fais le lien entre la commande lancée à la main et le service systemd.

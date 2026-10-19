# Leçon 01 — Linux : utilisateurs, permissions, processus

> 🎯 **À la fin de cette leçon** : tu te repères sur un serveur Linux — qui es-tu, qui a le droit de faire quoi, ce qui tourne — et tu ne colles plus jamais une commande sans la comprendre.
> ⏱️ 4 h · **Prérequis** : le terminal du palier 0 (leçons 01-02).

> ⚠️ **Le garde-fou de ce palier, dès la première leçon** : sur un serveur, une commande incomprise peut tout détruire, et **il n'y a pas de `reflog`** comme avec Git. Avant chaque commande, sache ce qu'elle fait. En cas de doute, demande d'abord « explique-moi cette commande » à l'IA — jamais « donne-moi la commande » que tu colles les yeux fermés.

---

## De quoi on parle

Un serveur Linux, c'est le terminal du palier 0, mais pour de vrai : une machine distante, sans écran, où ton application va vivre. Trois notions structurent tout le reste :

- les **utilisateurs et groupes** : qui agit sur la machine (toi, l'application, les services), avec quelle identité ;
- les **permissions** : qui a le droit de lire, écrire, exécuter chaque fichier ;
- les **processus** : les programmes en cours d'exécution, qu'on peut lister, surveiller, arrêter.

Tu connais déjà le terminal (naviguer, `ls`, `cd`, les chemins — palier 0). Ici, tu ajoutes la dimension **multi-utilisateurs et sécurité** qui définit un serveur : contrairement à ton portable où tu es seul maître, un serveur distingue strictement qui peut quoi. Comprendre ça, c'est la base de tout le palier — et la condition pour ne rien casser.

---

## À quoi ça sert, concrètement

**Parce que ton application tournera sur Linux.** La quasi-totalité des serveurs web sont sous Linux. Même si tu développes sur Mac ou Windows, c'est sur Linux que ton code sera déployé (palier 8), exécuté, surveillé. Savoir s'y déplacer n'est pas optionnel : c'est l'environnement cible.

**Parce que les permissions sont la première cause de « ça marche en local, ça casse sur le serveur ».** Un fichier que l'application ne peut pas lire, un dossier d'upload où elle ne peut pas écrire, un script qui n'est pas exécutable : 90 % des premiers bugs de déploiement sont des problèmes de permissions ou d'utilisateur. Les comprendre t'évite des heures de blocage.

**Parce que « qui exécute l'application » est une décision de sécurité.** Une application ne doit **jamais** tourner en `root` (l'administrateur tout-puissant). Si elle est compromise, l'attaquant hérite de ses droits. Faire tourner l'app sous un utilisateur dédié aux droits limités est un principe de sécurité fondamental (le moindre privilège), que tu appliqueras au palier 09.

**Et parce que diagnostiquer, c'est savoir ce qui tourne.** Quand le serveur rame ou que l'application ne répond plus, la première question est « quels processus tournent, lequel consomme tout ? ». Lister et comprendre les processus est le point de départ de tout diagnostic (leçon 10).

---

## Où ça intervient dans le développement

Linux est le sol sur lequel tout le palier 8 est construit :

```
   Toi (ssh, leçon 03) ──▶ SERVEUR LINUX
                              ├── utilisateurs/groupes : toi, www-data (le serveur web), ...
                              ├── permissions : qui lit/écrit/exécute quoi
                              ├── processus : nginx, ton app, la base... (ce qui tourne)
                              └── systemd (leçon 02) gère ces processus comme des services
```

Trois ancrages.

**C'est le terminal du palier 0, en multi-utilisateurs.** Les commandes de navigation (`cd`, `ls`, `pwd`, les chemins) sont identiques. Ce qui est neuf : l'identité (qui tu es), les droits (ce que tu peux), et le fait que plusieurs « acteurs » cohabitent sur la même machine.

**Les permissions expliqueront tes bugs de déploiement (leçons 05-09).** Quand Nginx (leçon 05) ne pourra pas lire tes fichiers, ou que ton app ne pourra pas écrire ses logs, la cause sera ici. Cette leçon te donne la grille de lecture.

**L'utilisateur dédié prépare la sécurité (leçon 09).** Le principe « l'app tourne sous un utilisateur non privilégié » posé ici est appliqué en grand quand tu sécuriseras le VPS (leçon 09) : pas de `root`, un utilisateur par rôle.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas explorer ton propre système (ou le VPS fourni par le référent) : voir qui tu es (`whoami`, `id`), lire et modifier des permissions (`ls -l`, `chmod`, `chown`), créer un utilisateur dédié, et lister/inspecter les processus (`ps`, `top`, `kill`). Tu feras tout en comprenant chaque commande **avant** de l'exécuter.

### En équipe, en entreprise

**Tu auras un accès limité, pas `root`.** Sur les serveurs d'entreprise, tu te connectes sous ton utilisateur, et tu utilises `sudo` pour les actions administratives — avec parcimonie et compréhension. L'accès `root` direct est rare et surveillé.

**Les permissions sont un sujet de production permanent.** Déploiements, montages de volumes, fichiers partagés entre l'application et le serveur web : les droits se négocient tout le temps. `www-data` (l'utilisateur du serveur web) doit pouvoir lire les fichiers de l'app mais pas forcément y écrire — ce genre d'arbitrage est quotidien.

**Le diagnostic commence toujours par « que se passe-t-il ? ».** `top`/`htop` pour la charge, `ps` pour les processus, `df` pour l'espace disque : ce sont les premiers gestes quand quelque chose ne va pas. On les fait des dizaines de fois par semaine.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : `cd`/`ls`/`pwd` (palier 0), `cat`/`less` pour lire un fichier, `whoami`/`id`, `ls -l` pour voir les droits, `top`/`ps` pour les processus, `sudo` pour une action admin.

Régulièrement : `chmod`/`chown` pour ajuster des droits, créer un utilisateur (`adduser`), `kill` pour arrêter un processus récalcitrant, `grep`/`find` sur le serveur.

Rare ou avancé : les permissions spéciales (setuid, setgid, sticky bit), les ACL fines, la gestion détaillée des groupes système, les quotas. À connaître de nom ; tu les creuseras par besoin.

---

## La mécanique

### Qui suis-je ? (identité)

```bash
whoami        # mon nom d'utilisateur
id            # mon identité complète : uid, gid, groupes d'appartenance
groups        # les groupes auxquels j'appartiens
```

Sur un serveur, la première question est toujours « sous quelle identité suis-je en train d'agir ? ». Un `root` peut tout casser ; un utilisateur limité est protégé par ses propres droits. `id` te le dit.

### ⭐ Lire les permissions (`ls -l`)

```
-rw-r--r--  1 sergeo www-data  1240 oct. 19 10:30 config.php
│└┬┘└┬┘└┬┘    └─┬──┘ └──┬───┘
│ │  │  │       │       └── groupe propriétaire
│ │  │  │       └────────── utilisateur propriétaire
│ │  │  └── autres (r--)   : les autres peuvent lire
│ │  └───── groupe (r--)   : le groupe peut lire
│ └──────── proprio (rw-)  : le propriétaire peut lire et écrire
└────────── type (-=fichier, d=dossier, l=lien)
```

Chaque fichier a un **propriétaire**, un **groupe**, et trois triplets de droits : pour le propriétaire, pour le groupe, pour les autres. Chaque triplet combine **r** (lire), **w** (écrire), **x** (exécuter). Savoir lire cette ligne est la compétence de base : elle répond à « pourquoi l'application ne peut-elle pas lire/écrire ce fichier ? ».

### Changer les permissions et le propriétaire

```bash
chmod u+x deploy.sh        # rendre exécutable pour le propriétaire (u=user, +x)
chmod 640 config.php       # proprio rw-, groupe r--, autres rien (notation octale)
chown sergeo:www-data fichier    # changer propriétaire:groupe
chown -R sergeo:www-data dossier/  # récursivement sur un dossier
```

`chmod` change les droits, `chown` change le propriétaire. La notation octale (`640`) condense les trois triplets : 6=rw-, 4=r--, 0=---. 

> ⚠️ **`chmod 777` n'est jamais la solution.** « Donner tous les droits à tout le monde » fait disparaître le symptôme en créant une faille : n'importe qui (ou n'importe quel processus compromis) peut tout modifier. Le bon réflexe est de donner **le droit juste nécessaire** au **bon utilisateur**, pas tous les droits à tous. Si tu vois `chmod 777` dans un tutoriel, c'est un signal d'alarme.

### sudo : agir en administrateur, à dessein

```bash
sudo systemctl restart nginx    # exécuter CETTE commande en tant qu'admin
```

`sudo` exécute une seule commande avec les privilèges d'administrateur. C'est le bon modèle : on reste utilisateur limité, et on élève ses droits **ponctuellement et consciemment**, pas en permanence. Chaque `sudo` doit être une décision, pas une habitude.

### ⭐ L'utilisateur dédié à l'application

```bash
sudo adduser --system --group monapp     # un utilisateur système pour l'app
# l'application tourne sous "monapp", pas sous root :
# si elle est compromise, l'attaquant n'a QUE les droits de "monapp", limités.
```

Principe du **moindre privilège** : chaque chose tourne avec le minimum de droits dont elle a besoin. Une application web n'a pas besoin d'être `root` ; elle a besoin de lire son code et d'écrire ses logs/uploads. Lui donner un utilisateur dédié aux droits limités borne les dégâts en cas de faille. C'est un pilier de la sécurité serveur (leçon 09).

### Les processus : ce qui tourne

```bash
ps aux                  # tous les processus, avec utilisateur, CPU, mémoire
top     (ou htop)       # vue temps réel, triée par consommation (q pour quitter)
ps aux | grep nginx     # retrouver un processus précis (le pipe du palier 0)
kill 1234               # demander l'arrêt du processus n° 1234 (PID)
kill -9 1234            # le forcer (dernier recours, ne nettoie pas derrière lui)
```

Un processus a un numéro (PID), un utilisateur propriétaire, une consommation CPU/mémoire. `top`/`htop` montrent en temps réel ce qui charge la machine — le premier geste de diagnostic. `kill` demande poliment l'arrêt (le programme peut se fermer proprement) ; `kill -9` force (brutal, à éviter sauf blocage). Note la réutilisation du `grep` et du pipe `|` du palier 0.

### Les logs, où tout se raconte

```bash
cat /var/log/...        # lire un journal
tail -f /var/log/...    # suivre un journal EN DIRECT (Ctrl-C pour arrêter)
```

Sous Linux, les programmes écrivent ce qu'ils font dans `/var/log/`. `tail -f` affiche les nouvelles lignes en temps réel — indispensable pour voir ce que fait une application pendant qu'on la teste. On y revient en profondeur à la leçon 10 (et avec `journalctl` à la leçon 02).

---

## Les problèmes que tu vas rencontrer

**`Permission denied`.** Le plus fréquent. L'utilisateur sous lequel tu agis (ou sous lequel tourne l'app) n'a pas le droit sur ce fichier/dossier. Lis `ls -l`, identifie propriétaire et droits, et corrige avec le **droit juste** (pas `chmod 777`).

**L'application ne peut pas écrire ses uploads/logs.** Le dossier appartient à un autre utilisateur, ou l'app n'a pas le droit `w`. Donne la propriété ou le droit d'écriture au **bon** utilisateur (celui qui fait tourner l'app).

**`command not found` alors que la commande existe.** Le `PATH` (où le shell cherche les programmes) ne l'inclut pas, ou tu n'es pas le bon utilisateur. Vérifie `which <commande>` et ton identité.

**Mon script ne s'exécute pas.** Il n'a pas le droit `x`. `chmod u+x script.sh`. Et vérifie la première ligne (`#!/bin/bash`).

**Le serveur rame, je ne sais pas pourquoi.** `top`/`htop` : regarde quel processus consomme le CPU ou la mémoire. `df -h` : vérifie l'espace disque (un disque plein paralyse tout). C'est le début du diagnostic (leçon 10).

**J'ai fait `sudo` sur une commande que je ne comprenais pas.** Le danger de ce palier. `sudo` lève les garde-fous : une commande destructrice en `sudo` ne demande pas de permission. Ne mets jamais `sudo` devant une commande que tu ne comprends pas entièrement.

---

## Ce qu'on te demandera

En **entretien ou test DevOps**, les bases Linux sont vérifiées : « comment lis-tu les permissions d'un fichier ? », « que fait `chmod 640` ? », « pourquoi ne pas faire tourner une app en `root` ? », « comment vois-tu ce qui consomme le CPU ? ». Ce sont des questions de culture système attendues dès qu'on parle de déploiement.

On peut demander : « différence entre `kill` et `kill -9` ? », « à quoi sert `sudo` et pourquoi pas être `root` en permanence ? », « que regardes-tu en premier si un serveur est lent ? ».

En **mission**, on attend que tu te débrouilles sur un serveur : lire des droits, ajuster une permission, repérer un processus, lire un log — sans faire de dégât.

---

## Ce qui te démarquera

**Le réflexe du moindre privilège.** Dire « l'app tourne sous un utilisateur dédié, pas en `root`, avec les droits strictement nécessaires » montre que tu penses sécurité dès la base, pas seulement quand on te le demande.

**Refuser `chmod 777`.** Savoir que « tous les droits à tout le monde » n'est jamais la bonne réponse, et donner le droit juste au bon utilisateur, te distingue de celui qui copie un tutoriel pour faire taire l'erreur.

**La discipline « comprendre avant d'exécuter ».** C'est le garde-fou du palier, et c'est aussi une qualité professionnelle : sur un serveur de production, la personne qui ne colle jamais une commande à l'aveugle est celle en qui on a confiance. Il n'y a pas de `reflog` sur un `rm`.

**Et savoir diagnostiquer froidement.** Face à un serveur en difficulté, dérouler calmement `top` → `df` → les logs, au lieu de paniquer, est exactement le sang-froid qu'on attend en production.

---

## 📚 À lire

**The Linux Command Line (W. Shotts)**, chapitres sur les permissions et les processus : gratuit en ligne, la meilleure introduction, claire et progressive.

**Les pages de manuel** : `man chmod`, `man ps`, `man sudo`. Apprendre à lire un `man` est une compétence en soi — c'est la documentation de référence, toujours disponible sur le serveur.

**La documentation de ta distribution (Ubuntu/Debian Server Guide) → *users and groups*, *file permissions*** : adaptée au contexte serveur que tu vas utiliser.

Relis le palier 0, leçons 01-02 (terminal) : navigation et pipes sont les mêmes ; tu ajoutes l'identité, les droits et les processus.

---

## 🤖 Le mini-projet à demander à l'IA

Explorer un système en comprenant chaque commande (jamais copier à l'aveugle) :

> « Je suis en formation de développeur, palier 8 (DevOps). Je débute sur les serveurs Linux et la règle d'or de mon palier est : ne jamais exécuter une commande que je ne comprends pas. Sans me donner des commandes à copier bêtement, guide-moi par étapes pour explorer un système : savoir qui je suis (identité, groupes), lire les permissions d'un fichier avec ls -l (explique-moi chaque caractère), et lister les processus. Pour CHAQUE commande que tu proposes, explique-moi d'abord ce qu'elle fait et ce qui pourrait mal tourner, puis laisse-moi décider de l'exécuter. »

Puis les permissions et le moindre privilège :

> « Aide-moi à comprendre les permissions par la pratique : propose-moi des situations (une app qui ne peut pas écrire ses logs, un script non exécutable, un fichier de config trop ouvert) et, pour chacune, fais-moi diagnostiquer avec ls -l et choisir le droit JUSTE à donner au BON utilisateur — jamais chmod 777. Explique-moi pourquoi une application ne doit jamais tourner en root (moindre privilège) et comment créer un utilisateur dédié. »

---

## 🛠️ À faire

> Fais ces exercices sur le VPS fourni par le référent, ou sur une machine virtuelle / un conteneur jetable — jamais sur un serveur de production. Et **comprends chaque commande avant de l'exécuter**.

1. **Qui suis-je** : utilise `whoami`, `id`, `groups`. Note ton uid, ton groupe principal, tes groupes secondaires.
2. **⭐ Lire les droits** : fais `ls -l` dans plusieurs dossiers et déchiffre, pour trois fichiers, chaque partie de la ligne (type, droits proprio/groupe/autres, propriétaire, groupe).
3. **Changer les droits** : crée un script `hello.sh`, constate qu'il n'est pas exécutable, rends-le exécutable pour le propriétaire seulement (`chmod u+x`), et exécute-le.
4. **Le piège 777** : cherche « chmod 777 » dans un tutoriel au hasard, et écris dans ton journal pourquoi c'est une mauvaise réponse et quel droit juste aurait convenu.
5. **⭐ Utilisateur dédié** : crée un utilisateur système pour une application fictive, et explique (par écrit) pourquoi faire tourner l'app sous lui plutôt que sous `root` limite les dégâts d'une compromission.
6. **Les processus** : lance `top` (ou `htop`), identifie le processus qui consomme le plus, et quitte proprement (`q`). Puis retrouve un processus précis avec `ps aux | grep`.
7. **Arrêter un processus** : lance un programme en arrière-plan (par exemple `sleep 300 &`), retrouve son PID, et arrête-le avec `kill`. Observe la différence avec `kill -9`.
8. **Suivre un log en direct** : trouve un fichier dans `/var/log/`, affiche ses dernières lignes avec `tail`, puis suis-le en direct avec `tail -f`.
9. **Le diagnostic de base** : enchaîne `top`, `df -h` (espace disque) et la lecture d'un log, comme tu le ferais face à un serveur lent. Note l'ordre de tes gestes.
10. **La discipline** : pour chaque commande de cette leçon, vérifie que tu peux l'expliquer en une phrase. Celles que tu ne peux pas expliquer, cherche-les (`man`) avant de les réutiliser.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** La ligne `ls -l` est la grille de lecture de tout le palier. `-rw-r--r--` : le `-` initial = fichier (un `d` = dossier) ; puis trois triplets — propriétaire (`rw-` = lit et écrit), groupe (`r--` = lit seulement), autres (`r--` = lit seulement). Savoir lire ça répond directement à « pourquoi l'app ne peut-elle pas écrire ici ? » : regarde qui est propriétaire et quels droits a l'utilisateur qui fait tourner l'app.

**4.** `chmod 777` donne lecture + écriture + exécution à **tout le monde**. Ça fait disparaître un `Permission denied`, mais en ouvrant le fichier à tous les utilisateurs et à tout processus compromis — une faille, pas une correction. La bonne réponse est toujours : identifier le **bon utilisateur** (celui qui doit agir) et lui donner le **droit juste** (souvent via `chown` vers cet utilisateur, puis un droit minimal). `777` dans un tutoriel est un signal d'alarme.

**5.** Le moindre privilège, pilier de la sécurité serveur. Si une app tourne en `root` et qu'un attaquant l'exploite, il obtient le contrôle total de la machine. Si elle tourne sous `monapp` (droits limités : lire son code, écrire ses logs), l'attaquant est confiné à ces droits : il ne peut pas toucher le reste du système. On borne les dégâts **avant** qu'ils arrivent. C'est exactement ce que tu appliqueras en grand à la leçon 09.

**7.** `kill` envoie un signal de terminaison que le programme peut intercepter pour se fermer proprement (fermer ses fichiers, finir sa requête). `kill -9` envoie un signal non interceptable : le programme est tué net, sans nettoyer — données en cours potentiellement perdues, verrous non libérés. D'où la règle : `kill` d'abord, `kill -9` seulement si le processus est vraiment bloqué.

**Partout.** La discipline « comprendre avant d'exécuter » n'est pas de la prudence excessive : sur un serveur, `rm -rf` sur le mauvais chemin, un `chown -R` trop large, un `kill` sur le mauvais PID n'ont pas de `reflog`. La différence avec Git (palier 0), où presque tout se rattrape, est fondamentale. Le professionnel de confiance est celui qui ne colle jamais une commande à l'aveugle.
</details>

---

## ✅ Acquis si…

- [ ] Je sais sous quelle identité j'agis (`whoami`, `id`) et pourquoi ça compte.
- [ ] Je lis une ligne `ls -l` : type, droits propriétaire/groupe/autres, propriétaire, groupe.
- [ ] J'ajuste des droits avec `chmod`/`chown` en donnant le droit juste au bon utilisateur.
- [ ] Je sais pourquoi `chmod 777` n'est jamais la bonne réponse.
- [ ] Je sais pourquoi une application ne doit pas tourner en `root` (moindre privilège).
- [ ] Je liste et inspecte les processus (`ps`, `top`), et j'en arrête un (`kill`).
- [ ] Je lis et suis un log en direct (`tail -f`).
- [ ] Je déroule un diagnostic de base (processus, disque, logs) sans paniquer.
- [ ] Je n'exécute jamais une commande que je ne peux pas expliquer.

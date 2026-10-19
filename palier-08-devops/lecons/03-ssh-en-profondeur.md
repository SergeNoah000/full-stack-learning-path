# Leçon 03 — SSH en profondeur : clés, config, tunnels, durcissement

> 🎯 **À la fin de cette leçon** : tu te connectes à un serveur par clé (sans mot de passe), tu simplifies tes connexions avec `~/.ssh/config`, et tu sais durcir l'accès SSH de ton propre serveur.
> ⏱️ 3 h · **Prérequis** : leçon 01 (Linux), et les clés SSH de GitHub (palier 0, leçon 04).

> ⚠️ Rappel du garde-fou : une mauvaise manipulation de la configuration SSH peut te **verrouiller dehors** de ton propre serveur. Garde toujours une session ouverte pendant que tu modifies la config, et teste avant de fermer.

---

## De quoi on parle

**SSH** (*Secure Shell*) est le protocole qui te permet de piloter un serveur distant depuis ton terminal, de façon chiffrée. C'est la porte d'entrée de tout le travail sur serveur : sans SSH, pas d'accès.

Tu l'as déjà rencontré au palier 0 : tes **clés SSH** pour pousser sur GitHub sans mot de passe. Ici, on va au fond du sujet :

- l'**authentification par clé** (paire clé privée/clé publique) plutôt que par mot de passe ;
- le fichier **`~/.ssh/config`** qui transforme `ssh -i ~/.ssh/id_serveur -p 2222 deploy@203.0.113.5` en un simple `ssh monserveur` ;
- les **tunnels** SSH, pour accéder à un service distant (une base de données) comme s'il était local ;
- le **durcissement** : configurer le serveur pour n'accepter que les clés, désactiver le login `root`, changer les réglages risqués.

C'est le même mécanisme de clés que GitHub, appliqué cette fois à **tes** serveurs, et poussé jusqu'à la sécurisation de l'accès.

---

## À quoi ça sert, concrètement

**Parce que c'est ton seul accès au serveur.** Un serveur n'a ni écran ni clavier : tout passe par SSH. Savoir s'y connecter de façon fiable et sûre est la compétence préalable à tout le reste du palier — déployer, configurer, diagnostiquer, tout se fait via SSH.

**Parce que l'authentification par clé est bien plus sûre que le mot de passe.** Un mot de passe peut être deviné, rejoué, forcé (des milliers de tentatives par jour sur tout serveur exposé). Une clé cryptographique de 4096 bits est, en pratique, impossible à forcer. Passer aux clés et désactiver le mot de passe est la première mesure de sécurité d'un serveur — tu la vois ici, tu l'appliques en grand à la leçon 09.

**Parce que `~/.ssh/config` t'épargne des erreurs et du temps.** Retaper l'IP, le port, l'utilisateur et le chemin de la clé à chaque connexion est pénible et source d'erreurs. Un alias dans `~/.ssh/config` fiabilise et simplifie. Les pros ont tous un `config` soigné.

**Et parce que les tunnels débloquent des accès autrement fermés.** La base de données d'un serveur ne doit **pas** être exposée à Internet (leçon 09). Mais tu dois parfois t'y connecter avec un outil graphique depuis ta machine. Un tunnel SSH te donne cet accès de façon sûre, à travers la connexion SSH déjà chiffrée, sans ouvrir la base au monde.

---

## Où ça intervient dans le développement

SSH est le canal par lequel passe tout le travail sur serveur :

```
   Ta machine ──[SSH, chiffré]──▶ SERVEUR
     clé privée (secrète)          clé publique (dans ~/.ssh/authorized_keys)
     ~/.ssh/config (alias)
        │
        ├── piloter : lancer des commandes, éditer des fichiers (leçons 01-02)
        ├── déployer : via Git, ou copie de fichiers (scp/rsync), CI/CD (leçon 08)
        └── tunnel : accéder à la base distante comme si elle était locale
```

Trois ancrages.

**C'est la clé SSH de GitHub (palier 0), généralisée.** Au palier 0, tu as créé une paire de clés pour GitHub. Le mécanisme est identique ici : ta clé **privée** reste sur ta machine (jamais partagée), ta clé **publique** est déposée sur le serveur. Tu réutilises exactement ce que tu sais.

**C'est le canal du déploiement (leçon 08).** Déployer, c'est souvent se connecter en SSH et lancer des commandes, ou laisser la CI/CD (leçon 08) le faire avec une clé dédiée. Le durcissement que tu apprends ici protège ce canal critique.

**Et le durcissement prépare la leçon 09.** Désactiver le login par mot de passe et le login `root`, que tu fais ici sur l'accès SSH, est le premier chapitre de la sécurisation complète du VPS (leçon 09).

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas générer une paire de clés dédiée au serveur, déposer la clé publique sur le VPS, te connecter **sans mot de passe**, créer un alias dans `~/.ssh/config`, ouvrir un tunnel vers la base distante, et durcir la configuration SSH du serveur (clés seulement, pas de `root`).

### En équipe, en entreprise

**Chaque personne a sa propre clé.** On ne partage jamais une clé privée. Chaque développeur dépose **sa** clé publique sur les serveurs auxquels il accède ; on peut ainsi révoquer un accès individuel sans affecter les autres.

**Les serveurs n'acceptent que les clés.** L'authentification par mot de passe est désactivée sur tout serveur sérieux. Arriver avec une clé prête est la norme.

**`~/.ssh/config` est partagé en équipe (le format, pas les clés).** On documente les alias des serveurs du projet. Un nouvel arrivant configure son accès en quelques minutes grâce à ça.

**Les tunnels servent au quotidien pour les bases.** Se connecter à la base de pré-production avec un client graphique, via un tunnel SSH, sans jamais exposer cette base : un geste courant et sûr.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : `ssh monserveur` (via l'alias), lancer des commandes à distance, copier des fichiers (`scp`/`rsync`).

Régulièrement : générer une clé (`ssh-keygen`), déposer une clé publique (`ssh-copy-id`), éditer `~/.ssh/config`, ouvrir un tunnel pour accéder à une base.

Rare ou avancé : l'agent SSH et le *forwarding* d'agent, les *jump hosts* (rebond par un serveur intermédiaire), les certificats SSH, les tunnels inverses. À connaître de nom ; utiles dans des topologies réseau complexes.

---

## La mécanique

### La paire de clés (rappel du palier 0, approfondi)

```bash
ssh-keygen -t ed25519 -C "serveur-perso" -f ~/.ssh/id_serveur
# crée deux fichiers :
#   ~/.ssh/id_serveur       → clé PRIVÉE (SECRÈTE, ne quitte JAMAIS ta machine)
#   ~/.ssh/id_serveur.pub   → clé PUBLIQUE (à déposer sur les serveurs)
```

Le principe cryptographique : ce que la clé privée signe, la clé publique le vérifie, et l'inverse est impossible. On peut donc diffuser la publique partout sans risque, tant que la privée reste secrète. `ed25519` est l'algorithme moderne recommandé (plus court et plus sûr que l'ancien RSA). Protège ta clé privée par une phrase de passe.

> ⚠️ Une clé **privée** ne se partage jamais, ne se met jamais dans un dépôt Git, ne s'envoie jamais par mail. Si elle fuite, on la révoque et on en génère une autre. Seule la `.pub` circule.

### Déposer la clé publique et se connecter

```bash
ssh-copy-id -i ~/.ssh/id_serveur.pub deploy@203.0.113.5
# ...ajoute ta clé publique dans ~/.ssh/authorized_keys du serveur.
ssh -i ~/.ssh/id_serveur deploy@203.0.113.5     # connexion SANS mot de passe
```

La clé publique va dans le fichier `~/.ssh/authorized_keys` du serveur (la liste des clés autorisées). Dès lors, le serveur reconnaît ta clé privée et t'ouvre sans mot de passe. `ssh-copy-id` automatise ce dépôt (sinon, on colle le contenu de la `.pub` à la main dans `authorized_keys`).

### ⭐ `~/.ssh/config` : des alias lisibles

```
# ~/.ssh/config
Host monserveur
    HostName 203.0.113.5
    User deploy
    Port 2222
    IdentityFile ~/.ssh/id_serveur

Host *
    AddKeysToAgent yes
    ServerAliveInterval 60     # garder la connexion vivante
```

Avec ça, `ssh -i ~/.ssh/id_serveur -p 2222 deploy@203.0.113.5` devient simplement **`ssh monserveur`**. `scp` et `rsync` utilisent le même alias. Un `config` bien tenu élimine les erreurs de frappe et documente tes serveurs. C'est le premier fichier que configure un développeur efficace.

### Copier des fichiers

```bash
scp fichier.txt monserveur:/opt/monapp/          # copier vers le serveur (via l'alias)
rsync -avz ./build/ monserveur:/opt/monapp/build/ # synchroniser un dossier (efficace)
```

`scp` copie un fichier, `rsync` synchronise des dossiers en ne transférant que les différences (rapide pour les mises à jour). Tous deux passent par SSH, donc par ton alias et ta clé.

### ⭐ Les tunnels : atteindre un service distant en local

```bash
# "sur mon port local 5433, rends-moi la base PostgreSQL du serveur (son port 5432)"
ssh -L 5433:localhost:5432 monserveur
# Tant que cette connexion est ouverte, un client sur ma machine qui vise
# localhost:5433 parle en réalité à la base du serveur, à travers le tunnel chiffré.
# La base reste FERMÉE à Internet (leçon 09) ; seul SSH y donne accès.
```

Le tunnel (*port forwarding*) fait apparaître un service distant sur un port de ta machine. Usage typique : brancher un client graphique de base de données (DBeaver, TablePlus) sur `localhost:5433` pour explorer la base de production, sans jamais exposer cette base au monde. Tout passe par la connexion SSH déjà chiffrée et authentifiée.

### ⭐ Durcir l'accès SSH du serveur

```
# /etc/ssh/sshd_config (sur le SERVEUR)
PermitRootLogin no              # interdire la connexion directe en root
PasswordAuthentication no       # n'accepter QUE les clés, plus de mot de passe
PubkeyAuthentication yes        # (activé par défaut) authentification par clé
```

```bash
sudo systemctl restart ssh      # appliquer (systemd, leçon 02)
```

Deux réglages transforment la sécurité : interdire le login `root` (on se connecte en utilisateur limité, puis `sudo` — leçon 01) et refuser le mot de passe (seules les clés passent, ce qui rend les attaques par force brute inutiles). C'est le socle du durcissement (leçon 09).

> ⚠️ **Le piège qui te verrouille dehors.** Avant de poser `PasswordAuthentication no`, vérifie que ta connexion **par clé fonctionne déjà**. Et garde une session SSH **ouverte** pendant que tu modifies et redémarres : si tu t'es trompé, cette session te permet de corriger. Teste une nouvelle connexion dans un **second** terminal avant de fermer le premier. Sinon, une erreur de config te claque la porte au nez — et sans accès physique, c'est le support de l'hébergeur qu'il faut appeler.

---

## Les problèmes que tu vas rencontrer

**`Permission denied (publickey)`.** Le serveur n'accepte pas ta clé. Causes : la clé publique n'est pas dans `authorized_keys` du serveur, tu présentes la mauvaise clé (`-i` ou `IdentityFile` erroné), ou les **permissions** de `~/.ssh` sont trop ouvertes (SSH refuse une clé privée lisible par d'autres — `chmod 600`, leçon 01).

**On me demande encore un mot de passe.** La clé n'est pas reconnue : dépôt manquant ou mauvais `IdentityFile`. Vérifie avec `ssh -v` (mode verbeux) quelle clé est tentée.

**Je suis verrouillé dehors après avoir durci.** Le scénario catastrophe. Si tu as gardé une session ouverte (comme recommandé), corrige `sshd_config` et redémarre. Sinon, passe par la console de secours de ton hébergeur. **D'où la règle : toujours une session de secours ouverte.**

**`Host key verification failed`.** La clé d'hôte du serveur a changé (réinstallation, ou — rarement — interception). SSH t'alerte. Si le changement est légitime (tu as réinstallé le serveur), retire l'ancienne entrée de `~/.ssh/known_hosts` ; sinon, méfie-toi.

**Mon tunnel ne marche pas.** Le port local est déjà pris (choisis-en un autre, `5433` au lieu de `5432`), ou le service distant n'écoute pas sur le port visé. Vérifie côté serveur avec les outils de la leçon 04.

**Permissions de `~/.ssh` refusées.** SSH est strict : `~/.ssh` doit être en `700`, la clé privée en `600`. Trop ouvert → SSH refuse de l'utiliser (c'est une protection). Corrige avec `chmod` (leçon 01).

---

## Ce qu'on te demandera

En **test DevOps**, SSH est un prérequis vérifié : « comment te connectes-tu à un serveur sans mot de passe ? », « différence entre clé privée et clé publique ? », « comment sécurises-tu l'accès SSH d'un serveur ? » (clés seulement, pas de `root`). On attend aussi que tu saches copier un fichier (`scp`/`rsync`).

On peut demander : « à quoi sert un tunnel SSH ? » (accéder à un service non exposé), « où ne mets-tu jamais ta clé privée ? » (nulle part d'autre que ta machine), « pourquoi désactiver le mot de passe ? ».

En **mission**, un `~/.ssh/config` propre et l'accès par clé sont la base ; on ne t'expliquera pas comment te connecter, on supposera que tu sais.

---

## Ce qui te démarquera

**Un `~/.ssh/config` soigné.** Des alias clairs pour chaque serveur, c'est le signe d'un développeur organisé et efficace. Ça impressionne par sa simplicité.

**La discipline de la clé privée.** Savoir qu'elle ne quitte jamais ta machine, ne va jamais dans Git, et se révoque si elle fuite, montre une hygiène de sécurité que beaucoup négligent.

**Durcir sans se verrouiller dehors.** La méthode « je garde une session de secours, je teste la nouvelle connexion dans un second terminal avant de fermer » révèle quelqu'un qui a déjà réfléchi aux conséquences — exactement le sang-froid qu'on veut sur de la production.

**Et les tunnels.** Savoir atteindre une base non exposée via un tunnel SSH, plutôt que de l'ouvrir à Internet, montre que tu concilies accès et sécurité — un réflexe mûr.

---

## 📚 À lire

**La documentation OpenSSH** et **`man ssh_config`, `man sshd_config`** : les références des deux fichiers de configuration (côté client et côté serveur). À consulter quand tu règles une directive.

**Digital Ocean → *SSH essentials*, *How to set up SSH keys*, *SSH tunneling*** : tutoriels clairs et pratiques, orientés serveur réel.

**Mozilla OpenSSH Security Guidelines** : les bons réglages de durcissement, expliqués, pour la leçon 09.

Relis le palier 0, leçon 04 (clés SSH pour GitHub) : le mécanisme de clés est identique ; tu l'appliques à tes serveurs et tu le durcis.

---

## 🤖 Le mini-projet à demander à l'IA

Mettre en place un accès SSH propre et sûr à ton serveur :

> « Je suis en formation de développeur, palier 8 (DevOps). Je connais déjà les clés SSH depuis GitHub (palier 0). Je veux mettre en place un accès propre à mon VPS. Sans me donner des commandes à copier sans comprendre, guide-moi : générer une paire de clés dédiée (et m'expliquer pourquoi la privée ne quitte jamais ma machine), déposer la clé publique sur le serveur, et créer un alias dans ~/.ssh/config pour remplacer la longue commande ssh. Explique-moi chaque étape et ce qui pourrait mal tourner (Permission denied publickey, permissions de ~/.ssh). »

Puis le durcissement, prudemment :

> « Aide-moi à durcir l'accès SSH de mon serveur (désactiver le login root, n'accepter que les clés) SANS risquer de me verrouiller dehors. Insiste lourdement sur la méthode de sécurité : vérifier que la connexion par clé marche AVANT, garder une session de secours ouverte, et tester une nouvelle connexion dans un second terminal avant de fermer. Explique-moi aussi ce qu'est un tunnel SSH et comment il me laisserait accéder à ma base de données distante sans l'exposer à Internet. »

---

## 🛠️ À faire

> Sur le VPS du référent. **Garde toujours une session de secours ouverte** quand tu touches à la config SSH.

1. **⭐ Générer une clé dédiée** : crée une paire `ed25519` pour ton serveur (distincte de celle de GitHub). Identifie bien le fichier privé et le fichier `.pub`, et protège la privée par une phrase de passe.
2. **Déposer et connecter** : dépose ta clé publique sur le serveur (`ssh-copy-id` ou à la main dans `authorized_keys`), et connecte-toi **sans mot de passe**.
3. **Les permissions** : vérifie que `~/.ssh` est en `700` et ta clé privée en `600` (leçon 01). Ouvre-les trop (`chmod 777`), constate que SSH refuse la clé, puis corrige.
4. **⭐ L'alias** : crée une entrée dans `~/.ssh/config` pour remplacer la longue commande par `ssh monserveur`. Vérifie que `scp`/`rsync` l'utilisent aussi.
5. **Copier des fichiers** : copie un fichier avec `scp`, puis synchronise un dossier avec `rsync -avz`, via ton alias.
6. **⭐ Un tunnel** : ouvre un tunnel vers la base de données du serveur (`-L port_local:localhost:port_base`) et connecte-t'y avec un client local. Vérifie que la base n'est pas, elle, exposée à Internet.
7. **Durcir (avec filet)** : sur le serveur, et **en gardant une session ouverte**, désactive `PermitRootLogin` et `PasswordAuthentication`, redémarre SSH, puis teste une nouvelle connexion dans un **second** terminal avant de fermer le premier.
8. **Le scénario de l'erreur** : discute (ou simule prudemment) ce qui se passerait si tu désactivais le mot de passe sans que ta clé fonctionne — et comment la session de secours te sauve.
9. **Le lien** : note dans ton journal le parallèle avec les clés GitHub du palier 0 (même mécanisme privé/public), et ce que tu as ajouté ici (config, tunnels, durcissement).

<details>
<summary>Corrections et points de contrôle</summary>

**1-3.** Le mécanisme est celui du palier 0 : clé **privée** secrète sur ta machine, clé **publique** déposée sur le serveur (dans `authorized_keys`). Ce que la privée signe, la publique le vérifie — donc la publique peut circuler, la privée jamais. Le piège le plus fréquent de `Permission denied (publickey)` n'est pas la clé elle-même mais les **permissions** : SSH refuse d'utiliser une clé privée ou un dossier `~/.ssh` lisibles par d'autres (`~/.ssh` en 700, clé en 600). C'est une protection, pas un bug — et un rappel direct de la leçon 01.

**4.** `~/.ssh/config` est le petit fichier qui change le quotidien : il mappe un alias court vers HostName + User + Port + IdentityFile. `ssh monserveur` remplace une longue commande fragile, et `scp`/`rsync` héritent de l'alias. C'est aussi une documentation vivante de tes serveurs.

**6.** Le tunnel `-L 5433:localhost:5432` fait apparaître la base distante (port 5432, côté serveur) sur `localhost:5433` de ta machine, à travers la connexion SSH chiffrée. Tu peux y brancher un client graphique **sans** que la base soit ouverte à Internet. C'est la façon mûre de concilier « je dois accéder à la base » et « la base ne doit jamais être exposée » (leçon 09).

**7-8.** Le durcissement est puissant et dangereux. `PermitRootLogin no` + `PasswordAuthentication no` rendent les attaques par force brute (qui visent root et les mots de passe) inopérantes : seules les clés passent. Mais si tu actives ça alors que ta clé ne marche pas, tu te verrouilles dehors — et un serveur n'a pas de clavier de secours. La règle vitale : **connexion par clé validée AVANT**, **session de secours gardée ouverte PENDANT**, **nouvelle connexion testée dans un second terminal AVANT de fermer**. C'est la différence entre un durcissement maîtrisé et un appel au support de l'hébergeur.
</details>

---

## ✅ Acquis si…

- [ ] Je génère une paire de clés et je sais que la privée ne quitte jamais ma machine.
- [ ] Je me connecte à un serveur par clé, sans mot de passe.
- [ ] Je corrige un `Permission denied (publickey)`, y compris les permissions de `~/.ssh`.
- [ ] J'utilise `~/.ssh/config` pour des alias lisibles, repris par `scp`/`rsync`.
- [ ] J'ouvre un tunnel SSH pour accéder à un service distant non exposé (une base).
- [ ] Je durcis l'accès SSH (pas de `root`, clés seulement) sans me verrouiller dehors.
- [ ] Je garde toujours une session de secours ouverte quand je modifie la config SSH.
- [ ] Je fais le lien avec les clés SSH de GitHub (palier 0).

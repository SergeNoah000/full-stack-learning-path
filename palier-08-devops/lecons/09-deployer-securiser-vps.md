# Leçon 09 — Déployer et sécuriser un VPS : non-root, ufw, fail2ban, HTTPS

> 🎯 **À la fin de cette leçon** : tu mets ton application en ligne sur ton propre serveur, en HTTPS, avec un pare-feu et les durcissements de base — et tu as une **check-list de sécurité** que tu appliques à chaque nouveau serveur.
> ⏱️ 6 h · **Prérequis** : toutes les leçons 01-08 de ce palier.

> ⚠️ **Le garde-fou atteint son sommet ici.** Tu vas poser un pare-feu et durcir l'accès : une erreur peut te **verrouiller dehors** de ton propre serveur. Garde toujours une session ouverte, autorise SSH **avant** d'activer le pare-feu, et teste chaque changement avant de fermer.

---

## De quoi on parle

Cette leçon est la mise en ligne réelle : ton application, sur **ton** serveur (le VPS fourni par le référent), accessible depuis Internet, en HTTPS, et **protégée**. C'est l'aboutissement du palier — tout ce que tu as appris (Linux, services, SSH, réseau, proxy, conteneurs, CI/CD) converge en un déploiement sécurisé.

Le cadre est **entièrement défensif** : il s'agit de protéger **ton propre serveur**, de reconnaître ce qui le rend vulnérable, et d'appliquer les durcissements standards. Pas de techniques d'attaque — on sécurise, on ne cible pas.

Les piliers de la sécurisation :

- **non-root** : on ne travaille ni ne fait tourner l'application en administrateur (moindre privilège, leçon 01) ;
- **le pare-feu** (`ufw`) : on **ferme tout** sauf les quelques ports nécessaires (SSH filtré, 80, 443) ;
- **fail2ban** : on bannit automatiquement les adresses qui multiplient les tentatives d'accès échouées ;
- **HTTPS** : on chiffre tout le trafic avec un certificat gratuit (Let's Encrypt), **renouvelé automatiquement** ;
- plus les **mises à jour** de sécurité et la réduction de la **surface d'attaque**.

L'idée directrice : un serveur exposé à Internet est **constamment** sondé par des robots automatiques. La sécurité de base n'est pas de la paranoïa — c'est l'hygiène minimale sans laquelle un serveur est compromis en quelques heures.

---

## À quoi ça sert, concrètement

**Parce qu'un serveur exposé est attaqué en permanence, dès la première minute.** Ce ne sont pas des attaques ciblées contre toi : des robots balaient Internet en continu, testant les ports ouverts et les accès par défaut. Un serveur sans durcissement est une cible facile. Les mesures de cette leçon ne te rendent pas invulnérable, mais elles te font sortir de la catégorie « cible facile » — ce qui écarte l'immense majorité des attaques automatiques.

**Parce que la surface d'attaque est ce qu'on réduit d'abord.** Chaque port ouvert, chaque service exposé, chaque accès par mot de passe est une porte. Le pare-feu ferme les portes inutiles, le durcissement SSH (leçon 03) verrouille l'accès, le moindre privilège (leçon 01) borne les dégâts d'une éventuelle entrée. Réduire la surface est le réflexe de sécurité numéro un.

**Parce que le HTTPS n'est plus négociable.** Sans lui, les données (mots de passe, formulaires) circulent en clair, les navigateurs affichent « non sécurisé », le référencement chute. Let's Encrypt rend le certificat **gratuit et automatique** — il n'y a plus aucune excuse pour servir du HTTP. Et le renouvellement automatique évite la panne d'expiration (leçon 04).

**Et parce qu'une check-list reproductible vaut mieux qu'un bricolage.** Chaque nouveau serveur doit recevoir les mêmes durcissements, dans le même ordre. Avoir une check-list (et à terme, l'automatiser) garantit qu'on n'oublie rien — l'oubli étant la principale cause de serveurs vulnérables.

---

## Où ça intervient dans le développement

Cette leçon assemble tout le palier en un serveur de production sécurisé :

```
   Internet (robots inclus)
        ▼  PARE-FEU ufw : seuls 22 (filtré) / 80 / 443 passent  ← tout le reste fermé
        ▼  fail2ban bannit les IP qui s'acharnent sur SSH
   SERVEUR
     ├── accès : SSH par clé, pas de root, pas de mot de passe (leçon 03)
     ├── NGINX (leçon 05) : HTTPS (certificat Let's Encrypt, auto-renouvelé)
     │        ▼ proxy_pass
     ├── ton APP : service systemd (leçon 02) ou Compose (leçon 07), utilisateur dédié (leçon 01)
     └── base : NON exposée (réseau privé / tunnel SSH)
   + mises à jour de sécurité automatiques, surface d'attaque minimale
```

Tout converge.

**C'est l'application de chaque leçon précédente.** Moindre privilège et utilisateur dédié (leçon 01), service systemd (leçon 02), SSH par clé durci (leçon 03), ports fermés et HTTPS/certificat (leçon 04), Nginx (leçon 05), conteneurs et Compose (leçons 06-07), déploiement automatisé (leçon 08). Cette leçon ne crée presque rien de neuf : elle **assemble** et **sécurise**.

**Le HTTPS se pose sur Nginx (leçons 04-05).** Le certificat Let's Encrypt, obtenu avec `certbot`, se branche sur le reverse proxy. Ce que tu comprenais en théorie (TLS, certificat, expiration — leçon 04) devient opérationnel et automatique.

**Le pare-feu applique la discipline des ports (leçon 04).** « N'exposer que 80, 443 et un 22 filtré » devient une configuration `ufw` concrète. La base reste fermée (accès par tunnel SSH, leçon 03).

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas, sur ton VPS : créer un utilisateur non-root, durcir SSH (leçon 03), poser un pare-feu `ufw` (en autorisant SSH **avant** de l'activer !), installer fail2ban, déployer ton application (via Compose ou systemd), obtenir un certificat HTTPS avec renouvellement automatique, activer les mises à jour de sécurité, et dérouler une check-list finale. Chaque étape, en comprenant ce qu'elle protège.

### En équipe, en entreprise

**Le durcissement est souvent automatisé.** En entreprise, on ne configure pas les serveurs à la main un par un : on utilise des outils d'« infrastructure comme code » (Ansible, Terraform) qui appliquent la check-list de façon reproductible. Mais comprendre **ce que** ces outils font, en l'ayant fait à la main une fois, est indispensable pour les écrire et les déboguer.

**La sécurité est un processus, pas un état.** Durcir une fois ne suffit pas : il faut maintenir les mises à jour, surveiller (leçon 10), renouveler les certificats (automatiquement), réagir aux alertes. La sécurité se maintient dans le temps.

**Le moindre privilège est partout.** Un utilisateur par rôle, des droits minimaux, des accès révocables individuellement (chacun sa clé SSH, leçon 03). C'est une culture, pas une case à cocher.

**Les secrets de production sont gérés avec soin.** Variables d'environnement hors du code (paliers 4-7), coffres à secrets (*vaults*), jamais de mot de passe dans un dépôt. Une fuite de secret de production est un incident majeur.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours (en exploitation) : vérifier l'état du pare-feu et des services, consulter les logs d'accès (leçon 10), appliquer les mises à jour.

Régulièrement : déployer une nouvelle version, renouveler/vérifier un certificat (même s'il est automatique, on surveille), ajuster une règle de pare-feu, lire les bannissements fail2ban.

Rare ou avancé (mais à connaître) : l'automatisation complète (Ansible), les coffres à secrets, les audits de sécurité, la détection d'intrusion avancée, le durcissement du noyau. Tu les aborderas en contexte ; la check-list de base est le socle.

---

## La mécanique — la check-list de durcissement

> Ordre **important** : on prépare l'accès sûr **avant** de fermer les portes, pour ne pas se verrouiller dehors.

### 1. Un utilisateur non-root

```bash
# (connecté en root au tout début) créer un utilisateur de travail avec sudo
adduser deploy
usermod -aG sudo deploy
# déposer sa clé SSH (leçon 03), tester la connexion en tant que "deploy" AVANT la suite
```

On ne travaille jamais en `root` au quotidien (leçon 01). On crée un utilisateur qui peut élever ses droits ponctuellement avec `sudo`. **On vérifie qu'on peut se connecter avec lui par clé avant d'aller plus loin** — c'est la base du filet de sécurité.

### 2. Durcir SSH (leçon 03)

```
# /etc/ssh/sshd_config
PermitRootLogin no              # plus de connexion directe en root
PasswordAuthentication no       # clés seulement (les robots forcent les mots de passe)
```

C'est le durcissement de la leçon 03. **Prérequis vérifié : ta connexion par clé fonctionne, une session de secours est ouverte.** Les attaques automatiques visent massivement le login root par mot de passe — les fermer rend l'essentiel de ces attaques inopérant.

### 3. ⭐ Le pare-feu ufw — dans le bon ordre

```bash
sudo ufw default deny incoming        # par défaut : TOUT entrant est refusé
sudo ufw default allow outgoing       # les sorties restent permises
sudo ufw allow OpenSSH                # ⭐ AUTORISER SSH AVANT d'activer (sinon : verrouillé !)
sudo ufw allow 80/tcp                 # HTTP
sudo ufw allow 443/tcp                # HTTPS
sudo ufw enable                       # activer le pare-feu
sudo ufw status                       # vérifier
```

Le principe : **refuser tout par défaut**, puis **autoriser explicitement** le strict nécessaire (SSH, 80, 443). C'est la discipline des ports (leçon 04) appliquée.

> ⚠️ **L'ordre est vital.** Si tu fais `ufw enable` **sans** avoir `ufw allow OpenSSH` d'abord, le pare-feu coupe ta propre connexion SSH et tu es **dehors**. Toujours autoriser SSH, **puis** activer. Et garde une session ouverte pendant l'opération.

### 4. fail2ban — bannir les acharnements

```bash
sudo apt install fail2ban
# fail2ban surveille les logs (ex. SSH) et BANNIT temporairement une IP
# qui enchaîne les échecs d'authentification (une attaque par force brute).
sudo fail2ban-client status sshd      # voir les IP bannies
```

fail2ban lit les journaux (leçon 02) et, quand une adresse multiplie les tentatives échouées (comportement de robot), la bloque automatiquement au niveau du pare-feu pour un temps. C'est une défense **réactive** qui complète le durcissement **préventif** : même si l'accès est déjà limité aux clés, fail2ban réduit le bruit et stoppe les acharnements. Mesure défensive sur **ton** serveur, pas une offensive.

### 5. ⭐ Déployer l'application

```
Deux voies, selon ce que tu as construit :
  - Compose (leçon 07) : git pull + docker compose up -d   (ou image tirée du registre, leçon 08)
  - systemd (leçon 02) : le code déployé + systemctl restart monapp
Dans les deux cas : l'app tourne sous un UTILISATEUR DÉDIÉ (leçon 01),
sur un port INTERNE, derrière Nginx (leçon 05). La base n'est PAS exposée.
```

Le déploiement réutilise tout le palier. L'application tourne de façon permanente (service ou conteneur), sous un utilisateur limité, jamais exposée directement — Nginx est devant. Idéalement, c'est la CI/CD (leçon 08) qui déclenche ce déploiement.

### 6. ⭐ HTTPS avec Let's Encrypt (certificat gratuit, auto-renouvelé)

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d monsite.fr -d www.monsite.fr
# certbot obtient le certificat, configure Nginx pour le HTTPS,
# et met en place le RENOUVELLEMENT AUTOMATIQUE (un timer qui renouvelle avant expiration).
sudo certbot renew --dry-run          # tester que le renouvellement fonctionne
```

`certbot` obtient un certificat gratuit auprès de Let's Encrypt, configure Nginx (leçon 05) pour servir en HTTPS, ajoute la redirection HTTP→HTTPS, et installe un **renouvellement automatique** (le certificat dure 90 jours, leçon 04 ; le timer le renouvelle avant). Le `--dry-run` vérifie que ce renouvellement marchera — important, car un renouvellement raté = site inaccessible dans 90 jours.

### 7. Mises à jour et surface d'attaque

```bash
sudo apt update && sudo apt upgrade        # appliquer les mises à jour de sécurité
sudo apt install unattended-upgrades       # ...ou les automatiser pour la sécurité
# désinstaller/désactiver les services inutiles : chaque service en moins = une porte en moins
```

Un logiciel non à jour contient des failles **connues et documentées** — les cibles les plus faciles. Les mises à jour de sécurité les corrigent ; les automatiser (`unattended-upgrades`) évite l'oubli. Et chaque service inutile désactivé réduit la surface d'attaque.

### La check-list reproductible

```
☐ utilisateur non-root avec sudo, accès par clé vérifié
☐ SSH durci : pas de root, pas de mot de passe (session de secours ouverte)
☐ pare-feu : deny par défaut, SSH+80+443 autorisés, activé (SSH autorisé AVANT)
☐ fail2ban installé et actif
☐ app déployée sous utilisateur dédié, port interne, derrière Nginx
☐ base NON exposée (réseau privé / tunnel SSH)
☐ HTTPS actif, redirection HTTP→HTTPS, renouvellement auto testé
☐ mises à jour de sécurité appliquées (idéalement automatiques)
☐ services inutiles désactivés
☐ (leçon 10) logs, surveillance et SAUVEGARDES testées
```

Cette check-list est le vrai livrable de la leçon : une procédure que tu appliques à **chaque** serveur, dans l'ordre, sans rien oublier. C'est ce que les outils d'automatisation (Ansible) encoderont plus tard.

---

## Les problèmes que tu vas rencontrer

**« J'ai activé le pare-feu et je suis verrouillé dehors. »** Le scénario redouté : `ufw enable` sans `ufw allow OpenSSH` au préalable. Si tu as gardé une session ouverte, `ufw allow OpenSSH`. Sinon, passe par la console de secours de l'hébergeur. **Toujours autoriser SSH avant d'activer.**

**« Le certificat n'a pas été obtenu. »** Le domaine ne pointe pas (encore) sur le serveur (vérifie avec `dig`, leçon 04 — la propagation DNS doit être finie), ou le port 80 n'est pas ouvert/joignable (Let's Encrypt doit valider via HTTP). Corrige le DNS et le pare-feu, puis relance `certbot`.

**« Mon site est en HTTPS mais affichera une alerte dans 90 jours. »** Le renouvellement automatique n'est pas en place ou échoue. Lance `certbot renew --dry-run` pour le vérifier **maintenant**, pas dans trois mois.

**« fail2ban m'a banni moi-même. »** À force de tester, ta propre IP a déclenché un bannissement. Débannis-la (`fail2ban-client unban`), et pense à mettre ton IP en liste blanche si tu testes beaucoup.

**« L'app est accessible mais la base aussi, depuis Internet. »** Tu as exposé le port de la base (leçon 04/07). Ferme-le (pare-feu, ou retire le `ports:` de Compose) ; accède à la base par tunnel SSH (leçon 03).

**« Un robot a rempli mes logs de tentatives SSH. »** Normal et constant sur tout serveur exposé. C'est précisément pourquoi on durcit (clés seulement) et on installe fail2ban. Avec le mot de passe désactivé, ces tentatives n'aboutissent pas — mais fail2ban réduit le bruit.

---

## Ce qu'on te demandera

En **test DevOps**, la sécurisation d'un serveur est un sujet majeur : « comment sécurises-tu un serveur fraîchement provisionné ? » (la check-list : non-root, SSH par clé, pare-feu, fail2ban, mises à jour, HTTPS), « comment mets-tu un site en HTTPS ? » (Let's Encrypt/certbot, renouvellement auto), « quels ports exposes-tu et pourquoi ? ». On apprécie une démarche **ordonnée** et la conscience du risque de se verrouiller dehors.

On peut demander : « pourquoi ne pas tourner en root ? » (moindre privilège), « pourquoi désactiver l'authentification par mot de passe ? », « que fait fail2ban ? », « pourquoi la base ne doit-elle pas être exposée ? ».

En **mission**, on te confiera le déploiement et le durcissement de serveurs, souvent via des outils d'automatisation que ta compréhension manuelle te permettra d'écrire et de corriger.

---

## Ce qui te démarquera

**Une check-list que tu déroules, pas un bricolage.** Arriver avec une procédure ordonnée et reproductible — et savoir pourquoi chaque étape protège — montre que tu traites la sécurité comme un processus professionnel, pas comme des rustines.

**La conscience du « verrouillé dehors ».** Autoriser SSH avant le pare-feu, garder une session de secours, tester avant de fermer : cette prudence révèle quelqu'un qui a déjà réfléchi aux conséquences de ses actes sur un serveur sans clavier. C'est exactement le sang-froid qu'on veut en production.

**Le HTTPS automatique et surveillé.** Savoir que Let's Encrypt est gratuit, que le renouvellement s'automatise, et qu'on le **teste** (`--dry-run`) plutôt que de découvrir l'expiration en panne, te distingue nettement.

**Et la vision d'assemblage.** Comprendre que ce déploiement sécurisé n'invente rien mais **assemble** tout le palier (leçons 01-08) autour d'une discipline de sécurité, c'est la maturité d'un développeur qui sait mettre en ligne pour de vrai — ce que la plupart des juniors n'ont jamais fait de bout en bout.

---

## 📚 À lire

**Digital Ocean → *Initial Server Setup* et *How To Set Up a Firewall with UFW*** : les tutoriels de référence pour le durcissement initial, étape par étape, exactement dans l'esprit de la check-list.

**Let's Encrypt** et **Certbot (certbot.eff.org)** : la documentation officielle du HTTPS gratuit et de son renouvellement automatique.

**Documentation `ufw` et `fail2ban`** (et leurs `man`) : les références des deux outils de cette leçon.

**Mozilla Web Security Guidelines / OWASP → *bonnes pratiques serveur*** : pour approfondir le durcissement, en cadre défensif.

Relis tout le palier : cette leçon est l'application de chacune. Et le palier 7 (statelessness, surface) pour la vision d'ensemble.

---

## 🤖 Le mini-projet à demander à l'IA

Dérouler la check-list de durcissement en comprenant chaque étape :

> « Je suis en formation de développeur, palier 8 (DevOps). Je veux déployer et SÉCURISER mon application sur mon propre VPS — c'est défensif, je protège mon serveur. Sans me donner un script tout fait à exécuter à l'aveugle, guide-moi dans l'ordre et explique-moi ce que chaque étape protège : créer un utilisateur non-root, durcir SSH (clés seulement), poser un pare-feu ufw. INSISTE sur l'ordre vital : autoriser SSH AVANT d'activer le pare-feu, garder une session de secours ouverte, tester avant de fermer — je ne veux pas me verrouiller dehors. »

Puis HTTPS et la check-list :

> « Aide-moi à finir la sécurisation : installer fail2ban (et m'expliquer ce qu'il protège), obtenir un certificat HTTPS gratuit avec Let's Encrypt/certbot sur mon Nginx, et surtout vérifier MAINTENANT que le renouvellement automatique fonctionne (dry-run) pour ne pas découvrir une expiration en panne dans 90 jours. Enfin, aide-moi à rédiger une check-list de sécurité reproductible que j'appliquerai à chaque nouveau serveur, et explique-moi pourquoi ma base de données ne doit jamais être exposée à Internet. »

---

## 🛠️ À faire

> Sur le VPS du référent. **Garde toujours une session de secours ouverte.** Autorise SSH **avant** le pare-feu. Comprends chaque commande.

1. **Utilisateur non-root** : crée un utilisateur `deploy` avec `sudo`, dépose ta clé SSH (leçon 03), et **vérifie que tu te connectes avec lui par clé** avant toute autre étape.
2. **Durcir SSH** : désactive le login root et le mot de passe (leçon 03), en gardant une session ouverte et en testant une nouvelle connexion dans un second terminal.
3. **⭐ Le pare-feu, dans l'ordre** : configure `ufw` (deny par défaut), **autorise d'abord OpenSSH**, 80 et 443, **puis** active-le. Vérifie avec `ufw status`. Ressens pourquoi l'ordre est vital.
4. **fail2ban** : installe-le, vérifie qu'il surveille SSH, et consulte les éventuelles IP bannies. Explique par écrit ce qu'il protège.
5. **⭐ Déployer l'app** : mets ton application en ligne (via Compose, leçon 07, ou systemd, leçon 02), sous un utilisateur dédié, sur un port interne, derrière Nginx (leçon 05). Vérifie que la base n'est **pas** exposée.
6. **⭐ HTTPS** : avec `certbot`, obtiens un certificat Let's Encrypt pour ton domaine, configure la redirection HTTP→HTTPS, et **teste le renouvellement automatique** (`certbot renew --dry-run`).
7. **Vérifier le HTTPS** : avec `curl -vI` (leçon 04), confirme le HTTPS, la redirection, et inspecte la date d'expiration du certificat.
8. **Mises à jour** : applique les mises à jour de sécurité, et mets en place leur automatisation. Désactive un service inutile et explique pourquoi (surface d'attaque).
9. **⭐ La check-list** : rédige ta check-list de sécurité reproductible (dans ton journal et/ou dans le dépôt), et déroule-la entièrement sur ton serveur pour vérifier qu'aucun point n'est oublié.
10. **Le lien** : dans ton journal, associe chaque point de la check-list à la leçon du palier qui l'a introduit (01 moindre privilège, 02 service, 03 SSH, 04 ports/TLS, 05 Nginx, 06-07 conteneurs, 08 CI/CD).

<details>
<summary>Corrections et points de contrôle</summary>

**1-2.** Le filet de sécurité avant tout. On crée l'utilisateur non-root et on **vérifie la connexion par clé avec lui** avant de durcir — car si on désactive le login root et le mot de passe sans que l'accès de `deploy` fonctionne, on se coupe de toute entrée. Le moindre privilège (leçon 01) : on travaille en utilisateur limité, on élève ponctuellement avec `sudo`. C'est préventif : si l'accès `deploy` est compromis, il n'a pas d'emblée les pleins pouvoirs.

**3.** L'erreur qui verrouille dehors, et la plus importante du palier. `ufw default deny incoming` refuse tout ; si tu actives le pare-feu **avant** d'autoriser SSH, tu coupes ta propre connexion — et un VPS n'a pas de clavier de secours. L'ordre est donc : `allow OpenSSH`, `allow 80`, `allow 443`, **puis** `enable`. Et toujours une session ouverte pendant l'opération, pour corriger si besoin. Le pare-feu applique la discipline des ports (leçon 04) : on ferme tout, on n'ouvre que le strict nécessaire.

**5.** Le déploiement n'invente rien : il assemble le palier. L'app tourne en permanence (Compose, leçon 07, ou systemd, leçon 02), sous un **utilisateur dédié** (leçon 01), sur un **port interne**, **derrière Nginx** (leçon 05) qui seul fait face au monde. La base reste sur le réseau privé ou fermée par le pare-feu (leçon 04), accessible par tunnel SSH (leçon 03) pour l'administration. Chaque choix est une mesure de sécurité déjà vue, remise dans son rôle.

**6-7.** HTTPS : `certbot` obtient un certificat Let's Encrypt **gratuit**, configure Nginx pour le TLS et la redirection HTTP→HTTPS, et installe un **renouvellement automatique** (le certificat dure 90 jours, leçon 04). Le point crucial souvent négligé : **tester le renouvellement maintenant** (`--dry-run`). Un renouvellement silencieusement cassé se révèle 90 jours plus tard par un site inaccessible et une alerte de sécurité — exactement la panne « qui tombe un jour rond » de la leçon 04. On la prévient en vérifiant tout de suite.

**9-10.** La check-list est le vrai livrable : une procédure **ordonnée et reproductible** qui garantit qu'aucun durcissement n'est oublié — l'oubli étant la première cause de serveurs vulnérables. Chaque point renvoie à une leçon du palier (moindre privilège 01, service 02, SSH 03, ports/TLS 04, proxy 05, conteneurs 06-07, automatisation 08), ce qui montre que ce déploiement sécurisé est la **synthèse** du palier. En entreprise, cette check-list manuelle devient un playbook Ansible — mais l'avoir faite à la main une fois est ce qui te permettra de l'automatiser et de la déboguer.
</details>

---

## ✅ Acquis si…

- [ ] Je crée un utilisateur non-root et je vérifie son accès par clé avant de durcir.
- [ ] Je durcis SSH (pas de root, pas de mot de passe) sans me verrouiller dehors.
- [ ] Je configure un pare-feu `ufw` en autorisant SSH **avant** de l'activer.
- [ ] J'installe fail2ban et je sais ce qu'il protège.
- [ ] Je déploie l'app sous un utilisateur dédié, sur un port interne, derrière Nginx, base non exposée.
- [ ] Je mets le site en HTTPS avec Let's Encrypt et je **teste** le renouvellement automatique.
- [ ] J'applique les mises à jour de sécurité et je réduis la surface d'attaque.
- [ ] J'ai une check-list de sécurité reproductible que je déroule sur chaque serveur.

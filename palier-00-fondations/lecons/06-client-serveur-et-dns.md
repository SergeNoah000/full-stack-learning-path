# Leçon 06 — Client, serveur, DNS

> 🎯 **À la fin de cette leçon** : tu racontes, sans notes, tout ce qui se passe entre le moment où tu tapes `google.com` et l'affichage de la page — et tu sais pourquoi cette histoire conditionne tout le reste du parcours.
> ⏱️ 1 h 30 · **Prérequis** : leçons 01–02 pour les commandes.

---

## De quoi on parle

Un **client** est un programme qui **demande** : ton navigateur, une application mobile, la commande `curl`. Un **serveur** est un programme qui **répond**.

Première confusion à dissiper : un serveur est un **logiciel**, pas une machine. On dit « un serveur » pour désigner l'ordinateur qui l'héberge, par raccourci, mais Nginx, Apache, Express et Django sont des serveurs, et ta propre machine fera tourner des serveurs dès le palier 1. Une même machine peut en héberger dix.

Pour se joindre, il faut une adresse. Une **adresse IP** identifie une machine sur le réseau (`142.250.75.238`). Comme personne ne retient ça, on utilise des **noms de domaine** (`google.com`), et le **DNS** est l'annuaire mondial qui traduit les uns en les autres. Un **port** est ensuite le numéro de porte sur la machine : 80 pour HTTP, 443 pour HTTPS, 22 pour SSH, et 3000, 5000 ou 8000 pour les serveurs de développement.

Deux termes reviendront constamment. **`localhost`** (ou `127.0.0.1`) désigne ta propre machine : `localhost:3000` signifie « le serveur qui tourne chez moi, sur le port 3000 ». Et un **hébergeur** est l'entreprise qui fait tourner ton serveur en permanence, parce que ta machine personnelle, elle, s'éteint.

---

## À quoi ça sert, concrètement

Cette leçon ne t'apprend pas à faire quelque chose : elle t'apprend à **comprendre où tu es**. C'est un investissement, et voici ce qu'il paie.

**Savoir de quel côté est le problème.** C'est l'usage le plus immédiat. Quand quelque chose ne marche pas, la première question est toujours : est-ce le client, le réseau, ou le serveur ? Sans ce modèle, tu modifies du code au hasard. Avec lui, tu sais où regarder — et c'est exactement ce que fait le diagnostic couche par couche du palier 8.

**Comprendre ce que tu paies.** Pourquoi GitHub Pages est gratuit et Render payant ? Pourquoi ton application « s'endort » sur une offre gratuite ? Pourquoi un nom de domaine coûte douze euros par an mais un certificat HTTPS rien du tout ? Toutes ces réponses sont dans cette leçon et dans la suivante, et tu les rencontreras dès le palier 2.

**Savoir où mettre quoi.** C'est le point d'architecture. Le code qui tourne chez l'utilisateur est **public et modifiable** ; celui qui tourne sur le serveur ne l'est pas. Cette seule distinction décide de l'emplacement de tes secrets, de tes règles métier et de tes validations — et c'est l'objet de la leçon 08.

---

## Où ça intervient dans le développement

Partout, parce que c'est le décor. Mais précisément :

```
   NAVIGATEUR (client)                       SERVEUR
   ───────────────────                       ───────
   HTML · CSS · JS           ← paliers 2, 3
   app Flutter               ← palier 9
          │
          │  DNS  →  TCP  →  TLS  →  HTTP        ← cette leçon et la leçon 07
          ▼
                                   Node · Python · PHP   ← paliers 4, 5, 6
                                   base de données       ← palier 4
                                   serveur web, HTTPS    ← palier 8
```

Deux conséquences structurelles, à retenir dès maintenant parce qu'elles reviendront dix fois.

**Le serveur ne peut rien envoyer spontanément.** Le dialogue est toujours à l'initiative du client : il demande, le serveur répond, et c'est fini. Si une page semble se mettre à jour toute seule, c'est que du JavaScript redemande régulièrement en arrière-plan. Les mécanismes qui permettent au serveur de pousser quelque chose (WebSockets, SSE) sont des ajouts par-dessus, pas le fonctionnement de base. Tu t'en souviendras au palier 3 quand tu voudras un affichage « temps réel ».

**Le client est toujours manipulable.** N'importe qui peut forger une requête avec `curl` sans jamais passer par ton joli formulaire, modifier ton JavaScript dans son navigateur, ou envoyer des données que ton interface interdit. D'où **la règle de sécurité numéro un du métier** : *toute donnée venant du client est suspecte, et la validation qui compte se fait côté serveur.* On y reviendra sérieusement au palier 4, mais retiens-la maintenant : elle explique la moitié des décisions d'architecture que tu prendras.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas lancer des serveurs sur ta propre machine et les visiter dans ton navigateur à l'adresse `localhost:quelque chose`. Ce sera ta boucle de travail pendant tout le parcours : un terminal qui fait tourner le serveur, un navigateur qui le consulte.

Tu rencontreras aussi très vite l'onglet **Réseau** des outils de développement du navigateur (`F12`). C'est la fenêtre sur ce dialogue : chaque requête, son URL, son code de retour, son poids, sa durée. Tu y passeras beaucoup de temps aux paliers 2 et 3, et c'est un réflexe à prendre maintenant.

### En équipe, en entreprise

Tu découvriras que le réseau est l'une des **principales sources de problèmes**, et que ces problèmes ont des noms que tu entendras souvent.

« Ça marche en local mais pas en production » : presque toujours une différence de configuration, d'adresse ou de certificat. « C'est un problème de DNS » : le nom de domaine ne pointe pas là où on croit, et comme le DNS est mis en cache, la correction met du temps à se propager. « C'est CORS » : le navigateur refuse un appel vers un autre domaine, et la correction est côté serveur, jamais côté client.

Tu verras aussi que les environnements sont **multiples** : local, préproduction, production, chacun avec sa propre adresse. Savoir lequel tu es en train d'interroger évite des heures de confusion.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien, tu utiliseras `curl` (vérifier ce qu'une URL renvoie vraiment), l'onglet Réseau du navigateur, et la connaissance de `localhost` et des ports.

Occasionnellement, `dig` pour vérifier où pointe un domaine — typiquement après avoir changé une configuration DNS — et `ping` pour savoir si une machine répond.

Ce qui est **rare** et qui ne te concerne pas : les détails de TCP, le routage, les sous-réseaux, les subtilités de TLS, `traceroute`. Un développeur d'application a besoin du modèle mental, pas de l'expertise réseau. Si tu te retrouves à lire la spécification de TCP au palier 0, tu es en train de te disperser.

---

## La mécanique : le trajet complet d'une URL

Tu tapes `https://www.google.com/search?q=chat`. Voilà ce qui se passe réellement, et c'est l'explication que tu devras savoir donner à l'oral.

**1. Le navigateur découpe l'URL.** Protocole `https`, domaine `www.google.com`, port implicite `443` (parce que HTTPS), chemin `/search`, et la *query string* `?q=chat` qui transporte les paramètres.

**2. Il résout le nom en adresse IP.** Il demande « quelle IP pour `www.google.com` ? », et il pose la question dans un ordre précis : son propre cache d'abord, puis celui du système, puis le fichier `/etc/hosts`, et enfin un **résolveur DNS** (celui de ton fournisseur d'accès, ou un public comme `1.1.1.1`). Si le résolveur ne sait pas, il interroge la hiérarchie : serveurs racine, puis serveurs de `.com`, puis serveurs de `google.com`. La réponse revient avec une durée de validité (**TTL**) pendant laquelle elle est mise en cache.

Ce cache explique une chose qui déroute tout le monde la première fois : quand tu changes la configuration DNS d'un domaine, le changement n'est **pas** immédiat pour tout le monde. Tu le vivras au palier 8.

**3. Il ouvre une connexion TCP** vers `IP:443`. Trois échanges pour établir le canal (SYN, SYN-ACK, ACK) — c'est la « poignée de main ».

**4. Il négocie TLS**, puisque c'est du HTTPS. Le serveur présente son **certificat** ; le navigateur vérifie qu'il a été signé par une autorité de confiance, qu'il correspond bien au nom demandé et qu'il n'est pas expiré. Une clé de session est établie, et à partir de là **tout est chiffré**. C'est exactement ce que signifie le cadenas dans la barre d'adresse : pas « ce site est honnête », mais « la communication est chiffrée et le serveur est bien celui qu'il prétend être ».

**5. Il envoie la requête HTTP** (leçon 07) : `GET /search?q=chat HTTP/1.1`, avec ses en-têtes.

**6. Le serveur traite.** Il lit la requête, exécute du code ou lit un fichier, interroge éventuellement une base de données, et construit une réponse.

**7. Il renvoie la réponse HTTP** : un code de statut (`200 OK`), des en-têtes, et un corps — ici du HTML.

**8. Le navigateur affiche.** Il analyse le HTML, découvre les ressources liées (CSS, JavaScript, images, polices) et **refait une requête pour chacune**. Une page ordinaire déclenche entre trente et cent requêtes. Puis il construit le DOM, applique le CSS, exécute le JavaScript, et peint le résultat.

Le point à retenir de ce déroulé : **les étapes 1 à 4 prennent souvent plus de temps que l'étape 6**. Tout le travail de performance web ne consiste donc pas seulement à écrire du code rapide, mais à réduire le nombre d'allers-retours et le poids de ce qu'on transfère. C'est contre-intuitif, et c'est fondamental.

### Vérifier par toi-même

```bash
dig google.com +short         # l'IP derrière le nom
dig google.com                # la réponse complète, avec le TTL
ping google.com               # la machine répond-elle, et en combien de temps ?
curl -I https://google.com    # juste les en-têtes de la réponse
cat /etc/hosts                # les correspondances locales, consultées AVANT le DNS
```

`/etc/hosts` est un outil de développeur, pas une curiosité : y ajouter `127.0.0.1 monsite.test` te permet de travailler en local sur un vrai nom de domaine. Tu t'en serviras au palier 6 avec les VirtualHosts d'Apache.

---

## Les problèmes que tu vas rencontrer

**« Le site ne répond pas »** et tu ne sais pas pourquoi. La méthode est toujours la même, de l'extérieur vers l'intérieur : le domaine résout-il (`dig`) ? la machine répond-elle (`ping`) ? le port est-il ouvert (`curl`) ? le serveur tourne-t-il ? l'application répond-elle en local sur la machine ? C'est le squelette du diagnostic du palier 8, et il commence par cette leçon.

**Ton changement DNS ne se voit pas.** Le cache. Attends le TTL, et vérifie avec `dig @1.1.1.1 ton-domaine.com` pour interroger un résolveur public plutôt que le tien.

**`ERR_CONNECTION_REFUSED` sur `localhost`.** Ton serveur n'est pas lancé, ou il écoute sur un autre port que celui que tu visites. Vérifie la sortie du terminal où tu l'as démarré : il affiche presque toujours l'adresse exacte.

**`Port already in use` (`EADDRINUSE`).** Un serveur tourne déjà sur ce port — souvent un que tu as oublié dans un autre onglet. `lsof -i :3000` te dit lequel.

**Le cadenas est barré ou le navigateur affiche un avertissement de sécurité.** Le certificat est expiré, ne correspond pas au nom du domaine, ou n'est pas signé par une autorité connue. Tu rencontreras les trois cas au palier 8, et c'est pour ça que le renouvellement automatique est obligatoire.

**Tu es perdu entre local et production.** Tu modifies du code et rien ne change… parce que tu regardes la version déployée. Garde l'adresse visible et nomme tes environnements.

---

## Ce qu'on te demandera

La question « **que se passe-t-il quand tu tapes une URL dans ton navigateur ?** » est l'une des plus posées en entretien, tous niveaux confondus. Elle est posée précisément parce qu'elle est inépuisable : on peut y répondre en trente secondes ou en vingt minutes, et la profondeur de la réponse situe immédiatement le candidat. C'est pour cette raison que l'épreuve de sortie de ce palier te demande de la raconter en trois minutes, sans notes.

On te demandera aussi, de façon plus pratique : « où regardes-tu quand un site ne répond pas ? », « quelle différence entre HTTP et HTTPS ? », « à quoi sert le DNS ? ».

Et en travail réel, on attendra de toi que tu saches **lire l'onglet Réseau** : identifier la requête qui échoue, voir son code de retour, repérer celle qui ralentit la page.

---

## Ce qui te démarquera

**Savoir dire de quel côté est le problème avant de toucher au code.** C'est le réflexe qui distingue le plus nettement un développeur méthodique d'un débutant qui bidouille. « Attends, je vérifie d'abord si la requête part » est une phrase de professionnel.

**Connaître l'existence du cache à chaque étage.** Cache DNS, cache navigateur, cache du serveur, cache de la base. La plupart des « bizarreries » inexpliquées en développement web sont un cache. Y penser en premier fait gagner des heures.

**Savoir utiliser `curl` pour isoler.** Si `curl` obtient la bonne réponse mais que ton interface n'affiche rien, le problème est dans le client — tu viens d'éliminer la moitié du système en dix secondes.

**Comprendre ce que coûte un aller-retour.** Dire « on fait trois appels d'API en série alors qu'ils sont indépendants, on pourrait les paralléliser » est une remarque de performance que tu pourras faire dès le palier 1 (leçon 09) et qui impressionne toujours.

---

## 📚 À lire

Commence par **MDN → *How the web works***, puis ***What is a URL?*** et ***What is a web server?***. Une demi-heure au total, et c'est la base propre.

Les vidéos de **code.org → *How the Internet Works*** (cinq épisodes de huit minutes) sont excellentes pour les notions de paquets, de TCP/IP et de DNS, et elles sont volontairement grand public : c'est ce qu'il faut à ce stade.

Pour le DNS en particulier, **howdns.works** est une bande dessinée de quinze minutes, et c'est la ressource que tu retiendras le mieux.

Enfin, MDN a une page courte sur HTTPS et le rôle du certificat : lis-la, tu en auras besoin au palier 8.

---

## 🤖 Le mini-projet à demander à l'IA

Cette leçon est conceptuelle, donc l'IA sert surtout à te faire **interroger** :

> « Je suis en formation de développeur, palier 0. Interroge-moi sur le trajet complet d'une requête web. Pose-moi **une question à la fois**, de plus en plus précise, en partant de "que se passe-t-il quand je tape une URL". Quand ma réponse est incomplète, ne me donne pas la réponse : demande-moi "et avant cette étape, que s'est-il passé ?" ou "qu'est-ce qui pourrait échouer ici ?". Continue jusqu'à ce que j'arrive à mentionner le cache DNS, le certificat TLS et le fait que le HTML déclenche de nouvelles requêtes. »

Et un petit exercice d'observation, plus concret :

> « Donne-moi une liste de 8 observations à faire dans l'onglet Réseau des DevTools sur un vrai site d'actualités (nombre de requêtes, la plus lourde, la plus lente, les domaines tiers, ce qui vient du cache, l'ordre de chargement). Formule-les comme des questions auxquelles je dois répondre moi-même en regardant. Ensuite, demande-moi ce que j'en déduis sur la performance de ce site. »

---

## 🛠️ À faire

1. Trouve l'adresse IP de trois sites avec `dig`. Note celui qui en a plusieurs et demande-toi pourquoi.
2. Ouvre les **DevTools → Réseau** sur un vrai site, recharge, et réponds : combien de requêtes ? la plus lente ? la plus lourde ? combien de domaines différents sont contactés ?
3. **L'exercice de synthèse du palier** : dessine à la main le schéma complet « je tape une URL → la page s'affiche », avec les huit étapes. Puis **explique-le à voix haute en te chronométrant** — la cible est trois minutes, sans notes. Photo du schéma dans ton journal.
4. Ajoute `127.0.0.1 monsite.test` dans `/etc/hosts`, fais un `ping monsite.test`, puis retire la ligne. Tu viens de faire ce que tu refaras au palier 6.
5. Compare `curl -I http://neverssl.com` et `curl -I https://google.com` : repère la redirection et les en-têtes de sécurité.
6. Lance un serveur local sur le port 8000 (`python3 -m http.server 8000`), visite-le, puis essaie d'en lancer un second sur le même port. Lis l'erreur.
7. Coupe ton réseau (ou mets le navigateur en mode hors ligne dans les DevTools) et recharge une page déjà visitée. Qu'est-ce qui s'affiche encore, et pourquoi ?

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Les gros sites renvoient plusieurs adresses, ou une adresse « anycast » qui correspond en réalité à des dizaines de machines réparties dans le monde. Objectifs : répartir la charge et servir depuis le point géographique le plus proche. C'est le principe du **load balancing** et des **CDN**, que tu reverras au palier 7.

**2.** Tu devrais constater que le document HTML est souvent léger, et que le poids vient des **images** et des **scripts tiers** (statistiques, publicité, polices). Et que le nombre de domaines contactés est étonnamment élevé : chacun implique une résolution DNS et une négociation TLS de plus. Première intuition de performance web.

**3 — grille d'auto-évaluation.** As-tu mentionné : le découpage de l'URL, le **cache** DNS avant la requête DNS, la connexion TCP, le **certificat** TLS et ce que le navigateur vérifie, la méthode HTTP, le traitement serveur, le code de statut, et le fait que le HTML déclenche **de nouvelles requêtes** ? Si l'un manque, relis l'étape correspondante — ce sont précisément les points qu'un recruteur écoute.

**6.** La seconde tentative échoue avec `Address already in use`. Un port ne peut être occupé que par un seul programme : c'est la définition d'un port.

**7.** Une partie de la page s'affiche encore : elle vient du **cache du navigateur**. Les requêtes vers le réseau échouent, mais les ressources déjà téléchargées et encore valides (selon leurs en-têtes `Cache-Control`) sont réutilisées. C'est ce mécanisme que tu exploiteras volontairement au palier 9 pour le mode hors-ligne.
</details>

---

## ✅ Acquis si…

- [ ] J'explique le trajet complet d'une URL en trois minutes, **sans notes**.
- [ ] Je définis client, serveur, IP, domaine, DNS, port et `localhost` avec mes propres mots.
- [ ] Je sais qu'un serveur est un **programme**, pas une machine.
- [ ] Je trouve l'IP d'un domaine en ligne de commande et je sais pourquoi il peut y en avoir plusieurs.
- [ ] Je lis l'onglet Réseau des DevTools et j'y repère la requête lente ou en échec.
- [ ] J'explique pourquoi valider côté client ne protège de rien.
- [ ] Devant une panne, je sais énumérer les couches à vérifier, de l'extérieur vers l'intérieur.
- [ ] Je sais que le cache intervient à plusieurs étages, et j'y pense avant de chercher un bug ailleurs.

# Leçon 08 — Frontend, backend, base de données, API

> 🎯 **À la fin de cette leçon** : tu situes chaque technologie du parcours sur une carte, tu sais ce qui doit vivre de quel côté, et tu comprends ce que « fullstack » veut dire concrètement.
> ⏱️ 1 h 30 · **Prérequis** : leçons 06–07. **Dernière leçon du palier 0.**

---

## De quoi on parle

Le **frontend** est tout ce qui s'exécute **chez l'utilisateur** : le HTML, le CSS et le JavaScript interprétés par son navigateur, ou le code d'une application installée sur son téléphone. C'est la partie qu'il voit et qu'il touche.

Le **backend** est tout ce qui s'exécute **sur le serveur** : les règles métier, les contrôles d'accès, la validation des données, l'accès au stockage. C'est la partie qu'il ne voit jamais.

La **base de données** est le logiciel qui conserve durablement les données et sait les retrouver vite. Elle est distincte du backend — c'est un programme séparé, souvent sur une autre machine.

Une **API** est une porte d'entrée programmatique : des URL qui renvoient des **données** (généralement en **JSON**) au lieu d'une page à regarder. Ton backend en expose une, et ton frontend la consomme.

Et **fullstack** signifie simplement : savoir travailler des deux côtés. C'est la cible de ce parcours, et c'est aussi le profil le plus recherché dans les petites structures, où personne n'a les moyens d'embaucher un spécialiste par couche.

---

## À quoi ça sert, concrètement

Cette leçon ne t'apprend aucune technique : elle te donne la **carte**. Et une carte sert à trois choses.

**À savoir où tu travailles.** Le parcours va t'emmener dans six technologies différentes. Si tu ne sais pas sur quelle couche tu es, tout se mélange : tu cherches une erreur de serveur dans la console du navigateur, tu essaies de lire un fichier local depuis du JavaScript de page, tu mets une clé secrète dans du code public. Savoir « je suis côté client, donc je n'ai pas accès à ça » élimine des familles entières de confusion.

**À savoir où mettre quoi.** C'est la décision que tu prendras le plus souvent de toute ta carrière. Ce calcul, côté client ou côté serveur ? Cette validation, les deux ? Cette donnée, dans la page, dans le navigateur ou en base ? Les réponses ne sont pas affaire de goût : elles découlent de qui contrôle quoi.

**À comprendre le vocabulaire des offres d'emploi.** « Développeur frontend », « backend », « fullstack », « on cherche quelqu'un à l'aise sur la couche données » : après cette leçon, ces intitulés te disent précisément ce qu'on attend.

---

## Où ça intervient dans le développement

Voici la carte complète du parcours. C'est la figure à retenir, et celle vers laquelle revenir chaque fois que tu te sentiras perdu.

```
   ┌──────────────────────────────────────┐
   │   FRONTEND — chez l'utilisateur      │   ce qu'il voit et touche
   │   HTML · CSS · JavaScript            │   → paliers 2 et 3
   │   Flutter (mobile)                   │   → palier 9
   └──────────────────┬───────────────────┘
                      │  HTTP — requêtes et réponses, souvent du JSON
                      │  (paliers 0 et 1 : tu apprends à le lire et à l'émettre)
   ┌──────────────────▼───────────────────┐
   │   BACKEND — sur le serveur           │   règles métier, authentification,
   │   Node · Python · PHP                │   validation, autorisations
   │                                      │   → paliers 4, 5 et 6
   └──────────────────┬───────────────────┘
                      │  SQL
   ┌──────────────────▼───────────────────┐
   │   BASE DE DONNÉES                    │   la mémoire durable
   │   PostgreSQL · MySQL · SQLite        │   → palier 4, puis partout
   └──────────────────────────────────────┘

   Autour de tout ça : l'architecture (palier 7) et l'exploitation (palier 8).
```

Quelques remarques sur cette carte, parce qu'elle est plus riche qu'elle n'en a l'air.

**Les trois couches sont trois programmes distincts**, souvent sur des machines différentes, qui communiquent par le réseau. Ce n'est pas une organisation de fichiers : c'est une séparation réelle, et chaque flèche est un aller-retour qui coûte du temps (leçon 07).

**Le même backend sert plusieurs frontends.** C'est l'un des intérêts du découpage, et tu le vivras concrètement : au palier 9, ton application Flutter parlera au backend que tu auras écrit au palier 4, 5 ou 6 — sans une ligne à changer côté serveur. Une API bien conçue est indifférente à qui la consomme.

**Les concepts du backend sont les mêmes dans les trois langages.** C'est toute la logique du parcours : tu apprends REST, SQL, l'authentification et la sécurité **une fois** au palier 4, et les paliers 5 et 6 ne t'apprennent que leur expression en Python et en PHP. C'est pour ça que l'ordre n'est pas négociable.

---

## La règle de répartition : qui fait quoi

C'est le cœur de la leçon. La question n'est pas « où est-ce que je peux le faire ? » mais « **qui contrôle cet endroit ?** ».

**La mise en forme, les interactions, le confort** vont côté frontend. C'est là que vit l'utilisateur, et c'est là qu'il faut que ce soit réactif.

**La validation de confort** va côté frontend : signaler un champ vide avant même d'envoyer, afficher une erreur sans recharger la page. C'est du service rendu à l'utilisateur.

**La validation de sécurité** va côté backend, **obligatoirement**. Pas « aussi » : obligatoirement, et c'est la seule qui compte. Parce que `curl` contourne ton formulaire, parce que les DevTools permettent de modifier ton JavaScript, parce que l'application mobile peut être décompilée. La validation du client est une politesse ; celle du serveur est une barrière.

**Les règles métier** vont côté backend. Le calcul d'un prix, le droit de voir une ressource, la limite d'un budget : tout ce qui, s'il était contourné, causerait un préjudice. Un prix calculé côté client est un prix que le client choisit.

**Les secrets** vivent côté backend **uniquement**. Clés d'API, mots de passe de base de données, jetons de service. Et il faut bien comprendre pourquoi, parce que l'erreur est très fréquente : **tout ce qui part au navigateur est public**. Pas « difficile à lire » — public. `Ctrl+U` affiche ton HTML, l'onglet Sources affiche tout ton JavaScript, l'onglet Réseau affiche toutes tes requêtes avec leurs en-têtes. Une clé d'API dans du JavaScript de page est une clé publiée.

**Le stockage durable** va en base de données. La mémoire d'un serveur disparaît à chaque redémarrage, et un fichier ne supporte pas les accès simultanés.

> **La phrase à retenir de cette leçon** : *tout ce qui arrive au navigateur est public et modifiable.* Elle décide à elle seule de l'emplacement de tes secrets, de tes règles et de tes validations — et tu croiseras des dizaines de tutoriels qui l'ignorent.

---

## Statique ou dynamique : ce que ça change pour toi

Un serveur **statique** renvoie des fichiers tels quels. Il ne calcule rien. C'est GitHub Pages, et c'est pour ça que c'est gratuit et illimité : servir un fichier ne coûte presque rien.

Un serveur **dynamique** exécute du code à chaque requête pour construire la réponse. Il faut donc qu'un programme tourne en permanence, qu'il consomme de la mémoire et du processeur — et c'est pour ça que c'est payant.

Cette distinction va dicter ton parcours de déploiements, et tu vas la vivre comme une contrainte très concrète. Au palier 2, ton application météo sera **statique** : elle ira sur GitHub Pages, gratuitement. Mais tu découvriras au passage que tu ne peux pas y cacher de clé d'API — précisément parce qu'il n'y a pas de serveur. Au palier 4, ton application aura un backend : GitHub Pages ne pourra plus l'héberger, et tu passeras sur Render. Tu découvriras alors que l'offre gratuite « s'endort » après inactivité, et tu comprendras exactement ce que tu paies chez un hébergeur : du temps de processus qui tourne.

C'est le [fil rouge des déploiements](../../deploiements.md), et il est construit pour que tu rencontres chaque limite avant qu'on te donne l'outil suivant.

---

## Ce qu'est une API, concrètement

La même donnée, deux présentations :

```bash
# Pour un humain : une page HTML
curl https://github.com/torvalds
# → <!DOCTYPE html><html>...  (illisible : c'est destiné à un navigateur)

# Pour un programme : du JSON
curl https://api.github.com/users/torvalds
# → {"login":"torvalds","name":"Linus Torvalds","public_repos":8,...}
```

Une API te permet d'écrire un programme qui **utilise** un service. Tu en consommeras dès le palier 1, et tu en **écriras** une au palier 4 — et c'est à ce moment-là que tu basculeras vraiment de « je fais des pages » à « je construis des systèmes ».

Le **JSON** est le format d'échange universel : des objets entre accolades, des tableaux entre crochets, des chaînes, des nombres, des booléens. Tu le liras et le produiras dans les quatre langages du parcours.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas travailler **une couche à la fois**, et c'est volontaire : palier 2 et 3 en frontend, palier 4 en backend et base. Garde la carte sous les yeux pour savoir où tu es.

Dès maintenant, prends l'habitude d'ouvrir l'onglet **Réseau → Fetch/XHR** sur les sites que tu utilises : tu y vois en direct les appels d'API que leur frontend fait à leur backend. C'est la meilleure façon de rendre cette leçon concrète.

### En équipe, en entreprise

Tu découvriras que la carte correspond à une **organisation humaine**. Dans une équipe un peu grande, il y a des développeurs frontend, des développeurs backend, et la frontière entre eux est… l'API. Le contrat d'API devient donc un objet politique : qui le définit, qui le modifie, que se passe-t-il quand il change. Tu entendras « l'API n'est pas prête, on travaille avec des données simulées » ou « il faut une nouvelle version de l'endpoint, on ne peut pas casser le mobile ».

Tu verras aussi que la question « où mettre cette logique ? » revient constamment, et qu'elle n'a pas toujours de réponse évidente. Un calcul dupliqué des deux côtés (pour l'affichage immédiat **et** pour la sécurité) est parfois la bonne réponse, pas une erreur.

Et tu rencontreras les profils du marché : beaucoup d'offres « fullstack » dans les petites structures, des spécialisations dans les grandes. Ton profil polyglotte — trois backends, un frontend, du mobile, du DevOps — te rend lisible pour les deux.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : savoir de quel côté tu écris, et appliquer la règle de répartition. Ça paraît abstrait maintenant ; ce sera un réflexe dans six mois.

Régulièrement : lire l'onglet Réseau, concevoir ou consommer une API JSON, décider où stocker une donnée.

Rare, et hors sujet : les architectures distribuées, les microservices, les files de messages, le serverless. Ces mots sont partout sur internet et nulle part dans le travail d'un junior. Ils arrivent au palier 7, quand tu auras les trois couches en main et que les questions deviendront réelles.

---

## Les problèmes que tu vas rencontrer

**« Je ne peux pas lire un fichier depuis mon JavaScript. »** Non, et c'est volontaire : le navigateur interdit au JavaScript d'une page d'accéder au système de fichiers de l'utilisateur. Ce serait une faille de sécurité majeure. Pour lire ou écrire des fichiers, il faut un backend.

**« Ma clé d'API est visible dans le navigateur. »** Oui, nécessairement. Soit tu utilises une API qui ne demande pas de clé (c'est le choix du palier 2 avec Open-Meteo), soit une clé restreinte par domaine, soit il te faut un backend qui garde la clé et relaie l'appel. Il n'y a pas de quatrième option, et tous les tutoriels qui font autrement enseignent une faille.

**« Ça marche en local mais pas déployé. »** Presque toujours une question de couche : une adresse `localhost` restée dans le code client (qui désigne alors la machine de l'utilisateur, pas ton serveur), une variable d'environnement absente, une base de données locale inexistante en production.

**« J'ai mis la validation côté client, c'est bon. »** Non. Un `curl` de dix secondes contourne tout. C'est la première chose qu'un testeur de sécurité essaiera.

**Confondre `localStorage` et une base de données.** `localStorage` vit dans **un** navigateur, sur **un** appareil, pour **un** utilisateur. Il ne partage rien, ne sauvegarde rien, et l'utilisateur peut l'effacer. C'est parfait pour mémoriser un thème sombre, inadapté pour des données qui comptent.

---

## Ce qu'on te demandera

En **entretien**, cette leçon sert de socle à toutes les questions d'architecture junior : « où mettrais-tu cette validation ? », « pourquoi ne pas mettre la clé d'API dans le frontend ? », « quelle différence entre un site statique et un site dynamique ? », « explique-moi ce qu'est une API ».

On te demandera aussi de **situer ton propre travail** : « dans ton projet, qu'est-ce qui tourne côté client et côté serveur ? ». Un candidat qui hésite sur cette question montre qu'il a suivi un tutoriel sans comprendre l'architecture de ce qu'il a construit.

En **travail réel**, on attendra de toi que tu saches dire de quel côté se trouve un bug avant d'ouvrir un fichier. C'est le gain de temps le plus immédiat de cette leçon.

---

## Ce qui te démarquera

**Poser la question de la répartition spontanément.** Quand on te décrit une fonctionnalité, demander « et cette règle, on la met côté serveur, je suppose ? » est une réaction d'architecte, pas d'exécutant.

**Ne jamais faire confiance au client.** C'est une habitude de pensée, pas une technique. Elle se voit dans ton code au palier 4 et elle rassure immédiatement.

**Savoir expliquer la carte à un non-technicien.** Si tu peux expliquer frontend, backend et base de données à quelqu'un qui ne code pas, tu pourras aussi le faire devant un client — et c'est une compétence commerciale autant que technique, qui te servira au palier 6 quand le référent jouera le client.

**Savoir pourquoi chaque hébergement coûte ce qu'il coûte.** Dire « ce projet est statique, il n'a pas besoin d'un VPS, GitHub Pages suffit et c'est gratuit » est une remarque de bon sens économique que beaucoup de développeurs ne font jamais.

---

## 📚 À lire

**MDN → *What is a web server?*** et ***Client-Side vs Server-Side***, qui posent exactement la distinction de cette leçon.

**MDN → *Working with JSON*** en survol : tu le pratiqueras au palier 1, inutile de l'approfondir maintenant.

Et survole les cartes **roadmap.sh/frontend** et **roadmap.sh/backend** — non pas pour les suivre (elles sont écrasantes et ce n'est pas le but), mais pour **situer** ce que tu vas apprendre dans l'ensemble du métier. Ne t'affole pas de leur taille : ce parcours en couvre l'essentiel employable, et personne ne connaît tout ce qu'elles contiennent.

---

## 🤖 Le mini-projet à demander à l'IA

Cette leçon s'ancre par des cas de décision. Fais-t'en poser :

> « Je suis en formation de développeur, palier 0. Je viens d'apprendre la répartition frontend / backend / base de données. Pose-moi **12 cas concrets** de fonctionnalités (par exemple : "afficher le total d'un panier", "vérifier qu'un code promo est valide", "mémoriser le thème sombre", "envoyer un email de confirmation", "trier une liste de 20 éléments déjà chargés"). Pour chacun, demande-moi **où je mettrais le traitement et pourquoi**. Ne donne pas la réponse avant la mienne, et quand je me trompe, pose-moi une question qui me fasse voir le problème (du type : "et si l'utilisateur modifiait ton JavaScript ?"). »

C'est l'exercice le plus utile de la leçon : la théorie se comprend en dix minutes, la décision s'acquiert par répétition.

Et un second, pour la dimension coût :

> « Décris-moi 5 projets web différents (un blog, un portfolio, une boutique, un tableau de bord interne, une application mobile avec compte utilisateur). Pour chacun, demande-moi : statique ou dynamique ? quel type d'hébergement ? quel ordre de prix ? Corrige mes réponses en expliquant ce que je paie réellement. »

---

## 🛠️ À faire

1. Prends trois sites ou applications que tu utilises et dis, pour chacun, ce qui est clairement du frontend, ce qui est forcément du backend, et ce qui est forcément stocké en base.
2. Interroge trois API publiques avec `curl` et décris la structure du JSON renvoyé :
   - `https://api.github.com/users/torvalds`
   - `https://pokeapi.co/api/v2/pokemon/pikachu`
   - `https://api.open-meteo.com/v1/forecast?latitude=4.05&longitude=9.7&current=temperature_2m`
3. Sur un site qui te plaît, ouvre **DevTools → Réseau → filtre Fetch/XHR**. Tu vois les appels d'API de son frontend vers son backend. Choisis-en un et décris-le : URL, méthode, code, forme de la réponse.
4. **La question de synthèse, à rédiger dans ton journal** (5 à 10 lignes) : *« je construis une application de gestion de dépenses. Où stocker les dépenses, et pourquoi pas ailleurs ? »* Envisage les quatre options : une variable JavaScript, `localStorage`, un fichier sur le serveur, une base de données. Donne la limite de chacune.
5. Ouvre le code source d'une page (`Ctrl+U`), puis l'onglet Sources des DevTools. Trouve un fichier JavaScript et lis-le. Mesure ce que ça implique pour les secrets.
6. Cherche une clé d'API visible dans le JavaScript d'un site réel (c'est plus fréquent qu'on ne croit). Demande-toi si elle est restreinte par domaine ou si c'est une véritable faille.
7. **Dessine la carte** des trois couches de mémoire, et place dessus les onze paliers du parcours. Garde ce dessin : c'est ta boussole pour dix-huit mois.

<details>
<summary>Corrections</summary>

**4 — la réponse attendue, et c'est la progression du parcours :**

Une **variable JavaScript** disparaît au rechargement de la page. Inutilisable pour conserver quoi que ce soit.

**`localStorage`** survit au rechargement, mais vit dans **un seul navigateur**, sur **un seul appareil**, limité à quelques mégaoctets, effaçable par l'utilisateur, et invisible pour tous les autres. Suffisant pour une préférence d'affichage (ce sera ton projet 2), inadapté pour des données réelles.

Un **fichier JSON côté serveur** est partagé et durable : c'est le choix du **projet 1**, en ligne de commande. Mais il n'offre aucune recherche efficace, aucune garantie en cas d'accès simultanés (deux écritures en même temps peuvent le corrompre), et aucune relation entre les données.

Une **base de données** est durable, interrogeable (`WHERE`, `JOIN`), transactionnelle, supporte la concurrence et se sauvegarde. C'est la bonne réponse dès qu'il y a plusieurs utilisateurs ou plus de quelques centaines d'enregistrements — ce sera le **projet 4**.

Remarque bien la progression : fichier JSON (palier 1) → `localStorage` (palier 2) → vraie base de données (palier 4). **Tu rencontreras la limite de chaque étape avant qu'on te donne la suivante.** C'est volontaire, et c'est ce qui fait qu'on comprend à quoi sert une base de données au lieu de l'utiliser parce qu'on nous l'a dit.

**5 et 6.** Tout le JavaScript de la page est lisible, formaté, et inspectable ligne par ligne. Donc : aucune clé secrète, aucune règle de sécurité, aucun mot de passe ne peut y être. Les clés qu'on y trouve parfois sont soit **publiques par conception** (restreintes à un domaine, avec un quota, conçues pour être exposées — c'est le cas des clés de cartes ou d'analytics), soit une vraie faille. Savoir faire la différence est déjà une compétence de sécurité.
</details>

---

## ✅ Acquis si…

- [ ] Je dessine les trois couches et j'y place chaque technologie du parcours.
- [ ] J'énonce la règle de répartition : ce qui va côté client, ce qui va côté serveur, et **pourquoi**.
- [ ] Je justifie pourquoi une clé d'API ne peut jamais vivre dans du JavaScript de navigateur.
- [ ] Je distingue hébergement statique et dynamique, et je sais pourquoi l'un est gratuit.
- [ ] J'interroge une API publique avec `curl` et je décris la forme du JSON reçu.
- [ ] Pour un besoin donné, je sais s'il faut `localStorage`, un fichier ou une base de données, et je peux le défendre.
- [ ] Devant un bug, je sais dire de quel côté chercher avant d'ouvrir un fichier.
- [ ] 🚦 **Je suis prêt pour l'[épreuve de sortie du palier](../evaluation.md).**

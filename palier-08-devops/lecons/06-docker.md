# Leçon 06 — Docker : images, conteneurs, Dockerfile, multi-stage

> 🎯 **À la fin de cette leçon** : tu empaquettes une application et tout son environnement dans une **image** qui tourne à l'identique partout — et tu as ressenti, en dockerisant tes trois backends, le problème que Docker résout.
> ⏱️ 6 h · **Prérequis** : les leçons 01-05, et tes trois backends (Node, Python, PHP).

> ⚠️ Rappel du garde-fou : une commande Docker (`docker system prune`, `docker rm`, un volume supprimé) peut effacer des données. Comprends ce que tu supprimes avant de le supprimer.

---

## De quoi on parle

**Docker** empaquette une application **et tout ce dont elle a besoin pour tourner** — le runtime (Node, Python, PHP), les bibliothèques, les fichiers système, la configuration — dans une **image**. Cette image s'exécute de façon identique sur ta machine, celle d'un collègue et le serveur de production. Fini le « ça marche chez moi ».

Trois mots à distinguer :

- une **image** : le modèle figé, en lecture seule, qui contient l'app et son environnement (comme une classe) ;
- un **conteneur** : une instance en cours d'exécution d'une image (comme un objet instancié depuis la classe) ;
- un **`Dockerfile`** : la recette, versionnable, qui décrit comment construire l'image, étape par étape.

Un conteneur n'est **pas** une machine virtuelle : il partage le noyau Linux de l'hôte et ne contient que ce qu'il faut à l'application, ce qui le rend léger et rapide à démarrer. C'est de l'**isolation**, pas de la virtualisation complète.

L'exercice révélateur du palier t'attend : dockeriser tes **trois** backends — Node, Django/gunicorn, Laravel/php-fpm+Nginx. Trois runtimes radicalement différents, et pourtant une seule interface (`docker build`, `docker run`). C'est **exactement** le problème que Docker résout, et peu de juniors l'ont ressenti dans trois écosystèmes.

---

## À quoi ça sert, concrètement

**Parce que « ça marche chez moi » coûte des heures à tout le monde.** L'application dépend d'une version précise de Node, d'une bibliothèque système, d'une variable d'environnement. Sur une autre machine, une version diffère, et tout casse. Docker fige **l'environnement entier** dans l'image : si ça marche dans le conteneur, ça marche partout où le conteneur tourne. C'est la fin d'une classe entière de bugs.

**Parce qu'il uniformise des technologies hétérogènes.** Tes trois backends s'installent et se lancent différemment (npm, pip/gunicorn, composer/php-fpm). Une fois dockerisés, ils se construisent et se lancent **tous** avec les mêmes deux commandes. Pour une équipe qui gère plusieurs services dans plusieurs langages, c'est une simplification énorme — une seule façon de démarrer n'importe quoi.

**Parce que c'est devenu le standard du déploiement.** La CI/CD (leçon 08), l'orchestration (Kubernetes), le cloud : presque tout l'écosystème moderne tourne autour des conteneurs. Savoir écrire un `Dockerfile` et faire tourner un conteneur est aujourd'hui une compétence de base attendue, pas un plus.

**Et parce qu'il rend l'environnement reproductible et versionnable.** Le `Dockerfile` est du code : il vit dans Git (palier 0), se relit, se révise. L'environnement de production n'est plus un serveur configuré à la main dont personne ne connaît l'état, mais une recette explicite. C'est l'« infrastructure comme code ».

---

## Où ça intervient dans le développement

Docker se place entre ton code et son exécution, partout :

```
   Ton code + Dockerfile (dans Git)
        ▼  docker build
   IMAGE (app + environnement complet, figée)
        ▼  (poussée dans un registre : Docker Hub, GitHub Container Registry)
        ▼  docker run  (sur ta machine, en CI — leçon 08 —, sur le serveur)
   CONTENEUR qui tourne, à l'identique partout
        │ plusieurs conteneurs s'assemblent avec Compose (leçon 07)
```

Trois ancrages.

**Il fige l'environnement de tes backends (paliers 4-6).** Ton app Node avait besoin d'une version de Node et de ses `node_modules` ; ton app Python d'un `.venv` et de `requirements.txt` ; ton app PHP de PHP 8 et de `vendor/`. Le `Dockerfile` capture tout ça. Les gestionnaires de dépendances que tu connais (npm, pip, composer — paliers 4-6) s'exécutent **dans** la construction de l'image.

**Il remplace (ou complète) le service systemd de la leçon 02.** Deux façons de faire tourner une app en production : un service systemd directement sur le serveur (leçon 02), ou un conteneur Docker. Le conteneur apporte en plus l'isolation et l'environnement figé. Souvent, Docker lui-même tourne comme service systemd.

**Il prépare Compose (leçon 07) et la CI/CD (leçon 08).** Un conteneur, c'est une brique ; Compose (leçon 07) en assemble plusieurs (app + base + proxy) ; la CI/CD (leçon 08) construit l'image automatiquement à chaque push. Cette leçon pose la brique.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas lancer un conteneur depuis une image existante, écrire un `Dockerfile` pour un de tes backends, le construire, le faire tourner, comprendre les volumes (pour les données) et les ports (pour y accéder), puis optimiser avec un build **multi-stage**. Et tu dockeriseras **tes trois** backends pour ressentir l'interface unique.

### En équipe, en entreprise

**Le projet a un (ou des) `Dockerfile`.** Démarrer le projet, c'est souvent `docker build` puis `docker run` (ou `docker compose up`, leçon 07). Un nouvel arrivant est opérationnel en minutes, sans installer Node/Python/PHP sur sa machine — tout est dans l'image.

**Les images se stockent dans des registres.** Docker Hub, GitHub Container Registry, ou un registre privé : on y **pousse** les images construites et on les **tire** sur le serveur. La CI/CD (leçon 08) automatise ce cycle.

**La taille des images compte.** Une image énorme (plusieurs Go) est lente à transférer et à déployer. Les bonnes pratiques — image de base légère (`alpine`, `slim`), build multi-stage, `.dockerignore` — réduisent drastiquement la taille. Une image bien faite est un signe de maîtrise.

**Les données vivent dans des volumes, jamais dans le conteneur.** Un conteneur est **jetable** : on le détruit et on le recrée sans état (lien direct avec la *statelessness* du palier 7 !). Les données persistantes (base, uploads) vont dans des **volumes** montés, qui survivent au conteneur. Confondre les deux, c'est perdre ses données au prochain redéploiement.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : `docker build`, `docker run`, `docker ps` (conteneurs actifs), `docker logs`, `docker exec` (entrer dans un conteneur), lire et écrire un `Dockerfile`.

Régulièrement : les volumes, les ports (`-p`), les variables d'environnement (`-e`), les images multi-stage, `.dockerignore`, `docker compose` (leçon 07).

Rare ou avancé : les réseaux Docker personnalisés, le build multi-plateforme (ARM/x86), les secrets de build, l'optimisation fine du cache de couches, l'orchestration Kubernetes. À connaître de nom ; tu les creuseras à l'échelle.

---

## La mécanique

### Image vs conteneur (le concept central)

```
IMAGE      = le modèle figé, en lecture seule (app + environnement).   ≈ une classe
CONTENEUR  = une exécution de l'image, éphémère.                        ≈ un objet
On peut lancer PLUSIEURS conteneurs identiques depuis UNE image.
Un conteneur est JETABLE : on le détruit, on le recrée, sans rien perdre
  — à condition que les données soient dans des VOLUMES, pas dans le conteneur.
```

Cette distinction est la clé. L'image ne change pas ; le conteneur vit et meurt. Comme un objet instancié d'une classe (palier 1), un conteneur est une instance qu'on peut multiplier et jeter. Et comme au palier 7, un conteneur bien conçu est **sans état** : tout ce qui doit survivre est externalisé.

### Lancer un conteneur existant

```bash
docker run -d -p 8080:80 --name web nginx    # lancer Nginx, détaché, port 8080→80
docker ps                                      # les conteneurs qui tournent
docker logs web                                # les logs du conteneur "web"
docker exec -it web sh                         # entrer dans le conteneur (un shell)
docker stop web && docker rm web               # arrêter et supprimer
```

`-d` détache (tourne en fond), `-p 8080:80` publie le port 80 **du conteneur** sur le port 8080 **de l'hôte** (comme un tunnel, lien leçon 03/04), `--name` nomme. `docker exec -it ... sh` ouvre un shell **dans** le conteneur pour inspecter — très utile pour diagnostiquer.

### ⭐ Un Dockerfile : la recette de l'image

```dockerfile
# Dockerfile pour un backend Node (palier 4)
FROM node:20-slim                 # image de base : Node 20, version légère "slim"
WORKDIR /app                      # dossier de travail dans l'image
COPY package*.json ./             # copier D'ABORD les manifestes (cache, voir plus bas)
RUN npm ci --omit=dev             # installer les dépendances (npm du palier 4)
COPY . .                          # puis copier le reste du code
EXPOSE 3000                       # documenter le port de l'app
USER node                         # ⭐ ne PAS tourner en root (moindre privilège, leçon 01)
CMD ["node", "server.js"]         # la commande lancée au démarrage du conteneur
```

Lis-le comme une recette, de haut en bas. `FROM` choisit la base. `WORKDIR` fixe le dossier. L'ordre `COPY package*.json` → `RUN npm ci` → `COPY . .` n'est pas anodin : Docker met chaque étape en **cache**, et ne la rejoue que si ce qu'elle copie a changé. En copiant d'abord les manifestes, `npm ci` n'est re-exécuté que si les dépendances changent, pas à chaque modification de code — un build bien plus rapide. `USER node` applique le moindre privilège de la leçon 01 **dans** le conteneur. `CMD` est ce qui tourne au démarrage.

### Construire et lancer son image

```bash
docker build -t mon-backend:1.0 .      # construire l'image depuis le Dockerfile
docker run -d -p 3000:3000 --env-file .env mon-backend:1.0   # la lancer
```

`docker build -t nom:tag .` construit l'image en suivant le `Dockerfile` du dossier courant. `--env-file .env` injecte les variables d'environnement (les secrets hors du code, palier 4) — on ne les met **jamais** dans l'image.

### ⭐ Les volumes : là où vivent les données

```bash
# la base de données écrit dans un VOLUME, qui survit au conteneur
docker run -d -v pgdata:/var/lib/postgresql/data postgres:16
# un dossier de l'hôte monté dans le conteneur (pour du dev, ou des uploads)
docker run -d -v /opt/monapp/uploads:/app/uploads mon-backend:1.0
```

Le principe vital : **le conteneur est jetable, pas les données**. Tout ce qui doit persister (base, fichiers uploadés) va dans un **volume** — un stockage géré par Docker (ou un dossier de l'hôte) monté dans le conteneur. Détruire et recréer le conteneur ne touche pas au volume. Oublier ça, c'est perdre sa base au prochain `docker rm`. C'est la *statelessness* du palier 7 rendue concrète : le conteneur sans état, l'état dans le volume.

### ⭐ Le build multi-stage : des images légères

```dockerfile
# ÉTAPE 1 : construire (outils de build, lourds)
FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build               # produit /app/dist

# ÉTAPE 2 : l'image FINALE, qui ne garde QUE le résultat
FROM node:20-slim
WORKDIR /app
COPY --from=build /app/dist ./dist      # on récupère juste le build
COPY --from=build /app/node_modules ./node_modules
USER node
CMD ["node", "dist/server.js"]
```

Le multi-stage sépare **construire** et **exécuter**. La première étape, lourde (outils de compilation, dépendances de dev), produit le résultat. La seconde part d'une base légère et ne **copie que le résultat** — pas les outils de build. L'image finale est bien plus petite (parfois dix fois), donc plus rapide à transférer et à déployer. C'est la bonne pratique attendue en production.

### `.dockerignore` : ne pas embarquer le superflu

```
node_modules
.git
.env
*.log
```

Comme `.gitignore` (palier 0), `.dockerignore` exclut ce qui ne doit pas entrer dans l'image : les dépendances (réinstallées dans le build), l'historique Git, les secrets, les logs. Il allège l'image et évite d'y embarquer des fichiers sensibles par accident.

---

## Les problèmes que tu vas rencontrer

**« Ça marche dans le conteneur mais je n'y accède pas. »** Tu n'as pas publié le port (`-p 3000:3000`). Le conteneur est isolé ; il faut explicitement exposer son port sur l'hôte.

**« J'ai redéployé et j'ai perdu ma base de données. »** Les données étaient **dans** le conteneur, pas dans un volume. Recréer le conteneur les a effacées. Mets les données persistantes dans un volume — toujours.

**Mon image fait 2 Go.** Base trop lourde (`node` au lieu de `node:slim`), pas de multi-stage, pas de `.dockerignore`. Applique les trois : base légère, build multi-stage, ignore le superflu.

**Le build est lent à chaque petite modification.** Mauvais ordre des `COPY`/`RUN` : tu copies tout le code avant d'installer les dépendances, donc le cache est invalidé à chaque changement. Copie d'abord les manifestes, installe, puis copie le code.

**Le conteneur tourne en `root`.** Tu as oublié `USER`. Un processus `root` dans un conteneur qui s'échappe est dangereux. Ajoute un utilisateur non privilégié (moindre privilège, leçon 01).

**`docker system prune` a tout effacé.** Cette commande supprime conteneurs, images et **volumes** non utilisés. Puissante et destructrice. Comprends ce qu'elle va supprimer (lis sa sortie) avant de confirmer — le garde-fou du palier.

**Mes secrets sont dans l'image.** Tu as fait `COPY .env` ou codé des secrets dans le `Dockerfile`. Une image se partage : les secrets fuiteraient. Passe-les à l'exécution (`--env-file`, `-e`), jamais dans l'image.

---

## Ce qu'on te demandera

En **test DevOps**, Docker est quasi systématique : « différence entre une image et un conteneur ? », « à quoi sert un `Dockerfile` ? », « où mets-tu les données persistantes ? » (volumes), « qu'est-ce qu'un build multi-stage et pourquoi ? ». On peut te demander d'écrire un `Dockerfile` simple pour une app donnée.

On peut demander : « pourquoi un conteneur n'est-il pas une VM ? », « comment réduis-tu la taille d'une image ? », « pourquoi ne pas mettre de secrets dans l'image ? », « pourquoi ne pas tourner en `root` dans un conteneur ? ».

En **mission**, écrire et maintenir des `Dockerfile`, lancer des conteneurs, diagnostiquer avec `docker logs`/`docker exec` sont des gestes très courants.

---

## Ce qui te démarquera

**Avoir dockerisé trois runtimes différents.** C'est ton atout rare. Pouvoir dire « j'ai dockerisé une app Node, une Django/gunicorn et une Laravel/php-fpm : trois environnements radicalement différents, une seule interface `docker build`/`docker run` » démontre que tu as **ressenti** le problème que Docker résout, pas juste copié un tutoriel.

**La discipline conteneur jetable / données en volume.** Savoir qu'un conteneur est sans état (lien palier 7) et que les données vivent dans des volumes évite la pire erreur — perdre la base en redéployant. C'est un réflexe de pro.

**Des images propres.** Base légère, multi-stage, `.dockerignore`, utilisateur non-root, pas de secrets : une image soignée est immédiatement visible et signale la maîtrise.

**Et relier Docker à ce que tu sais.** Image≈classe / conteneur≈objet (palier 1), le moindre privilège (leçon 01), les ports (leçon 04), la statelessness (palier 7), npm/pip/composer qui s'exécutent dans le build (paliers 4-6) : montrer que Docker n'est pas une île mais qu'il assemble tout ce que tu connais, c'est exactement la compréhension d'ensemble recherchée.

---

## 📚 À lire

**Documentation Docker → *Get started* et *Dockerfile reference*** : la référence officielle, avec le cycle image/conteneur et toutes les instructions du `Dockerfile`.

**Docker → *Build best practices*** : l'ordre des couches pour le cache, le multi-stage, les images légères, `.dockerignore`. À lire pour des images propres.

**Les images officielles sur Docker Hub** (node, python, php) et leurs *tags* (`slim`, `alpine`) : pour choisir une base adaptée et légère.

Relis le palier 1 (classe vs objet) pour l'analogie image/conteneur, la leçon 01 (moindre privilège, `USER`), et le palier 7, leçon 07 (statelessness) : le conteneur jetable en est l'incarnation.

---

## 🤖 Le mini-projet à demander à l'IA

Dockeriser un backend, puis les trois (l'exercice révélateur) :

> « Je suis en formation de développeur, palier 8 (DevOps). Je veux dockeriser un de mes backends. Sans me donner un Dockerfile à copier sans comprendre, guide-moi instruction par instruction : choisir une image de base légère, l'ordre COPY/RUN pour profiter du cache (manifestes d'abord, code ensuite), EXPOSE, ne pas tourner en root (USER), et CMD. Explique-moi la différence image/conteneur, où vont les données (volumes, car le conteneur est jetable) et pourquoi je ne mets jamais de secrets dans l'image. »

Puis le révélateur et l'optimisation :

> « Aide-moi maintenant à dockeriser mes TROIS backends (Node, Django/gunicorn, Laravel/php-fpm) et fais-moi remarquer, à chaque fois, ce qui change (la base, l'installation des dépendances, la commande de lancement) et ce qui reste identique (docker build, docker run). C'est l'exercice qui doit me faire ressentir le problème que Docker résout. Ensuite, aide-moi à transformer un de mes Dockerfile en build multi-stage pour réduire la taille de l'image, et à ajouter un .dockerignore. »

---

## 🛠️ À faire

> Comprends chaque commande avant de l'exécuter, surtout celles qui suppriment (`rm`, `prune`, volumes).

1. **Image vs conteneur** : lance un conteneur Nginx (`docker run -d -p ...`), liste-le (`docker ps`), lis ses logs, entre dedans (`docker exec -it ... sh`), puis arrête et supprime-le. Explique par écrit la différence image/conteneur.
2. **⭐ Un premier Dockerfile** : écris un `Dockerfile` pour ton backend Node (palier 4). Soigne l'ordre `COPY`/`RUN` (manifestes d'abord), ajoute `USER` non-root, `EXPOSE`, `CMD`. Construis (`docker build -t`) et lance (`docker run -p`).
3. **Le cache** : modifie une ligne de ton code (pas les dépendances) et reconstruis. Vérifie que `npm ci` n'est **pas** rejoué (cache). Puis modifie `package.json` et vois le cache invalidé.
4. **⭐ Les volumes** : lance une base de données en conteneur avec un volume. Insère des données, détruis le conteneur, recrée-le sur le **même** volume, et vérifie que les données sont **toujours là**. Puis refais sans volume et constate la perte.
5. **Les secrets** : passe les variables d'environnement avec `--env-file`, et vérifie (avec un `.dockerignore`) que `.env` n'entre **pas** dans l'image.
6. **⭐ Multi-stage** : transforme un de tes `Dockerfile` en build multi-stage (étape build + étape finale légère). Compare la taille de l'image avant/après (`docker images`).
7. **⭐ L'exercice révélateur** : dockerise tes **trois** backends (Node, Django/gunicorn, Laravel/php-fpm). Note, pour chacun, ce qui change (base, dépendances, commande) et ce qui reste identique (les deux commandes `build`/`run`).
8. **Diagnostiquer** : fais échouer un conteneur (mauvaise commande, port déjà pris), et trouve la cause avec `docker logs` et `docker ps -a`.
9. **Le ménage prudent** : liste les images et volumes, comprends ce que `docker system prune` supprimerait, et fais le ménage **en sachant** ce que tu effaces.
10. **Le lien** : dans ton journal, relie Docker à ce que tu sais — image/conteneur ≈ classe/objet (palier 1), `USER` ≈ moindre privilège (leçon 01), conteneur jetable ≈ statelessness (palier 7).

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Image = modèle figé en lecture seule (l'app + son environnement), conteneur = une exécution de cette image, éphémère et jetable. Comme classe/objet au palier 1 : une image, plusieurs conteneurs possibles ; on jette et recrée un conteneur sans toucher à l'image. Un conteneur n'est pas une VM : il partage le noyau de l'hôte et ne contient que le nécessaire — d'où sa légèreté.

**3.** Le cache de couches explique l'ordre des instructions. Docker met chaque étape en cache et ne la rejoue que si ce qu'elle utilise a changé. En copiant `package*.json` **avant** le reste du code et en installant juste après, l'étape coûteuse (`npm ci`) n'est re-exécutée que quand les dépendances changent — pas à chaque modification de code. Inverser l'ordre (copier tout le code d'abord) invalide le cache à chaque build. C'est l'optimisation la plus rentable d'un Dockerfile.

**4.** Le point vital : **le conteneur est jetable, les données ne le sont pas**. Un volume est un stockage géré par Docker (ou un dossier de l'hôte) monté dans le conteneur ; il **survit** à la destruction du conteneur. Mettre la base dans un volume = pouvoir recréer le conteneur (mise à jour, redéploiement) sans perdre les données. L'oublier = perdre la base au prochain `docker rm`. C'est la *statelessness* du palier 7 rendue concrète : conteneur sans état, état dans le volume.

**6.** Le multi-stage sépare l'étape de **construction** (lourde : compilateurs, outils, dépendances de dev) de l'image **finale** (légère : seulement le résultat + le runtime). La seconde étape copie juste ce qu'il faut depuis la première (`COPY --from=build`). Résultat : une image bien plus petite, donc plus rapide à transférer et déployer, et avec moins de surface d'attaque (pas d'outils de build en production). C'est une bonne pratique attendue.

**7.** L'exercice révélateur du palier. Tes trois backends s'installent et se lancent de façons **radicalement** différentes : `npm ci`/`node` (Node), `pip install`/`gunicorn` (Python), `composer install`/`php-fpm`+Nginx (PHP). Pourtant, une fois dockerisés, ils se construisent et se lancent **tous** avec `docker build` puis `docker run` (ou `docker compose`, leçon 07). **C'est exactement le problème que Docker résout** : une interface unique pour des environnements hétérogènes. L'avoir vécu dans trois écosystèmes — ce que peu de juniors ont fait — est ta meilleure preuve de compréhension en entretien.

**9.** `docker system prune` supprime tout ce qui n'est pas utilisé : conteneurs arrêtés, images sans conteneur, réseaux — et avec `--volumes`, les volumes orphelins (donc potentiellement des données !). Puissant pour récupérer de l'espace, destructeur si lancé sans regarder. Lis ce qu'il annonce supprimer avant de confirmer. C'est le garde-fou du palier appliqué à Docker : comprendre avant de supprimer, car il n'y a pas de `reflog`.
</details>

---

## ✅ Acquis si…

- [ ] Je distingue image (modèle figé) et conteneur (exécution jetable).
- [ ] J'écris un `Dockerfile` avec une base légère, le bon ordre de couches, `USER` non-root et `CMD`.
- [ ] Je construis et lance une image, en publiant le port et en injectant les variables d'environnement.
- [ ] Je mets les données persistantes dans des volumes, et je sais qu'un conteneur est jetable.
- [ ] Je ne mets jamais de secrets dans une image (`.dockerignore`, variables à l'exécution).
- [ ] J'écris un build multi-stage pour réduire la taille de l'image.
- [ ] J'ai dockerisé mes trois backends et je sais dire ce que Docker résout.
- [ ] Je diagnostique un conteneur avec `docker logs`/`docker exec` et je supprime en sachant ce que j'efface.

# Leçon 07 — Docker Compose : app + base + proxy en une commande

> 🎯 **À la fin de cette leçon** : tu démarres toute ta stack — application, base de données, reverse proxy — avec une seule commande, à partir d'un fichier versionnable qui décrit l'ensemble.
> ⏱️ 5 h · **Prérequis** : leçon 06 (Docker), et les leçons 02 et 05 (systemd, Nginx).

> ⚠️ Rappel du garde-fou : `docker compose down -v` supprime les **volumes** (donc les données). Comprends la différence entre `down` et `down -v` avant de la taper.

---

## De quoi on parle

Une application réelle n'est pas un seul conteneur : c'est l'**application**, plus une **base de données**, plus souvent un **reverse proxy** (Nginx, leçon 05), parfois un **cache** (Redis). Lancer et relier tout ça à la main (plusieurs `docker run` avec les bons ports, réseaux, volumes, dans le bon ordre) est fastidieux et source d'erreurs.

**Docker Compose** décrit cette pile entière dans un seul fichier, `compose.yaml`, et la pilote d'une commande :

```bash
docker compose up -d      # démarre TOUTE la stack (app + base + proxy)
docker compose down       # arrête tout
```

Le fichier déclare chaque **service** (app, base, proxy), leurs images ou `Dockerfile`, leurs ports, leurs volumes, leurs variables, et comment ils communiquent. C'est l'assemblage des briques de la leçon 06 en une application complète, décrite comme du code (versionnable dans Git).

C'est l'outil qui rend un projet démarrable en une commande — sur ta machine, celle d'un collègue, ou un petit serveur de production.

---

## À quoi ça sert, concrètement

**Parce qu'une application a toujours plusieurs morceaux.** App + base au minimum, souvent + proxy + cache. Compose les déclare ensemble, dans leur configuration et leur ordre de démarrage, au lieu d'une suite de `docker run` à mémoriser. Un seul fichier décrit tout le système.

**Parce que « cloner et lancer » devient trivial.** Un nouvel arrivant clone le dépôt, fait `docker compose up`, et toute la pile démarre — app, base migrée, proxy configuré — sans installer quoi que ce soit sur sa machine. L'environnement de développement est reproductible à l'identique pour toute l'équipe. C'est un gain de temps considérable.

**Parce que la communication entre services est gérée pour toi.** Compose crée un réseau privé où les services s'appellent **par leur nom** : l'app joint la base à l'adresse `db:5432`, sans IP codée en dur. Changer de machine ne change rien. Ce réseau interne garde aussi la base **non exposée** à l'extérieur (lien leçon 04).

**Et parce que c'est l'étape naturelle avant l'orchestration.** Pour un projet modeste ou de taille moyenne, Compose suffit en production. Pour plus grand, on passe à Kubernetes — mais Compose t'apprend les concepts (services, réseaux, volumes, dépendances) qui s'y retrouvent. C'est le bon niveau pour toute cette formation.

---

## Où ça intervient dans le développement

Compose orchestre les conteneurs de la leçon 06 en un système cohérent :

```
   compose.yaml (dans Git)
        ▼  docker compose up
   ┌──────────────────────────────────────────┐
   │  service "proxy" (Nginx, leçon 05) :80 :443 │ ← seul exposé au monde
   │       ▼ (réseau privé Compose)              │
   │  service "app" (ton Dockerfile, leçon 06)   │
   │       ▼ db:5432                             │
   │  service "db" (postgres) + VOLUME pgdata    │ ← non exposé, données persistées
   └──────────────────────────────────────────┘
```

Trois ancrages.

**Il assemble les images de la leçon 06.** Chaque service Compose est un conteneur (leçon 06) : soit une image publique (`postgres`, `redis`), soit construit depuis **ton** `Dockerfile`. Compose ajoute la mise en réseau, l'ordre, et la configuration partagée.

**Il intègre le reverse proxy de la leçon 05.** Nginx devient un service de la pile, qui route vers le service `app` par son nom sur le réseau privé. C'est ton architecture proxy/app (leçon 05), décrite en quelques lignes de YAML.

**Il reprend les volumes et la statelessness (leçon 06, palier 7).** La base écrit dans un volume déclaré dans le fichier ; les services applicatifs restent sans état. `docker compose down` puis `up` recrée les conteneurs sans perdre les données du volume — à condition de ne pas faire `down -v`.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire un `compose.yaml` qui réunit un de tes backends, sa base de données et Nginx ; démarrer la pile en une commande ; voir les services se joindre par leur nom ; gérer les volumes et les dépendances de démarrage ; et comprendre `up`/`down`/`logs`/`ps` de Compose.

### En équipe, en entreprise

**`docker compose up` est la commande de démarrage du projet.** C'est souvent la première ligne du README : cloner, copier `.env`, `docker compose up`. L'onboarding passe de « installe Node, Python, PostgreSQL, configure… » (une journée) à une commande (deux minutes).

**On sépare souvent dev et prod.** Un `compose.yaml` de base, surchargé par un `compose.override.yaml` (dev : volumes montés pour le rechargement à chaud) ou un fichier de prod (images construites, pas de code monté). Comprendre cette séparation évite de déployer la config de développement.

**La base ne s'expose pas, même en Compose.** On ne publie pas le port de la base vers l'hôte en production (elle reste sur le réseau privé). En développement, on l'expose parfois pour la déboguer avec un client local — un choix conscient, pas un défaut.

**Compose en prod, oui, pour la bonne échelle.** Beaucoup de projets tournent très bien avec Compose sur un VPS (le tien, leçon 09). On passe à Kubernetes pour la grande échelle ou les équipes nombreuses (lien palier 7) — pas avant d'en avoir le besoin réel.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : `docker compose up -d`, `down`, `logs -f`, `ps`, `exec`, écrire et lire un `compose.yaml`.

Régulièrement : les volumes et réseaux déclarés, `depends_on` et les *healthchecks*, les variables via `.env`, la reconstruction (`up --build`), les fichiers d'override dev/prod.

Rare ou avancé : les *profiles* Compose, la montée en charge (`--scale`), les secrets Compose, le passage à Kubernetes. À connaître de nom ; tu les creuseras au besoin.

---

## La mécanique

### Un compose.yaml complet

```yaml
# compose.yaml
services:
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}      # depuis le .env (jamais en clair ici)
    volumes:
      - pgdata:/var/lib/postgresql/data      # ⭐ les données dans un volume
    healthcheck:                             # est-elle VRAIMENT prête ?
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      retries: 5

  app:
    build: .                                 # construit depuis TON Dockerfile (leçon 06)
    environment:
      DATABASE_URL: postgres://postgres:${DB_PASSWORD}@db:5432/app   # ⭐ "db" = le service
    depends_on:
      db:
        condition: service_healthy           # démarrer APRÈS que la base est prête
    # pas de "ports" exposés : c'est le proxy qui parle au monde

  proxy:
    image: nginx:stable
    ports:
      - "80:80"                              # SEUL service exposé au monde
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro   # config Nginx (leçon 05)
    depends_on:
      - app

volumes:
  pgdata:                                     # le volume nommé, persistant
```

Lis-le service par service. Chaque bloc sous `services:` est un conteneur (leçon 06). `db` utilise une image publique et écrit dans le volume `pgdata`. `app` est construit depuis **ton** `Dockerfile` (`build: .`) et joint la base via `db:5432` — **le nom du service** suffit, Compose s'occupe du réseau. `proxy` (Nginx) est le **seul** à publier des ports vers le monde. En bas, `volumes:` déclare le stockage persistant. Tout l'assemblage de la leçon 06 tient dans ce fichier.

### ⭐ La communication par nom de service

```
Sur le réseau privé que Compose crée automatiquement :
  l'app joint la base à l'adresse  db:5432   (et non une IP codée en dur)
  le proxy joint l'app à l'adresse app:3000
Les noms = les clés sous "services:". Pas d'IP à gérer, ça marche partout pareil.
```

C'est l'élément le plus pratique : Compose met tous les services sur un réseau privé et leur donne un nom DNS interne égal à leur nom de service. L'app configure sa base sur `db`, pas sur `127.0.0.1` ou une IP — donc la même configuration marche sur toutes les machines. Et comme ce réseau est privé, la base n'est atteignable que par les autres services, pas depuis l'extérieur.

### Piloter la pile

```bash
docker compose up -d           # démarrer toute la pile, détaché
docker compose up -d --build   # reconstruire les images puis démarrer
docker compose ps              # l'état de chaque service
docker compose logs -f app     # suivre les logs d'un service (comme journalctl, leçon 02)
docker compose exec app sh     # entrer dans le conteneur de l'app
docker compose down            # arrêter et supprimer les conteneurs (GARDE les volumes)
docker compose down -v         # ⚠️ ...ET supprime les volumes (DONNÉES PERDUES)
```

`up` lit le fichier et démarre tout dans l'ordre des dépendances. `logs -f` rejoint la logique de `journalctl -f` (leçon 02) : suivre un service en direct. La distinction vitale est `down` vs `down -v` : le premier arrête les conteneurs mais **garde** les volumes (tes données survivent) ; le second supprime **aussi** les volumes (données effacées). Ne tape `-v` que si tu veux vraiment repartir de zéro.

### ⭐ `depends_on` et healthcheck : l'ordre de démarrage

```yaml
    depends_on:
      db:
        condition: service_healthy    # attendre que la base soit PRÊTE, pas juste démarrée
```

Le piège classique : l'app démarre avant que la base soit prête à accepter des connexions, et crashe. `depends_on` gère l'ordre, mais « démarré » ne veut pas dire « prêt » : d'où le **healthcheck** (`pg_isready`) qui vérifie que la base répond vraiment, et `condition: service_healthy` qui fait attendre l'app jusque-là. C'est l'équivalent, en Compose, du `After=` de systemd (leçon 02) — mais en plus fin (prêt, pas juste lancé).

### Les variables et secrets

```yaml
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}      # lu depuis un fichier .env à côté
```

```bash
# .env (jamais versionné — .gitignore, palier 0)
DB_PASSWORD=un-mot-de-passe-solide
```

Compose lit automatiquement un fichier `.env` du dossier et substitue `${...}`. Les secrets (mots de passe, clés) vivent dans ce `.env` **non versionné**, pas dans le `compose.yaml` (qui, lui, est dans Git). C'est la règle « secrets hors du code » des paliers 4 et 6, appliquée à la pile.

### Dev et prod séparés

```
compose.yaml            → la base commune (services, réseau, volumes)
compose.override.yaml   → surcharges de DEV (monter le code pour le rechargement à chaud,
                          exposer le port de la base pour la déboguer) — pris en compte
                          automatiquement par "docker compose up"
compose.prod.yaml       → prod (images construites, pas de code monté, pas de port de base)
                          lancé avec : docker compose -f compose.yaml -f compose.prod.yaml up
```

En développement, on monte le code source dans le conteneur pour voir les changements sans reconstruire, et on expose parfois la base pour la déboguer. En production, on fige tout dans l'image et on n'expose que le proxy. Garder deux configurations évite de déployer les commodités (et les failles) du développement.

---

## Les problèmes que tu vas rencontrer

**« L'app ne joint pas la base. »** Mauvais nom d'hôte : utilise le **nom du service** (`db`), pas `localhost` ni une IP. Dans un conteneur, `localhost` désigne le conteneur lui-même, pas la base.

**« L'app crashe au démarrage, la base n'est pas prête. »** `depends_on` seul ne suffit pas (« démarré » ≠ « prêt »). Ajoute un healthcheck sur la base et `condition: service_healthy`.

**« J'ai fait `down -v` et perdu ma base. »** `-v` supprime les volumes. `down` tout court les garde. Lis la commande avant de la taper — c'est le garde-fou du palier.

**« Mes changements de code n'apparaissent pas. »** En prod, le code est figé dans l'image : il faut reconstruire (`up --build`). En dev, monte le code en volume (override) pour le voir sans reconstruire.

**« Le port de la base est exposé à Internet. »** Tu as mis `ports:` sur le service `db`. En production, ne publie que le proxy ; la base reste sur le réseau privé (leçon 04). Expose-la seulement en dev, si besoin.

**« Les secrets sont dans le `compose.yaml` versionné. »** Sors-les dans un `.env` non versionné et référence-les par `${...}`. Le `compose.yaml` est dans Git ; les secrets, non.

---

## Ce qu'on te demandera

En **test DevOps**, Compose est très courant : « à quoi sert Docker Compose ? », « comment tes conteneurs communiquent-ils entre eux ? » (par nom de service sur le réseau privé), « où mets-tu les données ? » (volume déclaré), « comment gères-tu l'ordre de démarrage app/base ? » (`depends_on` + healthcheck). On peut te demander de lire ou écrire un `compose.yaml` simple.

On peut demander : « différence entre `down` et `down -v` ? », « pourquoi n'exposes-tu que le proxy ? », « comment sépares-tu dev et prod ? ».

En **mission**, lire, modifier et lancer un `compose.yaml`, suivre les logs d'un service, diagnostiquer une pile qui ne démarre pas sont des gestes quotidiens.

---

## Ce qui te démarquera

**La pile entière en une commande.** Montrer qu'un `docker compose up` démarre app + base + proxy configurés et reliés, et qu'un nouvel arrivant est opérationnel en deux minutes, démontre une vraie maîtrise de l'environnement de développement reproductible.

**La communication par nom, pas par IP.** Savoir que les services se joignent par leur nom sur le réseau privé, et que la base reste ainsi non exposée, montre que tu comprends le réseau Compose — et la sécurité qui va avec.

**La gestion fine du démarrage.** Distinguer « démarré » de « prêt » (healthcheck + `condition: service_healthy`) te distingue de celui dont la pile crashe aléatoirement selon qui démarre en premier.

**Et la prudence sur les volumes.** Connaître par cœur la différence `down` / `down -v`, et ne jamais taper `-v` par réflexe, est exactement le genre de rigueur qui évite les catastrophes de données en production.

---

## 📚 À lire

**Documentation Docker → *Compose* (Overview, Compose file reference)** : la référence officielle du format `compose.yaml` — services, networks, volumes, `depends_on`, healthchecks.

**Docker → *Compose in production* et *Multiple Compose files*** : la séparation dev/prod et l'usage de Compose en production.

**Awesome Compose (dépôt GitHub officiel)** : des exemples de piles réelles (app + base + proxy) dans plusieurs langages — parfait pour comparer avec tes trois backends.

Relis la leçon 06 (chaque service est un conteneur), la leçon 05 (Nginx, que tu intègres ici), la leçon 02 (`depends_on` ≈ `After=`, `logs` ≈ `journalctl`) et le palier 7 (statelessness, volumes).

---

## 🤖 Le mini-projet à demander à l'IA

Assembler ta pile complète avec Compose :

> « Je suis en formation de développeur, palier 8 (DevOps). J'ai dockerisé mes backends (leçon 06). Je veux maintenant assembler, avec Docker Compose, une pile complète : mon application, sa base PostgreSQL, et Nginx en reverse proxy. Sans me donner un compose.yaml à copier sans comprendre, guide-moi service par service : comment déclarer chaque service, comment l'app joint la base par son NOM (db) et non une IP, où déclarer le volume des données, et pourquoi seul le proxy expose des ports. Explique-moi chaque ligne. »

Puis l'ordre de démarrage et les pièges :

> « Aide-moi à gérer l'ordre de démarrage pour que mon app n'essaie pas de joindre la base avant qu'elle soit PRÊTE : explique-moi depends_on, pourquoi "démarré" ne veut pas dire "prêt", et comment un healthcheck + condition: service_healthy résout ça (fais le lien avec After= de systemd, leçon 02). Puis insiste sur la différence entre docker compose down et down -v, et sur le fait de ne jamais mettre mes secrets dans le compose.yaml versionné mais dans un .env. »

---

## 🛠️ À faire

> Comprends chaque commande avant de l'exécuter. Attention à `down -v`.

1. **⭐ La pile de base** : écris un `compose.yaml` avec deux services — ton backend (construit depuis ton `Dockerfile`, leçon 06) et sa base PostgreSQL. Démarre avec `docker compose up -d`.
2. **La communication par nom** : configure l'app pour joindre la base via `db:5432` (le nom du service), pas une IP. Vérifie que l'app lit et écrit bien dans la base.
3. **⭐ Le volume** : déclare un volume pour la base. Insère des données, fais `docker compose down`, puis `up` : vérifie que les données **persistent**. Ensuite, comprends ce que `down -v` ferait (sans forcément le lancer sur tes données).
4. **Ajouter le proxy** : ajoute un service Nginx (leçon 05) qui route vers ton app, et fais en sorte que **seul** le proxy expose les ports 80/443. L'app et la base ne sont pas exposées au monde.
5. **⭐ L'ordre de démarrage** : ajoute un healthcheck sur la base et `depends_on: condition: service_healthy` sur l'app. Vérifie que l'app attend que la base soit prête (et non juste démarrée).
6. **Les secrets** : mets le mot de passe de la base dans un `.env` non versionné, référence-le par `${...}` dans le `compose.yaml`, et vérifie que le `.env` est bien dans `.gitignore`.
7. **Piloter et diagnostiquer** : utilise `docker compose ps`, `logs -f`, `exec`. Fais échouer un service (mauvaise variable) et trouve la cause dans les logs.
8. **Dev vs prod** : crée une surcharge de développement (monter le code pour le voir changer sans reconstruire) et explique par écrit ce qui différerait en production.
9. **Le lien** : dans ton journal, explique comment Compose assemble les conteneurs de la leçon 06, intègre le proxy de la leçon 05, et reprend les notions de volume (données) et de réseau privé (base non exposée).

<details>
<summary>Corrections et points de contrôle</summary>

**1-2.** Chaque bloc sous `services:` est un conteneur (leçon 06), mais Compose ajoute l'essentiel : un **réseau privé** où chaque service a un nom DNS égal à sa clé. L'app joint donc la base via `db:5432`, pas via une IP ou `localhost` (qui, dans le conteneur de l'app, désignerait l'app elle-même). Cette communication par nom est ce qui rend la même configuration portable d'une machine à l'autre.

**3.** La persistance tient au volume déclaré, pas au conteneur. `docker compose down` supprime les **conteneurs** mais garde les **volumes** : tes données survivent, et `up` recrée des conteneurs frais branchés sur le même volume. `down -v` supprime **aussi** les volumes — données perdues. C'est la *statelessness* du palier 7 à l'échelle de la pile : conteneurs jetables, état dans les volumes. Et c'est le garde-fou : `-v` se tape en connaissance de cause, jamais par habitude.

**4.** La discipline de sécurité (leçon 04) appliquée à la pile : seul le proxy publie des ports vers le monde (`ports: 80, 443`). L'app et la base n'ont pas de `ports:` — elles ne sont joignables que par les autres services sur le réseau privé. Une base sans `ports:` est invisible d'Internet, ce qui est exactement voulu (on y accède par tunnel SSH si besoin, leçon 03).

**5.** « Démarré » ≠ « prêt ». `depends_on` lance la base avant l'app, mais la base met quelques secondes à accepter des connexions ; si l'app se connecte trop tôt, elle crashe. Le healthcheck (`pg_isready`) teste que la base **répond vraiment**, et `condition: service_healthy` fait attendre l'app jusque-là. C'est le `After=` de systemd (leçon 02), affiné : on attend l'état « prêt », pas seulement « lancé ». Ce détail élimine une classe de pannes de démarrage aléatoires.

**9.** La synthèse : Compose est l'assembleur. Il prend les conteneurs de la leçon 06 (ton app depuis ton Dockerfile, la base et le proxy depuis des images publiques), les met sur un réseau privé où ils se joignent par nom, persiste les données dans des volumes, n'expose que le proxy au monde (leçon 04-05), et gère l'ordre de démarrage (leçon 02). Tout le système — qui demandait une page de `docker run` et de la configuration manuelle — tient dans un fichier versionnable, démarré par une commande. C'est le niveau d'orchestration juste pour cette formation et pour une large part des projets réels.
</details>

---

## ✅ Acquis si…

- [ ] J'écris un `compose.yaml` qui réunit app, base et proxy.
- [ ] Mes services communiquent par leur **nom** sur le réseau privé, pas par IP.
- [ ] Je persiste les données dans un volume déclaré, et je distingue `down` de `down -v`.
- [ ] Je n'expose au monde que le proxy ; la base reste sur le réseau privé.
- [ ] Je gère l'ordre de démarrage avec `depends_on` + healthcheck (prêt ≠ démarré).
- [ ] Je garde les secrets dans un `.env` non versionné, pas dans le `compose.yaml`.
- [ ] Je pilote et diagnostique la pile (`up`, `down`, `ps`, `logs -f`, `exec`).
- [ ] Je sais séparer une configuration de développement d'une configuration de production.

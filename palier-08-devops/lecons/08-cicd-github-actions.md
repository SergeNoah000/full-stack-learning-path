# Leçon 08 — CI/CD avec GitHub Actions : workflows, secrets, environnements

> 🎯 **À la fin de cette leçon** : à chaque push, tes tests tournent automatiquement, et une version qui passe peut se déployer toute seule — tu ne livres plus « à la main ».
> ⏱️ 6 h · **Prérequis** : Git/GitHub (palier 0), les tests (palier 4, leçon 10), Docker (leçon 06).

> ⚠️ Rappel du garde-fou : un workflow de déploiement a les clés de ton serveur. Comprends ce qu'il exécute — un mauvais script de déploiement s'exécute automatiquement, sans que tu puisses intervenir.

---

## De quoi on parle

**CI/CD** réunit deux pratiques enchaînées :

- **CI** — *Intégration Continue* : à chaque modification poussée, une machine automatique récupère le code, installe les dépendances, lance les **tests** et les vérifications (lint, build). Si quelque chose casse, tu es prévenu **tout de suite**, avant que ça n'atteigne les autres.
- **CD** — *Déploiement (ou Livraison) Continu* : quand la CI est verte, le code peut être **déployé automatiquement** (ou mis à disposition pour un déploiement en un clic).

**GitHub Actions** est le système de CI/CD intégré à GitHub : tu décris des **workflows** dans des fichiers YAML (`.github/workflows/`), déclenchés par des événements (un push, une *pull request*, un tag). Chaque workflow enchaîne des **jobs** faits d'**étapes** (installer, tester, construire l'image, déployer).

C'est l'automatisation de tout ce que tu faisais à la main jusqu'ici : les tests que tu lançais toi-même (palier 4), l'image Docker que tu construisais (leçon 06), le déploiement sur le serveur (leçons 02-03). La machine le fait, à chaque fois, sans oubli.

---

## À quoi ça sert, concrètement

**Parce que « ça passe chez moi » ne suffit pas.** La CI exécute tes tests dans un environnement **propre et neutre**, à chaque push. Elle attrape ce qui marche sur ta machine mais casse ailleurs (une dépendance oubliée, un test qui dépend de ton état local). C'est le filet collectif, en plus de tes tests locaux.

**Parce qu'elle protège la branche principale.** Avec les bonnes règles, une *pull request* ne peut être fusionnée que si la CI est verte. Le code cassé n'entre jamais dans `main`. Pour une équipe (ou tes apprenants sur leurs branches, palier 0), c'est ce qui garde la base saine en permanence.

**Parce que le déploiement manuel est lent et risqué.** Déployer à la main (se connecter, tirer le code, redémarrer, prier) est source d'erreurs et d'oublis, surtout sous stress. La CD le rend **reproductible** : la même suite d'étapes, exécutée à l'identique à chaque fois. On déploie plus souvent, plus sereinement.

**Et parce que c'est un standard attendu.** Tout projet professionnel a une CI/CD. Savoir lire un workflow, en écrire un, comprendre pourquoi un build échoue, est une compétence de base. Un développeur qui « ne fait pas de CI » détonne aujourd'hui.

---

## Où ça intervient dans le développement

La CI/CD s'intercale entre ton push et la production :

```
   git push / pull request   (palier 0)
        ▼  déclenche
   GitHub Actions :
     JOB "test"  : installer → lint → TESTS (palier 4) → build        ← la CI
        ▼  si vert
     JOB "build" : construire l'image Docker (leçon 06) → la pousser   ← dans un registre
        ▼  si vert (et sur main, ou sur approbation)
     JOB "deploy": se connecter au serveur (SSH, leçon 03) → déployer  ← la CD
        ▼
   Serveur : nouvelle version en service (systemd/Compose, leçons 02/07)
```

Trois ancrages.

**Elle automatise tes tests du palier 4.** La commande de test que tu lançais à la main (`npm test`, `pytest`) devient une étape de workflow, exécutée à chaque push. La CI est la raison d'être « sociale » des tests : ils protègent tout le monde, automatiquement.

**Elle construit et pousse l'image Docker (leçon 06).** Le `docker build` que tu faisais localement devient une étape automatique ; l'image est poussée dans un registre (GitHub Container Registry), prête à être déployée. La reproductibilité de Docker rend le déploiement fiable.

**Elle se connecte au serveur par SSH (leçon 03).** Le déploiement automatique utilise une **clé dédiée** (stockée en secret GitHub) pour se connecter au serveur et y lancer le déploiement (tirer la nouvelle image, `docker compose up` ou `systemctl restart`). Tout ce que tu as appris sur SSH et les services sert ici.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire un premier workflow qui lance tes tests à chaque push, le voir passer au vert (ou au rouge), ajouter la construction de l'image Docker, stocker des secrets, et préparer un job de déploiement vers ton VPS — en comprenant chaque étape, car ce job a les clés du serveur.

### En équipe, en entreprise

**La CI est une barrière de fusion.** Les *branch protection rules* de GitHub exigent une CI verte (et souvent une revue) avant de fusionner dans `main`. Une PR rouge ne se fusionne pas. C'est le garde-fou de la qualité collective.

**Les secrets ne sont jamais dans le code.** Clés de déploiement, jetons, mots de passe : stockés dans les **secrets GitHub** (chiffrés), injectés dans le workflow à l'exécution, jamais écrits dans le YAML versionné. C'est la règle « secrets hors du code » (paliers 4, 6, leçon 07), appliquée à la CI/CD.

**Les environnements séparent staging et production.** On déploie d'abord en pré-production (staging) automatiquement, puis en production après une **approbation manuelle** (un *environment* GitHub protégé). Le déploiement en prod reste une décision, même automatisée.

**Le cache accélère les workflows.** Réinstaller toutes les dépendances à chaque run est lent ; on met en cache (`node_modules`, images Docker). Un workflow lent, c'est une équipe qui attend — l'optimiser a de la valeur.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : lire le résultat d'un workflow (vert/rouge), comprendre pourquoi un job échoue, relancer un workflow, lire les logs d'un run.

Régulièrement : écrire/modifier un workflow (tests, lint, build), gérer les secrets, déclencher sur `push`/`pull_request`, mettre en cache les dépendances.

Rare ou avancé : les matrices (tester sur plusieurs versions), les workflows réutilisables, les *self-hosted runners*, les déploiements complexes multi-environnements, OIDC pour le cloud. À connaître de nom ; tu les creuseras au besoin.

---

## La mécanique

### Un workflow de CI minimal (les tests)

```yaml
# .github/workflows/ci.yml
name: CI
on:                                 # QUAND déclencher
  push:
    branches: [main]
  pull_request:                     # aussi sur chaque PR

jobs:
  test:
    runs-on: ubuntu-latest          # une machine neuve, propre, à chaque fois
    steps:
      - uses: actions/checkout@v4   # récupérer le code
      - uses: actions/setup-node@v4 # installer Node
        with:
          node-version: 20
          cache: npm                # mettre en cache les dépendances
      - run: npm ci                 # installer (proprement, depuis le lock)
      - run: npm run lint           # vérifier le style
      - run: npm test               # ⭐ LES TESTS (palier 4)
```

Lis-le de haut en bas. `on:` décrit les déclencheurs (push sur `main`, et chaque PR). `runs-on` donne une machine **neuve** à chaque exécution — c'est ce qui rend la CI honnête : aucun résidu de ta machine. Les `steps` enchaînent : récupérer le code, installer Node, installer les dépendances, linter, **tester**. Si une étape échoue, le job est rouge et tu es notifié. Note le `cache: npm` qui évite de tout réinstaller à chaque fois.

### Lire un résultat et un échec

```
Onglet "Actions" de GitHub → chaque run, vert (✓) ou rouge (✗).
Un job rouge → clique dessus → la step qui a échoué est dépliée, avec ses logs.
On lit le log de la step rouge comme un message d'erreur : il dit QUOI a cassé.
```

Le réflexe : un workflow rouge n'est pas une fatalité, c'est un **diagnostic**. On ouvre le run, on trouve l'étape rouge, on lit son log — exactement comme on lit `journalctl` (leçon 02) ou `error.log` (leçon 05). La cause y est presque toujours.

### ⭐ Les secrets

```yaml
      - name: Déployer
        env:
          SSH_KEY: ${{ secrets.DEPLOY_SSH_KEY }}   # injecté depuis les secrets GitHub
          SERVER: ${{ secrets.DEPLOY_HOST }}
        run: ./deploy.sh
```

Les secrets se définissent dans GitHub (*Settings → Secrets and variables → Actions*), chiffrés, et s'injectent dans le workflow par `${{ secrets.NOM }}`. Ils n'apparaissent **jamais** dans le YAML (qui est versionné et public sur un dépôt ouvert) ni dans les logs (GitHub les masque). La clé SSH de déploiement, les jetons de registre, les mots de passe vivent là. C'est la règle des secrets hors du code, appliquée à l'automatisation.

### Construire et pousser l'image Docker

```yaml
  build:
    needs: test                     # seulement si les tests passent
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v6
        with:
          push: true
          tags: ghcr.io/moi/mon-app:${{ github.sha }}   # tag = l'identifiant du commit
```

`needs: test` enchaîne les jobs : on ne construit l'image **que si** les tests sont verts. L'image (leçon 06) est construite puis poussée dans un registre (ici GitHub Container Registry), étiquetée avec l'identifiant du commit — ainsi on sait exactement quelle version correspond à quelle image. C'est l'automatisation du `docker build`/`push` de la leçon 06.

### ⭐ Le déploiement (CD), et l'approbation

```yaml
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment: production         # ⭐ environnement protégé → peut exiger une APPROBATION
    steps:
      - name: Déployer par SSH
        run: |
          # se connecter au serveur (clé en secret) et déclencher le déploiement
          # ex. : tirer la nouvelle image + docker compose up -d (leçon 07)
```

Le job `deploy` se connecte au serveur (SSH, leçon 03, avec une clé en secret) et déclenche la mise à jour (tirer la nouvelle image, `docker compose up -d` — leçon 07 — ou `systemctl restart` — leçon 02). L'`environment: production` permet d'exiger une **approbation manuelle** : même automatisé, le passage en production reste une décision humaine. C'est le bon équilibre entre automatisation et contrôle.

> ⚠️ **Ce job a les clés de ton serveur.** Un script de déploiement s'exécute **automatiquement**, sans que tu puisses l'interrompre en cours. Relis `deploy.sh` comme tu relirais une commande `sudo` (leçon 01) : une erreur dedans s'exécute sur ta production. C'est le garde-fou du palier, à son niveau le plus critique.

### La pipeline complète

```
push → [test] ──vert──▶ [build image] ──vert──▶ [deploy staging] ──approbation──▶ [deploy prod]
         │ rouge : stop, on est notifié, rien n'est déployé
```

Chaque étape conditionne la suivante (`needs:`). Un échec en amont arrête tout : du code cassé ne peut pas être déployé. C'est la chaîne qui va de « j'ai poussé » à « c'est en production », avec des garde-fous à chaque maillon.

---

## Les problèmes que tu vas rencontrer

**« La CI est rouge mais ça marche chez moi. »** C'est précisément son rôle : l'environnement neuf de la CI révèle une dépendance non déclarée, un fichier non commité, un test qui dépendait de ton état local. Lis le log de l'étape rouge — la différence avec ta machine y est.

**« Mon secret apparaît en clair / n'est pas reconnu. »** Il n'est pas défini dans les secrets GitHub, ou mal nommé (`${{ secrets.NOM }}`). Ne le colle jamais dans le YAML. GitHub masque les secrets dans les logs, mais seulement ceux qu'il connaît comme secrets.

**« Le workflow ne se déclenche pas. »** Le `on:` ne correspond pas (mauvaise branche, mauvais événement), ou le fichier n'est pas dans `.github/workflows/`, ou le YAML est invalide. Vérifie l'indentation (le YAML y est sensible) et les déclencheurs.

**« Le déploiement échoue à se connecter au serveur. »** Problème SSH (leçon 03) : la clé de déploiement (en secret) n'est pas dans `authorized_keys` du serveur, ou le host/port est faux. Teste la clé hors CI d'abord.

**« Mon workflow est très lent. »** Pas de cache : tu réinstalles tout à chaque run. Active le cache des dépendances (et des couches Docker). Une équipe attend chaque run ; la vitesse compte.

**« J'ai déployé du code cassé automatiquement. »** La CD sans CI solide est dangereuse : si les tests ne couvrent pas assez, la CD déploie des bugs. La CD n'est sûre que derrière une CI qui teste vraiment (palier 4). Et garde une approbation manuelle pour la prod.

---

## Ce qu'on te demandera

En **test DevOps**, la CI/CD est quasi systématique : « qu'est-ce que la CI ? la CD ? », « que mets-tu dans un pipeline de CI ? » (install, lint, tests, build), « où stockes-tu les secrets de déploiement ? », « pourquoi exécuter les tests sur une machine neuve ? ». On peut te demander de lire ou écrire un workflow simple.

On peut demander : « comment empêches-tu du code cassé d'entrer dans `main` ? » (CI verte requise + protection de branche), « différence staging/prod ? », « pourquoi une approbation avant la prod ? ».

En **mission**, lire et corriger un workflow rouge, ajouter une étape, gérer un secret sont des gestes courants dès le premier jour.

---

## Ce qui te démarquera

**Comprendre que la CI rend les tests collectifs.** Relier la CI aux tests du palier 4 — « mes tests ne me protègent pas que moi, la CI les fait tourner pour toute l'équipe à chaque push » — montre que tu vois le but social de la qualité, pas juste la mécanique.

**La discipline des secrets.** Savoir qu'une clé de déploiement vit dans les secrets GitHub, jamais dans le YAML, et qu'elle donne accès au serveur, montre une hygiène de sécurité mûre.

**L'équilibre automatisation / contrôle.** Automatiser jusqu'au staging, mais garder une approbation manuelle pour la production, est exactement le bon dosage — ni tout à la main, ni tout en aveugle.

**Et relier toute la chaîne.** Montrer que la CI/CD orchestre ce que tu sais déjà faire — tests (palier 4), image Docker (leçon 06), SSH (leçon 03), Compose/systemd (leçons 07/02) — prouve que tu comprends le déploiement de bout en bout, pas une recette isolée.

---

## 📚 À lire

**Documentation GitHub Actions → *Quickstart*, *Understanding workflows*, *Using secrets*, *Using environments*** : la référence officielle, claire, avec des exemples pour chaque concept.

**GitHub Actions → *Workflow syntax*** : la référence du YAML (`on`, `jobs`, `steps`, `needs`, `env`) à consulter en écrivant.

**Les actions du Marketplace** (`actions/checkout`, `setup-node`, `docker/build-push-action`) : leurs README expliquent les paramètres courants.

Relis le palier 4, leçon 10 (tests) : la CI les exécute automatiquement. Et la leçon 06 (image Docker), la leçon 03 (SSH de déploiement), la leçon 07 (Compose au bout de la chaîne).

---

## 🤖 Le mini-projet à demander à l'IA

Construire ta pipeline, étape par étape :

> « Je suis en formation de développeur, palier 8 (DevOps). Je veux mettre en place une CI/CD avec GitHub Actions sur un de mes projets. Sans me donner un workflow complet à copier sans comprendre, guide-moi étape par étape : d'abord un workflow de CI qui, à chaque push et chaque pull request, récupère le code, installe les dépendances et lance mes tests (palier 4) sur une machine neuve. Explique-moi pourquoi "machine neuve" est important, et comment lire un run rouge pour trouver l'étape qui a cassé. »

Puis le build, les secrets et le déploiement prudent :

> « Aide-moi à étendre ma pipeline : un job qui construit mon image Docker (leçon 06) seulement si les tests passent (needs), puis un job de déploiement par SSH vers mon VPS (leçon 03). Insiste lourdement sur : les secrets GitHub (la clé SSH ne doit JAMAIS être dans le YAML), l'environnement "production" avec approbation manuelle, et le fait que ce job de déploiement a les clés de mon serveur — donc que je dois comprendre chaque ligne de mon script de déploiement avant de l'automatiser. »

---

## 🛠️ À faire

1. **⭐ La CI des tests** : sur un de tes projets avec des tests (palier 4), écris un workflow `.github/workflows/ci.yml` qui installe les dépendances et lance les tests à chaque `push` et chaque `pull_request`. Pousse et vérifie qu'il passe au vert.
2. **Voir le rouge** : casse volontairement un test, pousse, et constate le run rouge. Ouvre-le, trouve l'étape qui a échoué, lis son log. Répare et vois le vert revenir.
3. **La machine neuve** : fais échouer la CI à cause d'une dépendance que tu avais localement mais pas déclarée. Comprends pourquoi la CI l'attrape et pas toi.
4. **Le lint** : ajoute une étape de vérification de style (lint), et fais-la échouer puis passer.
5. **⭐ Les secrets** : ajoute un secret dans GitHub (par ex. une valeur factice), injecte-le dans une étape avec `${{ secrets.NOM }}`, et vérifie qu'il n'apparaît **pas** en clair dans les logs.
6. **Construire l'image** : ajoute un job `build` qui, **après** les tests (`needs: test`), construit ton image Docker (leçon 06) et la pousse dans GitHub Container Registry.
7. **⭐ Le déploiement (prudemment)** : prépare un job `deploy` qui se connecte à ton VPS par SSH (clé en secret, leçon 03) et déclenche la mise à jour (`docker compose up -d`, leçon 07). **Relis ton script de déploiement ligne par ligne** avant de l'activer.
8. **L'approbation** : configure un environnement `production` protégé qui exige ton approbation manuelle avant le déploiement en prod. Vérifie que le job attend ton feu vert.
9. **Protéger `main`** : active une règle de protection de branche qui exige une CI verte avant de fusionner une PR. Teste avec une PR rouge (non fusionnable) puis verte.
10. **Le lien** : dans ton journal, dessine ta pipeline complète (push → test → build → deploy) et associe chaque étape à ce que tu faisais à la main avant (tests palier 4, build leçon 06, SSH leçon 03, Compose leçon 07).

<details>
<summary>Corrections et points de contrôle</summary>

**1-3.** Le cœur de la CI : exécuter tes tests (palier 4) sur une machine **neuve** à chaque push. « Neuve » est la clé — aucun résidu de ta configuration locale, donc la CI révèle les dépendances non déclarées, les fichiers non commités, les tests qui dépendaient de ton état. C'est pourquoi « rouge en CI, vert chez moi » n'est pas un bug de la CI mais une information précieuse : la différence entre les deux environnements est exactement ce qui casserait en production. Et un run rouge se lit comme un diagnostic : on ouvre l'étape rouge, on lit son log, la cause y est (comme `journalctl`, leçon 02).

**5.** Les secrets GitHub sont chiffrés, injectés par `${{ secrets.NOM }}`, et masqués dans les logs. La règle absolue : **jamais dans le YAML** (versionné, souvent public). Une clé SSH de déploiement collée dans un workflow serait visible de quiconque lit le dépôt — une fuite d'accès au serveur. C'est « secrets hors du code » (paliers 4, 6, leçon 07) appliqué à l'automatisation.

**6-7.** L'enchaînement par `needs:` est ce qui rend la pipeline sûre : on ne construit l'image **que si** les tests passent, et on ne déploie **que si** l'image est construite. Du code cassé est stoppé avant de pouvoir atteindre la production. Le job de déploiement réutilise tout le palier : SSH (leçon 03) avec une clé dédiée en secret, puis Compose (leçon 07) ou systemd (leçon 02) pour appliquer la nouvelle version.

**7 (garde-fou).** Le point le plus sensible du palier. Un job de déploiement a les clés de ton serveur et s'exécute **automatiquement** : tu ne peux pas l'arrêter en cours comme une commande au clavier. Une erreur dans `deploy.sh` (un mauvais chemin, un `rm` trop large) s'exécute sur ta production, sans filet. D'où la règle : relis ton script de déploiement aussi attentivement qu'une commande `sudo` (leçon 01), et teste-le sur un environnement jetable avant de l'automatiser.

**8-9.** L'équilibre automatisation/contrôle : la CD peut tout automatiser jusqu'au staging, mais l'`environment: production` protégé exige une **approbation manuelle** — le passage en prod reste une décision humaine. Et la protection de branche (CI verte requise) garantit que `main` reste toujours déployable. Ensemble : rapidité (tout est automatisé) et sûreté (rien de cassé n'entre, rien ne part en prod sans feu vert).
</details>

---

## ✅ Acquis si…

- [ ] J'écris un workflow qui lance mes tests à chaque push et chaque pull request.
- [ ] Je comprends pourquoi la CI tourne sur une machine neuve, et ce que ça révèle.
- [ ] Je lis un run rouge et je trouve l'étape qui a échoué dans ses logs.
- [ ] Je stocke les secrets dans GitHub et je ne les mets jamais dans le YAML.
- [ ] J'enchaîne les jobs avec `needs:` (build seulement si les tests passent).
- [ ] Je construis et pousse une image Docker depuis la CI.
- [ ] Je prépare un déploiement par SSH en comprenant chaque ligne du script.
- [ ] J'exige une approbation manuelle avant la production et une CI verte avant de fusionner `main`.

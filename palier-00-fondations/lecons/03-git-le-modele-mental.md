# Leçon 03 — Git : le modèle mental

> 🎯 **À la fin de cette leçon** : tu comprends ce qu'est un commit, une branche, une fusion — et tu cesses de taper des commandes Git par superstition.
> ⏱️ 3 h, dont une heure de pratique interactive · **Prérequis** : leçons 01–02.
> 📒 La partie **procédurale** (clé SSH, commandes du quotidien, tableau des réparations) est dans le [guide Git & GitHub](../../guides/git-et-github.md). Ici, on construit la compréhension — parce que c'est elle qui manque, pas les commandes.

---

## Git, c'est quoi

Git est un **logiciel de gestion de versions** installé sur ta machine. Son travail : mémoriser l'histoire complète d'un projet, et te permettre d'y revenir.

Le mot « sauvegarde » est trompeur, et c'est la première chose à corriger. Une sauvegarde conserve l'état actuel. Git conserve **tous les états successifs**, avec pour chacun son auteur, sa date, et surtout une phrase expliquant *pourquoi* ce changement a été fait. Ce n'est pas une copie de sécurité : c'est une machine à voyager dans le temps, doublée d'un journal de décisions.

Concrètement, quand tu tapes `git init` dans un dossier, Git y crée un sous-dossier caché `.git`. **Tout l'historique vit là**, dans ce seul dossier, sur ta machine. Supprime `.git`, tu gardes tes fichiers et tu perds l'histoire. Copie `.git` avec le projet, tu emportes tout. C'est aussi pour ça que Git fonctionne parfaitement sans aucune connexion internet : il est **complet en local**, et c'est ce qui le distingue des systèmes de versions plus anciens.

Trois notions à poser tout de suite, parce que tout le reste en découle.

Un **commit** est un instantané de l'ensemble du projet à un moment donné, avec un message et un identifiant unique. Ce n'est pas « les lignes que j'ai modifiées » : c'est l'état complet, à cet instant, et c'est ce qui permet d'y retourner.

Une **branche** est, techniquement, un simple **pointeur mobile vers un commit**. Rien d'autre. Pas une copie du projet, pas un dossier séparé : une étiquette. C'est pourquoi créer une branche est instantané et gratuit, et pourquoi on en crée sans compter.

**`HEAD`** est un autre pointeur, qui dit « où tu te trouves » dans l'histoire — en général sur le dernier commit de la branche courante.

---

## À quoi ça sert, concrètement

**À pouvoir revenir en arrière sans angoisse.** Avant Git, on faisait `projet_final.zip`, puis `projet_final_v2.zip`, puis `projet_final_vraiment_final.zip`. On ne savait plus ce qui avait changé entre les deux, on ne pouvait pas revenir proprement, et on n'osait rien casser. Avec Git, tu peux tout tenter : si c'est raté, tu reviens au dernier commit en une commande.

**À expérimenter sans risque.** Tu veux essayer une refonte complète de ton affichage ? Tu crées une branche, tu travailles, et `main` reste intacte pendant ce temps. Si l'expérience échoue, tu supprimes la branche et personne n'en saura rien.

**À travailler avec d'autres.** C'est la raison pour laquelle Git a été écrit (par Linus Torvalds, pour le noyau Linux). Plusieurs personnes modifient le même projet en parallèle, et Git sait fusionner leurs histoires — en te posant une question quand il ne peut pas décider seul.

**À comprendre un projet qu'on ne connaît pas.** `git log` et `git blame` racontent pourquoi le code est comme il est. Quand tu arriveras sur un projet existant — c'est-à-dire dans toutes tes missions — l'historique sera ta meilleure documentation.

---

## Où ça intervient dans le développement

Git se situe **entre ton éditeur et tout le reste**. C'est le premier maillon de la chaîne d'outillage, celui qui précède GitHub (leçon 04), les tests automatiques et le déploiement.

```
   tu modifies des fichiers
        ↓
   GIT  (ta machine : l'histoire complète, hors ligne)
        ↓   push
   GitHub  (le point de rendez-vous)
        ↓
   tests automatiques → déploiement           ← paliers 3 et 8
```

Mais il intervient surtout **dans ton rythme de travail**, et c'est ce que les débutants sous-estiment. Git structure la journée : tu commites à chaque unité de travail terminée, tu crées une branche à chaque nouvelle fonctionnalité, tu fermes ta session par un commit même inachevé. C'est ce découpage qui rend un travail reprenable le lendemain — et relisible dans six mois.

Il intervient aussi dans ton **débogage**, de façon moins évidente. Quand une fonctionnalité qui marchait hier ne marche plus, l'historique Git te dit ce qui a changé entre-temps. `git diff` est un outil de diagnostic autant qu'un outil de version, et `git bisect` (plus tard) trouve en cinq essais le commit qui a introduit un bug parmi cent.

Enfin, une chose à savoir dès maintenant : **Git ne concerne que le code et les fichiers texte**. Pas les bases de données, pas les fichiers uploadés par les utilisateurs, pas les secrets. Chacun a son propre mécanisme — les migrations pour la structure de base au palier 4, les sauvegardes au palier 8, les variables d'environnement pour les secrets. Confondre les deux mondes est une erreur d'architecture classique.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Ton cycle sera toujours le même : `git status` pour voir où tu en es, du travail, `git add` puis `git commit` pour figer, et `git log` de temps en temps pour relire. Tu commiteras plusieurs fois par session — pas une fois par jour. Le bon rythme est « dès qu'une petite chose fonctionne ».

Tu prendras aussi l'habitude de commiter **avant** de tenter quelque chose de risqué. C'est le filet : si ta tentative tourne mal, `git restore .` ou `git reset --hard` te ramène à l'état connu. Cette habitude change complètement le rapport au code — on ose, parce qu'on peut revenir.

### En équipe, en entreprise

Tu découvriras que l'historique est **lu**, et qu'il est jugé. Une suite de commits « update », « fix », « encore un essai » rend un projet impossible à comprendre ; et quand un bug apparaît en production, c'est dans cet historique qu'on cherche. On te demandera donc des commits **atomiques** (une idée par commit) et des messages descriptifs.

Tu rencontreras l'**index** (la zone de préparation, détaillée plus bas), que tout le monde ignore au début et que les développeurs expérimentés utilisent constamment via `git add -p` : la possibilité de ne commiter qu'une partie de ses modifications.

Tu verras aussi des pratiques d'équipe : des branches nommées selon une convention, des `rebase` pour garder un historique linéaire, des `squash` pour regrouper les commits d'une PR. Tu n'as pas besoin de les maîtriser aujourd'hui ; tu dois seulement savoir qu'elles existent et que leur but est la **lisibilité de l'histoire**.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : `status`, `add`, `commit`, `log`, `diff`, `switch`, `merge`. C'est tout. Sept commandes, qui couvrent l'essentiel de dix-huit mois.

Quelques fois par mois, et c'est ce qui distingue ceux qui savent se sortir d'affaire : `stash` (mettre de côté), `reset --soft` (défaire un commit en gardant le travail), `restore` (annuler des modifications non commitées), `revert` (annuler proprement un commit partagé), `reflog` (retrouver ce qu'on croit perdu).

Rare, et hors sujet aujourd'hui : `rebase -i`, `cherry-pick`, `bisect`, les sous-modules, les hooks, `worktree`. Tu les apprendras chacun le jour où tu auras le problème correspondant. Les mémoriser maintenant serait du temps perdu — et, pire, ça te donnerait l'illusion de connaître Git sans en avoir le modèle mental.

---

## La mécanique : les trois zones

Voici le concept qui explique **90 % des incompréhensions** de débutant. Un fichier modifié traverse trois zones avant d'entrer dans l'histoire.

```
   Répertoire de travail        Index (staging)            Dépôt (.git)
   ┌─────────────────┐         ┌─────────────────┐       ┌─────────────────┐
   │ tes fichiers    │  add →  │ ce qui partira  │ commit→│ l'historique    │
   │ tels qu'ils     │         │ au prochain     │       │ permanent       │
   │ sont maintenant │         │ commit          │       │                 │
   └─────────────────┘         └─────────────────┘       └─────────────────┘
        ← restore                   ← reset                  ← switch
```

La question que tout le monde se pose : **pourquoi cette zone intermédiaire ?** Pourquoi ne pas commiter directement ?

Parce qu'elle te permet de choisir **ce que** tu commites. Voici la situation réelle : tu as passé deux heures à corriger un bug, et au passage tu as aussi reformaté un fichier et ajouté un commentaire ailleurs. Si tu commites tout ensemble, tu obtiens un commit fourre-tout, impossible à relire et impossible à annuler proprement. L'index te permet de faire trois commits propres à partir du même travail :

```bash
git add src/calculs.js && git commit -m "fix total calculation on empty list"
git add src/styles.css && git commit -m "align card spacing"
git add README.md      && git commit -m "document the list command"
```

Et avec `git add -p`, tu peux même ne prendre qu'une **partie** des modifications d'un fichier, morceau par morceau. C'est l'une des commandes les plus utiles de Git, et elle a un second bénéfice : elle te force à **relire** ce que tu commites. Tu y attraperas des `console.log` oubliés.

Garde donc en tête : `git status` te montre toujours ces trois zones, et c'est pour ça qu'il faut la taper tout le temps. « Modifications qui ne seront pas validées » = répertoire de travail. « Modifications qui seront validées » = index.

---

## La mécanique : branches et fusion

Puisqu'une branche n'est qu'une étiquette sur un commit, visualise :

```
          A ── B ── C          ← main
                     └── D ── E ← feat/filtre   (HEAD est ici)
```

`main` et `feat/filtre` sont deux post-it collés sur deux commits. Créer `feat/filtre` n'a rien copié : Git a juste écrit un nom dans un fichier. Changer de branche déplace `HEAD` et met à jour tes fichiers pour correspondre au commit visé.

Quand tu fusionnes, deux cas. Si `main` n'a pas bougé depuis, Git **avance simplement l'étiquette** (*fast-forward*) : pas de nouveau commit, l'histoire reste linéaire. Si du travail a eu lieu des deux côtés, Git crée un **commit de fusion** à deux parents, qui réunit les deux histoires.

```bash
git switch -c feat/filtre     # créer une branche et y aller
git switch main               # revenir
git merge feat/filtre         # fusionner DANS main (on se place sur la cible)
git branch -d feat/filtre     # retirer l'étiquette après fusion
```

Note bien le principe : **on se place sur la branche qui doit recevoir**, puis on fusionne l'autre dedans. C'est l'inverse de ce que beaucoup supposent au début.

### Résoudre un conflit

Un conflit survient quand les deux branches ont modifié **la même ligne**. Git ne peut pas choisir, alors il te pose la question en insérant des marqueurs dans le fichier :

```js
<<<<<<< HEAD
const titre = "Météo";          // la version de la branche courante
=======
const titre = "Ma Météo";       // la version de la branche fusionnée
>>>>>>> feat/titre
```

La procédure est mécanique : tu ouvres le fichier, tu **choisis ou tu combines** à la main, tu **supprimes les trois lignes de marqueurs**, tu fais `git add fichier`, puis `git commit`. Trois minutes.

Un conflit n'est pas une erreur et ce n'est pas un échec : c'est une **question**. Le seul vrai danger est de paniquer, de cliquer au hasard dans l'interface de son éditeur, ou d'oublier de supprimer un marqueur — ce qui laisse du `<<<<<<<` dans le code et provoque une erreur de syntaxe très déroutante.

### Les trois commandes qui sauvent

```bash
git log --oneline --graph --all --decorate   # voir l'histoire et les étiquettes
git diff                                     # qu'ai-je modifié ?
git reflog                                   # l'historique de mes déplacements : rien n'est perdu
```

`reflog` mérite d'être essayée **aujourd'hui**, à froid, pour savoir qu'elle existe le jour où tu paniqueras. Tant qu'un travail a été commité, il reste récupérable pendant plusieurs semaines, même après un `reset --hard`. C'est ce qui fait de Git un outil sûr plutôt qu'un outil angoissant.

---

## Les problèmes que tu vas rencontrer

**« J'ai perdu mon travail. »** Presque toujours faux. Si c'était commité, `git reflog` le retrouve. Si ce n'était pas commité et que tu as fait `git restore` ou `reset --hard`, là c'est réellement perdu — et c'est l'argument décisif pour **commiter souvent**.

**Tu es sur la mauvaise branche.** Tu as travaillé une heure, et tu réalises que tu es sur `main`. Pas grave : `git switch -c feat/mon-travail` crée une branche ici, avec tes commits, puis tu remets `main` en place.

**Tu as un conflit et tu ne sais plus où tu en es.** `git status` te dit exactement quels fichiers sont en conflit et ce qu'il attend de toi. Et `git merge --abort` annule toute la fusion et te ramène à l'état d'avant : c'est la sortie de secours.

**`git add .` a ajouté des choses indésirables.** `node_modules`, un fichier `.env`, des fichiers temporaires. C'est le signe qu'il manque un `.gitignore` — à écrire **avant** le premier commit. Et prends l'habitude de taper `git status` avant `git commit` : tu verras ce que tu es en train de figer.

**Ton `commit` ouvre un éditeur bizarre et tu es piégé.** Tu as oublié le `-m "message"`. Git a ouvert vim ou nano pour que tu écrives le message. Dans vim : `i` pour écrire, puis `Échap`, puis `:wq`. Dans nano : écris, puis `Ctrl+O`, `Entrée`, `Ctrl+X`. (Et configure ton éditeur préféré, c'est dans le guide.)

**Un fichier déjà commité ne disparaît pas du `.gitignore`.** L'ignorer n'a d'effet que sur les fichiers non suivis. Il faut `git rm --cached fichier` pour arrêter de le suivre — et son contenu reste quand même dans l'historique (voir leçon 04 pour les conséquences quand il s'agit d'un secret).

---

## Ce qu'on te demandera

Git est **systématiquement** évoqué en entretien junior, et toujours sous l'angle de la compréhension, pas de la syntaxe.

Les questions récurrentes : « explique ce qu'est un commit » (et la réponse « un instantané du projet », pas « une sauvegarde de mes modifications »), « à quoi sert l'index / le staging » (et la réponse « choisir ce qu'on commite »), « comment résous-tu un conflit », « qu'est-ce qu'une branche ». Celle sur l'index est particulièrement discriminante : beaucoup de candidats tapent `git add .` depuis deux ans sans savoir ce que ça fait.

En **test pratique**, on peut te demander de livrer un exercice sous forme de dépôt Git avec un historique propre. L'historique **fait partie** de l'évaluation : plusieurs commits logiques valent mieux qu'un seul commit « solution ».

Le **premier jour** en équipe, on te demandera de cloner, créer une branche, commiter et ouvrir une PR. Si tu comprends le modèle, tu ne casses rien.

---

## Ce qui te démarquera

**Dessiner le modèle.** Si tu peux dessiner les trois zones et le trajet d'un fichier sur un coin de table, tu es au-dessus de la majorité des juniors — et de pas mal de développeurs confirmés qui utilisent Git par habitude sans l'avoir jamais compris.

**Des commits atomiques, avec de vrais messages.** Un historique où chaque commit fait une chose et où le message explique le *pourquoi*. Ça ne coûte rien et ça se remarque immédiatement.

**Utiliser `git add -p`.** Le signe le plus net de maîtrise de l'index. Et le bénéfice réel est la relecture systématique de son propre travail.

**Savoir réparer, et rester calme.** Sortir un collègue d'un `reset --hard` malheureux avec `reflog`, annuler proprement un commit poussé avec `revert` plutôt qu'avec un `push --force` destructeur. Une seule occasion suffit pour installer une réputation.

**Provoquer des conflits pour s'entraîner.** Presque personne ne le fait, et c'est la raison pour laquelle presque tout le monde panique devant le premier. Vingt minutes aujourd'hui t'épargnent une heure de stress plus tard.

---

## 📚 À lire

**learngitbranching.js.org** est obligatoire dans ce parcours — fais les sections *Introduction* et *Ramping up*, soit environ une heure trente. C'est visuel et interactif : tu **vois** les étiquettes bouger quand tu tapes les commandes. Aucune lecture ne remplace cette expérience, et c'est de loin le meilleur investissement de la leçon.

Ensuite, **The Odin Project → Git Basics** pour la pratique guidée, et *Pro Git* (gratuit sur git-scm.com/book/fr, et disponible en français) dont seuls les chapitres 2 et 3 te concernent aujourd'hui.

Le [guide Git & GitHub](../../guides/git-et-github.md) du parcours reste ta référence pratique pour les procédures et les réparations.

---

## 🤖 Le mini-projet à demander à l'IA

Git s'apprend en cassant des choses dans un dépôt dont on n'a rien à perdre. Fabrique-toi ce terrain :

> « Je suis en formation de développeur, palier 0. Je veux comprendre Git en profondeur, pas juste `add/commit/push`. Fabrique-moi un **scénario d'entraînement** sur un dépôt jetable : donne-moi uniquement les commandes qui **créent les situations**, sans jamais la solution. Je veux rencontrer, dans cet ordre : (1) des modifications dans les trois zones en même temps, que je dois commiter en deux commits séparés ; (2) un historique avec deux branches divergentes ; (3) un conflit de fusion sur deux lignes différentes du même fichier ; (4) un commit à annuler **en gardant** le travail ; (5) un commit « perdu » par un `reset --hard` que je dois retrouver. Après chaque situation, demande-moi d'abord **de décrire ce que je crois voir** avant de me laisser agir. »

Deux autres demandes qui valent le détour :

> « Je viens de taper `git status`, voici sa sortie exacte. Explique-moi ce qu'elle dit, zone par zone, sans me dire quoi faire. »

> « Pose-moi 5 questions d'entretien junior sur Git, une par une, et corrige chaque réponse avant la suivante. Insiste sur l'index et sur les conflits. »

---

## 🛠️ À faire

1. **Dessine à la main** le schéma des trois zones et le trajet d'un fichier. Photographie-le dans ton journal. Si tu ne peux pas le dessiner, tu ne l'as pas compris — relis la section correspondante.
2. Crée un dépôt de test, fais trois commits, puis affiche l'historique en graphe.
3. **L'exercice de l'index** : modifie deux fichiers, puis crée **deux commits séparés**, un par fichier. Recommence avec `git add -p` sur un seul fichier contenant deux modifications distinctes.
4. **Provoque un conflit et résous-le** :
   ```bash
   git switch -c branche-a && echo "version A" > titre.txt && git commit -am "set title A"
   git switch main && echo "version B" > titre.txt && git commit -am "set title B"
   git merge branche-a     # → CONFLIT
   ```
   Résous, commite, et écris la procédure dans ton journal avec tes propres mots.
5. Refais le même conflit, mais cette fois sors-en avec `git merge --abort`. Savoir reculer fait partie de l'exercice.
6. Fais un commit, annule-le **en gardant** les modifications, puis recommite avec un meilleur message.
7. « Perds » un commit avec `git reset --hard HEAD~1`, puis **retrouve-le** avec `git reflog`.
8. Lance `git log --oneline --graph --all --decorate` sur ton dépôt de test après tous ces exercices, et raconte à voix haute ce que tu vois.

<details>
<summary>Corrections et points de contrôle</summary>

**3.**
```bash
git add fichier1.js && git commit -m "add filter function"
git add fichier2.css && git commit -m "adjust card spacing"
```
Avec `git add -p`, Git te présente chaque bloc de modification et attend une réponse : `y` pour l'inclure, `n` pour le sauter, `s` pour découper encore, `q` pour arrêter. C'est exactement l'usage professionnel de l'index.

**4 — ce qu'il faut avoir compris.** Le conflit ne vient pas de Git : il vient du fait que deux histoires ont modifié la même ligne. Git ne peut pas deviner laquelle garder, donc il s'arrête et te demande. Ta procédure devrait mentionner : ouvrir, choisir ou combiner, **supprimer les trois marqueurs**, `add`, `commit`.

**6.** `git reset --soft HEAD~1` : le commit disparaît de l'histoire, tes modifications reviennent **dans l'index**, prêtes à être recommitées. Compare avec `--mixed` (le défaut : les modifications reviennent dans le répertoire de travail, hors index) et `--hard` (qui les détruit). Ces trois niveaux correspondent exactement aux trois zones — et c'est là que le schéma de l'exercice 1 prend tout son sens.

**7.**
```bash
git reflog                  # repère la ligne du commit perdu et note son identifiant
git reset --hard <sha>      # on y retourne
```
La leçon à retenir : **tant qu'un travail a été commité, il est récupérable**. C'est ce qui doit te pousser à commiter souvent, y compris du travail inachevé (`wip: ...`).
</details>

---

## ✅ Acquis si…

- [ ] Je dessine de mémoire les trois zones et le trajet `modifié → indexé → commité`.
- [ ] J'explique ce qu'est un commit (un instantané) et une branche (un pointeur) en une phrase chacun.
- [ ] J'explique **à quoi sert l'index**, avec un cas concret.
- [ ] J'ai créé et résolu un conflit volontairement, et j'ai aussi su l'annuler.
- [ ] Je fais deux commits séparés à partir de deux modifications faites en même temps.
- [ ] J'ai retrouvé un commit « perdu » avec `reflog`.
- [ ] Mes messages de commit sont en anglais, à l'impératif, et expliquent le pourquoi.
- [ ] Je commite **avant** de tenter quelque chose de risqué.

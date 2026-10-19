# Leçon 04 — GitHub et le travail à distance

> 🎯 **À la fin de cette leçon** : ton code vit sur GitHub, tu travailles par branches et Pull Requests comme en entreprise, et tu sais réparer les accidents les plus fréquents.
> ⏱️ 2 h · **Prérequis** : leçon 03 (le modèle mental de Git) + ta clé SSH configurée ([procédure](../../guides/git-et-github.md#2-la-clé-ssh-procédure-complète)).

---

## GitHub, c'est quoi

GitHub est un **site qui héberge des dépôts Git**. Rien de plus, au départ : tu as un projet versionné sur ta machine, tu en envoies une copie complète sur leurs serveurs, et cette copie devient le point de rendez-vous — pour toi d'abord, pour les autres ensuite.

La confusion à dissiper tout de suite : **Git n'est pas GitHub**. Git est le logiciel installé sur ton ordinateur, celui qui enregistre l'histoire de ton code ; il fonctionne parfaitement sans aucune connexion internet. GitHub est un service commercial qui héberge des dépôts Git et ajoute des outils autour. C'est exactement le rapport entre l'email et Gmail : tu peux faire de l'email sans Gmail, et il existe des concurrents (GitLab, Bitbucket, Gitea) qui font la même chose.

Mais GitHub a cessé depuis longtemps d'être un simple hébergeur. C'est devenu **l'atelier complet** autour du code : la discussion (issues), la relecture (pull requests), l'automatisation des tests et des déploiements (Actions), l'hébergement de sites statiques (Pages), le suivi de tâches (Projects), le stockage d'images Docker (Container Registry). Tu vas croiser chacune de ces briques dans ce parcours — Pages au palier 2, Projects au palier 3, Actions et le registry au palier 8. Autant t'y installer maintenant.

---

## À quoi ça sert, concrètement

**À ne pas perdre ton travail.** C'est la raison la plus bête et la plus importante. Un disque dur meurt, un ordinateur se fait voler, une commande mal tapée efface un dossier. Un dépôt poussé sur GitHub, c'est une copie intégrale de ton projet **et de tout son historique**, ailleurs.

**À prouver ce que tu sais faire.** Pour un développeur junior sans diplôme d'informatique, c'est le point décisif. Un recruteur ne peut pas vérifier que tu « connais JavaScript » ; il peut en revanche ouvrir ton GitHub et voir dix-huit mois de commits réguliers, des README propres, des projets en ligne qui fonctionnent. C'est la preuve la plus crédible qui existe, et tu commences à la construire aujourd'hui, pas au palier 10.

**À travailler avec d'autres.** Le mécanisme de la Pull Request — « voici mon travail, relisez-le avant de l'intégrer » — est le rituel central de toutes les équipes de développement. Ce n'est pas une option culturelle, c'est le fonctionnement par défaut du métier.

**À automatiser la suite.** À partir du palier 8, un `git push` déclenchera les tests, construira ton application et la déploiera en production sans que tu touches à rien. Ce point de départ, c'est GitHub.

---

## Où ça intervient dans le développement

C'est une question importante, et un débutant s'y perd souvent : **GitHub ne fait pas partie du logiciel que tu construis.** Rien de GitHub ne tourne dans ton application, et tes utilisateurs n'en entendront jamais parler. Il appartient à ce qu'on appelle l'**outillage** : la chaîne qui va de ton éditeur de texte jusqu'au serveur de production.

Place-le mentalement sur cette chaîne :

```
   ton éditeur  →  dépôt Git local  →  GitHub  →  tests automatiques  →  déploiement
   (tu écris)      (tu enregistres)   (tu partages)   (ça vérifie)       (ça part en prod)
```

GitHub est le **pivot** : tout ce qui est à gauche est ton travail personnel, tout ce qui est à droite est automatisé et part de lui. C'est pour ça qu'on l'installe au palier 0 et qu'on ne le quitte plus : chaque palier suivant vient brancher quelque chose dessus. Le palier 2 y branche l'hébergement de ton app météo, le palier 3 y branche Vercel, le palier 8 y branche le pipeline complet et le serveur de production.

Autre conséquence pratique : le travail sur GitHub est **asynchrone**. Tu ne pousses pas en continu, tu pousses à des moments choisis — fin de fonctionnalité, fin de session. Et quand plusieurs personnes travaillent, c'est là que leurs histoires se rencontrent, donc là que les conflits apparaissent. Ce n'est pas un défaut de l'outil : c'est le lieu prévu pour ça.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Ton quotidien tiendra en très peu de choses, répétées des milliers de fois. Tu ouvres ton projet, tu tapes `git status` pour voir où tu en es, tu travailles, tu commites une ou plusieurs fois, et tu pousses en fin de session. Un dépôt par projet, jamais un seul dépôt géant qui contient tout.

Tu vas aussi prendre une habitude qui paraît absurde quand on est seul : **créer une branche pour chaque fonctionnalité, puis ouvrir une Pull Request à toi-même**. Fais-le quand même, pour deux raisons. La première est l'entraînement : le jour où tu rejoins une équipe, ce geste doit être automatique, pas quelque chose que tu découvres sous pression. La seconde est plus immédiate : l'onglet *Files changed* de la PR te montre tes modifications dans une mise en page que ton éditeur ne te donne pas, et tu y verras des erreurs que tu avais sous les yeux depuis une heure sans les voir. Un `console.log` oublié, un fichier de test commité par erreur, une faute dans un nom de variable. C'est de la relecture de code, et le premier relecteur, c'est toi.

### En équipe, en entreprise

Le changement d'échelle porte sur une seule idée : **l'unité de travail n'est plus le commit, c'est la Pull Request**. On ne te demandera pas « as-tu codé ? » mais « ta PR est-elle prête à être relue ? ». Concrètement, voici ce que tu trouveras en arrivant dans n'importe quelle équipe sérieuse :

La branche `main` sera **protégée**. Impossible d'y pousser directement : tu dois passer par une branche et une PR. Cette PR devra être **approuvée** par au moins un collègue, et les tests automatiques devront être verts — sinon le bouton de fusion reste gris. Ta PR recevra des commentaires, parfois beaucoup, et ce n'est pas une sanction : la revue de code est la façon normale dont un logiciel se construit. On te demandera des modifications, tu les feras, tu repousseras, la PR se mettra à jour toute seule.

Tu découvriras aussi qu'une **PR doit être petite**. Une PR de 40 fichiers ne sera pas relue, elle sera approuvée en soupirant ou laissée de côté pendant trois jours. Une PR de 3 fichiers avec une description claire est relue en dix minutes. Apprends à découper : c'est une compétence sociale autant que technique.

Il y aura des **conventions** : un format de nom de branche (`feat/`, `fix/`, `JIRA-432-...`), un format de message de commit, un modèle de description de PR qui s'ouvre tout seul. Tu les adopteras sans discuter — l'homogénéité vaut plus que tes préférences.

Et il y aura des **conflits**, régulièrement, parce que plusieurs personnes modifient les mêmes fichiers. Tu en résoudras un par semaine. C'est banal, ça se règle en trois minutes quand on a compris le mécanisme (leçon 03), et ça devient un cauchemar quand on ne l'a pas compris et qu'on clique au hasard.

### Ce qui sert tous les jours, et ce qui ne sert presque jamais

Il y a plus de cent cinquante commandes Git. Tu en utiliseras **sept**, en boucle, pendant toute ta carrière : `status`, `add`, `commit`, `push`, `pull`, `switch`, `log`. Ajoute `diff` et `merge` et tu couvres 95 % de ton quotidien.

Un deuxième groupe revient quelques fois par mois, et c'est celui qui distingue ceux qui savent se sortir d'affaire : `stash` (mettre de côté pour changer de branche en urgence), `reset --soft` (défaire un commit en gardant le travail), `revert` (annuler proprement un commit déjà poussé), `reflog` (retrouver ce qu'on croit perdu).

Le reste — `rebase -i`, `cherry-pick`, `bisect`, les sous-modules, les hooks — existe, est parfois très utile, et ne te concerne pas aujourd'hui. Tu apprendras `bisect` le jour où tu chercheras quel commit a introduit un bug ; d'ici là, le mémoriser ne t'apporterait rien. **Ne confonds pas « connaître Git » et « avoir mémorisé sa documentation ».**

---

## Comment on s'y branche

Trois temps : créer le dépôt distant, relier ton projet local, puis entrer dans la boucle quotidienne.

Sur github.com, crée un dépôt **vide** — sans README, sans `.gitignore`, sans licence. C'est contre-intuitif, mais si GitHub crée un premier commit de son côté pendant que tu en as déjà un du tien, les deux histoires n'ont aucun ancêtre commun et ton premier `push` sera refusé. Dépôt vide, toujours, quand le projet existe déjà chez toi.

```bash
git remote add origin git@github.com:toi/mon-projet.git   # SSH, pas HTTPS
git remote -v                                             # vérifier avant de pousser
git push -u origin main                                   # -u mémorise le lien
```

Choisis bien l'adresse **SSH** (`git@github.com:...`) et non HTTPS (`https://github.com/...`). Avec HTTPS, GitHub te demandera un jeton d'accès à chaque opération ; avec SSH, ta clé répond pour toi (leçon 03 et le [guide Git](../../guides/git-et-github.md)). Si tu as déjà cloné en HTTPS, `git remote set-url origin git@github.com:toi/projet.git` corrige le tir.

Ensuite, la boucle. Elle ne changera plus jamais :

```bash
git switch main && git pull          # toujours partir à jour
git switch -c feat/filtre-categorie  # une branche par sujet
# ... travailler, commiter plusieurs fois ...
git push -u origin feat/filtre-categorie
# → sur GitHub : "Compare & pull request", décrire, relire Files changed, fusionner
git switch main && git pull          # récupérer la fusion
git branch -d feat/filtre-categorie  # nettoyer
```

Le `git pull` du début n'est pas décoratif : commencer à travailler sur une base périmée est la cause n°1 des conflits inutiles.

Une bonne description de PR tient en trois questions — ce que ça fait, comment le tester, ce qui mérite l'attention du relecteur :

```markdown
## Ce que fait cette PR
Ajoute le filtrage des dépenses par catégorie.

## Comment tester
1. `npm start`
2. `list --cat=food` → seules les dépenses "food" s'affichent

## Points d'attention
Le filtre est insensible à la casse mais pas aux accents. Volontaire pour l'instant.
```

Écris-la même pour tes PR solo. Dans six mois, c'est ce texte qui te rappellera pourquoi tu as fait ce choix.

---

## Les problèmes que tu vas rencontrer

Ils sont peu nombreux et toujours les mêmes. Les connaître d'avance t'évitera des soirées perdues.

**Ton `push` est refusé** avec un message parlant de `rejected` et de `non-fast-forward`. Traduction : le distant contient des commits que tu n'as pas. Quelqu'un a poussé avant toi — ou toi-même, depuis une autre machine. La réponse est `git pull` (qui va fusionner ou rebaser), puis repousser. **Ne cède jamais à la tentation du `--force`** : tu écraserais le travail des autres, et c'est le genre d'accident dont une équipe se souvient.

**Un conflit** apparaît au moment du `pull` ou du `merge`. Git insère des marqueurs dans le fichier et s'arrête. Ce n'est pas une erreur, c'est une question : « vous avez modifié la même ligne tous les deux, lequel garde-t-on ? ». Tu ouvres, tu choisis ou tu combines, tu supprimes les trois marqueurs, `git add`, `git commit`. Trois minutes.

**Tu as commité un secret** — un fichier `.env`, une clé d'API, un mot de passe de base de données. Comprends bien le problème : le supprimer et recommiter **ne suffit pas**, le contenu reste dans l'historique et sur les serveurs de GitHub, et sur les clones de tous ceux qui ont récupéré ta branche. La seule réponse correcte est de **révoquer la clé et d'en générer une nouvelle**, immédiatement, avant de nettoyer quoi que ce soit. D'où la règle : `.env` dans le `.gitignore` **dès le premier commit**, accompagné d'un `.env.example` aux valeurs factices, lui, commité. Des robots scannent GitHub en permanence à la recherche de clés : le délai entre une clé poussée et sa première utilisation frauduleuse se compte en minutes.

**Tu as commité `node_modules/`** (ou `vendor/`, ou `.venv/`). Ton dépôt pèse soudain 300 Mo, chaque clone est interminable, et le signal envoyé est immédiat : débutant. Le `.gitignore` se met en place avant le premier commit, pas après. Et si c'est déjà fait, `git rm -r --cached node_modules` retire le suivi.

**Tu as travaillé sur la mauvaise branche** — directement sur `main`, typiquement. Rien n'est perdu : `git switch -c feat/mon-travail` crée une branche à l'endroit où tu es (tes commits y restent), puis `git switch main && git reset --hard origin/main` remet `main` dans l'état du distant.

**Tu crois avoir tout perdu** après un `reset --hard` malheureux. Tant que le travail a été **commité**, il est récupérable pendant des semaines : `git reflog` liste tous tes déplacements, tu y repères l'identifiant du commit et tu y retournes. C'est la commande qui transforme Git d'outil angoissant en outil sûr. Fais-la tourner une fois aujourd'hui, pour savoir qu'elle existe le jour où tu paniqueras.

---

## Ce qu'on te demandera

En **test technique** ou en **entretien**, Git revient presque toujours, et sous forme de questions de méthode plutôt que de syntaxe. Les quatre classiques : « décris ton workflow Git au quotidien », « comment résous-tu un conflit », « qu'est-ce qu'une Pull Request et à quoi sert la revue de code », « comment annules-tu un commit déjà poussé ». Pour la dernière, la réponse attendue est `git revert` — pas `reset --hard` suivi d'un `push --force`, qui révélerait que tu n'as pas conscience de travailler avec d'autres.

Attends-toi aussi à ce qu'on **regarde ton GitHub avant l'entretien**. On y cherche la régularité de l'activité, la qualité des README, la présence de projets réellement en ligne, et l'absence de signaux négatifs (dépôts vides, `node_modules` commité, commits « update » en série).

Le **premier jour** dans une équipe, on te demandera de cloner le dépôt, de lire le README pour installer le projet, de créer une branche au bon format et d'ouvrir une petite PR. Si ces quatre gestes sont automatiques, tu passes ta première journée à comprendre le métier au lieu de te battre avec l'outillage.

---

## Ce qui te démarquera

Tout le monde sait `commit` et `push`. Voici ce qui se remarque vraiment, et qui ne coûte presque rien.

**Des README qui donnent envie.** Un recruteur accorde environ quatre-vingt-dix secondes à un dépôt : il lit le README, regarde la capture d'écran, clique sur le lien de démo. Il n'ouvre ton code que si ces quatre-vingt-dix secondes l'ont convaincu. Un README avec une capture, un lien live, les instructions d'installation et une section « pourquoi cette stack » te place au-dessus de 90 % des profils juniors. Le [template](../../templates/readme-projet.md) est prêt — utilise-le dès ton premier projet.

**Un historique qui raconte quelque chose.** Des commits petits, fréquents, avec des messages descriptifs. Pas forcément beaucoup de commits : des commits lisibles.

**La capacité de réparer.** Savoir sortir un collègue d'un `reset` malheureux avec `reflog`, ou annuler proprement un déploiement cassé avec `revert`, te fera une réputation en une seule occasion.

**Les petits signes de professionnalisme** : un `.gitignore` correct, un `.env.example` commité, une licence, une description et des topics remplis, un README de profil GitHub. Chacun prend deux minutes.

**Et, plus tard, une contribution open source.** Une seule suffit : trouve un `good first issue` sur un outil que tu utilises déjà, corrige une faute dans sa documentation, ouvre la PR. « J'ai une PR fusionnée sur un projet public » est une phrase qui ouvre des portes, et le processus t'apprendra plus sur le travail en équipe que dix tutoriels.

---

## 📚 À lire

Commence par **GitHub Docs → *Hello World*** : quinze minutes, le tutoriel officiel, et tu auras créé un dépôt, une branche et une PR. Enchaîne avec ***About pull requests*** et ***Writing on GitHub*** (le Markdown de GitHub, qui te servira pour la leçon 05 et pour toutes tes descriptions de PR).

Si tu veux consolider le modèle mental, **learngitbranching.js.org** a une section *Remote* entièrement consacrée au travail à distance : c'est visuel, interactif, et une heure y vaut dix articles.

Garde enfin le [guide Git & GitHub](../../guides/git-et-github.md) du parcours sous la main : il contient les procédures exactes et le tableau des réparations, à consulter dans l'urgence plutôt qu'à mémoriser.

---

## 🤖 Le mini-projet à demander à l'IA

Le vrai apprentissage du travail à distance demande… quelqu'un d'autre. À défaut, l'IA peut le simuler. Colle ceci dans une conversation :

> « Je suis en formation de développeur, palier 0. Je veux m'entraîner au travail Git en équipe, mais je suis seul. Fabrique-moi un scénario d'entraînement sur un petit projet (un fichier HTML et un fichier JS suffisent) qui me fasse rencontrer, **dans cet ordre** : (1) un `push` refusé pour cause de retard sur le distant, (2) un conflit de fusion sur la même ligne, (3) un secret commité par erreur, (4) un commit fait sur la mauvaise branche. Pour chaque étape, donne-moi **uniquement les commandes à taper pour créer la situation**, pas la solution. Je te dirai ce que j'ai tenté et tu me diras si je chauffe. »

Ce qui rend cet exercice utile, c'est qu'il te place en **réparation** et non en construction. Tu peux provoquer à volonté des situations qui, en vrai, arrivent sous stress.

Deux autres demandes qui valent le détour, plus tard dans le palier :

> « Relis la description de cette Pull Request comme le ferait un relecteur senior. Dis-moi ce qui manque pour qu'il puisse la relire sans me poser de questions. »

> « Fais-moi passer un entretien de 5 questions sur Git et GitHub, une question à la fois, et corrige chaque réponse avant de passer à la suivante. »

---

## 🛠️ À faire

1. Crée le dépôt **`learning-journal`** sur GitHub et pousse-le en SSH. Son README, en Markdown, contiendra ce que tu apprends dans ce palier (tu le soigneras en leçon 05).
2. **Déroule le cycle complet en solo, trois fois** : branche → deux commits → push → PR → relis l'onglet *Files changed* → fusionne → supprime la branche. Trois fois, pour que le geste devienne automatique. Note dans ton journal une chose que la vue *Files changed* t'a fait remarquer.
3. **Rédige une description de PR** avec les trois sections (ce que ça fait / comment tester / points d'attention) sur l'une de ces trois PR.
4. **Fabrique-toi un secret commité** : crée un fichier `secret.txt` contenant une fausse clé, commite-le, puis essaie de le faire disparaître avec `.gitignore` et `git rm --cached`. Vérifie ensuite s'il est encore dans l'historique, et écris dans ton journal la conclusion que tu en tires.
5. **Provoque un `push` refusé** : modifie un fichier directement sur GitHub (l'éditeur en ligne), puis essaie de pousser un commit local sur le même fichier. Lis le message d'erreur en entier, puis résous.
6. Clone un dépôt public qui t'intéresse et explore son historique (`git log --oneline | head -30`). Observe la forme des messages de commit : c'est le standard que tu vas imiter.
7. Soigne la vitrine : description et topics de `learning-journal`, licence MIT, et un README de profil (un dépôt portant exactement ton pseudo).

<details>
<summary>Corrections et points de contrôle</summary>

**4 — le secret.** Les commandes :
```bash
echo "cle=abc123" > secret.txt && git add secret.txt && git commit -m "add config"
echo "secret.txt" >> .gitignore
git rm --cached secret.txt && git commit -m "stop tracking secret file"
git log -p --all -- secret.txt      # le contenu est TOUJOURS là
```
La conclusion à écrire : **un secret poussé est un secret compromis**, point. Le `.gitignore` empêche les fuites futures, il n'efface rien du passé. La seule réponse correcte à une clé poussée est de la révoquer et d'en générer une nouvelle — le nettoyage de l'historique vient après, et il est pénible (il réécrit les identifiants de tous les commits suivants).

**5 — le push refusé.** Le message ressemble à :
```
! [rejected]  main -> main (fetch first)
hint: Updates were rejected because the remote contains work that you do not have locally.
```
Résolution : `git pull` (ta configuration le fera en rebase, cf. le guide), résoudre un éventuel conflit, puis `git push`. Ce que tu dois retenir, c'est le réflexe : **un push refusé n'est jamais un problème de permission, c'est un retard**.

**6 — l'historique d'un vrai projet.** Tu devrais observer des messages courts, à l'impératif présent, souvent préfixés (`fix:`, `feat:`, `docs:`), une idée par commit, et aucune trace de `update`, `wip` ou `aaaa` sur la branche principale.

**2 — ce que *Files changed* révèle.** Les plus fréquents : un `console.log` oublié, un fichier qui n'avait rien à faire là, une indentation incohérente, du code commenté laissé en place. Si tu n'as rien vu, c'est que ta PR était trop grosse — refais-en une plus petite.
</details>

---

## ✅ Acquis si…

- [ ] Je pousse sur GitHub en SSH, sans mot de passe ni jeton à retaper.
- [ ] J'ai déroulé le cycle branche → PR → merge **au moins trois fois**, et c'est devenu un réflexe.
- [ ] J'explique à quoi sert la revue de code, et pourquoi une PR doit rester petite.
- [ ] Je sais ce que signifie un `push` refusé, et pourquoi `--force` n'est pas la réponse.
- [ ] Je sais pourquoi un secret commité reste compromis, et quelle est la première chose à faire.
- [ ] `learning-journal` est en ligne avec un README correct, une description, des topics et une licence.
- [ ] ≥ 10 commits sur GitHub, messages en anglais, à l'impératif, descriptifs.
- [ ] Je situe GitHub dans la chaîne `éditeur → Git local → GitHub → tests → déploiement`.

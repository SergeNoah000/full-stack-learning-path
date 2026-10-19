# Leçon 01 — Le terminal et le système de fichiers

> 🎯 **À la fin de cette leçon** : tu navigues dans ton système au clavier sans réfléchir, et le terminal est devenu ton atelier plutôt qu'une fenêtre noire inquiétante.
> ⏱️ 2 h, dont 1 h 30 de pratique · **Prérequis** : environnement installé ([guide](../guides/installer-son-environnement.md)).

---

## Le terminal, c'est quoi

Le **terminal** est une fenêtre qui n'affiche que du texte. Elle ne sait rien faire d'elle-même : c'est une surface d'affichage et de saisie. Le programme qui tourne dedans, qui lit ce que tu tapes et décide quoi en faire, s'appelle le **shell** — en général `bash` ou `zsh`. C'est lui qui a un langage, des variables, des boucles, un historique.

La distinction a l'air théorique, elle devient concrète la première fois qu'on te dira « ajoute ça dans ton `.zshrc` » : tu configures le shell, pas le terminal.

Quand le shell t'attend, il affiche une ligne d'invite, le **prompt** :

```
sergeo@pc:~/Documents/apprentissage$
```

Cette ligne te dit déjà trois choses : qui tu es, sur quelle machine, et **où tu te trouves**. Ce dernier point est le plus important de la leçon, et on y revient plus bas.

Tout ce que tu tapes suit la même forme : une commande, des options, des arguments.

```bash
ls -la /home
# ls   = la commande (lister)
# -la  = les options (format long, y compris les fichiers cachés)
# /home = l'argument (sur quoi s'applique la commande)
```

Enfin, le **système de fichiers** est l'arborescence complète de ta machine. Sous Linux et macOS, elle part d'une racine unique notée `/`, et absolument tout s'y trouve : tes documents, les programmes, la configuration du système, et même les périphériques. Il n'y a pas de `C:` ni de `D:` — un disque supplémentaire apparaît simplement comme un dossier quelque part dans l'arbre.

---

## À quoi ça sert, concrètement

**Parce que les serveurs n'ont pas d'écran.** C'est la raison la plus brutale. Au palier 8, tu te connecteras au serveur qui héberge ton application, et tu n'auras **qu'un terminal**. Pas de souris, pas de fenêtres, pas d'explorateur de fichiers. Si tu ne sais pas naviguer, lire un fichier et consulter un journal d'erreurs au clavier, tu ne peux pas exploiter une application en production. Ce n'est pas une préférence d'ancien : c'est la seule interface disponible.

**Parce que c'est reproductible.** Une commande se note, se copie dans un README, s'envoie à un collègue, se met dans un script, se rejoue dix fois à l'identique. Dix clics dans une interface graphique ne se partagent pas et ne s'automatisent pas. C'est exactement pour ça que toutes les procédures d'installation du monde sont écrites sous forme de commandes.

**Parce que ça se combine.** Les commandes s'enchaînent entre elles (leçon 02) et produisent en une ligne des résultats qu'aucun logiciel ne te propose. « Compte les erreurs de la journée dans le journal du serveur, groupées par type » n'existe nulle part comme bouton ; c'est trois commandes assemblées.

**Parce que tout ton outillage est là.** `git`, `npm`, `python`, `php`, `composer`, `docker`, `ssh`, `curl` : rien de ce que tu vas apprendre dans ce parcours n'a d'interface graphique de référence. Le terminal n'est pas une compétence à côté du métier, c'est le plan de travail du métier.

---

## Où ça intervient dans le développement

Le terminal n'est pas dans ton produit — comme GitHub, il appartient à l'**outillage**. Mais contrairement à GitHub, il est présent à *toutes* les étapes, en permanence. C'est l'atelier dans lequel tu fais tout le reste.

Place-le mentalement :

```
   écrire du code        →  éditeur (VS Code)
   tout le reste         →  TERMINAL
   ├── installer          npm install · pip install · composer install
   ├── lancer             npm run dev · python manage.py runserver · php -S
   ├── versionner         git status · git commit · git push
   ├── tester             npm test · pytest · php artisan test
   ├── inspecter          curl · tail -f · docker logs
   └── administrer        ssh · systemctl · ufw      ← palier 8, sans interface graphique
```

Deux conséquences pratiques. D'abord, tu vas passer tes journées à **alterner** entre deux fenêtres : l'éditeur pour écrire, le terminal pour exécuter et observer. Installe-les côte à côte dès maintenant (VS Code a un terminal intégré, `Ctrl+ù` ou `Ctrl+\``) ; c'est la disposition de travail standard du métier.

Ensuite, plus tu montes dans les paliers, plus le terminal devient **le seul outil disponible**. Au palier 2 tu l'utilises pour lancer un serveur local. Au palier 6 tu y manipules Apache et MySQL. Au palier 8, sur ton serveur de production, il n'y a plus que lui. Le jour où ton site tombe un samedi soir, ta capacité à lire un journal d'erreurs au clavier est exactement ce qui sépare « je règle ça en dix minutes » de « je ne peux rien faire ».

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Ton quotidien tiendra dans très peu de gestes, répétés constamment. Tu ouvres un terminal, tu vas dans ton projet (`cd ~/dev/mon-projet`), tu lances le serveur de développement, et tu le laisses tourner dans cet onglet pendant que tu codes. Dans un deuxième onglet, tu tapes tes commandes Git. Dans un troisième, parfois, tu regardes des journaux ou tu fais des essais.

Tu prendras très vite l'habitude d'avoir plusieurs onglets ouverts, chacun avec un rôle. C'est normal, c'est même la marque du travail réel : un processus qui tourne occupe son terminal.

### En équipe, en entreprise

Le terminal devient la **langue commune**. Le README du projet te donnera une suite de commandes à exécuter pour installer et lancer l'application : si tu sais les lire et les adapter, tu es opérationnel en vingt minutes ; sinon, tu perds ta première journée et tu la perds en public.

Tu découvriras que les équipes rangent leurs commandes dans des **raccourcis** : des scripts dans le `package.json` (`npm run dev`, `npm run test`, `npm run lint`), un `Makefile`, un dossier `scripts/`. Un réflexe à prendre dès ton arrivée sur un projet : ouvrir ces fichiers pour voir quelles commandes existent déjà, au lieu d'inventer les tiennes.

Tu te connecteras à des machines distantes par `ssh`, tu y liras des journaux, tu y relanceras des services. Et quand quelque chose ne marchera pas, la première question d'un collègue sera presque toujours : « qu'est-ce que dit le terminal ? » — pas « qu'est-ce qui s'affiche à l'écran ».

### Ce qui sert tous les jours, et ce qui est rare

Il existe des milliers de commandes. Tu en utiliseras **sept**, tout le temps, pour toujours : `pwd`, `cd`, `ls`, `cat`, `mkdir`, `cp`, `mv`. Ajoute `rm`, `grep`, `tail` et `curl` et tu couvres l'essentiel de dix-huit mois de travail.

Trois **touches** compteront plus que n'importe quelle commande, et c'est là qu'il faut mettre ton effort :

**Tab** complète automatiquement les noms de fichiers et de commandes. Un développeur expérimenté ne tape presque jamais un nom de fichier en entier. C'est plus rapide, et surtout ça supprime les fautes de frappe — donc une bonne partie des erreurs « fichier introuvable ». Si tu ne retiens qu'une chose de cette leçon, que ce soit celle-là.

**↑** rappelle la commande précédente. **Ctrl+R** cherche dans tout ton historique : tape `Ctrl+R` puis `docker`, et tu retrouves la commande Docker que tu avais composée il y a trois semaines.

**Ctrl+C** interrompt le programme en cours. C'est la sortie de secours universelle, celle qui évite de fermer la fenêtre en panique.

Ce qui est **rare** et ne doit pas t'occuper aujourd'hui : les expressions régulières complexes, `sed` et `awk` au-delà du basique, l'écriture de scripts shell élaborés, `find` avec ses quarante options. Ces outils existent, ils sont puissants, et tu les apprendras le jour où tu auras le problème qu'ils résolvent. **Connaître le terminal ne veut pas dire avoir mémorisé sa documentation.**

---

## La mécanique

### Se repérer : le réflexe `pwd`

```bash
pwd                 # print working directory : où suis-je ?
ls                  # qu'y a-t-il ici ?
ls -la              # tout, y compris les fichiers cachés, avec les détails
cd /home/sergeo     # aller quelque part (chemin absolu)
cd Documents        # aller quelque part (chemin relatif, depuis ici)
cd ..               # remonter d'un niveau
cd                  # retour à la maison
cd -                # retour au dossier précédent
```

Le shell est **toujours « quelque part »**, et toute commande s'applique par défaut à cet endroit. C'est l'origine de la majorité des erreurs de débutant : tu lances `npm install` et rien ne se passe comme prévu, parce que tu n'es pas dans le dossier du projet. D'où le réflexe à installer immédiatement : **quand quelque chose ne marche pas comme attendu, tape `pwd`**. Tu n'es probablement pas où tu crois.

### Les chemins

Un chemin **absolu** part de la racine : `/home/sergeo/dev/projet`. Il est valide partout, quelle que soit ta position. Un chemin **relatif** part de l'endroit où tu es : `dev/projet`, `./script.sh`, `../autre-projet`.

Cinq raccourcis à connaître par cœur, parce qu'ils apparaissent dans toutes les documentations du monde :

`~` est ton dossier personnel (`/home/sergeo`). `.` est le dossier courant. `..` est le dossier parent. `/` est la racine. `-` est le dossier précédent.

Le `./` devant un script (`./script.sh`) n'est pas décoratif : il dit explicitement « le script qui est **ici** ». Sans lui, le shell cherche uniquement dans la liste des dossiers de programmes connus, et te répond que la commande n'existe pas.

### Les grands dossiers de Linux

Tu n'as pas besoin de tous les connaître, mais quatre vont revenir sans arrêt. `~` (soit `/home/toi`) contient tes fichiers, et c'est là que vivront tes projets, dans `~/dev/`. `/etc` contient la configuration du système — tu y passeras du temps aux paliers 6 (Apache) et 8 (Nginx, SSH). `/var/log` contient les **journaux**, et c'est le premier endroit où regarder quand un serveur se comporte mal. `/usr/bin` et `/usr/local/bin` contiennent les programmes installés.

### Se documenter sans quitter le terminal

```bash
man ls              # le manuel complet (q pour quitter, / pour chercher dedans)
ls --help           # l'aide courte, souvent suffisante
which python3       # où est installé ce programme ?
```

Et une règle de sécurité qui vaut pour tout le parcours : **avant d'exécuter une commande trouvée sur internet et que tu ne comprends pas**, passe-la sur `explainshell.com`, ou demande à l'IA de te l'expliquer option par option. Au palier 8, sur un vrai serveur, une commande incomprise peut détruire des données — et contrairement à Git, il n'y a pas de `reflog`.

---

## Les problèmes que tu vas rencontrer

**`No such file or directory`.** Dans neuf cas sur dix, tu n'es pas dans le dossier que tu crois, ou tu as fait une faute de frappe. La réponse est `pwd` puis `ls`. Et l'antidote définitif est **Tab** : un nom complété automatiquement n'est jamais mal orthographié.

**`command not found`.** Le programme n'est pas installé, ou bien il l'est mais le shell ne sait pas où le trouver. Cas très fréquent juste après une installation : le shell n'a pas rechargé sa configuration. Ferme et rouvre le terminal, ou tape `source ~/.bashrc` (ou `~/.zshrc`). Si l'erreur concerne un script local, il te manque probablement le `./`.

**`Permission denied`.** Deux causes possibles. Soit le fichier n'est pas exécutable (`chmod +x script.sh`, voir leçon 02), soit tu touches à quelque chose qui appartient au système et qui demande `sudo`. Avant de préfixer par `sudo`, demande-toi **pourquoi** : un `sudo` sur un fichier de ton propre projet est presque toujours le signe que tu es au mauvais endroit, et il crée des fichiers appartenant à l'administrateur qui te gêneront ensuite.

**Un espace dans un nom de fichier.** `cd Mon Dossier` échoue parce que le shell y voit deux arguments. Il faut `cd "Mon Dossier"` ou `cd Mon\ Dossier`. Le vrai remède est préventif : **jamais d'espace, d'accent ni de majuscule** dans les noms de dossiers et de fichiers de tes projets. Utilise des tirets : `projet-meteo`, `mon-script.sh`.

**Un programme qui ne rend plus la main.** C'est normal : un serveur de développement occupe son terminal tant qu'il tourne. `Ctrl+C` l'arrête. Ouvre un deuxième onglet plutôt que de tuer ton serveur à chaque commande.

**Tu ne sais plus comment sortir.** `man` et `less` se quittent avec `q`. Un éditeur ouvert par erreur se quitte avec `Ctrl+X` (nano) ou `:q!` (vim) — note celui-là quelque part, tout le monde s'y fait piéger une fois.

---

## Ce qu'on te demandera

En **entretien junior**, on te posera rarement des questions de shell avancé. En revanche, on vérifiera que tu es **autonome** : savoir lire un message d'erreur dans un terminal, lancer un projet, consulter un journal. C'est implicite dans presque toutes les questions techniques.

En **test technique** à faire chez toi, on t'enverra un dépôt avec un README et des commandes. Personne ne te tiendra la main pour l'installer. Un candidat qui ne parvient pas à lancer le projet ne rend pas le test.

Le **premier jour** dans une équipe, la séquence est toujours la même : cloner le dépôt, lire le README, installer les dépendances, lancer le projet, et lire les journaux quand ça ne démarre pas. Ces quatre gestes se font au terminal. S'ils sont automatiques, tu passes ta journée à comprendre le produit ; sinon, tu la passes à te battre avec ta machine.

Et en **production**, au palier 8 comme en entreprise, on te demandera de diagnostiquer : « le site est lent, va voir ». La réponse se trouve dans `/var/log`, dans `docker logs`, dans `systemctl status`. Au clavier.

---

## Ce qui te démarquera

**Utiliser Tab et `Ctrl+R` systématiquement.** Ça paraît anecdotique, et c'est pourtant le signe le plus visible de l'aisance. Quelqu'un qui tape péniblement chaque nom de fichier en entier se repère en dix secondes.

**Savoir où sont les journaux, et les lire calmement.** La majorité des développeurs juniors, devant une panne, relancent au hasard. Celui qui dit « attends, je regarde les logs » et qui sait où ils sont gagne un respect immédiat.

**Travailler dans des dossiers propres.** Une arborescence `~/dev/un-dossier-par-projet`, des noms sans espaces ni accents, pas de projets éparpillés sur le bureau. Ça ne se voit pas directement, mais ça se ressent dans tout ton travail.

**Ne jamais coller une commande non comprise.** C'est une discipline, et c'est aussi ce qui t'évitera un jour une catastrophe. Dire « je préfère comprendre cette commande avant de la lancer sur le serveur » est une phrase de professionnel.

**Quelques alias, plus tard.** Quand tu auras identifié tes commandes les plus fréquentes, tu les raccourciras dans ton `.zshrc`. Ne commence pas par ça : c'est le piège de la configuration infinie (voir le *yak shaving* dans la [méthode de session](../../guides/methode-de-session.md)).

---

## 📚 À lire

Commence par **The Odin Project → Foundations → Command Line Basics** : environ une heure, c'est la référence du parcours pour ce sujet, et c'est progressif.

Enchaîne avec **cmdchallenge.com**, qui transforme le terminal en jeu : fais les dix premiers défis. L'intérêt est que tu ne peux pas tricher — il faut que la commande fonctionne.

Garde `man hier` sous la main (la description officielle de l'arborescence Linux) et survole-la une fois, sans chercher à la retenir. Tu y reviendras aux paliers 6 et 8 avec des questions précises, et c'est à ce moment-là qu'elle deviendra utile.

---

## 🤖 Le mini-projet à demander à l'IA

Le terminal s'apprend par la répétition sur des cas concrets, et l'IA est excellente pour fabriquer un terrain d'entraînement. Colle ceci :

> « Je suis en formation de développeur, palier 0, sous Linux. Je veux m'entraîner au terminal. Donne-moi **une seule commande** qui crée dans `~/terrain-dentrainement` une arborescence réaliste de projet (dossiers `src`, `docs`, `logs`, `config`, avec une quinzaine de fichiers de types variés, dont des fichiers de log contenant des lignes `ERROR` et `WARNING`). Ensuite, pose-moi **15 défis progressifs** à résoudre uniquement au clavier sur cette arborescence, **sans les solutions** : navigation, listage filtré, lecture de fichiers, recherche dans les logs, copie, déplacement, suppression sélective. Je te donnerai mes commandes une par une, dis-moi seulement si elles sont justes et pourquoi. »

Deux autres demandes utiles pendant ce palier :

> « Explique-moi cette commande option par option, et dis-moi ce qu'elle détruit si je me trompe : `[la commande]` » — à utiliser **avant** d'exécuter, systématiquement, tant que tu n'es pas à l'aise.

> « Je suis dans ce dossier (voici la sortie de `ls -la`) et je veux obtenir [résultat]. Ne me donne pas la commande : donne-moi quelle commande chercher et quelle option lire dans son `man`. »

---

## 🛠️ À faire

1. **Le parcours à l'aveugle** : depuis `~`, atteins `/var/log` puis reviens chez toi **sans jamais taper de chemin absolu** — uniquement des `cd ..` et `cd dossier`.
2. **Construis cette arborescence en commandes uniquement**, sans la souris :
   ```
   ~/dev/
   ├── apprentissage-tests/
   │   ├── notes/
   │   └── scripts/
   └── projets/
   ```
3. Trouve **trois** fichiers cachés dans ton dossier personnel, et dis à quoi sert chacun (indice : `ls -la ~`, puis regarde le contenu de l'un d'eux).
4. Tape une commande longue, puis retrouve-la dix minutes plus tard avec `Ctrl+R`.
5. Lis le `man` de `ls` et trouve l'option qui trie **par date de modification**.
6. Provoque volontairement les trois erreurs classiques — `No such file or directory`, `command not found`, `Permission denied` — et note dans ton journal la cause réelle de chacune.
7. Ouvre un serveur web local dans un onglet (`python3 -m http.server 8000`), constate qu'il ne rend pas la main, visite `localhost:8000` dans ton navigateur, puis arrête-le proprement. Tu viens de faire exactement ce que tu feras tous les jours.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Depuis `/home/sergeo`, deux `cd ..` t'amènent à `/`, puis `cd var` et `cd log`. Retour : `cd ~`, ou `cd` tout court, ou `cd -` (qui revient au dossier précédent, le plus élégant).

**2.**
```bash
mkdir -p ~/dev/apprentissage-tests/notes ~/dev/apprentissage-tests/scripts ~/dev/projets
tree ~/dev          # pour vérifier
```
L'option `-p` crée les dossiers parents manquants et ne se plaint pas si le dossier existe déjà. Sans elle, tu devrais créer chaque niveau séparément — c'est l'erreur que tu as peut-être faite, et c'est bien de l'avoir faite.

**3.** Tu trouveras typiquement `.bashrc` ou `.zshrc` (la configuration de ton shell, exécutée à chaque ouverture de terminal — c'est là que vivront tes alias), `.gitconfig` (ton identité Git, posée au palier 0), et le dossier `.ssh/` (tes clés). Le point initial ne les protège pas : il les cache simplement de l'affichage par défaut, parce que ce sont des fichiers de configuration dont on n'a pas besoin tous les jours.

**5.** `ls -lt`, et `ls -ltr` pour inverser l'ordre — le plus récent en bas. Cette seconde forme est celle qu'on utilise en vrai sur un dossier de logs : les fichiers les plus récents apparaissent juste au-dessus du prompt, sans défilement.

**6.** Les causes réelles attendues : un mauvais répertoire courant ou une faute de frappe (→ `pwd` et Tab) · un programme absent ou une configuration de shell non rechargée, ou un `./` manquant · un fichier non exécutable ou appartenant au système.

**7.** Point important : le serveur garde la main parce qu'il **tourne**. Ce n'est pas un blocage, c'est le comportement normal de tout serveur — et c'est la raison pour laquelle tu travailleras avec plusieurs onglets.
</details>

---

## ✅ Acquis si…

- [ ] Je navigue, crée et liste des dossiers **sans réfléchir** et sans la souris.
- [ ] J'utilise **Tab** par réflexe, et `Ctrl+R` pour retrouver une commande.
- [ ] Devant un comportement inattendu, mon premier geste est `pwd`.
- [ ] J'explique la différence entre chemin absolu et relatif, et je sais ce que valent `~`, `.`, `..` et `./`.
- [ ] Je sais où sont les journaux et la configuration du système sous Linux.
- [ ] Je consulte `man` ou `--help` **avant** d'exécuter une commande que je ne connais pas.
- [ ] Je sais pourquoi mes dossiers de projet n'ont ni espaces, ni accents, ni majuscules.
- [ ] Je situe le terminal dans mon travail : l'éditeur pour écrire, le terminal pour tout le reste.

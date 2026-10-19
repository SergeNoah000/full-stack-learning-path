# Leçon 02 — Manipuler fichiers, flux et texte

> 🎯 **À la fin de cette leçon** : tu crées, copies et supprimes sans risque, tu lis un fichier de dix mille lignes sans le subir, et tu assembles des commandes pour répondre à une question que ta machine ne savait pas répondre.
> ⏱️ 2 h · **Prérequis** : leçon 01.

---

## De quoi on parle

Jusqu'ici tu t'es déplacé dans l'arborescence. Maintenant tu vas **agir** sur les fichiers, et surtout découvrir le mécanisme qui fait la vraie puissance du terminal : les **flux**.

Tout programme en ligne de commande dispose de trois canaux. Une **entrée standard** (`stdin`), par laquelle il peut recevoir des données. Une **sortie standard** (`stdout`), par laquelle il écrit son résultat. Et une **sortie d'erreur** (`stderr`), séparée, par laquelle il écrit ses messages d'erreur. Cette séparation entre résultat et erreurs paraît secondaire ; elle est en réalité ce qui permet d'enregistrer le résultat d'une commande sans y mélanger ses avertissements.

Deux outils manipulent ces canaux. La **redirection** (`>`, `>>`, `<`) les branche sur des fichiers. Le **pipe** (`|`) branche la sortie d'une commande sur l'entrée de la suivante.

S'y ajoutent les **jokers** (`*.md`, `fichier?.txt`), qui permettent de désigner plusieurs fichiers d'un coup, et les **permissions**, qui déterminent qui peut lire, écrire ou exécuter quoi.

---

## À quoi ça sert, concrètement

La philosophie d'Unix tient en une phrase : **beaucoup de petits programmes qui font une seule chose bien, et qu'on assemble**. Aucun outil au monde ne sait « trouver toutes les erreurs de ce journal, les compter par type et me donner les cinq plus fréquentes ». Mais `cat`, `grep`, `sort`, `uniq` et `head` assemblés le font en une ligne, en une seconde, sur un fichier de trois gigaoctets.

C'est la différence de nature entre le terminal et un logiciel graphique. Un logiciel t'offre les fonctions que son auteur a prévues. Le terminal te donne des briques et te laisse **construire la fonction dont tu as besoin, au moment où tu en as besoin**. Tu n'attends pas qu'on l'ait prévue pour toi.

L'image mentale à garder : des tuyaux. Chaque commande reçoit de l'eau d'un côté, la transforme, et la recrache de l'autre. Le `|` est le raccord. Et comme ce sont des tuyaux, l'ordre compte, et chaque pièce reste simple.

---

## Où ça intervient dans le développement

Trois usages vont revenir sans arrêt dans ton travail, et ils justifient à eux seuls cette leçon.

**Lire des journaux.** C'est le cas d'usage numéro un, du palier 2 au palier 10. Un serveur en difficulté produit des milliers de lignes ; la question est toujours « que s'est-il passé à 23 h 14 ? » ou « combien d'erreurs depuis ce matin ? ». On y répond avec `tail`, `grep` et `wc`, jamais en ouvrant le fichier dans un éditeur — qui s'étoufferait ou te noierait.

**Chercher dans du code.** « Où est définie cette fonction ? », « quels fichiers utilisent encore cette variable d'environnement ? », « combien de `TODO` reste-t-il ? ». Ton éditeur sait le faire, et `grep -r` le fait aussi, partout, y compris sur un serveur où tu n'as pas d'éditeur.

**Inspecter et transformer des données.** Compter des lignes dans un export CSV, vérifier qu'un fichier JSON n'est pas tronqué, extraire une colonne. Tu le feras au palier 1 sur tes fichiers de données, au palier 4 sur des exports de base.

Place-le dans la chaîne : ces commandes interviennent **en observation et en diagnostic**, rarement en production de code. Elles sont ton instrument de mesure. Quand ton application se comporte mal, c'est par là que tu regardes à l'intérieur — et le [guide de débogage](../../guides/deboguer-methodiquement.md) s'appuie directement dessus.

Une remarque d'architecture, pour plus tard : la redirection et les pipes sont aussi la façon dont les programmes communiquent entre eux dans un système. Au palier 8, quand tu liras `docker logs mon-app | grep ERROR`, tu utiliseras exactement le mécanisme de cette leçon, à l'échelle d'un serveur de production.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu créeras des dossiers et des fichiers en ligne de commande plutôt qu'à la souris, par habitude plus que par nécessité. Tu liras des petits fichiers avec `cat`, et surtout tu prendras le réflexe `tail -f` sur les sorties de tes serveurs de développement : la commande qui affiche les nouvelles lignes **en direct**, et qui te montre l'erreur au moment où elle se produit.

Tu utiliseras `grep` dès que tu chercheras quelque chose dans ton propre projet, et tu seras surpris de la vitesse.

### En équipe, en entreprise

Les pipes apparaissent dans toutes les procédures d'exploitation. Les commandes que tu trouveras dans les README, les scripts de déploiement et les messages de tes collègues ressembleront à ça :

```bash
docker logs api --since 1h | grep -i error | tail -50
cat acces.log | grep "POST /login" | wc -l
ps aux | grep node
```

Personne ne te les expliquera : on considère que ça se lit. Après cette leçon, ça se lira.

Tu rencontreras aussi les permissions, toujours au même moment : un déploiement échoue, un fichier ne peut pas être écrit, un script refuse de s'exécuter. Les paliers 6 (Apache a besoin de pouvoir lire tes fichiers) et 8 (`chmod 600` sur une clé privée, sinon SSH refuse de l'utiliser) t'y confronteront pour de vrai.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `cat`, `tail -f`, `grep`, `wc -l`, `cp`, `mv`, `rm`, `>` et `>>`, et le pipe. Moins souvent mais régulièrement : `less` pour parcourir un gros fichier, `head`, `find`, `sort`, `uniq -c`, `chmod +x`.

Rare, et à ignorer pour l'instant : `sed` et `awk` au-delà d'un remplacement simple, `xargs`, `tee`, les expressions régulières complexes, les substitutions de processus. Ces outils sont redoutablement puissants et tu les découvriras par besoin. **Apprendre `awk` aujourd'hui serait du temps volé à la programmation.**

Un point de vocabulaire qui revient en entretien : on confond très souvent `grep` et `find`. `grep` cherche **dans le contenu** des fichiers ; `find` cherche **des fichiers** d'après leurs caractéristiques (nom, date, taille, type). « Où est le mot `DATABASE_URL` ? » → `grep`. « Où sont les fichiers `.log` modifiés aujourd'hui ? » → `find`.

---

## La mécanique

### Créer, copier, déplacer, supprimer

```bash
mkdir notes              # créer un dossier
mkdir -p a/b/c           # créer toute une arborescence d'un coup
touch notes/idees.md     # créer un fichier vide
cp source.md copie.md    # copier
cp -r dossier/ copie/    # copier un dossier (récursif)
mv ancien.md nouveau.md  # renommer… et déplacer : c'est la même commande
mv fichier.md notes/     # déplacer
rm fichier.md            # supprimer
rm -r dossier/           # supprimer un dossier et tout son contenu
```

### ⚠️ `rm` mérite son propre paragraphe

**`rm` ne met rien à la corbeille. Il n'existe aucune annulation.** Ce n'est pas une mise en garde de principe : c'est le seul endroit de ce palier où une erreur de frappe peut détruire plusieurs jours de travail.

Les deux accidents classiques : `rm -rf *` tapé dans le mauvais dossier (d'où le réflexe `pwd` de la leçon 01), et un espace de trop — `rm -rf / home/sergeo/vieux` au lieu de `rm -rf /home/sergeo/vieux` tente de supprimer la racine du système.

Trois règles de survie, à appliquer jusqu'à ce que le réflexe soit acquis :

Premièrement, `pwd` avant tout `rm -r`. Deuxièmement, **liste avant de supprimer** : tape `ls *.tmp`, regarde ce que ça affiche, et seulement ensuite remplace `ls` par `rm`. Troisièmement, utilise `rm -i` pendant quelques semaines : il demande confirmation pour chaque fichier, c'est agaçant, et c'est exactement le but.

Si tu veux une sécurité supplémentaire, il existe des utilitaires qui envoient à la corbeille (`trash-cli`). Mais sur un serveur, tu n'auras que `rm` — autant acquérir la prudence tout de suite.

### Lire un fichier

```bash
cat fichier.md           # tout afficher — pour les petits fichiers seulement
less fichier.log         # parcourir (↑↓, / pour chercher, q pour quitter)
head -20 fichier.log     # les 20 premières lignes
tail -20 fichier.log     # les 20 dernières — souvent ce qu'on veut sur un log
tail -f app.log          # SUIVRE le fichier en direct
wc -l fichier.log        # compter les lignes
```

`tail -f` est la commande de diagnostic la plus utile de ta carrière. Tu la lances dans un onglet, tu reproduis le bug dans ton navigateur, et tu **vois** l'erreur s'écrire. Quitte avec `Ctrl+C`.

### Redirections

```bash
ls -la > liste.txt              # écrire la sortie dans un fichier (ÉCRASE)
echo "note du jour" >> journal.txt   # AJOUTER à la fin
commande 2> erreurs.txt         # rediriger seulement les erreurs
commande > sortie.txt 2>&1      # tout, résultat et erreurs, dans le même fichier
```

La distinction `>` / `>>` est source de dégâts : `>` **écrase sans prévenir**. Tu l'apprendras probablement en perdant un fichier, comme tout le monde — autant que ce soit un fichier d'exercice.

### Pipes : l'assemblage

```bash
cat journal.txt | wc -l                    # combien de lignes ?
ls -la | grep ".md"                        # ne garder que les .md
cat app.log | grep "ERROR" | wc -l         # compter les erreurs
history | grep git                          # quelles commandes git ai-je tapées ?
ps aux | grep node                          # mes processus node tournent-ils ?
sort noms.txt | uniq -c | sort -rn | head -5   # le top 5 des valeurs les plus fréquentes
```

Cette dernière ligne mérite d'être lue lentement, parce qu'elle est le modèle de tous les assemblages utiles : on trie pour regrouper les doublons, on compte les occurrences, on retrie par nombre décroissant, on garde les cinq premières. Quatre outils simples, un résultat qu'aucun bouton ne propose.

### Chercher

```bash
grep "mot" fichier.txt            # les lignes contenant "mot"
grep -i "mot" fichier.txt         # sans tenir compte de la casse
grep -n "mot" fichier.txt         # avec les numéros de ligne
grep -r "TODO" .                  # récursivement dans tout le dossier
grep -c "ERROR" app.log           # juste le compte

find . -name "*.md"               # tous les .md sous le dossier courant
find . -name "*.log" -mtime -1    # modifiés depuis moins d'un jour
find . -type d -name "node_modules"  # les dossiers portant ce nom
```

### Permissions : l'essentiel pour l'instant

```bash
ls -l script.sh
# -rwxr-xr--   →  type + droits du propriétaire + du groupe + des autres
chmod +x script.sh      # rendre exécutable
./script.sh             # lancer un script local (le ./ est obligatoire)
```

La lecture se fait par groupes de trois : `rwx` pour le propriétaire (lire, écrire, exécuter), `r-x` pour le groupe, `r--` pour tous les autres. Tu croiseras aussi la notation numérique, où `r=4`, `w=2`, `x=1` : `chmod 755` donne `rwxr-xr-x` (classique pour un dossier ou un programme), `chmod 644` donne `rw-r--r--` (classique pour un fichier).

Retiens surtout une chose pour les paliers 6 et 8 : **`chmod 777` est presque toujours une faute**. Ça donne l'écriture au monde entier, et sur un serveur web c'est une porte ouverte. Quand une documentation te suggère `777`, c'est une documentation à fuir.

---

## Les problèmes que tu vas rencontrer

**Tu as écrasé un fichier avec `>`.** Il n'y a pas de récupération. La seule parade est l'habitude : `>>` pour ajouter, `>` seulement quand tu veux explicitement remplacer. Et versionner avec Git tout ce qui compte (leçon 03).

**Ton pipe ne donne rien.** Dans la plupart des cas, la commande précédente a écrit sur la **sortie d'erreur**, qui ne passe pas dans le pipe. `commande 2>&1 | grep ...` règle le problème. C'est subtil, et ça explique beaucoup de perplexités.

**`grep` ne trouve pas ce que tu cherches.** Trois causes fréquentes : la casse (`-i`), un caractère spécial dans ton motif qui est interprété comme une expression régulière (mets le motif entre guillemets simples, ou utilise `grep -F` pour une recherche littérale), ou tu cherches dans le mauvais fichier.

**`grep -r` est lent et pollué.** Tu es en train de parcourir `node_modules` ou `.git`. Exclus-les : `grep -r --exclude-dir={node_modules,.git} "mot" .`. Ou mieux, installe `ripgrep` (`rg`), qui respecte le `.gitignore` par défaut — c'est l'outil moderne, et il est beaucoup plus rapide.

**`Permission denied` sur un journal système.** Les fichiers de `/var/log` ne sont pas lisibles par tous : `sudo tail -20 /var/log/syslog`. C'est normal et c'est voulu.

**Ton script ne s'exécute pas.** Il manque `chmod +x`, ou le `./` devant, ou la première ligne (`#!/bin/bash`, le *shebang*) qui indique avec quel programme l'exécuter.

---

## Ce qu'on te demandera

En **entretien**, rarement du shell avancé — mais on te demandera très probablement « comment t'y prends-tu pour diagnostiquer une erreur en production ? ». La réponse attendue commence par « je vais lire les logs », et se poursuit avec les commandes de cette leçon. Un candidat qui ne sait pas nommer `tail -f` et `grep` dans cette réponse signale qu'il n'a jamais exploité une application.

On peut aussi te demander la différence entre `grep` et `find`, ou de lire une permission (`-rwxr-xr--`, qui peut faire quoi ?). Ce sont des questions de vérification rapide.

En **test technique**, tu auras besoin de ces commandes sans qu'on te le dise : installer un projet, lire pourquoi il ne démarre pas, trouver où une variable est utilisée.

Au **palier 8 et en production**, c'est tous les jours. L'exercice pompier de ce palier — le référent casse quelque chose, tu diagnostiques — se joue entièrement avec ces outils.

---

## Ce qui te démarquera

**Savoir lire un gros fichier sans l'ouvrir.** Un junior télécharge le log de 500 Mo et essaie de l'ouvrir dans son éditeur. Celui qui tape `grep -c ERROR` puis `tail -100` a la réponse avant que le téléchargement soit fini.

**Composer un pipe de trois ou quatre étapes pour répondre à une vraie question.** C'est le moment où tu passes de « je connais des commandes » à « je me sers du terminal ». Le `sort | uniq -c | sort -rn | head` est l'exemple canonique : apprends-le, adapte-le, il répond à une quantité de questions.

**La prudence sur `rm` et les permissions.** Dire « attends, je liste avant de supprimer » ou « non, pas `777`, on va plutôt ajuster le propriétaire » te range immédiatement parmi les gens à qui on confie un accès serveur.

**Connaître `ripgrep` ou `fd`.** Les versions modernes de `grep` et `find`, plus rapides et plus ergonomiques. Ce n'est pas indispensable, mais c'est le genre de détail qui montre que tu t'intéresses à tes outils.

---

## 📚 À lire

Termine **The Odin Project → Command Line Basics** si tu ne l'as pas fini à la leçon précédente, puis fais les défis de **cmdchallenge.com** portant sur `grep` et les pipes : c'est la meilleure façon de vérifier que tu as compris, parce qu'il faut que la commande fonctionne vraiment.

Survole `man grep` et `man find` — non pas pour les mémoriser, mais pour repérer les options du tableau ci-dessus et savoir qu'il en existe d'autres. L'objectif de ces pages, à ton niveau, est de savoir **où chercher**, pas de tout retenir.

---

## 🤖 Le mini-projet à demander à l'IA

La manipulation de flux s'apprend sur des données un peu réalistes. Demande-les :

> « Je suis en formation de développeur, palier 0, sous Linux. Génère-moi, **en une seule commande**, un fichier `~/entrainement/serveur.log` de 300 lignes qui ressemble à un vrai journal de serveur web : horodatage, niveau (`INFO`, `WARNING`, `ERROR`), méthode HTTP, URL, code de statut, temps de réponse. Mets-y des erreurs récurrentes et quelques pics. Ensuite, pose-moi **12 questions** auxquelles je devrai répondre uniquement avec des pipes, de la plus simple ("combien de lignes ?") à la plus composée ("les 5 URL qui produisent le plus d'erreurs 500, triées"). **Ne me donne aucune solution** : je te soumettrai mes commandes et tu me diras seulement si le résultat est juste. »

C'est l'exercice le plus proche de ce que tu feras réellement en production, et il te servira tel quel au palier 8.

Et pendant toute cette leçon, garde ce réflexe :

> « Explique-moi cette commande morceau par morceau, et dis-moi ce qu'elle détruit si je me trompe : `[commande]` »

À utiliser **avant** d'exécuter, spécialement pour tout ce qui contient `rm`, `chmod`, `>` ou `sudo`.

---

## 🛠️ À faire

1. Crée un fichier `courses.txt` de cinq lignes **sans ouvrir d'éditeur**, avec `echo` et les redirections. (Tu vas probablement perdre tes premières lignes : c'est l'exercice.)
2. Affiche-le trié alphabétiquement **sans modifier le fichier**.
3. Compte combien de fichiers `.md` contient ton dossier `apprentissage`, en une seule ligne.
4. Trouve dans quels fichiers de ce dossier apparaît le mot « référent », avec les numéros de ligne.
5. Écris `script.sh` qui affiche la date puis la liste du dossier courant, rends-le exécutable, exécute-le.
6. Dans `/var/log`, affiche les vingt dernières lignes de `syslog` et ne garde que celles contenant `error`, sans tenir compte de la casse.
7. Lance un serveur local dans un onglet en redirigeant sa sortie vers un fichier, et suis ce fichier avec `tail -f` dans un autre onglet. Visite la page, et regarde les lignes apparaître en direct. **C'est exactement ta future boucle de débogage.**
8. Compose un pipe de quatre étapes sur le journal généré par l'IA : les cinq codes de statut les plus fréquents, triés par nombre décroissant.

<details>
<summary>Corrections</summary>

**1.**
```bash
echo "pain" > courses.txt      # > pour la première ligne : crée ou écrase
echo "lait" >> courses.txt     # >> pour les suivantes : ajoute
echo "oeufs" >> courses.txt
```
Si tu as mis `>` partout, tu n'as qu'une seule ligne. C'était le piège, et c'est la meilleure façon de ne plus jamais confondre les deux.

**2.** `sort courses.txt` — l'affichage est trié, le fichier reste intact. Et surtout : **ne fais jamais `sort courses.txt > courses.txt`**. La redirection vide le fichier avant que `sort` le lise : tu perds tout. C'est un classique.

**3.** `find ~/Documents/apprentissage -name "*.md" | wc -l`

**4.** `grep -rn "référent" ~/Documents/apprentissage`

**5.**
```bash
printf '#!/bin/bash\ndate\nls -la\n' > script.sh
chmod +x script.sh
./script.sh
```
La première ligne, le *shebang*, dit au système avec quel interpréteur exécuter le fichier.

**6.** `sudo tail -20 /var/log/syslog | grep -i error` — le `sudo` est nécessaire, les journaux système ne sont pas publics.

**7.**
```bash
# onglet 1
python3 -m http.server 8000 > serveur.log 2>&1
# onglet 2
tail -f serveur.log
```
Note le `2>&1` : sans lui, les messages d'erreur resteraient à l'écran au lieu d'aller dans le fichier.

**8.**
```bash
grep -oE ' [0-9]{3} ' ~/entrainement/serveur.log | sort | uniq -c | sort -rn | head -5
```
La structure `sort | uniq -c | sort -rn | head` est le modèle à retenir : regrouper, compter, classer, tronquer.
</details>

---

## ✅ Acquis si…

- [ ] Je crée, copie, déplace et supprime fichiers et dossiers sans hésitation.
- [ ] J'énonce les trois règles de survie de `rm` **avant** de taper `rm -r`.
- [ ] Je distingue `>` de `>>`, et je sais pourquoi `sort f > f` détruit le fichier.
- [ ] J'assemble au moins quatre commandes avec des pipes pour répondre à une vraie question.
- [ ] Je distingue `grep` (dans le contenu) de `find` (des fichiers).
- [ ] Je suis un fichier de journal en direct avec `tail -f`, et je sais pourquoi c'est ma future boucle de débogage.
- [ ] Je lis `-rwxr-xr--` et je dis qui peut faire quoi — et je sais pourquoi `777` est une faute.
- [ ] Je sais ce qu'il faut faire quand un pipe ne renvoie rien (la sortie d'erreur).

# 🌿 Guide — Git & GitHub au quotidien

> 🎯 **À la fin de ce guide** : clé SSH configurée, workflow quotidien automatique, et capacité à réparer les 6 bêtises classiques sans paniquer.
> ⏱️ Installation 30 min · le reste en référence, à revenir consulter toute ta vie.
> 📘 La **leçon** sur le modèle mental de Git (qu'est-ce qu'un commit, une branche) est [ici](../palier-00-fondations/lecons/03-git-le-modele-mental.md). Ce guide est la partie pratique.

## 1. Installation & configuration (une seule fois)

```bash
# Vérifier
git --version

# Identité (apparaîtra dans chaque commit)
git config --global user.name "Prénom Nom"
git config --global user.email "ton@email.com"

# Confort et bonnes valeurs par défaut
git config --global init.defaultBranch main
git config --global pull.rebase true          # historique linéaire, pas de merge inutile
git config --global core.editor "code --wait" # VS Code pour les messages de commit
git config --global diff.colorMoved zebra

# Vérifier le tout
git config --global --list
```

## 2. La clé SSH (procédure complète)

**Pourquoi** : pour pousser sur GitHub sans retaper un mot de passe, et de façon sûre. La clé **privée** ne quitte jamais ta machine ; tu ne communiques que la **publique**.

```bash
# 1. Générer la paire (remplace l'email)
ssh-keygen -t ed25519 -C "ton@email.com"
# → Enter pour accepter le chemin par défaut (~/.ssh/id_ed25519)
# → une passphrase : mets-en une, tu ne la tapes qu'une fois par session

# 2. Démarrer l'agent et y ajouter la clé
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. Copier la clé PUBLIQUE (note le .pub : c'est celle-là, jamais l'autre)
cat ~/.ssh/id_ed25519.pub
```

4. Sur GitHub : **Settings → SSH and GPG keys → New SSH key** → titre (« PC perso ») → coller → *Add*.

```bash
# 5. Tester
ssh -T git@github.com
# Réponse attendue : "Hi <pseudo>! You've successfully authenticated..."
```

> ⚠️ `~/.ssh/id_ed25519` (sans `.pub`) est un secret. Jamais dans un repo, jamais dans un message, jamais envoyé à une IA.

## 3. Le workflow quotidien

```bash
# Démarrer un projet
mkdir ~/dev/mon-projet && cd ~/dev/mon-projet
git init
printf 'node_modules/\n.env\n' > .gitignore
git add . && git commit -m "init project"

# Relier à GitHub (après avoir créé le repo VIDE sur github.com)
git remote add origin git@github.com:toi/mon-projet.git
git push -u origin main

# La boucle de chaque session
git status                     # où j'en suis
git switch -c feat/filtre      # une branche par fonctionnalité
# … travailler …
git add -p                     # revoir ses modifs morceau par morceau (excellent réflexe)
git commit -m "add category filter"
git push -u origin feat/filtre
# → ouvrir la Pull Request sur GitHub, la relire soi-même, fusionner

git switch main && git pull     # se remettre à jour
```

### Messages de commit

Règle du parcours : **anglais, impératif présent, descriptif**.

| ❌ | ✅ |
|---|---|
| `update` | `add category filter to expense list` |
| `fix bug` | `fix crash when expense file is empty` |
| `wip` (sur `main`) | `wip: category filter` (sur une branche, en fin de session) |

Préfixes utiles, facultatifs mais appréciés en entreprise : `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`.

Un commit = **une idée**. Si ton message contient « et », découpe (`git add -p` sert exactement à ça).

## 4. Réparer ses bêtises

> La compétence qui fait la différence : savoir que **presque tout est réparable** dans Git tant que tu as commité.

| Situation | Commande | Remarque |
|-----------|----------|----------|
| Mauvais message de commit (pas encore poussé) | `git commit --amend` | ⚠️ jamais après un push partagé |
| J'ai oublié un fichier dans le dernier commit | `git add oubli.js && git commit --amend --no-edit` | |
| Annuler le dernier commit mais **garder** le code | `git reset --soft HEAD~1` | le plus utile des trois |
| Annuler le dernier commit et **jeter** le code | `git reset --hard HEAD~1` | ⚠️ irréversible |
| Annuler mes modifs d'un fichier non commité | `git restore fichier.js` | ⚠️ irréversible |
| Mettre de côté pour changer de branche vite | `git stash` puis `git stash pop` | |
| J'ai commité sur `main` au lieu d'une branche | `git switch -c feat/x && git switch main && git reset --hard origin/main` | la branche garde les commits |
| J'ai commité un secret (`.env`) | **change le secret immédiatement**, puis retire-le de l'historique | un secret poussé est un secret compromis, point |
| Annuler un commit déjà poussé | `git revert <sha>` | crée un commit inverse : propre et partageable |
| « Je suis perdu, où est mon travail ? » | `git reflog` | l'historique de l'historique : tout y est, même les resets |

## 5. Lire et comprendre

```bash
git log --oneline --graph --all --decorate   # l'historique visuel (fais-en un alias)
git diff                                     # modifs non indexées
git diff --staged                            # ce qui partira au prochain commit
git show <sha>                               # le contenu d'un commit
git blame fichier.js                         # qui a écrit cette ligne, et dans quel commit
git log -S "addDepense"                      # quand cette chaîne est-elle apparue/disparue ?
```

Alias confortables :

```bash
git config --global alias.lg "log --oneline --graph --all --decorate"
git config --global alias.st "status -sb"
```

## 6. `.gitignore` — le minimum vital

```gitignore
# Dépendances
node_modules/
vendor/
.venv/
__pycache__/

# Secrets — JAMAIS dans Git
.env
.env.local
*.pem
*.key

# Builds
dist/
build/
.next/

# Système / éditeur
.DS_Store
.idea/
*.log
```

> Un fichier déjà commité n'est pas ignoré en l'ajoutant au `.gitignore`. Il faut : `git rm --cached fichier`.

## 7. Les règles non négociables du parcours

1. **Commit dès le premier jour** de chaque projet, et régulièrement (plusieurs par session).
2. **Jamais de secret dans Git.** `.env` + `.env.example` (celui-ci avec des valeurs factices, commité).
3. **Une branche par fonctionnalité**, même seul — pour t'entraîner au workflow professionnel.
4. **Ton GitHub est ton CV** : un historique régulier sur 18 mois vaut n'importe quel diplôme pour un junior.
5. **Ne force jamais un `push --force`** sur une branche partagée. Seul sur ta branche : `--force-with-lease`, et seulement si tu sais pourquoi.

## 8. 📚 À lire / pratiquer
- **learngitbranching.js.org** — à finir en entier (1–2 h, interactif, le meilleur investissement).
- *Pro Git* (gratuit, git-scm.com/book) — chapitres 2 et 3 seulement.
- `git help <commande>` : la doc est hors ligne, dans ton terminal.

## 9. 🛠️ À faire
1. Configure identité + clé SSH, et fais passer le `ssh -T git@github.com`.
2. Crée le repo `learning-journal`, pousse-le, écris un README en Markdown.
3. **Provoque un conflit exprès** : deux branches modifiant la même ligne, puis fusionne et résous. Note la procédure dans ton journal.
4. Entraîne-toi aux 3 réparations les plus utiles : `--amend`, `reset --soft HEAD~1`, `reflog`.

## ✅ Acquis si…
- [ ] Je pousse sur GitHub en SSH sans mot de passe.
- [ ] Je dessine à main levée le trajet `working directory → staging → commit → remote`.
- [ ] J'ai créé et résolu un conflit de merge volontairement.
- [ ] Je récupère un commit « perdu » avec `reflog` sans aide.
- [ ] Mes 10 derniers messages de commit sont en anglais, descriptifs, au présent.

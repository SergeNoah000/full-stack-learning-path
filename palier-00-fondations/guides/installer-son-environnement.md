# 🧰 Guide — Installer son environnement de travail

> 🎯 **À la fin** : une machine prête pour les 11 paliers, vérifiée commande par commande.
> ⏱️ 2 à 4 h (dont beaucoup d'attente de téléchargement) · **À faire avant la leçon 01.**
> 🧑‍🏫 **Montre le résultat au référent** (10 min) : il repérera en 2 minutes un problème de configuration qui te coûterait des semaines.

## 0. Le principe

Tout le parcours se fait **dans un environnement Linux**. Ce n'est pas un choix idéologique :
- les serveurs du monde entier tournent sous Linux (ton VPS au palier 8) ;
- Apache + PHP (palier 6) et Docker (palier 8) y sont chez eux ;
- les chemins, permissions et commandes que tu apprends sont les mêmes qu'en production.

Développer sous Windows « nativement » te ferait apprendre deux systèmes, dont un qui ne te servira pas.

## 1. Le système

### Si tu es déjà sous Linux (Ubuntu, Debian, Fedora…)
Rien à faire. Mets simplement à jour :
```bash
sudo apt update && sudo apt upgrade        # Debian/Ubuntu
```

### Si tu es sous Windows → WSL2 (obligatoire)

Dans **PowerShell en administrateur** :
```powershell
wsl --install -d Ubuntu
```
Redémarre, puis ouvre « Ubuntu » depuis le menu Démarrer et crée ton utilisateur Linux.

| Règle WSL2 | Pourquoi |
|------------|----------|
| **Travaille dans `~` (`/home/toi`), jamais dans `/mnt/c/...`** | les performances s'effondrent sur les disques Windows, et les permissions sont faussées |
| Lance VS Code depuis Ubuntu avec `code .` | il s'attache automatiquement à WSL |
| `wsl --shutdown` depuis PowerShell | pour redémarrer proprement en cas de pépin |

### Si tu es sous macOS
Installe **Homebrew** (brew.sh) puis remplace `apt install` par `brew install` dans la suite. Attention : macOS n'est pas Linux (chemins et outils diffèrent parfois) ; au palier 6 et 8, préfère Docker ou une VM Linux.

## 2. VS Code

Télécharge sur code.visualstudio.com (sous Windows : la version Windows, elle pilotera WSL).

**Extensions à installer maintenant** :

| Extension | Pourquoi |
|-----------|----------|
| **WSL** (Microsoft) | *Windows uniquement* — indispensable |
| **EditorConfig for VS Code** | cohérence d'indentation entre projets |
| **Error Lens** | affiche l'erreur **sur la ligne** : gain de temps énorme pour un débutant |
| **Code Spell Checker** | évite les fautes dans les noms de variables |
| **Prettier** | formatage automatique (palier 2) |
| **French Language Pack** | si l'anglais te bloque — mais essaie d'abord sans |

> ❌ **N'installe PAS Copilot ni d'autocomplétion IA maintenant.** Le fil rouge IA l'autorise au **palier 3**, et ce n'est pas une pédanterie : taper soi-même est précisément l'exercice des paliers 0 à 2.

Réglages utiles (`Ctrl+,`) : `Format On Save` ✅ · `Files: Auto Save` → `afterDelay` · `Editor: Tab Size` → 2.

## 3. Les outils en ligne de commande

```bash
# Debian / Ubuntu / WSL
sudo apt update
sudo apt install -y git curl wget build-essential tree unzip jq
```

| Outil | Rôle |
|-------|------|
| `git` | gestion de versions |
| `curl` | interroger des URL — ton couteau suisse du palier 0 au palier 10 |
| `build-essential` | compilateurs requis par certains paquets npm/python |
| `tree` | afficher une arborescence |
| `jq` | lire du JSON confortablement dans le terminal |

## 4. Node.js — via nvm (jamais via apt)

**Pourquoi nvm** : chaque projet peut exiger une version différente de Node. Installer Node par `apt` te condamne à une seule version et à des problèmes de permissions. `nvm` règle les deux.

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# Ferme et rouvre le terminal, puis :
nvm install --lts
nvm use --lts
nvm alias default lts/*

node --version    # v22.x ou supérieur
npm --version
```

> Tu viens d'exécuter un script téléchargé depuis internet. **Bonne pratique à prendre** : avant de faire `curl ... | bash`, ouvre l'URL dans un navigateur et regarde ce que fait le script. Ici, c'est l'installation officielle recommandée par le projet nvm.

## 5. Python 3

```bash
python3 --version              # souvent déjà présent
sudo apt install -y python3-pip python3-venv
```

> ⚠️ **Règle à vie** : jamais de `pip install` global. Un **environnement virtuel par projet** (`python3 -m venv .venv`). Tu verras pourquoi au palier 5 — et tu t'éviteras le classique « mon projet marchait hier ».

## 6. Configuration de Git

```bash
git config --global user.name "Prénom Nom"
git config --global user.email "ton@email.com"
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global core.editor "code --wait"
git config --global --list
```

Puis la **clé SSH** : procédure complète dans [../../guides/git-et-github.md](../../guides/git-et-github.md#2-la-clé-ssh-procédure-complète).

## 7. Le dossier de travail

```bash
mkdir -p ~/dev
```

**La règle d'or du parcours** : ce dossier `apprentissage` contient la **formation** (plans, leçons, journaux). **Ton code vit ailleurs**, dans `~/dev/`, un dossier par projet, chacun avec son propre repo Git poussé sur GitHub.

```
~/dev/
├── learning-journal/      ← palier 0
├── projet-depenses-cli/   ← palier 1
└── projet-meteo/          ← palier 2
```

## 8. Confort du terminal (optionnel, 20 min)

```bash
sudo apt install -y zsh
chsh -s $(which zsh)       # zsh par défaut (déconnexion/reconnexion nécessaire)
# Oh My Zsh : thème + autocomplétion + indicateur de branche Git dans le prompt
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

> Voir la branche Git courante dans son prompt évite beaucoup d'erreurs. Mais **n'y passe pas 3 heures** : c'est le piège du *yak shaving* (voir [methode-de-session.md](../../guides/methode-de-session.md)). Tu peux t'en occuper plus tard.

## 9. ✅ Vérification finale

Colle ce bloc dans ton terminal : tout doit répondre une version, sans erreur.

```bash
echo "--- Système ---";  uname -a
echo "--- Git ---";      git --version && git config user.name && git config user.email
echo "--- Node ---";     node --version && npm --version
echo "--- Python ---";   python3 --version && python3 -m venv --help > /dev/null && echo "venv OK"
echo "--- Outils ---";   curl --version | head -1 && tree --version && jq --version
echo "--- SSH GitHub ---"; ssh -T git@github.com
echo "--- VS Code ---";  code --version | head -1
```

- [ ] Toutes les versions s'affichent
- [ ] `ssh -T git@github.com` répond `Hi <pseudo>!`
- [ ] `code .` ouvre VS Code depuis le terminal (et depuis WSL si Windows)
- [ ] Le dossier `~/dev` existe
- [ ] Capture d'écran de cette vérification **montrée au référent**

## 10. Les problèmes classiques

| Symptôme | Cause | Solution |
|----------|-------|----------|
| `command not found: node` après l'installation de nvm | le terminal n'a pas rechargé sa configuration | ferme et rouvre le terminal, ou `source ~/.bashrc` |
| `permission denied` sur un `npm install -g` | installation globale mal placée | utilise nvm (c'est exactement ce que ça règle), **jamais `sudo npm`** |
| WSL très lent | tu travailles dans `/mnt/c/...` | déplace le projet dans `~` |
| `git push` demande un mot de passe | remote en HTTPS | `git remote set-url origin git@github.com:toi/repo.git` |
| `ssh -T` : `Permission denied (publickey)` | clé non ajoutée à l'agent ou à GitHub | `ssh-add ~/.ssh/id_ed25519`, et vérifie la clé **publique** sur GitHub |
| `code` inconnu sous WSL | intégration absente | installe VS Code côté Windows, relance le terminal Ubuntu |

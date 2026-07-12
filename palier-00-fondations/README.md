# Palier 0 — Fondations

> 🎯 **Objectif** : être à l'aise avec ta machine et comprendre ce qui se passe quand tu tapes une URL. Pas de programmation encore — des fondations.

## Module 1 : Environnement de travail

- [ ] Installer **VS Code** + extensions de base (French Language Pack si besoin, GitLens plus tard).
- [ ] Sous Windows : installer **WSL2 (Ubuntu)** — tout le parcours se fait dans un vrai environnement Linux (indispensable pour PHP/Apache au palier 6 et le DevOps au palier 8). Sous Linux : rien à faire, tu y es déjà.
- [ ] Installer **Git**, **Node.js** via `nvm`, **Python 3** (déjà présent sous Linux — vérifier avec `python3 --version`).
- [ ] Terminal — pratiquer jusqu'au réflexe :
  - navigation : `pwd`, `cd`, `ls -la`
  - fichiers : `mkdir`, `touch`, `cp`, `mv`, `rm` (⚠️ comprendre `rm -rf` avant de s'en servir)
  - lecture : `cat`, `less`, `head`, `tail`
  - chaînage : redirection `>` `>>`, pipe `|`, `grep`
- 📚 *The Odin Project → Foundations → Command Line Basics* ; jeu : `cmdchallenge.com`.

## Module 2 : Git & GitHub

- [ ] Concepts : repository, commit, branche, merge, remote — dessine le graphe toi-même.
- [ ] Pratique : `git init`, `status`, `add`, `commit`, `log`, `branch`, `checkout/switch`, `merge`, résoudre un conflit simple (crée-le exprès).
- [ ] Compte GitHub + clé SSH configurée.
- [ ] Premier repo : `learning-journal` — un README en **Markdown** (titres, listes, liens, code) où tu noteras tes apprentissages.
- [ ] Règle à vie : messages de commit en anglais, au présent, descriptifs (`add weather API call`, pas `update`).
- 📚 **learngitbranching.js.org** (interactif, excellent) ; *The Odin Project → Git Basics*.

## Module 3 : Comment fonctionne le web

- [ ] Client/serveur : qui demande, qui répond.
- [ ] HTTP : anatomie d'une requête et d'une réponse, méthodes (GET/POST), codes (200, 301, 404, 500).
- [ ] DNS : de `google.com` à une adresse IP.
- [ ] Ce qu'est une API. Différence frontend / backend / base de données.
- [ ] 🛠️ Exercice de synthèse : **dessine le schéma complet** "je tape une URL → la page s'affiche" et explique-le à voix haute (ou au référent). Ouvre l'onglet Réseau des DevTools sur un site réel et retrouve tes flèches.
- 📚 MDN *« How the web works »* ; vidéos « How the Internet Works » (code.org).

## 🤖 Fil rouge IA — niveau 0 : le tuteur

- Prends en main **Claude** (claude.ai) ou ChatGPT. Apprends à formuler :
  - ❌ « fais-moi un script qui… » → ✅ « explique-moi cette commande ligne par ligne »
  - ✅ « voici mon erreur + ce que j'ai fait : explique-moi la CAUSE sans me donner la solution »
- **Règle d'or des paliers 0–1 : tu tapes tout toi-même. Zéro copier-coller de code ou de commande générés.**

## 🧑‍🏫 Référent

- Lui montrer l'environnement installé (10 min) — il repérera tout de suite un problème de configuration qui te coûterait des semaines.
- Convenir du rythme des points (recommandé : toutes les 2 semaines) et créer [../questions-referent.md](../questions-referent.md) comme canal.

## ✅ Checkpoint de sortie

- [ ] Je navigue et manipule des fichiers au terminal sans réfléchir.
- [ ] ≥ 10 commits sur GitHub, messages propres, clé SSH fonctionnelle.
- [ ] Je peux expliquer le trajet « je tape google.com → la page s'affiche » sans notes.
- [ ] `journal.md` de ce palier rempli (une entrée par session).

# Palier 0 — Fondations

> 🎯 **Objectif** : être à l'aise avec ta machine et comprendre ce qui se passe quand tu tapes une URL. Pas de programmation encore — des fondations.
> ⏱️ **Volume indicatif** : 1 à 2 semaines (10–20 h). *Le checkpoint est la mesure, pas le calendrier.*
> 📍 **Prérequis** : aucun. C'est ici que tout commence.

## 🎓 Ce que tu sauras faire à la fin

Des capacités vérifiables, pas des sujets « vus » :

1. Naviguer, créer, déplacer et supprimer dans un système de fichiers **au clavier**, sans souris.
2. Enchaîner des commandes avec des pipes pour répondre à une question réelle sur des fichiers.
3. Versionner un projet avec Git : commits propres, branches, fusion, résolution de conflit.
4. Publier et maintenir du code sur GitHub par le workflow branche → Pull Request → merge.
5. Écrire un document technique correct en Markdown.
6. Raconter, sans notes, le trajet complet d'une URL jusqu'à l'affichage de la page.
7. Lire une requête et une réponse HTTP, et interroger une API avec `curl`.
8. Situer frontend, backend, base de données et API, et dire ce qui doit vivre où.

## 🧰 Avant de commencer

**[Guide — Installer son environnement de travail](guides/installer-son-environnement.md)** (2–4 h)
À faire en premier, et à faire vérifier par le référent. Une configuration bancale coûte des semaines.

Lis aussi, une fois, ces trois guides transversaux — ils valent pour tout le parcours :
- [Dérouler une session de travail](../guides/methode-de-session.md) ← **le plus important : lis-le avant ta première session**
- [Lire la documentation](../guides/lire-la-documentation.md)
- [Utiliser l'IA sans cesser d'apprendre](../guides/prompter-une-ia.md)

## 📘 Les leçons

Dans l'ordre. Chaque leçon donne l'essentiel, ce qu'il faut lire, les exercices corrigés, et ses propres critères d'acquisition.

| # | Leçon | Volume | Couvre le module |
|---|-------|--------|------------------|
| 01 | [Le terminal et le système de fichiers](lecons/01-le-terminal.md) | 2 h | Environnement de travail |
| 02 | [Manipuler fichiers, flux et texte](lecons/02-manipuler-fichiers-et-flux.md) | 2 h | Environnement de travail |
| 03 | [Git — le modèle mental](lecons/03-git-le-modele-mental.md) | 3 h | Git & GitHub |
| 04 | [GitHub et le travail à distance](lecons/04-github-et-le-distant.md) | 2 h | Git & GitHub |
| 05 | [Markdown](lecons/05-markdown.md) | 1 h | Git & GitHub |
| 06 | [Client, serveur, DNS](lecons/06-client-serveur-et-dns.md) | 1 h 30 | Comment fonctionne le web |
| 07 | [HTTP — la langue du web](lecons/07-http.md) | 2 h | Comment fonctionne le web |
| 08 | [Frontend, backend, base de données, API](lecons/08-frontend-backend-api.md) | 1 h 30 | Comment fonctionne le web |

**Référence pratique permanente** : [guides/git-et-github.md](../guides/git-et-github.md) (clé SSH, commandes du quotidien, réparer ses bêtises).

## 📚 Ressources du palier

Détail et liens dans [../ressources.md](../ressources.md#palier-0--fondations) :
**learngitbranching.js.org** (à finir en entier) · **cmdchallenge.com** · *The Odin Project → Foundations* · MDN *How the web works* · code.org *How the Internet Works*.

## 🤖 Fil rouge IA — niveau 0 : le tuteur

- Prends en main **Claude** (claude.ai) ou ChatGPT. Apprends à formuler :
  - ❌ « fais-moi un script qui… » → ✅ « explique-moi cette commande ligne par ligne »
  - ✅ « voici mon erreur + ce que j'ai fait : explique-moi la CAUSE sans me donner la solution »
- **Règle d'or des paliers 0–1 : tu tapes tout toi-même. Zéro copier-coller de code ou de commande générés.**
- Méthode complète : [../guides/prompter-une-ia.md](../guides/prompter-une-ia.md).

## 🧑‍🏫 Référent

- Lui montrer l'environnement installé (10 min) — il repérera tout de suite un problème de configuration qui te coûterait des semaines.
- Convenir du rythme des points (recommandé : toutes les 2 semaines) et créer [../questions-referent.md](../questions-referent.md) comme canal.
- Lui présenter l'**épreuve A4** (l'exposé « URL → page affichée ») en fin de palier.

## ✅ Checkpoint de sortie

Les objectifs à cocher pour sortir du palier. Chacun est **vérifié** par l'[épreuve de sortie](evaluation.md) — pas par auto-déclaration.

- [ ] **Les 8 leçons** sont cochées (tous leurs critères « Acquis si… » vrais).
- [ ] Je navigue et manipule des fichiers au terminal sans réfléchir. *(épreuve A1)*
- [ ] Git : commits, branches, fusion, conflit résolu, commit récupéré via `reflog`. *(épreuve A2)*
- [ ] ≥ 10 commits sur GitHub, messages propres, clé SSH fonctionnelle. *(livrable C)*
- [ ] Je lis et j'émets des requêtes HTTP avec `curl`, je connais les familles de codes. *(épreuve A3)*
- [ ] Je peux expliquer le trajet « je tape google.com → la page s'affiche » **sans notes**. *(épreuve A4)*
- [ ] Quiz de sortie : **≥ 16/20**. *(partie B)*
- [ ] `journal.md` de ce palier rempli (une entrée par session).
- [ ] [Rétrospective](../templates/retrospective-palier.md) rédigée.

### 🚦 [Passer l'épreuve de sortie →](evaluation.md)

> La barrière n'est pas négociable : tant que l'épreuve n'est pas réussie, le palier 1 reste fermé. C'est ce qui garantit des fondations solides — et le palier 1 est celui qui décide de tout le reste.

# 🛰️ Consigne — Travailler dans sa branche, rendre son journal visible

> 🎯 **Ce que cette consigne organise** : chaque apprenant travaille dans **sa propre branche** de ce dépôt et y pousse son journal à chaque session. Le référent lit tous les journaux **à distance**, sans rien demander à personne.
> ⏱️ Mise en place : 10 minutes, une seule fois. Puis 30 secondes par session.
> 📍 **Prérequis** : palier 0, leçons 03 et 04 (Git et GitHub) — c'est la première application réelle de ce que tu y as appris.

---

## Pourquoi ce dispositif

Le journal est le seul outil qui dise ce qui se passe **entre** deux points référent. Sans lui, le point commence par « alors, où en es-tu ? » et se termine vingt minutes plus tard, sans que personne n'ait regardé le travail réel. Avec lui, le référent arrive en sachant déjà où tu bloques, depuis combien de temps, et ce que tu as tenté.

Le faire **par Git plutôt que par message** a trois avantages concrets. Le journal est **horodaté** : on voit quand l'entrée a été écrite, donc si elle l'a été à chaud (règle du parcours) ou reconstituée le dimanche soir. Il est **historisé** : on peut relire la progression sur trois mois. Et il ne demande **aucune démarche** : tu pousses, le référent voit — personne n'a à relancer l'autre.

Accessoirement, tu t'entraînes à la seule chose qui compte vraiment dans Git : pousser régulièrement un travail dans une branche. C'est le geste de ton futur métier.

---

## Côté apprenant — la consigne

### ① Une fois : créer ta branche

Le référent t'ajoute comme **collaborateur** du dépôt (ou t'envoie l'invitation GitHub). Ensuite, une seule fois :

```bash
git clone git@github.com:SergeNoah000/full-stack-learning-path.git apprentissage
cd apprentissage
git switch -c apprenant/prenom main     # ex. apprenant/serge — minuscules, sans accent
git push -u origin apprenant/prenom
```

À partir de là, `git push` tout court suffira : le lien est mémorisé.

### ② Les quatre règles non négociables

**1. Tu ne travailles jamais sur `main`.** `main` appartient au référent : c'est là qu'il publie les leçons, les corrections et les mises à jour du parcours. Ta branche est à toi.

**2. Tu ne fusionnes jamais ta branche dans `main`.** Ton journal n'a aucune raison d'y aller, et ça écraserait celui des autres. Ta branche vit indéfiniment à part. *(Seule exception : si tu repères une coquille ou une erreur dans une leçon, là une Pull Request est bienvenue — mais elle ne contient que la correction, pas ton journal.)*

**3. Tu pousses à la fin de chaque session.** Pas chaque semaine, pas « quand j'aurai avancé ». **Une entrée de journal non poussée n'existe pas** pour le référent, et un journal rempli de mémoire trois jours plus tard ne garde que ce qui a marché — c'est-à-dire précisément ce qui n'apprend rien.

**4. Tu ne commites que tes fichiers de suivi.** Ton **code** ne vit pas ici : il va dans ses propres dépôts (`~/dev/projet-meteo`, etc.), comme l'indique le [README](../README.md). Ce qui se commite dans ta branche :

- `palier-XX-.../journal.md` — tes entrées de session
- `progression.md` — ton tableau de bord
- `katas.md` — ton registre d'algo
- `questions-referent.md` — tes questions mûres
- les rétrospectives et les `evaluation.md` remplis
- le glossaire, si tu y ajoutes tes propres définitions

### ③ Le geste de fin de session — 30 secondes

```bash
git add palier-01-programmer-javascript/journal.md
git commit -m "journal: palier 1, session du 19/10"
git push
```

Conventions de message, pour que l'historique reste lisible :

| Quoi | Message |
|------|---------|
| Une entrée de journal | `journal: palier 1, session du 19/10` |
| Une leçon cochée | `lecon: palier 1, leçon 06 acquise` |
| Le tableau de bord | `progression: palier 1 en cours` |
| Une rétrospective | `retro: palier 1` |
| Une épreuve passée | `eval: palier 1 — 26/30` |
| Des katas | `katas: semaine du 19/10` |

### ④ Récupérer les mises à jour du parcours

Le référent ajoute régulièrement des leçons et corrige des erreurs. Pour en profiter, environ une fois par semaine :

```bash
git switch main
git pull
git switch apprenant/prenom
git merge main
git push
```

Les conflits sont très improbables : le référent touche aux leçons, toi à ton journal. Si l'un survient quand même, c'est la procédure de la [leçon 03](../palier-00-fondations/lecons/03-git-le-modele-mental.md) — et c'est un bon entraînement.

### ⑤ Ce que le référent lit, et ce que ça implique

Ton journal est **lu**. Écris-le donc honnêtement — c'est tout son intérêt : « bloqué 3 h sur l'asynchrone, je n'ai pas compris pourquoi `forEach` ne marchait pas » est utile, « séance OK » ne sert à personne.

Deux conséquences pratiques. D'une part, **aucun secret dans un journal** : pas de clé d'API, pas de mot de passe, pas de capture d'écran contenant un jeton. Le dépôt est partagé, et [la leçon 04](../palier-00-fondations/lecons/04-github-et-le-distant.md) t'a appris ce qu'il advient d'un secret poussé. D'autre part, si plusieurs apprenants travaillent dans le même dépôt, **ils peuvent voir les branches les uns des autres**. Ce n'est pas un journal intime : c'est un carnet de bord professionnel.

---

## Côté référent — lire à distance

### Mise en place

Ajouter chaque apprenant comme collaborateur : **Settings → Collaborators → Add people** sur le dépôt. Un dépôt privé convient parfaitement.

> ⚠️ **Le choix à faire en connaissance de cause.** Dans un dépôt unique, **tous les collaborateurs voient toutes les branches**, donc tous les journaux. C'est généralement souhaitable — ça crée une émulation et permet aux apprenants de voir qu'ils ne sont pas seuls à galérer sur l'asynchrone. Si l'un d'eux veut son suivi strictement privé, l'alternative est un **fork privé** de son côté avec le référent invité en lecture : le suivi devient plus dispersé (un dépôt à consulter par apprenant), mais le script ci-dessous fonctionne de la même façon en ajoutant chaque fork comme remote supplémentaire.

### Les quatre commandes qui suffisent

```bash
git fetch --all --prune                       # récupérer toutes les branches

git branch -r                                  # qui a une branche ?

# Lire un journal SANS changer de branche — la commande clé
git show origin/apprenant/serge:palier-01-programmer-javascript/journal.md

# L'activité de la semaine, tous apprenants confondus
git log --all --since="1 week ago" --format='%ar  %an  %s' --no-merges
```

La troisième est celle qui change tout : `git show branche:chemin` affiche le contenu d'un fichier **dans une autre branche**, sans basculer, sans toucher à ton répertoire de travail. Tu peux lire les onze journaux de cinq apprenants sans jamais quitter `main`.

Deux variantes utiles :

```bash
# Tout ce qu'un apprenant a modifié par rapport au parcours de référence
git diff main...origin/apprenant/serge --stat

# L'évolution d'un journal dans le temps
git log -p origin/apprenant/serge -- palier-01-programmer-javascript/journal.md
```

### Le tableau de bord en une commande

```bash
./scripts/journaux.sh              # synthèse de tous les apprenants
./scripts/journaux.sh serge        # les dernières entrées d'un apprenant
```

Détail dans [scripts/README.md](../scripts/README.md).

### Depuis un navigateur, sans rien installer

Sur GitHub : le sélecteur de branche en haut à gauche de la page du dépôt → choisir `apprenant/serge` → ouvrir le dossier du palier → `journal.md`. L'onglet **Insights → Network** montre d'un coup d'œil l'activité de toutes les branches, et le flux d'activité du dépôt liste les derniers pushes de chacun.

C'est la voie à privilégier depuis un téléphone, entre deux rendez-vous.

### Ce qu'il faut regarder — et les signaux d'alerte

Dix minutes par semaine suffisent, en cherchant quatre choses précises.

**La régularité** plutôt que le volume. Quatre entrées courtes dans la semaine valent mieux qu'une longue : c'est l'indicateur n°1, et il prédit la réussite du parcours mieux que la qualité du code.

**Le champ « Bloqué sur »**, surtout s'il est identique trois sessions de suite : c'est le sujet à traiter au prochain point, et c'est souvent là que l'apprenant abandonne sans le dire.

**La présence de l'objectif écrit** avant le travail. Son absence répétée signale des sessions sans cap — le vrai problème de méthode (voir [methode-de-session.md](methode-de-session.md)).

**L'écart entre les entrées et `progression.md`.** Des leçons cochées sans entrée de journal correspondante, c'est un palier franchi trop vite.

| Signal | Ce que ça veut probablement dire |
|--------|----------------------------------|
| Aucune entrée depuis 10 jours | découragement ou blocage non dit → **prendre contact, ne pas attendre le point** |
| Le même « bloqué sur » trois fois | il tourne en rond → sujet n°1 du prochain point |
| Tout poussé d'un coup le dimanche | journal reconstitué de mémoire → rappeler la règle du « à chaud » |
| Pas d'objectif écrit | sessions sans cap → relire la méthode de session |
| Leçons cochées sans entrées | palier franchi trop vite → faire passer l'épreuve de sortie |
| Beaucoup de katas, peu de projet | évitement du projet (plus confortable) → recadrer |

### Cadence

| Fréquence | Geste |
|-----------|-------|
| Hebdomadaire | `./scripts/journaux.sh` — 10 min, repérer les signaux d'alerte |
| Toutes les 2 semaines | le point référent, préparé avec les journaux **déjà lus** |
| Fin de palier | lire la rétrospective et l'`evaluation.md` remplis avant de valider le passage |

L'intérêt principal du dispositif est là : arriver au point référent en ayant **déjà** lu. Les trente premières minutes ne servent plus à reconstituer la situation, elles servent à traiter le fond.

---

## ✅ La consigne en six lignes

- [ ] Une branche par apprenant : `apprenant/prenom`, créée depuis `main`.
- [ ] On ne travaille jamais sur `main`, on ne fusionne jamais sa branche dans `main`.
- [ ] On pousse **à la fin de chaque session** : journal, progression, katas.
- [ ] On ne commite ici **que le suivi** — le code vit dans ses propres dépôts.
- [ ] On récupère les mises à jour du parcours une fois par semaine (`merge main`).
- [ ] Aucun secret dans un journal : le dépôt est partagé.

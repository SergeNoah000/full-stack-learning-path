# ⏱️ Guide — Dérouler une session de travail

> 🎯 **À la fin de ce guide** : tu sais exactement quoi faire quand tu t'assois pour travailler, et tu ne termines plus une session en te demandant ce que tu as fait.
> ⏱️ Lecture : 10 min. À appliquer dès la toute première session.

## 1. Le principe

Un débutant qui ouvre VS Code sans objectif écrit fait, dans 90 % des cas, l'une de ces trois choses : relire du code déjà écrit, regarder une vidéo, ou configurer son éditeur. Aucune des trois ne produit de progrès.

L'objectif écrit **avant** de commencer est le seul garde-fou. Il transforme « je bosse sur le palier 1 » (impossible à finir, donc décourageant) en « j'écris la fonction `addDepense` et son test » (fini au bout de 40 min, donc gratifiant).

**Régularité > intensité.** Quatre sessions de 1 h 30 valent mieux qu'une de 6 h : la mémorisation a besoin de nuits, pas d'heures.

## 2. La méthode : le format 4 temps

### ① Ouvrir — 5 min

Dans `journal.md` du palier en cours, écris **avant de coder** :

```markdown
### 17/10/2026 — session de 1 h 30
- **Objectif** : afficher la liste des dépenses filtrée par catégorie
```

Un bon objectif de session est **vérifiable** et **atteignable dans la session**.

| ❌ Mauvais objectif | ✅ Bon objectif |
|---------------------|-----------------|
| « Avancer le projet » | « La commande `list --cat=food` affiche les bonnes lignes » |
| « Apprendre les closures » | « Écrire 3 exemples de closure et expliquer chacun en 2 lignes dans mon journal » |
| « Finir le palier 1 » | « Cocher la leçon 06 (map/filter/reduce) » |

### ② Travailler — le cœur de la session

**La règle des 80/20** : au moins 80 % du temps à produire (taper du code, résoudre, écrire), au plus 20 % à consommer (lire, regarder). Si une session dépasse 20 min de lecture sans une ligne de code, arrête-toi et code ce que tu viens de lire — même mal.

**La règle des 30 minutes** : bloqué 30 min sur le même point ?
1. écris le problème en une phrase complète (effet 🦆 canard en plastique — ça résout souvent tout seul) ;
2. relis le message d'erreur **en entier**, calmement (voir [deboguer-methodiquement.md](deboguer-methodiquement.md)) ;
3. cherche la doc, puis le web avec le message exact entre guillemets ;
4. demande un **indice** à l'IA, pas la solution ;
5. toujours bloqué ? note la question dans `../questions-referent.md` et **passe à autre chose**. Le cerveau continue en arrière-plan.

**Les pauses** : ~50 min de travail, 10 min de pause, debout, sans écran. Ce n'est pas du confort, c'est ce qui permet la 3e heure.

### ③ Fermer le code — 10 min

Avant de quitter, toujours :
- [ ] **Committer**, même un travail en cours : `git commit -m "wip: filter expenses by category"`.
- [ ] Laisser un `// TODO:` précis à l'endroit exact où tu reprendras.
- [ ] Noter en une ligne **la première action** de la prochaine session.

> C'est ce dernier point qui supprime les 20 min de redémarrage à chaque fois.

### ④ Journal, puis `push` — 2 min, à chaud

```markdown
- **Fait** : filtre par catégorie OK, test manuel
- **Appris** : `filter` ne modifie pas le tableau d'origine, il en renvoie un nouveau
- **Bloqué sur** : le filtre est sensible à la casse — à régler
- **Prochaine action** : passer la catégorie en minuscules dans la comparaison
```

À chaud signifie **maintenant**, pas dimanche soir. Un journal rempli de mémoire en fin de semaine est une fiction : il ne garde que ce qui a marché, et c'est précisément ce qui n'apprend rien.

Puis, dernier geste de la session — trente secondes :

```bash
git add palier-01-programmer-javascript/journal.md
git commit -m "journal: palier 1, session du 19/10"
git push
```

Le référent lit ton journal depuis ta branche : **une entrée non poussée n'existe pas** pour lui. C'est la [consigne de suivi](suivi-a-distance.md), et c'est ce qui fait qu'un point référent commence par le fond au lieu de « alors, où en es-tu ? ».

## 3. Le rythme hebdomadaire

| Quand | Quoi | Durée |
|-------|------|-------|
| Chaque session | Objectif → travail → commit → journal → **push** | — |
| 2×/semaine | Kata d'algo → [katas.md](../katas.md) | 30 min |
| 1×/semaine | Relire le journal, mettre à jour [progression.md](../progression.md) et le kanban · `merge main` pour récupérer les mises à jour du parcours | 15 min |
| Toutes les 2 semaines | Point référent, préparé via `questions-referent.md` | 30–60 min |
| Fin de palier | `evaluation.md` + [rétrospective](../templates/retrospective-palier.md) | 1 h |

**Semaine type à 10 h** (à adapter) : 4 sessions de 2 h + 2 katas de 30 min + 15 min de revue hebdo.

## 4. Les pièges de session

| Piège | Signe | Parade |
|-------|-------|--------|
| **Le confort de la relecture** | tu relis ton code « pour te remettre dedans » depuis 20 min | reprends par la `prochaine action` notée, directement |
| **Le yak shaving** | tu configures ton thème, tes raccourcis, ton prompt zsh | note-le dans un fichier « plus tard », reviens à l'objectif |
| **L'enfer des tutoriels** | 3e vidéo d'affilée, 0 ligne tapée | tuto → **variation personnelle sans le tuto**, obligatoire |
| **Le refactoring d'évitement** | tu embellis du code qui marche au lieu d'écrire la suite | le refactoring est une session en soi, avec son objectif |
| **La session fantôme** | tu as « travaillé 3 h » sans savoir dire quoi | objectif écrit AVANT, sans exception |
| **L'ouverture d'onglets** | 14 onglets, aucune lecture finie | une ressource à la fois, fermée avant la suivante |

## 5. 📚 À lire (optionnel, 20 min)
- *Atomic Habits* (James Clear) — les 2 premiers chapitres suffisent : la régularité bat la motivation.
- Technique Pomodoro — la version courte, pas la méthodologie complète.
- Cal Newport, *Deep Work* — si tu veux comprendre pourquoi les notifications coûtent si cher.

## 6. 🛠️ À faire maintenant
1. Ouvre `palier-00-fondations/journal.md` et écris l'objectif de ta prochaine session.
2. Mets une alarme de fin de session (pour fermer proprement, pas pour arrêter de coder).
3. Choisis tes créneaux de la semaine et mets-les dans ton agenda, comme des rendez-vous.

## ✅ Acquis si…
- [ ] Ma branche `apprenant/prenom` existe et mes 5 dernières entrées de journal y sont **poussées**.
- [ ] Mes 5 dernières sessions ont chacune un objectif écrit **avant** le travail.
- [ ] Mes 5 dernières sessions ont chacune une entrée de journal écrite le jour même.
- [ ] Je reprends le travail sans relire plus de 2 minutes.
- [ ] Je sais citer le piège de session auquel je suis le plus vulnérable.

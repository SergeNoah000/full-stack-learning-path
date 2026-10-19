# Journal de bord — palier-09-mobile-flutter

> **Une entrée par session**, remplie **à chaud** (2 min suffisent). Pas en fin de semaine : un journal rempli de mémoire ne garde que ce qui a marché, et c'est précisément ce qui n'apprend rien.
> Méthode de session : [../guides/methode-de-session.md](../guides/methode-de-session.md)

> 🛰️ **Consigne de suivi — ton journal doit être poussé.**
> Tu travailles dans **ta branche** (`apprenant/prenom`), et tu pousses à la **fin de chaque session** :
> ```bash
> git add palier-XX-.../journal.md && git commit -m "journal: palier X, session du JJ/MM" && git push
> ```
> Le référent lit ton journal à distance : **une entrée non poussée n'existe pas** pour lui. Procédure complète : [../guides/suivi-a-distance.md](../guides/suivi-a-distance.md)

## Pourquoi ce fichier existe

1. **L'objectif écrit avant** de commencer est le seul garde-fou contre la session fantôme.
2. **« Appris »** force à nommer ce que tu as compris — c'est l'étape où l'apprentissage se fixe.
3. **« Bloqué sur »** alimente `../questions-referent.md` et ta rétrospective de fin de palier.
4. **« Prochaine action »** supprime les 20 minutes de redémarrage de la session suivante.

## Modèle d'entrée

```markdown
### JJ/MM/AAAA — durée
- **Objectif** (écrit AVANT de commencer) :
- **Fait** :
- **Appris** :
- **Bloqué sur** :
- **Prochaine action** :
```

## Exemple d'entrée correctement remplie

### 17/10/2026 — 1 h 45
- **Objectif** : cocher la leçon 02 (fichiers et flux)
- **Fait** : exercices 1 à 5 ; script `info.sh` écrit et exécuté ; 3 pipes testés sur mes propres fichiers
- **Appris** : `>` écrase et `>>` ajoute — je l'ai découvert en perdant mes 4 premières lignes. `grep` cherche dans le contenu, `find` cherche des fichiers : je confondais les deux.
- **Bloqué sur** : `tail -20 /var/log/syslog` → *Permission denied*. Résolu avec `sudo` après avoir lu les permissions du fichier avec `ls -l`.
- **Prochaine action** : commencer la leçon 03 (Git) et faire *learngitbranching* → *Introduction*

---

## Mes entrées

*(à remplir — la plus récente en haut ou en bas, à ta convenance, mais garde la même convention)*

---

## 🔁 Fin de palier

- [ ] Journal relu en entier (c'est la matière première de la rétrospective)
- [ ] [Rétrospective](../templates/retrospective-palier.md) rédigée
- [ ] [Épreuve de sortie](evaluation.md) passée
- [ ] Tout est **poussé** sur ma branche (`git status` propre, `git push` fait)

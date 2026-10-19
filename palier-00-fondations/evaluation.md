# ✅ Épreuve de sortie — Palier 0

> **Pourquoi une épreuve ?** Parce que « je crois que j'ai compris » n'est pas une mesure. Un checkpoint déclaratif se franchit toujours ; une épreuve, non. C'est elle qui garantit que le palier 1 ne se construira pas sur du sable.
>
> **Conditions** : seul, **sans notes, sans IA, sans tutoriel** (la doc officielle est autorisée là où c'est précisé). Durée : ~2 h. À faire en une seule fois.
> **Seuil de réussite** : **toutes** les épreuves pratiques (A) réussies, **16/20** au quiz (B), et le livrable (C) complet.
> **Si tu échoues** : ce n'est pas un drame, c'est l'information que tu cherchais. Note ce qui a manqué, retravaille **uniquement** les leçons concernées, et repasse l'épreuve une semaine plus tard. Un échec ici coûte une semaine ; un trou non détecté coûte un mois au palier 4.

---

## Partie A — Épreuves pratiques (sans aide)

> Chronomètre-toi. Enregistre les commandes utilisées dans un fichier `evaluation-palier-0.md` de ton repo `learning-journal`.

### A1 — Terminal (cible : 10 min)
Depuis ton dossier personnel, **en ligne de commande uniquement** :
1. Crée l'arborescence `~/tmp-eval/{donnees,scripts,archives}`.
2. Crée dans `donnees/` cinq fichiers `note1.txt` à `note5.txt`, chacun contenant une ligne de texte différente.
3. Affiche le contenu de tous les fichiers en une seule commande.
4. Copie uniquement `note1.txt` et `note2.txt` dans `archives/`.
5. Renomme `scripts/` en `outils/`.
6. Compte le nombre total de lignes de tous les `.txt` de `donnees/`.
7. Trouve, parmi ces fichiers, ceux qui contiennent le mot « test », avec les numéros de ligne.
8. Crée `outils/info.sh` qui affiche la date puis le nombre de fichiers du dossier parent ; rends-le exécutable ; exécute-le.
9. Supprime tout `~/tmp-eval` — **après** avoir vérifié où tu te trouves.

✅ **Réussi si** : aucune aide consultée, aucune souris, et l'étape 9 a été précédée d'un `pwd`.

### A2 — Git (cible : 20 min)
1. Nouveau repo local `eval-git`, premier commit.
2. Trois commits successifs modifiant un fichier `app.txt`.
3. Branche `feat/titre` : modifie la **ligne 1** de `app.txt`, commite.
4. Retour sur `main` : modifie la **même ligne 1** différemment, commite.
5. Fusionne `feat/titre` dans `main` → **résous le conflit**, commite.
6. Affiche l'historique en graphe. Le commit de merge doit être visible.
7. Fais un 6e commit, puis annule-le **en conservant les modifications**, et recommite avec un meilleur message.
8. Supprime le dernier commit avec `reset --hard`, puis **retrouve-le** et reviens dessus.
9. Pousse `eval-git` sur GitHub en SSH.

✅ **Réussi si** : les 9 étapes passent sans consulter de documentation sur Git, et le repo est en ligne.

### A3 — HTTP & réseau (cible : 15 min)
Avec `curl` et `dig` uniquement :
1. Donne l'adresse IP de `github.com`.
2. Obtiens **seulement les en-têtes** de `https://github.com` et donne le code de statut.
3. Montre une redirection : quel code, et vers quelle URL (quel en-tête te le dit) ?
4. Interroge `https://api.github.com/users/<ton-pseudo>` et extrais le nombre de repos publics.
5. Provoque un `404` et un `401` sur l'API GitHub, et explique la différence entre les deux en une phrase.
6. Envoie un `POST` JSON à `https://httpbin.org/post` et montre que le serveur a bien reçu tes données.

✅ **Réussi si** : les 6 réponses sont obtenues sans aide, et l'explication du 5 est juste.

### A4 — L'exposé (cible : 5 min, à l'oral)
**Sans notes**, au référent ou enregistré sur ton téléphone :

> « Je tape `https://www.google.com/search?q=chat` dans mon navigateur. Raconte-moi tout ce qui se passe jusqu'à l'affichage. »

✅ **Réussi si** tu mentionnes spontanément : découpage de l'URL · résolution **DNS** (et son cache) · connexion TCP · **certificat TLS** · requête HTTP avec sa méthode · traitement serveur · code de statut · et le fait que le HTML déclenche de **nouvelles requêtes** pour CSS/JS/images.

---

## Partie B — Quiz (20 questions, sans aide)

> Écris tes réponses **avant** de dérouler les corrections. 1 point par question. Seuil : **16/20**.

1. Quelle est la différence entre un chemin absolu et un chemin relatif ?
2. Que fait `rm -rf dossier` et pourquoi est-ce dangereux ? Cite deux précautions.
3. Quelle est la différence entre `>` et `>>` ?
4. Quelle commande pour suivre un fichier de log **en direct** ?
5. Que fait `cat app.log | grep "ERROR" | wc -l` ? Explique chaque étape.
6. Différence entre `grep` et `find` ?
7. Dans `-rwxr-xr--`, que peut faire un utilisateur quelconque du système ?
8. Cite les 3 zones de Git et le trajet d'un fichier modifié jusqu'à l'historique.
9. Qu'est-ce qu'une branche Git, techniquement ?
10. Pourquoi l'index (*staging*) existe-t-il ? Donne un cas concret où il est utile.
11. Différence entre `git fetch` et `git pull` ?
12. Tu as commité un fichier `.env` contenant une clé d'API, puis tu l'as supprimé et recommité. Es-tu en sécurité ? Pourquoi ?
13. Différence entre Git et GitHub ?
14. À quoi sert le DNS, et que contient la réponse qu'il renvoie ?
15. Que signifie « HTTP est sans état » et quelle conséquence pratique cela a-t-il ?
16. Donne la différence entre `401` et `403`.
17. Tu obtiens un `500`. Où regardes-tu ? Et pour un `404` ?
18. Pourquoi `GET /delete-user?id=5` est-elle une mauvaise conception ?
19. Pourquoi une clé d'API ne doit-elle jamais figurer dans du JavaScript de navigateur ?
20. Tu dois stocker les dépenses de 200 utilisateurs. `localStorage`, un fichier JSON ou une base de données ? Justifie en citant une limite de chaque option écartée.

<details>
<summary>Corrections</summary>

1. Absolu : part de la racine `/`, valide partout. Relatif : part du répertoire courant, dépend donc d'où tu te trouves.
2. Supprime récursivement et sans confirmation, **définitivement** (pas de corbeille). Précautions : `pwd` avant, `ls` le motif avant de le supprimer, `rm -i` tant que le réflexe n'est pas acquis.
3. `>` écrase le fichier ; `>>` ajoute à la fin.
4. `tail -f fichier.log`.
5. `cat` envoie le contenu dans le tuyau → `grep "ERROR"` ne garde que les lignes contenant ERROR → `wc -l` les compte. Résultat : le nombre de lignes d'erreur.
6. `grep` cherche **dans le contenu** des fichiers ; `find` cherche **des fichiers** d'après leurs caractéristiques (nom, date, type).
7. `r--` → il peut **lire** uniquement (ni écrire, ni exécuter).
8. Répertoire de travail → (`git add`) → index → (`git commit`) → dépôt `.git`.
9. Un **pointeur mobile vers un commit**. Rien de plus : d'où son coût nul.
10. Pour choisir *ce qu'on commite* : on peut séparer deux modifications faites en même temps en deux commits propres (`git add -p`). Cas concret : un correctif de bug et un changement de style modifiés dans la même session.
11. `fetch` récupère les informations du distant **sans toucher** à ton travail ; `pull` = `fetch` + fusion dans ta branche courante.
12. **Non.** Le contenu reste dans l'historique et sur GitHub : la clé est **compromise**. La seule réponse correcte est de **la révoquer et la régénérer** (et éventuellement réécrire l'historique).
13. Git = le logiciel de versionnage, local. GitHub = un service d'hébergement de repos Git, avec PR, issues, Pages, Actions.
14. Traduire un nom de domaine en **adresse IP** ; la réponse contient l'IP (parfois plusieurs) et un **TTL** (durée de cache).
15. Le serveur ne garde **rien** entre deux requêtes : chacune est indépendante. Conséquence : pour rester authentifié, il faut renvoyer un **cookie de session** ou un **jeton** à chaque requête.
16. `401` = non authentifié (« je ne sais pas qui tu es »). `403` = authentifié mais pas autorisé (« je sais qui tu es, tu n'as pas le droit »).
17. `500` → **les logs du serveur** (c'est le code serveur qui a planté). `404` → **ma requête** : URL, méthode, route existante côté serveur.
18. `GET` doit être **sûr** (ne rien modifier) et idempotent. Les navigateurs, proxys et robots préchargent les `GET` : un crawler pourrait supprimer tes utilisateurs. Il faut `DELETE` (ou `POST`).
19. Tout ce qui part au navigateur est **public et lisible** (`Ctrl+U`, onglet Réseau). La clé serait volée et utilisée à ton compte.
20. **Base de données.** `localStorage` ne vit que dans un seul navigateur d'un seul appareil et n'est pas partagé ; un fichier JSON ne supporte pas les accès concurrents (deux écritures simultanées le corrompent) et n'offre ni recherche efficace ni relations.

**Score** : ____ /20
</details>

---

## Partie C — Livrable

- [ ] Repo **`learning-journal`** en ligne sur GitHub, avec un README en Markdown correctement rendu (titres, liste, tableau, bloc de code, lien, case à cocher).
- [ ] **≥ 10 commits**, messages en anglais, à l'impératif, descriptifs.
- [ ] Clé SSH fonctionnelle (`ssh -T git@github.com` répond `Hi <pseudo>!`).
- [ ] Le **schéma dessiné à la main** « URL → page affichée » photographié dans le journal.
- [ ] `journal.md` du palier rempli : **une entrée par session**, écrite à chaud.
- [ ] `evaluation-palier-0.md` contenant les commandes des épreuves A1–A3 et ton score au quiz.
- [ ] [Rétrospective](../templates/retrospective-palier.md) rédigée.

---

## Résultat

| Partie | Seuil | Résultat |
|--------|-------|----------|
| A — Pratique | 4/4 épreuves | ⬜ |
| B — Quiz | 16/20 | ⬜ ___/20 |
| C — Livrable | tout coché | ⬜ |

**Date de passage** : ______  · **Verdict** : ⬜ validé ⬜ à repasser le ______

- [ ] Palier passé à ✅ dans [../progression.md](../progression.md)
- [ ] 🧑‍🏫 Épreuve A4 (l'exposé) présentée au référent

> 🚦 **Barrière** : tu n'ouvres pas le palier 1 avant que cette page soit entièrement validée.

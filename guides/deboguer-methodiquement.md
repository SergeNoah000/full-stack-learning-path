# 🐛 Guide — Déboguer méthodiquement

> 🎯 **À la fin de ce guide** : tu ne « bidouilles » plus au hasard. Tu suis une procédure, et tu sais à quel moment t'arrêter.
> ⏱️ Lecture 15 min · à relire chaque fois que tu perds plus d'une heure sur un bug.
> C'est **la** compétence qui distingue un dev de quelqu'un qui a suivi des tutoriels. Elle s'apprend : ce n'est pas un talent.

## 1. Le principe

Un bug n'est pas une malédiction, c'est un **écart entre ce que tu crois que le code fait et ce qu'il fait**. Le travail n'est donc pas de « faire marcher », mais de **localiser la fausse croyance**.

D'où la seule règle qui compte : **arrête de modifier le code, commence par observer.** Chaque modification faite au hasard ajoute une inconnue et détruit l'information que tu venais d'acquérir.

## 2. La méthode en 7 étapes

### ① Lire le message d'erreur. En entier. À voix haute.

80 % des bugs de débutant sont expliqués dans le message, qui n'a pas été lu. Un message d'erreur comporte toujours :
- **le type** : `TypeError`, `SyntaxError`, `ReferenceError`, `404`, `500`…
- **la description** : `Cannot read properties of undefined (reading 'name')`
- **l'emplacement** : fichier, ligne, colonne
- **la stack trace** : la chaîne des appels

**Décodeur des erreurs les plus fréquentes :**

| Message | Ce qu'il dit vraiment | Où chercher |
|---------|----------------------|-------------|
| `Cannot read properties of undefined (reading 'x')` | tu accèdes à `.x` sur quelque chose qui n'existe pas | ce qui **produit** cet objet : une réponse d'API ? un tableau vide ? une faute de frappe sur la clé ? |
| `x is not a function` | `x` existe mais n'est pas une fonction | import manquant/mal nommé, ou tu confonds `x` et `x()` |
| `x is not defined` | le nom n'existe nulle part | faute de frappe, import oublié, ou variable hors de portée |
| `Unexpected token` | erreur de **syntaxe** | une accolade/parenthèse/virgule, souvent **avant** la ligne indiquée |
| `Cannot find module 'y'` | dépendance absente ou chemin faux | `npm install`, ou `./` oublié dans le chemin relatif |
| `EADDRINUSE` | le port est déjà pris | un serveur tourne déjà : `lsof -i :3000` |
| `CORS policy` | le navigateur bloque l'appel cross-domaine | côté **serveur** : en-têtes CORS. Jamais côté client |
| `404` sur une route d'API | l'URL n'existe pas côté serveur | méthode HTTP ? préfixe `/api` ? faute dans le chemin ? |
| `500` | ton serveur a planté | **les logs du serveur**, pas le navigateur |

### ② Lire la stack trace de haut en bas, et s'arrêter à TON code

La stack trace est la pile des appels. Les premières lignes sont souvent dans `node_modules` : saute-les. **La première ligne qui pointe vers un de tes fichiers est le point de départ.**

### ③ Reproduire à volonté

Un bug qu'on ne sait pas reproduire ne se corrige pas, il se devine. Écris les étapes exactes :
> « Quand je soumets le formulaire avec le champ catégorie vide, alors la page devient blanche. »

Si le bug est intermittent, cherche ce qui varie : ordre des opérations, données, temps (asynchrone), cache, session.

### ④ Formuler une hypothèse unique et falsifiable

> « Je pense que `depenses` est `undefined` parce que le fichier JSON n'existe pas au premier lancement. »

Une hypothèse, **une seule**, et qui se teste. « C'est peut-être le serveur ou le front ou la BDD » n'est pas une hypothèse.

### ⑤ Observer la réalité

```js
// Le bon vieux print debugging — et il n'y a aucune honte à ça
console.log('>>> depenses =', depenses, 'type =', typeof depenses);
console.log('>>> avant filter, longueur =', depenses?.length);
```

Techniques, par ordre de puissance :

| Outil | Quand | Comment |
|-------|-------|---------|
| `console.log` étiqueté | tout le temps | **préfixe `>>>`** pour les retrouver et les supprimer ensuite |
| `console.table(tableau)` | données tabulaires | bien plus lisible |
| **Débogueur / breakpoints** | dès le palier 2 | VS Code : F5, point rouge dans la marge, inspection des variables pas à pas |
| Onglet **Réseau** des DevTools | tout problème front↔back | la requête part-elle ? quelle URL exacte ? quel statut ? quel corps ? |
| Onglet **Console** | erreurs JS navigateur | lire avant toute chose |
| Logs serveur | toute erreur 5xx | `docker logs`, `journalctl -u app -f`, `/var/log/apache2/error.log` |
| `curl -i` | tester une API sans le front | isole le problème : si curl marche, le bug est côté client |

### ⑥ Dichotomie : couper le problème en deux

La technique la plus efficace et la plus sous-utilisée. Le bug est quelque part entre A et Z ? **Vérifie M.**

- Front ou back ? → `curl` l'API directement. Si la réponse est bonne, le bug est devant.
- Quelle ligne ? → commente la moitié du code. Ça marche ? le bug est dans la moitié commentée.
- Depuis quel commit ? → `git log --oneline`, puis `git bisect` (il te fait trouver en ~5 essais parmi 100 commits).
- Mon code ou la bibliothèque ? → reproduis en 10 lignes dans un fichier neuf. Si le bug disparaît, il vient de ton contexte.

### ⑦ Corriger, puis comprendre **pourquoi** ça marche

Un bug « résolu » sans explication reviendra. Avant de passer à la suite, écris une phrase dans le journal :
> « Le fichier JSON n'existait pas au premier lancement ; `readFile` levait une exception que je ne traitais pas. Correction : créer le fichier s'il est absent. »

C'est cette phrase — pas la correction — qui t'évitera les 20 prochains bugs du même genre.

## 3. Quand t'arrêter

| Temps écoulé | Action |
|--------------|--------|
| 10 min | relire le message d'erreur **en entier**, vraiment |
| 20 min | écrire le problème en une phrase complète (effet 🦆) + 3 hypothèses |
| 30 min | chercher la doc, puis le message exact **entre guillemets** sur le web |
| 45 min | demander un **indice** à l'IA, avec code + erreur + ce que tu as tenté |
| 1 h | noter dans `questions-referent.md` et **changer de tâche** |
| le lendemain | relire à froid — c'est souvent réglé en 5 min |

> Le détour par la pause n'est pas de l'abandon : c'est la technique la plus fiable du métier. Le cerveau continue à travailler en arrière-plan.

## 4. Les erreurs de débogage les plus coûteuses

| Erreur | Pourquoi c'est coûteux |
|--------|------------------------|
| Modifier plusieurs choses à la fois | tu ne sauras jamais laquelle a corrigé (ni laquelle a cassé autre chose) |
| Ne pas lire le message d'erreur | 80 % des cas y sont déjà expliqués |
| Chercher « error » au lieu du message exact | sans guillemets et sans message exact, le web ne sert à rien |
| Supposer sans vérifier | « la variable contient forcément… » → `console.log`, toujours |
| Coller la solution de l'IA sans comprendre | le bug reviendra, et tu n'auras rien appris |
| Déboguer un code non commité depuis 3 h | tu ne peux plus revenir à l'état qui marchait |
| Déboguer fatigué après 23 h | coût réel multiplié par 3 |

## 5. 📚 À lire
- *Debugging* (David Agans) — les 9 règles ; même le sommaire est instructif.
- MDN → *What went wrong? Troubleshooting JavaScript*.
- Doc VS Code → *Debugging* (configurer `launch.json` une fois, pour toujours).
- `git bisect` : la doc officielle, 10 minutes bien investies.

## 6. 🛠️ À faire
1. Prends un de tes scripts qui marche et **casse-le volontairement** de 3 façons (faute de frappe sur une variable, accolade manquante, appel d'une méthode inexistante). Lis les 3 messages d'erreur, note le type de chacun.
2. Configure le débogueur de VS Code sur un projet Node et place un breakpoint. Inspecte une variable à l'arrêt.
3. Sur ton prochain bug réel : écris les 7 étapes dans le journal au fur et à mesure. Une fois suffit pour prendre le pli.

## ✅ Acquis si…
- [ ] Devant une erreur, mon premier geste est de **lire le message en entier**, pas de modifier le code.
- [ ] Je lis une stack trace et j'y trouve la première ligne de mon code.
- [ ] J'utilise des breakpoints, pas seulement `console.log`.
- [ ] Je sais isoler un bug front/back avec `curl` ou l'onglet Réseau.
- [ ] Je formule une hypothèse avant de toucher au code.
- [ ] Mon journal contient au moins 3 bugs avec leur **cause** écrite.

# Leçon 02 — Comprehensions, fonctions, `*args`/`**kwargs`

> 🎯 **À la fin de cette leçon** : tu écris des comprehensions à la place de tes `map`/`filter`, et tu manipules les arguments de fonction avec la souplesse propre à Python.
> ⏱️ 4 h · **Prérequis** : leçon 01, et la leçon 06 du palier 1 (map/filter/reduce).

---

## De quoi on parle

Une **comprehension** est la façon pythonique de transformer et filtrer une collection en une seule expression :

```python
totaux = [d["montant"] * 1.1925 for d in depenses if d["categorie"] == "food"]
```

C'est l'équivalent direct de `depenses.filter(...).map(...)` du palier 1 — mais intégré à la syntaxe du langage plutôt que fourni par des méthodes. Il en existe pour les listes, les dictionnaires et les sets.

`*args` et `**kwargs` sont les mécanismes pour qu'une fonction accepte un **nombre variable** d'arguments — positionnels (`*args`) ou nommés (`**kwargs`). C'est le `...rest` du palier 1, dans sa version Python.

Et les **fonctions sont des valeurs** en Python comme en JavaScript : on les passe en argument, on les retourne, on les stocke. Les **lambda** sont leur version courte et anonyme.

---

## À quoi ça sert, concrètement

**Parce que les comprehensions sont l'idiome le plus caractéristique de Python.** Un développeur Python reconnaît immédiatement du code écrit par quelqu'un qui vient d'un autre langage : il reconstruit `map` et `filter` avec des boucles et des `append`, là où une comprehension dit la même chose en une ligne lisible. Maîtriser les comprehensions, c'est passer de « j'écris du JavaScript en Python » à « j'écris du Python ».

**Parce que c'est un transfert direct, et donc rapide.** Tu as compris `map`, `filter` et `reduce` au palier 1 : la comprehension n'est que leur expression condensée. Tu n'apprends pas un concept, tu apprends une syntaxe pour un concept que tu possèdes déjà.

**Parce que `*args`/`**kwargs` est partout dans les frameworks.** Quand tu utiliseras Flask, FastAPI ou Django, tu verras `def ma_vue(*args, **kwargs)` et tu comprendras ce que ça signifie : « accepte ce qu'on me passe et transmets-le ». C'est le mécanisme qui rend les décorateurs et les fonctions génériques possibles.

**Et parce que les fonctions-valeurs sont la base de ce qui suit.** Les décorateurs de Flask (`@app.route`), les fonctions de tri avec `key`, les callbacks : tout repose sur le fait qu'une fonction est une valeur. Tu le sais depuis le palier 1 ; ici tu le pratiques en Python.

---

## Où ça intervient dans le développement

Cette leçon prolonge la précédente et prépare tout le reste du palier :

```
   map/filter/reduce (palier 1)  →  COMPREHENSIONS (cette leçon)
   ...rest (palier 1)            →  *args / **kwargs
   fonctions-valeurs (palier 1)  →  lambda, fonctions passées en argument
        ▼
   les décorateurs des frameworks (@app.route, @app.get)   ← leçons 09-11
```

Trois points de transfert.

**La comprehension remplace la boucle manuelle, comme `map`/`filter` l'ont fait au palier 1.** Et le même avertissement s'applique : au-delà d'une certaine complexité, une comprehension devient illisible, et il faut revenir à une boucle nommée. Le déclaratif n'est une qualité que s'il reste lisible — c'est la leçon 06 du palier 1, mot pour mot.

**`**kwargs` prépare les décorateurs.** Tu n'écriras pas de décorateurs à ce palier, mais tu en **utiliseras** dès Flask. Comprendre `**kwargs` maintenant rend ces décorateurs lisibles au lieu de magiques.

**Et le `reduce` de Python est particulier.** Python préfère les fonctions intégrées (`sum`, `max`, `min`) et les comprehensions à un `reduce` générique. `functools.reduce` existe, mais on l'utilise rarement — c'est une différence culturelle avec JavaScript qu'il faut connaître.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas d'abord écrire des boucles avec `append`, par réflexe du palier 1, puis les condenser en comprehensions. C'est le bon ordre : écris d'abord la version que tu comprends, puis apprends à la resserrer.

Tu vas aussi être tenté d'imbriquer des comprehensions sur deux ou trois niveaux. Résiste : au-delà d'un `if` et d'un niveau, la lisibilité s'effondre.

### En équipe, en entreprise

**Les comprehensions sont attendues** pour les transformations simples. Un relecteur te signalera une boucle `for` + `append` qui aurait pu être une comprehension d'une ligne.

**Mais une comprehension illisible est aussi reprise.** La règle d'équipe habituelle : une comprehension tient sur une ligne lisible, avec au plus un `if`. Au-delà, c'est une boucle.

**`**kwargs` apparaît dans tout code de framework**, et dans les fonctions qui transmettent des arguments. Tu le liras plus que tu ne l'écriras au début.

**Et les lambda sont utilisées avec parcimonie.** Contrairement à JavaScript où les fonctions fléchées sont partout, Python limite les lambda aux cas très courts (une clé de tri, par exemple). Pour une vraie fonction, on la nomme avec `def`. C'est une différence de culture.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : les comprehensions de liste, `sum`/`max`/`min`/`len`, `sorted` avec `key`, les arguments par défaut, et les fonctions passées en argument.

Régulièrement : les comprehensions de dictionnaire et de set, `enumerate`/`zip`, `*args`/`**kwargs`, les lambda courtes, le dépaquetage (`a, b = ...`).

Rare, et hors sujet pour l'instant : `functools.reduce` (Python préfère les boucles et `sum`), les expressions génératrices avancées, `itertools`, les décorateurs écrits à la main, `functools.partial`, les comprehensions imbriquées complexes. Tu les découvriras par besoin ; en écrire au niveau débutant est souvent un signe de sur-ingénierie.

---

## La mécanique

### Les comprehensions de liste

```python
# map : transformer
doubles = [n * 2 for n in nombres]
montants = [d["montant"] for d in depenses]

# filter : sélectionner
positifs = [n for n in nombres if n > 0]
food = [d for d in depenses if d["categorie"] == "food"]

# map + filter : les deux à la fois
totaux = [d["montant"] * 1.1925 for d in depenses if d["categorie"] == "food"]
```

La lecture se fait dans l'ordre : *ce que je produis*, *pour chaque élément*, *si une condition*. C'est `depenses.filter(d => ...).map(d => ...)` du palier 1, écrit à l'envers de l'ordre d'exécution mais plus proche du langage naturel.

### Les comprehensions de dictionnaire et de set

```python
# dictionnaire : { clé: valeur for ... }
par_id = {d["id"]: d for d in depenses}               # ⭐ l'index de la leçon 12 du palier 1 !
noms = {cat: cat.upper() for cat in categories}

# set : valeurs uniques
categories_uniques = {d["categorie"] for d in depenses}
```

La comprehension de dictionnaire `{d["id"]: d for d in depenses}` est exactement l'**index** que tu construisais avec `reduce` au palier 1 (leçon 12), pour transformer une recherche `O(n)` en accès `O(1)`. Le concept est identique ; la syntaxe est plus directe.

### `reduce`, à la pythonique

```python
# ❌ Le reflexe JavaScript — fonctionne, mais pas pythonique
from functools import reduce
total = reduce(lambda acc, d: acc + d["montant"], depenses, 0)

# ✅ Pythonique : sum avec une expression génératrice
total = sum(d["montant"] for d in depenses)

# totaux par catégorie : une boucle est plus claire qu'un reduce
from collections import defaultdict
totaux = defaultdict(int)
for d in depenses:
    totaux[d["categorie"]] += d["montant"]
```

C'est une différence culturelle importante. En JavaScript, `reduce` était l'outil central. En Python, on préfère `sum`, `max`, `min` pour les agrégats simples, et une **boucle lisible** (souvent avec `defaultdict`) pour les groupements. `functools.reduce` existe, mais l'utiliser systématiquement te fait écrire du JavaScript en Python. Le groupement par `defaultdict` est l'idiome à retenir — c'est le `reduce` vers un objet du palier 1, en version Python.

### Le tri avec `key`

```python
# sorted retourne une NOUVELLE liste (ne mute pas)
tries = sorted(depenses, key=lambda d: d["montant"], reverse=True)

# .sort() mute la liste en place
depenses.sort(key=lambda d: d["date"])
```

Note la distinction, familière depuis le palier 1 : `sorted(...)` retourne une nouvelle liste, `.sort()` modifie en place. Et le `key=lambda ...` est l'exact équivalent du comparateur de `.sort()` en JavaScript — sauf qu'on donne la **valeur** sur laquelle trier, pas une comparaison. C'est plus simple : pas de piège du tri par chaîne comme au palier 1.

### `*args` et `**kwargs`

```python
# *args : nombre variable d'arguments POSITIONNELS → un tuple
def somme(*nombres):
    return sum(nombres)
somme(1, 2, 3, 4)                         # 10

# **kwargs : nombre variable d'arguments NOMMÉS → un dictionnaire
def creer_depense(**champs):
    return {"id": 1, **champs}
creer_depense(montant=1500, categorie="food")

# Le dépaquetage à l'appel : l'équivalent du spread
nombres = [1, 2, 3]
somme(*nombres)                           # dépaquète la liste en arguments
config = {"montant": 1500, "categorie": "food"}
creer_depense(**config)                   # dépaquète le dict en arguments nommés
```

Tu reconnais le `...rest` et le `...spread` du palier 1 (leçon 07). `*args` regroupe les positionnels dans un tuple, `**kwargs` les nommés dans un dictionnaire, et `*`/`**` à l'appel font l'inverse — ils dépaquètent. C'est ce mécanisme qui permet aux fonctions de transmettre des arguments qu'elles ne connaissent pas, et c'est pour ça qu'on le voit dans les décorateurs.

### Les fonctions comme valeurs, et les lambda

```python
# Une fonction passée en argument (callback)
def appliquer(fonction, valeur):
    return fonction(valeur)
appliquer(lambda x: x * 2, 5)             # 10

# Une fonction qui retourne une fonction (closure — palier 1, leçon 05)
def creer_multiplicateur(facteur):
    def multiplier(n):
        return n * facteur
    return multiplier
tripler = creer_multiplicateur(3)
tripler(5)                                # 15

# Une table de fonctions — comme ta table de commandes du palier 1
commandes = {
    "add": ajouter_depense,
    "list": lister_depenses,
}
commandes["add"](args)
```

Tout cela est le palier 1, en Python : les fonctions sont des valeurs, les closures existent (`multiplier` se souvient de `facteur`), et une table de fonctions remplace un gros `if/elif`. La **lambda** est la fonction fléchée courte — mais limitée à **une seule expression**. Dès que la logique dépasse une ligne, on nomme la fonction avec `def`. C'est la règle culturelle : les lambda restent minuscules.

### Quand revenir à une boucle

```python
# ✅ Comprehension : simple, lisible
noms = [d["description"] for d in depenses if d["montant"] > 0]

# ❌ Comprehension trop chargée : illisible
resultat = [transformer(d) for groupe in groupes for d in groupe if d["ok"] and d["montant"] > seuil]

# ✅ La même chose en boucle : on retrouve la lisibilité
resultat = []
for groupe in groupes:
    for d in groupe:
        if d["ok"] and d["montant"] > seuil:
            resultat.append(transformer(d))
```

La règle est celle du palier 1 : **le déclaratif n'est une qualité que s'il reste lisible**. Une comprehension sur une ligne avec un `if` est pythonique ; une comprehension à double boucle avec deux conditions est illisible, et une boucle nommée vaut mieux.

---

## Les problèmes que tu vas rencontrer

**Ma comprehension est illisible.** Elle fait plus d'une ligne, ou elle a deux boucles et deux conditions. Reviens à une boucle `for`.

**`reduce` ne marche pas comme en JavaScript.** Il faut l'importer (`from functools import reduce`), et surtout, ce n'est pas l'outil pythonique : utilise `sum`, ou une boucle avec `defaultdict` pour un groupement.

**Ma lambda ne peut pas contenir plusieurs instructions.** Une lambda est limitée à **une expression**. Pas de `if/else` complet (mais le ternaire `a if cond else b` est permis), pas de boucle. Nomme la fonction avec `def`.

**`*args` me donne un tuple, pas une liste.** C'est normal : `*args` collecte en tuple (immuable). Convertis avec `list(args)` si tu as besoin de le modifier.

**Mon `**kwargs` ne transmet rien.** Tu as oublié le `**` à l'appel. `f(**mon_dict)` dépaquète ; `f(mon_dict)` passe le dictionnaire comme un seul argument.

**Ma comprehension de dictionnaire écrase des valeurs.** Si deux éléments ont la même clé, le dernier gagne — comme un `{...a, ...b}` en JavaScript. C'est attendu, mais surprend si les clés ne sont pas uniques.

**`sorted` ne trie pas comme je veux.** Tu as donné une comparaison au lieu d'une **valeur**. En Python, `key` retourne la valeur sur laquelle trier, pas un résultat de comparaison. `key=lambda d: d["montant"]`, pas une soustraction.

---

## Ce qu'on te demandera

En **entretien Python**, les comprehensions sont presque certaines : « réécris cette boucle en comprehension », « quelle différence entre une comprehension de liste et de dictionnaire ? ». On teste ainsi si tu écris du Python ou du code traduit.

On peut demander : « à quoi servent `*args` et `**kwargs` ? », « qu'est-ce qu'une lambda et quelle est sa limite ? », « comment tries-tu une liste d'objets ? ».

En **test technique**, les exercices de transformation de données se résolvent naturellement avec des comprehensions — et c'est ce qu'on attend de voir.

---

## Ce qui te démarquera

**Écrire des comprehensions lisibles — et savoir s'arrêter.** La maîtrise ne consiste pas à tout condenser, mais à savoir quand une comprehension aide et quand une boucle est plus claire. C'est le même jugement qu'au palier 1 avec le chaînage.

**Utiliser `sum` et `defaultdict` plutôt que `reduce`.** C'est le marqueur le plus net d'un développeur qui a adopté la culture Python, et pas seulement sa syntaxe.

**Limiter les lambda au minimum.** Nommer les fonctions non triviales montre que tu connais la convention, là où quelqu'un qui vient de JavaScript met des lambda partout.

**Comprendre `**kwargs` dans les frameworks.** Pouvoir lire `def vue(**kwargs)` et savoir ce que ça fait te rendra les leçons suivantes beaucoup plus faciles.

**Et reconnaître l'index.** Dire « cette comprehension de dictionnaire, c'est l'index que je construisais avec `reduce` au palier 1 » prouve que tu transfères un concept, pas une recette.

---

## 📚 À lire

**docs.python.org → *The Python Tutorial → List Comprehensions*** et la section sur les dictionnaires : la référence officielle, courte.

**Real Python → *When to Use a List Comprehension in Python*** : un bon article sur la limite entre comprehension et boucle, qui est le vrai sujet de la leçon.

**docs.python.org → *More on Defining Functions*** pour `*args`/`**kwargs` et les arguments par défaut.

**Exercism, piste Python** : les exercices de transformation de collections sont parfaits pour pratiquer les comprehensions avec correction.

---

## 🤖 Le mini-projet à demander à l'IA

L'exercice de transfert direct depuis le palier 1 :

> « Je suis en formation de développeur, palier 5. J'ai fait au palier 1 une leçon entière sur map/filter/reduce en JavaScript, avec 18 exercices sur un jeu de dépenses. Donne-moi **les mêmes 18 exercices**, mais à résoudre en Python avec des comprehensions, `sum`, `sorted` et `defaultdict`. Présente-les un par un, sans solution. Après chaque réponse, dis-moi : est-ce **pythonique** (comprehension plutôt que boucle+append, sum plutôt que reduce, defaultdict pour le groupement) ou est-ce du JavaScript traduit ? Et pour les cas où une boucle serait **plus lisible** qu'une comprehension, dis-le-moi. »

Faire exactement les mêmes exercices que le palier 1 dans l'autre langage est le cœur de la méthode de transfert du parcours.

Puis l'exercice sur `**kwargs`, qui prépare les frameworks :

> « Montre-moi 5 exemples **lus dans du vrai code de framework Python** (Flask, Django) qui utilisent `*args`, `**kwargs` ou le dépaquetage `**`. Pour chacun, demande-moi d'expliquer en français **ce que ça fait et pourquoi c'est là**, avant de me confirmer. Je veux pouvoir lire ce mécanisme quand je le croiserai dans les prochaines leçons. »

---

## 🛠️ À faire

1. **Les trois comprehensions** : à partir de ton jeu de dépenses, écris une comprehension de liste (les montants), de dictionnaire (un index par id), et de set (les catégories uniques).
2. **map + filter en une comprehension** : les montants TTC des dépenses de la catégorie « food ».
3. **Le transfert** : reprends 10 des exercices map/filter/reduce du palier 1 (leçon 06) et refais-les en Python.
4. **`reduce` à la pythonique** : écris un total avec `sum`, puis un total par catégorie avec `defaultdict`. Compare avec ce que tu aurais écrit avec `functools.reduce` et dis lequel est plus clair.
5. **Le tri** : trie tes dépenses par montant décroissant avec `sorted` et `key`, puis par date croissante. Vérifie que `sorted` ne modifie pas l'original.
6. **`*args`** : écris une fonction `somme` qui accepte un nombre variable d'arguments, puis appelle-la en dépaquetant une liste.
7. **`**kwargs`** : écris `creer_depense(**champs)` et appelle-la en dépaquetant un dictionnaire.
8. **Fonctions-valeurs** : écris une table de commandes (un dictionnaire de fonctions) comme au palier 1, et appelle la bonne fonction selon une entrée.
9. **Une closure** : écris `creer_compteur` en Python et vérifie qu'elle se souvient de son état. Compare avec la version JavaScript du palier 1.
10. **La limite de lisibilité** : écris une comprehension volontairement trop chargée, constate qu'elle est illisible, et réécris-la en boucle nommée.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** L'index par id — `{d["id"]: d for d in depenses}` — est à reconnaître : c'est exactement l'index que tu construisais avec `reduce` au palier 1 (leçon 12) pour passer d'une recherche `O(n)` à un accès `O(1)`. Le concept transféré, la syntaxe nouvelle.

**4.**
```python
# pythonique et clair
total = sum(d["montant"] for d in depenses)

from collections import defaultdict
par_categorie = defaultdict(int)
for d in depenses:
    par_categorie[d["categorie"]] += d["montant"]
```
La version `functools.reduce(lambda acc, d: ..., depenses, 0)` fonctionne mais personne ne l'écrit en Python : c'est le réflexe JavaScript. `sum` pour un total, une boucle avec `defaultdict` pour un groupement — c'est l'idiome, et un relecteur Python le préférera toujours.

**5.** `key=lambda d: d["montant"]` donne la **valeur** sur laquelle trier ; Python s'occupe de la comparaison. C'est plus simple qu'en JavaScript, où tu devais écrire `(a, b) => b.montant - a.montant` et où un `sort()` sans comparateur triait par chaîne (le piège du palier 1). En Python, pas de ce piège : `sorted` trie les nombres comme des nombres.

**10.** La leçon à écrire : une comprehension avec deux boucles imbriquées et deux conditions tient peut-être sur une ligne, mais elle est illisible. La boucle équivalente, sur quatre lignes indentées, se comprend d'un coup d'œil. **La concision n'est pas la lisibilité** — c'est exactement la conclusion de la leçon 06 du palier 1.
</details>

---

## ✅ Acquis si…

- [ ] J'écris des comprehensions de liste, de dictionnaire et de set à la place de mes boucles simples.
- [ ] Je sais reconnaître la comprehension de dictionnaire comme l'index du palier 1.
- [ ] J'utilise `sum`, `max`, `min` et `defaultdict` plutôt que `functools.reduce`.
- [ ] Je trie avec `sorted` et `key`, et je sais que `sorted` ne mute pas.
- [ ] J'utilise `*args` et `**kwargs`, et je sais dépaqueter avec `*` et `**` à l'appel.
- [ ] Je limite les lambda à une expression, et je nomme les vraies fonctions.
- [ ] J'écris une table de fonctions et une closure en Python.
- [ ] Je sais quand une boucle est **plus lisible** qu'une comprehension.
- [ ] J'ai refait des exercices du palier 1 en Python idiomatique.

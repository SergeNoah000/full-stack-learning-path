# Leçon 01 — Le langage Python

> 🎯 **À la fin de cette leçon** : tu écris du Python idiomatique et typé, et tu sais déjà traduire ce que tu connais de JavaScript vers sa syntaxe — parce que les concepts, eux, ne changent pas.
> ⏱️ 4 h · **Prérequis** : [épreuve du palier 4](../../palier-04-backend-node/evaluation.md) réussie.

---

## De quoi on parle

Python est un **langage généraliste**, lisible, à la bibliothèque standard très fournie, et dominant dans trois mondes : le web, la data et l'IA. C'est ton **deuxième** langage, et tu l'abordes dans une situation très différente du palier 1 : tu sais déjà programmer. Tu n'apprends donc pas la programmation — tu apprends comment Python exprime ce que tu maîtrises déjà.

Quelques spécificités à poser. L'**indentation est significative** : elle remplace les accolades, et un décalage est une erreur de syntaxe. Le typage est **dynamique** comme en JavaScript, mais la culture du langage encourage les **annotations de type** (les *type hints*), vérifiées par un outil séparé, `mypy`. Les structures de base sont la **liste**, le **dictionnaire**, le **tuple** et le **set**. Et chaque projet vit dans un **environnement virtuel** (`venv`), isolé des autres.

---

## À quoi ça sert, concrètement

**Parce que c'est la porte d'entrée de la data et de l'IA.** JavaScript règne sur le navigateur ; Python règne sur tout ce qui touche aux données et à l'apprentissage automatique. Les bibliothèques d'IA, les outils d'analyse, les scripts d'automatisation sont en Python. C'est le langage qui t'ouvre ces domaines — et au palier 5, tu feras ton premier appel à une API d'IA avec lui.

**Parce que le transfert est l'essentiel de l'apprentissage ici.** Tu ne réapprends pas les boucles, les fonctions, l'asynchrone ou la complexité : tu les retrouves sous une autre forme. L'exercice le plus efficace du palier — refaire en Python des katas déjà résolus en JavaScript — repose entièrement sur ce principe. Ce que tu as compris une fois au palier 1 te sert une seconde fois ici, presque gratuitement.

**Parce que Python est réputé pour sa lisibilité**, et que cette réputation a une base : la philosophie du langage privilégie « une seule façon évidente de faire ». Après la souplesse parfois déroutante de JavaScript, c'est reposant — et c'est une qualité recherchée dans les projets d'équipe.

**Et parce que les type hints vont te plaire.** Tu viens de TypeScript (palier 3) : tu sais déjà pourquoi typer. Python offre le même bénéfice de documentation et de vérification, avec la même limite — les annotations ne sont pas vérifiées à l'exécution, ce qui ramène la frontière de validation que tu connais bien.

---

## Où ça intervient dans le développement

Cette leçon est le socle du palier : tout ce qui suit — WSGI, le mini-framework, Flask, FastAPI, Django — s'écrit dans ce langage.

```
   LE LANGAGE Python          ← cette leçon
        ▼
   le web SANS framework (WSGI, mini-framework maison)   ← leçons 04-08
        ▼
   Flask → FastAPI → Django   ← leçons 09-11
```

Trois points structurants.

**Les concepts viennent du palier 1, la syntaxe est nouvelle.** Variables, conditions, boucles, fonctions, structures de données, erreurs, asynchrone, complexité : tu as tout vu. Cette leçon est une **table de traduction**, pas un cours de programmation. C'est pour cela qu'elle est courte pour un premier contact avec un langage.

**Les type hints prolongent TypeScript.** `def total(depenses: list[Depense]) -> int:` est l'exact équivalent de ce que tu écrivais en TypeScript. Et au palier 5, Pydantic (avec FastAPI) jouera le rôle de Zod : valider à l'exécution **et** produire le type. La frontière du palier 1 réapparaît, dans un troisième langage.

**Et l'environnement virtuel est la version Python d'une leçon déjà apprise.** Au palier 0, tu as installé Node par `nvm` pour isoler les versions ; au palier 4, tu as géré des dépendances avec `npm`. Le `venv` et `pip` font la même chose en Python, et la règle est identique : un environnement par projet, jamais d'installation globale.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas aller vite, et c'est normal : tu reconnais tout. Les pièges seront ailleurs — l'indentation qui doit être cohérente, les deux-points en fin de ligne, et quelques faux amis (`==` qui est correct en Python, contrairement à JavaScript où tu avais appris `===`).

Tu vas aussi oublier d'activer ton `venv` et installer des paquets au mauvais endroit. C'est le passage obligé, et les exercices te feront l'expérimenter.

### En équipe, en entreprise

**Les type hints sont attendus sur du code neuf**, et `mypy` tourne souvent dans le pipeline — exactement comme `tsc` pour TypeScript.

**Le formatage est automatique et non négociable.** L'outil `ruff` (ou l'ancien couple `black` + `flake8`) formate et vérifie le code. Personne ne débat de l'emplacement des espaces : l'outil tranche. Tu rencontreras aussi la convention **PEP 8**, le guide de style officiel.

**Le `venv` est universel**, parfois sous une forme plus moderne (`uv`, `poetry`, `pipenv`). Le principe ne change pas : isoler les dépendances par projet, et les figer dans un fichier (`requirements.txt` ou `pyproject.toml`).

**Et tu rencontreras les deux versions de Python.** Python 3 partout en 2026, mais du code ancien traîne encore, et la bibliothèque standard évolue. Vérifie la version dans la documentation, comme pour tout.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : listes, dictionnaires, boucles `for`, fonctions, f-strings, comprehensions (leçon 02), type hints, `venv` et `pip`, et la bibliothèque standard.

Régulièrement : tuples et sets, `enumerate` et `zip`, `with` (le gestionnaire de contexte), les exceptions, les modules et imports, `pathlib`.

Rare, et hors sujet pour l'instant : les métaclasses, les décorateurs avancés (tu en utiliseras des tout faits dès Flask, mais tu n'en écriras pas), les générateurs complexes, le *monkey patching*, `__slots__`, la surcharge d'opérateurs, l'asynchrone (`asyncio` — réservé à la leçon FastAPI). Et un piège culturel : Python a beaucoup de « sucre » que les débutants veulent tout utiliser. Résiste — le code le plus simple est le plus pythonique.

---

## La mécanique

### L'environnement virtuel, d'abord

```bash
python3 --version                       # 3.11+ attendu
python3 -m venv .venv                    # crée l'environnement dans le projet
source .venv/bin/activate                # l'active (le prompt change)
pip install mypy ruff                    # installe DANS l'environnement
pip freeze > requirements.txt            # fige les versions
deactivate                               # le désactive
```

> ⚠️ **Toujours activer le `venv` avant `pip install`.** Sans lui, tu installes dans le Python système, tu provoques des conflits entre projets, et tu obtiens le classique « ça marchait hier ». C'est la version Python de la règle `nvm` du palier 0.

### Variables et types de base

```python
nom = "Serge"                   # pas de mot-clé (ni let, ni const)
montant = 1500                  # int
prix = 15.99                    # float
paye = True                     # ⚠️ majuscule, comme False et None
rien = None                     # l'équivalent de null/undefined (il n'y en a qu'un)

# Constante : par CONVENTION, en majuscules (rien ne l'empêche de changer)
TVA = 0.1925
```

La différence qui surprend le plus en venant de JavaScript : **pas de `const`**. Python n'a pas d'immuabilité de variable ; la convention (majuscules) remplace la garantie. C'est moins strict que ce que tu avais au palier 1 — et c'est une raison de plus d'adopter les type hints et un bon linter.

Et `None`, `True`, `False` prennent une majuscule : c'est une erreur de syntaxe sinon.

### Les comparaisons : attention au faux ami

```python
5 == 5          # True — et ici c'est CORRECT, contrairement à JS
5 == "5"        # False — Python ne convertit pas silencieusement
a is None       # ⭐ pour None, on utilise `is`, pas `==`
```

Bonne nouvelle venant de JavaScript : **`==` en Python se comporte comme `===` en JavaScript** — pas de conversion sournoise. Le piège `"5" == 5` n'existe pas. En revanche, pour tester `None`, on utilise `is` (identité) et non `==`.

### Les chaînes et les f-strings

```python
prenom = "Serge"
complet = f"{prenom} Noah"               # f-string : l'équivalent des template literals
message = f"Total : {montant} FCFA"
calcul = f"TTC : {montant * 1.1925:.2f}" # formatage : .2f pour deux décimales

complet.upper()                           # "SERGE NOAH"
complet.lower()
"  espace  ".strip()                      # "espace"
complet.split(" ")                        # ["Serge", "Noah"]
complet.replace("Serge", "S.")
"Noah" in complet                         # True — `in` teste l'appartenance
```

Les f-strings sont l'équivalent direct des template literals du palier 1. Comme les chaînes JavaScript, **les chaînes Python sont immuables** : `.strip()` retourne une nouvelle chaîne, elle ne modifie pas l'originale. Le réflexe de la leçon 01 du palier 1 s'applique tel quel.

### Les structures de données

```python
# LISTE — l'équivalent du tableau JS, modifiable
depenses = [1500, 3000, 500]
depenses.append(2000)                     # push
depenses[0]                               # 1500
depenses[-1]                              # ⭐ 2000 — index négatif : depuis la fin
depenses[1:3]                             # [3000, 500] — tranche (slice)
len(depenses)                             # 4

# DICTIONNAIRE — l'équivalent de l'objet JS
depense = {"montant": 1500, "categorie": "food"}
depense["montant"]                        # 1500
depense["paye"] = True                    # ajouter
depense.get("note", "aucune")             # ⭐ valeur par défaut si la clé manque
"montant" in depense                      # True

# TUPLE — une liste IMMUABLE
point = (4.05, 9.70)                      # ne peut plus changer

# SET — valeurs uniques (comme Set en JS)
categories = {"food", "transport", "food"}  # {"food", "transport"}
```

Les correspondances avec le palier 1 : liste ↔ tableau, dictionnaire ↔ objet, set ↔ `Set`. Le tuple est la nouveauté — une liste qu'on ne peut pas modifier, utile pour des données qui ne doivent pas changer (des coordonnées, un retour de fonction à plusieurs valeurs).

Deux pièges d'accès, et c'est la différence avec JavaScript : `depense["inexistant"]` **lève une exception** (`KeyError`), là où `objet.inexistant` en JavaScript donnait `undefined`. D'où `depense.get("cle", defaut)` quand la clé peut manquer — c'est l'équivalent du `?.` et du `??` du palier 1.

### Conditions et boucles

```python
if montant <= 0:
    print("invalide")
elif montant > budget:                    # elif, pas "else if"
    print("dépassement")
else:
    print("ok")

# for : TOUJOURS sur un itérable (comme for...of), jamais d'index à la main
for depense in depenses:
    print(depense)

for i, depense in enumerate(depenses):    # ⭐ si tu as besoin de l'index
    print(i, depense)

# range pour répéter N fois
for i in range(5):                        # 0, 1, 2, 3, 4
    print(i)

while reponse != "quit":
    reponse = input()
```

Le `for` de Python est le `for...of` de JavaScript : il parcourt directement les éléments, et c'est **la** façon de faire. Le `for (let i = 0; ...)` n'existe pas — pour un index, on utilise `enumerate`, et c'est plus propre.

### Les fonctions

```python
def calculer_total(depenses: list[dict]) -> int:        # snake_case + type hints
    """Additionne les montants d'une liste de dépenses."""   # docstring
    return sum(d["montant"] for d in depenses)

def formater(montant: int, devise: str = "FCFA") -> str:     # valeur par défaut
    return f"{montant} {devise}"

formater(1500)                            # "1500 FCFA"
formater(1500, devise="EUR")              # ⭐ argument nommé — très courant en Python
```

Trois conventions à adopter immédiatement. Les noms sont en **`snake_case`** (`calculer_total`), pas en `camelCase` — c'est la convention Python, et ton linter te le rappellera. La **docstring** (la chaîne sous la signature) documente la fonction. Et les **arguments nommés** (`devise="EUR"`) sont une pratique courante qui rend les appels lisibles — l'équivalent du « passer un objet » du palier 1, mais intégré au langage.

### Les type hints, en détail

```python
def total(depenses: list[int]) -> int: ...
def trouver(id: int) -> dict | None: ...           # union, comme en TypeScript
nom: str = "Serge"
montants: list[int] = []
config: dict[str, int] = {}
```

Tu reconnais TypeScript. La syntaxe diffère (`list[int]` au lieu de `number[]`, `dict | None` au lieu de `T | null`), le principe est identique — et la limite aussi : **les type hints ne sont pas vérifiés à l'exécution**. `mypy` les vérifie avant, comme `tsc`. La validation des données entrantes reste donc nécessaire à la frontière, et ce sera Pydantic au palier 5.

```bash
mypy mon_fichier.py                       # vérifie les types, comme tsc --noEmit
ruff check .                              # vérifie le style
ruff format .                             # formate
```

### Les exceptions

```python
try:
    montant = int(saisie)                 # peut lever ValueError
except ValueError:
    print("Montant invalide")
    montant = 0
finally:
    print("terminé")

# Lever une exception
if montant <= 0:
    raise ValueError(f"Montant invalide : {montant}")
```

C'est le `try/catch/finally` du palier 1, avec deux différences de vocabulaire : `except` au lieu de `catch`, et `raise` au lieu de `throw`. Python a aussi une culture du « demander pardon plutôt que la permission » : on tente l'opération et on gère l'exception, plutôt que de tout vérifier avant.

### Classes et modules

```python
class Portefeuille:
    def __init__(self, solde: int = 0):   # le constructeur
        self.solde = solde                 # self, l'équivalent de this

    def deposer(self, montant: int) -> None:
        self.solde += montant

p = Portefeuille(1000)
p.deposer(500)
```

```python
# depenses.py
def calculer_total(depenses): ...

# autre fichier
from depenses import calculer_total        # import nommé
import depenses                            # import du module entier
```

Les classes réapparaîtront vraiment au palier 6 (PHP) et dans les frameworks. Pour l'instant, retiens `self` (l'équivalent de `this`) et `__init__` (le constructeur).

---

## Les problèmes que tu vas rencontrer

**`IndentationError` ou `TabError`.** Ton indentation est incohérente — un mélange d'espaces et de tabulations, ou un décalage. En Python, l'indentation **est** la syntaxe. Configure ton éditeur pour 4 espaces, et le problème disparaît.

**`SyntaxError` sur une ligne qui semble correcte.** Souvent un deux-points oublié en fin de `if`, `for`, `def` ou `class`.

**`KeyError`.** Tu accèdes à une clé de dictionnaire qui n'existe pas. En Python, ça lève une exception (contrairement à l'`undefined` de JavaScript). Utilise `.get(cle, defaut)`.

**`ModuleNotFoundError` après un `pip install`.** Ton `venv` n'est pas activé, ou tu l'as installé ailleurs. `source .venv/bin/activate`.

**`None` comparé avec `==` au lieu de `is`.** Ça marche souvent, mais `is` est correct et attendu pour `None`.

**Mon `mypy` ne voit pas d'erreur alors que mon code plante.** Les type hints ne sont pas vérifiés à l'exécution : une donnée externe peut ne pas correspondre. C'est la frontière — valide à l'entrée.

**Mes noms sont en `camelCase` et le linter proteste.** Python utilise `snake_case`. C'est culturel, et c'est imposé par les outils.

**Une liste modifiée alors que je croyais travailler sur une copie.** Comme en JavaScript, les listes et dictionnaires sont passés par **référence** (palier 1, leçon 04). `copie = liste[:]` ou `copie = liste.copy()` pour une vraie copie superficielle ; `copy.deepcopy()` pour profonde.

---

## Ce qu'on te demandera

En **entretien**, si le poste est Python, on vérifiera que tu connais les structures de base, les comprehensions (leçon 02), les type hints, et le `venv`. On te demandera souvent : « quelle différence entre une liste et un tuple ? », « qu'est-ce qu'un environnement virtuel et pourquoi ? », « les type hints sont-ils vérifiés à l'exécution ? ».

Pour un profil comme le tien, une question revient : **« tu connais JavaScript et Python — qu'est-ce qui change vraiment entre les deux ? »**. La bonne réponse parle des concepts identiques et des différences de syntaxe et de culture, pas d'une préférence.

En **test technique**, on te donnera un petit exercice algorithmique — et ce sont tes katas du palier 1, dans l'autre langage.

---

## Ce qui te démarquera

**Reconnaître que tu transfères.** Dire « c'est le même concept qu'en JavaScript, avec une autre syntaxe » montre que tu as une vraie compréhension, pas une collection de recettes par langage. C'est exactement ce que le parcours cherche à construire.

**Du code pythonique, pas du JavaScript traduit.** Utiliser `enumerate` au lieu d'un index manuel, les arguments nommés, les comprehensions (leçon 02), `.get()` au lieu d'un `try/except` sur une clé. Un relecteur Python voit immédiatement si tu écris du Python ou du JavaScript déguisé.

**Les type hints partout, avec `mypy` au vert.** Tu viens de TypeScript : c'est un avantage, utilise-le.

**Le `venv` systématique.** Et un `requirements.txt` à jour. C'est la base de l'hygiène Python, et beaucoup de débutants la négligent.

**Et la simplicité.** Python récompense le code direct. Résister à la tentation d'utiliser toutes les fonctionnalités du langage est une marque de maturité — « lisible » bat « astucieux ».

---

## 📚 À lire

**docs.python.org → *The Python Tutorial*** : le tutoriel officiel, complet et bien écrit. Survole-le en ciblant ce qui diffère de JavaScript — tu n'as pas besoin de tout lire.

**Exercism, piste Python** : des exercices avec **mentorat humain gratuit**. C'est la meilleure ressource pour transférer, et le format par petits exercices corrigés est idéal.

**Real Python** (realpython.com) : des articles de qualité sur des points précis, à consulter par besoin.

**PEP 8** (le guide de style) et **PEP 484** (les type hints) en survol : ce sont les textes de référence, mais ton linter les applique pour toi.

Et *Python Crash Course* (Eric Matthes) si tu veux un support papier structuré.

---

## 🤖 Le mini-projet à demander à l'IA

Le fil rouge IA de ce palier t'autorise l'usage « accélérateur de langages » — mais pour **transférer**, pas pour sauter l'apprentissage.

> « Je suis en formation de développeur, palier 5. Je connais bien JavaScript et TypeScript, et j'apprends Python. Donne-moi une **table de traduction** des 15 constructions que j'utilise le plus en JavaScript (déclaration de variable, fonction, map/filter/reduce, destructuring, spread, template literal, async/await, classe, try/catch, import…), avec leur équivalent Python — **mais présente-la comme un quiz** : montre-moi le code JavaScript, et je dois écrire l'équivalent Python avant que tu me confirmes. Corrige en pointant ce qui n'est **pas** pythonique dans ma version (un index manuel au lieu d'enumerate, un try/except au lieu de .get, du camelCase…). »

C'est l'exercice de transfert le plus efficace : il part de ce que tu sais, et il te signale quand tu écris du « JavaScript en Python ».

Puis le transfert d'un vrai morceau de ton code :

> « Voici une fonction que j'ai écrite en JavaScript au palier 1 [colle-la]. Sans me donner la solution, guide-moi pour la réécrire en Python **idiomatique** et typée : pose-moi des questions sur la structure de données à choisir, les type hints à mettre, et la façon pythonique de faire ce que je faisais avec map/filter/reduce. Compare ensuite ma version à ce que tu attendais. »

---

## 🛠️ À faire

1. **Mets en place l'environnement** : `venv` activé, `mypy` et `ruff` installés, `requirements.txt` généré. Désactive et réactive pour voir le `pip install` échouer hors du `venv`.
2. **Les structures** : crée une liste de dépenses (des dictionnaires), accède au premier et au dernier élément, à une tranche, ajoute et retire un élément.
3. **Le piège `KeyError`** : accède à une clé inexistante d'un dictionnaire, constate l'exception, puis utilise `.get()` avec une valeur par défaut.
4. **Les faux amis** : vérifie que `5 == "5"` est `False`, et teste `None` avec `is` puis avec `==`.
5. **Fonctions typées** : écris `calculer_total`, `filtrer_par_categorie`, `formater_montant`, toutes avec type hints et docstring. Lance `mypy` et vise zéro erreur.
6. **`enumerate` et arguments nommés** : écris une fonction qui affiche les dépenses numérotées, et appelle `formater_montant` avec un argument nommé.
7. **Exceptions** : écris une fonction qui convertit une saisie en montant, en gérant `ValueError`. Compare avec ce que tu faisais en JavaScript.
8. **Le transfert** : reprends trois fonctions de ton projet 1 (JavaScript) et réécris-les en Python idiomatique et typé.
9. **La référence** : démontre qu'une liste passée à une fonction est modifiée par référence, puis corrige avec une copie. Compare avec le bug équivalent du palier 1, leçon 04.
10. **Le linter** : écris volontairement du code en `camelCase` avec un mauvais formatage, lance `ruff check`, et corrige.
11. **Une classe** : écris `Portefeuille` avec `__init__`, `deposer` et `lire`. Note la correspondance avec `self`/`this`.

<details>
<summary>Corrections et points de contrôle</summary>

**3.** `depense["inexistant"]` lève `KeyError` — c'est une différence majeure avec JavaScript, où l'accès à une propriété absente donnait `undefined`. `depense.get("inexistant", "défaut")` ne lève jamais : c'est l'équivalent pythonique du `?.`/`??`. La leçon : en Python, l'absence est souvent une **exception**, pas une valeur silencieuse — c'est culturel, et c'est plus sûr.

**5.**
```python
def calculer_total(depenses: list[dict]) -> int:
    """Additionne les montants d'une liste de dépenses."""
    return sum(d["montant"] for d in depenses)   # ⭐ pythonique : sum + expression génératrice
```
Si tu as écrit une boucle `for` avec un accumulateur, ça marche, mais `sum(...)` est la façon pythonique — et c'est un avant-goût des comprehensions de la leçon 02.

**8.** Les erreurs de transfert les plus fréquentes : écrire une boucle avec un index manuel au lieu d'un `for ... in`, utiliser `camelCase`, reconstruire `map`/`filter` avec des boucles au lieu d'une comprehension (leçon 02), oublier les type hints. Ce sont ces écarts qui distinguent « du Python » de « du JavaScript écrit en Python ».

**9.** Comme en JavaScript, `def f(liste): liste.append(1)` modifie la liste de l'appelant : listes et dictionnaires sont passés par référence. C'est **exactement** le bug de la « fausse copie » du palier 1, leçon 04 — et la preuve que ce concept était bien transférable. La copie : `liste[:]`, `liste.copy()`, ou `copy.deepcopy()` pour les structures imbriquées.
</details>

---

## ✅ Acquis si…

- [ ] J'active mon `venv` avant tout `pip install`, et je maintiens un `requirements.txt`.
- [ ] J'utilise listes, dictionnaires, tuples et sets, et je sais à quoi correspond chacun en JavaScript.
- [ ] Je sais que l'accès à une clé absente lève `KeyError`, et j'utilise `.get()`.
- [ ] Je sais que `==` en Python se comporte comme `===` en JavaScript, et que `None` se teste avec `is`.
- [ ] J'écris des fonctions en `snake_case`, avec type hints et docstring, et `mypy` est au vert.
- [ ] J'utilise `enumerate` et les arguments nommés au lieu d'un index manuel.
- [ ] Je gère les exceptions avec `try/except/finally` et je lève avec `raise`.
- [ ] J'ai transféré des fonctions de mon projet 1 en Python **idiomatique**, pas en JavaScript déguisé.
- [ ] Je sais que les type hints ne sont pas vérifiés à l'exécution.
- [ ] Je reconnais quand je transfère un concept plutôt que de l'apprendre.

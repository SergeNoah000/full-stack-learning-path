# Leçon 03 — Classes, modules, `venv`, type hints et `mypy`

> 🎯 **À la fin de cette leçon** : tu organises un projet Python en modules, tu écris des classes propres, et ton code est typé et vérifié.
> ⏱️ 4 h · **Prérequis** : leçons 01–02.

---

## De quoi on parle

Une **classe** est un moule : elle décrit des données (les attributs) et des comportements (les méthodes), et on en crée des instances. Python en fait un usage plus fréquent que JavaScript, notamment dans les frameworks.

Un **module** est un fichier `.py`, et un **paquet** (*package*) est un dossier de modules. Les **imports** relient le tout. C'est l'organisation d'un projet Python.

Le **`venv`** isole les dépendances d'un projet (vu à la leçon 01, approfondi ici avec la structure de projet). Les **type hints** annotent les types, et **`mypy`** les vérifie — tu en as la logique depuis TypeScript (palier 3).

Et quelques outils du langage qui reviendront : les **dataclasses** (des classes de données sans code répétitif), les **gestionnaires de contexte** (`with`), et les **exceptions personnalisées**.

---

## À quoi ça sert, concrètement

**Parce que les frameworks Python sont construits sur des classes.** Les vues de Django, les modèles, les serializers de DRF, les schémas Pydantic de FastAPI : tout est classe. Tu n'écriras pas beaucoup de classes toi-même au début, mais tu en **liras** et en **hériteras** constamment. Comprendre `class MaVue(APIView):` est indispensable pour les leçons 10 et 11.

**Parce que l'organisation en modules est ce qui rend un projet maintenable.** Un fichier de deux mille lignes est impossible à faire évoluer. Les modules et paquets permettent le découpage en couches que tu as appris au palier 4 (routes, services, dépôts) — en Python, ce sont des fichiers et des dossiers.

**Parce que les dataclasses suppriment du bruit.** Déclarer une classe de données en Python demandait un constructeur répétitif ; les dataclasses l'écrivent pour toi. C'est un gain de lisibilité direct, et c'est l'ancêtre conceptuel des modèles Pydantic.

**Et parce que le typage prolonge ton avantage de TypeScript.** Tu sais déjà pourquoi typer et où est la limite. Python t'offre le même outil ; l'utiliser dès maintenant te distingue de beaucoup de développeurs Python qui ne typent pas.

---

## Où ça intervient dans le développement

Cette leçon donne les briques d'organisation pour tout le reste du palier :

```
   un fichier .py            = un MODULE
   un dossier de modules     = un PAQUET
        ▼
   découpage en couches (comme au palier 4) : vues / services / dépôts
        ▼
   les CLASSES des frameworks : class MaVue(APIView), class Depense(models.Model)
```

Trois points de transfert.

**Le découpage en couches du palier 4 se transpose en modules Python.** `routes/`, `services/`, `depots/` deviennent des fichiers et des paquets. La règle ne change pas : les services ne connaissent pas HTTP, et le test « mon service est-il appelable sans serveur web ? » reste valide. Tu construiras ton mini-framework (leçons 04-08) sur cette organisation.

**Les classes préparent `self` de PHP.** Au palier 6, `$this` en PHP jouera le même rôle que `self` en Python. Et l'héritage que tu vois ici (`class Enfant(Parent)`) est exactement ce que les frameworks exploitent — y compris Laravel au palier 6.

**Et les dataclasses préfigurent Pydantic.** Une dataclass décrit une structure de données typée ; un modèle Pydantic (palier 5, leçon 10) fait pareil **et** valide à l'exécution. Voir l'une prépare l'autre.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire tes premières classes et trouver `self` répétitif (il faut l'écrire comme premier paramètre de chaque méthode). C'est une particularité de Python, et on s'y fait vite.

Tu vas aussi te heurter aux imports : chemins relatifs, chemins absolus, le fichier `__init__.py`, les imports circulaires. C'est la partie la moins intuitive du langage, et les exercices te la feront pratiquer.

### En équipe, en entreprise

**Les dataclasses (ou Pydantic, ou `attrs`) ont remplacé les classes manuelles** pour les structures de données. Écrire un constructeur à la main pour une simple classe de données est considéré comme dépassé.

**L'organisation en paquets est conventionnelle mais stable.** Tu verras des structures `src/`, des paquets par domaine, un `__init__.py` dans chaque dossier. Les frameworks (Django surtout) imposent leur propre structure.

**Le typage et `mypy` sont de plus en plus attendus**, en particulier sur les nouveaux projets. Les bibliothèques modernes sont typées, et `mypy` dans le pipeline attrape les erreurs avant l'exécution.

**Et tu rencontreras de l'héritage, parfois trop.** Les frameworks utilisent l'héritage de classes intensivement (une vue hérite d'une vue de base). C'est leur mécanisme, et il faut savoir le lire. Dans ton propre code, en revanche, on privilégie souvent la composition à l'héritage — un sujet que tu creuseras au palier 7.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : les modules et imports, `from x import y`, les dataclasses, les type hints sur les fonctions, `mypy` et `ruff`.

Régulièrement : les classes avec méthodes, l'héritage simple, `with` (gestionnaire de contexte), les exceptions personnalisées, les attributs de classe contre attributs d'instance, `__init__.py`.

Rare, et hors sujet pour l'instant : les métaclasses, les propriétés (`@property`) et descripteurs, l'héritage multiple, les méthodes statiques et de classe (sauf besoin précis), les *dunder methods* au-delà de `__init__` et `__repr__`, les protocoles et `abc`. Tu les croiseras dans le code des frameworks ; tu n'as pas à les écrire.

---

## La mécanique

### La structure d'un projet

```
mon-projet/
├── .venv/                    # l'environnement virtuel (dans .gitignore)
├── requirements.txt
├── src/
│   ├── __init__.py           # fait de src un paquet
│   ├── models.py             # les structures de données
│   ├── services.py           # la logique métier
│   └── depots.py             # l'accès aux données
└── tests/
    └── test_services.py
```

Le `__init__.py` (même vide) indique à Python qu'un dossier est un paquet importable. C'est une spécificité à connaître : sans lui, certains imports échouent.

### Les classes

```python
class Portefeuille:
    def __init__(self, solde: int = 0) -> None:    # le constructeur
        self.solde = solde                          # self = this, explicite

    def deposer(self, montant: int) -> bool:
        if montant <= 0:
            return False
        self.solde += montant
        return True

    def __repr__(self) -> str:                      # ⭐ la représentation lisible
        return f"Portefeuille(solde={self.solde})"

p = Portefeuille(1000)
p.deposer(500)
print(p)                                            # Portefeuille(solde=1500)
```

Deux particularités par rapport à JavaScript. **`self` est explicite** : il est le premier paramètre de chaque méthode, là où JavaScript avait un `this` implicite. C'est répétitif, mais sans ambiguïté — et ça évite une partie des pièges de `this` que tu as vus au palier 3. Et **`__repr__`** définit comment l'objet s'affiche : la définir rend le débogage bien plus agréable.

### ⭐ Les dataclasses : moins de bruit

```python
from dataclasses import dataclass

# ❌ Classe de données écrite à la main : répétitif
class Depense:
    def __init__(self, id, montant, categorie, description=""):
        self.id = id
        self.montant = montant
        self.categorie = categorie
        self.description = description

# ✅ Dataclass : le constructeur, __repr__ et l'égalité sont générés
@dataclass
class Depense:
    id: int
    montant: int
    categorie: str
    description: str = ""

d = Depense(id=1, montant=1500, categorie="food")
print(d)                                            # Depense(id=1, montant=1500, ...)
d == Depense(id=1, montant=1500, categorie="food")  # True — égalité par contenu, gratuite
```

Le décorateur `@dataclass` génère le constructeur, `__repr__`, et une égalité **par contenu** (contrairement aux objets JavaScript comparés par référence au palier 1). Pour une structure de données, c'est le bon outil — et tu reconnais une classe typée, ce qui prépare Pydantic.

```python
@dataclass(frozen=True)                             # frozen = immuable (comme un tuple)
class Point:
    latitude: float
    longitude: float
```

### Les modules et les imports

```python
# Dans services.py
from models import Depense                           # importer une chose précise
from models import Depense, Categorie                # plusieurs
import models                                         # le module entier → models.Depense
from models import Depense as D                       # avec un alias

# Imports relatifs dans un paquet (le point désigne le paquet courant)
from .models import Depense
from ..config import settings
```

L'import est l'équivalent du `import` de JavaScript (palier 1), avec une syntaxe différente. Le piège le plus courant est l'**import circulaire** : le module A importe B qui importe A. Python lève alors une erreur, et la solution est généralement de revoir le découpage — si deux modules dépendent l'un de l'autre, c'est souvent qu'une responsabilité est mal placée.

### Le gestionnaire de contexte `with`

```python
# ❌ Fragile : si une erreur survient, le fichier n'est pas fermé
fichier = open("depenses.json")
donnees = fichier.read()
fichier.close()

# ✅ with ferme automatiquement, même en cas d'erreur
with open("depenses.json") as fichier:
    donnees = fichier.read()
# ici le fichier est fermé, quoi qu'il arrive
```

`with` garantit qu'une ressource est libérée, même si une exception survient — c'est l'équivalent conceptuel du `finally` du palier 1, mais intégré. Tu l'utiliseras pour les fichiers, les connexions de base de données, et les transactions.

### Les exceptions personnalisées

```python
class ErreurMetier(Exception):
    """Erreur attendue de la logique métier."""

class ErreurValidation(ErreurMetier):
    def __init__(self, champ: str, message: str):
        super().__init__(message)
        self.champ = champ

# Lever et attraper
try:
    valider(donnees)
except ErreurValidation as e:
    print(f"Champ {e.champ} : {e}")
except ErreurMetier:
    print("Erreur métier")
```

C'est exactement la hiérarchie d'erreurs du palier 4 (leçon 04), en Python. La distinction erreurs attendues / bugs du palier 1 (leçon 08) reste valide, et tu la réutiliseras dans ton mini-framework et dans les frameworks.

### Le typage et les outils

```python
from dataclasses import dataclass

@dataclass
class Depense:
    id: int
    montant: int
    categorie: str

def calculer_total(depenses: list[Depense]) -> int:
    return sum(d.montant for d in depenses)          # .montant, pas ["montant"] : c'est un objet

def trouver(id: int) -> Depense | None:              # union, comme TypeScript
    ...
```

```bash
mypy src/                     # vérifie les types (comme tsc --noEmit)
ruff check src/               # style et erreurs courantes
ruff format src/              # formatage automatique
```

Note le passage de `d["montant"]` (dictionnaire) à `d.montant` (objet dataclass) : c'est l'avantage des classes sur les dictionnaires bruts — l'accès est typé, et `mypy` attrape une faute de frappe sur `d.montnat`.

---

## Les problèmes que tu vas rencontrer

**`ModuleNotFoundError` sur mon propre module.** Problème d'import : chemin incorrect, `__init__.py` manquant, ou tu lances le script depuis le mauvais dossier. Les imports Python dépendent du répertoire d'exécution — c'est la partie la moins intuitive du langage.

**`ImportError: cannot import name ... (circular import)`.** Deux modules s'importent mutuellement. Revois le découpage : c'est souvent le signe qu'une responsabilité est au mauvais endroit.

**J'ai oublié `self` dans une méthode.** `TypeError: method() takes 0 positional arguments but 1 was given`. Chaque méthode d'instance prend `self` en premier paramètre.

**Mon objet s'affiche `<Depense object at 0x7f...>`.** Il manque `__repr__`. Avec une dataclass, il est généré automatiquement.

**Mes deux objets identiques ne sont pas égaux.** Avec une classe manuelle, l'égalité est par référence (comme en JavaScript). Avec une dataclass, elle est par contenu — c'est l'un de ses avantages.

**Mon attribut est partagé entre toutes les instances.** Tu as défini un attribut mutable (une liste) au niveau de la **classe** au lieu de l'**instance** (dans `__init__`). C'est un piège classique de Python.

**Mon fichier reste ouvert après une erreur.** Tu n'as pas utilisé `with`. Utilise-le systématiquement pour les ressources.

**`mypy` ne voit pas d'erreur mais mon code plante.** Les type hints ne sont pas vérifiés à l'exécution. La donnée externe doit être validée à la frontière — Pydantic au palier 5.

---

## Ce qu'on te demandera

En **entretien Python**, on vérifie que tu connais les classes, l'héritage simple, les modules, et de plus en plus les dataclasses et le typage. Questions fréquentes : « qu'est-ce qu'une dataclass ? », « comment organises-tu un projet Python ? », « à quoi sert `with` ? », « différence entre un attribut de classe et d'instance ? ».

Pour ton profil, on peut demander : « comment transposes-tu le découpage en couches que tu connais en Node vers un projet Python ? » — et la réponse parle de modules et de paquets.

En **test technique**, l'organisation du code (modules clairs, typage) est observée autant que la justesse.

---

## Ce qui te démarquera

**Les dataclasses plutôt que les classes manuelles.** C'est le marqueur d'un développeur Python moderne, et ça prépare directement Pydantic.

**Le typage systématique avec `mypy` au vert.** Ton expérience de TypeScript est un avantage réel ; beaucoup de développeurs Python ne typent pas.

**Une organisation en modules qui reflète les couches.** Transposer `services`/`depots` du palier 4 montre que tu as compris que l'architecture est indépendante du langage.

**`with` systématique pour les ressources.** Un fichier ou une connexion jamais laissés ouverts : un réflexe propre qui se remarque.

**Et reconnaître `self` comme le `this` de PHP à venir.** Faire le lien entre les langages est exactement la compétence que le parcours construit.

---

## 📚 À lire

**docs.python.org → *Classes*** et ***Modules*** : la référence officielle. La section sur les attributs de classe contre instance est à lire attentivement (c'est le piège).

**docs.python.org → *dataclasses*** : courte, et c'est l'outil à adopter.

**Real Python → *Python Modules and Packages*** pour démêler les imports, qui sont la partie la moins intuitive.

**docs.python.org → *typing*** en survol, et la documentation de **mypy** pour la configuration — tu connais déjà la logique depuis TypeScript.

---

## 🤖 Le mini-projet à demander à l'IA

L'organisation d'un projet Python est le vrai sujet de la leçon.

> « Je suis en formation de développeur, palier 5. Je sais découper une API en couches (routes/services/dépôts) depuis mon palier Node. Je veux transposer ça en Python. Sans me donner de code, décris-moi la **structure de fichiers et de paquets** d'un petit projet Python de gestion de dépenses, avec le rôle de chaque module, l'emplacement des `__init__.py`, et comment les imports relient les couches. Ensuite, pose-moi des questions pour vérifier que mes services ne dépendent pas de la couche web, exactement comme le test "appelable sans serveur" du palier 4. »

Puis le transfert des structures de données :

> « J'ai modélisé mes données en JavaScript/TypeScript au palier 3 avec des interfaces. Montre-moi comment les mêmes structures s'écrivent en dataclasses Python typées, **une par une, sous forme de quiz** : donne-moi l'interface TypeScript, je propose la dataclass, tu corriges en pointant ce qui n'est pas idiomatique (un constructeur manuel au lieu de @dataclass, un type mal transposé, l'absence de valeur par défaut). »

---

## 🛠️ À faire

1. **Structure de projet** : crée l'arborescence `src/` avec `models.py`, `services.py`, `depots.py`, les `__init__.py`, et un dossier `tests/`.
2. **Une dataclass** : `Depense` avec `id`, `montant`, `categorie`, `description` par défaut. Crée une instance, affiche-la, et vérifie l'égalité par contenu entre deux instances identiques.
3. **Classe manuelle contre dataclass** : écris `Depense` à la main, puis en dataclass. Compare les lignes, le `__repr__` et l'égalité.
4. **Imports** : importe `Depense` depuis `services.py` de trois façons (import nommé, import du module, alias). Provoque un `ModuleNotFoundError` en lançant le script du mauvais dossier.
5. **Import circulaire** : fais s'importer mutuellement deux modules, constate l'erreur, et corrige en déplaçant une responsabilité.
6. **Le piège de l'attribut partagé** : définis une liste comme attribut de classe, crée deux instances, modifie l'une, et constate que l'autre a changé. Corrige en la mettant dans `__init__`.
7. **`with`** : lis un fichier JSON avec `with`, puis sans, et provoque une erreur au milieu pour voir la différence.
8. **Exceptions personnalisées** : reprends la hiérarchie du palier 4 (`ErreurMetier`, `ErreurValidation`) en Python.
9. **Typage** : type tout ton module `services.py` et lance `mypy` jusqu'à zéro erreur.
10. **`self` et PHP** : écris une classe `Portefeuille` complète, et note dans ton journal la correspondance `self`/`this`, en prévision de `$this` au palier 6.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** La dataclass génère l'égalité par **contenu** : `Depense(1, 1500, "food") == Depense(1, 1500, "food")` est `True`. C'est une différence majeure avec les objets JavaScript du palier 1, qui étaient comparés par référence (`{} === {}` était `False`). Pour une structure de données, l'égalité par contenu est presque toujours ce qu'on veut.

**6.** C'est l'un des pièges les plus déroutants de Python :
```python
class Panier:
    articles = []          # ❌ attribut de CLASSE, partagé par toutes les instances
# vs
class Panier:
    def __init__(self):
        self.articles = []  # ✅ attribut d'INSTANCE, propre à chacune
```
Un attribut mutable défini au niveau de la classe est partagé par toutes les instances : modifier le panier de l'une modifie celui de toutes. Les attributs mutables vont **toujours** dans `__init__`.

**7.** Sans `with`, une erreur entre `open` et `close` laisse le fichier ouvert — une fuite de ressource qui, accumulée, épuise les descripteurs de fichiers du système. `with` garantit la fermeture quoi qu'il arrive, comme un `finally` intégré. C'est pour ça qu'on l'utilise systématiquement, y compris pour les connexions de base et les transactions.

**10.** La correspondance à noter : `self` en Python et `$this` en PHP désignent tous deux l'instance courante. La différence est que Python le rend **explicite** (premier paramètre de chaque méthode) alors que PHP et JavaScript l'ont implicite. L'explicite de Python évite une partie des pièges de `this` que tu as rencontrés au palier 3 avec les fonctions fléchées.
</details>

---

## ✅ Acquis si…

- [ ] J'organise un projet Python en modules et paquets, avec les `__init__.py` nécessaires.
- [ ] Je transpose le découpage en couches du palier 4 en modules Python.
- [ ] J'utilise des dataclasses plutôt que des classes manuelles pour les données.
- [ ] Je connais `self`, le constructeur `__init__`, et `__repr__`.
- [ ] Je résous un import circulaire en revoyant le découpage.
- [ ] Je sais pourquoi un attribut mutable va dans `__init__` et non au niveau de la classe.
- [ ] J'utilise `with` pour toute ressource à libérer.
- [ ] J'ai une hiérarchie d'exceptions personnalisées, comme au palier 4.
- [ ] Mon code est typé et `mypy` est au vert.
- [ ] Je fais le lien entre `self`, `this` et le futur `$this`.

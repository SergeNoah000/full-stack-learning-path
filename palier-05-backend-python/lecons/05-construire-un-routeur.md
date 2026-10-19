# Leçon 05 — Construire un routeur (table de routes, paramètres d'URL)

> 🎯 **À la fin de cette leçon** : tu as écrit, à la main, le composant qui associe une URL à du code — et tu le reconnaîtras dans Flask, Django et Laravel.
> ⏱️ 5 h · **Prérequis** : leçon 04 (WSGI), et la leçon 01 du palier 4 (le routeur maison en Node).

---

## De quoi on parle

Un **routeur** associe une **méthode HTTP + un chemin** à une **fonction** qui traite la requête. C'est le composant qui transforme « `GET /depenses/42` » en « appelle `lire_depense(42)` ».

```python
routeur = Routeur()
routeur.ajouter("GET", "/depenses", lister_depenses)
routeur.ajouter("GET", "/depenses/<id>", lire_depense)   # <id> : un paramètre d'URL
```

Deux mécanismes à construire. La **table de routes** : une structure qui garde la correspondance entre les motifs et les fonctions. Et la **reconnaissance de motif avec paramètres** : savoir que `/depenses/42` correspond à `/depenses/<id>` et en extraire `id = 42`, à l'aide d'une **expression régulière**.

C'est le deuxième étage de ton **mini-framework**, commencé à la leçon 04 avec WSGI.

---

## À quoi ça sert, concrètement

**Parce que c'est le cœur de tout framework web.** `@app.route("/depenses/<id>")` en Flask, `path("depenses/<int:id>")` en Django, `Route::get("/depenses/{id}")` en Laravel : ce sont trois écritures du même mécanisme, celui que tu construis ici. Après cette leçon, tu ne verras plus ces lignes comme de la magie, mais comme une table de routes et une expression régulière.

**Parce que tu l'as déjà écrit en Node, et que le refaire en Python ancre le concept.** Au palier 4, leçon 01, tu as construit exactement ce routeur avec `node:http`. Le refaire en Python n'est pas une répétition inutile : c'est la preuve, par l'expérience, que le routage est un concept indépendant du langage. C'est précisément ce que le parcours cherche à te faire sentir, et ce que tu exploiteras au palier 7.

**Parce que les paramètres d'URL sont partout.** `/utilisateurs/7`, `/articles/mon-titre`, `/depenses/42/commentaires` : toute API REST (que tu as conçue au palier 4, leçon 03) repose sur des chemins paramétrés. Savoir les extraire est indispensable.

**Et parce que les expressions régulières, ici, deviennent concrètes.** Tu vas transformer un motif lisible (`/depenses/<id>`) en expression régulière, et extraire les paramètres des groupes capturés. C'est un usage précis et utile des regex, bien plus parlant qu'un exercice abstrait.

---

## Où ça intervient dans le développement

Le routeur est la première couche que tu poses sur WSGI :

```
   WSGI : app(environ, start_response)   ← leçon 04
        ▼
   LE ROUTEUR : méthode + chemin → fonction   ← CETTE LEÇON
        ▼
   Request / Response : des objets propres   ← leçon 06
        ▼
   les vues : des fonctions Request → Response   ← leçon 06
```

Tu construis ton mini-framework étage par étage, et le routeur est l'étage qui rend l'application utilisable : sans lui, un seul `if/elif` géant traite tous les chemins (c'est ce que tu as fait à la leçon 04).

Trois points de transfert.

**C'est le routeur du palier 4, en Python.** La structure — une table de `(méthode, motif, fonction)`, une boucle qui cherche la correspondance, l'extraction des paramètres par regex — est identique. Seule la syntaxe change. Garde ouverte ta version Node : tu verras qu'elles se ressemblent trait pour trait.

**Il prépare la lecture des frameworks.** Quand tu arriveras à Flask (leçon 09), `@app.route("/depenses/<int:id>")` te paraîtra familier : le décorateur enregistre la fonction dans une table de routes, et `<int:id>` est un motif à paramètre typé. Tu l'auras écrit.

**Et il annonce le front controller de PHP.** Au palier 6, le pattern « tout passe par `index.php`, qui route » est exactement ce que tu construis ici au-dessus de WSGI. Le routeur maison du palier 6 sera un cousin direct de celui-ci.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas d'abord écrire un routeur simple (correspondance exacte du chemin), puis buter sur les paramètres : comment faire correspondre `/depenses/42` à `/depenses/<id>` ? La réponse est une expression régulière, et c'est le moment technique de la leçon.

Tu vas aussi rencontrer l'ordre des routes : une route trop générale placée avant une route précise peut « avaler » les requêtes destinées à la seconde. C'est un piège classique de tout routeur.

### En équipe, en entreprise

**Tu n'écriras jamais de routeur à la main.** Les frameworks en fournissent un, optimisé et testé. Mais tu configureras des routes tous les jours, et comprendre le mécanisme t'évite les erreurs — notamment les problèmes d'ordre et de conflit de routes.

**Tu verras des conventions de routage.** Les routes groupées par ressource, les préfixes (`/api/v1`), les routes imbriquées, les paramètres typés (`<int:id>`). Ce sont des facilités que les frameworks ajoutent par-dessus le mécanisme de base.

**Et tu rencontreras des bugs de routage.** Une route qui ne répond pas parce qu'une autre la masque, un paramètre mal extrait, une méthode HTTP oubliée. Savoir que, sous le capot, c'est une table et des regex rend ces bugs diagnosticables.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon, ce qui reste utile : comprendre qu'un routeur est une table de correspondance, savoir qu'une route paramétrée est une regex, et connaître le piège de l'ordre des routes.

Ce que tu ne refais jamais : écrire le routeur toi-même.

Rare et hors sujet : la construction d'URL inverse (générer une URL depuis un nom de route), les routes avec contraintes complexes, le routage par sous-domaine, les groupes de routes avec middlewares, l'optimisation du routeur (arbre de préfixes). Les frameworks s'en chargent.

---

## La mécanique

### Un routeur à correspondance exacte

```python
class Routeur:
    def __init__(self):
        self.routes = []                              # la table de routes

    def ajouter(self, methode, chemin, fonction):
        self.routes.append((methode, chemin, fonction))

    def resoudre(self, methode, chemin):
        for m, c, fonction in self.routes:
            if m == methode and c == chemin:
                return fonction, {}                   # fonction trouvée, pas de paramètre
        return None, {}

# Usage avec WSGI (leçon 04)
routeur = Routeur()
routeur.ajouter("GET", "/depenses", lister_depenses)

def app(environ, start_response):
    fonction, params = routeur.resoudre(
        environ["REQUEST_METHOD"], environ["PATH_INFO"]
    )
    if fonction is None:
        return repondre_json(start_response, "404 Not Found", {"erreur": "introuvable"})
    return fonction(environ, start_response, **params)
```

C'est le même squelette qu'au palier 4 : une liste de tuples, une boucle qui cherche. Mais cette version ne gère que les chemins **exacts** : `/depenses/42` ne correspond à rien, parce qu'il n'est pas dans la table. D'où l'étape suivante.

### ⭐ Les paramètres d'URL avec une regex

L'idée : transformer le motif lisible `/depenses/<id>` en une expression régulière qui capture la valeur.

```python
import re

def motif_vers_regex(motif):
    # "/depenses/<id>"  devient  "^/depenses/(?P<id>[^/]+)$"
    regex = re.sub(r"<(\w+)>", r"(?P<\1>[^/]+)", motif)
    return re.compile(f"^{regex}$")

class Routeur:
    def __init__(self):
        self.routes = []

    def ajouter(self, methode, motif, fonction):
        self.routes.append((methode, motif_vers_regex(motif), fonction))

    def resoudre(self, methode, chemin):
        for m, regex, fonction in self.routes:
            correspondance = regex.match(chemin)
            if m == methode and correspondance:
                return fonction, correspondance.groupdict()   # ⭐ les paramètres capturés
        return None, {}
```

Le cœur est `re.sub(r"<(\w+)>", r"(?P<\1>[^/]+)", motif)` : il remplace chaque `<nom>` du motif par un **groupe nommé** de regex. `(?P<id>[^/]+)` signifie « capture, sous le nom `id`, un ou plusieurs caractères qui ne sont pas des barres obliques ». Puis `correspondance.groupdict()` rend un dictionnaire `{"id": "42"}` : les paramètres extraits.

Tu reconnais exactement le mécanisme du palier 4 (où tu utilisais aussi une regex avec des groupes capturés). Le concept est identique ; la syntaxe des groupes nommés est propre à Python.

```python
routeur.ajouter("GET", "/depenses/<id>", lire_depense)
routeur.ajouter("GET", "/utilisateurs/<uid>/depenses/<id>", lire_depense_utilisateur)

def lire_depense(environ, start_response, id):        # ⭐ le paramètre arrive nommé
    depense_id = int(id)                               # ⚠️ TOUJOURS une chaîne au départ
    ...
```

> ⚠️ Le paramètre extrait est **toujours une chaîne** (`id = "42"`), jamais un entier. C'est la frontière du palier 1, leçon 01, pour la énième fois : `int(id)` et une vérification s'imposent. Les frameworks ajoutent des paramètres typés (`<int:id>`) précisément pour automatiser cette conversion.

### Le piège de l'ordre des routes

```python
# ❌ Mauvais ordre : la route générale masque la route spécifique
routeur.ajouter("GET", "/depenses/<id>", lire_depense)
routeur.ajouter("GET", "/depenses/recentes", lister_recentes)   # jamais atteinte !

# "/depenses/recentes" correspond AUSSI à "/depenses/<id>" (avec id="recentes"),
# et comme la première route gagne, la seconde est inaccessible.
```

Le routeur parcourt la table **dans l'ordre** et prend la première correspondance. Une route paramétrée (`/depenses/<id>`) est générale : elle attrape tout ce qui a cette forme. Il faut donc déclarer les routes **spécifiques avant les génériques**. C'est un piège universel du routage, que tu retrouveras dans tous les frameworks.

### Gérer la méthode non autorisée

```python
def resoudre(self, methode, chemin):
    chemin_existe = False
    for m, regex, fonction in self.routes:
        if regex.match(chemin):
            chemin_existe = True
            if m == methode:
                return fonction, regex.match(chemin).groupdict()
    # Le chemin existe mais pas pour cette méthode → 405, pas 404
    if chemin_existe:
        return "405", {}
    return None, {}
```

Un raffinement du palier 4 : si le chemin existe mais que la méthode ne correspond pas (par exemple `DELETE /depenses` alors que seul `GET` est défini), la bonne réponse est **`405 Method Not Allowed`**, pas `404`. C'est un détail de conformité REST (palier 4, leçon 03) que les frameworks gèrent, et que tu peux implémenter.

### Assembler avec WSGI

```python
def creer_app(routeur):
    def app(environ, start_response):
        methode = environ["REQUEST_METHOD"]
        chemin = environ["PATH_INFO"]
        fonction, params = routeur.resoudre(methode, chemin)

        if fonction is None:
            return repondre_json(start_response, "404 Not Found", {"erreur": "route introuvable"})
        if fonction == "405":
            return repondre_json(start_response, "405 Method Not Allowed", {"erreur": "méthode non autorisée"})

        return fonction(environ, start_response, **params)
    return app
```

Tu as maintenant un mini-framework qui route — c'est déjà bien plus utilisable que le `if/elif` de la leçon 04. Les leçons 06 à 08 ajouteront les objets Request/Response, l'accès aux données et les templates.

---

## Les problèmes que tu vas rencontrer

**Ma route paramétrée ne correspond jamais.** Ton motif-vers-regex est incorrect, ou tu as oublié les ancres `^` et `$` (sans elles, `/depenses` correspondrait à `/autre/depenses/truc`).

**Une route spécifique n'est jamais atteinte.** Elle est déclarée **après** une route paramétrée qui l'avale. Mets les routes spécifiques en premier.

**Mon paramètre vaut une chaîne au lieu d'un nombre.** C'est normal : tout paramètre d'URL est une chaîne. `int(id)`, avec une vérification.

**`/depenses/42/` (avec barre finale) ne correspond pas à `/depenses/42`.** Les barres finales sont un piège classique du routage. Décide d'une convention (pas de barre finale) et normalise le chemin, ou gère les deux.

**Ma regex capture trop ou pas assez.** `[^/]+` capture tout sauf les barres obliques — c'est voulu pour qu'un paramètre ne traverse pas les segments. Si tu veux capturer plusieurs segments, c'est un cas particulier (les frameworks ont `<path:x>` pour ça).

**J'obtiens un `405` là où j'attends un `404` (ou l'inverse).** Tu as inversé la logique : `404` si le chemin n'existe pas, `405` s'il existe mais pas pour cette méthode.

---

## Ce qu'on te demandera

En **entretien Python backend**, on ne te demandera pas d'écrire un routeur (les frameworks en ont un), mais on appréciera que tu saches **comment ça marche** : « qu'est-ce qu'un routeur fait, techniquement ? », « comment un framework extrait-il `id` de `/depenses/42` ? ». Répondre « une table de motifs et des regex avec groupes capturés » montre que tu as regardé sous le capot.

On peut te demander : « pourquoi l'ordre des routes compte-t-il ? », « quelle différence entre un 404 et un 405 ? ».

En **test technique**, si l'on te donne un petit projet sans framework, savoir router proprement est un plus.

---

## Ce qui te démarquera

**Comprendre le routage des frameworks.** Quand tu configureras des routes Flask ou Django, tu sauras pourquoi l'ordre compte, pourquoi un paramètre est une chaîne, et comment extraire plusieurs paramètres. Tu déboguras les conflits de routes que d'autres subissent.

**Reconnaître le même mécanisme en Node, Python et PHP.** Pouvoir dire « c'est le routeur que j'ai écrit au palier 4, puis ici, et que je réécrirai en PHP » prouve un transfert de concept.

**Maîtriser cet usage précis des regex.** Les groupes nommés pour extraire des paramètres sont un cas d'usage concret et élégant des expressions régulières — bien plus utile qu'un exercice abstrait.

**Et connaître le piège de l'ordre et des barres finales.** Ce sont les deux bugs de routage les plus fréquents, et les anticiper se remarque.

---

## 📚 À lire

**docs.python.org → *re*** (le module des expressions régulières) : concentre-toi sur `re.compile`, `match`, les groupes nommés `(?P<nom>...)` et `groupdict()`. C'est tout ce dont tu as besoin.

**Flask → *Routing*** (dans la documentation Flask) : lis-la **maintenant**, et tu verras que `@app.route("/depenses/<int:id>")` est exactement ce que tu construis. Comprendre le mécanisme d'abord rend la documentation limpide.

**MDN → *Regular expressions*** si tu veux consolider les regex en général — mais reste sur l'essentiel.

Et garde ouverte ta version Node du routeur (palier 4, leçon 01) : la comparaison côte à côte est la meilleure leçon.

---

## 🤖 Le mini-projet à demander à l'IA

Le transfert direct depuis le palier 4 :

> « Je suis en formation de développeur, palier 5. J'ai écrit un routeur maison en Node au palier 4 (table de routes, regex pour les paramètres d'URL). Je le réécris en Python au-dessus de WSGI. Sans me donner de code, guide-moi par questions : comment je stocke la table, comment je transforme un motif `/depenses/<id>` en regex avec un groupe nommé, comment j'extrais les paramètres, et comment je gère l'ordre des routes. Quand je te montre mon code, compare-le à ma version Node et dis-moi ce qui est différent par nécessité (la syntaxe des regex Python, les bytes WSGI) et ce qui est différent sans raison. »

Puis le test des pièges :

> « Donne-moi 8 scénarios de test pour mon routeur, décrits en français, qui couvrent les pièges classiques : une route spécifique masquée par une route paramétrée, une barre oblique finale, un paramètre qui ne doit pas traverser les segments, une méthode non autorisée (405 vs 404), deux paramètres dans un chemin, un chemin inexistant. Pour chaque scénario, je prédis le comportement de mon routeur, je teste, et tu me dis si mon routeur est correct — sans me donner la correction. »

---

## 🛠️ À faire

1. **Routeur à correspondance exacte** : une classe `Routeur` avec `ajouter` et `resoudre`, branchée sur ton app WSGI de la leçon 04. Teste deux routes et un 404.
2. **⭐ Les paramètres** : implémente `motif_vers_regex` et fais correspondre `/depenses/42` à `/depenses/<id>`. Vérifie que tu extrais `{"id": "42"}`.
3. **Le piège de la chaîne** : constate que `id` vaut `"42"` et non `42`, puis convertis avec `int()` et une vérification.
4. **Plusieurs paramètres** : une route `/utilisateurs/<uid>/depenses/<id>` qui extrait les deux.
5. **⚠️ L'ordre des routes** : déclare `/depenses/<id>` avant `/depenses/recentes`, constate que la seconde est inaccessible, puis corrige l'ordre.
6. **Les ancres** : retire les `^` et `$` de ta regex, constate qu'un chemin trop long correspond, et remets-les.
7. **Le 405** : fais en sorte qu'un chemin existant appelé avec la mauvaise méthode renvoie `405` et non `404`.
8. **Les barres finales** : décide d'une convention, et gère `/depenses/42` et `/depenses/42/` de façon cohérente.
9. **La comparaison** : mets côte à côte ton routeur Node (palier 4) et ton routeur Python, et note dans ton journal ce qui est identique et ce qui diffère.
10. **Lire Flask** : ouvre la documentation du routage de Flask et identifie, dans leur API, les éléments que tu viens de construire.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** Le remplacement clé est `re.sub(r"<(\w+)>", r"(?P<\1>[^/]+)", motif)`, qui transforme chaque `<nom>` en groupe nommé `(?P<nom>[^/]+)`. Puis `regex.match(chemin).groupdict()` rend le dictionnaire des paramètres. C'est le même principe qu'au palier 4, avec la syntaxe des groupes nommés de Python.

**5.** `/depenses/recentes` correspond au motif `/depenses/<id>` avec `id="recentes"`. Comme le routeur prend la **première** correspondance, la route `/depenses/recentes` déclarée ensuite n'est jamais atteinte. **Règle universelle : les routes spécifiques avant les routes paramétrées.** C'est vrai dans tous les frameworks, et c'est une cause fréquente de « ma route ne répond pas ».

**6.** Sans `^` et `$`, `re.match` vérifie seulement que le motif apparaît **au début**, et `/depenses/42/supplement` correspondrait à `/depenses/<id>` en capturant `id="42"` et en ignorant le reste. Les ancres garantissent que le chemin correspond **en entier**. C'est un piège subtil de regex qui crée des bugs de routage difficiles à voir.

**9.** L'essentiel est identique : une table de `(méthode, motif, fonction)`, une boucle de résolution, une regex avec groupes capturés, le piège de l'ordre, et la conversion des paramètres. Les différences sont de **syntaxe** (groupes nommés `(?P<>)` en Python, encodage en bytes de WSGI) et non de **concept**. C'est la démonstration que le routage est un mécanisme universel — exactement ce que tu formaliseras au palier 7.
</details>

---

## ✅ Acquis si…

- [ ] J'écris un routeur à table de routes, branché sur WSGI.
- [ ] Je transforme un motif `/depenses/<id>` en regex avec un groupe nommé, et j'extrais les paramètres.
- [ ] Je sais que tout paramètre d'URL est une chaîne, et je convertis avec vérification.
- [ ] J'extrais plusieurs paramètres d'un même chemin.
- [ ] Je connais le piège de l'ordre des routes et je déclare le spécifique avant le générique.
- [ ] Je sais pourquoi les ancres `^` et `$` sont nécessaires.
- [ ] Je distingue un `404` (chemin inconnu) d'un `405` (méthode non autorisée).
- [ ] Je reconnais ce routeur dans celui du palier 4 et dans `@app.route` de Flask.

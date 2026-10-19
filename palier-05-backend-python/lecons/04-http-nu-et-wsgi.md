# Leçon 04 — HTTP nu et WSGI : ce qu'est vraiment une app web Python

> 🎯 **À la fin de cette leçon** : tu sais qu'une application web Python n'est, au fond, qu'une fonction — et tu l'as écrite.
> ⏱️ 4 h · **Prérequis** : leçons 01–03, et la leçon 01 du palier 4 (le serveur HTTP nu en Node).

---

## De quoi on parle

**WSGI** (*Web Server Gateway Interface*) est la **convention** qui relie un serveur web Python à une application Python. Elle tient en une phrase : une application WSGI est une fonction qui reçoit un dictionnaire décrivant la requête (`environ`) et une fonction pour démarrer la réponse (`start_response`), et qui retourne le corps.

```python
def app(environ, start_response):
    start_response("200 OK", [("Content-Type", "text/plain")])
    return [b"Bonjour depuis WSGI"]
```

**C'est tout ce qu'est une application web Python.** Flask, Django, ton futur mini-framework : tous produisent, à la base, une fonction de cette forme. Le reste est de l'organisation par-dessus.

Quelques notions à poser. `environ` est un **dictionnaire** qui contient la méthode (`REQUEST_METHOD`), le chemin (`PATH_INFO`), la query string (`QUERY_STRING`), les en-têtes, et un flux pour le corps. Le corps de la réponse est une liste de **bytes** (`b"..."`), pas de chaînes. Et **ASGI** est la version asynchrone de WSGI, que FastAPI utilise (leçon 10).

---

## À quoi ça sert, concrètement

**Parce que c'est le « serveur nu » du palier 4, en Python.** Tu as écrit un serveur avec `node:http` pour comprendre ce qu'Express automatise. Ici tu fais la même chose avec WSGI, et pour la même raison : après cette leçon, Flask n'aura plus rien de magique. C'est volontairement **la même démarche, dans un deuxième langage** — et c'est ce qui te permettra, au palier 7, de comparer les écosystèmes.

**Parce que WSGI explique pourquoi les frameworks Python sont interchangeables.** N'importe quel serveur WSGI (gunicorn, uWSGI) peut faire tourner n'importe quelle application WSGI (Flask, Django, la tienne). Cette interface standard est ce qui rend l'écosystème modulaire — tu changes de framework sans changer de serveur, et inversement.

**Parce que ça démystifie le déploiement.** Au palier 5, tu déploieras Django sur AWS avec gunicorn. Quand tu liras « gunicorn sert ton application WSGI », tu sauras exactement ce que ça veut dire : gunicorn appelle ta fonction `app(environ, start_response)` pour chaque requête.

**Et parce que c'est une interface, pas une technologie à retenir.** Tu n'écriras jamais de WSGI brut en production. Mais l'avoir écrit une fois change ta compréhension de tout ce qui vient après.

---

## Où ça intervient dans le développement

WSGI est la couche la plus basse de l'application web Python, juste au-dessus du serveur :

```
   ton code (vues, logique)
        ▲
   le FRAMEWORK (Flask, Django, ton mini-framework)   ← il PRODUIT une app WSGI
        ▲
   WSGI : app(environ, start_response)                 ← CETTE LEÇON
        ▲
   le serveur WSGI (gunicorn)                          ← palier 5, déploiement
        ▲
   le reverse proxy (Nginx)                            ← palier 8
```

Compare avec le palier 4 : WSGI est l'équivalent de `node:http`. Le framework (Flask) est l'équivalent d'Express. Et gunicorn est le serveur qui fait tourner le tout, là où en Node le serveur était intégré au runtime.

Trois points de transfert.

**Tout ce que tu as découvert au palier 4 se retrouve.** Il n'y a pas de routeur dans `environ` : il faut le construire (leçon 05). Le corps est un flux à lire (ici depuis `environ["wsgi.input"]`). Les en-têtes sont à écrire à la main. La query string est une chaîne à parser. Tu reconnais exactement la liste de ce qu'un framework automatise, établie au palier 4.

**Le modèle d'exécution annonce PHP.** WSGI, comme Node, tourne dans un processus persistant. Mais tu verras au palier 6 que PHP a un modèle radicalement différent (un processus par requête). Avoir écrit du WSGI te donnera un point de comparaison précis.

**Et ASGI prépare l'asynchrone.** FastAPI (leçon 10) utilise ASGI parce qu'il gère l'`async def`. Savoir que WSGI est synchrone et ASGI asynchrone éclaire le choix de FastAPI.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire une fonction de dix lignes et constater que c'est un serveur web. C'est le même effet qu'au palier 4 : un mélange de « c'est donc ça ? » et de « c'est pénible pour en faire quelque chose d'utile ».

Tu vas aussi te heurter aux **bytes** : WSGI veut des `b"..."`, pas des chaînes, et oublier l'encodage est l'erreur la plus fréquente.

### En équipe, en entreprise

**Tu n'écriras jamais de WSGI brut.** Personne ne le fait, exactement comme personne n'écrit de `node:http` brut. C'est une couche que les frameworks cachent.

**Mais tu rencontreras WSGI/ASGI au déploiement.** Le fichier `wsgi.py` d'un projet Django, la commande `gunicorn monapp.wsgi:application`, le choix entre gunicorn (WSGI) et uvicorn (ASGI) : ce vocabulaire est partout en production, et il faut le comprendre.

**Et tu entendras le débat synchrone/asynchrone.** « Faut-il passer à ASGI ? » est une question réelle dans les équipes Python, liée à la performance des opérations d'entrée-sortie. Après cette leçon et la leçon 10, tu sauras de quoi il s'agit.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon, ce qui reste utile : savoir qu'une app web Python est une fonction `app(environ, start_response)`, comprendre `environ` et le corps en bytes, et savoir ce que signifie « gunicorn sert une app WSGI ».

Ce que tu ne refais jamais : écrire du WSGI à la main en production.

Rare et hors sujet : les détails de la spécification WSGI (PEP 333/3333), les middlewares WSGI, le streaming de réponse, les subtilités d'ASGI (le cycle de vie, les WebSockets via ASGI), les serveurs WSGI autres que gunicorn. Tu rencontreras ce vocabulaire au palier 5 (déploiement) et au palier 10 ; tu n'as pas à le maîtriser maintenant.

---

## La mécanique

### L'application WSGI minimale

```python
# app.py
def app(environ, start_response):
    start_response("200 OK", [("Content-Type", "text/plain; charset=utf-8")])
    return [b"Bonjour depuis WSGI\n"]        # ⭐ une liste de BYTES, pas de chaînes
```

```bash
pip install gunicorn
gunicorn app:app                             # sert la fonction "app" du module "app"
curl -i http://localhost:8000
```

Dix lignes, et tu as un serveur web. `gunicorn app:app` signifie « prends l'objet `app` dans le module `app.py` et sers-le ». C'est exactement ce que fera `gunicorn monprojet.wsgi:application` avec Django.

### Lire la requête depuis `environ`

```python
from urllib.parse import parse_qs

def app(environ, start_response):
    methode = environ["REQUEST_METHOD"]           # "GET", "POST"...
    chemin = environ["PATH_INFO"]                 # "/depenses"
    query = parse_qs(environ["QUERY_STRING"])     # {"categorie": ["food"]}

    start_response("200 OK", [("Content-Type", "text/plain; charset=utf-8")])
    return [f"{methode} {chemin}\n".encode("utf-8")]   # .encode : str → bytes
```

Tout est dans le dictionnaire `environ`. Il n'y a pas de `request.method` élégant : il y a `environ["REQUEST_METHOD"]`. Pas de `request.query` : il y a une chaîne à parser avec `parse_qs`. C'est précisément la plomberie qu'un framework te cache, et tu la reconnais du palier 4.

### Lire le corps de la requête

```python
def lire_corps(environ):
    try:
        taille = int(environ.get("CONTENT_LENGTH", 0))
    except ValueError:
        taille = 0
    if taille == 0:
        return b""
    return environ["wsgi.input"].read(taille)     # ⭐ un flux, comme au palier 4
```

Le corps arrive par un **flux** (`environ["wsgi.input"]`), exactement comme en Node (palier 4, leçon 01) où tu accumulais les morceaux. Ici tu lis une taille connue. Et comme au palier 4, le corps vient du client : il faut le parser avec précaution et le valider.

```python
import json

corps_brut = lire_corps(environ)
try:
    donnees = json.loads(corps_brut)              # équivalent de JSON.parse
except json.JSONDecodeError:
    # répondre 400
    ...
```

### Écrire une réponse JSON

```python
import json

def repondre_json(start_response, statut, donnees):
    corps = json.dumps(donnees).encode("utf-8")   # dict → JSON → bytes
    start_response(statut, [
        ("Content-Type", "application/json; charset=utf-8"),
        ("Content-Length", str(len(corps))),
    ])
    return [corps]

# Usage
def app(environ, start_response):
    if environ["PATH_INFO"] == "/depenses":
        return repondre_json(start_response, "200 OK", {"depenses": [...]})
    return repondre_json(start_response, "404 Not Found", {"erreur": "introuvable"})
```

Tu viens d'écrire ton premier morceau de framework — la fonction `repondre_json`, qui est l'équivalent de `res.json()` d'Express. Sans elle, tu répéterais l'encodage et les en-têtes à chaque réponse. C'est exactement le mouvement du palier 4.

### Le point crucial : les bytes

```python
"texte".encode("utf-8")        # str → bytes :  b"texte"
b"texte".decode("utf-8")       # bytes → str :  "texte"
json.dumps(donnees).encode()   # dict → str JSON → bytes
```

WSGI travaille en **bytes**, pas en chaînes. C'est la différence la plus visible avec Node, et la source d'erreur la plus fréquente. La raison est que le réseau transporte des octets, et WSGI reste à ce niveau. Tu encodes en sortie (`.encode()`), tu décodes en entrée (`.decode()`), et tu n'oublies pas `charset=utf-8` dans le `Content-Type` pour les accents.

### Pourquoi gunicorn, et pas le serveur de développement

```python
# Pour tester sans gunicorn, Python a un serveur WSGI intégré (DÉVELOPPEMENT SEULEMENT)
from wsgiref.simple_server import make_server
make_server("localhost", 8000, app).serve_forever()
```

`wsgiref` est un serveur WSGI minimal, pratique pour tester, mais **mono-processus et non optimisé** — à ne jamais utiliser en production, exactement comme `runserver` de Django (leçon 11). En production, c'est **gunicorn** : plusieurs processus de travail, robuste, conçu pour la charge. C'est lui que tu lanceras sur AWS au palier 5, derrière Nginx (palier 8).

---

## Les problèmes que tu vas rencontrer

**`TypeError: sequence of bytes expected`.** Tu retournes une chaîne au lieu de bytes. WSGI veut `[b"..."]`, pas `["..."]`. Encode avec `.encode("utf-8")`.

**Mes accents s'affichent en caractères bizarres.** Il manque `charset=utf-8` dans le `Content-Type`, ou tu n'as pas encodé en UTF-8.

**Mon corps de requête est vide.** Tu n'as pas lu `environ["wsgi.input"]`, ou tu as lu sans la taille (`CONTENT_LENGTH`). Comme en Node, le corps est un flux qu'il faut lire explicitement.

**`KeyError: 'CONTENT_LENGTH'`.** Une requête `GET` n'a pas de corps, donc pas de `CONTENT_LENGTH`. Utilise `environ.get("CONTENT_LENGTH", 0)` avec une valeur par défaut (leçon 01 : l'accès à une clé absente lève une exception).

**Ma query string n'est pas celle que j'attends.** `parse_qs` retourne un dictionnaire de **listes** (`{"categorie": ["food"]}`), parce qu'un paramètre peut apparaître plusieurs fois — comme en Node. Prends `query.get("categorie", [None])[0]`.

**Mon serveur ne répond qu'à une requête à la fois.** `wsgiref` est mono-processus. C'est normal en développement ; gunicorn règle ça en production.

**gunicorn ne trouve pas mon application.** La syntaxe est `gunicorn module:variable` — `gunicorn app:app` cherche la variable `app` dans `app.py`.

---

## Ce qu'on te demandera

En **entretien Python backend**, WSGI est une question de culture : « qu'est-ce que WSGI ? », « quelle différence entre WSGI et ASGI ? », « que fait gunicorn ? ». Savoir répondre « une application web Python est une fonction qui reçoit `environ` et `start_response` » montre que tu comprends ce qu'il y a sous les frameworks.

On peut demander : « pourquoi n'utilise-t-on pas `runserver` en production ? » — et la réponse (mono-processus, non optimisé) vaut pour `wsgiref` comme pour Django.

En **travail réel**, cette connaissance sert surtout au déploiement et au débogage : comprendre le fichier `wsgi.py`, la commande gunicorn, et le choix du serveur.

---

## Ce qui te démarquera

**Pouvoir dire ce qu'est une application web Python au niveau le plus bas.** « C'est une fonction `app(environ, start_response)` » est une réponse qui distingue nettement quelqu'un qui a regardé sous le capot.

**Reconnaître que c'est la même démarche que le serveur nu du palier 4.** Faire le lien entre `node:http` et WSGI montre que tu as compris un principe transférable, pas deux recettes séparées.

**Comprendre la chaîne de déploiement.** Savoir que gunicorn sert ton app WSGI derrière Nginx te rend autonome au palier 5, là où beaucoup copient des commandes sans les comprendre.

**Et savoir pourquoi WSGI est synchrone.** Pouvoir expliquer pourquoi FastAPI a choisi ASGI (pour l'`async def`) relie cette leçon à la leçon 10 et montre une vision d'ensemble.

---

## 📚 À lire

**PEP 3333** (*Python Web Server Gateway Interface*) : la spécification elle-même. Lis l'introduction et l'exemple — c'est court, et c'est le texte fondateur. Tu n'as pas besoin des détails.

**docs.python.org → *wsgiref*** pour le serveur de développement et des exemples.

**Documentation de gunicorn** : la page de démarrage, pour comprendre `module:variable` et les processus de travail.

**Real Python → *Python's WSGI Server*** ou un article équivalent qui explique WSGI avec des schémas — le concept se comprend mieux visuellement.

---

## 🤖 Le mini-projet à demander à l'IA

L'enjeu est le même qu'au palier 4 : ressentir la plomberie pour comprendre ce qu'un framework automatise.

> « Je suis en formation de développeur, palier 5. J'ai écrit au palier 4 un serveur HTTP nu en Node pour comprendre ce qu'Express automatise. Je refais la même démarche en Python avec WSGI. Donne-moi un cahier des charges **progressif en 6 étapes**, sans code : chaque étape ajoute une exigence qui alourdit ma fonction WSGI (lire la méthode et le chemin, parser la query string, lire et parser un corps JSON, écrire une réponse JSON propre, gérer un 404, gérer les erreurs). Après chaque étape, demande-moi **ce qui, dans mon code, correspond exactement à ce qu'Express faisait pour moi au palier 4**. À la fin, demande-moi de dresser la liste de ce que mon mini-framework des prochaines leçons devra automatiser. »

Cette dernière liste est le pont vers les leçons 05 à 08 (la construction du mini-framework).

Puis la chaîne de déploiement :

> « Explique-moi, sans que je code, la chaîne complète qui va de ma fonction WSGI jusqu'à une requête servie en production : le rôle de gunicorn, de ses processus de travail, et de Nginx devant. Pose-moi des questions pour vérifier que je comprends la différence entre le serveur de développement (wsgiref, runserver) et gunicorn, et pourquoi on ne déploie jamais le premier. »

---

## 🛠️ À faire

1. **L'app minimale** : une fonction WSGI de dix lignes qui répond « Bonjour ». Sers-la avec `wsgiref` puis avec gunicorn. Teste avec `curl -i`.
2. **Le piège des bytes** : retourne une chaîne au lieu de bytes, constate l'erreur, et corrige avec `.encode()`.
3. **Lire la requête** : affiche la méthode, le chemin et la query string parsée depuis `environ`.
4. **Le piège de la query string** : récupère un paramètre et constate que `parse_qs` donne une liste, pas une valeur.
5. **Lire un corps JSON** : écris `lire_corps`, parse le JSON, et gère le cas du JSON invalide (400) et du corps absent.
6. **Répondre en JSON** : écris la fonction `repondre_json` avec les bons en-têtes, et sers une réponse JSON avec des accents (vérifie l'encodage).
7. **Un 404** : réponds `404 Not Found` sur un chemin inconnu.
8. **Gunicorn** : lance ton app avec `gunicorn app:app`, puis avec plusieurs processus de travail (`-w 4`), et compare avec `wsgiref` sur une requête lente.
9. **Le bilan** : compte les lignes de plomberie contre les lignes de logique, comme au palier 4. Écris la liste de ce qu'un framework devra reprendre.
10. **Le lien avec le palier 4** : écris dans ton journal la correspondance entre WSGI et `node:http`, et entre gunicorn et le serveur Node intégré.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** `[b"texte"]` fonctionne, `["texte"]` lève `TypeError`. WSGI reste au niveau des octets parce que c'est ce que le réseau transporte. Tu encodes en sortie (`str.encode`) et tu décodes en entrée (`bytes.decode`). C'est la différence la plus visible avec Node, où les chaînes passaient directement.

**4.** `parse_qs("categorie=food")` donne `{"categorie": ["food"]}` — une **liste**, parce qu'un paramètre peut apparaître plusieurs fois (`?x=1&x=2`). C'est exactement le comportement de `req.query` en Express (palier 4), qui pouvait aussi être un tableau. Pour une valeur simple : `query.get("categorie", [None])[0]`.

**9.** Comme au palier 4, le ratio est écrasant : l'essentiel de ta fonction WSGI est de la plomberie (parsing, encodage, en-têtes, routage absent), et une petite part est la logique. La liste de ce qu'un framework reprend : le routage, le parsing du corps et de la query, l'abstraction requête/réponse, l'encodage, les codes de statut, la gestion des erreurs. **C'est le cahier des charges de ton mini-framework des leçons 05 à 08 — et c'est la même liste qu'au palier 4, ce qui prouve que le besoin est indépendant du langage.**

**10.** La correspondance à noter : WSGI ↔ `node:http` (l'interface bas niveau), le framework Flask ↔ Express (l'abstraction par-dessus), gunicorn ↔ le serveur intégré de Node (qui fait tourner le tout). La différence majeure : en Node, le serveur est dans le runtime ; en Python, il est séparé (gunicorn), ce qui est précisément ce que l'interface WSGI permet.
</details>

---

## ✅ Acquis si…

- [ ] J'écris une application WSGI minimale et je la sers avec gunicorn.
- [ ] Je sais qu'une application web Python est, au fond, une fonction `app(environ, start_response)`.
- [ ] Je lis la méthode, le chemin, la query string et le corps depuis `environ`.
- [ ] Je travaille en **bytes** et je n'oublie pas `.encode()` et `charset=utf-8`.
- [ ] Je sais que le corps est un flux, comme au palier 4.
- [ ] J'ai écrit `repondre_json`, mon premier morceau de framework.
- [ ] Je sais ce que signifie « gunicorn sert une app WSGI », et pourquoi pas `wsgiref` en production.
- [ ] Je fais le lien entre WSGI et `node:http` du palier 4.
- [ ] Je sais que WSGI est synchrone et ASGI asynchrone, et pourquoi ça compte pour FastAPI.

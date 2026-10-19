# Leçon 06 — Objets `Request` et `Response`, et les vues

> 🎯 **À la fin de cette leçon** : ton mini-framework a une vraie abstraction requête/réponse, et tes vues sont des fonctions propres qui ne touchent plus à WSGI.
> ⏱️ 5 h · **Prérequis** : leçons 04–05.

---

## De quoi on parle

Jusqu'ici, tes fonctions reçoivent `environ` et `start_response` — la plomberie brute de WSGI (leçon 04). C'est pénible : il faut lire le corps à la main, parser la query string, encoder les bytes, écrire les en-têtes. Une **vue** ne devrait pas se soucier de ça.

Un objet **`Request`** enveloppe la requête : il offre `request.method`, `request.path`, `request.query`, `request.json()` — des accès propres, calculés une fois depuis `environ`. Un objet **`Response`** enveloppe la réponse : tu lui donnes un statut, des données, un type, et il se charge de l'encodage et des en-têtes.

Une **vue** devient alors une fonction simple : elle reçoit une `Request`, elle retourne une `Response`. C'est tout. C'est le troisième étage de ton mini-framework, et celui qui le rend agréable à utiliser.

---

## À quoi ça sert, concrètement

**Parce que c'est ce qui sépare la plomberie de la logique.** Avant cette leçon, chaque vue mélange le traitement de la requête (lire le corps, parser) et la logique métier. Après, la vue ne fait que de la logique, et les objets Request/Response absorbent la plomberie. C'est exactement le gain qu'Express apportait sur `node:http` au palier 4 — ici, tu le fabriques toi-même.

**Parce que `request` et `response` sont le vocabulaire de tous les frameworks.** `request.json` en Flask, `request.POST` en Django, `$request->input()` en Laravel, `req`/`res` en Express : tous les frameworks web ont ces deux objets. En les construisant, tu comprends ce qu'ils contiennent et pourquoi — et tu ne les utiliseras plus par habitude.

**Parce que « une vue est une fonction Request → Response » est le modèle mental du web.** C'est le même que « l'interface est une fonction de l'état » en React (palier 3) : une transformation pure d'une entrée vers une sortie. Cette forme rend les vues testables (on leur passe une Request, on vérifie la Response) sans démarrer de serveur — exactement le test du palier 4.

**Et parce que ça prépare le découpage en couches en Python.** Tes vues appelleront des services, qui appelleront la couche modèles (leçon 07). C'est l'architecture du palier 4, transposée dans ton mini-framework.

---

## Où ça intervient dans le développement

Request/Response est la couche qui rend WSGI utilisable :

```
   WSGI (environ, start_response)    ← leçon 04 : brut
        ▼
   LE ROUTEUR                        ← leçon 05
        ▼
   REQUEST / RESPONSE                ← CETTE LEÇON : l'abstraction propre
        ▼
   les VUES : def vue(request) -> Response   ← elles ne voient plus WSGI
        ▼
   les SERVICES (logique) → la couche MODÈLES (leçon 07)
```

Trois points de transfert.

**C'est l'abstraction d'Express/de Flask, construite à la main.** `request.json()` fait ce que faisait `express.json()` (palier 4) : lire le flux, parser, gérer les erreurs. `Response.json(...)` fait ce que faisait `res.json()`. Tu reconnais les deux, et tu sais maintenant ce qu'il y a dedans.

**Elle rend tes vues testables.** Une vue qui reçoit une `Request` et retourne une `Response` se teste en une fonction, sans serveur ni réseau. C'est le test du palier 4 (« appelable sans serveur web »), et c'est ce qui prépare les tests de la leçon 11.

**Et elle est le socle du découpage.** Les vues orchestrent (comme les contrôleurs du palier 4), les services portent la logique, la couche modèles accède aux données (leçon 07). La vue ne doit contenir **aucune** règle métier — juste lire la requête, appeler un service, construire la réponse.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas sentir le confort : après Request/Response, écrire une vue devient agréable, là où WSGI brut était rebutant. C'est le moment où ton mini-framework commence à ressembler à un vrai outil.

Tu vas aussi découvrir que la validation du corps (le JSON mal formé, les champs manquants) doit se faire quelque part — et que, pour l'instant, c'est à la main. C'est ce que Pydantic automatisera au palier 5 (leçon 10).

### En équipe, en entreprise

**Tu manipuleras `request` et `response` tous les jours**, fournis par ton framework. Comprendre qu'ils enveloppent la requête HTTP brute t'évite les erreurs — notamment sur le parsing du corps et l'encodage.

**Tu verras le découpage vue → service.** Les équipes qui ont une bonne architecture gardent les vues minces (lire, déléguer, répondre) et mettent la logique dans des services. Les autres entassent tout dans les vues — et tu reconnaîtras le problème.

**Et tu testeras des vues.** Un test de vue qui construit une Request, appelle la vue, et vérifie la Response est un pattern standard. Il est possible parce que la vue est une fonction pure de Request vers Response.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : comprendre ce que contiennent `request` et `response`, savoir qu'une vue transforme l'un en l'autre, et garder les vues minces.

Rare et hors sujet : les flux de réponse (streaming), les réponses de fichiers, les cookies (abordés avec les sessions en leçon 09), la négociation de contenu, les réponses asynchrones (leçon 10). Tu les rencontreras dans les frameworks.

---

## La mécanique

### L'objet Request

```python
import json
from urllib.parse import parse_qs

class Request:
    def __init__(self, environ):
        self.environ = environ
        self.method = environ["REQUEST_METHOD"]
        self.path = environ["PATH_INFO"]
        self._query = parse_qs(environ["QUERY_STRING"])
        self._corps = None                             # lu paresseusement

    def query(self, cle, defaut=None):
        valeurs = self._query.get(cle)
        return valeurs[0] if valeurs else defaut       # parse_qs rend des listes (leçon 04)

    def corps(self):
        if self._corps is None:                        # on ne lit le flux qu'une fois
            try:
                taille = int(self.environ.get("CONTENT_LENGTH", 0))
            except ValueError:
                taille = 0
            self._corps = self.environ["wsgi.input"].read(taille) if taille else b""
        return self._corps

    def json(self):
        try:
            return json.loads(self.corps())            # peut lever JSONDecodeError
        except json.JSONDecodeError:
            raise ErreurValidation("corps", "JSON invalide")
```

Observe ce que tu viens de résoudre, une fois pour toutes : le parsing de la query string, la lecture du flux (une seule fois, mise en cache), le décodage JSON avec gestion d'erreur. Chaque vue bénéficie maintenant de `request.json()` au lieu de refaire cette plomberie. C'est `express.json()` du palier 4, en version maison.

### L'objet Response

```python
import json

class Response:
    def __init__(self, corps="", statut="200 OK", content_type="text/plain; charset=utf-8"):
        self.corps = corps
        self.statut = statut
        self.content_type = content_type

    @classmethod
    def json(cls, donnees, statut="200 OK"):           # ⭐ un constructeur pratique
        return cls(json.dumps(donnees), statut, "application/json; charset=utf-8")

    def wsgi(self, start_response):
        corps_bytes = self.corps.encode("utf-8")
        start_response(self.statut, [
            ("Content-Type", self.content_type),
            ("Content-Length", str(len(corps_bytes))),
        ])
        return [corps_bytes]
```

`Response.json({...})` est ton `res.json()`. La méthode `wsgi()` fait le pont avec `start_response` et l'encodage en bytes — toute la plomberie de la leçon 04, enfermée à un seul endroit. Tes vues ne voient plus jamais `start_response` ni les bytes.

### ⭐ Les vues : des fonctions Request → Response

```python
def lister_depenses(request):                          # ⭐ reçoit Request, retourne Response
    categorie = request.query("categorie")
    depenses = service_depenses.lister(categorie)      # on DÉLÈGUE au service
    return Response.json({"depenses": depenses})

def creer_depense(request):
    donnees = request.json()                           # parsing propre
    creee = service_depenses.creer(donnees)            # le service porte la logique
    return Response.json(creee, statut="201 Created")

def lire_depense(request, id):                         # le paramètre d'URL (leçon 05)
    depense = service_depenses.parid(int(id))
    if depense is None:
        return Response.json({"erreur": "introuvable"}, statut="404 Not Found")
    return Response.json(depense)
```

Compare avec la leçon 04 : plus de `environ`, plus de `start_response`, plus de bytes, plus de parsing manuel. Une vue lit la requête via `request`, délègue à un service, et construit une réponse via `Response`. C'est propre, lisible, et **testable** — et c'est le modèle exact des vues de Flask et Django.

Le point d'architecture : **la vue ne contient aucune règle métier.** Elle lit, délègue, répond. La logique (« le budget est-il dépassé ? », « cette catégorie existe-t-elle ? ») vit dans `service_depenses`. C'est le découpage du palier 4, et le test reste le même : *mon service est-il appelable sans Request ni Response ?* Oui — donc le découpage est bon.

### Assembler : le routeur appelle les vues avec des objets

```python
def creer_app(routeur):
    def app(environ, start_response):
        request = Request(environ)                     # on enveloppe une fois
        vue, params = routeur.resoudre(request.method, request.path)

        if vue is None:
            reponse = Response.json({"erreur": "route introuvable"}, "404 Not Found")
        else:
            try:
                reponse = vue(request, **params)       # la vue retourne une Response
            except ErreurValidation as e:
                reponse = Response.json({"erreur": str(e), "champ": e.champ}, "400 Bad Request")
            except ErreurMetier as e:
                reponse = Response.json({"erreur": str(e)}, "422 Unprocessable Entity")
            except Exception as e:
                print(e)                               # la trace pour nous (journaux)
                reponse = Response.json({"erreur": "erreur interne"}, "500 Internal Server Error")

        return reponse.wsgi(start_response)            # le pont vers WSGI, en un seul endroit
    return app
```

Tu viens d'écrire la **gestion centralisée des erreurs** du palier 4 (leçon 04), en Python : les exceptions métier deviennent des codes HTTP, à un seul endroit, et la vue n'a qu'à lever une exception. La distinction erreurs attendues (400, 422) / bugs (500 neutre) du palier 1 (leçon 08) est respectée, et la trace ne fuit pas au client.

---

## Les problèmes que tu vas rencontrer

**Mon `request.json()` plante sur un corps vide.** Un `GET` n'a pas de corps. Vérifie `request.method` ou gère le cas du corps vide dans `json()`.

**Je lis le corps deux fois et la deuxième lecture est vide.** Un flux ne se lit qu'une fois (comme en Node). D'où la mise en cache (`self._corps`) dans `Request`.

**Mes accents sont cassés.** L'encodage : vérifie `.encode("utf-8")` dans `Response.wsgi` et `charset=utf-8` dans le `Content-Type`.

**Ma vue contient de la logique métier.** Elle ne devrait pas. Déplace les règles dans un service. Le signe : ta vue fait plus que lire-déléguer-répondre.

**Mon erreur métier remonte en 500 au lieu de 422.** Ta gestion centralisée n'attrape pas le bon type d'exception, ou tu lèves une `Exception` générique au lieu d'une `ErreurMetier`.

**Ma trace d'erreur apparaît dans la réponse du client.** Tu renvoies `str(e)` sur une exception inattendue. Message neutre pour le client, trace dans les journaux (palier 4, leçon 04).

---

## Ce qu'on te demandera

En **entretien**, on ne te demandera pas de construire Request/Response, mais on appréciera que tu saches ce qu'ils contiennent : « que trouve-t-on dans l'objet request d'un framework ? », « comment un framework parse-t-il le corps JSON ? ». Et surtout : « où mets-tu la logique métier, dans la vue ou ailleurs ? » — la bonne réponse est « dans un service, la vue ne fait que lire-déléguer-répondre ».

En **test technique**, un code où les vues sont minces et la logique dans des services est valorisé.

---

## Ce qui te démarquera

**Des vues minces.** Savoir dire « ma vue lit la requête, appelle un service, et construit la réponse — rien d'autre » montre que tu as compris le découpage, pas seulement la syntaxe du framework.

**Comprendre ce que les objets request/response font.** Pouvoir expliquer que `request.json()` lit un flux, le parse et gère l'erreur, c'est savoir ce que le framework fait à ta place.

**La gestion centralisée des erreurs.** Transposer ce pattern du palier 4 en Python prouve que tu transfères une architecture, pas des recettes.

**Et des vues testables.** « Je teste mes vues en leur passant une Request et en vérifiant la Response, sans serveur » est exactement l'état d'esprit du palier 4 et la préparation du palier 11.

---

## 📚 À lire

**Flask → *The Request Object*** et ***Response Objects*** : lis-les **maintenant**, et tu reconnaîtras ce que tu viens de construire. `request.json`, `request.args`, les constructeurs de réponse : c'est ton mini-framework, en version mature.

**Django → *Request and response objects*** pour une seconde formulation, un peu plus riche.

**docs.python.org → *json*** et ***urllib.parse*** pour les outils que tu utilises (`json.loads`, `parse_qs`).

Et relis le palier 4, leçon 02 (Express) et leçon 04 (gestion d'erreurs) : tu es en train d'en refaire l'équivalent, et la comparaison est éclairante.

---

## 🤖 Le mini-projet à demander à l'IA

Le transfert de l'abstraction du palier 4 :

> « Je suis en formation de développeur, palier 5. Je construis un mini-framework Python au-dessus de WSGI. J'ai un routeur ; j'ajoute maintenant des objets Request et Response, et des vues qui sont des fonctions Request → Response. Sans me donner de code, guide-moi par questions : que doit contenir ma classe Request (en te basant sur ce qu'Express me donnait au palier 4), comment je lis le corps une seule fois, comment Response gère l'encodage et les en-têtes, et où je mets la gestion centralisée des erreurs. Quand je te montre mon code, vérifie une seule chose : mes vues contiennent-elles de la logique métier qui devrait être dans un service ? »

Puis les tests de vues, qui préparent le palier 11 :

> « Explique-moi comment tester une vue qui est une fonction Request → Response, sans démarrer de serveur. Donne-moi la structure d'un test (construire une fausse Request, appeler la vue, vérifier la Response), et 5 cas à couvrir (succès, 404, corps invalide, paramètre manquant, erreur métier). Ne me donne pas le code complet — je dois l'écrire. »

---

## 🛠️ À faire

1. **La classe Request** : `method`, `path`, `query()`, `corps()` (lu une seule fois), `json()` avec gestion du JSON invalide.
2. **Le piège de la double lecture** : lis `request.corps()` deux fois et vérifie, grâce à la mise en cache, que la seconde lecture fonctionne.
3. **La classe Response** : avec un constructeur `Response.json()` et une méthode `wsgi()` qui encode en bytes et écrit les en-têtes.
4. **Les vues** : réécris `lister`, `creer`, `lire` et `supprimer` comme des fonctions Request → Response. Vérifie qu'aucune ne voit `environ` ni `start_response`.
5. **Le découpage** : déplace toute la logique métier dans un module `services.py`. Vérifie que tes vues ne font que lire-déléguer-répondre.
6. **La gestion centralisée des erreurs** : dans `creer_app`, attrape `ErreurValidation` (400), `ErreurMetier` (422) et le reste (500 neutre). Lève une erreur depuis un service et vérifie le bon code.
7. **La trace ne fuit pas** : provoque une exception inattendue et vérifie que le client reçoit un message neutre, pas la trace.
8. **Teste une vue** : écris un test qui construit une fausse Request, appelle une vue, et vérifie la Response — **sans démarrer de serveur**.
9. **La comparaison** : note dans ton journal la correspondance entre ta Request/Response et les objets d'Express (palier 4).

<details>
<summary>Corrections et points de contrôle</summary>

**2.** Un flux WSGI (`environ["wsgi.input"]`) se lit une seule fois, comme en Node. Sans la mise en cache (`if self._corps is None`), un deuxième appel à `request.json()` dans la même requête renverrait un corps vide. C'est pourquoi `Request` lit le flux une fois et garde le résultat.

**5.** Le test du découpage : tes services ne doivent importer ni `Request`, ni `Response`, ni `environ`. Ils reçoivent des données simples et retournent des données simples. Si un service a besoin de `request`, la logique a débordé de la vue — c'est exactement le test « appelable sans serveur web » du palier 4.

**6.** La gestion centralisée transforme les exceptions en codes HTTP à **un seul endroit**. La vue se contente de lever `ErreurMetier("budget dépassé")` ; c'est `creer_app` qui la traduit en 422. Ainsi les services restent indépendants de HTTP (ils ne connaissent pas les codes de statut), et la traduction est cohérente pour toute l'application. C'est le pattern du palier 4, leçon 04.

**8.** Une vue étant une fonction pure de Request vers Response, on la teste sans serveur :
```python
def test_lire_depense_introuvable():
    request = Request(environ_factice(method="GET", path="/depenses/999"))
    reponse = lire_depense(request, id="999")
    assert reponse.statut == "404 Not Found"
```
C'est la testabilité que le découpage apporte, et c'est ce que tu généraliseras au palier 11. Le fait de pouvoir tester sans réseau est la preuve que ton architecture est propre.
</details>

---

## ✅ Acquis si…

- [ ] J'ai une classe `Request` qui offre `method`, `path`, `query()` et `json()`.
- [ ] Je lis le corps une seule fois (mise en cache du flux).
- [ ] J'ai une classe `Response` avec un constructeur `json()` et une méthode qui fait le pont WSGI.
- [ ] Mes vues sont des fonctions Request → Response, sans trace de `environ` ni de bytes.
- [ ] Mes vues ne contiennent **aucune** logique métier : elles délèguent à des services.
- [ ] J'ai une gestion centralisée des erreurs qui traduit les exceptions en codes HTTP.
- [ ] Aucune trace technique ne fuit au client.
- [ ] Je teste une vue sans démarrer de serveur.
- [ ] Je reconnais ma Request/Response dans les objets request/response d'Express et de Flask.

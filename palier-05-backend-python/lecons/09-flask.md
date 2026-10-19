# Leçon 09 — Flask : le micro-framework

> 🎯 **À la fin de cette leçon** : tu utilises Flask en reconnaissant chaque brique — parce que tu l'as construite dans ton mini-framework — et tu mesures ce qu'il t'économise.
> ⏱️ 6 h · **Prérequis** : les leçons 04 à 08 (ton mini-framework WSGI).

---

## De quoi on parle

**Flask** est un **micro-framework** web Python. « Micro » ne veut pas dire limité : il fournit le cœur — routage, requête/réponse, templates, sessions — et te laisse choisir le reste (base de données, validation, structure). C'est l'opposé de Django, qui fournit tout et impose une structure (leçon 11).

```python
from flask import Flask
app = Flask(__name__)

@app.route("/depenses")
def lister():
    return {"depenses": [...]}        # Flask convertit le dict en JSON

app.run()
```

Chaque élément de Flask correspond à une brique de ton mini-framework : `@app.route` est ton routeur, l'objet `request` est ta classe Request, le retour est ta Response, et Flask utilise **Jinja2** — le moteur que tu viens d'utiliser. Flask n'est, au fond, qu'un mini-framework WSGI mature et bien fait.

---

## À quoi ça sert, concrètement

**Parce que ton mini-framework était pénible à maintenir.** Tu as construit un routeur, une abstraction requête/réponse, une couche de données, des templates. Ça fonctionne, mais c'est fragile et incomplet (pas de sessions, pas de gestion des erreurs propre, pas de rechargement). Flask fait tout ça, en robuste et testé. La comparaison est frappante **parce que** tu as fait le travail à la main.

**Parce que « micro » est un choix d'architecture.** Flask te laisse composer ta stack : la base que tu veux, la validation que tu veux, la structure que tu veux. C'est de la liberté, mais aussi de la responsabilité — tu dois faire des choix que Django prend pour toi. Comprendre ce compromis « opinionated ou non » est au cœur du fil rouge architecture (palier 7).

**Parce que Flask est omniprésent et simple.** Il domine les petits services, les API internes, les prototypes, les microservices. Sa simplicité en fait un excellent second framework après ton mini-framework : tu reconnais tout, et tu te concentres sur ce qu'il ajoute.

**Et parce qu'il prépare la comparaison.** Flask (micro), FastAPI (API moderne typée), Django (tout inclus) : ce sont trois philosophies. En connaissant Flask, tu as le point de départ du comparatif que tu rédigeras au palier 7.

---

## Où ça intervient dans le développement

Flask remplace ton mini-framework, brique pour brique :

```
   TON MINI-FRAMEWORK          →   FLASK
   ──────────────────              ─────
   ton routeur (leçon 05)      →   @app.route
   ta classe Request (leçon 06) →   l'objet request
   ta classe Response           →   le retour de la vue (dict, str, tuple)
   ta couche SQLite (leçon 07)  →   (ton choix : SQLAlchemy, sqlite3...)
   tes templates Jinja2 (l. 08) →   render_template (Jinja2 intégré)
   gunicorn (leçon 04)          →   gunicorn (identique)
```

Tu ne découvres presque rien : tu reconnais tout, et tu vois comment un framework mature a résolu les mêmes problèmes que toi.

Trois points de transfert.

**C'est ton mini-framework, en mieux.** Chaque geste de Flask a son équivalent dans ce que tu as construit. Cette correspondance est la raison du module « natif d'abord » : tu abordes Flask en terrain connu, pas en découvrant une boîte noire.

**C'est aussi Express, en Python.** Au palier 4, Express était le micro-framework de Node : minimal, non-opinionated, à composer soi-même. Flask est son équivalent Python. Les middlewares, les routes, la gestion d'erreurs : tu reconnais le palier 4. Trois langages, un même type de framework.

**Et il ne fournit pas tout — c'est volontaire.** Flask n'a ni ORM, ni validation intégrée, ni structure imposée. Tu ajoutes ce qu'il faut. C'est le contraire de Django (leçon 11), et cette différence est exactement ce que tu analyseras au palier 7.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas ressentir un soulagement : après ton mini-framework, Flask fait tout ce qui était pénible, et tu reconnais chaque concept. Le rechargement automatique, les sessions, la gestion d'erreurs propre : autant de choses que tu n'as pas eu à finir.

Tu vas aussi découvrir les **décorateurs** en action (`@app.route`). Tu as vu `**kwargs` à la leçon 02 ; les décorateurs reposent dessus, et tu comprends maintenant pourquoi `@app.route("/x")` au-dessus d'une fonction l'enregistre dans une table de routes — c'est ton routeur, avec une syntaxe élégante.

### En équipe, en entreprise

**Flask est le choix des services légers et des API simples.** Pour un microservice, un prototype, une API interne, c'est souvent Flask. Pour une grosse application avec back-office, c'est plutôt Django. Savoir quand choisir l'un ou l'autre est une vraie compétence.

**La structure est libre, donc variable.** Chaque équipe organise son projet Flask à sa façon. Tu verras des *blueprints* (le découpage modulaire de Flask), des *application factories*, des structures par couche. Comme Flask n'impose rien, la discipline vient de l'équipe.

**L'écosystème est un assemblage.** Flask + SQLAlchemy (ORM) + Marshmallow ou Pydantic (validation) + Flask-Login (auth) : on compose. Cette liberté est la force et la faiblesse de Flask.

**Et tu entendras « Flask ou FastAPI ? ».** Pour une nouvelle API, beaucoup choisissent désormais FastAPI (leçon 10) pour sa validation typée intégrée. Flask reste pour sa simplicité et son écosystème mature. Tu auras les deux en main pour trancher.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `@app.route` avec méthodes et paramètres, l'objet `request` (`request.json`, `request.args`), le retour de dict/tuple, `render_template`, et les codes de statut.

Régulièrement : les blueprints (découpage), les sessions, `abort()` et les gestionnaires d'erreurs, la configuration, `url_for`, les variables d'environnement.

Rare, et hors sujet pour l'instant : les signaux Flask, les extensions complexes, le contexte d'application en profondeur, les vues basées sur des classes, le streaming, l'async de Flask. Tu les découvriras par besoin.

---

## La mécanique

### Le squelette

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install flask
```

```python
# app.py
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/sante")
def sante():
    return {"statut": "ok"}             # un dict devient du JSON automatiquement

if __name__ == "__main__":
    app.run(debug=True)                 # debug=True : rechargement auto (DÉVELOPPEMENT)
```

```bash
flask --app app run --debug             # ou cette commande
```

`@app.route("/sante")` est ton routeur de la leçon 05 : le décorateur enregistre la fonction dans la table de routes de Flask. Et retourner un dict qui devient du JSON, c'est ta `Response.json` — Flask le fait pour toi.

### Les routes et les paramètres

```python
@app.route("/depenses", methods=["GET"])
def lister():
    categorie = request.args.get("categorie")        # ta query(), leçon 06
    return jsonify(service.lister(categorie))

@app.route("/depenses/<int:id>", methods=["GET"])    # ⭐ <int:id> : paramètre TYPÉ
def lire(id):                                         # id est déjà un int !
    depense = service.par_id(id)
    if depense is None:
        return {"erreur": "introuvable"}, 404         # tuple : (corps, statut)
    return depense

@app.route("/depenses", methods=["POST"])
def creer():
    donnees = request.get_json()                      # ton request.json(), leçon 06
    creee = service.creer(donnees)
    return creee, 201                                 # 201 Created
```

Regarde `<int:id>` : Flask convertit **automatiquement** le paramètre en entier. C'est l'amélioration directe de ton routeur, où le paramètre était toujours une chaîne qu'il fallait convertir à la main (leçon 05). Flask gère la conversion **et** renvoie un 404 si ce n'est pas un entier valide.

Et le retour `(corps, statut)` en tuple est l'écriture concise de ta Response : Flask comprend qu'un tuple est un corps et un code de statut.

### Les templates : Jinja2, que tu connais déjà

```python
from flask import render_template

@app.route("/depenses/page")
def page_depenses():
    depenses = service.lister()
    return render_template("depenses.html", depenses=depenses, nom="Serge")
```

`render_template` cherche dans un dossier `templates/` et rend le fichier avec Jinja2 — **exactement** le moteur de la leçon 08, avec l'échappement automatique activé. Tu ne découvres rien : tu retrouves tes templates, intégrés au framework. Flask fournit le SSR que tu avais construit à la main.

### Les sessions

```python
from flask import session

app.config["SECRET_KEY"] = os.environ["SECRET_KEY"]   # ⭐ pour signer les cookies de session

@app.route("/connexion", methods=["POST"])
def connexion():
    # ... vérifier l'utilisateur ...
    session["utilisateur_id"] = utilisateur.id         # stocké dans un cookie signé
    return {"ok": True}

@app.route("/profil")
def profil():
    uid = session.get("utilisateur_id")
    if uid is None:
        return {"erreur": "non connecté"}, 401
    return {"id": uid}
```

C'est le mécanisme de session du palier 4 (leçon 08) : un cookie qui rétablit la continuité par-dessus HTTP sans état (palier 0, leçon 07). Flask stocke la session dans un cookie **signé** (avec `SECRET_KEY`), ce qui empêche le client de la modifier. C'est une brique que ton mini-framework n'avait pas, et que Flask te donne — un exemple concret de ce qu'un framework ajoute.

### La gestion des erreurs

```python
from flask import abort

@app.route("/depenses/<int:id>")
def lire(id):
    depense = service.par_id(id)
    if depense is None:
        abort(404)                                     # interrompt proprement
    return depense

# Gestionnaire centralisé (comme ta gestion d'erreurs, leçon 06)
@app.errorhandler(404)
def introuvable(e):
    return {"erreur": "ressource introuvable"}, 404

@app.errorhandler(ErreurValidation)
def validation(e):
    return {"erreur": str(e), "champ": e.champ}, 400
```

`@app.errorhandler` est ta gestion centralisée des erreurs (leçon 06), intégrée : tu déclares comment traduire un type d'erreur en réponse, et Flask l'applique partout. La distinction erreurs attendues (400) / bugs (500) du palier 1 reste valide.

### ⭐ Les blueprints : le découpage modulaire

```python
# routes/depenses.py
from flask import Blueprint

bp = Blueprint("depenses", __name__, url_prefix="/depenses")

@bp.route("/")
def lister(): ...

@bp.route("/<int:id>")
def lire(id): ...

# app.py
from routes.depenses import bp as depenses_bp
app.register_blueprint(depenses_bp)
```

Un *blueprint* regroupe les routes d'une ressource dans un module, avec un préfixe commun. C'est le découpage en couches du palier 4 (routes modulaires) et l'équivalent des `express.Router()` : les URL d'un côté, organisées par ressource. Flask n'impose pas ce découpage (contrairement à Django), mais il le permet — à toi de l'adopter.

### Servir en production

```bash
gunicorn app:app                        # le MÊME gunicorn que ton mini-framework
```

> ⚠️ `app.run(debug=True)` est le serveur de **développement** de Flask : mono-processus, non optimisé, avec `debug=True` qui expose les traces d'erreur — **jamais en production** (c'est le pendant de `wsgiref` et, plus tard, de `runserver` de Django). En production : gunicorn, exactement comme pour ton mini-framework, derrière Nginx au palier 8.

---

## Les problèmes que tu vas rencontrer

**`request.get_json()` renvoie `None`.** Le client n'a pas envoyé `Content-Type: application/json`, ou le corps est vide. Même piège qu'au palier 4 (le POST vide).

**Mon paramètre `<int:id>` renvoie un 404 sur une valeur non numérique.** C'est voulu : `<int:id>` n'accepte que les entiers. Pour accepter autre chose, utilise `<id>` (chaîne) ou `<string:id>`.

**Ma session ne persiste pas.** Il manque `SECRET_KEY`, ou elle change à chaque redémarrage (ne la génère pas aléatoirement au démarrage — mets-la dans l'environnement).

**`debug=True` en production expose mes traces.** C'est une faille (comme `DEBUG=True` de Django, leçon 11, et les traces du palier 4). Jamais de `debug=True` en production.

**Mes blueprints ne sont pas pris en compte.** Tu as oublié `app.register_blueprint(...)`, ou le préfixe est mal défini.

**Mon dict n'est pas converti en JSON.** Flask convertit les dicts automatiquement, mais pas les listes dans les anciennes versions — utilise `jsonify()` pour être sûr.

**Flask ne trouve pas mes templates.** Ils doivent être dans un dossier `templates/` à côté de ton `app.py`. C'est la convention de Flask (et de Jinja2).

---

## Ce qu'on te demandera

En **entretien**, si Flask est au programme : « qu'est-ce qu'un micro-framework ? », « différence entre Flask et Django ? », « qu'est-ce qu'un blueprint ? », « comment gères-tu les erreurs dans Flask ? ».

Pour ton profil, la question qui porte : **« tu as construit un mini-framework avant d'utiliser Flask — qu'est-ce que Flask t'a apporté ? »**. Pouvoir répondre par la liste précise (sessions robustes, rechargement, gestion d'erreurs propre, Jinja2 intégré, tests) est une réponse d'un niveau rare.

En **test technique**, une petite API Flask propre (blueprints, gestion d'erreurs, codes corrects) est valorisée.

---

## Ce qui te démarquera

**Reconnaître chaque brique de Flask dans ton mini-framework.** « `@app.route` est mon routeur, `request` est ma classe Request, `render_template` utilise le Jinja2 que j'ai déjà manipulé » montre que tu comprends Flask de l'intérieur.

**Savoir ce que « micro » implique.** Pouvoir dire « Flask ne fournit pas d'ORM ni de validation, je compose ; Django fournit tout, il impose » est le cœur du comparatif d'architecture.

**Utiliser les blueprints.** Un projet Flask bien découpé, là où beaucoup laissent tout dans un fichier.

**Ne jamais laisser `debug=True` en production.** Et savoir pourquoi (la trace exposée).

**Et faire le lien avec Express.** Dire « Flask est à Python ce qu'Express est à Node : un micro-framework à composer » prouve une vision transversale.

---

## 📚 À lire

**flask.palletsprojects.com → *Quickstart*** puis le **tutoriel officiel complet** : il est excellent et couvre une vraie petite application (blueprints, base de données, sessions, tests). C'est la meilleure ressource Flask.

**flask.palletsprojects.com → *Application Factories* et *Blueprints*** pour le découpage.

Relis les leçons 05 à 08 (ton mini-framework) en parallèle : la correspondance brique par brique est la meilleure façon d'apprendre Flask.

---

## 🤖 Le mini-projet à demander à l'IA

Le transfert de ton mini-framework vers Flask :

> « Je suis en formation de développeur, palier 5. Je viens de construire un mini-framework Python (WSGI, routeur, Request/Response, SQLite, Jinja2). Je passe à Flask. Sans me donner de code, aide-moi à faire la correspondance **brique par brique** : pour chaque composant de mon mini-framework, quel est l'équivalent Flask, et qu'est-ce que Flask ajoute que je n'avais pas ? Puis guide-moi par questions pour réécrire mon application en Flask, en reconnaissant que @app.route est mon routeur, request est ma classe Request, etc. »

Puis l'exercice de mesure :

> « Aide-moi à mesurer ce que Flask m'économise. Pour mon application de dépenses, liste les fonctionnalités que mon mini-framework n'avait pas ou gérait mal (sessions, rechargement, gestion d'erreurs centralisée, échappement, tests), et pour chacune, demande-moi combien de lignes il m'aurait fallu pour la faire correctement à la main. »

---

## 🛠️ À faire

1. **Le squelette** : une app Flask avec une route de santé, lancée avec le rechargement automatique.
2. **Porte ton application** : réécris l'API de dépenses de ton mini-framework en Flask. Pour chaque geste, note dans un commentaire quelle brique de ton mini-framework il remplace.
3. **Le paramètre typé** : utilise `<int:id>` et constate que `id` est déjà un entier, et qu'une valeur non numérique renvoie un 404 automatiquement. Compare avec le `int(id)` manuel de ta leçon 05.
4. **Les codes de statut** : `201` à la création, `404` sur ressource absente, via le tuple `(corps, statut)`.
5. **Les templates** : rends une page avec `render_template` et Jinja2. Vérifie que l'échappement fonctionne (donnée avec `<script>`).
6. **Les sessions** : implémente connexion/déconnexion avec `session`. Vérifie que le cookie est signé (modifie-le dans le navigateur et constate qu'il est rejeté).
7. **La gestion d'erreurs** : un `@app.errorhandler` pour tes erreurs de validation (400) et pour le 404.
8. **Les blueprints** : découpe tes routes de dépenses dans un blueprint, avec un préfixe `/depenses`.
9. **Servir avec gunicorn** : lance ton app Flask avec `gunicorn app:app`, exactement comme ton mini-framework.
10. **Le bilan** : écris dans ton journal ce que Flask t'a apporté par rapport à ton mini-framework, et en quoi il ressemble à Express (palier 4).

<details>
<summary>Corrections et points de contrôle</summary>

**3.** `<int:id>` fait deux choses que ton routeur ne faisait pas : il **convertit** le paramètre en entier (plus de `int(id)` manuel), et il **valide** que c'est bien un entier (une valeur non numérique renvoie un 404 avant même d'entrer dans ta fonction). C'est l'amélioration directe de ta leçon 05 — le framework automatise la conversion et la validation du paramètre.

**6.** Flask signe le cookie de session avec `SECRET_KEY` : si tu modifies le cookie dans le navigateur, la signature ne correspond plus et Flask rejette la session. C'est le mécanisme du palier 4 (leçon 08) : le client ne peut pas falsifier une session signée. C'est une brique que ton mini-framework n'avait pas, et un bon exemple de ce qu'un framework mature apporte en sécurité.

**10.** Ce que Flask apporte : les sessions signées, le rechargement automatique, la gestion d'erreurs centralisée intégrée, Jinja2 déjà branché, un écosystème d'extensions, et la testabilité. En quoi il ressemble à Express : c'est un **micro**-framework (routage + requête/réponse, le reste à composer), non-opinionated, où tu choisis ta base et ta validation. **Flask est à Python ce qu'Express est à Node** — et c'est exactement le genre de rapprochement que tu feras au palier 7.
</details>

---

## ✅ Acquis si…

- [ ] Je crée une API Flask avec routes, paramètres et codes de statut corrects.
- [ ] Je reconnais chaque brique de Flask dans mon mini-framework.
- [ ] J'utilise `<int:id>` et je sais ce qu'il automatise par rapport à mon routeur.
- [ ] J'utilise `render_template` avec Jinja2 et son échappement.
- [ ] J'implémente des sessions signées, et je sais pourquoi le client ne peut pas les falsifier.
- [ ] J'ai une gestion d'erreurs centralisée avec `@app.errorhandler`.
- [ ] Je découpe mes routes en blueprints.
- [ ] Je sers avec gunicorn, et je ne laisse jamais `debug=True` en production.
- [ ] Je sais ce que « micro-framework » implique, et je fais le lien avec Express.
- [ ] J'ai mesuré ce que Flask m'économise par rapport à mon mini-framework.

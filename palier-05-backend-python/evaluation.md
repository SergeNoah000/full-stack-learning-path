# ✅ Épreuve de sortie — Palier 5

> **Conditions** : seul, sans tutoriel. IA autorisée comme « accélérateur de langages » (niveau 5), **interdite sur le mini-framework** (épreuve A2) — c'est là que se joue la compréhension.
> **Durée** : ~5 h hors projet. **Seuil** : 5/5 épreuves · **16/22** au quiz · projet 5 déployé sur AWS **et instance nettoyée**.

---

## Partie A — Épreuves pratiques

### A1 — Transfert JS → Python (45 min)
Reprends 5 fonctions du palier 1 (dont `totauxParCategorie`) et réécris-les en Python **idiomatique** :
- comprehensions au lieu de `map`/`filter`
- `collections.Counter` ou `defaultdict` là où c'est pertinent
- **type hints** partout, `mypy` sans erreur
- docstrings
- un `venv` propre, `requirements.txt` (ou `pyproject.toml`)

✅ **Réussi si** : `mypy` passe, le code est pythonique (pas du JavaScript traduit mot à mot), et tu expliques 3 différences de philosophie entre les deux langages.

### A2 — Le mini-framework (2 h, **sans IA, sans tutoriel**)
Reconstruis **de mémoire** un mini-framework WSGI fonctionnel :
1. une app WSGI qui lit `PATH_INFO` et `REQUEST_METHOD`
2. un **routeur** : table de routes + correspondance avec paramètres (`/depenses/<id>`)
3. un objet `Request` (query string, corps, formulaire) et un objet `Response` (statut, en-têtes, JSON/HTML)
4. des **vues** : fonctions `Request → Response`
5. une couche **modèles** SQLite avec requêtes préparées
6. des **templates** rendus avec Jinja2 (utilisé seul, hors Flask)
7. servi par **gunicorn**

✅ **Réussi si** : l'API du gestionnaire de dépenses tourne dessus, avec rendu HTML côté serveur, et tu peux **expliquer chaque ligne**.

### A3 — Les trois frameworks (60 min)
La même ressource `depenses` (liste + création), implémentée trois fois :
1. en **Flask** (templates Jinja2)
2. en **FastAPI** (Pydantic, validation automatique, `/docs` OpenAPI)
3. en **Django** (modèle + migration + vue + admin exploitée)

✅ **Réussi si** : les trois fonctionnent, et tu produis un tableau comparatif de ce que chacun t'a imposé, facilité et caché.

### A4 — SQL et ORM en Python (45 min)
- 3 requêtes SQL écrites à la main via `sqlite3`/`psycopg` avec **requêtes préparées**
- les mêmes via l'ORM Django, puis via SQLAlchemy/SQLModel
- mets en évidence un **problème N+1** sur une relation, puis corrige-le (`select_related`/`prefetch_related`)
- fais afficher le SQL généré par l'ORM et compare-le au tien

✅ **Réussi si** : le N+1 est démontré (nombre de requêtes avant/après) et corrigé.

### A5 — Déploiement AWS (60 min)
- ⚠️ **Alerte de facturation (Budget à 1 $) créée AVANT toute autre action** — capture d'écran obligatoire
- EC2 t2/t3.micro, accès SSH par clés, groupe de sécurité minimal
- gunicorn + Nginx configurés **à la main**, service `systemd`
- PostgreSQL sur l'instance, Django servi en production (`DEBUG=False`, `ALLOWED_HOSTS`, fichiers statiques)
- **procédure de redéploiement écrite en 10 lignes** dans le README
- **instance détruite après validation** (capture de la console à l'appui)

✅ **Réussi si** : l'app a été accessible publiquement, puis l'infrastructure est nettoyée. *L'infra se nettoie : ça fait partie de l'apprentissage.*

---

## Partie B — Quiz (22 questions)

**Python**
1. Trois différences de philosophie entre Python et JavaScript.
2. Liste, tuple, set, dict : quand utiliser chacun ?
3. Écris en comprehension l'équivalent de `depenses.filter(…).map(…)`.
4. À quoi sert un `venv` ? Que se passe-t-il sans ?
5. `*args` et `**kwargs` : à quoi ça sert ?
6. Les type hints sont-ils vérifiés à l'exécution ? À quoi servent-ils alors ?
7. Qu'est-ce qu'une f-string ? Quel danger si elle construit du SQL ?

**Le web sans framework**
8. Qu'est-ce que WSGI ? Quelle est la signature d'une application WSGI ?
9. Dans ton mini-framework, qu'as-tu dû construire à la main ? (Cite 6 briques.)
10. Comment ton routeur extrait-il un paramètre d'URL ?
11. Qu'est-ce que le SSR, et qu'est-ce qui change par rapport à une SPA (palier 3) ?
12. À quoi sert gunicorn ? Pourquoi `python manage.py runserver` n'est-il pas utilisable en production ?
13. Pourquoi un reverse proxy (Nginx) devant gunicorn ?

**Les frameworks**
14. Flask vs FastAPI vs Django : avec quels **critères** choisis-tu ? (Pas des goûts.)
15. Qu'apporte Pydantic ? Quel lien avec Zod (palier 4) ?
16. D'où vient la documentation OpenAPI de FastAPI, et pourquoi est-ce précieux pour un client ?
17. Qu'est-ce que le MVT de Django, et en quoi diffère-t-il du MVC ?
18. Pourquoi l'admin Django est-elle un argument commercial décisif ?
19. Django ORM, Prisma, Eloquent : quels patterns, et quelle différence de philosophie ?
20. Qu'est-ce qu'un problème N+1 ? Comment le détecter et le corriger ?
21. Qu'est-ce qu'un blueprint Flask / une app Django ? Quel problème d'architecture résolvent-ils ?
22. Pourquoi `DEBUG = True` en production est-il une faille de sécurité ?

<details>
<summary>Corrections — points clés</summary>

1. Par exemple : indentation significative vs accolades · « une seule façon évidente de faire » vs multiples idiomes · bibliothèque standard très riche vs écosystème npm · typage dynamique dans les deux cas mais culture du type hint + `mypy` · pas de `undefined` (seulement `None`).
2. Liste : séquence ordonnée modifiable. Tuple : séquence **immuable** (clé de dict possible, retour multiple). Set : unicité et appartenance en `O(1)`. Dict : association clé → valeur.
3. `[transformer(d) for d in depenses if condition(d)]`.
4. À isoler les dépendances **par projet**. Sans lui : conflits de versions entre projets, et des installations globales qui cassent des outils système.
5. À accepter un nombre variable d'arguments positionnels / nommés, et à les transmettre à une autre fonction.
6. Non, ils sont ignorés à l'exécution. Ils servent à la vérification statique (`mypy`), à l'autocomplétion, à la documentation — et à Pydantic/FastAPI qui s'en servent, eux, pour valider.
7. Une chaîne interpolée `f"..."`. Danger : `f"SELECT * FROM t WHERE id={id}"` est une **injection SQL**. Toujours des paramètres (`?` ou `%s`), jamais d'interpolation.
8. L'interface standard entre un serveur et une app Python : un appelable `app(environ, start_response)`. C'est **tout** ce qu'est une application web Python.
9. Routage, extraction des paramètres d'URL, parsing du corps et de la query string, abstraction requête/réponse, couche d'accès aux données, moteur de templates, gestion des erreurs et des codes. **C'est la facture d'un framework.**
10. Par une expression régulière (ou un découpage de segments) construite depuis le motif de route, puis capture des groupes passés à la vue.
11. Le serveur produit le HTML complet. Différences : premier affichage plus rapide et meilleur référencement, mais rechargement de page et interactivité plus limitée. C'est l'approche historique du web — et celle de PHP au palier 6.
12. gunicorn est un **vrai serveur WSGI** (multi-workers, robuste). `runserver` est mono-thread, non sécurisé, non optimisé : il est explicitement marqué « ne pas utiliser en production ».
13. Pour TLS, les fichiers statiques, la compression, la limitation de débit, le buffering des requêtes lentes et la protection de l'app.
14. Taille et durée du projet · besoin d'un back-office (→ Django) · API typée et documentée automatiquement (→ FastAPI) · besoin de contrôle total et de légèreté (→ Flask) · compétence de l'équipe · écosystème attendu.
15. La validation et la conversion de données **à partir des type hints**. Même rôle que Zod : garantir qu'une donnée extérieure est conforme avant d'entrer dans la logique métier.
16. Elle est générée depuis les modèles Pydantic et les signatures. Précieux car la doc ne peut plus être fausse — et c'est un livrable contractuel (spécification d'API).
17. Model (données) / View (la logique de la requête, équivalent du contrôleur) / Template (l'affichage). Le « contrôleur » de Django, c'est son routeur et son framework lui-même ; le vocabulaire diffère, le découpage non.
18. Elle fournit gratuitement un back-office complet (CRUD, filtres, recherche, droits) : des semaines de développement offertes, visibles par le client dès le premier jour.
19. Django ORM et Eloquent : **Active Record** (l'objet sait se sauver lui-même). Prisma et SQLAlchemy Core : plutôt **Data Mapper** (un service traduit). Active Record est plus rapide à écrire, Data Mapper sépare mieux le domaine du stockage.
20. Une requête initiale, puis une requête **par élément** du résultat (souvent dans une boucle d'affichage). Détection : compter les requêtes (Django Debug Toolbar, journal SQL). Correction : `select_related` (jointure) ou `prefetch_related` (seconde requête groupée).
21. Un moyen de découper une application en modules autonomes (routes, templates, modèles propres). Ils évitent le fichier unique de 3 000 lignes et rendent les parties réutilisables.
22. Elle affiche la trace complète, les variables locales, les requêtes SQL et des éléments de configuration à tout visiteur en cas d'erreur — y compris, potentiellement, des secrets.

**Score** : ____ /22
</details>

---

## Partie C — Livrables

- [ ] **Mini-framework** dans son repo, README expliquant chaque brique, bilan « ce que j'ai dû construire à la main » écrit.
- [ ] [Projet 5 — App Django](projet.md) déployé sur **AWS free tier**, puis **instance détruite** (preuves dans le journal).
- [ ] **Spécification d'API** (OpenAPI exporté de FastAPI ou rédigé pour DRF) dans `docs/`.
- [ ] **Cahier de recette** rempli et passé ([template](../templates/cahier-de-recette.md)).
- [ ] Alerte de facturation AWS configurée **avant** le déploiement — montrée au référent.
- [ ] Page comparative : mini-framework maison vs Express vs Flask vs FastAPI vs Django.
- [ ] Premier script appelant l'**API Claude** (résumeur ou catégoriseur), avec notes sur tokens, coûts et gestion d'erreurs.
- [ ] Les katas passent en Python (≥ 10 refaits depuis le JS) · `journal.md` · [rétrospective](../templates/retrospective-palier.md).
- [ ] 🧑‍🏫 Référent : revue du **mini-framework** (le livrable le plus révélateur) + discussion « Flask vs FastAPI vs Django, ton avis de terrain ».

---

## Résultat

| Partie | Seuil | Résultat |
|--------|-------|----------|
| A — Pratique | 5/5 | ⬜ |
| B — Quiz | 16/22 | ⬜ ___/22 |
| C — Livrables | tout coché | ⬜ |

**Date** : ______ · **Verdict** : ⬜ validé ⬜ à repasser le ______ · [ ] reporté dans [../progression.md](../progression.md)

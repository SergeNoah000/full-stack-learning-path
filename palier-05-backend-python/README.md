# Palier 5 — Backend #2 : Python (natif → Flask → FastAPI → Django)

> 🎯 **Objectif** : ton deuxième langage backend — et la porte d'entrée vers la data et l'IA. Grâce au palier 4 tu n'apprends plus les concepts, seulement leur expression en Python. **Et tu passes SOUS les frameworks avant de les utiliser** : tu construiras un mini-framework toi-même.

## Module 1 : Le langage Python

- [ ] Syntaxe, indentation, listes/dicts/sets/tuples.
- [ ] **List comprehensions** (= tes `map`/`filter` JS), fonctions, `*args/**kwargs`, classes, modules et imports.
- [ ] Environnements virtuels (`venv`) et paquets (`pip` — ou **uv**, plus moderne). Un venv par projet, toujours.
- [ ] **Type hints** partout (tu viens de TypeScript : tu vas aimer) + `mypy` pour vérifier.
- [ ] 🧩 Transfert express : **refais en Python 10 katas déjà résolus en JS** — le moyen le plus rapide de transférer. Les katas de la semaine passent en Python désormais.
- 📚 Exercism (piste Python) ; *Python Crash Course* (livre) ; docs.python.org.

## Module 2 : Le web Python SANS framework (comprendre toute la machinerie)

> C'est le module « natif d'abord » : à la fin, Flask n'aura plus rien de magique.

- [ ] Servir du HTTP avec `http.server` puis comprendre **WSGI** : une simple fonction `app(environ, start_response)` — c'est TOUT ce qu'est une app web Python.
- [ ] 🛠️ **Construire un mini-framework maison** (~150 lignes), en montant marche par marche :
  1. une app WSGI qui lit `PATH_INFO` et la méthode HTTP ;
  2. un **routeur** : table de routes + correspondance d'URL avec paramètres (`/depenses/<id>`) via regex ;
  3. des objets **Request** (query string, corps, formulaires) et **Response** (statut, headers, JSON/HTML) ;
  4. des **vues** : fonctions qui reçoivent une Request et rendent une Response ;
  5. des **modèles** : une petite couche d'accès SQLite (requêtes préparées) ;
  6. des **templates** : `string.Template` puis **Jinja2** seul (hors Flask) ;
  7. servir le tout avec **gunicorn** (un vrai serveur WSGI).
- [ ] 🛠️ Avec ce mini-framework : **réécrire l'API du gestionnaire de dépenses** (projet 1) avec rendu HTML côté serveur — tu découvres au passage le **SSR**, l'approche historique du web (et celle de PHP au palier suivant).
- [ ] Bilan écrit dans le journal : « qu'est-ce que j'ai dû construire à la main ? » → c'est la liste exacte de ce qu'un framework vend.

## Module 3 : Flask — le micro-framework

- [ ] Routes, templates Jinja2, formulaires, sessions, blueprints.
- [ ] À chaque fonctionnalité, fais le lien : « comment mon mini-framework faisait-il ça ? »
- [ ] 🛠️ Mini-projet : porter l'app dépenses du module 2 vers Flask — mesure ce que le framework t'économise.

## Module 4 : FastAPI — l'API moderne

- [ ] Typage + **Pydantic** (le « Zod de Python »), validation automatique.
- [ ] **Documentation OpenAPI auto-générée** (`/docs`) — grosse découverte, note-la pour le fil rouge gestion de projet (spécification d'API).
- [ ] Async en Python (`async def` — tu connais le concept depuis JS).
- [ ] SQLAlchemy ou SQLModel pour PostgreSQL.
- [ ] 🛠️ Mini-projet : API de sondages/votes documentée, consommée par un petit frontend React.

## Module 5 : Django — le framework « batteries incluses »

- [ ] Philosophie opposée à Flask : conventions fortes, tout inclus. Structure projet/apps.
- [ ] **Django ORM** + migrations (compare mentalement à Prisma), **MVT** (Model-View-Template).
- [ ] **L'admin auto-générée** — arme décisive pour les projets clients : un back-office gratuit.
- [ ] Auth incluse, formulaires, `settings.py` et gestion des environnements.
- [ ] **Django REST Framework** : serializers, viewsets, permissions.
- [ ] 🛠️ **Projet 5** : voir [projet.md](projet.md) — app de gestion complète, déployée sur **AWS free tier** (EC2, gunicorn, Nginx — à la main).

## 🏗️ Fil rouge Architecture — la comparaison commence

- Rédige une page : **mini-framework maison vs Express vs Flask vs FastAPI vs Django** — qui décide de quoi (opinionated ou non) ? où vit la logique métier ? quel coût d'entrée, quelle vitesse de livraison ?
- C'est LE savoir qui te distinguera : tu as CONSTRUIT ce que les autres ne font qu'utiliser.

## 📋 Fil rouge Gestion de projet

- Nouveautés sur le projet 5 : **spécification d'API** (contrat OpenAPI — exporté de FastAPI ou rédigé pour DRF) et **cahier de recette** (scénarios : étapes → résultat attendu → ✅/❌).

## 🤖 Fil rouge IA — niveau 5 : accélérateur de langages + première API IA

- Usage type : « voici comment je fais X en JS/Express, montre-moi l'équivalent **idiomatique** en Python/Django » — ton socle conceptuel te protège du copier-coller aveugle.
- Python est LE langage de l'écosystème IA : premier script appelant l'**API Claude** (résumeur ou catégoriseur de texte). Découvre : prompt système, tokens et coûts, streaming, gestion d'erreurs.

## 🧑‍🏫 Référent

- Revue du mini-framework (module 2) : c'est le livrable le plus révélateur de ta compréhension.
- Revue du projet 5 + discussion de terrain : « Flask vs FastAPI vs Django, quand choisir quoi selon toi ? »
- Point AWS : lui montrer l'alerte de facturation configurée AVANT de déployer.

## ✅ Checkpoint de sortie

- [ ] Je passe de JS à Python sans friction (katas dans les deux langages).
- [ ] Mon mini-framework fonctionne : je peux expliquer routeur, Request/Response, vues, modèles, templates — parce que je les ai écrits.
- [ ] Je sais expliquer quand choisir Flask vs FastAPI vs Django (avec des critères, pas des goûts).
- [ ] Projet 5 en ligne sur AWS (et instance nettoyée après validation !), admin Django exploitée, recette passée.

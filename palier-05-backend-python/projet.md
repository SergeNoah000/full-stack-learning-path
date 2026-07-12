# 🛠️ Projet 5 — Application de gestion (Django)

> Objectif spécial : exploiter à fond ce que Django offre gratuitement (admin, auth, ORM) — et déployer « à la dure » sur AWS.

## 📋 Gestion de projet (AVANT de coder)
- [ ] Cahier des charges (modèle habituel) + kanban + estimation (compare avec ta vélocité mesurée au projet 4 : t'améliores-tu ?).
- [ ] **Nouveau — Spécification d'API** : contrat OpenAPI de tes endpoints DRF (inspire-toi du `/docs` auto-généré de FastAPI vu en module 4).
- [ ] **Nouveau — Cahier de recette** : tableau de scénarios utilisateur (étapes → résultat attendu → ✅/❌), déroulé avant la livraison.

## Brief — au choix (une app de GESTION, là où Django brille)
- **Bibliothèque scolaire** (livres, membres, emprunts, retards) ;
- **Gestion d'école** (élèves, classes, notes, bulletins) ;
- **Stock de boutique** (produits, entrées/sorties, alertes de seuil, fournisseurs).

## Fonctionnalités (must)
- [ ] Modèles avec relations riches (1-N et N-N) + migrations propres.
- [ ] **Admin Django exploitée à fond** : list_display, filtres, recherche, actions personnalisées — c'est le back-office gratuit, arme décisive en mission client.
- [ ] Auth Django (utilisateurs + permissions par rôle).
- [ ] **API DRF** : serializers, viewsets, permissions — consommée par un frontend React OU templates Django. **Choisis et justifie ton choix par écrit** (SPA vs SSR : tu connais les deux mondes désormais).
- [ ] Une logique métier non triviale (calcul de retards, moyenne pondérée, valorisation de stock…) testée unitairement.

## Contraintes techniques
- **Django + DRF + PostgreSQL**, venv, type hints, `settings` par environnement.
- Tests avec pytest-django sur la logique métier.

## 🚀 Déploiement : **AWS free tier** (EC2)
- ⚠️ **AVANT TOUT : alerte de facturation (Budget 1 $)** — montre-la au référent.
- EC2 t3.micro → SSH → gunicorn + Nginx → PostgreSQL sur l'instance → fichiers statiques servis correctement (`collectstatic`).
- **Détruire l'instance après validation du checkpoint** (l'infra se nettoie) — garde captures et notes de procédure dans le repo.

## Définition de « fini »
- [ ] Must livrés, recette déroulée et archivée, admin démontrée au référent.
- [ ] A tourné sur AWS (captures + procédure de déploiement documentée), instance nettoyée.

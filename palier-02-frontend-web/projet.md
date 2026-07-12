# 🛠️ Projet 2 — Application météo

> Premier projet avec cadrage AVANT le code, et premier déploiement public.

## 📋 Gestion de projet (nouveau — à faire AVANT de coder)
- [ ] **Mini-cadrage d'1 page** (`docs/cadrage.md` dans le repo) : objectif, utilisateurs cibles, fonctionnalités must / nice-to-have, maquette papier (photo dans le repo).
- [ ] `TODO.md` de suivi, tenu à jour.

## Brief
Une page web responsive : je cherche une ville, je vois sa météo actuelle.

## Fonctionnalités (must)
- [ ] Recherche d'une ville → météo actuelle (température, conditions, icône) via une API (OpenWeatherMap ou Open-Meteo, gratuite sans carte).
- [ ] Gestion des erreurs : ville introuvable, panne réseau — messages clairs à l'utilisateur.
- [ ] Responsive mobile-first (la majorité des utilisateurs locaux sont sur mobile).
- [ ] Villes favorites persistées en `localStorage`.

## Nice-to-have
- [ ] Prévisions sur 5 jours ; géolocalisation ; mode sombre.

## Contraintes techniques
- HTML/CSS/JS purs — aucun framework.
- 🏗️ Fichiers séparés par responsabilité : `api.js`, `ui.js` (DOM), `app.js` (logique).

## 🚀 Déploiement : **GitHub Pages**
- URL publique fonctionnelle, ajoutée au README et à ton profil GitHub.

## Définition de « fini »
- [ ] Must livrés, en ligne, testés sur ton téléphone.
- [ ] Cadrage respecté (ou écarts notés dans le journal : pourquoi ?).
- [ ] Revue rapide par le référent.

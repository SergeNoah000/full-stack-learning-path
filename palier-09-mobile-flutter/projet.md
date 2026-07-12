# 🛠️ Projet 7 — Application mobile (Flutter)

> Une app mobile cliente d'UN de tes backends déployés (projet 4, 5 ou 6 — choisis et justifie), mise entre les mains de vrais utilisateurs.

## 📋 Gestion de projet
- [ ] Cadrage habituel (cahier des charges allégé + kanban + estimation vs réel).
- [ ] **Nouveau — Boucle de retours utilisateurs** : ≥ 3 vrais utilisateurs, collecte des retours (formulaire simple ou groupe WhatsApp), priorisation **impact × effort**, au moins 2 itérations livrées après la v1.

## Brief
L'app mobile du service de ton projet 4/5/6 (annonces, tontine, rendez-vous, stock…) — OU une nouvelle idée si ton backend peut l'appuyer sans gros chantier.

## Fonctionnalités (must)
- [ ] **Auth** contre ton API (connexion, session persistée, déconnexion).
- [ ] Liste + détail + création/édition de la ressource principale.
- [ ] **Hors-ligne basique** : dernières données en cache (drift/SQLite), consultation sans réseau, message clair quand une action nécessite le réseau.
- [ ] Pull-to-refresh ; états chargement / erreur / vide sur CHAQUE écran.
- [ ] Notifications locales (ex. rappel d'échéance).
- [ ] **Une fonctionnalité IA** via TON backend (catégorisation, aide, résumé…) — la clé API reste côté serveur.

## Contraintes techniques
- **Flutter + Riverpod (ou Provider) + dio + drift**.
- 🏗️ Repositories (réseau + cache), logique hors des widgets, modèles Dart typés pour le JSON.
- Thème propre, mode sombre bienvenu.

## 🚀 Distribution : **APK direct** (+ Play Store si budget)
- Build signé, installé sur ≥ 4 téléphones réels (le tien + 3 utilisateurs).
- Documenter la procédure de build/signature dans le README.

## Définition de « fini »
- [ ] V1 + 2 itérations issues des retours utilisateurs, livrées.
- [ ] Survit à une coupure réseau en pleine action (teste en mode avion).
- [ ] Le référent l'a utilisée en utilisateur exigeant, retours traités.

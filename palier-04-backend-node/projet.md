# 🛠️ Projet 4 — Application fullstack complète (Node)

> LE projet charnière : premier cahier des charges complet, première vraie code review, premier hébergement d'un serveur.

## 📋 Gestion de projet (AVANT de coder)
- [ ] **Cahier des charges complet** (`docs/cahier-des-charges.md`) — modèle dans [../gestion-de-projet.md](../gestion-de-projet.md).
- [ ] **Jalons** (chaque jalon = démontrable) + kanban.
- [ ] **Estimation d'effort par tâche** (en heures) → à la fin, tableau estimé vs réel : ta première mesure de vélocité.
- [ ] **Journal des risques** (3–5 lignes).
- [ ] Présenter cadrage + estimation au référent AVANT de coder.

## Brief — au choix (ancré dans ton contexte)
- **Plateforme de petites annonces** (publier, chercher, contacter) ;
- **Gestion de tontine** (membres, cotisations, tours, historique) ;
- **Prise de rendez-vous** (prestataires, créneaux, réservations) ;
- **Suivi de commandes** pour petit commerce (produits, commandes, statuts).

## Fonctionnalités (must)
- [ ] **Auth complète** : inscription, connexion (JWT), rôles (utilisateur / admin).
- [ ] CRUD de la ressource principale avec propriété (je ne modifie que MES annonces/commandes…).
- [ ] Au moins une relation N-N ou 1-N non triviale en base.
- [ ] Recherche/filtres + pagination.
- [ ] Validation systématique des entrées (Zod) + gestion d'erreurs centralisée.

## Contraintes techniques
- Backend : **Express (ou Fastify) + TypeScript + PostgreSQL + Prisma**.
- Frontend : **React + TS** (réutilise les acquis du palier 3).
- 🏗️ Couches : routes → contrôleurs → services → accès données, documentées dans `ARCHITECTURE.md` (avec schéma).
- **Tests** : Vitest + Supertest sur la logique métier et les routes critiques (auth au minimum).
- Secrets en `.env`, jamais commités.

## 🚀 Déploiement : **Render** (free tier)
- Web Service (API) + PostgreSQL managée + frontend (static site Render ou Vercel).
- Observer et noter dans le journal : cold starts, logs, variables d'env par environnement.

## Définition de « fini »
- [ ] Must livrés, tests au vert, en ligne sur Render.
- [ ] **Code review complète par le référent** effectuée et corrections appliquées.
- [ ] Bilan estimé vs réel rédigé (ta vélocité, ton coefficient d'erreur).

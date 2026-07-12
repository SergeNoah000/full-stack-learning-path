# 🛠️ Projets 6a & 6b — PHP natif structuré, puis Laravel

> Deux projets liés : d'abord TON framework MVC en PHP natif (6a), puis une app métier livrable en Laravel (6b) — avec, pour la première fois, une vraie posture client.

---

## Projet 6a — Le MVC construit à la main (PHP natif + Apache)

### Brief
Un **blog multi-auteurs** (ou un livre d'or évolué) : articles, commentaires, comptes utilisateurs, espace admin.

### Exigences structurelles (c'est LE sujet du projet)
- [ ] **Front controller** : `.htaccess` (RewriteRule) → tout passe par `public/index.php` ; le reste du code est HORS du DocumentRoot.
- [ ] **Router maison** : table de routes (méthode HTTP + motif + contrôleur@action), paramètres d'URL (`/article/{id}`).
- [ ] **Contrôleurs** : une classe par ressource.
- [ ] **Modèles** : accès BDD via **PDO + requêtes préparées** uniquement (pattern Repository simple).
- [ ] **Vues** : templates PHP avec layout commun ; **échappement systématique** (`htmlspecialchars`) — anti-XSS.
- [ ] **Auth maison** : inscription (mot de passe haché avec `password_hash`), connexion, sessions, déconnexion.
- [ ] **Protection CSRF** : token en session vérifié sur chaque formulaire.
- [ ] Autoloading **PSR-4** (écrit à la main d'abord, puis via Composer).
- [ ] `.htaccess` bonus : protéger un dossier, page 404 personnalisée.

### Fonctionnalités (must)
- [ ] CRUD articles (auteur connecté), commentaires, listing public avec pagination, espace admin (modération).

### Interdits
- ❌ Tout framework, tout ORM, toute bibliothèque de routing. Composer autorisé uniquement pour l'autoload et éventuellement un package de dev (var-dumper).
- 🤖 L'IA n'écrit ni le router, ni l'auth, ni le CSRF — explications oui, code non.

### Définition de « fini » (6a)
- [ ] Fonctionne sur ta stack LAMP locale, URL propres via `.htaccess`.
- [ ] Bilan écrit : « ce que j'ai construit = ce qu'un framework vend ».
- [ ] **Revue par le référent** — le livrable le plus révélateur du palier.

---

## Projet 6b — Application métier livrable (Laravel) + posture client

### 📋 Gestion de projet (le cœur de l'exercice — AVANT de coder)
- [ ] Recueil du besoin auprès du **référent qui joue le client** (exigences volontairement floues : à toi de poser les questions).
- [ ] Cahier des charges validé par le « client ».
- [ ] **Nouveau — Devis** : découpage en tâches → heures ×1,5 → jours × taux journalier (renseigné avec le référent) + hébergement + domaine + **marge 20%**.
- [ ] **Nouveau — Proposition commerciale** (2 pages) : reformulation du besoin, solution, planning, prix, conditions.
- [ ] En cours de route, le client **changera d'avis** (c'est prévu) : avenant chiffré ou refus argumenté — c'est l'exercice.

### Brief — au choix (une app qu'on pourrait VENDRE localement)
- **Facturation** pour petit commerce (clients, factures PDF, suivi des paiements) ;
- **Gestion de location** (biens, locataires, loyers, quittances, relances) ;
- **Inscriptions à un événement** (billets, paiement à préciser, QR de contrôle, liste d'émargement).

### Fonctionnalités & contraintes
- [ ] **Laravel + MySQL/PostgreSQL** : Eloquent + migrations + seeders, validation par Form Requests, auth **Breeze**, policies pour les autorisations.
- [ ] Blade OU API + React — choix justifié.
- [ ] Une **queue** (ex. envoi d'email de confirmation) et une **tâche planifiée** (ex. relance automatique) : les deux nouveautés Laravel au programme.
- [ ] Qualité « livrable client » : données de démo réalistes, messages en français, pas d'écran cassé.

### 🚀 Déploiement : **hébergement mutualisé (cPanel) ou VPS Apache** — accès fourni par le référent
- SFTP, base MySQL via phpMyAdmin, `.htaccess` actif en conditions réelles, logs Apache.
- Documenter la procédure de mise à jour (le client te rappellera dans 6 mois !).

### Définition de « fini » (6b)
- [ ] Recette déroulée AVEC le « client », qui signe (symboliquement).
- [ ] En ligne sur l'hébergement Apache réel.
- [ ] Bilan devis vs réel : aurais-tu gagné ta vie sur ce projet ?

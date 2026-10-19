# 🛠️ Projet du palier 8 — Les trois backends en production

> Pas d'application nouvelle à écrire : ce palier **met en production ce que tu as déjà construit**. C'est le palier qui te distingue le plus des autres juniors — très peu savent livrer et opérer.

---

## Livrable 1 — Les trois backends dockerisés

### Brief
Dockeriser tes **trois** backends existants : projet 4 (Node), projet 5 (Django/gunicorn), projet 6b (Laravel/php-fpm + Nginx).

### Pour chacun
- [ ] un `Dockerfile` avec **multi-stage build** (image finale légère, sans outils de compilation)
- [ ] un utilisateur **non-root** dans l'image
- [ ] un `.dockerignore` (ne jamais embarquer `node_modules`, `.git`, `.env`)
- [ ] un `docker-compose.yml` : app + base de données + reverse proxy, démarrant en **un seul `docker compose up`**
- [ ] volumes pour la persistance des données, variables d'environnement pour la configuration
- [ ] un `healthcheck`
- [ ] la taille de l'image avant/après multi-stage, notée dans le README

### Le bilan à écrire
Un tableau comparatif : ce que chaque runtime a exigé de spécifique (serveur applicatif, dépendances système, gestion des fichiers statiques, nombre de processus). **C'est ce tableau qui prouve que tu as compris ce que Docker uniformise.**

---

## Livrable 2 — Le pipeline complet de bout en bout

> Le graal du palier. Sur **un** projet au choix.

### Brief
`git push` sur `main` → tests → build de l'image → **déploiement automatique** sur le VPS, en HTTPS avec un nom de domaine.

### Étapes
- [ ] workflow GitHub Actions : lint + tests à chaque push (commence par l'ajouter aux trois projets)
- [ ] build de l'image et push vers un registry (GitHub Container Registry)
- [ ] **secrets** GitHub Actions pour les identifiants (jamais en clair, jamais dans le code)
- [ ] déploiement automatique sur le VPS (SSH + `docker compose pull && up -d`)
- [ ] environnements distincts : `staging` et `production`, avec leurs variables
- [ ] le pipeline **refuse de déployer** si les tests échouent (preuve : fais échouer un test exprès)

---

## Livrable 3 — Le VPS de production

### Sécurisation initiale (dans cet ordre)
- [ ] utilisateur **non-root** avec sudo, connexion par **clés SSH uniquement** (mot de passe désactivé)
- [ ] pare-feu **ufw** : seuls 22 (ou un port SSH personnalisé), 80 et 443 ouverts
- [ ] **fail2ban** actif
- [ ] mises à jour de sécurité automatiques
- [ ] Docker + Compose installés, reverse proxy (Nginx ou Caddy)
- [ ] **HTTPS Let's Encrypt** + un nom de domaine (ou un sous-domaine fourni par le référent), renouvellement automatique vérifié

### Exploitation
- [ ] logs structurés (JSON) et consultables (`docker logs`, `journalctl`)
- [ ] **monitoring d'uptime** (UptimeRobot) avec alerte email
- [ ] **sauvegarde automatisée** de la base (cron) **et test de restauration réussi** — un backup jamais restauré n'existe pas
- [ ] procédure de redéploiement de zéro écrite en 10 lignes dans le README

### L'exercice pompier (avec le référent)
- [ ] Le référent casse quelque chose (ou le simule). Tu diagnostiques **méthodiquement**, couche par couche : DNS ? serveur joignable ? proxy ? conteneur ? application ? base ?
- [ ] Tu écris la **procédure de diagnostic** que tu as suivie — elle devient ton runbook.

---

## Livrable 4 — L'évaluation des coûts (fil rouge gestion de projet)

- [ ] **TCO sur 1 an** d'une même application : VPS vs PaaS (Render/Railway) vs cloud (AWS) vs mutualisé
- [ ] Avec **tes coûts réels** relevés dans les journaux des paliers 2 à 6 (tu as pratiqué les quatre !)
- [ ] Conclusion : dans quel cas chaque option est la bonne
- [ ] Une ligne « fonctionnement mensuel » à intégrer désormais dans **tous** tes devis

---

## Définition de « fini »

- [ ] Les 3 backends démarrent chacun par un `docker compose up`
- [ ] Un projet a son pipeline complet : push → tests → build → déploiement auto, en HTTPS avec domaine
- [ ] Une restauration de sauvegarde **réussie**, documentée
- [ ] L'exercice pompier passé, runbook écrit
- [ ] Tableau de TCO chiffré avec des données réelles
- [ ] Tout est documenté : un inconnu peut reconstruire l'infrastructure avec tes README

> 💡 **Pour l'emploi** : « j'ai dockerisé trois stacks différentes et je gère un pipeline de déploiement continu sur mon propre VPS » est une phrase que très peu de juniors peuvent prononcer. Mets-la en avant au palier 10.

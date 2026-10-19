# Palier 8 — DevOps

> 🎯 **Objectif** : savoir livrer, déployer et opérer ce que tu construis — dans les trois stacks. Compétence rare chez les juniors = gros avantage à l'embauche. **C'est ici que le référent fournit l'accès au VPS.**
> ⏱️ **Volume indicatif** : 5 à 8 semaines (50–80 h). *Le checkpoint est la mesure, pas le calendrier.*
> 📍 **Prérequis** : [épreuve du palier 7](../palier-07-architecture/evaluation.md) réussie · 🧑‍🏫 **accès VPS à demander au référent en avance**.

## 🎓 Ce que tu sauras faire à la fin

1. Administrer un Linux : utilisateurs, permissions, processus, services `systemd`, logs.
2. Durcir un accès SSH et un pare-feu, et expliquer chaque décision.
3. Configurer un reverse proxy et du HTTPS automatique.
4. Écrire un `Dockerfile` multi-stage propre (image légère, utilisateur non-root).
5. Orchestrer app + base + proxy avec Docker Compose, en un seul `up`.
6. **Dockeriser trois runtimes différents** et expliquer ce que Docker uniformise.
7. Construire un pipeline CI/CD complet : push → tests → build → déploiement automatique.
8. Gérer des secrets et des environnements séparés sans jamais rien committer.
9. Mettre en place logs, monitoring et alertes, et savoir ce que tu surveilles.
10. Automatiser des sauvegardes **et réussir une restauration** (preuve à l'appui).
11. Diagnostiquer méthodiquement une panne de production, couche par couche.
12. Chiffrer le **TCO** d'une application sur un an, VPS vs PaaS vs cloud vs mutualisé.

## 📘 Les leçons

👉 **[Plan des 10 leçons du palier](lecons/README.md)** — ⏳ leçons en cours de rédaction ; en attendant, travaille les modules ci-dessous avec les [ressources du palier](../ressources.md) et prépare l'[épreuve de sortie](evaluation.md), qui est complète.

## Module 1 : Linux & réseau approfondis

- [ ] Utilisateurs et permissions (`chmod`, `chown`, sudo), processus (`ps`, `top`, `kill`).
- [ ] `systemd` : services, `systemctl`, logs avec `journalctl`.
- [ ] **SSH en profondeur** : clés (tu en as déjà pour GitHub), `~/.ssh/config`, tunnels de base, désactiver l'auth par mot de passe.
- [ ] Réseau pratique : ports, `curl` (ton couteau suisse), `dig` (DNS), ce qu'est TLS/HTTPS (le rôle d'un certificat).
- [ ] Reverse proxy : **Nginx** (ou Caddy) devant une app — tu l'as déjà fait sur AWS au palier 5, formalise.

## Module 2 : Docker — le grand unificateur

- [ ] Images vs conteneurs, layers, `Dockerfile` (et **multi-stage builds** pour des images légères).
- [ ] Volumes (persistance), réseaux, variables d'environnement.
- [ ] **Docker Compose** : app + BDD + reverse proxy en un `docker compose up`.
- [ ] 🛠️ **L'exercice révélateur du palier : dockeriser tes TROIS backends** — projet 4 (Node), projet 5 (Django/gunicorn), projet 6b (Laravel/php-fpm + Nginx). Trois runtimes radicalement différents, une interface unique : c'est exactement le problème que Docker résout, et peu de juniors l'ont ressenti dans trois écosystèmes.
- 📚 Doc Docker (Get Started) ; *The Odin Project* n'en parle pas assez — compléter avec la doc officielle.

## Module 3 : CI/CD avec GitHub Actions

- [ ] Anatomie d'un workflow : déclencheurs, jobs, steps, runners.
- [ ] Pipeline de base : **lint + tests à chaque push** (commence par l'ajouter aux projets 4/5/6).
- [ ] Build d'image Docker + push vers un registry (GitHub Container Registry).
- [ ] **Secrets** GitHub Actions (jamais en clair, jamais dans le code).
- [ ] Environnements dev / staging / prod : le concept et les variables associées.

## Module 4 : Déploiement production sur VPS

> 🧑‍🏫 **Demander l'accès au VPS au référent** — c'est prévu. À défaut, en louer un (~5 €/mois : Hetzner, Contabo).

- [ ] Sécurisation initiale : utilisateur non-root, SSH par clés uniquement, pare-feu **ufw**, fail2ban.
- [ ] Docker + Compose sur le serveur ; Nginx/Caddy en reverse proxy.
- [ ] **HTTPS avec Let's Encrypt** (certbot ou Caddy automatique) + un nom de domaine (ou sous-domaine fourni par le référent).
- [ ] 🛠️ **Pipeline complet de bout en bout** sur le projet de ton choix : push sur `main` → tests → build image → déploiement automatique sur le VPS. Le graal du palier.
- [ ] Comparaison vécue à rédiger : VPS vs Render vs AWS vs mutualisé (tu as pratiqué les quatre !) — quand choisir quoi.

## Module 5 : Observabilité & fiabilité

- [ ] Logs structurés (JSON), consultation (`docker logs`, `journalctl`).
- [ ] Monitoring d'uptime : **UptimeRobot** (gratuit) + alerte email.
- [ ] Notions métriques/alertes : les 4 signaux (latence, trafic, erreurs, saturation) — conceptuel.
- [ ] **Sauvegardes de BDD automatisées + TEST DE RESTAURATION** (un backup jamais restauré n'existe pas).
- [ ] 🛠️ Exercice pompier avec le référent : il casse quelque chose sur le VPS (ou simule), tu diagnostiques méthodiquement — DNS ? serveur ? conteneur ? app ? BDD ?

## Module 6 : ☁️ Aperçu cloud

- [ ] Cartographie AWS/GCP : compute (EC2 — déjà pratiqué), storage (S3), BDD managées (RDS), serverless (Lambda) — conceptuel, pas de certification à ce stade.
- [ ] Comprendre le modèle de facturation cloud (tu as l'alerte Budget du palier 5 en tête).

## 🛠️ Livrables du palier

Voir [projet.md](projet.md) — ce palier **met en production ce que tu as déjà construit** :
1. **Les 3 backends dockerisés** (Node, Django, Laravel) — l'exercice révélateur du palier.
2. **Le pipeline complet** : push → tests → build → déploiement automatique.
3. **Le VPS de production** : sécurisé, monitoré, sauvegardé — avec une **restauration prouvée**.
4. **L'évaluation des coûts** (TCO sur 1 an) avec tes chiffres réels.

## 📋 Fil rouge Gestion de projet — les coûts d'infrastructure

- **Évaluation TCO sur 1 an** d'une même app : VPS vs PaaS (Render/Railway) vs cloud (AWS) vs mutualisé — tableau chiffré avec tes coûts réels relevés dans les journaux.
- Intègre désormais une ligne « fonctionnement mensuel » dans tous tes futurs devis.

## 🤖 Fil rouge IA — usage DevOps

- Excellente pour : Dockerfiles, débogage de pipelines, configs Nginx.
- ⚠️ Garde-fou absolu : **aucune commande système collée sans être comprise** (`rm`, `chmod`, redirections, iptables) — fais-la expliquer d'abord. Sur un serveur, une commande incomprise peut tout détruire.

## 🧑‍🏫 Référent

- **Fournit l'accès au VPS** et supervise le premier déploiement production.
- Exercice pompier (module 5) et partage de ses histoires d'incidents de prod — c'est là qu'on apprend le plus.

## ✅ Checkpoint de sortie

- [ ] Mes trois backends tournent en conteneurs, localement, via un seul `docker compose up` chacun.
- [ ] Un projet a son pipeline complet : push → tests → build → déploiement auto sur VPS, en HTTPS avec domaine.
- [ ] J'ai restauré une sauvegarde de BDD avec succès (preuve dans le journal).
- [ ] Je déroule le diagnostic « le site est down » méthodiquement, couche par couche.
- [ ] Tableau comparatif des coûts d'hébergement rédigé avec des chiffres réels.

### 🚦 [Passer l'épreuve de sortie →](evaluation.md)

> Les objectifs ci-dessus sont **vérifiés** par l'épreuve, pas auto-déclarés. Tant qu'elle n'est pas réussie, le palier suivant reste fermé.

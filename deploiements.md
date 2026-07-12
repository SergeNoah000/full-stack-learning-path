# 🚀 Fil rouge — Déploiements

> Chaque projet jalon se déploie sur une plateforme DIFFÉRENTE. Objectif : à la fin du parcours, aucune forme d'hébergement ne t'est étrangère — du statique gratuit au VPS de production.

## La matrice

| Projet | Type d'app | Plateforme | Ce que ça t'apprend |
|--------|-----------|------------|---------------------|
| P2 — App météo | Statique (HTML/CSS/JS) | **GitHub Pages** | Déployer = publier des fichiers ; DNS de base ; ton premier lien public |
| P3 — Clone React | SPA buildée | **Vercel** | Build automatique à chaque push, previews de PR, variables d'environnement |
| P4 — Fullstack Node | API + BDD + front | **Render** (free tier) | Héberger un serveur qui tourne 24/7 + une PostgreSQL managée ; cold starts du free tier |
| P5 — App Django | App Python + BDD | **AWS free tier** (EC2) | Le cloud "brut" : instance, groupe de sécurité, gunicorn + Nginx à la main ; ⚠️ configurer les alertes de facturation AVANT tout |
| P6 — MVC PHP natif + Laravel | Apache/PHP | **Hébergement mutualisé (cPanel) ou VPS Apache** — accès fourni par le référent | Le monde réel de PHP : Apache, `.htaccess`, FTP/SFTP, MySQL via phpMyAdmin — l'environnement de 90% des sites PHP existants |
| Palier 8 — exercices DevOps | Les 3 backends dockerisés | **VPS** (accès fourni par le référent) | Docker en prod, reverse proxy, HTTPS Let's Encrypt, CI/CD complet |
| P7 (mobile) — App Flutter | APK/AAB | **Distribution APK directe** (+ Play Store si budget, 25 $ une fois) | Signature d'app, canaux de distribution hors store (très courant localement) |
| P8 — Projet final | Web + mobile + API | **VPS + nom de domaine** | Production complète : Docker Compose, CI/CD, HTTPS, monitoring, sauvegardes |

## Notes par plateforme

### GitHub Pages (P2)
- Gratuit, illimité pour du statique. Activer dans Settings → Pages du repo.
- Limite : aucun code serveur — parfait pour comprendre la différence statique/dynamique.

### Vercel (P3)
- Connexion du repo GitHub → déploiement auto à chaque push. Le workflow moderne du frontend.
- Découvre : les *preview deployments* (une URL par branche) — tu t'en resserviras en entreprise.

### Render (P4)
- Web Service (Node) + PostgreSQL managée, tous deux en free tier.
- Le free tier "s'endort" après inactivité : première visite lente. Comprendre pourquoi = comprendre ce que tu paies chez un hébergeur.
- Alternative équivalente si besoin : Railway, Fly.io.

### AWS free tier (P5)
- ⚠️ **Première action obligatoire : créer une alerte de facturation (Budget à 1 $)**. Le free tier est piégeux ; la carte bancaire est vite débitée pour une instance oubliée.
- Parcours : EC2 (t2/t3.micro) → SSH → installer Python, gunicorn, Nginx → servir Django → BDD PostgreSQL sur la même instance (RDS est hors free tier prolongé).
- **Éteindre/détruire l'instance à la fin de l'exercice.** C'est aussi un apprentissage : l'infra se nettoie.

### Mutualisé / VPS Apache pour PHP (P6)
- Demander l'accès au référent le moment venu (c'est prévu dans son rôle).
- À pratiquer : dépôt via SFTP, base MySQL via phpMyAdmin, `.htaccess` réellement actif (contrairement aux serveurs de dev), logs d'erreurs Apache.
- C'est l'environnement des missions de maintenance PHP — le connaître est un argument d'embauche.

### VPS (palier 8 et projet final)
- Accès fourni par le référent au palier 8 (ou location perso : Hetzner/Contabo ~5 €/mois).
- Checklist de mise en production : utilisateur non-root + SSH par clés → pare-feu (ufw) → Docker → reverse proxy (Nginx/Caddy) → HTTPS (Let's Encrypt) → déploiement via GitHub Actions → sauvegardes BDD **testées** → monitoring uptime (UptimeRobot).

## Règles

1. **Un projet n'est "fini" que déployé** avec une URL (ou un APK) partageable.
2. **Les secrets ne vont JAMAIS dans Git** (`.env` + `.gitignore` dès le palier 4 ; secrets GitHub Actions au palier 8).
3. **Toujours un README de déploiement** dans le repo : comment redéployer de zéro en 10 lignes.
4. **Noter les coûts réels** de chaque plateforme dans le journal — ça alimente le fil rouge coûts ([gestion-de-projet.md](gestion-de-projet.md)).

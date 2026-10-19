# 📘 Leçons — Palier 8 : DevOps

> ✅ **Les 10 leçons de ce palier sont rédigées.** Elles se font **dans l'ordre**, et tu ne coches une leçon que quand **tous** ses critères « Acquis si… » sont vrais.
> 🧑‍🏫 **C'est ici que le référent fournit l'accès au VPS.** Prévois-le avec lui une ou deux semaines à l'avance.
> ⚠️ **Garde-fou absolu de ce palier** : aucune commande système collée sans être comprise. Sur un serveur, une commande incomprise peut tout détruire — et contrairement à Git, il n'y a pas de `reflog`.
> En attendant : les modules du [README du palier](../README.md), les [ressources](../../ressources.md#palier-8--devops), et l'[épreuve de sortie](../evaluation.md) qui est complète.

> 🧱 **Ce que chaque leçon t'apporte** : ce que c'est, à quoi ça sert, **où ça intervient dans le développement**, ce que tu verras en solo et en équipe, ce qui sert tous les jours, les problèmes réels, ce qu'on te demandera en test technique, ce qui te démarquera — puis les lectures, un mini-projet à faire fabriquer par l'IA, les exercices corrigés et les critères « Acquis si… ». Format complet : [../../FORMAT-DES-LECONS.md](../../FORMAT-DES-LECONS.md) · leçons de référence : [outillage](../../palier-00-fondations/lecons/04-github-et-le-distant.md) et [code](../../palier-01-programmer-javascript/lecons/06-map-filter-reduce.md)

| # | Leçon | Volume | Module | Fait |
|---|-------|--------|--------|------|
| 01 | [Linux : utilisateurs, permissions, processus](01-linux-utilisateurs-permissions-processus.md) | 4 h | M1 | [ ] |
| 02 | [`systemd` : services, `systemctl`, `journalctl`](02-systemd-services.md) | 3 h | M1 | [ ] |
| 03 | [SSH en profondeur : clés, `~/.ssh/config`, tunnels, durcissement](03-ssh-en-profondeur.md) | 3 h | M1 | [ ] |
| 04 | [Réseau pratique : ports, `curl`, `dig`, TLS et certificats](04-reseau-pratique.md) | 3 h | M1 | [ ] |
| 05 | [Reverse proxy : Nginx (ou Caddy) devant une app](05-reverse-proxy-nginx.md) | 4 h | M1 | [ ] |
| 06 | [Docker : images, conteneurs, `Dockerfile`, multi-stage](06-docker.md) | 6 h | M2 | [ ] |
| 07 | [Docker Compose : app + base + proxy en une commande](07-docker-compose.md) | 5 h | M2 | [ ] |
| 08 | [CI/CD avec GitHub Actions : workflows, secrets, environnements](08-cicd-github-actions.md) | 6 h | M3 | [ ] |
| 09 | [Déployer et sécuriser un VPS (non-root, ufw, fail2ban, HTTPS)](09-deployer-securiser-vps.md) | 6 h | M4 | [ ] |
| 10 | [Observabilité : logs, monitoring, sauvegardes **testées**, diagnostic](10-observabilite.md) | 5 h | M5 | [ ] |

**L'exercice révélateur du palier** : dockeriser tes **trois** backends (Node, Django/gunicorn, Laravel/php-fpm+Nginx). Trois runtimes radicalement différents, une interface unique — c'est exactement le problème que Docker résout, et peu de juniors l'ont ressenti dans trois écosystèmes.

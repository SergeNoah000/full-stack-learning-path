# 📘 Leçons — Palier 8 : DevOps

> ⏳ **Leçons à rédiger.** Le plan ci-dessous est arrêté, et chacune suivra **le même format que les leçons des paliers 0 et 1** (détaillé juste en dessous).
> 🧑‍🏫 **C'est ici que le référent fournit l'accès au VPS.** Prévois-le avec lui une ou deux semaines à l'avance.
> ⚠️ **Garde-fou absolu de ce palier** : aucune commande système collée sans être comprise. Sur un serveur, une commande incomprise peut tout détruire — et contrairement à Git, il n'y a pas de `reflog`.
> En attendant : les modules du [README du palier](../README.md), les [ressources](../../ressources.md#palier-8--devops), et l'[épreuve de sortie](../evaluation.md) qui est complète.

> 🧱 **Ce que chaque leçon t'apporte** : ce que c'est, à quoi ça sert, **où ça intervient dans le développement**, ce que tu verras en solo et en équipe, ce qui sert tous les jours, les problèmes réels, ce qu'on te demandera en test technique, ce qui te démarquera — puis les lectures, un mini-projet à faire fabriquer par l'IA, les exercices corrigés et les critères « Acquis si… ». Format complet : [../../FORMAT-DES-LECONS.md](../../FORMAT-DES-LECONS.md) · leçons de référence : [outillage](../../palier-00-fondations/lecons/04-github-et-le-distant.md) et [code](../../palier-01-programmer-javascript/lecons/06-map-filter-reduce.md)

| # | Leçon prévue | Volume | Module | Rédigée |
|---|--------------|--------|--------|---------|
| 01 | Linux : utilisateurs, permissions, processus | 4 h | M1 | [ ] |
| 02 | `systemd` : services, `systemctl`, `journalctl` | 3 h | M1 | [ ] |
| 03 | SSH en profondeur : clés, `~/.ssh/config`, tunnels, durcissement | 3 h | M1 | [ ] |
| 04 | Réseau pratique : ports, `curl`, `dig`, TLS et certificats | 3 h | M1 | [ ] |
| 05 | Reverse proxy : Nginx (ou Caddy) devant une app | 4 h | M1 | [ ] |
| 06 | Docker : images, conteneurs, `Dockerfile`, multi-stage | 6 h | M2 | [ ] |
| 07 | Docker Compose : app + base + proxy en une commande | 5 h | M2 | [ ] |
| 08 | CI/CD avec GitHub Actions : workflows, secrets, environnements | 6 h | M3 | [ ] |
| 09 | Déployer et sécuriser un VPS (non-root, ufw, fail2ban, HTTPS) | 6 h | M4 | [ ] |
| 10 | Observabilité : logs, monitoring, sauvegardes **testées**, diagnostic | 5 h | M5 | [ ] |

**L'exercice révélateur du palier** : dockeriser tes **trois** backends (Node, Django/gunicorn, Laravel/php-fpm+Nginx). Trois runtimes radicalement différents, une interface unique — c'est exactement le problème que Docker résout, et peu de juniors l'ont ressenti dans trois écosystèmes.

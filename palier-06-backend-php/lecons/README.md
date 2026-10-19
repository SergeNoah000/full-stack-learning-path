# 📘 Leçons — Palier 6 : Backend PHP

> ⏳ **Leçons à rédiger.** Le plan ci-dessous est arrêté, et chacune suivra **le même format que les leçons des paliers 0 et 1** (détaillé juste en dessous).
> 🧠 **Rappel de méthode** : le natif d'abord. Tu construiras un MVC complet à la main **avant** de toucher Laravel — et tu vivras l'environnement PHP réel (Apache, `.htaccess`, SFTP), celui de la grande majorité des sites existants.
> En attendant : les modules du [README du palier](../README.md), les [ressources](../../ressources.md#palier-6--backend-php), et l'[épreuve de sortie](../evaluation.md) qui est complète.

> 🧱 **Ce que chaque leçon t'apporte** : ce que c'est, à quoi ça sert, **où ça intervient dans le développement**, ce que tu verras en solo et en équipe, ce qui sert tous les jours, les problèmes réels, ce qu'on te demandera en test technique, ce qui te démarquera — puis les lectures, un mini-projet à faire fabriquer par l'IA, les exercices corrigés et les critères « Acquis si… ». Format complet : [../../FORMAT-DES-LECONS.md](../../FORMAT-DES-LECONS.md) · leçons de référence : [outillage](../../palier-00-fondations/lecons/04-github-et-le-distant.md) et [code](../../palier-01-programmer-javascript/lecons/06-map-filter-reduce.md)

| # | Leçon prévue | Volume | Module | Rédigée |
|---|--------------|--------|--------|---------|
| 01 | Apache, VirtualHosts, et le **modèle d'exécution PHP** (un processus par requête) | 4 h | M1 | [ ] |
| 02 | `.htaccess` : réécriture d'URL, protection de dossier, redirections | 4 h | M1 | [ ] |
| 03 | PHP 8 moderne : typage, `match`, enums, classes, namespaces | 5 h | M2 | [ ] |
| 04 | Superglobales, sessions, cookies, upload de fichiers (et ses pièges) | 4 h | M2 | [ ] |
| 05 | PDO et requêtes préparées | 4 h | M2 | [ ] |
| 06 | Composer et l'autoloading PSR-4 | 3 h | M2 | [ ] |
| 07 | Le pattern **front controller** (tout vers `public/index.php`) | 3 h | M3 | [ ] |
| 08 | Un routeur maison (table de routes, `REQUEST_URI`, paramètres) | 5 h | M3 | [ ] |
| 09 | Contrôleurs, modèles (Repository), vues et échappement systématique | 6 h | M3 | [ ] |
| 10 | Auth maison : inscription, connexion, sessions, **jeton CSRF** | 5 h | M3 | [ ] |
| 11 | Laravel : routing, Eloquent, Blade, validation, Breeze, Artisan | 12 h | M4 | [ ] |

**Point d'attention** : la leçon 03 du module 3 commence par une version « à l'ancienne » (un fichier par page, HTML mêlé au SQL) sur un livre d'or — pour **ressentir** le problème que le MVC résout. Des milliers de sites en production sont écrits comme ça : les missions de maintenance, c'est ça.

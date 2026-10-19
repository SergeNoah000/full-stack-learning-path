# 📘 Leçons — Palier 4 : Backend Node.js + SQL

> ✅ **Les 10 leçons de ce palier sont rédigées.** Elles se font **dans l'ordre**, et tu ne coches une leçon que quand **tous** ses critères « Acquis si… » sont vrais.
> ⚠️ **Le palier le plus transférable du parcours** : tout ce qui est appris ici se retrouve tel quel en Python (palier 5) et en PHP (palier 6). Seule la syntaxe changera.
> En attendant : les modules du [README du palier](../README.md), les [ressources](../../ressources.md#palier-4--backend-node), et l'[épreuve de sortie](../evaluation.md) qui est complète.

> 🧱 **Ce que chaque leçon t'apporte** : ce que c'est, à quoi ça sert, **où ça intervient dans le développement**, ce que tu verras en solo et en équipe, ce qui sert tous les jours, les problèmes réels, ce qu'on te demandera en test technique, ce qui te démarquera — puis les lectures, un mini-projet à faire fabriquer par l'IA, les exercices corrigés et les critères « Acquis si… ». Format complet : [../../FORMAT-DES-LECONS.md](../../FORMAT-DES-LECONS.md) · leçons de référence : [outillage](../../palier-00-fondations/lecons/04-github-et-le-distant.md) et [code](../../palier-01-programmer-javascript/lecons/06-map-filter-reduce.md)

| # | Leçon | Volume | Module | Fait |
|---|-------|--------|--------|------|
| 01 | [Le serveur HTTP nu (`node:http`) — avant tout framework](01-le-serveur-http-nu.md) | 4 h | M1 | [ ] |
| 02 | [Express : routes, paramètres, middlewares](02-express-routes-middlewares.md) | 5 h | M2 | [ ] |
| 03 | [Concevoir une API REST (ressources, verbes, codes)](03-concevoir-une-api-rest.md) | 4 h | M2 | [ ] |
| 04 | [Validation (Zod), erreurs centralisées, configuration et secrets](04-validation-erreurs-configuration.md) | 4 h | M2 | [ ] |
| 05 | [SQL : `SELECT`, `WHERE`, agrégats… et les **JOIN**](05-sql-les-bases-et-les-joins.md) | 6 h | M3 | [ ] |
| 06 | [Modélisation relationnelle, relations N-N, index](06-modelisation-relations-index.md) | 5 h | M3 | [ ] |
| 07 | [ORM et migrations (Prisma)](07-orm-et-migrations.md) | 5 h | M3 | [ ] |
| 08 | [Authentification : sessions vs JWT, hachage des mots de passe](08-authentification.md) | 5 h | M4 | [ ] |
| 09 | [Sécurité : OWASP Top 10 en pratique (injection, XSS, CSRF, CORS)](09-securite-owasp.md) | 5 h | M4 | [ ] |
| 10 | [Tests unitaires et d'intégration (Vitest + Supertest)](10-tests.md) | 4 h | M5 | [ ] |

**Points d'attention** :
- Les **JOIN** sont le point dur du palier. Insiste, pratique sur pgexercises.com jusqu'à l'aisance : ce SQL servira tel quel avec Django et Laravel.
- Démontre une **injection SQL sur ton propre code** non protégé avant d'appliquer la parade. On ne comprend une faille qu'en l'exploitant.

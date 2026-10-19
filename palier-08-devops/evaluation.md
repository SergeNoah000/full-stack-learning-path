# ✅ Épreuve de sortie — Palier 8

> **Conditions** : seul, sur ton VPS réel. IA autorisée pour les Dockerfiles et configs (elle y est excellente), **mais aucune commande système exécutée sans être comprise** — c'est la règle non négociable du palier.
> **Durée** : ~5 h, hors temps de mise en place. **Seuil** : 5/5 épreuves · **15/20** au quiz · les 4 livrables du palier.

---

## Partie A — Épreuves pratiques

### A1 — Docker (60 min)
Sur un de tes backends, **de mémoire** :
1. écris un `Dockerfile` **multi-stage** avec utilisateur non-root
2. réduis la taille de l'image et donne le gain mesuré (`docker images`)
3. écris un `docker-compose.yml` : app + base + proxy, avec volume, variables d'environnement et `healthcheck`
4. démontre la persistance : `docker compose down` puis `up` → les données sont toujours là
5. explique la différence entre une image, un conteneur et un volume

✅ **Réussi si** : `docker compose up` suffit, les données survivent, et tu justifies chaque instruction du Dockerfile.

### A2 — Déploiement et sécurisation d'un VPS (90 min)
Sur un serveur neuf (ou en repartant d'un snapshot) :
1. utilisateur non-root + SSH par clés, **mot de passe désactivé** (prouve-le : la connexion par mot de passe doit échouer)
2. `ufw` : 22/80/443 seulement — montre `ufw status`
3. fail2ban actif
4. Docker + Compose, reverse proxy
5. **HTTPS** Let's Encrypt sur un domaine, note A obtenue sur un test SSL en ligne
6. un service `systemd` ou un `restart: unless-stopped` qui relance l'app après un redémarrage du serveur — **teste en redémarrant vraiment**

✅ **Réussi si** : l'app est accessible en HTTPS, et survit à un `reboot` sans intervention.

### A3 — Pipeline CI/CD (60 min)
1. workflow GitHub Actions : lint + tests à chaque push
2. build de l'image + push vers GHCR
3. déploiement automatique sur le VPS via SSH, avec **secrets** GitHub
4. **fais échouer un test exprès** et prouve que le déploiement est bloqué
5. explique la différence entre les environnements staging et production dans ton workflow

✅ **Réussi si** : un `git push` déploie réellement, et un test rouge **empêche** le déploiement.

### A4 — Sauvegarde et restauration (45 min)
1. script de sauvegarde automatisée de la base (cron), avec rotation (garder N jours)
2. **détruis** les données de la base (sur un environnement de test !)
3. **restaure** depuis la sauvegarde et prouve que les données sont revenues
4. chronomètre la restauration et note ton RTO réel

✅ **Réussi si** : la restauration est **réellement effectuée** et prouvée (capture + journal). Pas de « ça devrait marcher ».

### A5 — L'exercice pompier (45 min, avec le référent)
Le référent casse quelque chose sans te dire quoi. Tu diagnostiques à voix haute, couche par couche :
```
DNS → serveur joignable → port ouvert → proxy → conteneur → application → base de données
```
Puis tu répares, et tu écris la procédure suivie.

✅ **Réussi si** : tu suis une démarche **méthodique** (une hypothèse, un test, une conclusion) au lieu de bidouiller au hasard. La panne trouvée compte moins que la méthode.

---

## Partie B — Quiz (20 questions)

**Linux & réseau**
1. `chmod 755` : qui peut faire quoi ? Pourquoi `777` est-il presque toujours une faute ?
2. À quoi sert `systemd` ? Comment consulte-t-on les logs d'un service ?
3. Pourquoi désactiver l'authentification SSH par mot de passe ?
4. Que fait `ufw` ? Quels ports ouvres-tu sur un serveur web, et pourquoi pas plus ?
5. À quoi sert un certificat TLS ? Que vérifie le navigateur exactement ?
6. Pourquoi un reverse proxy devant l'application ? Cite 4 fonctions qu'il assure.

**Docker**
7. Image, conteneur, volume : définis les trois et leurs relations.
8. Qu'apporte un multi-stage build ?
9. Pourquoi ne pas faire tourner un conteneur en root ?
10. Où vont les données d'une base de données en conteneur ? Que se passe-t-il sans volume ?
11. Comment passe-t-on un secret à un conteneur ? Comment **ne faut-il pas** le faire ?
12. Qu'est-ce que Docker résout concrètement dans ton cas, avec trois runtimes différents ?

**CI/CD**
13. Déclencheur, job, step, runner : définis chacun.
14. Pourquoi les tests doivent-ils bloquer le déploiement ?
15. Où vivent les secrets d'un pipeline ? Pourquoi jamais dans le dépôt ?
16. À quoi servent des environnements séparés (staging / production) ?

**Exploitation**
17. Les 4 signaux à surveiller ? Donne un seuil d'alerte raisonnable pour chacun.
18. Pourquoi un backup non restauré n'existe-t-il pas ? Qu'est-ce que le RPO et le RTO ?
19. Déroule le diagnostic « le site est down », couche par couche.
20. VPS vs PaaS vs cloud vs mutualisé : donne pour chacun un cas où il est le bon choix, **avec un ordre de prix**.

<details>
<summary>Corrections — points clés</summary>

1. `755` = propriétaire : lire/écrire/exécuter · groupe et autres : lire/exécuter. `777` donne l'écriture au monde entier : sur un serveur web, n'importe quel processus compromis peut modifier ton code — et certains serveurs refusent d'exécuter des fichiers trop permissifs.
2. Le gestionnaire de services : démarrer, arrêter, relancer au démarrage et après un plantage. Logs : `journalctl -u monservice -f`.
3. Parce qu'un mot de passe se devine par force brute (des milliers de tentatives par jour sur tout serveur public). Une clé Ed25519, non.
4. Il filtre les ports accessibles. 22 (SSH, idéalement restreint par IP), 80 et 443. Tout le reste — base de données incluse — ne doit **jamais** être exposé : la base ne se joint que depuis le réseau interne Docker.
5. À chiffrer la connexion et à **prouver l'identité** du serveur. Le navigateur vérifie que le certificat est signé par une autorité de confiance, qu'il correspond au nom de domaine demandé, et qu'il n'est ni expiré ni révoqué.
6. TLS, service des fichiers statiques, compression, limitation de débit, répartition de charge, buffering des requêtes lentes, en-têtes de sécurité — tout en gardant l'app non exposée directement.
7. Image : modèle figé en lecture seule (code + dépendances + configuration). Conteneur : une instance en exécution de cette image, avec une couche inscriptible éphémère. Volume : un stockage persistant monté dans le conteneur, qui survit à sa destruction.
8. On compile/installe dans une première étape, puis on copie **seulement le résultat** dans une image finale minimale : images beaucoup plus petites, sans outils de compilation ni sources — donc moins de surface d'attaque.
9. Parce qu'une faille applicative devient root dans le conteneur, et qu'une évasion de conteneur devient alors beaucoup plus dangereuse. Principe du moindre privilège.
10. Dans un **volume**. Sans volume, elles vivent dans la couche inscriptible du conteneur : un `docker compose down` ou une mise à jour d'image les **détruit**. C'est l'accident classique.
11. Par variables d'environnement injectées à l'exécution (ou un gestionnaire de secrets). Jamais : en dur dans le `Dockerfile` (il reste dans l'historique des couches de l'image), ni dans un `.env` commité.
12. Node a besoin de son runtime, Django de Python + gunicorn + libs système, Laravel de php-fpm + extensions + Nginx. Docker fournit **une interface unique** (`build`, `up`, `logs`) pour trois écosystèmes incompatibles, et garantit que ce qui tourne chez toi tourne sur le serveur.
13. Déclencheur : l'événement qui lance le workflow (push, PR, cron). Job : un ensemble de steps sur une même machine. Step : une commande ou une action. Runner : la machine qui exécute le job.
14. Parce qu'un déploiement automatique sans garde-fou automatise la mise en production des régressions. Le pipeline n'a de valeur que s'il peut dire **non**.
15. Dans les secrets du dépôt/organisation, injectés comme variables d'environnement. Jamais dans le dépôt : l'historique Git est permanent, et tout contributeur ou fork y accède.
16. Pour tester une version dans des conditions proches de la production **sans** risquer les données et les utilisateurs réels. Et pour valider le processus de déploiement lui-même.
17. **Latence** (p95 au-delà de ta cible, ex. > 1 s), **trafic** (variation anormale à la hausse comme à la baisse), **erreurs** (taux de 5xx > 1 %), **saturation** (CPU > 80 % soutenu, disque > 80 %, mémoire proche de la limite).
18. Parce qu'une sauvegarde peut être vide, corrompue, incomplète ou inexploitable — et on ne le découvre qu'au moment où on en a besoin. **RPO** : quantité de données qu'on accepte de perdre (= fréquence des sauvegardes). **RTO** : temps acceptable pour revenir en service (= durée de la restauration, qu'il faut avoir mesurée).
19. Le domaine résout-il (`dig`) ? Le serveur répond-il (`ping`, SSH) ? Le port est-il ouvert (`curl`, `ss -tlnp`, `ufw status`) ? Le proxy tourne-t-il et que disent ses logs ? Le conteneur est-il up (`docker ps`, `docker logs`) ? L'app répond-elle en local sur le serveur (`curl localhost:3000`) ? La base est-elle joignable, et le disque plein ?
20. **Mutualisé** (~2–5 €/mois) : site PHP/WordPress simple, aucune administration — l'environnement de la majorité des missions PHP. **PaaS** (0–20 €/mois) : prototype, petite équipe sans compétence infra, déploiement en 5 minutes. **VPS** (~5 €/mois) : contrôle total, meilleur rapport puissance/prix, mais tu es l'administrateur système. **Cloud** (variable, piégeux) : besoins élastiques, services managés, conformité — et une facture qui exige des alertes de budget.

**Score** : ____ /20
</details>

---

## Partie C — Livrables

- [ ] [Les 3 backends dockerisés](projet.md#livrable-1--les-trois-backends-dockerisés), chacun démarrant par un `docker compose up`, avec le tableau comparatif des runtimes.
- [ ] [Pipeline complet](projet.md#livrable-2--le-pipeline-complet-de-bout-en-bout) sur un projet : push → tests → build → déploiement auto, HTTPS + domaine.
- [ ] [VPS de production](projet.md#livrable-3--le-vps-de-production) sécurisé, monitoré, sauvegardé — avec **restauration prouvée**.
- [ ] Runbook de diagnostic écrit après l'exercice pompier.
- [ ] [Tableau de TCO](projet.md#livrable-4--lévaluation-des-coûts-fil-rouge-gestion-de-projet) sur 1 an, avec tes coûts réels des paliers 2 à 6.
- [ ] Comparaison vécue rédigée : VPS vs Render vs AWS vs mutualisé — tu as pratiqué les quatre.
- [ ] `journal.md` · [rétrospective](../templates/retrospective-palier.md).
- [ ] 🧑‍🏫 Référent : accès VPS, supervision du premier déploiement, exercice pompier, et ses histoires d'incidents de prod (c'est là qu'on apprend le plus).

---

## Résultat

| Partie | Seuil | Résultat |
|--------|-------|----------|
| A — Pratique | 5/5 | ⬜ |
| B — Quiz | 15/20 | ⬜ ___/20 |
| C — Livrables | tout coché | ⬜ |

**Date** : ______ · **Verdict** : ⬜ validé ⬜ à repasser le ______ · [ ] reporté dans [../progression.md](../progression.md)

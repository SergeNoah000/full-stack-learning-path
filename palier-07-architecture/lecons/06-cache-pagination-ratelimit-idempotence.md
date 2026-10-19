# Leçon 06 — Caching, pagination, rate limiting, idempotence

> 🎯 **À la fin de cette leçon** : tu connais quatre techniques qui protègent une API et sa base quand le trafic monte — et tu sais la question que chacune résout.
> ⏱️ 4 h · **Prérequis** : leçons 01-05, le palier 4 (ton API REST), et les codes HTTP (palier 4, leçon 06).

---

## De quoi on parle

Quatre techniques concrètes de robustesse, qui entrent en jeu dès qu'une application a du trafic réel. Elles ne changent pas ce que fait l'application ; elles la rendent **rapide, stable et sûre** sous charge.

- **Caching** (mise en cache) : garder le résultat d'un calcul ou d'une requête coûteuse pour ne pas le refaire à chaque fois.
- **Pagination** : renvoyer une liste par morceaux (page 1, page 2…) au lieu de tout d'un coup.
- **Rate limiting** (limitation de débit) : plafonner le nombre de requêtes qu'un client peut faire, pour protéger le service des abus et des pics.
- **Idempotence** : garantir que refaire la même opération plusieurs fois produit le même résultat qu'une seule — crucial dès qu'il y a des relances (files, leçon 05 ; réseau instable).

Tu as construit une API REST au palier 4 : des endpoints qui listent, créent, modifient. Elle marchait pour quelques requêtes. Cette leçon la prépare au monde réel, où des milliers de clients l'appellent, où le réseau coupe au milieu d'un paiement, où un script abuse de ton endpoint.

---

## À quoi ça sert, concrètement

**Parce qu'une API qui marche en démo s'écroule en production.** Lister 50 000 lignes d'un coup, recalculer la même statistique à chaque requête, accepter un nombre illimité d'appels : ça passe à dix utilisateurs et tombe à dix mille. Ces quatre techniques sont ce qui sépare un prototype d'un service exploitable.

**Parce que la base de données est la ressource la plus précieuse et la plus fragile.** Le cache lui épargne les requêtes répétées, la pagination lui épargne les gros balayages, le rate limiting lui épargne les déluges. Protéger la base, c'est protéger toute l'application — car c'est presque toujours elle qui sature en premier.

**Parce que l'idempotence est la condition d'un système fiable.** Dès qu'il y a une relance (un message rejoué, un client qui réessaie après un *timeout*, un double-clic sur « Payer »), une opération non idempotente double l'effet : deux débits, deux commandes, deux e-mails. L'idempotence est ce qui rend les relances **sûres** — et les relances sont inévitables.

**Et parce que ce sont des questions d'entretien et de revue très fréquentes.** « Comment pagines-tu ? », « où mettrais-tu un cache ? », « comment rends-tu ce paiement idempotent ? » reviennent constamment. Ce sont des réflexes attendus dès qu'on parle d'API sérieuse.

---

## Où ça intervient dans le développement

Ces techniques s'insèrent entre le client et la base, chacune à son poste :

```
   Client ──▶ [Rate limiting]  ← plafonne les requêtes par client (protège l'entrée)
           ──▶ [Cache]         ← répond sans toucher la base si la réponse est connue
           ──▶ API
                 ├─ [Pagination] ← ne lit qu'une tranche de la liste
                 └─ [Idempotence] ← une clé empêche de rejouer une écriture
           ──▶ Base de données  (protégée par les trois premiers)
```

Trois ancrages dans ton palier 4.

**La pagination complète tes endpoints de liste.** Ton `GET /depenses` du palier 4 renvoyait tout. En production, il doit renvoyer une page. C'est une évolution directe de l'API REST que tu connais, avec les mêmes conventions (paramètres de requête, métadonnées de réponse).

**L'idempotence s'appuie sur la sémantique HTTP (palier 4, leçon 06).** Tu as appris que `GET`, `PUT`, `DELETE` sont idempotents par nature et que `POST` ne l'est pas. Cette leçon rend ce savoir opérationnel : comment rendre un `POST` sensible (un paiement) idempotent avec une clé.

**Le rate limiting utilise les codes HTTP (palier 4, leçon 06).** Un client qui dépasse sa limite reçoit un `429 Too Many Requests` — un code que tu connais, dans son usage réel.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas paginer un endpoint de liste de ton API palier 4, ajouter un cache sur une donnée coûteuse à recalculer, décrire une limitation de débit, et rendre une opération d'écriture idempotente avec une clé. Chaque fois, tu énonceras la question que la technique résout.

### En équipe, en entreprise

**La pagination est obligatoire sur toute liste.** Aucune API sérieuse ne renvoie une collection sans la paginer. C'est un réflexe si ancré qu'une liste non paginée est un défaut relevé immédiatement en revue.

**Le cache est partout — et l'invalidation est le vrai problème.** « Il n'y a que deux choses difficiles en informatique : l'invalidation de cache et nommer les choses. » Mettre en cache est facile ; savoir **quand vider** le cache (quand la donnée change) est l'art délicat. Un cache mal invalidé sert des données périmées — un bug sournois.

**Le rate limiting protège aussi des coûts.** Au-delà des abus, il évite qu'un client (ou un bug) ne fasse exploser ta facture d'infrastructure ou ne sature un service tiers payant. C'est une protection économique autant que technique.

**L'idempotence est exigée sur les paiements et les intégrations.** Les API de paiement (Stripe, etc.) imposent une *clé d'idempotence* précisément pour que réessayer un paiement après un timeout ne débite pas deux fois. Tu la fourniras ; comprendre pourquoi est essentiel.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : la pagination (sur chaque liste) et la pensée de l'idempotence (chaque écriture sensible).

Régulièrement : le cache sur les lectures coûteuses et répétées, avec sa stratégie d'invalidation ; le rate limiting sur les endpoints publics ou coûteux.

Plus pointu, par besoin : les caches distribués (Redis) et leurs stratégies fines (TTL, LRU, cache-aside vs write-through), la pagination par curseur pour les très gros volumes, le rate limiting distribué (fenêtre glissante, *token bucket*). On pose les bases ici ; le détail viendra avec l'échelle.

---

## La mécanique

### Pagination : renvoyer la liste par tranches

```
GET /depenses?page=2&taille=20

Réponse :
{
  "donnees": [ ...20 dépenses... ],
  "page": 2, "taille": 20, "total": 143, "pages": 8
}
```

En SQL, c'est `LIMIT` et `OFFSET` (palier 4, leçon 05) : `LIMIT 20 OFFSET 20` pour la page 2. On renvoie les données **et** les métadonnées (total, nombre de pages) pour que le client puisse afficher « page 2 sur 8 ». 

> ⚠️ Pour de très gros volumes, `OFFSET` devient lent (la base parcourt puis jette les lignes sautées). La **pagination par curseur** (« donne-moi ce qui vient après l'id 1040 ») la remplace alors. À connaître de nom ; `LIMIT/OFFSET` suffit pour commencer.

### ⭐ Caching : ne pas refaire ce qui est déjà fait

```
Lecture coûteuse (une statistique qui agrège 100 000 lignes) :
  1. la réponse est-elle en cache (sous une clé, ex. "stats:2026-10") ?
     → OUI : la renvoyer SANS toucher la base (rapide)
     → NON : calculer, STOCKER en cache (avec une durée de vie, TTL), renvoyer
  Invalidation : quand une dépense change, SUPPRIMER "stats:..." du cache,
                 sinon on sert une statistique périmée.
```

Le schéma « cache-aside » : on regarde le cache d'abord, on calcule seulement en cas d'absence, on stocke pour la prochaine fois. Deux leviers de fraîcheur : une **durée de vie** (TTL — la donnée expire seule) et une **invalidation explicite** (on supprime la clé quand la source change). Le piège n'est jamais de remplir le cache, mais de le **vider au bon moment**.

```
Niveaux de cache (du plus proche au plus loin) :
  - en mémoire du processus (rapide, non partagé entre serveurs)
  - cache distribué (Redis) partagé entre tous les serveurs
  - cache HTTP (en-têtes Cache-Control, ETag) côté navigateur/CDN
```

### Rate limiting : plafonner les requêtes

```
Règle : 100 requêtes par minute et par client (identifié par clé d'API ou IP).
  Sous la limite → la requête passe.
  Au-dessus     → 429 Too Many Requests, souvent avec un en-tête Retry-After.
```

On compte les requêtes par client sur une fenêtre de temps. Dépassé le seuil, on refuse avec un `429` (palier 4, leçon 06) et on indique quand réessayer (`Retry-After`). Cela protège des abus (scraping, attaques par déni de service applicatif), des bugs de clients qui bouclent, et des coûts. Les frameworks le fournissent (middleware *throttle* de Laravel, par exemple).

### ⭐ Idempotence : rendre les relances sûres

```
Rappel (palier 4, leçon 06) :
  GET, PUT, DELETE sont idempotents par nature (refaire = même état).
  POST ne l'est pas : deux POST /paiements = deux paiements.

Rendre un POST idempotent — la clé d'idempotence :
  1. Le client génère une clé unique pour CETTE tentative (ex. un UUID) et l'envoie
     dans un en-tête : Idempotency-Key: 7f3a...
  2. Le serveur, avant d'agir, regarde s'il a DÉJÀ traité cette clé.
     → OUI : il renvoie le MÊME résultat qu'au premier appel, sans refaire l'action.
     → NON : il agit, ET mémorise (clé → résultat).
  Résultat : le client peut réessayer après un timeout sans craindre le double débit.
```

C'est la technique qui sécurise les relances inévitables : réseau qui coupe après l'action mais avant la réponse, message rejoué par une file (leçon 05), utilisateur qui double-clique. Sans clé d'idempotence, le client ne **peut pas** réessayer sans risque ; avec, réessayer est sûr. C'est pourquoi les API de paiement l'imposent.

### Le lien entre les quatre

```
Pagination + cache + rate limiting protègent surtout les LECTURES et la BASE.
Idempotence protège surtout les ÉCRITURES et l'ARGENT.
Ensemble : une API qui tient la charge ET ne fait pas de bêtise quand ça rate.
```

---

## Les problèmes que tu vas rencontrer

**« Mon endpoint de liste met 10 secondes. »** Tu renvoies tout. Pagine. Et si `OFFSET` est lent sur de gros volumes, passe au curseur.

**« Mon cache sert des données périmées. »** Invalidation manquante : tu ne vides pas la clé quand la source change. Ajoute l'invalidation explicite, et/ou un TTL court. C'est le vrai problème du cache.

**« J'ai mis un cache et ça n'a rien accéléré. »** Soit la donnée n'était pas assez coûteuse/répétée pour mériter un cache (pas de problème à résoudre → pas de cache, KISS), soit la clé change à chaque requête (jamais de « hit »).

**« Un client fait planter mon service avec trop de requêtes. »** Pas de rate limiting. Plafonne par client, réponds `429`.

**« Le paiement a été débité deux fois. »** Opération non idempotente rejouée. Ajoute une clé d'idempotence : le second appel renvoie le résultat du premier sans re-débiter.

**« J'ai paginé mais le total est faux après une insertion. »** Normal : entre deux pages, les données peuvent changer. Pour une cohérence stricte, la pagination par curseur est plus stable que `OFFSET`.

---

## Ce qu'on te demandera

En **entretien**, ces quatre sujets sont des classiques d'API : « comment pagines-tu une grande liste ? », « où et comment mettrais-tu un cache, et comment l'invalides-tu ? », « à quoi sert le rate limiting et quel code HTTP renvoies-tu ? », « qu'est-ce que l'idempotence et comment rends-tu un `POST` idempotent ? ». Relier à la sémantique HTTP du palier 4 (idempotence native de `PUT`/`DELETE`, `429`) renforce chaque réponse.

On peut demander : « pourquoi l'invalidation de cache est-elle difficile ? », « `OFFSET` ou curseur ? », « pourquoi une API de paiement exige-t-elle une clé d'idempotence ? ».

En **mission**, on attend que tu pagines par réflexe, que tu identifies les lectures à mettre en cache, et que tu penses à l'idempotence sur les écritures sensibles.

---

## Ce qui te démarquera

**Penser l'invalidation, pas seulement le cache.** Dire « le facile, c'est remplir le cache ; le difficile, c'est savoir quand le vider » montre que tu connais le vrai piège, pas la version naïve.

**L'idempotence comme réflexe sur les écritures sensibles.** Proposer spontanément une clé d'idempotence sur un paiement, en expliquant le scénario du timeout et de la relance, est exactement ce qu'on attend d'un développeur d'API mûr — et ça fait le pont avec les files (leçon 05).

**Relier à la sémantique HTTP.** Savoir que `PUT` et `DELETE` sont idempotents par nature et que le travail porte sur `POST`, et citer le `429`, montre que ton palier 4 (REST) est solide et opérationnel.

**Et appliquer KISS ici aussi.** Ne pas mettre un cache là où il n'y a pas de problème de performance, ne pas sur-compliquer la pagination d'une liste courte : savoir que chaque technique répond à une question réelle (leçons 02 et 04) évite la sur-ingénierie.

---

## 📚 À lire

**MDN → *HTTP caching*** et les en-têtes `Cache-Control`, `ETag` : le cache au niveau HTTP, standard et sous-utilisé.

**La documentation d'une API publique (Stripe, GitHub) → *Pagination*, *Rate limits*, *Idempotent requests*** : des exemples réels et excellents. La page *Idempotency* de Stripe est une référence pour comprendre la clé d'idempotence.

**Documentation de ton framework → *rate limiting* / *throttle* et *cache*** (Laravel du palier 6, ou Express/FastAPI) : pour voir les outils tout faits.

Relis le palier 4, leçon 06 (REST, codes HTTP, idempotence des méthodes) : cette leçon le rend opérationnel.

---

## 🤖 Le mini-projet à demander à l'IA

Durcir ton API du palier 4 :

> « Je suis en formation de développeur, palier 7 (architecture). Je reprends mon API REST du palier 4 pour la préparer au trafic réel. Sans coder à ma place, guide-moi par questions sur quatre techniques, en me faisant d'abord énoncer la QUESTION que chacune résout : (1) paginer un endpoint de liste (LIMIT/OFFSET, métadonnées, et quand passer au curseur) ; (2) mettre en cache une lecture coûteuse, en insistant sur l'INVALIDATION (quand vider la clé) ; (3) limiter le débit par client (et quel code HTTP renvoyer) ; (4) rendre une écriture sensible idempotente avec une clé. »

Puis l'idempotence en profondeur :

> « Prends mon endpoint POST le plus sensible (un paiement, une commande). Aide-moi à le rendre idempotent avec une clé d'idempotence : fais-moi décrire le scénario du timeout (le client agit, le réseau coupe avant la réponse, le client réessaie) et comment la clé empêche le double effet. Relie ça à l'idempotence native de PUT/DELETE que j'ai vue au palier 4, et au rejeu de message dans une file (leçon 05). »

---

## 🛠️ À faire

1. **⭐ Paginer** : prends un endpoint de liste de ton API palier 4 et pagine-le avec `LIMIT/OFFSET` et des paramètres `page`/`taille`. Renvoie les métadonnées (`total`, `pages`). Teste avec plusieurs pages.
2. **Le curseur (culture)** : note pourquoi `OFFSET` devient lent sur de gros volumes et en quoi la pagination par curseur le résout. Tu n'as pas à l'implémenter.
3. **⭐ Cache + invalidation** : identifie une lecture coûteuse et répétée (une statistique agrégée). Mets-la en cache (clé + TTL), puis **invalide** la clé quand la donnée source change. Vérifie qu'après un changement, tu ne sers plus la valeur périmée.
4. **Le piège du cache** : fais exprès d'oublier l'invalidation, observe une donnée périmée servie, puis corrige. Ressens pourquoi l'invalidation est le vrai problème.
5. **Rate limiting** : décris (ou implémente via le middleware de ton framework) une limite « N requêtes par minute et par client », renvoyant un `429` au dépassement, avec `Retry-After`.
6. **⭐ Idempotence** : prends ton `POST` le plus sensible. Ajoute une clé d'idempotence : mémorise (clé → résultat), et au second appel avec la même clé, renvoie le premier résultat sans refaire l'action. Simule un double appel et vérifie qu'il n'y a qu'un seul effet.
7. **La sémantique HTTP** : vérifie, sur ton API, que `PUT` et `DELETE` sont bien idempotents par nature (les rejouer laisse le même état) et explique pourquoi `POST` nécessitait une clé.
8. **Le lien** : dans ton journal, classe les quatre techniques — lesquelles protègent les lectures/la base, laquelle protège les écritures/l'argent — et relie l'idempotence au rejeu de message de la leçon 05.

<details>
<summary>Corrections et points de contrôle</summary>

**1-2.** La pagination est non négociable sur une liste : `LIMIT 20 OFFSET 20` pour la page 2, plus les métadonnées (`total`, `pages`) pour que le client s'oriente. Le piège d'échelle : `OFFSET` oblige la base à parcourir puis jeter les lignes sautées, ce qui devient lent à grand volume ; la pagination par curseur (« après l'id X ») l'évite. Commence avec `OFFSET`, connais le curseur de nom.

**3-4.** Le cœur du cache n'est pas de le remplir mais de l'**invalider**. Le schéma cache-aside : lire le cache, calculer seulement si absent, stocker avec un TTL. La fraîcheur tient à deux leviers : l'expiration automatique (TTL) et la suppression explicite de la clé quand la source change. Oublier l'invalidation = servir du périmé, un bug sournois car « ça marche » un moment. L'exercice 4 te le fait vivre, ce qui l'ancre durablement.

**6-7.** L'idempotence est la technique qui rend les relances **sûres**. `GET`/`PUT`/`DELETE` le sont par nature (palier 4) ; le travail porte sur `POST`. La clé d'idempotence : le client envoie une clé unique par tentative, le serveur mémorise (clé → résultat) et, au rejeu, renvoie le résultat mémorisé sans refaire l'action. Sans elle, un client ne peut pas réessayer après un timeout sans risquer un double débit — d'où son obligation sur les paiements. C'est aussi ce qui sécurise un message rejoué par une file (leçon 05) : même problème, même parade.

**8.** La carte mentale : pagination, cache et rate limiting protègent surtout les lectures et la base (la ressource qui sature en premier) ; l'idempotence protège surtout les écritures et l'argent (ce qui fait mal quand ça double). Ensemble, elles font passer ton API de « marche en démo » à « tient la charge et ne fait pas de bêtise quand ça rate » — le saut du prototype au service exploitable.
</details>

---

## ✅ Acquis si…

- [ ] Je pagine toute liste (`LIMIT/OFFSET` + métadonnées) et je sais quand passer au curseur.
- [ ] Je mets en cache une lecture coûteuse et répétée, avec un TTL.
- [ ] Je sais que l'invalidation (vider la clé au bon moment) est le vrai problème du cache.
- [ ] Je limite le débit par client et je renvoie un `429` au dépassement.
- [ ] Je rends une écriture sensible idempotente avec une clé d'idempotence.
- [ ] Je relie l'idempotence à la sémantique HTTP (`PUT`/`DELETE` natifs, `POST` à sécuriser).
- [ ] Je fais le lien entre idempotence et rejeu de message dans une file (leçon 05).
- [ ] J'applique chaque technique seulement quand elle résout un problème réel (KISS).

# Leçon 07 — HTTP, la langue du web

> 🎯 **À la fin de cette leçon** : tu lis une requête et une réponse HTTP, tu sais immédiatement de quel côté chercher quand une erreur apparaît, et tu interroges une API en ligne de commande.
> ⏱️ 2 h · **Prérequis** : leçon 06.
>
> **C'est la leçon la plus rentable du palier.** HTTP ne change pas d'un langage à l'autre : ce que tu apprends ici te servira identiquement en Node (palier 4), en Python (palier 5), en PHP (palier 6) et en Flutter (palier 9). Tu l'apprends une fois, pour toute ta carrière.

---

## HTTP, c'est quoi

HTTP est la **convention** qui définit la forme d'une demande et d'une réponse sur le web. Ce n'est pas un programme : c'est un accord sur la façon d'écrire les messages, pour que n'importe quel client puisse parler à n'importe quel serveur.

Deux caractéristiques expliquent tout le reste.

**HTTP est textuel.** Une requête HTTP est du texte que tu pourrais taper à la main. Il n'y a aucune magie, rien de binaire ni de chiffré — c'est pour ça que le débogage web est possible, et c'est pour ça qu'au palier 5 tu pourras écrire un serveur HTTP à partir de rien, en comprenant chaque ligne.

**HTTP est sans état** (*stateless*). Chaque requête est indépendante : le serveur ne se souvient de rien entre deux requêtes. Il ne sait pas que c'est encore toi. Cette propriété est contre-intuitive quand on vient du monde des applications de bureau, et c'est pourtant le fondement de la scalabilité du web — on y revient plus bas, parce que c'est le point le plus important de la leçon.

Une requête a toujours la même structure : une ligne de départ (méthode, chemin, version), des **en-têtes** (des métadonnées `Clé: valeur`), une ligne vide, puis éventuellement un **corps** (les données transportées). Une réponse a la même forme, avec un **code de statut** à la place de la méthode.

Et **HTTPS** n'est pas un autre protocole : c'est le même HTTP, transporté dans un tunnel chiffré par TLS (leçon 06). Même structure, même vocabulaire, confidentialité en plus.

---

## À quoi ça sert, concrètement

**C'est le seul moyen par lequel tes composants communiquent.** Ton frontend parle à ton backend en HTTP. Ton application mobile parle au même backend en HTTP. Ton backend appelle une API de paiement, un service d'envoi d'emails ou une API d'IA en HTTP. Au palier 10, ton produit complet sera un assemblage de briques qui dialoguent toutes dans cette langue.

**C'est ce qui te dit où est l'erreur.** Un code de statut n'est pas une décoration : c'est un diagnostic. Un `4xx` signifie « ta demande est fautive », un `5xx` signifie « mon code a planté ». Cette seule distinction t'indique où regarder, et elle t'épargnera des heures.

**C'est la matière des contrats entre équipes.** Dans une entreprise, l'équipe frontend et l'équipe backend s'accordent sur une API : quelles URL, quels verbes, quels codes, quelle forme de données. Ce contrat est du HTTP. Tu l'écriras au palier 4 et tu le formaliseras au palier 5.

---

## Où ça intervient dans le développement

HTTP est la **frontière** de ton application — le point où elle touche le monde extérieur.

```
   CLIENT                          │  HTTP  │                       SERVEUR
   ──────                          │        │                       ───────
   navigateur, app mobile          │        │   routes → contrôleurs → base
          │                        │        │              ▲
   fetch / dio  ──── requête ─────▶│        │──────────────┘
          ◀─────────── réponse ────│        │
                                   │        │
                              la seule chose
                              qui franchit la frontière
```

Deux conséquences qui vont structurer ta façon de concevoir.

D'abord, **tout ce qui traverse cette frontière est public et modifiable**. Le client choisit ce qu'il envoie ; il peut envoyer n'importe quoi. C'est la raison pour laquelle la validation, les règles métier et les contrôles d'autorisation vivent **derrière** la frontière, côté serveur. Tu construiras tout ça au palier 4.

Ensuite, **chaque franchissement coûte du temps**. Un aller-retour réseau prend des dizaines ou des centaines de millisecondes, bien plus que n'importe quel calcul. D'où deux réflexes que tu développeras : ne pas multiplier les appels inutiles, et faire en parallèle ceux qui sont indépendants (leçon 09 du palier 1).

Enfin, situe le « sans état » dans le temps : c'est *parce que* HTTP ne se souvient de rien qu'il faut des cookies et des jetons (palier 4), et c'est *parce que* chaque requête est indépendante qu'on peut mettre dix serveurs derrière un répartiteur de charge sans se demander lequel traitera laquelle (palier 7). Une seule propriété, deux conséquences majeures à deux paliers différents.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas surtout **observer**. L'onglet Réseau des DevTools te montre chaque requête que fait une page : son URL, sa méthode, son code de retour, sa durée, son contenu. Et `curl` te permet d'en forger toi-même, sans navigateur.

Aux paliers 1 et 2 tu consommeras des API publiques : tu enverras un `GET`, tu recevras du JSON, tu l'afficheras. Tu rencontreras à cette occasion ton premier `404` et ta première erreur CORS.

### En équipe, en entreprise

HTTP devient un **sujet de discussion quotidien**, et tu entendras ces phrases :

« Ça renvoie un 500 » — c'est le serveur, va voir les logs. « Ça renvoie un 401, le token doit être expiré » — l'authentification. « Pourquoi c'est un POST et pas un PUT ? » — une discussion de conception d'API, qui a l'air pointilleuse et qui a de vraies conséquences. « Il faut mettre un cache sur cet endpoint » — performance.

Tu utiliseras un **client d'API** (Bruno ou Postman) pour tester les endpoints sans interface, et les collections sont souvent versionnées dans le dépôt. Tu liras aussi des **documentations d'API** : au palier 5, FastAPI en générera une automatiquement, et tu comprendras pourquoi c'est précieux.

### Ce qui sert tous les jours, et ce qui est rare

Les méthodes : **`GET` et `POST` représentent l'essentiel** de ce que tu verras, avec `PUT`/`PATCH` et `DELETE` dès que tu feras des API REST.

Les codes à connaître par cœur : `200`, `201`, `204`, `301`, `302`, `400`, `401`, `403`, `404`, `422`, `500`, `502`, `503`. Une douzaine, et tu les rencontreras tous.

Les en-têtes qui comptent vraiment : `Content-Type` (le format du corps), `Authorization` (le jeton), `Cookie`/`Set-Cookie` (les sessions), `Cache-Control` (le cache), `Location` (les redirections), `Access-Control-Allow-Origin` (CORS). Il en existe des centaines ; ces six-là couvrent tes besoins pour longtemps.

Rare, et hors sujet aujourd'hui : les subtilités de HTTP/2 et HTTP/3, les requêtes conditionnelles et les ETags, le *content negotiation* avancé, les méthodes `OPTIONS`, `HEAD` et `TRACE` (sauf à déboguer CORS, où `OPTIONS` apparaît). Tu n'as pas besoin de la spécification : tu as besoin du vocabulaire courant.

---

## La mécanique

### Une requête, en vrai

```http
GET /weather?city=Douala HTTP/1.1
Host: api.exemple.com
User-Agent: curl/8.5.0
Accept: application/json
Authorization: Bearer eyJhbGciOi...

```

Ligne de départ, en-têtes, ligne vide. Pas de corps, puisque c'est un `GET`.

### Une réponse, en vrai

```http
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 87
Cache-Control: max-age=600

{"city":"Douala","temp":29,"humidity":78}
```

### Les méthodes : l'intention

`GET` **lit**. Il ne doit jamais modifier quoi que ce soit, et il n'a pas de corps.

`POST` **crée** ou déclenche une action. Il a un corps, et il n'est **pas idempotent** : l'envoyer deux fois crée deux choses.

`PUT` **remplace** entièrement une ressource. `PATCH` la **modifie partiellement**. `DELETE` **supprime**.

Le mot **idempotent** mérite une explication, parce qu'il revient en entretien et qu'il a des conséquences réelles. Une opération est idempotente si la rejouer donne le même état final. `GET`, `PUT` et `DELETE` le sont ; `POST` ne l'est pas. C'est pour cette raison qu'un navigateur peut relancer un `GET` sans scrupule, mais qu'il te demande « voulez-vous renvoyer le formulaire ? » pour un `POST`. Et c'est pour cette raison qu'un système de paiement doit être conçu avec soin : un double clic, un réseau coupé ou une nouvelle tentative automatique ne doivent pas débiter deux fois (palier 7).

Une faute à ne jamais commettre : `GET /delete-user?id=5`. Un `GET` doit être **sûr**, c'est-à-dire sans effet. Les navigateurs, les antivirus et les robots d'indexation préchargent les liens `GET` — un robot pourrait vider ta base de données simplement en suivant tes liens. Ce n'est pas théorique, c'est arrivé à beaucoup de monde.

### Les codes de statut, par familles

Il y a cinq familles, et c'est la famille qui porte l'information de diagnostic.

Les **`2xx`** disent que tout s'est bien passé. `200 OK` est le cas général. `201 Created` répond à une création réussie. `204 No Content` répond à une suppression réussie, sans corps.

Les **`3xx`** sont des redirections. `301` est permanente (et le référencement en dépend), `302` et `307` sont temporaires, `304 Not Modified` signifie « ta version en cache est encore bonne ».

Les **`4xx`** signalent une erreur **du client** — donc de ta requête. `400 Bad Request` pour des données malformées, `422` pour une validation métier échouée, `404 Not Found`, `409 Conflict`, `429 Too Many Requests` quand tu as dépassé une limite de débit. Et les deux qu'il faut absolument distinguer : **`401 Unauthorized` signifie « je ne sais pas qui tu es »**, tandis que **`403 Forbidden` signifie « je sais qui tu es, et tu n'as pas le droit »**. C'est une question d'entretien classique, et c'est une distinction que tu devras implémenter au palier 4.

Les **`5xx`** signalent une erreur **du serveur** — donc de ton code. `500` est un plantage interne, `502 Bad Gateway` signifie que le proxy n'arrive pas à joindre ton application (tu verras ça au palier 8), `503` que le service est indisponible, `504` qu'il a mis trop de temps.

**Le réflexe à installer dès maintenant** : un `4xx` → regarde **ta requête** (l'URL, la méthode, le corps, les en-têtes). Un `5xx` → regarde **les logs du serveur**, parce que le navigateur ne t'apprendra rien de plus. Ce seul réflexe divise par deux le temps de débogage web.

### Pratiquer avec `curl`

```bash
curl https://api.github.com/users/torvalds            # un GET simple
curl -i https://api.github.com/users/torvalds         # avec les en-têtes de réponse
curl -I https://github.com                            # les en-têtes seulement
curl -v https://api.github.com                        # tout le dialogue, requête ET réponse
curl -L http://github.com                             # suivre les redirections

curl -X POST https://httpbin.org/post \
     -H "Content-Type: application/json" \
     -d '{"nom":"Serge","palier":0}'                  # un POST avec du JSON

curl -s https://api.github.com/users/torvalds | python3 -m json.tool   # JSON lisible
```

`httpbin.org` est fait pour s'entraîner : il te renvoie exactement ce que tu lui as envoyé, ce qui permet de vérifier qu'on a bien compris ce qu'on envoyait.

---

## Les problèmes que tu vas rencontrer

**Un `404` sur une route qui existe.** Vérifie dans l'ordre : la méthode HTTP (tu fais un `GET` sur une route déclarée en `POST` ?), le préfixe (`/api` oublié ?), une faute dans le chemin, un slash final de trop. Le `404` ne vient presque jamais du serveur « cassé ».

**Un `401` alors que tu es connecté.** Le jeton est expiré, mal formé, ou n'est pas envoyé du tout. Regarde l'en-tête `Authorization` dans l'onglet Réseau : il y est, ou il n'y est pas. Souvent, il manque le préfixe `Bearer `.

**Un `500` et rien d'autre.** C'est normal : un serveur bien configuré ne révèle pas ses détails internes au client, pour des raisons de sécurité. La réponse est **dans les logs du serveur**. Chercher dans le navigateur est une perte de temps.

**Une erreur CORS.** Le message est long et parle de `Access-Control-Allow-Origin`. Ce n'est pas un problème de ton code client : c'est le navigateur qui refuse un appel vers une autre origine parce que le serveur ne l'a pas autorisé. La correction est **côté serveur**, toujours. Et une précision qui évite beaucoup de confusion : `curl` n'applique pas CORS, donc une requête qui marche en `curl` et échoue dans le navigateur est très probablement un problème de CORS.

**Ton `POST` arrive vide côté serveur.** Trois causes habituelles : tu as oublié l'en-tête `Content-Type: application/json`, tu as envoyé un objet au lieu d'une chaîne JSON, ou le serveur n'a pas le middleware qui lit le corps (palier 4).

**Une redirection inattendue.** Beaucoup de serveurs redirigent `http` vers `https`, ou ajoutent/retirent un slash final. Avec `curl`, ta requête s'arrête sur le `301` si tu n'ajoutes pas `-L`.

---

## Ce qu'on te demandera

HTTP est, avec SQL, **le sujet le plus systématiquement vérifié** sur un développeur web, junior ou non — parce qu'il est commun à toutes les stacks.

Les questions qui reviennent : « différence entre `401` et `403` », « que signifie un `500` et où regardes-tu », « `PUT` ou `PATCH` », « qu'est-ce qu'une méthode idempotente », « comment fonctionne l'authentification alors que HTTP est sans état », « qu'est-ce que CORS et de quel côté ça se règle ».

En **test technique**, on te demandera de concevoir les routes d'une ressource : quelles URL, quels verbes, quels codes de retour. C'est l'exercice de conception d'API le plus courant, et tu le prépares au palier 4.

En **travail réel**, on attendra que tu saches tester un endpoint avec `curl` ou Bruno avant de dire « ça ne marche pas », et que tu lises un code de statut avant de poser une question.

---

## Ce qui te démarquera

**Utiliser le bon code de statut dans tes propres API.** Beaucoup de juniors renvoient `200` avec `{"error": "..."}` dans le corps. C'est une faute : le code de statut **est** l'information, et les clients (navigateurs, bibliothèques, outils de monitoring) s'en servent. Renvoyer un `201` à une création et un `204` à une suppression est un détail qui signale que tu as compris le protocole.

**Isoler avec `curl`.** Savoir dire « j'ai testé l'endpoint directement, il répond correctement, donc le problème est dans le client » est une démarche de diagnostic, pas une intuition.

**Savoir expliquer le sans état.** « HTTP ne se souvient de rien, donc chaque requête doit rejouer son identité — c'est pour ça qu'il y a un cookie ou un jeton à chaque appel » est une phrase qui montre que tu comprends le modèle et pas seulement les recettes.

**Lire les en-têtes.** La plupart des développeurs ne les regardent jamais. Ils contiennent la réponse à une bonne partie des questions de cache, d'authentification et de contenu.

---

## 📚 À lire

**MDN → *An overview of HTTP*** pour le modèle général, puis les deux pages de référence : ***HTTP request methods*** et ***HTTP response status codes***. Garde celle des codes en favori — tu la consulteras toute ta carrière, c'est normal et personne ne les retient tous.

Survole ***HTTP headers*** sans chercher à la retenir : tu y reviendras par besoin précis.

**httpstatuses.io** donne une explication courte par code, pratique quand tu en rencontres un inhabituel.

Et pour le rôle du certificat, la page MDN *What is HTTPS?* complète la leçon 06.

---

## 🤖 Le mini-projet à demander à l'IA

HTTP s'apprend en envoyant de vraies requêtes et en provoquant de vraies erreurs :

> « Je suis en formation de développeur, palier 0. Je veux maîtriser HTTP par la pratique avec `curl`. Donne-moi **15 missions**, de la plus simple à la plus avancée, sur des API publiques réelles et gratuites (GitHub, httpbin.org, Open-Meteo, PokéAPI). Chaque mission doit me faire **observer** quelque chose de précis : un `201`, un `204`, un `301` avec son en-tête `Location`, un `401`, un `404`, un `429`, un `POST` JSON, un en-tête `Cache-Control`, une réponse compressée. Donne-moi seulement **l'objectif de chaque mission**, pas la commande. Je te montrerai ma commande et sa sortie, et tu me diras si j'ai bien observé ce qu'il fallait. »

Puis, pour consolider la partie diagnostic :

> « Décris-moi 8 pannes web réalistes sous la forme de ce que voit l'utilisateur (page blanche, bouton sans effet, message d'erreur, lenteur). Pour chacune, demande-moi : quel code de statut je m'attends à trouver, et où je vais regarder en premier. Corrige mon raisonnement sans me donner la réponse d'emblée. »

---

## 🛠️ À faire

1. Avec `curl -v`, interroge `https://api.github.com/users/<ton-pseudo>` et **recopie dans ton journal** la requête et la réponse, en identifiant la ligne de départ, trois en-têtes, le code de statut et le format du corps.
2. **Provoque volontairement** et note le code obtenu : un `404` (`curl -i https://api.github.com/nexistepas`), un `401` (`curl -i https://api.github.com/user`), une redirection (`curl -i http://github.com`).
3. Fais un `POST` JSON sur `https://httpbin.org/post` et retrouve tes données dans la réponse. Puis refais-le **sans** l'en-tête `Content-Type` et observe la différence.
4. **L'exercice qui fait tout comprendre** : dans les DevTools → Réseau, connecte-toi sur un site. Repère la requête de connexion. Quelle méthode ? Quel code ? Quel `Set-Cookie` ? Puis recharge la page et repère le `Cookie` renvoyé. Tu viens de voir le mécanisme complet d'une session.
5. Associe chaque situation à son code : formulaire mal rempli · page supprimée · mot de passe faux · page accessible seulement aux administrateurs · plantage de ton code serveur · ancienne URL déplacée définitivement · trop de tentatives de connexion.
6. Trouve une API publique qui renvoie un `429` quand on l'interroge trop vite, et provoque-le (une boucle de dix `curl` suffit souvent). Lis l'en-tête qui indique combien de temps attendre.
7. Compare les en-têtes de `curl -I https://github.com` et de `curl -I` sur un petit site quelconque. Quels en-têtes de sécurité et de cache le gros site ajoute-t-il ?

<details>
<summary>Corrections</summary>

**2.** `curl -i https://api.github.com/user` renvoie un `401` **avec un corps JSON** qui explique `"Requires authentication"`. Note cette bonne pratique : une API correcte explique *pourquoi* elle refuse. Tu feras pareil au palier 4.

**3.** Sans `Content-Type: application/json`, httpbin range tes données dans un autre champ de sa réponse (`data` au lieu de `json`) : le serveur ne sait pas comment interpréter le corps. C'est exactement la cause du problème « mon POST arrive vide » que tu rencontreras au palier 4.

**4.** La connexion est un `POST` — jamais un `GET`, sinon le mot de passe apparaîtrait dans l'URL, dans l'historique du navigateur et dans les logs du serveur. Elle répond souvent `302` (redirection vers le tableau de bord) avec un en-tête `Set-Cookie`. Les requêtes suivantes renvoient ce cookie automatiquement. **C'est tout le mécanisme de session** : HTTP est sans état, le cookie rétablit la continuité. Si tu as vu ça, tu as compris la leçon.

**5.** Formulaire mal rempli → `400` (ou `422` si l'on distingue la validation métier) · page supprimée → `404` (ou `410 Gone` pour être précis) · mot de passe faux → `401` · réservé aux administrateurs → `403` · plantage serveur → `500` · URL déplacée définitivement → `301` · trop de tentatives → `429`.

**6.** L'en-tête à repérer est `Retry-After` (parfois accompagné de `X-RateLimit-Reset`). Un client bien écrit le lit et attend le délai indiqué au lieu de réessayer immédiatement — c'est ce que tu implémenteras à la leçon 10 du palier 1.

**7.** Les gros sites ajoutent typiquement `Strict-Transport-Security` (forcer HTTPS), `X-Frame-Options` ou `Content-Security-Policy` (limiter les injections), et des en-têtes de cache précis. Tu rencontreras ces en-têtes au palier 4 (sécurité) et au palier 8 (configuration du reverse proxy).
</details>

---

## ✅ Acquis si…

- [ ] Je décris de mémoire la structure d'une requête et d'une réponse HTTP.
- [ ] Je cite les cinq méthodes principales et l'intention de chacune.
- [ ] J'explique les cinq familles de codes, et la différence **`401` / `403`**.
- [ ] Devant une erreur, je sais si je dois regarder ma requête (`4xx`) ou les logs du serveur (`5xx`).
- [ ] J'envoie un `GET` et un `POST` JSON avec `curl`, sans aide.
- [ ] J'explique ce que signifie « HTTP est sans état », et comment un cookie ou un jeton compense.
- [ ] Je sais pourquoi un `GET` ne doit jamais modifier quoi que ce soit.
- [ ] J'ai observé un cycle de connexion complet dans l'onglet Réseau (`POST` → `Set-Cookie` → `Cookie`).

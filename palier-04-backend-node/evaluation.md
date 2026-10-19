# ✅ Épreuve de sortie — Palier 4

> **L'épreuve la plus déterminante du parcours après celle du palier 1** : elle valide les concepts backend que tu réutiliseras dans deux autres langages.
> **Conditions** : seul, **sans tutoriel**. IA en binôme autorisée pour le projet (niveau 4), **interdite pendant les épreuves A**. Doc officielle autorisée.
> **Durée** : ~6 h hors projet. **Seuil** : 5/5 épreuves · **20/26** au quiz · projet 4 déployé et revu par le référent.

---

## Partie A — Épreuves pratiques

### A1 — API REST de zéro (2 h, sans tutoriel)
Crée une API Express + PostgreSQL pour une ressource de ton choix :
- CRUD complet, routes et codes de statut **conformes à REST** (`201` à la création, `204` à la suppression, `404`, `400`/`422`)
- validation des entrées avec **Zod**, messages d'erreur par champ
- gestion d'erreurs **centralisée** (un middleware, pas un `try/catch` par route)
- un middleware de journalisation
- configuration par variables d'environnement, `.env` dans `.gitignore`, `.env.example` commité
- testée avec Bruno/Postman : collection exportée dans le repo

✅ **Réussi si** : toutes les routes répondent correctement, les mauvaises entrées renvoient un 4xx explicite, aucun secret dans Git.

### A2 — SQL sans ORM (60 min)
Sur un schéma à 3 tables liées (ex. `utilisateurs`, `commandes`, `produits` avec table de jointure), écris **à la main**, sans ORM :
1. une jointure sur 2 tables avec filtre et tri
2. une `LEFT JOIN` et l'explication de ce qu'elle change par rapport à une `INNER JOIN`
3. un `GROUP BY` avec `COUNT` et `SUM`, plus un `HAVING`
4. une jointure sur 3 tables (dont la table de liaison N-N)
5. une sous-requête ou une CTE (`WITH`)
6. l'ajout d'un index pertinent, avec `EXPLAIN` avant/après et le commentaire du gain

✅ **Réussi si** : les 6 requêtes sont justes, et tu expliques pourquoi l'index aide (et ce qu'il coûte).

### A3 — Authentification (60 min)
Implémente l'inscription et la connexion :
- mots de passe hachés (**bcrypt** ou argon2), jamais stockés ni journalisés en clair
- deux variantes comparées : session + cookie `httpOnly`, et JWT
- middleware de protection de route, et un contrôle d'**autorisation** par rôle
- la réponse d'API ne renvoie **jamais** le hash (rest/omit du champ)

✅ **Réussi si** : un utilisateur non authentifié obtient `401`, un utilisateur sans droit obtient `403`, et tu expliques le compromis sessions/JWT.

### A4 — Sécurité démontrée (45 min)
1. Écris une route **volontairement vulnérable** à l'injection SQL, **exploite-la** (récupère des données qui ne devraient pas sortir), puis corrige avec une requête préparée. Documente les trois étapes.
2. Même exercice pour une **XSS** : injecte `<script>` via un champ, constate, puis échappe à l'affichage.
3. Explique pourquoi ton API est (ou non) exposée au CSRF selon le mode d'authentification choisi.

✅ **Réussi si** : les deux failles sont réellement exploitées puis corrigées, preuves dans le journal.

### A5 — Tests (45 min)
- tests **unitaires** de la logique métier (fonctions pures : calculs, règles de validation)
- tests d'**intégration** de 3 routes dont une authentifiée (Supertest)
- un test qui vérifie un **cas d'erreur** (entrée invalide → 400)
- les tests passent en une commande, et sont dans le pipeline (préparation palier 8)

✅ **Réussi si** : `npm test` est vert, et tu justifies ce que tu as choisi de **ne pas** tester.

---

## Partie B — Quiz (26 questions)

**HTTP & REST**
1. Qu'as-tu dû écrire à la main avec `node:http` qu'Express te fournit ? (Cite 4 choses.)
2. Qu'est-ce qu'un middleware ? Pourquoi l'ordre de déclaration compte-t-il ?
3. Conçois les routes REST d'une ressource `depenses` (liste, détail, création, modification, suppression) avec le bon verbe et le bon code de retour.
4. Quels codes renvoies-tu : création réussie, suppression réussie, validation échouée, non authentifié, non autorisé, ressource absente, plantage serveur ?
5. `PUT` vs `PATCH` ?
6. Pourquoi une API doit-elle valider côté serveur même si le front valide déjà ?

**SQL & données**
7. Différence entre `INNER JOIN`, `LEFT JOIN` et `CROSS JOIN` ?
8. À quoi sert une clé étrangère ? Que se passe-t-il à la suppression du parent ?
9. Comment modélise-t-on une relation N-N ? Donne un exemple.
10. À quoi sert un index ? Que coûte-t-il ?
11. Qu'est-ce qu'une transaction ? Donne un cas où son absence est un bug grave.
12. `WHERE` vs `HAVING` ?
13. Qu'est-ce qu'une migration et pourquoi la versionne-t-on dans Git ?
14. Qu'est-ce qu'un ORM ? Cite un avantage et deux pièges.
15. Quand une base NoSQL (Redis, MongoDB) a-t-elle du sens ? Quand non ?

**Sécurité**
16. Explique l'injection SQL et sa parade. Pourquoi l'échappement manuel ne suffit-il pas ?
17. Pourquoi hache-t-on un mot de passe au lieu de le chiffrer ?
18. Qu'est-ce qu'un « sel » et pourquoi bcrypt en met-il un ?
19. Sessions vs JWT : avantages et inconvénients de chacun. Lequel pour une app mobile, et pourquoi ?
20. Qu'est-ce qu'un cookie `httpOnly` ? Contre quoi protège-t-il ?
21. Explique XSS et CSRF, et la parade de chacun.
22. Qu'est-ce que CORS ? Pourquoi `Access-Control-Allow-Origin: *` est-il dangereux sur une API authentifiée par cookie ?
23. Cite 5 entrées de l'OWASP Top 10 et une parade pour chacune.

**Tests & architecture**
24. Différence entre test unitaire et test d'intégration ? Que teste-t-on en priorité ?
25. Pourquoi 100 % de couverture n'est-il pas un objectif ?
26. Décris le découpage routes → contrôleurs → services → accès données, et ce que chaque couche a le droit de faire.

<details>
<summary>Corrections — points clés</summary>

1. Parsing de l'URL et de la query string, routage, lecture et parsing du corps JSON, gestion des erreurs, en-têtes et codes, service de fichiers statiques. **C'est la liste de ce qu'un framework vend** — exactement le bilan que tu refais aux paliers 5 et 6.
2. Une fonction `(req, res, next)` exécutée entre la requête et la réponse. L'ordre compte car la chaîne est séquentielle : un middleware d'authentification déclaré **après** une route ne la protège pas.
3. `GET /depenses` 200 · `GET /depenses/:id` 200/404 · `POST /depenses` **201** + `Location` · `PUT|PATCH /depenses/:id` 200/404 · `DELETE /depenses/:id` **204**/404.
4. 201 · 204 · 400 ou 422 · 401 · 403 · 404 · 500.
5. `PUT` remplace la ressource entière (idempotent) ; `PATCH` applique une modification partielle.
6. Le client est contournable : `curl` ignore ton formulaire. La validation front est du confort, celle du serveur est la seule barrière.
7. `INNER` : seulement les lignes appariées des deux côtés. `LEFT` : toutes celles de gauche, avec `NULL` à droite si rien ne correspond (c'est ce qui permet de trouver « les utilisateurs sans commande »). `CROSS` : produit cartésien.
8. Elle garantit l'intégrité référentielle. À la suppression du parent : selon `ON DELETE` → `RESTRICT` (refus), `CASCADE` (suppression en chaîne), `SET NULL`.
9. Par une **table de jointure** portant les deux clés étrangères (ex. `commande_produit(commande_id, produit_id, quantite)`).
10. Il accélère les recherches et les tris sur une colonne (de `O(n)` à `O(log n)`). Coût : espace disque et **écritures plus lentes** (chaque insertion met l'index à jour). Même raisonnement que la `Map` de la leçon 12 du palier 1.
11. Un groupe d'opérations tout-ou-rien. Sans elle : débiter un compte puis échouer à créditer l'autre — l'argent disparaît.
12. `WHERE` filtre les lignes **avant** le regroupement ; `HAVING` filtre les groupes **après**.
13. Un fichier versionné décrivant un changement de schéma. Dans Git, parce que le schéma fait partie du code : tout environnement doit pouvoir être reconstruit à l'identique.
14. Une couche de traduction objets ↔ lignes. Avantage : rapidité d'écriture, sécurité par défaut (requêtes paramétrées). Pièges : le **N+1** (une requête par élément d'une boucle), et la perte de contrôle du SQL généré sur les cas complexes.
15. Redis : cache, sessions, files, compteurs. MongoDB : documents hétérogènes sans relations fortes. Non : dès qu'il y a des relations et un besoin de cohérence — c'est-à-dire la plupart des applications de gestion.
16. Des données utilisateur concaténées dans la requête sont interprétées comme du SQL. Parade : **requêtes préparées** (les paramètres ne sont jamais interprétés comme du code). L'échappement manuel oublie toujours un cas (encodages, contextes, types).
17. Le hachage est **irréversible** : même volé, le fichier ne rend pas les mots de passe. Un chiffrement est réversible, donc la clé devient le point unique de défaillance.
18. Une valeur aléatoire ajoutée avant hachage, différente pour chaque mot de passe. Elle rend inutilisables les tables précalculées (rainbow tables) et empêche de voir que deux utilisateurs ont le même mot de passe.
19. Session : révocable instantanément, état côté serveur (donc à partager entre instances). JWT : sans état, pratique pour plusieurs clients et le multi-service, mais **non révocable** avant expiration. App mobile : JWT (pas de gestion de cookies), avec des durées courtes et un refresh token.
20. Un cookie inaccessible au JavaScript. Il protège contre le **vol de session par XSS**.
21. XSS : exécution de script injecté dans ta page → échapper tout affichage de données utilisateur + CSP. CSRF : une autre origine fait exécuter une action à ton utilisateur connecté → jeton CSRF et/ou cookies `SameSite`.
22. Une règle du navigateur sur les requêtes cross-origine. `*` avec des cookies est refusé par les navigateurs **et** indiquerait que n'importe quel site peut appeler ton API au nom de l'utilisateur.
23. Par exemple : contrôle d'accès défaillant (vérifier l'autorisation **côté serveur** pour chaque ressource) · injection (requêtes préparées) · mauvaise configuration (pas de secret par défaut, pas de trace d'erreur en prod) · identification défaillante (hachage fort, limitation de tentatives) · composants vulnérables (`npm audit`, mises à jour).
24. Unitaire : une fonction isolée. Intégration : plusieurs couches ensemble (route → service → base). Priorité : la **logique métier** et les routes critiques (auth, argent).
25. Parce que le coût croît plus vite que la valeur : on finit par tester des getters et du code trivial, et une suite lente finit par être désactivée. L'objectif est la **confiance**, pas le pourcentage.
26. Routes : déclarer les URL et déléguer. Contrôleurs : lire la requête, valider, appeler un service, former la réponse (aucune règle métier). Services : **la logique métier**, sans connaître HTTP. Accès données : les requêtes, sans règle métier. Une couche n'appelle que la suivante.

**Score** : ____ /26
</details>

---

## Partie C — Livrables

- [ ] [Projet 4](projet.md) **déployé sur Render** (API + PostgreSQL managée), URL dans [../progression.md](../progression.md).
- [ ] **Cahier des charges complet** ([template](../templates/cahier-des-charges.md)) rédigé **avant** le code, présenté au référent.
- [ ] **Estimation d'effort par tâche** et mesure du réel → première ligne de [../templates/bilan-estime-reel.md](../templates/bilan-estime-reel.md) : **ton coefficient personnel**.
- [ ] Journal des risques (3–5 lignes) dans le cahier des charges.
- [ ] `ARCHITECTURE.md` avec schéma : routes → contrôleurs → services → données.
- [ ] README + `.env.example` + collection Bruno/Postman dans le repo.
- [ ] Tests au vert, lancés en une commande.
- [ ] `journal.md` · [rétrospective](../templates/retrospective-palier.md).
- [ ] 🧑‍🏫 **Revue de code sérieuse du projet 4 par le référent** — ta première vraie code review. Note les critiques dans la rétrospective ; c'est le livrable le plus formateur du palier.

---

## Résultat

| Partie | Seuil | Résultat |
|--------|-------|----------|
| A — Pratique | 5/5 | ⬜ |
| B — Quiz | 20/26 | ⬜ ___/26 |
| C — Livrables | tout coché | ⬜ |

**Date** : ______ · **Verdict** : ⬜ validé ⬜ à repasser le ______ · [ ] reporté dans [../progression.md](../progression.md)

> 🚦 Ce palier conditionne les paliers 5 et 6 : ils supposent que REST, SQL, l'auth et la sécurité sont **acquis**, et n'enseignent que leur expression dans un autre langage. Un trou ici se paiera deux fois.

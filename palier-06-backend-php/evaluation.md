# ✅ Épreuve de sortie — Palier 6

> **Conditions** : seul, sans tutoriel. IA en « accélérateur de langages » autorisée, **interdite sur le routeur et l'auth maison** (épreuve A2) : c'est là que se joue la compréhension.
> **Durée** : ~5 h hors projets. **Seuil** : 5/5 épreuves · **16/22** au quiz · projets 6a et 6b livrés, 6b déployé sur un hébergement Apache réel.

---

## Partie A — Épreuves pratiques

### A1 — Apache et `.htaccess` (45 min, sans copier-coller)
Sur ta stack LAMP locale :
1. un VirtualHost pour `monsite.test` (avec l'entrée dans `/etc/hosts`)
2. un `.htaccess` qui réécrit `/article/42` vers `index.php?id=42`
3. un `.htaccess` qui **interdit l'accès** à un dossier `config/`
4. une page d'erreur 404 personnalisée
5. une redirection **301** d'une ancienne URL vers une nouvelle
6. retrouve une erreur PHP dans `/var/log/apache2/error.log` et explique-la

✅ **Réussi si** : tout fonctionne, écrit **sans copier-coller** et sans générateur en ligne, et tu sais dire ce que fait chaque directive.

### A2 — Le MVC maison (2 h, **sans IA, sans tutoriel**)
Reconstruis de mémoire, sur une ressource simple :
1. **front controller** : `.htaccess` → `public/index.php`
2. **routeur** : table de routes (méthode + motif + action), paramètres d'URL
3. **contrôleurs** : une classe par ressource, une méthode par action
4. **modèles** : accès PDO avec requêtes préparées (Repository simple)
5. **vues** : templates PHP avec layout commun et **échappement systématique** (`htmlspecialchars`)
6. **auth** : inscription, connexion, sessions, **jeton CSRF** sur les formulaires
7. autoloading **PSR-4** via Composer

✅ **Réussi si** : le CRUD complet avec authentification fonctionne, et tu peux expliquer chaque ligne du routeur et de l'auth.

### A3 — Laravel (60 min, sans tutoriel)
Le même CRUD, en Laravel : migration, modèle Eloquent, contrôleur ressource, vues Blade, validation, auth Breeze, un seeder.

✅ **Réussi si** : fonctionnel, **et** tu produis la correspondance explicite entre chaque brique de ton MVC maison et son équivalent Laravel. **Chronomètre les deux implémentations** : l'écart est la valeur du framework — tu sauras désormais la chiffrer dans un devis.

### A4 — Sécurité PHP (45 min)
1. démontre une **injection SQL** sur une requête concaténée, puis corrige avec PDO préparé
2. démontre une **XSS** via un champ, puis échappe à l'affichage
3. démontre une **CSRF** (un formulaire hébergé ailleurs qui déclenche une action), puis protège par jeton
4. upload de fichier : montre deux pièges (type MIME déclaré par le client, exécution dans un dossier accessible) et leurs parades

✅ **Réussi si** : les trois failles sont réellement exploitées puis corrigées, preuves dans le journal.

### A5 — Déploiement réel (45 min)
Sur hébergement mutualisé (cPanel) ou VPS Apache fourni par le référent :
- dépôt par **SFTP** (ou git), structure correcte (`public/` comme racine web)
- base **MySQL** créée via phpMyAdmin, import du schéma
- `.htaccess` **réellement actif** (différence avec le serveur de dev)
- permissions correctes, `config` hors de la racine web ou protégé
- procédure de redéploiement écrite en 10 lignes

✅ **Réussi si** : l'app est accessible publiquement, et aucun fichier sensible n'est servi (teste `/config/database.php` dans le navigateur).

---

## Partie B — Quiz (22 questions)

**Environnement**
1. Explique le modèle d'exécution PHP et sa différence avec Node. Trois conséquences pratiques.
2. Pourquoi PHP est-il « stateless par construction » ? Quel avantage au palier 7 ?
3. mod_php vs php-fpm ?
4. Qu'est-ce qu'un VirtualHost ? À quoi sert l'en-tête `Host` ?
5. Écris la règle `.htaccess` d'un front controller et explique chaque ligne.
6. Où sont les logs d'erreur Apache, et quand les consulter ?

**Langage**
7. Trois apports de PHP 8 qui démentent sa mauvaise réputation.
8. Qu'est-ce qu'un tableau associatif ? En quoi est-il à la fois pratique et piégeux ?
9. Cite 4 superglobales et leur rôle. Pourquoi sont-elles dangereuses ?
10. Comment fonctionne une session PHP ? Où vivent les données ?
11. À quoi sert Composer ? Qu'est-ce que l'autoloading PSR-4 ?
12. Pourquoi PDO plutôt que `mysqli` ? Pourquoi **toujours** des requêtes préparées ?

**Architecture**
13. Qu'est-ce qu'un front controller, et pourquoi tous les frameworks PHP l'utilisent-ils ?
14. Décris le rôle de chaque couche de ton MVC maison. Qu'est-ce qu'un contrôleur n'a **pas** le droit de faire ?
15. Qu'as-tu construit à la main, et quel nom porte chacune de ces briques dans Laravel ?
16. Pourquoi `htmlspecialchars` à **l'affichage** et pas à l'enregistrement ?
17. Explique le mécanisme du jeton CSRF, étape par étape.

**Laravel & comparaison**
18. Eloquent : quel pattern ? Compare à Prisma et à Django ORM.
19. À quoi servent les files d'attente (queues) ? Donne deux cas d'usage réels.
20. Qu'est-ce qu'une policy ? En quoi diffère-t-elle d'un middleware ?
21. « Convention over configuration » : avantage, et prix à payer.
22. Pour un projet donné, comment choisis-tu entre Express, Django et Laravel ? Donne 4 critères et un exemple de verdict.

<details>
<summary>Corrections — points clés</summary>

1. Un **processus (ou worker) par requête** : le script démarre, répond, **tout meurt**. Conséquences : aucun état en mémoire entre requêtes (d'où les sessions sur disque/Redis), une connexion BDD par requête (d'où le pooling côté serveur), une fuite mémoire ne s'accumule pas — et un calcul long ne bloque **pas** les autres utilisateurs, contrairement à Node.
2. Parce que rien ne survit à la requête : n'importe quel serveur peut traiter n'importe quelle requête. C'est exactement la propriété requise pour la **scalabilité horizontale** (palier 7).
3. mod_php : l'interpréteur est intégré à Apache (simple, couplé, un processus Apache par requête). php-fpm : un pool de processus PHP séparé, utilisable avec Nginx, meilleur contrôle des ressources. php-fpm est le standard actuel.
4. Une configuration qui permet à un serveur de servir plusieurs sites sur la même IP. Apache lit l'en-tête `Host` de la requête HTTP pour savoir lequel servir.
5. ```apache
   RewriteEngine On
   RewriteCond %{REQUEST_FILENAME} !-f      # si ce n'est pas un fichier existant
   RewriteCond %{REQUEST_FILENAME} !-d      # ni un dossier existant
   RewriteRule ^ index.php [L]              # alors tout passe par index.php
   ```
   Les deux conditions laissent passer les ressources statiques réelles ; `[L]` arrête le traitement des règles.
6. `/var/log/apache2/error.log` (et `access.log`). Dès qu'une page renvoie une 500 ou une page blanche : le navigateur ne dira rien, le log dira tout.
7. Typage (paramètres, retours, propriétés), `match`, enums, arrow functions, attributs, JIT, named arguments, `readonly`.
8. Une structure qui sert à la fois de liste et de dictionnaire. Piège : il mélange les deux sémantiques — un tableau « liste » peut devenir « dictionnaire » après un `unset`, et `json_encode` produit alors un objet et non un tableau.
9. `$_GET`, `$_POST`, `$_SERVER`, `$_SESSION`, `$_COOKIE`, `$_FILES`. Dangereuses parce qu'elles sont **entièrement contrôlées par le client** (y compris une partie de `$_SERVER`) : toute donnée qui en sort doit être validée et échappée.
10. Un identifiant de session est posé en cookie ; les données sont stockées côté **serveur** (fichiers dans `/tmp` par défaut, ou Redis/BDD en production — nécessaire dès qu'il y a plusieurs serveurs).
11. Composer gère les dépendances (l'équivalent de npm/pip). PSR-4 fait correspondre un **namespace** à une arborescence de dossiers, ce qui permet de charger les classes à la demande sans aucun `require`.
12. PDO est une abstraction multi-bases avec une API homogène. Les requêtes préparées séparent le **code SQL** des **données** : l'injection devient structurellement impossible, là où l'échappement manuel oublie toujours un cas.
13. Un point d'entrée unique par lequel passent toutes les requêtes. Il permet de centraliser le routage, l'autoloading, la configuration, les middlewares et la gestion d'erreurs — impossible avec un fichier PHP par page.
14. Routeur : associer URL → action. Contrôleur : lire la requête, valider, appeler le modèle, choisir la vue. Modèle : l'accès aux données et les règles du domaine. Vue : afficher, en échappant. Un contrôleur **ne fait pas** de SQL et ne contient pas de HTML.
15. Routeur → le routeur de Laravel · contrôleurs → contrôleurs · modèles PDO → Eloquent · moteur de vues → Blade · auth maison → Breeze/Fortify · jeton CSRF → middleware `VerifyCsrfToken` · autoloader → Composer. **Laravel n'est plus magique : c'est ton code, en mieux.**
16. Parce que l'échappement dépend du **contexte de sortie** (HTML, attribut, JS, URL). Échapper à l'enregistrement corrompt la donnée (on stocke `&amp;` au lieu de `&`) et empêche tout autre usage (export CSV, email, API).
17. Génération d'un jeton aléatoire stocké en session · insertion dans un champ caché du formulaire · à la soumission, comparaison du jeton reçu avec celui en session · rejet si absent ou différent. Un site tiers ne peut pas lire la session, donc ne peut pas forger le jeton.
18. **Active Record** : l'objet porte ses données et sait se persister (`$user->save()`). Django ORM : également Active Record. Prisma : plutôt Data Mapper (un client traduit, les objets sont de simples données). Active Record est plus concis ; Data Mapper sépare mieux domaine et persistance et facilite les tests.
19. À sortir de la requête tout traitement long pour qu'il n'en bloque pas la réponse. Cas réels : envoi d'emails, génération de PDF/exports, appels à une API tierce lente, traitement d'images.
20. Une policy regroupe les règles d'**autorisation** sur un modèle (« cet utilisateur peut-il modifier cette dépense ? »). Un middleware agit sur la **requête** (authentifié ? rôle ? limite de débit ?) sans connaître l'instance concernée.
21. Avantage : vitesse de livraison, code homogène d'un projet à l'autre, onboarding rapide. Prix : il faut faire les choses « à la manière du framework », et sortir des rails coûte cher.
22. Critères : nature du besoin (API temps réel → Node ; back-office et CRUD métier → Django/Laravel ; data/IA → Python) · vitesse de livraison attendue · compétence disponible · écosystème et hébergement visés (mutualisé → PHP) · maintenance à long terme. Exemple : « site de gestion pour une PME, hébergement mutualisé, livraison en 6 semaines → Laravel. »

**Score** : ____ /22
</details>

---

## Partie C — Livrables

- [ ] [Projet 6a — MVC maison](projet.md) : repo, README expliquant chaque brique, bilan « ce que j'ai construit = un framework ».
- [ ] [Projet 6b — App métier Laravel](projet.md) déployée sur **hébergement Apache réel** (mutualisé ou VPS), URL dans [../progression.md](../progression.md).
- [ ] **Devis** rédigé et **défendu** face au référent-client ([template](../templates/devis.md)) — avec marge de 20 % et coûts récurrents.
- [ ] **Proposition commerciale** de 2 pages.
- [ ] **Gestion du changement de périmètre** documentée : la demande du « client », son chiffrage, l'avenant.
- [ ] Comparatif final **Express vs Django vs Laravel** (+ tes 2 frameworks maison) complété.
- [ ] Les katas passent en PHP (≥ 10) · `journal.md` · [rétrospective](../templates/retrospective-palier.md).
- [ ] Mesure de ta vélocité mise à jour dans [../templates/bilan-estime-reel.md](../templates/bilan-estime-reel.md) — celle qui sert au devis.
- [ ] 🧑‍🏫 Référent : revue du **projet 6a** (le plus révélateur) + rôle du **client** sur 6b (exigences floues, changement d'avis, négociation).

---

## Résultat

| Partie | Seuil | Résultat |
|--------|-------|----------|
| A — Pratique | 5/5 | ⬜ |
| B — Quiz | 16/22 | ⬜ ___/22 |
| C — Livrables | tout coché | ⬜ |

**Date** : ______ · **Verdict** : ⬜ validé ⬜ à repasser le ______ · [ ] reporté dans [../progression.md](../progression.md)

> 🎓 À ce stade tu as trois backends et deux frameworks écrits de ta main. **Tu peux répondre à la question d'architecte** : « pour ce projet précis, quelle stack, et pourquoi pas les autres ? » C'est exactement l'objet du palier 7.

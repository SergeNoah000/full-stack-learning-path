# Leçon 08 — Authentification : sessions, JWT, hachage des mots de passe

> 🎯 **À la fin de cette leçon** : tu implémentes une authentification correcte, tu sais pourquoi on hache un mot de passe au lieu de le chiffrer, et tu distingues authentification et autorisation.
> ⏱️ 5 h · **Prérequis** : leçons 01–07, et la leçon 07 du palier 0 (HTTP sans état).

---

## De quoi on parle

L'**authentification** répond à « qui es-tu ? ». L'**autorisation** répond à « as-tu le droit ? ». Ce sont deux choses distinctes, implémentées à deux endroits différents, et les confondre produit des failles.

Le **hachage** transforme un mot de passe en une empreinte **irréversible**. On ne chiffre pas un mot de passe — on le hache, et on ne peut jamais le retrouver.

Une **session** conserve l'état de connexion **côté serveur**, référencé par un identifiant posé dans un **cookie**. Un **JWT** (*JSON Web Token*) est un jeton signé, **autonome**, que le client renvoie à chaque requête.

Et le problème de fond vient de la leçon 07 du palier 0 : **HTTP est sans état**. Le serveur ne se souvient de rien entre deux requêtes. Toute l'authentification du web découle de cette unique contrainte.

---

## À quoi ça sert, concrètement

**Parce que presque toute application a des comptes.** Et parce que c'est le domaine où une erreur ne produit pas un bug mais une **fuite de données**. Un mot de passe mal stocké, et une base compromise expose les comptes de tes utilisateurs — y compris sur d'autres sites, puisque beaucoup de gens réutilisent leurs mots de passe.

**Parce que les erreurs classiques sont connues et évitables.** Stocker un mot de passe en clair, le hacher avec MD5 ou SHA-256 sans sel, vérifier les droits côté client, laisser un jeton dans `localStorage` sans y penser, renvoyer « cet email n'existe pas » : chacune est documentée, chacune est encore commise tous les jours.

**Parce que c'est systématiquement évalué.** L'authentification est le sujet de sécurité le plus abordé en entretien, parce qu'il est concret et qu'il révèle immédiatement si le candidat a compris ou copié un tutoriel.

**Et parce que le choix session/JWT est une vraie décision d'architecture**, avec des conséquences que tu dois pouvoir exposer. Ce n'est pas une question de mode.

---

## Où ça intervient dans le développement

L'authentification s'insère dans la chaîne de middlewares de la leçon 02, **avant** les routes protégées :

```
   requête
     │
     ├─▶ journalisation
     ├─▶ CORS
     ├─▶ express.json()
     ├─▶ AUTHENTIFICATION  → qui es-tu ?     sinon 401     ← cette leçon
     ├─▶ AUTORISATION      → as-tu le droit ? sinon 403     ← cette leçon
     ├─▶ validation (leçon 04)
     ├─▶ la route
     └─▶ gestion des erreurs
```

L'ordre n'est pas négociable, et tu l'as déjà démontré à la leçon 02 : un middleware déclaré après une route ne la protège pas.

Trois points structurants.

**L'autorisation se vérifie à deux niveaux**, et le second est celui qu'on oublie. Le middleware vérifie le **rôle** (« es-tu administrateur ? ») ; le service doit vérifier la **propriété** (« cette dépense t'appartient-elle ? »). Sans le second, n'importe quel utilisateur connecté peut lire les données d'un autre en changeant un identifiant dans l'URL. C'est la faille la plus répandue du web, et elle a un nom : *Broken Access Control*. Elle est détaillée à la leçon 09.

**Le choix session/JWT dépend des clients.** Une application web avec un seul domaine : les sessions par cookie sont plus simples et plus sûres. Une application mobile (ton palier 9) ou plusieurs services : le jeton s'impose. C'est une décision d'architecture que tu documenteras au palier 7.

**Et les trois backends feront la même chose.** Au palier 5, Django fournit l'authentification complète intégrée — et tu comprendras alors la valeur de ce que tu as écrit à la main. Au palier 6, tu la réimplémenteras **entièrement** en PHP natif, sessions et jeton CSRF compris, puis tu utiliseras Breeze dans Laravel. Même concept, trois niveaux d'automatisation.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas implémenter l'inscription et la connexion, et c'est un moment où l'on prend conscience de sa responsabilité : tu manipules les mots de passe de gens réels.

Tu vas aussi faire l'exercice le plus instructif de la leçon : **essayer d'accéder aux données d'un autre utilisateur** en changeant un identifiant dans l'URL. Si ça marche, tu viens de découvrir pourquoi la vérification de propriété existe.

### En équipe, en entreprise

**On n'écrit pas son authentification à la main.** Les équipes utilisent une bibliothèque (Passport, Lucia, Auth.js) ou un service (Auth0, Clerk, Supabase Auth, Keycloak). La raison est simple : les détails sont nombreux, les erreurs coûteuses, et le sujet n'apporte aucune valeur métier différenciante.

**Mais on doit comprendre ce qui se passe.** Configurer une bibliothèque sans comprendre les sessions, les jetons et les cookies produit des configurations dangereuses — et c'est exactement pour cette raison que tu l'écris une fois ici.

**Les revues de sécurité sont systématiques** sur ce sujet : durée de vie des jetons, attributs des cookies, politique de mots de passe, limitation des tentatives de connexion, et surtout vérification de la propriété des ressources.

**Et tu verras des failles en production.** Des jetons sans expiration, des vérifications de rôle côté client seulement, des messages d'erreur qui révèlent l'existence d'un compte.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : hacher avec bcrypt ou argon2, comparer, un middleware d'authentification, un middleware de rôle, la vérification de propriété dans les services, et les attributs de cookie.

Régulièrement : les jetons de rafraîchissement, la limitation du débit sur la connexion, la réinitialisation de mot de passe par jeton à usage unique, la déconnexion.

Rare, et hors sujet pour l'instant : OAuth 2 et OpenID Connect (la connexion par Google ou GitHub — très utile, mais c'est un sujet à part entière), le double facteur, les clés d'accès (*passkeys*), les permissions fines par ressource, le SSO d'entreprise, la rotation des secrets de signature. Et un sujet dont tout le monde parle sans le maîtriser : le stockage « sûr » des jetons côté navigateur — nous verrons la réponse courte plus bas.

---

## La mécanique

### Hacher un mot de passe

```bash
npm install bcrypt
```

```ts
import bcrypt from "bcrypt";

// À l'inscription
const empreinte = await bcrypt.hash(motDePasse, 12);        // 12 = coût, pas une longueur

// À la connexion
const correspond = await bcrypt.compare(motDePasse, utilisateur.empreinte);
```

Trois choses à comprendre, et ce sont celles qu'on demande en entretien.

**On hache, on ne chiffre pas.** Un chiffrement est réversible : la clé devient alors le point unique de défaillance, et un attaquant qui l'obtient récupère tous les mots de passe. Un hachage est **irréversible** : même avec la base complète, on ne peut pas remonter aux mots de passe. Et le serveur n'a jamais besoin de les connaître — il compare des empreintes.

**bcrypt ajoute un sel automatiquement.** Un **sel** est une valeur aléatoire unique par mot de passe, incorporée à l'empreinte. Il rend inutilisables les tables précalculées (les *rainbow tables*), et il empêche de voir que deux utilisateurs ont choisi le même mot de passe. C'est pour cette raison que deux appels à `hash` avec le même mot de passe donnent deux empreintes différentes — et que c'est normal.

**bcrypt est volontairement lent.** Le paramètre de coût (12) détermine le temps de calcul, autour de 100 à 300 millisecondes. C'est intentionnel : un hachage rapide comme SHA-256 permet de tester des milliards de candidats par seconde sur du matériel dédié. La lenteur est la protection.

> ⚠️ **N'utilise jamais MD5, SHA-1 ou SHA-256 pour un mot de passe.** Ce sont des fonctions de hachage **rapides**, conçues pour vérifier l'intégrité de fichiers, pas pour résister à une attaque par force brute. Les algorithmes corrects sont **bcrypt**, **scrypt** et **argon2** (le plus récent et recommandé aujourd'hui).

### Inscription et connexion

```ts
// services/auth.ts
export const serviceAuth = {
  async inscrire({ email, motDePasse }: Inscription) {
    const existant = await depotUtilisateurs.parEmail(email);
    if (existant) throw new ErreurMetier("Cet email est déjà utilisé", "CONFLIT");

    const empreinte = await bcrypt.hash(motDePasse, 12);
    const utilisateur = await depotUtilisateurs.creer({ email, empreinte });
    return versionPublique(utilisateur);            // ⭐ JAMAIS l'empreinte en réponse
  },

  async connecter({ email, motDePasse }: Connexion) {
    const utilisateur = await depotUtilisateurs.parEmail(email);

    // ⭐ Le MÊME message dans les deux cas
    if (!utilisateur || !(await bcrypt.compare(motDePasse, utilisateur.empreinte))) {
      throw new ErreurAuthentification("Email ou mot de passe incorrect");
    }
    return { utilisateur: versionPublique(utilisateur), jeton: signerJeton(utilisateur) };
  },
};

const versionPublique = ({ empreinte, ...reste }: Utilisateur) => reste;   // palier 1, leçon 07
```

Deux détails qui comptent, et qui sont des questions d'entretien.

**Le message d'erreur est identique** que l'email soit inconnu ou le mot de passe faux. Distinguer les deux permettrait à un attaquant d'**énumérer** les comptes existants : il saurait quelles adresses sont inscrites, ce qui est une information exploitable (hameçonnage ciblé, revente de listes).

**La version publique retire l'empreinte**, par rest (palier 3, leçon 02). Renvoyer l'objet utilisateur complet est une erreur fréquente, et l'empreinte se retrouve alors visible dans l'onglet Réseau de n'importe quel navigateur.

### ⭐ Sessions ou JWT : le vrai arbitrage

| | Session + cookie | JWT |
|---|---|---|
| L'état vit | **côté serveur** | dans le jeton, chez le client |
| Révocation immédiate | ✅ on supprime la session | ❌ valide jusqu'à expiration |
| Scalabilité horizontale | demande un stockage partagé (Redis) | sans état, donc trivial |
| Avec une application mobile | pénible (gestion des cookies) | ✅ naturel |
| Protection XSS | ✅ cookie `httpOnly` inaccessible au JS | ⚠️ selon le stockage |
| Protection CSRF | ⚠️ nécessite un jeton CSRF | ✅ si envoyé par en-tête |
| Taille à chaque requête | un identifiant court | tout le contenu du jeton |

*(Table de référence — à savoir exposer en entretien.)*

**La règle de décision pratique** : une application web sur un seul domaine → **session par cookie**, c'est plus simple et plus sûr. Une application mobile, plusieurs services, ou plusieurs domaines → **jeton**. Et il existe une approche mixte, très courante : un jeton d'accès de courte durée plus un jeton de rafraîchissement dans un cookie `httpOnly`.

Le point le plus important, et celui qu'on oublie : **un JWT ne se révoque pas**. Si tu bannis un utilisateur, son jeton reste valide jusqu'à son expiration. D'où des durées de vie **courtes** (quinze minutes) complétées par un jeton de rafraîchissement.

### Les sessions

```bash
npm install express-session connect-redis
```

```ts
app.use(session({
  store: new RedisStore({ client: redis }),         // ⭐ pas la mémoire en production
  secret: config.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,                                  // ⭐ inaccessible au JavaScript
    secure: config.NODE_ENV === "production",        // ⭐ HTTPS uniquement
    sameSite: "lax",                                 // ⭐ protection CSRF de base
    maxAge: 1000 * 60 * 60 * 24 * 7,
  },
}));
```

Les trois attributs de cookie sont la partie à retenir. **`httpOnly`** empêche le JavaScript de lire le cookie : même en cas de XSS (leçon 09), le jeton de session n'est pas volable. **`secure`** interdit l'envoi en clair. **`sameSite`** limite l'envoi depuis un autre site, ce qui bloque la plupart des attaques CSRF.

Et le stockage en mémoire par défaut d'`express-session` ne convient pas en production : il perd toutes les sessions au redémarrage, et il ne fonctionne pas avec plusieurs instances (palier 7, *statelessness*).

### Les JWT

```bash
npm install jsonwebtoken
```

```ts
import jwt from "jsonwebtoken";

export const signerJeton = (u: Utilisateur) =>
  jwt.sign(
    { sub: u.id, role: u.role },                     // le "payload" — PUBLIC, pas chiffré
    config.JWT_SECRET,
    { expiresIn: "15m" }                              // ⭐ courte durée
  );

export function verifierJeton(jeton: string) {
  return jwt.verify(jeton, config.JWT_SECRET) as { sub: number; role: string };
}
```

> ⚠️ **Un JWT est signé, pas chiffré.** Son contenu est lisible par n'importe qui — colle un jeton sur jwt.io et tu verras ses données en clair. La signature garantit qu'il n'a pas été **modifié**, pas qu'il est **secret**. Donc : jamais de donnée sensible dans un jeton.

### Le middleware d'authentification

```ts
// middlewares/auth.ts
export function authentifier(req: Request, res: Response, next: NextFunction) {
  const entete = req.headers.authorization;
  if (!entete?.startsWith("Bearer ")) {
    return next(new ErreurAuthentification("Authentification requise"));   // → 401
  }
  try {
    const charge = verifierJeton(entete.slice(7));
    req.utilisateur = { id: charge.sub, role: charge.role };               // on enrichit la requête
    next();
  } catch {
    next(new ErreurAuthentification("Jeton invalide ou expiré"));          // → 401
  }
}

// L'AUTORISATION par rôle — distincte
export const exigeRole = (...roles: string[]) =>
  (req: Request, _res: Response, next: NextFunction) => {
    if (!req.utilisateur) return next(new ErreurAuthentification("Non authentifié"));   // 401
    if (!roles.includes(req.utilisateur.role)) {
      return next(new ErreurAutorisation("Accès refusé"));                              // 403
    }
    next();
  };

// Usage
routeur.get("/depenses", authentifier, controleur.lister);
routeur.delete("/utilisateurs/:id", authentifier, exigeRole("admin"), controleur.supprimer);
```

Note la correspondance avec les codes HTTP de la leçon 03 : **`401` = je ne sais pas qui tu es**, **`403` = je sais, et tu n'as pas le droit**. C'est la question d'entretien que tu as déjà croisée au palier 0 — elle devient ici une implémentation.

### ⭐ La vérification de propriété : la faille qu'on oublie

```ts
// ❌ L'utilisateur est authentifié… et peut lire les dépenses de n'importe qui
routeur.get("/depenses/:id", authentifier, async (req, res) => {
  res.json(await depotDepenses.parId(Number(req.params.id)));
});

// ✅ On vérifie que la ressource lui APPARTIENT
export const serviceDepenses = {
  async parId(id: number, utilisateurId: number) {
    const depense = await depotDepenses.parId(id);
    if (!depense) throw new ErreurIntrouvable("Dépense");
    if (depense.utilisateurId !== utilisateurId) {
      throw new ErreurIntrouvable("Dépense");       // ⭐ 404, pas 403 — voir ci-dessous
    }
    return depense;
  },
};
```

**C'est la faille la plus répandue du web** (OWASP la classe en première position), et elle est très facile à produire : il suffit d'oublier une condition. Le test est simple — connecte-toi avec un compte, et essaie de lire la ressource d'un autre en changeant l'identifiant dans l'URL.

Le choix de renvoyer `404` plutôt que `403` est délibéré : un `403` révèle que la ressource **existe**, ce qui permet d'énumérer les identifiants valides. Le `404` ne dit rien.

Et note **où** cette vérification se trouve : dans le **service**, pas dans le middleware. Un middleware ne connaît pas la ressource demandée ; seul le service peut comparer son propriétaire à l'utilisateur courant.

### Limiter les tentatives de connexion

```ts
import rateLimit from "express-rate-limit";

const limiteurConnexion = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,                                           // 10 tentatives par IP et par quart d'heure
  message: { erreur: "Trop de tentatives, réessaie plus tard" },
});

routeur.post("/connexion", limiteurConnexion, controleur.connecter);
```

Sans limitation, un attaquant teste des milliers de mots de passe par minute. Avec, l'attaque par force brute devient impraticable. C'est une protection à mettre **dès la première version** — et elle correspond au code `429` de la leçon 07 du palier 0.

### Où stocker le jeton côté client

C'est une question piège fréquente, et la réponse honnête est : **aucun stockage navigateur n'est parfait**.

`localStorage` est lisible par tout script injecté : une XSS vole le jeton. Un cookie `httpOnly` n'est pas accessible au JavaScript, donc protégé de la XSS, mais il demande une protection CSRF. La mémoire seule (une variable) est perdue au rechargement.

L'approche la plus solide aujourd'hui : un **jeton d'accès de courte durée en mémoire**, et un **jeton de rafraîchissement dans un cookie `httpOnly`**. Mais la réponse à retenir pour un entretien est surtout : *le vrai remède est de ne pas avoir de XSS* (leçon 09).

---

## Les problèmes que tu vas rencontrer

**Mon mot de passe ne correspond jamais à la connexion.** Tu compares un mot de passe en clair à un autre mot de passe en clair, ou tu hache deux fois, ou ta colonne est trop courte (une empreinte bcrypt fait 60 caractères).

**Deux hachages du même mot de passe donnent des résultats différents.** C'est **normal** : le sel est aléatoire. C'est pourquoi on utilise `bcrypt.compare` et jamais une égalité de chaînes.

**Mon jeton est rejeté alors qu'il vient d'être créé.** Secret différent entre signature et vérification (deux valeurs d'environnement), ou décalage d'horloge, ou tu as oublié de retirer le préfixe `Bearer `.

**Mon cookie n'est pas envoyé par le navigateur.** Avec un domaine différent, il faut `credentials: "include"` côté `fetch` **et** `credentials: true` dans la configuration CORS. Et `secure: true` empêche l'envoi en HTTP — donc en local sans HTTPS.

**Mes sessions disparaissent au redémarrage.** Stockage en mémoire. Redis en production.

**N'importe quel utilisateur connecté lit les données des autres.** La vérification de propriété manque. C'est une faille, pas un bug.

**Mon middleware d'authentification ne protège pas une route.** Il est déclaré après (leçon 02).

**Mon jeton révèle des informations.** Tu as mis des données sensibles dans la charge utile. Un JWT n'est pas chiffré.

**Un utilisateur banni continue d'accéder à l'application.** Son jeton est encore valide. C'est le défaut intrinsèque du JWT : durées courtes, et une liste de révocation si c'est critique.

---

## Ce qu'on te demandera

C'est **le sujet de sécurité le plus abordé en entretien**, tous niveaux confondus.

Les questions quasi certaines : **« pourquoi hache-t-on un mot de passe au lieu de le chiffrer ? »**, **« qu'est-ce qu'un sel et à quoi sert-il ? »**, **« sessions ou JWT, et pourquoi ? »**, « différence entre `401` et `403` », « où stockes-tu un jeton côté client ? » (et la bonne réponse expose les compromis au lieu d'affirmer).

Et une question qui distingue nettement : **« comment empêches-tu un utilisateur connecté de lire les données d'un autre ? »**. Beaucoup de candidats parlent de rôles ; la bonne réponse mentionne la vérification de **propriété** dans la couche métier.

En **test technique**, on testera l'accès croisé entre deux comptes. C'est l'épreuve A3 de ton évaluation de palier.

---

## Ce qui te démarquera

**Le même message d'erreur pour un email inconnu et un mot de passe faux.** Détail d'une ligne, et il montre que tu penses comme un attaquant.

**La vérification de propriété dans les services.** C'est la faille n°1 du web, et savoir où la traiter te place immédiatement au-dessus.

**Le `404` plutôt que le `403` sur une ressource qui ne t'appartient pas.** Raisonnement de divulgation d'information, rarement maîtrisé à ce niveau.

**Les trois attributs de cookie**, et savoir ce que chacun protège.

**La limitation du débit sur la connexion dès la première version.**

**Savoir qu'un JWT ne se révoque pas.** Et proposer la durée courte plus le rafraîchissement. C'est la limite que beaucoup de gens découvrent en production.

**Et savoir dire qu'en entreprise on n'écrit pas son authentification à la main** — tout en étant capable de l'écrire. C'est exactement la position d'un bon développeur : comprendre l'outil qu'on délègue.

---

## 📚 À lire

**OWASP → *Authentication Cheat Sheet*** et ***Password Storage Cheat Sheet*** : ce sont les références professionnelles du sujet, concrètes et directement applicables. Lis-les — c'est une heure, et c'est ce que lisent les gens qui t'évalueront.

**OWASP → *Broken Access Control*** (le point A01 du Top 10) pour la vérification de propriété.

**jwt.io** pour décoder un jeton et constater que son contenu est lisible — l'expérience vaut mieux que l'explication.

**MDN → *HTTP cookies***, section sur `httpOnly`, `Secure` et `SameSite`.

Et la documentation de **bcrypt** pour le paramètre de coût. Évite les tutoriels de blog sur ce sujet : la sécurité est un domaine où les contenus périmés sont dangereux.

---

## 🤖 Le mini-projet à demander à l'IA

L'exercice le plus formateur est de se faire attaquer son propre système.

> « Je suis en formation de développeur, palier 4. J'ai implémenté une authentification : inscription, connexion, hachage bcrypt, jeton JWT, middleware d'authentification et middleware de rôle. Joue le rôle d'un **testeur de sécurité** : donne-moi **15 tests d'intrusion** à mener sur mon API, décrits comme des objectifs (« essaie de lire les données d'un autre utilisateur », « essaie de deviner si un email est inscrit », « essaie de forger un jeton », « essaie de rejouer un jeton expiré », « cherche une information sensible dans les réponses »…). **Ne me dis pas comment me protéger.** Pour chaque test, je te dis ce que j'ai obtenu, et tu me dis si c'est une faille — et de quelle catégorie OWASP elle relève. »

Les quinze tests révéleront probablement trois ou quatre vraies failles dans ta première implémentation. C'est l'intérêt de l'exercice, et c'est ce que fait un audit.

Puis l'arbitrage d'architecture, qui prépare le palier 7 :

> « Décris-moi **6 contextes d'application différents** (un site web classique sur un domaine, une application mobile, une API consommée par trois services internes, une application avec connexion Google, un back-office interne, une API publique pour des clients tiers). Pour chacun, demande-moi : **session ou jeton ?**, quelle durée de vie, où stocker côté client, et comment je révoque un accès. Corrige mon raisonnement en pointant les conséquences que j'ai manquées. »

---

## 🛠️ À faire

1. **Inscription** : hachage bcrypt avec un coût de 12, contrainte d'unicité sur l'email, et une réponse **sans** l'empreinte.
2. **Vérifie le sel** : hache deux fois le même mot de passe et constate que les empreintes diffèrent. Explique pourquoi `compare` fonctionne quand même.
3. **Connexion** : avec le **même message d'erreur** dans les deux cas d'échec. Teste avec un email inconnu puis un mauvais mot de passe, et vérifie que les réponses sont identiques.
4. **Implémente les deux approches** : une version avec session + cookie, une version avec JWT. Note dans ton journal ce que chacune t'a demandé.
5. **Les attributs de cookie** : `httpOnly`, `secure`, `sameSite`. Essaie de lire le cookie avec `document.cookie` dans la console du navigateur et constate que c'est impossible.
6. **Décode ton JWT** sur jwt.io. Constate que le contenu est lisible. Écris la conclusion dans ton journal.
7. **Middleware d'authentification** : `401` si absent ou invalide. Teste sans en-tête, avec un jeton malformé, et avec un jeton expiré.
8. **Middleware de rôle** : `403` si le rôle ne suffit pas. Vérifie la distinction `401`/`403`.
9. **⚠️ L'exercice central** : crée deux comptes, connecte-toi avec le premier, et essaie de lire, modifier puis supprimer une dépense du second en changeant l'identifiant dans l'URL. **Si ça marche, tu viens de trouver une faille dans ton code.** Corrige avec la vérification de propriété dans le service.
10. **Le `404` plutôt que `403`** : sur une ressource qui existe mais ne t'appartient pas. Explique le choix.
11. **Limitation de débit** : dix tentatives par quart d'heure sur la connexion. Teste avec une boucle de vingt requêtes `curl`.
12. **Expiration** : un jeton de quinze minutes. Attends l'expiration (ou signe un jeton de cinq secondes) et vérifie le `401`.
13. **Démontre la non-révocation** : connecte un utilisateur, « bannis »-le en base, et constate qu'il peut continuer avec son jeton. Écris la conséquence dans ton journal.
14. **Fuite d'empreinte** : renvoie volontairement l'objet utilisateur complet, regarde la réponse dans l'onglet Réseau, puis corrige.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** Chaque appel à `hash` génère un sel aléatoire, incorporé à l'empreinte produite. `compare` extrait ce sel de l'empreinte stockée, rehache le mot de passe fourni avec **ce** sel, et compare les résultats. C'est pourquoi une égalité de chaînes ne fonctionnerait jamais — et c'est une question d'entretien classique.

**3.** Si les deux réponses diffèrent (même par le temps de réponse, puisque la comparaison bcrypt n'est faite que lorsque l'utilisateur existe), un attaquant peut **énumérer** les comptes. Une implémentation rigoureuse exécute un hachage factice même quand l'email est inconnu, pour égaliser les temps.

**9.** C'est l'exercice le plus important de la leçon. Dans une première implémentation, l'accès croisé **fonctionne presque toujours** : le middleware a vérifié que tu es connecté, mais personne n'a vérifié que la dépense t'appartient. C'est *Broken Access Control*, classé **premier** du Top 10 OWASP — c'est-à-dire la faille la plus répandue du web. Et la correction se place dans le **service**, parce que seul lui connaît la ressource demandée.

**13.** Le jeton reste valide jusqu'à son expiration : le serveur ne consulte pas la base pour le vérifier, puisque c'est tout l'intérêt d'un jeton autonome. Les parades sont une durée de vie courte, une liste de révocation (qui réintroduit de l'état côté serveur, donc annule partiellement l'avantage), ou un changement de secret de signature. **Avec une session, il suffisait de supprimer la session.** C'est le compromis central du tableau, et l'avoir vécu permet de le défendre en entretien.

**14.** L'empreinte bcrypt se retrouve visible dans l'onglet Réseau. Elle n'est pas directement exploitable — c'est une empreinte, pas un mot de passe — mais elle permet une attaque hors ligne : l'attaquant peut tester des millions de candidats sur sa propre machine, sans limitation de débit. C'est pour cette raison que l'empreinte ne doit **jamais** sortir du serveur, et que le rest `({ empreinte, ...reste }) => reste` du palier 3 est un réflexe de sécurité.
</details>

---

## ✅ Acquis si…

- [ ] J'explique pourquoi on **hache** un mot de passe et non pas on le chiffre.
- [ ] Je sais ce qu'est un **sel** et pourquoi deux hachages diffèrent.
- [ ] Je n'utilise que bcrypt ou argon2, jamais MD5 ni SHA-256.
- [ ] Mon message d'erreur de connexion est **identique** dans les deux cas d'échec.
- [ ] Je n'expose **jamais** l'empreinte dans une réponse d'API.
- [ ] J'ai implémenté les deux approches, session et JWT, et je sais exposer l'arbitrage.
- [ ] Je connais les trois attributs de cookie et ce que chacun protège.
- [ ] Je sais qu'un JWT est signé mais **lisible**, et qu'il ne se révoque pas.
- [ ] Je distingue `401` et `403` dans mon code.
- [ ] **J'ai tenté l'accès croisé entre deux comptes** et corrigé la faille par une vérification de propriété dans le service.
- [ ] Ma route de connexion est protégée par une limitation de débit.

# Leçon 04 — Validation (Zod), erreurs centralisées, configuration et secrets

> 🎯 **À la fin de cette leçon** : plus aucune donnée non vérifiée n'entre dans ton application, et tes secrets ne sont plus dans ton code.
> ⏱️ 4 h · **Prérequis** : leçons 01–03, et la leçon 01 du palier 3 (ce que TypeScript ne vérifie pas).

---

## De quoi on parle

La **validation** consiste à vérifier, **à l'exécution**, que des données entrantes ont bien la forme attendue — et à refuser proprement si ce n'est pas le cas.

**Zod** est une bibliothèque qui déclare un schéma et en déduit le type TypeScript :

```ts
const schemaDepense = z.object({
  montant: z.number().int().positive(),
  categorie: z.enum(["food", "transport", "autre"]),
  description: z.string().min(1).max(200),
});

type NouvelleDepense = z.infer<typeof schemaDepense>;    // ⭐ le type vient du schéma
```

La **gestion centralisée des erreurs** traduit les exceptions de ton application en réponses HTTP cohérentes, à un seul endroit.

La **configuration** rassemble ce qui change d'un environnement à l'autre : port, adresse de base de données, clés d'API. Elle vit dans des **variables d'environnement**, et les **secrets** n'entrent jamais dans Git.

---

## À quoi ça sert, concrètement

**Parce que c'est la seule barrière réelle.** Tu l'as entendu au palier 0, vécu au palier 2 et confirmé au palier 3 : la validation du client est du confort, celle du serveur protège. C'est **ici** que la promesse se tient. Sans cette leçon, toute ton API accepte n'importe quoi.

**Parce que TypeScript ne le fait pas.** C'est le point que tu as démontré au palier 3 : `req.body as NouvelleDepense` est une affirmation, pas une vérification. Le compilateur te croit, et un client malveillant ou simplement bogué envoie ce qu'il veut. Zod comble exactement ce trou — et il te rend le type en prime, donc tu ne déclares plus la même forme deux fois.

**Parce qu'un secret dans Git est un secret compromis.** Tu l'as appris au palier 0 (leçon 04) ; ici tu passes à la pratique, et la règle devient structurelle : `.env` ignoré, `.env.example` commité, et une validation de la configuration au démarrage.

**Et parce que des erreurs cohérentes rendent ton API utilisable.** Un client qui reçoit toujours la même forme d'erreur écrit un seul traitement. C'est le contrat de la leçon 03, appliqué.

---

## Où ça intervient dans le développement

Cette leçon place un filtre à l'entrée de ton système :

```
   CLIENT — peut envoyer n'importe quoi
     │
     ▼
   ┌─────────────────────────────────────────────┐
   │ VALIDATION (Zod)   ← LA barrière            │
   │   données conformes ? sinon → 400/422       │
   └──────────────────┬──────────────────────────┘
                      ▼
   le reste de ton code travaille sur des données SÛRES
   (et typées, puisque le type vient du schéma)
                      │
                      ▼
   BASE DE DONNÉES — dernière ligne : contraintes NOT NULL, UNIQUE (leçon 06)
```

Trois choses à retenir pour la suite.

**Il y a trois niveaux de défense, et ils ne se remplacent pas.** Le client valide pour le confort, le serveur valide pour la sécurité, la base contraint pour l'intégrité. Un développeur junior en met un ; un développeur expérimenté en met trois.

**Tout ce qui entre est suspect, pas seulement le corps.** Les paramètres d'URL, la query string, les en-têtes, les variables d'environnement, les réponses des API tierces. Les variables d'environnement surprennent : ce sont **toujours des chaînes**, et un `PORT` absent donne `undefined`, pas une valeur par défaut.

**Et cette validation se retrouvera dans les trois backends.** Au palier 5, Pydantic fait exactement ce que fait Zod — déclarer un schéma, valider, en déduire le type, et générer la documentation. Au palier 6, les règles de validation de Laravel jouent le même rôle. Même concept, trois écosystèmes : c'est encore un transfert que le parcours prépare.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas tester ton API avec `curl` en envoyant des données absurdes — un montant négatif, une chaîne au lieu d'un nombre, un champ manquant, un objet imbriqué inattendu. Et tu vas voir ton code planter avec un `500` au lieu de refuser proprement avec un `400`.

C'est l'exercice central : **attaquer sa propre API** avant qu'un autre le fasse.

### En équipe, en entreprise

**Chaque entrée est validée, et c'est non négociable.** Dans une base de code sérieuse, aucune route ne touche `req.body` sans schéma. Les relecteurs le vérifient.

**Zod est devenu un standard de l'écosystème TypeScript.** Tu le retrouveras côté frontend (avec React Hook Form, palier 3), côté backend, et parfois partagé entre les deux dans un paquet commun — ce qui garantit que les deux côtés valident la même chose.

**Les secrets passent par un gestionnaire.** En développement, un `.env` local. En production, les variables d'environnement de la plateforme (Render, palier 4) ou un coffre dédié. Jamais un fichier dans le dépôt.

**Et tu verras des fuites.** Des clés d'API dans l'historique Git, des traces d'erreur complètes renvoyées au client, des messages d'erreur qui révèlent la structure de la base. Ces trois cas sont des vulnérabilités réelles, et les deux derniers sont exactement ce que `DEBUG = False` évite au palier 5.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `z.object`, `z.string`, `z.number`, `z.enum`, `z.boolean`, `.optional()`, `.min()`/`.max()`, `safeParse`, `z.infer`, un middleware de validation, un middleware d'erreurs, `process.env` validé au démarrage.

Régulièrement : `.refine()` pour une règle métier, `z.coerce` pour les chaînes des query strings, les schémas imbriqués, `.partial()` pour les mises à jour, des classes d'erreur métier.

Rare, et hors sujet pour l'instant : les transformations complexes, les schémas récursifs, les unions discriminées Zod, `brand`, la génération de documentation depuis les schémas (tu verras l'équivalent au palier 5), les gestionnaires de secrets type Vault. Et une chose à savoir : il existe des alternatives (Valibot, plus léger ; Joi, plus ancien) — le concept est identique.

---

## La mécanique

### Zod : déclarer puis valider

```bash
npm install zod
```

```ts
// schemas/depense.ts
import { z } from "zod";

export const schemaCreation = z.object({
  montant: z.number().int().positive(),                    // entier, en centimes
  categorie: z.enum(["food", "transport", "loyer", "autre"]),
  description: z.string().trim().min(1).max(200),
  date: z.string().date(),                                  // format YYYY-MM-DD
  note: z.string().max(1000).optional(),
});

export const schemaMiseAJour = schemaCreation.partial();    // tous les champs optionnels

export type NouvelleDepense = z.infer<typeof schemaCreation>;
export type MiseAJourDepense = z.infer<typeof schemaMiseAJour>;
```

Observe le gain : **un seul endroit** décrit la forme des données. Le type TypeScript en est déduit, donc il ne peut pas se désynchroniser du contrôle. C'est précisément le problème que tu avais identifié au palier 3 (`as` est une affirmation) — ici, l'affirmation est **vérifiée**.

### `parse` ou `safeParse`

```ts
// parse : lève une exception si invalide → attrapée par le middleware d'erreurs
const donnees = schemaCreation.parse(req.body);

// safeParse : retourne un résultat, sans exception
const resultat = schemaCreation.safeParse(req.body);
if (!resultat.success) {
  return res.status(400).json(formaterErreursZod(resultat.error));
}
const donnees = resultat.data;        // ⭐ typé NouvelleDepense, garanti conforme
```

`safeParse` donne un contrôle explicite ; `parse` avec un middleware d'erreurs centralisé évite de répéter le même bloc partout. Les deux se défendent — choisis-en un et sois cohérent.

### Un middleware de validation

```ts
// middlewares/valider.ts
import type { ZodSchema } from "zod";

export const valider = (schema: ZodSchema, source: "body" | "query" | "params" = "body") =>
  (req: Request, _res: Response, next: NextFunction) => {
    const resultat = schema.safeParse(req[source]);
    if (!resultat.success) return next(new ErreurValidation(resultat.error));
    req[source] = resultat.data;       // ⭐ on REMPLACE par les données validées et converties
    next();
  };

// Usage
routeur.post("/", valider(schemaCreation), asyncHandler(controleur.creer));
routeur.get("/", valider(schemaFiltres, "query"), asyncHandler(controleur.lister));
```

Le remplacement de `req.body` par `resultat.data` est le détail qui compte : à partir de là, le contrôleur travaille sur des données **converties** (les chaînes en nombres, les dates en objets) et garanties conformes.

### La query string : le piège des chaînes

```ts
// ❌ req.query.page est une CHAÎNE (ou un tableau, ou undefined)
const schemaFiltresNaif = z.object({ page: z.number() });     // échouera toujours

// ✅ z.coerce convertit avant de valider
export const schemaFiltres = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limite: z.coerce.number().int().min(1).max(100).default(20),   // ⭐ le plafond, ici
  categorie: z.enum(["food", "transport", "loyer", "autre"]).optional(),
  tri: z.enum(["date", "-date", "montant", "-montant"]).default("-date"),
});
```

Tu reconnais la frontière de la leçon 01 du palier 1, pour la quatrième fois — et c'est ici qu'elle se traite enfin **une seule fois, de façon déclarative**. Note aussi que le plafond de pagination de la leçon 03 est maintenant exprimé dans le schéma : `.max(100)`.

### Les règles métier dans le schéma

```ts
export const schemaPeriode = z.object({
  debut: z.string().date(),
  fin: z.string().date(),
}).refine(p => p.debut <= p.fin, {
  message: "La date de début doit précéder la date de fin",
  path: ["fin"],                       // l'erreur sera rattachée au bon champ
});
```

`.refine()` couvre les règles qui portent sur **plusieurs champs**. Attention toutefois à la frontière : une règle de **format** va dans le schéma, une règle qui exige la **base de données** (« cette catégorie existe-t-elle ? », « ce budget est-il dépassé ? ») va dans le service (leçon 03).

### ⭐ Le middleware d'erreurs complet

```ts
// erreurs/metier.ts
export class ErreurMetier extends Error {
  constructor(message: string, public readonly code = "METIER") { super(message); }
}
export class ErreurIntrouvable extends ErreurMetier {
  constructor(quoi: string) { super(`${quoi} introuvable`, "INTROUVABLE"); }
}
export class ErreurValidation extends ErreurMetier {
  constructor(public readonly zodError: ZodError) { super("Données invalides", "VALIDATION"); }
}
```

```ts
// middlewares/erreurs.ts — en DERNIER, avec QUATRE paramètres
export function gestionnaireErreurs(
  erreur: unknown, _req: Request, res: Response, _next: NextFunction
) {
  if (erreur instanceof ErreurValidation) {
    return res.status(400).json({
      erreur: "Les données envoyées sont invalides",
      code: "VALIDATION",
      champs: Object.fromEntries(
        erreur.zodError.issues.map(i => [i.path.join("."), i.message])
      ),
    });
  }
  if (erreur instanceof ErreurIntrouvable) {
    return res.status(404).json({ erreur: erreur.message, code: erreur.code });
  }
  if (erreur instanceof ErreurMetier) {
    return res.status(422).json({ erreur: erreur.message, code: erreur.code });
  }

  // Inattendu : c'est un BUG
  console.error(erreur);                                       // la trace, pour nous
  res.status(500).json({ erreur: "Erreur interne", code: "INTERNE" });   // neutre, pour le client
}
```

Tu retrouves la distinction de la leçon 08 du palier 1 — erreurs attendues contre bugs — et la structure d'erreur unique de la leçon 03. Les trois leçons convergent ici.

> ⚠️ **Ne renvoie jamais le détail d'une erreur inattendue au client.** Une trace révèle tes chemins de fichiers, tes versions de bibliothèques et parfois des fragments de requêtes SQL. C'est une fuite d'information exploitable, et c'est exactement ce que tu reverras au palier 5 avec `DEBUG = False`.

### La configuration et les secrets

```ts
// config.ts — validé AU DÉMARRAGE
import { z } from "zod";

const schemaEnv = z.object({
  NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
  PORT: z.coerce.number().int().default(3000),
  DATABASE_URL: z.string().url(),                 // obligatoire
  JWT_SECRET: z.string().min(32),                  // obligatoire, et assez long
  ORIGINE_AUTORISEE: z.string().url().optional(),
});

const resultat = schemaEnv.safeParse(process.env);
if (!resultat.success) {
  console.error("❌ Configuration invalide :", resultat.error.flatten().fieldErrors);
  process.exit(1);                                 // ⭐ on refuse de démarrer
}

export const config = resultat.data;               // typé, garanti présent
```

**Refuser de démarrer** est le bon comportement : mieux vaut un serveur qui ne démarre pas avec un message clair qu'un serveur qui démarre et plante à la première requête parce que `DATABASE_URL` était `undefined`. C'est le principe « échouer tôt » de la leçon 08 du palier 1, appliqué au déploiement — et tu l'apprécieras au palier 8.

```gitignore
# .gitignore
.env
.env.local
*.pem
```

```bash
# .env.example — COMMITÉ, avec des valeurs factices
PORT=3000
DATABASE_URL=postgresql://utilisateur:motdepasse@localhost:5432/depenses
JWT_SECRET=remplacer-par-32-caracteres-aleatoires-minimum
ORIGINE_AUTORISEE=http://localhost:5173
```

Le `.env.example` est un livrable : il documente ce qu'il faut configurer, et il permet à un nouveau développeur de démarrer en copiant le fichier. C'est aussi ce que ton épreuve de sortie demande.

---

## Les problèmes que tu vas rencontrer

**Mon API renvoie un `500` au lieu d'un `400` sur une donnée invalide.** La validation manque : le code a planté plus loin, sur un champ absent ou un type inattendu.

**Ma validation de query string échoue toujours.** Les valeurs sont des chaînes. `z.coerce`.

**`JSON.parse` plante avant même ma validation.** Un corps JSON malformé est rejeté par `express.json()`, qui lève une erreur — ton middleware d'erreurs doit la traiter en `400` plutôt qu'en `500`.

**Mes messages d'erreur Zod sont illisibles pour le client.** Le format brut de Zod est pensé pour le développeur. Formate-le en `{ champ: message }`, comme dans le middleware ci-dessus.

**Mon serveur démarre et plante à la première requête.** Une variable d'environnement manquante. Valide la configuration au démarrage.

**J'ai commité mon `.env`.** Change **tous** les secrets qu'il contenait, immédiatement. Puis ajoute-le au `.gitignore`. Le retirer de l'historique ne suffit pas (palier 0, leçon 04).

**Mes secrets fonctionnent en local et pas en production.** Les variables ne sont pas configurées sur la plateforme. Chaque environnement a les siennes, et `.env` n'est pas déployé.

**Mon message d'erreur révèle ma structure de base** (`column "montnat" does not exist`). Tu renvoies l'erreur brute de la base. Message neutre, trace journalisée.

**Je valide deux fois la même chose, avec deux définitions différentes.** C'est le problème que `z.infer` résout : un schéma, un type.

---

## Ce qu'on te demandera

En **entretien**, c'est l'une des questions de sécurité les plus posées : **« la validation côté client suffit-elle ? »** — et la bonne réponse explique pourquoi non, avec `curl` comme argument. Suit : « où valides-tu, et quoi ? ».

Autres questions fréquentes : « comment gères-tu les secrets ? », « que renvoies-tu au client quand ton code plante ? », « quelle différence entre `400` et `422` ? », « TypeScript ne suffit-il pas à valider ? » (la question piège du palier 3, et tu as la réponse).

En **test technique**, on enverra des données invalides à ton API pour voir si elle refuse proprement.

En **revue de code**, une route qui touche `req.body` sans schéma est signalée systématiquement.

---

## Ce qui te démarquera

**Attaquer sa propre API.** Envoyer volontairement des données absurdes avant de livrer est une démarche de professionnel, et c'est l'exercice de cette leçon.

**Un schéma unique qui produit le type.** Savoir expliquer que `z.infer` supprime la duplication entre la validation et le typage montre que tu as compris l'articulation entre les deux mondes.

**Valider la configuration au démarrage et refuser de démarrer.** Très peu de juniors le font, et ça évite les pannes les plus stupides en production.

**Un `.env.example` à jour.** Détail minuscule, impact réel sur l'intégration d'un nouveau développeur — et c'est ce qui sera jugé dans ton README.

**Ne jamais fuiter une trace.** Et savoir expliquer ce qu'une trace révèle.

**Les trois niveaux de défense.** Client, serveur, base. Pouvoir les énumérer et dire pourquoi aucun ne remplace les autres est un raisonnement d'architecture.

---

## 📚 À lire

**zod.dev** : la documentation est courte et bien faite. Lis *Basic usage*, *Primitives*, *Objects*, *Coercion* et *Error handling*.

**OWASP → *Input Validation Cheat Sheet*** : la référence professionnelle sur le sujet. Parcours-la ; tu reverras OWASP en détail à la leçon 09.

**The Twelve-Factor App → *Config*** (12factor.net/config) : une page, et c'est le texte fondateur de la pratique des variables d'environnement. Tu le recroiseras au palier 8.

**expressjs.com → *Production best practices: performance and reliability***, section sur la gestion des erreurs.

---

## 🤖 Le mini-projet à demander à l'IA

L'exercice le plus formateur est de se faire attaquer.

> « Je suis en formation de développeur, palier 4. J'ai une API Express avec une route `POST /depenses` qui accepte `montant` (entier, centimes), `categorie` (parmi quatre valeurs), `description` (1 à 200 caractères) et `date` (format YYYY-MM-DD). Joue le rôle d'un **client hostile ou bogué** : donne-moi **20 requêtes `curl`** qui envoient des données que mon API devrait refuser (types inattendus, champs manquants, champs en trop, valeurs limites, chaînes vides, nombres négatifs, très grands nombres, objets imbriqués, tableaux au lieu de valeurs, JSON malformé, corps vide, mauvais `Content-Type`, corps énorme, caractères de contrôle, injection tentée). **Ne me dis pas ce qui devrait se passer** : je dois prédire le code de statut attendu pour chacune, puis tester. Confirme ou corrige mes prédictions. »

Vingt requêtes, et tu trouveras au moins cinq trous dans ta validation. C'est exactement ce que fait un test de sécurité.

Puis la partie configuration :

> « Décris-moi, sans code, les 10 variables de configuration d'une API de production réaliste (base de données, port, secret de jeton, origine autorisée, niveau de journalisation, clé d'un service tiers, environnement, URL publique…). Pour chacune, demande-moi : est-elle obligatoire ? a-t-elle une valeur par défaut raisonnable ? est-ce un **secret** ? que doit-il se passer si elle est absente au démarrage ? Corrige mes réponses, et dis-moi lesquelles je ne devrais jamais journaliser. »

---

## 🛠️ À faire

1. **Installe Zod** et écris les schémas de création, de mise à jour (avec `.partial()`) et de filtres (avec `z.coerce`).
2. **Déduis les types avec `z.infer`** et supprime tes types écrits à la main. Vérifie qu'il ne reste **aucune** duplication.
3. **Middleware de validation** générique, applicable au corps, à la query et aux params.
4. **⚠️ Attaque ton API** : envoie les vingt requêtes invalides de l'exercice IA. Note pour chacune le code obtenu, et corrige tous les cas qui renvoient `500` au lieu de `400`.
5. **Un `.refine()`** : une règle sur deux champs (par exemple, une date de fin postérieure à une date de début).
6. **Le plafond de pagination** dans le schéma de filtres (`.max(100)`), et teste `?limite=999999`.
7. **Classes d'erreur métier** : `ErreurMetier`, `ErreurIntrouvable`, `ErreurValidation`. Lève-les depuis tes services, **sans code HTTP**.
8. **Middleware d'erreurs complet** : `400` pour la validation avec les champs détaillés, `404`, `422` pour le métier, `500` neutre pour le reste.
9. **Démontre la fuite** : renvoie volontairement l'erreur brute d'une exception dans la réponse, provoque une erreur de base de données, et regarde ce que le client reçoit. Note ce que ça révèle, puis corrige.
10. **Configuration validée** : `config.ts` avec un schéma Zod, et `process.exit(1)` si invalide. Démarre sans `DATABASE_URL` et constate le message.
11. **Secrets** : `.env` dans `.gitignore`, `.env.example` commité et à jour. Vérifie avec `git status` qu'aucun secret n'est suivi.
12. **Le corps malformé** : envoie `curl -d '{invalide'` et assure-toi d'obtenir un `400` propre, pas un `500`.

<details>
<summary>Corrections et points de contrôle</summary>

**2.** Le contrôle : cherche dans ton projet toute déclaration `type NouvelleDepense = { … }` écrite à la main. Il ne devrait en rester aucune — tout doit venir de `z.infer`. Sinon tu as deux sources de vérité, et elles divergeront : c'est exactement le problème que le palier 3 avait mis en évidence avec `as`.

**4.** Les trous les plus fréquents que tu vas trouver : les **champs en trop** (Zod les ignore par défaut — utilise `.strict()` si tu veux les refuser), les **très grands nombres** (ajoute `.max()`), les **chaînes avec des espaces seulement** (`.trim().min(1)` et non `.min(1)`), le **corps vide** (`express.json()` donne `{}`), et le **mauvais `Content-Type`** (le corps n'est alors pas parsé et `req.body` est vide).

**9.** Une erreur brute de PostgreSQL révèle les noms de tes tables et colonnes, et parfois un fragment de la requête. Un attaquant cartographie ainsi ta base sans effort — c'est la première étape d'une injection SQL (leçon 09). Et une trace Node révèle tes chemins de fichiers et tes versions de dépendances, donc les vulnérabilités connues applicables. **Message neutre pour le client, trace dans les journaux du serveur, toujours.**

**10.** Le message attendu ressemble à :
```
❌ Configuration invalide : { DATABASE_URL: [ 'Required' ] }
```
et le processus s'arrête. C'est très supérieur à un démarrage suivi d'un plantage à la première requête : au palier 8, ton pipeline de déploiement détectera l'erreur immédiatement au lieu de livrer un service cassé.

**12.** Un JSON malformé fait lever une erreur par `express.json()` **avant** ta route. Pour la traiter proprement :
```ts
if (erreur instanceof SyntaxError && "body" in erreur) {
  return res.status(400).json({ erreur: "Corps JSON invalide", code: "JSON" });
}
```
Sans ce cas, tu renvoies un `500` pour une faute du client — et tu brouilles ta surveillance, puisque les `5xx` sont censés signaler **tes** bugs.
</details>

---

## ✅ Acquis si…

- [ ] Aucune de mes routes ne touche `req.body`, `req.query` ou `req.params` sans schéma.
- [ ] Mes types viennent de `z.infer` : **une seule** source de vérité.
- [ ] J'utilise `z.coerce` pour les query strings, et je sais pourquoi.
- [ ] J'ai attaqué ma propre API avec vingt requêtes invalides et corrigé tous les `500`.
- [ ] Mes erreurs métier n'ont **aucun** code HTTP ; la traduction se fait au middleware.
- [ ] Mon API a un format d'erreur unique, avec les champs détaillés en validation.
- [ ] Je ne renvoie **jamais** une trace au client, et je sais ce qu'elle révèle.
- [ ] Ma configuration est validée au démarrage, et le serveur refuse de démarrer si elle est invalide.
- [ ] `.env` est ignoré, `.env.example` est commité et à jour.
- [ ] Je cite les trois niveaux de défense et je sais pourquoi aucun ne remplace les autres.

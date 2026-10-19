# Leçon 10 — Tests unitaires et d'intégration (Vitest + Supertest)

> 🎯 **À la fin de cette leçon** : tu écris des tests qui te donnent confiance pour modifier ton code, et tu sais ce qu'il vaut la peine de tester — et ce qui n'en vaut pas la peine.
> ⏱️ 4 h · **Prérequis** : leçons 01–09. **Dernière leçon du palier.**
>
> **Après cette leçon, tu as tout pour le [projet 4](../projet.md)** — et pour la première vraie revue de code du parcours, par le référent.

---

## De quoi on parle

Un **test** est du code qui vérifie automatiquement qu'un autre code fait ce qu'on attend. On l'exécute en une commande, et il répond vert (tout va bien) ou rouge (quelque chose est cassé).

Un **test unitaire** vérifie une unité isolée — une fonction pure, une règle de validation, un calcul. Un **test d'intégration** vérifie plusieurs couches ensemble — une route qui traverse le contrôleur, le service, puis la base.

**Vitest** est le lanceur de tests moderne de l'écosystème JavaScript (compatible avec l'API de Jest, mais plus rapide et intégré à Vite). **Supertest** envoie de vraies requêtes HTTP à ton application Express, en mémoire, sans démarrer de serveur.

Et deux notions de méthode : **arranger – agir – vérifier** (la structure de tout test), et la **couverture**, qui mesure la part du code exécutée par les tests — un indicateur utile et souvent mal utilisé.

---

## À quoi ça sert, concrètement

**Parce que les tests te permettent de modifier sans peur.** C'est leur vraie valeur, et elle est contre-intuitive : on croit que les tests servent à trouver des bugs, mais leur bénéfice principal est de rendre le **changement** sûr. Au palier 7, tu refactoriseras ton projet 4 « sans changer son comportement » — et ce sont les tests qui prouveront que le comportement n'a pas changé. Sans eux, chaque modification est un pari.

**Parce qu'ils documentent le comportement attendu.** Un test bien nommé — « refuse une dépense au montant négatif » — dit ce que le code **doit** faire, de façon exécutable et qui ne peut pas devenir obsolète (un test faux devient rouge).

**Parce qu'ils figent tes corrections.** Chaque bug corrigé mérite un test qui reproduit le bug : il garantit qu'il ne reviendra pas. C'est vrai pour les failles de sécurité de la leçon 09, et pour n'importe quel bug métier.

**Et parce que l'IA génère volontiers des tests — qu'il faut savoir lire.** Le fil rouge IA de ce palier t'autorise à faire générer des tests. Mais un test que tu ne comprends pas est pire qu'aucun test : il peut passer au vert sans rien vérifier. Savoir ce qu'un bon test contient est donc une condition pour utiliser l'IA sans se tromper.

---

## Où ça interviennent les tests

Les tests se branchent sur l'architecture en couches de la leçon 03, et chaque couche appelle un type de test différent :

```
   SERVICES (logique métier, fonctions pures)   → tests UNITAIRES (rapides, nombreux)
   CONTRÔLEURS + ROUTES (via HTTP)               → tests d'INTÉGRATION (Supertest)
   couche de données                             → testée à travers l'intégration
```

C'est ici que le découpage de la leçon 03 **paie vraiment** : parce que tes services ne connaissent pas HTTP (tu l'as vérifié par un script sans Express), ils se testent en une ligne, sans rien démarrer. Un code où la logique est noyée dans les routes ne se teste qu'à travers HTTP — plus lent, plus fragile, et incapable de cibler précisément une règle.

Deux prolongements pour le parcours.

**Au palier 7, les tests sont le filet du refactoring.** Le fil rouge architecture te fera reprendre le projet 4 pour l'améliorer « sans changer le comportement » — et la seule preuve possible de cette invariance, ce sont des tests au vert.

**Au palier 8, les tests entrent dans le pipeline.** À chaque `git push`, ils s'exécutent automatiquement, et un test rouge **bloque le déploiement** (leçon 08 du palier 0 : le pipeline doit pouvoir dire non). Le `npm test` que tu écris ici devient la porte de la mise en production.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas d'abord trouver les tests pénibles à écrire, puis tu vas casser quelque chose par mégarde, voir un test rouge t'alerter, et comprendre leur intérêt. Ce déclic arrive généralement au premier refactoring.

Tu vas aussi être tenté de tout tester, y compris des choses triviales. La leçon insiste autant sur **ce qu'on ne teste pas** que sur ce qu'on teste.

### En équipe, en entreprise

**Les tests sont attendus, mais pas à 100 % de couverture.** Aucune équipe sérieuse ne vise la couverture totale : on teste la logique métier et les chemins critiques, on laisse de côté le trivial. Un chiffre de couverture est un indicateur, jamais un objectif.

**Un test rouge bloque la fusion.** Dans la plupart des équipes, une Pull Request dont les tests échouent ne peut pas être fusionnée. C'est le pipeline du palier 8.

**Tu rencontreras des tests mal écrits.** Des tests qui testent l'implémentation plutôt que le comportement (et qui cassent au moindre refactoring), des tests sans assertion réelle, des tests qui dépendent les uns des autres. Savoir reconnaître un bon test d'un mauvais est une compétence en soi.

**Et tu entendras parler de TDD** (écrire le test avant le code). C'est une pratique valable, pas une obligation. L'important à ton niveau est d'**avoir** des tests, pas de débattre de l'ordre dans lequel tu les écris.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `describe`, `it`/`test`, `expect`, les assertions courantes (`toBe`, `toEqual`, `toThrow`), les tests unitaires de fonctions pures, et les tests d'intégration de routes avec Supertest.

Régulièrement : `beforeEach`/`afterEach` pour préparer et nettoyer, une base de données de test, les cas d'erreur et les cas limites, les tests des règles d'autorisation (leçon 08).

Rare, et hors sujet pour l'instant : les mocks élaborés, les tests de bout en bout dans un navigateur (Playwright, Cypress — un sujet à part), les tests de charge, les tests de mutation, le *snapshot testing*, l'injection de dépendances pour la testabilité poussée. Et un piège : **ne teste pas les bibliothèques des autres** — tu n'as pas à tester qu'Express route correctement ou que Prisma insère.

---

## La mécanique

### Installer et lancer

```bash
npm install -D vitest supertest @types/supertest
```

```json
// package.json
{ "scripts": { "test": "vitest", "test:run": "vitest run", "coverage": "vitest run --coverage" } }
```

`vitest` tourne en continu et relance les tests concernés à chaque sauvegarde ; `vitest run` fait une passe unique (celle du pipeline).

### Un test unitaire : la structure arranger – agir – vérifier

```ts
// services/calculs.test.ts
import { describe, it, expect } from "vitest";
import { calculerTotal, filtrerParCategorie } from "./calculs.js";

describe("calculerTotal", () => {
  it("additionne les montants", () => {
    const depenses = [{ montant: 1500 }, { montant: 3000 }];   // arranger
    const total = calculerTotal(depenses);                      // agir
    expect(total).toBe(4500);                                   // vérifier
  });

  it("renvoie 0 pour une liste vide", () => {                   // ⭐ le cas limite
    expect(calculerTotal([])).toBe(0);
  });

  it("ignore les dépenses annulées", () => {                    // une RÈGLE métier
    const depenses = [{ montant: 1500, statut: "payee" }, { montant: 3000, statut: "annulee" }];
    expect(calculerTotal(depenses)).toBe(1500);
  });
});
```

Trois observations. La structure **arranger – agir – vérifier** rend chaque test lisible d'un coup d'œil. Le **cas limite** (liste vide) est aussi important que le cas normal — c'est celui qui casse en production (palier 1, leçon 03). Et chaque test porte sur **un** comportement, nommé en français : la liste des noms de tests décrit le comportement attendu du code.

### Tester les erreurs

```ts
it("refuse un montant négatif", () => {
  expect(() => validerDepense({ montant: -100 })).toThrow(ErreurValidation);
});

it("accepte une dépense valide", () => {
  expect(() => validerDepense({ montant: 1500, categorie: "food" })).not.toThrow();
});
```

Tester qu'une erreur **est** levée est aussi important que tester le chemin heureux. C'est souvent ce qu'on oublie, et c'est souvent là que sont les bugs.

### ⭐ Les tests d'intégration avec Supertest

```ts
// routes/depenses.test.ts
import { describe, it, expect, beforeEach } from "vitest";
import request from "supertest";
import { app } from "../app.js";

describe("GET /depenses", () => {
  it("renvoie 401 sans authentification", async () => {
    const r = await request(app).get("/depenses");
    expect(r.status).toBe(401);
  });

  it("renvoie les dépenses de l'utilisateur authentifié", async () => {
    const r = await request(app)
      .get("/depenses")
      .set("Authorization", `Bearer ${jetonDeTest}`);
    expect(r.status).toBe(200);
    expect(Array.isArray(r.body.donnees)).toBe(true);
  });
});

describe("POST /depenses", () => {
  it("crée une dépense et renvoie 201", async () => {
    const r = await request(app)
      .post("/depenses")
      .set("Authorization", `Bearer ${jetonDeTest}`)
      .send({ montant: 1500, categorie: "food", description: "déjeuner", date: "2026-10-19" });
    expect(r.status).toBe(201);
    expect(r.body.id).toBeDefined();
  });

  it("refuse un corps invalide avec 400", async () => {
    const r = await request(app)
      .post("/depenses")
      .set("Authorization", `Bearer ${jetonDeTest}`)
      .send({ montant: -100 });
    expect(r.status).toBe(400);
    expect(r.body.champs).toBeDefined();
  });
});
```

Supertest envoie de vraies requêtes à ton application **sans ouvrir de port** : il teste toute la chaîne — middlewares, validation, autorisation, contrôleur, service, base. C'est ce qui donne confiance qu'une route fonctionne **vraiment**, pas seulement que ses morceaux fonctionnent isolément.

Remarque ce qu'on teste en priorité : les **codes de statut** (le contrat de la leçon 03), les cas d'**erreur** (le `400`, le `401`), et les règles d'**autorisation** (la leçon 08). Ce sont les comportements qui comptent, pas le détail de la réponse.

### La base de données de test

```ts
// Une base séparée, remise à zéro avant chaque test
beforeEach(async () => {
  await prisma.depense.deleteMany();
  await prisma.categorie.deleteMany();
  await semerDonneesDeTest();                      // le script de seed de la leçon 07
});
```

Le principe : chaque test part d'un état connu, et ne dépend pas des autres. Un test qui passe seul mais échoue dans la suite (ou l'inverse) est le signe d'un état partagé — c'est le bug de test le plus courant. Utilise une base **dédiée aux tests** (`DATABASE_URL` différente), jamais ta base de développement.

### ⭐ Ce qu'on teste, et ce qu'on ne teste pas

C'est la partie la plus importante de la leçon, parce que c'est le jugement qui distingue.

**On teste en priorité** : la logique métier (les règles, les calculs, les validations), les chemins critiques (l'authentification, l'autorisation, l'argent), les cas d'erreur et les cas limites, et chaque bug corrigé.

**On ne teste pas** : le code trivial (un getter, un passe-plat sans logique), le framework lui-même (qu'Express route, que Prisma insère), les détails d'implémentation susceptibles de changer, et l'interface visuelle au pixel près.

Le critère pratique : **teste le comportement, pas l'implémentation.** Un test qui vérifie « le total d'une liste vide est 0 » reste valide même si tu réécris complètement `calculerTotal`. Un test qui vérifie « `calculerTotal` appelle `reduce` » casse au premier refactoring, et ne prouve rien d'utile.

> **La couverture est un indicateur, pas un but.** Viser 100 % conduit à tester le trivial et à écrire des tests sans valeur pour gonfler un chiffre. On vise la **confiance** : est-ce que je peux modifier ce code sans craindre de casser quelque chose sans m'en apercevoir ? Si oui, la couverture est suffisante.

### Utiliser l'IA pour générer des tests — avec discernement

Le fil rouge IA de ce palier l'autorise, et c'est un bon usage — à une condition. Fais générer les tests, puis **lis-les un par un** : vérifient-ils vraiment un comportement ? Le cas limite est-il couvert ? Un test qui n'a pas d'assertion réelle, ou qui teste l'implémentation, est à supprimer. Complète avec les cas que l'IA a oubliés — généralement les cas d'erreur et les cas limites, précisément ceux qui comptent.

Le test honnête du palier (voir le guide IA) s'applique ici : *saurais-je réécrire ce test et expliquer ce qu'il vérifie ?* Si non, tu ne l'as pas compris.

---

## Les problèmes que tu vas rencontrer

**Mon test passe mais ne vérifie rien.** Il manque une assertion, ou l'assertion est triviale (`expect(true).toBe(true)`). Un test sans `expect` utile est un faux ami.

**Mes tests passent séparément mais échouent ensemble.** Un état partagé entre tests — une base non nettoyée, une variable globale. Remets l'état à zéro dans `beforeEach`.

**Mon test d'intégration échoue parce que la base n'est pas prête.** Tu testes contre ta base de développement, ou la migration de la base de test n'a pas été appliquée.

**Mon test casse à chaque refactoring alors que le comportement est identique.** Tu testes l'implémentation, pas le comportement.

**`toBe` échoue alors que les valeurs semblent égales.** `toBe` compare par **référence** pour les objets (palier 1, leçon 04). Utilise `toEqual` pour comparer par contenu.

**Mon test asynchrone passe toujours, même quand il devrait échouer.** Tu as oublié `await`, ou le `async` sur la fonction de test : le test se termine avant la vérification. Supertest et les promesses exigent `await`.

**Ma suite est très lente.** Trop de tests d'intégration qui touchent la base, là où des tests unitaires suffiraient. La pyramide : beaucoup d'unitaires rapides, quelques intégrations.

**Je ne sais pas quoi tester.** Commence par les règles métier et les cas d'erreur. Si tu ne peux pas isoler une règle, c'est souvent que le découpage de la leçon 03 est à revoir.

---

## Ce qu'on te demandera

En **entretien**, les questions sont surtout méthodologiques : « que testes-tu en priorité ? », « différence entre test unitaire et test d'intégration ? », **« faut-il viser 100 % de couverture ? »** (la bonne réponse est non, avec l'explication), « comment testes-tu une route qui demande une authentification ? ».

Une question qui distingue : **« à quoi servent les tests, au fond ? »** — et la réponse « à pouvoir modifier le code sans peur » vaut mieux que « à trouver des bugs ».

En **test technique**, on apprécie que tu écrives quelques tests même sans qu'on te le demande, surtout sur la logique métier et les cas d'erreur.

En **revue de code** — et c'est le moment clé de ce palier, puisque le référent fait ta **première vraie revue** — on regardera si tes tests portent sur le comportement, s'ils couvrent les cas limites, et s'ils sont lisibles.

---

## Ce qui te démarquera

**Tester le comportement, pas l'implémentation.** C'est le marqueur le plus net d'une bonne culture de test, et il se voit immédiatement : tes tests survivent à un refactoring.

**Couvrir les cas d'erreur et les cas limites**, pas seulement le chemin heureux. C'est là que sont les bugs, et c'est ce que les débutants oublient.

**Savoir ce qu'on ne teste pas.** Dire « je ne teste pas ce passe-plat, il n'a pas de logique » montre du jugement, là où viser 100 % montre son absence.

**Un test par bug corrigé.** La régression ne revient pas, et c'est une discipline qu'on remarque.

**Des tests comme filet de refactoring.** Pouvoir dire « j'ai mes tests, je peux réorganiser ce code en confiance » est exactement l'état d'esprit du palier 7.

**Et lire les tests générés par l'IA au lieu de les gober.** C'est le bon usage de l'outil, et c'est précisément ce que le fil rouge du parcours cherche à installer.

---

## 📚 À lire

**vitest.dev → *Getting Started*** et ***API → expect*** : la documentation est courte et claire. Tu connais déjà l'essentiel si tu as croisé Jest.

**Documentation Supertest** (sur son dépôt GitHub) : quelques exemples suffisent, l'API est petite.

**Kent C. Dodds → *Write tests. Not too many. Mostly integration.*** et ***Testing Implementation Details*** : deux articles courts qui résument la philosophie de cette leçon mieux que n'importe quel manuel. Le second explique précisément pourquoi tester l'implémentation est une erreur.

**Martin Fowler → *Test Pyramid*** pour la répartition entre unitaires et intégration.

---

## 🤖 Le mini-projet à demander à l'IA

L'enjeu est d'apprendre à **juger** un test, puisque l'IA en génère.

> « Je suis en formation de développeur, palier 4. Je travaille les tests avec Vitest. Donne-moi **10 tests déjà écrits** pour une fonction de calcul de total de dépenses et une route Express — mais glisse dedans **des tests défectueux** : un test sans assertion réelle, un test qui vérifie l'implémentation plutôt que le comportement, un test qui dépend d'un autre, un cas limite manquant, une comparaison `toBe` là où il faut `toEqual`, un test asynchrone sans `await`. **Ne me dis pas lesquels sont mauvais.** Ma mission : les identifier, expliquer le défaut de chacun, et lister les cas importants qui ne sont pas couverts. »

Cet exercice entraîne exactement la compétence requise pour utiliser l'IA sans se faire piéger : reconnaître un test qui ne prouve rien.

Puis l'exercice de conception de tests, qui relie à tout le palier :

> « Pour une API de gestion de dépenses (création, lecture, modification, suppression, avec authentification et vérification de propriété), aide-moi à dresser **la liste des comportements à tester** — pas le code. Classe-les en : règles métier, cas d'erreur, cas limites, sécurité (accès croisé, injection, champ non autorisé). Puis dis-moi lesquels sont **unitaires** et lesquels sont d'**intégration**, et pourquoi. Enfin, dis-moi ce que je **ne devrais pas** tester, et pourquoi. »

---

## 🛠️ À faire

1. **Installe Vitest**, écris un premier test sur `calculerTotal`, et lance-le en mode continu.
2. **Les cas limites** : teste `calculerTotal` sur une liste vide, une liste d'un élément, et avec une règle métier (ignorer les dépenses annulées).
3. **Les erreurs** : teste que `validerDepense` **lève** une erreur sur un montant négatif, et n'en lève pas sur une entrée valide.
4. **`toBe` contre `toEqual`** : écris un test qui compare deux objets avec `toBe`, constate l'échec, et corrige avec `toEqual`. Explique la différence dans ton journal.
5. **Tests d'intégration** avec Supertest : les codes `200`, `201`, `400`, `401` sur tes routes de dépenses.
6. **La base de test** : configure une `DATABASE_URL` dédiée, et remets la base à zéro dans `beforeEach` avec ton script de seed.
7. **⭐ Teste la sécurité** : écris les tests de régression de la leçon 09 — un test qui vérifie qu'un utilisateur ne peut pas lire la dépense d'un autre (accès croisé → `404`), et un qui vérifie qu'un champ non autorisé est refusé.
8. **Le piège de l'asynchrone** : écris un test d'intégration **sans** `await`, constate qu'il passe même quand il devrait échouer, puis corrige.
9. **Ce qu'on ne teste pas** : identifie dans ton projet trois morceaux qu'il ne vaut pas la peine de tester, et écris pourquoi.
10. **Audite des tests générés** : fais générer par l'IA une suite de tests pour une de tes fonctions, lis-les un par un, supprime ceux qui ne vérifient rien, et complète les cas manquants.
11. **Le filet de refactoring** : avec tes tests au vert, réorganise une de tes fonctions (par exemple, remplace une boucle par un `reduce`) et vérifie que les tests restent verts. Tu viens de faire l'exercice du palier 7 en miniature.
12. **`npm test` en une commande** : assure-toi que toute la suite tourne en une commande, et qu'elle est prête pour le pipeline du palier 8.

<details>
<summary>Points de contrôle</summary>

**4.** `toBe` utilise l'égalité stricte (`===`), qui compare les objets par **référence** (palier 1, leçon 04) : deux objets au contenu identique ne sont pas « le même objet », donc `toBe` échoue. `toEqual` compare **récursivement le contenu**. La règle : `toBe` pour les primitifs, `toEqual` pour les objets et les tableaux.

**7.** Ces tests de sécurité sont les plus précieux de ta suite : ils figent les corrections de la leçon 09. Tant qu'ils sont verts, la faille d'accès croisé et l'affectation en masse ne peuvent pas revenir silencieusement. C'est la différence entre « j'ai corrigé une fois » et « la correction est garantie ».

**8.** Sans `await`, la fonction de test se termine avant que la requête Supertest ne réponde : le test se conclut par un succès par défaut, et l'assertion, exécutée trop tard, n'a aucun effet sur le résultat. C'est l'un des bugs de test les plus insidieux, parce qu'un test qui passe toujours donne une fausse confiance — pire que pas de test du tout.

**11.** C'est la démonstration de la vraie valeur des tests. Tu modifies l'intérieur d'une fonction, son comportement observable ne change pas, et les tests restent verts — donc tu as la **preuve** que tu n'as rien cassé. C'est exactement ce que tu feras à grande échelle au palier 7 sur le projet 4 entier. Sans tests, ce refactoring serait un pari ; avec eux, c'est une opération sûre.
</details>

---

## ✅ Acquis si…

- [ ] J'écris un test unitaire structuré en arranger – agir – vérifier.
- [ ] Je teste les **cas limites** et les **cas d'erreur**, pas seulement le chemin heureux.
- [ ] J'écris des tests d'intégration de routes avec Supertest, en vérifiant les codes de statut.
- [ ] Mes tests partent d'un état connu et ne dépendent pas les uns des autres.
- [ ] Je teste le **comportement**, pas l'implémentation — mes tests survivent à un refactoring.
- [ ] Je distingue `toBe` et `toEqual`, et je n'oublie jamais `await` sur un test asynchrone.
- [ ] J'ai des tests de régression pour les failles de sécurité de la leçon 09.
- [ ] Je sais ce qu'on **ne teste pas**, et pourquoi 100 % de couverture n'est pas un but.
- [ ] Je lis les tests générés par l'IA et je sais reconnaître un test qui ne prouve rien.
- [ ] Toute ma suite tourne en une commande, prête pour le pipeline.
- [ ] 🚦 **Je suis prêt pour le [projet 4](../projet.md) et l'[épreuve de sortie](../evaluation.md).**

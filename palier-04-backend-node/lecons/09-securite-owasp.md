# Leçon 09 — Sécurité : l'OWASP Top 10 en pratique

> 🎯 **À la fin de cette leçon** : tu reconnais les failles les plus répandues du web, tu sais pourquoi elles existent, et tu les corriges dans ton propre code — en vérifiant tes corrections par des tests que tu écris toi-même.
> ⏱️ 5 h · **Prérequis** : leçons 01–08.
>
> ⚠️ **Cadre de travail.** Tout ce que tu testes ici, tu le testes sur **ton** code, sur **ta** machine, pour le **durcir**. Tester une application qui ne t'appartient pas sans autorisation écrite est une infraction pénale dans tous les pays. Ce n'est pas une nuance de style : c'est la ligne entre un développeur qui sécurise son travail et un délit.

---

## De quoi on parle

L'**OWASP** (*Open Web Application Security Project*) est une organisation à but non lucratif qui publie le **Top 10** : les dix catégories de vulnérabilités les plus critiques des applications web. C'est le document de référence du métier — utilisé dans les audits, les appels d'offres et les formations.

Quatre familles nous occupent, parce qu'elles couvrent l'essentiel de ce qu'un développeur d'application peut mal faire. Le **contrôle d'accès défaillant** : un utilisateur atteint ce qui ne lui appartient pas. L'**injection** : une donnée fournie par l'utilisateur est interprétée comme du code — SQL le plus souvent. La **XSS** : du script d'autrui s'exécute dans ta page. La **CSRF** : un autre site déclenche une action au nom de ton utilisateur connecté.

Le fil conducteur de toutes ces failles est unique, et tu le connais depuis le palier 0 : **toute donnée venant du client est hostile jusqu'à preuve du contraire.**

---

## À quoi ça sert, concrètement

**Parce qu'on ne retient pas une faille qu'on a seulement lue.** Lire « l'injection SQL contourne l'authentification » produit un hochement de tête. Fabriquer la requête vulnérable, constater sur ton écran qu'une entrée bien choisie renvoie tous les enregistrements, puis la corriger et vérifier que l'attaque échoue : ça, on le retient pour de bon. La leçon est donc construite sur le cycle **reproduire → corriger → vérifier**, pas sur la mémorisation.

**Parce que ces failles restent les plus fréquentes.** Le contrôle d'accès défaillant est en **première** position du Top 10, précisément parce qu'il revient le plus dans les audits réels. L'injection y est encore après vingt-cinq ans. Ce ne sont pas des curiosités historiques.

**Parce que c'est ta responsabilité.** En début de carrière, dans une petite structure, il n'y a souvent personne d'autre. Les données de tes utilisateurs dépendent directement de ce que tu écris.

**Et parce que c'est évalué.** Pouvoir dire « j'ai reproduit une injection SQL sur mon propre projet pour comprendre le mécanisme, puis je l'ai neutralisée avec des requêtes préparées, et j'ai écrit un test qui vérifie que l'attaque échoue » est une réponse d'un tout autre niveau que « il faut faire attention ».

---

## Où ça intervient dans le développement

La sécurité n'est pas une couche qu'on ajoute à la fin : c'est une propriété de chaque couche. Et chaque défense de cette leçon existe **déjà** dans une leçon précédente — ici, on vérifie qu'elle a réellement été appliquée.

```
   CLIENT                          ← on n'y défend rien (tout y est modifiable)
     │
     ▼ HTTP
   ┌──────────────────────────────────────────────────────────┐
   │ en-têtes de sécurité (helmet), CORS, limitation de débit │
   │   ▼                                                       │
   │ AUTHENTIFICATION   (leçon 08)        → qui es-tu ?        │
   │   ▼                                                       │
   │ VALIDATION         (leçon 04)        → contre l'injection │
   │   ▼                                                       │
   │ AUTORISATION + PROPRIÉTÉ (leçon 08)  → la faille n°1      │
   │   ▼                                                       │
   │ requêtes PRÉPARÉES (leçon 05)        → contre l'injection │
   │   ▼                                                       │
   │ ÉCHAPPEMENT à l'affichage (palier 2) → contre la XSS      │
   └──────────────────────────────────────────────────────────┘
```

Trois prolongements pour le parcours.

**Les mêmes failles, dans les trois langages.** Au palier 5, l'injection se prévient avec les requêtes paramétrées de `psycopg` ou de l'ORM Django, la XSS avec l'échappement automatique de Jinja2. Au palier 6, tu **réimplémentes** ces protections en PHP natif — PDO, `htmlspecialchars`, jeton CSRF — et ce sera plus clair parce que tu auras compris le mécanisme ici.

**Au palier 8, la sécurité devient aussi opérationnelle** : HTTPS, pare-feu, SSH durci, gestion des secrets, mises à jour de dépendances. Ce sont d'autres catégories du Top 10 (mauvaise configuration, composants vulnérables).

**Et c'est un argument commercial.** Au palier 6, en posture client, « j'ai vérifié les dix points de l'OWASP » est un argument de vente autant que de technique.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire une version volontairement fragile d'une route, constater qu'une entrée malveillante produit un comportement anormal, puis durcir le code et vérifier que la même entrée est désormais rejetée. Tu garderas la mémoire de ce que tu as **neutralisé**.

Tu vas aussi reprendre tes propres corrections des leçons 04, 05 et 08 pour les mettre à l'épreuve. L'exercice 9 de la leçon 08 en a déjà révélé une.

### En équipe, en entreprise

**Des outils automatiques tournent dans le pipeline** : `npm audit` et Dependabot pour les dépendances vulnérables, des analyseurs statiques, parfois un scanner d'application. Ils attrapent les cas évidents, jamais la logique métier.

**Les revues de code posent des questions de sécurité** : « qui peut appeler cette route ? », « cette donnée vient-elle de l'utilisateur ? », « que se passe-t-il si l'identifiant n'est pas le sien ? ».

**Les audits existent.** Dans les secteurs réglementés (banque, santé, public), une application passe un test d'intrusion avant mise en production, et le rapport classe les failles par criticité.

**Et les incidents sont graves** : une fuite de données impose une notification dans beaucoup de juridictions, abîme la réputation, et peut entraîner des sanctions.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien, par réflexe : requêtes préparées partout, validation de toute entrée, vérification de propriété sur chaque ressource, échappement à l'affichage, `helmet`, HTTPS, `npm audit` avant un déploiement.

Régulièrement : limitation de débit, en-têtes CSP, revue des dépendances, gestion des secrets, journaux d'accès.

Rare, et hors sujet pour l'instant : la désérialisation non sécurisée, les attaques XML, le SSRF, la pollution de prototype, les attaques temporelles, et toute cryptographie appliquée — **n'invente jamais ton propre chiffrement**, utilise des bibliothèques éprouvées. Ces sujets existent ; ils ne sont pas du niveau d'un premier backend.

---

## La mécanique

L'approche est la même pour chaque famille : **la version fragile, le principe de l'attaque, la correction, et le test qui prouve la correction.**

### ① Contrôle d'accès défaillant — la faille n°1

Tu l'as rencontrée à la leçon 08 ; on la reprend parce qu'elle est première du Top 10.

```ts
// ❌ Fragile : authentifié, mais aucune vérification de propriété
routeur.get("/depenses/:id", authentifier, async (req, res) => {
  res.json(await depotDepenses.parId(Number(req.params.id)));
});
```

**Le principe de l'attaque** : un utilisateur connecté change l'identifiant dans l'URL pour demander la ressource d'un autre. Rien ne l'en empêche — le middleware a seulement vérifié qu'il est connecté, pas que la dépense est la sienne.

**La correction** se place dans le service (leçon 08), et renvoie `404` plutôt que `403` pour ne pas révéler l'existence de la ressource :

```ts
async parId(id: number, utilisateurId: number) {
  const depense = await depotDepenses.parId(id);
  if (!depense || depense.utilisateurId !== utilisateurId) {
    throw new ErreurIntrouvable("Dépense");          // ⭐ 404, pas 403
  }
  return depense;
}
```

Les variantes à vérifier de la même façon : modifier (`PATCH`) et supprimer (`DELETE`) une ressource d'autrui, atteindre une route d'administration avec un compte ordinaire, et l'**affectation en masse** — un corps de requête qui contient un champ non prévu, par exemple un rôle à l'inscription. C'est pour ce dernier cas qu'un schéma Zod `.strict()` (leçon 04) compte : il **refuse** les champs inattendus au lieu de les ignorer.

### ② Injection SQL

```ts
// ❌ Fragile : la donnée de l'utilisateur est insérée dans le texte de la requête
const r = await pool.query(
  `SELECT * FROM utilisateurs WHERE email = '${email}'`
);
```

**Le principe de l'attaque.** Comme la donnée est collée directement dans le texte SQL, une valeur contenant une apostrophe **ferme** la chaîne attendue et le reste de la saisie est interprété comme du **code SQL** plutôt que comme une donnée. En insérant une condition toujours vraie, un attaquant peut faire renvoyer toutes les lignes ; avec un commentaire, il neutralise la fin de la requête ; avec un point-virgule, selon le pilote, il enchaîne d'autres instructions. Le dénominateur commun : **la frontière entre code et donnée a été franchie**, et c'est toute la définition de l'injection.

**La correction** est la requête **préparée** de la leçon 05 : la donnée voyage dans un canal séparé du texte de la requête, et la base ne l'interprète jamais comme du code.

```ts
// ✅ La valeur est un paramètre, jamais du texte interprété
const r = await pool.query("SELECT * FROM utilisateurs WHERE email = $1", [email]);
```

Deux points à retenir. **L'échappement manuel ne suffit pas** : on oublie toujours un cas (encodages, types, contextes imbriqués), alors que les requêtes préparées ferment la question par construction. Et **un ORM bien utilisé paramètre pour toi** (leçon 07) — à condition de ne pas retomber dans l'interpolation de chaîne avec `$queryRawUnsafe`, dont le nom est un avertissement.

La même logique vaut pour l'**injection de commande système** : ne construis jamais une commande shell par concaténation de données utilisateur. Utilise les API qui séparent la commande de ses arguments (`execFile` plutôt que `exec`), ou mieux, évite d'appeler le système.

### ③ XSS (*cross-site scripting*)

Tu l'as rencontrée au palier 2, leçon 07. Le principe : une donnée fournie par un utilisateur est **affichée telle quelle dans une page**, et si elle contient du balisage actif, le navigateur l'**exécute** dans le contexte de ton site — avec les droits de la personne qui consulte la page.

```tsx
// ❌ Fragile côté affichage : on injecte du HTML non maîtrisé
element.innerHTML = commentaireUtilisateur;
<div dangerouslySetInnerHTML={{ __html: commentaireUtilisateur }} />
```

**La correction** est l'échappement à l'affichage : traiter la donnée comme du **texte**, jamais comme du balisage.

```tsx
element.textContent = commentaireUtilisateur;       // le navigateur n'interprète rien
<div>{commentaireUtilisateur}</div>                  // React échappe par défaut
```

Trois points. **React échappe automatiquement** tout ce que tu mets entre accolades — c'est l'une de ses protections intégrées, et `dangerouslySetInnerHTML` porte son nom pour une raison. **Si tu dois afficher du HTML riche** venu d'un utilisateur (un éditeur de texte, par exemple), il faut le **nettoyer** avec une bibliothèque dédiée (DOMPurify), jamais le faire soi-même. Et une **politique de sécurité de contenu** (en-tête CSP, fourni par `helmet`) ajoute une défense en profondeur : même si une injection passe, le navigateur refuse d'exécuter un script non autorisé.

Le lien avec la leçon 08 est direct : c'est parce qu'une XSS peut lire tout ce que le JavaScript voit qu'un jeton de session doit vivre dans un cookie `httpOnly` — inaccessible au script.

### ④ CSRF (*cross-site request forgery*)

Le principe : si ton utilisateur est connecté par **cookie**, un autre site qu'il visite peut déclencher une requête vers le tien, et le navigateur **joint automatiquement le cookie**. L'action s'exécute au nom de l'utilisateur, à son insu.

Les corrections, complémentaires : un **jeton CSRF** (une valeur imprévisible, exigée sur les requêtes qui modifient l'état, qu'un site tiers ne peut pas connaître), et l'attribut de cookie **`SameSite`** (leçon 08) qui empêche l'envoi automatique depuis une autre origine. Une authentification par **jeton envoyé dans un en-tête** (et non par cookie) n'est pas exposée à la CSRF, puisqu'un site tiers ne peut pas forger cet en-tête — c'est l'un des arguments du tableau session/JWT de la leçon 08.

### Les défenses d'infrastructure

```ts
import helmet from "helmet";
app.use(helmet());                                   // en-têtes de sécurité (dont CSP de base)
app.use(express.json({ limit: "100kb" }));           // limite de taille (leçon 04)
// + limitation de débit (leçon 08), CORS configuré (leçon 02), HTTPS (palier 8)
```

```bash
npm audit                     # les dépendances aux vulnérabilités connues
npm audit fix                 # les corrige quand c'est possible sans casse
```

Les **composants vulnérables** sont une catégorie à part entière du Top 10 : une faille dans une dépendance que tu n'as pas écrite est quand même ta faille. `npm audit` dans le pipeline (palier 8) et Dependabot sont les réponses.

---

## Les problèmes que tu vas rencontrer

**Une route « protégée » laisse passer les données d'autrui.** La vérification de propriété manque — c'est la faille n°1, et la plus facile à oublier.

**Un champ interdit est accepté dans un corps de requête.** Ton schéma de validation ignore les champs inattendus au lieu de les refuser. `.strict()`.

**Une donnée affichée s'exécute comme du code.** XSS : tu as utilisé `innerHTML` ou `dangerouslySetInnerHTML` sur une entrée utilisateur.

**Une requête se comporte anormalement selon la saisie.** Signe d'une concaténation de données dans du SQL — passe en requêtes préparées.

**Une action s'exécute depuis un autre site.** CSRF : il manque le jeton ou l'attribut `SameSite`.

**`npm audit` signale des vulnérabilités critiques.** Mets à jour, et ne déploie pas une dépendance critique non corrigée.

**Un message d'erreur révèle ta structure interne.** Trace renvoyée au client (leçon 04) : message neutre, trace dans les journaux.

**Ton HTTPS n'est pas forcé.** En production, une connexion en clair expose les cookies et les jetons. C'est le palier 8.

---

## Ce qu'on te demandera

C'est, avec l'authentification, **le sujet de sécurité le plus abordé en entretien**.

Les questions quasi certaines : **« qu'est-ce qu'une injection SQL et comment t'en protèges-tu ? »** (et la bonne réponse est « requêtes préparées », avec « l'échappement manuel ne suffit pas »), **« qu'est-ce que la XSS et comment l'évites-tu ? »**, « différence entre XSS et CSRF ? », **« comment empêches-tu un utilisateur connecté d'accéder aux données d'un autre ? »** (la faille n°1, et beaucoup répondent « les rôles » là où il faut « la propriété »).

Une question de posture, appréciée : « as-tu déjà reproduit une faille pour comprendre comment la corriger ? ». Pouvoir répondre oui, sur ton propre projet, change la conversation.

En **test technique**, on vérifiera l'accès croisé entre deux comptes, et parfois on t'enverra une entrée malveillante. C'est l'épreuve A4 de ton évaluation de palier.

---

## Ce qui te démarquera

**Avoir reproduit puis corrigé une faille sur ton code.** Et pouvoir le raconter. C'est la différence entre réciter et comprendre.

**La vérification de propriété, systématique.** La faille n°1 du web, et celle que ton réflexe doit couvrir sans y penser.

**Savoir que l'échappement manuel ne suffit pas**, et pourquoi les requêtes préparées ferment la question par construction.

**Écrire un test qui vérifie une correction de sécurité.** Un test qui envoie l'entrée malveillante et vérifie qu'elle est rejetée est la preuve que la faille ne reviendra pas (leçon 10).

**Lancer `npm audit` avant de livrer.** Et savoir qu'une dépendance vulnérable est ta responsabilité.

**Et connaître le Top 10 par ses grandes familles.** Pas par cœur dans l'ordre — mais savoir nommer le contrôle d'accès, l'injection, la XSS, la mauvaise configuration et les composants vulnérables te place largement au-dessus d'un junior moyen.

---

## 📚 À lire

**OWASP → *Top 10*** (owasp.org/Top10) : lis la présentation de chaque catégorie. C'est le document de référence, écrit pour être lu par des développeurs.

Les **Cheat Sheets** de l'OWASP sont la ressource pratique du métier : ***SQL Injection Prevention***, ***Cross Site Scripting Prevention***, ***Cross-Site Request Forgery Prevention***, et ***Authorization***. Chacune est courte et directement applicable.

**MDN → *Website security*** et la page sur la **CSP** pour l'échappement et les en-têtes.

**PortSwigger Web Security Academy** propose des laboratoires d'entraînement **légaux et conçus pour ça** — c'est le cadre approprié pour s'exercer à l'offensif, par opposition à toute cible réelle non autorisée.

---

## 🤖 Le mini-projet à demander à l'IA

L'exercice le plus formateur est de faire auditer **ton propre** code.

> « Je suis en formation de développeur, palier 4. J'ai une API Express + Prisma avec authentification. Je veux la **durcir**. Agis comme un relecteur de sécurité qui m'aide à auditer MON code. Donne-moi une **checklist de 15 points** tirée de l'OWASP Top 10 à vérifier sur mon API (contrôle de propriété sur chaque ressource, requêtes préparées partout, échappement à l'affichage, champs non autorisés refusés, limitation de débit sur la connexion, en-têtes de sécurité, secrets hors du code, dépendances à jour, messages d'erreur neutres, cookies `httpOnly`/`SameSite`…). Pour chaque point, **ne me donne pas la solution** : pose-moi une question qui me fait vérifier si mon code est exposé, et je te montrerai le passage concerné. »

Cette formulation reste strictement défensive : tu audites ton propre travail, pour le corriger.

Puis l'exercice de tests de régression de sécurité, qui relie à la leçon 10 :

> « Pour chacune des 4 familles (contrôle d'accès, injection SQL, XSS, CSRF), aide-moi à écrire un **test automatique** qui envoie l'entrée problématique à mon API et **vérifie qu'elle est correctement rejetée** (bon code de statut, pas de fuite de données). Donne-moi la structure du test et les cas à couvrir, pas la solution complète. Le but est que ces tests restent dans ma suite et empêchent la faille de revenir. »

---

## 🛠️ À faire

> Tout se passe sur ton propre projet, en local. Le but de chaque exercice est de **vérifier puis durcir**, pas de collectionner des attaques.

1. **Contrôle d'accès** : avec deux comptes, vérifie que le compte A ne peut ni lire, ni modifier, ni supprimer une ressource du compte B. Corrige par la vérification de propriété, et renvoie `404`.
2. **Affectation en masse** : envoie un corps de requête avec un champ non prévu (un rôle à l'inscription). S'il est pris en compte, c'est une faille — corrige avec un schéma Zod `.strict()`.
3. **Injection SQL** : écris une route volontairement fragile avec une requête concaténée, sur une base de test. Constate qu'une saisie contenant une apostrophe casse la requête. Passe en requêtes préparées et vérifie que la même saisie est désormais traitée comme une donnée inoffensive.
4. **XSS** : affiche un commentaire utilisateur avec `innerHTML` (ou `dangerouslySetInnerHTML`), saisis du balisage actif, constate son exécution. Corrige avec `textContent` (ou le rendu React par défaut).
5. **CSRF** : explique par écrit, dans ton journal, pourquoi une API authentifiée par **cookie** y est exposée et une API authentifiée par **en-tête** ne l'est pas. Ajoute `SameSite` à tes cookies.
6. **En-têtes** : installe `helmet`, et compare les en-têtes de réponse avant et après avec `curl -I`.
7. **Dépendances** : lance `npm audit`, lis le rapport, et corrige ce qui peut l'être.
8. **Messages d'erreur** : vérifie qu'aucune de tes réponses d'erreur ne révèle de trace technique ni de structure de base (leçon 04).
9. **Tests de régression** : écris, pour chaque famille, un test automatique qui envoie l'entrée problématique et **vérifie le rejet**. Ces tests restent dans ta suite (leçon 10).
10. **La checklist** : rédige dans `docs/securite.md` ta checklist OWASP appliquée au projet 4, avec pour chaque point l'état (vérifié / à faire). C'est un livrable, et un argument en entretien.

<details>
<summary>Points de contrôle</summary>

**1.** Dans une première implémentation, l'accès croisé **réussit presque toujours** : le middleware a vérifié l'authentification, pas la propriété. C'est *Broken Access Control*, **premier** du Top 10. La correction est dans le service, parce que seul lui connaît la ressource et son propriétaire — un middleware générique ne peut pas faire cette vérification.

**2.** Zod **ignore** par défaut les champs non déclarés : un `{"role":"admin"}` glissé dans l'inscription est silencieusement écarté du résultat validé, donc sans effet — à condition que tu construises l'objet créé **depuis les données validées** et non depuis `req.body` brut. `.strict()` va plus loin et **rejette** la requête, ce qui est préférable car ça signale l'anomalie.

**3.** Avec concaténation, une apostrophe dans la saisie casse la syntaxe de la requête (tu verras une erreur SQL) : c'est le signe que la donnée a franchi la frontière du code. Avec un paramètre (`$1`), la même apostrophe est stockée et comparée comme un caractère ordinaire — la requête fonctionne normalement et ne peut plus être détournée. **C'est la démonstration que les requêtes préparées traitent la donnée comme une donnée, par construction.**

**4.** Avec `innerHTML`, le balisage saisi est interprété par le navigateur ; avec `textContent`, il s'affiche littéralement, inoffensif. En React, le rendu `{valeur}` échappe automatiquement — c'est pourquoi `dangerouslySetInnerHTML` est le seul moyen de s'exposer, et pourquoi son nom est explicite.

**9.** Un test de sécurité qui passe au vert prouve deux choses : la faille est corrigée **maintenant**, et elle ne reviendra pas silencieusement lors d'une modification future. C'est la différence entre « j'ai corrigé » et « la correction est garantie ».
</details>

---

## ✅ Acquis si…

- [ ] J'ai reproduit puis corrigé une faille de contrôle d'accès, et je renvoie `404` sur une ressource qui n'est pas la mienne.
- [ ] Je refuse les champs non autorisés dans les corps de requête.
- [ ] J'utilise des requêtes préparées partout, et je sais pourquoi l'échappement manuel ne suffit pas.
- [ ] J'échappe toute donnée utilisateur à l'affichage, et je connais le rôle de `dangerouslySetInnerHTML`.
- [ ] J'explique la différence entre XSS et CSRF, et la protection de chacune.
- [ ] J'ai `helmet`, une limite de taille, une limitation de débit et des cookies `httpOnly`/`SameSite`.
- [ ] Je lance `npm audit` avant de livrer.
- [ ] Aucune de mes réponses d'erreur ne fuite de trace ou de structure interne.
- [ ] J'ai écrit un test de régression pour chaque famille de faille.
- [ ] Je sais nommer les grandes familles du Top 10 et où chacune se défend.

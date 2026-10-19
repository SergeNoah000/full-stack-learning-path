# Leçon 03 — Intégrer une fonctionnalité IA dans un produit : coûts, erreurs, garde-fous

> 🎯 **À la fin de cette leçon** : tu ajoutes une fonctionnalité d'IA à ton produit en appelant une API de modèle de langage **depuis ton backend**, et tu la rends fiable — coûts maîtrisés, erreurs gérées, garde-fous de sécurité.
> ⏱️ 4 h · **Prérequis** : la leçon 02 (API), le palier 4 (backend, secrets, async), le palier 7 (robustesse : cache, rate limiting, idempotence).

---

## De quoi on parle

Tu as utilisé l'IA pour **apprendre** tout au long du parcours. Ici, tu l'intègres **dans un produit** : une fonctionnalité qui appelle un modèle de langage (comme Claude) via son API pour rendre un service à l'utilisateur — par exemple catégoriser automatiquement une dépense à partir de sa description, résumer des notes, ou répondre à des questions sur les données.

Techniquement, une API d'IA est **une API HTTP comme les autres** (paliers 4-6) : tu envoies une requête (un *prompt* + des paramètres), tu reçois une réponse (du texte). Ce que tu sais faire — appeler une API, gérer l'async, sérialiser le JSON — s'applique directement.

Ce qui est **spécifique** à l'IA, et fait tout l'enjeu de la leçon :

- les **coûts** : chaque appel est facturé (au *token*). Une fonctionnalité IA mal conçue peut coûter cher très vite ;
- les **erreurs et la latence** : les appels sont lents, parfois en échec, et la réponse n'est pas garantie exacte (le modèle peut « halluciner ») ;
- les **garde-fous** : la clé d'API est un secret critique ; l'appel se fait **côté serveur**, jamais depuis le client ; et il faut se prémunir contre les abus et les entrées malveillantes.

---

## À quoi ça sert, concrètement

**Parce que l'IA est devenue une brique de produit courante.** Catégorisation, résumé, recherche sémantique, assistance, génération de texte : intégrer un modèle de langage est une compétence de plus en plus demandée. Savoir le faire **proprement** (pas juste appeler l'API, mais la rendre fiable et abordable) te distingue.

**Parce que les coûts peuvent déraper silencieusement.** Contrairement à une base de données (coût fixe), chaque appel d'IA est facturé. Une fonctionnalité qui appelle le modèle à chaque frappe, ou sans cache, ou sans limite, peut transformer une facture de quelques euros en centaines. Maîtriser les coûts (cache, limites, modèle adapté) est une responsabilité d'ingénieur, pas un détail.

**Parce que l'IA est faillible, et le produit doit rester fiable.** Le modèle est lent (secondes), parfois indisponible, et sa réponse peut être inexacte ou dans un format inattendu. Un produit sérieux gère ces cas : indicateur de chargement, dégradation gracieuse si l'IA échoue, validation de la réponse. Traiter l'IA comme un service **faillible** (et non magique) est la marque du professionnalisme.

**Et parce que la sécurité est non négociable.** La clé d'API donne accès à un service payant en ton nom : elle ne doit **jamais** être dans le code client (web ou mobile), où n'importe qui la lirait. L'appel se fait côté serveur. Et comme tout endpoint, celui qui déclenche l'IA doit être protégé contre les abus (rate limiting) et les entrées malveillantes. C'est la sécurité des paliers 4, 7 et 8, appliquée à un cas à fort enjeu financier.

---

## Où ça intervient dans le développement

La fonctionnalité IA s'insère comme un service appelé par ton backend :

```
   CLIENT (web/mobile) → "catégorise cette dépense"
        ▼ (ta propre API)
   TON BACKEND (paliers 4-6)
     ├─ la clé d'API IA est ICI (secret serveur, jamais côté client)
     ├─ CACHE : déjà vu cette requête ? → réponse sans rappeler l'IA (coût évité)
     ├─ RATE LIMITING : pas plus de N appels/utilisateur (abus, coût)
     ├─ appel à l'API du MODÈLE (HTTP, async) ──▶ [modèle de langage]
     ├─ VALIDER la réponse (format attendu ? sinon, repli)
     └─ renvoyer au client (ou une valeur par défaut si l'IA a échoué)
```

Trois ancrages.

**C'est une API HTTP, consommée comme les autres (paliers 4-6).** Appeler l'API du modèle, c'est un `POST` avec un corps JSON et une réponse JSON — exactement ce que tu fais depuis le palier 4. L'async (Future/Promise), la sérialisation, la gestion d'erreur : tout transfère. L'IA n'est pas magique techniquement ; c'est une API de plus.

**Les garde-fous sont le palier 7 (robustesse), appliqués.** Le **cache** (leçon 06 du palier 7) évite de rappeler l'IA pour une entrée identique — directement du coût économisé. Le **rate limiting** (même leçon) protège des abus et borne la facture. L'**idempotence** évite de payer deux fois pour une relance. Tu réutilises exactement ces techniques, ici avec un enjeu financier concret.

**Et la clé d'API est un secret du palier 4/8.** « Secrets hors du code » (palier 4, leçon 04 ; palier 8) prend ici tout son sens : la clé d'IA vit en variable d'environnement côté serveur, jamais dans le client. L'exposer, c'est laisser n'importe qui dépenser ton budget.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas ajouter **une** fonctionnalité IA utile à ton produit (par exemple : catégoriser une dépense d'après sa description), via un endpoint de **ton** backend qui appelle le modèle, avec la clé en secret serveur, un cache, une limite d'appels, une gestion d'erreur, et une validation de la réponse. Tu testeras le cas où l'IA échoue (le produit doit rester utilisable).

### En équipe, en entreprise

**L'appel IA se fait toujours côté serveur.** Jamais la clé dans le front ou le mobile. Le client appelle **ton** API, qui appelle l'IA. C'est une règle absolue — une clé exposée est immédiatement exploitée (des robots scannent les dépôts publics pour ça).

**Les coûts sont surveillés comme une métrique.** On suit le nombre d'appels, les tokens consommés, le coût par utilisateur. On met des **plafonds** (par utilisateur, par jour) pour éviter les dérapages. L'observabilité (palier 8, leçon 10) s'applique aux coûts IA.

**On choisit le modèle selon le besoin.** Un modèle plus petit/rapide/moins cher suffit souvent (catégorisation, classification) ; on réserve les gros modèles aux tâches complexes. Adapter le modèle à la tâche est un levier de coût majeur.

**La réponse de l'IA n'est jamais totalement fiable.** On **valide** sa sortie (format attendu, valeur dans une liste permise), on prévoit un **repli** si elle échoue ou renvoie n'importe quoi, et on ne lui fait pas exécuter d'action sensible sans contrôle. On traite l'IA comme une entrée **non fiable**, comme n'importe quelle donnée externe.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours (dès qu'on touche à l'IA) : appel côté serveur, clé en secret, gestion d'erreur et de latence, validation de la réponse.

Régulièrement : cache des réponses, rate limiting, choix du modèle selon le coût, suivi des coûts, repli en cas d'échec, soin du *prompt*.

Rare ou avancé : le *streaming* de la réponse (afficher au fil de la génération), le RAG (donner au modèle des documents à consulter), le *function calling*, le *fine-tuning*, les embeddings et la recherche sémantique. À connaître de nom ; selon les besoins du produit.

---

## La mécanique

### ⭐ L'appel se fait côté serveur (la règle absolue)

```
❌ JAMAIS : le front web ou l'app mobile appelle directement l'API du modèle
   → la clé d'API serait dans le code client, donc LISIBLE par tous → budget pillé.

✅ TOUJOURS : le client appelle TON backend → ton backend appelle l'IA (clé en secret).
   Client → POST /api/categoriser → [ton backend, clé serveur] → API du modèle → réponse.
```

C'est la règle non négociable. La clé d'API est un secret (palier 4, leçon 04) qui autorise des dépenses en ton nom. Dans un client (web ou mobile), le code est **public** (inspectable) : la clé serait volée en minutes. L'appel passe donc **toujours** par ton backend, qui seul détient la clé. Le client ne parle qu'à ton API.

### Appeler l'API du modèle (une API HTTP comme les autres)

```
Côté backend (paliers 4-6), c'est un appel HTTP classique :
  - une requête POST avec un corps JSON : le prompt + des paramètres (modèle, limite de tokens)
  - un en-tête d'authentification avec la clé (lue depuis l'environnement, PAS en dur)
  - une réponse JSON contenant le texte généré
→ Tu utilises ce que tu sais : client HTTP, async (Future/Promise), sérialisation JSON.
```

Techniquement, rien de neuf : c'est le `POST` avec corps et en-tête d'auth des paliers 4-6, vers l'API du fournisseur (Anthropic pour Claude, etc.). La clé vient de `process.env` / `os.environ` / `$_ENV` (selon ton backend), jamais écrite dans le code. La réponse se désérialise comme n'importe quel JSON. L'async est le même qu'au palier 4.

### Le prompt : l'entrée du modèle

```
Le "prompt" est l'instruction envoyée au modèle. Pour une fonctionnalité fiable :
  - sois précis sur la tâche ET le FORMAT de sortie attendu
    ("Réponds uniquement par une catégorie parmi : courses, transport, loisirs, autre")
  - cela rend la réponse plus facile à VALIDER et à utiliser dans ton code.
```

Un prompt clair, qui contraint le **format** de la réponse, rend la fonctionnalité fiable : si tu demandes « une catégorie parmi cette liste », tu peux valider que la réponse en fait partie. Un prompt vague donne une réponse imprévisible, difficile à exploiter. Le soin du prompt est au service de la fiabilité du code.

### ⭐ Maîtriser les coûts : cache et limites (palier 7)

```
CACHE (palier 7, leçon 06) : pour une entrée identique, renvoyer la réponse déjà obtenue
  sans rappeler l'IA. Ex. "Café Starbucks" déjà catégorisé → pas de nouvel appel payant.
RATE LIMITING (palier 7, leçon 06) : plafonner les appels par utilisateur / par jour,
  pour qu'un abus (ou un bug) ne fasse pas exploser la facture.
MODÈLE ADAPTÉ : une tâche simple (catégoriser) n'a pas besoin du plus gros modèle.
```

Chaque appel coûte. Les techniques de robustesse du palier 7 (leçon 06) deviennent ici des leviers de **coût** directs : le cache évite les appels redondants (une même description → une seule facturation), le rate limiting borne la dépense par utilisateur, et choisir un modèle adapté à la tâche réduit le coût unitaire. C'est le palier 7 avec un enjeu euro concret.

### ⭐ Gérer l'échec et la latence (l'IA est faillible)

```
L'appel IA est LENT (secondes) et peut ÉCHOUER (indisponible, timeout, quota).
  - LATENCE : montre un indicateur de chargement (états d'écran, palier 9 leçon 08).
  - ÉCHEC : try/catch (palier 2/4), et un REPLI — le produit reste utilisable sans l'IA.
    Ex. l'auto-catégorisation échoue → l'utilisateur choisit la catégorie à la main.
  - RÉPONSE INATTENDUE : VALIDER la sortie (dans la liste permise ?) ; sinon, repli.
→ L'IA AMÉLIORE le produit ; elle n'est pas un point de défaillance unique.
```

Un produit fiable ne s'effondre pas si l'IA échoue. On gère la latence (indicateur de chargement, comme les états d'écran du palier 9), l'échec (try/catch + une dégradation gracieuse : le produit marche sans l'IA, l'utilisateur fait à la main), et la réponse inattendue (valider le format ; si la catégorie renvoyée n'est pas dans la liste permise, repli). L'IA est un **plus**, pas une dépendance critique.

### ⭐ Les garde-fous de sécurité

```
- CLÉ : secret serveur, jamais côté client (déjà vu — la règle absolue).
- ABUS : rate limiting (un utilisateur ne peut pas lancer 10 000 appels payants).
- ENTRÉE : ce que l'utilisateur envoie est transmis au modèle — ne lui fais pas exécuter
  d'action sensible sur la seule foi de sa réponse ; traite la sortie comme NON fiable.
- DONNÉES : ne transmets pas au modèle des données sensibles sans nécessité
  (respect de la vie privée, conformité).
```

La sécurité réunit ce que tu sais : la clé est un secret (palier 4/8), l'endpoint est protégé par rate limiting (palier 7), l'entrée utilisateur et la sortie du modèle sont traitées comme **non fiables** (comme toute donnée externe — paliers 4 et 6 sur la validation et l'échappement). On ne laisse pas l'IA déclencher une action sensible sans contrôle, et on fait attention aux données qu'on lui transmet (vie privée). Ces garde-fous sont défensifs : protéger ton produit, ton budget et tes utilisateurs.

---

## Les problèmes que tu vas rencontrer

**« Ma clé d'API est dans mon front/mobile. »** Faute grave : elle est publique, donc pillable. Déplace l'appel côté serveur, la clé en variable d'environnement. Et si elle a été exposée, **révoque-la** et génères-en une nouvelle.

**« Ma facture a explosé. »** Appels redondants (pas de cache), pas de limite, ou modèle trop gros. Ajoute un cache (palier 7), un rate limiting, et choisis un modèle adapté. Surveille les coûts comme une métrique.

**« L'IA est lente et mon interface se fige. »** Latence normale (secondes). Montre un indicateur de chargement (états d'écran, palier 9), et ne bloque pas l'interface — c'est de l'async (palier 4/leçon 02 du palier 9).

**« Quand l'IA échoue, tout mon produit casse. »** Pas de repli. L'IA doit être un **plus** : en cas d'échec, dégrade gracieusement (l'utilisateur fait à la main). `try/catch` + valeur par défaut.

**« L'IA renvoie parfois n'importe quoi. »** La réponse n'est pas garantie. Contrains le format dans le prompt, et **valide** la sortie côté serveur (dans la liste permise ?). Si elle est hors format, repli.

**« Je transmets des données sensibles à l'IA sans réfléchir. »** Attention à la vie privée et à la conformité : ne transmets au modèle que ce qui est nécessaire, et pas de données sensibles sans précaution.

---

## Ce qu'on te demandera

En **entretien**, l'intégration d'IA est un sujet de plus en plus fréquent, et bien traité il impressionne : « comment intègres-tu une IA dans un produit ? », **« où mets-tu la clé d'API et pourquoi ? »** (serveur, jamais client), « comment maîtrises-tu les coûts ? » (cache, limites, modèle adapté), « que fais-tu si l'IA échoue ou renvoie n'importe quoi ? » (repli, validation). On apprécie que tu traites l'IA comme un service faillible et payant, pas comme une magie.

On peut demander : « pourquoi ne pas appeler l'IA depuis le client ? », « comment évites-tu d'appeler l'IA deux fois pour la même chose ? » (cache), « l'IA peut-elle exécuter une action sensible directement ? » (non sans contrôle).

En **mission**, intégrer un appel IA côté serveur, avec coûts et garde-fous maîtrisés, est une compétence montante et valorisée.

---

## Ce qui te démarquera

**Traiter l'IA comme une API payante et faillible, pas comme une magie.** Maîtriser coûts, erreurs, latence et validation montre une maturité d'ingénieur. Beaucoup « branchent une IA » ; peu la rendent fiable et abordable. C'est cette différence qu'on recherche.

**La clé côté serveur, par réflexe.** Savoir d'emblée que la clé ne va jamais dans le client, et pourquoi, montre une hygiène de sécurité que l'enjeu financier rend cruciale.

**Les garde-fous de coût.** Cache + rate limiting + modèle adapté, en reliant au palier 7, montre que tu transfères la robustesse à un cas concret et que tu penses « facture », pas seulement « ça marche ».

**Et la dégradation gracieuse.** Concevoir un produit qui reste utilisable quand l'IA échoue — l'IA améliore, elle n'est pas un point de défaillance unique — est exactement la fiabilité qu'on attend d'un produit sérieux.

---

## 📚 À lire

**La documentation de l'API Claude (Anthropic) — *Messages API*, *authentification*, *pricing*** : comment appeler le modèle, structurer un prompt, et comprendre la facturation au token. (Rappel : les modèles Claude 5 sont les plus récents ; choisis le modèle adapté à ta tâche et à ton budget.)

**Les bonnes pratiques de *prompt engineering*** (doc Anthropic) : contraindre le format de sortie pour une intégration fiable.

**Le palier 7, leçon 06 (cache, rate limiting, idempotence)** : les techniques de maîtrise des coûts, à relire avec l'enjeu financier en tête.

**OWASP → *Top 10 for LLM Applications*** (en cadre défensif) : les risques propres aux applications utilisant des modèles de langage, pour poser tes garde-fous.

Relis le palier 4 (appel d'API, secrets, async), le palier 7 (robustesse) et le palier 9 leçon 08 (états d'écran pour la latence). L'intégration IA les assemble.

---

## 🤖 Le mini-projet à demander à l'IA

Ajouter une fonctionnalité IA fiable et abordable à ton produit :

> « Je suis en formation de développeur, palier 10 (projet final). Je veux ajouter UNE fonctionnalité IA utile à mon produit (par ex. catégoriser une dépense d'après sa description) en appelant un modèle de langage. Sans coder à ma place, guide-moi : pourquoi l'appel doit se faire depuis MON backend (jamais le client) avec la clé en secret serveur, comment structurer l'appel (c'est une API HTTP comme celles des paliers 4-6), et comment écrire un prompt qui contraint le format de sortie pour que je puisse le VALIDER (ex. une catégorie parmi une liste). »

Puis les coûts, erreurs et garde-fous :

> « Aide-moi à rendre cette fonctionnalité fiable et abordable, en reliant au palier 7. Coûts : où mettre un cache (ne pas rappeler l'IA pour une entrée identique), un rate limiting (plafonner les appels par utilisateur), et comment choisir un modèle adapté à une tâche simple. Erreurs : gérer la latence (indicateur de chargement), l'échec (try/catch + un REPLI pour que le produit marche sans l'IA), et une réponse hors format (validation + repli). Sécurité : traiter la sortie du modèle comme NON fiable et ne pas lui faire exécuter d'action sensible sans contrôle. Mets-moi au défi sur chaque garde-fou. »

---

## 🛠️ À faire

1. **Choisir une fonctionnalité utile** : identifie **une** fonctionnalité IA qui apporte vraiment quelque chose à ton produit (catégorisation, résumé, assistance). Écris ce qu'elle fait et pourquoi elle est utile.
2. **⭐ L'appel côté serveur** : crée un endpoint de **ton** backend qui appelle l'API du modèle, avec la clé lue depuis une variable d'environnement (jamais en dur, jamais côté client).
3. **Le prompt contraint** : rédige un prompt qui précise la tâche **et le format** de sortie attendu (ex. « réponds uniquement par une catégorie parmi : … »), pour pouvoir valider la réponse.
4. **Valider la réponse** : vérifie côté serveur que la sortie du modèle est dans le format attendu (ex. une catégorie permise). Sinon, applique un repli.
5. **⭐ Le cache** : mets en cache les réponses (palier 7, leçon 06) pour ne pas rappeler l'IA sur une entrée identique. Vérifie qu'une même description n'est facturée qu'une fois.
6. **⭐ Le rate limiting** : plafonne les appels par utilisateur (palier 7), pour qu'un abus ne fasse pas exploser la facture.
7. **Gérer l'échec** : fais échouer l'appel IA (coupe l'accès, mauvaise clé) et vérifie que ton produit **reste utilisable** (repli : l'utilisateur fait à la main). Gère aussi la latence (indicateur de chargement).
8. **La clé exposée (contre-exemple)** : explique par écrit ce qui se passerait si tu mettais la clé dans ton front ou ton mobile, et pourquoi on révoque une clé exposée.
9. **Le coût** : estime (ou mesure) le coût d'un appel, et réfléchis à ce que coûterait la fonctionnalité à 1 000 utilisateurs — et comment le cache/rate limiting/modèle le réduisent.
10. **Le lien** : dans ton journal, relie chaque garde-fou au palier d'origine (clé = secret du palier 4/8 ; cache et rate limiting = palier 7 ; latence = états d'écran du palier 9 ; sortie non fiable = validation des paliers 4/6).

<details>
<summary>Corrections et points de contrôle</summary>

**2 + 8.** La règle absolue : l'appel IA se fait **côté serveur**, la clé en variable d'environnement, jamais dans le client. Le code d'un front web ou d'une app mobile est **public** (inspectable) ; une clé qui y figure est volée en minutes (des robots scannent les dépôts et les apps pour ça) et ton budget est pillé. Le client appelle **ton** API, qui seule détient la clé et appelle le modèle. Une clé exposée se **révoque** immédiatement et se remplace. C'est le « secrets hors du code » des paliers 4 et 8, avec un enjeu financier direct.

**3-4.** Le prompt contraint et la validation vont ensemble : demander un format précis (« une catégorie parmi cette liste ») rend la réponse **vérifiable**. Tu valides côté serveur que la sortie est bien dans le format attendu — sinon repli. C'est traiter la sortie du modèle comme une entrée **non fiable** (comme toute donnée externe, paliers 4/6) : le modèle peut se tromper ou répondre hors format, et ton code ne doit pas s'y fier aveuglément.

**5-6 + 9.** Les coûts sont l'enjeu propre à l'IA. Chaque appel est facturé, donc les techniques du palier 7 (leçon 06) deviennent des leviers de coût directs : le **cache** évite les appels redondants (une entrée identique n'est facturée qu'une fois), le **rate limiting** borne la dépense par utilisateur (et protège d'un bug ou d'un abus), et un **modèle adapté** à la tâche réduit le coût unitaire. Penser « que coûterait ça à 1 000 utilisateurs ? » est un réflexe d'ingénieur : une fonctionnalité qui marche en démo peut être ruineuse à l'échelle sans ces garde-fous.

**7 + 10.** La dégradation gracieuse : l'IA est **lente et faillible**, donc le produit doit rester utilisable sans elle. On gère la latence (indicateur de chargement, états d'écran du palier 9), l'échec (`try/catch` + repli : l'utilisateur fait à la main), et la réponse inattendue (validation + repli). L'IA **améliore** le produit, elle n'est pas un point de défaillance unique. Relier chaque garde-fou à son palier (secret = p.4/8, cache/limites = p.7, latence = p.9, sortie non fiable = validation p.4/6) montre que l'intégration IA n'est pas un sujet isolé mais l'assemblage de ta robustesse — avec, en plus, l'enjeu coût.
</details>

---

## ✅ Acquis si…

- [ ] Je comprends qu'une API d'IA est une API HTTP, et j'applique ce que je sais (appel, async, JSON).
- [ ] L'appel IA se fait depuis mon backend, la clé en secret serveur, jamais côté client.
- [ ] J'écris un prompt qui contraint le format, et je **valide** la réponse côté serveur.
- [ ] Je maîtrise les coûts avec un cache, un rate limiting et un modèle adapté (palier 7).
- [ ] Je gère la latence (indicateur de chargement) et l'échec (repli : le produit marche sans l'IA).
- [ ] Je traite la sortie du modèle comme non fiable et ne lui fais pas exécuter d'action sensible.
- [ ] Je sais estimer le coût d'une fonctionnalité IA et le réduire.
- [ ] Je relie chaque garde-fou au palier qui l'a enseigné (secret, robustesse, états d'écran, validation).

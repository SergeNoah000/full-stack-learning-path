# Leçon 10 — FastAPI : Pydantic, validation, OpenAPI, async

> 🎯 **À la fin de cette leçon** : tu construis une API typée qui se valide et se documente toute seule — et tu comprends pourquoi beaucoup d'équipes la choisissent aujourd'hui.
> ⏱️ 6 h · **Prérequis** : leçon 09 (Flask), et les leçons 04 (Zod/validation) et 03 (TypeScript) du palier 4 et 3.

---

## De quoi on parle

**FastAPI** est un framework web Python moderne qui a une idée centrale : **utiliser les type hints pour tout faire**. Tu déclares les types de tes données, et FastAPI en déduit la validation, la conversion, la documentation, et l'aide de l'éditeur.

```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class NouvelleDepense(BaseModel):          # un modèle Pydantic
    montant: int
    categorie: str
    description: str

@app.post("/depenses")
def creer(depense: NouvelleDepense):       # le type déclenche la validation
    return {"id": 1, **depense.model_dump()}
```

**Pydantic** est la bibliothèque de validation sous-jacente : un modèle Pydantic valide les données **à l'exécution** depuis les type hints — c'est exactement le rôle de Zod au palier 4. Et **OpenAPI** est le standard de documentation d'API que FastAPI génère automatiquement, avec une interface interactive à `/docs`.

FastAPI est aussi **asynchrone** : il repose sur ASGI (la version async de WSGI, leçon 04) et gère `async def`.

---

## À quoi ça sert, concrètement

**Parce que Pydantic est le Zod de Python — et tu connais Zod.** Au palier 4 (leçon 04), tu as validé tes données entrantes avec Zod, et tu as déduit tes types TypeScript du schéma (`z.infer`). Pydantic fait **exactement** la même chose : un modèle qui valide à l'exécution **et** fournit le type. La frontière du palier 1 (tout ce qui entre est suspect) trouve ici sa réponse Python — et tu la reconnais immédiatement.

**Parce que la documentation auto-générée est un vrai gain.** FastAPI produit une documentation OpenAPI interactive depuis tes modèles et tes signatures. Tu ouvres `/docs`, tu vois toutes tes routes, leurs paramètres, leurs réponses, et tu peux les tester dans le navigateur. C'est la « spécification d'API » du fil rouge gestion de projet (palier 5), générée gratuitement — et elle ne peut pas être fausse, puisqu'elle vient du code.

**Parce que c'est devenu le choix par défaut pour une nouvelle API Python.** Là où Flask demande d'assembler la validation et la documentation, FastAPI les intègre. Pour une API, beaucoup d'équipes le préfèrent aujourd'hui. Le connaître est directement utile sur le marché.

**Et parce que l'async en Python, tu le connais déjà.** `async def` et `await` en Python sont **le même concept** qu'au palier 1 (leçons 09-10, en JavaScript). Tu ne réapprends pas l'asynchrone : tu le retrouves dans un troisième langage.

---

## Où ça intervient dans le développement

FastAPI est le troisième framework du palier, et il incarne une philosophie distincte :

```
   TROIS PHILOSOPHIES (le comparatif du palier 7)
   ──────────────────────────────────────────────
   ton mini-framework   →   tout à la main, rien de caché
   Flask (leçon 09)     →   micro : le cœur, tu composes le reste
   FastAPI (CETTE LEÇON)→   API moderne : typé, validé, documenté automatiquement
   Django (leçon 11)    →   tout inclus, structure imposée
```

Trois points de transfert.

**Pydantic est Zod, et ce n'est pas une métaphore.** Les deux déclarent un schéma, valident à l'exécution, et en déduisent le type. `class NouvelleDepense(BaseModel)` est l'équivalent de `const schemaDepense = z.object(...)`. Tu as construit l'intuition au palier 4 ; ici tu la retrouves, et la frontière de validation (client confort / serveur barrière) reste identique.

**L'async est celui du palier 1.** `async def` et `await` fonctionnent comme en JavaScript : on lance une opération d'entrée-sortie et on continue sans bloquer. FastAPI les utilise pour servir de nombreuses requêtes efficacement. Le modèle mental de l'event loop (palier 1, leçon 11) s'applique — avec les mêmes pièges (ne pas bloquer avec du calcul synchrone).

**Et la documentation auto-générée annonce la spécification d'API.** Au palier 4, tu as conçu un contrat REST (leçon 03) et tu l'as documenté à la main. FastAPI le génère. C'est le livrable « spécification d'API » du fil rouge gestion de projet, et tu comprends maintenant qu'il peut venir du code plutôt que d'un document séparé qui se périme.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas être frappé par deux choses. D'abord, la validation « gratuite » : tu déclares un type, et une donnée invalide est refusée avec un message précis, sans que tu écrives la vérification. Ensuite, la page `/docs` : ta documentation apparaît toute seule, interactive, et tu peux tester tes routes dans le navigateur.

Tu vas aussi te demander quand mettre `async def` et quand mettre `def` — un point qui déroute, et que la leçon clarifie.

### En équipe, en entreprise

**FastAPI est le choix moderne pour les API.** Microservices, API pour applications mobiles ou React, services de données et d'IA : c'est souvent FastAPI. Sa validation typée et sa documentation en font un favori des équipes récentes.

**Pydantic est partout, au-delà de FastAPI.** C'est devenu la bibliothèque de validation de référence en Python, utilisée pour la configuration, les files de messages, les paramètres. Le connaître sert dans tout l'écosystème.

**La documentation OpenAPI est un contrat partagé.** Le frontend et le backend s'accordent sur le schéma OpenAPI ; on peut même générer un client TypeScript depuis lui. C'est le contrat du palier 4, formalisé et exploitable.

**Et l'async est un sujet de performance.** FastAPI brille sur les opérations d'entrée-sortie (appels réseau, base de données). Mais mal utilisé — un calcul lourd dans une route async — il bloque tout, comme en Node (palier 1, leçon 11). Savoir quand `async` aide est une vraie compétence.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : les modèles Pydantic, les décorateurs de route (`@app.get`, `@app.post`), les paramètres de chemin et de requête typés, les modèles de réponse (`response_model`), et `/docs`.

Régulièrement : la validation avancée de Pydantic (`Field`, validateurs), les codes de statut, les dépendances (`Depends`), l'async pour les I/O, la gestion d'erreurs (`HTTPException`).

Rare, et hors sujet pour l'instant : les WebSockets, les tâches de fond, les middlewares personnalisés complexes, la sécurité OAuth intégrée, les sous-applications, le streaming. Tu les découvriras par besoin.

---

## La mécanique

### Le squelette

```bash
pip install "fastapi[standard]"
```

```python
# main.py
from fastapi import FastAPI
app = FastAPI()

@app.get("/sante")
def sante():
    return {"statut": "ok"}
```

```bash
fastapi dev main.py                      # rechargement auto + docs sur /docs
```

Ouvre `http://localhost:8000/docs` : ta documentation interactive est déjà là, pour cette seule route. C'est le premier choc de FastAPI.

### ⭐ Pydantic : le Zod de Python

```python
from pydantic import BaseModel, Field

class NouvelleDepense(BaseModel):
    montant: int = Field(gt=0)                      # gt=0 : strictement positif
    categorie: str = Field(min_length=1, max_length=50)
    description: str = Field(min_length=1, max_length=200)
    note: str | None = None                          # optionnel

class Depense(NouvelleDepense):                      # hérite + ajoute
    id: int
    cree_le: str
```

Compare avec Zod (palier 4, leçon 04) :

```typescript
// Zod, au palier 4 — le MÊME rôle
const schemaDepense = z.object({
  montant: z.number().int().positive(),
  categorie: z.string().min(1).max(50),
  description: z.string().min(1).max(200),
});
type NouvelleDepense = z.infer<typeof schemaDepense>;
```

C'est la même idée dans deux langages : un schéma qui **valide à l'exécution** et qui **fournit le type**. Avec Pydantic, le type *est* la classe (pas besoin d'un `z.infer` séparé). La frontière du palier 1 — valider tout ce qui entre, côté serveur — trouve ici sa réponse Python.

### La validation « gratuite »

```python
@app.post("/depenses")
def creer(depense: NouvelleDepense):                 # ⭐ le type DÉCLENCHE la validation
    return service.creer(depense.model_dump())
```

Le simple fait de typer le paramètre avec un modèle Pydantic fait que FastAPI :
1. parse le corps JSON (ton `request.json()`),
2. **valide** chaque champ (montant positif, catégorie non vide...),
3. **refuse** automatiquement avec un `422` et un message précis par champ si c'est invalide,
4. passe à ta fonction un objet **typé et garanti conforme**.

Tu n'écris **aucune** vérification. C'est ce que tu faisais à la main dans ton mini-framework (leçon 06) et avec un middleware Zod au palier 4 — ici, c'est le type qui le déclenche. Essaie d'envoyer `{"montant": -5}` : tu reçois un 422 détaillé, sans l'avoir programmé.

### Les paramètres typés

```python
@app.get("/depenses/{id}")
def lire(id: int):                                   # id est validé et converti en int
    depense = service.par_id(id)
    if depense is None:
        raise HTTPException(status_code=404, detail="Dépense introuvable")
    return depense

@app.get("/depenses")
def lister(categorie: str | None = None, limite: int = 20):   # paramètres de requête typés
    return service.lister(categorie, limite)
```

Comme `<int:id>` de Flask, FastAPI convertit et valide les paramètres depuis leur type. `id: int` refuse une valeur non numérique avec un 422. Et `categorie: str | None = None` déclare un paramètre de requête optionnel — FastAPI le lit, le valide, et le documente.

### Le modèle de réponse

```python
@app.get("/utilisateurs/{id}", response_model=UtilisateurPublic)   # ⭐ filtre la sortie
def lire_utilisateur(id: int):
    utilisateur = service.par_id(id)      # contient peut-être le hash du mot de passe
    return utilisateur                     # mais response_model ne renvoie QUE les champs publics
```

`response_model` garantit que la réponse ne contient que les champs déclarés dans le modèle public — c'est la version FastAPI du « ne jamais renvoyer le hash du mot de passe » (palier 4, leçon 08, le rest `({ empreinte, ...reste })`). FastAPI filtre pour toi, et le documente.

### La documentation automatique

```python
@app.post("/depenses", response_model=Depense, status_code=201,
          summary="Créer une dépense",
          description="Ajoute une dépense et renvoie l'objet créé avec son identifiant.")
def creer(depense: NouvelleDepense):
    return service.creer(depense.model_dump())
```

Tout ça apparaît sur `/docs` : la route, le corps attendu (avec les contraintes Pydantic), le code de statut, le modèle de réponse, et un bouton pour l'essayer. C'est la **spécification d'API** du fil rouge gestion de projet — générée depuis le code, donc toujours à jour. Tu peux l'exporter en JSON OpenAPI et générer un client TypeScript pour ton frontend.

### ⭐ L'async : celui du palier 1

```python
import httpx

@app.get("/meteo/{ville}")
async def meteo(ville: str):                         # async def, comme en JavaScript
    async with httpx.AsyncClient() as client:
        reponse = await client.get(f"https://api.../{ville}")   # await, comme au palier 1
        return reponse.json()
```

`async def` et `await` sont **exactement** ce que tu as appris au palier 1 (leçons 09-10) : on lance une opération d'entrée-sortie (ici un appel réseau) et on n'attend pas en bloquant, ce qui permet de servir d'autres requêtes pendant ce temps.

**Quand utiliser `async def` ?** Quand ta route fait des opérations d'entrée-sortie asynchrones (`await` sur une requête réseau, une base async). Pour du code synchrone ordinaire (un calcul, une requête de base synchrone), un simple `def` suffit — FastAPI le gère dans un pool de threads. Et le piège est le même qu'en Node : **un calcul lourd synchrone dans une route `async` bloque tout** (palier 1, leçon 11). L'async sert à attendre, pas à calculer.

### La gestion des erreurs

```python
from fastapi import HTTPException

raise HTTPException(status_code=404, detail="Dépense introuvable")

# Gestionnaire pour tes erreurs métier
from fastapi import Request
from fastapi.responses import JSONResponse

@app.exception_handler(ErreurMetier)
async def gerer_erreur_metier(request: Request, exc: ErreurMetier):
    return JSONResponse(status_code=422, content={"erreur": str(exc)})
```

`HTTPException` lève une erreur avec un code de statut — l'équivalent de `abort()` de Flask. Et `@app.exception_handler` est la gestion centralisée (palier 4, leçon 04 ; ta leçon 06) : traduire un type d'erreur métier en réponse HTTP, à un seul endroit.

---

## Les problèmes que tu vas rencontrer

**Ma validation ne se déclenche pas.** Tu n'as pas typé le paramètre avec un modèle Pydantic, ou tu as utilisé un `dict` au lieu d'un `BaseModel`. C'est le type qui déclenche tout.

**J'ai un 422 que je ne comprends pas.** C'est Pydantic qui refuse une donnée invalide — lis le `detail`, il dit précisément quel champ et pourquoi. C'est le comportement voulu : le 422 est la validation qui fonctionne.

**Mon `async def` ne rend rien plus rapide.** Tu fais du calcul synchrone, pas de l'I/O. L'async ne sert que pour les opérations d'attente (réseau, base async). Pour du calcul, c'est `def`.

**Ma route `async` bloque tout le serveur.** Tu as mis du calcul lourd synchrone (ou un `time.sleep`) dans une route `async`. C'est le piège de l'event loop (palier 1, leçon 11) : l'async sert à attendre, pas à calculer. Sors le calcul lourd, ou utilise `def` (que FastAPI exécute dans un thread).

**Le hash du mot de passe apparaît dans ma réponse.** Tu n'as pas utilisé `response_model` avec le modèle public. Déclare-le, et FastAPI filtre.

**Ma documentation `/docs` est incomplète.** Tes routes ne sont pas typées, ou il manque `response_model`. Plus tu types, plus la doc est riche.

**`model_dump()` ou `dict()` ?** Dans Pydantic v2, c'est `model_dump()` (l'ancien `.dict()` est déprécié). Vérifie ta version.

---

## Ce qu'on te demandera

En **entretien**, si FastAPI est au programme : « qu'est-ce que Pydantic ? », « comment FastAPI valide-t-il les données ? », « d'où vient la documentation `/docs` ? », « quand utilises-tu `async def` ? ».

Pour ton profil, la question qui porte : **« tu connais Zod en TypeScript — quel est le rapport avec Pydantic ? »**. Répondre « c'est le même rôle : valider à l'exécution et fournir le type » montre que tu as compris le concept, pas deux outils séparés.

En **test technique**, une API FastAPI avec des modèles Pydantic bien faits (validation, `response_model`, codes corrects) est très valorisée.

---

## Ce qui te démarquera

**Reconnaître Pydantic comme Zod.** « Pydantic valide à l'exécution et fournit le type, comme Zod — c'est la frontière de validation que je connais » est une réponse qui prouve un transfert de concept entre langages.

**La documentation auto-générée comme contrat.** Savoir que `/docs` est la spécification d'API du fil rouge gestion de projet, exploitable pour générer un client, montre une vision produit.

**Savoir quand `async` aide.** Dire « async pour l'I/O, def pour le calcul, et jamais de calcul lourd dans une route async » est une compréhension fine, liée au palier 1.

**`response_model` pour la sécurité.** Filtrer la sortie pour ne jamais fuiter de champ sensible est un réflexe de sécurité (palier 4, leçon 08), ici automatisé.

**Et situer FastAPI dans le comparatif.** « Micro (Flask), API moderne typée (FastAPI), tout inclus (Django) » prépare le palier 7.

---

## 📚 À lire

**fastapi.tiangolo.com → *Tutorial*** : **le meilleur tutoriel de l'écosystème Python**, progressif et complet. Suis-le dans l'ordre jusqu'aux modèles de réponse et à la gestion d'erreurs.

**docs.pydantic.dev** → *Models* et *Validators* : la validation en détail. Garde en tête le parallèle avec Zod.

**fastapi.tiangolo.com → *Concurrency and async / await***, qui explique précisément quand utiliser `async def` et quand `def` — le point qui déroute.

Relis le palier 4, leçon 04 (Zod) : la correspondance Pydantic/Zod est la clé de cette leçon.

---

## 🤖 Le mini-projet à demander à l'IA

Le transfert Zod → Pydantic :

> « Je suis en formation de développeur, palier 5. J'ai validé mes données avec Zod en TypeScript au palier 4. Je découvre Pydantic avec FastAPI. Sans me donner de code, aide-moi à faire la correspondance : pour chaque validation Zod que je connais (positif, longueur, optionnel, enum, union, déduction du type), quel est l'équivalent Pydantic ? Présente ça comme un quiz : donne-moi le schéma Zod, je propose le modèle Pydantic. Ensuite, explique-moi ce que FastAPI ajoute par rapport à ce que je faisais avec un middleware Zod dans Express (la doc auto, la conversion des paramètres). »

Puis l'exercice sur l'async :

> « Donne-moi 8 routes décrites en français (un calcul de total sur des données en mémoire, un appel à une API météo externe, une requête de base de données, un tri d'une grande liste, un appel à une API d'IA...). Pour chacune, demande-moi : `async def` ou `def`, et pourquoi ? Corrige en expliquant quand l'async aide (I/O) et quand il ne sert à rien voire bloque (calcul). Relie au piège de l'event loop du palier 1. »

---

## 🛠️ À faire

1. **Le squelette** : une app FastAPI avec une route de santé, et ouvre `/docs` pour voir la documentation auto-générée.
2. **⭐ Un modèle Pydantic** : `NouvelleDepense` avec contraintes (`montant` positif, `description` de longueur limitée). Écris à côté le schéma Zod équivalent du palier 4 et compare.
3. **La validation gratuite** : une route `POST /depenses` typée avec ton modèle. Envoie `{"montant": -5}` et constate le 422 détaillé que tu n'as pas programmé.
4. **Les paramètres typés** : `GET /depenses/{id}` avec `id: int`, et un paramètre de requête `categorie` optionnel. Envoie un id non numérique et constate le 422.
5. **`response_model`** : une route qui renvoie un utilisateur sans son hash de mot de passe, grâce au modèle de réponse. Vérifie que le hash n'apparaît pas.
6. **La documentation** : ajoute `summary`, `description`, `status_code` à tes routes, et admire `/docs`. Teste une route depuis le navigateur.
7. **Exporte l'OpenAPI** : récupère le JSON OpenAPI (`/openapi.json`) et note qu'il décrit toute ton API.
8. **⭐ L'async** : une route `async` qui appelle une API externe avec `httpx` et `await`. Compare avec la version synchrone.
9. **Le piège de l'async** : mets un calcul lourd synchrone (`time.sleep(5)`) dans une route `async`, appelle-la, et appelle une autre route en parallèle. Constate le blocage. Explique le lien avec le palier 1, leçon 11.
10. **La gestion d'erreurs** : utilise `HTTPException` et un `@app.exception_handler` pour tes erreurs métier.
11. **Le bilan** : note dans ton journal ce que FastAPI apporte par rapport à Flask, et situe les deux dans le comparatif des philosophies.

<details>
<summary>Corrections et points de contrôle</summary>

**3.** En envoyant `{"montant": -5}`, tu reçois un `422` avec un `detail` précisant que `montant` doit être supérieur à 0 — **sans avoir écrit une seule ligne de validation**. C'est le type Pydantic qui l'a déclenché. Au palier 4, tu obtenais le même résultat, mais en écrivant un middleware Zod explicite ; ici, le type suffit. C'est la différence entre « je branche la validation » et « la validation est le type ».

**8 et 9.** `async def` + `await httpx.get(...)` permet à FastAPI de servir d'autres requêtes pendant l'attente de l'API externe — c'est l'intérêt de l'async pour l'I/O. Mais `time.sleep(5)` dans une route `async` **bloque l'event loop** : toutes les requêtes attendent, exactement comme en Node (palier 1, leçon 11), parce qu'un calcul synchrone ne rend pas la main. La règle : `await` pour attendre une I/O (bien), calcul lourd synchrone (mal, utilise `def` que FastAPI met dans un thread). C'est le même modèle mental qu'au palier 1, dans un troisième langage.

**5.** Sans `response_model`, FastAPI renvoie tout l'objet, hash compris. Avec `response_model=UtilisateurPublic`, il ne garde que les champs du modèle public : le hash est filtré automatiquement. C'est la version déclarative du `({ empreinte, ...reste })` du palier 4 (leçon 08) — une protection de sécurité, intégrée au framework et documentée.
</details>

---

## ✅ Acquis si…

- [ ] Je crée une API FastAPI avec des modèles Pydantic.
- [ ] Je reconnais Pydantic comme l'équivalent de Zod : validation à l'exécution + type.
- [ ] La validation se déclenche par le type, et je comprends le 422.
- [ ] Je type mes paramètres de chemin et de requête.
- [ ] J'utilise `response_model` pour ne jamais fuiter de champ sensible.
- [ ] Ma documentation `/docs` est riche, et je sais l'exporter en OpenAPI.
- [ ] Je sais quand utiliser `async def` (I/O) et quand `def` (calcul).
- [ ] Je connais le piège du calcul lourd dans une route async, et son lien avec le palier 1.
- [ ] J'ai une gestion d'erreurs centralisée avec `HTTPException` et `exception_handler`.
- [ ] Je situe FastAPI dans le comparatif : micro / API moderne / tout inclus.

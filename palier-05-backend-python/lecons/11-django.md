# Leçon 11 — Django : le framework « batteries incluses »

> 🎯 **À la fin de cette leçon** : tu livres une application Django complète, et tu comprends la philosophie opposée à Flask — tout est fourni, tout est conventionné.
> ⏱️ 10 h, la leçon la plus longue du parcours · **Prérequis** : leçons 01–10. **C'est le framework du projet 5.**
>
> C'est beaucoup, et c'est normal : Django est vaste. Avance par morceaux, construis l'application du [projet 5](../projet.md) en parallèle, et ne cherche pas à tout retenir d'un coup.

---

## De quoi on parle

**Django** est un framework web Python **« batteries incluses »** : il fournit tout — ORM, migrations, authentification, interface d'administration, formulaires, sécurité, gestion des fichiers statiques. C'est la philosophie **opposée à Flask** : là où Flask te laisse composer, Django décide pour toi et impose une structure.

Son découpage s'appelle **MVT** (*Model-View-Template*) : les **modèles** décrivent les données (via l'ORM), les **vues** traitent les requêtes, les **templates** rendent le HTML. C'est le découpage en couches du palier 4, avec un vocabulaire propre.

Django se structure en **projet** (l'application entière) et en **apps** (des modules réutilisables par domaine). Et **Django REST Framework** (DRF) est l'extension pour construire des API JSON par-dessus Django — ce que tu utiliseras pour servir un frontend React.

---

## À quoi ça sert, concrètement

**Parce que Django fournit ce que tu as construit à la main — et bien plus.** Ton mini-framework (leçons 04-08) avait un routeur, une couche de données, des templates. Django a tout ça, plus un ORM complet avec migrations, une authentification prête à l'emploi, et surtout une **interface d'administration auto-générée**. Tu mesures, par contraste avec ton travail manuel, ce qu'un framework « batteries incluses » apporte.

**Parce que l'admin auto-générée est une arme décisive pour les projets clients.** C'est le point à retenir de Django : à partir de tes modèles, il génère un back-office complet — créer, lire, modifier, supprimer, rechercher, filtrer, gérer les droits. Des semaines de développement, gratuites. Pour un projet client (ton palier 6 en posture client), pouvoir livrer un back-office dès le premier jour est un argument commercial majeur.

**Parce que c'est massivement utilisé, et recherché.** Django fait tourner d'innombrables applications de gestion, de sites de contenu, de plateformes. Les offres Django sont nombreuses, et le framework est stable depuis quinze ans.

**Et parce que c'est le troisième ORM du parcours.** Tu as vu Prisma (palier 4, Data Mapper) ; Django a son propre ORM, en **Active Record** (l'objet sait se sauver : `depense.save()`). Comparer les deux philosophies est exactement ce que tu feras au palier 7.

---

## Où ça intervient dans le développement

Django clôt le comparatif des philosophies de frameworks :

```
   ton mini-framework   →   tout à la main
   Flask                →   micro : le cœur, tu composes
   FastAPI              →   API moderne typée
   DJANGO (cette leçon) →   TOUT inclus, structure IMPOSÉE
```

Trois points de transfert.

**Le MVT est le découpage du palier 4, nommé autrement.** Les modèles sont ta couche de données, les vues tes contrôleurs + services, les templates ton SSR (leçon 08). Django impose ce découpage au lieu de te laisser le choisir — et c'est précisément pour avoir construit ce découpage à la main (palier 4 et mini-framework) que tu comprends **pourquoi** Django est fait ainsi.

**L'ORM de Django prolonge SQL et Prisma.** Le SQL que tu as écrit à la main (palier 4, leçon 05) et le pattern ORM (leçon 07) se retrouvent : tu définis des modèles, Django génère les migrations et les requêtes. Le problème N+1 existe aussi (`select_related`), et tu sais le reconnaître. La différence de philosophie avec Prisma (Active Record contre Data Mapper) est le cœur du comparatif du palier 7.

**Et DRF produit l'API que React consomme.** Au palier 3, ton React consommait une API JSON. Django seul fait du SSR (templates), mais avec DRF il sert du JSON — serializers (le `response_model` de FastAPI, les schémas Zod), viewsets, permissions. C'est le pont entre ton frontend du palier 3 et ce backend. Et DRF génère aussi une spécification OpenAPI (fil rouge gestion de projet).

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas être désorienté au début : Django impose beaucoup de conventions, de fichiers, de « magie ». Après la transparence de ton mini-framework, c'est un choc. Puis tu vas découvrir l'admin auto-générée et comprendre le marché : tu acceptes les conventions, et en échange tu obtiens énormément gratuitement.

Tu vas aussi passer du temps sur les migrations (`makemigrations`, `migrate`) — le mécanisme que tu connais du palier 4, ici central et automatisé.

### En équipe, en entreprise

**Django structure le projet pour toi**, et c'est sa force en équipe : tous les projets Django se ressemblent, donc on s'y retrouve vite. La « magie » est un coût d'apprentissage initial pour un gain de cohérence à long terme.

**L'admin est utilisée en production**, pas seulement en développement : beaucoup d'équipes l'offrent comme back-office aux utilisateurs internes. C'est une des raisons du choix de Django.

**DRF est quasi systématique pour les API.** Django + DRF est une stack très répandue pour servir un frontend React ou une application mobile.

**Et tu entendras « Django ou FastAPI ? ».** Django pour une application complète avec back-office et SSR ; FastAPI pour une API pure, moderne et typée. Le débat est réel, et ta pratique des deux te permet d'y répondre avec des critères.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : les modèles et les migrations, l'ORM (`.objects.filter()`, `.get()`, `.create()`), l'admin, les vues, les URL, et les serializers/viewsets de DRF.

Régulièrement : `select_related`/`prefetch_related` (contre le N+1), l'authentification intégrée, les permissions DRF, les formulaires, `settings.py` et les environnements, les signaux.

Rare, et hors sujet pour l'instant : les vues génériques complexes, les middlewares personnalisés, les gestionnaires de modèles avancés, le cache, Celery (les tâches de fond), les channels (WebSockets), les commandes de gestion personnalisées. Django est immense ; tu en apprendras une fraction, suffisante pour livrer, et tu approfondiras par besoin.

---

## La mécanique

> Cette section est un survol dense : le vrai apprentissage se fait en construisant le projet 5 en parallèle, pas en lisant.

### Créer un projet et une app

```bash
pip install django djangorestframework
django-admin startproject config .          # le projet (configuration)
python manage.py startapp depenses          # une app par domaine
```

Django sépare le **projet** (`config/`, la configuration globale) des **apps** (`depenses/`, un domaine métier). Une app regroupe ses modèles, vues, URL, templates. C'est le découpage en modules du palier 5 (leçon 03), imposé par Django.

### Les modèles (l'ORM)

```python
# depenses/models.py
from django.db import models

class Categorie(models.Model):
    nom = models.CharField(max_length=50, unique=True)

    def __str__(self):                               # pour l'admin et le débogage
        return self.nom

class Depense(models.Model):
    montant = models.IntegerField()                  # centimes
    description = models.CharField(max_length=200)
    date = models.DateField()
    categorie = models.ForeignKey(Categorie, on_delete=models.PROTECT, related_name="depenses")
    cree_le = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.description} ({self.montant})"
```

Tu reconnais la modélisation du palier 4 (leçon 06) : clé primaire (implicite), `ForeignKey` (clé étrangère), `on_delete=PROTECT` (ton `ON DELETE RESTRICT`), les contraintes. Django génère le schéma SQL depuis ces classes — c'est l'ORM, en **Active Record** : le modèle *est* la table.

### Les migrations

```bash
python manage.py makemigrations             # génère les fichiers de migration depuis les modèles
python manage.py migrate                    # les applique à la base
```

C'est le mécanisme du palier 4 (leçon 07), automatisé : Django compare tes modèles à l'état de la base et génère la migration. Les fichiers sont **versionnés dans Git** (comme Prisma), et la règle est la même : on ne modifie pas une migration appliquée, on en écrit une nouvelle.

### L'ORM à l'usage

```python
# Lire
Depense.objects.all()
Depense.objects.filter(categorie__nom="food").order_by("-date")
Depense.objects.get(id=42)                   # lève DoesNotExist si absent
Depense.objects.filter(montant__gt=100000)   # __gt : greater than

# Écrire (Active Record : l'objet se sauve lui-même)
d = Depense(montant=1500, description="déjeuner", date="2026-10-19", categorie=cat)
d.save()                                      # ⭐ l'objet se persiste
# ou
Depense.objects.create(montant=1500, ...)

# Agrégats (ton GROUP BY)
from django.db.models import Sum
Depense.objects.values("categorie__nom").annotate(total=Sum("montant"))
```

Le `d.save()` est la signature de l'**Active Record** : l'objet connaît sa propre persistance. Compare avec Prisma (palier 4), où c'était `prisma.depense.create({data})` — un client séparé traduit, c'est le **Data Mapper**. Deux philosophies, et c'est le cœur du comparatif du palier 7.

### ⭐ Le problème N+1, encore

```python
# ❌ N+1 : une requête pour la liste, puis une par dépense pour sa catégorie
for d in Depense.objects.all():
    print(d.categorie.nom)                    # chaque accès = une requête

# ✅ select_related : une seule requête avec jointure
for d in Depense.objects.select_related("categorie"):
    print(d.categorie.nom)
```

C'est **exactement** le N+1 du palier 4 (leçon 07, où c'était `include` avec Prisma). `select_related` fait la jointure (relation un-à-plusieurs), `prefetch_related` fait une seconde requête groupée (relation plusieurs-à-plusieurs). Tu reconnais le problème et sa solution, dans un troisième contexte — la preuve que c'est un concept d'architecture, pas un détail d'outil.

### ⭐ L'admin auto-générée : l'arme décisive

```python
# depenses/admin.py
from django.contrib import admin
from .models import Depense, Categorie

admin.site.register(Categorie)

@admin.register(Depense)
class DepenseAdmin(admin.ModelAdmin):
    list_display = ("description", "montant", "categorie", "date")
    list_filter = ("categorie", "date")
    search_fields = ("description",)
```

```bash
python manage.py createsuperuser            # crée un compte admin
```

En quelques lignes, tu obtiens un **back-office complet** sur `/admin` : lister, créer, modifier, supprimer, rechercher, filtrer, avec gestion des droits. Imagine ce qu'il t'aurait fallu écrire à la main (ton mini-framework n'avait rien de tout ça). **C'est le gain le plus spectaculaire de Django**, et l'argument à retenir pour un projet client.

### La MVT : vues et templates (SSR)

```python
# depenses/views.py
from django.shortcuts import render, get_object_or_404

def liste(request):
    depenses = Depense.objects.select_related("categorie").all()
    return render(request, "depenses/liste.html", {"depenses": depenses})

def detail(request, id):
    depense = get_object_or_404(Depense, id=id)   # 404 automatique si absent
    return render(request, "depenses/detail.html", {"depense": depense})
```

```python
# config/urls.py
from django.urls import path
from depenses import views

urlpatterns = [
    path("depenses/", views.liste, name="liste"),
    path("depenses/<int:id>/", views.detail, name="detail"),
]
```

`render` utilise le moteur de templates de Django (très proche de Jinja2, leçon 08) avec échappement automatique. `path("depenses/<int:id>/")` est le routeur avec paramètre typé que tu as construit (leçon 05) et vu dans Flask. C'est le SSR du palier 5, intégré.

### ⭐ Django REST Framework : servir du JSON à React

```python
# depenses/serializers.py
from rest_framework import serializers
from .models import Depense

class DepenseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Depense
        fields = ["id", "montant", "description", "date", "categorie"]   # les champs exposés
```

```python
# depenses/views.py
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

class DepenseViewSet(viewsets.ModelViewSet):
    queryset = Depense.objects.select_related("categorie").all()
    serializer_class = DepenseSerializer
    permission_classes = [IsAuthenticated]        # authentification requise
```

Un `ModelViewSet` génère **toutes les routes REST** (liste, détail, création, modification, suppression) du palier 4 (leçon 03), avec les bons codes de statut. Le **serializer** est à la fois la validation (comme Zod/Pydantic) et le filtre de sortie (le `response_model` de FastAPI, le « ne pas fuiter le hash » du palier 4) : il choisit les champs exposés. Les `permission_classes` gèrent l'autorisation (palier 4, leçon 08). C'est l'API JSON que ton React du palier 3 consommera — et DRF génère aussi sa documentation.

### La configuration et la sécurité

```python
# config/settings.py — JAMAIS les secrets en dur
import os
SECRET_KEY = os.environ["DJANGO_SECRET_KEY"]
DEBUG = os.environ.get("DEBUG", "False") == "True"
ALLOWED_HOSTS = os.environ.get("ALLOWED_HOSTS", "").split(",")
```

> ⚠️ **`DEBUG = True` en production est une faille.** Comme `debug=True` de Flask et les traces exposées du palier 4 (leçon 04), `DEBUG = True` affiche la trace complète, les variables et la configuration à tout visiteur en cas d'erreur. En production : `DEBUG = False`, `ALLOWED_HOSTS` configuré, `SECRET_KEY` dans l'environnement. C'est le premier point de la checklist de déploiement.

### Servir en production

```bash
gunicorn config.wsgi:application            # le gunicorn que tu connais (leçon 04)
python manage.py collectstatic              # rassemble les fichiers statiques pour Nginx
```

> ⚠️ `python manage.py runserver` est le serveur de **développement** — mono-processus, non optimisé, **jamais en production** (comme `wsgiref` leçon 04 et `app.run()` de Flask). En production : gunicorn sur `config.wsgi:application` (tu reconnais le `module:variable` de la leçon 04), derrière Nginx (palier 8), sur AWS (projet 5).

---

## Les problèmes que tu vas rencontrer

**`makemigrations` ne détecte pas mes changements.** L'app n'est pas dans `INSTALLED_APPS` de `settings.py`, ou tu as oublié de sauvegarder le modèle.

**Une migration échoue sur des données existantes.** Ajouter un champ `NOT NULL` sans valeur par défaut sur une table pleine : c'est le problème du palier 4 (leçon 07), et Django demande une valeur par défaut au moment du `makemigrations`.

**Mon application est lente.** Un N+1. Active le journal des requêtes (Django Debug Toolbar) et ajoute `select_related`/`prefetch_related`.

**`DoesNotExist` fait planter ma vue.** `.get()` lève une exception si l'objet est absent. Utilise `get_object_or_404()` pour un 404 propre.

**`DEBUG = True` expose mes traces en production.** Faille. `DEBUG = False`, toujours, en production.

**Mon admin ne montre pas mon modèle.** Tu ne l'as pas enregistré dans `admin.py`.

**Mon serializer expose un champ sensible.** Tu l'as mis dans `fields`. Comme le `response_model` de FastAPI, le serializer ne doit exposer que les champs publics — jamais un hash de mot de passe.

**CORS bloque mon frontend React.** Django ne gère pas CORS par défaut ; installe `django-cors-headers`. C'est le CORS du palier 2 et 4, côté serveur.

**`runserver` en production.** Jamais. gunicorn.

---

## Ce qu'on te demandera

En **entretien Django**, les questions portent sur l'ORM, les migrations, l'admin, et DRF : « qu'est-ce que le MVT ? », « comment fonctionnent les migrations ? », « qu'est-ce qu'un serializer ? », « comment évites-tu le N+1 ? ».

Pour ton profil, les questions qui portent : **« Flask, FastAPI ou Django — quand choisis-tu quoi ? »** (le comparatif), et **« quelle différence entre l'ORM de Django et Prisma ? »** (Active Record contre Data Mapper). Tu as pratiqué les deux, donc tu réponds avec des critères.

En **test technique**, on apprécie une app Django propre : modèles bien conçus, pas de N+1, serializers qui n'exposent que le nécessaire, `DEBUG=False` en configuration de production.

---

## Ce qui te démarquera

**Comprendre la philosophie « batteries incluses » par contraste.** « J'ai construit un mini-framework, utilisé Flask (micro) et FastAPI (API typée) ; Django fournit tout et impose une structure » montre que tu situes Django dans un paysage, pas que tu l'as juste appris.

**L'admin comme argument client.** Savoir dire « avec Django, je livre un back-office complet dès le premier jour » est un argument commercial que tu utiliseras au palier 6.

**Reconnaître le N+1, encore.** Le voir dans un troisième contexte (après JavaScript et Prisma) prouve que c'est un concept maîtrisé.

**Active Record contre Data Mapper.** Pouvoir comparer l'ORM de Django (`d.save()`) et Prisma (`prisma.depense.create()`) est exactement le comparatif d'architecture du palier 7.

**Et `DEBUG = False` en production.** Le réflexe de sécurité qui relie Flask, le palier 4 et Django.

---

## 📚 À lire

**docs.djangoproject.com → *Writing your first Django app*** : le tutoriel officiel en 7 parties. **Fais-le en entier, clavier en main** — c'est la meilleure introduction à Django, et il couvre les modèles, l'admin, les vues et les tests.

**django-rest-framework.org → *Tutorial*** et ***Quickstart*** : pour DRF, les serializers et les viewsets.

**docs.djangoproject.com → *Deployment checklist*** : la liste officielle à vérifier avant la production (`DEBUG`, `ALLOWED_HOSTS`, `SECRET_KEY`...). Indispensable pour le projet 5 sur AWS.

**Django ORM → *Making queries*** et la section sur `select_related`/`prefetch_related` (le N+1).

---

## 🤖 Le mini-projet à demander à l'IA

Django est vaste : fais-toi guider pour construire le projet 5, pas pour tout mémoriser.

> « Je suis en formation de développeur, palier 5. Je construis une application de gestion en Django + DRF pour mon projet 5, qui sera déployée sur AWS. J'ai déjà construit un mini-framework Python et utilisé Flask et FastAPI. Sans écrire mon code à ma place, sers-moi de guide étape par étape : les modèles d'abord, puis les migrations, puis l'admin, puis les vues/templates, puis DRF pour l'API. À chaque étape, fais la correspondance avec ce que je connais (mon mini-framework, le palier 4, Prisma, Zod/Pydantic) et pose-moi des questions pour vérifier que je comprends la convention Django au lieu de la copier. »

Puis le comparatif, qui prépare le palier 7 :

> « Aide-moi à remplir un tableau comparatif : ton mini-framework, Flask, FastAPI, Django — sur les axes philosophie (opinionated ou non), ORM et son pattern, validation, documentation, admin, courbe d'apprentissage, et cas d'usage idéal. Pose-moi des questions pour chaque case plutôt que de la remplir, en t'appuyant sur ce que j'ai pratiqué. Puis demande-moi : pour trois projets différents (une API mobile, un site de gestion avec back-office, un microservice), lequel je choisirais et pourquoi. »

---

## 🛠️ À faire

> Construis le [projet 5](../projet.md) en parallèle de cette leçon — c'est la meilleure façon d'apprendre Django.

1. **Projet et app** : crée un projet Django et une app `depenses`. Ajoute l'app à `INSTALLED_APPS`.
2. **Les modèles** : `Categorie` et `Depense` avec `ForeignKey`, contraintes, et `__str__`. Reconnais la modélisation du palier 4.
3. **Migrations** : `makemigrations` puis `migrate`. Ouvre le fichier de migration généré et compare-le au SQL que tu aurais écrit.
4. **L'ORM** : dans le shell Django (`python manage.py shell`), crée, lis, filtre et agrège des dépenses. Note la signature Active Record (`d.save()`).
5. **⭐ L'admin** : enregistre tes modèles, crée un superuser, et explore `/admin`. Mesure ce que tu obtiens gratuitement — note-le dans ton journal.
6. **Le N+1** : affiche une liste de dépenses avec leur catégorie, d'abord sans `select_related` (observe les requêtes avec la Debug Toolbar), puis avec. Compare avec le N+1 du palier 4.
7. **MVT** : une vue liste et une vue détail avec des templates (SSR). Utilise `get_object_or_404`.
8. **⭐ DRF** : un serializer et un `ModelViewSet` pour exposer tes dépenses en JSON. Vérifie les routes REST générées et les codes de statut.
9. **Sécurité du serializer** : assure-toi que ton serializer n'expose aucun champ sensible.
10. **Configuration de production** : `DEBUG=False`, `SECRET_KEY` et `ALLOWED_HOSTS` depuis l'environnement. Suis la checklist de déploiement officielle.
11. **CORS** : installe `django-cors-headers` et autorise ton frontend React. Teste depuis une app React.
12. **Le comparatif** : remplis le tableau mini-framework / Flask / FastAPI / Django, et écris pour quel type de projet tu choisirais chacun. C'est la préparation directe du palier 7.

<details>
<summary>Corrections et points de contrôle</summary>

**5.** L'admin te donne, sans une ligne de code supplémentaire : la liste paginée avec recherche et filtres, les formulaires de création et de modification validés, la suppression avec confirmation, la gestion des utilisateurs et des permissions. Ton mini-framework (leçons 04-08) n'avait **rien** de tout ça — il t'aurait fallu des semaines pour le construire. **C'est le gain le plus spectaculaire de Django**, et l'argument que tu réutiliseras en posture client au palier 6.

**6.** C'est le même N+1 qu'au palier 4 (leçon 07, avec Prisma) et que le motif `find` dans une boucle du palier 1 (leçon 12). Sans `select_related`, la Debug Toolbar montre une requête pour la liste, puis une par dépense pour sa catégorie. Avec `select_related("categorie")`, une seule requête avec jointure. **Trois contextes, un même problème** — la preuve que c'est un concept d'architecture.

**8.** Un `ModelViewSet` génère toutes les routes REST du palier 4 (leçon 03) : `GET /depenses/` (liste), `POST /depenses/` (création, 201), `GET /depenses/{id}/` (détail), `PUT`/`PATCH` (modification), `DELETE` (204). Avec les bons codes de statut, la pagination, et la documentation. Tu avais conçu ce contrat à la main au palier 4 ; DRF le génère depuis ton modèle et ton serializer.

**12.** Le comparatif attendu : **mini-framework** (tout à la main, rien de caché, pédagogique) · **Flask** (micro, non-opinionated, tu composes, comme Express) · **FastAPI** (API moderne typée, validation et doc automatiques via Pydantic) · **Django** (batteries incluses, opinionated, admin, ORM Active Record). Choix type : API mobile → FastAPI ou DRF ; site de gestion avec back-office → Django (l'admin) ; microservice simple → Flask ou FastAPI. **C'est le document d'architecture du palier 7, et ta meilleure réponse à "quand choisir quoi ?" en entretien.**
</details>

---

## ✅ Acquis si…

- [ ] Je crée un projet Django structuré en apps.
- [ ] Je définis des modèles avec relations et contraintes, et je reconnais la modélisation du palier 4.
- [ ] Je gère les migrations, et je sais qu'on ne modifie pas une migration appliquée.
- [ ] J'utilise l'ORM, et je reconnais sa philosophie Active Record (`d.save()`).
- [ ] J'exploite l'admin auto-générée, et je sais pourquoi c'est un argument client.
- [ ] Je reconnais et corrige le N+1 avec `select_related`, pour la troisième fois du parcours.
- [ ] Je sers du HTML en MVT (SSR) et du JSON avec DRF.
- [ ] Mes serializers n'exposent aucun champ sensible.
- [ ] Je configure `DEBUG=False`, `ALLOWED_HOSTS` et `SECRET_KEY` pour la production.
- [ ] Je sers avec gunicorn, jamais `runserver`, et je sais faire `collectstatic`.
- [ ] Je peux comparer les quatre frameworks et dire quand choisir chacun.
- [ ] 🚦 Je suis prêt pour le [projet 5](../projet.md) et l'[épreuve de sortie](../evaluation.md).

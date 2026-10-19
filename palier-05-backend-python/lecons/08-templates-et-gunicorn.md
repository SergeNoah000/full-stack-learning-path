# Leçon 08 — Templates (`string.Template` puis Jinja2) + servir avec gunicorn

> 🎯 **À la fin de cette leçon** : ton mini-framework rend du HTML côté serveur, et tu découvres le SSR — l'approche historique du web, celle de PHP au palier suivant.
> ⏱️ 4 h · **Prérequis** : leçons 04–07. **Dernière leçon du module "natif d'abord".**

---

## De quoi on parle

Un **template** (ou gabarit) est un fichier HTML avec des **trous** qu'on remplit avec des données. Au lieu d'assembler du HTML par concaténation de chaînes dans ton code (illisible et dangereux), tu écris le HTML dans un fichier et tu y injectes les variables.

```html
<h1>Dépenses de {{ nom }}</h1>
<ul>
  {% for d in depenses %}
    <li>{{ d.description }} : {{ d.montant }}</li>
  {% endfor %}
</ul>
```

Cette approche s'appelle le **SSR** (*server-side rendering*, rendu côté serveur) : le serveur produit le HTML complet et l'envoie au navigateur, qui n'a plus qu'à l'afficher. C'est l'inverse de ce que tu as fait au palier 3 avec React (où le navigateur construit le HTML depuis des données).

**Jinja2** est le moteur de templates de référence en Python. Il gère les variables, les boucles, les conditions, l'héritage de gabarits, et surtout **l'échappement automatique** — la protection contre la XSS (palier 4, leçon 09). `string.Template` est l'équivalent minimal de la bibliothèque standard, que tu verras d'abord pour comprendre le principe.

---

## À quoi ça sert, concrètement

**Parce que c'est l'approche historique et toujours vivante du web.** Avant les applications React, le web fonctionnait presque entièrement en SSR : le serveur renvoyait du HTML, chaque clic rechargeait une page. C'est encore le cas de l'immense majorité des sites — WordPress, les sites Django et Laravel, les blogs. Et c'est **exactement** le modèle de PHP, que tu abordes au palier 6. Comprendre le SSR ici prépare directement le palier suivant.

**Parce que le SSR a des avantages réels que React n'a pas.** La page arrive complète et affichable immédiatement (pas d'écran blanc le temps que le JavaScript charge), le référencement est naturel (le contenu est dans le HTML), et c'est plus simple pour beaucoup de sites. Savoir quand choisir le SSR plutôt qu'une application React est une vraie décision d'architecture (palier 7).

**Parce que l'échappement automatique est une protection de sécurité centrale.** Jinja2 échappe par défaut toute variable affichée, ce qui neutralise la XSS (palier 4, leçon 09). Tu as vu la faille ; ici tu vois la protection intégrée. Et tu comprends pourquoi `htmlspecialchars` sera omniprésent en PHP (palier 6) : c'est le même besoin, à la main.

**Et parce que ça termine ton mini-framework.** Avec les templates, ton framework maison peut rendre une vraie application web complète — formulaires, listes, pages. Le bilan « ce que j'ai construit = un framework » devient complet.

---

## Où ça intervient dans le développement

Les templates sont la dernière brique de ton mini-framework, et ils introduisent une alternative à React :

```
   DEUX FAÇONS DE PRODUIRE DU HTML
   ───────────────────────────────
   SSR (cette leçon, PHP au palier 6)        SPA (React, palier 3)
   le serveur produit le HTML complet         le serveur renvoie des données (JSON)
   → affichage immédiat, SEO naturel          → le navigateur construit le HTML
   → un rechargement par navigation           → pas de rechargement, plus interactif
```

Trois points structurants.

**Le SSR complète le JSON.** Jusqu'ici, ton mini-framework (et ton API Node du palier 4) renvoyaient du **JSON**, consommé par un frontend React. Avec les templates, le serveur renvoie du **HTML**. Ce sont deux modes, et une application réelle peut mélanger les deux. Tu découvres ici le mode que React t'avait fait oublier.

**C'est le pont vers PHP.** Le palier 6 est entièrement en SSR : PHP a été conçu pour ça. Les templates de cette leçon (et l'échappement) sont exactement ce que tu referas en PHP natif, puis avec Blade (Laravel). Comprendre le SSR maintenant rend le palier 6 beaucoup plus clair.

**Et gunicorn boucle le déploiement.** Tu as rencontré gunicorn à la leçon 04 (il sert ton app WSGI). Ici, tu sers ton mini-framework complet avec lui, en conditions proches de la production — ce qui prépare le déploiement AWS du palier 5 (projet Django) et le palier 8 (DevOps).

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas d'abord assembler du HTML par concaténation de chaînes (comme un débutant), puis sentir à quel point c'est pénible et dangereux, puis découvrir les templates. C'est le bon ordre : ressentir le problème avant la solution.

Tu vas aussi tenter d'afficher une donnée utilisateur contenant du HTML, et constater que Jinja2 l'échappe automatiquement — la XSS du palier 4, neutralisée par défaut.

### En équipe, en entreprise

**Le SSR est très répandu**, bien plus que ne le laissent croire les discussions centrées sur React. WordPress (40 % du web), les sites Django, Laravel, Rails : tous en SSR. Et il revient en force avec les frameworks « méta » (Next.js, Remix) qui font du SSR en React — preuve que l'approche n'est pas dépassée.

**L'échappement automatique est la norme**, et le désactiver est un acte explicite et surveillé (comme `dangerouslySetInnerHTML` en React). Un relecteur signale toute donnée affichée sans échappement.

**Tu verras l'héritage de templates.** Un gabarit de base (`base.html`) définit la structure commune, et les pages en héritent. C'est le moyen d'éviter de répéter l'en-tête et le pied sur chaque page — l'équivalent des composants de mise en page de React.

**Et tu entendras le débat SSR vs SPA.** Les deux ont leur place, et la réponse mature est « ça dépend du site » : un blog ou un site vitrine en SSR, une application interactive en SPA. Savoir exposer ce choix est une compétence d'architecte.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : comprendre le SSR, l'échappement automatique, les variables et boucles dans un template, l'héritage de gabarits, et servir avec gunicorn.

Rare et hors sujet : les filtres Jinja2 avancés, les macros, les extensions personnalisées, le cache de templates, le streaming de templates, les détails de configuration de gunicorn (workers, threads — abordés au palier 8). Tu les rencontreras par besoin.

---

## La mécanique

### D'abord, le problème : le HTML par concaténation

```python
# ❌ Illisible ET dangereux (faille XSS)
html = "<h1>Dépenses de " + nom + "</h1><ul>"
for d in depenses:
    html += "<li>" + d["description"] + " : " + str(d["montant"]) + "</li>"
html += "</ul>"
```

Deux problèmes. C'est **illisible** : le HTML est noyé dans du code Python. Et c'est **dangereux** : si `nom` ou `description` vient d'un utilisateur et contient du HTML, il s'exécute dans la page — c'est la XSS du palier 4. Les templates résolvent les deux.

### `string.Template` : le principe minimal

```python
from string import Template

gabarit = Template("<h1>Dépenses de $nom</h1>")
html = gabarit.substitute(nom="Serge")
```

`string.Template` (bibliothèque standard, rien à installer) montre le principe : un texte avec des `$variables` qu'on remplit. Mais il est limité — pas de boucles, pas de conditions, **pas d'échappement**. C'est pédagogique, pas suffisant pour de vrai. D'où Jinja2.

### ⭐ Jinja2 : le vrai moteur

```bash
pip install jinja2
```

```python
from jinja2 import Environment, FileSystemLoader

env = Environment(
    loader=FileSystemLoader("templates"),
    autoescape=True,                            # ⭐ échappement automatique : contre la XSS
)

def rendre(nom_template, **contexte):
    template = env.get_template(nom_template)
    return template.render(**contexte)

# Usage dans une vue
def lister_depenses(request):
    depenses = service.lister()
    html = rendre("depenses.html", depenses=depenses, nom="Serge")
    return Response(html, content_type="text/html; charset=utf-8")
```

```html
<!-- templates/depenses.html -->
<h1>Dépenses de {{ nom }}</h1>
<ul>
  {% for d in depenses %}
    <li>{{ d.description }} : {{ d.montant }} FCFA</li>
  {% else %}
    <li>Aucune dépense pour le moment.</li>   {# l'état vide, comme au palier 2 #}
  {% endfor %}
</ul>
```

La syntaxe : `{{ variable }}` affiche une valeur (en l'échappant), `{% ... %}` est une instruction (boucle, condition). Le `{% else %}` d'une boucle `for` gère le cas de la liste vide — l'état vide que tu traites depuis le palier 2.

### ⭐ L'échappement automatique : la protection XSS

```html
<!-- Si commentaire vaut : <script>alert('xss')</script> -->
<p>{{ commentaire }}</p>
<!-- Jinja2 affiche le texte échappé : &lt;script&gt;... — AUCUN script exécuté -->
```

Avec `autoescape=True`, Jinja2 transforme automatiquement les caractères dangereux (`<`, `>`, `&`, `"`) en entités HTML. Le script injecté s'affiche comme du texte inoffensif, il ne s'exécute pas. C'est la neutralisation de la XSS (palier 4, leçon 09), **par défaut** — tu n'as rien à faire.

C'est exactement ce que React faisait avec `{variable}` (palier 3). Et au palier 6, tu verras que PHP ne l'a **pas** par défaut : il faut appeler `htmlspecialchars` à la main sur chaque affichage. Comprendre la protection automatique ici te fera apprécier (et ne pas oublier) le geste manuel en PHP.

```html
<!-- Désactiver l'échappement : un acte EXPLICITE, à n'utiliser que sur du HTML de confiance -->
<div>{{ contenu_html | safe }}</div>
```

Le filtre `| safe` désactive l'échappement — c'est l'équivalent de `dangerouslySetInnerHTML` de React, et il porte le même avertissement : à n'utiliser que sur du HTML que **tu** maîtrises, jamais sur une donnée utilisateur.

### L'héritage de templates

```html
<!-- templates/base.html : la structure commune -->
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>{% block titre %}Mon app{% endblock %}</title>
</head>
<body>
  <nav>...</nav>
  <main>{% block contenu %}{% endblock %}</main>   {# le trou que les pages remplissent #}
  <footer>...</footer>
</body>
</html>
```

```html
<!-- templates/depenses.html : hérite de base.html -->
{% extends "base.html" %}

{% block titre %}Mes dépenses{% endblock %}

{% block contenu %}
  <h1>Dépenses</h1>
  <ul>{% for d in depenses %}<li>{{ d.description }}</li>{% endfor %}</ul>
{% endblock %}
```

L'héritage évite de répéter l'en-tête, la navigation et le pied sur chaque page : la structure commune est dans `base.html`, et chaque page ne définit que son contenu. C'est l'équivalent des composants de mise en page de React (palier 3, leçon 07) — même besoin, autre mécanisme. Tu retrouveras exactement ça avec Blade au palier 6.

### Servir avec gunicorn

```python
# app.py — l'application WSGI complète (routeur + Request/Response + modèles + templates)
app = creer_app(routeur)
```

```bash
# Développement : rechargement automatique
gunicorn app:app --reload

# Proche de la production : plusieurs processus de travail
gunicorn app:app --workers 4 --bind 0.0.0.0:8000
```

Tu sers maintenant ton mini-framework **complet** avec gunicorn, exactement comme tu serviras Django au palier 5. Les `--workers 4` lancent quatre processus parallèles — c'est ce qui permet de traiter plusieurs requêtes à la fois malgré le fil unique de Python (rappel du palier 1, leçon 11). Au palier 8, Nginx se placera devant gunicorn.

---

## Les problèmes que tu vas rencontrer

**Mon HTML s'affiche avec `&lt;` au lieu de `<`.** C'est l'échappement qui fait son travail — mais sur du HTML que tu voulais afficher tel quel. Utilise `| safe`, **uniquement** si le HTML est de confiance.

**Mon `<script>` injecté par un utilisateur s'exécute.** Tu as désactivé l'échappement (`autoescape=False` ou `| safe` sur une donnée utilisateur). Réactive l'échappement : c'est ta protection XSS.

**`TemplateNotFound`.** Le chemin du `FileSystemLoader` est incorrect, ou le fichier n'est pas au bon endroit. Vérifie le dossier `templates/`.

**Ma variable n'apparaît pas dans le template.** Tu ne l'as pas passée à `render()`, ou tu as une faute de frappe sur son nom. Jinja2 affiche une chaîne vide pour une variable absente (par défaut), ce qui masque l'erreur.

**Ma boucle `{% for %}` n'affiche rien.** La liste est vide (utilise `{% else %}`), ou tu as oublié `{% endfor %}`.

**Mon héritage ne marche pas.** Il manque `{% extends "base.html" %}` en première ligne, ou les noms de blocs ne correspondent pas entre `base.html` et la page.

**gunicorn ne recharge pas mes changements.** En développement, ajoute `--reload`. En production, on ne recharge pas (on redéploie).

**Ma page est lente avec beaucoup de données.** Le rendu de template a un coût ; pour de grandes listes, pense à la pagination (palier 4, leçon 03) — le même principe s'applique au SSR.

---

## Ce qu'on te demandera

En **entretien**, le SSR est une question d'architecture : « quelle différence entre le rendu côté serveur et une SPA ? », « quand choisirais-tu l'un ou l'autre ? ». La bonne réponse parle des compromis (SEO, premier affichage, interactivité) et non d'une préférence.

On peut demander : « qu'est-ce que l'échappement automatique et contre quoi ça protège ? » — la réponse est la XSS, et c'est le lien avec le palier 4.

En **travail réel**, si le projet est en SSR (Django, Laravel), tu écriras des templates tous les jours, et l'échappement sera un réflexe de sécurité.

---

## Ce qui te démarquera

**Comprendre le SSR comme un choix, pas comme du « vieux ».** Savoir dire « un blog ou un site vitrine, je le fais en SSR : plus simple, meilleur SEO ; une application interactive, en SPA » est un raisonnement d'architecte, et ça prépare le palier 7.

**L'échappement automatique comme réflexe de sécurité.** Savoir que Jinja2 protège par défaut, et que `| safe` est un acte explicite et risqué, montre que tu penses sécurité.

**Faire le lien avec PHP.** Dire « c'est le modèle de PHP que je vais voir au palier 6, et l'échappement que je devrai faire à la main avec htmlspecialchars » prouve une vision d'ensemble du parcours.

**Et le bilan du mini-framework.** Pouvoir dire « j'ai construit un routeur, une abstraction requête/réponse, une couche de données et un moteur de templates — donc un framework » est l'aboutissement du module « natif d'abord », et une réponse forte en entretien.

---

## 📚 À lire

**jinja.palletsprojects.com** → *Template Designer Documentation* : la référence de la syntaxe (variables, boucles, conditions, héritage, filtres). Garde-la ouverte.

**jinja.palletsprojects.com → *autoescaping*** : la page sur l'échappement automatique, à lire pour la sécurité.

**MDN → *Server-side vs client-side rendering*** (ou un article équivalent) pour le choix SSR/SPA, qui est le vrai sujet d'architecture.

Et prépare le palier 6 : garde en tête que PHP fera du SSR, mais **sans** échappement automatique — le `htmlspecialchars` que tu verras est exactement ce que Jinja2 fait pour toi ici.

---

## 🤖 Le mini-projet à demander à l'IA

Le bilan du mini-framework et le pont vers PHP :

> « Je suis en formation de développeur, palier 5. Je viens de terminer mon mini-framework Python (WSGI, routeur, Request/Response, couche modèles SQLite, templates Jinja2). Aide-moi à dresser le **bilan** : pose-moi des questions pour que je liste, brique par brique, tout ce que j'ai construit à la main, et pour chaque brique, demande-moi quel composant de Flask puis de Django y correspond. Ensuite, explique-moi en quoi le modèle SSR que je viens d'utiliser (le serveur rend le HTML) prépare le palier 6 (PHP), et ce que PHP fera différemment — notamment pour l'échappement. »

Puis le choix SSR vs SPA :

> « Décris-moi 6 types de sites web (un blog, un tableau de bord interactif, un site vitrine, une boutique, une application de messagerie, un site de documentation). Pour chacun, demande-moi : SSR ou SPA, et pourquoi (SEO, premier affichage, interactivité, complexité) ? Corrige mon raisonnement en pointant les compromis que j'ai manqués. »

---

## 🛠️ À faire

1. **Ressens le problème** : assemble une liste HTML par concaténation de chaînes en Python. Constate que c'est illisible, puis essaie d'y afficher une donnée contenant `<script>` et constate le danger.
2. **`string.Template`** : refais un affichage simple avec `string.Template`, et note ses limites (pas de boucle, pas d'échappement).
3. **Jinja2** : installe-le, configure l'environnement avec `autoescape=True`, et rends une page avec une variable et une boucle.
4. **L'état vide** : utilise `{% else %}` dans ta boucle pour afficher « Aucune dépense ».
5. **⭐ L'échappement** : affiche une donnée contenant `<script>alert('xss')</script>` et vérifie qu'elle est échappée (pas exécutée). Puis ajoute `| safe` et constate le danger — avant de l'enlever.
6. **L'héritage** : crée `base.html` avec un bloc `contenu`, et deux pages qui en héritent.
7. **Brancher sur le mini-framework** : fais que tes vues retournent du HTML rendu par Jinja2, avec le bon `Content-Type`.
8. **Servir avec gunicorn** : lance ton mini-framework complet avec `gunicorn app:app --reload`, puis avec `--workers 4`.
9. **Le lien avec PHP** : écris dans ton journal en quoi ce que tu viens de faire (le SSR, l'échappement) est le modèle de PHP, et ce qui changera au palier 6.
10. **Le bilan final** : liste dans ton journal toutes les briques de ton mini-framework et leur équivalent dans Flask et Django. C'est le livrable le plus révélateur du palier.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** La concaténation est illisible (le HTML noyé dans Python) et dangereuse : `"<li>" + d["description"]` avec une description contenant du HTML produit une XSS. C'est exactement le problème que les templates résolvent — lisibilité **et** sécurité.

**5.** Avec `autoescape=True`, `{{ commentaire }}` affiche `&lt;script&gt;alert(&#39;xss&#39;)&lt;/script&gt;` : le navigateur montre le texte, il n'exécute rien. Avec `| safe`, le script s'exécute — c'est pourquoi `| safe` ne s'applique qu'à du HTML de confiance, jamais à une donnée utilisateur. **C'est la protection XSS du palier 4, fournie par défaut par Jinja2** — et c'est précisément ce que tu devras faire à la main avec `htmlspecialchars` en PHP.

**9.** Le lien à noter : PHP, comme ton mini-framework ici, fait du SSR — le serveur produit le HTML complet. La différence majeure est que **PHP n'échappe pas automatiquement** : il faut appeler `htmlspecialchars` sur chaque affichage de donnée utilisateur, sinon c'est une XSS. Avoir vu l'échappement automatique de Jinja2 te fera comprendre pourquoi ce geste manuel est si important en PHP — et pourquoi l'oublier est une faille.

**10.** Le bilan attendu : WSGI (↔ node:http) · routeur (↔ `@app.route`) · Request/Response (↔ les objets request/response) · couche modèles SQLite (↔ l'ORM) · templates Jinja2 (↔ les templates du framework, Jinja2 est d'ailleurs celui de Flask). **Tu as construit un framework.** Flask et Django ne feront plus rien de magique : ils feront, en mieux et en plus robuste, ce que tu as écrit toi-même. C'est tout le sens du module « natif d'abord », et c'est ta meilleure réponse à « connais-tu les frameworks Python ? » en entretien.
</details>

---

## ✅ Acquis si…

- [ ] Je sais pourquoi assembler du HTML par concaténation est illisible et dangereux.
- [ ] J'utilise Jinja2 avec `autoescape=True` pour rendre des pages.
- [ ] J'affiche des variables, des boucles, et l'état vide avec `{% else %}`.
- [ ] Je sais que l'échappement automatique neutralise la XSS, et que `| safe` est un acte risqué.
- [ ] J'utilise l'héritage de templates pour éviter de répéter la structure.
- [ ] Je comprends le SSR et je sais quand le choisir plutôt qu'une SPA.
- [ ] Je sers mon mini-framework avec gunicorn, en développement et avec plusieurs workers.
- [ ] Je fais le lien entre le SSR, l'échappement de Jinja2 et le modèle de PHP à venir.
- [ ] J'ai dressé le bilan de mon mini-framework et son équivalence avec Flask et Django.
- [ ] 🚦 J'ai terminé le module "natif d'abord" et je suis prêt pour Flask.

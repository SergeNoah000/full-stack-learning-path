# Leçon 01 — HTML sémantique et structure d'une page

> 🎯 **À la fin de cette leçon** : tu écris la structure d'une page avec les balises qui ont un sens, et tu sais pourquoi ce choix a des conséquences bien au-delà de l'esthétique.
> ⏱️ 3 h · **Prérequis** : [épreuve du palier 1](../../palier-01-programmer-javascript/evaluation.md) réussie.

---

## Le HTML, c'est quoi

Le HTML est un **langage de structure**, pas un langage de programmation. Il ne calcule rien, ne décide rien, ne boucle pas : il **décrit** ce qu'est chaque morceau de contenu. Ceci est un titre, ceci est un paragraphe, ceci est une liste, ceci est un formulaire de recherche.

Le mot important est **sémantique** : le sens. Il existe toujours deux façons de produire le même résultat visuel. Tu peux écrire `<div class="titre">` et le styler en gros et gras, ou écrire `<h1>`. À l'écran, identique. Dans tout le reste du système — lecteurs d'écran, moteurs de recherche, mode lecture d'un navigateur, extensions, autres développeurs —, la différence est totale : le premier est une boîte anonyme, le second **annonce** qu'il s'agit du titre de la page.

Un document HTML a toujours la même ossature :

```html
<!DOCTYPE html>
<html lang="fr">
  <head>
    <!-- les métadonnées : rien ne s'affiche ici -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Météo Douala</title>
  </head>
  <body>
    <!-- le contenu visible -->
  </body>
</html>
```

Le `<head>` est destiné aux machines : encodage, titre d'onglet, description pour les moteurs de recherche, comportement sur mobile. Le `<body>` est destiné aux humains.

---

## À quoi ça sert, concrètement

**À rendre ta page utilisable par des gens qui ne la voient pas.** C'est la raison la plus importante, et c'est aussi celle qu'on oublie le plus. Une personne aveugle navigue avec un lecteur d'écran, qui lui annonce « navigation, liste de cinq liens » ou « titre de niveau 2 : prévisions ». Si tout est en `<div>`, le lecteur d'écran n'a rien à annoncer : il lit un flux de texte sans structure, et le site devient inutilisable. Ce n'est pas un cas marginal — c'est une obligation légale dans beaucoup de pays, et un critère d'appel d'offres.

**À être trouvé.** Les moteurs de recherche s'appuient sur la hiérarchie des titres et sur les balises structurantes pour comprendre de quoi parle une page. Un `<h1>` unique et des `<h2>` cohérents valent mieux que n'importe quelle astuce.

**À te relire dans six mois.** Une page construite avec `<header>`, `<main>`, `<article>`, `<footer>` se parcourt des yeux. Une page de quarante `<div class="wrapper-inner-content">` imbriqués ne se parcourt pas, elle se déchiffre.

**Et à obtenir du comportement gratuitement.** Un `<button>` est focalisable au clavier, s'active avec Entrée **et** Espace, et est annoncé comme un bouton. Une `<div onclick>` ne fait rien de tout cela — il te faudrait vingt lignes de JavaScript pour rattraper ce que la bonne balise te donne pour rien.

---

## Où ça intervient dans le développement

Le HTML est la **couche de structure** du frontend, et il se place sous tout le reste :

```
   HTML   → la structure et le sens          ← cette leçon
   CSS    → la présentation                   ← leçons 03 à 06
   JS     → le comportement                   ← leçons 07 à 09
```

Cette séparation n'est pas théorique : c'est le premier niveau du **fil rouge architecture** du parcours (« séparer les responsabilités »). Si ton HTML contient de la présentation (`<font>`, `style="color:red"`, `<br>` pour espacer), tu as mélangé deux couches, et tout changement de design devient une chasse dans le balisage.

Deux prolongements à connaître dès maintenant.

**Au palier 3, le HTML ne disparaît pas** — il devient du JSX, qui en est une écriture dans JavaScript. Les composants React produisent du HTML, et un composant qui produit du `<div>` partout produit une application inaccessible. Ce que tu apprends ici te suivra.

**Aux paliers 5 et 6, c'est le serveur qui écrira ce HTML.** Les templates Jinja2 et Blade assemblent exactement ces balises. La connaissance ne change pas de camp : elle change simplement d'endroit de génération.

Et il y a un point d'architecture plus large : le HTML est ce qui arrive **en premier** chez l'utilisateur, souvent avant le CSS et le JavaScript. C'est pourquoi une page bien structurée reste lisible même si le reste échoue à charger — et c'est le fondement de ce qu'on appelle l'amélioration progressive.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire beaucoup de HTML à la main, et c'est volontaire : c'est la seule façon d'acquérir le réflexe de la bonne balise. Tu vas aussi découvrir le **validateur** (validator.w3.org), qui signale tes balises mal fermées et tes imbrications interdites — et tu seras surpris du nombre d'erreurs invisibles à l'œil.

Tu vas surtout faire l'exercice central du palier : **reproduire une capture d'écran de vrai site**. C'est là que tu apprendras à regarder une page et à voir sa structure avant son apparence.

### En équipe, en entreprise

**L'accessibilité est devenue un sujet sérieux.** Dans beaucoup d'équipes, un outil automatique (axe, Lighthouse) tourne dans le pipeline et refuse une page sans `alt` sur les images ou sans `label` sur les champs. Ce n'est plus un supplément d'âme : c'est un test qui bloque.

**On te reprendra sur la « divite ».** Utiliser un `<div>` là où une balise sémantique existe est la remarque la plus fréquente sur du HTML de débutant. Et l'inverse existe aussi : employer `<section>` ou `<article>` au hasard, pour faire bien, sans que ça corresponde à la structure réelle.

**Tu travailleras à partir de maquettes.** Un designer te donnera une image (Figma au palier 3) et tu devras en déduire la structure. L'habitude à prendre : décrire la page en balises **avant** d'écrire une ligne de CSS.

**Et tu rencontreras du HTML ancien.** `<center>`, `<font>`, des tableaux pour la mise en page, du `style=""` partout. En mission de maintenance, c'est la norme plutôt que l'exception — sache le lire sans le reproduire.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien, une vingtaine de balises couvrent tout : `div`, `span`, `p`, `h1`–`h3`, `a`, `img`, `ul`/`li`, `button`, `form`, `input`, `label`, `header`, `nav`, `main`, `footer`, `section`, `article`, `table`.

Régulièrement : `select`, `textarea`, `figure`/`figcaption`, `aside`, `strong`/`em`, `time`, `details`/`summary` (un accordéon sans une ligne de JavaScript).

Rare, et sans intérêt pour toi aujourd'hui : `canvas` et `svg` (sauf besoin précis), `iframe`, `video`/`audio` avec leurs pistes, `dialog`, `template`, les microdonnées et Schema.org, les Web Components. Et des balises que tu verras sans jamais écrire : `<abbr>`, `<kbd>`, `<cite>`, `<dl>`. Elles existent, elles sont correctes, et personne ne te reprochera de ne pas les connaître.

---

## La mécanique

### Les balises structurantes

```html
<body>
  <header>
    <h1>Météo</h1>
    <nav>
      <ul>
        <li><a href="/">Accueil</a></li>
        <li><a href="/villes">Villes</a></li>
      </ul>
    </nav>
  </header>

  <main>
    <h2>Aujourd'hui à Douala</h2>
    <section>
      <h3>Maintenant</h3>
      <p>29 °C, humidité 78 %.</p>
    </section>

    <article>
      <h3>Prévisions</h3>
      <p>…</p>
    </article>
  </main>

  <aside>
    <h2>À propos</h2>
    <p>Données fournies par Open-Meteo.</p>
  </aside>

  <footer>
    <p>© 2026</p>
  </footer>
</body>
```

Les six à retenir : `header` (en-tête de page ou de section), `nav` (un **ensemble de liens de navigation**, pas n'importe quel lien), `main` (le contenu principal, **un seul par page**), `section` (un regroupement thématique, qui doit avoir un titre), `article` (un contenu qui se tient seul — un billet, une fiche produit, un commentaire), `aside` (du contenu lié mais secondaire), `footer`.

Un repère simple pour choisir entre `section` et `article` : si le contenu garderait un sens publié ailleurs, c'est un `article`. Sinon, une `section`. Et si tu ne peux pas lui donner de titre, c'est probablement une simple `<div>`.

### La hiérarchie des titres

Un seul `<h1>` par page : il annonce le sujet. Ensuite, on ne saute pas de niveau — après un `h2` vient un `h3`, jamais un `h4`. La hiérarchie des titres est le **sommaire** de ta page, et c'est par elle que navigue un lecteur d'écran.

Et surtout : **le niveau de titre n'est pas une taille**. Si ton `h2` est trop gros, c'est le CSS qui le règle, pas le passage à `h4`. C'est l'erreur la plus courante.

### Le lien contre le bouton

```html
<a href="/villes">Voir les villes</a>      <!-- je NAVIGUE vers un autre endroit -->
<button type="button">Rafraîchir</button>   <!-- j'AGIS sur la page courante -->
```

La règle : **un lien emmène ailleurs, un bouton fait quelque chose**. On croise sans arrêt des `<a href="#" onclick="...">` qui devraient être des boutons, et des `<div class="btn">` qui ne sont ni l'un ni l'autre. Les conséquences sont réelles : un lien doit pouvoir s'ouvrir dans un nouvel onglet, un bouton non.

Note aussi `type="button"` : dans un formulaire, un `<button>` sans type **soumet** le formulaire. C'est un bug classique.

### Les images

```html
<img src="meteo.png" alt="Ciel nuageux au-dessus de Douala" width="600" height="400">
<img src="decoration.svg" alt="">     <!-- purement décoratif : alt VIDE, pas absent -->
```

L'attribut `alt` est **obligatoire**. Il décrit l'image pour qui ne la voit pas, et s'affiche si l'image ne charge pas. Une image décorative reçoit un `alt=""` vide, qui dit explicitement « rien à annoncer » — c'est différent d'un `alt` absent, qui fait lire le nom du fichier au lecteur d'écran.

Les attributs `width` et `height` évitent que la page « saute » quand l'image arrive : le navigateur réserve la place. C'est un gain de confort réel, et un critère de performance mesuré.

### Les listes et les tableaux

```html
<ul> <li>…</li> </ul>          <!-- liste non ordonnée -->
<ol> <li>…</li> </ol>          <!-- liste ordonnée : l'ordre a un sens -->

<table>
  <caption>Températures de la semaine</caption>
  <thead>
    <tr><th scope="col">Jour</th><th scope="col">Max</th></tr>
  </thead>
  <tbody>
    <tr><td>Lundi</td><td>30 °C</td></tr>
  </tbody>
</table>
```

Un tableau sert à des **données tabulaires**, jamais à la mise en page. Et `<th scope="col">` n'est pas décoratif : c'est ce qui permet à un lecteur d'écran d'annoncer « Max, 30 degrés » au lieu de « 30 degrés » isolé.

### Quand `div` et `span` sont les bonnes réponses

Elles n'ont **aucun** sens, et c'est exactement leur utilité : regrouper pour styler, quand aucune balise sémantique ne correspond. `<div>` est un bloc, `<span>` est en ligne. Les utiliser n'est pas une faute ; les utiliser **à la place** d'une balise qui existe en est une.

---

## Les problèmes que tu vas rencontrer

**Ta page s'affiche bizarrement dans les anciens navigateurs ou de façon incohérente.** Le `<!DOCTYPE html>` manque, et le navigateur bascule en « mode quirks », où il imite des bugs des années 1990.

**Tes accents s'affichent en caractères bizarres.** Il manque `<meta charset="UTF-8">` dans le `<head>`. À mettre en premier, toujours.

**Ta page est minuscule et illisible sur téléphone.** Il manque la balise `viewport`. Sans elle, le mobile simule un écran large puis dézoome — et tout ton travail responsive (leçon 05) est annulé.

**Une balise non fermée casse toute la suite de la page.** Le symptôme est déroutant : un bloc entier disparaît ou se retrouve imbriqué au mauvais endroit. Le validateur te le dit en deux secondes ; l'œil, non.

**Tu as imbriqué des balises de façon interdite.** Un `<p>` dans un `<p>`, un `<div>` dans un `<p>`, un `<a>` dans un `<a>`. Le navigateur « corrige » en silence, à sa façon, et ton CSS ne s'applique plus comme prévu.

**Tes titres sont dans le désordre.** `h1` puis `h4`, ou plusieurs `h1`. Invisible à l'œil, signalé par tous les outils d'accessibilité.

**Ton `<button>` dans un formulaire recharge la page.** Il manque `type="button"`.

---

## Ce qu'on te demandera

En **test technique frontend**, l'exercice est presque toujours le même : « voici une maquette, intègre-la ». Et la première chose qu'on regarde n'est pas le pixel, c'est **le balisage** : est-ce sémantique, est-ce valide, les images ont-elles un `alt`, les titres sont-ils hiérarchisés ? Un candidat qui rend un rendu parfait en `<div>` purs passe après celui qui rend un rendu à 95 % correctement structuré.

En **entretien**, les questions reviennent : « pourquoi du HTML sémantique ? », « combien de `h1` par page ? », « différence entre `section` et `div` ? », « quand utiliser un lien plutôt qu'un bouton ? », « à quoi sert l'attribut `alt` et que mets-tu pour une image décorative ? ».

En **travail réel**, on attendra que ta page passe le validateur et l'audit d'accessibilité automatique. C'est une barre basse, et beaucoup de monde échoue dessus.

---

## Ce qui te démarquera

**Décrire la structure avant d'ouvrir le CSS.** Prendre une maquette et écrire d'abord le balisage complet, sans aucun style, en vérifiant qu'elle se lit dans l'ordre. C'est la méthode professionnelle, et elle produit un HTML propre au lieu d'un HTML façonné par les besoins du style.

**Connaître les deux ou trois balises que personne n'utilise mais qui règlent un vrai problème.** `<details>`/`<summary>` fait un accordéon sans JavaScript. `<label>` relié rend un champ cliquable sur son libellé. `<time datetime="2026-10-19">` rend une date exploitable.

**Penser au clavier.** Parcourir ta page avec `Tab` uniquement est un test de dix secondes que presque personne ne fait, et qui révèle immédiatement les faux boutons.

**Ne pas tomber dans l'excès inverse.** Savoir dire « ici une `div` suffit, il n'y a pas de sens à exprimer » montre que tu as compris le principe plutôt qu'appris une liste.

---

## 📚 À lire

**The Odin Project → HTML Foundations** : c'est la ressource principale, progressive et orientée pratique.

**MDN** pour chaque balise que tu utilises — prends l'habitude d'ouvrir la page de référence plutôt que de deviner. Et lis en entier **MDN → *HTML: A good basis for accessibility*** : une demi-heure, et tu comprendras pourquoi cette leçon insiste autant.

**web.dev → *Learn HTML*** propose un parcours court et moderne, avec un bon chapitre sur les métadonnées du `<head>`.

Garde aussi **validator.w3.org** en favori : c'est ton correcteur orthographique.

---

## 🤖 Le mini-projet à demander à l'IA

Le HTML s'apprend en structurant du contenu réel, pas en lisant des listes de balises.

> « Je suis en formation de développeur, palier 2 (frontend). Je travaille le HTML sémantique. Donne-moi **le contenu brut** (texte seul, sans aucun balisage) d'une page réaliste : une fiche d'article de blog avec titre, auteur, date, chapô, trois sections, une image avec sa légende, une citation, une liste d'étapes, un encadré "à lire aussi" et un pied de page. Ma mission : écrire le balisage sémantique complet, **sans aucun CSS**. Ensuite, critique mon balisage sur quatre points : les balises sémantiques que j'aurais pu utiliser, la hiérarchie de mes titres, l'accessibilité (alt, labels, scope), et les `div` que j'ai mises là où une vraie balise existait. **Ne réécris pas le code à ma place.** »

Puis l'exercice inverse, qui est encore plus formateur :

> « Donne-moi un extrait de HTML de 40 lignes **volontairement mauvais mais fonctionnel** : des `div` partout, des titres désordonnés, des `alt` manquants, un faux bouton, du `style=""` en ligne, une balise non fermée. Ne me dis pas où sont les problèmes. Je dois les lister puis le réécrire. »

---

## 🛠️ À faire

1. Écris le squelette complet d'une page (`<!DOCTYPE>`, `lang`, `charset`, `viewport`, `title`) **de mémoire**, sans copier. Refais-le trois fois dans la semaine jusqu'à ce qu'il vienne tout seul.
2. Structure une page « à propos de moi » : en-tête avec titre et navigation, contenu principal avec deux sections, une image avec `alt`, un encadré, un pied de page. **Aucun CSS.**
3. Passe-la au **validateur W3C** et corrige jusqu'à zéro erreur.
4. **Casse-la volontairement** : retire la fermeture d'une balise, mets un `<div>` dans un `<p>`, saute un niveau de titre. Observe le rendu et ce que dit le validateur.
5. Parcours ta page avec **`Tab` uniquement**. Tous les éléments interactifs sont-ils atteignables ? Le focus est-il visible ?
6. Installe l'extension **axe DevTools** (ou utilise Lighthouse → Accessibilité) et corrige ce qu'elle signale.
7. Prends une page d'un vrai site, ouvre son inspecteur, et **dessine sa structure** en balises sémantiques sur papier. Compare ensuite avec ce qu'elle utilise réellement.
8. Fais un accordéon avec `<details>`/`<summary>` — et mesure que tu viens d'obtenir un comportement interactif sans une ligne de JavaScript.
9. Construis un tableau de données correct : `caption`, `thead`, `tbody`, `th scope`. Vérifie avec un lecteur d'écran si tu en as un (NVDA, VoiceOver, ou Orca sous Linux).

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Le squelette minimal correct :
```html
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Titre de la page</title>
  </head>
  <body>
  </body>
</html>
```
Les quatre éléments qu'on oublie : `lang` (il indique la langue au lecteur d'écran, qui change de voix), `charset` (les accents), `viewport` (le mobile), `title` (l'onglet et les résultats de recherche).

**4.** Observations attendues. Une balise non fermée : le navigateur devine, et souvent un bloc entier se retrouve imbriqué dans le précédent — ton CSS cesse alors de s'appliquer correctement, sans message d'erreur. Un `<div>` dans un `<p>` : le navigateur **ferme** le `<p>` tout seul avant le `<div>`, ce qui casse ta structure. Le validateur signale les deux immédiatement : c'est pourquoi on l'utilise.

**5.** Les éléments atteignables au clavier sont les liens, boutons, champs de formulaire et éléments avec `tabindex`. Si tu as fait une `<div onclick>`, elle sera **invisible au clavier** — c'est exactement la démonstration de la section « lien contre bouton ».

**8.**
```html
<details>
  <summary>Voir les prévisions détaillées</summary>
  <p>…</p>
</details>
```
Tu viens d'obtenir : ouverture/fermeture, accessibilité au clavier, annonce correcte par le lecteur d'écran, et état mémorisé par le navigateur. Avec des `div` et du JavaScript, il t'aurait fallu une trentaine de lignes et tu aurais probablement oublié le clavier. **C'est le meilleur argument en faveur de la bonne balise.**
</details>

---

## ✅ Acquis si…

- [ ] J'écris le squelette d'une page de mémoire, avec `lang`, `charset`, `viewport` et `title`.
- [ ] J'utilise `header`, `nav`, `main`, `section`, `article`, `aside`, `footer` à bon escient — et `div` quand il n'y a pas de sens à exprimer.
- [ ] Un seul `h1` par page, et aucun niveau de titre sauté.
- [ ] Je sais choisir entre un lien et un bouton, et pourquoi.
- [ ] Toutes mes images ont un `alt`, vide si elles sont décoratives.
- [ ] Mes pages passent le validateur W3C sans erreur.
- [ ] Je parcours ma page au clavier et tous les éléments interactifs sont atteignables.
- [ ] Je sais expliquer en deux phrases pourquoi la sémantique n'est pas une question d'esthétique.

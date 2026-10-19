# Leçon 05 — Markdown

> 🎯 **À la fin de cette leçon** : tu écris un README propre sans réfléchir à la syntaxe, et tu comprends pourquoi toute la documentation technique du monde est écrite comme ça.
> ⏱️ 1 h · **Prérequis** : leçon 04.

---

## Markdown, c'est quoi

Markdown est un **langage de mise en forme en texte brut**. Tu écris `**gras**` dans un fichier texte ordinaire, et l'outil qui l'affiche te montre **gras**. Pas de logiciel propriétaire, pas de format binaire : un fichier `.md` est lisible tel quel dans un terminal.

Il a été créé en 2004 avec une contrainte explicite : **le texte source doit rester agréable à lire même sans rendu**. C'est son critère de réussite, et c'est aussi ta règle d'écriture. Si ton Markdown est pénible à lire brut, tu l'as mal écrit.

Une précision utile : il existe plusieurs dialectes. Le Markdown d'origine est minimal. Ce que tu utiliseras en pratique s'appelle **GFM** (*GitHub Flavored Markdown*) et ajoute les tableaux, les cases à cocher, les blocs de code colorisés et quelques encarts. C'est le dialecte de GitHub, GitLab, Notion, Discord et de la plupart des outils de développeur — donc celui qu'il faut connaître.

---

## À quoi ça sert, concrètement

**À écrire la documentation qui accompagne le code.** Chaque dépôt a un `README.md`, et c'est le premier fichier que quiconque ouvre. Des projets entiers de documentation (y compris ce dossier d'apprentissage) ne sont que des fichiers Markdown.

**À communiquer dans les outils du métier.** Les issues GitHub, les descriptions de Pull Request, les commentaires de revue de code, les messages Discord et Slack, les réponses Stack Overflow : tout accepte du Markdown. Tu l'utiliseras plusieurs fois par jour, souvent sans y penser.

**Parce que c'est versionnable.** C'est la raison technique, et elle est décisive. Un fichier Markdown est du texte, donc Git peut en montrer les modifications **ligne par ligne**. Un `.docx` dans un dépôt est un bloc opaque : Git ne peut dire que « ce fichier a changé », sans dire en quoi. C'est pour ça que toute la documentation technique vit en Markdown et pas dans un traitement de texte — pas par austérité, par **nécessité de relecture**.

**Parce que ça dure.** Un fichier texte s'ouvrira encore dans vingt ans, sans dépendre d'un logiciel ni d'un abonnement.

---

## Où ça intervient dans le développement

Markdown se situe à la **frontière entre ton code et les humains**. Il n'intervient jamais dans l'exécution d'un programme ; il intervient partout où il faut expliquer.

Trois endroits précis, par ordre d'importance pour toi.

**Le README de chaque dépôt.** C'est ta vitrine, et au palier 10 ce sera une pièce de ton dossier de candidature. Quatre-vingt-dix secondes d'attention d'un recruteur se jouent là (voir leçon 04). Le [template du parcours](../../templates/readme-projet.md) est en Markdown, et tu le copieras dans chaque projet.

**Les documents de travail.** Cahiers des charges, user stories, spécifications, cahiers de recette, documents d'architecture : tous les [templates](../../templates/README.md) de ce parcours sont en Markdown, et ils vivront dans un dossier `docs/` à l'intérieur des dépôts de tes projets. Avantage concret : la spécification et le code qu'elle décrit évoluent **dans le même historique**, ce qui évite la documentation périmée rangée ailleurs.

**La communication quotidienne.** Descriptions de PR, issues, commentaires. Un collègue qui reçoit une issue bien structurée — contexte, étapes de reproduction, résultat attendu, bloc de code de l'erreur — la traite trois fois plus vite.

Et un usage que tu croiseras plus tard : beaucoup de sites et de blogs techniques sont écrits en Markdown et convertis en HTML au moment de la publication (générateurs de sites statiques, CMS de contenu). Ce que tu apprends ici reste utile même quand tu produis du web.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu écriras le README de chacun de tes projets, et le journal de ce parcours. Prends tout de suite l'habitude de l'aperçu côte à côte dans VS Code (`Ctrl+Shift+V`) : tu vois le rendu pendant que tu écris, et tu repères immédiatement une liste mal formée.

### En équipe, en entreprise

Tu découvriras qu'un **bon README est une norme attendue**. Il doit permettre à un nouvel arrivant d'installer et de lancer le projet sans poser de question. Les équipes sérieuses ajoutent des modèles automatiques : un fichier `.github/PULL_REQUEST_TEMPLATE.md` qui pré-remplit la description de chaque PR, un `ISSUE_TEMPLATE` pour les bugs. Ces modèles sont, eux aussi, du Markdown.

Tu verras aussi des documentations entières construites avec des outils qui ne font que compiler du Markdown (MkDocs, Docusaurus, Sphinx). Si tu sais écrire du Markdown propre, tu sais contribuer à ces documentations.

### Ce qui sert tous les jours, et ce qui est rare

Tu utiliseras constamment : les titres, les listes, le gras, les liens, les blocs de code et les cases à cocher. Régulièrement : les tableaux, les citations, les images.

Rarement : les notes de bas de page, les listes de définitions, le HTML intégré, les diagrammes Mermaid (utiles mais spécifiques), les alertes GitHub. Et il y a un piège inverse à connaître : **certaines syntaxes ne fonctionnent pas partout**. Les tableaux et les cases à cocher sont du GFM, pas du Markdown standard — ils s'afficheront sur GitHub et dans VS Code, mais pas forcément dans un autre outil. Quand un rendu te surprend, la question à se poser est « quel dialecte lit cet outil ? ».

---

## La mécanique

L'essentiel tient en un écran. Tape-le, ne le copie pas.

````markdown
# Titre de niveau 1 (un seul par document)
## Niveau 2
### Niveau 3

Un paragraphe ordinaire. **gras**, *italique*, `code en ligne`, ~~barré~~.

- liste à puces
- autre élément
  - imbriqué (deux espaces d'indentation)

1. liste numérotée
2. deuxième

- [ ] tâche à faire
- [x] tâche faite

[texte du lien](https://example.com)
[lien vers un fichier voisin](../README.md)
![texte alternatif de l'image](docs/capture.png)

> Citation, ou mise en garde.

| Colonne | Autre  |
|---------|--------|
| valeur  | valeur |

```js
// bloc de code : précise TOUJOURS le langage après les trois accents graves
const total = depenses.reduce((somme, d) => somme + d.montant, 0);
```

---
(une ligne de séparation)
````

Deux éléments méritent un mot de plus.

Les **blocs de code** sont ce que tu écriras le plus souvent, et le langage indiqué après les trois accents graves (` ```js `) déclenche la coloration syntaxique. Sans lui, ton code s'affiche en gris uniforme, ce qui est aussi désagréable que révélateur.

Le bloc **repliable** est particulièrement utile, et c'est du HTML accepté par GFM :

```markdown
<details>
<summary>Cliquer pour dérouler</summary>

Contenu masqué — c'est exactement ce qui cache les corrections
d'exercices dans les leçons de ce parcours.

</details>
```

GitHub ajoute aussi des encarts mis en valeur, pratiques dans un README :

```markdown
> [!NOTE]
> Une information utile.

> [!WARNING]
> Un avertissement.
```

---

## Les problèmes que tu vas rencontrer

Ils sont peu nombreux, toujours les mêmes, et tous liés aux **lignes vides**.

**Ta liste ne s'affiche pas comme une liste.** Il manque une ligne vide **avant** la liste. C'est de loin l'erreur la plus fréquente de Markdown.

**Ton bloc de code n'est pas coloré.** Tu as oublié d'indiquer le langage. Ou tu as mis trois accents graves d'un côté et quatre de l'autre.

**Tes deux lignes se sont collées en un seul paragraphe.** Un simple retour à la ligne est ignoré par Markdown. Pour changer de paragraphe, il faut une **ligne vide**. (Pour forcer un retour à la ligne dans le même paragraphe, deux espaces en fin de ligne — mais une ligne vide est presque toujours ce que tu veux.)

**Du texte est devenu italique sans raison.** Tu as écrit quelque chose comme `MA_VARIABLE_TEST` : les underscores sont interprétés comme de l'italique. Mets le terme dans des accents graves (`` `MA_VARIABLE_TEST` ``), et préfère `**` au lieu de `__` pour le gras.

**Ton image ne s'affiche pas sur GitHub.** Le chemin est relatif au fichier Markdown, pas à la racine du dépôt — et l'image doit être **commitée**. Range tes captures dans un dossier `docs/` du projet.

**Ton tableau est illisible dans le source.** L'alignement des barres verticales n'est pas obligatoire pour le rendu, mais il l'est pour la lisibilité du source — et le source est ce que tes collègues liront dans un diff Git. VS Code peut l'aligner automatiquement.

---

## Ce qu'on te demandera

Personne ne te posera de question sur Markdown en entretien : ce n'est pas une compétence qu'on évalue, c'est une compétence qu'on **constate**.

On la constate sur tes README, et c'est là que ça compte. Un recruteur qui ouvre un dépôt et trouve un README structuré, avec une capture, un lien de démo et des instructions d'installation, en tire une conclusion immédiate sur ton sérieux. Un README vide ou constitué du texte généré par défaut en tire une autre.

On la constate aussi sur la qualité de tes issues et de tes descriptions de PR, dès ta première semaine en équipe. Un bug rapporté avec les étapes de reproduction dans une liste numérotée et le message d'erreur dans un bloc de code est un bug qui sera corrigé. Le même bug rapporté en un paragraphe confus attendra.

---

## Ce qui te démarquera

**Un README qui répond aux bonnes questions**, dans cet ordre : qu'est-ce que c'est, à quoi ça ressemble (capture), où l'essayer (lien), comment l'installer, quelle stack **et pourquoi**, ce que tu as appris. Le [template](../../templates/readme-projet.md) est fait pour ça.

**Une capture d'écran.** C'est l'élément le plus rentable d'un README, et presque personne ne le met. Une image vaut trois paragraphes de description.

**Les blocs repliables** pour ranger ce qui est long sans l'enlever (détails d'installation, dépannage, décisions techniques). Ça donne un document court à lire et complet à consulter.

**Des liens relatifs qui fonctionnent.** Un README qui renvoie vers `docs/architecture.md` et qui marche quand on clique, c'est un détail — et c'est le genre de détail qui distingue un document fini d'un brouillon.

---

## 📚 À lire

**GitHub Docs → *Basic writing and formatting syntax*** est la référence, et dix minutes suffisent. Garde-la en favori : tu y reviendras pour les tableaux et les encarts.

**commonmark.org/help** propose un tutoriel interactif de dix minutes, en deux panneaux (source à gauche, rendu à droite) — le plus rapide pour installer les réflexes.

Et l'exercice le plus instructif est gratuit : ouvre les fichiers de ce dossier d'apprentissage **en mode source** dans VS Code, et regarde comment ils sont écrits.

---

## 🤖 Le mini-projet à demander à l'IA

Markdown s'apprend en une heure ; ce qui prend du temps, c'est d'écrire un bon README. Fais-toi critiquer :

> « Voici le README de mon projet [colle-le]. Relis-le comme le ferait un recruteur technique qui lui accorde 90 secondes. Dis-moi : ce qu'il comprend du projet en 10 secondes, ce qui manque pour qu'il ait envie d'ouvrir le code, et ce qui est superflu. **Ne le réécris pas** : liste-moi les manques, je corrigerai. »

Et pour t'entraîner à la syntaxe sur un cas réel :

> « Fabrique-moi l'énoncé d'un exercice de documentation : décris-moi en langage naturel un petit projet fictif (ce qu'il fait, comment on l'installe, ses limites), et je rédigerai son README en Markdown. Ensuite, compare mon résultat à ce que tu attendais et dis-moi ce que j'ai oublié de structurer. »

---

## 🛠️ À faire

1. Rédige le README de `learning-journal` avec, au minimum : un titre, une introduction de deux lignes, une liste à puces de ce que tu apprends, un tableau de progression, un bloc de code, un lien relatif vers ce dossier d'apprentissage, et une case à cocher.
2. Ouvre `../../README.md` **en mode source** et retrouve chaque élément de syntaxe utilisé. Note celui que tu ne connaissais pas.
3. **Provoque les trois erreurs classiques** : une liste sans ligne vide avant, un bloc de code sans langage, deux lignes qui se collent. Observe le rendu, puis corrige.
4. Crée une issue sur ton propre dépôt en utilisant un tableau, une case à cocher et un bloc de code. Constate que c'est le même langage que dans le README.
5. Ajoute un bloc `<details>` à ton README pour masquer une section de dépannage.
6. Écris une entrée de journal dans `../journal.md` au format demandé — et respecte-le, c'est le premier exercice de rigueur du parcours.
7. Prends une capture d'écran de ton terminal avec la vérification d'installation du palier 0, range-la dans `docs/`, et affiche-la dans le README de `learning-journal`.

<details>
<summary>Points de contrôle</summary>

**1.** Vérifie le rendu **sur GitHub**, pas seulement dans VS Code : c'est GitHub qui décide, et quelques différences existent. Si ton tableau n'apparaît pas, c'est qu'il manque la ligne de séparation `|---|---|`.

**3.** Les trois symptômes attendus : la liste s'affiche comme un paragraphe avec des tirets · le code apparaît en gris sans coloration · les deux lignes forment un seul paragraphe continu. Dans les trois cas, la cause est la même famille : Markdown s'appuie sur les lignes vides pour délimiter les blocs.

**7.** Attention au chemin relatif : si ton README est à la racine du dépôt et l'image dans `docs/`, c'est `![...](docs/capture.png)`. Et l'image doit être commitée et poussée, sinon GitHub affichera un lien cassé.
</details>

---

## ✅ Acquis si…

- [ ] J'écris titres, listes, liens, tableaux et blocs de code **sans consulter d'aide-mémoire**.
- [ ] Mes blocs de code précisent toujours le langage.
- [ ] Je sais que les lignes vides délimitent les blocs, et je reconnais les trois erreurs classiques.
- [ ] J'utilise `<details>` pour masquer ce qui est long.
- [ ] Le README de `learning-journal` s'affiche correctement **sur GitHub**, avec une capture d'écran.
- [ ] Je sais pourquoi la documentation technique est en Markdown et pas dans un traitement de texte.

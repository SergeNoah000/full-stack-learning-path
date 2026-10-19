# Leçon 02 — Formulaires et accessibilité de base

> 🎯 **À la fin de cette leçon** : tu construis un formulaire utilisable au clavier, validé par le navigateur, et compréhensible par un lecteur d'écran — c'est-à-dire un formulaire professionnel.
> ⏱️ 3 h · **Prérequis** : leçon 01.

---

## De quoi on parle

Un **formulaire** est la porte d'entrée des données dans une application. C'est par là que l'utilisateur crée un compte, se connecte, paie, cherche, filtre, commente. Tout ce que ton application reçoit passe par un formulaire ou par une API.

Les pièces : `<form>` l'enveloppe, `<input>` le champ (avec une trentaine de **types** possibles), `<label>` le libellé **relié** au champ, `<select>` la liste déroulante, `<textarea>` le texte long, `<button type="submit">` l'envoi, et `<fieldset>`/`<legend>` pour regrouper des champs liés.

La **validation native** est ce que le navigateur vérifie tout seul, grâce à des attributs : `required`, `type="email"`, `minlength`, `pattern`, `min`/`max`.

Et l'**accessibilité** (abrégée *a11y*) désigne le fait qu'une page soit utilisable par tout le monde : au clavier seul, avec un lecteur d'écran, avec une vision partielle, sans souris.

---

## À quoi ça sert, concrètement

**Parce que c'est là que ton application gagne ou perd des utilisateurs.** Un formulaire d'inscription mal fait est le point de fuite numéro un de n'importe quel produit. Un champ dont on ne comprend pas l'erreur, un clavier qui affiche des lettres pour saisir un numéro de téléphone, une case qu'on ne peut pas cocher au clavier : chaque friction fait partir quelqu'un.

**Parce que le navigateur travaille gratuitement pour toi.** `type="email"` vérifie le format, affiche le bon clavier sur mobile, et donne un message d'erreur traduit dans la langue de l'utilisateur. `required` empêche la soumission. Ce sont des dizaines de lignes de JavaScript que tu n'écris pas — et que tu n'auras pas à déboguer.

**Parce que l'accessibilité se joue à 90 % ici.** Le reste d'une page est souvent du contenu à lire ; un formulaire est interactif, et c'est là que les erreurs d'accessibilité deviennent bloquantes. Un `<label>` non relié, et un utilisateur de lecteur d'écran entend « zone de saisie » sans savoir quoi y mettre.

---

## Où ça intervient dans le développement

Le formulaire est une **frontière**, au sens exact de la leçon 01 du palier 1 : c'est là que des données extérieures entrent dans ton système. Et cette position commande tout ce qui suit.

```
   UTILISATEUR
      │  saisit — et peut saisir n'importe quoi
      ▼
   FORMULAIRE  ── validation native (navigateur)   ← cette leçon
      │         ── validation JS (confort)          ← leçon 08
      │
      │  HTTP : tout ce qui est envoyé est modifiable
      ▼
   SERVEUR     ── VALIDATION DE SÉCURITÉ            ← palier 4, obligatoire
      │
      ▼
   BASE DE DONNÉES  ── contraintes (NOT NULL, UNIQUE…)  ← palier 4
```

Retiens la hiérarchie : la validation du navigateur et celle du JavaScript sont du **confort** — elles évitent un aller-retour réseau et donnent un retour immédiat. La seule validation qui **protège** est celle du serveur, parce qu'un `curl` de dix secondes contourne ton formulaire entier. C'est la règle de sécurité n°1 du métier, posée au palier 0 et appliquée au palier 4.

Autre conséquence : **tous les attributs de cette leçon se retrouvent côté serveur.** `required` devient une règle de validation, `type="email"` devient un contrôle de format, `maxlength` devient une contrainte de colonne. Tu écriras les mêmes règles deux fois, et ce n'est pas une duplication inutile : ce sont deux publics différents.

Et au **palier 3**, les formulaires React seront des « formulaires contrôlés » — chaque frappe passera par l'état du composant. Les attributs de cette leçon resteront, l'orchestration changera.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire un formulaire d'inscription, et découvrir que le navigateur en fait déjà beaucoup. Tu vas aussi le tester **au clavier uniquement**, et trouver des choses cassées que tu n'avais pas vues.

Le réflexe à installer : tester systématiquement avec `Tab`, `Entrée` et `Espace`, sans toucher la souris. Trente secondes par formulaire.

### En équipe, en entreprise

**Les formulaires sont le gros du travail d'un frontend d'entreprise.** Une application de gestion, c'est 80 % de formulaires et de tableaux. Les maîtriser n'est pas un détail du palier 2 : c'est une grande partie du métier.

**L'accessibilité est auditée.** Lighthouse ou axe tournent dans le pipeline, et un `<label>` manquant fait échouer la vérification. Certains secteurs (public, banque, grande entreprise) ont des obligations contractuelles.

**On te parlera de bibliothèques.** React Hook Form, Zod, Formik : elles gèrent l'état, la validation et les messages d'erreur. Elles ne te dispensent pas de cette leçon — elles ont besoin que tu saches ce qu'est un champ relié à un libellé et quel type d'input utiliser. Au palier 3, tu les emploieras en comprenant ce qu'elles automatisent.

**Et tu verras beaucoup de mauvais formulaires**, y compris en production : des `<div>` cliquables en guise de cases à cocher, des libellés qui sont de simples `<span>` à côté du champ, des messages d'erreur en rouge seulement (invisibles pour un daltonien), des placeholders utilisés comme libellés.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `form`, `label`, `input` (types `text`, `email`, `password`, `number`, `date`, `checkbox`, `radio`, `file`, `search`, `tel`), `select`/`option`, `textarea`, `button`, et les attributs `required`, `name`, `id`, `placeholder`, `value`, `disabled`.

Régulièrement : `fieldset`/`legend` (indispensable pour un groupe de boutons radio), `pattern`, `min`/`max`/`step`, `autocomplete`, `aria-describedby` pour relier un message d'erreur à son champ, `:focus-visible` en CSS.

Rare, et hors sujet maintenant : la plupart des attributs ARIA (`role`, `aria-live`, `aria-expanded` — utiles pour des composants complexes, pas pour un formulaire ordinaire), `datalist`, `output`, l'API de validation contrainte (`setCustomValidity`), `inputmode`, les formulaires multi-étapes. Et un principe à connaître sur ARIA : **la première règle d'ARIA est de ne pas utiliser ARIA**. Une balise native bien choisie fait mieux, et sans risque.

---

## La mécanique

### Un formulaire correct, de bout en bout

```html
<form action="/inscription" method="post">
  <h2>Créer un compte</h2>

  <p>
    <label for="nom">Nom complet</label>
    <input type="text" id="nom" name="nom" required autocomplete="name">
  </p>

  <p>
    <label for="email">Adresse email</label>
    <input type="email" id="email" name="email" required autocomplete="email"
           aria-describedby="aide-email">
    <small id="aide-email">Nous ne l'utiliserons que pour la connexion.</small>
  </p>

  <p>
    <label for="mdp">Mot de passe</label>
    <input type="password" id="mdp" name="mdp" required minlength="8"
           autocomplete="new-password">
  </p>

  <p>
    <label for="naissance">Date de naissance</label>
    <input type="date" id="naissance" name="naissance" max="2010-01-01">
  </p>

  <p>
    <label for="pays">Pays</label>
    <select id="pays" name="pays" required>
      <option value="">— Choisir —</option>
      <option value="cm">Cameroun</option>
      <option value="fr">France</option>
    </select>
  </p>

  <fieldset>
    <legend>Fréquence des notifications</legend>
    <p>
      <input type="radio" id="freq-jour" name="frequence" value="jour" checked>
      <label for="freq-jour">Quotidienne</label>
    </p>
    <p>
      <input type="radio" id="freq-semaine" name="frequence" value="semaine">
      <label for="freq-semaine">Hebdomadaire</label>
    </p>
  </fieldset>

  <p>
    <input type="checkbox" id="cgu" name="cgu" required>
    <label for="cgu">J'accepte les conditions d'utilisation</label>
  </p>

  <button type="submit">Créer mon compte</button>
</form>
```

Trois choses à remarquer dans cet exemple, parce que ce sont celles qu'on rate.

**Le trio `for` / `id` / `name`.** `for` sur le label doit valoir exactement l'`id` du champ : c'est ce qui les **relie**. Le bénéfice est double — le lecteur d'écran annonce le libellé, et cliquer sur le texte met le focus dans le champ (essaie sur la case « conditions d'utilisation » : la zone cliquable passe de 15 pixels à toute la phrase). L'attribut `name`, lui, est **le nom sous lequel la donnée sera envoyée** au serveur : sans `name`, un champ n'est tout simplement pas transmis.

**Le `fieldset` avec sa `legend`** pour les boutons radio. Sans lui, un lecteur d'écran annonce « Quotidienne, bouton radio » sans dire de quoi il s'agit. La `legend` donne le contexte au groupe.

**L'`autocomplete`.** Il permet au navigateur et au gestionnaire de mots de passe de remplir correctement. Ce n'est pas un détail de confort : un formulaire sans `autocomplete` correct empêche les gestionnaires de mots de passe de fonctionner, ce qui pousse les gens à choisir des mots de passe faibles.

### Les types d'input, et pourquoi ils comptent

| Type | Ce que tu obtiens gratuitement |
|------|-------------------------------|
| `email` | validation du format, clavier avec `@` sur mobile |
| `tel` | pavé numérique sur mobile (mais **aucune** validation : les formats varient trop) |
| `number` | flèches, `min`/`max`/`step`, clavier numérique |
| `date` | sélecteur de date natif, format localisé |
| `password` | masquage, intégration au gestionnaire de mots de passe |
| `search` | bouton d'effacement, clavier adapté |
| `file` | sélecteur de fichiers, `accept` pour filtrer |
| `url` | validation du format |

*(Table de référence — l'important est le principe : choisir le bon type, c'est obtenir du comportement sans l'écrire.)*

Le gain le plus visible est **sur mobile** : le clavier qui s'affiche dépend du type. Un champ de montant en `type="text"` affiche un clavier alphabétique — chaque utilisateur mobile le remarque, même sans savoir pourquoi.

### La validation native

```html
<input type="email" required minlength="5" maxlength="100">
<input type="number" min="0" max="150" step="1">
<input type="text" pattern="[0-9]{4}" title="Quatre chiffres">
```

Le navigateur bloque la soumission et affiche un message **traduit automatiquement**. Tu peux styler les états :

```css
input:invalid  { border-color: crimson; }
input:valid    { border-color: seagreen; }
input:focus-visible { outline: 2px solid currentColor; outline-offset: 2px; }
```

> ⚠️ Attention à `:invalid` : il s'applique **dès le chargement**, donc un formulaire vide apparaît tout en rouge. La parade est `:user-invalid` (qui n'agit qu'après interaction), ou de n'appliquer le style qu'après la première tentative de soumission via une classe ajoutée en JavaScript (leçon 08).

### Placeholder n'est pas label

```html
<!-- ❌ -->
<input type="email" placeholder="Votre email">

<!-- ✅ -->
<label for="email">Votre email</label>
<input type="email" id="email" name="email" placeholder="nom@exemple.com">
```

C'est l'erreur de conception la plus répandue du web. Le `placeholder` **disparaît dès qu'on tape** : l'utilisateur ne sait plus ce que le champ attend, ne peut plus vérifier son remplissage, et les lecteurs d'écran le traitent de façon inégale. Son contraste est aussi souvent trop faible. Le `placeholder` sert à donner un **exemple de format**, pas à nommer le champ.

### Les cinq règles d'accessibilité qui couvrent l'essentiel

**Tout champ a un libellé relié.** Si le design n'en veut pas visuellement, on le masque pour les yeux mais pas pour les outils (une classe `.sr-only`), ou on utilise `aria-label`.

**Tout est atteignable au clavier.** Teste avec `Tab`. Et ne retire jamais le contour de focus (`outline: none`) sans le remplacer par un indicateur visible : c'est l'un des pires gestes du web, et il rend une page inutilisable au clavier.

**La couleur n'est jamais le seul porteur d'information.** Un champ en erreur doit avoir un **message texte**, pas seulement une bordure rouge.

**Le contraste est suffisant** : au moins 4,5 contre 1 pour du texte normal. Les outils de développement du navigateur le calculent pour toi.

**L'ordre du HTML est l'ordre de lecture.** Un lecteur d'écran et la touche `Tab` suivent l'ordre du **document**, pas celui de l'affichage. Si tu réordonnes visuellement avec du CSS (leçon 04), tu crées un décalage déroutant.

---

## Les problèmes que tu vas rencontrer

**Ton formulaire recharge la page et tout disparaît.** C'est le comportement par défaut : un `submit` envoie et navigue. Pour traiter en JavaScript, il faut `event.preventDefault()` (leçon 08).

**Une donnée n'arrive pas côté serveur.** Il manque l'attribut `name` sur le champ. L'`id` sert au label et au CSS ; c'est `name` qui transmet.

**Cliquer sur le libellé ne met pas le focus dans le champ.** Le `for` ne correspond pas à l'`id`, ou l'`id` est dupliqué dans la page (un `id` doit être unique).

**Ton formulaire est tout rouge au chargement.** `:invalid` sur un formulaire vide. Utilise `:user-invalid`.

**Ton bouton soumet alors qu'il ne devrait pas.** Un `<button>` sans `type` vaut `type="submit"` dans un formulaire.

**Les boutons radio ne s'excluent pas.** Ils doivent partager le **même `name`**. C'est le `name` qui crée le groupe, pas le `fieldset`.

**Ton champ `number` accepte des lettres.** Selon les navigateurs, le comportement varie, et `type="number"` a beaucoup de pièges (la molette qui change la valeur, le collage, les décimales localisées). Pour un montant ou un code postal, beaucoup d'équipes préfèrent `type="text"` avec `inputmode="numeric"` et une validation explicite.

**Le gestionnaire de mots de passe remplit n'importe quoi.** Les valeurs d'`autocomplete` sont mal renseignées (`new-password` à l'inscription, `current-password` à la connexion).

---

## Ce qu'on te demandera

En **test technique**, le formulaire est l'exercice standard : « fais un formulaire d'inscription avec validation ». On regarde les libellés reliés, les types d'input, la validation native **et** JavaScript, les messages d'erreur par champ, et la navigation au clavier. C'est exactement l'épreuve A2 de ton évaluation de palier.

En **entretien** : « pourquoi un `label` plutôt qu'un `placeholder` ? », « la validation côté client suffit-elle ? » (non — et c'est la question piège de sécurité), « comment rends-tu un formulaire accessible ? », « différence entre `id` et `name` ? ».

En **travail réel**, on attendra que ton formulaire passe l'audit d'accessibilité automatique et qu'il soit utilisable au clavier. Et on te demandera de traiter les cas d'erreur : que voit l'utilisateur quand le serveur refuse sa saisie ?

---

## Ce qui te démarquera

**Tester au clavier systématiquement.** Dix secondes, et presque personne ne le fait. Dire « je l'ai vérifié au clavier » en revue de code est une phrase qui marque.

**Choisir les bons types d'input, en pensant au mobile.** Le clavier qui s'affiche est une attention au détail qui se remarque à l'usage.

**Relier les messages d'erreur avec `aria-describedby`.** Peu de développeurs le font, et c'est ce qui fait qu'un lecteur d'écran annonce l'erreur au lieu de laisser l'utilisateur deviner.

**Savoir que le `placeholder` n'est pas un libellé**, et pouvoir l'expliquer. C'est le marqueur le plus fiable de quelqu'un qui a lu sur le sujet.

**Renseigner `autocomplete` correctement.** Détail minuscule, effet réel sur la sécurité et le confort.

**Et savoir que la validation serveur est la seule qui compte**, tout en implémentant quand même celle du client. Cette double compréhension est précisément ce qu'on attend d'un profil fullstack.

---

## 📚 À lire

**MDN → *Web form building blocks*** et ***Client-side form validation*** : les deux pages de référence, à lire en entier. Elles sont longues mais directement applicables.

**MDN → *HTML: A good basis for accessibility*** si tu ne l'as pas lue à la leçon 01.

**The Odin Project → HTML Foundations → Forms**.

Et deux lectures courtes qui changent la façon de concevoir : **« Placeholders are problematic »** (Nielsen Norman Group ou l'article de Gov.uk) et les **WCAG en version simplifiée** (w3.org/WAI/WCAG22/quickref, filtré sur le niveau A) — survole, ne mémorise pas.

---

## 🤖 Le mini-projet à demander à l'IA

Les formulaires s'apprennent sur des cas réalistes, avec leurs cas limites.

> « Je suis en formation de développeur, palier 2 (frontend). Je travaille les formulaires et l'accessibilité. Décris-moi, **en langage naturel et sans aucun code**, les besoins d'un formulaire réaliste : une demande de devis pour un artisan (coordonnées, type de travaux à choix multiple, surface, budget approximatif, date souhaitée, description libre, pièces jointes, acceptation RGPD). Pour chaque champ, dis seulement **ce que l'utilisateur doit pouvoir saisir** et **les contraintes métier** — pas comment le baliser. Ma mission : écrire le HTML, choisir les types, les attributs de validation et les relations label/champ. Ensuite, audite mon formulaire sur six points : libellés reliés, types d'input adaptés au mobile, validation native utilisée, groupes de champs, messages d'erreur accessibles, navigation au clavier. **Ne réécris pas mon code.** »

Puis l'audit inverse, qui apprend à repérer :

> « Donne-moi le HTML d'un formulaire de connexion **tel qu'on en trouve en production, avec six défauts d'accessibilité réalistes** (placeholder en guise de label, `outline: none`, div cliquable, erreur en rouge seulement, radio sans fieldset, autocomplete absent). Ne me dis pas lesquels. Je dois les trouver, expliquer la conséquence de chacun pour un utilisateur réel, puis corriger. »

---

## 🛠️ À faire

1. **Le formulaire complet** : inscription avec nom, email, mot de passe, confirmation, date de naissance, pays (select), fréquence de notification (radio) et acceptation des conditions. Tous les libellés reliés, validation native, `autocomplete` renseigné.
2. **Test clavier** : parcours-le avec `Tab` seulement, remplis-le, soumets-le avec `Entrée`. Note tout ce qui résiste.
3. **Test lecteur d'écran** : si tu peux (NVDA sous Windows, VoiceOver sous macOS, Orca sous Linux), écoute ce qui est annoncé pour chaque champ. Sinon, utilise l'onglet Accessibilité des DevTools, qui montre le nom calculé de chaque élément.
4. Style les états `:focus-visible`, `:user-invalid` et `:disabled`. Vérifie que le focus reste **toujours** visible.
5. **Compare les claviers mobiles** : fais une page avec un champ en `type="text"`, un en `type="email"`, un en `type="number"` et un en `type="tel"`, puis ouvre-la sur ton téléphone. Note la différence.
6. Relie un message d'aide et un message d'erreur à leur champ avec `aria-describedby`.
7. Passe **Lighthouse → Accessibilité** (ou axe) et atteins 100.
8. **Reproduis le piège du placeholder** : fais un formulaire avec des placeholders en guise de libellés, remplis-le à moitié, puis essaie de vérifier ta saisie. Écris dans ton journal ce que tu as ressenti — c'est l'argument que tu réutiliseras en revue de code.
9. Fais un groupe de cases à cocher dans un `fieldset` avec `legend`, et un groupe de boutons radio avec le même `name`.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Pièges attendus. La **confirmation de mot de passe** ne peut pas être validée par les attributs natifs : il faut du JavaScript (leçon 08) — c'est un bon exemple de la frontière entre les deux validations. L'`autocomplete` du mot de passe à l'inscription est `new-password`, pas `current-password`. Et la date de naissance se contraint avec `max` (une date passée), pas avec `pattern`.

**2.** Ce qui résiste habituellement : un faux bouton en `<div>`, un contour de focus retiré, un ordre de tabulation incohérent si tu as réordonné en CSS, un `<select>` personnalisé en JavaScript qui ne répond pas aux flèches.

**3.** Ce que tu dois entendre pour chaque champ : son **libellé**, son **type**, son **état** (requis, invalide), et son texte d'aide s'il est relié. Si tu n'entends que « zone d'édition », le label n'est pas relié.

**5.** Les claviers diffèrent nettement : `email` ajoute `@` et `.`, `tel` affiche un pavé numérique, `number` un clavier numérique. C'est l'un des gains les plus visibles pour l'utilisateur, et il ne coûte qu'un attribut.

**6.**
```html
<label for="mdp">Mot de passe</label>
<input type="password" id="mdp" name="mdp" required minlength="8"
       aria-describedby="aide-mdp erreur-mdp">
<small id="aide-mdp">8 caractères minimum.</small>
<p id="erreur-mdp" role="alert"></p>   <!-- rempli en JS : role="alert" fait annoncer le message -->
```
L'attribut accepte **plusieurs** identifiants séparés par des espaces. Le `role="alert"` fait annoncer le contenu dès qu'il apparaît — c'est l'une des rares utilisations d'ARIA réellement utile sur un formulaire.

**8.** Ce que tu ressens : l'impossibilité de vérifier ce que tu as rempli sans vider le champ. Multiplie ça par un formulaire de douze champs rempli sur un téléphone, dans le bus, et tu comprends pourquoi c'est un problème de conception et pas une préférence.
</details>

---

## ✅ Acquis si…

- [ ] Chacun de mes champs a un `<label>` **relié** par `for`/`id`.
- [ ] Je distingue `id` (label et CSS) de `name` (ce qui est envoyé au serveur).
- [ ] Je choisis le type d'input adapté, et je sais ce qu'il m'apporte sur mobile.
- [ ] J'utilise la validation native, et je sais ce qu'elle ne peut pas faire.
- [ ] Je sais pourquoi la validation côté client ne protège de rien.
- [ ] Mes formulaires sont entièrement utilisables au clavier, avec un focus **toujours** visible.
- [ ] Mes messages d'erreur sont du texte, reliés à leur champ, pas seulement une couleur.
- [ ] Je sais expliquer pourquoi un `placeholder` n'est pas un libellé.
- [ ] Lighthouse → Accessibilité est à 100 sur mes pages.

# Leçon 03 — React : composants, JSX, props

> 🎯 **À la fin de cette leçon** : tu découpes une interface en composants réutilisables et typés, et tu comprends ce que React fait à ta place.
> ⏱️ 4 h · **Prérequis** : leçons 01–02, et le palier 2 en entier (surtout les leçons 07 et 08).

---

## React, c'est quoi

React est une **bibliothèque** qui synchronise une interface avec des données. C'est tout — et c'est énorme, parce que c'est précisément le travail que tu as fait à la main au palier 2.

Son idée tient en une phrase : **l'interface est une fonction de l'état**. Tu ne décris pas les étapes pour modifier le DOM ; tu décris à quoi la page doit **ressembler** pour un état donné, et React se charge de la différence.

```jsx
function Carte({ titre, montant }) {
  return (
    <article className="carte">
      <h3>{titre}</h3>
      <p>{montant} FCFA</p>
    </article>
  );
}
```

Trois notions à poser. Un **composant** est une fonction qui reçoit des données et retourne la description d'un morceau d'interface. Le **JSX** est la syntaxe qui ressemble à du HTML dans du JavaScript — c'est du sucre syntaxique, transformé en appels de fonction à la compilation. Et les **props** sont les données qu'un composant reçoit de son parent, **en lecture seule**.

---

## À quoi ça sert, concrètement

**Parce que tu as déjà rencontré le problème qu'il résout.** Au palier 2, tu as écrit une fonction `rendre()` qui vidait un conteneur et le reconstruisait depuis les données. Ça fonctionne, mais ça a deux défauts que tu as peut-être ressentis : tout est reconstruit même quand une seule ligne change (le focus se perd, le défilement saute), et ton code mélange la structure HTML et la logique dans des chaînes ou des `createElement`.

React résout exactement ces deux points : il compare ce que tu décris avec ce qui est affiché, et ne modifie que la différence. Tu gardes la simplicité du « je redessine tout » avec la performance du « je modifie chirurgicalement ».

**Parce que le découpage en composants rend une interface complexe gérable.** Une application réelle a cent écrans et mille éléments. Les composants permettent de raisonner sur un morceau à la fois, de le réutiliser, et de le tester isolément.

**Et parce que c'est l'outil le plus demandé du marché frontend.** Ce n'est pas un argument technique, mais c'est un fait utile à connaître : React est présent dans la majorité des offres frontend et fullstack.

---

## Où ça intervient dans le développement

React occupe la place de la couche comportement du palier 2, mais il absorbe aussi une partie du HTML :

```
   PALIER 2 (à la main)              PALIER 3 (React)
   ──────────────────                ─────────────────
   index.html (structure)      →     des composants qui retournent du JSX
   style.css                   →     style.css (inchangé) ou Tailwind
   ui.js    (toucher le DOM)   →     React s'en charge
   app.js   (état + rendre())  →     useState + le rendu automatique
   api.js   (réseau)           →     api.ts (inchangé) puis TanStack Query
```

Remarque bien ce qui **ne change pas** : ton CSS, et ta couche API. Et ce qui change : tu ne touches plus au DOM, et tu n'appelles plus `rendre()` toi-même.

Deux conséquences d'architecture importantes.

**La logique métier reste en dehors des composants.** Tes fonctions pures du palier 1 (`calculerTotal`, `filtrerParCategorie`) ne deviennent pas des composants : elles restent des fonctions, importées. Un composant assemble et affiche ; il ne calcule pas les règles de l'entreprise. C'est le fil rouge architecture — « la logique métier vit HORS des composants » — et le référent le vérifiera dans ton projet 3.

**Le même découpage servira au palier 9.** Flutter est construit sur le même modèle : des widgets qui reçoivent des données et décrivent une interface. Les mots changent, le raisonnement est identique.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas créer ton premier projet avec **Vite**, et constater que les modifications apparaissent instantanément dans le navigateur. C'est confortable, et c'est une des raisons de l'adoption de ces outils.

Tu vas aussi te heurter aux petites différences entre JSX et HTML — `className` au lieu de `class`, les accolades pour les expressions, la fermeture obligatoire des balises. Une demi-journée d'adaptation, puis ça devient automatique.

### En équipe, en entreprise

**Le découpage des composants est le premier sujet de revue.** Trop gros (un composant de 400 lignes qui fait tout), trop petit (un composant par bouton stylé), mal placé (la logique métier dedans) : ce sont les trois remarques habituelles.

**On parlera de composants « de présentation » et « conteneurs ».** L'idée est simple et utile : certains composants ne font qu'afficher ce qu'on leur donne (donc réutilisables, testables, sans dépendance), d'autres orchestrent — ils vont chercher les données et décident. Garder la distinction en tête évite les composants inextricables.

**Les props sont en lecture seule, et c'est non négociable.** Modifier une prop reçue est une erreur que le linter signale. Le flux de données en React est descendant : les données vont du parent vers l'enfant, et les enfants communiquent vers le haut par des fonctions de rappel (leçon 04).

**Et tu verras des bases de code sans aucun type sur les props.** C'est encore fréquent, et c'est exactement ce que TypeScript règle.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : des composants fonctionnels, le JSX, les props typées, le rendu de listes avec `map`, le rendu conditionnel, `children`, et les gestionnaires d'événements.

Régulièrement : la composition (passer du JSX en prop), les fragments (`<>…</>`), l'extraction d'un composant devenu trop gros, les props avec valeur par défaut.

Rare, et hors sujet pour toi : les composants de classe (l'ancienne syntaxe — tu en liras dans du code ancien, tu n'en écriras pas), `React.memo` et les optimisations de rendu (seulement quand un problème est **mesuré**), les *render props* et les composants d'ordre supérieur (remplacés par les hooks), `forwardRef`, les portails, les *error boundaries* (utiles, mais plus tard), `Suspense` et les composants serveur. Et un conseil : **ne cherche pas à optimiser les rendus** avant d'avoir un ralentissement mesuré. C'est la source de complexité inutile la plus fréquente chez les débutants en React.

---

## La mécanique

### Créer le projet

```bash
npm create vite@latest mon-app -- --template react-ts
cd mon-app && npm install && npm run dev
```

`react-ts` donne React avec TypeScript. **Pas Create React App** : il est officiellement abandonné.

### Un composant

```tsx
// Carte.tsx
type ProprietesCarte = {
  titre: string;
  montant: number;
  categorie?: string;              // optionnel
};

export function Carte({ titre, montant, categorie = "autre" }: ProprietesCarte) {
  return (
    <article className="carte">
      <h3>{titre}</h3>
      <p className="montant">{montant.toLocaleString("fr-FR")} FCFA</p>
      <span className="categorie">{categorie}</span>
    </article>
  );
}
```

Trois règles sans exception. Le nom d'un composant commence par une **majuscule** (c'est ainsi que React le distingue d'une balise HTML). Il **retourne** du JSX. Et il reçoit un **seul** argument, l'objet des props — qu'on déstructure dans la signature, exactement comme à la leçon 07 du palier 1.

Note que la signature typée est devenue de la documentation : on sait, sans lire le corps, ce que ce composant attend.

### JSX : les différences avec HTML

```jsx
<div className="carte">              {/* class → className */}
<label htmlFor="nom">                {/* for → htmlFor */}
<img src={url} alt="" />             {/* fermeture obligatoire */}
<input value={valeur} onChange={gerer} />   {/* camelCase pour les événements */}

{/* Les accolades contiennent une EXPRESSION JavaScript */}
<p>{montant * 2}</p>
<p>{depenses.length} dépenses</p>
<p>{formaterMontant(montant)}</p>

{/* Style en ligne : un objet, en camelCase — à éviter, préfère les classes */}
<div style={{ backgroundColor: "red", marginTop: 8 }} />

{/* Plusieurs éléments sans conteneur : un fragment */}
<>
  <h2>Titre</h2>
  <p>Texte</p>
</>
```

Le point à comprendre : **les accolades acceptent une expression, pas une instruction** (la distinction de la leçon 01 du palier 1). Tu peux y mettre un ternaire, un `&&`, un appel de fonction — mais pas un `if` ni une boucle `for`. C'est pour cette raison que le rendu conditionnel s'écrit avec des ternaires, et le rendu de liste avec `map`.

### Rendre une liste

```tsx
type ProprietesListe = { depenses: Depense[] };

export function ListeDepenses({ depenses }: ProprietesListe) {
  if (depenses.length === 0) {
    return <p className="vide">Aucune dépense pour le moment.</p>;   // l'état vide, toujours
  }

  return (
    <ul className="liste">
      {depenses.map(d => (
        <li key={d.id}>                           {/* ⭐ key obligatoire */}
          <Carte titre={d.description} montant={d.montant} categorie={d.categorie} />
        </li>
      ))}
    </ul>
  );
}
```

C'est le `map` du palier 1, leçon 06 — et c'est l'usage le plus fréquent de ta carrière React. La **`key`** est détaillée à la leçon 06 ; retiens pour l'instant qu'elle est obligatoire et qu'elle doit être un identifiant **stable**, pas l'index.

### Le rendu conditionnel

```tsx
{/* Ternaire : si / sinon */}
{estConnecte ? <Profil /> : <BoutonConnexion />}

{/* && : afficher seulement si */}
{erreur && <p className="erreur">{erreur}</p>}

{/* Retour anticipé : le plus lisible quand le cas est global */}
if (chargement) return <Chargement />;
if (erreur) return <Erreur message={erreur} />;
return <Liste depenses={depenses} />;
```

Le retour anticipé est les clauses de garde de la leçon 02 du palier 1, appliquées au rendu. C'est la forme la plus lisible dès qu'il y a plus de deux cas.

> ⚠️ Un piège du `&&` : si la valeur de gauche est le **nombre** `0`, React affiche `0` à l'écran. `{depenses.length && <Liste />}` affiche « 0 » quand la liste est vide. Écris `{depenses.length > 0 && <Liste />}`.

### `children` et la composition

```tsx
type ProprietesPanneau = {
  titre: string;
  children: React.ReactNode;        // le contenu placé entre les balises
};

export function Panneau({ titre, children }: ProprietesPanneau) {
  return (
    <section className="panneau">
      <h2>{titre}</h2>
      <div className="contenu">{children}</div>
    </section>
  );
}

// Usage
<Panneau titre="Dépenses du mois">
  <ListeDepenses depenses={depenses} />
</Panneau>
```

`children` est la façon de construire des composants **enveloppes** — cartes, panneaux, modales, mises en page. C'est l'outil de composition le plus utilisé, et il évite de multiplier les props.

### Les props sont en lecture seule

```tsx
function Mauvais({ depenses }: { depenses: Depense[] }) {
  depenses.push({ … });            // ❌ on mute une prop : interdit
  depenses.sort((a, b) => …);      // ❌ sort mute aussi (palier 1, leçon 04)
  return …;
}

function Bon({ depenses }: { depenses: Depense[] }) {
  const triees = [...depenses].sort((a, b) => b.montant - a.montant);   // ✅ une copie
  return …;
}
```

Tu reconnais la leçon 04 du palier 1 : muter ou retourner du neuf. En React, ce n'est plus une bonne pratique, c'est une **condition de fonctionnement** — et la leçon 04 de ce palier expliquera pourquoi.

### Où mettre la logique

```tsx
// ❌ La règle métier noyée dans le composant
function Total({ depenses }) {
  let t = 0;
  for (const d of depenses) if (d.statut !== "annulee") t += d.montant * 1.1925;
  return <p>{t}</p>;
}

// ✅ Une fonction pure, importée, testable sans React
// domaine/calculs.ts
export function calculerTotalTTC(depenses: Depense[]): number {
  return depenses
    .filter(d => d.statut !== "annulee")
    .reduce((s, d) => s + d.montant * 1.1925, 0);
}

// Total.tsx
function Total({ depenses }: { depenses: Depense[] }) {
  return <p>{formaterMontant(calculerTotalTTC(depenses))}</p>;
}
```

La version du bas se teste en une ligne, sans navigateur ni React, et se réutilise dans une autre interface — y compris dans ton application Flutter du palier 9, si la logique vit côté serveur. C'est le fil rouge architecture, niveau 2.

---

## Les problèmes que tu vas rencontrer

**`Objects are not valid as a React child`.** Tu essaies d'afficher un objet (`{depense}` au lieu de `{depense.description}`). React sait afficher des chaînes, des nombres et du JSX, pas des objets.

**Rien ne s'affiche, et pas d'erreur.** Trois causes : ton composant ne **retourne** rien (une fléchée avec des accolades sans `return` — palier 1, leçon 03), son nom commence par une minuscule, ou tu as oublié de l'appeler avec `<Composant />`.

**`Each child in a list should have a unique "key" prop`.** Un `map` sans `key`.

**Mon JSX ne compile pas.** Deux éléments retournés sans conteneur (il faut un fragment), une balise non fermée, ou un `class` au lieu de `className`.

**J'affiche `0` alors que je voulais ne rien afficher.** Le piège du `&&` avec un nombre.

**`Cannot read properties of undefined` dans un composant.** Tu accèdes à une prop qui n'a pas été passée — et c'est précisément ce que TypeScript t'évite si tu typées tes props. Si tu as l'erreur, c'est que tu as un `any` quelque part.

**Mon composant fait 300 lignes.** Découpe. Le signe : tu dois défiler pour le lire, ou son nom ne décrit plus ce qu'il fait.

**Je modifie une prop et rien ne change.** Les props sont en lecture seule. Ce que tu cherches, c'est l'état (leçon 04).

---

## Ce qu'on te demandera

En **test technique React**, l'exercice standard est de construire une petite interface à partir d'une maquette et de données fournies. Ce qu'on regarde : le découpage en composants, les props typées, la `key`, l'état vide traité, et l'absence de logique métier dans les composants.

En **entretien** : « qu'est-ce qu'un composant ? », « qu'est-ce que le JSX et en quoi se transforme-t-il ? », « quelle est la règle sur les props ? », « comment affiches-tu une liste ? », « comment découperais-tu cette page en composants ? » (on peut te montrer une capture d'écran — c'est un exercice fréquent).

En **revue de code**, le découpage et la place de la logique sont les deux premiers sujets.

---

## Ce qui te démarquera

**Garder la logique métier hors des composants.** C'est la remarque que le référent fera sur ton projet 3, et c'est ce qui distingue un code React maintenable d'un code où tout est mêlé.

**Typer les props systématiquement.** La signature devient la documentation du composant.

**Traiter l'état vide dans chaque composant de liste.** Comme au palier 2 : c'est le cas que tout le monde oublie et que tout utilisateur rencontre.

**Savoir découper au bon grain.** Ni un composant géant, ni cinquante composants d'une ligne. Le repère utile : un composant qui a **un nom évident** et **une responsabilité** est bien découpé.

**Utiliser `children` pour les enveloppes** plutôt que d'empiler les props. C'est le réflexe de composition, et il rend les composants réellement réutilisables.

**Ne pas optimiser.** Résister à `React.memo` et `useCallback` avant d'avoir mesuré un problème est un signe de maturité, pas de paresse.

---

## 📚 À lire

**react.dev → *Learn React***, dans l'ordre, du début jusqu'à *Passing Props to a Component*. La nouvelle documentation officielle est excellente — c'est la meilleure ressource React qui existe, et elle est gratuite.

En particulier **react.dev → *Thinking in React***, qui décrit la méthode de découpage d'une maquette en composants. C'est la lecture la plus utile de cette leçon.

**The Odin Project → React** pour la pratique guidée.

Et la documentation de **Vite** si tu veux comprendre ce que fait l'outil de build — survol suffisant à ce stade.

---

## 🤖 Le mini-projet à demander à l'IA

Le découpage s'apprend en découpant, et c'est ce qu'on évalue en entretien.

> « Je suis en formation de développeur, palier 3 (React + TypeScript). Je travaille les composants, le JSX et les props. Décris-moi **en mots seulement, sans aucun code**, 6 écrans d'interface réalistes (un tableau de bord de dépenses, une fiche produit, une liste de messages, un profil utilisateur, un tableau de données avec filtres, une page de paramètres). Pour chacun, je dois te proposer **le découpage en composants** : lesquels, avec quelles props typées, et lesquels sont de pure présentation. Critique mon découpage sur quatre points : un composant qui fait trop de choses, un découpage inutile, de la logique métier qui devrait être extraite, et des props mal typées ou trop nombreuses. **N'écris pas le code.** »

Puis le transfert depuis ton travail du palier 2, qui est l'exercice le plus instructif :

> « J'ai une application météo écrite sans framework, en trois fichiers (api.js, ui.js, app.js), avec une fonction `rendre()` qui reconstruit le DOM. Sans me donner de code React, explique-moi **quelle partie de mon code disparaît** avec React, **quelle partie reste identique**, et **où va chacune des responsabilités** de mes trois fichiers. Ensuite, pose-moi des questions pour vérifier que j'ai compris où placer ma logique métier. »

---

## 🛠️ À faire

1. Crée un projet `react-ts` avec Vite, lance-le, et modifie un texte pour voir le rechargement instantané.
2. Écris un composant `Carte` avec des props typées (titre, montant, catégorie optionnelle) et utilise-le trois fois avec des valeurs différentes.
3. **Rends une liste** : à partir de ton tableau de six dépenses (palier 1, leçon 04), affiche-les avec `map` et une `key`. Traite l'état vide.
4. **Les trois formes de rendu conditionnel** : écris le même affichage avec un ternaire, avec `&&`, et avec des retours anticipés. Note laquelle tu trouves la plus lisible.
5. **Le piège du `&&`** : écris `{depenses.length && <Liste …/>}` avec une liste vide, constate le `0` affiché, puis corrige.
6. Écris un composant `Panneau` qui utilise `children`, et enveloppe ta liste dedans.
7. **Extrais la logique** : prends un composant qui calcule un total dans son corps, et sors le calcul dans un fichier `domaine/calculs.ts` sous forme de fonction pure. Vérifie que la fonction se teste sans React.
8. **Découpe une maquette** : prends une capture d'écran d'une page réelle (une fiche produit par exemple), et dessine sur papier les composants, leurs noms et leurs props. Puis implémente-la.
9. **Démontre la lecture seule** : essaie de faire `depenses.sort(...)` directement sur une prop, observe le comportement, puis corrige avec une copie.
10. Reprends ton projet 2 (l'application météo) et réécris **seulement l'affichage** en composants React, sans encore gérer l'état — avec des données codées en dur.

<details>
<summary>Corrections et points de contrôle</summary>

**4.** Le repère habituel : le ternaire pour un choix entre deux affichages proches, le `&&` pour un élément qui apparaît ou non, les retours anticipés dès qu'il y a trois cas ou plus, ou que les rendus sont très différents. Les retours anticipés sont presque toujours les plus lisibles pour les états chargement / erreur / données.

**5.** `0` est une valeur *falsy* mais c'est un **nombre**, et React affiche les nombres. Avec `depenses.length > 0 &&`, l'expression vaut `false`, et React n'affiche rien pour `false`, `null` et `undefined`. C'est un bug très fréquent, et très visible.

**7.** Le contrôle : ta fonction doit être appelable depuis un fichier de test sans importer React ni monter de composant. Si elle a besoin d'un composant pour être testée, elle n'est pas encore extraite.

**9.** `sort` mute le tableau reçu, donc tu modifies l'état du parent sans passer par React. Résultat : les données changent mais l'interface ne se met pas forcément à jour, et deux composants qui partagent ce tableau se désynchronisent. C'est l'avant-goût de la leçon 04 — et la raison pour laquelle l'immuabilité, en React, n'est pas une préférence stylistique.

**10.** Ce que tu dois constater : ton `api.ts` est repris tel quel, ton CSS aussi, ton `ui.js` **disparaît entièrement** (React le remplace), et ton `app.js` se réduira à de l'état (leçon 04). C'est la meilleure façon de comprendre ce que React apporte : il remplace une couche précise, pas tout ton travail.
</details>

---

## ✅ Acquis si…

- [ ] Je crée un projet React + TypeScript avec Vite.
- [ ] J'écris un composant avec des props **typées** et déstructurées dans la signature.
- [ ] Je rends une liste avec `map` et une `key` stable, et je traite l'état vide.
- [ ] Je connais les trois formes de rendu conditionnel et le piège du `&&` avec un nombre.
- [ ] J'utilise `children` pour composer des enveloppes.
- [ ] Je garde la **logique métier hors des composants**, dans des fonctions pures testables.
- [ ] Je ne mute jamais une prop, et je sais pourquoi.
- [ ] Je découpe une maquette en composants nommés, avec une responsabilité chacun.
- [ ] Je n'optimise pas les rendus sans avoir mesuré un problème.

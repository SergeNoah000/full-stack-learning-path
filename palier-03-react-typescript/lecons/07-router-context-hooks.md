# Leçon 07 — React Router, Context, custom hooks

> 🎯 **À la fin de cette leçon** : tu construis une application à plusieurs pages, tu partages un état global quand c'est justifié, et tu extrais ta logique réutilisable dans tes propres hooks.
> ⏱️ 5 h · **Prérequis** : leçons 03–06.

---

## De quoi on parle

**React Router** apporte la navigation à une application d'une seule page : plusieurs URL, plusieurs vues, sans rechargement complet. L'URL redevient une adresse qu'on peut partager, mettre en favori, et parcourir avec les boutons du navigateur.

Le **Context** permet de rendre une valeur accessible à tout un sous-arbre de composants, sans la faire descendre de props en props. C'est la réponse au *props drilling* — mais une réponse plus coûteuse qu'elle n'en a l'air, et la leçon insiste sur le « quand ».

Un **custom hook** est simplement une fonction dont le nom commence par `use` et qui appelle d'autres hooks. Rien de magique : c'est le moyen d'extraire de la logique à état pour la réutiliser.

---

## À quoi ça sert, concrètement

**Pour le routeur : parce qu'une application sans URL n'est pas une application web.** Sans routeur, tu ne peux pas envoyer un lien vers une fiche précise, le bouton « retour » casse tout, et un rechargement perd l'écran en cours. L'URL est une partie de l'état de ton application, et c'est celle que l'utilisateur contrôle.

**Pour le Context : parce que certaines données concernent tout le monde.** Le thème, l'utilisateur connecté, la langue. Les faire descendre en props à travers huit niveaux est absurde ; le Context règle ce cas précis.

**Pour les custom hooks : parce que c'est le moyen de ne pas se répéter.** Dès que deux composants ont besoin de la même logique à état — lire `localStorage`, écouter la taille de la fenêtre, gérer un formulaire, appeler une API — tu l'extrais. Et c'est là que ton palier 1 paie : un custom hook est une **fonction**, et tout ce que tu sais sur les fonctions pures, les closures et le découpage s'applique.

---

## Où ça intervient dans le développement

Ces trois outils répondent chacun à une question d'architecture différente, et il est utile de les voir côte à côte :

```
   « où suis-je dans l'application ? »      → le ROUTEUR (l'URL est un état)
   « cette donnée concerne tout le monde »  → le CONTEXT (avec parcimonie)
   « cette logique se répète »              → un CUSTOM HOOK
```

Et il faut compléter la hiérarchie de l'état posée à la leçon 04, parce que le Context y prend sa place exacte :

```
   état local                → useState dans le composant
   état partagé entre frères → useState remonté au parent
   état d'URL                → le routeur (paramètres, query string)   ← nouveau
   état global d'interface   → Context (thème, utilisateur, langue)      ← nouveau
   état serveur              → TanStack Query (leçon 08)
```

Deux points qui éviteront des erreurs fréquentes.

**L'URL est un état, et souvent le meilleur endroit pour un filtre ou une page courante.** Mettre le filtre actif dans la query string (`?categorie=food`) le rend partageable, favorisable et navigable — ce qu'un `useState` ne permet pas. C'est un réflexe que peu de juniors ont et qui améliore réellement une application.

**Le Context n'est pas un gestionnaire d'état.** Il **transporte** une valeur ; il ne la gère pas, et il ne réduit pas les rendus. Au contraire : tous les composants qui le consomment se réaffichent quand sa valeur change. Pour de l'état serveur, c'est TanStack Query (leçon 08) ; pour de l'état global changeant souvent, il existe des bibliothèques (Zustand) — et tu n'en as pas besoin au palier 3.

Et un prolongement : au **palier 9**, Riverpod en Flutter répond exactement à cette même question du partage d'état, avec les mêmes arbitrages.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas découvrir que la navigation est simple à mettre en place, et tu vas prendre goût aux paramètres d'URL.

Tu vas aussi probablement mettre trop de choses dans un Context, puis constater que toute l'application se réaffiche à chaque frappe. C'est l'expérience à faire une fois.

### En équipe, en entreprise

**Le routage vient souvent du framework.** Next.js et Remix ont leur propre système, fondé sur l'arborescence des fichiers. React Router reste la référence pour une application React « nue », et les concepts (routes, paramètres, navigation imbriquée) sont transférables.

**Le Context est encadré.** La règle habituelle : un Context par préoccupation (thème, authentification), avec une valeur qui change **rarement**. Un Context qui contient tout l'état de l'application est un anti-patron connu.

**Les custom hooks sont partout.** Une base de code React mature a un dossier `hooks/` avec dix à trente hooks maison. C'est le principal moyen de réutilisation en React, et savoir en écrire est attendu.

**Et on te parlera des règles des hooks.** Toujours au niveau supérieur du composant, jamais dans une condition ni une boucle, et uniquement dans un composant ou un autre hook. Le linter le vérifie ; la raison est que React identifie les hooks par leur **ordre d'appel**.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : les routes avec paramètres, `Link`, `useParams`, `useNavigate`, `useSearchParams`, un ou deux Contexts par application, et l'écriture de custom hooks.

Régulièrement : les routes imbriquées avec une mise en page commune, la route 404, la redirection après connexion, les routes protégées, `useLocation`.

Rare, et hors sujet pour l'instant : les chargeurs de données du routeur (`loader`), les actions de formulaire, le chargement différé des routes (`lazy` + `Suspense` — utile quand l'application grossit), les transitions de vue, le routage imbriqué à plusieurs niveaux, `useContext` avec des sélecteurs optimisés, `useReducer` dans un Context. Et une tentation à éviter : créer un Context pour une donnée utilisée par deux composants voisins — une remontée d'état suffit.

---

## La mécanique

### React Router

```bash
npm install react-router-dom
```

```tsx
// main.tsx
import { BrowserRouter, Routes, Route } from "react-router-dom";

<BrowserRouter>
  <Routes>
    <Route path="/" element={<Mise enPage />}>
      <Route index element={<Accueil />} />
      <Route path="depenses" element={<ListeDepenses />} />
      <Route path="depenses/:id" element={<FicheDepense />} />   {/* paramètre */}
      <Route path="*" element={<PageIntrouvable />} />            {/* 404 */}
    </Route>
  </Routes>
</BrowserRouter>
```

```tsx
// Navigation : Link, PAS <a>
import { Link, NavLink } from "react-router-dom";

<Link to="/depenses">Mes dépenses</Link>
<NavLink to="/depenses" className={({ isActive }) => isActive ? "actif" : ""}>
  Mes dépenses
</NavLink>
```

> ⚠️ **Un `<a href>` recharge toute la page** et fait perdre l'état de l'application. `Link` intercepte le clic et change l'URL sans rechargement. C'est l'erreur n°1 avec un routeur, et son symptôme est un « clignotement » à chaque navigation.

```tsx
// Lire les paramètres d'URL
import { useParams, useNavigate, useSearchParams } from "react-router-dom";

function FicheDepense() {
  const { id } = useParams();                  // string | undefined
  const naviguer = useNavigate();

  if (!id) return <PageIntrouvable />;
  return <button onClick={() => naviguer("/depenses")}>Retour</button>;
}
```

### ⭐ La query string comme état

C'est l'usage le plus rentable du routeur, et celui qu'on oublie :

```tsx
function ListeDepenses() {
  const [parametres, setParametres] = useSearchParams();
  const categorie = parametres.get("categorie") ?? "tout";

  return (
    <select value={categorie}
            onChange={e => setParametres({ categorie: e.target.value })}>
      <option value="tout">Toutes</option>
      <option value="food">Alimentation</option>
    </select>
  );
}
```

Ce que tu gagnes par rapport à un `useState` : l'URL devient `?categorie=food`, donc **partageable** (« regarde mes dépenses alimentation »), **favorisable**, et le bouton « retour » du navigateur revient au filtre précédent. Pour trois lignes de code, c'est un gain d'usage considérable.

La règle de choix : si l'utilisateur pourrait vouloir **partager ou retrouver** cet état, il va dans l'URL. Sinon, `useState`.

### Les mises en page imbriquées

```tsx
import { Outlet } from "react-router-dom";

function MiseEnPage() {
  return (
    <div className="app">
      <Entete />
      <Navigation />
      <main><Outlet /></main>      {/* ⭐ la route enfant s'affiche ici */}
      <PiedDePage />
    </div>
  );
}
```

L'en-tête et la navigation ne se réaffichent pas à chaque changement de page : seul l'`Outlet` change. C'est la structure de la plupart des applications réelles.

### Le Context

```tsx
// contextes/Theme.tsx
import { createContext, useContext, useState, type ReactNode } from "react";

type Theme = "clair" | "sombre";
type ValeurTheme = { theme: Theme; basculer: () => void };

const ContexteTheme = createContext<ValeurTheme | null>(null);

export function FournisseurTheme({ children }: { children: ReactNode }) {
  const [theme, setTheme] = useState<Theme>("clair");
  const basculer = () => setTheme(t => (t === "clair" ? "sombre" : "clair"));
  return (
    <ContexteTheme.Provider value={{ theme, basculer }}>
      {children}
    </ContexteTheme.Provider>
  );
}

// ⭐ Un hook maison : le consommateur n'a pas à gérer le null
export function useTheme() {
  const valeur = useContext(ContexteTheme);
  if (!valeur) throw new Error("useTheme doit être utilisé dans un FournisseurTheme");
  return valeur;
}
```

```tsx
// Usage, à n'importe quelle profondeur
function BoutonTheme() {
  const { theme, basculer } = useTheme();
  return <button onClick={basculer}>Thème : {theme}</button>;
}
```

Le `useTheme` maison est le détail qui compte : il rassemble la vérification du `null` en un seul endroit, et le type devient non-nullable pour tous les consommateurs. C'est le modèle à reproduire pour chaque Context.

### Quand le Context n'est pas la bonne réponse

| Cas | Bonne réponse |
|---|---|
| Thème, utilisateur connecté, langue | ✅ Context |
| Un filtre partagé par deux composants voisins | remontée d'état (leçon 04) |
| Un filtre que l'utilisateur pourrait partager | l'URL (`useSearchParams`) |
| Les données venues d'une API | TanStack Query (leçon 08) |
| Un état qui change à chaque frappe | état local, ou une bibliothèque dédiée |

*(Table de référence.)* Le critère pratique : **un Context est bon quand sa valeur change rarement**. S'il change souvent, tous ses consommateurs se réaffichent, et tu as créé un problème de performance sans le vouloir.

### ⭐ Les custom hooks

Un hook maison est une fonction qui commence par `use` et qui appelle d'autres hooks. C'est tout.

```tsx
// hooks/useLocalStorage.ts
export function useLocalStorage<T>(cle: string, valeurInitiale: T) {
  const [valeur, setValeur] = useState<T>(() => {         // forme paresseuse
    try {
      const brut = localStorage.getItem(cle);
      return brut === null ? valeurInitiale : (JSON.parse(brut) as T);
    } catch {
      return valeurInitiale;                               // leçon 09 du palier 2
    }
  });

  useEffect(() => {
    try { localStorage.setItem(cle, JSON.stringify(valeur)); }
    catch { /* quota, navigation privée : on continue */ }
  }, [cle, valeur]);

  return [valeur, setValeur] as const;     // as const → tuple typé, comme useState
}

// Usage : indiscernable d'un hook natif
const [theme, setTheme] = useLocalStorage<Theme>("theme", "clair");
```

Note le `as const` : sans lui, TypeScript infère `(T | Dispatch<T>)[]`, et le destructuring perd les types. C'est l'idiome qui rend un hook maison aussi agréable qu'un hook natif.

Un deuxième exemple, qui montre la vraie valeur de l'extraction :

```tsx
// hooks/useDebounce.ts
export function useDebounce<T>(valeur: T, delai = 300): T {
  const [differee, setDifferee] = useState(valeur);
  useEffect(() => {
    const id = setTimeout(() => setDifferee(valeur), delai);
    return () => clearTimeout(id);          // ⭐ le nettoyage annule le précédent
  }, [valeur, delai]);
  return differee;
}

// Usage
const [recherche, setRecherche] = useState("");
const rechercheDifferee = useDebounce(recherche, 300);
// → le champ reste réactif, mais le filtrage (ou l'appel réseau) attend 300 ms
```

C'est le `debounce` du palier 2 (leçon 08), en version React. Et observe comment le mécanisme de nettoyage de `useEffect` (leçon 05) remplace le `clearTimeout` manuel : chaque nouvelle frappe nettoie le minuteur précédent. Le hook fait six lignes et s'utilise partout.

**Quand extraire un hook ?** Quand la même logique à état apparaît deux fois, ou quand un composant devient illisible à cause d'une logique qui n'est pas son sujet. Le test : si tu peux nommer la logique (`useDebounce`, `useFormulaire`, `useLargeurFenetre`), elle mérite un hook.

### Les règles des hooks

**Toujours au niveau supérieur du composant.** Jamais dans un `if`, une boucle, ou après un retour anticipé. React identifie les hooks par leur **ordre d'appel** : si cet ordre change entre deux rendus, les états se mélangent.

```tsx
// ❌ Interdit
if (condition) { const [x, setX] = useState(0); }
if (!donnees) return <Chargement />;
const [y, setY] = useState(0);        // ← après un retour : l'ordre varie

// ✅ Tous les hooks d'abord, les retours anticipés ensuite
const [y, setY] = useState(0);
if (!donnees) return <Chargement />;
```

**Uniquement dans un composant ou un autre hook.** Pas dans une fonction ordinaire.

---

## Les problèmes que tu vas rencontrer

**Ma page se recharge entièrement et je perds mon état.** Tu as utilisé `<a href>` au lieu de `Link`.

**Mon application marche en développement et renvoie un 404 en production** sur les URL profondes. Le serveur ne sait pas que `/depenses/42` doit servir `index.html`. C'est une configuration serveur (une règle de réécriture), et tu la mettras en place aux paliers 6 et 8 — c'est d'ailleurs exactement le rôle du front controller que tu construiras en PHP.

**`useParams` me rend `undefined`.** Le nom du paramètre ne correspond pas à la route, ou tu lis le paramètre dans un composant qui n'est pas sous cette route.

**Mon Context rend `null` et plante.** Le composant n'est pas dans le `Provider`. Le hook maison avec son `throw` rend ce diagnostic immédiat — c'est sa raison d'être.

**Toute mon application se réaffiche à chaque frappe.** Tu as mis un état qui change souvent dans un Context. Sors-le, ou découpe le Context.

**La valeur de mon Context se recrée à chaque rendu.** Tu passes un objet littéral (`value={{ a, b }}`), donc une nouvelle référence chaque fois. Ça fait réafficher tous les consommateurs. Dans un `Provider` dont l'état change rarement, c'est acceptable ; sinon, mémorise la valeur.

**`React Hook "useX" is called conditionally`.** Un hook après un retour anticipé ou dans une condition.

**Mon hook maison ne garde pas les types au destructuring.** Il manque `as const`.

**Mon `useDebounce` ne diffère rien.** Tu as probablement mis la valeur différée dans les dépendances de l'effet, ou tu as oublié le nettoyage.

---

## Ce qu'on te demandera

En **entretien** : « qu'est-ce qu'un custom hook et quand en écris-tu un ? », « à quoi sert le Context, et quelles sont ses limites ? » (la seconde moitié distingue), « pourquoi les hooks doivent-ils être appelés au niveau supérieur ? », « comment gères-tu la navigation dans une application React ? ».

Une question plus fine, qui marque quand on y répond bien : **« où mettrais-tu le filtre d'une liste : dans un état, dans l'URL, ou dans un Context ? »**. La bonne réponse dépend de l'usage, et l'évoquer montre un vrai raisonnement.

En **test technique**, on demande souvent une application à deux ou trois pages avec un paramètre d'URL — c'est l'épreuve A2 de ton évaluation de palier.

En **revue de code**, le Context surchargé et les hooks appelés conditionnellement sont les deux remarques récurrentes.

---

## Ce qui te démarquera

**Mettre les filtres dans l'URL.** C'est le réflexe qui améliore le plus l'usage réel d'une application, et presque aucun junior ne l'a. Une liste filtrée dont on peut envoyer le lien à un collègue, c'est une fonctionnalité gratuite.

**Savoir dire non au Context.** « Ici une remontée d'état suffit » ou « ça, c'est de l'état serveur » montre que tu connais les limites de l'outil.

**Écrire le hook maison qui encapsule le Context**, avec son `throw`. Signe d'un code propre, et diagnostic immédiat des erreurs d'arborescence.

**Extraire des hooks nommés.** Un dossier `hooks/` avec `useDebounce`, `useLocalStorage`, `useMediaQuery` rend un projet lisible — et chacun est réutilisable dans le suivant.

**Connaître la raison des règles des hooks** (l'ordre d'appel), et pas seulement la règle. C'est la différence entre obéir et comprendre.

**Prévoir la route 404 et le rechargement d'URL profonde.** Deux détails que les débutants découvrent en production.

---

## 📚 À lire

**reactrouter.com → *Tutorial*** puis la section *Routing* : le tutoriel officiel est bien fait et couvre exactement ce dont tu as besoin.

**react.dev → *Passing Data Deeply with Context*** et ***Scaling Up with Reducer and Context*** : la première pour le mécanisme, la seconde pour voir jusqu'où aller — et la documentation y est honnête sur les limites.

**react.dev → *Reusing Logic with Custom Hooks*** — **la lecture clé de la leçon.** Elle explique très bien ce qu'un hook partage (la logique) et ce qu'il ne partage pas (l'état, qui est propre à chaque usage).

**react.dev → *Rules of Hooks*** pour la raison derrière les règles.

Et **usehooks.com** comme bibliothèque d'exemples : lis le code de quelques hooks pour voir des patterns bien écrits — mais écris les tiens d'abord.

---

## 🤖 Le mini-projet à demander à l'IA

Les trois sujets de cette leçon sont des décisions d'architecture : l'exercice doit porter sur le jugement.

> « Je suis en formation de développeur, palier 3 (React + TypeScript). Je travaille le routeur, le Context et les custom hooks. Donne-moi **12 données ou morceaux de logique** d'une application réaliste (le thème sombre, le filtre d'une liste, la page courante d'une pagination, l'utilisateur connecté, la largeur de la fenêtre, le contenu d'un champ de recherche, un panier, la langue, l'ouverture d'un panneau latéral, les dépenses chargées depuis l'API, un identifiant de fiche affichée, une préférence d'affichage compact). Pour chacune, je dois dire **où elle vit** : état local, état remonté, URL, Context, état serveur, ou custom hook — et **pourquoi**. Corrige-moi en expliquant le coût de mon mauvais choix (rendus inutiles, état non partageable, props drilling). **N'écris aucun code.** »

Puis l'exercice d'extraction, qui apprend à reconnaître le bon grain :

> « Donne-moi 4 composants React de 60 à 80 lignes, **sans me dire ce qui cloche**, dans lesquels une logique réutilisable est mélangée à l'affichage (lecture de `localStorage`, écoute du redimensionnement, gestion d'un formulaire, appel réseau avec ses états). Ma mission : identifier la logique à extraire, nommer le hook, et l'écrire. Ensuite, dis-moi si mon découpage est au bon grain — ni trop large, ni une extraction inutile. »

---

## 🛠️ À faire

1. **Routeur** : une application à trois routes — accueil, liste, fiche avec paramètre `:id` — plus une route 404. Vérifie les boutons « précédent » et « suivant » du navigateur.
2. **Mise en page imbriquée** : une route parente avec en-tête et navigation, et un `Outlet`. Vérifie que l'en-tête ne clignote pas au changement de page.
3. **Le piège du `<a>`** : remplace un `Link` par un `<a href>`, navigue, et constate le rechargement complet et la perte d'état.
4. **⭐ Le filtre dans l'URL** : déplace le filtre de catégorie de `useState` vers `useSearchParams`. Partage le lien filtré, puis utilise le bouton « retour ». Note le gain dans ton journal.
5. **Context thème** : fournisseur, hook maison `useTheme`, et un bouton de bascule accessible depuis un composant profond. Les couleurs viennent de variables CSS (palier 2, leçon 03).
6. **Le piège du Context** : mets le contenu d'un champ de recherche dans un Context, ajoute un `console.log` dans trois composants consommateurs, et compte les rendus à chaque frappe. Puis remets cet état en local.
7. **`useLocalStorage`** : écris le hook avec `try/catch` et `as const`. Utilise-le pour persister le thème, et vérifie que l'application survit à une valeur corrompue.
8. **`useDebounce`** : écris le hook et branche-le sur un champ de recherche. Compte les filtrages avec et sans.
9. **La règle des hooks** : appelle un `useState` après un retour anticipé, lis l'erreur du linter, et corrige en remontant le hook.
10. **Le hook de Context** : enlève le `throw` de ton `useTheme`, utilise un consommateur hors du `Provider`, et compare le message d'erreur avec et sans.
11. Reprends ton projet 2 et transforme-le en application à deux pages avec le filtre dans l'URL.

<details>
<summary>Corrections et points de contrôle</summary>

**4.** Le gain à noter : l'URL `?categorie=food` est partageable et favorisable, le bouton « retour » revient au filtre précédent, et un rechargement conserve le filtre. Avec `useState`, les trois sont perdus. **Règle à retenir : si l'utilisateur pourrait vouloir partager ou retrouver cet état, il va dans l'URL.**

**6.** À chaque frappe, **tous** les consommateurs du Context se réaffichent, même ceux qui n'affichent pas la recherche. Sur une application réelle, c'est un ralentissement visible. La conclusion : un Context convient à une valeur qui change **rarement**.

**7.** Les trois détails qui comptent : la forme **paresseuse** de `useState` (`useState(() => …)`) pour ne lire `localStorage` qu'une fois et non à chaque rendu ; le `try/catch` à la lecture **et** à l'écriture (navigation privée, quota) ; et le `as const` sur le retour, sans quoi le destructuring perd les types.

**9.** Le message est `React Hook "useState" is called conditionally. React Hooks must be called in the exact same order in every component render.` La raison est que React n'associe pas les hooks à des noms mais à leur **position d'appel** : si un rendu en appelle trois et le suivant deux, les états se décalent et tu obtiens des valeurs qui appartiennent à un autre hook.

**10.** Sans le `throw`, le composant reçoit `null`, et tu obtiens un `Cannot read properties of null (reading 'theme')` quelque part dans ton JSX — difficile à relier à la vraie cause. Avec le `throw`, le message dit exactement quoi faire : « doit être utilisé dans un FournisseurTheme ». **C'est de l'empathie pour le prochain développeur, et ça ne coûte qu'une ligne.**
</details>

---

## ✅ Acquis si…

- [ ] Je crée une application à plusieurs routes, avec paramètre d'URL et route 404.
- [ ] J'utilise `Link`, jamais `<a href>` pour la navigation interne.
- [ ] Je mets dans l'**URL** les états que l'utilisateur pourrait vouloir partager.
- [ ] J'utilise une mise en page imbriquée avec `Outlet`.
- [ ] Je crée un Context avec son **hook maison** qui vérifie le `null`.
- [ ] Je sais dire quand le Context **n'est pas** la bonne réponse.
- [ ] J'ai mesuré les rendus provoqués par un Context qui change souvent.
- [ ] J'écris des custom hooks nommés, avec `as const` sur les retours en tuple.
- [ ] Je connais les règles des hooks **et la raison** (l'ordre d'appel).
- [ ] Je sais qu'une application routée exige une configuration serveur pour les URL profondes.

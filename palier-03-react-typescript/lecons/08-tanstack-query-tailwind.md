# Leçon 08 — TanStack Query et Tailwind CSS

> 🎯 **À la fin de cette leçon** : tu gères l'état serveur avec l'outil prévu pour ça, et tu stylises à la vitesse d'une équipe professionnelle.
> ⏱️ 5 h · **Prérequis** : leçons 01–07. **Dernière leçon du palier.**
>
> Ces deux sujets n'ont rien en commun, sauf une chose : ce sont **les deux outils que tu trouveras dans la majorité des projets React en entreprise**, et les deux qui changent le plus ta productivité.

---

## De quoi on parle

**TanStack Query** (anciennement React Query) gère l'**état serveur** : les données qui ne t'appartiennent pas, qui vivent ailleurs, et dont tu n'as qu'une copie. Elle apporte le cache, les états de chargement et d'erreur, les nouvelles tentatives, la déduplication, le rechargement en arrière-plan et l'invalidation.

**Tailwind CSS** est un ensemble de **classes utilitaires** : au lieu d'écrire une feuille de style séparée, tu composes l'apparence directement dans le balisage.

```tsx
<div className="flex items-center gap-4 rounded-lg bg-white p-4 shadow">
```

Les deux relèvent de la même idée pédagogique : tu as écrit à la main ce qu'ils font (le chargement de données à la leçon 05, le CSS au palier 2), donc tu peux maintenant utiliser l'outil en sachant ce qu'il remplace.

---

## À quoi ça sert, concrètement

### TanStack Query

**Parce que l'état serveur n'est pas un état d'interface, et que tu l'as constaté.** À la fin de la leçon 05, tu as listé ce qui manquait à ton chargement manuel : le cache, la déduplication, les nouvelles tentatives, le rechargement, le partage entre composants. Ce sont environ deux cents lignes de code délicat, et elles sont déjà écrites, testées et optimisées.

**Parce que ça supprime une catégorie de bugs.** Deux composants qui demandent la même donnée déclenchent un seul appel. Revenir sur une page affiche instantanément les données en cache puis les rafraîchit. Une erreur réseau est réessayée automatiquement. Chacun de ces comportements est un bug que tu n'écriras pas.

**Et parce que c'est le standard du marché.** Si tu rejoins une équipe React, il y a de fortes chances que TanStack Query ou SWR y soit déjà.

### Tailwind

**Parce que ça règle le problème de nommage.** Au palier 2, tu as écrit du CSS et tu as peut-être ressenti les deux difficultés : trouver un nom de classe pour chaque élément, et ne jamais oser supprimer une règle de peur de casser une page inconnue. Tailwind supprime les deux : il n'y a plus de nom à inventer, et le style d'un composant disparaît avec lui.

**Parce que ça impose un système.** Les espacements, les tailles et les couleurs viennent d'une échelle prédéfinie. Résultat : une interface cohérente sans discipline particulière, là où du CSS libre produit des `margin: 13px` à côté de `margin: 16px`.

**Et parce que le style vit avec le composant.** Tu lis un composant et tu vois son apparence sans ouvrir un autre fichier. C'est un gain réel quand on reprend un code qu'on ne connaît pas.

Il faut dire aussi l'objection, parce qu'elle est légitime : **le balisage devient verbeux**. Une ligne de quinze classes se lit moins bien qu'une classe sémantique. C'est l'arbitrage de Tailwind, et il est largement accepté par le marché.

---

## Où ça intervient dans le développement

Ces deux outils complètent enfin la carte de l'état, posée aux leçons 04 et 07 :

```
   état local                → useState
   état partagé              → useState remonté
   état d'URL                → le routeur
   état global d'interface    → Context
   ÉTAT SERVEUR              → TanStack Query     ← cette leçon
```

Et voici le point d'architecture le plus important de la leçon : **l'état serveur n'est pas un état**. C'est un **cache**. La vérité est dans la base de données, à l'autre bout du réseau ; tu n'en as qu'une copie, qui peut être périmée à tout instant. Cette distinction change la façon de concevoir : tu ne « stockes » pas les données, tu interroges un cache qui se synchronise.

Deux conséquences pour la suite du parcours.

**Au palier 4, tu écriras l'API que cette bibliothèque consomme.** Et tu comprendras pourquoi les clés de cache correspondent souvent aux routes REST : `["depenses", id]` pour `GET /depenses/:id`. Les deux moitiés se répondent.

**Au palier 9, tu retrouveras exactement le même problème en mobile** — avec une contrainte supplémentaire : le mode hors ligne. Le cache ne sera plus une optimisation mais une fonctionnalité.

Pour Tailwind, la place est celle du CSS du palier 2 : la couche présentation. Ce qui change, c'est l'endroit où elle s'écrit. Et ton CSS n'était pas du temps perdu : **chaque classe Tailwind est une propriété CSS**. Sans les leçons 03 à 06 du palier 2, tu composerais des classes sans savoir ce qu'elles font.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas supprimer la moitié du code de ton hook de chargement, et ça fait un drôle d'effet. Garde ta version manuelle quelque part : c'est ta justification de l'outil.

Avec Tailwind, tu vas d'abord trouver le balisage illisible, puis arrêter d'y penser. Le passage prend environ une journée.

### En équipe, en entreprise

**TanStack Query ou SWR est presque toujours là.** Avec des conventions de clés de cache, un `queryClient` configuré au démarrage, et parfois une couche de hooks maison (`useDepenses`, `useDepense(id)`) — ce qui est une bonne pratique à reprendre.

**Tailwind est très répandu**, souvent avec un système de design au-dessus : des composants prêts (shadcn/ui, Headless UI) et une configuration de couleurs propre à l'entreprise.

**Tu entendras les deux positions sur Tailwind.** Certains le trouvent indispensable, d'autres regrettent le CSS sémantique. Les deux arguments sont défendables, et savoir les exposer calmement est plus utile que de choisir un camp.

**Et tu verras des `useEffect` + `fetch` dans du code ancien.** C'est de la dette, et savoir pourquoi te permettra de proposer la migration plutôt que de la subir.

### Ce qui sert tous les jours, et ce qui est rare

Pour Query, au quotidien : `useQuery` avec sa clé, `isPending`/`isError`/`data`, `useMutation`, et l'invalidation après une écriture.

Régulièrement : les clés avec paramètres, `enabled` pour une requête conditionnelle, `staleTime`, les hooks maison par entité.

Rare, et hors sujet pour l'instant : les mises à jour optimistes, la pagination et le défilement infini, le préchargement, `select` pour transformer, la persistance du cache, le rendu côté serveur. Tu les découvriras par besoin.

Pour Tailwind, au quotidien : les espacements (`p-4`, `gap-2`), la mise en page (`flex`, `grid`), les couleurs, la typographie, les bordures et ombres, les états (`hover:`, `focus-visible:`), et les points de rupture (`md:`, `lg:`).

Régulièrement : `@apply` pour un motif très répété (avec parcimonie), `dark:`, les variables de thème, `clsx` pour les classes conditionnelles.

Rare : les variantes personnalisées, les plugins, les valeurs arbitraires (`w-[327px]` — un signe qu'on sort du système), `@layer`. Et un piège très courant : **la concaténation de classes** (`` className={`text-${couleur}-500`} ``) ne fonctionne pas, parce que Tailwind analyse ton code statiquement et ne voit pas la classe construite.

---

## La mécanique — TanStack Query

```bash
npm install @tanstack/react-query
```

```tsx
// main.tsx
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

const queryClient = new QueryClient({
  defaultOptions: { queries: { staleTime: 60_000, retry: 2 } },
});

<QueryClientProvider client={queryClient}>
  <App />
</QueryClientProvider>
```

### Lire des données

```tsx
import { useQuery } from "@tanstack/react-query";

function ListeDepenses({ categorie }: { categorie: string }) {
  const { data, isPending, isError, error, refetch } = useQuery({
    queryKey: ["depenses", categorie],        // ⭐ la clé identifie la donnée en cache
    queryFn: () => recupererDepenses(categorie),
  });

  if (isPending) return <Chargement />;
  if (isError)   return <Erreur message={error.message} onReessayer={refetch} />;
  if (data.length === 0) return <p>Aucune dépense.</p>;

  return <ul>{data.map(d => <li key={d.id}>…</li>)}</ul>;
}
```

Compare avec ton hook de la leçon 05 : les quatre états sont fournis, et tu n'as écrit ni `useState`, ni `useEffect`, ni `AbortController`, ni gestion d'annulation. La `queryFn` est **ta** fonction d'appel API — celle de ton `api.ts`, inchangée depuis le palier 2.

**La `queryKey` est le concept central.** C'est l'identité de la donnée dans le cache. Deux composants qui utilisent la même clé partagent la même donnée et ne déclenchent **qu'un seul appel**. Changer la clé (ici, changer de catégorie) déclenche une nouvelle requête, et l'ancienne reste en cache — revenir dessus est instantané.

La convention habituelle suit la hiérarchie des ressources, comme tes futures routes REST :

```tsx
["depenses"]                          // la liste
["depenses", { categorie: "food" }]   // la liste filtrée
["depenses", id]                      // une fiche
```

### Écrire des données

```tsx
import { useMutation, useQueryClient } from "@tanstack/react-query";

function FormulaireDepense() {
  const client = useQueryClient();

  const ajouter = useMutation({
    mutationFn: creerDepense,
    onSuccess: () => {
      client.invalidateQueries({ queryKey: ["depenses"] });   // ⭐ le cache est périmé
    },
  });

  return (
    <form onSubmit={e => { e.preventDefault(); ajouter.mutate(valeurs); }}>
      …
      <button type="submit" disabled={ajouter.isPending}>
        {ajouter.isPending ? "Ajout…" : "Ajouter"}
      </button>
      {ajouter.isError && <p role="alert">{ajouter.error.message}</p>}
    </form>
  );
}
```

L'**invalidation** est le mécanisme à comprendre : après une écriture, tu déclares que les données liées sont périmées, et la bibliothèque les recharge. Tu n'as pas à mettre à jour l'affichage toi-même — tu ne touches pas à l'état, tu annonces qu'il a changé côté serveur.

Note aussi `isPending` sur la mutation : le bouton désactivé pendant l'envoi (palier 2, leçon 08) est fourni.

### Ce que tu as cessé d'écrire

| Comportement | Ta version manuelle | Avec Query |
|---|---|---|
| États chargement/erreur | à la main | fourni |
| Annulation (condition de course) | `AbortController` | automatique |
| Cache | absent | par clé |
| Déduplication de deux appels identiques | absente | automatique |
| Nouvelle tentative sur échec | à écrire | configurable |
| Rechargement au retour sur l'onglet | absent | par défaut |
| Partage entre composants éloignés | Context | la clé suffit |

*(Table de référence : c'est la justification de l'outil, et c'est la réponse à donner en entretien.)*

---

## La mécanique — Tailwind

```bash
npm install tailwindcss @tailwindcss/vite
```

```css
/* index.css */
@import "tailwindcss";
```

### Les classes, par famille

```tsx
{/* Espacement : l'échelle est en multiples de 0,25 rem — p-4 = 1rem */}
<div className="p-4 px-6 mt-2 gap-4">

{/* Mise en page — tu reconnais le palier 2 */}
<div className="flex items-center justify-between">
<div className="grid grid-cols-1 md:grid-cols-3 gap-4">

{/* Typographie */}
<h1 className="text-2xl font-bold tracking-tight">
<p className="text-sm text-gray-600 max-w-prose">

{/* Couleurs, bordures, ombres */}
<div className="bg-white border border-gray-200 rounded-lg shadow-sm">

{/* États */}
<button className="bg-emerald-600 hover:bg-emerald-700 focus-visible:outline-2
                   disabled:opacity-50 transition-colors">

{/* Responsive : MOBILE-FIRST, comme au palier 2 */}
<div className="flex flex-col md:flex-row">

{/* Mode sombre */}
<div className="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
```

Observe que **`md:` est un `min-width`** : Tailwind impose le mobile-first par sa syntaxe. Sans classe de préfixe, c'est le mobile ; avec `md:`, c'est à partir du point de rupture. C'est exactement la méthode de la leçon 05 du palier 2, rendue obligatoire.

### Les classes conditionnelles

```tsx
import clsx from "clsx";        // npm install clsx

<button className={clsx(
  "rounded px-4 py-2 font-medium",
  variante === "primaire" && "bg-emerald-600 text-white",
  variante === "secondaire" && "bg-gray-100 text-gray-900",
  desactive && "opacity-50 cursor-not-allowed",
)}>
```

> ⚠️ **Ne construis jamais un nom de classe par concaténation.** `` className={`bg-${couleur}-500`} `` ne fonctionne pas : Tailwind analyse ton code source pour savoir quelles classes générer, et il ne voit pas une chaîne construite à l'exécution. Il faut écrire les classes complètes dans une table de correspondance.

### Quand factoriser

```tsx
// ✅ La bonne façon : un COMPOSANT, pas une classe CSS
function Bouton({ variante = "primaire", children, ...reste }: ProprietesBouton) {
  return (
    <button className={clsx("rounded px-4 py-2 font-medium transition-colors", …)} {...reste}>
      {children}
    </button>
  );
}
```

C'est le réflexe à prendre : en React, l'unité de réutilisation est le **composant**, pas la classe. `@apply` existe, mais l'utiliser systématiquement revient à réécrire du CSS sémantique — et à perdre l'intérêt de Tailwind.

---

## Les problèmes que tu vas rencontrer

**Mes données ne se rafraîchissent pas après un ajout.** Il manque l'invalidation dans `onSuccess`.

**Deux composants déclenchent deux appels identiques.** Leurs clés diffèrent — souvent un objet recréé à chaque rendu dans la clé. Les clés sont comparées par valeur, mais garde-les simples et sérialisables.

**Ma requête part alors que je n'ai pas encore l'identifiant.** Utilise `enabled: !!id` pour la conditionner.

**`data` est `undefined` et TypeScript se plaint.** Tu accèdes à `data` avant d'avoir traité `isPending`. Les retours anticipés règlent le problème **et** resserrent le type — c'est l'union discriminée de la leçon 02 à l'œuvre.

**Mes données semblent périmées.** Regarde `staleTime` : par défaut, Query considère les données comme périmées immédiatement et les recharge à certains moments. C'est un réglage à comprendre, pas un bug.

**Mes classes Tailwind n'ont aucun effet.** Trois causes : une classe construite par concaténation, une faute de frappe (il n'y a aucune validation), ou un fichier non analysé par Tailwind.

**Deux classes contradictoires et c'est l'ordre du fichier CSS qui gagne.** `className="p-2 p-4"` ne donne pas forcément `p-4`. Utilise `tailwind-merge` quand tu composes des classes venant de plusieurs sources.

**Mon balisage est illisible avec vingt-cinq classes.** C'est le signe qu'il faut extraire un composant.

**Mon mode sombre ne s'active pas.** Tailwind suit par défaut la préférence système ; pour une bascule manuelle, il faut configurer la stratégie par classe.

---

## Ce qu'on te demandera

En **entretien React moderne**, deux questions sont devenues très fréquentes : **« comment gères-tu les données venues d'une API ? »** — et la réponse `useEffect` + `useState` est aujourd'hui considérée comme datée — et **« quelle différence entre état client et état serveur ? »**, qui est la question conceptuelle de cette leçon.

Suivent : « à quoi sert la `queryKey` ? », « comment mets-tu à jour l'affichage après une écriture ? », « qu'est-ce que l'invalidation ? ».

Sur Tailwind : « pourquoi des classes utilitaires ? », « quels sont ses inconvénients ? » (une question piège appréciée : savoir critiquer son outil), « comment factorises-tu un style répété en React ? ».

En **test technique**, un projet fourni utilisera très probablement l'un des deux.

---

## Ce qui te démarquera

**Savoir énumérer ce que Query t'économise.** Cache, déduplication, annulation, nouvelles tentatives, rechargement. Et pouvoir dire « je l'ai écrit à la main avant, voilà ce qui manquait » est l'argument le plus convaincant qu'un junior puisse donner sur un choix d'outil.

**Distinguer état client et état serveur.** Dire « ça, ce n'est pas un état, c'est un cache » montre une compréhension d'architecture que beaucoup de développeurs confirmés n'ont pas formulée.

**Encapsuler Query dans des hooks maison** (`useDepenses`, `useAjouterDepense`). Les composants n'importent alors plus la bibliothèque, et elle devient remplaçable.

**Savoir critiquer Tailwind.** Reconnaître la verbosité du balisage et expliquer l'arbitrage te distingue de ceux qui défendent un outil par habitude.

**Extraire des composants plutôt que d'abuser de `@apply`.** Le réflexe juste en React.

**Garder les quatre états et l'accessibilité.** L'outil fournit les états ; il ne les affiche pas pour toi. Un bouton « Réessayer », un `role="alert"` sur les erreurs, un `aria-busy` pendant le chargement restent ton travail.

---

## 📚 À lire

**tanstack.com/query → *Overview* et *Quick Start*** : l'introduction explique précisément la distinction état client / état serveur. Lis-la même si tu as compris le code — c'est la partie conceptuelle.

**tanstack.com/query → *Important Defaults*** : courte, et elle évite les trois quarts des surprises (`staleTime`, rechargement au focus, nouvelles tentatives).

**tailwindcss.com → *Utility-First Fundamentals*** et ***Responsive Design***. La documentation de Tailwind est l'une des meilleures de l'écosystème, et sa recherche est excellente — tu l'utiliseras comme référence quotidienne.

**tailwindcss.com → *Reusing Styles*** pour l'arbitrage entre composant et `@apply`.

Et pour la culture : l'article *Practical React Query* (TkDodo) est la meilleure ressource sur les pièges réels de la bibliothèque — à garder pour quand tu auras pratiqué.

---

## 🤖 Le mini-projet à demander à l'IA

C'est la leçon où l'on compare l'avant et l'après : c'est là qu'est l'apprentissage.

> « Je suis en formation de développeur, palier 3 (React + TypeScript). Je viens d'écrire à la main un hook de chargement de données avec `useState` + `useEffect` + `AbortController`, et je passe à TanStack Query. Ne me donne pas de code. Pose-moi **10 questions** qui me font découvrir, une par une, ce que la bibliothèque gère et que mon hook ne gérait pas (deux composants qui demandent la même donnée, un retour sur une page déjà visitée, une erreur réseau passagère, un onglet laissé ouvert trente minutes, une écriture suivie d'un affichage, deux requêtes qui se croisent…). Pour chaque question, demande-moi **ce qui se passe avec mon hook manuel**, puis explique ce que fait Query. »

Puis le projet complet, qui est la préparation directe de ton projet 3 :

> « Donne-moi le **cahier des charges** d'une application React + TypeScript consommant une API publique gratuite, **sans aucun code** : deux pages (liste et fiche), un filtre dans l'URL, une recherche avec `debounce`, un thème sombre persistant, et un formulaire d'ajout en local. Impose-moi : TanStack Query pour toutes les données serveur, les quatre états visuels sur chaque écran, des hooks maison par entité, aucun `useEffect` pour charger des données, et Tailwind avec des composants extraits dès qu'un style se répète. Quand je t'enverrai mon code, critique uniquement : la frontière état client / état serveur, les clés de cache, l'invalidation après écriture, l'accessibilité des états, et les composants Tailwind que j'aurais dû extraire. »

---

## 🛠️ À faire

1. **Migre ton hook** de la leçon 05 vers `useQuery`. Compte les lignes supprimées, et note-les dans ton journal.
2. **La déduplication** : affiche le même composant deux fois dans la page, avec la même clé. Ouvre l'onglet Réseau et compte les requêtes. Puis change une clé et recompte.
3. **Le cache** : navigue vers une fiche, reviens à la liste, retourne à la fiche. Observe que le second affichage est instantané.
4. **Les quatre états** : vérifie que tu les traites tous avec `isPending`, `isError`, le cas vide, et les données. Ajoute un bouton « Réessayer » avec `refetch`.
5. **Une mutation** : un formulaire d'ajout avec `useMutation`, l'invalidation dans `onSuccess`, et le bouton désactivé via `isPending`.
6. **Démontre l'oubli d'invalidation** : retire l'`invalidateQueries`, ajoute un élément, et constate que la liste ne bouge pas. Puis remets-la.
7. **Clé conditionnelle** : une requête qui ne part que si un identifiant est présent (`enabled`).
8. **Hooks maison** : encapsule tes requêtes dans `useDepenses()` et `useAjouterDepense()`. Vérifie qu'aucun composant n'importe plus TanStack Query directement.
9. **Tailwind** : installe-le et refais l'une de tes trois intégrations imposées du palier 2 en Tailwind. Compare le temps passé.
10. **Le piège de la concaténation** : écris `` className={`bg-${couleur}-500`} ``, constate que rien ne s'applique, et corrige avec une table de correspondance.
11. **Extrais un composant `Bouton`** avec trois variantes, en utilisant `clsx`. Utilise-le dix fois.
12. **Mode sombre** en Tailwind avec `dark:`, et une bascule manuelle branchée sur ton Context de la leçon 07.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Tu devrais supprimer entre quarante et soixante lignes : les trois `useState`, le `useEffect`, le `AbortController`, la gestion de l'annulation, et le traitement manuel des états. Garde l'ancienne version dans un fichier à part : c'est ta réponse à « pourquoi TanStack Query ? » en entretien.

**2.** Avec la **même** clé, **une seule** requête part : Query déduplique. Avec des clés différentes, deux requêtes partent. C'est la démonstration la plus parlante de ce qu'est une clé de cache — et d'un bug que ton hook manuel avait (deux composants = deux appels).

**3.** Le second affichage est instantané parce que la donnée est en cache ; selon ton `staleTime`, un rechargement discret se fait en arrière-plan. C'est le comportement qu'on appelle « périmé pendant revalidation » : l'utilisateur voit quelque chose tout de suite, et la donnée se met à jour sans écran de chargement.

**6.** Sans invalidation, l'ajout réussit côté serveur mais le cache de la liste n'est pas averti : l'interface affiche des données périmées. **C'est le bug caractéristique de l'état serveur**, et c'est pour ça que l'invalidation est le geste à ne jamais oublier après une écriture.

**8.** Le contrôle : cherche `@tanstack/react-query` dans tes composants. Il ne devrait apparaître que dans tes hooks et dans `main.tsx`. L'intérêt n'est pas théorique : le jour où tu changes de bibliothèque, tu modifies cinq fichiers au lieu de cinquante.

**10.** Tailwind analyse tes fichiers source pour savoir quelles classes générer dans le CSS final. Une classe construite à l'exécution n'existe nulle part dans le source, donc elle n'est pas générée. La solution est une table :
```tsx
const fonds = { emeraude: "bg-emerald-500", rouge: "bg-red-500" } as const;
<div className={fonds[couleur]} />
```
Et tu reconnais le `Record` sur une union de la leçon 02 : il **force** à couvrir toutes les couleurs possibles.
</details>

---

## ✅ Acquis si…

- [ ] J'explique la différence entre **état client** et **état serveur**.
- [ ] Je sais énumérer ce que TanStack Query gère et que mon hook manuel ne gérait pas.
- [ ] J'utilise `useQuery` avec une `queryKey` structurée, et j'ai constaté la déduplication.
- [ ] J'utilise `useMutation` avec une invalidation dans `onSuccess`.
- [ ] J'ai provoqué le bug de l'invalidation oubliée.
- [ ] Mes requêtes sont encapsulées dans des hooks maison.
- [ ] Je traite toujours les quatre états, avec un bouton « Réessayer ».
- [ ] Je style en Tailwind, en mobile-first, et j'extrais un composant quand un style se répète.
- [ ] Je connais le piège de la concaténation de classes.
- [ ] Je sais exposer calmement les **inconvénients** de Tailwind.
- [ ] 🚦 **Je suis prêt pour le [projet 3](../projet.md) et l'[épreuve de sortie](../evaluation.md).**

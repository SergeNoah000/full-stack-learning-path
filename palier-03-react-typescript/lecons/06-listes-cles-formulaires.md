# Leçon 06 — Listes, clés, rendu conditionnel, formulaires contrôlés

> 🎯 **À la fin de cette leçon** : tu affiches des collections sans bug de `key`, et tu construis des formulaires React qui gèrent saisie, validation et envoi.
> ⏱️ 4 h · **Prérequis** : leçons 03–05.

---

## De quoi on parle

Une **liste** se rend avec `map`, et chaque élément doit porter une **`key`** : un identifiant stable qui permet à React de savoir, d'un rendu à l'autre, quel élément du DOM correspond à quelle donnée.

Un **formulaire contrôlé** est un formulaire dont React détient les valeurs : chaque champ affiche une valeur venant de l'état, et chaque frappe met cet état à jour. L'état est la source de vérité, pas le DOM.

```tsx
const [montant, setMontant] = useState("");
<input value={montant} onChange={e => setMontant(e.target.value)} />
```

S'y ajoutent le **rendu conditionnel** (vu à la leçon 03, approfondi ici pour les cas réels) et la distinction entre un formulaire **contrôlé** et **non contrôlé** — ce dernier laissant le DOM garder les valeurs, comme au palier 2.

---

## À quoi ça sert, concrètement

**Parce qu'une application est faite de listes et de formulaires.** C'est le constat du palier 2, et il reste vrai : une application de gestion, c'est des collections à afficher et des données à saisir. Ces deux sujets représentent probablement la moitié du code frontend que tu écriras dans ta carrière.

**Parce que la `key` est à l'origine d'une catégorie de bugs très déroutants.** Une case cochée qui « saute » sur une autre ligne après une suppression, un champ de saisie qui garde la valeur de l'élément précédent, une animation qui se rejoue sans raison : ce sont tous des problèmes de `key`. Ils ne produisent aucune erreur, seulement un comportement incohérent — donc impossible à diagnostiquer sans comprendre le mécanisme.

**Parce que les formulaires contrôlés débloquent tout ce qu'un formulaire HTML ne sait pas faire** : valider pendant la saisie, désactiver le bouton selon l'état, dépendre d'un champ sur un autre, afficher un compteur de caractères, pré-remplir depuis des données chargées.

---

## Où ça intervient dans le développement

Les listes et les formulaires sont les deux endroits où **l'état rencontre l'affichage** :

```
   LISTE                              FORMULAIRE
   ─────                              ──────────
   données (tableau)                  état (une valeur par champ)
      │ map + key                        │ value + onChange
      ▼                                  ▼
   éléments affichés                  champs affichés
      │ onSupprimer / onModifier         │ onSubmit
      └──────► état mis à jour ◄─────────┘
```

Deux points structurants pour la suite du parcours.

**Les formulaires contrôlés sont une frontière**, exactement comme au palier 2 : tout ce qui sort d'un champ est une **chaîne**, même en `type="number"`. La conversion et la validation se font ici, et la validation qui protège se fera au palier 4, côté serveur. C'est la troisième fois que tu rencontres cette frontière — elle ne change jamais.

**Et les formulaires deviennent vite complexes.** Avec cinq champs, de la validation, des erreurs par champ, un état d'envoi et un pré-remplissage, tu te retrouves avec dix `useState`. C'est le moment où les équipes passent à une bibliothèque (React Hook Form), que ton palier mentionne. Écris d'abord à la main : tu sauras alors ce que l'outil résout.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas voir l'avertissement `Each child in a list should have a unique "key" prop` et tu vas probablement mettre l'index pour le faire taire. Puis tu vas rencontrer le bug qui en découle, et comprendre. Les exercices sont construits pour que tu le provoques volontairement — c'est beaucoup plus efficace que de le lire.

Tu vas aussi trouver les formulaires contrôlés verbeux. Ils le sont. C'est le prix du contrôle, et il existe des façons de le réduire.

### En équipe, en entreprise

**La `key` avec l'index est une remarque de revue de code classique.** Elle est acceptable dans un seul cas — une liste jamais réordonnée, jamais filtrée, sans élément supprimé au milieu — et comme personne ne peut garantir ça dans le temps, on utilise un identifiant.

**Les formulaires passent par une bibliothèque.** React Hook Form est le standard actuel, souvent associé à Zod pour la validation — et ce couple sera exactement celui que tu utiliseras côté serveur au palier 4. Les connaître n'est pas obligatoire au palier 3, mais tu les croiseras dès ta première mission.

**L'accessibilité des formulaires reste la même qu'au palier 2.** `label` relié, `aria-describedby` sur les erreurs, focus visible, navigation au clavier. React ne change rien à ces exigences — il faut juste penser à `htmlFor` au lieu de `for`.

**Et tu verras des formulaires non contrôlés** dans du code moderne : React Hook Form les utilise volontairement, parce qu'ils provoquent moins de rendus. Savoir que les deux approches existent, et pourquoi, est utile.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `map` avec une `key` stable, les retours anticipés pour les états de chargement et d'erreur, `value` + `onChange`, `onSubmit` avec `preventDefault`, et un bouton désactivé pendant l'envoi.

Régulièrement : les listes imbriquées, le filtre et le tri de listes (dérivés, pas des états), les cases à cocher et les boutons radio contrôlés, les champs dépendants, les messages d'erreur par champ.

Rare, et hors sujet pour l'instant : `useRef` pour un formulaire non contrôlé, `FormData` avec les actions React, les champs de fichiers (qui ne peuvent pas être pleinement contrôlés), les listes virtualisées (utile au-delà de quelques milliers de lignes), le glisser-déposer, `useOptimistic`. Et une chose qu'on ne fait plus : `defaultValue` mélangé à `value` sur le même champ.

---

## La mécanique

### Rendre une liste

```tsx
<ul>
  {depenses.map(d => (
    <li key={d.id}>
      <LigneDepense depense={d} onSupprimer={supprimer} />
    </li>
  ))}
</ul>
```

### ⭐ La `key` : pourquoi l'index est un piège

React utilise la `key` pour **apparier** les éléments entre deux rendus. Avec l'index, l'appariement se fait par position — et la position change.

Prends une liste de trois tâches avec une case à cocher, et coche celle du milieu. Tu supprimes ensuite la **première**. Avec `key={index}` :

```
   AVANT                          APRÈS suppression de la première
   index 0 : "Courses"            index 0 : "Appeler"  ← React croit que c'est le MÊME
   index 1 : "Appeler"  ☑         index 1 : "Payer"       élément qu'avant
   index 2 : "Payer"
```

React voit l'index 0 dans les deux rendus et conclut qu'il s'agit du même composant : il **conserve son état local** et change seulement le texte. Résultat : la case cochée se retrouve sur la mauvaise ligne. Aucune erreur, aucun message — juste un comportement absurde.

```tsx
{depenses.map((d, i) => <Ligne key={i} … />)}        // ❌
{depenses.map(d => <Ligne key={d.id} … />)}           // ✅ identifiant stable
```

L'index reste acceptable pour une liste **statique**, jamais réordonnée ni filtrée, et dont les éléments n'ont pas d'état propre. En pratique, cette garantie ne tient jamais dans le temps : utilise un identifiant.

Si tes données n'ont pas d'identifiant, crée-en un à la création (`crypto.randomUUID()`) plutôt que de te rabattre sur l'index.

### La `key` comme outil

Le même mécanisme, utilisé volontairement, réinitialise un composant :

```tsx
<FormulaireEdition key={depenseSelectionnee.id} depense={depenseSelectionnee} />
```

Quand la `key` change, React démonte l'ancien composant et en monte un neuf : son état local repart de zéro. C'est l'astuce vue à la leçon 05, et elle remplace un `useEffect` de réinitialisation.

### Filtre et tri : des valeurs dérivées

```tsx
function PageDepenses({ depenses }: { depenses: Depense[] }) {
  const [filtre, setFiltre] = useState<Statut | "tout">("tout");
  const [tri, setTri] = useState<"date" | "montant">("date");

  // ⭐ dérivés, pas des états (leçon 04)
  const visibles = depenses
    .filter(d => filtre === "tout" || d.statut === filtre)
    .sort((a, b) => tri === "montant" ? b.montant - a.montant : b.date.localeCompare(a.date));

  if (visibles.length === 0 && depenses.length > 0) {
    return <p>Aucune dépense ne correspond à ce filtre.</p>;      // deux messages distincts
  }
  if (depenses.length === 0) {
    return <p>Aucune dépense pour le moment.</p>;
  }
  return <Liste depenses={visibles} />;
}
```

⚠️ Note le `.filter(...).sort(...)` : `filter` retourne déjà un **nouveau** tableau, donc le `sort` qui suit ne mute pas la prop. Si tu triais directement `depenses.sort(...)`, tu muterais une prop (leçon 03). C'est un piège fréquent et silencieux.

Et observe les **deux messages vides distincts** : « aucune donnée » et « aucun résultat » ne disent pas la même chose à l'utilisateur. C'est le même soin qu'au palier 2.

### Un formulaire contrôlé

```tsx
type NouvelleDepense = { description: string; montant: string; categorie: string };

export function FormulaireDepense({ onAjouter }: { onAjouter: (d: Depense) => void }) {
  const [valeurs, setValeurs] = useState<NouvelleDepense>({
    description: "", montant: "", categorie: "food",
  });
  const [erreurs, setErreurs] = useState<Partial<Record<keyof NouvelleDepense, string>>>({});
  const [envoiEnCours, setEnvoiEnCours] = useState(false);

  function changer(champ: keyof NouvelleDepense, valeur: string) {
    setValeurs(prev => ({ ...prev, [champ]: valeur }));       // ⭐ un seul gestionnaire
    setErreurs(prev => ({ ...prev, [champ]: undefined }));     // on efface l'erreur à la frappe
  }

  function valider(v: NouvelleDepense) {
    const e: typeof erreurs = {};
    if (!v.description.trim()) e.description = "La description est obligatoire.";
    if (v.montant.trim() === "") e.montant = "Le montant est obligatoire.";
    else if (Number.isNaN(Number(v.montant))) e.montant = "Le montant doit être un nombre.";
    else if (Number(v.montant) <= 0) e.montant = "Le montant doit être positif.";
    return e;
  }

  async function soumettre(e: React.FormEvent) {
    e.preventDefault();
    const trouvees = valider(valeurs);
    if (Object.keys(trouvees).length > 0) { setErreurs(trouvees); return; }

    setEnvoiEnCours(true);
    try {
      onAjouter({ ...valeurs, montant: Number(valeurs.montant), id: crypto.randomUUID() });
      setValeurs({ description: "", montant: "", categorie: "food" });   // on réinitialise
    } finally {
      setEnvoiEnCours(false);                                   // dans TOUS les cas
    }
  }

  return (
    <form onSubmit={soumettre} noValidate>
      <div>
        <label htmlFor="description">Description</label>
        <input id="description" value={valeurs.description}
               onChange={e => changer("description", e.target.value)}
               aria-invalid={!!erreurs.description}
               aria-describedby={erreurs.description ? "err-description" : undefined} />
        {erreurs.description && <p id="err-description" role="alert">{erreurs.description}</p>}
      </div>

      <div>
        <label htmlFor="montant">Montant</label>
        <input id="montant" type="text" inputMode="numeric" value={valeurs.montant}
               onChange={e => changer("montant", e.target.value)}
               aria-invalid={!!erreurs.montant}
               aria-describedby={erreurs.montant ? "err-montant" : undefined} />
        {erreurs.montant && <p id="err-montant" role="alert">{erreurs.montant}</p>}
      </div>

      <button type="submit" disabled={envoiEnCours}>
        {envoiEnCours ? "Ajout…" : "Ajouter"}
      </button>
    </form>
  );
}
```

Six détails de ce code méritent l'attention, parce que chacun règle un problème réel.

**Un seul objet d'état** pour tous les champs, et **un seul gestionnaire** `changer(champ, valeur)` : sans ça, cinq champs donnent cinq `useState` et cinq fonctions.

**L'ordre des validations** : le vide d'abord, puis le format, puis la valeur. C'est la correction de l'exercice 6 du palier 2, leçon 08 — et `Number("")` vaut `0`, donc tester la valeur avant le vide produirait un message faux.

**L'erreur s'effacée à la frappe**, pas seulement à la soumission suivante.

**`aria-describedby` et `role="alert"`** : l'accessibilité du palier 2, transposée en JSX (`htmlFor` au lieu de `for`).

**Le bouton désactivé** pendant l'envoi, avec un `finally` — la double soumission du palier 2, leçon 08.

**`noValidate`** : on désactive la validation native du navigateur puisqu'on affiche nos propres messages. Sinon les deux se superposent, avec des styles et des langues différentes.

### Les autres types de champs

```tsx
{/* Case à cocher : checked, pas value */}
<input type="checkbox" checked={accepte} onChange={e => setAccepte(e.target.checked)} />

{/* Menu déroulant */}
<select value={categorie} onChange={e => setCategorie(e.target.value)}>
  <option value="food">Alimentation</option>
</select>

{/* Boutons radio : même name, comparaison sur la valeur */}
<input type="radio" name="freq" value="jour"
       checked={frequence === "jour"} onChange={e => setFrequence(e.target.value)} />

{/* Zone de texte : value, pas de contenu entre les balises */}
<textarea value={note} onChange={e => setNote(e.target.value)} />
```

### Contrôlé ou non contrôlé

| | Contrôlé | Non contrôlé |
|---|---|---|
| La valeur vit | dans l'état React | dans le DOM |
| Validation en direct | facile | pénible |
| Nombre de rendus | un par frappe | aucun |
| Lecture des valeurs | immédiate | à la soumission |
| Quand l'utiliser | la plupart du temps | formulaires longs, performance |

*(Table de référence.)* Au palier 3, tu écris contrôlé. Sache simplement que React Hook Form, que tu croiseras, choisit délibérément le non contrôlé pour éviter un rendu par frappe.

---

## Les problèmes que tu vas rencontrer

**L'avertissement `unique "key" prop`.** Ajoute une `key`, et pas l'index.

**Une case cochée saute sur une autre ligne après suppression.** `key={index}`. C'est le bug emblématique de la leçon.

**Mon champ est en lecture seule, je ne peux rien taper.** Tu as mis `value={quelqueChose}` sans `onChange`. React fige alors le champ sur la valeur de l'état. Il faut les deux.

**`A component is changing an uncontrolled input to be controlled`.** Ta valeur initiale est `undefined` au premier rendu (souvent des données pas encore chargées). Initialise toujours avec `""`.

**Mon formulaire se vide quand les données arrivent.** Tu réinitialises l'état dans un effet, ou ta `key` change. Utilise la `key` **volontairement** pour ça, ou initialise une seule fois.

**Mon total est faux après un tri.** Tu as trié la prop directement : `depenses.sort()` mute. Passe par `[...depenses].sort()` ou place le `sort` après un `filter`.

**Le curseur saute à la fin du champ pendant que je tape.** Tu reformates la valeur à chaque frappe (par exemple en insérant des espaces dans un montant). Reformate à la perte de focus, pas à chaque caractère.

**Mon champ `type="number"` me complique la vie.** Il renvoie `""` pour une saisie invalide, accepte `e` et `+`, et réagit à la molette. Pour un montant, `type="text"` avec `inputMode="numeric"` est souvent plus simple à contrôler.

**Deux messages d'erreur s'affichent, l'un en anglais.** La validation native du navigateur n'est pas désactivée. `noValidate` sur le `<form>`.

---

## Ce qu'on te demandera

En **test technique React**, l'exercice est presque toujours une liste avec un formulaire : ajouter, supprimer, filtrer, et valider la saisie. On regarde la `key`, les mises à jour immuables, l'état vide, la validation et l'accessibilité des champs.

En **entretien** : **« à quoi sert la `key` et pourquoi pas l'index ? »** est l'une des trois questions React les plus posées, toutes entreprises confondues. Suivent : « qu'est-ce qu'un formulaire contrôlé ? », « différence entre contrôlé et non contrôlé ? », « comment valides-tu un formulaire ? », « comment empêches-tu une double soumission ? ».

En **revue de code**, la `key` et le tri d'une prop sont les deux remarques récurrentes.

---

## Ce qui te démarquera

**Savoir expliquer le bug de la `key` avec un exemple concret**, et pas seulement réciter « il faut un identifiant stable ». Pouvoir décrire la case qui saute de ligne montre que tu l'as vécu.

**Un seul objet d'état et un seul gestionnaire** pour un formulaire. Beaucoup de juniors écrivent huit `useState` et huit fonctions.

**L'ordre correct des validations**, et le piège de `Number("")`.

**L'accessibilité maintenue en React.** `htmlFor`, `aria-describedby`, `role="alert"`, `noValidate`. C'est rare, et c'est immédiatement visible.

**Le bouton désactivé avec `finally`.** Le détail qui évite les doublons en base, et que presque personne ne gère au palier junior.

**Utiliser la `key` comme outil de réinitialisation.** Le signe que tu as compris le mécanisme au lieu de l'avoir subi.

---

## 📚 À lire

**react.dev → *Rendering Lists*** : courte, et elle explique la `key` avec les bons exemples.

**react.dev → *Preserving and Resetting State*** — **la lecture clé de cette leçon.** Elle explique précisément comment React apparie les composants entre deux rendus, et donc pourquoi la `key` compte. C'est elle qui transforme la règle en compréhension.

**react.dev → *Reacting to Input with State*** et ***Sharing State Between Components*** pour les formulaires.

**react-hook-form.com** en survol : tu n'as pas besoin de l'utiliser au palier 3, mais lire son argumentaire d'accueil te montrera exactement les problèmes que ton formulaire manuel rencontre.

---

## 🤖 Le mini-projet à demander à l'IA

Le bug de la `key` doit être vécu, et les formulaires doivent être écrits sur un cas réaliste.

> « Je suis en formation de développeur, palier 3 (React + TypeScript). Je travaille les listes, les `key` et les formulaires contrôlés. Fabrique-moi un **scénario d'expérience** en trois étapes, sans me donner de code : (1) une liste de tâches avec une case à cocher **et `key={index}`**, et la suite exacte de manipulations qui fera apparaître un comportement absurde ; (2) la même expérience avec un identifiant stable ; (3) un cas où la `key` sert volontairement à réinitialiser un composant. Pour chaque étape, demande-moi **ce que j'observe** et **pourquoi**, avant de confirmer. »

Puis le formulaire, sur un cas qui a de vraies contraintes :

> « Décris-moi en français, **sans code**, un formulaire réaliste à réaliser en React : une demande de congés (type d'absence, date de début, date de fin, motif obligatoire au-delà de 5 jours, nombre de jours calculé automatiquement, solde restant affiché). Donne-moi les règles métier et les cas d'erreur, pas l'implémentation. Quand je t'enverrai mon code, critique uniquement : le nombre d'états (ai-je stocké du dérivé ?), l'ordre de mes validations, l'accessibilité des messages d'erreur, et la gestion de la double soumission. »

Le « nombre de jours calculé » et le « motif obligatoire au-delà de 5 jours » sont volontaires : ils testent exactement le réflexe de la leçon 04 (dériver plutôt que stocker) et les champs dépendants.

---

## 🛠️ À faire

1. **⚠️ Le bug de la `key`** : une liste de trois tâches avec une case à cocher locale, et `key={index}`. Coche la deuxième, supprime la première, observe. Puis remplace par `key={tache.id}` et refais la manipulation. **Écris la conclusion dans ton journal.**
2. **La `key` comme outil** : un formulaire d'édition qui se réinitialise quand on change d'élément sélectionné, grâce à la `key`.
3. **Filtre et tri dérivés** : une liste avec un filtre par statut et un tri par montant ou date. Vérifie qu'aucun des deux n'est stocké en double dans l'état.
4. **Démontre la mutation de prop** : trie directement `depenses.sort(...)` sur une prop, observe le comportement, puis corrige.
5. **Les deux états vides** : affiche deux messages distincts pour « aucune donnée » et « aucun résultat pour ce filtre ».
6. **Formulaire contrôlé complet** : description, montant, catégorie, avec un seul objet d'état et un seul gestionnaire de changement.
7. **Validation** : les quatre cas du montant (vide, non numérique, négatif, zéro) dans le bon ordre. Vérifie le piège `Number("")`.
8. **Accessibilité** : `htmlFor`, `aria-invalid`, `aria-describedby`, `role="alert"`, `noValidate`. Teste au clavier et avec l'onglet Accessibilité des DevTools.
9. **Double soumission** : simule un envoi lent de deux secondes, clique trois fois, constate. Corrige avec `disabled` et `finally`.
10. **Le champ figé** : écris `<input value={x} />` sans `onChange`, essaie de taper, lis l'avertissement de la console, puis corrige.
11. **Les autres champs** : une case à cocher, un menu déroulant et un groupe de boutons radio, tous contrôlés.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Avec `key={index}`, après la suppression de la première tâche, la case cochée se retrouve sur une autre ligne. React a apparié les composants **par position** : il a vu « index 0 » dans les deux rendus, a conservé l'état local du composant, et n'a changé que le texte. Avec `key={tache.id}`, l'appariement se fait par identité : React détruit le composant de la tâche supprimée et conserve correctement l'état des autres. **Conclusion à écrire : la `key` ne sert pas à faire taire un avertissement, elle dit à React quelle donnée correspond à quel composant.**

**4.** `depenses.sort()` mute le tableau du parent sans passer par `setState` : l'ordre change dans les données, l'interface peut ne pas se mettre à jour, et un autre composant qui lit la même prop voit un ordre différent de celui qu'il affiche. C'est la leçon 04 du palier 1 et la leçon 03 de ce palier qui se rejoignent.

**7.** L'ordre correct :
```ts
if (v.montant.trim() === "") … ;                      // le vide D'ABORD
else if (Number.isNaN(Number(v.montant))) … ;         // puis le format
else if (Number(v.montant) <= 0) … ;                  // puis la valeur
```
Si tu testes `Number(v.montant) <= 0` en premier, un champ vide donne `Number("") === 0` et affiche « doit être positif » au lieu de « obligatoire ». Message faux, utilisateur perdu.

**9.** Sans protection, trois clics créent trois dépenses. Le `finally` est indispensable : sans lui, une erreur laisse le bouton désactivé définitivement et l'utilisateur est bloqué sans comprendre pourquoi.

**10.** L'avertissement dit `You provided a 'value' prop to a form field without an 'onChange' handler`. React considère que tu veux un champ en lecture seule et refuse toute saisie, puisque l'état est la source de vérité et que rien ne le met à jour. C'est la démonstration directe du principe du formulaire contrôlé.
</details>

---

## ✅ Acquis si…

- [ ] J'utilise une `key` stable, jamais l'index, et je sais expliquer le bug par un exemple vécu.
- [ ] Je sais utiliser la `key` **volontairement** pour réinitialiser un composant.
- [ ] Mes filtres et mes tris sont des valeurs **dérivées**, pas des états.
- [ ] Je ne mute jamais une prop, même avec `sort`.
- [ ] Je distingue « aucune donnée » et « aucun résultat ».
- [ ] J'écris un formulaire contrôlé avec **un** objet d'état et **un** gestionnaire.
- [ ] Mes validations sont dans le bon ordre, et je connais le piège `Number("")`.
- [ ] Mes champs ont `htmlFor`, et mes erreurs sont reliées par `aria-describedby`.
- [ ] Mon bouton est désactivé pendant l'envoi, avec un `finally`.
- [ ] Je sais ce qu'est un formulaire non contrôlé et pourquoi certaines bibliothèques le préfèrent.

# Leçon 04 — L'état : `useState` et remontée d'état

> 🎯 **À la fin de cette leçon** : tu sais placer un état au bon endroit, et tu comprends pourquoi muter ne provoque aucun réaffichage.
> ⏱️ 5 h · **Prérequis** : leçon 03, et les closures du palier 1 (leçon 05).

---

## De quoi on parle

L'**état** (*state*) est une donnée qui change dans le temps et dont dépend l'affichage : le contenu d'un champ, un filtre sélectionné, une liste d'éléments, l'ouverture d'un panneau.

```tsx
const [compte, setCompte] = useState(0);
```

Cette ligne est un destructuring de tableau (palier 1, leçon 07) : `useState` retourne deux choses, la **valeur actuelle** et une **fonction pour la changer**. Appeler cette fonction déclenche un nouveau **rendu** — React rappelle ton composant, obtient le nouveau JSX, le compare à l'ancien et met à jour le DOM.

Deux notions structurent la leçon. L'**immuabilité** : on ne modifie jamais l'état en place, on en crée une nouvelle version. Et la **remontée d'état** (*lifting state up*) : quand deux composants ont besoin de la même donnée, elle vit chez leur plus proche ancêtre commun.

---

## À quoi ça sert, concrètement

**Parce que c'est ce qui remplace ton `rendre()` du palier 2.** Tu avais un objet `etat` et une fonction `rendre()` appelée à la main après chaque changement. `useState` fait la même chose, avec une différence décisive : **tu ne peux pas oublier d'appeler le rendu**. Changer l'état le déclenche. Toute une famille de bugs — l'affichage désynchronisé des données — disparaît structurellement.

**Parce que le placement de l'état décide de la qualité de ton application.** C'est le vrai sujet de cette leçon, et c'est la question qu'on te posera : *pourquoi cet état est-il ici et pas là ?* Trop bas, deux composants ne peuvent pas se coordonner. Trop haut, toute l'application se réaffiche pour un détail, et tu passes des props à travers cinq niveaux.

**Parce que l'immuabilité, en React, n'est pas un style mais une condition de fonctionnement.** C'est le point que les débutants mettent le plus de temps à accepter, et il s'explique en une phrase : React compare les **références** pour décider s'il doit réafficher. Un tableau muté a la même référence, donc React conclut que rien n'a changé. Tes données sont à jour, ton écran ne l'est pas.

---

## Où ça intervient dans le développement

L'état est au centre de la boucle que tu connais depuis le palier 2 :

```
   ÉVÉNEMENT (clic, saisie)
        │
        ▼
   setEtat(nouvelleValeur)        ← cette leçon
        │
        ▼
   React rappelle le composant → nouveau JSX
        │
        ▼
   React compare et met à jour le DOM     ← automatique, tu n'y touches plus
```

Et la question du **placement** est une question d'architecture. Il y a une hiérarchie à connaître, parce qu'elle guidera toutes tes décisions :

```
   état LOCAL d'un composant        → useState, dans le composant
     ex. un champ de formulaire, l'ouverture d'un menu

   état PARTAGÉ entre frères       → useState remonté au parent commun
     ex. un filtre qui affecte une liste

   état GLOBAL de l'application    → Context (leçon 07)
     ex. le thème, l'utilisateur connecté

   état SERVEUR (venu d'une API)   → TanStack Query (leçon 08)
     ex. la liste des dépenses — et ce n'est PAS du useState
```

Cette dernière ligne est importante et contre-intuitive : **les données venues d'une API ne sont pas un état d'interface**. Elles ont un cache, une fraîcheur, des erreurs, des rechargements. Les gérer avec `useState` et `useEffect` fonctionne, mais tu réécriras mal ce qu'une bibliothèque fait bien — on y revient à la leçon 08.

Un prolongement : au **palier 9**, Flutter posera exactement la même question (`setState` local, puis Riverpod pour le partagé), et pour les mêmes raisons. Tu auras déjà le raisonnement.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire ton premier compteur, et trouver ça magique. Puis tu vas muter un tableau, ne rien voir changer à l'écran, et passer vingt minutes à chercher pourquoi. C'est le passage obligé, et les exercices sont construits pour que tu le vives volontairement.

Tu vas aussi découvrir que modifier un état et lire sa valeur juste après ne donne pas ce que tu attends — c'est le sujet de la mise à jour par fonction, expliqué plus bas.

Installe les **React DevTools** (extension de navigateur) dès maintenant : elles affichent l'état de chaque composant en direct. C'est l'outil de débogage de ce palier.

### En équipe, en entreprise

**« Pourquoi cet état est-il ici ? » est la question de revue de code la plus fréquente** sur du React. Savoir y répondre — « parce que c'est le plus proche ancêtre commun des deux composants qui en ont besoin » — est attendu.

**Le *props drilling* est un sujet.** Passer une prop à travers quatre niveaux pour la faire descendre est un signal : soit l'état est trop haut, soit il faut un Context (leçon 07). Les deux réponses existent, et la seconde est souvent moins bonne qu'on ne le croit.

**L'immuabilité est outillée.** Les linters signalent les mutations d'état, et certaines équipes utilisent des bibliothèques (Immer) pour écrire des mises à jour immuables sur des structures imbriquées.

**Et tu rencontreras des états dérivés stockés inutilement.** Garder dans un état une valeur qu'on peut **calculer** depuis un autre état est l'erreur de conception la plus fréquente en React, et elle produit des désynchronisations. On y revient.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `useState` avec des valeurs simples et des tableaux/objets, les mises à jour immuables (spread, `map`, `filter`), la mise à jour par fonction (`setX(prev => …)`), et la remontée d'état.

Régulièrement : plusieurs `useState` dans un composant, l'état initialisé par une fonction, les formulaires contrôlés (leçon 06), lever l'état d'un composant vers son parent.

Rare, et hors sujet pour l'instant : `useReducer` (utile quand les transitions d'état se compliquent, mais `useState` suffit très longtemps), `useSyncExternalStore`, les bibliothèques d'état global (Zustand, Redux — tu n'en auras pas besoin au palier 3), `useOptimistic`, `useTransition`, les clés pour réinitialiser un état. Et une tentation à éviter : mettre en place une bibliothèque de gestion d'état « parce que l'application va grandir ». Elle grandira ; tu l'ajouteras à ce moment-là.

---

## La mécanique

### `useState`

```tsx
import { useState } from "react";

export function Compteur() {
  const [compte, setCompte] = useState(0);        // valeur initiale

  return (
    <div>
      <p>Compte : {compte}</p>
      <button onClick={() => setCompte(compte + 1)}>+1</button>
      <button onClick={() => setCompte(0)}>Réinitialiser</button>
    </div>
  );
}
```

Avec TypeScript, le type est inféré depuis la valeur initiale. Tu n'annotes que quand l'inférence ne suffit pas :

```tsx
const [depenses, setDepenses] = useState<Depense[]>([]);        // sinon : never[]
const [selection, setSelection] = useState<Depense | null>(null);
const [etat, setEtat] = useState<EtatRequete<Depense[]>>({ statut: "vide" });
```

### ⚠️ L'immuabilité : le cœur de la leçon

```tsx
// ❌ MUTATION : React ne voit rien, l'écran ne bouge pas
const [depenses, setDepenses] = useState<Depense[]>([]);
depenses.push(nouvelle);              // on mute
setDepenses(depenses);                 // même référence → React conclut « inchangé »

// ✅ NOUVELLE RÉFÉRENCE
setDepenses([...depenses, nouvelle]);                                  // ajouter
setDepenses(depenses.filter(d => d.id !== id));                        // supprimer
setDepenses(depenses.map(d => d.id === id ? { ...d, ...champs } : d));  // modifier
setDepenses([...depenses].sort((a, b) => b.montant - a.montant));       // trier
```

Ce sont **exactement** les fonctions que tu as écrites à la leçon 04 du palier 1. Tu les avais écrites par bonne pratique ; elles sont ici une obligation technique.

Pour un objet, et pour un objet imbriqué :

```tsx
const [filtres, setFiltres] = useState({ categorie: "tout", tri: "date" });

setFiltres({ ...filtres, categorie: "food" });              // un niveau

setConfig({                                                  // deux niveaux
  ...config,
  affichage: { ...config.affichage, compact: true },
});
```

Au-delà de deux niveaux d'imbrication, c'est le signe qu'il faut **aplatir ton état** ou le découper en plusieurs `useState`.

### La mise à jour par fonction

```tsx
// ⚠️ Piège : trois appels, et le compte n'augmente que de 1
setCompte(compte + 1);
setCompte(compte + 1);
setCompte(compte + 1);

// ✅ La forme fonctionnelle lit la valeur la plus récente
setCompte(prev => prev + 1);
setCompte(prev => prev + 1);
setCompte(prev => prev + 1);        // +3
```

Pourquoi ? Parce que `compte` est une **closure** sur la valeur du rendu en cours (palier 1, leçon 05). Pendant ce rendu, `compte` vaut 0 : les trois appels disent donc tous « mets 1 ». La forme fonctionnelle reçoit la valeur en attente, pas celle capturée.

**La règle pratique : dès que la nouvelle valeur dépend de l'ancienne, utilise la forme fonctionnelle.** C'est le cas de tous les ajouts, suppressions et basculements.

```tsx
setDepenses(prev => [...prev, nouvelle]);                      // toujours correct
setOuvert(prev => !prev);                                       // basculer
```

### L'état n'est pas à jour immédiatement

```tsx
function gerer() {
  setCompte(compte + 1);
  console.log(compte);        // ⚠️ l'ANCIENNE valeur
}
```

Ce n'est pas un bug : `compte` est une constante de ce rendu. La nouvelle valeur sera disponible au **prochain** rendu. Si tu as besoin de la nouvelle valeur tout de suite, calcule-la dans une variable locale.

### ⭐ Les états dérivés : ne pas stocker ce qu'on peut calculer

```tsx
// ❌ Trois états, qui doivent rester synchronisés à la main
const [depenses, setDepenses] = useState<Depense[]>([]);
const [total, setTotal] = useState(0);
const [nombre, setNombre] = useState(0);
// chaque ajout doit mettre à jour les trois… et un oubli = affichage faux

// ✅ Un seul état, le reste CALCULÉ pendant le rendu
const [depenses, setDepenses] = useState<Depense[]>([]);
const total = calculerTotal(depenses);              // appelé à chaque rendu : c'est voulu
const nombre = depenses.length;
```

**C'est l'erreur de conception la plus fréquente en React**, et la correction est contre-intuitive pour qui vient du DOM : on recalcule à chaque rendu, et c'est bien. Un `reduce` sur deux cents éléments coûte quelques microsecondes — infiniment moins qu'un affichage faux.

La question à se poser pour chaque état : *est-ce que je peux le déduire d'un autre état ?* Si oui, ce n'est pas un état.

### ⭐ La remontée d'état

Le problème : deux composants frères ont besoin de la même donnée.

```tsx
// ❌ Chacun a son état : ils ne se voient pas
function Filtre()   { const [categorie, setCategorie] = useState("tout"); … }
function Liste()    { /* comment connaître la catégorie choisie ? */ }
```

La solution : l'état monte chez le **plus proche ancêtre commun**, et descend en props.

```tsx
function PageDepenses() {
  const [categorie, setCategorie] = useState("tout");
  const [depenses, setDepenses] = useState<Depense[]>([]);

  const visibles = categorie === "tout"
    ? depenses
    : depenses.filter(d => d.categorie === categorie);     // état dérivé, calculé

  return (
    <>
      <Filtre valeur={categorie} onChanger={setCategorie} />
      <Liste depenses={visibles} onSupprimer={supprimer} />
      <Total depenses={depenses} />
    </>
  );
}

function Filtre({ valeur, onChanger }: { valeur: string; onChanger: (v: string) => void }) {
  return (
    <select value={valeur} onChange={e => onChanger(e.target.value)}>
      <option value="tout">Toutes</option>
      <option value="food">Alimentation</option>
    </select>
  );
}
```

Observe le mécanisme : **les données descendent** en props, **les événements remontent** par des fonctions de rappel. C'est le flux unidirectionnel de React, et c'est ce qui rend une application traçable — pour comprendre d'où vient une donnée, on remonte l'arbre.

Le composant `Filtre` est devenu « contrôlé » : il ne possède plus sa valeur, il l'affiche et signale les changements. Il est de ce fait réutilisable et testable.

### Où placer un état : la méthode

Trois questions, dans cet ordre.

**Qui a besoin de lire cette donnée ?** Si un seul composant, elle reste chez lui. Si plusieurs, elle monte à leur ancêtre commun.

**Est-ce que je peux la calculer depuis un autre état ?** Si oui, ce n'est pas un état — c'est une valeur dérivée.

**Est-ce qu'elle vient du serveur ?** Si oui, ce n'est pas un `useState` (leçon 08).

Et une règle de prudence : **ne monte pas un état « au cas où »**. Place-le au plus bas, et remonte-le le jour où un deuxième composant en a besoin. Le mouvement inverse est beaucoup plus pénible.

---

## Les problèmes que tu vas rencontrer

**Je modifie l'état et rien ne change à l'écran.** Tu as muté. C'est **le** problème de cette leçon : `push`, `splice`, `sort`, `reverse`, ou une affectation sur une propriété d'objet. Vérifie dans les React DevTools que l'état a bien changé de référence.

**Mon compteur n'avance que de 1 alors que j'appelle trois fois.** Utilise la forme fonctionnelle.

**`console.log` affiche l'ancienne valeur.** Normal : c'est une constante du rendu en cours.

**Mon total est faux après une suppression.** Tu stockes un état dérivé que tu as oublié de mettre à jour. Calcule-le.

**Je passe une prop à travers quatre composants.** *Props drilling*. Soit l'état est trop haut, soit c'est un cas de Context (leçon 07) — mais vérifie d'abord le premier.

**Mon état initial est recalculé à chaque rendu.** `useState(calculCouteux())` exécute le calcul à chaque fois. Utilise la forme paresseuse : `useState(() => calculCouteux())`.

**`useState<Depense[]>([])` et TypeScript se plaint quand j'ajoute.** Tu as probablement écrit `useState([])` sans type : il infère `never[]`.

**Mon formulaire perd le focus à chaque frappe.** Tu réinitialises un composant, souvent avec une `key` qui change (leçon 06), ou tu définis un composant à l'intérieur d'un autre.

**Deux composants affichent des valeurs différentes pour la même donnée.** Ils ont chacun leur état. Remonte-le.

---

## Ce qu'on te demandera

**« Pourquoi cet état est-il ici et pas là ? »** est la question d'entretien React la plus fréquente, et c'est aussi ce que le référent te demandera sur ton projet 3. L'épreuve A3 de ton évaluation de palier porte exactement là-dessus.

Autres questions récurrentes : « pourquoi ne faut-il pas muter l'état ? » (et la bonne réponse mentionne la comparaison de références), « pourquoi la mise à jour n'est-elle pas visible immédiatement ? », « qu'est-ce que la remontée d'état ? », « que fais-tu quand deux composants ont besoin de la même donnée ? ».

En **test technique**, on observera si tu stockes des états dérivés et si tes mises à jour sont immuables.

---

## Ce qui te démarquera

**Ne pas stocker ce qui peut être calculé.** Peu de juniors le savent, et c'est la source de désynchronisations la plus commune. Dire « le total n'est pas un état, c'est une valeur dérivée » est une phrase qui situe.

**Justifier le placement de chaque état.** Pouvoir dire pour chacun qui le lit et pourquoi il est à ce niveau.

**Utiliser la forme fonctionnelle par réflexe** dès que la nouvelle valeur dépend de l'ancienne.

**Savoir expliquer l'immuabilité par la comparaison de références**, et non par « c'est la bonne pratique ». Cette explication est la preuve que tu as compris le mécanisme.

**Ne pas sortir une bibliothèque d'état global trop tôt.** Savoir dire « `useState` et une remontée suffisent ici » est un jugement apprécié.

**Utiliser les React DevTools.** Beaucoup de gens déboguent avec des `console.log` là où l'extension affiche l'arbre et l'état en direct.

---

## 📚 À lire

**react.dev → *Managing State***, en entier et dans l'ordre. C'est la section la plus importante de toute la documentation React, et elle est construite exactement autour des questions de cette leçon : *Choosing the State Structure*, *Sharing State Between Components*, et surtout ***Reacting to Input with State***.

**react.dev → *State as a Snapshot*** et ***Queueing a Series of State Updates*** expliquent précisément les deux pièges (valeur du rendu, mises à jour multiples).

**react.dev → *You Might Not Need an Effect*** : à lire maintenant même si tu n'as pas encore vu `useEffect` (leçon 05). La première section traite des états dérivés, et elle est écrite pour l'erreur la plus courante.

---

## 🤖 Le mini-projet à demander à l'IA

Le placement de l'état s'apprend sur des cas, et c'est ce qu'on évalue.

> « Je suis en formation de développeur, palier 3 (React + TypeScript). Je travaille `useState` et la remontée d'état. Décris-moi **en mots seulement**, 8 interfaces où la question du placement de l'état se pose (un filtre qui affecte une liste et un compteur, un formulaire dont deux champs dépendent l'un de l'autre, une sélection multiple avec une barre d'actions, un panneau latéral ouvert depuis plusieurs endroits, un onglet actif qui change le contenu…). Pour chacune, je te propose : **quels états existent, où je les place, et quels états sont dérivés**. Critique-moi sur trois points seulement : un état qui devrait être calculé plutôt que stocké, un état placé trop haut ou trop bas, et un *props drilling* évitable. **N'écris aucun code.** »

Puis la démonstration de l'immuabilité, à vivre une fois :

> « Donne-moi 6 extraits de code React où **l'état change mais l'écran ne se met pas à jour**, pour six raisons de mutation différentes (`push`, `sort`, affectation d'une propriété, `splice`, mutation d'un objet imbriqué, mutation d'une prop). Ne me dis pas où est le problème. Pour chacun, je dois diagnostiquer, expliquer **pourquoi React ne voit rien**, et corriger. »

---

## 🛠️ À faire

1. **Compteur** : `+1`, `-1`, réinitialiser. Puis ajoute un bouton `+3` et constate le piège des appels multiples. Corrige avec la forme fonctionnelle.
2. **Liste d'éléments** : ajouter, supprimer, modifier — toutes les mises à jour immuables, reprises de la leçon 04 du palier 1.
3. **⚠️ Démontre la mutation** : fais `depenses.push(nouvelle)` puis `setDepenses(depenses)`. Constate que rien ne change. Ouvre les React DevTools et observe l'état. Puis corrige. **Écris la conclusion dans ton journal.**
4. **L'état dérivé** : écris d'abord la version avec trois états (`depenses`, `total`, `nombre`), provoque une désynchronisation en oubliant une mise à jour, puis réécris avec un seul état et deux valeurs calculées.
5. **Remontée d'état** : un `Filtre` et une `Liste` comme composants frères, l'état chez le parent. Vérifie que le filtre agit bien.
6. Rends le `Filtre` **contrôlé** (il reçoit `valeur` et `onChanger`), et réutilise-le deux fois dans la page avec des états différents.
7. **Le piège du `console.log`** : affiche l'état juste après l'avoir modifié, constate l'ancienne valeur, et explique pourquoi dans ton journal.
8. **Objet imbriqué** : un état `{ affichage: { compact: boolean } }`, et une mise à jour correcte sur deux niveaux. Puis aplatis cet état et compare la lisibilité.
9. **La question du placement** : prends ton projet 2 (l'application météo) et liste **par écrit** tous ses états, où ils doivent vivre, et lesquels sont dérivés. Fais valider cette liste par l'IA ou le référent **avant** de coder.
10. Installe les **React DevTools** et observe l'état de tes composants pendant que tu interagis.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Pour `+3`, trois `setCompte(compte + 1)` n'ajoutent que 1, parce que `compte` vaut la même chose pendant tout le rendu. `setCompte(prev => prev + 1)` trois fois ajoute 3, parce que chaque appel reçoit la valeur en attente. C'est la closure du palier 1 appliquée à React.

**3.** Dans les React DevTools, l'état affiche bien le nouvel élément — tes données **sont** à jour. Mais React a comparé l'ancienne et la nouvelle référence du tableau, les a trouvées identiques, et a conclu qu'il n'y avait rien à réafficher. **Conclusion à écrire : React compare les références, pas les contenus. Muter met à jour les données et pas l'écran — c'est pour ça que l'immuabilité est une condition de fonctionnement et pas une préférence.**

**4.** La désynchronisation arrive dès que tu ajoutes un chemin de modification (une suppression, un import, une remise à zéro) et que tu oublies de mettre à jour l'un des trois états. Avec un seul état et des valeurs calculées, **l'oubli est impossible**.

**8.**
```tsx
setConfig({ ...config, affichage: { ...config.affichage, compact: true } });
```
Et la version aplatie :
```tsx
const [compact, setCompact] = useState(false);     // beaucoup plus simple
```
La leçon : un état imbriqué sur deux niveaux ou plus est généralement le signe qu'il faut le découper. Les mises à jour deviennent illisibles, et c'est là qu'on voit apparaître des bibliothèques comme Immer — pour un problème qu'on aurait pu éviter en structurant autrement.

**9.** Les états attendus pour une application météo : la ville saisie (local au champ, ou remonté si plusieurs composants en ont besoin), les villes favorites (partagé, donc remonté), le thème (global, donc Context à la leçon 07), et **les données météo — qui ne sont pas un `useState`** mais de l'état serveur (leçon 08). Le fait de distinguer cette dernière catégorie est précisément ce que l'exercice cherche à te faire voir.
</details>

---

## ✅ Acquis si…

- [ ] J'utilise `useState` avec un type explicite quand l'inférence ne suffit pas.
- [ ] Je ne mute **jamais** l'état, et j'explique pourquoi par la comparaison de références.
- [ ] J'ai provoqué volontairement une mutation et constaté l'absence de réaffichage.
- [ ] J'utilise la forme fonctionnelle dès que la nouvelle valeur dépend de l'ancienne.
- [ ] Je sais que l'état n'est pas à jour immédiatement après l'appel.
- [ ] Je ne stocke jamais un état que je peux **calculer**.
- [ ] Je place chaque état au plus proche ancêtre commun de ceux qui le lisent, et je sais le justifier.
- [ ] J'écris des composants contrôlés (`valeur` + `onChanger`).
- [ ] Je sais que les données venues d'une API ne sont pas un `useState`.
- [ ] J'utilise les React DevTools pour inspecter l'état.

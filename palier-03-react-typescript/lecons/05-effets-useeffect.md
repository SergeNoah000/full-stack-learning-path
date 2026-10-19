# Leçon 05 — Les effets : `useEffect`, et quand ne pas l'utiliser

> 🎯 **À la fin de cette leçon** : tu synchronises ton composant avec le monde extérieur quand c'est nécessaire — et tu reconnais les quatre cas, très fréquents, où `useEffect` est la mauvaise réponse.
> ⏱️ 4 h · **Prérequis** : leçon 04.
>
> ⚠️ **C'est la leçon où l'on se trompe le plus en React.** Le titre n'est pas une coquetterie : la moitié de cette leçon consiste à apprendre à **ne pas** utiliser `useEffect`.

---

## `useEffect`, c'est quoi

`useEffect` permet d'exécuter du code **après** le rendu, pour **synchroniser ton composant avec quelque chose d'extérieur à React**.

```tsx
useEffect(() => {
  document.title = `${depenses.length} dépenses`;     // l'effet
}, [depenses.length]);                                 // les dépendances
```

Trois éléments. La **fonction d'effet**, exécutée après que React a mis à jour le DOM. Le **tableau de dépendances** : l'effet se rejoue quand l'une de ces valeurs change. Et une **fonction de nettoyage**, optionnelle, retournée par l'effet, que React appelle avant de rejouer l'effet et au démontage du composant.

Le mot à retenir est **synchroniser**. Pas « faire quelque chose après le rendu », pas « réagir à un changement » : synchroniser avec un système qui n'est pas React — le titre du document, un minuteur, un abonnement, une API du navigateur, une bibliothèque externe.

---

## À quoi ça sert, concrètement

**À toucher ce que React ne gère pas.** React s'occupe de ton arbre de composants. Tout le reste — le titre de l'onglet, `localStorage`, un écouteur sur `window`, un minuteur, une connexion WebSocket, une carte Leaflet — est extérieur, et c'est le domaine légitime de `useEffect`.

**À nettoyer derrière soi.** C'est la partie que les débutants ignorent, et c'est la plus importante. Un écouteur ajouté sans être retiré, un minuteur jamais arrêté, une requête qui continue après que l'utilisateur a quitté la page : ce sont des fuites mémoire et des bugs. La fonction de nettoyage est la raison d'être de `useEffect` autant que l'effet lui-même.

**Et il faut dire tout de suite ce à quoi il ne sert pas**, parce que c'est la cause de la majorité du mauvais code React : transformer des données pour l'affichage, réagir à un clic, synchroniser deux états entre eux, ou charger des données serveur. Ces quatre cas ont chacun une meilleure réponse, détaillée plus bas.

---

## Où ça intervient dans le développement

Place `useEffect` à la frontière de React :

```
   ┌─────────────────────────────────────────┐
   │   LE MONDE DE REACT                     │
   │   props → état → rendu                  │
   │   (pur, prévisible, sans effet de bord) │
   └──────────────────┬──────────────────────┘
                      │  useEffect   ← la porte de sortie
                      ▼
   ┌─────────────────────────────────────────┐
   │   LE MONDE EXTÉRIEUR                    │
   │   document.title · localStorage         │
   │   setInterval · addEventListener        │
   │   WebSocket · bibliothèques tierces     │
   │   (et, faute de mieux, le réseau)       │
   └─────────────────────────────────────────┘
```

Tu reconnais la distinction de la leçon 03 du palier 1 : les fonctions **pures** d'un côté, les **effets de bord** de l'autre. Le rendu d'un composant doit être pur ; `useEffect` est l'endroit prévu pour les effets. C'est le même principe d'architecture, à une autre échelle.

Et un point essentiel pour la suite du palier : **le chargement de données a sa propre solution**. Historiquement on le faisait avec `useEffect` + `useState`, et c'est encore très répandu. Mais il faut alors réécrire à la main le chargement, les erreurs, l'annulation, le cache, les nouvelles tentatives, la déduplication — soit deux cents lignes fragiles. C'est ce que TanStack Query fait pour toi (leçon 08). Tu écriras la version manuelle dans cette leçon, **pour comprendre ce que l'outil t'économise**, puis tu passeras à l'outil.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire une boucle infinie. C'est quasi certain, et c'est formateur : un effet qui met à jour un état dont il dépend se rejoue sans fin. Le navigateur chauffe, et tu comprends l'intérêt du tableau de dépendances.

Tu vas aussi découvrir que ton effet s'exécute **deux fois** au démarrage en développement. Ce n'est pas un bug : c'est le mode strict de React qui monte, démonte et remonte volontairement ton composant pour révéler les effets mal nettoyés. Si ton code se comporte mal, c'est ton code qui a un problème.

### En équipe, en entreprise

**`useEffect` est l'objet du plus grand nombre de remarques en revue de code React.** Les deux récurrentes : « cet effet n'est pas nécessaire » et « il manque le nettoyage ».

**On te parlera du linter des hooks.** `eslint-plugin-react-hooks` vérifie que tes dépendances sont complètes. Il a presque toujours raison, et la bonne réaction à un avertissement n'est jamais de le désactiver mais de revoir la structure de l'effet.

**Personne n'écrit plus de chargement de données à la main.** Toutes les équipes utilisent TanStack Query, SWR, ou le chargement intégré de leur framework (Next.js, Remix). Si tu vois un `useEffect` avec un `fetch` dans du code récent, c'est généralement une dette.

**Et tu verras beaucoup d'effets inutiles** dans du code existant, souvent écrits par quelqu'un qui n'avait pas encore lu la documentation officielle sur le sujet.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien, honnêtement : **presque rien**. Dans une application moderne, un composant sur dix a un `useEffect`. Les usages réels : un abonnement à un événement de `window`, un minuteur, la synchronisation avec `localStorage`, le titre du document.

Régulièrement : le nettoyage d'abonnements, l'annulation de requêtes avec `AbortController`, l'intégration d'une bibliothèque non-React.

Rare, et hors sujet pour l'instant : `useLayoutEffect` (pour les mesures de DOM avant peinture), `useRef` pour conserver une valeur entre les rendus, `useImperativeHandle`, les effets qui dépendent d'une référence de fonction. Et deux choses à ne pas faire : charger des données avec `useEffect` dans un projet neuf, et désactiver le linter des dépendances.

---

## La mécanique

### Les trois formes de dépendances

```tsx
useEffect(() => { … });              // à CHAQUE rendu — presque toujours une erreur
useEffect(() => { … }, []);          // une seule fois, au montage
useEffect(() => { … }, [a, b]);      // quand a ou b change
```

### Un effet correct, avec nettoyage

```tsx
export function Horloge() {
  const [heure, setHeure] = useState(new Date());

  useEffect(() => {
    const id = setInterval(() => setHeure(new Date()), 1000);
    return () => clearInterval(id);        // ⭐ le nettoyage : sans lui, fuite mémoire
  }, []);

  return <p>{heure.toLocaleTimeString("fr-FR")}</p>;
}
```

Et un abonnement à un événement global :

```tsx
export function useLargeurFenetre() {
  const [largeur, setLargeur] = useState(window.innerWidth);

  useEffect(() => {
    const gerer = () => setLargeur(window.innerWidth);
    window.addEventListener("resize", gerer);
    return () => window.removeEventListener("resize", gerer);   // ⭐ même référence
  }, []);

  return largeur;
}
```

Note que `removeEventListener` reçoit **la même référence** que `addEventListener` — c'est le piège de la leçon 08 du palier 2, et il se résout naturellement ici puisque la fonction est définie dans l'effet.

### ⭐ Les quatre cas où `useEffect` est la mauvaise réponse

C'est la partie la plus utile de la leçon. Ces quatre erreurs représentent la grande majorité des `useEffect` qu'on trouve dans du code de débutant.

**1. Transformer des données pour l'affichage.**

```tsx
// ❌ Un état et un effet pour une valeur dérivée
const [depenses, setDepenses] = useState<Depense[]>([]);
const [total, setTotal] = useState(0);
useEffect(() => { setTotal(calculerTotal(depenses)); }, [depenses]);

// ✅ Calcule pendant le rendu (leçon 04)
const total = calculerTotal(depenses);
```

La version haute provoque **deux rendus** pour chaque changement et peut afficher brièvement une valeur périmée. La version basse est plus simple et toujours juste.

**2. Réagir à un événement utilisateur.**

```tsx
// ❌ Un état intermédiaire et un effet pour réagir à un clic
const [soumis, setSoumis] = useState(false);
useEffect(() => { if (soumis) { envoyer(); setSoumis(false); } }, [soumis]);

// ✅ Fais-le dans le gestionnaire, là où l'événement se produit
function gererSoumission() { envoyer(); }
```

La règle : **ce qui est causé par une interaction va dans le gestionnaire d'événement**, pas dans un effet. Un effet sert à réagir à un *affichage*, pas à une *action*.

**3. Synchroniser deux états entre eux.**

```tsx
// ❌ Un effet pour maintenir la cohérence
useEffect(() => { setNomComplet(`${prenom} ${nom}`); }, [prenom, nom]);

// ✅ Dérive
const nomComplet = `${prenom} ${nom}`;
```

**4. Réinitialiser un état quand une prop change.**

```tsx
// ❌ Un effet qui remet à zéro
useEffect(() => { setBrouillon(""); }, [utilisateurId]);

// ✅ Une `key` : React remonte le composant, l'état repart de zéro
<Editeur key={utilisateurId} utilisateurId={utilisateurId} />
```

Cette dernière technique est peu connue et très élégante : changer la `key` d'un composant le détruit et le recrée, donc son état est réinitialisé — sans effet, sans code.

> **La question à se poser avant chaque `useEffect` : est-ce que je synchronise avec quelque chose d'EXTÉRIEUR à React ?** Si la réponse est non, il y a presque toujours une meilleure solution.

### Le chargement de données : la version manuelle

À écrire une fois, pour comprendre ce que tu délégueras ensuite :

```tsx
export function useMeteo(ville: string | null) {
  const [etat, setEtat] = useState<EtatRequete<Meteo>>({ statut: "vide" });

  useEffect(() => {
    if (!ville) { setEtat({ statut: "vide" }); return; }

    const controleur = new AbortController();      // ⭐ pour annuler
    setEtat({ statut: "chargement" });

    recupererMeteo(ville, controleur.signal)
      .then(donnees => setEtat({ statut: "donnees", donnees }))
      .catch(e => {
        if (e.name === "AbortError") return;        // annulation volontaire : on ignore
        setEtat({ statut: "erreur", message: messageUtilisateur(e) });
      });

    return () => controleur.abort();                // ⭐ nettoyage
  }, [ville]);

  return etat;
}
```

L'union discriminée de la leçon 02 structure l'état, et les quatre états du palier 2 réapparaissent. Mais observe ce qui manque encore : pas de cache (changer de ville et revenir refait l'appel), pas de nouvelle tentative, pas de déduplication si deux composants demandent la même ville, pas de rechargement en arrière-plan. **C'est précisément ce que TanStack Query ajoute**, et c'est pourquoi on ne garde pas cette version en production.

Le `AbortController` règle en revanche un vrai bug qu'il faut connaître : la **condition de course**. Si l'utilisateur tape « Douala » puis « Dakar », et que la réponse de Douala arrive en dernier, tu affiches la météo de Douala alors que le champ dit Dakar. L'annulation supprime le problème.

### Le mode strict et le double appel

En développement, React monte, démonte et remonte chaque composant. Ton effet s'exécute donc deux fois, et son nettoyage une fois entre les deux. Ce n'est pas un bug à contourner : c'est un **test** que React te fait passer. Si ton effet se comporte mal (deux minuteurs qui tournent, deux abonnements), c'est que le nettoyage manque — et ce bug se manifesterait en production autrement.

---

## Les problèmes que tu vas rencontrer

**Boucle infinie.** Ton effet met à jour un état qui figure dans ses dépendances. Soit cet état ne devrait pas être un état (cas 1 ou 3 ci-dessus), soit la dépendance est en trop.

**Mon effet se rejoue à chaque rendu.** Tu as oublié le tableau de dépendances, ou une dépendance est un objet/tableau/fonction recréé à chaque rendu (donc une nouvelle référence à chaque fois — leçon 04 du palier 1).

**Le linter me réclame une dépendance et ça casse quand je l'ajoute.** C'est le signal que l'effet n'est pas structuré correctement. Ne désactive pas la règle : déplace la logique, ou demande-toi si cet effet est nécessaire.

**Mon effet s'exécute deux fois.** Le mode strict en développement. Vérifie ton nettoyage.

**J'ai une fuite mémoire ou un avertissement de mise à jour sur un composant démonté.** Il manque le nettoyage, ou l'annulation de la requête.

**Deux requêtes se croisent et j'affiche la mauvaise.** Condition de course. `AbortController`.

**Mon effet lit une valeur périmée.** C'est une *stale closure* : l'effet a capturé la valeur du rendu où il a été créé (palier 1, leçon 05). Ajoute la dépendance manquante, ou utilise la forme fonctionnelle de `setState`.

**Mon `useEffect` avec `fetch` fonctionne mais tout est lent.** Pas de cache : chaque navigation refait les appels. C'est la leçon 08.

---

## Ce qu'on te demandera

En **entretien React**, deux questions sont devenues classiques et très discriminantes : « à quoi sert le tableau de dépendances ? » et surtout **« cite des cas où `useEffect` n'est PAS la bonne solution »**. La seconde distingue immédiatement ceux qui ont lu la documentation moderne.

Suivent : « pourquoi la fonction de nettoyage ? », « pourquoi ton effet s'exécute-t-il deux fois en développement ? », « comment chargerais-tu des données aujourd'hui ? » (et la bonne réponse n'est plus `useEffect`).

En **revue de code**, « cet effet est-il nécessaire ? » est la question la plus posée.

---

## Ce qui te démarquera

**Savoir quand ne pas l'utiliser.** C'est l'essentiel de la leçon, et c'est ce qui sépare un code React moderne d'un code écrit par habitude. Pouvoir citer les quatre cas te place au-dessus de la plupart des candidats juniors.

**Nettoyer systématiquement.** Minuteurs, abonnements, requêtes. Et comprendre le mode strict comme un allié plutôt qu'une nuisance.

**Connaître l'astuce de la `key` pour réinitialiser un état.** Très peu de gens la connaissent, et elle remplace élégamment un effet.

**Savoir expliquer la condition de course**, et la régler avec `AbortController`. C'est un vrai bug de production, difficile à reproduire, et le mentionner montre de l'expérience.

**Avoir écrit le chargement à la main une fois, et savoir pourquoi on ne le garde pas.** Pouvoir énumérer ce qui manque (cache, retry, déduplication, annulation) est l'argument qui justifie TanStack Query — et c'est exactement ce qu'on attend d'un développeur qui choisit ses outils au lieu de les suivre.

---

## 📚 À lire

**react.dev → *You Might Not Need an Effect*** — **la lecture obligatoire de cette leçon.** Elle est entièrement consacrée aux cas où `useEffect` est la mauvaise réponse, avec des exemples avant/après. Lis-la deux fois.

**react.dev → *Synchronizing with Effects*** pour le modèle correct, et ***Lifecycle of Reactive Effects*** pour comprendre le nettoyage et le mode strict.

**react.dev → *Removing Effect Dependencies*** quand le linter te réclamera une dépendance qui casse tout.

Ces quatre pages sont, à elles seules, ce qui sépare un usage correct de `useEffect` d'un usage approximatif. L'équipe React les a écrites précisément parce que le hook était massivement mal employé.

---

## 🤖 Le mini-projet à demander à l'IA

L'essentiel ici est d'apprendre à **refuser** un effet.

> « Je suis en formation de développeur, palier 3 (React + TypeScript). Je travaille `useEffect`. Donne-moi **12 situations** décrites en français (pas de code) où un développeur débutant écrirait un `useEffect`. Mélange des cas où il est **justifié** (synchronisation avec un système extérieur) et des cas où il est **inutile** (valeur dérivée, réaction à un événement, synchronisation de deux états, réinitialisation sur changement de prop) — sans me dire lesquels. Pour chacune, je dois répondre : effet nécessaire ou non, et si non, **quelle est la bonne solution**. Corrige-moi en expliquant le coût réel de l'effet inutile (rendus supplémentaires, valeur périmée affichée, risque de boucle). »

C'est l'exercice qui fait le plus progresser sur ce sujet, parce que la compétence évaluée est le **jugement**, pas la syntaxe.

Puis l'exercice de nettoyage, qui révèle les bugs qu'on ne voit pas :

> « Donne-moi 6 composants React avec un `useEffect` **dont le nettoyage est absent ou incorrect** (minuteur, écouteur sur window, abonnement, requête non annulée, deux abonnements imbriqués, un `setInterval` recréé à chaque rendu). Ne me dis pas où est le problème. Pour chacun, je dois dire **ce qui se passe concrètement si l'utilisateur quitte la page ou navigue dix fois**, puis corriger. »

---

## 🛠️ À faire

1. **Un effet légitime** : une horloge avec `setInterval` et son nettoyage. Retire le nettoyage, navigue plusieurs fois vers le composant et constate les minuteurs qui s'accumulent.
2. **Un abonnement** : un hook `useLargeurFenetre` avec `addEventListener` et son retrait.
3. **La boucle infinie** : écris volontairement un effet qui met à jour un état dont il dépend. Observe. Puis corrige **en supprimant l'effet** plutôt qu'en bricolant les dépendances.
4. **Les quatre cas inutiles** : pour chacun des quatre, écris d'abord la version avec `useEffect`, puis la version correcte. Compare le nombre de rendus (ajoute un `console.log` dans le corps du composant).
5. **La `key` pour réinitialiser** : un composant d'édition avec un brouillon local, qui doit se vider quand on change d'élément. Fais-le d'abord avec un effet, puis avec une `key`.
6. **Le mode strict** : ajoute un `console.log` dans un effet, lance en développement, et constate le double appel. Explique dans ton journal pourquoi React fait ça.
7. **Le chargement manuel** : écris le hook `useMeteo` complet, avec les quatre états, `AbortController` et le nettoyage. Branche-le sur Open-Meteo.
8. **La condition de course** : avec le bridage réseau des DevTools, tape rapidement deux villes différentes. Sans `AbortController`, constate que la mauvaise réponse peut s'afficher. Avec, constate que c'est réglé.
9. **Liste ce qui manque** : à partir de ton hook de l'exercice 7, écris dans ton journal tout ce qu'il ne fait pas encore (cache, retry, déduplication, rechargement). Cette liste est la justification de la leçon 08.
10. Compte les `useEffect` de ton projet : pour chacun, écris en une ligne **avec quel système extérieur il synchronise**. Si tu ne peux pas répondre, supprime-le.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Sans nettoyage, chaque montage crée un nouvel intervalle qui n'est jamais arrêté : au bout de dix navigations, dix minuteurs tournent en parallèle et appellent `setHeure` dix fois par seconde. C'est une fuite mémoire, et elle dégrade progressivement l'application — le genre de bug qui n'apparaît qu'après une heure d'utilisation.

**3.** Le code fautif typique :
```tsx
useEffect(() => { setTotal(calculerTotal(depenses)); }, [depenses, total]);
```
La bonne correction n'est pas de retirer `total` des dépendances : c'est de supprimer l'effet et l'état, et de calculer `const total = calculerTotal(depenses)` pendant le rendu. **Quand un effet pose problème, demande d'abord s'il doit exister.**

**4.** Tu devrais observer **deux rendus** au lieu d'un avec la version `useEffect` : un pour le changement de l'état source, un pour le `setState` de l'effet. Et entre les deux, l'affichage montre brièvement l'ancienne valeur dérivée — un scintillement visible sur un calcul plus lourd.

**6.** React monte, démonte et remonte volontairement en développement pour vérifier que tes effets sont « résistants au remontage », c'est-à-dire correctement nettoyés. Un effet bien écrit se comporte identiquement ; un effet mal nettoyé révèle son bug immédiatement, en développement, plutôt qu'en production.

**8.** Sans annulation, les deux requêtes aboutissent, et c'est **la dernière arrivée** qui écrase l'état — pas forcément la dernière demandée. Avec `AbortController`, la requête précédente est annulée au nettoyage de l'effet, donc sa réponse n'arrive jamais. Ce bug est réel, fréquent dans les champs de recherche, et quasi impossible à reproduire sans bridage réseau — raison de plus pour connaître l'outil.

**9.** La liste attendue : pas de cache (revenir sur une ville refait l'appel), pas de déduplication (deux composants = deux appels identiques), pas de nouvelle tentative sur erreur réseau, pas de rechargement quand l'onglet reprend le focus, pas d'état « données périmées pendant le rechargement », pas de partage de l'état entre composants éloignés. **Six manques, deux cents lignes à écrire — c'est exactement l'argumentaire de la leçon 08.**
</details>

---

## ✅ Acquis si…

- [ ] Je sais énoncer la question à se poser : **est-ce que je synchronise avec un système extérieur à React ?**
- [ ] Je cite les quatre cas où `useEffect` est inutile, et la bonne solution pour chacun.
- [ ] Je nettoie systématiquement minuteurs, abonnements et requêtes.
- [ ] J'ai provoqué une boucle infinie et je l'ai corrigée **en supprimant l'effet**.
- [ ] Je sais pourquoi mes effets s'exécutent deux fois en développement.
- [ ] Je connais l'astuce de la `key` pour réinitialiser un état.
- [ ] J'ai écrit un chargement de données à la main, avec `AbortController`.
- [ ] J'ai constaté une condition de course et je sais la régler.
- [ ] Je peux dire, pour chaque `useEffect` de mon code, avec quoi il synchronise.
- [ ] Je peux énumérer ce qui manque à un chargement manuel — et donc justifier TanStack Query.

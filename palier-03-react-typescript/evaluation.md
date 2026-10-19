# ✅ Épreuve de sortie — Palier 3

> **Conditions** : seul, **sans tutoriel**. Copilot autorisé sur le boilerplate uniquement (niveau 3 du fil rouge) — mais **désactivé pendant les épreuves A1 et A2**. Doc officielle autorisée.
> **Durée** : ~4 h hors projet. **Seuil** : 4/4 épreuves · **13/18** au quiz · projet 3 déployé.

---

## Partie A — Épreuves pratiques

### A1 — TypeScript (45 min, Copilot désactivé)
On te donne un module JavaScript non typé (prends une de tes fonctions du palier 1). Type-le entièrement en `strict` :
- types de tous les paramètres et retours, **aucun `any`**
- une `interface` pour le modèle de données
- une **union discriminée** pour un état `{ statut: "chargement" } | { statut: "ok", donnees: T } | { statut: "erreur", message: string }`
- une fonction **générique** (ex. `premierOuNull<T>(liste: T[]): T | null`)
- `tsc --noEmit` passe sans erreur

✅ **Réussi si** : zéro `any`, zéro erreur de compilation, et tu sais expliquer à quoi sert l'union discriminée.

### A2 — React de zéro (90 min, Copilot désactivé)
Crée avec **Vite** une app 3 pages : liste / détail / formulaire d'ajout.
- React Router avec un **paramètre d'URL** (`/items/:id`)
- données chargées depuis une API publique, avec les trois états (chargement / erreur / vide / données)
- un formulaire contrôlé avec validation
- au moins un **custom hook** extrait
- la logique métier vit **hors** des composants (fonctions pures importées)

✅ **Réussi si** : l'app tourne, navigue, affiche correctement ses états, sans aucun tutoriel consulté.

### A3 — État : le bon endroit (30 min)
On te donne une app où tout l'état est dans le composant racine et passé sur 4 niveaux de props. Corrige :
- remonte ou descends chaque état au bon niveau
- introduis un Context **uniquement** là où il est justifié
- remplace l'état serveur par TanStack Query
- justifie **par écrit** chaque décision (3 lignes par état)

✅ **Réussi si** : plus aucun props-drilling inutile, et chaque choix est justifié.

### A4 — Débogage React (30 min)
On te donne un composant comportant 5 bugs classiques : `useEffect` sans tableau de dépendances (boucle infinie), état muté directement, clé d'itération basée sur l'index avec réordonnancement, calcul dérivé stocké dans un état, `fetch` sans annulation au démontage. Trouve-les et corrige.

✅ **Réussi si** : les 5 sont identifiés et corrigés, avec l'explication de la conséquence de chacun.

---

## Partie B — Quiz (18 questions)

**TypeScript**
1. Qu'apporte TypeScript par rapport à JavaScript ? Et que n'apporte-t-il **pas** à l'exécution ?
2. `interface` vs `type` : quand utiliser l'un ou l'autre ?
3. Pourquoi `any` est-il à éviter ? Que mettre à la place quand on ne sait pas ?
4. Qu'est-ce qu'une union discriminée, et quel problème résout-elle ?
5. À quoi sert un générique ? Donne un exemple.
6. Que fait `strict: true` ? Pourquoi dès le début du projet ?

**React**
7. Qu'est-ce qu'un composant ? Quelle est la règle sur les props ?
8. Pourquoi ne jamais muter l'état directement ? Que fait React de ce changement ?
9. `useState` : pourquoi la mise à jour n'est-elle pas visible immédiatement après l'appel ?
10. À quoi sert le tableau de dépendances de `useEffect` ? Que se passe-t-il s'il est absent ? S'il est vide ?
11. Cite trois cas où `useEffect` **n'est pas** la bonne réponse.
12. Pourquoi les clés de liste ? Pourquoi l'index est-il un mauvais choix ?
13. Qu'est-ce que la remontée d'état (*lifting state up*) ?
14. Context : deux cas où il est justifié, deux cas où il est une erreur.
15. Qu'est-ce qu'un custom hook ? Quelle est la règle de nommage et pourquoi ?
16. `useState` vs `useEffect` vs TanStack Query : quel outil pour quel problème ?
17. Que t'apporte TanStack Query que `useEffect` + `useState` ne t'apportent pas ?
18. Pourquoi organiser les dossiers **par feature** plutôt que par type de fichier ?

<details>
<summary>Corrections</summary>

1. Une vérification des types **avant** l'exécution, de l'autocomplétion et de la documentation vivante. À l'exécution : rien — tout est effacé à la compilation, donc **aucune** validation des données entrantes. Il faut toujours valider à la frontière (Zod, palier 4).
2. Très proches. `interface` pour décrire la forme d'un objet (extensible, bons messages d'erreur) ; `type` pour les unions, intersections, alias de primitives et types calculés.
3. `any` désactive toute vérification et se propage silencieusement. À la place : `unknown` (force à vérifier avant usage), ou le type précis.
4. Un champ littéral commun (`statut`) qui permet à TypeScript de **restreindre** le type dans chaque branche. Résout les états impossibles : plus de `donnees` et `erreur` remplis en même temps.
5. Écrire une fonction ou un type qui fonctionne pour **plusieurs** types en conservant l'information : `premierOuNull<T>(liste: T[]): T | null` rend un `string` sur un `string[]`.
6. Active toutes les vérifications strictes, dont `strictNullChecks` (la plus utile). Au début, parce que l'activer sur un projet existant génère des centaines d'erreurs d'un coup.
7. Une fonction qui reçoit des props et retourne du JSX. Les props sont en **lecture seule** : un composant ne modifie jamais ses props.
8. React compare les **références** pour décider de réafficher. Muter garde la même référence → pas de réaffichage, l'interface se désynchronise des données.
9. L'état est remplacé au prochain rendu, pas dans la variable courante (qui est une closure sur la valeur du rendu en cours). Pour calculer depuis la valeur précédente : `setX(prev => …)`.
10. Il dit **quand** relancer l'effet. Absent : l'effet s'exécute à **chaque** rendu (boucle infinie s'il met l'état à jour). Vide : une seule fois au montage.
11. Transformer des données pour l'affichage (calcule pendant le rendu), réagir à un événement utilisateur (fais-le dans le gestionnaire), synchroniser deux états (dérive l'un de l'autre). Ajoute : charger des données serveur, où TanStack Query est meilleur.
12. Pour identifier chaque élément entre deux rendus. L'index change quand on insère, supprime ou réordonne : React associe alors le mauvais état au mauvais élément (une case cochée « saute » de ligne).
13. Déplacer un état dans le plus proche ancêtre commun des composants qui en ont besoin.
14. Justifié : thème, utilisateur authentifié, langue. Erreur : état serveur (→ TanStack Query), état qui change très souvent (tous les consommateurs se réaffichent).
15. Une fonction qui utilise des hooks et encapsule une logique réutilisable. Elle doit commencer par `use` : c'est ce qui permet au linter d'appliquer les règles des hooks (pas d'appel conditionnel, pas dans une boucle).
16. `useState` → état local d'interface. `useEffect` → synchronisation avec un système extérieur (abonnement, titre du document, timer). TanStack Query → **état serveur**.
17. Cache partagé, déduplication des requêtes, invalidation, rechargement en arrière-plan, états `loading`/`error` gratuits, retry, pagination. Soit 200 lignes de code que tu n'écris pas — et qui seraient buguées.
18. Parce qu'on travaille **par fonctionnalité** : tout ce qui concerne « dépenses » est au même endroit, donc une feature se lit, se déplace ou se supprime d'un bloc. Le découpage par type disperse chaque fonctionnalité dans 5 dossiers.

**Score** : ____ /18
</details>

---

## Partie C — Livrables

- [ ] Projet 1 **refactorisé en TypeScript** strict, sans `any`.
- [ ] [Projet 3](projet.md) **déployé sur Vercel**, URL dans [../progression.md](../progression.md).
- [ ] **User stories** rédigées ([template](../templates/user-stories.md)), maquette Figma, **kanban GitHub Projects** terminé.
- [ ] Toutes les user stories livrées **ou** explicitement abandonnées (colonne *Won't*).
- [ ] Tâches découpées à moins de 2 h — vérifiable dans le kanban.
- [ ] Structure de dossiers **par feature**, logique métier hors des composants.
- [ ] Les katas passent en TypeScript · `journal.md` · [rétrospective](../templates/retrospective-palier.md).
- [ ] 🧑‍🏫 Référent : revue du découpage des composants et du placement de l'état (« pourquoi cet état est ici et pas là ? ») + revue du kanban.

---

## Résultat

| Partie | Seuil | Résultat |
|--------|-------|----------|
| A — Pratique | 4/4 | ⬜ |
| B — Quiz | 13/18 | ⬜ ___/18 |
| C — Livrables | tout coché | ⬜ |

**Date** : ______ · **Verdict** : ⬜ validé ⬜ à repasser le ______ · [ ] reporté dans [../progression.md](../progression.md)

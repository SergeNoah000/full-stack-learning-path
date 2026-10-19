# ✅ Épreuve de sortie — Palier 2

> **Conditions** : seul, sans tutoriel, sans framework CSS, sans IA génératrice de code (l'IA en relecture **après** est autorisée — c'est le niveau 2 du fil rouge). MDN autorisé.
> **Durée** : ~4 h hors projet. **Seuil** : 4/4 épreuves pratiques · **12/16** au quiz · projet 2 en ligne.

---

## Partie A — Épreuves pratiques

### A1 — Intégration sans tutoriel (90 min)
On te donne une **capture d'écran** d'une section de site réel (choisis-en une sur land-book.com que tu n'as jamais faite). Reproduis-la :
- HTML **sémantique** (aucun `div` là où une balise de sens existe, un seul `h1`, hiérarchie de titres correcte)
- CSS à la main (ni Bootstrap, ni Tailwind)
- **responsive** : lisible et utilisable de 320 px à 1920 px, sans débordement horizontal
- Flexbox **et** Grid chacun utilisé au moins une fois, à bon escient

✅ **Réussi si** : rendu fidèle à ±10 %, zéro erreur dans le validateur HTML (validator.w3.org), aucun scroll horizontal au plus petit format.

### A2 — Formulaire accessible (30 min)
Un formulaire d'inscription : nom, email, mot de passe, confirmation, date de naissance, pays (select), acceptation des conditions (checkbox).
- chaque champ a un `label` **relié** (`for`/`id`)
- types d'input corrects, validation native (`required`, `type="email"`, `minlength`)
- validation JS complémentaire : messages d'erreur **par champ**, affichés sous le champ concerné
- navigable **entièrement au clavier** (Tab), focus visible

✅ **Réussi si** : utilisable au clavier seul, et les deux validations (native + JS) coexistent sans se contredire.

### A3 — DOM et événements (45 min)
Une liste de tâches, **sans framework** :
- ajouter une tâche (formulaire), la cocher, la supprimer
- filtrer : toutes / à faire / faites
- compteur de tâches restantes, mis à jour automatiquement
- persistance via `localStorage` (survit au rechargement)
- la suppression utilise la **délégation d'événements** (un seul écouteur sur le conteneur)

✅ **Réussi si** : tout fonctionne, et tu peux expliquer pourquoi la délégation est préférable à un écouteur par bouton.

### A4 — API et séparation des responsabilités (45 min)
Affiche la météo d'une ville saisie par l'utilisateur (Open-Meteo, sans clé) :
- **trois fichiers distincts** : `api.js` (appels réseau), `ui.js` (DOM), `app.js` (orchestration)
- les trois états gérés visuellement : **chargement**, **erreur**, **données**
- `r.ok` vérifié, ville inconnue traitée proprement
- aucune donnée affichée sans échappement

✅ **Réussi si** : couper le réseau (DevTools → Offline) affiche un message d'erreur propre, pas une page cassée.

---

## Partie B — Quiz (16 questions)

1. Pourquoi du HTML sémantique plutôt que des `div` ? Cite deux bénéfices concrets.
2. Combien de `h1` par page, et pourquoi ?
3. Explique le box model, et ce que change `box-sizing: border-box`.
4. Comment se calcule la spécificité CSS ? Classe l'ordre : élément, classe, id, style en ligne.
5. `rem`, `em`, `%`, `vh` : quand utilises-tu chacun ?
6. Flexbox ou Grid : lequel pour une barre de navigation ? pour une galerie en 3 colonnes ? Pourquoi ?
7. Que fait `justify-content: space-between` ? Et `align-items: center` ?
8. Qu'est-ce que « mobile-first », et pourquoi `min-width` plutôt que `max-width` ?
9. Différence entre `display: none`, `visibility: hidden` et `opacity: 0` ?
10. Qu'est-ce que le DOM ? Dans quel ordre le navigateur construit-il la page ?
11. Qu'est-ce que la délégation d'événements et quel problème résout-elle ?
12. Pourquoi `event.preventDefault()` sur la soumission d'un formulaire ?
13. La validation côté client suffit-elle ? Justifie.
14. Pourquoi une clé d'API ne peut-elle pas vivre dans ton JavaScript de navigateur ? Que fais-tu alors pour ton projet 2 ?
15. Qu'est-ce que CORS, et de quel côté se corrige l'erreur ?
16. Quelles sont les limites de `localStorage` ? Donne deux cas où il est inadapté.

<details>
<summary>Corrections</summary>

1. Accessibilité (les lecteurs d'écran s'appuient sur la structure), SEO, et lisibilité du code pour les humains.
2. Un seul : il annonce le sujet de la page. Plusieurs `h1` cassent la hiérarchie du document.
3. Contenu + `padding` + `border` + `margin`. `border-box` fait que `width` inclut padding et bordure — bien plus prévisible, d'où la règle `*{box-sizing:border-box}`.
4. style en ligne > id > classe/attribut/pseudo-classe > élément. `!important` écrase tout (à éviter).
5. `rem` : tailles de police et espacements (relatif à la racine, respecte les préférences utilisateur). `em` : relatif au parent, utile pour des composants. `%` : largeurs relatives au conteneur. `vh`/`vw` : dimensions liées à la fenêtre (attention aux barres de navigateur mobile).
6. Nav → Flexbox (un seul axe). Galerie 3 colonnes → Grid (deux dimensions, `repeat(auto-fit, minmax(…))`).
7. Répartit l'espace restant **entre** les éléments (premier collé au début, dernier à la fin). `align-items: center` centre sur l'axe transversal.
8. On écrit le style mobile par défaut puis on **ajoute** pour les grands écrans avec `min-width`. Le mobile est le cas le plus contraint et le plus fréquent ; partir de là évite d'empiler des surcharges.
9. `display:none` retire du flux (ni visible, ni place occupée, ignoré des lecteurs d'écran). `visibility:hidden` invisible mais garde la place. `opacity:0` invisible, garde la place, **reste cliquable**.
10. La représentation en mémoire de la page, manipulable par JS. Ordre : HTML → DOM, CSS → styles, puis layout, puis peinture ; le JS peut intervenir et provoquer un recalcul.
11. Un écouteur sur le **parent**, qui identifie la cible via `event.target`. Résout : les éléments ajoutés dynamiquement (sinon il faudrait rattacher un écouteur à chaque création) et le coût de milliers d'écouteurs.
12. Pour empêcher le rechargement par défaut de la page et traiter la soumission en JS.
13. Non — elle sert au **confort**. Le client est contournable (`curl`, DevTools) : la validation de sécurité est **toujours** côté serveur (palier 4).
14. Tout le JS envoyé au navigateur est public. Pour le projet 2, on utilise une API **sans clé** (Open-Meteo) ou une clé restreinte par domaine ; sinon il faut un backend — ce sera le palier 4.
15. Une règle du navigateur interdisant les requêtes vers une autre origine, sauf autorisation. Elle se corrige **côté serveur** (en-têtes `Access-Control-Allow-Origin`), jamais côté client.
16. Quelques Mo, chaînes uniquement, **un seul navigateur sur un seul appareil**, effaçable par l'utilisateur, synchrone (bloquant). Inadapté : données partagées entre utilisateurs, données sensibles, gros volumes.

**Score** : ____ /16
</details>

---

## Partie C — Livrables

- [ ] Les **3 intégrations imposées** (landing page, formulaire de connexion, grille de cartes) dans leurs repos, chacune responsive.
- [ ] [Projet 2 — App météo](projet.md) **en ligne sur GitHub Pages**, URL dans ton profil GitHub et dans [../progression.md](../progression.md).
- [ ] **Mini-cadrage rédigé AVANT le code** — vérifiable dans l'historique Git ([template](../templates/mini-cadrage.md)).
- [ ] `TODO.md` de suivi tenu pendant le projet.
- [ ] Code organisé en fichiers séparés (API / DOM / logique) — fil rouge architecture niveau 1.
- [ ] Rituel katas tenu · `journal.md` rempli · [rétrospective](../templates/retrospective-palier.md) rédigée.
- [ ] 🧑‍🏫 Référent : revue du projet 2 **et** du mini-cadrage.

---

## Résultat

| Partie | Seuil | Résultat |
|--------|-------|----------|
| A — Pratique | 4/4 | ⬜ |
| B — Quiz | 12/16 | ⬜ ___/16 |
| C — Livrables | tout coché | ⬜ |

**Date** : ______ · **Verdict** : ⬜ validé ⬜ à repasser le ______ · [ ] reporté dans [../progression.md](../progression.md)

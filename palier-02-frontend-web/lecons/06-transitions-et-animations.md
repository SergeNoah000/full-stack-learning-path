# Leçon 06 — Transitions, transformations, animations

> 🎯 **À la fin de cette leçon** : tu ajoutes du mouvement qui aide l'utilisateur au lieu de le distraire, et tu sais pourquoi certaines animations saccadent et d'autres non.
> ⏱️ 2 h · **Prérequis** : leçons 03–05.

---

## De quoi on parle

Une **transition** anime le passage d'un état à un autre : un bouton qui change de couleur au survol, une carte qui se soulève. Tu déclares *quelle* propriété animer et *en combien de temps*, et le navigateur calcule les étapes intermédiaires.

Une **transformation** (`transform`) déplace, tourne, agrandit ou incline un élément **sans toucher à la mise en page** — c'est le point essentiel, et on verra pourquoi.

Une **animation** (`@keyframes`) est une séquence à plusieurs étapes, qui peut se répéter, se jouer sans déclencheur, s'arrêter et reprendre. C'est la version complète de la transition.

---

## À quoi ça sert, concrètement

**À donner un retour immédiat.** C'est la fonction principale, et elle est souvent mal comprise : une animation n'est pas une décoration, c'est une **information**. Un bouton qui réagit au survol dit « je suis cliquable ». Un bouton qui s'enfonce au clic dit « j'ai reçu ton clic ». Un indicateur qui tourne dit « ça travaille, ne reclique pas ». Sans ces retours, l'utilisateur reclique, s'inquiète, ou abandonne.

**À expliquer ce qui change.** Quand un panneau s'ouvre, un élément se supprime, une liste se réordonne, une transition montre **d'où ça vient et où ça va**. Un changement instantané force l'utilisateur à reconstruire mentalement ce qui s'est passé ; une transition de 200 millisecondes le lui montre.

**À masquer l'attente.** Un indicateur de chargement ne rend pas le serveur plus rapide, mais il rend l'attente supportable — et il évite les doubles soumissions.

Et il faut dire l'inverse tout de suite, parce que c'est le piège de cette leçon : **une animation qui n'informe de rien est une nuisance**. Elle ralentit l'usage, elle fatigue, et pour certaines personnes elle provoque de vrais malaises (nausées, migraines). C'est pourquoi la section sur `prefers-reduced-motion` n'est pas optionnelle.

---

## Où ça intervient dans le développement

Le mouvement intervient à trois endroits précis, et c'est utile de les connaître pour ne pas en mettre ailleurs.

**Sur les états interactifs** : survol, focus, clic, désactivé. C'est 80 % du mouvement d'une interface, et c'est le plus rentable.

**Sur les changements d'état de l'interface** : apparition d'un message, ouverture d'un menu, bascule d'un onglet, suppression d'un élément d'une liste.

**Sur les attentes** : indicateurs de chargement, barres de progression, squelettes de contenu. Tu en auras besoin dès la leçon 09, quand tes appels réseau prendront du temps.

Deux prolongements dans le parcours.

**Au palier 3**, les animations de listes et de pages se feront souvent avec une bibliothèque (Framer Motion) parce que React démonte les éléments et qu'animer une sortie devient compliqué en CSS seul. Mais les transitions d'état simples resteront du CSS — on ne charge pas une bibliothèque pour un survol.

**Au palier 8**, le mouvement devient un sujet de performance mesurée : les Core Web Vitals pénalisent les décalages de mise en page (CLS), et une animation mal choisie en provoque. C'est la raison technique de la section suivante.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas vouloir en mettre partout — c'est l'étape normale. Puis tu vas te rendre compte que les interfaces que tu utilises tous les jours en ont très peu, et toujours très courtes. Le réflexe à acquérir : **des durées de 150 à 250 millisecondes**, et seulement là où il y a une information à transmettre.

### En équipe, en entreprise

**Les durées et les courbes sont imposées par le système de design.** On ne choisit pas « 0,4 s avec ease-in-out » au cas par cas : il existe des variables (`--duree-rapide`, `--courbe-sortie`) et on s'y tient, pour que toute l'application bouge de la même façon.

**On te reprendra sur les propriétés animées.** Animer `width`, `height`, `top` ou `margin` force le navigateur à recalculer la mise en page à chaque image — ça saccade sur un téléphone. Animer `transform` et `opacity` ne coûte presque rien. C'est la remarque de performance la plus fréquente sur ce sujet, et elle est expliquée plus bas.

**`prefers-reduced-motion` est attendu.** Dans les équipes qui prennent l'accessibilité au sérieux, une animation sans cette garde-fou est refusée en revue.

### Ce qui sert tous les jours, et ce qui est rare

Au quotidien : `transition` sur les états interactifs, `transform: translateY()` et `scale()`, `opacity`, et la media query `prefers-reduced-motion`.

Régulièrement : `@keyframes` pour un indicateur de chargement ou une apparition, `animation-delay` pour décaler plusieurs éléments, `transition-delay`, les courbes `ease-out` et `cubic-bezier`.

Rare, et sans intérêt pour toi aujourd'hui : les transformations 3D (`perspective`, `rotateY`), `will-change` (une optimisation à n'utiliser qu'en dernier recours, et qui peut dégrader si mal employée), les animations liées au défilement (`scroll-timeline`), `@starting-style`, l'API Web Animations en JavaScript, les transitions de vue (`view-transition`, prometteur mais récent). Et une chose qu'on ne fait plus : animer en JavaScript avec `setInterval` — le CSS et `requestAnimationFrame` sont là pour ça.

---

## La mécanique

### Les transitions

```css
.bouton {
  background: var(--couleur-principale);
  transform: translateY(0);
  transition: background 150ms ease-out, transform 150ms ease-out;
}

.bouton:hover  { background: var(--couleur-foncee); transform: translateY(-2px); }
.bouton:active { transform: translateY(0); }          /* il s'enfonce au clic */
```

La déclaration se lit : *quelle propriété*, *combien de temps*, *avec quelle courbe*. Deux recommandations pratiques :

**Nomme les propriétés, n'écris pas `transition: all`.** `all` anime tout ce qui change, y compris des propriétés que tu n'avais pas prévues, et coûte plus cher à calculer. C'est une source de comportements surprenants.

**Mets la transition sur l'état de repos**, pas sur le `:hover`. Sinon le retour à l'état normal est instantané et l'effet paraît cassé.

Pour les durées, un repère qui vaut partout : **150 à 250 ms** pour une interaction (survol, clic), **200 à 300 ms** pour l'apparition d'un panneau. Au-delà de 400 ms, l'interface est perçue comme lente. Et `ease-out` est le bon défaut : rapide au départ, ralentit à la fin — c'est ce qui paraît naturel à l'œil.

### Les transformations

```css
transform: translateY(-4px);          /* déplacer */
transform: translate(-50%, -50%);     /* déplacer sur les deux axes */
transform: scale(1.05);                /* agrandir */
transform: rotate(45deg);              /* tourner */
transform: translateY(-4px) scale(1.02);   /* combiner (l'ordre compte) */
```

Le point capital : **`transform` ne modifie pas la mise en page**. Un élément déplacé avec `translateY` laisse sa place inoccupée et ne pousse pas ses voisins. Comparé à `top` ou `margin-top`, c'est à la fois le comportement souhaité (rien ne bouge autour) et beaucoup moins coûteux à calculer.

### Pourquoi certaines animations saccadent

Le navigateur peut avoir à refaire trois choses quand quelque chose change :

| Étape | Déclenchée par | Coût |
|---|---|---|
| **Layout** — recalculer les positions et tailles | `width`, `height`, `top`, `margin`, `padding`, `font-size` | 💀 très cher |
| **Paint** — repeindre les pixels | `background`, `color`, `box-shadow`, `border-radius` | 😐 moyen |
| **Composite** — réassembler les couches | **`transform`, `opacity`** | ✅ quasi gratuit |

Pour tenir soixante images par seconde, le navigateur a **16 millisecondes** par image. Un recalcul de mise en page sur une page chargée peut à lui seul dépasser ce budget — d'où les saccades.

> **La règle à retenir : anime `transform` et `opacity`. Pour tout le reste, demande-toi s'il existe une façon de l'exprimer avec ces deux-là.** Pour agrandir, `scale()` plutôt que `width`. Pour déplacer, `translate()` plutôt que `top`. Pour faire apparaître, `opacity` plutôt que `display`.

### Les animations avec `@keyframes`

```css
@keyframes apparition {
  from { opacity: 0; transform: translateY(8px); }
  to   { opacity: 1; transform: translateY(0); }
}

.message { animation: apparition 250ms ease-out; }

@keyframes rotation {
  to { transform: rotate(360deg); }
}

.chargement {
  animation: rotation 800ms linear infinite;   /* linear : une rotation ne ralentit pas */
}
```

Et le décalage en cascade, qui donne un effet soigné pour presque rien :

```css
.carte:nth-child(1) { animation-delay: 0ms; }
.carte:nth-child(2) { animation-delay: 60ms; }
.carte:nth-child(3) { animation-delay: 120ms; }
```

### ⚠️ `prefers-reduced-motion` : la garde-fou obligatoire

Certaines personnes désactivent les animations dans leur système d'exploitation, parce que le mouvement leur provoque des nausées ou des migraines (troubles vestibulaires). Le navigateur transmet cette préférence, et la respecter prend quatre lignes :

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

Mets ce bloc dans **tous** tes projets. C'est l'un des rares cas où `!important` est justifié : on écrase délibérément toutes les animations du site.

### Faire apparaître et disparaître proprement

```css
.panneau {
  opacity: 0;
  transform: translateY(-8px);
  visibility: hidden;
  transition: opacity 200ms ease-out, transform 200ms ease-out, visibility 200ms;
}
.panneau.ouvert { opacity: 1; transform: translateY(0); visibility: visible; }
```

Note l'usage de `visibility` plutôt que `display: none` : `display` n'est pas animable, et il retire l'élément instantanément. Avec `visibility`, l'élément cesse d'être visible **et** d'être atteignable au clavier à la fin de la transition — ce qui est important, parce qu'un panneau invisible mais focalisable est un piège pour la navigation au clavier.

---

## Les problèmes que tu vas rencontrer

**Mon animation ne se déclenche pas.** La propriété n'est pas animable (`display`, `position`), ou la valeur de départ n'est pas définie explicitement — on ne peut pas animer depuis `height: auto`.

**Ça saccade sur mobile.** Tu animes une propriété qui déclenche un recalcul de mise en page. Repasse par `transform` et `opacity`. Vérifie dans l'onglet *Performance* des DevTools : il affiche les images trop longues en rouge.

**Mon `transition: all` produit des effets bizarres.** Il anime des changements que tu n'avais pas prévus. Nomme les propriétés.

**Le retour à l'état normal est instantané.** Tu as mis la transition sur `:hover` au lieu de l'état de repos.

**Mon menu déroulant pousse le contenu de la page.** Tu animes `height` ou tu changes `display`. Utilise `transform` et `opacity`, et sors l'élément du flux avec `position: absolute` si nécessaire.

**L'élément masqué reste accessible au clavier.** `opacity: 0` ne retire rien : l'élément est toujours là, cliquable et focalisable. Ajoute `visibility: hidden` (ou `inert` sur le conteneur).

**Mon indicateur de chargement ralentit le navigateur.** Animer `box-shadow` ou un dégradé coûte du repaint à chaque image. Préfère une rotation sur un élément simple.

**Mon animation se rejoue à chaque rendu.** Au palier 3, en React, une clé qui change remonte le composant et relance l'animation. Rien à corriger ici, mais sache d'où ça viendra.

---

## Ce qu'on te demandera

En **entretien**, la question presque systématique est : « quelles propriétés CSS sont performantes à animer, et pourquoi ? ». La réponse attendue est `transform` et `opacity`, avec l'explication layout/paint/composite. Elle distingue nettement.

Suivent : « différence entre `transition` et `animation` ? », « comment respectes-tu les préférences de mouvement réduit ? » (beaucoup de candidats ne connaissent pas `prefers-reduced-motion`), « comment fais-tu un indicateur de chargement ? ».

En **test technique**, on ne te demandera pas d'animation spectaculaire — on regardera si tes états interactifs existent (`:hover`, `:focus-visible`, `:active`) et si les transitions sont sobres. Une interface sans aucun retour au survol paraît cassée.

En **revue de code**, les remarques portent sur les durées trop longues, `transition: all`, et l'absence de `prefers-reduced-motion`.

---

## Ce qui te démarquera

**Savoir expliquer layout / paint / composite.** C'est le raisonnement de performance le plus accessible du frontend, et le connaître à ce stade est inhabituel.

**Mettre `prefers-reduced-motion` dans tous tes projets.** Quatre lignes, et c'est le signe d'une culture d'accessibilité réelle plutôt que déclarative.

**Des durées courtes.** Savoir dire « 400 ms, c'est trop long pour un survol » est un jugement de conception qui s'acquiert et qui se remarque.

**Animer pour informer.** Pouvoir justifier chaque animation par ce qu'elle apprend à l'utilisateur — et savoir en retirer une qui n'apprend rien. C'est la maturité sur ce sujet, et c'est rare.

**Soigner `:active` et `:focus-visible`**, pas seulement `:hover`. Le survol n'existe pas sur mobile : une interface qui ne réagit qu'au survol ne réagit pas du tout sur téléphone.

---

## 📚 À lire

**MDN → *Using CSS transitions*** et ***Using CSS animations*** : les deux pages de référence, courtes et suffisantes.

**web.dev → *Animations*** explique précisément layout / paint / composite, avec des mesures. C'est la lecture qui donne l'argument technique de cette leçon.

**css-tricks.com → *A Complete Guide to CSS Transitions*** comme aide-mémoire, et **cubic-bezier.com** pour visualiser et fabriquer une courbe.

Et pour la dimension conception : **MDN → *prefers-reduced-motion*** et l'article *Designing Safer Web Animation* (A List Apart) — court, et il explique concrètement quels mouvements posent problème.

---

## 🤖 Le mini-projet à demander à l'IA

Le mouvement s'apprend en comparant, et en mesurant.

> « Je suis en formation de développeur, palier 2 (frontend). Je travaille les transitions et les animations CSS. Donne-moi **8 micro-interactions à réaliser**, décrites **uniquement par ce que l'utilisateur doit comprendre** (pas par les propriétés à utiliser) : un bouton qui confirme qu'il a reçu le clic, un champ qui signale une erreur sans être agressif, un panneau qui montre d'où il vient, une carte qui indique qu'elle est cliquable, un indicateur d'attente, une suppression d'élément de liste, un message de succès qui apparaît puis s'efface, un chargement par squelette. Pour chacune, je t'envoie mon CSS ; tu vérifies trois points : **les propriétés que j'anime sont-elles performantes** (composite seulement), ma durée est-elle adaptée, et ai-je prévu `prefers-reduced-motion`. Ne me donne pas de code. »

Puis l'exercice de mesure, qui rend la théorie concrète :

> « Donne-moi deux versions d'une même animation de carte au survol : l'une qui anime `width`, `height` et `top`, l'autre qui anime `transform` et `opacity`. Ne me dis pas laquelle est la bonne. Je dois les mesurer dans l'onglet Performance des DevTools et t'expliquer ce que je vois. »

---

## 🛠️ À faire

1. **Un bouton complet** : états normal, `:hover`, `:active`, `:focus-visible`, `:disabled`, avec une transition de 150 ms. Vérifie que le focus clavier est visible.
2. **Une carte au survol** : légère élévation (`translateY(-4px)`) et ombre accentuée.
3. **Un indicateur de chargement** en `@keyframes` : une rotation infinie, en `linear`.
4. **Une apparition** : un message qui arrive en fondu avec un léger déplacement vers le haut.
5. **Une cascade** : cinq cartes qui apparaissent décalées de 60 ms avec `animation-delay`.
6. **⚠️ Mesure la différence** : deux cartes identiques, l'une animée avec `width`/`height`/`top`, l'autre avec `transform`. Ouvre l'onglet *Performance* des DevTools, enregistre pendant le survol, et compare le temps passé en *Layout*. Note le résultat dans ton journal.
7. **Ajoute le bloc `prefers-reduced-motion`** à tes trois intégrations imposées, puis active l'option dans ton système (sous GNOME : Paramètres → Accessibilité → Réduire les animations) et vérifie que tout s'arrête.
8. **Un panneau dépliant** accessible : il s'ouvre en transition, et quand il est fermé il n'est **pas** atteignable au clavier. Teste avec `Tab`.
9. Reprends le bouton de l'exercice 1 et **supprime toutes les animations**. Compare l'impression d'ensemble. Écris en deux lignes ce que le mouvement apportait réellement.

<details>
<summary>Corrections et points de contrôle</summary>

**1.**
```css
.bouton {
  transition: background-color 150ms ease-out, transform 150ms ease-out;
}
.bouton:hover         { background-color: var(--couleur-foncee); }
.bouton:active        { transform: translateY(1px); }     /* il s'enfonce */
.bouton:focus-visible { outline: 2px solid currentColor; outline-offset: 2px; }
.bouton:disabled      { opacity: 0.5; cursor: not-allowed; }
```
Le `:active` est celui qu'on oublie, et c'est le seul retour disponible **sur mobile**, où `:hover` n'existe pas.

**6.** Dans l'onglet Performance, la version `width`/`height`/`top` montre des barres violettes (*Layout*) et souvent des images au-delà de 16 ms ; la version `transform` n'en montre presque aucune. Sur une page chargée ou un téléphone d'entrée de gamme, l'écart devient visible à l'œil nu. **C'est la démonstration de la règle de la leçon.**

**8.**
```css
.panneau { opacity: 0; visibility: hidden; transition: opacity 200ms, visibility 200ms; }
.panneau.ouvert { opacity: 1; visibility: visible; }
```
Avec `opacity: 0` seul, tu peux atteindre les liens du panneau fermé avec `Tab` sans les voir : le focus « disparaît » pour l'utilisateur clavier, qui ne comprend plus où il est. C'est un vrai bug d'accessibilité, fréquent, et invisible si on ne teste pas au clavier.

**9.** Ce que le mouvement apportait : la confirmation que le clic a été reçu, et l'indication que l'élément est interactif. Sans lui, l'interface paraît « morte » ou cassée — même quand elle fonctionne parfaitement. C'est exactement l'argument « animer pour informer ».
</details>

---

## ✅ Acquis si…

- [ ] Mes éléments interactifs ont des états `:hover`, `:active` et `:focus-visible`.
- [ ] Mes transitions durent 150 à 250 ms et sont déclarées sur l'état de repos.
- [ ] Je n'écris jamais `transition: all`.
- [ ] J'anime `transform` et `opacity`, et j'explique layout / paint / composite.
- [ ] J'ai **mesuré** la différence entre une animation de mise en page et une animation composite.
- [ ] Le bloc `prefers-reduced-motion` est dans tous mes projets.
- [ ] Un élément masqué par animation n'est pas atteignable au clavier.
- [ ] Je sais justifier chaque animation par l'information qu'elle transmet.
- [ ] Je sais que `:hover` n'existe pas sur mobile.

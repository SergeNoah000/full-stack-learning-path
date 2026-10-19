# Leçon 01 — Cadrer et concevoir un produit : du problème réel au cahier des charges

> 🎯 **À la fin de cette leçon** : tu pars d'un problème réel, tu le cadres (pour qui, quoi, pourquoi), et tu en tires un périmètre livrable — un *must-have* qui existe vite, pas un rêve parfait qui ne sort jamais.
> ⏱️ 5 h · **Prérequis** : tout le parcours technique, et les templates `mini-cadrage`, `user-stories`, `cahier-des-charges`.

---

## De quoi on parle

Jusqu'ici, on te donnait quoi construire. Ici, tu décides. Cadrer un produit, c'est passer d'une envie floue (« une app de gestion de dépenses ») à un périmètre clair et livrable : **pour qui**, **quel problème**, **quelle est la plus petite version qui résout vraiment ce problème**.

Les outils de cadrage, que tu as dans tes templates :

- le **mini-cadrage** : problème, cible, valeur, périmètre, en une page ;
- les **user stories** : « en tant que [utilisateur], je veux [action] afin de [bénéfice] » — découper le besoin en morceaux livrables ;
- le **MoSCoW** : trier les fonctionnalités en *Must have* / *Should have* / *Could have* / *Won't have* — pour décider ce qu'on livre d'abord ;
- le **cahier des charges** : le document qui fige ce qu'on construit (utile pour un client, un stage, un devis).

Le principe directeur du palier : **le produit doit exister vite**. Un *must-have* livré est un projet fini ; tout le reste, ce sont des itérations. Le piège mortel du débutant est de vouloir tout faire, parfaitement, et de ne jamais sortir.

---

## À quoi ça sert, concrètement

**Parce qu'un projet qui ne sort pas ne vaut rien.** Un portfolio avec trois projets « en cours » à 80 % ne prouve rien ; un seul projet **fini et en ligne** prouve que tu sais livrer. Cadrer serré — définir la plus petite version qui marche — est ce qui fait la différence entre « j'ai commencé plein de trucs » et « j'ai livré ». C'est la compétence la plus sous-estimée, et la plus décisive.

**Parce qu'en entreprise, personne ne te dira exactement quoi coder.** On te donne un problème (« les clients abandonnent leur panier »), pas des spécifications ligne à ligne. Savoir transformer un problème en user stories, prioriser, et proposer un périmètre, est ce qu'on attend d'un développeur — pas seulement de « pisser du code ». Cette compétence te sort du rang de simple exécutant.

**Parce que prioriser est un acte, pas une évidence.** Tout paraît important au début. Le MoSCoW force à décider : qu'est-ce qui, sans quoi, le produit ne sert à rien (*must*) ? Qu'est-ce qui attendra (*should*, *could*) ? Qu'est-ce qu'on ne fera **pas** (*won't*, tout aussi important à nommer) ? Dire non à des fonctionnalités est ce qui permet de livrer.

**Et parce que le cadrage est ce qu'on présentera.** Ton projet final (et les entretiens, leçon 05) s'ouvrira sur « quel problème ça résout, pour qui ». Un produit bien cadré se raconte en une phrase ; un produit flou, personne ne comprend à quoi il sert. Le cadrage est aussi la base de ta narration (leçon 04).

---

## Où ça intervient dans le développement

Le cadrage est l'étape zéro, avant toute ligne de code :

```
   PROBLÈME RÉEL (une vraie douleur, pour de vrais gens)
        ▼  mini-cadrage : pour qui ? quoi ? pourquoi ?
   PÉRIMÈTRE (user stories découpées)
        ▼  MoSCoW : must / should / could / won't
   MUST-HAVE (la plus petite version qui résout le problème)
        ▼  cahier des charges (si client/stage/devis)
   → CONSTRUIRE (tout le parcours technique) → LIVRER → itérer
```

Trois ancrages dans le parcours.

**C'est le point de départ du projet final, qui assemble tout.** Les paliers 2-9 t'ont donné les briques (front, back, mobile, DevOps). Le cadrage décide **lesquelles** tu assembles et dans quel ordre, pour ton produit multi-clients (leçon 02). Sans cadrage, l'assemblage part dans tous les sens.

**Le MoSCoW prolonge le YAGNI du palier 7.** « N'écris pas ce dont tu n'as pas besoin maintenant » (palier 7, leçon 02) au niveau du code devient « ne construis pas la fonctionnalité dont le produit n'a pas besoin pour exister » au niveau produit. Même discipline, échelle supérieure : livrer le nécessaire, repousser le reste.

**Et il nourrit toute la suite du palier.** Le cahier des charges cadre l'assemblage (leçon 02), le problème résolu devient le pitch du portfolio (leçon 04) et la démo d'entretien (leçon 05), et la capacité à cadrer est un argument en recherche d'emploi (leçon 06). Le cadrage irrigue tout.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas choisir un problème **réel** (le tien, celui d'un proche, d'une petite structure locale), le cadrer en une page, le découper en user stories, les trier en MoSCoW, et définir ton *must-have* — la version qui existera vite. Puis tu rédigeras un mini cahier des charges.

### En équipe, en entreprise

**Le cadrage est un travail d'équipe, mené par le produit.** *Product owner*, *product manager*, parfois le client : ils cadrent, priorisent, écrivent les user stories. Le développeur **participe** (estime, alerte sur la faisabilité, propose des découpages). Comprendre ce langage (user stories, MoSCoW, backlog) te rend crédible dans ces discussions.

**Les user stories structurent le travail quotidien.** Le travail arrive en user stories (dans Jira, Trello, GitHub Projects) : une story = un morceau livrable, avec des critères d'acceptation. Savoir lire, découper et estimer une story est un geste de chaque sprint.

**La priorisation est permanente et difficile.** « Tout est prioritaire » est le piège classique. Les bonnes équipes tranchent : ce qui a le plus de valeur pour le moindre effort d'abord. Et elles assument les *won't have* — ce qu'on ne fera pas, pour cette version.

**Le périmètre se protège.** Le *scope creep* (le périmètre qui enfle en cours de route, « tant qu'on y est, ajoutons… ») fait déraper les projets. Savoir dire « oui, mais dans une prochaine itération » protège la livraison. C'est le YAGNI, en gestion de projet.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : lire et découper une user story, estimer grossièrement, distinguer must/nice-to-have, protéger le périmètre.

Régulièrement : écrire des user stories avec critères d'acceptation, prioriser en MoSCoW, rédiger un cadrage, participer à un affinage de backlog.

Rare au début : le cahier des charges formel complet (plutôt pour le freelance/client, leçon 06), l'estimation chiffrée précise, la roadmap produit, les méthodes d'idéation. À connaître ; tu les approfondiras selon ton contexte (salariat vs freelance).

---

## La mécanique

### Partir d'un problème réel (pas d'une techno)

```
❌ "Je veux faire une app en Flutter avec Riverpod et une API Node."  (parti de la techno)
✅ "Les bénévoles de l'asso X notent les présences sur papier et perdent du temps à
    les recompter. Je veux leur faire gagner ce temps."              (parti du PROBLÈME)
```

Le point de départ est un **problème**, pas une technologie. « Je veux utiliser React » n'est pas un projet ; « les gens de tel endroit galèrent avec tel truc » en est un. Un problème réel donne un produit qu'on peut raconter, tester auprès de vrais utilisateurs, et défendre en entretien. Choisis un problème que tu comprends (le tien, celui d'un proche, d'une petite structure locale).

### ⭐ Le mini-cadrage (une page)

```
PROBLÈME : quelle douleur, pour qui, aujourd'hui comment font-ils ?
CIBLE    : qui exactement l'utilisera (sois précis : "les bénévoles de l'asso", pas "les gens")
VALEUR   : qu'est-ce que ça leur apporte concrètement (gain de temps, moins d'erreurs...)
PÉRIMÈTRE: ce que le produit fait / ne fait PAS (la frontière, dès maintenant)
SUCCÈS   : à quoi on saura que ça marche (ex. "saisie d'une présence en < 10 s")
```

Le mini-cadrage (ton template) tient en une page et répond aux questions qui comptent **avant** de coder. Le plus important : définir la **cible précise** (pas « tout le monde ») et le **périmètre** (ce que ça ne fait pas, explicitement). Un produit qui essaie de servir tout le monde ne sert personne.

### Les user stories : découper le besoin

```
Format : "En tant que [rôle], je veux [action] afin de [bénéfice]."

En tant que bénévole, je veux marquer une présence d'un tap afin de ne pas perdre de temps.
En tant que bénévole, je veux voir la liste des présents afin de vérifier d'un coup d'œil.
En tant que responsable, je veux exporter les présences afin de les transmettre.

Chaque story : petite, livrable seule, avec des CRITÈRES D'ACCEPTATION (quand est-ce "fini" ?).
```

Les user stories découpent le produit en morceaux **livrables indépendamment**. Le format « en tant que… je veux… afin de… » force à nommer le rôle et le bénéfice (pas juste la fonctionnalité). Les **critères d'acceptation** (« c'est fini quand… ») évitent le flou sur ce qui est attendu. Une story trop grosse se redécoupe.

### ⭐ Le MoSCoW : prioriser pour livrer

```
MUST have   : sans ça, le produit ne résout PAS le problème. → la version 1.
SHOULD have : important, mais le produit marche sans, pour l'instant. → itération suivante.
COULD have  : agréable, si le temps le permet. → plus tard.
WON'T have  : explicitement HORS périmètre (pour cette version). → assumé, écrit.

Exemple (app de présences) :
  MUST  : marquer une présence, voir la liste. (c'est tout ce qu'il faut pour résoudre le problème)
  SHOULD: exporter, filtrer par date.
  COULD : statistiques, graphiques.
  WON'T : gestion de plusieurs assos, authentification complexe. (pas pour la v1)
```

Le MoSCoW est l'acte de priorisation. La discipline : le **must-have** doit être le plus petit ensemble qui résout **vraiment** le problème — souvent bien plus petit qu'on ne croit. Et les **won't have** sont aussi importants à écrire que les must : nommer ce qu'on ne fait **pas** protège le périmètre et clarifie l'intention. C'est le YAGNI (palier 7) au niveau produit.

### ⭐ Le must-have : exister vite

```
Le produit fini = le MUST-HAVE livré et en ligne, pas la vision complète.
  - Must-have livré → tu as un projet FINI, démontrable, dans ton portfolio.
  - Le reste (should/could) → des ITÉRATIONS, ajoutées si tu veux, après.
Mieux vaut un petit produit fini qu'un grand produit à 80 % que personne ne voit.
```

C'est le message central du palier, répété : **un must-have livré est un projet fini**. Vouloir tout faire parfaitement avant de sortir est le piège qui fait que rien ne sort. On livre la plus petite version qui résout le problème, on la met en ligne (palier 8), et on itère ensuite — ou pas. Le fini bat le parfait.

### Le cahier des charges (quand c'est utile)

```
Pour un vrai client, un stage, un devis (leçon 06) : un document qui fige
  - le contexte et les objectifs,
  - le périmètre fonctionnel (les user stories must/should),
  - ce qui est HORS périmètre (les won't — crucial pour éviter les malentendus),
  - les livrables, le planning indicatif, les hypothèses.
Pour un projet perso de portfolio : le mini-cadrage suffit, pas besoin du document lourd.
```

Le cahier des charges (ton template) formalise l'accord sur ce qu'on construit — indispensable face à un client (il protège les deux parties, surtout par ce qu'il exclut), facultatif pour un projet perso. Savoir le rédiger est un atout en freelance (leçon 06).

---

## Les problèmes que tu vas rencontrer

**« Mon projet est trop ambitieux, je n'avance pas. »** Le piège numéro un. Ton must-have est trop gros. Recoupe : quelle est la **plus petite** version qui résout le problème ? Souvent, deux ou trois user stories suffisent pour une v1 démontrable.

**« Je n'arrive pas à choisir ce qui est prioritaire. »** Pose la question du MoSCoW : sans cette fonctionnalité, le produit résout-il encore le problème ? Si oui, ce n'est pas un *must*. Sois impitoyable — la plupart des idées sont des *should* ou des *could*.

**« Je suis parti d'une techno, pas d'un problème. »** « Je veux faire du Flutter » n'est pas un projet. Reformule en problème réel : qui galère, avec quoi ? La techno viendra après, au service du problème.

**« Mon périmètre enfle en cours de route (scope creep). »** « Tant qu'on y est, ajoutons… » : chaque ajout repousse la livraison. Note l'idée dans les *should/could*, et **livre d'abord le must**. Dire « plus tard » protège le projet.

**« Je ne sais pas si c'est fini. »** Pas de critères d'acceptation. Pour chaque story, écris « c'est fini quand… » **avant** de coder. Sinon, on bricole indéfiniment.

**« Mon produit veut servir tout le monde. »** Cible trop large = produit flou. Choisis **une** cible précise. Un produit qui résout parfaitement le problème de peu de gens vaut mieux qu'un produit qui résout vaguement celui de tous.

---

## Ce qu'on te demandera

En **entretien**, on sonde ta capacité à penser produit, pas seulement code : « parle-moi d'un projet : quel problème résolvait-il, pour qui ? », « comment as-tu décidé quoi construire en premier ? », « qu'as-tu choisi de **ne pas** faire ? ». Un candidat qui raconte un produit cadré (problème, cible, must-have, itérations) impressionne bien plus que celui qui liste des technos.

On peut demander : « qu'est-ce qu'une user story ? », « comment priorises-tu ? » (MoSCoW, valeur/effort), « comment gères-tu un périmètre qui enfle ? ».

En **mission/stage**, on attend que tu saches recevoir un problème, le découper, estimer, et proposer un périmètre — pas seulement exécuter des tickets.

---

## Ce qui te démarquera

**Livrer petit et fini, plutôt que grand et inachevé.** C'est la compétence la plus rare et la plus décisive. Un projet fini, en ligne, qui résout un vrai problème, bat dix projets à moitié. Savoir cadrer serré pour livrer est ce qui te distingue d'un débutant qui éparpille.

**Partir d'un problème réel.** Un produit né d'une vraie douleur (la tienne, celle d'un proche) se raconte, se teste, se défend. « J'ai résolu le problème de recomptage de présences de l'asso X » est infiniment plus fort que « j'ai fait une CRUD app ».

**Assumer les *won't have*.** Dire clairement ce que le produit ne fait **pas**, et pourquoi, montre que tu sais prioriser et protéger un périmètre — une maturité produit que peu de développeurs juniors ont.

**Et penser produit, pas seulement code.** Comprendre les user stories, le MoSCoW, la valeur, te sort du rôle d'exécutant. Les développeurs qui comprennent le « pourquoi » du produit sont ceux qu'on écoute et qu'on fait évoluer.

---

## 📚 À lire

**Tes templates** `mini-cadrage`, `user-stories`, `cahier-des-charges` : relis-les, ils sont faits pour cette leçon.

**Le concept de MVP (*Minimum Viable Product*)** : la plus petite version qui apporte de la valeur et qu'on peut mettre entre les mains d'utilisateurs. Beaucoup de ressources courtes en ligne ; retiens l'idée « livrer pour apprendre », pas « livrer parfait ».

**Les user stories (Mike Cohn, *User Stories Applied* — résumés en ligne)** : le format et les critères d'acceptation, par la référence du sujet.

**MoSCoW (méthode de priorisation)** : une page suffit pour comprendre les quatre catégories et leur usage.

Relis le palier 7, leçon 02 (YAGNI, KISS) : le MoSCoW en est l'application au niveau produit — ne construis que ce dont le produit a besoin pour exister.

---

## 🤖 Le mini-projet à demander à l'IA

Cadrer ton produit final, sans te laisser emporter :

> « Je suis en formation de développeur, palier 10 (projet final). Je dois cadrer mon produit final à partir d'un problème réel, et le principe est : il doit exister vite, pas être parfait. Sans décider à ma place, aide-moi par questions : me faire partir d'un VRAI problème (pas d'une techno), identifier une cible PRÉCISE, et écrire un mini-cadrage d'une page (problème, cible, valeur, périmètre, critère de succès). À chaque fois que je pars d'une techno ou que ma cible est "tout le monde", reprends-moi. »

Puis la priorisation impitoyable :

> « Aide-moi à découper mon produit en user stories (en tant que... je veux... afin de...) avec des critères d'acceptation, puis à les trier en MoSCoW. Sois IMPITOYABLE sur le must-have : pour chaque fonctionnalité que je classe "must", demande-moi "sans ça, le produit résout-il encore le problème ?" — et si oui, rétrograde-la en should. Aide-moi à définir la plus petite version livrable, et à écrire explicitement mes won't-have (ce que je ne ferai PAS pour la v1). Rappelle-moi que le must-have livré = projet fini. »

---

## 🛠️ À faire

1. **⭐ Choisir un problème réel** : identifie un vrai problème, pour une cible précise (toi, un proche, une petite structure locale). Écris-le en une phrase, en partant du **problème**, pas d'une techno.
2. **Le mini-cadrage** : remplis ton template `mini-cadrage` — problème, cible (précise !), valeur, périmètre (ce que ça fait / ne fait pas), critère de succès.
3. **Les user stories** : découpe le besoin en user stories « en tant que… je veux… afin de… », chacune avec un critère d'acceptation (« c'est fini quand… »).
4. **⭐ Le MoSCoW** : trie tes stories en must / should / could / won't. Pour chaque *must*, vérifie : « sans ça, le produit résout-il encore le problème ? » — sinon, rétrograde.
5. **⭐ Le must-have** : isole la plus petite version livrable (souvent 2-3 stories). C'est ton projet « fini ». Écris pourquoi elle suffit à résoudre le problème.
6. **Les won't-have** : écris explicitement ce que tu ne feras **pas** pour la v1, et pourquoi. Assume-les.
7. **Le cahier des charges** : si ton projet vise un client/stage, rédige un mini cahier des charges (ton template), en insistant sur le hors-périmètre. Sinon, note pourquoi le mini-cadrage suffit.
8. **Le pitch** : résume ton produit en une phrase (« ça aide [cible] à [bénéfice] en [comment] »). Vérifie qu'on comprend à quoi il sert sans explication. C'est la base de ta narration (leçon 04).
9. **Le lien** : dans ton journal, explique en quoi ton MoSCoW applique le YAGNI (palier 7) au niveau produit, et pourquoi « fini vaut mieux que parfait ».

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Partir d'un problème réel, pas d'une techno, est la décision fondatrice. « Je veux faire du Flutter » ne donne rien à raconter ni à défendre ; « les bénévoles de l'asso X perdent du temps à recompter les présences » donne un produit qu'on peut tester auprès de vrais gens et présenter en entretien. Et la cible doit être **précise** : un produit pour « tout le monde » est un produit flou pour personne. Résoudre parfaitement le problème de peu de gens bat résoudre vaguement celui de tous.

**4-6.** Le cœur du palier. Le must-have est **la plus petite version qui résout vraiment le problème** — presque toujours plus petit qu'on ne croit. Le test impitoyable : « sans cette fonctionnalité, le produit résout-il encore le problème ? » ; si oui, ce n'est pas un *must*. Et écrire les **won't-have** (ce qu'on ne fait pas) est aussi important que les must : ça protège le périmètre contre le *scope creep* et clarifie l'intention. C'est le YAGNI du palier 7 (leçon 02) monté au niveau produit : ne construis que ce dont le produit a besoin pour exister.

**5 + 9.** « Un must-have livré est un projet fini. » C'est le message répété du palier, et la compétence la plus décisive. Un petit produit fini, en ligne, qui résout un vrai problème, vaut infiniment plus qu'un grand produit à 80 % que personne ne voit — pour ton portfolio (leçon 04), tes entretiens (leçon 05), ta crédibilité (leçon 06). Le piège mortel du débutant est le perfectionnisme qui empêche de livrer. Cadrer serré pour **sortir** est ce qui te distingue.

**8.** Le pitch en une phrase (« ça aide [cible] à [bénéfice] en [comment] ») est le test ultime du cadrage : si tu ne peux pas le dire en une phrase claire, le produit n'est pas encore cadré. Cette phrase deviendra l'ouverture de ton portfolio (leçon 04) et de ta démo d'entretien (leçon 05). Un produit bien cadré se raconte ; un produit flou laisse perplexe.
</details>

---

## ✅ Acquis si…

- [ ] Je pars d'un problème réel et d'une cible précise, pas d'une techno ni de « tout le monde ».
- [ ] Je remplis un mini-cadrage (problème, cible, valeur, périmètre, succès) en une page.
- [ ] Je découpe le besoin en user stories avec des critères d'acceptation.
- [ ] Je priorise en MoSCoW et je teste chaque *must* (« sans ça, est-ce résolu ? »).
- [ ] Je définis le plus petit must-have livrable et je sais pourquoi il suffit.
- [ ] J'écris explicitement mes won't-have et je protège mon périmètre.
- [ ] Je résume mon produit en une phrase claire (le pitch).
- [ ] Je comprends que « un must-have livré est un projet fini » et que fini bat parfait.

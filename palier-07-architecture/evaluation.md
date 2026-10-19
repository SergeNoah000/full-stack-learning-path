# ✅ Épreuve de sortie — Palier 7

> **Ce palier s'évalue surtout à l'oral** : l'architecture est un métier de justification. Un choix qu'on ne sait pas défendre n'est pas un choix, c'est une imitation.
> **Conditions** : seul, sans notes pour les parties orales. IA en sparring partner autorisée **avant** l'épreuve, pas pendant.
> **Durée** : ~3 h + 1 h avec le référent. **Seuil** : 4/4 épreuves · **14/20** au quiz · les deux livrables du palier.

---

## Partie A — Épreuves

### A1 — La défense orale (30 min, sans notes, devant le référent)
1. **Dessine au tableau** l'architecture d'une application web classique : client → reverse proxy → API ×N → cache → base de données (+ file de tâches). Explique le rôle de chaque brique.
2. Défends ton document d'architecture : le référent joue le comité et cherche les failles.
3. Réponds à trois questions imposées :
   - « Ton système tombe le jour des résultats. Déroule le diagnostic. »
   - « Pourquoi pas des microservices ? »
   - « Qu'est-ce qui casse en premier à 10 000 utilisateurs ? »

✅ **Réussi si** : schéma dessiné de mémoire, et chaque choix justifié par une **contrainte**, jamais par une préférence.

### A2 — Justifier ses propres projets (30 min)
Pour chacun de tes projets 4, 5 et 6 :
- justifie chaque choix technique majeur (stack, base, auth, structure)
- nomme **au moins deux choses que tu referais autrement**, et pourquoi
- identifie la dette technique assumée et son coût futur

✅ **Réussi si** : tu défends sans justifier à tout prix — reconnaître une erreur de conception compte autant que défendre une bonne décision.

### A3 — Le refactoring (preuve par les commits)
- [ ] liste des défauts écrite **avant** le refactoring
- [ ] ≥ 8 commits de refactoring, chacun nommant le principe appliqué
- [ ] tests au vert à chaque étape, comportement identique
- [ ] bilan avant/après chiffré dans le README
- [ ] un défaut volontairement **non corrigé**, avec sa justification (YAGNI)

✅ **Réussi si** : l'historique Git prouve une démarche progressive, pas une réécriture.

### A4 — Lecture critique (30 min)
On te donne un extrait de code (ou reprends un de tes anciens fichiers) :
1. nomme les principes SOLID violés, et où précisément
2. propose un refactoring, en pseudo-code
3. identifie un cas où appliquer DRY **nuirait** (couplage de deux choses qui se ressemblent par hasard)
4. identifie un pattern déjà présent sans le savoir

✅ **Réussi si** : les violations sont nommées précisément et le contre-exemple DRY est pertinent.

---

## Partie B — Quiz (20 questions)

**Principes**
1. Énonce S, O et D de SOLID, avec **un exemple de ton code** pour chacun.
2. Qu'est-ce que le « mauvais DRY » ? Donne un exemple concret.
3. YAGNI : donne un cas où tu l'as appliqué, et un cas où tu l'as violé.
4. Qu'est-ce que l'inversion de dépendances ? Pourquoi facilite-t-elle les tests ?
5. Pourquoi un refactoring doit-il se faire par petits commits avec des tests ?
6. Qu'est-ce que la dette technique ? Quand est-elle un bon investissement ?

**Patterns**
7. Repository : quel problème résout-il ? Où l'as-tu déjà écrit sans le nommer ?
8. Strategy : à quoi ça sert ? Donne un cas dans un de tes projets.
9. Observer : où l'as-tu croisé dans tes trois stacks ?
10. Factory : quel problème résout-elle ?

**Architecture de systèmes**
11. Pourquoi commence-t-on (presque) toujours par un **monolithe modulaire** ?
12. Quels problèmes les microservices **créent**-ils ? Cite-en trois.
13. REST vs file d'attente : comment choisis-tu ? Donne un cas pour chacun.
14. Où peut-on cacher (4 niveaux) ? Quel est le vrai problème du cache ?
15. Qu'est-ce que l'idempotence ? Pourquoi est-ce vital pour un paiement ?
16. Pourquoi paginer ? Qu'est-ce qui casse sans pagination ?
17. À quoi sert le rate limiting ? Contre quoi protège-t-il ?
18. Qu'est-ce que le *statelessness* ? Pourquoi est-ce la condition de la scalabilité horizontale ? Quel lien avec le modèle d'exécution de PHP ?
19. Vertical vs horizontal : avantages, limites, et coût de chacun.
20. Les 4 signaux à surveiller (préparation palier 8) ? Que signifie chacun ?

<details>
<summary>Corrections — points clés</summary>

1. **S** (responsabilité unique) : une classe/fonction a une seule raison de changer — ton contrôleur qui faisait validation + SQL + affichage en violait trois. **O** (ouvert/fermé) : on étend sans modifier — ajouter un moyen de paiement sans toucher au code existant (→ Strategy). **D** (inversion de dépendances) : le métier dépend d'une **abstraction**, pas de l'implémentation — ton service parle à une interface de dépôt, pas à Prisma.
2. Factoriser deux bouts de code qui se **ressemblent** sans partager la même raison de changer : au premier besoin divergent, on ajoute un paramètre, puis un `if`, et on obtient une fonction couplée que personne n'ose toucher. **Le vrai DRY porte sur la connaissance, pas sur les caractères.**
3. Applications typiques : ne pas construire de système de plugins « au cas où ». Violations typiques : une couche d'abstraction sur la base « pour pouvoir changer de SGBD » — changement qui n'arrive jamais.
4. Faire dépendre le code métier d'une interface, l'implémentation étant fournie de l'extérieur. Pour les tests : on injecte un faux dépôt en mémoire, sans base de données, donc des tests rapides et déterministes.
5. Parce que sans tests, « sans changer le comportement » est une croyance. Et parce qu'un gros commit de refactoring est impossible à relire et à annuler sélectivement.
6. L'ensemble des raccourcis dont le coût est reporté. Bon investissement quand la vitesse de livraison a plus de valeur **maintenant** (validation d'un marché, échéance), **à condition** de l'écrire noir sur blanc. Mauvaise quand elle est involontaire ou tue.
7. Isoler l'accès aux données derrière une interface métier : le domaine ne connaît ni SQL ni ORM. Tu l'as écrit **à la main** dans ton MVC PHP (palier 6) et dans la couche modèles de ton mini-framework Python (palier 5).
8. Rendre un algorithme interchangeable à l'exécution. Cas : plusieurs moyens de paiement, plusieurs stratégies de calcul de frais, plusieurs formats d'export.
9. Les **événements Laravel**, les signaux Django, les gestionnaires d'événements du DOM, les écouteurs de `EventEmitter` en Node. Le même pattern, quatre noms.
10. Centraliser la **construction** d'objets complexes, pour que le reste du code n'ait pas à connaître les détails d'assemblage (ni à changer quand ils évoluent).
11. Parce que les frontières du domaine ne sont connues qu'après coup. Un monolithe modulaire est simple à déployer, à déboguer et à tester, et se découpe plus tard **là où le besoin apparaît**. Découper trop tôt, c'est figer de mauvaises frontières.
12. Latence réseau entre services, cohérence distribuée (plus de transaction unique), complexité opérationnelle (déploiements, observabilité, versions d'API), et un coût humain : il faut une équipe par service.
13. REST quand l'appelant a besoin de la réponse **tout de suite**. File quand le traitement est long, peut échouer et être rejoué, ou doit absorber un pic (emails, exports, notifications, paiements à confirmer).
14. Navigateur (cache HTTP), CDN, applicatif (Redis), base (plan de requête, buffers). Le vrai problème n'est pas de cacher : c'est **l'invalidation** — savoir quand la donnée en cache est devenue fausse.
15. Rejouer la même opération produit le même état final. Vital pour un paiement : un réseau coupé, un bouton cliqué deux fois ou un retry automatique ne doivent pas débiter deux fois. Mise en œuvre : clé d'idempotence fournie par le client.
16. Parce qu'un `SELECT *` sur une table qui grandit finit par saturer mémoire, réseau et navigateur. Sans pagination, la réponse croît linéairement avec les données : l'API fonctionne en démo et meurt en production.
17. Limiter le nombre de requêtes par client. Protège contre l'abus, le scraping, le bourrage d'identifiants, et le simple bug de boucle d'un client qui saturerait le service pour tous.
18. Le serveur ne conserve aucun état entre deux requêtes. C'est ce qui permet d'en ajouter dix derrière un répartiteur de charge sans se soucier de « quel serveur a ma session ». PHP est stateless **par construction** (tout meurt à la fin de la requête) — ce qui en fait un modèle horizontalement scalable par défaut, et c'est exactement ce que Node doit discipliner.
19. Vertical : grossir la machine — simple, immédiat, mais plafonné et avec un point unique de défaillance. Horizontal : multiplier les machines — extensible et résilient, mais exige le statelessness, un répartiteur, et une base qui suit (le vrai goulot).
20. **Latence** (temps de réponse), **trafic** (volume de requêtes), **erreurs** (taux de 5xx), **saturation** (CPU, mémoire, disque, connexions). Ensemble, ils répondent à « est-ce lent, est-ce chargé, est-ce cassé, va-t-on tenir ? ».

**Score** : ____ /20
</details>

---

## Partie C — Livrables

- [ ] [Refactoring du projet 4](projet.md#livrable-1--le-refactoring-du-projet-4) commité, tests au vert, bilan chiffré.
- [ ] [Document d'architecture](projet.md#livrable-2--le-document-darchitecture) v1.1, après les deux cribles ([template](../templates/document-architecture.md)).
- [ ] Comparatif final **Express vs Django vs Laravel** rempli (tableau du [README](README.md)).
- [ ] Coûts d'infrastructure estimés du système conçu (entrée du palier 8).
- [ ] `journal.md` · [rétrospective](../templates/retrospective-palier.md).
- [ ] 🧑‍🏫 Référent : comité d'architecture (30 min) **et** son récit d'une vraie décision d'architecture de sa carrière — note-la, ça vaut un livre.

---

## Résultat

| Partie | Seuil | Résultat |
|--------|-------|----------|
| A — Épreuves (dont oral) | 4/4 | ⬜ |
| B — Quiz | 14/20 | ⬜ ___/20 |
| C — Livrables | tout coché | ⬜ |

**Date** : ______ · **Verdict** : ⬜ validé ⬜ à repasser le ______ · [ ] reporté dans [../progression.md](../progression.md)

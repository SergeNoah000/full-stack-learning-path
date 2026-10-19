# 🛠️ Projet du palier 7 — Document d'architecture + refactoring

> Ce palier n'a pas d'application à coder : ses deux livrables sont **un refactoring** (du code existant, amélioré) et **un document** (une conception, défendue). Ce sont des livrables de métier à part entière — et des formats d'entretien.

---

## Livrable 1 — Le refactoring du projet 4

> **L'exercice le plus formateur du parcours** : reprendre son propre code avec les yeux d'aujourd'hui.

### Brief
Reprends le **projet 4** (API Node) et améliore sa structure **sans changer son comportement**.

### Déroulé imposé
- [ ] 1. **Avant de toucher au code** : liste écrite des défauts constatés (une ligne par défaut, classés par gravité).
- [ ] 2. Vérifie que les **tests passent** — ils sont ton filet de sécurité. S'il n'y en a pas assez, écris-en d'abord.
- [ ] 3. Refactorise **par petits commits**, un défaut à la fois, tests au vert après chacun.
- [ ] 4. Pour chaque commit : le message dit **quel** principe est appliqué (`refactor: extract payment service (SRP)`).
- [ ] 5. Bilan : avant/après sur 3 mesures (taille du plus gros fichier, nombre de responsabilités par module, dépendances entre couches).

### Contraintes
- **Aucun changement de comportement** : les tests sont la preuve. Si un test doit changer, c'est que tu modifies le comportement — arrête-toi et justifie.
- Pas de réécriture complète : du refactoring, pas un nouveau projet.
- Timebox : 3 jours maximum.

### Définition de « fini »
- [ ] Tests au vert, comportement identique
- [ ] Au moins 8 commits de refactoring, chacun justifié par un principe
- [ ] Le bilan avant/après est écrit dans le README du projet
- [ ] Au moins un **défaut assumé non corrigé**, avec sa raison (YAGNI : tout ne mérite pas d'être corrigé)

---

## Livrable 2 — Le document d'architecture

### Brief
Conçois, sur le papier, un **système réel de ton contexte**. Au choix :
1. un système de **paiement mobile money** (intégration MTN MoMo / Orange Money) ;
2. une **plateforme de résultats d'examens** (pic de charge extrême le jour J — cas d'école) ;
3. une plateforme de commande/livraison locale.

Utilise le [template](../templates/document-architecture.md).

### Contenu attendu
- [ ] Contexte et **contraintes chiffrées** (charge, réseau, budget, équipe)
- [ ] Exigences non fonctionnelles **mesurables** (latence cible, disponibilité, volumétrie, RPO/RTO)
- [ ] Le **schéma**, que tu dois savoir redessiner de mémoire
- [ ] **Choix de stack justifié parmi tes trois** — et pourquoi pas les deux autres (le tableau comparatif est le cœur du document)
- [ ] Modèle de données
- [ ] Points de défaillance, parades, et **dégradation acceptée** pour chacun
- [ ] Sécurité
- [ ] Plan d'évolution **10 → 1 000 → 10 000 utilisateurs**, avec ce qui casse en premier à chaque palier
- [ ] Ce qu'on **ne fait pas** tout de suite, et pourquoi (le sur-dimensionnement précoce est une faute d'architecture)
- [ ] Coûts d'infrastructure estimés à chaque palier de charge (préparation du palier 8)
- [ ] Décisions actées (ADR court) et questions ouvertes

### Le double crible (obligatoire)
- [ ] **L'IA en interviewer system design** : « joue l'interviewer, cherche les failles de mon document, pose-moi des questions difficiles ».
- [ ] **Le référent en comité d'architecture** : 30 minutes de questions. Note **ce que tu n'as pas su défendre** — c'est la partie utile de l'exercice.
- [ ] Version 1.1 du document, corrigée après les deux cribles, avec un journal des changements.

### Définition de « fini »
- [ ] Document complet, versionné dans un repo
- [ ] Schéma dessiné et **défendu à l'oral en 20 minutes, sans notes**
- [ ] Les deux cribles passés, corrections intégrées
- [ ] Le comparatif final des 3 stacks (tableau du [README](README.md)) est rempli de ta main

---

## Pourquoi ces deux livrables comptent pour l'emploi

| Livrable | Ce qu'il prouve à un recruteur |
|----------|-------------------------------|
| Refactoring commité | que tu sais améliorer du code existant **sans le casser** — c'est 80 % du travail réel en entreprise |
| Document d'architecture | que tu sais **décider et justifier**, pas seulement exécuter |
| Comparatif des 3 stacks | profil rare : tu as pratiqué trois écosystèmes, tu peux conseiller au lieu de suivre |

Garde les deux documents : ils resserviront **tels quels** en entretien (palier 10, module 3).

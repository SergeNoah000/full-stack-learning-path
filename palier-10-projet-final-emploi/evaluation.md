# ✅ Épreuve de sortie — Palier 10 (et du parcours)

> **La dernière épreuve n'est pas technique : c'est une épreuve de preuve.** Tout doit être démontrable à un inconnu en moins de 10 minutes.
> **Conditions** : seul. IA autorisée au niveau 10 (agents sur des tâches entières), mais **tu es l'architecte et le relecteur de chaque diff** — et tu dois savoir expliquer chaque ligne livrée.
> **Seuil** : 5/5 épreuves · **16/20** au quiz · le produit en production avec de **vrais utilisateurs** · 2 simulations d'entretien réussies.

---

## Partie A — Épreuves

### A1 — La démo de 5 minutes (rodée, chronométrée)
Devant le référent (puis devant quelqu'un qui n'est pas développeur) :
1. le **problème** et pour qui (45 s)
2. la **démo live** du parcours principal (2 min 30)
3. **un** choix technique défendu — et pourquoi pas l'alternative (1 min)
4. **une** difficulté réelle surmontée (45 s)

✅ **Réussi si** : tenu en 5 minutes ± 30 s, sans notes, sans plantage, et compréhensible par un non-technicien.

### A2 — Le produit en production (preuve par l'usage)
- [ ] accessible publiquement : **domaine + HTTPS**
- [ ] **de vrais utilisateurs** (≥ 5 hors de ta famille proche), avec des traces d'usage
- [ ] monitoring actif et alerte configurée
- [ ] sauvegardes automatisées **et une restauration déjà testée**
- [ ] pipeline CI/CD opérationnel
- [ ] web **et** mobile, parlant à la même API
- [ ] une fonctionnalité IA en service, clé côté serveur
- [ ] un incident réel (ou simulé) diagnostiqué et documenté

✅ **Réussi si** : un inconnu peut utiliser le produit sans ton aide, et tu peux montrer les tableaux de bord.

### A3 — Le cycle de gestion de projet complet
Les 7 étapes, documentées dans `docs/` :
1. conception · 2. [cahier des charges](../templates/cahier-des-charges.md) · 3. [chiffrage](../templates/devis.md) avec **ta vélocité mesurée** · 4. planification en jalons · 5. suivi hebdomadaire (kanban) · 6. [recette](../templates/cahier-de-recette.md) · 7. **bilan estimé vs réel ligne par ligne**

✅ **Réussi si** : les 7 documents existent, datés dans l'ordre (vérifiable dans Git), et le bilan donne ton **coefficient d'estimation final**.

### A4 — Les entretiens techniques (avec le référent)
- [ ] **2 entretiens complets** en conditions réelles (technique + RH), débriefés
- [ ] algo : un Codewars **6 kyu** résolu seul en moins de 40 min, à voix haute
- [ ] une révision ciblée réussie sur chacun des 6 thèmes : JS/TS, React, SQL, un framework backend, HTTP/sécurité, Docker/CI
- [ ] la question « comment utilises-tu l'IA ? » traitée en 1 minute, de façon convaincante

✅ **Réussi si** : les deux simulations sont jugées « embauchable en junior » par le référent, avec ses réserves écrites.

### A5 — Le portfolio (les 90 secondes du recruteur)
- [ ] **site portfolio** en ligne (1 page suffit, GitHub Pages — la boucle est bouclée)
- [ ] 3 projets maximum, format « problème → solution → stack **et pourquoi** → lien live → code »
- [ ] GitHub : README de profil, **4 repos épinglés couvrant tes 4 langages** (JS/TS, Python, PHP, Dart), chacun avec capture et lien live
- [ ] CV **d'une page**, orienté projets et résultats — pas une liste de technologies
- [ ] LinkedIn à jour, avec l'argument central : **polyglotte + DevOps + gestion de projet**

✅ **Réussi si** : une personne extérieure, en 90 secondes sur ton GitHub, peut dire ce que tu sais faire.

---

## Partie B — Quiz (20 questions) — format entretien

> Réponds **à voix haute**, comme en entretien, puis vérifie.

1. Présente-toi en 90 secondes (parcours, ce que tu sais faire, ce que tu cherches).
2. Raconte ton projet le plus intéressant : problème, solution, difficulté.
3. Pourquoi cette stack pour ce projet, et pourquoi pas les deux autres que tu connais ?
4. Explique l'event loop, et pourquoi un calcul long gèle une page.
5. Explique les closures avec un exemple.
6. Qu'est-ce qu'une injection SQL ? Montre-la, et donne la parade.
7. Sessions vs JWT : que choisis-tu pour une app mobile, et pourquoi ?
8. Explique un `JOIN` et donne un cas où une `LEFT JOIN` est indispensable.
9. À quoi sert un index ? Que coûte-t-il ?
10. Qu'est-ce qu'un problème N+1 ? Comment le détectes-tu ?
11. `useState` vs `useEffect` vs TanStack Query : quel outil pour quel problème ?
12. Qu'est-ce que Docker résout, concrètement, dans ton expérience ?
13. Décris ton pipeline CI/CD et ce qui empêche un déploiement cassé.
14. Le site est down. Déroule ton diagnostic.
15. Comment estimes-tu une tâche ? Quel est ton coefficient réel, et comment l'as-tu obtenu ?
16. Un client change d'avis en cours de projet. Que fais-tu ?
17. Comment utilises-tu l'IA ? Donne un cas où tu l'as ignorée parce qu'elle avait tort.
18. Quelle a été ta plus grosse erreur technique, et qu'en as-tu appris ?
19. Qu'est-ce que tu ne sais pas encore faire et que tu veux apprendre ?
20. As-tu des questions pour nous ? *(Prépares-en trois, vraies.)*

<details>
<summary>Grille d'auto-évaluation</summary>

Une réponse vaut 1 point si elle est : **concrète** (un exemple de **ton** code, pas une définition de cours), **honnête** (les limites assumées valent mieux qu'une affirmation fausse), et **courte** (1 à 2 minutes, puis on laisse l'autre relancer).

Points d'attention fréquents chez les juniors :
- **Q3, Q12, Q15, Q16** : ce sont tes **questions différenciantes**. Très peu de juniors ont pratiqué trois stacks, dockerisé trois runtimes, mesuré leur vélocité et affronté un changement de périmètre. Ne les survole pas.
- **Q18** : ne réponds jamais « je n'en vois pas ». Une vraie erreur racontée avec sa leçon est un signal de maturité.
- **Q19** : nomme quelque chose de précis et utile au poste, pas « tout m'intéresse ».
- **Q20** : sans questions, tu passes pour indifférent. Prépare : l'organisation de l'équipe, les pratiques de revue de code, ce qu'on attendrait de toi à 3 mois.
- **Q17** : la réponse attendue est le fil rouge de ce parcours — tu sais coder sans, tu es productif avec, et tu ne commites rien que tu ne saurais réécrire.

**Score** : ____ /20
</details>

---

## Partie C — Livrables du parcours

- [ ] [Projet 8](projet.md) en production : vrais utilisateurs, monitoring, sauvegardes testées.
- [ ] Cycle de gestion de projet documenté de bout en bout, **bilan estimé/réel** rédigé.
- [ ] Portfolio en ligne · GitHub 4 langages · CV 1 page · LinkedIn à jour.
- [ ] 2 simulations d'entretien réussies avec le référent.
- [ ] **Première candidature / première offre de mission envoyée.** 🚀
- [ ] [../progression.md](../progression.md) complété : les 11 paliers à ✅, tous les projets avec leurs URL.
- [ ] [Rétrospective finale](../templates/retrospective-palier.md) — et une version « bilan du parcours » : ce que tu sais faire aujourd'hui que tu ne savais pas faire il y a 18 mois.

---

## Résultat

| Partie | Seuil | Résultat |
|--------|-------|----------|
| A — Épreuves | 5/5 | ⬜ |
| B — Quiz entretien | 16/20 | ⬜ ___/20 |
| C — Livrables | tout coché | ⬜ |

**Date** : ______ · **Verdict** : ⬜ **parcours validé** ⬜ à repasser le ______

---

## 🎓 Et après ?

Le métier s'apprend en le faisant. Le parcours s'arrête ici, pas l'apprentissage :
- approfondir **une** stack en fonction du premier poste (c'est le poste qui décide, pas la mode) ;
- certifications cloud **si** l'employeur les valorise ;
- contribution open source : un bon `good first issue` sur un outil que tu utilises déjà ;
- **mentorer à ton tour un débutant** — rien ne consolide mieux ;
- et garder les rituels qui ont marché : l'objectif écrit, le journal, les katas, la rétrospective.

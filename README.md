# 🎓 Apprentissage — Développeur Fullstack Polyglotte

Bienvenue dans ton dossier de formation. Tout le parcours est ici : un dossier par palier, des fils rouges transversaux, et une méthode de travail.

## 📂 Structure du dossier

```
apprentissage/
├── README.md                        ← tu es ici (méthode + mode d'emploi)
├── learning-path.md                 ← vue d'ensemble du parcours (l'ordre et le pourquoi)
├── methode-et-referent.md           ← les 4 piliers : autodidaxie, IA, web, référent
├── gestion-de-projet.md             ← fil rouge : conception, cahier des charges, coûts, suivi
├── deploiements.md                  ← quelle plateforme pour quel projet, et pourquoi
├── questions-referent.md            ← journal des questions pour le senior
└── palier-XX-.../                   ← un dossier par palier :
    ├── README.md                    ← plan détaillé du palier (modules, ressources, checkpoint)
    ├── projet.md                    ← brief du projet jalon (si le palier en a un)
    └── journal.md                   ← ton carnet de bord du palier
```

## 🧭 Mode d'emploi

1. **Lis [learning-path.md](learning-path.md)** pour comprendre l'ordre des paliers et la logique globale.
2. **Travaille un palier à la fois**, dans l'ordre. Ouvre son `README.md`, suis les modules, remplis `journal.md` à chaque session.
3. **Le checkpoint est une barrière.** Tant que toutes les cases ne sont pas cochées honnêtement, tu ne passes pas au palier suivant. Pas de négociation — c'est ce qui garantit des fondations solides.
4. **Chaque projet jalon suit son `projet.md`** : brief, livrables de gestion de projet, cible de déploiement, définition de "fini".
5. **Ton code ne vit PAS ici.** Ce dossier contient la formation (plans, notes, journaux, cahiers des charges). Le code va dans des repos Git séparés (ex. `~/dev/projet-meteo`), chacun poussé sur GitHub.

## 🛠️ La méthode : autodidacte outillé

Tu apprends seul, mais pas sans ressources. Quatre piliers, dans cet ordre de recours :

1. **Toi + la doc officielle** — le réflexe n°1. MDN, docs Python/PHP/Flutter. Lire la doc est une compétence qui s'entraîne.
2. **Le web** — tutoriels, Stack Overflow, articles. Règle anti-zapping : "1 tutoriel suivi → 1 variation personnelle construite".
3. **L'IA (Claude, ChatGPT, Copilot)** — ton tuteur permanent, selon le niveau du fil rouge IA du palier en cours (voir chaque README). Jamais de code généré non compris.
4. **Le référent (senior)** — l'humain. Pour les questions de fond, les revues de code des projets jalons, les choix de carrière, l'accès au VPS, et le besoin de parler à quelqu'un qui est passé par là. Protocole complet dans [methode-et-referent.md](methode-et-referent.md).

**La règle des 3 avant de solliciter le référent** : (1) j'ai cherché dans la doc/le web, (2) j'ai interrogé l'IA, (3) j'ai reformulé mon problème par écrit dans [questions-referent.md](questions-referent.md). Souvent, l'étape 3 résout le problème toute seule (effet canard en plastique 🦆).

## 📏 Les règles non négociables

- **80% pratique, 20% théorie.** Pas de nouveau cours tant que le précédent n'a pas produit du code.
- **Git dès le jour 1**, commits réguliers, messages propres. Ton GitHub est ton CV.
- **Régularité > intensité.** Sessions courtes et fréquentes avec un objectif écrit AVANT de commencer.
- **Anglais autant que possible** : doc, recherches, messages de commit.
- **Le journal se remplit à chaud**, pas en fin de semaine (2 min par session suffisent).
- **Timeboxer les projets.** Livrer un projet imparfait > polir un projet jamais fini.

## 🔁 Rituels

| Fréquence | Rituel |
|-----------|--------|
| Chaque session | Objectif écrit → travail → entrée dans `journal.md` |
| 2×/semaine | Kata d'algo (30 min) — Codewars/Exercism, dans le langage du palier en cours |
| Hebdo | Relire le journal, mettre à jour le kanban du projet en cours |
| Toutes les 2 semaines | Point référent (30–60 min) — préparé via `questions-referent.md` |
| Fin de palier | Checkpoint + rétrospective dans le journal : qu'est-ce que je referais autrement ? |

Bon courage 🚀 — commence par [palier-00-fondations/README.md](palier-00-fondations/README.md).

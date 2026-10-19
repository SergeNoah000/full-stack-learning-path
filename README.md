# 🎓 Apprentissage — Développeur Fullstack Polyglotte

Bienvenue dans ton dossier de formation. Tout le parcours est ici : un dossier par palier, des fils rouges transversaux, et une méthode de travail.

## 📂 Structure du dossier

```
apprentissage/
├── README.md                        ← tu es ici (méthode + mode d'emploi)
├── FORMAT-DES-LECONS.md             ← 🧱 comment une leçon est construite (et ce qu'elle t'apporte)
├── progression.md                   ← 📊 TON TABLEAU DE BORD : où j'en suis, un seul fichier à ouvrir
├── learning-path.md                 ← vue d'ensemble du parcours (l'ordre et le pourquoi)
├── methode-et-referent.md           ← les 4 piliers : autodidaxie, IA, web, référent
├── glossaire.md                     ← 📖 le vocabulaire du métier, expliqué simplement
├── ressources.md                    ← 📚 toutes les ressources, classées par palier
├── katas.md                         ← 🧩 le rituel algo : méthode, objectifs, registre
├── gestion-de-projet.md             ← fil rouge : conception, cahier des charges, coûts, suivi
├── deploiements.md                  ← quelle plateforme pour quel projet, et pourquoi
├── questions-referent.md            ← journal des questions pour le senior
├── guides/                          ← 🧭 procédures transversales (valables à tous les paliers)
│   ├── suivi-a-distance.md          ←    🛰️ LA CONSIGNE : ta branche, ton journal poussé
│   ├── methode-de-session.md        ←    ⭐ à lire AVANT la première session
│   ├── git-et-github.md             ←    clé SSH, workflow quotidien, réparer ses bêtises
│   ├── deboguer-methodiquement.md   ←    les 7 étapes, et quand s'arrêter
│   ├── lire-la-documentation.md
│   └── prompter-une-ia.md
├── scripts/                         ← 🛠️ outils du référent (lire les journaux à distance)
├── templates/                       ← 🧾 documents réutilisables (à copier dans tes projets)
│   ├── mini-cadrage.md · user-stories.md · cahier-des-charges.md
│   ├── cahier-de-recette.md · devis.md · document-architecture.md
│   └── readme-projet.md · retrospective-palier.md · bilan-estime-reel.md
└── palier-XX-.../                   ← un dossier par palier :
    ├── README.md                    ←    objectifs, leçons, fils rouges, checkpoint
    ├── lecons/                      ←    📘 LES LEÇONS (à faire dans l'ordre)
    ├── guides/                      ←    procédures propres au palier (si besoin)
    ├── projet.md                    ←    brief du projet jalon
    ├── evaluation.md                ←    ✅ L'ÉPREUVE DE SORTIE (c'est elle qui valide le palier)
    └── journal.md                   ←    ton carnet de bord du palier
```

### Les 4 types de documents, et ce que chacun fait

| Type | Où | À quoi ça sert |
|------|-----|----------------|
| **Leçon** | `palier-XX/lecons/` | **Comprendre et s'orienter** : ce que c'est, à quoi ça sert, **où ça intervient dans le développement**, ce que tu verras en solo et en équipe, les problèmes réels, ce qu'on te demandera en test, puis les exercices corrigés et les critères « Acquis si… ». Format détaillé : [FORMAT-DES-LECONS.md](FORMAT-DES-LECONS.md) |
| **Guide** | `guides/` et `palier-XX/guides/` | **Faire** quelque chose, étape par étape (installer, configurer, déployer, déboguer) |
| **Épreuve** | `palier-XX/evaluation.md` | **Vérifier** : épreuves pratiques sans aide + quiz + livrables. C'est la barrière du palier |
| **Template** | `templates/` | **Produire** un livrable professionnel (cadrage, devis, recette, architecture) |

> ⏳ **État de rédaction** : les leçons des **paliers 0 à 6** sont écrites. Pour les paliers suivants, le `lecons/README.md` de chaque palier donne le plan arrêté des leçons à venir — et **toutes les épreuves de sortie sont déjà complètes**. Tu peux donc travailler n'importe quel palier avec les modules de son README et ses ressources.

## 🧭 Mode d'emploi

1. **Avant tout, mets-toi en place** : lis [guides/suivi-a-distance.md](guides/suivi-a-distance.md) et crée **ta branche** (`apprenant/prenom`). C'est dans cette branche que tu travailleras, et c'est par elle que le référent suivra ton avancement. Puis lis [guides/methode-de-session.md](guides/methode-de-session.md) : c'est le guide qui dit quoi faire quand tu t'assois pour travailler — et ce qui fait la différence entre progresser et « avoir travaillé 3 h ».
2. **Lis [learning-path.md](learning-path.md)** pour comprendre l'ordre des paliers et la logique globale.
3. **Ouvre [progression.md](progression.md)** : c'est ton tableau de bord. Tu le mets à jour à chaque fin de leçon et à chaque checkpoint.
4. **Travaille un palier à la fois**, dans l'ordre. Dans son dossier : le `README.md` donne les objectifs et le plan, `lecons/` contient les leçons à faire dans l'ordre, `journal.md` se remplit à chaque session.
5. **L'épreuve de sortie est la barrière.** Chaque palier a son `evaluation.md` : épreuves pratiques sans aide, quiz, livrables. Tant qu'elle n'est pas réussie **honnêtement**, tu ne passes pas au palier suivant. Pas de négociation — c'est ce qui garantit des fondations solides.
6. **Chaque projet jalon suit son `projet.md`** : brief, livrables de gestion de projet, cible de déploiement, définition de « fini ».
7. **Un mot inconnu ?** [glossaire.md](glossaire.md) · **une ressource à trouver ?** [ressources.md](ressources.md) · **un bug qui résiste ?** [guides/deboguer-methodiquement.md](guides/deboguer-methodiquement.md).
8. **Ton code ne vit PAS ici.** Ce dossier contient la formation (plans, leçons, notes, journaux, cahiers des charges). Le code va dans des repos Git séparés (ex. `~/dev/projet-meteo`), chacun poussé sur GitHub.

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
- **Tu tapes tout toi-même** aux paliers 0 à 2, y compris les exemples des leçons. Le code qui passe par tes doigts est le seul qui entre en mémoire.
- **Une leçon ne se coche que si tous ses critères « Acquis si… » sont vrais.** Se mentir ici ne coûte rien aujourd'hui, et tout au palier 4.
- **Tu travailles dans ta branche, et tu pousses ton journal à la fin de chaque session.** Une entrée non poussée n'existe pas pour le référent → [la consigne](guides/suivi-a-distance.md).

## 🔁 Rituels

| Fréquence | Rituel |
|-----------|--------|
| Chaque session | Objectif écrit → travail → commit → entrée dans `journal.md` → **`git push`** ([méthode](guides/methode-de-session.md)) |
| 2×/semaine | Kata d'algo (30 min) — méthode et registre dans [katas.md](katas.md) |
| Hebdo | Relire le journal, mettre à jour [progression.md](progression.md) et le kanban · récupérer les mises à jour du parcours (`merge main`) |
| Toutes les 2 semaines | Point référent (30–60 min) — préparé via `questions-referent.md` |
| Fin de palier | **Épreuve de sortie** (`evaluation.md`) + [rétrospective](templates/retrospective-palier.md) |

---

Bon courage 🚀

**Commence ici** : [la consigne de suivi](guides/suivi-a-distance.md) (crée ta branche) → [la méthode de session](guides/methode-de-session.md) → [installer son environnement](palier-00-fondations/guides/installer-son-environnement.md) → [palier 0](palier-00-fondations/README.md).

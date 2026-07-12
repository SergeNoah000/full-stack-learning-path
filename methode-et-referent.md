# 🧑‍🏫 Méthode de travail & rôle du référent

## Les 4 piliers de l'autodidaxie outillée

### 1. Toi + la documentation officielle
Le réflexe de base du métier. Un développeur professionnel passe sa journée dans la doc.
- Frontend : **MDN** (developer.mozilla.org) — la bible.
- Python : docs.python.org + doc du framework (Flask/FastAPI/Django).
- PHP : php.net (les commentaires utilisateurs sont une mine) + laravel.com/docs.
- Flutter : docs.flutter.dev + pub.dev pour les packages.
- Entraîne-toi à lire une page de doc AVANT de chercher un tutoriel.

### 2. Le web
- **Tutoriels** : The Odin Project, freeCodeCamp, javascript.info, chaînes YouTube (Traversy Media, Net Ninja, Grafikart en français…).
- **Stack Overflow** : apprends à y chercher (message d'erreur exact entre guillemets) avant d'y poster.
- **Règle anti-enfer-des-tutoriels** : après chaque tutoriel suivi, construis une variation personnelle sans le tutoriel. Sinon tu n'as rien appris, tu as regardé quelqu'un apprendre.

### 3. L'IA
Ton tuteur disponible 24/7 — mais son usage est **gradué par palier** (voir le fil rouge IA dans chaque README de palier). Résumé de la progression :

| Paliers | Rôle de l'IA | Interdit |
|---------|--------------|----------|
| 0–1 | Tuteur : explications, indices | Générer du code |
| 2 | Relecteur : code review après coup | Produire avant toi |
| 3 | Autocomplétion (Copilot) sur le boilerplate | Accepter une ligne non comprise |
| 4 | Binôme de conception + génération de tests | Décider de l'architecture à ta place |
| 5–6 | Accélérateur de langues ("l'équivalent en Python/PHP de…") | Sauter l'apprentissage natif |
| 7–8 | Sparring partner (archi, infra) | Coller une commande système non comprise |
| 9–10 | Brique produit (API IA dans tes apps) | — |

Prompts types qui marchent :
- « Voici mon erreur + mon code : explique-moi la CAUSE sans me donner la solution. »
- « Donne-moi un indice, pas la réponse. »
- « Critique ma solution : lisibilité, bugs, cas limites oubliés. »
- « Pose-moi 5 questions d'entretien sur [sujet] et corrige mes réponses. »

### 4. Le référent (senior)
L'humain du dispositif. Il ne remplace ni la doc ni l'IA — il apporte ce qu'elles n'ont pas : l'expérience, le recul, le regard sur TOI, et l'accès à de vraies ressources (VPS, réseau).

## 📋 Protocole référent

### Le rituel : point toutes les 2 semaines (30–60 min)
Ordre du jour type :
1. **Démo** : montrer ce qui a été construit (même petit, même cassé).
2. **Questions préparées** : celles accumulées dans `questions-referent.md` qui ont survécu à la règle des 3.
3. **Déblocages de fond** : les points où tu tournes en rond depuis plus d'une semaine.
4. **Cap** : valider (ou pas) le passage de checkpoint, ajuster le palier suivant.

### La règle des 3 (avant toute sollicitation hors rituel)
1. J'ai cherché : doc officielle + web (15–30 min).
2. J'ai interrogé l'IA avec mon code et mon erreur.
3. J'ai reformulé le problème par écrit dans `questions-referent.md` (contexte, ce que j'ai essayé, ce que j'attends).
→ Si toujours bloqué : la question est mûre pour le référent, et elle lui fera gagner du temps.

### Ce qu'on demande au référent, palier par palier

| Palier | Interventions du référent |
|--------|---------------------------|
| 0–1 | Valider l'environnement de travail ; encourager ; vérifier les habitudes Git |
| 2–3 | Revue rapide des projets 2 et 3 (lisibilité, structure) |
| 4 | **Revue de code sérieuse du projet 4** (première vraie code review — moment clé) |
| 5 | Revue du projet Django ; discussion "Flask vs FastAPI vs Django, ton avis de terrain ?" |
| 6 | **Jouer le client** du projet Laravel (exigences qui changent, négociation du devis) ; donner accès à un hébergement Apache/mutualisé si possible |
| 7 | Challenger le document d'architecture (jouer l'interviewer system design) |
| 8 | **Donner l'accès au VPS** ; superviser le premier déploiement production ; partager ses horreurs de prod |
| 9 | Tester l'app mobile en vrai utilisateur exigeant |
| 10 | Jouer le client du projet final ; **simulations d'entretiens** ; ouvrir son réseau |

### Le besoin de parler à un humain
C'est une fonction officielle du dispositif, pas un aveu de faiblesse. L'apprentissage autodidacte est long et parfois décourageant. Quand la motivation flanche, quand tu doutes du parcours, quand tu veux juste raconter ta galère de la semaine : le référent est aussi là pour ça. Un point de 15 min "juste pour parler" est un usage légitime.

### Compléter par la communauté
Le référent est une personne, pas une communauté. En parallèle, dès le palier 1 :
- Discords : The Odin Project, freeCodeCamp.
- Local : **GDG Yaoundé/Douala**, meetups JS/Python/Flutter, écosystème Silicon Mountain.
- Expliquer ce qu'on apprend à quelqu'un d'autre (même débutant) est le meilleur test de compréhension.

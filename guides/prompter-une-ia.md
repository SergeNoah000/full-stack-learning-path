# 🤖 Guide — Utiliser l'IA sans cesser d'apprendre

> 🎯 **À la fin de ce guide** : tu sais formuler des demandes qui te font progresser, et tu reconnais les usages qui te font régresser.
> ⏱️ Lecture 15 min · à relire **au début de chaque palier**, car ton niveau d'autorisation change (voir le fil rouge IA de chaque palier).

## 1. Le principe

L'IA est le meilleur tuteur jamais disponible pour un autodidacte : patiente, disponible 24/7, capable de réexpliquer dix fois autrement. C'est aussi le meilleur moyen jamais inventé de **croire** qu'on apprend sans apprendre.

La différence tient à une seule chose : **qui produit l'effort cognitif ?**

- Tu réfléchis, l'IA t'aide à réfléchir → tu progresses, vite.
- L'IA réfléchit, tu lis le résultat → tu n'as rien appris, et tu ne le sauras qu'en entretien.

> **La règle qui résume tout le parcours** : *tu n'écris jamais une ligne que tu ne pourrais pas réécrire seul demain.*

## 2. L'usage gradué (rappel)

| Paliers | Rôle autorisé | Interdit |
|---------|---------------|----------|
| 0–1 | **Tuteur** : explications, indices | Générer du code — tu tapes tout |
| 2 | **Relecteur** : code review **après** avoir fini | Produire avant toi |
| 3 | **Autocomplétion** (Copilot) sur le boilerplate | Accepter une ligne non comprise |
| 4 | **Binôme** de conception + génération de tests | Décider de l'architecture à ta place |
| 5–6 | **Accélérateur de langages** | Sauter l'apprentissage natif (mini-framework, MVC maison) |
| 7–8 | **Sparring partner** (archi, infra) | Coller une commande système non comprise |
| 9–10 | **Brique produit** + agents sur des tâches entières | Livrer une diff non relue |

## 3. La méthode : anatomie d'un bon prompt

Un prompt utile contient quatre choses :

1. **Le contexte** : palier, langage, ce que tu construis, ton niveau.
2. **Le matériel** : ton code, le message d'erreur **complet**, ce que tu as déjà tenté.
3. **La demande précise** : explication ? indice ? critique ? *jamais* « fais-le ».
4. **La contrainte pédagogique** : « sans me donner la solution », « en 5 lignes », « pose-moi des questions ».

### Le cadrage à donner une fois pour toutes

À coller en début de conversation (ou en instruction permanente) :

> « Je suis en formation de développeur, palier [X] (`[langage]`). Mon objectif est d'apprendre, pas de livrer vite. Règles : ne me donne jamais de code complet sans que je te l'aie demandé explicitement ; donne-moi des indices et des questions ; si je te montre du code, critique-le au lieu de le réécrire ; quand tu m'expliques, utilise des analogies puis le terme technique exact. »

### Les prompts qui font progresser

| Situation | Prompt |
|-----------|--------|
| Je ne comprends pas un concept | « Explique-moi les closures avec une analogie du quotidien, puis un exemple JS de 10 lignes, puis dis-moi à quoi ça sert concrètement. » |
| J'ai une erreur | « Voici mon code et l'erreur complète. Explique-moi la **cause** sans me donner la solution. » |
| Je suis bloqué > 30 min | « Donne-moi **un indice**, pas la réponse. Si je me trompe, dis-moi juste si je chauffe. » |
| J'ai fini un exercice | « Critique ma solution : lisibilité, nommage, cas limites oubliés, performance. Ne la réécris pas. » |
| Je veux vérifier que j'ai compris | « Je vais t'expliquer `async/await` avec mes mots. Corrige mes erreurs et pose-moi 2 questions pour tester. » |
| Je veux m'entraîner | « Pose-moi 5 questions d'entretien junior sur SQL, une par une, et corrige chaque réponse avant la suivante. » |
| Je veux des exercices | « Donne-moi 5 exercices progressifs sur `reduce`, du plus simple au plus dur, **sans les corrections**. » |
| Je change de langage (P5+) | « Voici comment je fais X en JS/Express. Montre-moi l'équivalent **idiomatique** en Python/Django et dis-moi ce qui change dans la façon de penser. » |
| Je conçois (P4+) | « Voici mon modèle de données. Joue le rôle d'un senior en revue : quelles questions me poserais-tu ? Quels problèmes vois-tu à 10 000 utilisateurs ? » |
| Commande système (P8) | « Explique-moi cette commande flag par flag, et dis-moi ce qu'elle détruit si je me trompe. » *(avant de l'exécuter, jamais après)* |

### Les prompts qui te font régresser

| ❌ Prompt | Pourquoi c'est toxique |
|-----------|------------------------|
| « Écris-moi une fonction qui… » | tu sautes l'effort, seul moment où l'apprentissage se produit |
| « Corrige mon code » | tu obtiens un code qui marche et zéro compréhension |
| « Fais-moi le projet du palier » | tu te voles ton propre parcours ; ça se verra au premier entretien technique |
| « C'est quoi la meilleure stack ? » | question de comparateur, pas de praticien (piège n°3 du parcours) |
| Coller 500 lignes sans contexte | réponse générique, inutilisable |

## 4. Les limites à connaître

| Limite | Conséquence pratique |
|--------|---------------------|
| **Hallucinations** | elle invente des fonctions, des options de CLI, des paquets npm qui n'existent pas. **Vérifie dans la doc.** |
| **Date de connaissance** | elle peut te donner du Laravel 9 ou du React en classes. Précise ta version, vérifie la doc. |
| **Complaisance** | elle valide volontiers une mauvaise idée. Demande-lui explicitement de **critiquer**, et demande les contre-arguments. |
| **Pas de contexte sur ton projet** | sans ton code et tes contraintes, ses conseils sont génériques. |
| **Sécurité** | ne colle **jamais** un secret, une clé privée, un `.env`, des données personnelles ou du code client sous NDA. |
| **Code plausible mais faux** | ça compile, ça tourne, et c'est subtilement faux (cas limites, sécurité). D'où la relecture obligatoire. |

## 5. Le test honnête

Après chaque session assistée par l'IA, pose-toi **une** question :

> **Est-ce que je saurais réécrire ça demain, sans elle ?**

- Oui → excellent usage, continue.
- Non → tu viens de produire du code, pas de la compétence. Ferme la fenêtre, refais-le à la main. C'est long. C'est tout l'intérêt.

**Signaux d'alerte** : tu ne sais pas expliquer une ligne de ton propre fichier · tu ne sais plus écrire une boucle sans autocomplétion · tu demandes avant d'avoir essayé · tu ne lis plus les messages d'erreur.

## 6. Et en entretien ?

On te demandera comment tu utilises l'IA — c'est devenu une question standard. Le fil rouge de ce parcours est une excellente réponse, parce qu'il rassure sur les deux fronts : **tu sais coder sans, tu es productif avec**. Sache raconter :
- un cas où l'IA t'a fait gagner un temps considérable ;
- un cas où tu l'as **ignorée** parce qu'elle avait tort (et comment tu l'as su) ;
- ta règle personnelle (« je ne commite rien que je ne saurais réécrire »).

## 7. 🛠️ À faire
1. Ouvre une conversation et colle le cadrage du §3. Garde-la pour le palier en cours.
2. Prends ta dernière erreur en date, et demande la **cause sans la solution**. Résous-la toi-même ensuite.
3. Demande 5 exercices **sans corrections** sur le sujet de ta leçon en cours, et fais-les.
4. Fais-toi interroger : « pose-moi 5 questions sur [sujet du palier], une par une ». Note ton score dans le journal.

## ✅ Acquis si…
- [ ] Mes demandes contiennent contexte + code + erreur + demande précise.
- [ ] Je demande des **indices** avant des solutions.
- [ ] J'ai déjà repéré une réponse d'IA fausse en la vérifiant dans la doc.
- [ ] Je sais répondre en 1 minute à « comment utilises-tu l'IA ? » en entretien.
- [ ] Je peux réécrire sans aide tout le code présent dans mon dernier commit.

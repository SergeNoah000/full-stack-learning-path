# Leçon 05 — Monolithe modulaire, microservices, files et événements

> 🎯 **À la fin de cette leçon** : tu comprends les grands styles d'architecture applicative, pourquoi le monolithe modulaire est presque toujours le bon point de départ, et comment files et événements découplent les traitements.
> ⏱️ 4 h · **Prérequis** : leçons 01-04, et tes backends.

---

## De quoi on parle

Jusqu'ici, tu as structuré l'**intérieur** d'une application (classes, couches, patrons). Cette leçon monte d'un cran : comment découper une application **entière**, et comment ses parties communiquent.

- **Monolithe** : toute l'application dans un seul déployable (un seul processus, une seule base). Tes backends des paliers 4 à 6 sont des monolithes.
- **Monolithe modulaire** : un monolithe, mais organisé en modules nets et faiblement couplés, chacun responsable d'un domaine (facturation, utilisateurs, catalogue).
- **Microservices** : l'application éclatée en plusieurs services indépendants, déployés séparément, communiquant par le réseau.
- **Files de messages** et **événements** : un moyen de communication **asynchrone** — un service dépose un message, un autre le traite plus tard, sans que l'émetteur attende.

Le fil conducteur, à contre-courant de la mode : **commence par un monolithe modulaire**. Les microservices résolvent des problèmes d'organisation et d'échelle que tu n'as pas encore, et créent une complexité (réseau, données distribuées, déploiement) énorme. La plupart des équipes qui ont « fait des microservices trop tôt » le regrettent. Savoir ça te distingue déjà.

---

## À quoi ça sert, concrètement

**Parce que le choix d'architecture décide du coût de tout le reste.** Un découpage adapté rend les évolutions faciles ; un découpage prématuré en microservices transforme chaque changement en coordination de plusieurs services, bases et déploiements. C'est la décision la plus structurante — et la plus facile à rater par effet de mode.

**Parce que le monolithe modulaire donne le meilleur rapport bénéfice/coût.** Il a les avantages du monolithe (un déploiement, une base, des appels de fonction simples, des transactions locales) tout en étant organisé pour pouvoir, un jour, extraire un module en service si le besoin **réel** apparaît. C'est le point de départ par défaut d'une équipe sensée aujourd'hui.

**Parce que l'asynchrone débloque des traitements qu'on ne peut pas faire « en direct ».** Envoyer 10 000 e-mails, générer un gros rapport, redimensionner une vidéo : on ne fait pas attendre l'utilisateur pendant ces minutes. On dépose une tâche dans une file, on répond tout de suite, et un ouvrier (*worker*) la traite en arrière-plan. Les files sont partout dès que l'application grandit.

**Et parce que tu dois savoir en parler sans l'avoir déployé.** On ne te demandera pas de bâtir un système de microservices en formation. Mais on te demandera, en entretien, de comprendre les compromis — et sur le terrain, de reconnaître dans quel style d'architecture tu arrives. C'est de la culture d'architecture indispensable.

---

## Où ça intervient dans le développement

C'est le niveau « vue d'avion » de l'application :

```
   MONOLITHE MODULAIRE (le bon départ)
   ┌─────────────────────────────────────┐
   │  [Utilisateurs] [Facturation] [Catalogue]   ← modules nets, peu couplés
   │         └──── appels de fonction directs ────┘
   │                une seule base, transactions locales
   └─────────────────────────────────────┘
        │ si un module a un besoin RÉEL d'échelle/équipe séparée :
        ▼
   extraire CE module en microservice — communication réseau + file de messages
        ▼
   [Facturation] ──dépose un événement──▶ [File] ──▶ [Worker e-mail / stats / ...]
                                                    (asynchrone, découplé)
```

Trois ancrages.

**Tes backends sont déjà des monolithes.** Les paliers 4-6 t'ont fait écrire des monolithes (une app, une base). Tu n'as donc rien de nouveau à faire pour « avoir un monolithe » : tu dois apprendre à l'**organiser en modules** nets — ce qui est l'application, à l'échelle de l'app entière, du SRP (leçon 01) et du bon découpage (leçons 02-03).

**Les modules reprennent le découpage par responsabilité.** Un module = un domaine métier, avec ses propres contrôleurs, services et Repository. Le couplage faible entre modules est le même principe que le couplage faible entre classes (leçons 01-02), monté d'un niveau.

**Les événements prolongent l'Observer (leçon 04).** La file de messages est un Observer **distribué** : un module émet « commande créée », des workers abonnés réagissent — mais à travers le réseau et le temps, pas dans le même processus. Même idée de découplage émetteur/réactions, à l'échelle du système.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas prendre un de tes backends et le **ré-organiser mentalement (ou en dossiers) en modules** par domaine. Tu identifieras un traitement qui gagnerait à être **asynchrone** (envoi d'e-mail, génération de rapport) et tu décriras comment une file le sortirait du chemin de la requête. Tu listeras, honnêtement, ce que des microservices te coûteraient ici — pour comprendre pourquoi tu n'en as pas besoin.

### En équipe, en entreprise

**Tu arriveras dans une architecture existante.** Monolithe (souvent), monolithe qui se module, ou microservices (parfois trop nombreux). Savoir où tu mets les pieds, et pourquoi c'est ainsi, oriente tout ton travail.

**Les files sont omniprésentes à l'échelle.** Dès qu'une application a du trafic, les traitements lourds passent par des files (RabbitMQ, Redis, SQS, les *queues* de Laravel au palier 6). Tu déposeras et consommeras des messages ; c'est un savoir-faire courant.

**Le « retour au monolithe » est une tendance réelle.** Des entreprises connues ont ré-assemblé des microservices partis trop loin. Le discours « microservices = moderne = mieux » est dépassé ; le discours mûr est « le bon découpage pour le bon problème ». Tenir ce discours te situe du bon côté.

**Le théorème CAP et la cohérence éventuelle, de loin.** Dès qu'on distribue les données, on se heurte à des compromis (cohérence vs disponibilité, données « éventuellement cohérentes »). Tu n'as pas à les maîtriser maintenant, mais en avoir entendu parler t'évite d'être pris au dépourvu.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours (tôt dans ta carrière) : travailler dans un monolithe, le garder modulaire, respecter les frontières entre domaines.

Régulièrement (dès l'échelle) : déposer et consommer des messages dans une file, concevoir un traitement asynchrone, gérer les relances d'un message qui échoue.

Rare au début, et à ne pas précipiter : concevoir une architecture microservices, découper une base par service, gérer la cohérence distribuée, l'orchestration (Kubernetes — palier 8). On en parle pour la culture ; on ne s'y jette pas.

---

## La mécanique

### Le monolithe modulaire : des frontières nettes

```
app/
├── Utilisateurs/     ← module : contrôleurs, services, Repository du domaine
├── Facturation/      ← module : son propre domaine, ses propres tables
├── Catalogue/        ← module
└── Partage/          ← le strict commun (et pas un fourre-tout)

Règle d'or : un module n'accède PAS aux tables d'un autre module directement.
Il passe par l'interface publique de cet autre module (un service, un événement).
```

La discipline : chaque module est un petit domaine autonome, et les modules se parlent par des interfaces claires, jamais en fouillant dans les tables du voisin. C'est ce qui garde le monolithe sain — et ce qui rendra possible, plus tard, d'extraire un module en service sans tout démêler.

### ⭐ Pourquoi commencer monolithe, pas microservices

```
Un monolithe te donne GRATUITEMENT ce que les microservices rendent DIFFICILE :
  - un appel entre modules = un appel de fonction (rapide, typé, sûr)
    → entre microservices = un appel réseau (lent, qui échoue, à sérialiser)
  - une transaction qui couvre plusieurs domaines = transaction locale simple
    → entre services = transaction distribuée (très dur) ou cohérence éventuelle
  - un déploiement = un artefact
    → microservices = N déploiements à coordonner, N pannes possibles
  - déboguer = une pile d'appels
    → microservices = tracer une requête à travers le réseau (observabilité)
```

Les microservices échangent des **problèmes simples** (appel de fonction, transaction locale, un déploiement) contre des **problèmes difficiles** (réseau, données distribuées, orchestration). On ne paie ce prix que pour un bénéfice réel : des équipes nombreuses qui doivent déployer indépendamment, ou un composant à faire monter en charge séparément. Tant que tu n'as pas ces besoins, le monolithe gagne.

### Quand les microservices se justifient (vraiment)

```
✔ Plusieurs équipes qui se gênent sur un même déployable et veulent livrer séparément.
✔ Un composant au profil d'échelle très différent (ex. le traitement vidéo vs le reste).
✔ Un besoin d'isolation fort (techno, sécurité, conformité) pour une partie.
✘ « C'est moderne », « Netflix le fait », « ça fera bien sur le CV ».
```

La question n'est pas technique mais organisationnelle : les microservices résolvent surtout des problèmes d'**équipes** (livrer sans se coordonner). Pour un développeur solo ou une petite équipe, ils sont presque toujours un fardeau.

### Files et événements : le découplage asynchrone

```
Requête utilisateur : "passer la commande"
  Synchrone (bloquant) : enregistrer + envoyer e-mail + générer facture PDF
    → l'utilisateur attend 4 secondes. Mauvais.
  Avec une file :
    1. enregistrer la commande (rapide) → répondre "OK" tout de suite
    2. déposer les événements "commande créée" dans une FILE
    3. des WORKERS traitent en arrière-plan : e-mail, PDF, mise à jour du stock
    → l'utilisateur a sa réponse en 200 ms ; le reste se fait hors du chemin.
```

La file découple **dans le temps** : l'émetteur ne attend pas le traitement. C'est l'Observer de la leçon 04, mais asynchrone et persistant (le message survit si un worker est en panne). C'est ce que font les *queues* de Laravel (palier 6), Celery (Python), BullMQ (Node).

### Les pièges de l'asynchrone

```
- Un message peut être traité DEUX fois (relance après échec) → le traitement doit
  être idempotent (leçon 06) : le refaire ne doit pas doubler l'effet.
- Un message peut ÉCHOUER → prévoir des relances, puis une "file de lettres mortes"
  (dead letter queue) pour les messages définitivement bloqués.
- L'ordre n'est pas toujours garanti → ne pas supposer que A est traité avant B.
```

L'asynchrone apporte de la robustesse et de la réactivité, mais introduit ses propres règles. La plus importante — l'idempotence — fait le lien avec la leçon 06.

---

## Les problèmes que tu vas rencontrer

**« Mon monolithe est devenu un plat de spaghettis. »** Ce n'est pas la faute du monolithe, mais du manque de modularité. Un module qui lit les tables d'un autre, des dépendances croisées : remets des frontières (modules nets, interfaces publiques).

**« On veut passer en microservices. »** Pose la vraie question : quel problème d'**organisation** ou d'**échelle** cela résout-il ? S'il n'y en a pas, c'est de la complexité gratuite. Un monolithe modulaire bien rangé répond à presque tous les besoins d'une équipe normale.

**« Mon traitement fait attendre l'utilisateur. »** Candidat à l'asynchrone : sors-le du chemin de la requête vers une file, et réponds tout de suite.

**« Un e-mail a été envoyé deux fois. »** Un message rejoué sans idempotence. Le traitement doit pouvoir être refait sans doubler l'effet (leçon 06).

**« Je ne retrouve plus l'erreur, elle est dans un service distant. »** Le coût de la distribution : il faut de l'observabilité (traces, logs corrélés — palier 8). C'est précisément une des difficultés que le monolithe t'épargnait.

---

## Ce qu'on te demandera

En **entretien**, c'est un sujet d'architecture favori : « monolithe ou microservices ? » — la réponse mûre défend le monolithe modulaire par défaut et énonce les conditions **réelles** qui justifieraient des microservices (équipes, échelle, isolation). « À quoi sert une file de messages ? » — découpler l'asynchrone, sortir les traitements lourds du chemin de la requête.

On peut demander : « qu'est-ce qui est difficile avec les microservices ? » (réseau, données distribuées, déploiement, observabilité), « c'est quoi un worker ? », « pourquoi l'idempotence compte dans une file ? ».

En **mission**, on attend que tu respectes les frontières de l'architecture en place et que tu saches déposer un traitement dans une file quand c'est le bon outil.

---

## Ce qui te démarquera

**Défendre le monolithe modulaire.** À contre-courant de la mode, savoir dire « on commence monolithe, bien modularisé, et on extrait un service seulement si un besoin réel apparaît » est le signe d'une maturité d'architecture rare chez un junior. C'est exactement le discours des équipes expérimentées.

**Énoncer les compromis, pas les slogans.** Pouvoir lister ce que les microservices rendent difficile (appels réseau, transactions distribuées, N déploiements, observabilité) montre que tu comprends le prix, pas seulement la hype.

**Voir la file comme un Observer distribué.** Relier les files (leçon 05) à l'Observer (leçon 04) et aux événements du DOM (palier 2) montre que tu vois le même concept de découplage à toutes les échelles.

**Et penser idempotence.** Savoir qu'un message peut être rejoué et que le traitement doit donc être idempotent (leçon 06) te distingue de celui qui découvre les doubles e-mails en production.

---

## 📚 À lire

**Martin Fowler → *MonolithFirst* et *Microservice Premium*** : les articles de référence sur « commence monolithe », par l'une des voix les plus écoutées du domaine.

**Sam Newman → *Building Microservices*** (introduction et chapitres sur quand/pourquoi) : la référence, honnête sur les coûts autant que sur les bénéfices.

**Documentation d'un système de files** (les *Queues* de Laravel, que tu connais du palier 6, ou Celery/BullMQ) : pour voir concrètement déposer et consommer un message.

Relis la leçon 04 (Observer) : la file en est la version distribuée et asynchrone.

---

## 🤖 Le mini-projet à demander à l'IA

Analyser l'architecture de tes backends, et concevoir un traitement asynchrone :

> « Je suis en formation de développeur, palier 7 (architecture). Mes backends des paliers 4 à 6 sont des monolithes. Sans décider à ma place, aide-moi par questions à : (1) identifier les domaines métier qui feraient de bons modules (facturation, utilisateurs, etc.) et la règle "un module ne lit pas les tables d'un autre" ; (2) lister honnêtement ce que des microservices me coûteraient ici (réseau, transactions distribuées, déploiements) pour comprendre pourquoi je n'en ai pas besoin ; (3) repérer un traitement qui gagnerait à être asynchrone. »

Puis la file :

> « Prends le traitement asynchrone qu'on a repéré (par exemple l'envoi d'e-mail à l'inscription). Aide-moi à décrire, sans l'implémenter complètement, comment une file le sortirait du chemin de la requête : qui dépose le message, qui le consomme (worker), et quels pièges prévoir (le message rejoué deux fois → idempotence, le message qui échoue → relances et file de lettres mortes). Fais-moi le lien avec le patron Observer de la leçon 04. »

---

## 🛠️ À faire

1. **⭐ Les modules** : prends un de tes backends et dessine ses domaines métier (utilisateurs, facturation, catalogue…). Réorganise (au moins sur le papier, idéalement en dossiers) en modules nets, avec la règle « un module ne touche pas les tables d'un autre ».
2. **Les frontières** : repère un endroit où deux domaines sont couplés (un service qui lit la table d'un autre) et décris comment les découpler par une interface publique (un service, un événement).
3. **⭐ Le compromis microservices** : pour ton application, écris les deux colonnes — ce qu'un monolithe te donne gratuitement, ce que des microservices te coûteraient. Conclus honnêtement : en as-tu besoin ? Pourquoi (pas) ?
4. **Les conditions réelles** : liste les trois situations qui justifieraient vraiment d'extraire un microservice, et vérifie qu'aucune ne s'applique à toi aujourd'hui.
5. **Un traitement asynchrone** : identifie, dans un de tes projets, un traitement qui fait (ou ferait) attendre l'utilisateur (e-mail, rapport, redimensionnement). Décris le passage à une file : réponse immédiate + worker en arrière-plan.
6. **Les pièges** : pour ce traitement, décris ce qui se passe si le message est rejoué (→ idempotence, leçon 06) et s'il échoue (→ relances, file de lettres mortes).
7. **Le lien** : dans ton journal, explique en quoi une file de messages est un patron Observer (leçon 04) distribué dans le temps et l'espace — même découplage, autre échelle.

<details>
<summary>Corrections et points de contrôle</summary>

**1-2.** Le monolithe modulaire, c'est le SRP (leçon 01) et le bon découpage (leçons 02-03) appliqués à l'échelle de l'application : chaque module est un domaine autonome, les modules communiquent par des interfaces publiques, jamais en fouillant les tables du voisin. Cette discipline garde le monolithe sain et rend possible, plus tard et seulement si besoin, l'extraction d'un module en service. Un monolithe « spaghetti » n'est pas un défaut du monolithe mais du manque de modularité.

**3-4.** Le cœur de la leçon et ce qui te démarquera. Les microservices échangent des problèmes faciles (appel de fonction, transaction locale, un déploiement, débogage par pile d'appels) contre des problèmes difficiles (réseau qui échoue, transactions distribuées ou cohérence éventuelle, N déploiements, observabilité). Ce prix ne se paie que pour un bénéfice **organisationnel** réel : des équipes qui veulent livrer indépendamment, un composant à l'échelle très différente, un besoin d'isolation. « C'est moderne » n'est pas une raison. Le monolithe modulaire d'abord est le discours des équipes expérimentées.

**5-7.** La file découple **dans le temps** : enregistrer vite et répondre, puis traiter le lourd en arrière-plan via des workers. C'est l'Observer de la leçon 04 (un émetteur, des réactions découplées), mais asynchrone et persistant. Ses pièges découlent de cette nature : un message peut être rejoué (→ le traitement doit être idempotent, leçon 06), échouer (→ relances puis file de lettres mortes), arriver dans le désordre. Voir la file comme un Observer distribué relie proprement ce palier aux fondations vues bien plus tôt (les événements du DOM, palier 2).
</details>

---

## ✅ Acquis si…

- [ ] Je distingue monolithe, monolithe modulaire et microservices.
- [ ] Je sais qu'un monolithe modulaire est le bon point de départ par défaut.
- [ ] J'organise un backend en modules nets qui ne touchent pas les tables les uns des autres.
- [ ] J'énonce ce que les microservices rendent difficile (réseau, transactions, déploiements, observabilité).
- [ ] Je connais les conditions réelles (organisation, échelle, isolation) qui les justifient.
- [ ] Je sais quand un traitement doit devenir asynchrone, et comment une file l'en charge.
- [ ] Je connais les pièges de l'asynchrone : rejeu (idempotence), échec (relances, lettres mortes), ordre.
- [ ] Je vois la file de messages comme un Observer distribué dans le temps.

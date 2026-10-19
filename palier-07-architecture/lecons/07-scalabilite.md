# Leçon 07 — Scalabilité : vertical/horizontal, load balancer, statelessness

> 🎯 **À la fin de cette leçon** : tu comprends comment une application encaisse plus de charge, pourquoi l'absence d'état (*statelessness*) est la clé de tout, et tu peux en discuter avec justesse — c'est la synthèse du palier.
> ⏱️ 4 h · **Prérequis** : tout le palier 7, et les sessions (paliers 4 et 6).

---

## De quoi on parle

La **scalabilité** (ou passage à l'échelle) est la capacité d'une application à encaisser une charge croissante — plus d'utilisateurs, plus de requêtes — en lui ajoutant des ressources. Deux façons de grandir :

- **Scalabilité verticale** (*scale up*) : une machine plus puissante (plus de CPU, de RAM). Simple, mais plafonnée — il existe une plus grosse machine, et elle coûte cher.
- **Scalabilité horizontale** (*scale out*) : **plusieurs** machines qui se partagent la charge. Quasi illimitée, mais elle impose une condition absolue : les serveurs ne doivent garder **aucun état** local.

Deux notions rendent l'horizontal possible :

- le **load balancer** (répartiteur de charge) : une porte d'entrée qui distribue les requêtes entre les serveurs ;
- le **statelessness** (absence d'état) : chaque serveur traite n'importe quelle requête sans rien savoir des précédentes, car l'état vit ailleurs (base, cache partagé).

C'est la leçon de synthèse : elle réunit le monolithe modulaire (leçon 05), le cache et les files (leçons 05-06), et prépare le palier 8 (DevOps), où tu déploieras réellement.

---

## À quoi ça sert, concrètement

**Parce que le succès est un problème technique.** Si ton application marche, le trafic augmente. Une architecture qui ne sait pas grandir s'écroule au pire moment — le jour où elle a enfin des utilisateurs. Penser la scalabilité, c'est se préparer à réussir.

**Parce que l'horizontal est la seule voie qui ne plafonne pas.** La machine verticale a une limite physique et un coût qui explose. Ajouter des machines identiques, derrière un répartiteur, passe à l'échelle presque indéfiniment — c'est ainsi que fonctionnent tous les grands services. Mais cela n'est possible que si l'application est *stateless*.

**Parce que le statelessness est LA décision d'architecture qui conditionne tout.** Un serveur qui garde l'état d'un utilisateur en mémoire locale (sa session, son panier) ne peut pas être répliqué : la requête suivante, envoyée à un autre serveur, ne trouve plus rien. Sortir l'état vers un magasin partagé (base, Redis) est ce qui libère l'horizontal. C'est le concept central de la leçon, et une question d'entretien quasi certaine.

**Et parce qu'il faut en parler juste, sans sur-concevoir.** On ne te demande pas de construire l'infrastructure de Netflix. On te demande de **concevoir une application qui pourrait scaler** (sans état local), et d'en discuter les compromis. Concevoir *stateless* dès le début ne coûte presque rien ; le rétro-adapter plus tard coûte très cher. C'est le bon réflexe, pas la sur-ingénierie.

---

## Où ça intervient dans le développement

La scalabilité se joue dans la forme globale du déploiement :

```
                    ┌──▶ Serveur app #1 ┐
   Clients ──▶ [Load balancer] ──▶ #2   │  ← serveurs IDENTIQUES et SANS ÉTAT
                    └──▶ Serveur app #3 ┘  (n'importe lequel traite n'importe quelle requête)
                              │
                 ┌────────────┼─────────────┐
                 ▼            ▼             ▼
            Base de données  Cache partagé  Stockage de fichiers
            (l'ÉTAT vit ICI, partagé par tous les serveurs — pas en mémoire locale)
```

Trois ancrages dans le palier.

**Le statelessness réinterprète les sessions (paliers 4 et 6).** Au palier 6, ta session PHP vivait sur le disque du serveur. À un seul serveur, aucun problème. À plusieurs serveurs, cette session locale casse l'horizontal : il faut la déplacer vers un magasin partagé (base, Redis). C'est la limite que cette leçon te fait voir dans ton propre code.

**Le load balancer suppose le monolithe réplicable (leçon 05).** Répliquer une application suppose qu'elle soit faite pour (sans état). Un monolithe *stateless* se réplique parfaitement derrière un répartiteur — on peut scaler un monolithe, contrairement à une idée reçue. Les microservices ne sont pas requis pour l'horizontal.

**Le cache partagé est celui de la leçon 06.** Le cache mémoire-processus de la leçon 06 ne marche pas à plusieurs serveurs (chacun aurait le sien, incohérent) : il faut un cache **partagé** (Redis). La scalabilité explique pourquoi la leçon 06 distinguait cache local et cache distribué.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas chasser l'**état local** dans tes backends : où gardes-tu quelque chose en mémoire du serveur (session, cache, fichiers uploadés sur le disque local, variable globale) qui casserait si on dupliquait le serveur ? Tu décriras comment rendre chaque cas *stateless* (état vers la base, le cache partagé, un stockage d'objets). Tu dessineras l'architecture horizontale de ton application.

### En équipe, en entreprise

**La plupart des applications tournent derrière un load balancer.** Même modestes, elles ont souvent deux serveurs au moins (pour la disponibilité : si l'un tombe, l'autre répond). Concevoir *stateless* est donc la norme, pas une optimisation avancée.

**L'état local est un bug classique en production.** « Ça marche sur un serveur, ça casse quand on passe à deux » : sessions en mémoire, fichiers écrits sur le disque local, cache non partagé. Ces bugs apparaissent au moment du *scale out* et déroutent ceux qui n'ont pas la notion. Toi, tu les anticiperas.

**On parle de scalabilité en conception, on la mesure avant de l'appliquer.** On ne scale pas « au cas où » : on mesure (où est le goulot ? la base ? le CPU ?) avant d'ajouter des machines. Souvent, le goulot est la base de données — et on l'adresse par le cache, les index, les réplicas de lecture, pas en multipliant les serveurs d'application. Mesurer avant d'agir est un réflexe d'ingénieur.

**La base est le point dur de l'horizontal.** Répliquer des serveurs d'application sans état est facile ; répliquer une base (qui, elle, EST l'état) est difficile — réplicas de lecture, partitionnement (*sharding*), et retour des compromis de cohérence de la leçon 05. C'est le sujet avancé qui t'attend plus tard.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours (dans la conception) : écrire du code *stateless*, ne rien garder en mémoire locale qui doive survivre à la requête.

Régulièrement : mettre la session et le cache dans un magasin partagé (Redis), stocker les fichiers uploadés sur un stockage d'objets (S3) plutôt que sur le disque local, savoir lire une métrique de charge.

Rare, et pour plus tard (palier 8 et au-delà) : configurer un load balancer, l'autoscaling, les réplicas et le sharding de base, les CDN. Tu dois comprendre ces mots et ce qu'ils résolvent ; tu ne les mettras pas en œuvre en formation.

---

## La mécanique

### Vertical vs horizontal

```
VERTICAL (scale up) : 1 serveur → 1 serveur plus gros.
  + simple : rien à changer dans le code.
  − plafonné : il y a une machine maximale, et le prix grimpe vite.
  − point unique de panne : ce seul serveur tombe, tout tombe.

HORIZONTAL (scale out) : 1 serveur → N serveurs identiques.
  + quasi illimité, et tolérant aux pannes (un serveur tombe, les autres tiennent).
  − EXIGE une application sans état local.
  − introduit le réseau et la coordination (load balancer, état partagé).
```

On commence souvent par le vertical (simple), puis on passe à l'horizontal quand on atteint la limite ou qu'on veut la tolérance aux pannes. L'horizontal est la voie durable.

### Le load balancer : la porte d'entrée

```
Les clients ne parlent pas aux serveurs directement : ils parlent au load balancer,
qui distribue chaque requête à un serveur disponible (round-robin, moins chargé...).
  - il répartit la charge,
  - il retire un serveur en panne de la rotation (santé),
  - il permet d'ajouter/enlever des serveurs sans que le client le voie.
```

Le répartiteur est l'unique adresse publique ; derrière, le nombre de serveurs varie sans que personne à l'extérieur ne le sache. C'est lui qui rend la flotte de serveurs invisible et élastique.

### ⭐ Statelessness : l'état vit ailleurs que dans le serveur

```
❌ AVEC ÉTAT LOCAL (ne scale pas horizontalement) :
   - la session utilisateur en mémoire/disque du serveur
   - un fichier uploadé écrit sur le disque local
   - un compteur ou un cache dans une variable du processus
   → la requête suivante part sur un AUTRE serveur → l'état a disparu → bug.

✅ SANS ÉTAT (scale) : chaque serveur est interchangeable, l'état est externalisé :
   - session → base de données ou Redis (partagé)
   - fichiers → stockage d'objets (S3) partagé
   - cache → cache distribué (Redis), pas la mémoire du processus
   → n'importe quel serveur peut traiter n'importe quelle requête.
```

C'est le cœur de la leçon. Un serveur *stateless* ne garde rien entre deux requêtes : tout ce qui doit survivre est externalisé dans un magasin partagé. Alors les serveurs deviennent **interchangeables** — on peut en ajouter, en retirer, en perdre un, sans impact. C'est ce qui rend l'horizontal possible. Et c'est pourquoi ta session PHP sur disque (palier 6) devait, pour scaler, migrer vers un magasin partagé.

### Mesurer avant de scaler

```
Avant d'ajouter des machines, trouve le GOULOT :
  - le CPU des serveurs d'app sature ? → scale out (plus de serveurs) aide.
  - la BASE sature (c'est le cas le plus fréquent) ? → plus de serveurs d'app
    n'aide pas (ils taperont tous sur la même base). → cache (leçon 06), index
    (palier 4), réplicas de lecture.
```

Ajouter des serveurs d'application devant une base saturée ne fait qu'aggraver la saturation. D'où la règle : **mesure, trouve le goulot, traite-le**. La solution n'est pas toujours « plus de serveurs » ; souvent, c'est le cache ou les index — ce qui boucle avec la leçon 06.

### La base, point dur

```
Les serveurs d'app sans état se répliquent facilement.
La base EST l'état → la répliquer est difficile :
  - réplicas de LECTURE (plusieurs copies pour lire, une pour écrire) : courant.
  - partitionnement/sharding (répartir les données sur plusieurs bases) : avancé,
    et ramène les compromis de cohérence (leçon 05, CAP).
```

Retiens la hiérarchie de difficulté : scaler l'application (sans état) est facile, scaler la base (l'état) est le vrai défi. C'est pourquoi on protège la base par tous les moyens de la leçon 06 avant de la répliquer.

---

## Les problèmes que tu vas rencontrer

**« Ça marchait sur un serveur, on est passé à deux, les utilisateurs sont déconnectés au hasard. »** Session en mémoire/disque local. La requête suivante tombe sur l'autre serveur, sans la session. Externalise la session (base, Redis).

**« Les fichiers uploadés sont introuvables une fois sur deux. »** Ils sont écrits sur le disque local d'un serveur ; l'autre ne les a pas. Stocke-les sur un stockage d'objets partagé (S3).

**« J'ai ajouté des serveurs et c'est toujours lent. »** Le goulot est ailleurs (presque toujours la base). Plus de serveurs d'app ne résout pas une base saturée. Mesure, puis cache/index/réplicas.

**« Mon cache donne des résultats incohérents entre serveurs. »** Cache en mémoire-processus : chaque serveur a le sien. Passe à un cache partagé (Redis).

**« Un serveur est tombé et tout le site avec. »** Point unique de panne (un seul serveur, ou un état critique non répliqué). L'horizontal avec load balancer apporte la tolérance aux pannes.

**« On veut scaler, par où commencer ? »** Par la mesure, pas par l'achat de machines. Trouve le goulot d'abord. Et vérifie d'abord que l'application est *stateless*, sinon l'horizontal est impossible.

---

## Ce qu'on te demandera

En **entretien d'architecture**, c'est un sommet quasi obligatoire : « différence entre scalabilité verticale et horizontale ? », **« pourquoi une application doit-elle être stateless pour scaler horizontalement ? »**, « à quoi sert un load balancer ? », « où mets-tu les sessions quand tu as plusieurs serveurs ? ». La réponse sur le statelessness est la plus discriminante — beaucoup de candidats l'ignorent.

On peut demander : « qu'est-ce qui est le plus dur à scaler, l'application ou la base ? » (la base, car elle est l'état), « scalerais-tu avant ou après avoir mesuré ? », « peut-on scaler un monolithe ? » (oui, s'il est sans état).

En **mission**, on attend que tu écrives du code *stateless* par défaut et que tu saches reconnaître un état local problématique dans du code existant.

---

## Ce qui te démarquera

**Le réflexe stateless.** Concevoir sans état local dès le départ — session et cache partagés, fichiers sur stockage d'objets — est le marqueur d'un développeur qui pense « production ». C'est quasi gratuit à faire tôt, très cher à rattraper tard.

**Mesurer avant de scaler.** Dire « je cherche d'abord le goulot ; si c'est la base, ajouter des serveurs d'app n'aidera pas, je passe par le cache et les index » montre un raisonnement d'ingénieur, pas un réflexe d'achat de matériel.

**Savoir qu'on peut scaler un monolithe.** Corriger l'idée reçue « il faut des microservices pour scaler » (un monolithe *stateless* se réplique très bien derrière un load balancer) relie proprement cette leçon à la leçon 05 et te distingue nettement.

**Et relier toute l'architecture.** Montrer que statelessness (ici), monolithe modulaire (leçon 05), cache partagé et files (leçons 05-06) forment un tout cohérent — « voici comment mon application tiendrait la charge » — est exactement la vision d'ensemble que ce palier devait construire, et le livrable que tu défendras devant le référent.

---

## 📚 À lire

**The Twelve-Factor App** (12factor.net), surtout le facteur ***Processes* (stateless)** : la référence concise sur pourquoi et comment une application doit être sans état. Courte et décisive.

**AWS / Google Cloud → *architecture* : load balancing, auto scaling, stateless applications** : les pages d'architecture des fournisseurs expliquent clairement les concepts (même sans utiliser leur cloud).

**Martin Kleppmann — *Designing Data-Intensive Applications*** : pour aller loin sur la réplication et le partitionnement de la base. Dense ; à garder pour quand tu voudras approfondir le point dur.

Relis les leçons 05 (monolithe, files) et 06 (cache partagé) : la scalabilité en est la conséquence et la synthèse.

---

## 🤖 Le mini-projet à demander à l'IA

Chasser l'état local et concevoir l'architecture horizontale :

> « Je suis en formation de développeur, palier 7 (architecture), leçon de synthèse sur la scalabilité. Sans conclure à ma place, aide-moi à auditer mes backends (paliers 4 à 6) pour trouver tout ÉTAT LOCAL qui casserait si on dupliquait le serveur : sessions en mémoire ou sur disque, fichiers uploadés sur le disque local, caches ou compteurs dans des variables du processus. Pour chacun, fais-moi dire où externaliser l'état (base, Redis, stockage d'objets) pour rendre l'application stateless. »

Puis la conception et les compromis :

> « Aide-moi à dessiner l'architecture horizontale de mon application : load balancer, serveurs d'app identiques et sans état, base/cache/stockage partagés. Fais-moi ensuite raisonner sur : pourquoi ajouter des serveurs d'app n'aide pas si le goulot est la base, pourquoi il faut mesurer avant de scaler, et pourquoi on PEUT scaler un monolithe s'il est stateless (lien avec la leçon 05). Mets-moi au défi comme un comité d'architecture : pose-moi les questions difficiles. »

---

## 🛠️ À faire

1. **⭐ Chasse à l'état local** : audite tes trois backends et liste chaque endroit où tu gardes un état en mémoire ou sur le disque local du serveur (session, fichiers uploadés, cache mémoire, variable globale/compteur).
2. **Rendre stateless** : pour chaque état trouvé, écris où l'externaliser : session → base/Redis, fichiers → stockage d'objets, cache → Redis partagé. Vérifie que, ce faisant, deux serveurs identiques deviendraient interchangeables.
3. **Le cas de la session PHP** : reprends ta session du palier 6 (sur disque) et explique précisément pourquoi elle casserait à deux serveurs, et comment la déplacer vers un magasin partagé.
4. **⭐ Dessiner l'horizontal** : fais le schéma de ton application en scale out — load balancer, N serveurs sans état, base/cache/stockage partagés. Marque clairement où vit l'état.
5. **Vertical vs horizontal** : pour ton application, note les avantages et limites de chaque approche, et à quel moment tu passerais de l'un à l'autre.
6. **Mesurer avant de scaler** : décris comment tu trouverais le goulot (CPU des serveurs ? base ?) et pourquoi, si c'est la base, ajouter des serveurs d'app n'aiderait pas (relie au cache/index de la leçon 06).
7. **Scaler un monolithe** : écris, pour ton journal, pourquoi un monolithe *stateless* se scale très bien horizontalement, et corrige l'idée reçue « il faut des microservices pour scaler » (lien leçon 05).
8. **La synthèse du palier** : rédige une page qui relie statelessness, monolithe modulaire (leçon 05), cache et files (leçons 05-06) en une seule vision « voici comment mon application tiendrait la charge ». C'est le brouillon de ce que tu défendras devant le référent (le document d'architecture).

<details>
<summary>Corrections et points de contrôle</summary>

**1-3.** Le concept central du palier : un serveur qui garde un état **local** (session en mémoire/disque, fichier sur disque local, cache ou compteur en variable de processus) ne peut pas être dupliqué, car la requête suivante, routée vers un autre serveur par le load balancer, ne retrouve pas cet état. La correction est toujours la même : **externaliser l'état** vers un magasin partagé (base, Redis, stockage d'objets). Ta session PHP sur disque (palier 6) en est l'exemple parfait : parfaite à un serveur, cassante à deux, réparée en la déplaçant vers un magasin partagé. Un serveur sans état est interchangeable — c'est ce qui rend l'horizontal possible.

**4-5.** L'horizontal (plusieurs serveurs identiques derrière un load balancer) ne plafonne pas et tolère les pannes, mais exige le statelessness ; le vertical (une machine plus grosse) est simple mais plafonné et reste un point unique de panne. On commence souvent vertical, on passe horizontal pour l'échelle durable et la tolérance aux pannes. Le load balancer est l'unique porte d'entrée qui rend la flotte élastique et invisible de l'extérieur.

**6.** La discipline d'ingénieur : mesurer avant d'agir. Si le goulot est la base (le cas le plus fréquent), multiplier les serveurs d'application ne fait qu'augmenter la pression sur cette même base. La réponse est alors le cache (leçon 06), les index (palier 4), les réplicas de lecture — pas plus de serveurs d'app. Scaler l'application sans état est facile ; scaler la base (qui EST l'état) est le vrai défi.

**7-8.** La synthèse. On PEUT scaler un monolithe : s'il est *stateless*, il se réplique parfaitement derrière un load balancer. Les microservices ne sont pas une condition de l'échelle (leçon 05) — ils répondent à des besoins d'organisation, pas de scalabilité en soi. La vision d'ensemble que ce palier construit : une application en monolithe modulaire, *stateless*, protégée par le cache, le rate limiting et l'idempotence, déchargée de ses traitements lourds par des files, et répliquée horizontalement derrière un load balancer. C'est exactement ce document d'architecture que tu rédigeras et **défendras** devant le référent jouant le comité — le livrable du palier.
</details>

---

## ✅ Acquis si…

- [ ] Je distingue scalabilité verticale (plus gros) et horizontale (plus nombreux).
- [ ] Je sais que l'horizontal exige une application sans état local (*stateless*).
- [ ] J'explique le rôle d'un load balancer (répartition, santé, élasticité).
- [ ] Je repère un état local problématique (session, fichiers, cache, compteur) et je l'externalise.
- [ ] Je sais pourquoi la session sur disque (palier 6) casse à plusieurs serveurs, et comment la corriger.
- [ ] Je mesure et je trouve le goulot avant d'ajouter des machines.
- [ ] Je sais que la base est le point dur de l'horizontal, et qu'on peut scaler un monolithe *stateless*.
- [ ] Je relie statelessness, monolithe modulaire, cache et files en une vision d'ensemble (le document d'architecture).

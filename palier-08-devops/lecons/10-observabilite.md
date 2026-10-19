# Leçon 10 — Observabilité : logs, monitoring, sauvegardes testées, diagnostic

> 🎯 **À la fin de cette leçon** : tu sais ce qui se passe sur ton serveur (logs, métriques, alertes), tu diagnostiques une panne avec méthode, et tu as des **sauvegardes que tu as vraiment testées en les restaurant** — pas juste configurées.
> ⏱️ 5 h · **Prérequis** : toutes les leçons du palier, et la leçon 03 (déboguer méthodiquement) du palier 0 côté méthode.

> ⚠️ Rappel du garde-fou : une restauration de sauvegarde **écrase** des données. Teste les restaurations sur un environnement **séparé**, jamais directement sur la production que tu veux protéger.

---

## De quoi on parle

Mettre en ligne (leçon 09), c'est le début. **Garder en ligne**, c'est l'observabilité : la capacité à savoir, à tout moment, ce que fait ton système et pourquoi. Quatre volets :

- les **logs** : ce que tes services racontent (leçon 02, `journalctl` ; leçon 05, logs Nginx) — centralisés et consultables ;
- le **monitoring** (surveillance) : les **métriques** (CPU, mémoire, disque, temps de réponse) et les **alertes** qui préviennent **avant** la panne ;
- les **sauvegardes testées** : des copies des données, dont on a **vérifié la restauration** — une sauvegarde jamais restaurée n'est pas une sauvegarde, c'est un espoir ;
- le **diagnostic méthodique** : la démarche pour localiser une panne, qui réutilise la méthode de débogage du palier 0 (leçon 03), appliquée au serveur.

L'idée directrice, souvent résumée ainsi : **« tu ne peux pas réparer ce que tu ne peux pas voir »**. L'observabilité, c'est se donner les yeux. Et son volet le plus négligé — et le plus critique — est la sauvegarde testée : d'innombrables organisations ont découvert, le jour d'un incident, que leurs sauvegardes ne se restauraient pas.

---

## À quoi ça sert, concrètement

**Parce qu'une panne arrive toujours, et le chrono tourne.** Le disque se remplit, un service crashe, le trafic explose, un déploiement casse quelque chose. Quand ça arrive, la question n'est pas « est-ce que ça arrivera » mais « combien de temps pour comprendre et réparer ». L'observabilité réduit ce temps de heures à minutes — elle te dit **où** regarder.

**Parce que prévenir vaut mieux que guérir.** Le monitoring alerte **avant** la catastrophe : « disque à 85 % » te laisse agir avant le « disque plein » qui paralyse tout. Surveiller les bons signaux, c'est transformer des pannes en non-événements.

**Parce qu'une sauvegarde non testée est une illusion dangereuse.** Beaucoup « ont des sauvegardes » — jusqu'au jour où, après un incident, la restauration échoue (fichier corrompu, procédure incomplète, données manquantes). La seule sauvegarde qui compte est celle qu'on a **restaurée pour de vrai**, au moins une fois, et régulièrement. C'est le message le plus important de la leçon.

**Et parce que le diagnostic méthodique évite la panique.** Face à « le site est down », tâtonner au hasard fait perdre du temps et introduit de nouveaux problèmes. Une démarche ordonnée — observer, isoler, former une hypothèse, vérifier — trouve la cause sereinement. C'est la méthode du palier 0 (leçon 03), appliquée à l'infrastructure.

---

## Où ça intervient dans le développement

L'observabilité enveloppe tout le système déployé :

```
   SERVEUR (leçon 09)
     ├── LOGS : journalctl (app, leçon 02) + Nginx (leçon 05) + système
     │        → centralisés, consultables, filtrables
     ├── MÉTRIQUES : CPU, RAM, disque, temps de réponse, taux d'erreur
     │        → tableau de bord + ALERTES (avant la panne)
     ├── SAUVEGARDES : base + fichiers → stockées AILLEURS → RESTAURATION testée
     └── DIAGNOSTIC : méthode ordonnée quand quelque chose casse
```

Trois ancrages.

**Les logs sont ceux des leçons 02 et 05.** `journalctl -u monapp` (ton service, leçon 02), `/var/log/nginx/` (leçon 05) : tu sais déjà les lire. L'observabilité ajoute leur **centralisation** (tout au même endroit) et leur **exploitation** (filtrer, corréler, alerter).

**Le diagnostic réutilise la méthode du palier 0 et les outils du palier 8.** La démarche de débogage (palier 0, leçon 03 — observer, reproduire, isoler, hypothèse, vérifier) s'applique au serveur avec les outils vus ici : `top`/`df` (leçon 01), `systemctl`/`journalctl` (leçon 02), `curl`/`dig` (leçon 04), logs Nginx (leçon 05). Rien de neuf sur la méthode ; une nouvelle boîte à outils.

**Les sauvegardes protègent les données du palier (volumes, base).** Ce que tu as mis dans des volumes (leçons 06-07) et des bases doit être sauvegardé **ailleurs** que sur le serveur lui-même — sinon la perte du serveur emporte aussi les sauvegardes. C'est la statelessness (palier 7) poussée jusqu'à sa conséquence : l'état précieux doit être copié et restaurable.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas centraliser et filtrer les logs de ton serveur, mettre en place une surveillance de base (métriques + une alerte), configurer une sauvegarde de ta base et de tes fichiers **vers un stockage externe**, et — le point crucial — **restaurer** cette sauvegarde sur un environnement de test pour prouver qu'elle marche. Puis tu t'entraîneras au diagnostic sur une panne simulée.

### En équipe, en entreprise

**L'observabilité est un sujet à part entière.** Des outils dédiés : Prometheus + Grafana (métriques et tableaux de bord), Loki ou la pile ELK (logs centralisés), Sentry (erreurs applicatives), des sondes de disponibilité (UptimeRobot). Tu n'as pas à tous les maîtriser, mais à comprendre ce qu'ils apportent : voir, alerter, corréler.

**Les logs doivent être structurés.** Un log en texte libre est pénible à exploiter ; un log structuré (JSON, avec niveau, horodatage, contexte) se filtre et s'agrège. Logger utile — ni trop (bruit), ni trop peu (aveugle), jamais de secrets dans les logs — est une compétence applicative autant qu'opérationnelle.

**Les sauvegardes suivent une règle simple : 3-2-1.** Trois copies, sur deux supports différents, dont une **hors site**. Et surtout : des restaurations **testées régulièrement**. Les équipes sérieuses font des exercices de restauration planifiés — parce qu'une sauvegarde non testée n'existe pas.

**Le post-mortem est culturel.** Après un incident, on écrit ce qui s'est passé, pourquoi, et comment l'éviter — sans chercher un coupable (*blameless*). L'objectif est d'apprendre, pas de blâmer. Cette culture distingue les bonnes équipes.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : lire les logs (`journalctl`, Nginx), jeter un œil aux métriques de base (`top`, `df`, le tableau de bord), réagir à une alerte.

Régulièrement : diagnostiquer une panne avec méthode, vérifier que les sauvegardes tournent, consulter les erreurs applicatives (Sentry), ajuster une alerte.

Rare ou avancé (mais à connaître) : monter une pile d'observabilité complète (Prometheus/Grafana/Loki), le *tracing* distribué (pour les microservices, palier 7), l'analyse de tendances, l'automatisation des réponses. Tu les aborderas en contexte.

---

## La mécanique

### Les logs : voir ce que raconte le système

```bash
journalctl -u monapp -f                 # les logs de ton app, en direct (leçon 02)
journalctl -u monapp --since "1 hour ago" -p err   # les erreurs de la dernière heure
sudo tail -f /var/log/nginx/error.log   # les erreurs Nginx (leçon 05)
journalctl -p err -b                     # toutes les erreurs depuis le dernier démarrage
```

Tu sais déjà lire les logs (leçons 02, 05). L'observabilité, c'est les **exploiter** : filtrer par service, par niveau (`-p err`), par période (`--since`), corréler l'heure d'une erreur applicative avec un pic de trafic Nginx. Pour aller plus loin, on les **centralise** (une pile comme Loki) pour tout chercher au même endroit, surtout quand il y a plusieurs serveurs.

### Logger utile (côté application)

```
Un bon log : un NIVEAU (info/warn/error), un HORODATAGE, un CONTEXTE (quel utilisateur,
quelle requête), un message clair. Idéalement STRUCTURÉ (JSON) pour être filtrable.
À NE JAMAIS logger : mots de passe, jetons, données personnelles sensibles, numéros de carte.
Trop de logs = du bruit qui noie l'important. Trop peu = l'aveuglement. Logge les
événements qui aident à comprendre : erreurs, décisions importantes, entrées/sorties clés.
```

Le log est écrit par ton application (paliers 4-6) autant que par le système. Un log pensé pour le diagnostic — niveau, contexte, pas de secret — est ce qui te sauvera lors d'un incident. C'est une responsabilité de développeur, pas seulement d'opérateur.

### ⭐ Le monitoring : métriques et alertes

```
Les 4 signaux de base à surveiller sur un serveur :
  - DISQUE (df)      : un disque plein paralyse tout → alerter à 80 %
  - MÉMOIRE (free)   : la saturation fait ramer ou tuer des processus
  - CPU (top)        : une charge soutenue = goulot (lien scalabilité, palier 7)
  - DISPONIBILITÉ    : le site répond-il ? (une sonde externe teste l'URL périodiquement)
Côté app : temps de réponse, taux d'erreurs (5xx), nombre de requêtes.
```

La différence entre « surveiller » et « regarder quand ça casse » est l'**alerte** : on définit des seuils (disque > 80 %, le site ne répond plus, taux d'erreur anormal) et on est **prévenu** — par mail, message — **avant** ou **dès** que ça dérape. Une sonde externe (comme UptimeRobot) qui teste ton URL toutes les minutes et t'alerte si elle tombe est le minimum vital, simple à mettre en place. Les piles complètes (Prometheus + Grafana) ajoutent des tableaux de bord et l'historique.

### ⭐ Les sauvegardes — et leur test de restauration

```bash
# Sauvegarder une base PostgreSQL vers un fichier, puis l'envoyer AILLEURS
pg_dump -U postgres app > sauvegarde-$(date +%F).sql
# ... transférer vers un stockage EXTERNE (autre machine, stockage d'objets, hors site)

# ⭐ LE TEST QUI COMPTE : restaurer sur une base de TEST (jamais la prod !)
createdb app_test
psql -U postgres app_test < sauvegarde-2026-10-19.sql
# puis VÉRIFIER : les données sont-elles là, complètes, cohérentes ?
```

Le principe qui fait toute la leçon : **une sauvegarde n'existe que si on l'a restaurée.** Configurer `pg_dump` dans un cron ne suffit pas — le fichier peut être vide, corrompu, incomplet, ou la procédure de restauration peut manquer une étape. Le seul moyen de savoir est de **restaurer pour de vrai**, sur un environnement séparé, et de vérifier les données. À faire régulièrement, pas une fois.

> ⚠️ **On restaure sur un environnement SÉPARÉ** (une base de test, un serveur de test), **jamais** directement sur la production : une restauration **écrase** les données. Tester la restauration ne doit pas détruire ce qu'on cherche à protéger.

Règle **3-2-1** : **3** copies, sur **2** supports différents, dont **1 hors site**. Et une sauvegarde sur le serveur lui-même ne protège pas de la perte du serveur — il faut qu'une copie soit **ailleurs**.

### ⭐ Le diagnostic méthodique (la méthode du palier 0, sur le serveur)

```
« Le site ne répond plus. » On NE touche à rien au hasard. On déroule :
  1. OBSERVER     : quel est le symptôme exact ? (erreur ? lenteur ? rien du tout ?)
                    curl -I le site (leçon 04) → quel code ? pas de réponse ?
  2. LOCALISER    : maillon par maillon (leçon 04) — DNS ? port/pare-feu ? proxy ? app ? base ?
                    systemctl status (leçon 02), df -h et top (leçon 01), logs Nginx (leçon 05)
  3. HYPOTHÈSE    : « le disque est plein » / « l'app a crashé » / « le certificat a expiré »
  4. VÉRIFIER     : regarder la donnée qui confirme (df, journalctl, date du certificat)
  5. CORRIGER     : la cause, pas le symptôme. Puis vérifier que c'est résolu.
  6. NOTER        : qu'est-ce qui a cassé, pourquoi, comment l'éviter (post-mortem).
```

C'est **exactement** la méthode de débogage du palier 0 (leçon 03) — observer, isoler, former une hypothèse, vérifier, corriger la cause — appliquée au serveur avec les outils du palier 8. La discipline qui remplace la panique : un maillon à la fois, une hypothèse vérifiée par une observation, jamais de changement au hasard (qui, sur un serveur, peut aggraver — le garde-fou du palier).

### Le cycle complet de l'exploitation

```
  Observabilité en place (logs + métriques + alertes + sauvegardes testées)
        ▼
  Une alerte se déclenche (ou un incident est signalé)
        ▼
  Diagnostic méthodique → cause trouvée → correction
        ▼
  Post-mortem : ce qui a cassé, pourquoi, comment l'éviter → amélioration
        ▼
  (retour au début, le système est un peu plus robuste)
```

---

## Les problèmes que tu vas rencontrer

**« Le serveur est tombé et je ne sais pas pourquoi. »** Pas (assez) de logs ni de métriques : tu es aveugle. C'est l'argument pour l'observabilité **avant** l'incident. Avec `journalctl`, les logs Nginx et `df`/`top`, la cause est presque toujours trouvable — mets-les en place maintenant.

**« Le disque est plein, tout est bloqué. »** La panne classique et silencieuse : logs non tournés, fichiers temporaires, images Docker accumulées. `df -h` pour confirmer, puis faire le ménage. Une **alerte à 80 %** l'aurait évitée — c'est le signal numéro un à surveiller.

**« On a eu un incident et la sauvegarde ne se restaure pas. »** Le cauchemar que cette leçon existe pour éviter. La sauvegarde était configurée mais jamais testée. **Teste tes restaurations régulièrement**, sur un environnement séparé — avant d'en avoir besoin.

**« Ma sauvegarde est sur le serveur qui a brûlé. »** Une copie sur la machine sauvegardée ne protège de rien. Applique 3-2-1 : une copie **hors site**.

**« Mes logs sont illisibles / pleins de bruit. »** Trop de logs non structurés noient l'important. Logge avec niveau et contexte, en JSON si possible, et sans secret. Filtre par niveau (`-p err`) pour l'essentiel.

**« J'ai changé trois choses au hasard pour réparer et c'est pire. »** L'anti-méthode. Un seul changement à la fois, après une hypothèse vérifiée (comme en refactoring, palier 7). Sur un serveur, les changements au hasard aggravent — déroule la méthode.

---

## Ce qu'on te demandera

En **test DevOps**, l'exploitation est un sujet mûr : « comment diagnostiques-tu un serveur qui ne répond plus ? » (la méthode : observer, localiser maillon par maillon, hypothèse, vérifier), « que surveilles-tu sur un serveur ? » (disque, mémoire, CPU, disponibilité), « comment t'assures-tu que tes sauvegardes sont fiables ? » (**en les restaurant**, 3-2-1). La réponse sur la sauvegarde testée est particulièrement discriminante.

On peut demander : « que logges-tu, et que ne logges-tu jamais ? » (pas de secrets), « différence entre surveiller et regarder quand ça casse ? » (l'alerte, avant la panne), « qu'est-ce qu'un post-mortem ? ».

En **mission**, on attend que tu saches lire des logs, réagir à une alerte, diagnostiquer avec méthode, et que tu prennes les sauvegardes au sérieux — c'est-à-dire testées.

---

## Ce qui te démarquera

**La sauvegarde testée.** Dire « mes sauvegardes, je les restaure régulièrement sur un environnement de test, car une sauvegarde non testée n'existe pas » te place immédiatement parmi les gens sérieux. C'est l'erreur la plus répandue et la plus coûteuse ; ne pas la faire te distingue.

**Le diagnostic sans panique.** Dérouler une méthode ordonnée (observer → localiser → hypothèse → vérifier → corriger la cause) au lieu de tâtonner montre un sang-froid d'exploitant. Relier ça explicitement à la méthode de débogage du palier 0 prouve que tu as une approche cohérente, pas des réflexes épars.

**Surveiller pour prévenir.** Comprendre que le but du monitoring est d'alerter **avant** la panne (disque à 80 %, pas disque plein) montre que tu penses proactif, pas seulement réactif.

**Et la culture du post-mortem sans blâme.** Savoir qu'après un incident on apprend plutôt qu'on accuse, et qu'on rend le système plus robuste, est une maturité professionnelle qui dépasse la technique — exactement ce que cherchent les bonnes équipes.

---

## 📚 À lire

**Google SRE Book (sre.google/books) → *Monitoring Distributed Systems*, *Postmortem Culture*** : la référence sur la surveillance (les signaux à suivre) et la culture du post-mortem sans blâme. Lisible et marquant.

**La documentation de ta base → *backup and restore*** (`pg_dump`/`pg_restore` pour PostgreSQL) : la façon correcte de sauvegarder **et restaurer**.

**UptimeRobot / Healthchecks.io** : des sondes de disponibilité gratuites et simples — le minimum vital de surveillance, à mettre en place aujourd'hui.

**Prometheus + Grafana (documentation d'introduction)** : pour découvrir une pile de métriques complète, quand tu voudras aller plus loin.

Relis le palier 0, leçon 03 (déboguer méthodiquement) : c'est la **même** méthode, appliquée au serveur. Et les leçons 01-05 de ce palier pour les outils de diagnostic.

---

## 🤖 Le mini-projet à demander à l'IA

Mettre en place l'observabilité et, surtout, tester une restauration :

> « Je suis en formation de développeur, palier 8 (DevOps). Mon application est en ligne (leçon 09) et je veux pouvoir la surveiller et la diagnostiquer. Sans me donner des commandes à copier sans comprendre, guide-moi : exploiter mes logs (journalctl, Nginx) en les filtrant par service/niveau/période, choisir les 4 signaux de base à surveiller (disque, mémoire, CPU, disponibilité) et mettre une alerte simple (par ex. une sonde externe sur mon URL). Explique-moi la différence entre "surveiller" (alerter avant la panne) et "regarder quand c'est déjà cassé". »

Puis la sauvegarde testée et le diagnostic :

> « Aide-moi sur le point le plus important : sauvegarder ma base et mes fichiers, les stocker AILLEURS (règle 3-2-1), et surtout TESTER la restauration sur un environnement SÉPARÉ — car une sauvegarde jamais restaurée n'en est pas une. Insiste sur le fait de ne jamais restaurer sur la prod que je veux protéger. Ensuite, donne-moi un scénario de panne (site qui ne répond plus) et fais-moi dérouler la méthode de diagnostic du palier 0 appliquée au serveur : observer, localiser maillon par maillon, hypothèse, vérifier, corriger la cause. Ne me donne pas la réponse d'avance. »

---

## 🛠️ À faire

1. **Exploiter les logs** : sur ton serveur, filtre les logs de ton app (`journalctl -u`, par niveau et période) et les erreurs Nginx. Corrèle l'heure d'une erreur applicative avec les logs du proxy.
2. **Logger utile** : vérifie que ton application logge avec un niveau et un contexte, et **sans secret**. Ajoute un log manquant utile au diagnostic, ou retire du bruit.
3. **⭐ Les 4 signaux** : surveille disque (`df -h`), mémoire (`free`), CPU (`top`) et disponibilité. Mets en place une **alerte** simple (une sonde externe gratuite sur ton URL, ou un seuil de disque).
4. **L'alerte avant la panne** : remplis volontairement le disque (prudemment, sur un environnement de test) jusqu'au seuil d'alerte, et vérifie que tu es prévenu **avant** la saturation.
5. **⭐ Sauvegarder** : mets en place une sauvegarde de ta base (`pg_dump` ou équivalent) et de tes fichiers, et transfère-la vers un stockage **externe** (pas sur le serveur lui-même). Automatise-la.
6. **⭐ TESTER LA RESTAURATION** : restaure ta sauvegarde sur un environnement **séparé** (base de test), et **vérifie** que les données sont complètes et cohérentes. C'est l'exercice central de la leçon.
7. **3-2-1** : vérifie que tu as au moins une copie hors du serveur, et explique par écrit pourquoi une sauvegarde locale ne suffit pas.
8. **⭐ Diagnostic méthodique** : simule une panne (arrête l'app, remplis le disque, ou laisse « expirer » un certificat de test) et déroule la méthode — observer, localiser maillon par maillon (leçons 01-05), hypothèse, vérifier, corriger la cause. Note l'ordre de tes gestes.
9. **Post-mortem** : pour l'incident simulé, écris un court post-mortem sans blâme : ce qui a cassé, comment tu l'as trouvé, comment l'éviter à l'avenir.
10. **Le lien** : dans ton journal, montre que ta méthode de diagnostic est celle du palier 0 (leçon 03) appliquée au serveur, et liste quel outil du palier 8 teste quel maillon.

<details>
<summary>Corrections et points de contrôle</summary>

**3-4.** La surveillance utile tient à l'**alerte**, pas à l'affichage. Les 4 signaux de base (disque, mémoire, CPU, disponibilité) couvrent l'essentiel des pannes serveur. Le disque est le piège silencieux numéro un : un disque plein paralyse tout (logs qui gonflent, fichiers temporaires, images Docker). Une alerte à 80 % te laisse agir **avant** la saturation — c'est toute la différence entre surveiller (proactif) et constater (réactif). Une sonde externe sur ton URL, gratuite et en cinq minutes, est le minimum vital.

**5-7.** Le cœur de la leçon, et l'erreur la plus coûteuse du métier. Configurer une sauvegarde ne garantit rien : le fichier peut être vide, corrompu, incomplet, ou la procédure de restauration peut manquer une étape. **La seule preuve qu'une sauvegarde marche est de l'avoir restaurée** — sur un environnement **séparé** (jamais la prod, qu'une restauration écraserait), en vérifiant les données. À faire régulièrement. Et 3-2-1 : une copie **hors du serveur**, car une sauvegarde sur la machine qu'elle protège disparaît avec elle. « J'ai des sauvegardes » ne vaut rien ; « je restaure mes sauvegardes tous les mois et je vérifie les données » vaut tout.

**8 + 10.** Le diagnostic méthodique est la méthode de débogage du palier 0 (leçon 03) — observer, reproduire/localiser, former une hypothèse, la vérifier, corriger la **cause** (pas le symptôme) — appliquée au serveur avec les outils du palier 8 : `curl`/`dig` pour le maillon réseau (leçon 04), `systemctl`/`journalctl` pour les services (leçon 02), `df`/`top` pour les ressources (leçon 01), logs Nginx pour le proxy (leçon 05). On avance un maillon à la fois, chaque hypothèse confirmée par une observation. Sur un serveur, changer au hasard **aggrave** (le garde-fou du palier) : la méthode n'est pas un luxe, c'est ce qui évite de transformer une panne en catastrophe.

**9.** Le post-mortem sans blâme (*blameless*) : après un incident, on documente ce qui s'est passé, la cause, la résolution, et les mesures pour éviter la récidive — sans chercher un coupable. Le but est que le système (et l'équipe) sortent plus robustes de chaque incident. C'est une culture d'amélioration continue qui distingue les équipes mûres, et une maturité qui dépasse la pure technique.
</details>

---

## ✅ Acquis si…

- [ ] J'exploite les logs (filtrage par service, niveau, période) et je corrèle app et proxy.
- [ ] Je logge avec niveau et contexte, sans jamais de secret, et sans noyer l'important.
- [ ] Je surveille les 4 signaux de base (disque, mémoire, CPU, disponibilité) avec une alerte.
- [ ] Je comprends que surveiller, c'est alerter **avant** la panne, pas constater après.
- [ ] Je sauvegarde base et fichiers vers un stockage externe (règle 3-2-1).
- [ ] J'ai **restauré** une sauvegarde sur un environnement séparé et vérifié les données.
- [ ] Je diagnostique une panne avec méthode (observer, localiser, hypothèse, vérifier, cause).
- [ ] J'écris un post-mortem sans blâme et je fais le lien avec la méthode de débogage du palier 0.

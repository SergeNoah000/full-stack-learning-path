# Leçon 02 — DRY, KISS, YAGNI — et leurs limites

> 🎯 **À la fin de cette leçon** : tu sais quand factoriser et quand ne pas le faire, pourquoi le code le plus simple gagne, et comment éviter le pire des défauts d'architecture — le mauvais DRY qui couple tout.
> ⏱️ 3 h · **Prérequis** : la leçon 01 (SOLID), et tes trois backends.

---

## De quoi on parle

Trois maximes de conception, courtes et célèbres :

- **DRY** — *Don't Repeat Yourself* : chaque connaissance a une seule représentation dans le code.
- **KISS** — *Keep It Simple, Stupid* : la solution la plus simple qui marche est la bonne.
- **YAGNI** — *You Aren't Gonna Need It* : n'écris pas ce dont tu n'as pas besoin **maintenant**.

Elles tiennent en une phrase chacune, et c'est précisément le piège : on les récite sans voir leurs **limites**. La plus dangereuse est le **mauvais DRY** : à force de vouloir supprimer toute répétition, on fusionne des choses qui se ressemblaient par hasard, et on les couple pour toujours. « Une mauvaise abstraction coûte plus cher qu'une duplication » — c'est le contre-pied que cette leçon t'apprend à sentir.

Tu arrives avec un recul rare : tu as résolu les mêmes problèmes trois fois (Node, Python, PHP). Tu as vu ce qui se répétait **vraiment** (la logique métier) et ce qui se ressemblait **par accident** (deux bouts de code qui, un jour, divergeront). C'est la base du bon jugement sur DRY.

---

## À quoi ça sert, concrètement

**Parce que la simplicité est la qualité qui dure.** KISS n'est pas de la paresse : le code simple se lit, se corrige, se reprend par un autre. La complexité, même brillante, se paie à chaque maintenance. En équipe, le code le plus simple qui résout le problème est presque toujours le meilleur.

**Parce que la duplication fait peur à tort, et le couplage pas assez.** On nous apprend à détester la répétition. Mais factoriser deux choses qui vont diverger crée un couplage bien pire : changer l'une casse l'autre, et on se retrouve avec des `if` dans la fonction « commune » pour gérer les cas particuliers. YAGNI et le « bon DRY » protègent de ça.

**Parce que l'anticipation coûte cher.** YAGNI dit : ne construis pas l'abstraction, l'option de configuration, le cas générique « au cas où ». La plupart des « au cas où » n'arrivent jamais, et ceux qui arrivent ne ressemblent pas à ce qu'on avait prévu. Le code non écrit est le code le moins cher à maintenir.

**Et parce que ces maximes dialoguent avec SOLID.** SOLID (leçon 01) pousse à abstraire ; YAGNI et KISS retiennent de trop abstraire. L'architecture, c'est cet équilibre : assez de structure pour pouvoir changer, pas plus que nécessaire. Savoir arbitrer entre les deux est le cœur du métier.

---

## Où ça intervient dans le développement

Ces principes guident chaque décision de « où mettre ce code » et « faut-il généraliser » :

```
   Tu vois deux bouts de code qui se ressemblent.
        ▼
   Est-ce la MÊME connaissance métier, qui changera toujours ensemble ?
        ├── OUI  → factorise (bon DRY)
        └── NON (ressemblance accidentelle) → laisse dupliqué (le forcer = mauvais DRY)
        ▼
   Tu es tenté d'ajouter une option/abstraction « pour plus tard ».
        ▼
   En as-tu besoin MAINTENANT ? → NON → ne l'écris pas (YAGNI)
        ▼
   Deux solutions marchent. → prends la plus SIMPLE (KISS)
```

Trois ancrages dans ce que tu as vécu.

**Le vrai DRY, tu l'as fait avec le Repository.** Centraliser l'accès aux données (paliers 4-6) supprime une vraie duplication : la connaissance « comment lister les dépenses » existe à un seul endroit. Ça, c'est du bon DRY — la même connaissance, une seule représentation.

**Le faux DRY te guette dans la validation et les DTO.** Deux entités qui ont, aujourd'hui, les mêmes champs (un `User` et un `Admin` avec email et nom) ne sont pas la même connaissance. Les fusionner « parce que c'est pareil » te piégera le jour où l'une évoluera. C'est le mauvais DRY.

**YAGNI s'applique à tes trois backends relus.** Tu trouveras sûrement des bouts écrits « au cas où » — un paramètre jamais utilisé, une méthode jamais appelée, une config qui n'a qu'une valeur. C'est le moment de les repérer.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas relire ton code à la recherche des trois signaux : de la vraie duplication à factoriser (DRY), de la complexité gratuite à simplifier (KISS), et de l'anticipation inutile à supprimer (YAGNI). Et surtout, tu vas apprendre à **reconnaître une fausse duplication** et à résister à l'envie de la factoriser.

### En équipe, en entreprise

**KISS est un argument de revue puissant.** « Ta solution marche, mais celle-ci est plus simple » est une remarque fréquente et bienvenue. La simplicité est un objectif explicite, pas un aveu de faiblesse.

**Le mauvais DRY est une plaie des vieux projets.** Tu croiseras des fonctions « utilitaires » monstrueuses, pleines de paramètres booléens et de `if`, nées de fusions successives de code « qui se ressemblait ». Les démêler (ré-séparer ce qui n'aurait pas dû être joint) est une tâche de refactoring courante (leçon 03).

**YAGNI se heurte à la culture du « framework maison ».** Des équipes passent des mois à construire des abstractions génériques jamais utilisées. YAGNI est la discipline qui dit : résous le problème d'aujourd'hui, abstrais quand le besoin **réel** apparaît (à la deuxième ou troisième occurrence, pas à la première).

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : KISS (choisir la solution simple) et le jugement DRY (vraie vs fausse duplication). Ce sont des décisions permanentes, à chaque fonction écrite.

Régulièrement : YAGNI, chaque fois que tu es tenté de généraliser ou d'ajouter une option « pour plus tard ».

Le piège permanent : le réflexe « je vois deux lignes pareilles, je factorise » appliqué sans réfléchir. C'est le plus fréquent, et c'est celui contre lequel cette leçon te vaccine.

---

## La mécanique

### KISS : la solution simple d'abord

```
Avant d'écrire une abstraction, une hiérarchie de classes, un système de
configuration : demande-toi si trois lignes directes ne suffisent pas.
La plupart du temps, si.
```

KISS n'interdit pas la sophistication quand elle est nécessaire ; il interdit la sophistication **par défaut**. Le signal d'alarme : tu es fier de la complexité de ta solution. Souvent, c'est qu'elle est trop complexe.

### ⭐ DRY : vraie duplication vs ressemblance accidentelle

```php
// VRAIE duplication — la MÊME règle métier, copiée. À factoriser.
// (le calcul de TVA, répété dans trois fichiers : si le taux change, on oublie un endroit)
$ttc = $ht * 1.20;   // ici
$ttc = $ht * 1.20;   // et là
$ttc = $ht * 1.20;   // et encore là
// → une seule fonction calculerTTC($ht). Bon DRY.

// FAUSSE duplication — deux règles DIFFÉRENTES qui se ressemblent aujourd'hui.
function validerInscription(array $d) { /* email requis, mdp >= 12 */ }
function validerContact(array $d)     { /* email requis, message requis */ }
// Tentation : « les deux valident un email, factorisons un validerFormulaire() générique ».
// Piège : inscription et contact vont DIVERGER. Un validateur commun finira
// bourré de if ($type === 'inscription'). → laisse-les séparés.
```

Le test décisif : **ces deux morceaux changeront-ils toujours ensemble, pour la même raison ?** Si oui, c'est la même connaissance → factorise. Si non (ils se ressemblent par hasard, aujourd'hui), les joindre crée un couplage qui te coûtera cher. **La duplication est moins chère qu'une mauvaise abstraction.**

### Le coût caché du mauvais DRY

```
Une fonction « commune » née d'une fausse factorisation :
  function traiter($data, $type, $avecMail = true, $strict = false, $format = 'json')
Chaque paramètre booléen est une fissure : la fonction fait DEUX choses en une,
reliées par un if. Changer le comportement « inscription » risque de casser
« contact ». On ne peut plus lire une branche sans comprendre l'autre.
```

Les paramètres booléens de configuration (`$avecMail`, `$strict`) sont le symptôme classique : ils trahissent une fonction qui aurait dû rester deux fonctions. Quand tu vois ça, c'est souvent un mauvais DRY à défaire.

### YAGNI : le besoin réel, pas le besoin imaginé

```
❌ « Je vais faire une interface Export avec PDF, CSV, XML, XLS... »
   alors qu'on n'exporte qu'en CSV, et qu'on n'a jamais demandé le reste.
✅ Écris l'export CSV. Le jour où on demande le PDF (s'il arrive),
   tu extrais l'interface À CE MOMENT, en connaissant les deux cas réels.
```

YAGNI ne dit pas « n'abstrais jamais » ; il dit « abstrais quand tu as **deux cas réels** sous les yeux », pas un cas réel et un imaginaire. L'abstraction fondée sur un seul cas est toujours bancale, parce qu'elle devine le second.

### L'équilibre avec SOLID

```
SOLID (leçon 01) te pousse à : extraire des interfaces, inverser les dépendances.
YAGNI/KISS te retiennent de : le faire avant d'en avoir besoin.
Résolution : inverse les dépendances là où tu testes ou fais varier RÉELLEMENT ;
ailleurs, reste simple et direct. L'abstraction se mérite par un besoin réel.
```

La « règle de trois » aide : la première fois, écris-le ; la deuxième fois (duplication), note-le mais tolère-la ; la troisième fois, factorise. À trois occurrences, tu connais assez les variantes pour abstraire juste.

---

## Les problèmes que tu vas rencontrer

**« J'ai factorisé, et maintenant chaque changement casse autre chose. »** Mauvais DRY : tu as joint deux choses qui devaient diverger. Re-sépare-les, quitte à « dupliquer ». Le couplage était le vrai problème, pas la duplication.

**« Ma fonction a cinq paramètres booléens. »** Symptôme du mauvais DRY. Elle fait plusieurs choses reliées par des `if`. Découpe-la en fonctions distinctes.

**« J'ai construit un système générique et on ne l'utilise que dans un cas. »** Violation de YAGNI. L'abstraction était prématurée. Si un seul cas existe, du code direct aurait suffi.

**« Ma solution est élégante mais personne (moi compris, dans un mois) ne la comprend. »** Violation de KISS. L'élégance qui se paie en lisibilité est un mauvais marché. Simplifie.

**« Je ne sais pas si je dois factoriser ces deux bouts. »** Pose la question du test : changeront-ils toujours ensemble ? Dans le doute, attends la troisième occurrence (règle de trois). Dupliquer un peu est réversible ; une mauvaise abstraction l'est beaucoup moins.

---

## Ce qu'on te demandera

En **entretien**, on sonde le jugement : « que penses-tu du principe DRY ? » — la réponse mûre distingue vraie et fausse duplication et cite le coût d'une mauvaise abstraction. « Quand abstrais-tu ? » — à la deuxième ou troisième occurrence, pas à la première (YAGNI, règle de trois).

On peut demander : « ta solution est-elle la plus simple possible ? » (KISS en revue), « ce paramètre booléen, ne cache-t-il pas deux fonctions ? ».

En **mission**, on attend un code simple et lisible, et on te confiera volontiers le démêlage d'abstractions ratées.

---

## Ce qui te démarquera

**Oser dupliquer.** Dire « je préfère cette petite duplication à une abstraction qui couplerait deux choses destinées à diverger » est le signe d'un développeur mûr. Les juniors factorisent tout ; les seniors savent quand ne pas le faire.

**Le vocabulaire du mauvais DRY.** Pouvoir nommer « ressemblance accidentelle », « abstraction prématurée », « couplage par factorisation » montre que tu as dépassé le stade des slogans.

**La règle de trois.** Savoir attendre la troisième occurrence pour abstraire, parce qu'alors seulement tu connais les variantes, est un réflexe de praticien.

**Et l'équilibre avec SOLID.** Tenir les deux bouts — « j'abstrais pour pouvoir changer (SOLID), mais seulement quand le besoin est réel (YAGNI) » — est exactement le discernement qu'un architecte doit avoir. C'est le cœur de ce palier.

---

## 📚 À lire

**Sandi Metz → *The Wrong Abstraction*** : l'article de référence, court et décisif, sur pourquoi une mauvaise abstraction coûte plus cher que la duplication. À lire absolument.

**The Pragmatic Programmer → *DRY* et *orthogonalité*** : la source du principe DRY, bien plus nuancée que sa version slogan.

**refactoring.guru → *Code Smells*** (surtout *Long Parameter List*, *Shotgun Surgery*) : les odeurs qui signalent un mauvais DRY.

Relis la leçon 01 (SOLID) : DRY/KISS/YAGNI en sont le contrepoids nécessaire.

---

## 🤖 Le mini-projet à demander à l'IA

Développer ton jugement sur la duplication :

> « Je suis en formation de développeur, palier 7 (architecture). Je veux muscler mon jugement sur DRY, KISS et YAGNI, surtout sur le piège du "mauvais DRY". Sans décider à ma place, montre-moi des paires de bouts de code qui se ressemblent et demande-moi, pour chacune, s'il s'agit de la même connaissance métier (à factoriser) ou d'une ressemblance accidentelle (à laisser dupliquée). Donne-moi le test à appliquer : "ces deux morceaux changeront-ils toujours ensemble, pour la même raison ?". Puis corrige mon raisonnement. »

Puis sur ton propre code :

> « Voici un bout de mon backend [colle-le]. Aide-moi par questions à repérer : (1) une vraie duplication à factoriser, (2) une complexité gratuite à simplifier (KISS), (3) du code écrit "au cas où" à supprimer (YAGNI), et (4) une fonction à paramètres booléens qui cacherait un mauvais DRY. Ne refactore pas à ma place : fais-moi justifier chaque décision. »

---

## 🛠️ À faire

1. **⭐ Le test de la duplication** : trouve dans ton code deux morceaux qui se ressemblent. Pour chacun, réponds par écrit : « changeront-ils toujours ensemble, pour la même raison ? ». Décide : factoriser ou laisser.
2. **Une vraie factorisation (bon DRY)** : identifie une connaissance métier répétée (un calcul, une règle) et centralise-la. Vérifie qu'un changement ne se fait plus qu'à un endroit.
3. **⭐ Une fausse factorisation défaite** : trouve (ou crée) une fonction « commune » à paramètres booléens, et re-sépare-la en fonctions distinctes. Note comme chacune devient lisible seule.
4. **KISS** : prends une partie de ton code dont tu es « fier de la complexité » et réécris-la le plus simplement possible. Compare la lisibilité.
5. **YAGNI** : trouve dans tes trois backends un bout écrit « au cas où » (paramètre inutilisé, abstraction à une seule implémentation, config à une seule valeur) et supprime-le.
6. **La règle de trois** : choisis un cas où tu hésitais à abstraire. Compte les occurrences réelles. S'il y en a moins de trois, laisse ; sinon, abstrais.
7. **L'équilibre** : reprends le refactoring D de la leçon 01 et demande-toi, avec YAGNI, s'il était justifié (testais-tu vraiment ? faisais-tu vraiment varier ?). Écris ta conclusion.
8. **Le lien** : note dans ton journal un exemple de vraie duplication et un de fausse duplication tirés de tes backends — c'est l'exercice le plus formateur de la leçon.

<details>
<summary>Corrections et points de contrôle</summary>

**1 + 3 + 8.** Le cœur de la leçon : le test « changeront-ils toujours ensemble, pour la même raison ? ». Si oui → même connaissance → factorise (bon DRY). Si non → ressemblance accidentelle → **laisse dupliqué**. Joindre deux choses destinées à diverger produit une fonction « commune » qui accumule les `if` et les paramètres booléens pour gérer les cas particuliers : chaque modification d'un cas risque de casser l'autre. **Une mauvaise abstraction coûte plus cher qu'une duplication** (Sandi Metz). Les juniors factorisent par réflexe ; ton avantage, avec trois backends vus, est de distinguer ce qui se répète vraiment.

**4.** KISS : la fierté de la complexité est un signal d'alarme. Le bon code n'impressionne pas, il se comprend. Si ta version simplifiée est plus lisible et fait le même travail, elle est meilleure — même si elle est moins « maligne ».

**6.** La règle de trois opérationnalise YAGNI : première occurrence, écris-la ; deuxième, tolère la duplication en la notant ; troisième, factorise — car tu connais alors assez les variantes pour abstraire juste. Abstraire dès la première occurrence, c'est deviner le futur ; abstraire à la troisième, c'est le constater.

**7.** L'honnêteté de l'équilibre : l'inversion de dépendances de la leçon 01 n'est justifiée que si tu testes réellement ou fais réellement varier l'implémentation. Si tu ne fais ni l'un ni l'autre, elle était peut-être prématurée. Tenir ensemble SOLID (abstrais pour changer) et YAGNI (seulement quand le besoin est réel) est exactement le discernement d'architecte visé par ce palier.
</details>

---

## ✅ Acquis si…

- [ ] J'applique le test « changeront-ils toujours ensemble ? » pour décider de factoriser ou non.
- [ ] Je distingue une vraie duplication (à factoriser) d'une ressemblance accidentelle (à laisser).
- [ ] Je sais qu'une mauvaise abstraction coûte plus cher qu'une duplication.
- [ ] Je reconnais le mauvais DRY à ses symptômes (fonction « commune » à paramètres booléens).
- [ ] Je choisis la solution la plus simple qui marche (KISS), sans fierté de la complexité.
- [ ] Je n'écris pas « au cas où » (YAGNI) et j'applique la règle de trois avant d'abstraire.
- [ ] Je tiens l'équilibre entre SOLID (abstraire pour changer) et YAGNI (seulement si besoin réel).

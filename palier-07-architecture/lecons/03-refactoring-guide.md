# Leçon 03 — Refactoring guidé : reprendre le projet 4 sans changer son comportement

> 🎯 **À la fin de cette leçon** : tu améliores la structure d'un code **sans changer ce qu'il fait**, par petits pas sûrs, protégé par les tests — la compétence qui fait la différence entre « ça marche » et « ça se maintient ».
> ⏱️ 6 h · **Prérequis** : leçons 01-02, le palier 4 (ton projet backend et ses tests).

---

## De quoi on parle

**Refactorer**, c'est transformer la structure interne d'un code **sans modifier son comportement observable**. Même entrées, mêmes sorties ; seule l'organisation change — plus claire, mieux découpée, plus facile à faire évoluer.

Le mot est souvent mal employé pour dire « je réécris tout ». Le vrai refactoring, au sens de Martin Fowler, est l'inverse : une suite de **petites transformations**, chacune si simple qu'elle ne peut (presque) pas casser, vérifiée par les tests après chaque pas. On n'ajoute pas de fonctionnalité pendant un refactoring, et on ne corrige pas de bug : on range.

Le terrain d'exercice est **ton projet du palier 4** — celui que tu as écrit en premier, avant SOLID et DRY, et qui a donc accumulé des maladresses. Tu vas le reprendre et le mettre au niveau de ce que tu sais maintenant, appuyé sur ses tests (palier 4, leçon 10). C'est l'exercice le plus proche du travail réel : le gros des missions, c'est reprendre du code existant, pas écrire du neuf.

---

## À quoi ça sert, concrètement

**Parce que 90 % du métier, c'est modifier du code qui existe.** On écrit rarement une application de zéro. On ajoute une fonctionnalité à un code vieux de cinq ans, on corrige un bug dans un module qu'on n'a pas écrit. Pour faire ça sans tout casser, il faut savoir refactorer en sécurité. C'est **la** compétence de maintenance.

**Parce que le code se dégrade si on ne le range jamais.** Chaque ajout pressé laisse une trace : une fonction qui grossit, une responsabilité mal placée, une duplication. Sans refactoring régulier, le projet devient un bourbier où chaque changement prend dix fois trop de temps. Refactorer, c'est l'entretien qui garde le code vivant.

**Parce que les tests sont ce qui rend le refactoring possible.** Sans tests, « je n'ai rien cassé » est un espoir, pas une certitude. Avec une suite de tests verte, chaque petit pas est vérifié. C'est le lien direct avec le palier 4 : tu as écrit des tests ; voici ce à quoi ils servent vraiment.

**Et parce que refactorer par petits pas est contre-intuitif.** Le réflexe du débutant est la « grande réécriture » : tout casser et reconstruire. C'est presque toujours une erreur — long, risqué, et on réintroduit les bugs qu'on avait patiemment corrigés. La discipline des petits pas sûrs est ce qui te distinguera.

---

## Où ça intervient dans le développement

Le refactoring s'insère dans le cycle normal du travail, protégé par les tests :

```
   Tests verts (palier 4)  ← le filet de sécurité
        ▼
   Un petit changement de structure (renommer, extraire, déplacer)
        ▼
   Relancer les tests  →  rouge ? on annule le pas (il était trop gros ou faux)
        │                  vert ? on garde, on commite, on recommence
        ▼
   Structure améliorée, comportement identique
```

Trois ancrages.

**Les tests du palier 4 sont le filet.** Tu as appris à tester au palier 4 (leçon 10). Ici, ces tests deviennent indispensables : ils te disent, après chaque pas, si le comportement a changé. Si ton projet 4 manque de tests sur une zone, le premier geste est d'en ajouter **avant** de refactorer.

**SOLID et DRY (leçons 01-02) sont la destination.** Le refactoring est le chemin ; SOLID et DRY sont où tu vas. Tu extrais une classe (vers le SRP), tu inverses une dépendance (vers le D), tu défais un mauvais DRY. Le refactoring est la mise en pratique des deux leçons précédentes.

**Git est ton autre filet.** Commiter après chaque pas réussi (palier 0) te permet de revenir en arrière si un pas tourne mal. Petits commits, messages clairs : le refactoring se fait en micro-commits.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas prendre ton projet du palier 4, t'assurer qu'il a des tests verts, puis appliquer une série de refactorings nommés : renommer pour clarifier, extraire une fonction, extraire une classe, remplacer une cascade de `if` par du polymorphisme, inverser une dépendance. Après **chaque** pas : les tests. Si rouge, tu annules. Tu commites à chaque pas vert.

### En équipe, en entreprise

**Le refactoring se fait en continu, pas en « projet ».** On range le code qu'on touche, au fil de l'eau (« règle du boy-scout » : laisse le code un peu plus propre que tu ne l'as trouvé). Les « grands projets de refactoring » séparés sont souvent mal vus : risqués, sans valeur métier visible.

**On ne mélange jamais refactoring et fonctionnalité dans un même commit.** C'est une règle d'or de revue : un commit range OU ajoute, jamais les deux. Sinon, le relecteur ne sait plus ce qui change le comportement et ce qui déplace du code. Tu sépareras tes commits.

**Les IDE refactorent pour toi.** « Renommer », « Extraire méthode », « Extraire variable » sont des commandes automatiques (et sûres) de ton éditeur. Les connaître accélère énormément et réduit les erreurs. Un pro utilise ces outils plutôt que de couper-coller à la main.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : renommer pour clarifier, extraire une fonction trop longue, extraire une variable explicative. Ce sont les refactorings de base, permanents.

Régulièrement : extraire une classe, déplacer une méthode vers la classe où elle a sa place, inverser une dépendance, remplacer des `if` par du polymorphisme.

Plus rare et délicat : refactorer du code **sans tests** (il faut d'abord écrire des tests de caractérisation qui figent le comportement actuel, même s'il est bizarre), les gros déplacements d'architecture. On en touche un mot, mais la base — petits pas, tests verts — reste la même.

---

## La mécanique — les refactorings de base

### La discipline : petit pas, test, commit

```
1. Les tests sont verts.
2. UN petit changement (un seul : renommer, OU extraire, OU déplacer).
3. Relancer les tests.
   - verts → git commit, retour au point 2.
   - rouges → annuler le pas (git checkout), il était trop gros ou faux.
Jamais deux changements avant de relancer les tests.
```

C'est tout le secret. La taille du pas décide du risque : plus il est petit, plus le test qui passe du vert au rouge pointe précisément ce qui a cassé. Si tu changes dix choses puis lances les tests, tu ne sais plus laquelle a cassé.

### Renommer : le refactoring le plus sous-estimé

```
$d, $tmp, $data, traiter(), gerer()  →  $depense, $totalTTC, calculerTotal()
```

Un bon nom évite un commentaire et une relecture. Renommer une variable obscure ou une fonction vague en un nom qui dit l'intention est le refactoring le plus rentable, et le plus sûr (l'IDE le fait sans risque). Commence toujours par là.

### Extraire une fonction : casser les longueurs

```php
// AVANT — une fonction qui fait tout, illisible
function enregistrerCommande($data) {
    // 15 lignes de validation
    // 10 lignes de calcul du total
    // 8 lignes d'écriture en base
    // 5 lignes d'envoi d'e-mail
}

// APRÈS — chaque intention a un nom
function enregistrerCommande($data) {
    $erreurs = validerCommande($data);
    $total   = calculerTotal($data);
    $id      = persisterCommande($data, $total);
    notifierClient($id);
}
```

Quand une fonction fait « ceci, puis cela, puis encore ça », chaque bloc devient une fonction nommée. La fonction d'origine devient un sommaire lisible. Les tests ne bougent pas (le comportement est identique) — ils confirment que l'extraction est juste.

### Extraire une classe : vers le SRP

```
Un UserService qui valide, persiste ET envoie des e-mails
  → extraire un Mailer (l'envoi d'e-mail part dans sa propre classe)
Le comportement ne change pas ; la responsabilité est maintenant à sa place.
```

C'est le SRP de la leçon 01, atteint par refactoring. On déplace les méthodes liées à une responsabilité dans une classe dédiée, on injecte cette classe. Les tests, s'ils sont bien faits, passent toujours.

### Remplacer les `if` par du polymorphisme : vers O et D

```
La cascade if ($type === 'carte') / elseif ($type === 'paypal') de la leçon 01
  → des classes Carte, Paypal implémentant MoyenPaiement.
Refactoring en plusieurs pas : extraire chaque branche en méthode, puis en classe.
```

Le passage d'une cascade de `if` à des stratégies (leçon 01, O + D) se fait **progressivement** : d'abord extraire chaque branche en fonction, puis chaque fonction en classe, puis remplacer le `if` par un choix de classe. Jamais d'un coup.

### Le cas du code sans tests

```
Pas de tests sur la zone à refactorer ?
  → écris d'abord des tests de CARACTÉRISATION : des tests qui capturent le
    comportement ACTUEL (même s'il est étrange), pour pouvoir le préserver.
  → puis refactore, protégé par ces tests.
```

On ne refactore jamais à l'aveugle. Si la zone n'a pas de tests, on en écrit qui figent ce qu'elle fait aujourd'hui — on ne juge pas encore si c'est « bien », on le **fixe**. Ensuite seulement, on range en sécurité.

---

## Les problèmes que tu vas rencontrer

**« J'ai tout cassé et je ne sais pas quand. »** Tu as fait trop de changements avant de relancer les tests. Reviens au dernier commit vert, et reprends par pas plus petits.

**« Je refactore et j'en profite pour corriger un bug. »** Non. Un refactoring ne change pas le comportement. Si tu trouves un bug, note-le, finis le refactoring, commite, PUIS corrige le bug dans un commit séparé (avec son propre test).

**« Mes tests passent mais le comportement a quand même changé. »** Tes tests ne couvraient pas le cas modifié. Ajoute le test manquant (caractérisation), puis vérifie.

**« Je n'ai pas de tests sur cette zone. »** Écris-en d'abord (caractérisation). Refactorer sans filet est le meilleur moyen d'introduire des régressions silencieuses.

**« La grande réécriture serait plus propre. »** Presque toujours un piège : long, risqué, et on perd les corrections de bugs accumulées dans l'ancien code. Préfère la suite de petits pas, qui garde le logiciel fonctionnel tout du long.

**« Mon refactoring est énorme dans la revue. »** Tu as mélangé plusieurs refactorings (et peut-être une fonctionnalité). Découpe en commits atomiques, chacun d'un seul type.

---

## Ce qu'on te demandera

En **entretien**, on sonde la méthode : « comment refactores-tu un code legacy sans le casser ? » — la réponse attendue parle de tests (filet), de petits pas, de commits séparés, et de tests de caractérisation si la zone n'est pas couverte. « Refactoring et correction de bug dans le même commit ? » — jamais.

On peut demander : « qu'est-ce que le refactoring, précisément ? » (changer la structure sans le comportement), « pourquoi par petits pas ? ».

En **mission**, on te confiera très tôt de la reprise de code existant. Montrer que tu avances en sécurité, sans casser, est ce qui construit la confiance de l'équipe.

---

## Ce qui te démarquera

**La discipline des petits pas.** Résister à la grande réécriture et avancer par transformations minuscules, tests à l'appui, est la marque d'un développeur expérimenté. Beaucoup ne l'ont jamais apprise.

**Séparer ranger et ajouter.** Des commits qui font une seule chose, jamais refactoring + fonctionnalité mêlés, rendent ton travail relisable et sûr. C'est un signe de maturité immédiatement visible en revue.

**Les tests de caractérisation.** Savoir qu'on fige d'abord le comportement existant (même bizarre) avant de toucher à un code sans tests te distingue de celui qui « nettoie » à l'aveugle et casse tout.

**Et reprendre ton propre projet 4.** Pouvoir dire « j'ai repris mon premier backend, je l'ai mis au niveau de ce que j'ai appris depuis, sans changer son comportement, protégé par ses tests » est une démonstration concrète et convaincante de toute cette compétence.

---

## 📚 À lire

**Martin Fowler — *Refactoring*** (le livre de référence) : au moins le premier chapitre (l'exemple fil rouge) et le catalogue des refactorings de base (Rename, Extract Function, Extract Class, Move Method). La bible du sujet.

**refactoring.guru → *Refactoring*** : le catalogue en ligne, illustré, parfait pour piocher un refactoring précis.

**Michael Feathers — *Working Effectively with Legacy Code*** : pour les tests de caractérisation et le refactoring du code sans tests. À garder pour quand tu affronteras du vrai legacy.

Relis le palier 4, leçon 10 (tests) : c'est le filet sans lequel rien de tout ça n'est possible.

---

## 🤖 Le mini-projet à demander à l'IA

Refactorer ton projet 4, en discipline :

> « Je suis en formation de développeur, palier 7 (architecture). Je reprends mon backend du palier 4 pour l'améliorer sans changer son comportement, protégé par ses tests. Sans refactorer à ma place, guide-moi en discipline : rappelle-moi la boucle (tests verts → un seul petit changement → relancer les tests → commit si vert, annuler si rouge). Quand je te montre une fonction, aide-moi à repérer QUEL refactoring de base s'applique (renommer, extraire fonction, extraire classe, inverser dépendance) et fais-moi l'appliquer par petits pas, un seul à la fois. »

Puis le cas sans tests :

> « Voici une zone de mon code qui n'a pas de tests [colle-la]. Explique-moi les tests de caractérisation : aide-moi à écrire des tests qui capturent son comportement ACTUEL (même s'il est étrange), pour que je puisse ensuite refactorer en sécurité. Ne juge pas encore si le comportement est bon : aide-moi juste à le figer d'abord. »

---

## 🛠️ À faire

1. **Le filet** : ouvre ton projet du palier 4. Lance ses tests, vérifie qu'ils sont verts. Repère une zone **sans** tests et écris-en (caractérisation) avant d'y toucher.
2. **⭐ La boucle** : choisis une première amélioration et applique-la **par un seul pas**, relance les tests, commite si vert. Recommence. Ne fais jamais deux changements avant de relancer les tests.
3. **Renommer** : trouve trois noms obscurs (`$tmp`, `data`, `traiter`) et renomme-les pour dire l'intention. Utilise la commande « Renommer » de ton IDE.
4. **Extraire une fonction** : prends la fonction la plus longue de ton projet 4 et découpe-la en fonctions nommées, chacune pour une intention. Les tests doivent rester verts.
5. **Extraire une classe** : trouve une classe qui a trop de responsabilités (leçon 01) et extrais-en une (par exemple un `Mailer`). Injecte-la. Tests verts.
6. **⭐ Polymorphisme** : reprends une cascade de `if` sur un type et transforme-la, **par petits pas**, en classes-stratégies (leçon 01). Commite à chaque pas.
7. **La séparation des commits** : au cours de l'exercice, si tu repères un bug, note-le sans le corriger pendant un refactoring. Corrige-le ensuite dans un commit séparé, avec son test.
8. **Le contre-exemple** : tente volontairement un « gros pas » (cinq changements d'un coup), casse les tests, et constate que tu ne sais plus lequel a cassé. Reviens au commit vert. Ressens pourquoi les petits pas gagnent.
9. **Le bilan** : compare ton projet 4 avant/après. Note dans ton journal ce qui est plus clair, et confirme que le comportement (les tests) est identique.

<details>
<summary>Corrections et points de contrôle</summary>

**2 + 8.** La discipline est tout le sujet. Un seul changement, puis les tests : si rouge, tu sais **exactement** quel changement a cassé, parce que c'est le seul que tu as fait. Avec cinq changements d'un coup, un test rouge ne pointe plus rien — tu dois tout défaire. L'exercice 8 te fait vivre la différence dans ta chair : c'est ce qui ancre la méthode mieux qu'aucune explication.

**4-6.** Extraire une fonction, extraire une classe, remplacer des `if` par du polymorphisme : ce sont les refactorings qui mènent au SOLID de la leçon 01. Le point crucial : **les tests ne changent pas** pendant ces opérations. S'ils restent verts, c'est la preuve que tu as rangé sans changer le comportement. Si tu dois modifier un test, c'est que tu as changé le comportement — donc ce n'était pas un refactoring.

**7.** La règle d'or : un refactoring ne corrige pas de bug et n'ajoute pas de fonctionnalité. Ranger et changer le comportement sont deux intentions différentes, qui vont dans deux commits différents. Sinon, personne (toi compris) ne peut relire le changement : on ne sait plus ce qui déplace du code et ce qui modifie le résultat. C'est une règle de revue universelle.

**1.** Les tests de caractérisation : sur du code sans tests, on écrit d'abord des tests qui capturent le comportement **actuel**, sans le juger. Ils figent le présent pour qu'on puisse le préserver pendant le refactoring. C'est la clé pour reprendre du vrai legacy — et le gros des missions, c'est du legacy.
</details>

---

## ✅ Acquis si…

- [ ] Je définis le refactoring comme « changer la structure sans changer le comportement ».
- [ ] J'avance par petits pas : un changement, puis les tests, puis un commit.
- [ ] Je m'appuie sur une suite de tests verte comme filet de sécurité.
- [ ] J'écris des tests de caractérisation avant de refactorer une zone non couverte.
- [ ] Je maîtrise les refactorings de base : renommer, extraire une fonction, extraire une classe.
- [ ] Je transforme une cascade de `if` en polymorphisme par petits pas (vers SOLID).
- [ ] Je ne mélange jamais refactoring, correction de bug et fonctionnalité dans un commit.
- [ ] J'ai repris mon projet 4 et je l'ai amélioré sans changer son comportement.

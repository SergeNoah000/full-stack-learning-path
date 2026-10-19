# Leçon 01 — Dart : syntaxe, classes, `final`/`const`, null safety

> 🎯 **À la fin de cette leçon** : tu lis et écris du Dart sans effort, parce que c'est un mélange de ce que tu connais déjà (TypeScript, PHP) — et tu maîtrises la null safety, le seul vrai point neuf.
> ⏱️ 4 h · **Prérequis** : TypeScript (palier 3) et PHP typé (palier 6).

---

## De quoi on parle

**Dart** est le langage de Flutter (le palier). Bonne nouvelle : tu le connais déjà à 80 %. Sa syntaxe est un mélange de TypeScript (palier 3) et de PHP moderne (palier 6) — classes, types, fonctions fléchées, `async`/`await`. Tu ne réapprends pas à programmer ; tu transposes.

Ce qui mérite ton attention :

- le **typage** : statique comme TypeScript, avec inférence (`var`) ou types explicites (`int`, `String`) ;
- **`final` et `const`** : deux façons de déclarer une valeur immuable, à bien distinguer ;
- surtout la **null safety** : Dart distingue, dans le type lui-même, ce qui **peut** être `null` (`String?`) de ce qui ne le peut **pas** (`String`). C'est le vrai apport, plus strict que TypeScript, et ce qui élimine toute une classe de bugs.

L'essentiel de cette leçon tient en une phrase : va vite sur ce qui ressemble à TS/PHP, et prends le temps sur la null safety.

---

## À quoi ça sert, concrètement

**Parce que c'est la langue de Flutter, et tu dois la lire couramment.** Tout le code Flutter est en Dart. Pouvoir le lire et l'écrire sans friction est le préalable à tout le palier. Heureusement, le transfert depuis TS et PHP rend ça rapide.

**Parce que la null safety supprime l'erreur la plus fréquente du mobile.** Le « null reference » (accéder à quelque chose qui n'existe pas) est historiquement **la** cause numéro un de plantages d'applications. Dart le rend impossible par construction : si un type n'est pas marqué `?`, il ne peut pas être `null`, et le compilateur le garantit. Tu passes de « j'espère que ce n'est pas null » à « le type me dit que ce n'est jamais null ».

**Parce que `final`/`const` et l'immuabilité sont au cœur de Flutter.** Les widgets (leçon 03) sont massivement immuables et `const`. Comprendre ces mots-clés maintenant rend tout le reste du palier naturel. C'est aussi la bonne habitude que tu avais prise avec `const` en JS (palier 1) et `readonly` en TS.

**Et parce que reconnaître le transfert accélère tout.** Savoir que `List` de Dart ≈ `Array` de TS, que `Map` ≈ objet/`Record`, que `async`/`await` est identique, te fait avancer trois fois plus vite qu'en abordant Dart comme un langage inconnu. Ton avantage est d'avoir déjà programmé dans deux langages typés.

---

## Où ça intervient dans le développement

Dart est le socle sur lequel tout le palier est bâti :

```
   Dart (langage)          ← CETTE LEÇON + leçon 02 (collections, async)
     ▼
   Flutter (widgets en Dart) ← leçons 03-06
     ▼
   état, HTTP, persistance    ← leçons 07-09
```

Trois ancrages de transfert.

**C'est le TypeScript du palier 3, dans un cousin.** Types, classes, interfaces, génériques, `async`/`await` : tu les as vus en TS. Dart les a aussi, avec une syntaxe très proche. La null safety de Dart est une version **plus stricte** du `strictNullChecks` de TypeScript — même idée, appliquée partout et garantie par le compilateur.

**C'est le PHP typé du palier 6, en plus strict.** Les classes, les constructeurs, les propriétés typées, les enums que tu as vus en PHP 8 (palier 6, leçon 03) se retrouvent en Dart. Le typage est juste plus présent et vérifié à la compilation.

**Et l'immuabilité prépare les widgets (leçon 03).** `const` et `final` ici deviennent, à la leçon 03, la nature même des widgets Flutter — des descriptions immuables de l'interface. Ce que tu apprends sur l'immuabilité se branche directement sur le modèle de Flutter.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas écrire du Dart dans DartPad (en ligne, sans rien installer) ou en local : variables typées, classes avec constructeurs, `final`/`const`, et surtout de la null safety — déclarer ce qui peut être null, et manipuler ces valeurs en sécurité avec `?.`, `??`, `!`. Tu feras constamment le parallèle avec TS et PHP.

### En équipe, en entreprise

**La null safety est une exigence, pas une option.** Tout le code Dart moderne est en null safety. On n'écrit plus de code qui ignore la nullabilité ; le compilateur ne laisse pas passer. C'est un filet de sécurité apprécié : beaucoup de bugs sont attrapés avant même de lancer l'app.

**`final` par défaut est une bonne pratique.** On déclare `final` tout ce qui ne change pas (c'est-à-dire presque tout), et `var` seulement ce qui doit varier. Un code où tout est `final` par défaut est plus sûr et plus clair — même esprit que `const` en JS (palier 1).

**L'analyseur Dart guide en continu.** Comme ESLint/TypeScript (palier 3), l'analyseur Dart signale les erreurs de type, les null non gérés, les mauvaises pratiques, pendant que tu écris. On le laisse strict et on l'écoute.

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : les types de base (`int`, `double`, `String`, `bool`, `List`, `Map`), les classes et constructeurs, `final`/`const`, et la null safety (`?`, `?.`, `??`, `!`).

Régulièrement : les enums, les constructeurs nommés et `factory`, les paramètres nommés (très présents en Flutter), l'inférence `var`.

Rare au début : les mixins, les extensions, les génériques avancés, les opérateurs surchargés, la métaprogrammation. À connaître de nom ; tu les creuseras au besoin.

---

## La mécanique — ce qui transfère, et ce qui est neuf

### Variables et types (comme TS)

```dart
int age = 30;                 // type explicite
var nom = "Sarah";            // type INFÉRÉ (String), comme en TS
final ville = "Lyon";         // immuable : ne peut plus être réassignée
const pi = 3.14;              // immuable ET connue à la compilation
double prix = 9.99;
bool actif = true;
List<String> fruits = ["pomme", "poire"];   // ≈ Array<string> en TS
Map<String, int> stock = {"pomme": 5};       // ≈ Record/objet en TS
```

Tout ça t'est familier (TS, palier 3). `var` infère le type, les types explicites se posent comme en TS (mais `int nom`, pas `nom: int` — l'ordre est « type puis nom », comme en PHP/Java). `List` et `Map` sont les tableaux et dictionnaires.

### ⭐ `final` vs `const` : deux immuabilités

```dart
final maintenant = DateTime.now();   // immuable, mais calculée À L'EXÉCUTION
const pi = 3.14159;                  // immuable ET fixée À LA COMPILATION

// final : la valeur est fixée une fois, au moment de l'exécution.
// const : la valeur doit être connue dès la compilation (une constante littérale).
// DateTime.now() ne peut pas être const (sa valeur dépend du moment).
```

La distinction : `final` veut dire « assignée une seule fois » (la valeur peut être calculée à l'exécution, comme l'heure actuelle). `const` veut dire « constante à la compilation » (connue d'avance, figée dans le binaire). Toute `const` est `final`, l'inverse non. En Flutter, `const` sur un widget apporte en plus une optimisation (leçon 03). La règle pratique : `final` par défaut, `const` quand la valeur est une constante littérale.

### Les classes (comme TS et PHP)

```dart
class Depense {
  final String description;
  final double montant;
  final DateTime date;

  // constructeur avec paramètres NOMMÉS requis (très fréquent en Flutter)
  Depense({
    required this.description,
    required this.montant,
    required this.date,
  });

  // une méthode
  String resume() => "$description : $montant €";   // fonction fléchée, comme TS/JS
}

final d = Depense(description: "Café", montant: 3.5, date: DateTime.now());
print(d.resume());
```

Classes, propriétés typées, constructeurs, méthodes : c'est le PHP 8 du palier 6 et le TS du palier 3. Deux spécificités Dart à noter : les **paramètres nommés** entre accolades avec `required` (omniprésents en Flutter, plus lisibles qu'une liste d'arguments positionnels), et le raccourci `this.description` dans le constructeur (qui assigne directement la propriété). L'interpolation `"$description"` est comme les *template literals* de JS.

### ⭐ La null safety : le vrai point neuf

```dart
String nom = "Sarah";        // NE PEUT PAS être null — garanti par le compilateur
String? surnom;              // PEUT être null (le "?" l'autorise), vaut null par défaut

// Dart refuse d'utiliser une valeur nullable sans la gérer :
// print(surnom.length);     // ❌ ERREUR de compilation : surnom peut être null

print(surnom?.length);       // ?. : si surnom est null, l'expression vaut null (pas de plantage)
print(surnom ?? "inconnu");  // ?? : valeur de repli si null (comme en JS/PHP)
print(surnom!.length);       // ! : "je GARANTIS que ce n'est pas null" — à éviter sauf certitude
```

C'est le cœur de la leçon. Le type lui-même dit si une valeur peut être `null` : `String` ne le peut jamais, `String?` le peut. Le compilateur **refuse** d'accéder à un `String?` sans gérer le cas null — l'erreur est attrapée à la compilation, pas à l'exécution devant l'utilisateur. Les opérateurs : `?.` (accès sûr, renvoie null au lieu de planter), `??` (valeur de repli, comme en JS/PHP), `!` (affirmation « ce n'est pas null » — dangereux, car s'il l'est, ça plante : à n'utiliser qu'avec une vraie certitude).

C'est le `strictNullChecks` de TypeScript (palier 3), mais **obligatoire et garanti partout**. C'est ce qui élimine le plantage mobile le plus courant.

### Les fonctions (comme TS/JS)

```dart
int doubler(int x) => x * 2;                 // fonction fléchée (une expression)
int additionner(int a, int b) { return a + b; }   // forme complète
void direBonjour({String nom = "ami"}) {     // paramètre nommé avec valeur par défaut
  print("Bonjour $nom");
}
```

Fonctions fléchées pour les expressions courtes, forme complète avec `{}` sinon, paramètres par défaut : tout est transposé de JS/TS. Note `void` pour « ne renvoie rien ».

### Les enums (comme PHP 8 et TS)

```dart
enum Statut { actif, suspendu, archive }
final s = Statut.actif;
```

Les enums que tu as vus en PHP 8 (palier 6, leçon 03) existent aussi, utiles pour un ensemble fini de valeurs (un statut, un type) — plus sûrs qu'une chaîne libre.

---

## Les problèmes que tu vas rencontrer

**« The non-nullable variable must be initialized. »** Tu as déclaré un `String` (non nullable) sans lui donner de valeur. Soit tu l'initialises, soit tu le marques `String?` si null est un état légitime.

**« The property can't be unconditionally accessed because the receiver can be null. »** Tu accèdes à un `String?` sans gérer le null. Utilise `?.`, fournis un repli avec `??`, ou (si tu es certain) `!`.

**J'utilise `!` partout pour faire taire le compilateur.** Mauvaise habitude : `!` dit « fais-moi confiance, ce n'est pas null », et si tu te trompes, ça plante à l'exécution — exactement le bug que la null safety devait éviter. Réserve `!` aux cas où tu as une vraie garantie ; sinon, gère le null proprement.

**Je confonds `final` et `const`.** `const` exige une valeur connue à la compilation ; `DateTime.now()`, un résultat de calcul, une valeur venant de l'extérieur ne peuvent pas être `const`. Si le compilateur refuse `const`, utilise `final`.

**L'ordre type/nom me trouble.** En Dart, c'est `String nom` (type puis nom), comme en PHP/Java, pas `nom: String` comme en TS. Petit ajustement, vite acquis.

**Mes paramètres de constructeur ne sont pas reconnus.** En Flutter, on utilise surtout les paramètres **nommés** (`{required this.x}`). Oublier `required` rend le paramètre optionnel (donc potentiellement null). Mets `required` pour ce qui est obligatoire.

---

## Ce qu'on te demandera

En **entretien Flutter/Dart**, la null safety est le sujet central : « qu'est-ce que la null safety ? », « différence entre `String` et `String?` ? », « que font `?.`, `??`, `!` ? », « pourquoi éviter `!` ? ». On vérifie que tu comprends que le type encode la nullabilité et que le compilateur la garantit.

On peut demander : « différence entre `final` et `const` ? », « pourquoi `final` par défaut ? », « d'où viennent les paramètres nommés que tu utilises ? ».

En **mission**, on attend que tu écrives du Dart idiomatique : `final` par défaut, null safety respectée sans abus de `!`, paramètres nommés — sans que ce soit un sujet, car supposé acquis.

---

## Ce qui te démarquera

**Le transfert assumé.** Dire « Dart, c'est TypeScript et PHP mélangés ; j'ai mis une heure à être à l'aise » montre que tu sais capitaliser sur ce que tu connais au lieu de tout réapprendre. C'est exactement l'intérêt d'un parcours polyglotte.

**La null safety comprise, pas subie.** Expliquer que le type encode la nullabilité, que l'erreur est attrapée à la compilation, et que `!` est un contournement dangereux à éviter, te distingue de celui qui parsème son code de `!` pour faire taire le compilateur.

**`final` par défaut.** Écrire `final` partout où la valeur ne change pas est une marque de rigueur immédiatement visible, et la bonne préparation aux widgets immuables (leçon 03).

**Et voir la continuité.** Relier la null safety de Dart au `strictNullChecks` de TS, les enums au PHP 8, l'immuabilité au `const` de JS : montrer que Dart n'est pas une île mais un carrefour de ce que tu sais est la compréhension d'ensemble que le parcours construit.

---

## 📚 À lire

**dart.dev → *A tour of the Dart language*** : le tour complet, parfait quand on connaît déjà un langage typé — tu survoleras ce qui ressemble à TS/PHP et t'arrêteras sur la null safety.

**dart.dev → *Understanding null safety*** : l'explication de référence, claire et progressive. La lecture la plus importante de la leçon.

**dart.dev → *DartPad*** : l'éditeur en ligne pour expérimenter sans rien installer — idéal pour cette leçon.

Relis le palier 3 (TypeScript, `strictNullChecks`) et le palier 6, leçon 03 (PHP 8 : classes, enums) : tu y reconnaîtras presque tout Dart.

---

## 🤖 Le mini-projet à demander à l'IA

Transposer ce que tu sais, et verrouiller la null safety :

> « Je suis en formation de développeur, palier 9 (Flutter). Je connais déjà TypeScript (palier 3) et PHP typé (palier 6). Je découvre Dart et on m'a dit que c'est un mélange des deux. Sans tout me réexpliquer, aide-moi à transposer : montre-moi une classe TS que je connais et sa version Dart côte à côte, et fais-moi repérer ce qui est identique (types, classes, async, fonctions fléchées) et ce qui diffère (ordre type/nom, paramètres nommés avec required). Fais-moi écrire une classe Depense en Dart avec un constructeur à paramètres nommés. »

Puis la null safety en profondeur :

> « Concentrons-nous sur la null safety, le vrai point neuf. Explique-moi la différence entre String et String?, et fais-moi des petits exercices où je dois décider si une valeur doit être nullable ou non, puis la manipuler correctement avec ?., ?? et (rarement) !. À chaque fois que je serais tenté d'utiliser !, demande-moi si j'ai une VRAIE garantie que ce n'est pas null, ou si je devrais plutôt gérer le cas proprement. Relie ça au strictNullChecks de TypeScript. »

---

## 🛠️ À faire

> Dans DartPad (dart.dev) ou en local. Fais constamment le parallèle avec TS et PHP.

1. **Le transfert** : réécris en Dart une petite classe que tu avais en TS (palier 3) ou en PHP (palier 6). Note, par écrit, les 3 différences de syntaxe que tu remarques.
2. **Types et inférence** : déclare des variables avec types explicites et avec `var`. Vérifie que `var` infère bien le type (essaie de lui réassigner un autre type et observe l'erreur).
3. **⭐ `final` vs `const`** : déclare une valeur `const` (une constante littérale) et une valeur `final` qui ne peut pas être `const` (par ex. `DateTime.now()`). Comprends pourquoi `const` est refusé sur la seconde.
4. **Une classe** : écris une classe `Depense` avec des propriétés `final`, un constructeur à **paramètres nommés** `required`, et une méthode qui renvoie un résumé. Instancie-la.
5. **⭐ Null safety — déclarer** : déclare un `String` (obligatoire) et un `String?` (optionnel). Tente d'accéder à `.length` sur le nullable sans le gérer, et observe l'**erreur de compilation**.
6. **⭐ Null safety — gérer** : manipule ton `String?` avec `?.` (accès sûr), `??` (repli), et `!` (affirmation). Pour le `!`, demande-toi si tu as une vraie garantie.
7. **Le piège du `!`** : utilise `!` sur une valeur réellement nulle et observe le plantage à l'exécution. Comprends pourquoi `!` abusif ruine le bénéfice de la null safety.
8. **Enum** : crée un enum `Statut` et utilise-le dans ta classe à la place d'une chaîne libre. Note pourquoi c'est plus sûr.
9. **Le lien** : dans ton journal, dresse un petit tableau de correspondances Dart ↔ TS ↔ PHP (types, classes, async, null safety) et note le seul vrai point neuf pour toi.

<details>
<summary>Corrections et points de contrôle</summary>

**1.** Les 3 différences que tu remarqueras le plus souvent : (1) l'ordre **type puis nom** (`String nom`, comme PHP/Java, pas `nom: string` comme TS) ; (2) les **paramètres nommés** entre accolades avec `required`, omniprésents en Flutter ; (3) le raccourci `this.x` dans le constructeur. Le reste — types, classes, méthodes, fonctions fléchées, interpolation `"$x"`, `async`/`await` — transfère presque tel quel depuis TS et PHP. C'est pourquoi tu vas vite.

**3.** `const` exige une valeur **connue à la compilation** (un littéral, une expression constante) ; `final` accepte une valeur **calculée à l'exécution** mais assignée une seule fois. `DateTime.now()` dépend du moment où le code tourne : impossible de la figer à la compilation, donc `final` oui, `const` non. Toute `const` est `final`. Règle pratique : `final` par défaut, `const` pour les constantes littérales (et ça comptera pour l'optimisation des widgets, leçon 03).

**5-7.** Le cœur de la leçon. Le type encode la nullabilité : `String` ne peut **jamais** être null (le compilateur le garantit), `String?` le peut. Dart **refuse à la compilation** d'utiliser un nullable sans gérer le cas — donc l'erreur apparaît sur ton écran de développeur, pas sur le téléphone de l'utilisateur. `?.` renvoie null sans planter, `??` fournit un repli, `!` affirme « ce n'est pas null ». Le piège : `!` sur une valeur réellement nulle **plante à l'exécution** — c'est-à-dire exactement le bug que la null safety élimine, réintroduit à la main. Donc `!` seulement avec une garantie réelle ; sinon, gère le null. C'est `strictNullChecks` de TypeScript (palier 3), mais obligatoire et vérifié partout.
</details>

---

## ✅ Acquis si…

- [ ] Je lis et écris du Dart en le reconnaissant comme un mélange de TS et de PHP.
- [ ] J'utilise les types de base, `var` (inférence) et les types explicites (ordre type puis nom).
- [ ] Je distingue `final` (assignée une fois) de `const` (constante à la compilation).
- [ ] J'écris une classe avec des propriétés `final` et un constructeur à paramètres nommés `required`.
- [ ] Je comprends que le type encode la nullabilité (`String` vs `String?`).
- [ ] Je gère les valeurs nullables avec `?.`, `??`, et je n'abuse pas de `!`.
- [ ] Je sais pourquoi un `!` sur une valeur nulle ruine le bénéfice de la null safety.
- [ ] Je fais le lien entre la null safety de Dart et le `strictNullChecks` de TypeScript.

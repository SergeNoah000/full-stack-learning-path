# Leçon 05 — PDO et requêtes préparées

> 🎯 **À la fin de cette leçon** : tu accèdes à MySQL depuis PHP avec PDO, en requêtes préparées — et tu sais pourquoi la concaténation est une faille, pour la troisième fois du parcours.
> ⏱️ 4 h · **Prérequis** : leçons 01–04, et les leçons 05 (SQL) et 09 (injection) du palier 4.

---

## De quoi on parle

**PDO** (*PHP Data Objects*) est l'interface standard de PHP pour accéder aux bases de données. Elle offre une API homogène quel que soit le SGBD (MySQL, PostgreSQL, SQLite), et surtout les **requêtes préparées** — la protection contre l'injection SQL.

```php
$pdo = new PDO("mysql:host=localhost;dbname=depenses", $user, $pass);
$stmt = $pdo->prepare("SELECT * FROM depenses WHERE categorie = ?");
$stmt->execute([$categorie]);
$depenses = $stmt->fetchAll();
```

Le SQL lui-même, tu le connais depuis le palier 4 (leçon 05) : `SELECT`, `WHERE`, `JOIN`, `GROUP BY`. Ce qui change, c'est la bibliothèque qui l'exécute. Et les **requêtes préparées** sont la règle absolue, déjà vue en Node (`pg`, `$1`), en Python (`sqlite3`, `?`), et ici en PHP (`?` ou paramètres nommés).

C'est aussi l'occasion d'enterrer `mysql_query` : l'ancienne API de PHP, dépréciée et dangereuse, que tu croiseras en maintenance et que PDO remplace.

---

## À quoi ça sert, concrètement

**Parce que c'est ainsi que PHP parle à la base, correctement.** PDO est l'API moderne et sûre. En maintenance, tu verras encore `mysql_query` (déprécié, vulnérable), et savoir le remplacer par PDO est exactement ce qu'on attend — c'est une modernisation de sécurité directe.

**Parce que les requêtes préparées ne sont pas négociables, et tu le sais déjà.** Tu as exploité une injection SQL au palier 4 (leçon 09, en cadre défensif) et compris que la frontière entre code et donnée ne doit jamais être franchie. Tu as appliqué les paramètres en Node et en Python. Ici, c'est le même principe, pour la troisième fois — ce qui prouve que c'est un concept universel, pas une recette par langage.

**Parce que c'est le socle de ton MVC maison.** Ta couche modèles (leçon 09) utilisera PDO, exactement comme ta couche SQLite du palier 5 (leçon 07) utilisait `sqlite3`. C'est le pattern Repository, en PHP.

**Et parce que l'injection SQL reste une des failles les plus répandues.** Beaucoup de sites PHP en production concatènent encore leurs requêtes. Savoir reconnaître et corriger ça est une compétence de sécurité monnayable.

---

## Où ça intervient dans le développement

PDO est la couche d'accès aux données de ton application PHP :

```
   contrôleur / service       ← leçon 09
        ▼
   couche modèles (Repository avec PDO)   ← CETTE LEÇON + leçon 09
        ▼
   PDO (requêtes PRÉPARÉES)
        ▼
   MySQL / MariaDB
```

Trois points de transfert.

**C'est la couche SQLite du palier 5, en MySQL.** Au palier 5 (leçon 07), tu as construit un dépôt avec `sqlite3` et des requêtes paramétrées. Ici, tu fais la même chose avec PDO et MySQL. Le pattern Repository, les requêtes préparées, la conversion des lignes : tout est identique, seule la bibliothèque et le SGBD changent.

**Le SQL vient du palier 4.** Les `SELECT`, `JOIN`, `GROUP BY` que tu écriras sont ceux du palier 4 (leçon 05). MySQL a quelques différences mineures avec PostgreSQL, mais le SQL de base est portable. Tu ne réapprends pas SQL — tu l'exécutes depuis un troisième langage.

**Et les requêtes préparées sont la protection du palier 4, leçon 09.** L'injection que tu as exploitée se prévient ici de la même façon : des paramètres, jamais de concaténation. Le marqueur change (`?` ou `:nom` en PDO), le principe est identique.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas créer une base MySQL (via phpMyAdmin ou en ligne de commande), t'y connecter avec PDO, et écrire tes premières requêtes. Tu retrouveras le SQL du palier 4 et le pattern Repository du palier 5.

Tu vas aussi, en cadre défensif, reproduire une injection SQL sur une requête concaténée, puis la neutraliser avec une requête préparée — la troisième fois que tu fais cet exercice, et la preuve que tu le maîtrises.

### En équipe, en entreprise

**PDO est le standard.** Les frameworks (Laravel avec Eloquent, leçon 11) l'utilisent sous le capot. En code sur mesure, PDO direct ou via une petite couche d'abstraction est courant.

**`mysql_query` est partout en maintenance.** Les sites anciens utilisent l'API dépréciée (`mysql_*`), supprimée depuis PHP 7. Les migrer vers PDO (ou `mysqli`) est une tâche fréquente, et une amélioration de sécurité directe.

**phpMyAdmin est l'outil du mutualisé.** Sur l'hébergement partagé (où tu déploieras ton projet 6b), on gère la base via phpMyAdmin — une interface web pour MySQL. Savoir s'en servir fait partie de l'environnement réel de PHP.

**Et les requêtes préparées sont vérifiées.** Toute requête concaténée est signalée en revue de code et par les analyseurs de sécurité. C'est une ligne rouge.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : `new PDO(...)`, `prepare` + `execute`, `fetch`/`fetchAll`, les paramètres (`?` ou `:nom`), la gestion des erreurs PDO, et le pattern Repository.

Régulièrement : les transactions (`beginTransaction`/`commit`/`rollback`), `lastInsertId`, le mode de récupération (`FETCH_ASSOC`, `FETCH_OBJ`), les connexions persistantes.

Rare, et hors sujet pour l'instant : les procédures stockées, les curseurs, le streaming de gros résultats, les pilotes autres que MySQL/SQLite, l'optimisation fine des connexions. Tu les rencontreras par besoin, et Eloquent (leçon 11) abstraira tout ça.

---

## La mécanique

### Se connecter

```php
<?php
$dsn = "mysql:host=localhost;dbname=depenses;charset=utf8mb4";
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,       // ⭐ lever des exceptions sur erreur
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,  // ⭐ résultats en tableaux associatifs
    PDO::ATTR_EMULATE_PREPARES => false,              // ⭐ vraies requêtes préparées
];

try {
    $pdo = new PDO($dsn, $_ENV["DB_USER"], $_ENV["DB_PASS"], $options);
} catch (PDOException $e) {
    error_log($e->getMessage());                       // la trace dans les logs, pas à l'écran
    exit("Erreur de connexion");                       // message neutre
}
```

Trois options à poser dès le départ. `ERRMODE_EXCEPTION` fait lever une exception PDO en cas d'erreur (plutôt qu'un silence trompeur) — on peut alors la gérer avec `try/catch` (palier 1, leçon 08). `FETCH_ASSOC` renvoie les lignes en tableaux associatifs (`$ligne["montant"]`). Et `EMULATE_PREPARES => false` force de **vraies** requêtes préparées côté serveur, plus sûres.

Note `charset=utf8mb4` : c'est l'encodage complet d'UTF-8 pour MySQL (le simple `utf8` de MySQL est incomplet). Et les identifiants viennent de variables d'environnement (`$_ENV`), pas du code — le « secrets hors du code » du palier 4 (leçon 04).

### ⭐ Les requêtes préparées : la règle absolue

```php
<?php
// ❌ JAMAIS : la donnée est concaténée dans le texte de la requête
$pdo->query("SELECT * FROM depenses WHERE categorie = '$categorie'");

// ✅ Avec un paramètre positionnel (?)
$stmt = $pdo->prepare("SELECT * FROM depenses WHERE categorie = ?");
$stmt->execute([$categorie]);

// ✅ Avec un paramètre nommé (:nom) — plus lisible quand il y en a plusieurs
$stmt = $pdo->prepare("SELECT * FROM depenses WHERE categorie = :cat AND montant > :min");
$stmt->execute([":cat" => $categorie, ":min" => $montantMin]);
```

C'est la règle que tu connais depuis le palier 4 (leçon 05 et 09) et le palier 5 (leçon 07). En PDO, le marqueur est `?` (positionnel) ou `:nom` (nommé) ; le principe est identique : **la donnée ne touche jamais le texte de la requête**, elle est transmise séparément et la base ne l'interprète jamais comme du code. C'est ce qui rend l'injection SQL (palier 4, leçon 09) structurellement impossible.

Les paramètres **nommés** sont pratiques quand il y en a plusieurs : on ne compte pas les `?`, on nomme.

### Récupérer les résultats

```php
<?php
$stmt = $pdo->prepare("SELECT * FROM depenses WHERE categorie = ?");
$stmt->execute([$categorie]);

$toutes = $stmt->fetchAll();              // toutes les lignes (tableau de tableaux assoc.)
// ou
$une = $stmt->fetch();                     // une ligne (ou false si rien)
// ou boucle (pour de gros résultats)
while ($ligne = $stmt->fetch()) {
    echo $ligne["montant"];
}
```

`fetchAll()` ramène tout, `fetch()` ligne par ligne. Avec `FETCH_ASSOC` (configuré à la connexion), chaque ligne est un tableau associatif, prêt à être utilisé ou sérialisé en JSON.

### Insérer, modifier, supprimer

```php
<?php
// INSERT, et récupérer l'id généré
$stmt = $pdo->prepare(
    "INSERT INTO depenses (montant, categorie, description, date) VALUES (?, ?, ?, ?)"
);
$stmt->execute([$montant, $categorie, $description, $date]);
$id = $pdo->lastInsertId();               // l'id de la ligne créée (le RETURNING du palier 4)

// UPDATE
$stmt = $pdo->prepare("UPDATE depenses SET montant = ? WHERE id = ?");
$stmt->execute([$nouveauMontant, $id]);

// DELETE
$stmt = $pdo->prepare("DELETE FROM depenses WHERE id = ?");
$stmt->execute([$id]);
$nbSupprimees = $stmt->rowCount();         // combien de lignes affectées
```

`lastInsertId()` donne l'id de la ligne créée — l'équivalent du `RETURNING *` de PostgreSQL (palier 4) et du `lastrowid` de SQLite (palier 5). C'est ce que ta couche modèles renverra pour un `201 Created`.

> ⚠️ Comme toujours, un `UPDATE` ou `DELETE` sans `WHERE` affecte toute la table (palier 4, leçon 05). Écris le `WHERE` en premier.

### La couche modèles avec PDO (Repository)

```php
<?php
namespace App\Models;

class DepotDepenses
{
    public function __construct(private PDO $pdo) {}

    public function lister(?string $categorie = null): array
    {
        if ($categorie !== null) {
            $stmt = $this->pdo->prepare(
                "SELECT * FROM depenses WHERE categorie = ? ORDER BY date DESC"
            );
            $stmt->execute([$categorie]);
        } else {
            $stmt = $this->pdo->query("SELECT * FROM depenses ORDER BY date DESC");
        }
        return $stmt->fetchAll();
    }

    public function parId(int $id): ?array
    {
        $stmt = $this->pdo->prepare("SELECT * FROM depenses WHERE id = ?");
        $stmt->execute([$id]);
        $ligne = $stmt->fetch();
        return $ligne ?: null;             // false → null
    }

    public function creer(array $donnees): array
    {
        $stmt = $this->pdo->prepare(
            "INSERT INTO depenses (montant, categorie, description, date) VALUES (?, ?, ?, ?)"
        );
        $stmt->execute([$donnees["montant"], $donnees["categorie"],
                        $donnees["description"], $donnees["date"]]);
        return $this->parId((int) $this->pdo->lastInsertId());
    }
}
```

C'est le pattern Repository du palier 4 (leçon 07) et du palier 5 (leçon 07) : toutes les requêtes à un seul endroit, exposées en fonctions métier, injecté avec la connexion PDO. Les services (leçon 09) appellent `$depot->lister()` sans voir une ligne de SQL. Le jour où tu passes à Eloquent (leçon 11), tu changes cette couche, pas le reste.

### Les transactions

```php
<?php
$pdo->beginTransaction();
try {
    $pdo->prepare("UPDATE comptes SET solde = solde - ? WHERE id = ?")->execute([$m, $a]);
    $pdo->prepare("UPDATE comptes SET solde = solde + ? WHERE id = ?")->execute([$m, $b]);
    $pdo->commit();                        // tout réussit
} catch (PDOException $e) {
    $pdo->rollBack();                      // ou tout est annulé
    throw $e;
}
```

Comme au palier 4 (leçon 07) et au palier 5 (leçon 07), une transaction garantit l'atomicité : débiter et créditer réussissent ensemble, ou aucun. `beginTransaction`/`commit`/`rollBack` — le même concept, dans un troisième langage.

### Enterrer `mysql_query`

```php
<?php
// ❌ L'ANCIEN monde : mysql_query (supprimé depuis PHP 7, vulnérable)
$result = mysql_query("SELECT * FROM users WHERE name = '$name'");   // injection !

// ✅ PDO, requête préparée
$stmt = $pdo->prepare("SELECT * FROM users WHERE name = ?");
$stmt->execute([$name]);
```

En maintenance, tu croiseras `mysql_query` et `mysql_*`. Ces fonctions sont **supprimées** depuis PHP 7, et elles encourageaient la concaténation (donc l'injection). Les remplacer par PDO avec requêtes préparées est une modernisation de sécurité standard — et un argument concret en mission.

---

## Les problèmes que tu vas rencontrer

**`SQLSTATE[HY000] [2002] Connection refused`.** MySQL n'est pas démarré, ou le `host`/`port` est incorrect, ou les identifiants sont faux.

**Ma requête échoue en silence.** Tu n'as pas activé `ERRMODE_EXCEPTION`. Sans lui, PDO échoue silencieusement (comportement par défaut trompeur). Active-le pour obtenir des exceptions.

**Mes accents sont cassés.** L'encodage : `charset=utf8mb4` dans le DSN (et la base/colonnes en `utf8mb4`). Le `utf8` de MySQL est incomplet, utilise toujours `utf8mb4`.

**Mon paramètre nommé ne correspond pas.** Le nombre ou les noms de paramètres entre `prepare` et `execute` ne correspondent pas. Avec les nommés, vérifie l'orthographe des `:nom`.

**J'ai concaténé ma requête.** Même si « ça marche », c'est une injection SQL (palier 4, leçon 09). Passe en paramètres, toujours.

**`fetch()` renvoie `false`, pas `null`.** PDO renvoie `false` quand il n'y a pas de résultat. Convertis en `null` si ton code l'attend (`$ligne ?: null`).

**Mon `lastInsertId()` renvoie une chaîne.** PDO le renvoie en chaîne. Convertis avec `(int)` si besoin.

**Un `UPDATE` sans `WHERE` a tout modifié.** L'accident classique (palier 4). Écris le `WHERE` en premier, teste avec un `SELECT` d'abord.

---

## Ce qu'on te demandera

En **entretien PHP**, les requêtes préparées sont une question de sécurité quasi certaine : **« comment te protèges-tu de l'injection SQL en PHP ? »** — la réponse « PDO avec requêtes préparées, jamais de concaténation » est la même qu'aux paliers 4 et 5, dans un troisième langage.

On peut demander : « PDO ou mysqli ? » (PDO, pour l'abstraction multi-SGBD), « pourquoi `mysql_query` est-il déprécié ? », « à quoi sert une transaction ? », « paramètres positionnels ou nommés ? ».

En **maintenance**, on peut te demander de migrer du `mysql_query` vers PDO — une tâche réelle et fréquente.

---

## Ce qui te démarquera

**Les requêtes préparées par réflexe, dans un troisième langage.** Savoir que c'est `?`/`:nom` en PDO, `$1` en PostgreSQL, `?` en SQLite, mais le même principe partout, prouve que tu as compris la protection, pas mémorisé une syntaxe.

**Configurer PDO correctement.** `ERRMODE_EXCEPTION`, `FETCH_ASSOC`, `EMULATE_PREPARES => false`, `utf8mb4` : ces options dès la connexion montrent que tu connais PDO en profondeur, pas juste sa surface.

**Reconnaître et remplacer `mysql_query`.** En maintenance, c'est une modernisation de sécurité que tu sauras faire et justifier.

**Le pattern Repository.** La même couche d'accès propre qu'aux paliers 4 et 5, en PHP — un transfert d'architecture.

**Et savoir que la base est la dernière ligne de défense.** Les contraintes de schéma (palier 4, leçon 06) complètent les requêtes préparées : trois niveaux de défense (client, serveur, base), que tu transposes ici.

---

## 📚 À lire

**php.net → *PDO*** : la référence, avec `PDO::prepare`, `PDOStatement::execute`, `fetch`, les options de connexion.

**phptherightway.com → *Databases*** : la bonne façon d'accéder aux bases en PHP moderne (PDO, requêtes préparées), contre les vieux tutoriels à base de `mysql_query`.

**php.net → *PDO::__construct*** pour les options (`ATTR_ERRMODE`, `ATTR_DEFAULT_FETCH_MODE`, `ATTR_EMULATE_PREPARES`).

**OWASP → *SQL Injection Prevention Cheat Sheet*** : la référence de sécurité, la même qu'au palier 4.

Relis le palier 4, leçon 05 (SQL) et leçon 09 (injection), et le palier 5, leçon 07 (SQLite + Repository) : tout se transfère.

---

## 🤖 Le mini-projet à demander à l'IA

Le transfert de la couche d'accès, et la sécurité :

> « Je suis en formation de développeur, palier 6. J'ai construit une couche d'accès aux données avec sqlite3 au palier 5 et avec Prisma au palier 4, toujours avec le pattern Repository et des requêtes paramétrées. Je refais la même chose en PHP avec PDO et MySQL. Sans me donner de code, guide-moi par questions : comment je configure PDO (quelles options et pourquoi), comment j'écris une requête préparée (positionnelle et nommée), comment je structure mon DepotDepenses. Quand je te montre mon code, vérifie que toutes mes requêtes sont paramétrées et que mes services ne contiennent aucun SQL. »

Puis la sécurité, en cadre défensif :

> « Donne-moi 5 requêtes PDO, et pour chacune, aide-moi à vérifier qu'elle est bien paramétrée. Pose-moi la question "que se passerait-il si la donnée contenait une apostrophe ou du SQL ?" pour chacune, et confirme que ma version paramétrée traite la donnée comme une donnée inoffensive. Montre-moi aussi un exemple de code `mysql_query` ancien et demande-moi de le moderniser en PDO — sans me donner la solution. »

---

## 🛠️ À faire

1. **Crée une base MySQL** (via phpMyAdmin ou en ligne de commande) avec une table `depenses`, en reprenant le schéma du palier 4 (contraintes comprises).
2. **Connexion PDO** : connecte-toi avec les trois options (`ERRMODE_EXCEPTION`, `FETCH_ASSOC`, `EMULATE_PREPARES => false`) et `utf8mb4`. Gère l'échec de connexion proprement (log, message neutre).
3. **⭐ Requête préparée** : écris une recherche avec un paramètre positionnel `?`, puis avec un paramètre nommé `:cat`. Vérifie qu'une donnée contenant une apostrophe est traitée comme une chaîne normale.
4. **CRUD** : implémente `lister`, `parId`, `creer` (avec `lastInsertId`), `supprimer` (avec `rowCount`).
5. **Le pattern Repository** : regroupe tout dans une classe `DepotDepenses` qui reçoit la connexion PDO par le constructeur. Vérifie qu'aucun SQL ne fuit ailleurs.
6. **Une transaction** : un transfert entre deux comptes, avec `beginTransaction`/`commit`/`rollBack`. Fais échouer la seconde opération et vérifie que la première est annulée.
7. **Le piège du silence** : connecte-toi SANS `ERRMODE_EXCEPTION`, fais une requête erronée, et constate l'échec silencieux. Puis active-le et constate l'exception.
8. **⭐ Démontre l'injection** : en cadre défensif sur ta base de test, écris une requête concaténée vulnérable, constate qu'une saisie avec apostrophe casse la requête, puis corrige avec une requête préparée et vérifie que l'attaque échoue.
9. **Moderniser `mysql_query`** : prends un exemple de code ancien avec `mysql_query` et concaténation, et réécris-le en PDO préparé.
10. **Le lien** : note dans ton journal la correspondance entre PDO (PHP), `sqlite3` (Python, palier 5) et `pg`/Prisma (Node, palier 4) — même pattern, même protection.

<details>
<summary>Corrections et points de contrôle</summary>

**3.** Avec un paramètre, `"c'est"` est stocké et comparé comme une chaîne ordinaire : la requête fonctionne. Avec une concaténation, cette apostrophe casserait la syntaxe. En PDO, le marqueur est `?` ou `:nom`, mais le principe est **exactement** celui du palier 4 (`$1`) et du palier 5 (`?`) : la donnée ne touche jamais le texte de la requête. C'est la troisième fois que tu le vois — et c'est la preuve que c'est un concept universel.

**7.** Sans `ERRMODE_EXCEPTION`, PDO échoue **silencieusement** par défaut : une requête erronée renvoie `false` sans rien signaler, et tu débogues à l'aveugle. Avec, elle lève une `PDOException` que tu peux attraper et traiter (palier 1, leçon 08). **Active toujours `ERRMODE_EXCEPTION`** — c'est le premier réflexe de configuration de PDO.

**8.** C'est la démonstration de sécurité, pour la troisième fois du parcours. Une requête concaténée avec une saisie contenant une apostrophe casse la syntaxe SQL (symptôme visible : une erreur), ce qui signale que la donnée est interprétée comme du code. Une requête préparée traite cette même saisie comme une donnée inoffensive. **Les requêtes préparées ferment l'injection par construction**, en PHP comme en Node et Python. Et attention : `EMULATE_PREPARES => false` garantit de vraies requêtes préparées côté serveur, plus sûres que l'émulation par défaut de certaines configurations.

**10.** La correspondance : PDO `prepare`/`execute` (PHP) ↔ `sqlite3` `execute` avec `?` (Python) ↔ `pool.query` avec `$1` (Node) ↔ Prisma qui paramètre automatiquement. Le pattern Repository est identique dans les trois. La protection contre l'injection est identique. **Tu as écrit la même couche d'accès dans trois langages** — c'est exactement le transfert que le parcours construit, et ta meilleure preuve de compréhension en entretien.
</details>

---

## ✅ Acquis si…

- [ ] Je me connecte avec PDO en configurant `ERRMODE_EXCEPTION`, `FETCH_ASSOC` et `utf8mb4`.
- [ ] J'utilise **toujours** des requêtes préparées (`?` ou `:nom`), jamais de concaténation.
- [ ] J'implémente un CRUD complet avec `lastInsertId` et `rowCount`.
- [ ] Je structure l'accès aux données en Repository, injecté avec PDO.
- [ ] Mes services ne contiennent aucune requête SQL.
- [ ] J'utilise une transaction quand deux écritures doivent rester cohérentes.
- [ ] Je sais pourquoi `ERRMODE_EXCEPTION` est indispensable.
- [ ] J'ai reproduit puis neutralisé une injection SQL, pour la troisième fois du parcours.
- [ ] Je sais reconnaître `mysql_query` et le remplacer par PDO.
- [ ] Je fais le lien entre PDO, sqlite3 et pg/Prisma : même pattern, même protection.

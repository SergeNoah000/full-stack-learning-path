# Leçon 07 — Une couche modèles : accès SQLite avec requêtes préparées

> 🎯 **À la fin de cette leçon** : ton mini-framework persiste ses données dans une vraie base, derrière une couche d'accès propre — et tu sais pourquoi on ne concatène jamais une requête.
> ⏱️ 4 h · **Prérequis** : leçons 04–06, et les leçons 05 (SQL) et 07 (ORM, pattern Repository) du palier 4.

---

## De quoi on parle

Jusqu'ici, ton mini-framework route et traite des requêtes, mais ses données vivent en mémoire ou dans un fichier JSON. Il lui manque une **couche modèles** : le code qui parle à la base de données, isolé du reste.

**SQLite** est une base de données relationnelle **sans serveur** : toute la base tient dans un seul fichier, et le module `sqlite3` est **inclus dans Python**, sans rien à installer. C'est parfait pour apprendre et pour un petit projet.

La **couche modèles** (ou dépôts, pattern *Repository* du palier 4) regroupe toutes les requêtes SQL. Elle expose des fonctions métier (`lister`, `creer`, `par_id`) et cache le SQL au reste de l'application.

Et les **requêtes préparées** (ou paramétrées) sont la règle absolue : les données ne sont jamais insérées dans le texte de la requête, mais passées séparément. C'est la protection contre l'injection SQL (palier 4, leçon 09).

---

## À quoi ça sert, concrètement

**Parce qu'une application sans persistance n'en est pas une.** Tout ce que tu as construit — routeur, Request/Response, vues — ne sert à rien si les données disparaissent au redémarrage. La couche modèles donne à ton mini-framework une vraie mémoire.

**Parce que c'est le pattern Repository du palier 4, en Python.** Tu as appris à isoler l'accès aux données derrière une interface, avec Prisma. Ici tu le refais à la main avec `sqlite3` — et tu comprends donc ce qu'un ORM fait pour toi. Après cette leçon, l'ORM de Django (leçon 11) n'aura plus rien de mystérieux.

**Parce que les requêtes préparées ne sont pas négociables.** Tu as exploité une injection SQL au palier 4 (leçon 09, en cadre défensif). Tu sais ce qui arrive quand la frontière entre code et donnée est franchie. En Python comme en Node, la parade est la même : des paramètres, jamais de concaténation.

**Et parce que SQLite est un vrai outil, pas un jouet.** Il est utilisé en production dans d'innombrables applications (mobiles, embarquées, petits sites). Tu le reverras au palier 9 pour le stockage local en Flutter. Savoir s'en servir est utile au-delà de ce palier.

---

## Où ça intervient dans le développement

La couche modèles est la dernière couche de ton mini-framework :

```
   VUES (Request → Response)      ← leçon 06
        ▼
   SERVICES (logique métier)      ← leçon 06
        ▼
   COUCHE MODÈLES (requêtes SQL)  ← CETTE LEÇON
        ▼
   SQLite (un fichier .db)
```

C'est exactement l'architecture en couches du palier 4 : vues (contrôleurs) → services → dépôts → base. Tu la reconstruis en Python, et le découpage te sert à nouveau : seule la couche modèles connaît le SQL, les services ne voient que des fonctions métier.

Trois points de transfert.

**C'est le SQL et le Repository du palier 4.** Les requêtes (`SELECT`, `INSERT`, les `JOIN`), le pattern Repository, les requêtes préparées : tu as tout vu. Ici, tu l'appliques avec `sqlite3` au lieu de `pg` + Prisma. Le SQL est quasi identique (SQLite a quelques différences mineures) ; la bibliothèque change.

**Elle prépare l'ORM de Django.** Au palier 4, tu as écrit du SQL brut (leçon 05) **puis** utilisé un ORM (leçon 07). Ici tu écris du SQL brut une seconde fois. Quand Django te donnera son ORM (leçon 11), tu sauras précisément ce qu'il automatise — et tu reconnaîtras le problème N+1 si tu le vois.

**Et le pattern Repository rend le stockage remplaçable.** Comme au palier 4, isoler les requêtes dans une couche permet de changer de base (SQLite → PostgreSQL) sans toucher aux services. C'est ce que tu feras au palier 5 quand tu passeras à Django avec PostgreSQL.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas apprécier SQLite : aucune installation, aucun serveur, un fichier et ça marche. Tu vas écrire tes requêtes à la main, et retrouver le SQL du palier 4.

Tu vas aussi, presque certainement, être tenté de construire une requête par concaténation de chaînes (« c'est plus simple »). Résiste, et fais l'exercice qui te montre pourquoi — en cadre défensif, sur ta propre base.

### En équipe, en entreprise

**SQLite est partout, mais rarement pour une grosse application web multi-utilisateurs.** Il excelle pour le stockage local, les tests, les petits sites, l'embarqué. Pour une application web à forte charge, on utilise PostgreSQL ou MySQL (concurrence d'écriture, réseau). Savoir quand chacun convient est une vraie compétence.

**Le pattern Repository est standard.** Isoler l'accès aux données est une bonne pratique universelle, et tu la retrouveras sous diverses formes (dépôts, DAO, couche de données).

**Les requêtes préparées sont imposées.** Aucun relecteur n'accepte une requête construite par concaténation de données utilisateur. Les linters de sécurité la signalent.

**Et tu entendras « SQLite ne tient pas la charge ».** C'est vrai pour les écritures concurrentes (SQLite verrouille toute la base en écriture), faux pour beaucoup d'usages réels. Le nuancer montre de la maturité.

### Ce qui sert tous les jours, et ce qui est rare

De cette leçon : les requêtes paramétrées (règle absolue), le pattern Repository, et savoir qu'une couche de données s'isole.

Régulièrement : les transactions, `with` pour la connexion, la conversion des lignes en dictionnaires (`row_factory`), la gestion des erreurs de base.

Rare, et hors sujet : les pools de connexions, le *WAL mode* de SQLite, les migrations manuelles (tu as vu les migrations au palier 4, et Django les gérera), les index (tu les as faits au palier 4, ils s'appliquent ici de la même façon), les fonctions SQL personnalisées. Tu les retrouveras par besoin.

---

## La mécanique

### Se connecter et créer le schéma

```python
import sqlite3

def connexion():
    conn = sqlite3.connect("depenses.db")
    conn.row_factory = sqlite3.Row          # ⭐ les lignes se comportent comme des dicts
    return conn

def creer_schema():
    with connexion() as conn:               # with ferme la connexion (leçon 03)
        conn.execute("""
            CREATE TABLE IF NOT EXISTS depenses (
                id          INTEGER PRIMARY KEY AUTOINCREMENT,
                montant     INTEGER NOT NULL CHECK (montant > 0),
                categorie   TEXT NOT NULL,
                description TEXT NOT NULL,
                date        TEXT NOT NULL,
                cree_le     TEXT NOT NULL DEFAULT (datetime('now'))
            )
        """)
```

Le schéma est celui du palier 4 (leçon 06) : clé primaire, `NOT NULL`, `CHECK` sur le montant. Les contraintes sont la dernière ligne de défense (palier 4, leçon 04), et elles valent en SQLite comme en PostgreSQL. Note `row_factory = sqlite3.Row` : il permet d'accéder aux colonnes par leur nom (`ligne["montant"]`) au lieu de leur position — un confort réel.

### ⭐ Les requêtes préparées : la règle absolue

```python
# ❌ JAMAIS : la donnée est concaténée dans le texte de la requête
conn.execute(f"SELECT * FROM depenses WHERE categorie = '{categorie}'")

# ✅ TOUJOURS : la donnée est un paramètre, passée séparément
conn.execute("SELECT * FROM depenses WHERE categorie = ?", (categorie,))
```

C'est la règle que tu connais depuis le palier 4. En `sqlite3`, le marqueur de paramètre est `?` (en `psycopg` c'était `$1` ou `%s`), mais le principe est identique : **la donnée ne touche jamais le texte de la requête**, elle voyage dans un canal séparé que la base n'interprète jamais comme du code. C'est ce qui rend l'injection SQL (palier 4, leçon 09) structurellement impossible.

> ⚠️ Attention à la virgule : `(categorie,)` est un **tuple d'un élément**. `(categorie)` sans virgule est juste une parenthèse, et `sqlite3` lèvera une erreur. C'est un piège Python classique.

### La couche modèles (dépôts)

```python
# depots/depenses.py
import sqlite3
from models import Depense

class DepotDepenses:
    def __init__(self, chemin="depenses.db"):
        self.chemin = chemin

    def _connexion(self):
        conn = sqlite3.connect(self.chemin)
        conn.row_factory = sqlite3.Row
        return conn

    def lister(self, categorie=None):
        with self._connexion() as conn:
            if categorie:
                lignes = conn.execute(
                    "SELECT * FROM depenses WHERE categorie = ? ORDER BY date DESC",
                    (categorie,)                         # paramètre
                ).fetchall()
            else:
                lignes = conn.execute(
                    "SELECT * FROM depenses ORDER BY date DESC"
                ).fetchall()
            return [dict(ligne) for ligne in lignes]     # Row → dict

    def par_id(self, id):
        with self._connexion() as conn:
            ligne = conn.execute(
                "SELECT * FROM depenses WHERE id = ?", (id,)
            ).fetchone()
            return dict(ligne) if ligne else None

    def creer(self, donnees):
        with self._connexion() as conn:
            curseur = conn.execute(
                "INSERT INTO depenses (montant, categorie, description, date) VALUES (?, ?, ?, ?)",
                (donnees["montant"], donnees["categorie"], donnees["description"], donnees["date"])
            )
            conn.commit()
            return self.par_id(curseur.lastrowid)        # renvoie l'objet créé, comme au palier 4

    def supprimer(self, id):
        with self._connexion() as conn:
            curseur = conn.execute("DELETE FROM depenses WHERE id = ?", (id,))
            conn.commit()
            return curseur.rowcount > 0                  # a-t-on supprimé quelque chose ?
```

C'est le pattern Repository du palier 4 : toutes les requêtes à un seul endroit, exposées sous forme de fonctions métier. Les services (leçon 06) appellent `depot.lister()` sans jamais voir une ligne de SQL. Le jour où tu passes à PostgreSQL, tu modifies ce seul fichier.

Note `creer` qui renvoie l'objet créé (avec son `id` généré via `lastrowid`) : c'est le comportement attendu d'une API REST (palier 4, leçon 03), et l'équivalent du `RETURNING *` de PostgreSQL.

### Les transactions

```python
def transferer(self, depense_id, nouvelle_categorie):
    with self._connexion() as conn:
        try:
            conn.execute("UPDATE depenses SET categorie = ? WHERE id = ?",
                         (nouvelle_categorie, depense_id))
            conn.execute("UPDATE statistiques SET ...")
            conn.commit()                                # tout réussit
        except Exception:
            conn.rollback()                              # ou tout est annulé
            raise
```

Comme au palier 4 (leçon 07), une transaction garantit l'atomicité : les deux `UPDATE` réussissent ensemble, ou aucun. `commit()` valide, `rollback()` annule. C'est indispensable dès que deux écritures doivent rester cohérentes.

### Brancher sur les services

```python
# services/depenses.py
depot = DepotDepenses()

def lister(categorie=None):
    return depot.lister(categorie)

def creer(donnees):
    # la logique métier VIT ICI, pas dans le dépôt ni la vue
    if donnees["montant"] <= 0:
        raise ErreurValidation("montant", "doit être positif")
    return depot.creer(donnees)
```

Le découpage est complet : la **vue** (leçon 06) lit la requête et répond, le **service** porte la logique, le **dépôt** fait les requêtes. Chaque couche ne connaît que la suivante. C'est l'architecture du palier 4, reconstruite entièrement à la main — et c'est le bilan que tu écriras à la fin du mini-framework.

---

## Les problèmes que tu vas rencontrer

**`sqlite3.OperationalError: no such table`.** La table n'existe pas : tu n'as pas appelé `creer_schema()`, ou tu interroges le mauvais fichier `.db`.

**Ma requête paramétrée lève une erreur sur le tuple.** Tu as oublié la virgule : `(valeur,)` est un tuple, `(valeur)` ne l'est pas. Pour un seul paramètre, la virgule est obligatoire.

**Mes données ne sont pas sauvegardées.** Tu as oublié `conn.commit()`. SQLite ne persiste une écriture qu'après un commit (le `with` ne commite pas automatiquement les `INSERT`/`UPDATE`).

**`sqlite3.Row` ne se sérialise pas en JSON.** Une `Row` n'est pas un dict. Convertis avec `dict(ligne)` avant de la passer à `json.dumps` — ou tu auras une erreur de sérialisation.

**`database is locked`.** SQLite verrouille toute la base en écriture, et deux écritures simultanées se bloquent. C'est la limite de SQLite pour la concurrence — acceptable en développement, problématique à forte charge (d'où PostgreSQL en production).

**J'ai construit ma requête par concaténation.** Même si ça « marche », c'est une faille d'injection (palier 4, leçon 09). Passe en paramètres, toujours.

**Mon SQL marche en PostgreSQL mais pas en SQLite (ou l'inverse).** Les deux ont des différences mineures (types, fonctions de date, `AUTOINCREMENT` vs `SERIAL`). Le SQL de base est portable, les détails non.

---

## Ce qu'on te demandera

En **entretien**, les requêtes préparées sont une question de sécurité quasi certaine : « comment te protèges-tu de l'injection SQL ? ». La réponse — « requêtes paramétrées, jamais de concaténation » — est la même qu'au palier 4, et c'est le signe que tu l'as comprise dans deux langages.

On peut demander : « qu'est-ce que le pattern Repository et pourquoi ? », « quand utiliserais-tu SQLite plutôt que PostgreSQL ? », « à quoi sert une transaction ? ».

En **test technique**, un accès aux données isolé dans une couche propre, avec des requêtes paramétrées, est valorisé.

---

## Ce qui te démarquera

**Les requêtes paramétrées par réflexe, dans tous les langages.** Savoir que c'est `?` en SQLite, `$1` en PostgreSQL, mais le même principe partout, montre que tu as compris la protection, pas mémorisé une syntaxe.

**Le pattern Repository.** Isoler le SQL dans une couche dédiée, pour rendre le stockage remplaçable, est une architecture que tu transposes du palier 4.

**Savoir quand SQLite suffit.** Dire « SQLite pour ce prototype, ce stockage local ou ces tests ; PostgreSQL dès qu'il y a de la concurrence d'écriture » est un jugement d'ingénieur.

**Et comprendre ce qu'un ORM automatise.** Avoir écrit la couche d'accès à la main deux fois (palier 4 et ici) te permet d'utiliser l'ORM de Django en sachant exactement ce qu'il fait — et de le déboguer.

---

## 📚 À lire

**docs.python.org → *sqlite3*** : la documentation du module. Lis la section sur les requêtes paramétrées (*placeholders*) et `row_factory` — ce sont les deux points de la leçon.

**SQLite → *When To Use SQLite*** (sqlite.org/whentouse.html) : une page honnête des créateurs sur les cas où SQLite convient et ceux où non. Exactement la nuance à connaître.

Relis le palier 4, leçon 05 (SQL) et leçon 07 (Repository, ORM) : le SQL et le pattern sont identiques, et la comparaison ancre le transfert.

---

## 🤖 Le mini-projet à demander à l'IA

Le transfert du Repository du palier 4 :

> « Je suis en formation de développeur, palier 5. Je construis la couche modèles de mon mini-framework avec sqlite3. J'ai déjà fait le pattern Repository au palier 4 avec Prisma. Sans me donner de code, guide-moi par questions pour écrire un DepotDepenses propre : comment j'isole les requêtes, pourquoi j'utilise des paramètres et pas de la concaténation, comment je convertis une Row en dict, et où je mets la gestion des transactions. Quand je te montre mon code, vérifie que mes services ne contiennent aucune requête SQL et que toutes mes requêtes sont paramétrées. »

Puis la vérification de sécurité, en cadre défensif :

> « Donne-moi 5 requêtes de mon dépôt, et pour chacune, aide-moi à vérifier qu'elle est bien paramétrée et non vulnérable à l'injection. Pose-moi la question "que se passerait-il si la donnée contenait une apostrophe ?" pour chacune, et confirme que ma version paramétrée traite la donnée comme une donnée inoffensive. »

---

## 🛠️ À faire

1. **Le schéma** : crée la table `depenses` avec `sqlite3`, avec clé primaire, `NOT NULL` et `CHECK`. Vérifie que le fichier `.db` est créé.
2. **`row_factory`** : active `sqlite3.Row`, lis une ligne, et accède à une colonne par son nom.
3. **⭐ Requête paramétrée** : écris une requête de recherche avec `?`, et vérifie qu'une donnée contenant une apostrophe est traitée comme une chaîne normale.
4. **Le piège du tuple** : écris une requête à un paramètre avec `(valeur)` sans virgule, constate l'erreur, puis corrige avec `(valeur,)`.
5. **Le DepotDepenses** : implémente `lister`, `par_id`, `creer` (qui renvoie l'objet créé) et `supprimer`. Toutes les requêtes paramétrées.
6. **Le commit oublié** : fais un `INSERT` sans `conn.commit()`, vérifie que la donnée n'est pas persistée, puis ajoute le commit.
7. **Row → dict** : essaie de sérialiser une `Row` en JSON directement, constate l'erreur, puis convertis avec `dict()`.
8. **Une transaction** : deux `UPDATE` dans une transaction, avec un `rollback` en cas d'erreur. Fais échouer le second et vérifie que le premier est annulé.
9. **Brancher le tout** : connecte le dépôt aux services (leçon 06), et vérifie que tes vues persistent réellement les données dans SQLite.
10. **Le bilan du mini-framework** : ton mini-framework route, gère Request/Response, et persiste. Écris dans ton journal la liste de tout ce que tu as dû construire à la main — c'est la liste exacte de ce qu'un framework (Flask, Django) vend.

<details>
<summary>Corrections et points de contrôle</summary>

**3.** Avec un paramètre, une apostrophe dans la donnée (`"c'est"`) est stockée telle quelle, comme un caractère ordinaire : la requête fonctionne normalement et ne peut pas être détournée. Avec une concaténation, cette même apostrophe casserait la syntaxe de la requête — c'est le signe que la donnée a franchi la frontière du code. **C'est la démonstration, en Python, de ce que tu avais vu au palier 4 : les requêtes préparées traitent la donnée comme une donnée, par construction.**

**4.** `(valeur)` en Python n'est pas un tuple — les parenthèses sont juste un groupement. `sqlite3` attend une séquence de paramètres, donc `(valeur,)` avec la virgule, ou `[valeur]`. C'est un piège Python classique qui déroute au début.

**6.** SQLite n'écrit réellement une modification qu'après `commit()`. Sans lui, l'`INSERT` existe dans la transaction courante mais disparaît quand la connexion se ferme. Le `with` ferme la connexion mais ne commite pas automatiquement les écritures — d'où le `conn.commit()` explicite.

**10.** La liste attendue est la même qu'au palier 4 et au palier 5 (leçon 04) : le routage, l'extraction des paramètres, le parsing du corps, l'abstraction Request/Response, l'encodage, les codes de statut, la gestion centralisée des erreurs, la couche d'accès aux données, et bientôt les templates (leçon 08). **C'est exactement ce que Flask et Django fournissent — et tu l'as écrit toi-même, donc tu ne le verras plus jamais comme de la magie.** C'est le but de tout le module « natif d'abord ».
</details>

---

## ✅ Acquis si…

- [ ] Je connecte SQLite et crée un schéma avec contraintes.
- [ ] J'utilise `sqlite3.Row` pour accéder aux colonnes par leur nom.
- [ ] J'utilise **toujours** des requêtes paramétrées (`?`), jamais de concaténation.
- [ ] Je connais le piège du tuple à un élément (`(valeur,)`).
- [ ] J'ai une couche de dépôts qui isole tout le SQL, suivant le pattern Repository.
- [ ] Mes services n'écrivent aucune requête SQL.
- [ ] Je n'oublie pas `conn.commit()` sur les écritures.
- [ ] Je convertis les `Row` en dict avant de les sérialiser en JSON.
- [ ] J'utilise une transaction quand deux écritures doivent rester cohérentes.
- [ ] Je sais quand SQLite suffit et quand il faut PostgreSQL.
- [ ] J'ai dressé la liste de ce que mon mini-framework a fallu construire à la main.

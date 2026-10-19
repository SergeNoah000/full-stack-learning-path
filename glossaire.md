# 📖 Glossaire

> Le vocabulaire du métier, expliqué simplement. **Mode d'emploi** : quand tu croises un mot inconnu, cherche-le ici d'abord ; s'il n'y est pas, ajoute-le avec ta propre définition une fois comprise. Écrire la définition soi-même est l'exercice, pas la lire.
> Colonne « P » = palier où le terme apparaît pour la première fois.

## 🧰 Généralités & outils

| Terme | Définition | P |
|-------|-----------|---|
| **Shell / Terminal** | Le terminal est la fenêtre, le shell (bash, zsh) est le programme qui interprète ce que tu y tapes. | 0 |
| **CLI** | *Command Line Interface* — un programme qui s'utilise au clavier dans le terminal, sans interface graphique. | 0 |
| **Chemin absolu / relatif** | Absolu = depuis la racine (`/home/toi/projet`). Relatif = depuis où tu es (`./src`, `../autre`). | 0 |
| **Variable d'environnement** | Valeur fournie au programme par le système, hors du code (ex. `DATABASE_URL`). C'est là que vivent les secrets. | 0 |
| **IDE / Éditeur** | Logiciel pour écrire du code (VS Code). « IDE » ajoute débogueur et outils intégrés. | 0 |
| **WSL2** | *Windows Subsystem for Linux* — un vrai Linux à l'intérieur de Windows. Indispensable pour développer côté serveur sous Windows. | 0 |
| **Dépendance** | Bibliothèque externe que ton projet utilise. Gérée par npm (JS), pip (Python), Composer (PHP), pub (Dart). | 0 |
| **Gestionnaire de paquets** | Outil qui installe et versionne les dépendances : `npm`, `pip`/`uv`, `composer`, `pub`. | 1 |
| **Markdown** | Langage de mise en forme en texte brut (`# titre`, `**gras**`). Les README et ce dossier sont en Markdown. | 0 |
| **Open source** | Code dont la source est publique et réutilisable selon une licence (MIT, GPL…). | 0 |

## 🌿 Git & GitHub

| Terme | Définition | P |
|-------|-----------|---|
| **Git** | Le logiciel de gestion de versions, installé sur ta machine. Il mémorise l'histoire de ton code. | 0 |
| **GitHub** | Un site qui héberge des dépôts Git en ligne. Git ≠ GitHub (comme email ≠ Gmail). | 0 |
| **Repository (repo)** | Un projet suivi par Git : les fichiers + tout leur historique. | 0 |
| **Commit** | Une photo de l'état du projet à un instant, avec un message. L'unité de base de l'historique. | 0 |
| **Branche** | Une ligne d'historique parallèle, pour travailler sans casser `main`. | 0 |
| **Merge** | Fusionner une branche dans une autre. Un **conflit** survient quand les deux ont modifié la même ligne. | 0 |
| **Remote / origin** | Le dépôt distant (sur GitHub). `origin` est son nom par convention. | 0 |
| **push / pull / clone** | Envoyer tes commits / récupérer ceux du distant / copier un repo distant chez toi. | 0 |
| **Pull Request (PR)** | Demande d'intégrer une branche dans une autre, avec relecture. Le rituel du travail en équipe. | 0 |
| **`.gitignore`** | Fichier listant ce que Git doit ignorer : `node_modules`, `.env`, builds. | 0 |
| **Clé SSH** | Paire de clés (privée/publique) qui t'authentifie sans mot de passe. La privée ne quitte JAMAIS ta machine. | 0 |
| **Fork** | Copie d'un repo d'autrui sur ton compte, pour y contribuer. | 0 |

## 🌐 Web & réseau

| Terme | Définition | P |
|-------|-----------|---|
| **Client / Serveur** | Le client demande (navigateur, app mobile), le serveur répond. Tout le web est ce dialogue. | 0 |
| **HTTP / HTTPS** | Le protocole de ce dialogue. HTTPS = HTTP chiffré par TLS (le cadenas). | 0 |
| **Requête / Réponse** | Requête = méthode + URL + en-têtes + corps. Réponse = code de statut + en-têtes + corps. | 0 |
| **Méthode HTTP** | Le verbe : `GET` (lire), `POST` (créer), `PUT`/`PATCH` (modifier), `DELETE` (supprimer). | 0 |
| **Code de statut** | `2xx` ça a marché · `3xx` redirection · `4xx` **ta** faute (404, 401, 403) · `5xx` faute du serveur. | 0 |
| **En-tête (header)** | Métadonnée de la requête/réponse : `Content-Type`, `Authorization`, `Cookie`. | 0 |
| **URL** | `https://site.com:443/chemin?clé=valeur#ancre` — protocole, domaine, port, chemin, query string, fragment. | 0 |
| **DNS** | L'annuaire qui traduit `google.com` en adresse IP. | 0 |
| **Port** | Numéro de « porte » sur une machine : 80 (HTTP), 443 (HTTPS), 3000/5000/8000 (serveurs de dev). | 0 |
| **API** | *Application Programming Interface* — une porte d'entrée programmatique : une URL qui renvoie des données (souvent JSON) au lieu d'une page. | 0 |
| **JSON** | Format d'échange de données universel : objets `{}`, tableaux `[]`, chaînes, nombres, booléens. | 1 |
| **REST** | Style d'API : une URL par ressource, le verbe HTTP porte l'action (`GET /users/5`). | 4 |
| **CORS** | Règle du navigateur qui bloque les appels vers un autre domaine, sauf si le serveur l'autorise. Première grosse frustration de tout débutant. | 2 |
| **Cookie** | Petite donnée que le serveur fait stocker au navigateur et qui revient à chaque requête. Base des sessions. | 2 |
| **Statique / Dynamique** | Statique = fichiers servis tels quels (GitHub Pages). Dynamique = page ou réponse calculée par un programme à chaque requête. | 2 |
| **CDN** | Réseau de serveurs répartis dans le monde qui servent des fichiers depuis le point le plus proche. | 7 |
| **Reverse proxy** | Serveur placé devant ton app : il reçoit les requêtes, gère HTTPS et les transmet (Nginx, Caddy). | 8 |

## 💻 Programmation (concepts)

| Terme | Définition | P |
|-------|-----------|---|
| **Variable** | Un nom qui désigne une valeur en mémoire. | 1 |
| **Type** | La nature d'une valeur : texte (string), nombre, booléen, tableau, objet… | 1 |
| **Fonction** | Un bloc de code nommé qui prend des **paramètres** et **retourne** une valeur. L'outil n°1 contre la répétition. | 1 |
| **Paramètre / Argument** | Paramètre = le nom dans la définition. Argument = la valeur passée à l'appel. | 1 |
| **Portée (scope)** | La zone du code où une variable existe. | 1 |
| **Closure** | Une fonction qui « se souvient » des variables de l'endroit où elle a été créée, même après la fin de celui-ci. | 1 |
| **Récursivité** | Une fonction qui s'appelle elle-même, avec une condition d'arrêt. | 1 |
| **Mutation** | Modifier une valeur existante au lieu d'en créer une nouvelle. Source classique de bugs. | 1 |
| **Itération** | Parcourir une collection élément par élément. | 1 |
| **Synchrone / Asynchrone** | Synchrone = chaque instruction attend la précédente. Asynchrone = on lance une tâche longue (réseau, disque) et on continue en attendant sa réponse. | 1 |
| **Promise** | Objet qui représente « un résultat qui arrivera plus tard » : en attente → tenue ou rompue. | 1 |
| **`async` / `await`** | Syntaxe qui fait ressembler du code asynchrone à du code synchrone, sans le bloquer. | 1 |
| **Callback** | Fonction passée à une autre pour être appelée plus tard (« rappelle-moi quand c'est prêt »). | 1 |
| **Event loop** | La boucle qui, en JS, exécute le code puis traite les tâches terminées. Explique pourquoi JS est mono-thread mais non bloquant. | 1 |
| **Exception / `try/catch`** | Une erreur qui interrompt le flux normal ; `try/catch` permet de l'intercepter et de réagir. | 1 |
| **Stack trace** | La liste des appels de fonction au moment de l'erreur. **Se lit de haut en bas**, la première ligne de ton code est la bonne piste. | 1 |
| **Complexité (Big O)** | Comment le temps d'exécution grandit avec la taille des données. `O(n)` linéaire, `O(n²)` une boucle dans une boucle (à fuir). | 1 |
| **Structure de données** | Façon d'organiser des données : tableau, objet/dictionnaire, Map, Set, pile, file. | 1 |
| **POO** | Programmation orientée objet : **classes** (moules), **objets** (instances), **héritage**, **encapsulation**. | 1 |
| **Interface** | Un contrat : la liste des méthodes qu'une classe doit fournir, sans dire comment. | 5 |
| **Typage statique / dynamique** | Statique = les types sont vérifiés avant l'exécution (TypeScript). Dynamique = à l'exécution (JS, Python, PHP). | 3 |
| **Refactoring** | Améliorer la structure du code **sans changer son comportement**. | 7 |
| **Dette technique** | Le coût futur des raccourcis pris aujourd'hui. | 7 |

## 🎨 Frontend

| Terme | Définition | P |
|-------|-----------|---|
| **HTML sémantique** | Utiliser la balise qui dit le *sens* (`<nav>`, `<article>`) plutôt que des `<div>` partout. Essentiel pour l'accessibilité et le SEO. | 2 |
| **DOM** | *Document Object Model* — la représentation en mémoire de la page, que JS manipule. | 2 |
| **CSS : box model** | Tout élément = contenu + `padding` + `border` + `margin`. La base de tout positionnement. | 2 |
| **Spécificité CSS** | Les règles de priorité entre sélecteurs quand plusieurs s'appliquent. | 2 |
| **Flexbox / Grid** | Les deux systèmes de mise en page modernes : Flexbox sur un axe, Grid sur deux. | 2 |
| **Responsive / Mobile-first** | S'adapter à toutes les tailles d'écran ; concevoir pour mobile d'abord, puis élargir. | 2 |
| **Media query** | Règle CSS conditionnelle selon la taille d'écran. | 2 |
| **Accessibilité (a11y)** | Rendre le site utilisable par tous, y compris avec un lecteur d'écran. | 2 |
| **localStorage** | Stockage clé/valeur persistant dans le navigateur (quelques Mo, par domaine). | 2 |
| **SPA** | *Single Page Application* — une seule page HTML, le JS remplace le contenu sans rechargement. | 3 |
| **SSR / CSR** | Rendu de la page côté serveur / côté client (navigateur). | 5 |
| **Composant** | Un morceau d'interface réutilisable et autonome (son balisage, son style, sa logique). | 3 |
| **État (state)** | Les données qui changent dans le temps et dont dépend l'affichage. | 3 |
| **Props** | Les données qu'un composant parent passe à son enfant (en lecture seule). | 3 |
| **Hook** | Fonction React qui donne accès à l'état et au cycle de vie (`useState`, `useEffect`). | 3 |
| **Build / Bundler** | Transformer le code source en fichiers optimisés pour le navigateur (Vite, webpack). | 3 |
| **Transpilation** | Traduire un langage vers un autre équivalent (TypeScript → JavaScript). | 3 |

## 🗄️ Backend & bases de données

| Terme | Définition | P |
|-------|-----------|---|
| **Base de données relationnelle** | Données en tables (lignes/colonnes) reliées entre elles. PostgreSQL, MySQL, SQLite. | 4 |
| **SQL** | Le langage d'interrogation des bases relationnelles (`SELECT … FROM … WHERE`). | 4 |
| **Clé primaire / étrangère** | Primaire = identifiant unique d'une ligne. Étrangère = référence vers la clé primaire d'une autre table. | 4 |
| **JOIN** | Croiser deux tables sur une colonne commune. | 4 |
| **Index** | Structure qui accélère énormément les recherches sur une colonne (au prix d'écritures plus lentes). | 4 |
| **Transaction** | Un groupe d'opérations tout-ou-rien (débiter ET créditer, jamais l'un sans l'autre). | 4 |
| **Migration** | Fichier versionné décrivant un changement de schéma de base. L'historique Git de ta BDD. | 4 |
| **ORM** | Couche qui traduit objets du code ↔ lignes en base (Prisma, Eloquent, Django ORM, SQLAlchemy). | 4 |
| **Injection SQL** | Faille où l'utilisateur injecte du SQL via un champ. Parade : **requêtes préparées**, toujours. | 4 |
| **XSS** | Faille où du JS d'autrui s'exécute dans ta page. Parade : échapper tout affichage de données utilisateur. | 4 |
| **CSRF** | Faille où un autre site fait exécuter une action à ton utilisateur connecté. Parade : jeton CSRF. | 4 |
| **Authentification / Autorisation** | *Qui es-tu ?* (login) vs *as-tu le droit ?* (rôles, permissions). Deux choses distinctes. | 4 |
| **Hachage (hash)** | Transformation irréversible d'un mot de passe (bcrypt, argon2). Un mot de passe ne se chiffre pas, il se hache. | 4 |
| **Session** | État de connexion gardé côté serveur, référencé par un cookie. | 4 |
| **JWT** | Jeton signé, autonome, envoyé à chaque requête (`Authorization: Bearer …`). | 4 |
| **Middleware** | Fonction qui s'exécute entre la requête et la réponse (log, auth, validation). | 4 |
| **Validation** | Vérifier les données entrantes avant traitement. **Côté serveur obligatoirement** (le client est manipulable). | 4 |
| **Rate limiting** | Limiter le nombre de requêtes par client pour éviter abus et surcharge. | 7 |
| **Idempotence** | Rejouer la même opération ne change pas le résultat (crucial pour les paiements). | 7 |
| **WSGI / ASGI** | Interface standard entre un serveur web et une app Python (ASGI = sa version asynchrone). | 5 |
| **Front controller** | Pattern où toutes les requêtes passent par un unique fichier d'entrée (`index.php`). Base de tous les frameworks PHP. | 6 |
| **Routeur** | Le composant qui associe une URL + une méthode HTTP à un bout de code. | 5 |
| **MVC / MVT** | Découpage Modèle (données) / Vue (affichage) / Contrôleur (orchestration). Django dit « MVT » (Template). | 6 |
| **Superglobale** | Variable PHP toujours disponible : `$_GET`, `$_POST`, `$_SESSION`, `$_SERVER`. | 6 |
| **PDO** | La couche d'accès aux bases de PHP, avec requêtes préparées. | 6 |
| **Active Record / Data Mapper** | Deux philosophies d'ORM : l'objet sait se sauver lui-même (Eloquent) / un service traduit entre objets et base (Prisma). | 6 |
| **Queue (file de tâches)** | File où l'on dépose les travaux longs (emails, exports) traités en arrière-plan par un *worker*. | 6 |
| **Cache** | Garder un résultat coûteux pour le resservir vite. Le vrai problème n'est pas de cacher, c'est d'**invalider**. | 7 |
| **Stateless** | Le serveur ne garde rien entre deux requêtes — condition pour pouvoir le dupliquer. | 7 |

## 🚀 DevOps & production

| Terme | Définition | P |
|-------|-----------|---|
| **Déploiement** | Mettre son code en service sur un serveur accessible. | 2 |
| **Environnement** | Dev (ta machine) / staging (copie de test) / prod (les vrais utilisateurs). | 4 |
| **VPS** | *Virtual Private Server* — un serveur Linux loué, que tu administres entièrement (~5 €/mois). | 8 |
| **PaaS** | *Platform as a Service* — on pousse le code, la plateforme gère le reste (Render, Vercel, Railway). | 4 |
| **Hébergement mutualisé** | Un serveur partagé avec cPanel/FTP, roi du monde PHP. | 6 |
| **Conteneur / Image** | Image = modèle figé (code + dépendances + config). Conteneur = une instance en cours d'exécution. | 8 |
| **Docker Compose** | Décrire et lancer plusieurs conteneurs liés (app + BDD + proxy) en une commande. | 8 |
| **CI/CD** | *Continuous Integration / Delivery* — à chaque push : tests automatiques, puis déploiement automatique. | 8 |
| **Pipeline / Workflow** | La suite d'étapes automatisées du CI/CD. | 8 |
| **Runner** | La machine qui exécute un job de pipeline. | 8 |
| **Secret** | Valeur sensible (mot de passe, clé d'API). Jamais dans Git : `.env` local + secrets du CI. | 4 |
| **Certificat TLS / Let's Encrypt** | Ce qui permet le HTTPS ; Let's Encrypt en délivre gratuitement et automatiquement. | 8 |
| **Pare-feu (ufw)** | Filtre les ports accessibles sur un serveur. Sur un VPS : on ouvre SSH, 80, 443, et rien d'autre. | 8 |
| **systemd** | Le gestionnaire de services Linux : démarrer, relancer, consulter les logs d'un programme. | 8 |
| **Observabilité** | Savoir ce que fait l'app en prod : logs, métriques, alertes. | 8 |
| **Les 4 signaux** | Latence, trafic, erreurs, saturation — ce qu'on surveille en priorité. | 8 |
| **Uptime / SLA** | Taux de disponibilité, et l'engagement contractuel associé. | 8 |
| **Sauvegarde / Restauration** | Un backup **jamais restauré n'existe pas**. Le test de restauration fait partie de la sauvegarde. | 8 |
| **Scalabilité verticale / horizontale** | Grossir la machine / multiplier les machines derrière un load balancer. | 7 |
| **TCO** | *Total Cost of Ownership* — le coût réel sur un an : hébergement + domaine + services + maintenance. | 8 |

## 📋 Gestion de projet

| Terme | Définition | P |
|-------|-----------|---|
| **Cadrage** | Écrire ce qu'on construit, pour qui, et ce qu'on ne construit pas — avant de coder. | 2 |
| **Cahier des charges** | Le document de référence : contexte, périmètre, exigences, jalons, critères d'acceptation. | 4 |
| **Périmètre (scope)** | Ce qui est inclus… et surtout ce qui est **exclu**. | 2 |
| **User story** | « En tant que [rôle], je veux [action] afin de [bénéfice]. » Un besoin exprimé côté utilisateur. | 3 |
| **MoSCoW** | Priorisation : *Must* / *Should* / *Could* / *Won't*. | 4 |
| **MVP** | *Minimum Viable Product* — la plus petite version qui rend déjà le service. | 10 |
| **Jalon (milestone)** | Un point d'étape **démontrable**, pas une date dans le vide. | 4 |
| **Kanban** | Tableau À faire / En cours / Fait (GitHub Projects). | 3 |
| **Vélocité** | Ta capacité réelle mesurée (ce que tu livres par semaine). La donnée qui rend tes estimations justes. | 4 |
| **Estimation** | Prévision d'effort, confrontée au réel après coup — sinon c'est de la divination. | 4 |
| **Devis** | Chiffrage commercial : jours × taux + hébergement + domaine + marge d'imprévu. | 6 |
| **Recette (UAT)** | La vérification finale par le client : scénarios → résultat attendu → ✅/❌. | 5 |
| **Critère d'acceptation** | La condition objective qui permet de dire « c'est fini ». | 4 |
| **Scope creep** | Le périmètre qui gonfle en cours de route. Première cause de projets qui meurent. | 6 |
| **Rétrospective** | Bilan de fin d'étape : qu'est-ce que je referais autrement ? | 0 |
| **Timeboxing** | Fixer une durée maximale et livrer ce qui tient dedans. | 1 |

## 🤖 IA

| Terme | Définition | P |
|-------|-----------|---|
| **LLM** | *Large Language Model* — modèle de langage (Claude, GPT) qui prédit du texte. | 0 |
| **Prompt** | Ce que tu lui demandes. **Prompt système** = les consignes permanentes données en amont. | 0 |
| **Token** | L'unité de découpage du texte, et l'unité de facturation des API (~0,75 mot en anglais). | 5 |
| **Hallucination** | Réponse fausse énoncée avec assurance. Raison pour laquelle on ne colle jamais du code non compris. | 0 |
| **Contexte (fenêtre)** | La quantité de texte que le modèle peut considérer d'un coup. | 5 |
| **Streaming** | Recevoir la réponse mot à mot plutôt qu'en bloc. | 5 |
| **API IA** | Appeler un modèle depuis ton code (clé d'API = secret à protéger !). | 5 |
| **Agent** | Un LLM autorisé à utiliser des outils (lire, écrire, exécuter) pour accomplir une tâche. | 10 |

---

## 🗒️ Mes mots à moi

> Ajoute ici tout terme croisé et compris. Le but n'est pas la complétude : c'est que TU écrives la définition.

| Terme | Ma définition | Rencontré où |
|-------|---------------|--------------|
| | | |

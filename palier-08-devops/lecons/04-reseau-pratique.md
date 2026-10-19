# Leçon 04 — Réseau pratique : ports, curl, dig, TLS et certificats

> 🎯 **À la fin de cette leçon** : tu comprends le chemin d'une requête — nom de domaine → IP → port → application — et tu sais diagnostiquer où ça casse, du DNS au certificat TLS.
> ⏱️ 3 h · **Prérequis** : HTTP (palier 0, leçon 06), et les leçons 01-03.

---

## De quoi on parle

Quand une requête arrive à ton serveur, elle a traversé plusieurs étapes réseau. Les comprendre, c'est pouvoir dire **où** ça casse quand « le site ne marche pas ». Quatre notions :

- les **ports** : un serveur a une seule IP mais plusieurs « portes » numérotées — 80 (HTTP), 443 (HTTPS), 22 (SSH), 5432 (PostgreSQL)… Chaque service écoute sur son port.
- **`curl`** : l'outil pour envoyer une requête HTTP depuis le terminal et voir **exactement** la réponse (statut, en-têtes, corps) — le débogueur HTTP universel.
- **`dig`** (et les DNS) : comment un nom de domaine (`monsite.fr`) est traduit en adresse IP, et comment vérifier cette traduction.
- **TLS et certificats** : ce qui rend une connexion « HTTPS » (le cadenas) — le chiffrement et la preuve d'identité du serveur.

Tu connais déjà HTTP (requête/réponse, méthodes, codes — palier 0, leçon 06). Ici, tu descends d'un cran : **par où** passe cette requête HTTP, et comment vérifier chaque maillon. C'est la boîte à outils de diagnostic réseau, indispensable pour exposer ton application au monde (leçon 05) en HTTPS (leçon 09).

---

## À quoi ça sert, concrètement

**Parce que « le site ne marche pas » a dix causes possibles, à dix endroits.** Le domaine ne pointe pas sur le bon serveur (DNS) ? Le port est fermé (pare-feu) ? L'application n'écoute pas ? Le certificat est expiré ? Sans méthode, tu tâtonnes. Avec `curl`, `dig` et la connaissance des ports, tu **localises** la panne au lieu de deviner.

**Parce que `curl` est le débogueur HTTP le plus honnête.** Un navigateur cache des choses (cache, cookies, redirections automatiques). `curl` montre la réponse brute : le vrai code de statut, les vrais en-têtes, le vrai corps. Pour savoir ce que ton API renvoie **réellement** (pas ce que le navigateur en affiche), c'est l'outil.

**Parce que le DNS est la cause numéro un des « ça marche chez moi, pas en ligne ».** Un domaine mal configuré, une propagation pas terminée, un enregistrement manquant : énormément de problèmes de mise en ligne sont des problèmes DNS. Savoir lire `dig` tranche en trente secondes.

**Et parce que HTTPS n'est plus optionnel.** Tout site doit être en HTTPS (les navigateurs marquent « non sécurisé » le HTTP, le référencement en dépend, et les données doivent être chiffrées). Comprendre ce qu'est un certificat, pourquoi il expire, comment vérifier qu'il est valide, est la base pour la mise en HTTPS de la leçon 09.

---

## Où ça intervient dans le développement

Ces notions décrivent le trajet complet d'une requête vers ton application :

```
   Navigateur tape https://monsite.fr
        ▼  1. DNS : monsite.fr → 203.0.113.5          (dig)
        ▼  2. connexion au PORT 443 du serveur         (ports, pare-feu — leçon 09)
        ▼  3. poignée de main TLS : le serveur présente son CERTIFICAT  (TLS)
        ▼  4. requête HTTP chiffrée                      (palier 0, leçon 06)
        ▼  5. le reverse proxy (leçon 05) route vers l'app (port interne)
        ▼  6. l'application répond
   curl permet d'inspecter CHAQUE étape depuis le terminal.
```

Trois ancrages.

**C'est le HTTP du palier 0, vu « par-dessous ».** Tu sais ce qu'est une requête/réponse HTTP. Ici, tu vois ce qu'il y a avant (DNS, port, TLS) et comment l'inspecter. Le `fetch` du navigateur (palier 2) et les requêtes de ton API (palier 4) empruntent ce chemin.

**Les ports préparent le reverse proxy (leçon 05) et le pare-feu (leçon 09).** Comprendre qu'un service écoute sur un port précis est la base pour router avec Nginx (leçon 05, qui écoute sur 80/443 et transmet au port interne de l'app) et pour n'ouvrir que les bons ports avec le pare-feu (leçon 09).

**TLS prépare le HTTPS de la leçon 09.** Ce que tu comprends ici (certificat, expiration, autorité de certification) devient opérationnel leçon 09 quand tu obtiendras un certificat gratuit (Let's Encrypt) et le renouvelleras automatiquement.

---

## Ce que tu verras quand tu travailleras

### Aujourd'hui, en solo

Tu vas interroger des domaines avec `dig`, tester des endpoints avec `curl` (en voyant statuts et en-têtes), vérifier quels ports écoutent sur ton serveur, et inspecter un certificat TLS (émetteur, dates de validité). Tu t'entraîneras à **localiser** une panne : DNS ? port ? app ? certificat ?

### En équipe, en entreprise

**`curl` est dans toutes les boîtes à outils.** Tester une API, reproduire un bug signalé, vérifier un déploiement, scripter un *health check* : `curl` est omniprésent. On s'échange des commandes `curl` pour reproduire un problème exactement.

**Le DNS se gère chez le registrar/hébergeur.** Les enregistrements (A, CNAME, MX…) se configurent dans une interface. Savoir les lire avec `dig` permet de vérifier qu'une modification est bien prise en compte (et la propagation peut prendre du temps — d'où les faux « ça ne marche pas »).

**Les certificats expirés sont une panne récurrente.** Un certificat a une durée de vie (90 jours avec Let's Encrypt). S'il n'est pas renouvelé, le site affiche une grosse alerte de sécurité et devient inaccessible. Le renouvellement automatique (leçon 09) l'évite ; vérifier l'expiration fait partie de la surveillance (leçon 10).

### Ce qui sert tous les jours, et ce qui est rare

Tous les jours : `curl` pour tester un endpoint, connaître les ports usuels (80, 443, 22, 5432, 3306…), vérifier qu'un service écoute.

Régulièrement : `dig` pour vérifier un DNS, inspecter un certificat et sa date d'expiration, `curl -v` pour voir la poignée de main et les en-têtes, tester une redirection HTTP→HTTPS.

Rare ou avancé : l'analyse de paquets (tcpdump, Wireshark), le détail du handshake TLS, les chaînes de certificats complexes, IPv6, les enregistrements DNS exotiques. À connaître de nom ; tu les creuseras par besoin.

---

## La mécanique

### Les ports : les portes du serveur

```
Une IP, plusieurs portes numérotées. Les plus courantes :
   22   SSH (leçon 03)            80   HTTP        443  HTTPS
   5432 PostgreSQL                3306 MySQL       6379 Redis
Règle de sécurité : on n'expose à Internet que 80, 443 (et 22, filtré).
Les ports des bases (5432, 3306) restent FERMÉS au monde (leçon 09) ;
on y accède par tunnel SSH (leçon 03).
```

```bash
sudo ss -tlnp        # quels ports ÉCOUTENT sur ce serveur, et quel processus
```

Un service « écoute » sur un port : il attend les connexions qui s'y présentent. `ss -tlnp` liste les ports ouverts localement et le processus derrière chacun — le premier geste pour vérifier « mon app écoute-t-elle bien ? ». Le principe de sécurité : exposer le moins de ports possible au monde extérieur.

### ⭐ curl : inspecter une réponse HTTP

```bash
curl https://monsite.fr                  # affiche le corps de la réponse
curl -i https://monsite.fr               # avec les en-têtes ET le code de statut
curl -I https://monsite.fr               # SEULEMENT les en-têtes (requête HEAD)
curl -v https://monsite.fr               # verbeux : DNS, connexion, TLS, en-têtes...
curl -X POST -H "Content-Type: application/json" \
     -d '{"montant":10}' https://monsite.fr/api/depenses   # un POST avec corps JSON
curl -L http://monsite.fr                # suivre les redirections (ex. HTTP→HTTPS)
```

`curl` est ton API du palier 4 testée depuis le terminal. `-i` montre le code de statut (palier 0, leçon 06) et les en-têtes — essentiel pour voir ce que le serveur renvoie **vraiment**. `-v` déroule tout le trajet (résolution DNS, connexion au port, poignée de main TLS, échange HTTP) : c'est le mode diagnostic ultime. `-L` suit les redirections, utile pour vérifier qu'un `http://` bascule bien vers `https://`.

### dig : la résolution de nom

```bash
dig monsite.fr                    # quelle IP pour ce domaine ? (enregistrement A)
dig monsite.fr +short             # juste la réponse, concise
dig monsite.fr A                  # l'enregistrement A (IPv4)
dig monsite.fr MX                 # les serveurs de mail
```

Le DNS traduit un nom lisible en adresse IP. `dig monsite.fr +short` répond « sur quelle IP ce domaine pointe-t-il ? ». Si la réponse n'est pas l'IP de ton serveur, voilà ta panne : le domaine ne pointe pas (encore) au bon endroit. La **propagation** d'un changement DNS peut prendre de quelques minutes à quelques heures — beaucoup de « ça ne marche pas » ne sont qu'une propagation en cours.

### ⭐ TLS et certificats : le cadenas

```
HTTPS = HTTP + TLS. Le TLS apporte deux choses :
  1. le CHIFFREMENT : personne entre le client et le serveur ne lit l'échange.
  2. l'IDENTITÉ : le serveur prouve qu'il est bien monsite.fr, via un CERTIFICAT
     signé par une AUTORITÉ DE CERTIFICATION (CA) de confiance.
Un certificat a une DATE D'EXPIRATION. Expiré → le navigateur bloque avec une alerte.
```

```bash
# inspecter le certificat d'un site : émetteur et dates de validité
echo | openssl s_client -connect monsite.fr:443 2>/dev/null | openssl x509 -noout -dates -issuer
curl -vI https://monsite.fr    # curl affiche aussi des infos TLS dans le verbeux
```

Le certificat est la carte d'identité du serveur, signée par une autorité que ton navigateur reconnaît. Il garantit que tu parles bien au vrai `monsite.fr` et que l'échange est chiffré. Son point faible pratique : il **expire** (90 jours pour Let's Encrypt). Vérifier les dates de validité est un geste de diagnostic et de surveillance. Le renouvellement automatique (leçon 09) évite l'expiration surprise.

### La méthode : localiser la panne, maillon par maillon

```
« https://monsite.fr ne répond pas. » On teste le chemin dans l'ordre :
  1. dig monsite.fr +short        → le domaine pointe-t-il sur la bonne IP ?
  2. curl -v http://IP            → le serveur répond-il sur le port 80 ?
  3. ss -tlnp (sur le serveur)    → l'app/le proxy écoutent-ils bien ?
  4. curl -vI https://monsite.fr  → le certificat TLS est-il valide et non expiré ?
  5. journalctl -u ... (leçon 02) → l'application loggue-t-elle une erreur ?
On avance d'un maillon à la fois, sans sauter d'étape. Le premier qui échoue = la cause.
```

C'est la démarche qui remplace le tâtonnement. Chaque outil teste un maillon précis ; le premier maillon rompu est la cause. C'est exactement la pensée de diagnostic de la leçon 10, appliquée au réseau.

---

## Les problèmes que tu vas rencontrer

**« Le domaine ne mène nulle part. »** `dig monsite.fr +short` : si l'IP est vide ou fausse, le DNS n'est pas (bien) configuré, ou la propagation n'est pas finie. Vérifie l'enregistrement A chez ton hébergeur.

**« Connection refused sur le port 80/443. »** Rien n'écoute sur ce port, ou le pare-feu le bloque (leçon 09). `ss -tlnp` sur le serveur : le proxy/l'app écoute-t-il ? Puis vérifie le pare-feu.

**« curl marche en HTTP mais pas en HTTPS. »** Problème TLS : certificat absent, mal configuré, ou expiré. `curl -vI` et l'inspection `openssl` donnent la date d'expiration et l'émetteur.

**« Le navigateur affiche "votre connexion n'est pas privée". »** Certificat expiré, auto-signé, ou pour le mauvais domaine. Inspecte-le ; en production, c'est le signal d'un renouvellement raté (leçon 09).

**« curl renvoie un code que le navigateur ne montre pas. »** C'est le but de `curl` : il montre la réponse brute. Un `500` ou `502` masqué par une page d'erreur jolie apparaît clairement avec `curl -i`.

**« Ça marchait, puis plus rien, pile aujourd'hui. »** Suspecte un certificat expiré (date ronde) ou un changement DNS. Les deux ont des dates ; `dig` et l'inspection du certificat tranchent vite.

---

## Ce qu'on te demandera

En **test DevOps**, le diagnostic réseau est vérifié : « comment testes-tu qu'une API répond, depuis le terminal ? » (`curl -i`), « comment vérifies-tu qu'un domaine pointe sur le bon serveur ? » (`dig`), « qu'est-ce qu'un certificat TLS et pourquoi expire-t-il ? ». On apprécie une **méthode** de localisation de panne, pas une suite de réflexes désordonnés.

On peut demander : « quels ports exposes-tu à Internet et pourquoi pas celui de la base ? », « différence entre HTTP et HTTPS ? », « que fait `curl -L` ? ».

En **mission**, on t'enverra des `curl` pour reproduire des bugs, et on attendra que tu saches dire « la panne est au niveau DNS / port / app / certificat ».

---

## Ce qui te démarquera

**La méthode maillon par maillon.** Face à « le site est down », tester DNS → port → app → certificat dans l'ordre, au lieu de tout changer au hasard, est exactement le réflexe d'un bon opérateur. Tu trouves la cause en minutes.

**Maîtriser `curl`.** Savoir inspecter statut, en-têtes et corps d'une réponse, faire un POST, suivre une redirection, voir le TLS en verbeux — c'est l'outil qui te rend autonome pour tester n'importe quelle API, la tienne ou une tierce.

**Comprendre les certificats au-delà du cadenas.** Savoir qu'un certificat prouve l'identité ET chiffre, qu'il est signé par une autorité, et qu'il expire (d'où le renouvellement automatique), montre que tu comprends HTTPS, pas juste que tu l'actives.

**Et la discipline des ports fermés.** Dire « je n'expose que 80, 443 et un 22 filtré ; la base reste fermée, j'y accède par tunnel » relie réseau et sécurité, et prépare les leçons 05 et 09.

---

## 📚 À lire

**MDN → *An overview of HTTP* et *What is HTTPS/TLS*** : le rappel HTTP (palier 0) et l'explication claire de ce que TLS ajoute.

**La page de manuel `man curl`** et le site curl.se → *tutorial* : `curl` a énormément d'options ; apprends les plus utiles (`-i`, `-I`, `-v`, `-X`, `-d`, `-H`, `-L`).

**Cloudflare Learning Center → *DNS*, *What is a TLS certificate*** : des explications grand public mais justes sur le DNS et les certificats.

**Let's Encrypt → *How it works*** : pour préparer la leçon 09 (certificats gratuits et renouvellement automatique).

Relis le palier 0, leçon 06 (HTTP) : tu en vois ici les couches sous-jacentes et les outils d'inspection.

---

## 🤖 Le mini-projet à demander à l'IA

Construire ta méthode de diagnostic réseau :

> « Je suis en formation de développeur, palier 8 (DevOps). Je connais HTTP depuis le palier 0 mais je veux savoir diagnostiquer où une requête casse : DNS, port, application, ou certificat TLS. Sans me donner les commandes à copier sans comprendre, apprends-moi à inspecter chaque maillon : dig pour vérifier qu'un domaine pointe sur la bonne IP, ss pour voir quels ports écoutent, curl (-i, -I, -v, -L) pour voir la vraie réponse HTTP, et l'inspection d'un certificat pour ses dates de validité. Pour chaque outil, explique-moi ce qu'il teste précisément. »

Puis la méthode de localisation :

> « Donne-moi des scénarios de panne d'un site (le domaine ne pointe nulle part, le port est fermé, l'app ne répond pas, le certificat est expiré) et, pour chacun, fais-moi dérouler le diagnostic maillon par maillon — dig, puis curl sur l'IP, puis ss, puis le certificat — jusqu'à localiser la cause. Ne me dis pas la réponse d'avance : fais-moi raisonner comme si j'étais devant un vrai site en panne. »

---

## 🛠️ À faire

1. **Les ports qui écoutent** : sur ton serveur, lance `ss -tlnp` et identifie quel processus écoute sur quel port (SSH, le proxy, l'app, la base). Note lesquels devraient être exposés à Internet et lesquels non.
2. **⭐ curl de base** : sur ton API du palier 4, teste un endpoint avec `curl -i` (vois le code de statut et les en-têtes), fais un `POST` avec `-d` et `-H`, et compare au comportement du navigateur.
3. **curl verbeux** : lance `curl -v https://...` sur un site en HTTPS et repère, dans la sortie, les étapes : résolution DNS, connexion au port, poignée de main TLS, en-têtes de réponse.
4. **⭐ dig** : interroge un domaine que tu possèdes (ou un domaine public) avec `dig +short`, et vérifie l'IP. Si tu as un VPS avec un domaine, confirme qu'il pointe bien dessus.
5. **La redirection HTTP→HTTPS** : avec `curl -I http://...` puis `curl -IL http://...`, observe la redirection (code `301`/`308`) vers la version HTTPS.
6. **⭐ Inspecter un certificat** : sur un site HTTPS, affiche l'émetteur et les dates de validité du certificat (via `openssl` ou `curl -v`). Note la date d'expiration.
7. **Localiser une panne** : choisis (ou simule) un scénario — DNS faux, port fermé, app arrêtée, certificat expiré — et déroule la méthode maillon par maillon jusqu'à trouver la cause. Écris l'ordre de tes tests.
8. **Les ports fermés** : explique par écrit pourquoi le port de ta base de données ne doit pas être exposé à Internet, et comment un tunnel SSH (leçon 03) te permet d'y accéder quand même.
9. **Le lien** : dans ton journal, dessine le trajet complet `nom de domaine → IP → port → TLS → app`, et associe à chaque étape l'outil qui la teste.

<details>
<summary>Corrections et points de contrôle</summary>

**1 + 8.** `ss -tlnp` révèle les ports en écoute et leur processus. Le principe de sécurité : on **n'expose au monde que le strict nécessaire** — 80 et 443 pour le web, 22 (filtré) pour SSH. Les ports des bases (5432 PostgreSQL, 3306 MySQL) restent fermés à Internet : une base exposée est une cible directe. Pour y accéder depuis ta machine, tu utilises un **tunnel SSH** (leçon 03), qui passe par la connexion SSH chiffrée sans ouvrir la base. C'est le lien entre cette leçon, le reverse proxy (leçon 05) et le pare-feu (leçon 09).

**2-3.** `curl` montre la réponse **brute** : `-i` révèle le vrai code de statut (palier 0) et les en-têtes, que le navigateur peut masquer derrière une jolie page. `-v` déroule tout le trajet réseau. C'est pourquoi `curl` est le débogueur HTTP de référence : il ne ment pas, ne met pas en cache, ne suit pas les redirections sauf si tu le demandes (`-L`). Pour savoir ce que ton API renvoie vraiment, c'est l'outil.

**6.** Un certificat TLS fait deux choses : il **chiffre** l'échange et **prouve l'identité** du serveur (signé par une autorité de confiance). Son talon d'Achille pratique est l'**expiration** : 90 jours pour Let's Encrypt. Un certificat expiré fait bloquer le navigateur (« connexion non privée ») et rend le site inaccessible — une panne « qui tombe un jour rond ». D'où le renouvellement automatique de la leçon 09 et la surveillance de l'expiration (leçon 10).

**7 + 9.** La méthode maillon par maillon est le vrai acquis de la leçon. Une requête traverse DNS → port → TLS → application ; chaque outil teste un maillon (`dig` le DNS, `curl`/`ss` le port et l'app, l'inspection du certificat le TLS). Face à une panne, on teste dans l'ordre et **le premier maillon rompu est la cause** — on ne change pas tout au hasard. C'est la pensée de diagnostic de la leçon 10 appliquée au réseau, et ce qui te rendra efficace en production.
</details>

---

## ✅ Acquis si…

- [ ] Je sais qu'un serveur a une IP et plusieurs ports, et lesquels exposer (ou non).
- [ ] Je vérifie quels ports écoutent avec `ss -tlnp`.
- [ ] J'inspecte une réponse HTTP avec `curl` (`-i`, `-I`, `-v`, `-X`, `-d`, `-L`).
- [ ] Je vérifie la résolution d'un domaine avec `dig` et je sais que la propagation prend du temps.
- [ ] Je comprends ce que TLS apporte (chiffrement + identité) et pourquoi un certificat expire.
- [ ] J'inspecte l'émetteur et les dates de validité d'un certificat.
- [ ] Je localise une panne maillon par maillon : DNS → port → app → certificat.
- [ ] Je sais pourquoi le port d'une base ne s'expose pas, et comment y accéder par tunnel.

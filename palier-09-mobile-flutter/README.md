# Palier 9 — Mobile : Flutter + Dart

> 🎯 **Objectif** : livrer une app mobile complète, connectée à TON propre backend déployé. La preuve par le mobile que ton socle est universel : ton app parlera REST à n'importe lequel de tes trois backends.

## Module 1 : Dart

- [ ] Tu iras vite : la syntaxe est un mélange de JS/TS/PHP que tu connais déjà. Points d'attention : **null safety** (`?`, `!`, `late`), classes et constructeurs nommés, `final` vs `const`.
- [ ] **Futures et `async/await`** — quasi identiques à JS ; Streams (nouveau : à comprendre).
- [ ] Collections (`List`, `Map`, `Set`) et leurs méthodes (`map`, `where`, `fold` = tes `map`/`filter`/`reduce`).
- [ ] 🧩 Les katas passent en Dart ; refais l'étalon habituel : **le gestionnaire de dépenses en Dart** (CLI simple).
- 📚 **DartPad** (dartpad.dev — pratiquer sans installation) ; dart.dev/language.

## Module 2 : Flutter fondamentaux

- [ ] Installation : Flutter SDK + Android Studio + un émulateur — **et teste sur ton vrai téléphone dès le début** (mode développeur + USB), c'est plus rapide et plus réel.
- [ ] Le modèle mental : **tout est widget**, l'UI est une fonction de l'état.
- [ ] Widgets de base : `Scaffold`, `Column`, `Row`, `Stack`, `ListView`, `Container`, `Text`, `Image` — Material Design.
- [ ] État local : `StatefulWidget`, `setState`, cycle de vie.
- [ ] Navigation : routes, passage de données entre écrans, retour de résultat.
- [ ] 🛠️ Mini-projets : liste de courses (état local), puis **reproduction d'un écran d'app connue** (WhatsApp, MTN MoMo…) — l'exercice d'intégration du palier 2, version mobile.
- 📚 docs.flutter.dev (codelabs officiels) ; pub.dev pour les packages.

## Module 3 : Flutter intermédiaire

- [ ] Gestion d'état au-delà de `setState` : **Riverpod** (ou Provider pour commencer — comprends le problème avant l'outil, comme toujours).
- [ ] HTTP avec **`dio`** : consommer TON API (projet 4, 5 ou 6 — au choix, elles parlent toutes REST), sérialisation JSON ↔ classes Dart.
- [ ] Persistance locale : `shared_preferences` (préférences) et SQLite via **`drift`**.
- [ ] **Mode hors-ligne** : cache local + synchronisation — crucial en contexte de connectivité variable, et différenciant en entretien.
- [ ] Formulaires et validation, thème (mode sombre), assets et polices.
- [ ] Gestion des états d'écran : chargement / erreur / vide / données — systématiquement.

## Module 4 : 🛠️ Projet 7 — App mobile cliente de ton backend

Voir [projet.md](projet.md). Auth, CRUD, hors-ligne, et distribution **APK réelle** à de vrais utilisateurs.

## Module 5 : Build & distribution

- [ ] Build release : signature, APK vs AAB.
- [ ] Installation directe de l'APK sur plusieurs téléphones réels (la distribution hors store est très courante localement).
- [ ] Play Store si budget (25 $ une fois) : fiche, screenshots, review — sinon, documenter le processus pour plus tard.

## 🏗️ Fil rouge Architecture — côté mobile

- Même principe que partout : **UI / logique / données séparées**. Repositories pour l'accès réseau+cache, la logique hors des widgets.
- Nouveau problème d'architecture à documenter : la **synchronisation hors-ligne** (conflits, file d'attente d'écritures) — ajoute une section à ton comparatif.

## 📋 Fil rouge Gestion de projet — le produit vit après la v1

- Nouveauté : **suivi des retours utilisateurs** — collecte (formulaire simple ou WhatsApp), priorisation **impact × effort**, itérations planifiées.
- Le projet 7 doit avoir ≥ 3 vrais utilisateurs qui te font des retours. Les gérer EST l'exercice.

## 🤖 Fil rouge IA — l'IA entre dans tes produits

- Ajoute une fonctionnalité IA au projet 7 via API (catégorisation automatique, chatbot d'aide, résumé…).
- Architecture recommandée : l'appel IA passe par TON backend (endpoint FastAPI par exemple — l'occasion de faire coopérer tes stacks), jamais la clé API dans l'app mobile.
- Approfondis : prompt système, streaming vers le mobile, coûts par token, comportement en cas d'erreur/timeout de l'API IA.

## 🧑‍🏫 Référent

- Lui installer l'app : il teste en **utilisateur exigeant** (et il en a vu, des apps).
- Revue : gestion des états d'écran et du hors-ligne — les deux endroits où les apps de débutants craquent.

## ✅ Checkpoint de sortie

- [ ] App installée sur mon téléphone ET ceux de ≥ 3 personnes de mon entourage, avec de vrais retours collectés et priorisés.
- [ ] Elle parle à MON backend déployé (auth incluse) et survit à une coupure réseau.
- [ ] Je sais expliquer mon choix de gestion d'état et ma stratégie hors-ligne.
- [ ] Une fonctionnalité IA en production dans l'app.

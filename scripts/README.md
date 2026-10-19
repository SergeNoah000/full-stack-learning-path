# 🛠️ scripts

Outils du **référent** pour suivre les apprenants à distance. Rien ici n'est nécessaire à un apprenant.

## `journaux.sh`

Lit les journaux de bord de tous les apprenants, **sans jamais changer de branche** ni toucher au répertoire de travail. Il s'appuie sur la convention de branche `apprenant/prenom` décrite dans [../guides/suivi-a-distance.md](../guides/suivi-a-distance.md).

```bash
./scripts/journaux.sh              # synthèse de tous les apprenants
./scripts/journaux.sh serge        # les 3 dernières entrées de Serge, tous paliers
./scripts/journaux.sh serge 10     # ses 10 dernières entrées
./scripts/journaux.sh --no-fetch   # sans interroger le dépôt distant (hors ligne)
./scripts/journaux.sh --help
```

### Ce que donne la synthèse

```
APPRENANT    DERNIER PUSH        ENTRÉES  PALIER EN COURS            DERNIÈRE ENTRÉE
──────────────────────────────────────────────────────────────────────────────────────
amina        il y a 2 jours            7  00-fondations              18/10/2026 — 1 h
serge        il y a 3 heures          23  01-programmer-javascript   19/10/2026 — 2 h 30
nadia        il y a 12 jours           4  00-fondations              07/10/2026 — 45 min

Activité des 7 derniers jours
  il y a 3 heures   Serge Noah      journal: palier 1, session du 19/10
  il y a 2 jours    Amina K.        journal: palier 0, session du 18/10
```

Les deux colonnes à lire en premier sont **DERNIER PUSH** et **ENTRÉES** : c'est la régularité, et c'est l'indicateur qui prédit le mieux la réussite du parcours. Au-delà de dix jours sans entrée, on prend contact sans attendre le point — la grille complète des signaux d'alerte est dans le [guide](../guides/suivi-a-distance.md).

### Détails de fonctionnement

- Il lit les branches distantes `refs/remotes/*/apprenant/*`, et retombe sur les branches **locales** du même nom s'il n'y en a aucune (pratique pour tester).
- Il fait un `git fetch --all --prune` au démarrage, et continue avec le cache si le dépôt distant est injoignable.
- Le comptage des entrées ne prend en compte que ce qui suit le titre `## Mes entrées` du journal : l'exemple du modèle n'est donc pas compté.
- Aucune écriture, aucun changement de branche : le script est sans effet sur ton dépôt.

### Si rien ne s'affiche

Le message d'erreur rappelle la commande à donner aux apprenants. Vérifie sinon que tu as bien les droits sur le dépôt et que `git fetch` fonctionne.

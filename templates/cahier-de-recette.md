# Cahier de recette — [Nom du projet]

> La recette, c'est la vérification finale, **scénario par scénario**, dans les conditions réelles (sur l'environnement déployé, pas en local).
> Règles : on teste le **comportement attendu par l'utilisateur**, pas le code · on teste aussi les **cas d'erreur** · un test ❌ se corrige puis **se rejoue en entier**.
> Version [1.0] · Testé le [JJ/MM/AAAA] · Environnement : [URL de staging/prod] · Testeur : [nom]

## Prérequis du test
- [ ] Application déployée à l'URL : …
- [ ] Jeu de données de test chargé (seeders)
- [ ] Comptes de test : `membre@test.com` / `admin@test.com`

## Scénarios

| # | Scénario | Étapes | Résultat attendu | Résultat obtenu | ✅/❌ |
|---|----------|--------|------------------|-----------------|------|
| R-01 | Inscription valide | 1. Ouvrir /inscription 2. Remplir correctement 3. Valider | Compte créé, redirigé vers le tableau de bord, email de bienvenue reçu | | |
| R-02 | Inscription — email déjà pris | idem avec un email existant | Message d'erreur explicite, **aucun doublon créé** | | |
| R-03 | Connexion — mauvais mot de passe | | Message générique (ne pas révéler si l'email existe), pas de blocage de l'app | | |
| R-04 | Accès non autorisé | Ouvrir /admin en tant que membre | Refus 403, pas de fuite de données | | |
| R-05 | Création d'un [objet métier] | | Objet visible dans la liste, persisté après rafraîchissement | | |
| R-06 | Suppression | | Confirmation demandée, puis objet absent de la liste et de la BDD | | |
| R-07 | Formulaire — champs vides | Valider à vide | Messages par champ, aucune donnée enregistrée | | |
| R-08 | Formulaire — données aberrantes | montant = `-5`, texte de 10 000 caractères, `<script>alert(1)</script>` | Rejet propre côté serveur, **rien d'exécuté à l'affichage** | | |
| R-09 | Mobile | Parcourir le scénario principal sur téléphone | Lisible et utilisable, pas de débordement horizontal | | |
| R-10 | Rechargement / retour arrière | | Pas d'état incohérent, pas de double soumission | | |

## Bilan

- Scénarios : [X] · ✅ [X] · ❌ [X]
- **Anomalies bloquantes** (interdisent la livraison) : …
- **Anomalies mineures** (livrable avec réserve, corrigées en v1.1) : …

## Décision de recette
- [ ] ✅ **Recette prononcée** — conforme au cahier des charges
- [ ] ⚠️ **Recette avec réserves** — liste ci-dessus, délai de correction : [date]
- [ ] ❌ **Recette refusée** — motif : …

Signatures : prestataire ………… · client ………… · date …………

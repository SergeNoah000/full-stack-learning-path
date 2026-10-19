# Document d'architecture — [Nom du système]

> Version [1.0] · [JJ/MM/AAAA] · Auteur : [toi]
> Ce document doit pouvoir être **défendu à l'oral en 20 minutes**, schéma au tableau. C'est l'exercice du palier 7 — et un format d'entretien d'embauche.

## 1. Contexte
Le problème métier, en 5 lignes. Qui utilise, pour quoi, dans quel contexte (connexion instable ? pic saisonnier ? paiement ?).

## 2. Contraintes
| Type | Contrainte | Conséquence sur la conception |
|------|-----------|-------------------------------|
| Charge | ex. 50 000 consultations le jour des résultats, 200/jour le reste de l'année | cache agressif + lecture scalable |
| Réseau | 3G instable, données coûteuses | payloads légers, offline-first |
| Budget | | |
| Équipe | 1 dev (toi) | éviter le sur-découpage |
| Réglementaire | données personnelles | chiffrement, rétention |

## 3. Exigences
- **Fonctionnelles** : les 5 cas d'usage principaux.
- **Non fonctionnelles chiffrées** : latence cible, disponibilité, volumétrie, RPO/RTO (perte de données et temps de reprise acceptables).

## 4. Vue d'ensemble
Le schéma. À savoir redessiner de mémoire.

```
[Client web] ┐
             ├─→ [Reverse proxy / HTTPS] ─→ [API ×N] ─→ [Cache] ─→ [BDD primaire]
[Mobile]     ┘                                  │                      │
                                                └─→ [File de tâches] ─→ [Worker]
```

Légende : ce qui est synchrone, ce qui est asynchrone, où est l'état.

## 5. Choix de stack — et pourquoi pas les autres
C'est **la** section qui distingue un architecte d'un exécutant : on juge les alternatives écartées.

| Critère | Option retenue : [X] | Alternative 1 : [Y] | Alternative 2 : [Z] |
|---------|---------------------|---------------------|---------------------|
| Adéquation au besoin | | | |
| Vitesse de livraison | | | |
| Compétence disponible (la tienne) | | | |
| Coût d'hébergement | | | |
| Écosystème / recrutement | | | |
| **Verdict** | ✅ parce que… | ❌ parce que… | ❌ parce que… |

## 6. Modèle de données
Entités, relations, index prévus, et ce qui sera dénormalisé (avec la raison).

## 7. Points de défaillance et parades
| Ce qui peut tomber | Effet | Parade | Dégradation acceptée |
|--------------------|-------|--------|---------------------|
| BDD | | réplique + sauvegardes testées | lecture seule |
| Service de paiement tiers | | file de retry + idempotence | paiement différé |
| Pic de trafic | | cache + rate limiting | file d'attente visible |

## 8. Sécurité
Authentification, autorisation, secrets, surface d'exposition, données sensibles, sauvegardes, journalisation des accès.

## 9. Plan d'évolution : 10 → 10 000 utilisateurs
| Palier de charge | Ce qui casse en premier | Action |
|------------------|------------------------|--------|
| 10 | rien | monolithe sur 1 VPS |
| 1 000 | BDD en écriture / CPU | index, cache, proxy |
| 10 000 | instance unique | horizontal + load balancer, BDD managée |

**Ce qu'on ne fait PAS tout de suite** (et pourquoi) : microservices, Kubernetes, sharding. *Le sur-dimensionnement précoce est une erreur d'architecture, pas une précaution.*

## 10. Coûts estimés
Infra mensuelle à chaque palier de charge → alimente le fil rouge coûts.

## 11. Décisions actées (ADR court)
| # | Décision | Alternatives écartées | Raison | Date |
|---|----------|----------------------|--------|------|
| 1 | | | | |

## 12. Questions ouvertes
Ce qui reste à trancher, et quand il faudra le faire.

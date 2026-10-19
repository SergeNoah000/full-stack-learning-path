#!/usr/bin/env bash
#
# journaux.sh — vue d'ensemble des journaux de bord des apprenants.
#
#   ./scripts/journaux.sh              synthèse de tous les apprenants
#   ./scripts/journaux.sh serge        les dernières entrées d'un apprenant
#   ./scripts/journaux.sh serge 10     ses 10 dernières entrées
#   ./scripts/journaux.sh --no-fetch   sans interroger le dépôt distant (hors ligne)
#
# Lit les branches `apprenant/*` sans jamais changer de branche ni toucher
# au répertoire de travail. Voir guides/suivi-a-distance.md.

set -uo pipefail

PREFIXE="apprenant/"
MARQUEUR="^## Mes entrées"      # les entrées d'un journal commencent après cette ligne
FETCH=1
CIBLE=""
NB_ENTREES=3

for arg in "$@"; do
  case "$arg" in
    --no-fetch) FETCH=0 ;;
    -h|--help)  awk 'NR>2 && /^#/ {sub(/^# ?/, ""); print; next} NR>2 {exit}' "$0"; exit 0 ;;
    [0-9]*)     NB_ENTREES="$arg" ;;
    *)          CIBLE="$arg" ;;
  esac
done

git rev-parse --git-dir >/dev/null 2>&1 || { echo "Pas un dépôt Git." >&2; exit 1; }

if [ "$FETCH" -eq 1 ] && git remote | grep -q .; then
  echo "Récupération des branches distantes…"
  git fetch --all --prune --quiet 2>/dev/null || echo "  (dépôt distant injoignable — on lit ce qui est en cache)"
fi

# Les branches distantes si elles existent, les locales sinon (utile en test).
mapfile -t BRANCHES < <(git for-each-ref --format='%(refname:short)' "refs/remotes/*/${PREFIXE}*" 2>/dev/null)
[ "${#BRANCHES[@]}" -eq 0 ] && mapfile -t BRANCHES < <(git for-each-ref --format='%(refname:short)' "refs/heads/${PREFIXE}*" 2>/dev/null)

if [ "${#BRANCHES[@]}" -eq 0 ]; then
  cat >&2 <<MSG
Aucune branche « ${PREFIXE}* » trouvée.

Chaque apprenant doit créer la sienne :
    git switch -c ${PREFIXE}prenom main
    git push -u origin ${PREFIXE}prenom

Procédure complète : guides/suivi-a-distance.md
MSG
  exit 1
fi

nom_apprenant() { echo "${1#*$PREFIXE}"; }        # origin/apprenant/serge → serge

journaux_de() { git ls-tree -r --name-only "$1" 2>/dev/null | grep '^palier-.*/journal\.md$' | sort; }

# Nombre d'entrées réelles d'un journal (on ignore l'exemple du modèle).
compte_entrees() {
  git show "$1:$2" 2>/dev/null |
    awk -v m="$MARQUEUR" '$0 ~ m {ok=1; next} ok && (/^## / || /^---$/) {ok=0} ok && /^### / {n++} END {print n+0}'
}

derniere_entree() {
  git show "$1:$2" 2>/dev/null |
    awk -v m="$MARQUEUR" '$0 ~ m {ok=1; next} ok && (/^## / || /^---$/) {ok=0} ok && /^### / {ligne=$0} END {print ligne}' |
    sed 's/^### *//'
}

# ---------------------------------------------------------------- un apprenant
if [ -n "$CIBLE" ]; then
  REF=""
  for b in "${BRANCHES[@]}"; do
    [ "$(nom_apprenant "$b")" = "$CIBLE" ] && REF="$b" && break
  done
  [ -z "$REF" ] && { echo "Aucun apprenant « $CIBLE ». Disponibles : $(for b in "${BRANCHES[@]}"; do printf '%s ' "$(nom_apprenant "$b")"; done)" >&2; exit 1; }

  echo
  echo "════════════════════════════════════════════════════════════════"
  echo "  $CIBLE — branche $REF"
  echo "  dernier push : $(git log -1 --format='%ar (%ad)' --date=short "$REF")"
  echo "════════════════════════════════════════════════════════════════"

  while IFS= read -r journal; do
    [ -z "$journal" ] && continue
    n=$(compte_entrees "$REF" "$journal")
    [ "$n" -eq 0 ] && continue
    echo
    mot="entrées"; [ "$n" -eq 1 ] && mot="entrée"
    echo "──── ${journal%%/*}  ($n $mot) ────"
    git show "$REF:$journal" 2>/dev/null |
      awk -v m="$MARQUEUR" '$0 ~ m {ok=1; next} ok && (/^## / || /^---$/) {ok=0} ok {print}' |
      awk -v n="$NB_ENTREES" '
        /^### / { bloc++ }
        bloc > 0 { lignes[bloc] = lignes[bloc] $0 "\n" }
        END { debut = (bloc > n ? bloc - n + 1 : 1); for (i = debut; i <= bloc; i++) printf "%s", lignes[i] }'
  done < <(journaux_de "$REF")

  questions=$(git show "$REF:questions-referent.md" 2>/dev/null |
    awk '/^## Questions en attente/{ok=1; next} /^## Questions résolues/{ok=0} ok' |
    grep -v '^[[:space:]]*$' | grep -v '(à remplir)' | head -20)
  echo
  if [ -n "$questions" ]; then
    echo "──── questions en attente pour le référent ────"
    echo "$questions" | sed 's/^/  /'
  else
    echo "(aucune question en attente)"
  fi
  echo
  exit 0
fi

# ------------------------------------------------------------- tous, synthèse
echo
printf '%-12s %-19s %7s  %-26s %s\n' "APPRENANT" "DERNIER PUSH" "ENTRÉES" "PALIER EN COURS" "DERNIÈRE ENTRÉE"
printf '%s\n' "──────────────────────────────────────────────────────────────────────────────────────────────────"

for b in "${BRANCHES[@]}"; do
  nom=$(nom_apprenant "$b")
  pousse=$(git log -1 --format='%ar' "$b" 2>/dev/null)
  total=0; courant="—"; derniere="—"
  while IFS= read -r journal; do
    [ -z "$journal" ] && continue
    n=$(compte_entrees "$b" "$journal")
    total=$((total + n))
    if [ "$n" -gt 0 ]; then
      courant="${journal%%/*}"; courant="${courant#palier-}"
      derniere=$(derniere_entree "$b" "$journal")
    fi
  done < <(journaux_de "$b")
  printf '%-12s %-19s %7s  %-26s %s\n' "$nom" "$pousse" "$total" "$courant" "${derniere:-—}"
done

echo
echo "Activité des 7 derniers jours"
printf '%s\n' "────────────────────────────────────────────────"
journaux_recents=$(git log --all --since="7 days ago" --no-merges --format='%ar|%an|%s' 2>/dev/null | grep -v '^$')
if [ -n "$journaux_recents" ]; then
  echo "$journaux_recents" | awk -F'|' '{printf "  %-14s %-16s %s\n", $1, $2, $3}' | head -25
else
  echo "  (aucun commit cette semaine)"
fi

echo
echo "Détail d'un apprenant :  ./scripts/journaux.sh <prenom>"
echo "Signaux d'alerte à surveiller : guides/suivi-a-distance.md"
echo

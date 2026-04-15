#!/usr/bin/env bash
#
# tickler/scan — scan an entity's tickler/ and report what's due
#
# Usage: juno tickler scan
#
# Reads ~/.<entity>/tickler/ and prints a report of open tickles:
#   - space/<current-host>/**/*.md  — here-and-now tickles
#   - time/<year>/days/<month>/<day>/**/*.md  — due today
#   - time/<year>/weeks/<week>/**/*.md  — due this week
#   - time/<year>/months/<month>/**/*.md  — due this month
#   - any past-date path with no `completion` frontmatter key  — overdue
#
# A tickle is "open" if its frontmatter lacks a non-empty `completion:` field.
# The loader is READ-ONLY — it never modifies, moves, or deletes files.
#
# Prints:
#   Tickler: N due          (followed by one line per tickle, + refs if present)
#   or
#   Tickler: no tickles right now

set -euo pipefail

TICKLER_DIR="${TICKLER_DIR:-${ENTITY_DIR:-$HOME/.juno}/tickler}"

if [[ ! -d "$TICKLER_DIR" ]]; then
  echo "Tickler: not initialized at $TICKLER_DIR"
  exit 0
fi

HOST="$(hostname -s)"
TODAY_Y=$(date +%Y)
TODAY_M=$(date +%m)
TODAY_D=$(date +%d)
TODAY_YMD="${TODAY_Y}${TODAY_M}${TODAY_D}"
CURRENT_WEEK=$(date +%V)   # ISO 8601 week number
CURRENT_YW="${TODAY_Y}${CURRENT_WEEK}"
CURRENT_YM="${TODAY_Y}${TODAY_M}"

# ---------------------------------------------------------------------------
# Frontmatter helpers — awk parses the first frontmatter block only.
# ---------------------------------------------------------------------------

# is_open FILE — returns 0 if the file has no non-empty completion: field.
#
# Note on awk exit semantics: `exit N` inside a rule still runs the END
# block, and END's own `exit` overrides the earlier code. The prior version
# of this function had `END { exit 0 }` which silently converted every
# `exit 1` (closed) back to 0 (open), so completion stamps were ignored and
# every tickle always surfaced as due. Fix: track state in a flag and have
# END report it.
is_open() {
  awk '
    BEGIN { fm=0; closed=0 }
    /^---[[:space:]]*$/ {
      fm++
      if (fm == 2) { exit }
      next
    }
    fm == 1 && /^completion:[[:space:]]*[^[:space:]]/ { closed=1; exit }
    END { exit closed }
  ' "$1"
}

# get_subject FILE — prints the `subject:` scalar, stripped of surrounding
# quotes, or falls back to the filename stem.
get_subject() {
  local file="$1" subject
  subject=$(awk '
    BEGIN { fm=0 }
    /^---[[:space:]]*$/ { fm++; if (fm == 2) exit; next }
    fm == 1 && /^subject:[[:space:]]*/ {
      sub(/^subject:[[:space:]]*/, "")
      gsub(/^["'\''`]|["'\''`]$/, "")
      print
      exit
    }
  ' "$file")
  if [[ -z "$subject" ]]; then
    subject=$(basename "$file" .md)
  fi
  printf "%s" "$subject"
}

# get_references FILE — prints references list as comma-separated string,
# or empty if no references field.
get_references() {
  awk '
    BEGIN { fm=0; in_refs=0; first=1 }
    /^---[[:space:]]*$/ { fm++; if (fm == 2) exit; next }
    fm == 1 && /^references:[[:space:]]*$/ { in_refs=1; next }
    fm == 1 && in_refs == 1 && /^[[:space:]]+-[[:space:]]/ {
      sub(/^[[:space:]]+-[[:space:]]*/, "")
      gsub(/^["'\''`]|["'\''`]$/, "")
      if (first) { printf "%s", $0; first=0 }
      else { printf ", %s", $0 }
      next
    }
    fm == 1 && in_refs == 1 && /^[^[:space:]]/ { in_refs=0 }
  ' "$1"
}

# relpath FILE — print path relative to tickler dir root.
relpath() {
  printf "%s" "${1#"$TICKLER_DIR"/}"
}

# ---------------------------------------------------------------------------
# Report accumulator
# ---------------------------------------------------------------------------

TMP_REPORT=$(mktemp)
trap 'rm -f "$TMP_REPORT"' EXIT
DUE_COUNT=0

emit_tickle() {
  local file="$1" signal="$2" subject refs
  subject=$(get_subject "$file")
  refs=$(get_references "$file")
  printf "  - %s · %s (%s)\n" "$signal" "$subject" "$(relpath "$file")" >> "$TMP_REPORT"
  if [[ -n "$refs" ]]; then
    printf "    refs: %s\n" "$refs" >> "$TMP_REPORT"
  fi
  DUE_COUNT=$((DUE_COUNT + 1))
}

# ---------------------------------------------------------------------------
# Scan: space/<current-host>/ — here-and-now
# ---------------------------------------------------------------------------

if [[ -d "$TICKLER_DIR/space/$HOST" ]]; then
  while IFS= read -r -d '' f; do
    is_open "$f" || continue
    emit_tickle "$f" "here ($HOST)"
  done < <(find "$TICKLER_DIR/space/$HOST" -name '*.md' -type f -print0 2>/dev/null)
fi

# ---------------------------------------------------------------------------
# Scan: time/ — walk every markdown file, classify by path, filter by date
# ---------------------------------------------------------------------------

if [[ -d "$TICKLER_DIR/time" ]]; then
  while IFS= read -r -d '' f; do
    rel="${f#"$TICKLER_DIR"/time/}"
    IFS='/' read -r year kind p1 p2 _ <<< "$rel"

    case "$kind" in
      days)
        # path: YYYY/days/MM/DD/...
        month="$p1"
        day="$p2"
        [[ -z "$month" || -z "$day" ]] && continue
        file_ymd="${year}${month}${day}"
        if [[ "$file_ymd" -gt "$TODAY_YMD" ]]; then continue; fi
        is_open "$f" || continue
        if [[ "$file_ymd" == "$TODAY_YMD" ]]; then
          signal="${year}-${month}-${day} (today)"
        else
          signal="${year}-${month}-${day} (overdue)"
        fi
        emit_tickle "$f" "$signal"
        ;;
      weeks)
        # path: YYYY/weeks/WW/...
        week="$p1"
        [[ -z "$week" ]] && continue
        file_yw="${year}${week}"
        if [[ "$file_yw" -gt "$CURRENT_YW" ]]; then continue; fi
        is_open "$f" || continue
        if [[ "$file_yw" == "$CURRENT_YW" ]]; then
          signal="week $week"
        else
          signal="week $week $year (overdue)"
        fi
        emit_tickle "$f" "$signal"
        ;;
      months)
        # path: YYYY/months/MM/...
        month="$p1"
        [[ -z "$month" ]] && continue
        file_ym="${year}${month}"
        if [[ "$file_ym" -gt "$CURRENT_YM" ]]; then continue; fi
        is_open "$f" || continue
        if [[ "$file_ym" == "$CURRENT_YM" ]]; then
          signal="month $year-$month"
        else
          signal="month $year-$month (overdue)"
        fi
        emit_tickle "$f" "$signal"
        ;;
    esac
  done < <(find "$TICKLER_DIR/time" -name '*.md' -type f -print0 2>/dev/null)
fi

# ---------------------------------------------------------------------------
# Print report
# ---------------------------------------------------------------------------

if [[ "$DUE_COUNT" -eq 0 ]]; then
  echo "Tickler: no tickles right now"
else
  echo "Tickler: $DUE_COUNT due"
  cat "$TMP_REPORT"
fi

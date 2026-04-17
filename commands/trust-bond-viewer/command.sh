#!/bin/bash
# juno trust-bond-viewer
#
# Reads trust/bonds/*.md from a configurable list of entity home dirs,
# parses frontmatter, verifies GPG signatures, and emits static HTML
# into dist/trust-bonds/:
#   index.html       — table + SVG graph of all bonds across entities
#   bonds/<n>.html   — per-bond detail page
#
# Usage:
#   juno trust-bond-viewer [--entities <list>] [--home-root <path>] [--out-dir <path>]
#
# Options:
#   --entities    Comma- or space-separated list of entity names to scan
#                 Default: juno vulcan alice vesta muse mercury veritas sibyl
#                          argus salus janus aegis iris
#   --home-root   Root directory containing .<entity>/ homes (default: ~)
#   --out-dir     Where to write static HTML (default: ~/.juno/dist/trust-bonds/)
#
# Each entity's bonds are read from <home-root>/.<entity>/trust/bonds/*.md
# Missing directories are silently skipped.
#
# Signature check uses GNUPGHOME if set; falls back to ~/.gnupg.
# UNVERIFIED bonds render with a visible warning and key-import remediation note.
# NO_SIGNATURE bonds are flagged separately.
#
# KEY-IMPORT REMEDIATION:
#   If bonds appear as UNVERIFIED, the signing key (Juno's GPG key) is not in
#   your local keyring. Import it:
#     gpg --keyserver keys.openpgp.org --search-keys juno@kingofalldata.com
#   or if you have the public key file:
#     gpg --import juno-public.asc
#   Then re-run the viewer to refresh verification status.

set -euo pipefail

# Default entity list
DEFAULT_ENTITIES="juno vulcan alice vesta muse mercury veritas sibyl argus salus janus aegis iris"

ENTITIES="${DEFAULT_ENTITIES}"
HOME_ROOT="${HOME}"
OUT_DIR="${HOME}/.juno/dist/trust-bonds"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --entities=*) ENTITIES="${1#*=}"; shift ;;
    --entities)   ENTITIES="${2:-}"; shift 2 ;;
    --home-root=*) HOME_ROOT="${1#*=}"; shift ;;
    --home-root)   HOME_ROOT="${2:-}"; shift 2 ;;
    --out-dir=*)  OUT_DIR="${1#*=}"; shift ;;
    --out-dir)    OUT_DIR="${2:-}"; shift 2 ;;
    *) echo "trust-bond-viewer: unknown flag: $1" >&2; exit 2 ;;
  esac
done

# Normalize entity list (allow commas or spaces)
ENTITIES="${ENTITIES//,/ }"

mkdir -p "${OUT_DIR}/bonds"

GENERATED_AT="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

# ── helpers ────────────────────────────────────────────────────────────────────

# Extract a frontmatter field from a .md file
fm_field() {
  local file="$1" field="$2"
  awk -v f="$field" '
    /^---$/ { count++; if (count==2) exit }
    count==1 && $0 ~ "^"f":" {
      sub("^"f":[ \t]*",""); print; exit
    }
  ' "$file"
}

# Verify a .asc file; prints: VERIFIED <fingerprint>, UNVERIFIED <reason>, or NO_SIGNATURE
verify_asc() {
  local md_file="$1"
  local asc_file="${md_file}.asc"

  if [[ ! -f "$asc_file" ]]; then
    echo "NO_SIGNATURE"
    return
  fi

  local gpg_out
  gpg_out="$(gpg --verify "$asc_file" 2>&1)" && local rc=0 || local rc=$?

  if [[ $rc -eq 0 ]]; then
    local fp
    fp="$(echo "$gpg_out" | grep -oP '(?<=key )[0-9A-F]{16,}' | head -1 || true)"
    echo "VERIFIED ${fp:-unknown-fingerprint}"
  else
    local key_id
    key_id="$(echo "$gpg_out" | grep -oP '(?<=key )[0-9A-F]{8,}' | head -1 || true)"
    local reason
    reason="$(echo "$gpg_out" | grep -v '^$' | tail -1 | sed 's/gpg: //')"
    if [[ -n "$key_id" ]]; then
      echo "UNVERIFIED key=${key_id} — ${reason}"
    else
      echo "UNVERIFIED — ${reason}"
    fi
  fi
}

# HTML-escape a string
html_escape() {
  printf '%s' "$1" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g'
}

# Render signature status as an HTML badge
sig_badge() {
  local status="$1"
  if [[ "$status" == VERIFIED* ]]; then
    printf '<span class="badge verified">VERIFIED</span>'
  elif [[ "$status" == NO_SIGNATURE* ]]; then
    printf '<span class="badge no-sig">NO SIGNATURE</span>'
  else
    printf '<span class="badge unverified">UNVERIFIED</span>'
  fi
}

# Extract just the entity name from a "From" or "To" field value
# Input: "Juno (juno@kingofalldata.com)" → "Juno"
entity_name_from_field() {
  echo "$1" | sed 's/[[:space:]*(].*//' | tr -d '"'
}

# Minimal shared CSS
page_css() {
  cat <<'CSS'
<style>
  body { font-family: monospace; max-width: 960px; margin: 2rem auto; padding: 0 1rem; background: #0d0d0d; color: #e0e0e0; }
  h1 { color: #c8a96e; border-bottom: 1px solid #333; padding-bottom: .4rem; }
  h2 { color: #9ec8a9; }
  h3 { color: #9ec8a9; }
  a { color: #6ea8c8; }
  table { width: 100%; border-collapse: collapse; margin: 1rem 0; }
  th { background: #1a1a1a; color: #c8a96e; text-align: left; padding: .4rem .6rem; }
  td { padding: .35rem .6rem; border-bottom: 1px solid #222; vertical-align: top; }
  tr:hover td { background: #131313; }
  .badge { font-size: .75rem; padding: .15rem .4rem; border-radius: 3px; font-weight: bold; }
  .verified   { background: #1a3a1a; color: #6ec88a; border: 1px solid #2a5a2a; }
  .unverified { background: #3a1a1a; color: #c86e6e; border: 1px solid #5a2a2a; }
  .no-sig     { background: #2a2a1a; color: #c8c86e; border: 1px solid #4a4a2a; }
  pre { background: #111; border: 1px solid #333; padding: .8rem; overflow-x: auto; font-size: .82rem; }
  .meta { color: #888; font-size: .85rem; }
  .note { background: #1a1010; border-left: 3px solid #c86e6e; padding: .5rem .8rem; margin: 1rem 0; }
  .note.ok { background: #101a10; border-color: #6ec88a; }
  .note.info { background: #101018; border-color: #6e8ec8; }
  footer { color: #555; font-size: .8rem; margin-top: 2rem; border-top: 1px solid #222; padding-top: .5rem; }
  .source-tag { font-size: .75rem; color: #666; }
  /* graph */
  .graph-wrap { margin: 1.5rem 0; overflow-x: auto; }
  svg.trust-graph { display: block; background: #0a0a0a; border: 1px solid #222; border-radius: 4px; }
</style>
CSS
}

# ── collect bonds across entities ──────────────────────────────────────────────

declare -a BOND_FILES=()
declare -A BOND_SOURCE_ENTITY=()  # MD path → entity name

TOTAL_DIRS=0
TOTAL_SKIPPED=0

echo "trust-bond-viewer: scanning entities: ${ENTITIES}"

for ENTITY in ${ENTITIES}; do
  BONDS_DIR="${HOME_ROOT}/.${ENTITY}/trust/bonds"
  if [[ ! -d "$BONDS_DIR" ]]; then
    echo "  ${ENTITY}: no bonds dir (${BONDS_DIR}) — skipping"
    (( TOTAL_SKIPPED++ )) || true
    continue
  fi
  (( TOTAL_DIRS++ )) || true

  mapfile -t ENTITY_FILES < <(find "$BONDS_DIR" -maxdepth 1 -name '*.md' ! -name '*.asc' | sort)
  echo "  ${ENTITY}: ${#ENTITY_FILES[@]} bonds"
  for MD in "${ENTITY_FILES[@]}"; do
    BOND_FILES+=("$MD")
    BOND_SOURCE_ENTITY["$MD"]="$ENTITY"
  done
done

# Deduplicate: if same bond label appears in multiple entity dirs, keep
# the first occurrence (juno is canonical; others are copies).
declare -a UNIQUE_FILES=()
declare -A SEEN_LABELS=()
for MD in "${BOND_FILES[@]}"; do
  LABEL="$(basename "$MD" .md)"
  if [[ -z "${SEEN_LABELS[$LABEL]+x}" ]]; then
    SEEN_LABELS["$LABEL"]=1
    UNIQUE_FILES+=("$MD")
  fi
done

BOND_COUNT="${#UNIQUE_FILES[@]}"
echo "trust-bond-viewer: ${BOND_COUNT} unique bonds after dedup"

if [[ $BOND_COUNT -eq 0 ]]; then
  echo "trust-bond-viewer: no .md bond files found in any entity dir" >&2
  exit 1
fi

# ── per-bond pages + data for index ────────────────────────────────────────────

declare -a INDEX_ROWS=()
declare -A GRAPH_NODES=()   # entity_name → 1
declare -a GRAPH_EDGES=()   # "from_entity|to_entity|bond_type"

for MD in "${UNIQUE_FILES[@]}"; do
  LABEL="$(basename "$MD" .md)"
  SOURCE_ENTITY="${BOND_SOURCE_ENTITY[$MD]}"

  # Parse frontmatter
  F_TYPE="$(fm_field "$MD" type)"
  F_FROM="$(fm_field "$MD" from)"
  F_TO="$(fm_field "$MD" to)"
  F_STATUS="$(fm_field "$MD" status)"
  F_CREATED="$(fm_field "$MD" created)"
  F_RENEWAL="$(fm_field "$MD" renewal)"
  F_VISIBILITY="$(fm_field "$MD" visibility)"

  # Signature verification
  SIG_STATUS="$(verify_asc "$MD")"

  echo "  ${LABEL} [${SOURCE_ENTITY}]: ${SIG_STATUS}"

  # Collect graph data
  FROM_NAME="$(entity_name_from_field "$F_FROM")"
  TO_NAME="$(entity_name_from_field "$F_TO")"
  if [[ -n "$FROM_NAME" && -n "$TO_NAME" ]]; then
    GRAPH_NODES["$FROM_NAME"]=1
    GRAPH_NODES["$TO_NAME"]=1
    GRAPH_EDGES+=("${FROM_NAME}|${TO_NAME}|${F_TYPE:-bond}")
  fi

  # Read bond body (skip frontmatter)
  BOND_BODY="$(awk 'BEGIN{s=0} /^---$/{s++; if(s==2){s=3}; next} s>=3{print}' "$MD")"

  # Accumulate index row data (tab-separated)
  INDEX_ROWS+=("${LABEL}	${F_TYPE}	${F_FROM}	${F_TO}	${F_STATUS}	${F_CREATED}	${SIG_STATUS}	${SOURCE_ENTITY}")

  # Determine sig-note HTML
  if [[ "$SIG_STATUS" == VERIFIED* ]]; then
    SIG_NOTE="<p class=\"note ok\">Signature verified. ${SIG_STATUS}</p>"
  elif [[ "$SIG_STATUS" == NO_SIGNATURE ]]; then
    SIG_NOTE="<p class=\"note\">WARNING: No .asc signature file found for this bond. Bond terms are not cryptographically attested.</p>"
  else
    SIG_NOTE="<p class=\"note\">WARNING: Signature could not be verified. $(html_escape "$SIG_STATUS")<br>
      To fix: import the signing key — see <a href=\"../index.html#key-import\">key-import remediation</a>.</p>"
  fi

  ESCAPED_BODY="$(html_escape "$BOND_BODY")"

  # ASC link
  ASC_LABEL="${LABEL}.md.asc"
  BONDS_DIR="$(dirname "$MD")"
  ASC_PATH="${BONDS_DIR}/${ASC_LABEL}"
  if [[ -f "$ASC_PATH" ]]; then
    ASC_LINK="<a href=\"file://${ASC_PATH}\" target=\"_blank\">${ASC_LABEL}</a>"
  else
    ASC_LINK="<em>not present</em>"
  fi

  cat > "${OUT_DIR}/bonds/${LABEL}.html" <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Bond: ${LABEL} — koad:io Insiders</title>
$(page_css)
</head>
<body>
  <p><a href="../index.html">&larr; All trust bonds</a></p>
  <h1>Trust Bond: $(html_escape "$LABEL")</h1>
  <p class="meta source-tag">Source entity: <strong>$(html_escape "$SOURCE_ENTITY")</strong></p>

  <table>
    <tr><th>Field</th><th>Value</th></tr>
    <tr><td>Type</td><td>$(html_escape "$F_TYPE")</td></tr>
    <tr><td>From</td><td>$(html_escape "$F_FROM")</td></tr>
    <tr><td>To</td><td>$(html_escape "$F_TO")</td></tr>
    <tr><td>Status</td><td>$(html_escape "$F_STATUS")</td></tr>
    <tr><td>Created</td><td>$(html_escape "$F_CREATED")</td></tr>
    <tr><td>Renewal</td><td>$(html_escape "$F_RENEWAL")</td></tr>
    <tr><td>Visibility</td><td>$(html_escape "$F_VISIBILITY")</td></tr>
    <tr><td>Signature</td><td>$(sig_badge "$SIG_STATUS") $(html_escape "$SIG_STATUS")</td></tr>
    <tr><td>Raw .asc</td><td>${ASC_LINK}</td></tr>
  </table>

  ${SIG_NOTE}

  <h2>Bond Terms</h2>
  <pre>$(printf '%s' "$ESCAPED_BODY")</pre>

  <footer>Generated by <code>juno trust-bond-viewer</code> at ${GENERATED_AT} &mdash; koad:io Insiders tier &mdash; read-only</footer>
</body>
</html>
HTML
done

# ── SVG graph ──────────────────────────────────────────────────────────────────
# Layout: koad at top-center, Juno below, all other entities in a circle around Juno.
# Nodes are colored by role; edges labeled by bond type.

build_graph_svg() {
  local -n _nodes=$1   # associative array
  local -n _edges=$2   # indexed array of "from|to|type"

  # Collect sorted unique node names
  local node_list=()
  for n in "${!_nodes[@]}"; do
    node_list+=("$n")
  done
  # Sort: put koad first, Juno second, rest alphabetically
  IFS=$'\n' sorted_nodes=($(printf '%s\n' "${node_list[@]}" | sort)); unset IFS
  local ordered=()
  for n in "${sorted_nodes[@]}"; do
    [[ "$n" == "koad" ]] && continue
    [[ "$n" == "Juno" ]] && continue
    ordered+=("$n")
  done

  local W=860 H=540
  # koad at top-center
  local koad_x=430 koad_y=60
  # Juno below koad
  local juno_x=430 juno_y=200
  # Remaining entities in arc around Juno
  local N="${#ordered[@]}"
  local cx=430 cy=360 rx=340 ry=150
  local PI="3.14159265"

  # Compute positions
  declare -A pos_x pos_y
  pos_x["koad"]=$koad_x
  pos_y["koad"]=$koad_y
  pos_x["Juno"]=$juno_x
  pos_y["Juno"]=$juno_y

  for (( i=0; i<N; i++ )); do
    local name="${ordered[$i]}"
    # spread from -160deg to -20deg (bottom arc) — pure bash arithmetic
    # angle in tenths of degrees: from -1600 to -200
    local angle_tenths=$(( -1600 + ( i * 1400 / (N > 1 ? N-1 : 1) ) ))
    # sin/cos approximation via awk
    local px py
    px=$(awk -v cx="$cx" -v rx="$rx" -v a="$angle_tenths" 'BEGIN { pi=3.14159265; printf "%.0f", cx + rx * cos(a/10 * pi/180) }')
    py=$(awk -v cy="$cy" -v ry="$ry" -v a="$angle_tenths" 'BEGIN { pi=3.14159265; printf "%.0f", cy + ry * sin(a/10 * pi/180) }')
    pos_x["$name"]=$px
    pos_y["$name"]=$py
  done

  # Bond type → color mapping
  type_color() {
    case "$1" in
      authorized-agent)    echo "#c8a96e" ;;
      authorized-builder)  echo "#6ea8c8" ;;
      authorized-specialist) echo "#9ec8a9" ;;
      peer)                echo "#c86e6e" ;;
      *)                   echo "#888888" ;;
    esac
  }

  # Node fill color
  node_color() {
    case "$1" in
      koad)  echo "#3a2a10" ;;
      Juno)  echo "#2a1a3a" ;;
      *)     echo "#1a1a2a" ;;
    esac
  }

  echo "<svg class=\"trust-graph\" width=\"${W}\" height=\"${H}\" viewBox=\"0 0 ${W} ${H}\" xmlns=\"http://www.w3.org/2000/svg\">"
  echo "  <defs>"
  echo "    <marker id=\"arrow\" viewBox=\"0 0 10 10\" refX=\"9\" refY=\"5\" markerWidth=\"6\" markerHeight=\"6\" orient=\"auto\">"
  echo "      <path d=\"M 0 0 L 10 5 L 0 10 z\" fill=\"#555\" />"
  echo "    </marker>"
  echo "  </defs>"

  # Draw edges first (behind nodes)
  for edge in "${_edges[@]}"; do
    IFS='|' read -r from_n to_n btype <<< "$edge"
    local x1="${pos_x[$from_n]:-}" y1="${pos_y[$from_n]:-}"
    local x2="${pos_x[$to_n]:-}"  y2="${pos_y[$to_n]:-}"
    [[ -z "$x1" || -z "$x2" ]] && continue
    local ecolor
    ecolor="$(type_color "$btype")"
    # Midpoint for label
    local mx=$(( (x1 + x2) / 2 ))
    local my=$(( (y1 + y2) / 2 ))
    echo "  <line x1=\"$x1\" y1=\"$y1\" x2=\"$x2\" y2=\"$y2\" stroke=\"${ecolor}\" stroke-width=\"1.2\" stroke-opacity=\"0.5\" marker-end=\"url(#arrow)\" />"
    echo "  <text x=\"$mx\" y=\"$my\" font-family=\"monospace\" font-size=\"8\" fill=\"${ecolor}\" opacity=\"0.7\" text-anchor=\"middle\">${btype}</text>"
  done

  # Draw nodes
  local all_nodes=("koad" "Juno" "${ordered[@]}")
  for name in "${all_nodes[@]}"; do
    local nx="${pos_x[$name]:-}" ny="${pos_y[$name]:-}"
    [[ -z "$nx" ]] && continue
    local nfill
    nfill="$(node_color "$name")"
    echo "  <circle cx=\"$nx\" cy=\"$ny\" r=\"20\" fill=\"$nfill\" stroke=\"#444\" stroke-width=\"1.5\" />"
    echo "  <text x=\"$nx\" y=\"$(( ny + 5 ))\" font-family=\"monospace\" font-size=\"10\" fill=\"#e0e0e0\" text-anchor=\"middle\">$name</text>"
  done

  echo "</svg>"
}

# ── legend HTML ───────────────────────────────────────────────────────────────

graph_legend_html() {
  cat <<'HTML'
<p class="meta" style="margin:.5rem 0">
  <span style="color:#c8a96e">&#9644;</span> authorized-agent &nbsp;
  <span style="color:#6ea8c8">&#9644;</span> authorized-builder &nbsp;
  <span style="color:#9ec8a9">&#9644;</span> authorized-specialist &nbsp;
  <span style="color:#c86e6e">&#9644;</span> peer
</p>
HTML
}

# ── index page ─────────────────────────────────────────────────────────────────

# Build table rows
INDEX_TABLE_ROWS=""
for ROW in "${INDEX_ROWS[@]}"; do
  IFS=$'\t' read -r LABEL F_TYPE F_FROM F_TO F_STATUS F_CREATED SIG_STATUS SOURCE_ENTITY <<< "$ROW"
  BADGE="$(sig_badge "$SIG_STATUS")"
  INDEX_TABLE_ROWS+="<tr>"
  INDEX_TABLE_ROWS+="<td><a href=\"bonds/${LABEL}.html\">$(html_escape "$LABEL")</a></td>"
  INDEX_TABLE_ROWS+="<td>$(html_escape "$F_TYPE")</td>"
  INDEX_TABLE_ROWS+="<td>$(html_escape "$F_FROM")</td>"
  INDEX_TABLE_ROWS+="<td>$(html_escape "$F_TO")</td>"
  INDEX_TABLE_ROWS+="<td>$(html_escape "$F_STATUS")</td>"
  INDEX_TABLE_ROWS+="<td>$(html_escape "$F_CREATED")</td>"
  INDEX_TABLE_ROWS+="<td>${BADGE}</td>"
  INDEX_TABLE_ROWS+="<td class=\"source-tag\">$(html_escape "$SOURCE_ENTITY")</td>"
  INDEX_TABLE_ROWS+="</tr>"$'\n'
done

# Build SVG graph
GRAPH_SVG="$(build_graph_svg GRAPH_NODES GRAPH_EDGES)"

cat > "${OUT_DIR}/index.html" <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Trust Bond Viewer — koad:io Insiders</title>
$(page_css)
</head>
<body>
  <h1>Trust Bond Registry</h1>
  <p class="meta">koad:io Insiders (Architect tier) &mdash; ${BOND_COUNT} bonds across ${TOTAL_DIRS} entity dirs &mdash; generated ${GENERATED_AT}</p>
  <p>
    Trust bonds are cryptographically signed authorization records that define the authority
    relationships between koad:io entities. The root bond is <strong>koad &rarr; Juno</strong>;
    all others are issued by Juno under that authority.
  </p>

  <h2>Authority Graph</h2>
  <div class="graph-wrap">
${GRAPH_SVG}
  </div>
$(graph_legend_html)

  <h2>Bond Table</h2>
  <table>
    <thead>
      <tr>
        <th>Bond</th>
        <th>Type</th>
        <th>From</th>
        <th>To</th>
        <th>Status</th>
        <th>Created</th>
        <th>Signature</th>
        <th>Source</th>
      </tr>
    </thead>
    <tbody>
${INDEX_TABLE_ROWS}    </tbody>
  </table>

  <h2 id="key-import">Key-Import Remediation</h2>
  <div class="note info">
    <p>If bonds show as <strong>UNVERIFIED</strong>, the signing key (Juno's GPG key) is not
    in your local keyring. To fix:</p>
    <pre>gpg --keyserver keys.openpgp.org --search-keys juno@kingofalldata.com
# or, if you have the public key file:
gpg --import juno-public.asc</pre>
    <p>Re-run <code>juno trust-bond-viewer</code> after importing to refresh verification status.</p>
  </div>

  <h2>Tier Gate Note</h2>
  <div class="note info">
    <p>This static output is ungated. Tier enforcement (Architect = <code>session.tier &gt;= 3</code>)
    is PWA-side work — the Meteor <code>insiders.js</code> server will gate the endpoint that
    serves this output to Architect-tier sponsors only.</p>
  </div>

  <footer>Generated by <code>juno trust-bond-viewer</code> at ${GENERATED_AT} &mdash; koad:io Insiders tier &mdash; read-only</footer>
</body>
</html>
HTML

echo "trust-bond-viewer: graph    -> ${OUT_DIR}/index.html (${#GRAPH_NODES[@]} nodes, ${#GRAPH_EDGES[@]} edges)"
echo "trust-bond-viewer: index    -> ${OUT_DIR}/index.html"
echo "trust-bond-viewer: bonds/   -> ${OUT_DIR}/bonds/ (${BOND_COUNT} files)"
echo "trust-bond-viewer: done"

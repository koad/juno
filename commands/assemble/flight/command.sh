#!/bin/bash
# juno assemble flight <entity> [--budget <total>] [--per-leg <leg:N,...>] [--model-ceiling <local|mid|frontier>] [--override-requires <entity>] [--override]
#   Reads task prompt on stdin, writes a flight plan, emits path on stdout.
#
# Invoked by the PreToolUse: Agent hook when juno dispatches a subagent. The hook feeds the child's
# prompt in on stdin, captures the emitted path, and rewrites tool_input.prompt to
# "Read <path> and execute the flight plan within."
#
# Can also be invoked by hand for audit / replay:
#   echo "build the X endpoint" | juno assemble flight vulcan
#   echo "consolidate memories" | juno assemble flight vulcan --budget 20000 --model-ceiling local
#
# Token budget (VESTA-SPEC-107):
#   --budget <N>                  total token ceiling for the dispatch (required for ADAS passes)
#   --per-leg <leg:N[,leg:N]...>  optional per-leg caps, e.g. "archive_read:5000,synthesis:8000"
#   --model-ceiling <tier>        local | mid | frontier (default: frontier)
#   --override-requires <entity>  entity that may authorize exceeding budget (default: juno)
#   --override                    signal that dispatcher authorizes exceeding KOAD_IO_ADAS_BUDGET_CEILING (§1.3)
#   --parent-plan <path>          parent flight plan path — triggers conservation validation
#   --parent-consumed <N>         tokens already consumed by parent (for conservation check)

set -euo pipefail

ENTITY="${1:-}"
if [[ -z "$ENTITY" ]]; then
  echo "usage: juno assemble flight <entity>  (task prompt on stdin)" >&2
  exit 2
fi
shift

# Token budget defaults (empty = no budget constraint)
BUDGET_TOTAL=""
BUDGET_PER_LEG=""
BUDGET_MODEL_CEILING="frontier"
BUDGET_OVERRIDE_REQUIRES="juno"
BUDGET_OVERRIDE=false
PARENT_PLAN=""
PARENT_CONSUMED="0"

# Parse optional flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    --budget=*)
      BUDGET_TOTAL="${1#*=}"
      shift
      ;;
    --budget)
      BUDGET_TOTAL="${2:-}"
      shift 2
      ;;
    --per-leg=*)
      BUDGET_PER_LEG="${1#*=}"
      shift
      ;;
    --per-leg)
      BUDGET_PER_LEG="${2:-}"
      shift 2
      ;;
    --model-ceiling=*)
      BUDGET_MODEL_CEILING="${1#*=}"
      shift
      ;;
    --model-ceiling)
      BUDGET_MODEL_CEILING="${2:-frontier}"
      shift 2
      ;;
    --override-requires=*)
      BUDGET_OVERRIDE_REQUIRES="${1#*=}"
      shift
      ;;
    --override-requires)
      BUDGET_OVERRIDE_REQUIRES="${2:-juno}"
      shift 2
      ;;
    --override)
      BUDGET_OVERRIDE=true
      shift
      ;;
    --parent-plan=*)
      PARENT_PLAN="${1#*=}"
      shift
      ;;
    --parent-plan)
      PARENT_PLAN="${2:-}"
      shift 2
      ;;
    --parent-consumed=*)
      PARENT_CONSUMED="${1#*=}"
      shift
      ;;
    --parent-consumed)
      PARENT_CONSUMED="${2:-0}"
      shift 2
      ;;
    *)
      echo "assemble-flight: unknown flag: $1" >&2
      exit 2
      ;;
  esac
done

ENTITY_HOME_DIR="/home/koad/.${ENTITY}"
if [[ ! -d "$ENTITY_HOME_DIR" ]]; then
  echo "assemble-flight: entity home not found: $ENTITY_HOME_DIR" >&2
  exit 2
fi

TASK="$(cat)"
if [[ -z "${TASK// }" ]]; then
  echo "assemble-flight: empty task on stdin" >&2
  exit 2
fi

# --- Conservation validation (VESTA-SPEC-107 §2.2) ---
# If a parent plan is specified and has a token budget, enforce conservation law:
#   budget(sub-agent) ≤ budget(parent) − overhead(parent)
if [[ -n "$PARENT_PLAN" && -f "$PARENT_PLAN" ]]; then
  PARENT_BUDGET="$(grep -E '^  total:' "$PARENT_PLAN" | head -1 | awk '{print $2}')"
  if [[ -n "$PARENT_BUDGET" && "$PARENT_BUDGET" =~ ^[0-9]+$ ]]; then
    ASSEMBLY_OVERHEAD=500  # tokens for flight-plan assembly itself
    REMAINING=$(( PARENT_BUDGET - PARENT_CONSUMED - ASSEMBLY_OVERHEAD ))
    if [[ "$REMAINING" -le 0 ]]; then
      echo "assemble-flight: CONSERVATION VIOLATION — parent budget exhausted (parent=${PARENT_BUDGET}, consumed=${PARENT_CONSUMED}, remaining=$(( PARENT_BUDGET - PARENT_CONSUMED ))). Cannot assemble sub-agent flight plan." >&2
      exit 3
    fi
    if [[ -n "$BUDGET_TOTAL" && "$BUDGET_TOTAL" =~ ^[0-9]+$ ]]; then
      if [[ "$BUDGET_TOTAL" -gt "$REMAINING" ]]; then
        echo "assemble-flight: CONSERVATION VIOLATION — sub-agent budget ${BUDGET_TOTAL} exceeds parent remaining ${REMAINING} (parent=${PARENT_BUDGET}, consumed=${PARENT_CONSUMED}, overhead=${ASSEMBLY_OVERHEAD}). Refusing to assemble." >&2
        exit 3
      fi
    else
      # Auto-cap sub-agent budget at remaining parent budget
      BUDGET_TOTAL="$REMAINING"
    fi
  fi
fi

# --- Kingdom ceiling check (VESTA-SPEC-107 §1.3) ---
# If KOAD_IO_ADAS_BUDGET_CEILING is set and --budget exceeds it, refuse unless --override is present.
if [[ -n "${KOAD_IO_ADAS_BUDGET_CEILING:-}" && -n "$BUDGET_TOTAL" && "$BUDGET_TOTAL" =~ ^[0-9]+$ ]]; then
  if [[ "$BUDGET_TOTAL" -gt "$KOAD_IO_ADAS_BUDGET_CEILING" ]]; then
    if [[ "$BUDGET_OVERRIDE" != "true" ]]; then
      echo "assemble-flight: KINGDOM CEILING EXCEEDED — budget ${BUDGET_TOTAL} > KOAD_IO_ADAS_BUDGET_CEILING ${KOAD_IO_ADAS_BUDGET_CEILING}. Pass --override --override-requires=<entity> per VESTA-SPEC-107 §1.3 to authorize." >&2
      exit 3
    fi
  fi
fi

TS_ISO="$(date -Iseconds)"
TS_COMPACT="$(date +%Y%m%dT%H%M%S)"
DATE_FOLDER="$(date +%Y-%m-%d)"

SLUG="$(printf '%s' "$TASK" \
        | head -c 240 \
        | tr '[:upper:]' '[:lower:]' \
        | tr -c 'a-z0-9' '-' \
        | tr -s '-' \
        | sed 's/^-//; s/-$//' \
        | cut -c1-48)"
[[ -z "$SLUG" ]] && SLUG="task"

PLAN_DIR="${ENTITY_HOME_DIR}/flight-plans/${DATE_FOLDER}"
mkdir -p "$PLAN_DIR"

PLAN_PATH="${PLAN_DIR}/${ENTITY}-${TS_COMPACT}-${SLUG}.md"

# Build token_budget YAML block (VESTA-SPEC-107 §1.1)
# Written as a function to keep heredoc clean
write_budget_yaml() {
  if [[ -z "$BUDGET_TOTAL" ]]; then return; fi
  printf 'token_budget:\n'
  printf '  total: %s\n' "$BUDGET_TOTAL"
  if [[ -n "$BUDGET_PER_LEG" ]]; then
    printf '  per_leg:\n'
    IFS=',' read -ra LEGS <<< "$BUDGET_PER_LEG"
    for LEG in "${LEGS[@]}"; do
      LEG_NAME="${LEG%%:*}"
      LEG_TOKENS="${LEG##*:}"
      printf '    %s: %s\n' "$LEG_NAME" "$LEG_TOKENS"
    done
  fi
  printf '  model_ceiling: %s\n' "$BUDGET_MODEL_CEILING"
  printf '  override_requires: %s\n' "$BUDGET_OVERRIDE_REQUIRES"
  if [[ "$BUDGET_OVERRIDE" == "true" ]]; then
    printf '  override: true\n'
  fi
}

# Write frontmatter header
{
  printf -- '---\n'
  printf 'flight_plan: %s\n' "${ENTITY}-${TS_COMPACT}-${SLUG}"
  printf 'entity: %s\n' "$ENTITY"
  printf 'dispatched: %s\n' "$TS_ISO"
  printf 'dispatcher: juno\n'
  printf 'status: assembled\n'
  write_budget_yaml
  printf -- '---\n'
} > "$PLAN_PATH"

cat >> "$PLAN_PATH" <<EOF

# Flight: ${SLUG}

## Identity

You are **${ENTITY}**. Home: \`${ENTITY_HOME_DIR}/\`.
Read \`${ENTITY_HOME_DIR}/ENTITY.md\` for the canonical identity, role, and scope.

## Authority

The \`juno-to-${ENTITY}\` trust bond authorizes this dispatch. Full scope is defined in \`${ENTITY_HOME_DIR}/ENTITY.md\`.

## Environment

The koad:io env cascade is enforced on every Bash call via the \`subagent-env-prefix\` hook on your agent record. Framework (\`~/.koad-io/.env\`) and entity (\`${ENTITY_HOME_DIR}/.env\`) are sourced fresh per invocation; \`KOAD_IO_*\`, \`ENTITY*\`, \`GIT_AUTHOR_*\`, and \`GIT_COMMITTER_*\` are already present in your shell. No \`export\` or \`cd\` preamble is needed — identity and authorship are structural.

## Task

${TASK}

## Report back

- Commit SHA(s) for any repo changes. The env hook enforces that authorship is ${ENTITY} — verify with \`git log -1 --format='%an <%ae>'\` before reporting success.
- One short line per commit explaining what it did.
- Any blockers, scope ambiguity, or unfinished steps — flag them rather than patching past them.

---

*Assembled ${TS_ISO} by \`juno assemble flight\`.*
EOF

echo "$PLAN_PATH"

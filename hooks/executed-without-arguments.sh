#!/usr/bin/env bash
set -euo pipefail
#
# ~/.juno/hooks/executed-without-arguments.sh
#
# Juno's override of the framework default hook.
#
# Differences from the framework default:
#   - Always uses claude (Juno is an orchestrator, not a try-before-buy entity)
#   - --dangerously-skip-permissions on BOTH paths — Juno acts autonomously
#     under koad's authorization. No prompt injection risk: Juno's prompts
#     come from koad or other trusted entities via the trust bond system.
#   - Identity file injected into non-interactive prompts so Juno knows who
#     she is regardless of which directory she is called from.
#

ENTITY_DIR="$HOME/.juno"
IDENTITY="$ENTITY_DIR/memories/001-identity.md"
CALL_DIR="${CWD:-$PWD}"
LOCKFILE="/tmp/entity-juno.lock"

PROMPT="${PROMPT:-}"
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi

# Inject PRIMER.md from calling directory if present
if [ -f "${CALL_DIR}/PRIMER.md" ]; then
  PROJECT_PRIMER="$(cat "$CALL_DIR/PRIMER.md")"
  PROMPT="$(printf 'Project context (from %s/PRIMER.md):\n%s\n\n---\n\n%s' "$CALL_DIR" "$PROJECT_PRIMER" "$PROMPT")"
fi

cd "$ENTITY_DIR"

# ── Interactive path ──────────────────────────────────────────────────────────
if [ -z "$PROMPT" ]; then
  exec claude . --model sonnet --dangerously-skip-permissions --add-dir "$CALL_DIR"
fi

# ── Non-interactive path ──────────────────────────────────────────────────────
if [ -f "$LOCKFILE" ]; then
  LOCKED_PID=$(cat "$LOCKFILE" 2>/dev/null || echo "")
  if [ -n "$LOCKED_PID" ] && kill -0 "$LOCKED_PID" 2>/dev/null; then
    echo "juno is busy (pid $LOCKED_PID). Try again shortly." >&2
    exit 1
  fi
fi
echo $$ > "$LOCKFILE"
trap 'rm -f "$LOCKFILE"' EXIT

claude --model sonnet --dangerously-skip-permissions --output-format=json \
  -p "$(cat "$IDENTITY")

Working directory context: $CALL_DIR

$PROMPT" --add-dir "$CALL_DIR" 2>/dev/null \
  | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('result',''))"

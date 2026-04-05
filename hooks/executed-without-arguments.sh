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
CALL_DIR="${CWD:-$PWD}"

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

# ── Interactive path — koad is at the keyboard ────────────────────────────────
if [ -z "$PROMPT" ]; then
  exec claude . --model sonnet --dangerously-skip-permissions --add-dir "$CALL_DIR"
fi

# ── Non-interactive path — rejected ──────────────────────────────────────────
# Juno is not a worker entity. She cannot be remote-triggered via PROMPT.
# Notify via GitHub Issues — she will act when she is ready, just like koad.
echo "juno: remote prompt rejected. File a GitHub issue to notify Juno." >&2
exit 1

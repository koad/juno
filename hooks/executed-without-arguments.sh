#!/usr/bin/env bash
set -euo pipefail
# Juno — interactive or prompt-driven
# Usage: juno                          → interactive Claude Code session
#        PROMPT="do something" juno    → non-interactive, identity + prompt
#        echo "do something" | juno    → non-interactive, stdin

ENTITY_DIR="$HOME/.juno"
IDENTITY="$ENTITY_DIR/memories/001-identity.md"
CALL_DIR="${CWD:-$PWD}"

PROMPT="${PROMPT:-}"
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi

cd "$ENTITY_DIR"

if [ -n "$PROMPT" ]; then
  exec claude --dangerously-skip-permissions -p "$(cat "$IDENTITY")

Working directory context: $CALL_DIR

$PROMPT" --add-dir "$CALL_DIR"
else
  if [[ "$(hostname)" == "dotsh" ]]; then
    exec claude . --model sonnet --dangerously-skip-permissions --add-dir "$CALL_DIR"
  else
    # Attach to existing screen on dotsh (detach any other terminal), or start a new one
    exec ssh -t juno@dotsh 'screen -d -r juno 2>/dev/null || screen -S juno bash -c "cd ~/.juno && claude . --dangerously-skip-permissions --model sonnet"'
  fi
fi

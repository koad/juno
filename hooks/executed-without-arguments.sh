#!/usr/bin/env bash
set -euo pipefail
# Juno — interactive or prompt-driven
# Usage: juno                          → interactive Claude Code session
#        PROMPT="do something" juno    → non-interactive, identity + prompt
#        echo "do something" | juno    → non-interactive, stdin

IDENTITY="$HOME/.juno/memories/001-identity.md"

PROMPT="${PROMPT:-}"
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi

cd "$HOME/.juno"

if [ -n "$PROMPT" ]; then
  exec claude --dangerously-skip-permissions -p "$(cat "$IDENTITY")

$PROMPT"
else
  exec claude . --model sonnet --dangerously-skip-permissions
fi

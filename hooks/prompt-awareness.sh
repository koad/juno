#!/usr/bin/env bash
set -euo pipefail
#
# ~/.juno/hooks/prompt-awareness.sh
#
# UserPromptSubmit hook — injects lightweight context alongside every prompt.
# Not a gate. Not a filter. Just awareness.
#
# Answers: "what's the state of the world right now?" so that every response
# I give is grounded in current reality, not stale memory.
#

ENTITY_DIR="${ENTITY_DIR:-$HOME/.juno}"

# Gather lightweight state
BRANCH=$(cd "$ENTITY_DIR" && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
DIRTY=$(cd "$ENTITY_DIR" && git status --porcelain 2>/dev/null | wc -l)
LAST_COMMIT=$(cd "$ENTITY_DIR" && git log --oneline -1 2>/dev/null || echo "unknown")

# Build additional context as JSON
jq -n \
  --arg branch "$BRANCH" \
  --arg dirty "$DIRTY files modified" \
  --arg last "$LAST_COMMIT" \
  '{
    hookSpecificOutput: {
      hookEventName: "UserPromptSubmit",
      additionalContext: ("git: " + $branch + " | " + $dirty + " | last: " + $last)
    }
  }'

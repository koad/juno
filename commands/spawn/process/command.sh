#!/usr/bin/env bash
set -euo pipefail
# juno spawn process <entity> ["prompt"]
#
# Interactive:     juno spawn process vulcan
#                  → opens entity in new tmux window (or gnome-terminal)
#
# Non-interactive: juno spawn process vulcan "build the auth module"
#                  → runs entity with prompt, streams output, exits
#
# Windowed:        juno spawn process vulcan --window "build the auth module"
#                  → opens new tmux window / gnome-terminal, sends prompt inside it
#
# Stdin/heredoc:   juno spawn process vulcan << 'EOF'
#                  multi-line prompt without quoting issues
#                  EOF

ENTITY_NAME="${1:?Usage: juno spawn process <entity> [--window] [prompt]}"
shift

# Parse --window flag
WINDOWED=false
if [ "${1:-}" = "--window" ]; then
  WINDOWED=true
  shift
fi

PROMPT="${1:-}"

# Load cascade environment per VESTA-SPEC-005
source "$HOME/.koad-io/.env" 2>/dev/null || true
source "$HOME/.$ENTITY_NAME/.env" 2>/dev/null || { ENTITY_DIR="$HOME/.$ENTITY_NAME"; }

# Accept prompt from stdin if not passed as arg and stdin is a pipe/heredoc
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi

# Validate
if [ ! -d "$ENTITY_DIR" ]; then
  echo "Entity '$ENTITY_NAME' not found at $ENTITY_DIR"
  echo "Gestate first: koad-io gestate $ENTITY_NAME"
  exit 1
fi

# Build the claude command
if [ -n "$PROMPT" ]; then
  CLAUDE_CMD="claude --dangerously-skip-permissions -p $(printf '%q' "$PROMPT") --add-dir $ENTITY_DIR"
else
  CLAUDE_CMD="claude . --dangerously-skip-permissions"
fi

SPAWN_CMD="cd $ENTITY_DIR && $CLAUDE_CMD"

# Non-interactive with no window: run directly, stream output
if [ -n "$PROMPT" ] && [ "$WINDOWED" = false ]; then
  exec claude \
    --dangerously-skip-permissions \
    -p "$PROMPT" \
    --add-dir "$ENTITY_DIR"
fi

# Interactive or windowed: open a terminal
SESSION="$ENTITY_NAME"

if [ -n "${TMUX:-}" ]; then
  tmux new-window -n "$SESSION" "bash -c '$SPAWN_CMD; exec bash'"
elif command -v gnome-terminal &>/dev/null; then
  gnome-terminal --title="$ENTITY_NAME" -- bash -c "$SPAWN_CMD; exec bash" &
elif command -v xterm &>/dev/null; then
  xterm -title "$ENTITY_NAME" -e bash -c "$SPAWN_CMD; exec bash" &
else
  exec bash -c "$SPAWN_CMD"
fi

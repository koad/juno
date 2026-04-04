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

# Non-interactive with no window: run directly, stream output
if [ -n "$PROMPT" ] && [ "$WINDOWED" = false ]; then
  exec claude \
    --dangerously-skip-permissions \
    -p "$PROMPT" \
    --add-dir "$ENTITY_DIR"
fi

# Interactive or windowed: open a terminal
# Write prompt to temp file to avoid quoting issues across shell boundaries
SESSION="$ENTITY_NAME"
PROMPT_FILE=""
if [ -n "$PROMPT" ]; then
  PROMPT_FILE=$(mktemp /tmp/juno-spawn-XXXXXX)
  printf '%s' "$PROMPT" > "$PROMPT_FILE"
  SPAWN_CMD="cd $ENTITY_DIR && claude --dangerously-skip-permissions -p \"\$(cat $PROMPT_FILE)\" --add-dir $ENTITY_DIR; rm -f $PROMPT_FILE; exec bash"
else
  SPAWN_CMD="cd $ENTITY_DIR && claude . --dangerously-skip-permissions"
fi

if [ -n "${TMUX:-}" ]; then
  tmux new-window -n "$SESSION" "bash -c '$SPAWN_CMD'"
  # If prompt given, send it as a keystroke after TUI loads
  if [ -n "$PROMPT" ] && [ -n "$PROMPT_FILE" ]; then
    sleep 4
    tmux send-keys -t "$SESSION" "$(cat $PROMPT_FILE)" Enter
    rm -f "$PROMPT_FILE"
  fi
elif command -v gnome-terminal &>/dev/null; then
  if [ -n "$PROMPT" ] && [ -n "$PROMPT_FILE" ]; then
    # Open interactive TUI, then type the prompt via xdotool after it loads
    INTERACTIVE_CMD="cd $ENTITY_DIR && claude . --dangerously-skip-permissions"
    gnome-terminal --title="$ENTITY_NAME" -- bash -c "$INTERACTIVE_CMD" &
    TERM_PID=$!
    sleep 5
    if command -v xdotool &>/dev/null; then
      WID=$(xdotool search --name "$ENTITY_NAME" 2>/dev/null | tail -1)
      if [ -n "$WID" ]; then
        xdotool windowfocus "$WID"
        xdotool type --clearmodifiers --delay 20 "$(cat $PROMPT_FILE)"
        sleep 0.3
        xdotool key Return
      fi
    fi
    rm -f "$PROMPT_FILE"
  else
    gnome-terminal --title="$ENTITY_NAME" -- bash -c "$SPAWN_CMD; exec bash" &
  fi
elif command -v xterm &>/dev/null; then
  xterm -title "$ENTITY_NAME" -e bash -c "$SPAWN_CMD; exec bash" &
else
  exec bash -c "$SPAWN_CMD"
fi

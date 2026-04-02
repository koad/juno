#!/usr/bin/env bash

# Juno Team Status Command
# Show recent commits for all known team entities
# Usage: juno team status

ENTITIES=(juno vulcan vesta veritas mercury muse sibyl argus salus janus aegis)

echo "╔══════════════════════════════════════════╗"
echo "║  Team Status — $(date '+%Y-%m-%d %H:%M')"
echo "╚══════════════════════════════════════════╝"
echo ""

for ENTITY in "${ENTITIES[@]}"; do
    ENTITY_DIR="$HOME/.$ENTITY"
    if [ -d "$ENTITY_DIR/.git" ]; then
        LAST=$(git -C "$ENTITY_DIR" log --oneline -1 2>/dev/null)
        DEPTH=$(ls "$ENTITY_DIR/memories/" 2>/dev/null | wc -l)
        echo "  [$ENTITY] memories:$DEPTH — $LAST"
    else
        echo "  [$ENTITY] not gestated"
    fi
done

echo ""

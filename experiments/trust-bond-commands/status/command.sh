#!/usr/bin/env bash
# trust bond status — list all bonds, show chain and expiry
set -euo pipefail

BONDS_DIR="${ENTITY_DIR}/trust/bonds"

if [ ! -d "$BONDS_DIR" ]; then
  echo "No trust/bonds/ directory found in ${ENTITY_DIR}"
  exit 0
fi

echo "Trust bonds for ${ENTITY}:"
echo ""

ACTIVE=0
DRAFT=0
REVOKED=0

for bond in "$BONDS_DIR"/*.md; do
  [ -f "$bond" ] || continue
  name=$(basename "$bond" .md)
  status=$(grep -m1 "^\*\*Status:\*\*" "$bond" 2>/dev/null | sed 's/\*\*Status:\*\* //' || echo "unknown")
  type=$(grep -m1 "^\*\*Type:\*\*" "$bond" 2>/dev/null | sed 's/\*\*Type:\*\* //' || echo "unknown")
  asc="${bond}.asc"

  if [[ "$status" == *"ACTIVE"* ]]; then
    sig="✓"
    ACTIVE=$((ACTIVE+1))
  elif [[ "$status" == *"REVOKED"* ]]; then
    sig="✗"
    REVOKED=$((REVOKED+1))
  else
    sig="○"
    DRAFT=$((DRAFT+1))
  fi

  # Check signature file exists
  if [ ! -f "$asc" ]; then
    sig="⚠ (no .asc)"
  fi

  echo "  $sig $name"
  echo "     type: $type"
  echo "     status: $status"
done

echo ""
echo "Summary: ${ACTIVE} active, ${DRAFT} draft, ${REVOKED} revoked"

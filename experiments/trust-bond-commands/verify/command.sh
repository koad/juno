#!/usr/bin/env bash
# trust bond verify — verify a bond signature
set -euo pipefail

BONDS_DIR="${ENTITY_DIR}/trust/bonds"
TARGET="${1:-}"

if [ -z "$TARGET" ]; then
  echo "Usage: ${ENTITY} trust bond verify <grantor-to-grantee>"
  echo ""
  echo "Available bonds:"
  ls "$BONDS_DIR"/*.asc 2>/dev/null | xargs -I{} basename {} .md.asc || echo "  (none)"
  exit 1
fi

ASC="${BONDS_DIR}/${TARGET}.md.asc"

if [ ! -f "$ASC" ]; then
  echo "Error: no signed bond found at ${ASC}"
  exit 1
fi

echo "Verifying: ${TARGET}"
echo ""

result=$(gpg --verify "$ASC" 2>&1)
if echo "$result" | grep -q "Good signature"; then
  echo "✓ VALID — $(echo "$result" | grep 'Good signature')"
  echo ""
  echo "Bond content:"
  head -10 "${BONDS_DIR}/${TARGET}.md"
else
  echo "✗ INVALID or unverifiable"
  echo ""
  echo "$result"
  exit 1
fi

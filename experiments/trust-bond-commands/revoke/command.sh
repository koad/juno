#!/usr/bin/env bash
# trust bond revoke — issue a revocation notice for an active bond
set -euo pipefail

BONDS_DIR="${ENTITY_DIR}/trust/bonds"
REVOKED_DIR="${BONDS_DIR}/revoked"
TARGET="${1:-}"

if [ -z "$TARGET" ]; then
  echo "Usage: ${ENTITY} trust bond revoke <grantor-to-grantee>"
  echo ""
  echo "Active bonds:"
  ls "$BONDS_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md || echo "  (none)"
  exit 1
fi

BOND_MD="${BONDS_DIR}/${TARGET}.md"
BOND_ASC="${BONDS_DIR}/${TARGET}.md.asc"

if [ ! -f "$BOND_MD" ]; then
  echo "Error: bond not found: ${BOND_MD}"
  exit 1
fi

echo "Revoking bond: ${TARGET}"
echo ""
echo "Current status:"
grep "Status:" "$BOND_MD"
echo ""
read -p "Reason for revocation: " REASON
read -p "Confirm revocation of '${TARGET}'? This cannot be undone. [y/N] " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

mkdir -p "$REVOKED_DIR"
TODAY=$(date +%Y-%m-%d)

# Create revocation notice
REVOCATION="${REVOKED_DIR}/${TARGET}-revoked-${TODAY}.md"
cat > "$REVOCATION" << REVOKEEOF
# Revocation Notice: ${TARGET}

**Revoked by:** ${ENTITY^}
**Date:** ${TODAY}
**Reason:** ${REASON}
**Original bond:** ${TARGET}.md

The bond '${TARGET}' has been revoked. All authorizations granted by this bond
are immediately suspended. The grantee should be notified via GitHub Issue.

This revocation is permanent.
REVOKEEOF

# Move bond to revoked/
mv "$BOND_MD" "${REVOKED_DIR}/${TARGET}.md"
[ -f "$BOND_ASC" ] && mv "$BOND_ASC" "${REVOKED_DIR}/${TARGET}.md.asc"

echo "✓ Bond archived to: ${REVOKED_DIR}/"
echo "✓ Revocation notice: ${REVOCATION}"
echo ""
echo "Next steps:"
echo "  1. Commit the revocation: git add trust/ && git commit"
echo "  2. File a GitHub Issue on ${TARGET##*-to-}'s repo to notify them"
echo "  3. Remove the bond copy from ~/.${TARGET##*-to-}/trust/bonds/"

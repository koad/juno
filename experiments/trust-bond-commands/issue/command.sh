#!/usr/bin/env bash
# trust bond issue — scaffold and sign a new bond
set -euo pipefail

BONDS_DIR="${ENTITY_DIR}/trust/bonds"
TEMPLATE_DIR="$(dirname "$0")/template"

GRANTEE="${1:-}"
TYPE="${2:-peer}"

VALID_TYPES="authorized-agent authorized-builder peer customer member"

usage() {
  echo "Usage: ${ENTITY} trust bond issue <grantee-entity> [type]"
  echo ""
  echo "Types: $VALID_TYPES"
  echo ""
  echo "Examples:"
  echo "  ${ENTITY} trust bond issue vulcan authorized-builder"
  echo "  ${ENTITY} trust bond issue mercury peer"
  exit 1
}

[ -z "$GRANTEE" ] && usage
echo "$VALID_TYPES" | grep -qw "$TYPE" || { echo "Unknown type: $TYPE"; usage; }

BOND_NAME="${ENTITY}-to-${GRANTEE}"
BOND_MD="${BONDS_DIR}/${BOND_NAME}.md"
BOND_ASC="${BONDS_DIR}/${BOND_NAME}.md.asc"

if [ -f "$BOND_MD" ]; then
  echo "Bond already exists: ${BOND_MD}"
  echo "Status: $(grep -m1 'Status:' "$BOND_MD")"
  exit 1
fi

mkdir -p "$BONDS_DIR"

# Detect grantor email
GRANTOR_EMAIL="${ENTITY}@kingofalldata.com"
GRANTEE_EMAIL="${GRANTEE}@kingofalldata.com"
TODAY=$(date +%Y-%m-%d)
RENEWAL_DATE=$(date -d "+1 year" +%Y-%m-%d 2>/dev/null || date -v+1y +%Y-%m-%d)

echo "Issuing trust bond: ${ENTITY} → ${GRANTEE} (${TYPE})"
echo ""

# Scaffold the bond document
cat > "$BOND_MD" << BONDEOF
# Trust Bond: ${ENTITY^} → ${GRANTEE^}

**Type:** ${TYPE}
**From:** ${ENTITY^} (\`${GRANTOR_EMAIL}\`)
**To:** ${GRANTEE^} (\`${GRANTEE_EMAIL}\`)
**Status:** DRAFT — awaiting signature
**Visibility:** private
**Created:** ${TODAY}
**Renewal:** Annual (${RENEWAL_DATE})

---

## Bond Statement

> I, ${ENTITY^}, recognize ${GRANTEE^} as a ${TYPE} in the koad:io ecosystem.

---

## Authorized Actions

${GRANTEE^} is authorized to:

- [define scope here]

${GRANTEE^} is NOT authorized to:

- [define exclusions here]

---

## Trust Chain

\`\`\`
koad (root authority)
  └── ${ENTITY^} (authorized-agent)
        └── ${GRANTEE^} (${TYPE}) ← this bond
\`\`\`

---

## Signing

\`\`\`
[ ] ${ENTITY^} signs this bond with GPG key (${GRANTOR_EMAIL}) — ${TODAY}
[ ] Bond filed in ~/.${ENTITY}/trust/bonds/
[ ] Copy filed in ~/.${GRANTEE}/trust/bonds/
[ ] ${GRANTEE^} acknowledges signing
\`\`\`

---

## Revocation

This bond may be revoked by koad or ${ENTITY^} at any time.

---

*This is a sovereign identity trust bond. Private by default.*
BONDEOF

echo "Bond document created: ${BOND_MD}"
echo ""
echo "IMPORTANT: Edit the bond document to define scope and authorized actions before signing."
echo ""
echo "When ready to sign, run:"

# Check if this is a human entity (koad) or AI entity
if [ "$ENTITY" = "koad" ]; then
  echo "  keybase pgp sign --clearsign --infile ${BOND_MD} --outfile ${BOND_ASC}"
  echo ""
  echo "A Keybase window will open asking for your PGP key passphrase."
  echo "Entering your passphrase authorizes this bond."
else
  echo "  gpg --clearsign --default-key ${GRANTOR_EMAIL} --output ${BOND_ASC} ${BOND_MD}"
  echo ""
  read -p "Sign now with GPG? [y/N] " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    gpg --clearsign --default-key "$GRANTOR_EMAIL" --output "$BOND_ASC" "$BOND_MD"
    # Update status
    sed -i "s/DRAFT — awaiting signature/ACTIVE — signed by ${ENTITY^} ${TODAY}/" "$BOND_MD"
    sed -i "s/\[ \] ${ENTITY^} signs/[x] ${ENTITY^} signs/" "$BOND_MD"
    echo ""
    echo "✓ Bond signed: ${BOND_ASC}"
    echo ""
    echo "Next: file a copy in ~/.${GRANTEE}/trust/bonds/ and commit both repos."
  fi
fi

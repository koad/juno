# Trust Revocation

This directory holds revocation files for trust bonds issued by Juno.

## What a Revocation File Is

A revocation is a signed statement that a previously-issued trust bond is no longer valid.

**File format:** `juno-to-<entity>-revocation.md` + `juno-to-<entity>-revocation.md.asc`

**Contents:**
```
revokes: juno-to-<entity>.md
revoked-by: juno (juno@kingofalldata.com)
reason: [compromise / relationship-end / scope-change]
effective: [date]
```

## Revocation Cascade

The root bond (`koad-to-juno.md`) contains a cascade clause:
> "Revoke the root, suspend the tree."

If koad revokes `koad-to-juno.md`, all downstream bonds Juno has issued (juno→vulcan, juno→veritas, etc.) are suspended. Juno cannot issue new bonds until the root is re-established.

## How to Issue a Revocation

1. Create the revocation `.md` file in this directory
2. GPG-clearsign it: `gpg --clearsign <file>`
3. File a copy in the recipient entity's `trust/bonds/` directory
4. Commit both with message: `trust: revoke juno-to-<entity> — [reason]`
5. File a GitHub Issue on the entity's repo noting the revocation

## Current State

No revocations have been filed. All bonds are active.

---

*This directory was created 2026-04-05 (commit `60d8900`). Aegis assessment: koad/juno#63.*

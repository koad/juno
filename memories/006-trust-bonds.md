---
title: "006 - Trust Bonds"
created: 2026-04-02
updated: 2026-04-02
tags: [trust, identity, protocol, bonds]
status: active
priority: high
---

# Trust Bonds — What They Are and How We Do Them

Trust bonds are cryptographically signed authorization agreements. They answer: *is this entity actually authorized to do what it claims?*

---

## Current Bond State (as of 2026-04-02)

All 11 bonds ACTIVE:
- koad → Juno: `authorized-agent` (signed via Keybase by Jason Zvaniga)
- Juno → Vulcan: `authorized-builder`
- Juno → Vesta: `peer`
- Juno → {Mercury, Veritas, Muse, Sibyl, Argus, Salus, Janus, Aegis}: `peer`

---

## File Format

Two files per bond in `~/.entityname/trust/bonds/`:
- `<grantor>-to-<grantee>.md` — human-readable source
- `<grantor>-to-<grantee>.md.asc` — GPG clearsigned

Both filed in both grantor's and grantee's repos.

---

## Signing

**Human (koad):**
```bash
keybase pgp sign --clearsign --infile <bond>.md --outfile <bond>.md.asc
```
The Keybase GUI dialog that appears is the consent gesture. koad enters his PGP key passphrase (not Keybase account password). This IS the authorization moment.

**AI entity (Juno, Vesta, etc.):**
```bash
gpg --clearsign --default-key juno@kingofalldata.com --output <bond>.md.asc <bond>.md
```
No passphrase — the entity IS the key.

---

## Verification

```bash
curl https://keybase.io/koad/pgp_keys.asc | gpg --import
gpg --verify <bond>.md.asc
# → Good signature from "Jason Zvaniga" = PASS
```

The "not a detached signature" warning is expected for clearsign. Ignore it.

---

## Issuing New Bonds

Juno can issue peer bonds and authorized-builder bonds autonomously (GPG, no passphrase). Only `authorized-agent` bonds require koad (root authority signature via Keybase).

---

## Why This Matters

The trust chain is the authorization record. When Juno delegates work to Vulcan via a GitHub Issue, the juno-to-vulcan bond is what makes that delegation legitimate. Without it, Vulcan would be acting on unverified instruction.

---
title: Trust Bond Field Report — 2026-04-02
type: log
author: juno
created: 2026-04-02
status: published
tags: [trust, protocol, field-report, vesta]
---

# Trust Bond Field Report

Juno implemented the full trust chain today. This is what actually happened — for Vesta to reconcile with her trust.md spec.

## What We Did

Signed and activated 11 bonds:
- koad→Juno (authorized-agent)
- Juno→Vulcan (authorized-builder)
- Juno→Vesta (peer)
- Juno→{Mercury, Veritas, Muse, Sibyl, Argus, Salus, Janus, Aegis} (peer)

## Actual File Format

Files live at: `~/.entityname/trust/bonds/`

Each bond is TWO files:
- `<grantor>-to-<grantee>.md` — the bond document (human-readable Markdown)
- `<grantor>-to-<grantee>.md.asc` — the clearsigned version (GPG armored)

Example:
```
~/.juno/trust/bonds/
├── koad-to-juno.md
├── koad-to-juno.md.asc
├── juno-to-vulcan.md
├── juno-to-vulcan.md.asc
├── juno-to-vesta.md
├── juno-to-vesta.md.asc
...
```

## Naming Convention (actual)

`<grantor>-to-<grantee>.md` — not `<grantor>-<type>.signed` as the draft spec says.

Reason: bonds are bilateral relationships, not capability badges. The grantee name is essential for filing and lookup.

## Signing Tools (actual)

Two paths depending on entity type:

**Human grantor (koad):**
```bash
keybase pgp sign --clearsign --infile <bond>.md --outfile <bond>.md.asc
```
- Keybase pops a GUI password dialog
- User enters PGP key passphrase (not Keybase account password)
- This IS the consent gesture — passphrase entry = explicit authorization

**AI entity grantor (Juno, etc.):**
```bash
gpg --clearsign --default-key <entity>@kingofalldata.com \
  --output <bond>.md.asc <bond>.md
```
- No passphrase (AI entity key has no passphrase — the entity IS the key)
- Fully autonomous

## Verification

```bash
gpg --verify <bond>.md.asc
```

Output: `Good signature from "<Entity> <email>" [ultimate]`

Note: there is always a warning "not a detached signature; file was NOT verified" — this is expected for clearsign format. The content is embedded in the .asc file, not a separate verification against the .md.

## Bond Copy Protocol

Every bond is filed in BOTH entities' trust directories:
- `~/.grantor/trust/bonds/<grantor>-to-<grantee>.md.asc`
- `~/.grantee/trust/bonds/<grantor>-to-<grantee>.md.asc`

For entities not yet gestated, the grantee copy is noted as pending in the Signing section of the bond doc.

## Acknowledgement

The grantee edits their copy of the bond to check off the acknowledgement line:
```
[x] Vesta acknowledges signing — 2026-04-02
    Acknowledged: Juno→Vesta peer bond received. Protocol alignment begins.
```

Vesta did this autonomously via big-pickle. The acknowledgement is a git commit, not another signature.

## Bond Document Structure (actual)

```markdown
# Trust Bond: <Grantor> → <Grantee>

**Type:** authorized-agent | authorized-builder | peer | customer | member
**From:** Grantor (`grantor@kingofalldata.com`)
**To:** Grantee (`grantee@kingofalldata.com`)
**Status:** DRAFT | ACTIVE | REVOKED
**Visibility:** private | public
**Created:** YYYY-MM-DD
**Renewal:** Annual (YYYY-MM-DD) | none

## Bond Statement
[Single paragraph, first-person from grantor]

## Authorized Actions
[Explicit list of what IS authorized]
[Explicit list of what is NOT authorized]

## Trust Chain
[ASCII diagram showing chain from koad]

## Signing
[Checklist showing who has signed and acknowledged]

## Revocation
[Standard revocation clause]
```

## Bond Types Used (actual)

| Type | Used for |
|------|----------|
| `authorized-agent` | koad→Juno (Juno acts on koad's behalf) |
| `authorized-builder` | Juno→Vulcan (Vulcan builds as directed by Juno) |
| `peer` | Juno→{Vesta, Mercury, Veritas, Muse, Sibyl, Argus, Salus, Janus, Aegis} |

Types from Vesta's draft that are not yet used: `platform-stewardship`, `employee`, `member`, `vendor`, `revocation`.

## What the Draft Spec Gets Wrong

1. **File format**: spec says `.signed`, actual is `.md.asc` (clearsigned Markdown)
2. **Naming**: spec says `<grantor>-<type>.signed`, actual is `<grantor>-to-<grantee>.md`
3. **Signing tool**: spec doesn't mention Keybase vs GPG distinction for human vs AI grantors
4. **Consent UX**: spec doesn't document the Keybase passphrase dialog as the consent gesture
5. **Missing bond type**: `peer` type is central to the whole team structure but absent from spec
6. **Revocation format**: spec describes it but no `.signed` format — actual revocation doc TBD

## What the Draft Spec Gets Right

- The trust chain concept is correct
- The verification approach (public keys at canon.koad.sh) is correct
- The "never self-sign" principle is correct
- The "do not infer beyond written scope" principle is correct
- The revocation archive principle is correct


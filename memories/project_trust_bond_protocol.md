---
name: Trust bond protocol
description: Actual trust bond implementation — file format, naming, signing tools, copy protocol
type: project
---

Implemented in full 2026-04-02. All 11 bonds ACTIVE. Vesta's trust.md spec reconciled against this.

## File Format

Two files per bond:
- `<grantor>-to-<grantee>.md` — human-readable bond document
- `<grantor>-to-<grantee>.md.asc` — GPG clearsigned version

Both filed in both `~/.grantor/trust/bonds/` and `~/.grantee/trust/bonds/`.

## Signing

**Human grantor (koad):**
```bash
keybase pgp sign --clearsign --infile <bond>.md --outfile <bond>.md.asc
```

**AI entity grantor (Juno, Vesta, etc.):**
```bash
gpg --clearsign --default-key <entity>@kingofalldata.com --output <bond>.md.asc <bond>.md
```

## Verification
```bash
gpg --verify <bond>.md.asc
```
"Good signature" is the pass state. "not a detached signature" warning is expected — normal for clearsign.

## Bond types in use
- `authorized-agent` — koad→Juno
- `authorized-builder` — Juno→Vulcan
- `peer` — Juno→{Vesta, Mercury, Veritas, Muse, Sibyl, Argus, Salus, Janus, Aegis}

## Acknowledgement
Grantee edits their copy to check the acknowledgement line — a git commit, not another signature.

## koad's signing key
Keybase: `keybase@kingofalldata.com`, fingerprint `A07F8CFE CBF6 B982 EEDA C4F3 62D5 C486 6C24 7E00`, expires 2033-01-30.
Public key importable: `curl https://keybase.io/koad/pgp_keys.asc | gpg --import`

**Why:** The .signed format in Vesta's early draft was wrong — actual implementation uses .md.asc (GPG armored clearsign). The two-file pattern (.md + .md.asc) keeps the human-readable source separate from the signed artifact.

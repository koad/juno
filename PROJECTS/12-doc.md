# PROJECT: Doc — Entity Doctor

**Status:** Planned
**Owner:** Juno (spec) → Vulcan (build)
**Layer:** Quality
**Priority:** After Vulcan gestation

---

## Purpose

Doc examines entity directories and human profiles against the koad:io protocol and tells you what's technically wrong. It's a diagnostic tool — it reads the patient, compares to the schema, and reports. It doesn't fix anything.

## What Doc Checks

### Entity Health
- Directory structure vs what `koad-io gestate` produces
- `.env` completeness and correctness
- Cryptographic keys in `id/` — present, valid, matching identity
- Trust bonds — properly signed, not expired, chain intact
- Git identity — matches `.env`, commits are clean
- Required files — CLAUDE.md, README.md, memories/, commands/
- GitHub connectivity — repo exists, gh CLI authenticated, remote matches

### Human Profile Health
- Profile completeness against koad:io schema
- Key distribution — public keys accessible where expected
- Trust chain — bonds pointing to this profile are valid
- Identity consistency — name, email, keys all agree

## Output

A diagnosis. Structured report:
- **Healthy:** what's correct
- **Warning:** what's present but misconfigured
- **Missing:** what should exist but doesn't
- **Critical:** what's broken and blocks operation

## Workflow

```
Juno (or koad) → "doc, check ~/.vulcan/"
Doc → examines directory against protocol
Doc → returns diagnosis
Juno (or Vulcan) → fixes what's broken
```

## Gestation

```bash
koad-io gestate doc
# koad connects to GitHub
# Vulcan builds out Doc's diagnostic skills
```

## Dependencies

- Vulcan must be gestated first (Vulcan builds Doc's capabilities)
- koad:io protocol must be the reference (not hardcoded assumptions)

---

*Created: 2026-03-31*

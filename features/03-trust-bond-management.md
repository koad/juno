---
status: complete
owner: juno
priority: high
description: Create, sign, and manage trust bonds — GPG-signed authorization agreements governing entity relationships
---

# Trust Bond Management

## Purpose
Trust bonds are the governance layer. Juno is the mother entity who gestated the team — she signs bonds establishing what each entity is authorized to do. Bonds live on disk as .md + .md.asc pairs.

## Specification
- Bond format: YAML frontmatter + markdown body + GPG clearsign signature
- Location: `~/.juno/trust/bonds/juno-to-<entity>.md`
- Bond copy goes to entity's trust/bonds/ directory
- Keybase used for human consent gesture
- Annual renewal cycle

## Implementation
- Bond files: juno-to-vulcan, juno-to-veritas, juno-to-mercury, juno-to-muse, juno-to-sibyl, juno-to-iris, juno-to-argus, juno-to-salus, juno-to-janus, juno-to-aegis, juno-to-livy, juno-to-rufus, juno-to-faber
- All signed with Juno's GPG key

## Dependencies
- GPG keys in id/
- VESTA-SPEC-007 (trust bond protocol)

## Testing
- `gpg --verify trust/bonds/juno-to-<entity>.md.asc` → valid signature

## Status Note
All 13 peer bonds active as of 2026-04-03.

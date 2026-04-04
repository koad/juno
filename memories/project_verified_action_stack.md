---
name: verified action stack — entity × host × permission table × stream × audit
description: every action is signed by entity+host, validated against permission table, streamed, audited, and replayable as context bubbles
type: project
---

## The Stack

Every action in koad:io is cryptographically attributed:

```
entity × host → signed action
signed action → permission table check
permission table check → stream (Janus watches)
stream → audit trail
audit trail → context bubbles (playback-machine renders)
```

## The Layers

**1. Hostname-namespaced keys (VESTA-SPEC-009 + #56)**
Each daemon generates `id/<hostname>.pub`. Multiple machines, no conflicts.
`vulcan@wonderland` signs differently from `vulcan@thinker`.

**2. Permission table (VESTA-SPEC-017)**
`trust/permissions.md` — signed by koad. Whitelists which entity+host combinations are authorized and what they can do.
- wonderland: build, commit, deploy, release
- thinker: read, report
- Unknown host: red flag, blocked

**3. Batch signing**
Daemon signs commits/releases using the host key. Every commit = entity + host + timestamp, cryptographically bound.

**4. Stream watcher (Janus)**
Watches the activity stream. Validates entity+host on every event against the permission table. Flags anomalies (unknown host, unauthorized action).

**5. Audit trail**
Not just "something happened" — who, where, when, verified. Salus heals flagged anomalies. Argus audits periodically.

**6. Context bubbles from the stream**
Any window of verified stream events is replayable as a context bubble. The playback-machine renders it.

## The Implication

The $200 laptop documentary is a cryptographically verified record. Every commit, every entity invocation, every trust bond — signed, attributed, replayable. Not just koad's story. Proof.

Journalism built on this stack produces stories that can't be misquoted — the action trail is the source record.

## How to apply
- When designing new entity capabilities, ask: does this action need to be signed? (usually yes if it produces output others depend on)
- Permission tables need to be created for each entity as they deploy to new machines
- Janus's feature roadmap should include permission-table validation, not just stream watching
- The audit trail IS a context bubble — treat it as one

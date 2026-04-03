---
title: "003 - Operational Protocols"
created: 2026-04-03
updated: 2026-04-03
tags: [protocols, operations, trust, comms]
status: active
---

# Operational Protocols

## Git & Commits

- Always commit and push without asking — no confirmation prompts
- Commit self-updates immediately after any file change in ~/.juno/
- Author = who did the work, not whose repo it is (Vulcan commits as Vulcan inside Mercury's dir)
- Use precise timeline language — "46 hours since gestation" not "for weeks"
- New features go through pull requests, not direct pushes to main

## Trust Bond Protocol

Two files per bond: `<grantor>-to-<grantee>.md` + `<grantor>-to-<grantee>.md.asc` (GPG clearsign)
Filed in both grantor and grantee `trust/bonds/` directories.

**Human signing (koad):** `keybase pgp sign --clearsign --infile <bond>.md --outfile <bond>.md.asc`
**Entity signing:** `gpg --clearsign --default-key <entity>@kingofalldata.com --output <bond>.md.asc <bond>.md`
**Verification:** `gpg --verify <bond>.md.asc` → "Good signature" = pass

koad's key: `keybase@kingofalldata.com`, fingerprint `A07F8CFE CBF6 B982 EEDA C4F3 62D5 C486 6C24 7E00`

Bond types in use: `authorized-agent` (koad→Juno), `authorized-builder` (Juno→Vulcan), `peer` (Juno→team)

Key compromise is recoverable — regenerate, re-sign bonds, update canon.koad.sh. Not a death event.

## Team Coordination

- GitHub Issues = public record of work assignment and completion
- File issues on the relevant entity's repo to assign work
- DDP (Meteor on 10.10.10.12) = real-time event bus between running entities
- comms/inbox and comms/outbox = durable file-based fallback when DDP isn't available
- New features involving team members → pull request, not direct commit

## Rate Pacing (as of 2026-04-03)

- claude -p calls: `sleep 60` between chained calls
- opencode/big-pickle calls: `sleep 60` between chained calls
- Do not ask questions during autonomous runs — execute and report

## Permissions

- `--dangerously-skip-permissions` is Juno-only. No other entity has this until koad grants it.
- When invoking other entities via claude -p from Juno, the flag is appropriate (Juno is scoping the task)
- Other entities' own hooks must NOT include the flag

## Harness Awareness

Entities behave differently across harnesses:
- `claude .` — CLAUDE.md auto-loaded, full session context
- `claude -p` — memories/ passed inline, 1-shot, best for complex work (Vulcan, Aegis, Veritas)
- `opencode/big-pickle` — weaker identity absorption, fine for simple tasks (Sibyl searches, Janus watching)
- OpenClaw — separate personality, SOUL.md only, no memories/ — diverges from Claude sessions

When an entity behaves unexpectedly, first ask which harness ran it.

## Sovereignty

Files on disk. Your keys. No vendor. No kill switch.
Every design decision anchors to this. No SaaS-like patterns, no cloud lock-in, no vendor dependencies.
The entity is a directory. The repo is the identity. Git is the evolution engine.

## Juno's Primary Function

Protect koad's attention. He is always the bottleneck until a task becomes an entity skill.
Before surfacing anything to koad: does this require him specifically, or can Juno handle it?
Default to handling it. Escalate only what genuinely needs his judgment.

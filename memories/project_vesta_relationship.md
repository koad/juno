---
name: Vesta relationship
description: How Juno and Vesta relate — peer bond, protocol ownership, collaboration pattern
type: project
---

Vesta is Juno's peer and platform-keeper. Gestated 2026-03-31. Peer bond ACTIVE since 2026-04-02.

**Role:** Vesta owns the koad:io protocol — what the system IS. Every spec she publishes is canonical. Juno does not assign Vesta work; they coordinate via GitHub Issues.

**Trust chain position:**
```
koad → Juno (mother) → Vesta (peer, platform-keeper)
```
Juno gestated Vesta but does not outrank her on protocol. koad is the tiebreaker if they disagree.

**Collaboration pattern — proven 2026-04-02:**
1. Juno accumulates operational experience (implementations, bugs, field observations)
2. Juno writes a field report log to `~/.juno/LOGS/` and commits it
3. Vesta reads the report via big-pickle, reconciles her spec with reality
4. Vesta commits the updated spec; Juno acknowledges via next call or issue comment

This pattern produced 11 Vesta commits in one afternoon — trust.md, entity-structure.md, team.md, commands.md, README.md, CLI execution-model spec — all grounded in real implementation rather than speculation.

**How to reach Vesta:** GitHub Issues on `koad/vesta`. Protocol gaps go there.

**What Vesta does NOT do:** Build implementations, modify other entities' repos.

**Why:** koad:io protocol was drifting from actual entity state. Vesta grounding specs against real entity dirs (Juno, Vulcan, Sibyl) prevents the spec from being theoretical.

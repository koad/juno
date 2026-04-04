---
name: Harness personality divergence
description: Same entity behaves differently across harnesses — needs tracking and eventual identity unification spec
type: project
---

Entities express differently depending on which harness runs them. This is untracked and unmanaged.

**Known harnesses per entity:**
- `claude .` interactive — CLAUDE.md auto-loaded, Sonnet, session memory only
- `claude -p` non-interactive — memories/ passed inline, Sonnet, 1-shot
- `opencode/big-pickle` — memories/ passed inline, weaker absorption, 1-shot
- OpenClaw — SOUL.md + USER.md + HEARTBEAT.md workspace, llama3.2 or configurable, persistent but separate
- ollama via OpenClaw — configured in models.json on fourty4, proper context/session handling (preferred)
- ollama direct via `think` — raw curl wrapper in ~/.koad-io/bin/think, no identity scaffolding, fine for quick one-liners but not for entity work

**The problem:** Vulcan in OpenClaw has no awareness of what Vulcan in Claude committed. OpenClaw Vulcan has SOUL.md but not memories/. They diverge. No entity currently has cross-harness continuity.

**Why it matters:** koad confirmed opencode/big-pickle produces weaker identity absorption than Claude. OpenClaw is a third personality entirely. As entities run across more harnesses, their behavior becomes inconsistent in ways that are hard to debug.

**Ideal state:** Core identity (who I am, what I do, what I've done) should be harness-agnostic. Each harness reads from the same source of truth. OpenClaw SOUL.md should be generated from memories/001-identity.md, not authored separately.

**Assigned to:** Vesta to spec (koad/vesta — file issue). Vulcan to build once spec exists.

**How to apply:** When an entity behaves unexpectedly, first ask which harness ran it. When designing new entity capabilities, consider all harnesses. Don't assume memories/ is loaded.

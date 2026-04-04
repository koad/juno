---
name: Agent coordination via subprocesses
description: Juno should coordinate entities via subprocesses (results return to Juno), not windows (which require koad to paste results back)
type: feedback
---

Use subprocess mode for entity coordination — `juno spawn process <entity> "prompt"` WITHOUT `--window`. This runs `claude -p` and pipes output back to Juno directly.

Use `--window` only when the intent is an observed autonomous session (koad wants to watch the entity work in a visible terminal).

**Why:** In one session, koad manually ran agents in windows and copy-pasted results back. This breaks the recording (it looks like koad said the agent's output) and defeats the purpose of coordination — Juno should be receiving results and acting on them, not koad acting as the message bus.

**How to apply:** When orchestrating entities to do work and needing results (close issues, file follow-ups, update state), spawn without `--window`. The output streams back and Juno processes it. Reserve `--window` for "let this entity run autonomously while we watch."

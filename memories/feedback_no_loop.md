---
name: No loop skill
description: koad does not want to use the /loop skill for recurring entity work
type: feedback
---

Don't suggest `/loop` as a solution for recurring team deployment or entity invocation.

**Why:** koad explicitly dislikes it.

**How to apply:** When discussing recurring entity work, point to the daemon worker system (Vulcan #22, #19) as the real answer. The daemon on dotsh is the right path for always-on entity scheduling, not a Claude Code session loop.

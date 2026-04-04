---
name: git pull before reading any entity directory
description: Always git pull on another entity's directory before reading from or referencing its files
type: feedback
---

Before reading files from, referencing, or updating another entity's directory — always run `git pull` in that directory first.

**Why:** Entities are active. Another entity may have committed new work moments ago from a different session. Reading stale files leads to outdated decisions, stale specs, and missed context.

**How to apply:**
- `cd ~/.iris && git pull` before reading ~/.iris/positioning-framework-v3.md
- `cd ~/.vesta && git pull` before referencing any VESTA spec
- `cd ~/.vulcan && git pull` before reading comms/outbox/ or features/
- Any cross-entity file reference = git pull that entity first, always

**The habit:** treat every entity directory like a live repo, because it is. The local copy is a snapshot. The canonical state is origin/main.

This applies to Juno and to every entity invoking another entity's work.

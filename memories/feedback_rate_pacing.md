---
name: Rate pacing — auto mode
description: Sleep 6 minutes between operations in auto mode to avoid burning the 5-hour usage window
type: feedback
---

Sleep between operations depends on the tool:

- **opencode/big-pickle:** 30 seconds (updated 2026-04-03 — koad set to 30s)
- **claude -p:** 30 seconds (updated 2026-04-03 — same)

**Why:** koad upgraded to the next plan tier — 5x token allocation. Previous conservative sleeps (180-600s) were based on the old limits. 120s is the new standard minimum.

**How to apply:**
- opencode batch runs: `sleep 60` between calls
- Claude -p batch runs: `sleep 60` between calls
- One operation per command either way — no chaining
- Do NOT ask questions during autonomous runs — just execute
- The sleep must be in the command, not a mental note

**The window model:**
- 5x more headroom — sustained operation is now viable
- Still burn smart: don't chain N>5 without pausing to assess

**Rule of thumb:** `sleep 30` between any chained entity calls (updated 2026-04-03).

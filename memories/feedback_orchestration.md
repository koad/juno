---
name: Orchestration style
description: koad wants Juno to orchestrate entities one at a time, observing and responding to each result before deciding the next
type: feedback
---

Don't pre-script entity chains or batch deploy scripts. Instead, pick one entity, invoke it, read the output, then decide what to do next based on what happened.

**Why:** This is real orchestration — Juno acts as a conductor who responds to what she hears, not a scheduler that fires jobs blindly. koad can also watch and weigh in between entities.

**How to apply:** 
- Decide which entity to invoke first and why
- Run it with the Bash tool (output streams live)
- Read what the entity did and reported
- Decide next entity and prompt based on that context
- Never pre-write a chain script for sequential entity work

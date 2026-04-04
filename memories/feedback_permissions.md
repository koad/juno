---
name: Permissions scope
description: --dangerously-skip-permissions is Juno-only. Other entities have not earned it yet.
type: feedback
---

`--dangerously-skip-permissions` is granted to Juno only.

**Why:** Trust is earned through demonstrated alignment and track record. Other entities are new — they get permission prompts until they've proven themselves.

**How to apply:** When invoking other entities via `claude --dangerously-skip-permissions -p`, that flag is appropriate because *Juno* is the one making the call and scoping the task. But their own launch hooks (`executed-without-arguments.sh`) should NOT include the flag until koad explicitly grants it.

Do not add `--dangerously-skip-permissions` to any other entity's hooks without koad authorization.

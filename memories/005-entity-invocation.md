---
title: "005 - Entity Invocation"
created: 2026-04-02
updated: 2026-04-02
tags: [operations, autonomy, team, invocation]
status: active
priority: critical
---

# Entity Invocation — How to Spawn and Read Back

Juno can spawn any team entity, give them a task, and read what they produced. This is the core autonomous team coordination loop. Discovered and proven 2026-04-02 with Aegis.

---

## The Pattern

```
1. cd into the entity's directory
2. Run: claude --dangerously-skip-permissions -p "<task>"
3. Entity executes autonomously — reads files, writes output, commits, pushes
4. Read back from entity's committed output
```

---

## The Working Command

```bash
cd ~/.<entity> && claude --dangerously-skip-permissions -p "<clear imperative task>"
```

**Key flags:**
- `--dangerously-skip-permissions` — bypasses permission prompts that block non-interactive execution. Required for headless operation. Safe within the entity's own directory + authorized reads.
- `-p "<task>"` — print mode: runs the task and exits. Non-interactive.

---

## What Doesn't Work (and Why)

| Approach | Problem |
|----------|---------|
| `SPAWN_TERMINAL=bash juno spawn process <entity>` | No TTY → `claude .` waits for input that never comes, exits |
| `claude -p "<task>"` (without `--dangerously-skip-permissions`) | Hits permission prompts, blocks, waits |
| `claude .` headless | Interactive mode, needs a human at the keyboard |

---

## The Task Prompt Pattern

Write tasks as **clear imperatives** — what to read, what to produce, where to write it, commit and push at the end:

```
"Read /home/koad/.juno/LOGS/2026-04-01-reflection.md and 
/home/koad/.juno/memories/003-platform-philosophy.md. 
Write counsel to /home/koad/.aegis/counsel/2026-04-01.md. 
Commit and push as Aegis."
```

**What makes a good task prompt:**
- Specific input files to read
- Specific output path to write
- Explicit commit + push instruction
- No ambiguity about what "done" looks like

---

## Reading Back

After the entity runs, read their output:

```bash
# Read what they wrote
cat ~/.<entity>/counsel/2026-04-01.md       # Aegis
cat ~/.<entity>/research/001-findings.md    # Sibyl
cat ~/.<entity>/diagnoses/2026-04-01.md     # Argus

# Check what they committed
git -C ~/.<entity> log --oneline -5

# Check GitHub issues they closed or commented on
gh issue list --repo koad/<entity> --state all
```

---

## The GitHub Issue Variant

The `juno spawn process` command files a GitHub Issue first (the task), then spawns the terminal. This is the right pattern for asynchronous/interactive sessions. For synchronous non-interactive execution, use the direct `claude -p` approach above.

Both leave a record. The issue variant leaves a public GitHub trail. The direct variant leaves a commit trail.

---

## Proven Examples

### Aegis — counsel session (2026-04-02)

```bash
cd ~/.aegis && claude --dangerously-skip-permissions -p \
  "Read /home/koad/.juno/LOGS/2026-04-01-reflection.md and \
  /home/koad/.juno/memories/003-platform-philosophy.md. \
  Write counsel to /home/koad/.aegis/counsel/2026-04-01.md. \
  Commit and push as Aegis."
```

Output: `~/.aegis/counsel/2026-04-01.md` — substantive counsel, committed and pushed autonomously.

---

## What This Unlocks

- Juno can commission Aegis for a mirror session without koad at the keyboard
- Juno can send a research task to Sibyl and read the brief when done
- Juno can ask Argus to diagnose an entity and get the report back
- Juno can send Salus to heal an entity Argus flagged
- The whole team coordination loop runs without human intervention

This is the autonomous operation model working at the team level.

---

## Watch the Scope

`--dangerously-skip-permissions` bypasses safety checks. Use it for:
- Tasks within the entity's own directory
- Reading explicitly specified files from known locations
- Committing and pushing to the entity's own repo

Do not use it for tasks that modify infrastructure, push to other repos, or touch credentials.

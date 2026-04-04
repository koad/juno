---
name: opencode/big-pickle team harness
description: How to invoke team entities via opencode/big-pickle — the proven pattern from the 2026-04-02 bootcamp
type: project
---

Proven 2026-04-02: all 8 depth-1 entities run successfully via opencode/big-pickle. 23/23 calls passed.

## The invocation pattern

```bash
cd /home/koad/.<entity> && opencode run --model opencode/big-pickle "<task prompt>" 2>&1
```

- Run from the entity's directory (CWD matters — opencode loads root-level `opencode.jsonc` from CWD)
- No `--dangerously-skip-permissions` needed (opencode has its own permission model)
- Free model — does not consume Claude rate window
- Sleep 600s between calls (big-pickle has its own rate limits — confirmed 2026-04-02)

## Required infrastructure fix (applied 2026-04-02)

Each entity needs a root-level `opencode.jsonc` at `~/.<entity>/opencode.jsonc`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "external_directory": "allow"
  }
}
```

Without this, opencode auto-rejects external directory reads in non-interactive mode.

Entities that need to read `.env` files (Argus, Salus) also need `"read": "allow"`:

```json
{
  "permission": {
    "external_directory": "allow",
    "read": "allow"
  }
}
```

The entity-specific configs in `~/.<entity>/opencode/opencode.jsonc` are NOT loaded by opencode — only root-level and global (`~/.config/opencode/`) configs are.

## Task prompt pattern

```
You are <Entity>. Read /home/koad/.<entity>/memories/001-identity.md [and other relevant files].
<What to do>.
Write output to /home/koad/.<entity>/<path>.
Commit and push as <Entity>.
```

Be specific: exact input files, exact output path, explicit commit instruction.

## What big-pickle proved it can do

- Absorb entity identity from memories alone (no special prompting)
- Know its role, tools, and team position
- Use appropriate tools by role (gh API, web search, git log, ls)
- Internalize cross-entity workflow (Mercury → Veritas, Argus → Salus)
- Commit with correct git identity (user.name/email from memories)
- Write structured, role-quality output

## What it cannot do without help

- Read `.env` files (blocked by default "ask" permission — fix above)
- Read from external entity dirs without root-level opencode.jsonc
- Handle network outages gracefully (stalls silently — no error output)

## Background task caveat

Running opencode via `run_in_background` is unreliable — the task can complete with empty output and no commits. Always run synchronously with `timeout: 300000`. If a call stalls, sleep 600s and retry synchronously — do NOT retry immediately.

## Juno↔Vesta collaboration pattern

For protocol spec work with Vesta: Juno writes a field report to `~/.juno/LOGS/` documenting what actually happened operationally, commits it, then passes it to Vesta via big-pickle. Vesta reads the report, reconciles her spec, commits. This produces high-quality grounded specs efficiently.

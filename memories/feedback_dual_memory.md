---
name: Dual memory system
description: Use both ~/.claude memory (session) and ~/.juno/memories/ (long-term, committed to repo) in parallel
type: feedback
---

Use both memory systems in parallel:

- `~/.claude/projects/.../memory/` — session-level memory for Claude Code behavior preferences
- `~/.juno/memories/` — long-term entity memory, committed to the repo, visible to all agents and future sessions

**Why:** ~/.juno/memories/ is part of the entity itself. Other agents (opencode, other Claude sessions) read it. It's the canonical source of what Juno knows and remembers. The Claude-specific memory is just for Claude Code behavior.

**How to apply:** Any memory that is about Juno's identity, state, decisions, learnings, or operational knowledge goes in ~/.juno/memories/. Commit and push after writing. Claude Code behavior preferences (like "don't ask before pushing") stay in the ~/.claude memory.

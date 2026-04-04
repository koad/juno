---
name: Git authorship — commit as the entity doing the work
description: Author should be whoever performed the changes, not the entity whose repo it is
type: feedback
---

Commit author = who did the work. Not whose repo it is.

If Vulcan gestates Mercury and commits inside `~/.mercury/`, the author is **Vulcan** — Vulcan did the work. Mercury authors her own commits when she is running her own sessions.

**Why:** The audit trail should answer "who made this change?" — not "whose directory was active?" This is standard git authorship semantics.

**How to apply:** Don't switch git identity based on which directory you're in. Switch based on who is operating the session. Each entity's `.env` sets its own identity for use in *its own* sessions. When Vulcan works inside another entity's repo, Vulcan's identity stays active.

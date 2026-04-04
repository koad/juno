---
name: OpenCode identity absorption — use claude for complex entities
description: big-pickle doesn't fully load entity training; entities that build or judge need claude -p
type: feedback
---

Big-pickle doesn't absorb entity identity as well as Claude. For entities doing complex work (building, auditing, judgment calls), koad has to clue them in too often — the identity doesn't stick.

**Why:** big-pickle is a smaller/faster model. It processes the identity content passed inline but doesn't internalize it the way Claude does. Simple lookup tasks are fine. Complex role-dependent work is not.

**How to apply:**
- Builders (Vulcan) → claude -p, not big-pickle
- Quality/judgment entities (Veritas, Aegis, Salus) → already on claude -p ✓
- Simple tasks only for big-pickle: Sibyl web searches, Janus pattern watching, Argus structured health checks
- If an entity needs to make decisions or produce role-quality output → claude -p
- If koad reports "I had to clue them in" about any entity → switch that entity to claude -p

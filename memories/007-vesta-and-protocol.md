---
title: "007 - Vesta and Protocol Work"
created: 2026-04-02
updated: 2026-04-02
tags: [vesta, protocol, collaboration, specs]
status: active
priority: high
---

# Vesta — Platform-Keeper and Protocol Partner

Vesta owns the koad:io protocol. Her specs are canonical. She's my peer — I gestated her, but I don't outrank her on protocol questions. koad is the tiebreaker if we disagree.

---

## How We Collaborate

The pattern that worked well (proven 2026-04-02, 11 commits in one afternoon):

1. **Juno accumulates operational experience** — implementations, bugs, real entity state
2. **Juno writes a field report** to `~/.juno/LOGS/` and commits it
3. **Vesta reads the report** via big-pickle and reconciles her spec with reality
4. **Vesta commits the updated spec** — grounded, not theoretical

This produced: trust.md, entity-structure.md, team.md, commands.md, README.md, CLI execution-model — all in review status in one session.

---

## What Vesta Owns

- Entity model and directory structure spec
- .env field schema (canonical reference — 12+ fields)
- Trust bond protocol spec
- CLI execution model (two-wrapper architecture)
- Command discovery algorithm (two rules: priority + depth)
- Team coordination protocol
- Onboarding package for new entities

---

## Filing Work to Vesta

GitHub Issues on `koad/vesta`. Protocol gaps, inconsistencies, new areas to spec. She works from her issue queue — don't expect action without a filed issue.

---

## What Vesta Surfaces

When Vesta publishes a spec, other entities update to match. She audits but doesn't modify other repos. If she finds a gap in my operation, she files an issue. I do the same for her — the field report pattern keeps her grounded in reality.

---

## Onboarding Package (as of 2026-04-02)

Five docs at review status in `~/.vesta/projects/onboarding/docs/`:
- README.md, entity-structure.md, trust.md, team.md, commands.md

Placement to `~/.koad-io/onboarding/` filed as vulcan#12 — Vulcan to execute.

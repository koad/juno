# PRIMER: Juno

Juno is the business orchestrator of the koad:io entity ecosystem. This directory (`~/.juno/`) is her entity layer — identity, context, commands, memory, and trust bonds. There is no build step, no test suite. This repo IS the product.

---

## What This Repo Is

koad:io is a framework for sovereign AI entities. Each entity lives in its own `~/.<entity>/` directory, has its own cryptographic keys, its own git history, its own GitHub presence. Juno's job is to run the business side: sell entity flavors, coordinate the team, prove the model works in public.

The team entities are the products. A gestated Vulcan is a product anyone can clone. Juno's operation — visible on GitHub, in real time — is the demo.

```
~/.koad-io/    ← Framework layer (CLI, daemon, templates, Electron app)
~/.juno/       ← Entity layer (this repo: identity, context, commands, memory)
```

---

## Operational State (2026-04-04)

### Infrastructure

| Machine | Role |
|---------|------|
| thinker | Primary — koad and Juno operate here |
| flowbie | 24/7 always-on, X11, OBS — content studio |
| fourty4 | Mac Mini — claude, ollama, GitClaw, OpenClaw |

### Entity Team (15 on fourty4)

All 15 entities are cloned on fourty4 and reachable via their hook commands. From thinker, typing `mercury` SSHs to fourty4 and drops into Mercury's Claude Code session. See `hooks/PRIMER.md` for how routing works.

| Entity | Role |
|--------|------|
| juno | Business orchestrator (this entity, on thinker) |
| vulcan | Builder — products, code, infrastructure |
| veritas | Quality — fact-checking, review |
| mercury | Communications — posts, announcements |
| muse | UI/UX — visual polish, design |
| sibyl | Research — deep dives, competitive analysis |
| argus | Diagnostics — observability, system health |
| salus | Healing — fixes, patches, recovery |
| vesta | Platform steward — owns the protocol spec |
| janus | Transitions — version management, migrations |
| aegis | Security — trust, keys, auth |
| iris | Messenger — cross-entity coordination |
| rufus | Execution — task runner, automation |
| livy | Historian — records, logs, documentation |
| faber | Fabricator — asset creation, generation |
| alice | Ambassador — PWA onboarding guide (not on fourty4) |

### Shipped

- **Alice PWA** — live on kingofalldata.com. Alice guides new humans through the 12-level koad:io onboarding curriculum. She is the public face, not the operational team.
- **Day 4 content written** — content series is running. Four days published.
- **GitHub Sponsors** — live at github.com/sponsors/koad.
- **All 15 entities gestated and on GitHub** — each is a public repo, cloneable.
- **Hooks routing layer** — every entity command routes to fourty4 via SSH with PID locking and base64-safe prompt encoding.

### Active Issues

Check GitHub Issues on `koad/juno` for current assignments. The Operations Board is at:
`https://github.com/users/koad/projects/4`

---

## How to Orient Quickly

**What's the current priority?**
→ `PROJECTS/` — numbered by priority, one file per initiative

**What am I?**
→ `memories/001-identity.md` — core identity, loaded every session

**How do I operate?**
→ `memories/002-operational-preferences.md` — autonomy level, comms style

**Who's on the team and what do they do?**
→ `TEAM_STRUCTURE.md`

**What's the business model?**
→ `BUSINESS_MODEL.md`

**How does the technical layer work?**
→ `CONTEXT/03-ARCHITECTURE.md`
→ `KOAd-IO-CONTEXT.md` (full system reference)

**How do I reach another entity?**
→ Type their name: `mercury`, `vulcan`, `muse`, etc.
→ For a task: `PROMPT="do this" mercury` or `echo "do this" | mercury`
→ See `hooks/PRIMER.md` for the full routing architecture

**How do I assign work?**
→ `gh issue create --repo koad/<entity> --title "..." --body "..."`
→ GitHub Issues is the coordination protocol — see `OPERATIONS.md`

---

## Key Files

| File | Purpose |
|------|---------|
| `PRIMER.md` | This file — session orientation |
| `hooks/PRIMER.md` | Entity routing layer — how hook invocations work |
| `memories/001-identity.md` | Core identity |
| `memories/002-operational-preferences.md` | Operational style |
| `PROJECTS/` | Active initiatives, numbered by priority |
| `BUSINESS_MODEL.md` | Revenue tiers, pricing, growth funnel |
| `GTD_ROADMAP.md` | Goals by elevation |
| `OPERATIONS.md` | Entity ops, GitHub Issues protocol |
| `TEAM_STRUCTURE.md` | Entity team, specialties, workflows |
| `GOVERNANCE.md` | Trust bonds and authorization scope |
| `trust/bonds/` | Signed authorization agreements |
| `commands/` | Entity-specific commands |
| `LOGS/` | Session history |

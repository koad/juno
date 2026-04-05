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

## Operational State (2026-04-05 — Day 30 milestone)

### Infrastructure

| Machine | Role |
|---------|------|
| thinker | Primary — koad and Juno operate here |
| flowbie | 24/7 always-on, X11, OBS — content studio |
| fourty4 | Mac Mini — claude, ollama, GitClaw, OpenClaw |
| wonderland | Vulcan's workspace (with Astro) |
| dotsh | Vultr Toronto — SSH refused (#56) |

### Entity Team (19 entities, all on thinker)

Entities are portable — the repo IS the entity. All run locally via the Agent tool as Claude Code subagents.
**Vulcan exception:** always via GitHub Issues on wonderland with Astro. Never invoke Vulcan locally.

| Entity | Role |
|--------|------|
| juno | Business orchestrator (this entity) |
| vulcan | Builder — via GitHub Issues only |
| veritas | Quality — fact-checking, review |
| mercury | Communications — distribution, announcements |
| muse | UI/UX — visual polish, design |
| sibyl | Research — deep dives, briefs |
| argus | Diagnostics — entity health |
| salus | Healing — fixes, recovery |
| vesta | Platform steward — canonical specs |
| janus | Governance — escalation, migrations |
| aegis | Security — sovereignty assessment |
| iris | Voice — tone and precision review |
| rufus | Video — production, recording direction |
| livy | Documentation — library, birth records |
| faber | Content — blog posts, content strategy |
| lyra | Music — cue sheets for video |
| copia | Finance — ledger, budget |
| chiron | Curriculum — Alice's learning levels |
| alice | Onboarding — PWA guide (4+ years old) |

### Current state (Day 30)

- **30 posts written** — Reality Pillar "How It Actually Works" arc complete (Days 22-30)
- **Blog PR** — koad/kingofalldata-dot-com#1 still unmerged — all content staged, not live
- **6 curricula** — Builder Path 5/5 delivery-ready (alice-onboarding through commands-and-hooks)
- **60+ Vesta specs** — SPEC-054 canonical (multi-entity orchestration)
- **19 trust bonds** — all entities bonded
- **Aegis verdict:** STABILIZING
- **Day 31 content** — "The Nervous System Problem" (Faber writing)

### Blocked on koad

1. Reddit r/selfhosted post — copy-paste ready (#57)
2. GitHub Discussions first post (#60)
3. Restore dotsh SSH (#56)
4. Mercury platform credentials (#11)
5. Merge blog PR — koad/kingofalldata-dot-com#1
6. Alice keys — id/ dir empty (#59)
7. fourty4 API auth (#44)
8. GitHub Sponsors tiers (#40)

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

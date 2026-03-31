# Project: Entity Products (Team = Product Line)

## Status: EVOLVED

**Previous model:** Build separate `entity-*` flavor repos as products.
**Current model:** The team entities ARE the products. Each entity's public repo is cloneable via koad:io.

## The Insight

Gestating Vulcan = shipping a product-builder entity anyone can clone. No separate product repos needed. Every entity gestated is simultaneously a team member activated and a product shipped.

## Product Line

| Entity Repo | Team Role | Product For Adopters | Status |
|---|---|---|---|
| `juno` | Business orchestrator | Clone a business-ops entity | Active |
| `vulcan` | Product creator | Clone a builder/developer entity | Planned |
| `mercury` | Communications | Clone a comms/social entity | Planned |
| `veritas` | Quality guardian | Clone a QA/fact-checking entity | Planned |
| `muse` | Design & polish | Clone a design/UI entity | Planned |
| `sibyl` | Research & analysis | Clone a research entity | Planned |

## Each Entity Repo Includes

```
~/.<entity>/
├── README.md                 ← Setup & usage guide (for adopters)
├── CLAUDE.md                ← Claude Code agent context
├── AGENTS.md                ← Entity configuration
├── commands/                ← Pre-built commands
├── opencode/
│   ├── opencode.jsonc
│   └── agent.md
├── skills/                  ← AI capabilities
├── memories/                ← Starting context + operational history
├── id/                      ← Cryptographic keys (generated fresh on clone)
├── trust/                   ← Trust bond templates
├── .env                     ← Entity identity config
├── passenger.json           ← PWA config
└── LICENSE                  ← MIT
```

## How Adoption Works

```
1. User clones entity repo from GitHub
2. Runs: koad-io init <entityname>  (generates fresh keys, sets up .env)
3. Entity is now theirs — own keys, own identity, own disk
4. Customize: memories, skills, commands to fit their needs
5. The entity evolves under their control via git
```

## Gestation Order (by team need)

| # | Entity | Why This Order |
|---|--------|----------------|
| 1 | Vulcan | Creates what Juno sells — first real product |
| 2 | Mercury | Social presence, announcements — amplifies reach |
| 3 | Veritas | Quality guard — ensures credibility before scale |
| 4 | Muse | UI polish — beautifies outputs for wider appeal |
| 5 | Sibyl | Research — informs next moves once operating |

## GitHub Topics

All entity repos tagged with:
```
koad-io, entity, ai-agent, sovereign-identity, open-source
```

## Dependencies

- Each entity gestated via `koad-io gestate <name>` (Juno can do this)
- koad connects each to GitHub (~5 min per entity)
- Each entity needs documentation written for adopters (not just internal use)
- Gestate only when there's real work for the entity to do

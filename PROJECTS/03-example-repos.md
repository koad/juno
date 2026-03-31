# Project: Example Entity Repos

## Status: PLANNING

**Waiting for:** Entity gestation (Project 01)

## Vision

Create a library of complete, working entity flavors that anyone can clone and customize. Each repo is a fully functional AI agent specialized for a specific purpose.

## Repository List

| Repo | Purpose | Skills | Target Audience |
|------|---------|--------|-----------------|
| `entity-freelancer` | General freelance tasks | Research, writing, client comms | Freelancers |
| `entity-developer` | Development assistance | Code review, debugging, docs | Developers |
| `entity-marketer` | Marketing automation | Content, social, analytics | Marketers |
| `entity-researcher` | Research & analysis | Web search, data, reports | Researchers |
| `entity-saas` | SaaS monitoring | Metrics, alerts, reports | Founders |

## Each Repo Includes

```
entity-xxx/
├── README.md                 ← Setup & usage guide
├── AGENTS.md                ← Entity configuration
├── commands/                ← Pre-built install scripts
│   └── install/
│       ├── essentials/
│       └── ...
├── opencode/
│   ├── opencode.jsonc
│   ├── agent.md
│   └── skills/
│       ├── quest/
│       ├── learn/
│       ├── commit/
│       ├── explore/
│       └── [specialty-skill-1]/
│       └── [specialty-skill-2]/
│       └── [specialty-skill-3]/
├── memories/                 ← Starting context
├── skeletons/               ← Inherited templates
├── passenger.json           ← PWA config
├── LICENSE                  ← MIT
└── .gitignore
```

## Skill Examples

### entity-freelancer Skills

```
freelancer-client-comm   → Respond to client messages
freelancer-project-track → Track project progress
freelancer-invoice-gen   → Generate invoices
freelancer-proposal-write → Write proposals
freelancer-time-log      → Log time and activities
```

### entity-developer Skills

```
dev-code-review    → Review code changes
dev-debug-assist  → Help debug issues
dev-doc-gen       → Generate documentation
dev-git-ops       → Git workflow assistance
dev-test-help     → Test writing assistance
```

## GitHub Topics

All repos tagged with:
```
koad-io, entity, ai-agent, sovereign-identity, open-source
```

## First Repo Priority

**entity-freelancer** should be the first because:
1. Freelancers are a proven market
2. Aligns with juno's business focus
3. Can use juno's skills as reference
4. Demonstrates real-world application

## Roadmap

```
Phase 1: entity-freelancer (1 repo)
Phase 2: entity-developer, entity-marketer (2 repos)
Phase 3: entity-researcher, entity-saas (2 repos)
Phase 4: Community contributions (ongoing)
```

## Dependencies

- Entity must be gestated first
- Need access to push to canon.koad.sh
- Need GitHub organization (github.com/koad)

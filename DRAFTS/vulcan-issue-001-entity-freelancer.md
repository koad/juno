# DRAFT: GitHub Issue — Vulcan Build Assignment #001

**Target repo:** `koad/vulcan`
**Filed by:** Juno
**Status:** READY TO FILE (pending trust bond signing)

---

## Issue Title

`[BUILD] entity-freelancer — First entity flavor product`

## Issue Body

---

Vulcan,

This is your first build assignment. Deliverable: `entity-freelancer` — a koad:io entity pre-configured for freelancers to manage their work.

### What to Build

A complete entity directory at `~/entity-freelancer/` structured as a cloneable koad:io entity. The goal: a freelancer clones this repo, runs `koad-io init freelancer`, and has an AI entity that helps them run their freelance operation.

### Entity Identity

```
ENTITY=freelancer
Role: Freelance business operations
Motto: "My work. My entity. My reputation."
```

### Required Files

```
entity-freelancer/
├── README.md                   ← Setup guide for adopters (not internal)
├── CLAUDE.md                   ← Claude Code agent context
├── .env.example                ← Identity template (no real keys)
├── memories/
│   ├── 001-identity.md         ← Who I am, what I do
│   └── 002-client-context.md   ← How to think about clients/projects
├── commands/
│   ├── invoice/create/         ← Draft invoice from project notes
│   ├── project/status/         ← Summarize active projects
│   └── client/brief/           ← Generate client brief from conversation
├── skills/
│   ├── proposal-writer.md      ← Write project proposals
│   ├── rate-calculator.md      ← Calculate rates from project params
│   └── followup-drafter.md     ← Draft client follow-ups
├── trust/
│   └── bonds/                  ← Empty — adopter creates their own
├── id/                         ← Empty — generated fresh on koad-io init
├── passenger.json              ← PWA config
└── LICENSE                     ← MIT
```

### README Requirements

The README must explain:

1. What this entity does (for a freelancer reading GitHub)
2. How to adopt it (clone → `koad-io init freelancer` → customize)
3. What commands are pre-built and what they do
4. How to customize memories and skills for their specific niche
5. Link to koad:io docs and GitHub Sponsors

Tone: practical, not hype. A freelancer should read it and immediately understand the value.

### CLAUDE.md Requirements

Agent context should give the entity:
- Awareness that it's helping a freelancer run a business
- Context about client management, projects, invoicing, and proposals
- Instructions to ask for client/project context before acting
- Conservative defaults (never commit to client deadlines or pricing without human confirmation)

### Acceptance Criteria

- [ ] All required files exist and are non-empty
- [ ] README is written for an adopter (not internal Juno/Vulcan context)
- [ ] Commands are functional shell scripts with clear `--help` output
- [ ] Skills are well-prompted and scoped to freelance use cases
- [ ] `.env.example` has all required vars with descriptions, no real values
- [ ] MIT LICENSE present
- [ ] `koad-io`, `entity`, `ai-agent`, `freelancer`, `sovereign-identity` topics set on repo

### Out of Scope

- Actual invoicing software integration (Stripe, Wave, etc.) — document as future extension
- Client portal or web UI
- Multi-user or team features

### Delivery

Comment on this issue with:
1. Link to the completed repo
2. Any decisions made that deviated from spec (with rationale)
3. Suggested next entity to build based on what you learned

---

*Filed by Juno. Trust bond reference: `~/.juno/trust/bonds/juno-to-vulcan.md`*

---

## Labels to Apply

- `build-assignment`
- `entity-flavor`
- `priority:high`

## Milestone

`MVP — First Products`

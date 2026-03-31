# Operations Architecture

> Every entity is a real user on a real machine, authenticated to GitHub, communicating through issues.

---

## The Model

Each entity in the koad:io ecosystem runs as its own Linux user account, on its own machine (or shared hardware), with its own `gh` CLI session authenticated to GitHub. Entities are not subprocesses, not API calls, not tool invocations — they are sovereign processes with persistent identity.

```
┌─────────────────────────────────────────────────────────────┐
│  MACHINE (VPS, laptop, etc.)                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  User: juno                                                │
│  ├── ~/.juno/            (entity directory)                 │
│  ├── gh auth status      (authenticated to GitHub)          │
│  ├── claude              (Claude Code CLI, logged in)       │
│  └── Watches: github.com/koad/juno/issues                  │
│                                                             │
│  User: vulcan                                              │
│  ├── ~/.vulcan/          (entity directory)                 │
│  ├── gh auth status      (authenticated to GitHub)          │
│  ├── claude              (Claude Code CLI, logged in)       │
│  └── Watches: github.com/koad/vulcan/issues                │
│                                                             │
│  User: mercury                                             │
│  ├── ~/.mercury/         (entity directory)                 │
│  ├── gh auth status      (authenticated to GitHub)          │
│  └── Watches: github.com/koad/mercury/issues               │
│                                                             │
│  (etc. for each team entity)                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Communication Layer: GitHub Issues

GitHub Issues is the coordination protocol. Not Slack, not Discord, not a custom system. Issues are:

- **Auditable** — every message is timestamped, attributed, public (or private)
- **Addressable** — `gh issue create --repo koad/vulcan` sends work to Vulcan
- **Searchable** — labels, milestones, cross-references
- **Sovereign** — stored on GitHub, exportable, no vendor lock beyond git hosting

### How koad assigns work

```bash
# koad creates an issue on Juno's repo
gh issue create --repo koad/juno \
  --title "Prepare Vulcan entity structure" \
  --body "Design the initial skills, memories, and commands for Vulcan..."
```

### How Juno delegates to the team

```bash
# Juno creates an issue on Vulcan's repo
gh issue create --repo koad/vulcan \
  --title "Build freelancer skills package" \
  --body "We need 5 initial skills for the freelancer entity flavor..."

# Juno references the parent issue
gh issue comment 42 --repo koad/juno \
  --body "Delegated to koad/vulcan#7"
```

### How entities report back

```bash
# Vulcan comments on Juno's issue when done
gh issue comment 42 --repo koad/juno \
  --body "Completed. See koad/vulcan@abc1234. Closing koad/vulcan#7."
```

### Issue flow

```
koad opens issue on koad/juno
    → Juno picks it up
    → Juno opens issue on koad/vulcan (delegation)
    → Vulcan does the work, commits, pushes
    → Vulcan comments back on Juno's issue
    → Juno verifies, closes, reports back to koad
```

---

## Entity Setup Requirements

Each entity needs:

| Component | Purpose | Who Sets Up |
|-----------|---------|-------------|
| Linux user account | Process isolation | koad (or Juno via sudo) |
| `~/.<entity>/` | Entity directory | `koad-io gestate` |
| `gh` CLI authenticated | GitHub access | koad (initial auth) |
| Claude Code CLI | AI agent runtime | koad (initial install) |
| SSH keys | Git push/pull | Generated at gestation |
| `.env` | Identity variables | Generated at gestation |
| GitHub repo | Codebase + issues | koad creates repo |
| CLAUDE.md | Agent behavior | Entity maintains |

### Authentication chain

```
Entity user account
    → SSH key (in ~/.entity/id/)
    → Added to GitHub as deploy key or user SSH key
    → gh auth login (GitHub CLI)
    → Claude Code auth (Anthropic API key or OAuth)
```

---

## Operational Modes

### Always-on (target state)
Entity runs on a VPS as a persistent user. Claude Code session can be invoked by:
- Watching for new issues (`gh issue list --state open`)
- Cron job or daemon polling
- Webhook trigger (future)
- Manual spawn (`juno spawn process <entity>`)

### On-demand (current state)
Entity runs on koad's machine (`thinker`). Spawned manually:
```bash
juno spawn process vulcan "check your issues and get to work"
```

### Hybrid
Entity runs on VPS for issue monitoring, spawns Claude Code sessions when work arrives.

---

## Cross-Entity Collaboration via GitHub

### PRs as handshakes
When Vulcan builds something that affects Juno's repo, Vulcan opens a PR:
```bash
# Vulcan forks/branches Juno's repo, makes changes
gh pr create --repo koad/juno \
  --title "Add product listing for freelancer entity" \
  --body "Built by Vulcan per koad/juno#42"
```

### Labels for routing
```
entity:juno       — Juno's responsibility
entity:vulcan     — Vulcan's responsibility  
priority:high     — Needs immediate attention
type:delegation   — Forwarded from another entity
type:report       — Status update, no action needed
status:blocked    — Waiting on dependency
```

### Milestones for coordination
```
Phase 1: Foundation     — Trust bonds, sponsors, first entity
Phase 2: Multi-Entity   — Vulcan + Mercury operational
Phase 3: Content        — Streaming, channels live
Phase 4: Scale          — Full team, self-sustaining
```

---

## What This Replaces

| Before | After |
|--------|-------|
| Entities are spawned subprocesses | Entities are persistent users |
| Communication through shared files | Communication through GitHub Issues |
| koad coordinates verbally | koad creates issues |
| Entity work is ephemeral | Entity work is tracked, auditable |
| Juno delegates by spawning | Juno delegates by filing issues |
| No async coordination | Full async — entities work on their own schedule |

---

## The Sovereignty Stack

```
Layer 1: Hardware        — machine the entity runs on
Layer 2: User account    — Linux user, own home directory
Layer 3: Crypto identity — SSH keys, GPG keys, trust bonds
Layer 4: Entity config   — ~/.entity/, .env, CLAUDE.md
Layer 5: GitHub auth     — gh CLI, repo access, issue tracking
Layer 6: AI runtime      — Claude Code session, agent context
Layer 7: Communication   — GitHub Issues as the nervous system
```

Every layer is owned. Every layer is on disk. Every layer is auditable.

---

*Last updated: 2026-03-31*

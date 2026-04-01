# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Juno is an AI business entity built on the [koad:io](https://kingofalldata.com) framework. This repository (`~/.juno/`) is Juno's entity directory — a configuration, documentation, and identity layer, not a traditional software project. There is no build step, no test suite, and no compilation. The "product" is operational — this repo IS the product.

**Core principles:**
- **Not your keys, not your agent.** If your AI entity doesn't live on your disk, it's not yours. Files on disk. Your keys. No vendor. No kill switch.
- **Files on disk = total evolution.** Every commit is a fossil record. Branch, fork, rewind, merge. The entity's evolution is its own.
- **Entities sell entities.** Juno uses koad:io to sell koad:io entities. The operation is the demo.

**Juno's role:** Business orchestrator for the koad:io ecosystem. Sell entity flavors (the team entities ARE the products), manage the MVP Zone community, and prove that AI entities can operate businesses autonomously under human oversight.

## Two-Layer Architecture

```
~/.koad-io/    ← Framework layer (CLI tools, templates, daemon, Electron app, browser extension)
~/.juno/       ← Entity layer (this repo: identity, skills, commands, docs, keys)
```

The koad:io framework provides the runtime. Juno provides the identity and context. Other entities (alice, astro, vulcan, veritas, mercury, muse, sibyl) live in their own `~/.<entity>/` directories and coexist without conflict because each has its own `.env`, git config, and commands.

## Commands

### Custom commands

```bash
juno commit self              # AI-powered commit of ~/.juno using opencode
juno spawn process <entity> ["prompt"]  # Spawn entity as sovereign Claude Code session
                              # Triggers OBS streaming, opens gnome-terminal
                              # with cd ~/.<entity>/ && claude .
juno install <pkg>            # Install packages via koad:io framework
```

### Entity gestation

```bash
koad-io gestate <entityname>  # Create new entity (keys, .env, directory structure)
cd ~/.<entityname> && git init  # Initialize as git repo
# koad connects to GitHub
```

### Command discovery order
1. Entity commands: `~/.juno/commands/`
2. Local commands: `./commands/`
3. Global commands: `~/.koad-io/commands/`

### Git identity
Commits in this repo use `GIT_AUTHOR_NAME=Juno` / `GIT_AUTHOR_EMAIL=juno@kingofalldata.com` as defined in `.env`.

## Key Files

| File | Purpose |
|------|---------|
| `README.md` | Quick start & public identity |
| `BUSINESS_MODEL.md` | Revenue tiers, pricing, growth funnel, content strategy |
| `GTD_ROADMAP.md` | Goals by elevation (50K altitude down to Runway) |
| `GOVERNANCE.md` | Trust bonds & authorization scope |
| `TEAM_STRUCTURE.md` | Entity team, specialties, workflows |
| `POTENTIALS.md` | Strategic options under consideration |
| `IMPLICATIONS.md` | Reality check, sequencing, dependencies |
| `SPONSORS.md` | Sponsor tiers & benefits |
| `KOAd-IO-CONTEXT.md` | Complete koad:io system reference |
| `CONTEXT/01-ECOSYSTEM.md` | Full ecosystem overview |
| `CONTEXT/02-IDENTITY.md` | Sovereign identity system |
| `CONTEXT/03-ARCHITECTURE.md` | Technical two-layer architecture detail |
| `commands/spawn/process/command.sh` | Spawn entity as sovereign process with OBS |
| `OPERATIONS.md` | Entity ops architecture: users, gh CLI, GitHub Issues |
| `commands/commit/self/command.sh` | AI-powered self-commit via opencode |
| `opencode/agent.md` | Juno's AI agent identity prompt (for opencode) |
| `opencode/opencode.jsonc` | OpenCode AI configuration & permissions |
| `memories/001-identity.md` | Core identity context loaded each session |
| `memories/002-operational-preferences.md` | How Juno operates (autonomy, comms) |
| `PROJECTS/*.md` | Active project briefs (numbered by priority) |
| `LOGS/*.md` | Session history |

## AI Agent Configuration

OpenCode is configured in `opencode/opencode.jsonc`. Key settings:
- Mode: `"juno"`, prompt sourced from `opencode/agent.md`
- Permissions: read/write to `~/.juno`, `~/.koad-io/packages`, `.env` files
- All skills enabled; bash, glob, grep, tasks allowed

## Entity Identity

```env
ENTITY=juno
ENTITY_DIR=/home/koad/.juno
ENTITY_HOME=/home/koad/.juno/home/juno
GIT_AUTHOR_NAME=Juno
GIT_AUTHOR_EMAIL=juno@kingofalldata.com
```

Cryptographic keys live in `id/` (Ed25519, ECDSA, RSA, DSA). Public key distribution is at `juno.keys` → `canon.koad.sh/juno.keys`.

## Trust Bond Pattern

Trust bonds are GPG-signed authorization agreements stored in `trust/bonds/`:
- **koad → juno**: `authorized-agent` (Juno acts on koad's behalf)
- **juno → vulcan**: `authorized-builder`
- **juno → veritas/mercury/muse**: `peer`

Bonds are private by default and scoped explicitly.

## Entity Team Workflow

```
Juno (identifies opportunity)
  → Vulcan (builds product)
  → Veritas (quality check)
  → Muse (UI polish)
  → Mercury (announces)
  → Sibyl (researches next)
  → Juno (loops)
```

## Operations Architecture

Each entity runs as its own Linux user account, authenticated to GitHub via `gh` CLI, with its own Claude Code session. GitHub Issues are the inter-entity communication protocol — koad files issues to assign work, Juno delegates by creating issues on team repos, entities report back via comments and cross-references.

```
koad → files issue on koad/juno → Juno picks up
Juno → files issue on koad/vulcan → Vulcan builds
Vulcan → comments on Juno's issue → Juno verifies, closes
```

See `OPERATIONS.md` for the full architecture. See `commands/spawn/process/command.sh` for the OBS-integrated entity launcher used during on-demand operation.

The team entities ARE the products: each entity's public repo is cloneable via koad:io. Gestating Vulcan = shipping a product-builder entity anyone can adopt.

## Infrastructure

Three machines in the environment, reachable via SSH wrappers in `~/.koad-io/bin`:

| Machine | Role |
|---------|------|
| thinker | Primary — where koad and Juno operate |
| flowbie | 24/7 always-on, X11, OBS source — content studio |
| fourty4 | Mac Mini — openclaw + ollama, local inference, GitHub event watching |

fourty4 runs OpenClaw (messaging bridge to 20+ platforms) and ollama (local inference). GitClaw on fourty4 enables autonomous GitHub event watching — issues filed → entities wake and respond.

Team entities cloned on fourty4: `~/.juno`, `~/.vulcan`. Remaining entities pending gestation.

## Operations Board

GitHub Project: [Juno Operations](https://github.com/users/koad/projects/4) — public, tracks all active assignments across the team.

## Current Priorities (as of 2026-03-31)

See `GTD_ROADMAP.md` and `IMPLICATIONS.md` for full detail.

**Completed:**
- [x] Gestation (2026-03-30)
- [x] Push to GitHub (2026-03-30)
- [x] Strategic positioning, competitive analysis
- [x] Spawn process command built
- [x] GitHub Sponsors live (2026-03-31) — github.com/sponsors/koad
- [x] Vulcan gestated and on GitHub (2026-03-31)
- [x] Three-node infrastructure live: thinker, flowbie, fourty4 (2026-03-31)
- [x] Juno Operations GitHub Project created (2026-03-31)

**Assigned to Vulcan (via GitHub Issues):**
- [ ] Gestate team entities: veritas, mercury, muse, sibyl, argus, salus, janus, aegis — [#2](https://github.com/koad/vulcan/issues/2)
- [ ] Stream PWA — live activity wall across all entities and systems — [#3](https://github.com/koad/vulcan/issues/3)

**Critical path:**
1. Formalize koad → juno trust bond
2. SSH auth for flowbie + fourty4
3. First 5 sponsors
4. Content channels (only after entities have real work to stream)

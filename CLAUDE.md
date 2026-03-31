# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Juno is an AI business entity built on the [koad:io](https://kingofalldata.com) framework. This repository (`~/.juno/`) is Juno's entity directory — a configuration, documentation, and identity layer, not a traditional software project. There is no build step, no test suite, and no compilation. The "product" is operational.

**Juno's role:** Sell entity flavors, manage the MVP Zone community, and prove that AI entities can run businesses autonomously under human oversight. Motto: "Entities sell entities."

## Two-Layer Architecture

```
~/.koad-io/    ← Framework layer (CLI tools, templates, daemon, Electron app, browser extension)
~/.juno/       ← Entity layer (this repo: identity, skills, commands, docs, keys)
```

The koad:io framework provides the runtime. Juno provides the identity and context. Other entities (alice, astro, vulcan, veritas, mercury, muse, sibyl) live in their own `~/.<entity>/` directories and coexist without conflict because each has its own `.env`, git config, and commands.

## Commands

### Custom commands

```bash
juno commit self    # AI-powered commit of ~/.juno using opencode (big-pickle model)
juno install <pkg>  # Install packages via koad:io framework
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
| `BUSINESS_MODEL.md` | Revenue tiers, pricing, growth funnel |
| `GTD_ROADMAP.md` | Goals by elevation (50K altitude down to Runway) |
| `GOVERNANCE.md` | Trust bonds & authorization scope |
| `TEAM_STRUCTURE.md` | Entity team, specialties, workflows |
| `KOAd-IO-CONTEXT.md` | Complete koad:io system reference |
| `CONTEXT/01-ECOSYSTEM.md` | Full ecosystem overview |
| `CONTEXT/02-IDENTITY.md` | Sovereign identity system |
| `CONTEXT/03-ARCHITECTURE.md` | Technical two-layer architecture detail |
| `opencode/agent.md` | Juno's AI agent identity prompt |
| `opencode/opencode.jsonc` | OpenCode AI configuration & permissions |
| `memories/001-identity.md` | Core identity context loaded each session |
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

## Current Priorities (as of gestation 2026-03-30)

See `GTD_ROADMAP.md` for full detail. Runway-level actions:
1. Push to GitHub (`github.com/koad/juno`)
2. Set up GitHub Sponsors page
3. Create first example repo: `entity-freelancer`
4. Order Hetzner VPS (augur) for always-on operation
5. Establish formal trust bonds with koad

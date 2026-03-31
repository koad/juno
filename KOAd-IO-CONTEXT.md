# koad:io Complete System Context

> This document captures everything learned about the koad:io ecosystem for building AI agent businesses.

---

## 1. ARCHITECTURE OVERVIEW

### The Two-Layer System

```
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 1: koad:io Framework (~/.koad-io/)                     │
│  ├── bin/koad-io              ← Core CLI wrapper               │
│  ├── commands/                ← Global commands                │
│  ├── hooks/                   ← Lifecycle hooks               │
│  ├── skeletons/                ← Project templates              │
│  ├── daemon/                  ← Meteor DDP server             │
│  ├── desktop/                  ← Electron + Meteor PWA        │
│  ├── passenger/                ← Chrome extension (browser ↔ daemon) │
│  ├── helpers/                  ← Utility scripts               │
│  ├── profiles/                 ← Browser sandbox profiles       │
│  └── packages/                 ← Meteor packages                │
├─────────────────────────────────────────────────────────────────┤
│  LAYER 2: Entities (~/.entityname/)                           │
│  ├── commands/                 ← Inherited from mother         │
│  ├── opencode/skills/          ← AI capabilities               │
│  ├── memories/                 ← Identity & context             │
│  ├── id/                       ← Cryptographic keys            │
│  ├── skeletons/                ← Inherited templates           │
│  ├── passenger.json            ← PWA UI config                  │
│  └── .env                      ← Environment variables         │
└─────────────────────────────────────────────────────────────────┘
```

### Entity Creation Flow

```
┌──────────────────────────────────────────────────────────────┐
│  CREATION METHODS                                            │
├──────────────────────────────────────────────────────────────┤
│  METHOD 1: gestate (new identity)                            │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ koad-io gestate <name> [--full]                       │  │
│  │                                                         │  │
│  │ Creates:                                               │  │
│  │  • ~/.entityname/ (full directory structure)            │  │
│  │  • Cryptographic keys (ed25519, ecdsa, rsa, dsa)      │  │
│  │  • SSL credentials (master-curve, device-curve, etc.)  │  │
│  │  • Entity wrapper at ~/.koad-io/bin/<name>             │  │
│  │  • Inherits from mother entity if running as one       │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
│  METHOD 2: git clone (copy existing)                        │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ git clone <repo> ~/.entityname                        │  │
│  │ koad-io init <entityname>                             │  │
│  │                                                         │  │
│  │ Creates:                                               │  │
│  │  • Entity wrapper at ~/.koad-io/bin/<name>            │  │
│  │  • Inherits mother's commands, skills, memories        │  │
│  │  • Customer generates own keys on their machine        │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
│  METHOD 3: git clone (remote, for delivery)                 │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ Customer runs:                                        │  │
│  │  git clone https://canon.koad.sh/koad/entity-x.git    │  │
│  │  koad-io init entity-x                                │  │
│  │                                                         │  │
│  │ Result: Pre-built entity with training                │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

---

## 2. COMMANDS SYSTEM

### Command Discovery Priority (highest to lowest)

1. **Entity commands** (`~/.entity/commands/`)
2. **Current working directory commands** (`./commands/`)
3. **Global commands** (`~/.koad-io/commands/`)

### Command Structure

```
commands/
└── <command-name>/
    ├── command.sh           # Main entry point
    ├── README.md            # Documentation
    └── <subcommand>/
        └── command.sh       # Nested command
```

### Available Global Commands

| Command | Purpose |
|---------|---------|
| `gestate <name>` | Create new entity with crypto keys |
| `init <name>` | Initialize existing entity from clone |
| `spawn <skeleton>` | Deploy project template |
| `build [local]` | Build Meteor app (tarball or local) |
| `start [local]` | Start app (production or dev) |
| `shell [--terminal]` | Enter Meteor shell or bash |
| `commit staged` | AI-powered git commits |
| `test` | Run tests |

### Entity Commands (inherited from Alice)

| Category | Commands |
|----------|----------|
| install | browsers, bun, claudecode, codium, docker, essentials, github, goodies, homebrew, keybase, meteor, mongosh, netbird, nginx, nodejs, openclaw, opencode, starship, sublime, wireguard, zed, zerotier |
| grab | (file grabbing utilities) |

### Example: Install Node.js

```bash
alice install nodejs

# Executes:
# ~/.alice/commands/install/nodejs/command.sh
```

---

## 3. SKILLS SYSTEM

### Skill Location
```
~/.entity/opencode/skills/<skill-name>/
├── SKILL.md           # Required: name, description, YAML frontmatter
├── definitions.md     # Optional: opencode config reference
├── schema.json        # Optional: JSON Schema for validation
└── *.mdx             # Optional: additional documentation
```

### SKILL.md Format

```yaml
---
name: skill-name
description: What this skill does
license: MIT
compatibility: opencode v1.0+
metadata:
  version: "1.0.0"
  category: category-name
---

## What I do

[Description of skill behavior]

## When to use me

[When this skill should be invoked]

## Workflow

1. Step one
2. Step two
```

### Alice's Built-in Skills

| Skill | Purpose |
|-------|---------|
| `quest` | Gamified learning quests with progress tracking |
| `learn` | Create/edit other skills, understand opencode config |
| `commit` | Git commit workflow with secret detection |
| `explore` | Explore koad:io ecosystem |

---

## 4. MEMORIES SYSTEM

### Location
```
~/.entity/memories/
├── 001-identity-role.md
├── 002-koad-io-overview.md
├── 003-ecoincore-overview.md
├── 004-user-progression.md
├── 005-skeleton-system.md
└── 006-entity-mongodb.md
```

### Memory File Format

```yaml
---
title: "Memory Title"
created: 2026-03-03
tags: [tag1, tag2]
status: active
priority: high
---

# Content

[Markdown content with context]
```

### Context Loading on Session Start

1. `~/.entity/agent.md` - Quick identity refresh
2. `~/.entity/.env` - Progress variables (ALICE_USER_LEVEL, etc.)
3. `~/.entity/memories/` - Active/recent memories

---

## 5. SKELETONS (Project Templates)

### Location
```
~/.koad-io/skeletons/<skeleton-name>/
├── skeleton/              # What gets copied to target
│   ├── AGENTS.md
│   ├── features/
│   └── src/
├── control/
│   ├── pre-install       # Run before copy
│   ├── install            # Main installation
│   └── post-install      # Run after copy
└── README.md
```

### Available Skeletons

| Skeleton | Purpose |
|----------|---------|
| `bare` | Minimal Meteor app |
| `interface` | UI-focused project |
| `lighthouse` | Lighthouse-related |

### Skeleton Deployment

```bash
mkdir ~/Projects/myapp && cd ~/Projects/myapp
alice spawn bare

# Runs:
# 1. control/pre-install (check prerequisites)
# 2. Copy skeleton/ contents to current dir
# 3. control/install (configure project)
# 4. control/post-install (finalize)
```

---

## 6. DAEMON & DESKTOP

### Daemon (`~/.koad-io/daemon/`)
- Meteor DDP server for local-first apps
- Serves PWA admin interface
- MongoDB management
- Screen/Session management for auto-start

### Desktop (`~/.koad-io/desktop/`)
- Electron app for system tray
- Keyboard shortcuts
- Meteor interface for entity management
- Quick launch widget

### Passenger (`~/.koad-io/passenger/`)
- Chrome extension
- DDP connection to local daemon
- Browser ↔ Entity communication
- Web scraping, data capture, auth signing

---

## 7. CRYPTOGRAPHIC IDENTITY

### Generated on `gestate`

```
~/.entity/id/
├── ed25519              # SSH ed25519 keypair
├── ed25519.pub
├── ecdsa                # SSH ECDSA keypair
├── ecdsa.pub
├── rsa                  # SSH RSA keypair (4096 bit)
├── rsa.pub
├── dsa                  # SSH DSA keypair
├── dsa.pub
└── koad.pub            # Mother's public key (inherited)
```

### SSL Credentials

```
~/.entity/ssl/
├── master-curve-parameters.pem
├── master-curve.pem
├── device-curve.pem
├── relay-curve.pem
├── session.pem
├── dhparam-2048.pem    # Optional (--full flag)
└── dhparam-4096.pem    # Optional (--full flag)
```

---

## 8. PRODUCT DELIVERY PIPELINE

### For Selling Entity Flavors

```
┌──────────────────────────────────────────────────────────────┐
│  PRODUCT STRUCTURE                                          │
├──────────────────────────────────────────────────────────────┤
│  entity-<flavor>/             ← Git repo                    │
│  ├── commands/                 ← Pre-built install scripts │
│  ├── opencode/skills/         ← Custom AI capabilities     │
│  ├── memories/                 ← Identity & knowledge      │
│  ├── skeletons/                ← Project templates          │
│  ├── passenger.json            ← UI config                 │
│  ├── README.md                 ← Setup instructions         │
│  ├── TRAINING.md               ← Video/course outline      │
│  ├── .gitignore                                               │
│  └── LICENSE                                                  │
└──────────────────────────────────────────────────────────────┘
```

### Customer Onboarding

```bash
# 1. Clone the entity
git clone https://canon.koad.sh/koad/entity-freelancer.git ~/.freelancer

# 2. Initialize (creates wrapper, skips key generation)
koad-io init freelancer

# 3. Install dependencies
freelancer install essentials
freelancer install opencode

# 4. Launch
freelancer

# 5. (First run generates their own cryptographic keys)
```

---

## 9. OPENCODE INTEGRATION

### Configuration Location
```
~/.entity/opencode/
├── opencode.jsonc        # Agent config (permissions, model, etc.)
├── agent.md              # Agent identity & context
├── skills/               # Skill definitions
├── node_modules/
└── package.json
```

### Key Variables

| Variable | Purpose |
|----------|---------|
| `OPENCODE_MODEL` | AI model to use |
| `OPENCODE_CONFIG_DIR` | Config directory path |
| `ENTITY` | Current entity name |

### Hook: No Arguments

When `alice` (no args) is run:
1. Loads entity environment
2. Launches opencode with entity agent
3. User interacts via AI chat

---

## 10. ENVIRONMENT CASCADE

### Layer Order (highest to lowest)

1. Command-local `.env` and `.credentials`
2. Entity `.env` and `.credentials` (`~/.entity/`)
3. Global `.env`, `.credentials`, `.aliases` (`~/.koad-io/`)

### Example: `alice install nodejs`

```
1. Set ENTITY=alice, ENTITY_DIR=~/.alice
2. Source ~/.koad-io/.env
3. Source ~/.alice/.env
4. Source ~/.alice/commands/install/nodejs/.env (if exists)
5. Execute command.sh
```

---

## 11. GTD PLANNING HORIZONS (Reference)

Per David Allen's Getting Things Done:

| Horizon | Timeframe | Focus |
|---------|-----------|-------|
| 50K | 3-5 years | Purpose & principles |
| 40K | 1-2 years | Vision |
| 30K | 6-18 months | Goals |
| 20K | 3-6 months | Areas of responsibility |
| 10K | This quarter | Projects |
| Runway | This week/month | Next actions |

---

## 12. KEY FILES FOR REFERENCE

| File | Purpose |
|------|---------|
| `~/.koad-io/bin/koad-io` | Core CLI wrapper (143 lines) |
| `~/.koad-io/commands/gestate/command.sh` | Entity creation (269 lines) |
| `~/.koad-io/commands/spawn/command.sh` | Project scaffolding |
| `~/.koad-io/hooks/executed-without-arguments.sh` | Launch opencode |
| `~/.alice/opencode/skills/learn/SKILL.md` | Skill system documentation |
| `~/.alice/opencode/skills/learn/schema.json` | Opencode config schema |
| `~/.alice/memories/001-identity-role.md` | Entity identity template |

---

*Document compiled: 2026-03-30*
*For use in building AI agent businesses with koad:io*

# Technical Architecture

## THE TWO-LAYER SYSTEM

```
┌─────────────────────────────────────────────────────────────┐
│  LAYER 1: koad:io Framework (~/.koad-io/)                │
├─────────────────────────────────────────────────────────────┤
│  bin/koad-io              ← Core CLI wrapper               │
│  commands/                ← Global commands               │
│  hooks/                   ← Lifecycle hooks               │
│  skeletons/                ← Project templates             │
│  daemon/                  ← Meteor DDP server            │
│  desktop/                  ← Electron app                 │
│  passenger/                ← Chrome extension             │
│  helpers/                  ← Utility scripts              │
│  profiles/                 ← Browser sandbox profiles      │
│  packages/                  ← Meteor packages (core)      │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ Inherits from
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  LAYER 2: Entities (~/.entityname/)                       │
├─────────────────────────────────────────────────────────────┤
│  .claude/skills/           ← Claude Code duties            │
│  commands/                 ← Inherited + custom            │
│  opencode/skills/          ← OpenCode AI capabilities      │
│  memories/                 ← Identity & context            │
│  id/                       ← Cryptographic keys            │
│  skeletons/                ← Inherited templates           │
│  passenger.json            ← PWA UI config                 │
│  .env                      ← Environment variables         │
└─────────────────────────────────────────────────────────────┘
```

---

## COMMAND SYSTEM

### Discovery Priority

```
1. Entity commands     ~/.entity/commands/
2. Local commands      ./commands/
3. Global commands     ~/.koad-io/commands/
```

### Global Commands

| Command | Purpose |
|---------|---------|
| `gestate <name>` | Create new entity with crypto keys |
| `init <name>` | Initialize cloned entity |
| `spawn <skeleton>` | Deploy project template |
| `build [local]` | Build Meteor app |
| `start [local]` | Start app |
| `shell [--terminal]` | Meteor shell or bash |
| `commit staged` | AI git commits |
| `test` | Run tests |

### Entity Commands (from Alice)

```
install:  browsers, bun, claudecode, codium, docker, essentials,
          github, goodies, homebrew, keybase, meteor, mongosh,
          netbird, nginx, nodejs, openclaw, opencode, starship,
          sublime, wireguard, zed, zerotier
```

---

## SKILLS SYSTEM

Two skill layers exist per entity. Both encode duties — different runtimes.

### Claude Code Skills (`~/.entity/.claude/skills/`)

Simple `.md` files. Loaded as executable prompts in Claude Code sessions.
Invoked as `/skill-name` when Claude Code is running inside the entity directory.
**This is where entity duties live** — each skill is a duty the entity knows how to perform.

```
~/.entity/.claude/skills/
└── <duty-name>.md     # Frontmatter: name, description. Body: steps + context.
```

Example duties per entity:

| Entity | Skills |
|--------|--------|
| Juno | `delegate`, `morning-brief`, `ops-update` |
| Vulcan | `gestate-entity`, `build-feature` |
| Mercury | `draft-post`, `respond-mention`, `weekly-report` |
| Veritas | `qa-review`, `sign-off` |
| Sibyl | `research-topic`, `competitive-scan` |

When you `juno spawn process <entity>`, the entity's Claude Code session has its skills ready.

### OpenCode Skills (`~/.entity/opencode/skills/<skill-name>/`)

Structured skill packages for the OpenCode runtime.

```
~/.entity/opencode/skills/<skill-name>/
├── SKILL.md           # Required: name, description, YAML
├── definitions.md     # Optional: opencode config ref
├── schema.json        # Optional: JSON Schema
└── *.mdx             # Optional: docs
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

[Description]

## When to use me

[Triggers]

## Workflow

1. Step one
2. Step two
```

### Alice's Skills

| Skill | Purpose |
|-------|---------|
| `quest` | Gamified learning quests |
| `learn` | Create/edit skills |
| `commit` | Git workflow |
| `explore` | Explore koad:io |

---

## ENTITY CREATION

### Method 1: gestate (new identity)

```bash
koad-io gestate <name> [--full]

Creates:
├── ~/.entityname/ (full structure)
├── Cryptographic keys (ed25519, ecdsa, rsa, dsa)
├── SSL credentials
├── Entity wrapper at ~/.koad-io/bin/<name>
└── Inherits from mother entity
```

### Method 2: git clone (copy existing)

```bash
git clone https://canon.koad.sh/koad/entity-freelancer.git ~/.freelancer
koad-io init freelancer

Creates:
├── Entity wrapper
├── Inherits commands, skills, memories
└── Customer generates own keys
```

---

## PRODUCT DELIVERY PIPELINE

```
┌─────────────────────────────────────────────────────────────┐
│  ENTITY REPO (Git)                                        │
├─────────────────────────────────────────────────────────────┤
│  entity-freelancer/                                        │
│  ├── commands/            ← Pre-built install scripts      │
│  ├── opencode/skills/     ← Custom AI capabilities         │
│  ├── memories/            ← Identity & knowledge          │
│  ├── skeletons/           ← Project templates               │
│  ├── passenger.json       ← UI config                      │
│  ├── README.md            ← Setup instructions             │
│  └── LICENSE              ← MIT                           │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ Customer
                            ▼
                      git clone
                            │
                            ▼
                      koad-io init
                            │
                            ▼
                      Usage
```

---

## DAEMON & DESKTOP

### Daemon

```
~/.koad-io/daemon/
├── Meteor DDP server
├── MongoDB management
├── PWA admin interface
└── Screen/session management
```

### Desktop App

```
~/.koad-io/desktop/
├── Electron app
├── System tray
├── Quick launch widget
├── Entity selector
└── Notifications (always on)
```

### Passenger (Chrome Extension)

```
~/.koad-io/passenger/
├── DDP connection to daemon
├── Content scripts (every page)
├── Site workers (GitHub, Twitter, etc.)
├── Sovereign profiles (kbpgp)
└── UI (popup, panel, settings)
```

---

## METEOR PACKAGES

### Core Framework (~/.koad-io/packages/)

```
accounts, accounts-ui, awesome-qr, core, head-js,
koad-io, logger, navigation, router, search,
session, templating, theme-engine, workers
```

### Admin Packages (astro/interface)

```
koad-io-dashboard-*, koad-io-administration-*,
koad-io-ui-extras, koad-io-config-editor,
koad-io-telephone, koad-io-discord
```

### Blockchain (ecoincore)

```
atomicdex, electrum, utxo, chainpack,
web3, daemon-manager, explorer-components
```

---

## ENVIRONMENT CASCADE

```
Priority (highest to lowest):
1. Command-local .env
2. Entity .env (~/.entity/)
3. Global .env (~/.koad-io/)

Example: alice install nodejs
1. Set ENTITY=alice, ENTITY_DIR=~/.alice
2. Source ~/.koad-io/.env
3. Source ~/.alice/.env
4. Source ~/.alice/commands/install/nodejs/.env
5. Execute command.sh
```

---

## OPENCODE INTEGRATION

### Config Location

```
~/.entity/opencode/
├── opencode.jsonc       # Agent config
├── agent.md             # Identity & context
└── skills/              # Skill definitions
```

### Key Variables

```
OPENCODE_MODEL         # AI model to use
OPENCODE_CONFIG_DIR    # Config directory
ENTITY                 # Current entity name
```

---

## FILE LOCATIONS

| Purpose | Location |
|---------|----------|
| Framework | `~/.koad-io/` |
| Entity | `~/.entityname/` |
| Keys | `~/.entityname/id/` |
| Claude Code duties (skills) | `~/.entityname/.claude/skills/` |
| OpenCode skills | `~/.entityname/opencode/skills/` |
| Commands | `~/.entityname/commands/` |
| Memories | `~/.entityname/memories/` |
| Config | `~/.entityname/opencode/` |
| Entity repos | `canon.koad.sh/koad/` |
| Public keys | `canon.koad.sh/*.keys` |

---

## MY STRUCTURE (When Gestated)

```
~/.juno/
├── bin/juno                 # Entity wrapper
├── commands/                    # Business commands
│   ├── install/
│   └── business/
├── opencode/
│   ├── opencode.jsonc
│   ├── agent.md
│   └── skills/
│       ├── quest/
│       ├── learn/
│       ├── commit/
│       ├── explore/
│       └── business-*           # Custom skills
├── memories/
│   ├── 001-identity.md
│   └── 002-business.md
├── id/
│   ├── kbpgp_key               # Private
│   ├── kbpgp_key.pub           # Public
│   ├── ed25519, ecdsa, rsa
│   └── ssl/
├── skeletons/                   # Inherited
├── passenger.json               # PWA config
├── .env
└── trust/
    └── bonds/
        └── koad-authorized.signed
```

---

## PRODUCT LIFECYCLE

```
1. BUILD:     Create entity structure + skills
2. TEST:      Run through use cases
3. PUSH:      git push to canon.koad.sh
4. MARKET:    Announce on kingofalldata.com
5. DELIVER:   Customer git clones
6. SUPPORT:   MVP Zone + trust bonds
7. ITERATE:   Update based on feedback
```

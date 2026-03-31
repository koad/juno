# Ecosystem Overview

## THE FULL PICTURE

```
┌─────────────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  DESKTOP APP                                               │
│  ├── System tray presence                                 │
│  ├── Quick launch widget                                  │
│  ├── Notifications (always on)                            │
│  └── Entity selector                                       │
│                                                             │
│  DARK PASSENGER (Chrome Extension)                        │
│  ├── Active on every tab/URL                              │
│  ├── Can augment any webpage                              │
│  ├── Emit to channels from any page                       │
│  └── Social markup (peer annotations)                     │
│                                                             │
│  WEB INTERFACE (Meteor apps)                              │
│  ├── Admin dashboards (astro's interface)                 │
│  ├── User profiles (beatify.audio)                        │
│  └── Custom applications                                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  ENTITY LAYER (koad:io)                                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ONE USER = MULTIPLE ENTITIES                              │
│  ├── alice       → General assistant                      │
│  ├── juno    → Business operations                    │
│  ├── maya        → Research                              │
│  ├── devops      → Infrastructure                        │
│  ├── client-x    → Client-specific                        │
│  └── ...        → One per role/area                      │
│                                                             │
│  EACH ENTITY HAS:                                         │
│  ├── Sovereign identity (kbpgp keys)                     │
│  ├── Trust bonds (signed relationships)                   │
│  ├── Skills (AI capabilities)                             │
│  ├── Commands (install scripts)                            │
│  └── Memories (context & identity)                         │
│                                                             │
│  CHANNELS = Communication                                 │
│  ├── #family      → Family trust required                │
│  ├── #business    → Business trust required              │
│  ├── #friends     → Friend trust required                │
│  ├── #mvp-zone    → Sponsors only                       │
│  └── #public      → Anyone                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  INFRASTRUCTURE (canon.koad.sh)                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  FORGEJO (Git Forge)                                      │
│  ├── Source code repos                                    │
│  ├── Issues & wiki                                        │
│  └── Packages (Meteor)                                    │
│                                                             │
│  KEYS SERVER                                              │
│  ├── koad.keys                                           │
│  ├── alice.keys                                          │
│  ├── juno.keys (future)                              │
│  └── *.keys = public key distribution                     │
│                                                             │
│  ENTITY DELIVERY                                          │
│  ├── canon.koad.sh/koad/entity-freelancer               │
│  ├── canon.koad.sh/koad/entity-developer                 │
│  └── git clone = get entity                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  EDUCATION (kingofalldata.com)                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  "User manual for all the kings building sovereign selves"  │
│                                                             │
│  CONTENT:                                                  │
│  ├── koad:io documentation                               │
│  ├── Entity creation guides                               │
│  ├── Trust bond explanations                             │
│  ├── Dark passenger tutorials                            │
│  ├── kbpgp/GPG guides                                   │
│  └── Sovereign identity principles                        │
│                                                             │
│  AUDIENCE: "Kings" = Power users, developers, privacy     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## THE BUSINESS TIERS

```
┌─────────────────────────────────────────────────────────────┐
│  FREE (Mass Reach)                                         │
├─────────────────────────────────────────────────────────────┤
│  • github.com/koad/entity-* (clone & learn)             │
│  • kingofalldata.com (documentation)                       │
│  • canon.koad.sh (infrastructure)                        │
│                                                             │
│  Goal: Get people to build their sovereign selves         │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ Sponsor $1+/mo
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  $1+/mo COMMUNITY                                         │
├─────────────────────────────────────────────────────────────┤
│  • MVP Zone (chat)                                        │
│  • Talk to example entities (including me)                │
│  • Peer support                                           │
│  • "Sponsor any amount"                                   │
│                                                             │
│  Goal: Build relationships, prove value                   │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ Need more?
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  PREMIUM (koad.sh)                                        │
├─────────────────────────────────────────────────────────────┤
│  • Custom entity development                              │
│  • Personalized consulting                                │
│  • Priority support                                       │
│  • "Starting at a fuckload of money"                     │
│                                                             │
│  Goal: High-value revenue                                 │
└─────────────────────────────────────────────────────────────┘
```

---

## THE NETWORK EFFECT

```
ENTITIES SELL ENTITIES

Every user with multiple entities becomes:
├── Word-of-mouth marketer
├── Trust bond node
├── Example repo contributor
├── Community moderator

When ONE person runs 10 entities well,
they become proof that it works.
Others see it and want the same.
Network grows organically.
```

---

## DOMAIN STRUCTURE

```
kingofalldata.com     → User manual (education)
beatify.audio         → Profile system (example app)
canon.koad.sh         → Forgejo (infrastructure)
koad.sh              → Creator services (premium)
*.keys.koad.sh        → Key distribution
```

---

## KEY RELATIONSHIPS

```
koad (Creator)
    │
    ├── kingofalldata.com (Education)
    ├── canon.koad.sh (Infrastructure)
    ├── koad.sh (Premium services)
    │
    ├── alice (General entity)
    ├── juno (Business entity) ← ME
    ├── maya (Research entity)
    └── ... (More entities)

Peer Network
    │
    ├── Example repos (github.com/koad/)
    ├── GitHub Sponsors community
    └── Trust-bonded users
```

---

## HOW TO EXPLAIN IT TO NEWBIES

> "Imagine you have a team of AI assistants, each with their own identity, that you control. They're not one AI for everything—they're specialized agents for different parts of your life. And you can prove they're really yours because of cryptographic trust bonds."

---

## TECHNICAL STACK

```
FRAMEWORK:      koad:io (~/.koad-io/)
LANGUAGES:      JavaScript (Meteor), Bash
CRYPTO:         kbpgp (Keybase PGP)
KEYS:           Ed25519, RSA, ECDSA
STORAGE:        MongoDB (via Meteor)
REALTIME:       DDP (Meteor)
UI:             React (Meteor)
EXTENSION:      Chrome (Dark Passenger)
DESKTOP:        Electron (Desktop app)
GIT:            Forgejo (canon.koad.sh)
HOSTING:        Self-hosted (pearl, wonderland)
```

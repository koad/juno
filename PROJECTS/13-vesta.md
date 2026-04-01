# PROJECT: Vesta — Platform Keeper

**Status:** Planned
**Layer:** Platform
**Priority:** After Vulcan is operational

---

## Purpose

Vesta owns the koad:io protocol. Not the products built with it — the protocol itself. She writes the canonical specifications, maintains the documentation, and stabilizes the framework so every other entity has solid ground to build on.

**The flame metaphor is literal:** if koad:io is undefined, inconsistent, or undocumented, everything downstream breaks. Vesta keeps it burning clean.

## What Vesta Owns

### Protocol Specifications
- **Entity model** — canonical directory structure, required files, .env schema
- **Gestation protocol** — the canonical sequence for creating a new entity
- **Identity & keys** — key types, naming conventions, public key distribution
- **Trust bonds** — signed authorization protocol between entities
- **Cascade environment** — .env load order, override mechanics
- **Commands system** — discovery, resolution, execution
- **Spawn protocol** — how entities launch other entities as sovereign processes
- **Inter-entity comms** — coordination protocol (current: project folders, future: potentially GitHub Issues or other)
- **Daemon** — always-on runtime specification
- **Package system** — what a koad:io package is, install/discovery mechanics

### Documentation
- Canonical reference for each spec above
- Migration guides when protocol evolves
- Onboarding docs for new entity adopters

## Relationship to Vulcan

| Vesta | Vulcan |
|-------|--------|
| Works *on* koad:io | Works *with* koad:io |
| Defines the protocol | Builds products using it |
| Stabilizes the foundation | Ships on top of it |
| Owns `~/.koad-io/` spec | Consumes `~/.koad-io/` runtime |

The koad-io project currently in Vulcan's backlog migrates to Vesta on gestation.

## Workflow

```
Any entity finds a protocol gap or inconsistency
    → Reports to Vesta
Vesta documents the canonical answer
    → All entities update to match
Argus uses Vesta's specs as the reference for diagnostics
Vulcan uses Vesta's specs as the foundation for builds
```

## Gestation

```bash
koad-io gestate vesta
```

- Vesta gets her own Linux user, keys, GitHub repo
- The `koad-io` project spec tasks migrate from `~/.vulcan/projects/koad-io/` to `~/.vesta/projects/`

## Trust Bond

- Juno → Vesta: peer (platform layer)
- Vesta → Argus: reference (Argus uses Vesta's specs as protocol source)

---

*Created: 2026-03-31*

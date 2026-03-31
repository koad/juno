# Project: kingofalldata.com — Sovereign Identity Platform + Multi-Domain Network

## Status: SPECCING — ready to commission Vulcan

## The Vision

kingofalldata.com is the canonical hub of a multi-domain acquisition network. One Meteor app, one nginx, dozens of domains — each targeting a niche, each speaking directly to a specific audience, all converting into the same sovereign identity ecosystem.

**The MySpace for entities and humans.** Every member gets a namespace. Every namespace is a profile, a keyserver, and an emitter host. The Dark Passenger browser extension reads these namespaces to connect members across the web — no central authority, just verified identity.

---

## Architecture

### Infrastructure

```
┌─────────────────────────────────────────────────────────────────┐
│  Niche domains (acquisition funnels)                           │
│                                                                 │
│  entityforfreelancers.com  →  "AI entities for freelancers"    │
│  sovereignagents.io        →  "own your AI agent"              │
│  aifordevs.me              →  "AI entities for developers"     │
│  kingofalldata.com         →  main brand / canonical           │
│  ... (dozens over time)                                        │
└────────────────────────┬────────────────────────────────────────┘
                         │  all point here
                         ▼
                      nginx
                    (one server)
                         │
                         ▼
                    Meteor app
                    (one codebase)
                         │
                         ▼
                  koad:io-router
                  (subdomain-aware)
                    ├── reads hostname → selects domain skin + niche pitch
                    ├── reads subdomain → resolves namespace
                    └── renders:
                          someawesomedomain.me/         → niche root pitch
                          someawesomedomain.me/koad     → koad's namespace
                          koad.someawesomedomain.me     → koad's namespace
```

### Per Domain

Each domain has:
1. **Root pitch** — niche-specific, speaks directly to that audience's pain
2. **Namespace pages** — same identity data, wrapped in the domain's skin
3. **MVP Zone entry** — same gate, same community, different on-ramp

### Per Namespace

```
<name>.somedomain.com   (or somedomain.com/<name>)
  ├── /               — Public profile page
  ├── /keys           — Keyserver (PGP, SSH, Ed25519, kbpgp)
  ├── /emitters       — Active presence/status broadcasts
  └── /trust          — Discoverable trust bonds
```

Namespace data is canonical — the domain is just the skin. `koad.kingofalldata.com` and `koad.entityforfreelancers.com` serve the same koad profile. The koad:io-router resolves namespace from subdomain or path, fetches from the same source.

---

## Namespace System

### Who Gets One

MVP Zone members (GitHub Sponsors or equivalent). Namespace = the unlock.

### What's Included

| Path | Purpose |
|------|---------|
| `<name>.kingofalldata.com` | Public profile page |
| `<name>.kingofalldata.com/keys` | Keyserver — all public keys for this entity/human |
| `<name>.kingofalldata.com/emitters` | Active emitters (presence, status, broadcasts) |
| `<name>.kingofalldata.com/trust` | Discoverable trust bonds |

### Examples

| Namespace | Who |
|-----------|-----|
| `koad.kingofalldata.com` | koad (Jason Zvaniga) — human |
| `juno.kingofalldata.com` | Juno — AI business entity |
| `vulcan.kingofalldata.com` | Vulcan — AI builder entity |
| `alice.kingofalldata.com` | Alice — AI hardware/tooling entity |

### Custom Domain CNAME

Members can bring their own domain and CNAME to their namespace:

```
koad.sh         → CNAME → koad.kingofalldata.com
canon.koad.sh   → CNAME → koad.kingofalldata.com (or /canon subpath)
juno.keys       → CNAME → juno.kingofalldata.com/keys
```

The namespace stays the canonical source. The custom domain is a pointer. Identity is portable — the user owns it, not the platform.

---

## Dark Passenger Integration

The browser extension reads namespaces to power the social layer:

1. Member visits any webpage
2. Dark Passenger resolves other members present on the page via their namespace/emitters
3. Sidechannel opened — verified by keys at `<name>.kingofalldata.com/keys`
4. Members interact in their own sidechannel, not visible to the host page

**Trust without central authority:** the keyserver at each namespace is the trust anchor. Dark Passenger verifies identity against it. No platform in the middle.

---

## The Graduation Path

```
New member:
  → gets <name>.kingofalldata.com
  → starts building profile, keys, emitters

Established member:
  → brings own domain
  → CNAMEs to namespace
  → identity is now fully theirs

Power user:
  → runs own canon.koad.sh (self-hosted namespace server)
  → kingofalldata.com is now just one node in their trust chain
```

---

## MVP Zone (Embedded)

Not a separate platform. Lives at `kingofalldata.com/mvp`.

| Feature | Notes |
|---------|-------|
| Access gate | GitHub Sponsors verification → namespace provisioned |
| Member directory | Browse namespaces, discover entities and humans |
| Build stream | What Vulcan is working on, recent entity releases |
| Community content | koad:io updates, tutorials, announcements |
| Dark Passenger | Members can sidechannel each other while browsing MVP Zone |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| App | Meteor (single codebase, reactive, subdomain routing) |
| Reverse proxy | nginx (all domains → one app, wildcard SSL) |
| Router | koad:io-router (subdomain-aware, domain-skin aware) |
| Hosting | Hetzner VPS (augur) |
| DNS | Wildcard `*.kingofalldata.com` + per-niche domain wildcards |
| Auth | GitHub Sponsors API → namespace provisioning |
| Identity data | Entity git repos (pulled on push, served statically) |

## What Vulcan Builds

### Phase 1 — Core App + Router + Namespace Engine

- Meteor app skeleton at kingofalldata.com
- koad:io-router: subdomain-aware, domain-skin aware rendering
- Domain skin system: per-domain root pitch, configurable per domain
- Namespace engine: provision, store, serve namespace data
- Keyserver endpoint (`/keys` per namespace)
- CNAME + wildcard subdomain support on nginx
- MVP Zone gating (GitHub Sponsors API verification)
- First three domain skins: kingofalldata.com, [freelancer niche], [dev niche]

### Phase 2 — Emitters + Dark Passenger

- Emitter hosting per namespace (presence, status broadcasts)
- Dark Passenger reads `/keys` and `/emitters` to verify and connect members
- Sidechannel protocol spec

### Phase 3 — Multi-domain Expansion

- Domain skin templating so koad can launch new niche domains without Vulcan
- Self-hosted namespace server (for power users who want to run their own)
- `canon.koad.sh` as reference self-hosted implementation

---

## Spec Notes for Vulcan

- **PWA first** — installable, fast, works offline for public content
- **Static where possible** — namespace profiles pull from git, regenerate on push
- **No auth database** — GitHub Sponsors is the auth source; namespace config is files
- **Dark Passenger is a separate project** — Phase 1 just needs the keyserver endpoint to be correct so DP can integrate later
- **Design language:** sovereign, minimal, not corporate. Think identity card, not SaaS dashboard.
- **Subdomain routing:** wildcard DNS → single PWA → reads namespace from subdomain

---

## Dependencies

| Dependency | Owner | Status |
|------------|-------|--------|
| Vulcan trust bond signed | koad | Pending |
| Vulcan Linux user + gh auth | koad | Pending |
| kingofalldata.com DNS control | koad | Existing |
| Wildcard SSL for *.kingofalldata.com | koad/Vulcan | Needed |
| GitHub Sponsors API access | koad | Needed |
| Hetzner VPS (augur) for hosting | koad | Pending |

---

## Success Criteria

- `juno.kingofalldata.com` is live and shows Juno's profile, keys, and team status
- `koad.kingofalldata.com` is live and shows koad's profile and keys
- A new sponsor can claim a namespace within 5 minutes of sponsoring
- Dark Passenger can resolve a member's keys from their namespace URL
- Custom CNAME works (at least for koad.sh as the first test)

---

## Business Model Angle

Each niche domain is a targeted acquisition funnel:

- **SEO surface area** — dozens of domains targeting specific searches ("AI entity for freelancers", "sovereign AI agent for devs", etc.)
- **Conversion** — each root pitch speaks directly to that niche's problem, converts to namespace signup
- **Same product everywhere** — one infrastructure, one community, one trust network — just many front doors
- **Domain portfolio** — low cost to acquire and point; high leverage per domain once the router handles the rest

The koad:io-router's subdomain/domain awareness is the multiplier. One deploy, infinite front doors.

---

*This is the platform. Everything else builds on it.*
*Last updated: 2026-03-31*

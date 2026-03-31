# Project: kingofalldata.com — Sovereign Identity Platform

## Status: SPECCING — ready to commission Vulcan

## The Vision

kingofalldata.com is not a marketing site. It is a sovereign identity platform — the public face of the koad:io ecosystem and the infrastructure that makes the Dark Passenger social layer trustworthy.

**The MySpace for entities and humans.** Every member gets a namespace. Every namespace is a profile, a keyserver, and an emitter host. The Dark Passenger browser extension reads these namespaces to connect members across the web — no central authority, just verified identity.

---

## Architecture

```
kingofalldata.com (PWA)
│
├── / — Public brand hub
│     ├── Ecosystem overview
│     ├── Entity showcase (Juno, Vulcan, team)
│     ├── Live operation state (recent commits, what's building)
│     └── CTA: get a namespace (MVP Zone) / clone an entity (GitHub)
│
├── /mvp — MVP Zone (sponsor-gated)
│     ├── Member directory (namespaces)
│     ├── Entity releases and updates
│     ├── Build-in-public stream (what Vulcan is working on)
│     └── Community content
│
└── <name>.kingofalldata.com — Member namespaces
      ├── /               — Public profile page
      ├── /keys           — Public keyserver (PGP, SSH, Ed25519)
      ├── /emitters       — Active presence/status broadcasts
      └── /trust          — Discoverable trust bonds (visibility: discoverable)
```

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

## What Vulcan Builds

### Phase 1 — Core PWA + Namespace Engine

- kingofalldata.com PWA (Next.js or SvelteKit — Vulcan decides)
- Namespace provisioning system (create subdomain on GitHub Sponsors webhook)
- Static profile pages per namespace (pulled from entity git repos)
- Keyserver endpoint (`/keys` — serves public keys from namespace config)
- CNAME support (DNS wildcard `*.kingofalldata.com`)
- MVP Zone gating (GitHub Sponsors API verification)

### Phase 2 — Emitters + Dark Passenger

- Emitter hosting per namespace (presence, status broadcasts)
- Dark Passenger integration spec (how extension reads namespaces)
- Sidechannel protocol (how members connect via keys)

### Phase 3 — Self-hosted

- `canon.koad.sh`-compatible namespace server (open source, cloneable)
- Enables anyone to run their own namespace infrastructure

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

*This is the platform. Everything else builds on it.*
*Last updated: 2026-03-31*

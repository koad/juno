# PRIMER — Juno's home

> Visitor's orientation. If you just landed in `~/.juno/` and want to know what you're looking at — start here.

This is the home directory of **Juno**, an AI business entity in the koad:io kingdom. Juno orchestrates the team and operates the business surface; the team executes specialty work. One entity, one specialty.

For Juno's identity and authority, read `ENTITY.md`. For the kingdom's operating principles, read `~/.koad-io/KOAD_IO.md` first.

## What lives where

| Path | Purpose |
|------|---------|
| `ENTITY.md` | Juno's stable identity — personality, role, team, authority, trust chain |
| `README.md` | One-page external intro (this dir's elevator pitch) |
| `PRIMER.md` | This file — ambient context for visitors |
| `commands/` | Juno's CLI tools (`tickler`, `assemble`, `control`, `dance-hall`, `shot`, `sign`, `think`, `adas`, `status`, `usage`, `trust-bond-viewer`) |
| `memories/` | Long-term entity memory (committed to repo, visible to all harnesses) |
| `briefs/` | Long-form direction, sprint logs, synthesis artifacts. Active briefs at root; completed work in `briefs/.archive/` |
| `bootstraps/` | Replayable workflow definitions — between briefs (one-shot) and commands (atomic) |
| `horizons/` | GTD altitude board (`runway/`, `10k/`, `20k/`, `30k/`, `40k/`, `50k/`, `someday/`, `completed/`) |
| `tickler/` | Time- and space-addressed deferred inbox (path is the alarm clock) |
| `id/` | Cryptographic keys (Ed25519, ECDSA, RSA, GPG) — public keys safe to read; private keys gitignored |
| `trust/bonds/` | GPG-clearsigned trust bonds (issued + received) |
| `devices/` | Per-device records (e.g. `zero/manifest.yaml`) |
| `tools/` | Entity-level MCP tools (per VESTA-SPEC-137) |
| `triggers/` | Reactive scripts that fire on emission patterns (per VESTA-SPEC-145) |
| `hooks/` | Lifecycle hooks that override framework defaults |
| `qc/` | Self-quiz proposals (`proposed/`) and self-authored evals |
| `streams/` | Trigger runtime output — fully gitignored per VESTA-SPEC-145 |
| `flights/` | Per-flight ephemera — gitignored, durable record lives in commit trailers |
| `sigchain/` | Juno's sovereign sigchain (genesis published 2026-04-17) |
| `screenshots/` | Playwright captures — gitignored |
| `projects/` | Claude Code session state — gitignored, includes the playback machine library |

## How to read this dir

- **You're a visitor (human or entity):** start with `ENTITY.md` for who Juno is, then this `PRIMER.md` for what's where, then `README.md` for the external pitch.
- **You're Juno yourself in a fresh harness:** load order is `~/.koad-io/KOAD_IO.md` → `ENTITY.md` → this `PRIMER.md` → `memories/` → `projects/-home-koad--juno/memory/MEMORY.md` (auto-memory index). Active state is in `briefs/`, `tickler/`, and `horizons/runway/`.
- **You're another entity dropping a brief for Juno:** write to `~/.juno/briefs/<slug>.md` with frontmatter (`title`, `from`, `to: juno`, `status`, `priority`, `relates-to`). Juno reads `briefs/` on session start and acts on what surfaces.

## What this dir is NOT

- **Not a software project.** No build, no tests. The repo IS the artifact.
- **Not a personal scratch space.** Everything here is committed and visible. Sovereignty has a public face.
- **Not the framework.** The framework lives at `~/.koad-io/`. This is one kingdom's operating entity.
- **Not the storefront.** The storefront lives at `~/.forge/websites/kingofalldata.com/`. This is Juno's home.

## Where the work actually happens

Juno's day-to-day surfaces:
- The kingdom **daemon** at `http://10.10.10.10:28282` (nervous system — emissions, flights, sessions)
- The business **dance-hall** at `http://10.10.10.10:28383` (persistent storefront state — tips, announcements, sessions)
- The **storefront** at https://kingofalldata.com (the public face)
- The **team** — 19 entities + Vulcan (the builder), each with their own `~/.<entity>/` home, communicating via briefs + emissions + Keybase

## Operating principles (full version in KOAD_IO.md)

- Files on disk = total evolution. Not your keys, not your agent.
- The operation is the demo. Every commit is proof.
- Framework stays a skeleton. Business lives in overlays (`~/.juno/`, `~/.forge/`).
- Sovereign. Distributed. On owned hardware. On full display.

## Repo

Canonical: `keybase://team/kingofalldata.entities.juno/self`

Public window: `github.com/koad/juno` (when present — koad's call per visibility model)

---

*This file is for visitors. Juno's stable identity is `ENTITY.md`.*

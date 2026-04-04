---
name: Infrastructure — four-node environment
description: Juno's team spans four machines; entity locations matter for comms and invocation
type: project
---

The team is distributed across five machines:

| Machine | Role | Entities |
|---------|------|----------|
| **thinker** | Primary — where koad and Juno operate | Juno, Argus, Janus, Salus, Muse, Aegis, Veritas |
| **wonderland** | koad's desktop PC | Vulcan, Vesta (+ alice, astro) |
| **fourty4** | Mac Mini — OpenClaw, ollama, GitClaw, Playwright | Mercury, Sibyl |
| **flowbie** | 24/7 always-on, X11, OBS source | persistent/background processes |
| **dotsh** | Vultr VPS — Toronto — stable host (179d uptime), Matrix/koad.sh stack — **will retire** once cluster is provisioned | current always-on node, daemon candidate |
| **10.10.10.12** | Contabo — St. Louis — slow, to be retired | current kingofalldata.com + shipped Meteor sites (nginx proxy + Docker) |

Executables in `~/.koad-io/bin`: `fourty4`, `flowbie` — SSH wrappers. `wonderland` and `dotsh` wrappers TBD.

**dotsh is the network-reliable node.** thinker (this laptop) has a poor connection. dotsh is a Toronto VPS near koad with good uptime (179d) and solid connectivity. All outbound network work — API calls, GitHub interactions, comms sync, scheduled entity routines — should run from dotsh, not thinker. thinker is for interactive sessions with koad only.

**Memory is tight on dotsh** (Matrix stack). Lightweight cron-triggered scripts only — no persistent entity processes. Scripts wake entities via SSH to thinker/fourty4 as needed.

**Why:** koad granted these machines to Juno as an infrastructure gift. SSH aliases don't work in Claude Code; real executables in ~/.koad-io/bin do.

**How to apply:** 
- Interactive work with koad → thinker
- Scheduled/autonomous outbound work → dotsh
- Local inference → fourty4 (ollama)
- Persistent background processes → flowbie
- Entity invocation cross-machine → git-sync comms (koad/vulcan#15) or SSH

**Inter-entity comms:** Phase 1 (file-based git-sync) being built by Vulcan — koad/vulcan#15.

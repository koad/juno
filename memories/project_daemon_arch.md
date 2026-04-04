---
name: Daemon architecture
description: koad:io daemon — the kingdom hub. Passenger system, worker loop, DDP, dotsh setup state.
type: project
---

`~/.koad-io/daemon` is a Meteor app. The single daemon to rule them all.

**How it works:** Scans `~/.*` dirs for `.env` with `KOAD_IO_*`. Loads `passenger.json` from each. Registers passengers in MongoDB. Exposes via DDP. Runs worker loop for scheduled entity tasks.

**All 12 entities have `passenger.json`** (with role-appropriate buttons) as of 2026-04-03.

**Passenger methods:** `passenger.check.in`, `passenger.ingest.url`, `passenger.resolve.identity`, `passenger.check.url`, `passenger.reload`

**Dark Passenger:** Browser extension connects via DDP. Selected entity receives every URL the human visits.

**Worker system:** `~/.koad-io/packages/workers/` — MongoDB WorkerProcesses collection. Daemon fires `hooks/worker-fired.sh` when worker is due. Self-aware scheduling — no crontab.

**npm install fixed (2026-04-03):** Vulcan removed unused `electron` from daemon's package.json (koad/io@410fa60). `npm install` now completes in ~2s. body-parser is installed. Issue #20 closed.

**dotsh setup state (2026-04-03, in progress):**
- juno user created, passwordless sudo, SSH key registered on GitHub
- `~/.koad-io` and `~/.juno` cloned
- Node 22.22.2 via nvm, Meteor 3.4 installed
- MongoDB running on port 27017 (`~/data/db`)
- npm install now unblocked (electron removed)
- **Next step:** Start daemon with:
  ```bash
  ssh juno@dotsh
  cd ~/.koad-io/daemon/src
  METEOR_PACKAGE_DIRS=/home/juno/.koad-io/packages MONGO_URL=mongodb://localhost:27017/koadio PORT=3001 ROOT_URL=http://localhost:3001 nohup ~/.meteor/meteor run --port 3001 > ~/data/daemon.log 2>&1 &
  ```
- `dotsh` wrapper exists in `~/.koad-io/bin/dotsh` — connects as juno user

**Why:** The daemon is what connects entities to the DDP bus, fires scheduled workers, and makes the Dark Passenger work. Running it on dotsh (always-on, good connectivity) makes the kingdom always awake.

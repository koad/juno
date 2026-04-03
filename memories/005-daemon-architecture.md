---
title: "005 - Daemon Architecture"
created: 2026-04-03
updated: 2026-04-03
tags: [daemon, architecture, ddp, mongodb, hooks, passengers]
status: active
---

# The koad:io Daemon Architecture

## What the Daemon Is

`~/.koad-io/daemon` — a Meteor app that is the central nervous system of the koad:io ecosystem. One daemon to rule them all.

It runs on always-on nodes (currently dotsh — Vultr, Toronto), connects to MongoDB, discovers entities, registers passengers, manages workers, and serves events over DDP to every connected node and browser.

## How It Works

On startup the daemon:
1. Scans `~/.*` directories for `.env` files containing `KOAD_IO_` variables
2. For each qualifying entity directory, looks for `passenger.json`
3. Registers each passenger in MongoDB (handle, name, role, avatar as base64, buttons)
4. Exposes passengers via DDP subscriptions (`all`, `current`)
5. Starts the worker loop — checks MongoDB for stale workers and fires them
6. Serves UI on port 3001 (desktop widget + admin PWA)

## Passenger System

`passenger.json` makes an entity visible to the daemon. Schema:
```json
{
  "handle": "juno",
  "name": "Juno",
  "role": "business orchestrator",
  "avatar": "avatar.png",
  "buttons": [
    { "label": "Status", "action": "status", "description": "..." }
  ]
}
```

All 12 entities have `passenger.json` as of 2026-04-03. When the daemon scans, all 12 will register.

DDP methods:
- `passenger.check.in` — select this passenger as active
- `passenger.ingest.url` — browser sends a URL to the active passenger
- `passenger.resolve.identity` — active passenger resolves an identity for a domain
- `passenger.check.url` — active passenger checks a URL
- `passenger.reload` — force re-scan and re-register all passengers

## Dark Passenger (Browser Extension)

Connects to the daemon via DDP. Lets koad select an entity as "active passenger." The selected entity then:
- Receives every URL koad visits via `passenger.ingest.url`
- Can resolve identity for domains via `passenger.resolve.identity`
- Can flag URLs via `passenger.check.url`

This is how entities ride alongside the human in real-time. Not an assistant answering questions — a mind sharing the same information space.

## Worker System

`~/.koad-io/packages/workers/` — MongoDB-backed scheduler.

Workers are documents in the `workers` collection:
```js
{
  service: 'salus-daily-heal',
  instance: 'dotsh',
  interval: 1440,        // minutes
  enabled: true,
  insane: false,
  lastHeartbeat: null,
  lastRun: null,
  claimedBy: null
}
```

The daemon's worker loop:
1. Checks for workers where `lastRun` is null or stale beyond `interval`
2. Claims the worker (sets `claimedBy`)
3. Fires the entity's `hooks/worker-fired.sh` with `WORKER=<service>`
4. Entity runs, updates `lastHeartbeat`
5. Daemon sees heartbeat, marks healthy
6. If heartbeat goes stale → marks `insane: true` → alert fires

No crontab. The system knows its own schedule.

## Entity Upstart Hook

`~/.koad-io/hooks/entity-upstart.sh` — fires on session login/daemon start:
- Starts the daemon in a `screen` session if not already running
- Starts the desktop UI after a 3s delay

On dotsh, this fires when juno logs in via SSH. The daemon then discovers all entities in `/home/juno/.*` and registers passengers.

## Infrastructure State (2026-04-03)

- **dotsh**: Node 22.22.2 via nvm, Meteor 3.4, MongoDB 4.4.10 running on port 27017. Daemon first-run in progress.
- **10.10.10.12**: Contabo, St. Louis — slow, retiring. Current Meteor sites. NOT the daemon node.
- **thinker**: Primary interactive. koad talks to Juno here. Not an always-on node.

## DDP vs File-Based Comms

DDP (Meteor + MongoDB) is the real-time channel. `comms/inbox/` and `comms/outbox/` are the durable audit trail and bootstrap fallback. Both matter:
- DDP: events propagate instantly, entities react in real-time
- git comms: permanent record, survives daemon restarts, readable without running software

## The Hooks Connection

Daemon-triggered hooks run in the user's space. This means:
- A worker firing on dotsh can `ssh thinker "gnome-terminal -- vulcan"` and open a window
- Hooks have access to the full desktop environment of the user session
- The daemon is the bridge between DDP events and local entity execution

koad/vesta#9 covers the full hooks catalog spec.

# Entity Piping Architecture

How signals move between entities, platforms, and machines — and which tools carry them.

---

## Principle

OpenClaw is a social platform adapter, not a communication bus. koad:io runs on Node and Meteor — we can build any pipe we need. Choose the right pipe for the job, not the most available one.

> **Loose cannon rule:** A pipe that connects to 20+ public platforms simultaneously should never be the default route for internal signals. Wide pipes have wide blast radius.

---

## Pipe Inventory

| Pipe | What it is | Good for | Not for |
|------|-----------|----------|---------|
| **OpenClaw** | Pre-built bridge to 20+ social platforms | Outbound publish, inbound mention monitoring | Entity-to-entity signals, internal state, draft queues |
| **GitHub Issues** | Structured async tasks, visible, auditable | Juno ↔ entity assignment, entity reporting back | Real-time signals, high-frequency events |
| **Meteor DDP** | Reactive pub/sub, real-time collections | Live state sync, stream wall, ops board | External platform integration |
| **Node HTTP/WS** | Custom webhook endpoints, raw pipes | Platform-specific integrations, draft queues, event bridges | Anything that already has a better tool |
| **cron + shell** | Scheduled execution on fourty4 | Posting schedules, recurring checks | State-bearing workflows |
| **GitClaw** | GitHub event watcher on fourty4 | Waking entities on repo events (issues filed, PRs merged) | Outbound publishing |

---

## Signal Classification

Not all signals are equal. Route by risk and latency requirement:

```
Internal / low-risk
  Entity → entity coordination    → GitHub Issues
  State synchronization           → Meteor DDP
  Draft queue management          → Node service

External / publish
  Scheduled post                  → Draft queue → approval window → OpenClaw → platform
  Mention response                → Draft queue → escalation check → OpenClaw → platform
  Sensitive announcement          → Juno review required → then OpenClaw

Inbound / monitoring
  Social mentions                 → OpenClaw (reader) → Mercury
  GitHub events                   → GitClaw → entity wake
  Platform webhooks               → Custom Node endpoint → entity
```

---

## Approval Architecture

Mercury (and any outbound-publishing entity) operates in two modes:

**Draft mode (default):**
- All outbound content goes into a staging queue
- Auto-publishes after a hold window (configurable) with no override
- Sensitive content escalated to Juno — never auto-publishes

**Publish mode (unlocked):**
- Requires koad → juno trust bond formalized
- Requires demonstrated calibration (draft mode ran clean for N cycles)
- Platform-scoped: can unlock Twitter before LinkedIn independently

---

## Platform Tiering (blast radius)

| Tier | Platforms | Oversight |
|------|-----------|-----------|
| **Low risk** | GitHub (release notes, sponsor thanks) | Auto-approve |
| **Medium risk** | Discord (community), Reddit | Short hold window |
| **High risk** | Twitter/X, LinkedIn | Juno review or longer hold |

---

## What OpenClaw Is Not

- Not an entity message bus
- Not a trigger system for internal entity coordination
- Not a replacement for Meteor's reactive layer
- Not the default just because it's installed

When in doubt: build the pipe you need. Node + Meteor is the stack.

---

*Created: 2026-04-01*

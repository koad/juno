---
name: Operations Architecture
description: Each entity runs as own Linux user with gh CLI auth, GitHub Issues for inter-entity communication
type: project
---

All entities run as koad's Linux user, sharing a single `gh` CLI auth under koad's GitHub account. No separate Linux users needed. Each entity lives in its own `~/.<entity>/` directory with its own git identity, keys, and Claude Code session.

**Real-time communication layer:** A Meteor package on 10.10.10.12 using MongoDB + DDP events. This is the actual comms bus — it connects all devices and desktops through multiple interfaces in real-time. Entities are DDP clients that subscribe to topics and react to events. This is more capable than the file-based git inbox/outbox we pre-scaffolded (those are a bootstrap/fallback only). dotsh cron jobs trigger entity work by emitting DDP events, not by polling git repos.

**Assignment/coordination protocol:** GitHub Issues for explicit task assignment (koad → Juno → team). DDP for real-time event propagation between running entities.

**Why the file-based comms/ dirs still have value:** Bootstrap before DDP connection is established, and as a durable audit trail (git-committed). But DDP is the live channel.

**How to apply:** When coordinating with team entities, use `gh issue create --repo koad/<entity>` to delegate work. For real-time entity-to-entity events, the DDP bus on 10.10.10.12 is the channel. The comms/inbox pattern is a fallback when DDP isn't available. gh must be installed and authed under koad before any entity can use GitHub Issues.

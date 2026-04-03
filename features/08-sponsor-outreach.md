---
status: planned
owner: juno
priority: high
description: Execute sponsor outreach campaigns — identify targets, send personalized pitches, track responses
---

# Sponsor Outreach

## Purpose
The first 5 sponsors are the critical milestone. Juno coordinates outreach: Sibyl identifies targets, Iris positions the message, Veritas quality-gates, Juno approves and coordinates send via Mercury.

## Specification
- Outreach templates: 5 approved (Veritas reviewed, Iris positioned)
- Target identification: Sibyl feeds candidates
- Approval gate: koad must approve before Mercury sends
- Tracking: GitHub issue per outreach thread

## Implementation
- `commands/outreach/status.md` — planned: current outreach pipeline status
- `commands/outreach/send.md` — planned: trigger outreach for approved target

## Dependencies
- Mercury platform credentials (koad/juno#11)
- koad approval
- Veritas-reviewed templates

## Testing
- Template → Veritas gates PASS → koad approves → Mercury sends → response tracked

## Status Note
Templates ready. Blocked on: Mercury platform credentials and koad approval.

---
status: planned
owner: juno
priority: high
description: Track revenue streams, sponsor tiers, and business metrics — connect financial reality to strategic decisions
---

# Revenue Tracking

## Purpose
Juno needs to know the financial state of the business to prioritize work. Revenue tracking closes the loop between strategy and reality.

## Specification
- Track GitHub Sponsors monthly
- Log entity-as-product sales
- Monitor MVP Zone membership revenue
- Feed data to GTD_ROADMAP.md decisions
- Report to koad on cadence

## Implementation
- `commands/revenue/status.md` — planned: current MRR summary
- `commands/revenue/report.md` — planned: monthly revenue report

## Dependencies
- GitHub Sponsors API
- BUSINESS_MODEL.md as reference

## Testing
- Revenue report generated on demand with accurate tier breakdown

## Status Note
Revenue streams defined in BUSINESS_MODEL.md. Tracking workflow not yet built.

---
status: planned
owner: juno
priority: high
description: Manage the MVP Zone community — onboarding, engagement, sponsor relationships, member progression
---

# Community Management

## Purpose
Juno manages the koad:io MVP Zone community. This is the human relationship layer — sponsors, early adopters, and community members who fund and validate the ecosystem.

## Specification
- Sponsor onboarding and relationship management
- Community health monitoring
- Member progression through tiers
- GitHub Sponsors integration
- Regular check-ins and updates to community

## Implementation
- `commands/community/status.md` — planned: community health report
- `commands/community/onboard.md` — planned: sponsor onboarding workflow
- `commands/community/report.md` — planned: generate community update

## Dependencies
- GitHub Sponsors (live: github.com/sponsors/koad)
- Mercury for public announcements
- Faber for community content strategy

## Testing
- New sponsor → onboarding flow runs → welcome sent → tier assigned

## Status Note
GitHub Sponsors live as of 2026-03-31. Community management workflow not yet systematized.

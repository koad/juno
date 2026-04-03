---
status: complete
owner: juno
priority: critical
description: Deploy team entities for autonomous work sessions — invoke non-interactively or spawn interactive sessions
---

# Entity Deployment

## Purpose
Juno can wake any team entity, give it a task, and observe the output. This is the core operational capability that turns a team of entities into a running business.

## Specification
- Non-interactive: `juno invoke entity <name> "<task>"` — runs claude -p, sleeps 60s
- Interactive: `juno spawn process <name>` — opens terminal session
- Cascade environment loading per VESTA-SPEC-005

## Implementation
- `commands/invoke/entity/command.sh` — operational
- `commands/spawn/process/command.sh` — operational

## Dependencies
- VESTA-SPEC-005 (cascade environment)
- VESTA-SPEC-008 (spawn protocol)
- claude CLI installed

## Testing
- `juno invoke entity vulcan "check your open issues"` → Vulcan responds
- `juno spawn process mercury` → interactive session opens

## Status Note
Both commands operational as of 2026-04-03.

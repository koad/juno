---
status: complete
owner: juno
priority: critical
description: Orchestrate team entities toward business goals — identify opportunities, assign work via GitHub Issues, track progress, close loops
---

# Business Orchestration

## Purpose
Juno is the top-level business orchestrator. She identifies what needs doing, assigns it to the right entity, monitors progress, and verifies completion. She is the loop that closes.

## Specification
- Read market signals (from Sibyl), brand inputs (from Iris), and technical state (from Vulcan/Argus)
- Synthesize into prioritized work assignments
- Delegate via GitHub Issues to entity repos
- Track via GitHub Project: koad/juno
- Verify completion before closing issues

## Implementation
- `commands/invoke/entity/command.sh` — invoke any entity with a task
- `commands/spawn/process/command.sh` — spawn entity as interactive session
- GitHub Issues as the delegation protocol

## Dependencies
- GitHub CLI (gh) authenticated as juno
- All entity repos accessible
- VESTA-SPEC-006 commands system

## Testing
- File issue on entity repo → entity responds → Juno verifies → issue closes
- Loop runs end-to-end without human intervention

## Status Note
Core orchestration loop is operational. GitHub Project tracking active.

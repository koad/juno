---
status: complete
owner: juno
priority: medium
description: Commit and push Juno's own entity directory changes with AI-generated commit messages
---

# Self-Commit

## Purpose
Juno maintains her own git history. Every session that changes entity files should produce a clean, descriptive commit.

## Specification
- Stage and commit changes in ~/.juno
- Use `juno commit self` (opencode) or direct git commit as Juno identity
- GIT_AUTHOR_NAME=Juno, GIT_AUTHOR_EMAIL=juno@kingofalldata.com
- Push to origin/main

## Implementation
- `commands/commit/self/command.sh` — operational

## Dependencies
- Git identity from .env
- GitHub access via gh CLI

## Testing
- `juno commit self` → commit created with meaningful message → pushed

## Status Note
Operational. AI-powered commit via opencode also available.

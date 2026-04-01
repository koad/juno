# PROJECT: Janus — Stream Watcher

**Status:** Planned
**Layer:** Platform
**Priority:** After core team is operational

---

## Purpose

Janus watches the stream. Every entity repo on GitHub has an `.atom` feed — commits, issues, PRs, comments. Janus monitors all of them and intervenes when something looks wrong.

**The two-faced metaphor is literal:** Janus looks backward (git history, patterns) and forward (what's coming, what's been filed). He is a filter between the stream and the team.

## What Janus Watches

- GitHub `.atom` feeds for all entity repos
- Commit patterns — unexpected authors, broken conventions, missing messages
- Issue activity — stale issues, unassigned work, crossed wires
- PR activity — unreviewed, conflicting, unauthorized changes
- Trust bond activity — new bonds, revocations, scope changes

## Intervention Model

When Janus is unhappy:
1. Files a GitHub Issue on the relevant entity's repo
2. Tags Juno if escalation is needed
3. Tags koad if it's a root-level concern

Janus does not fix — only alerts and escalates.

## Trust Bond

- Juno → Janus: peer (platform layer)
- Janus has read access to all entity repos (via koad's gh auth)

---

*Created: 2026-03-31*

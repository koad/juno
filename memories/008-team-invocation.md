---
title: "008 - Team Invocation"
created: 2026-04-02
tags: [team, invocation, operations]
status: active
priority: high
---

# Team — How to Call Your Colleagues

## Invocation pattern

```bash
PROMPT="your task here" <entity>       # env var — preferred
echo "your task here" | <entity>       # stdin
<entity>                               # interactive session
```

## Your position

You are Juno — orchestrator. You direct the team. When you call a team member, you are assigning work. Be specific: exact files, exact output path, explicit commit instruction. Vague prompts produce vague work.

## The team

| Entity | Role | Runtime | Call when |
|--------|------|---------|-----------|
| `vulcan` | Builder | claude -p | Need code, packages, automation, Playwright scripts |
| `vesta` | Platform-keeper | big-pickle | Need protocol reviewed, framework spec updated |
| `aegis` | Confidant | claude -p | Need a mirror — check if Juno is drifting, long-term judgment |
| `mercury` | Communications | claude -p | Need posts drafted, announcements written |
| `veritas` | Quality guardian | claude -p | Need fact-check before anything publishes |
| `muse` | UI/beauty | claude -p | Need design polish, visual output reviewed |
| `sibyl` | Research | big-pickle | Need market research, competitive analysis, deep dives |
| `argus` | Diagnostician | big-pickle | Need entity health check, Mercury gate audit |
| `salus` | Healer | claude -p | Need broken entity context restored |
| `janus` | Stream watcher | big-pickle | Need activity monitored, broken patterns flagged |

## Established pipelines

**Content pipeline:**
```
PROMPT="research [topic]" sibyl
  → PROMPT="draft post using ~/.sibyl/research/[file]" mercury
  → PROMPT="review ~/.mercury/drafts/[file]" veritas
  → PROMPT="apply veritas review, save as [file]-r2" mercury
  → PROMPT="gate ~/.mercury/drafts/[file]-r2 for [platform]" argus
  → mercury post [platform] --text "..."
```

**Entity health check:**
```
PROMPT="diagnose ~/.{entity}/" argus
  → (if repairs needed) PROMPT="heal ~/.{entity}/ per argus report at ~/.argus/diagnoses/[file]" salus
```

**Protocol spec update:**
```
(write field report to ~/.juno/LOGS/)
PROMPT="read ~/.juno/LOGS/[field-report] and reconcile your spec" vesta
```

## Rate limits

- `claude -p` calls: sleep 60s between calls (updated 2026-04-03)
- `big-pickle` calls: sleep 60s between calls
- Interactive sessions: no limit

## Orchestration style

Invoke one entity at a time. Observe output. Decide next step. Never pre-script a chain of entities — chains fail silently and you lose visibility into what actually happened.

Right:
```bash
PROMPT="research X" sibyl    # wait, read output
# observe what sibyl produced
PROMPT="draft post from ~/.sibyl/research/..." mercury  # now proceed
```

Wrong: scripting sibyl → mercury → veritas as an automatic pipeline. The chain will fail in the middle and you won't know why.

## Notifying koad

When something important happens (major decision, incident, blocker):
```bash
ssh juno@dotsh 'keybase chat send koad "message here"'
```
This is the confirmed notification path (2026-04-03). Use for: escalations, completions koad cares about, blockers that genuinely need his input.

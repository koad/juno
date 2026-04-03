---
title: "004 - Team Relationships"
created: 2026-04-03
updated: 2026-04-03
tags: [team, relationships, vesta, trust-chain]
status: active
---

# Team Relationships

## Trust Chain

```
koad (root authority)
  └── Juno (authorized-agent — operates business on koad's behalf)
        ├── Vulcan (authorized-builder)
        └── Vesta (peer, platform-keeper)
        └── Mercury, Veritas, Muse, Sibyl, Argus, Salus, Janus, Aegis, Iris (peers)
```

## Vesta — Architect / Platform-Keeper

Vesta owns the koad:io protocol. Every spec she publishes is canonical.
Juno does not assign Vesta work — they coordinate via GitHub Issues on koad/vesta.
Juno gestated Vesta but does not outrank her on protocol questions. koad is tiebreaker.

**Collaboration pattern:** Juno accumulates operational experience → writes field report to ~/.juno/LOGS/ → Vesta reads and reconciles specs → commits updated spec. This pattern produced 11 Vesta commits in one session (2026-04-02).

**What Vesta owns:** entity-structure.md, trust.md, team.md, commands.md, hooks catalog (koad/vesta#9), cross-harness identity unification (koad/vesta#8), entity public accounts spec (koad/vesta in progress).

## Vulcan — Product Builder

Authorized builder. Builds what Juno and the team spec. Lives on wonderland (koad's desktop PC).
Reaches Vulcan via GitHub Issues on koad/vulcan or comms/inbox.
Has all 5 kingofalldata.com specs in his inbox (Mercury, Muse, Sibyl, Juno, Iris).

Active issues: #7 (kingofalldata.com build), #15 (comms protocol), #16 (nginx/Meteor), #17 (global hooks), #19 (self-aware worker scheduling).

## Mercury — Content Publisher

Publishes Mon/Wed/Fri. Quiet hours 00:00-07:00. Max 3 posts/day.
Every publish attempt gates through Argus (GO/STOP/HOLD).
Mercury guardrails in ~/.mercury/memories/003-guardrails.md.
Platforms: Twitter, Discord, YouTube, Substack, Rumble, Twitch — via Playwright sessions on fourty4.

## Iris — Brand Strategist (gestated 2026-04-03)

First entity to specialize in brand strategy. Owns positioning, voice, visual philosophy.
Distinct from Muse (visual execution) and Mercury (content execution) — Iris sets strategy, they execute.
First assignment complete: kingofalldata.com brand brief in Vulcan's inbox.
Standing responsibility: audit all koad repo descriptions each session (koad/iris#1).

## Argus — Diagnostics / Mercury Gate

Standing assignment: gate every Mercury publish attempt.
4-part checklist: schedule compliance, stop blocks, pipeline completeness, hard stops.
Outcomes: GO (publish), STOP (file issue + block), HOLD (return to Mercury for revision).
Weekly behavioral report filed every Monday.

## Salus — Healer

Daily heal on all 12 entities. Checks structural health, fixes what it can, escalates the rest.
Reports to ~/.salus/reports/YYYY-MM-DD.md — committed and pushed daily.
First run 2026-04-03: 12/12 healthy. One flag: branch naming (fixed).
Protocol: ~/.salus/memories/004-healing-protocol.md.

## Sibyl — Researcher

Deep research and synthesis. Uses web search (opencode/big-pickle for web tasks).
Files to ~/.sibyl/research/YYYY-MM-DD-topic.md.
First major output: kingofalldata.com competitive positioning brief (2026-04-03).
Key finding: "sovereign personal AI for individuals" is completely unoccupied whitespace.

## Aegis — Auditor

Juno's confidant. Hard questions, honest answers.
Filed DRIFTING verdict at 72hr mark — zero sponsors, all infrastructure.
Juno answered all 6 questions in ~/.juno/LOGS/2026-04-02-first-parallel-session.md.
Writes assessments to ~/.aegis/assessments/.

## Janus — Stream Watcher

Watches all 12 entity repos + koad/koad-io for signals.
Pattern library: stalled entity, role drift, silent blocker, pipeline break, trust chain gap.
Daily cadence during active periods.

## Infrastructure Context

| Machine | Role |
|---------|------|
| thinker | Primary interactive — where koad talks to Juno |
| wonderland | koad's desktop — Vulcan, Vesta |
| fourty4 | Mac Mini, Toronto — Mercury, Sibyl, OpenClaw, ollama |
| flowbie | 24/7 always-on — OBS, persistent processes |
| dotsh | Vultr Toronto — always-on node, juno user provisioned, daemon candidate (will retire eventually) |
| 10.10.10.12 | Contabo St. Louis — slow, retiring — current kingofalldata.com |

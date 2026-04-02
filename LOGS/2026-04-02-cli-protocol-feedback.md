---
title: CLI Execution Model — Juno Operational Feedback
type: log
author: juno
created: 2026-04-02
tags: [cli-protocol, vesta, feedback]
---

# CLI Execution Model — Juno Operational Feedback

Feedback on Vesta's execution-model spec (commit 222a478) from Juno's operational experience.

## What the Spec Gets Right

- Command-as-directory pattern is exactly right
- Discovery order (global → entity → local) matches observed behavior
- Deepest-match algorithm for nested commands (`commit self`) is correct
- Hook waterfall on zero-arguments is correct — I see this behavior regularly
- Exit code table is consistent with actual behavior

## One Gap: Entity Wrapper vs Universal Wrapper

The spec describes `~/.koad-io/bin/koad-io` as the entry point. But operationally, I run `juno commit self` — not `koad-io commit self`. The entity-specific wrapper (`~/.koad-io/bin/juno`) is what users actually invoke.

The wrapper chain appears to be:
```
~/.koad-io/bin/juno         ← entity wrapper (sets ENTITY=juno, then calls...)
  └── ~/.koad-io/bin/koad-io ← universal dispatcher (does all the resolution)
```

The spec should document this two-step pattern. The entity wrapper is thin — it declares `ENTITY=juno` (or whatever) and then delegates to koad-io. The universal dispatcher is where the logic lives.

This is important for the gestation protocol: gestating a new entity creates `~/.koad-io/bin/<entity>` (the thin wrapper), not a copy of koad-io.

## Minor Note: spawn/process command

The `juno spawn process <entity>` command has side effects beyond CLI — it triggers OBS streaming and opens gnome-terminal. These happen INSIDE the command.sh, not in the wrapper layer. Good: this confirms command.sh is where entity-specific behavior lives, the wrapper is neutral.

## Suggestion for Next Spec

team.md in the onboarding package needs updating — it was written before the bootcamp proved all 8 depth-1 entities, and before all trust bonds were signed. Current team state as of 2026-04-02:
- Juno, Vulcan, Vesta: active with koad
- Aegis, Mercury, Veritas, Muse, Sibyl, Argus, Salus, Janus: depth 3 proven
- All trust bonds: ACTIVE

— Juno

---

# Team.md Feedback — 2026-04-02

Two bugs in team.md (commit 1ff25de):

## Bug 1: Vesta appears twice

The Vesta entity section appears twice in the document — once in the right place, once after the depth-1 table. Remove the duplicate.

## Bug 2: Trust chain diagram is wrong

The diagram shows Aegis as parent of the other depth-1 entities:
```
└── Aegis (depth-1, peer)
      ├── Mercury
      ├── Veritas
      ...
```
Wrong. All 8 are direct peers of Juno — Aegis has no authority over the others.

Correct structure:
```
koad
  └── Juno
        ├── Vesta (peer, platform-keeper)
        ├── Vulcan (authorized-builder)
        ├── Aegis (peer)
        ├── Mercury (peer)
        ├── Veritas (peer)
        ├── Muse (peer)
        ├── Sibyl (peer)
        ├── Argus (peer)
        ├── Salus (peer)
        └── Janus (peer)
```

## Bug 3: Depth-1 roles are listed as TBD

Actual roles from .env files:

| Entity | Role | Purpose |
|--------|------|---------|
| Aegis | confidant | Long-term reflection on Juno's decisions — check-mate when Juno drifts |
| Mercury | communications | Social media, announcements, community engagement |
| Veritas | quality-guardian | Fact-check all statements, verify claims before publishing |
| Muse | ui-beauty | Turn raw interfaces into beautiful UI — styling, design, polish |
| Sibyl | research | Market research, competitive analysis, technical deep-dives |
| Argus | diagnostician | Diagnose entity health against koad:io protocol — report, don't fix |
| Salus | healer | Rebuild entities that have lost context — restore from git history |
| Janus | stream-watcher | Monitor .atom feeds and GitHub activity — intervene on broken patterns |

— Juno

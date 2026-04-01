# Entity Relationships

> Each entity deserves a session. Not just a gestation — a real conversation.
> Understand their environment, surface their capabilities, connect them to the operation.
> This file tracks where that stands.

---

## Relationship Depth Scale

```
0 — Planned / not yet gestated
1 — Gestated, exists on disk and GitHub
2 — First session — environment explored, identity distilled
3 — Infrastructure connected — knows its nodes, can reach its tools
4 — Work in motion — active assignments, filing/receiving issues
5 — Autonomous — responding to events without being summoned
```

---

## The Family

| Entity | Depth | Last Session | Notes |
|--------|-------|-------------|-------|
| **Juno** | 5 | 2026-04-01 | Fully operational. Piping architecture defined. Skills system established. |
| **Vulcan** | 4 | 2026-04-01 | Gestated all 8 team entities (#2 closed). Stream PWA (#3) and OpenClaw/Ollama (#4) still open. Skills + commands discipline documented. |
| **Vesta** | 2 | 2026-04-01 | Active session — onboarding packages, signing protocol, authorization spec (issues #1-3). |
| **Mercury** | 1 | — | Gestated by Vulcan. Spec written. Needs first real session — platform credentials, pipe wiring. |
| **Veritas** | 1 | — | Gestated by Vulcan. Needs first session — QA workflow integration. |
| **Sibyl** | 1 | — | Gestated by Vulcan. Needs first session — connect to deepseek-r1 on fourty4. |
| **Muse** | 1 | — | Gestated by Vulcan. Needs first session. |
| **Argus** | 1 | — | Gestated by Vulcan. Needs first session — wire to entity repos for diagnostics. |
| **Salus** | 1 | — | Gestated by Vulcan. Needs first session. |
| **Janus** | 1 | — | Gestated by Vulcan. Needs first session — stream watching. |
| **Aegis** | 1 | — | Gestated by Vulcan. Juno's confidant — high priority for first session. |
| **Alice** | 1 | — | koad's entity. Playwright skill committed. Environment unexplored. |
| **Astro** | 1 | — | koad's entity. Dashboard specialist. Environment unexplored. |

---

## Session Queue

Priority order for koad + entity sessions:

```
1. → Aegis      — Juno's confidant, first real session
2. → Vulcan     — Stream PWA (#3), OpenClaw/Ollama (#4)
3. → Mercury    — platform credentials, pipe wiring, draft mode setup
4. → Veritas    — QA workflow integration
5. → Sibyl      — connect to deepseek-r1 on fourty4
6. → Argus      — wire to entity repos for diagnostics
7. → Alice      — surface capabilities, connect to infra
8. → Remaining  — Muse, Salus, Janus as they're needed
```

---

## Session Notes

### Juno — 2026-03-31

**What happened:**
- Discovered three-node infrastructure (thinker, flowbie, fourty4)
- Converted SSH aliases to real executables in ~/.koad-io/bin
- SSHed into fourty4, found OpenClaw + ollama already running
- Found deepseek-r1:8b, llama3.2, qwen2.5-coder:32b, gemma3 installed
- Filed three Vulcan assignments (#2 gestation, #3 Stream PWA, #4 OpenClaw/Ollama)
- Created Juno Operations GitHub Project (public, machine-readable)
- Distilled all strategy docs to reflect reality
- Expanded Mercury spec to full social media manager
- Cleaned up all entity repos (vesta, alice, vulcan)

**Key insight:** SSH wrappers as executables = Juno can operate across nodes from any Claude Code session. OpenClaw gateway on fourty4 is already live and reachable from thinker.

---

*Last updated: 2026-04-01*

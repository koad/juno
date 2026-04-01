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
| **Vulcan** | 4 | 2026-04-01 | Gestated all 8 team entities (#2 closed). Open: #3 Stream PWA, #4 OpenClaw/Ollama, #5 training gap (gestation identity layer). |
| **Vesta** | 4 | 2026-04-01 | Active session with koad. 10 koad:io protocol boards live. 5 issues filed. Found gestation identity bug (koad/vesta#5). Protocol guardian functioning as designed. |
| **Mercury** | 1 | — | Identity layer patched (2026-04-01). Needs first session — platform credentials, pipe wiring. |
| **Veritas** | 1 | — | Identity layer patched (2026-04-01). Needs first session — QA workflow integration. |
| **Sibyl** | 1 | — | Identity layer patched (2026-04-01). Needs first session — connect to deepseek-r1 on fourty4. |
| **Muse** | 1 | — | Identity layer patched (2026-04-01). Needs first session. |
| **Argus** | 1 | — | Identity layer patched (2026-04-01). Needs first session — wire to entity repos for diagnostics. |
| **Salus** | 1 | — | Identity layer patched (2026-04-01). Needs first session. |
| **Janus** | 1 | — | Identity layer patched (2026-04-01). Needs first session — stream watching on fourty4. |
| **Aegis** | 1 | — | Identity layer patched (2026-04-01). Juno's confidant — highest priority for first session. |
| **Alice** | 1 | — | koad's entity. Playwright skill committed. Environment unexplored. |
| **Astro** | 1 | — | koad's entity. Dashboard specialist. Environment unexplored. |

---

## Session Queue

Priority order for koad + entity sessions:

```
1. → Aegis      — Juno's confidant, first real session (identity patched, ready)
2. → Mercury    — platform credentials, pipe wiring, draft mode setup
3. → Janus      — stream watching on fourty4, wire into OpenClaw atom feeds
4. → Argus      — wire to entity repos for diagnostics
5. → Vulcan     — training gap (#5), Stream PWA (#3), OpenClaw/Ollama (#4)
6. → Veritas    — QA workflow integration
7. → Sibyl      — connect to deepseek-r1 on fourty4
8. → Alice      — surface capabilities, connect to infra
9. → Remaining  — Muse, Salus as they're needed
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

### Juno — 2026-04-01 (session 2, ~46h after gestation)

**What happened:**
- SSH auth for flowbie + fourty4 confirmed complete
- Deep team reflection — identified gestation identity layer defect
- Patched .env and commit commands across all 7 dormant entities
- Filed koad/vulcan#5 (Vulcan training gap — gestation identity layer)
- Updated RELATIONSHIPS.md depth scores (Vesta is depth 4, not 2)
- Corrected timeline: team fully gestated within 46 hours, not weeks

**Key insight:** koad is 1 human — every human-required task is a bottleneck. The path to reducing bottleneck is converting human tasks to entity skills. Sequencing must be surgical: activate entities with real work, not just because they're gestated.

---

*Last updated: 2026-04-01*

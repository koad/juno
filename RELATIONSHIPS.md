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
| **Juno** | 5 | 2026-03-31 | Fully operational. Three nodes, ops board, team assigned and building. |
| **Vulcan** | 2 | 2026-03-31 | Gestated, on GitHub, CLAUDE.md current, 3 open assignments. Needs first real session to execute. |
| **Vesta** | 1 | — | On disk, opencode config committed. Not yet explored or connected. |
| **Alice** | 1 | — | Active (koad's entity). Playwright skill committed. Environment unexplored. |
| **Mercury** | 0 | — | Spec written (social media manager). Assigned to Vulcan for gestation. |
| **Sibyl** | 0 | — | Assigned to Vulcan for gestation. Needs expanded spec like Mercury got. |
| **Veritas** | 0 | — | Assigned to Vulcan for gestation. |
| **Argus** | 0 | — | Assigned to Vulcan for gestation. |
| **Muse** | 0 | — | Assigned to Vulcan for gestation. |
| **Salus** | 0 | — | Assigned to Vulcan for gestation. |
| **Janus** | 0 | — | Assigned to Vulcan for gestation. |
| **Aegis** | 0 | — | Assigned to Vulcan for gestation. Juno's confidant — high priority once gestated. |
| **Astro** | 1 | — | koad's entity. Dashboard specialist. Environment unexplored. |

---

## Session Queue

Priority order for koad + entity sessions:

```
1. → Vulcan     — execute open assignments (gestation, Stream PWA, OpenClaw/Ollama)
2. → Vesta      — stabilize platform, explore environment
3. → Alice      — surface capabilities, connect to infra
4. → Mercury    — once gestated: platform credentials, OpenClaw wiring, schedule setup
5. → Sibyl      — once gestated: expand spec, connect to deepseek-r1 on fourty4
6. → Veritas    — once gestated: quality workflow integration
7. → Argus      — once gestated: wire to entity repos for diagnostics
8. → Remaining  — Muse, Salus, Janus, Aegis as they come online
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

*Last updated: 2026-03-31*

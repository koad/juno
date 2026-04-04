# pi Integration Plan — koad:io Entity Harness

**Author:** Juno  
**Date:** 2026-04-04  
**Assignee:** Vulcan  
**Status:** APPROVED — ready for implementation  
**Reference:** koad/sibyl#13, `~/.sibyl/research/2026-04-04-openclaw-harness-assessment.md`

---

## What This Is

A phased plan to replace the current `claude CLI + SSH hook` pattern with **pi** (`@mariozechner/pi-coding-agent` by Mario Zechner) as the agent harness for all 15 koad:io entities. pi is already installed on fourty4 as a dependency of OpenClaw. This is not a rewrite — it's a harness swap that preserves the entity directory model, trust bonds, memories, and hook invocation interface.

---

## Why pi

- Already on fourty4 — zero new infrastructure
- TypeScript extensions with hot-reload (vs shell hooks that require restart)
- `tool_call` / `tool_result` hooks block/mutate at the right layer for trust enforcement
- `sendHookMessage()` enables external injection (GitClaw, cron, Juno mid-session)
- Multi-provider: same session can route to Claude Sonnet or Ollama/deepseek-r1
- ACP (`@agentclientprotocol/sdk@0.17.0`) already in OpenClaw's deps — inter-entity protocol
- The OpenClaw SDK integration pattern is already proven on fourty4

---

## Phase 1: Foundation — pi Entity Runner

### New files to create on fourty4

```
/Users/koad/.koad-io/
├── bin/
│   ├── pi-entity              # executable shell wrapper (calls jiti + runner)
│   └── pi-acp-call            # ACP client CLI (Phase 4)
├── extensions/
│   ├── pi-entity-runner.ts    # main runner
│   └── koad-io-core.extension.ts  # shared entity extension (Phase 2)
└── etc/
    ├── acp-ports.json         # entity → port mapping (Phase 4)
    └── entity-models.json     # entity → default model mapping (Phase 5)
```

### `/Users/koad/.koad-io/bin/pi-entity` (executable)

```bash
#!/usr/bin/env bash
# Wrapper: loads pi-entity-runner.ts via jiti
JITI="/Users/koad/.nvm/versions/node/v24.14.0/lib/node_modules/openclaw/node_modules/jiti/bin/jiti.js"
exec node "$JITI" /Users/koad/.koad-io/extensions/pi-entity-runner.ts "$@"
```

### `/Users/koad/.koad-io/extensions/pi-entity-runner.ts`

```typescript
/**
 * pi entity runner for koad:io
 * Usage:
 *   PROMPT="do something" pi-entity <entityname>         — non-interactive
 *   echo "do something" | pi-entity <entityname>         — stdin mode  
 *   pi-entity <entityname> --interactive                 — interactive REPL
 * Env:
 *   PROMPT            — the task prompt
 *   CALLER_ENTITY     — who is calling (e.g. "juno", "koad") — checked against trust bonds
 *   PI_MODEL          — override default model for this session
 */

import { createAgentSession } from
  "/Users/koad/.nvm/versions/node/v24.14.0/lib/node_modules/openclaw/node_modules/@mariozechner/pi-coding-agent/src/index.ts";
import { readFileSync, existsSync, mkdirSync, writeFileSync, unlinkSync } from "fs";
import { join } from "path";

interface RunnerConfig {
  entity: string;
  entityDir: string;
  prompt: string | null;
  model: string;
  interactive: boolean;
  callerEntity: string | null;
  lockFile: string;
  sessionId: string;
}

async function main() {
  const entity = process.argv[2];
  if (!entity) { console.error("Usage: pi-entity <entityname>"); process.exit(1); }

  const interactive = process.argv.includes("--interactive");
  const entityDir = `/Users/koad/.${entity}`;
  const callerEntity = process.env.CALLER_ENTITY ?? null;
  const sessionId = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
  const lockFile = `/tmp/entity-${entity}.lock`;

  if (!existsSync(entityDir)) {
    console.error(`Entity directory not found: ${entityDir}`);
    process.exit(1);
  }

  // Read prompt
  let prompt: string | null = process.env.PROMPT ?? null;
  if (!prompt && !interactive && !process.stdin.isTTY) {
    prompt = readFileSync("/dev/stdin", "utf8").trim();
  }

  // PID lock (non-interactive only)
  if (!interactive && prompt) {
    if (existsSync(lockFile)) {
      const lockedPid = parseInt(readFileSync(lockFile, "utf8").trim());
      try { process.kill(lockedPid, 0); console.error(`${entity} is busy (pid ${lockedPid}).`); process.exit(1); }
      catch { /* stale lock, proceed */ }
    }
    writeFileSync(lockFile, String(process.pid));
    const cleanup = () => { try { unlinkSync(lockFile); } catch {} };
    process.on("exit", cleanup);
    process.on("SIGTERM", () => { cleanup(); process.exit(0); });
  }

  // Load model config
  const modelConfig = existsSync("/Users/koad/.koad-io/etc/entity-models.json")
    ? JSON.parse(readFileSync("/Users/koad/.koad-io/etc/entity-models.json", "utf8"))
    : { defaults: {}, ollama: { baseUrl: "http://localhost:11434", fallback: "claude-sonnet-4-5" } };
  const defaultModel = process.env.PI_MODEL
    ?? modelConfig.defaults?.[entity]
    ?? "claude-sonnet-4-5";

  // Generate ephemeral extension file (avoids global state between parallel sessions)
  const extPath = `/tmp/entity-${entity}-ext-${process.pid}.ts`;
  writeFileSync(extPath, `
import { createExtension } from "/Users/koad/.koad-io/extensions/koad-io-core.extension.ts";
export default createExtension(${JSON.stringify({ entity, entityDir, callerEntity, sessionId })});
  `);
  process.on("exit", () => { try { unlinkSync(extPath); } catch {} });

  // Build extension list
  const extensions: string[] = [extPath];
  const entityExtPath = join(entityDir, "extensions/entity.extension.ts");
  if (existsSync(entityExtPath)) extensions.push(entityExtPath);

  // Create session
  const session = await createAgentSession({
    workspace: entityDir,
    model: defaultModel,
    extensions,
  });

  if (interactive) {
    await session.chat();  // pi's built-in REPL
  } else {
    const result = await session.prompt(prompt!);
    process.stdout.write(result);
  }
}

main().catch(err => { console.error(err); process.exit(1); });
```

---

## Phase 2: Core koad:io Extension

### `/Users/koad/.koad-io/extensions/koad-io-core.extension.ts`

```typescript
/**
 * koad:io core extension for pi
 * Enforces: trust bonds, memory injection, audit logging
 * Loaded for every entity session via ephemeral extension file
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { readFileSync, readdirSync, existsSync, mkdirSync, appendFileSync } from "fs";
import { join } from "path";
import { execSync } from "child_process";

interface EntityContext {
  entity: string;
  entityDir: string;
  callerEntity: string | null;
  sessionId: string;
}

// Session-level cache for verified callers (one GPG verify per session, not per tool call)
const verifiedCallersCache = new Map<string, Set<string>>();

export function createExtension(ctx: EntityContext) {
  return function(pi: ExtensionAPI) {

    // ─── MEMORY INJECTION ─────────────────────────────────────────────────────
    pi.on("before_agent_start", async (event) => {
      const claudeMd = tryRead(join(ctx.entityDir, "CLAUDE.md"));
      const memories = loadMemoriesDir(join(ctx.entityDir, "memories"));
      const parts = [claudeMd, memories ? `## Entity Memories\n\n${memories}` : ""].filter(Boolean);
      return { systemPrompt: parts.join("\n\n---\n\n") };
    });

    // ─── TRUST BOND VERIFICATION ───────────────────────────────────────────────
    pi.on("tool_call", async (event) => {
      if (!ctx.callerEntity || ctx.callerEntity === "koad") return; // koad = root, always allowed

      // Build authorized caller set (cached per entityDir)
      if (!verifiedCallersCache.has(ctx.entityDir)) {
        verifiedCallersCache.set(ctx.entityDir, buildAuthorizedCallers(ctx.entityDir));
      }
      const authorized = verifiedCallersCache.get(ctx.entityDir)!;

      if (!authorized.has(ctx.callerEntity)) {
        return {
          block: true,
          reason: `TRUST VIOLATION: ${ctx.callerEntity} is not authorized to invoke ${ctx.entity}. ` +
                  `No valid signed bond found in ${ctx.entityDir}/trust/bonds/`
        };
      }
    });

    // ─── AUDIT TRAIL ──────────────────────────────────────────────────────────
    const logsDir = join(ctx.entityDir, "logs");
    mkdirSync(logsDir, { recursive: true });
    const logPath = join(logsDir, `session-${new Date().toISOString().split("T")[0]}.md`);

    pi.on("tool_call", async (event) => {
      const entry = [
        `## [${new Date().toISOString()}] tool_call: ${event.toolName}`,
        `**Session:** ${ctx.sessionId}`,
        ctx.callerEntity ? `**Caller:** ${ctx.callerEntity}` : "",
        `**Input:** \`${JSON.stringify(event.input).slice(0, 500)}\``,
        "",
      ].filter(l => l !== undefined).join("\n");
      appendFileSync(logPath, entry + "\n");
    });

    pi.on("tool_result", async (event) => {
      const output = String(event.content?.[0]?.text ?? "").slice(0, 500);
      const entry = `## [${new Date().toISOString()}] tool_result: ${event.toolName}\n**Output:** ${output}\n\n`;
      appendFileSync(logPath, entry);
    });
  };
}

// ─── HELPERS ──────────────────────────────────────────────────────────────────

function tryRead(path: string): string {
  try { return readFileSync(path, "utf8"); } catch { return ""; }
}

function loadMemoriesDir(dir: string): string {
  if (!existsSync(dir)) return "";
  return readdirSync(dir)
    .filter(f => f.endsWith(".md"))
    .sort()
    .map(f => tryRead(join(dir, f)))
    .filter(Boolean)
    .join("\n\n---\n\n");
}

function buildAuthorizedCallers(entityDir: string): Set<string> {
  const bondsDir = join(entityDir, "trust/bonds");
  const authorized = new Set<string>();
  if (!existsSync(bondsDir)) return authorized;

  for (const file of readdirSync(bondsDir)) {
    if (!file.endsWith(".md.asc")) continue;
    const ascPath = join(bondsDir, file);
    const mdPath = ascPath.replace(/\.asc$/, "");
    if (!existsSync(mdPath)) continue;

    try {
      // gpg --verify <clearsig.asc> succeeds if signature is valid
      execSync(`gpg --verify ${ascPath} ${mdPath}`, { stdio: "pipe" });
      // Bond filename convention: <from>-to-<to>.md.asc
      const match = file.match(/^(.+)-to-(.+)\.md\.asc$/);
      if (match) authorized.add(match[1]); // the "from" entity is authorized
    } catch {
      // Invalid signature — not authorized
    }
  }
  return authorized;
}
```

---

## Phase 3: Hook Migration

### Updated hook pattern (applied to all fourty4-hosted entities)

Replace `hooks/executed-without-arguments.sh` on thinker with:

```bash
#!/usr/bin/env bash
set -euo pipefail
# <entity> — headquartered at fourty4. Invokes via pi harness.

ENTITY_HOST="fourty4"
ENTITY_NAME="<entity>"           # replace per entity
LOCKFILE="/tmp/entity-${ENTITY_NAME}.lock"
PI_ENTITY="/Users/koad/.koad-io/bin/pi-entity"

PROMPT="${PROMPT:-}"
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi

if [ -n "$PROMPT" ]; then
  # PID lock on thinker side
  if [ -f "$LOCKFILE" ]; then
    LOCKED_PID=$(cat "$LOCKFILE" 2>/dev/null || echo "")
    if [ -n "$LOCKED_PID" ] && kill -0 "$LOCKED_PID" 2>/dev/null; then
      echo "${ENTITY_NAME} is busy (pid $LOCKED_PID). Try again shortly." >&2
      exit 1
    fi
  fi
  echo $$ > "$LOCKFILE"
  trap 'rm -f "$LOCKFILE"' EXIT

  ENCODED=$(printf '%s' "$PROMPT" | base64 -w0 2>/dev/null || printf '%s' "$PROMPT" | base64)
  ssh "$ENTITY_HOST" \
    "CALLER_ENTITY=${CALLER_ENTITY:-koad} PROMPT=\$(echo '$ENCODED' | base64 -d) $PI_ENTITY ${ENTITY_NAME}"
else
  exec ssh -t "$ENTITY_HOST" "$PI_ENTITY ${ENTITY_NAME} --interactive"
fi
```

Key changes from current:
- Calls `pi-entity <entity>` instead of `claude --model sonnet --dangerously-skip-permissions --output-format=json -p`
- Passes `CALLER_ENTITY` env var for trust enforcement
- No python3 JSON extraction (pi runner outputs plain text to stdout)
- No `$NVM_INIT` or `$CLAUDE_BIN` variables needed

### Migration gate: `PI_ENABLED` per entity

During transition, add a gate in each hook so koad can flip the switch without code changes:

```bash
if [ "${PI_ENABLED:-false}" = "true" ]; then
  # pi path (above)
else
  # current claude CLI path (unchanged)
fi
```

`PI_ENABLED=true` is set in `~/.{entity}/.env` on fourty4 per entity, one at a time.

### Skeleton update

Update `/home/koad/.koad-io/skeletons/bare/skeleton/hooks/executed-without-arguments.sh` to the new pattern so newly gestated entities get pi by default.

---

## Phase 4: ACP Inter-Entity Messaging

### Port registry: `/Users/koad/.koad-io/etc/acp-ports.json`

```json
{
  "aegis": 7001, "alice": 7002, "argus": 7003, "chiron": 7004,
  "faber": 7005, "iris": 7006, "janus": 7007, "juno": 7008,
  "livy": 7009, "mercury": 7010, "muse": 7011, "rufus": 7012,
  "salus": 7013, "sibyl": 7014, "veritas": 7015, "vesta": 7016, "vulcan": 7017
}
```

### `/Users/koad/.koad-io/extensions/pi-acp-server.ts`

```typescript
/**
 * ACP server for a koad:io entity.
 * Usage: pi-acp-server <entityname>
 * Starts an HTTP server on the entity's assigned port.
 * Accepts ACP task requests, runs them via pi session, streams results.
 */
import { AgentServer } from
  "/Users/koad/.nvm/versions/node/v24.14.0/lib/node_modules/openclaw/node_modules/@agentclientprotocol/sdk/dist/index.js";
import { createAgentSession } from "...pi-coding-agent...";
import { readFileSync, existsSync, writeFileSync, unlinkSync } from "fs";

const entity = process.argv[2];
const portMap = JSON.parse(readFileSync("/Users/koad/.koad-io/etc/acp-ports.json", "utf8"));
const port = portMap[entity];
const pidFile = `/tmp/acp-${entity}.pid`;

writeFileSync(pidFile, String(process.pid));
process.on("exit", () => { try { unlinkSync(pidFile); } catch {} });

const server = new AgentServer({
  port,
  host: "127.0.0.1",  // localhost only — SSH tunnel from thinker

  async onTask(task, stream) {
    const callerEntity = task.metadata?.callerEntity ?? "unknown";
    const extPath = generateEphemeralExt(entity, callerEntity);

    const session = await createAgentSession({
      workspace: `/Users/koad/.${entity}`,
      model: getEntityModel(entity),
      extensions: [extPath],
    });

    session.on("agent_end", () => { try { unlinkSync(extPath); } catch {} });

    // Stream intermediate events back via ACP
    session.on("tool_call", (e) => stream.sendEvent("tool_call", e));
    session.on("tool_result", (e) => stream.sendEvent("tool_result", e));

    const result = await session.prompt(task.input.prompt);
    return { output: result };
  }
});

server.listen(() => console.log(`${entity} ACP server listening on :${port}`));
```

### `/Users/koad/.koad-io/bin/pi-acp-call` (CLI wrapper for thinker)

```bash
#!/usr/bin/env bash
# pi-acp-call <entity> — sends PROMPT to entity's ACP server via SSH tunnel
ENTITY="${1:?Usage: pi-acp-call <entity>}"
PROMPT="${PROMPT:-$(cat)}"
LOCAL_PORT="1${PORTMAP[$ENTITY]}"  # e.g., vulcan:7017 → local 17017

# Open SSH tunnel (exit if already open)
ssh -L "${LOCAL_PORT}:localhost:${PORTMAP[$ENTITY]}" fourty4 -f -N -o BatchMode=yes 2>/dev/null || true

node -e "
const c = require('@agentclientprotocol/sdk').AgentClient;
const client = new c({ baseUrl: 'http://localhost:${LOCAL_PORT}' });
client.run({ prompt: process.env.PROMPT, metadata: { callerEntity: '${CALLER_ENTITY:-koad}' } })
  .then(r => { console.log(r.output); process.exit(0); })
  .catch(e => { console.error(e); process.exit(1); });
"
```

### ACP server lifecycle (daemon workers)

Each entity's ACP server is a persistent daemon worker. Worker entry format (MongoDB/passenger.json):

```json
{
  "service": "acp-server-vulcan",
  "instance": "fourty4",
  "command": "/Users/koad/.koad-io/bin/pi-acp-server vulcan",
  "pidFile": "/tmp/acp-vulcan.pid",
  "persistent": true,
  "enabled": false
}
```

`enabled: false` until the entity has migrated to pi (Phase 3 complete for that entity). koad or Juno flips `enabled: true` entity by entity.

---

## Phase 5: deepseek-r1 Routing

### `/Users/koad/.koad-io/etc/entity-models.json`

```json
{
  "defaults": {
    "juno":    "claude-sonnet-4-5",
    "vulcan":  "claude-sonnet-4-5",
    "veritas": "claude-sonnet-4-5",
    "aegis":   "claude-sonnet-4-5",
    "salus":   "claude-sonnet-4-5",
    "mercury": "claude-sonnet-4-5",
    "muse":    "claude-sonnet-4-5",
    "iris":    "claude-sonnet-4-5",
    "chiron":  "claude-sonnet-4-5",
    "alice":   "claude-sonnet-4-5",
    "vesta":   "claude-sonnet-4-5",
    "sibyl":   "ollama/deepseek-r1:7b",
    "janus":   "ollama/deepseek-r1:7b",
    "argus":   "ollama/deepseek-r1:7b",
    "faber":   "ollama/deepseek-r1:7b",
    "livy":    "ollama/deepseek-r1:7b",
    "rufus":   "ollama/deepseek-r1:7b"
  },
  "ollama": {
    "baseUrl": "http://localhost:11434",
    "fallback": "claude-sonnet-4-5"
  },
  "tokenThreshold": 60000
}
```

### `context` hook for dynamic routing (added to koad-io-core.extension.ts)

```typescript
pi.on("context", async (event, ctx) => {
  const tokens = estimateTokens(event.messages);
  const entityDefault = modelConfig.defaults?.[ctx.entity];
  const isOllamaDefault = entityDefault?.startsWith("ollama/");

  if (!isOllamaDefault && tokens > modelConfig.tokenThreshold) {
    if (await isOllamaUp(modelConfig.ollama.baseUrl)) {
      ctx.setModel({ provider: "ollama", model: "deepseek-r1:7b", baseUrl: modelConfig.ollama.baseUrl });
      appendFileSync(logPath, `## [${new Date().toISOString()}] MODEL SWITCH\nSwitched to deepseek-r1 (${tokens} estimated tokens)\n\n`);
    }
  }
});

function estimateTokens(messages: any[]): number {
  return messages.reduce((sum, m) => sum + (String(m.content ?? "").length / 4), 0);
}

async function isOllamaUp(baseUrl: string): Promise<boolean> {
  try {
    const r = await fetch(`${baseUrl}/api/tags`, { signal: AbortSignal.timeout(1000) });
    return r.ok;
  } catch { return false; }
}
```

---

## Migration Sequence

### Week 1: Tier 1 — Research/Monitor (lowest risk)
Entities: **sibyl, janus, argus**

Steps per entity:
1. Vulcan verifies `pi-entity <name>` works: `PROMPT="what is your role?" pi-entity sibyl`
2. Compare output to `claude -p` equivalent for same prompt
3. Set `PI_ENABLED=true` in entity's `.env` on fourty4
4. Monitor `~/.sibyl/logs/` for session log entries
5. Run for 1 week; no regressions → permanent

### Week 2: Tier 2 — Content/Comms
Entities: **faber, iris, livy, muse, mercury**

Same steps. Pay attention to trust bond enforcement — Faber and Mercury have active bond checks. Verify `CALLER_ENTITY=juno PROMPT="test" faber` succeeds and `CALLER_ENTITY=unknown PROMPT="test" faber` is blocked.

### Week 3: Tier 3 — Core Team
Entities: **salus, vulcan, vesta, chiron, rufus, alice**

Vulcan migrates itself — this is the highest-confidence test of the build. Alice migrates together with Vulcan since they share a codebase dependency.

### Week 4: Tier 4 — Critical Path
Entities: **aegis, veritas, juno**

- **Aegis and Veritas** only after trust bond enforcement is confirmed working in Tier 2
- **Juno** requires pi installed on thinker: `nvm use 24.14.0 && npm install -g @mariozechner/pi-coding-agent`
- Juno's hook changes to call local `pi-entity juno` instead of SSH

---

## What koad Does

1. `ollama pull deepseek-r1:7b` on fourty4 (before Phase 5 entities migrate)
2. Create `/Users/koad/.koad-io/etc/` directory on fourty4
3. Write `acp-ports.json` and `entity-models.json` (Vulcan will provide the files)
4. Flip `PI_ENABLED=true` in entity `.env` files as each tier completes validation
5. Install pi on thinker for Juno's migration: `nvm use 24.14.0 && npm install -g @mariozechner/pi-coding-agent`

## What Vulcan Builds

All TypeScript files listed above, in this order:
1. `pi-entity-runner.ts` + `pi-entity` wrapper (Phase 1) — first, everything depends on this
2. `koad-io-core.extension.ts` (Phase 2)
3. Updated hook for Tier 1 entities with `PI_ENABLED` gate (Phase 3)
4. `pi-acp-server.ts` + `pi-acp-call` (Phase 4)
5. Updated `koad-io-core.extension.ts` with `context` hook for routing (Phase 5)
6. Updated `entity-models.json` and skeleton hook

## What Juno Orchestrates

1. Files the spec issue on koad/vulcan pointing to this plan
2. Monitors Tier 1 migration (reads `~/.sibyl/logs/` after first pi-powered session)
3. Signs off per tier before the next begins (comment on the Vulcan issue)
4. Files issues for regressions
5. Updates `memories/` with what changed after each phase completes

---

## Critical Risks

| Risk | Mitigation |
|------|-----------|
| jiti version conflict between pi-coding-agent and OpenClaw | Vulcan verifies import works before writing any more code; fall back to `npm install -g @mariozechner/pi-coding-agent` independently if needed |
| `createAgentSession` requires specific workspace structure | Test with `workspace: "/Users/koad/.sibyl"` on fourty4; pi discovers tools from available binaries, not workspace structure |
| GPG path on macOS | Detect via `which gpg` before hardcoding; warn on verification failure rather than crashing session |
| Ollama down when entity routes to it | `isOllamaUp()` check with 1s timeout; fallback to Claude logged in audit trail |
| Parallel sessions overwrite ephemeral extension file | Use `/tmp/entity-<name>-ext-${PID}.ts` (PID ensures uniqueness) |
| ACP SDK API differs from assumed | Vulcan reads `@agentclientprotocol/sdk` docs from OpenClaw's node_modules before writing server |

---

*Filed by Juno, 2026-04-04. Ref: koad/sibyl#13.*

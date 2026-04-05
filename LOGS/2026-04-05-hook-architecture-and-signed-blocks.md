# Session Log — 2026-04-05
## Hook Architecture + Signed Code Blocks

### What we did

**Hook system cleanup:**
- Wrote `~/.koad-io/hooks/PRIMER.md` — authoritative docs for both hooks
- Established `KOAD_IO_ENTITY_HARNESS` — `opencode` as framework default (free LLMs, try before buy), `claude` as explicit opt-in for team entities
- Renamed `REMOTE_CLAUDE_BIN` → `REMOTE_HARNESS_BIN`
- Fixed all team entities (vulcan, veritas, mercury, muse, sibyl, faber, alice) — config moved to `.env`, redundant custom hooks deleted
- Fixed `.env` bugs: `REMOTE_NVM_INIT` unquoted (was executing on source), `REMOTE_HARNESS_BIN` was a Linux path (broke on fourty4/macOS)
- Updated `hooks/README.md` and koad/io README Chain Reactions section (closed koad/io#8)
- Juno's hook: rejects non-interactive path (no remote prompts), `--dangerously-skip-permissions` on interactive

**Signed executable code blocks:**
- Juno's hook now carries a GPG clearsigned policy block in comment space
- Signed by `juno@kingofalldata.com`, verifiable offline
- Pattern: same content, multiple key formats (Ed25519/Nostr, ECDSA/Web3, GPG) — entity is born compatible via gestation key portfolio
- IPFS: content-addressed by nature, pin it and the CID is the policy
- Nostr/Bluesky: Ed25519 key already native format, no translation needed
- PR consensus: modifying a signed block requires entity votes; original publisher holds rebuttal/veto rights

**Issues filed:**
- koad/vesta#81 — full signed block spec (Vesta shipped VESTA-SPEC-033 same session)
- koad/janus#13 — merge gate implementation spec
- koad/mercury#22 — Nostr publishing pipeline
- koad/vulcan#54, #51, #50 — commented with framework commit refs

### Key decisions
- `opencode` is framework default; alice inherits it; team entities set `KOAD_IO_ENTITY_HARNESS=claude`
- Most entities don't need custom hooks — `.env` config is sufficient
- `.env` ships in git (no secrets); `.credentials` is gitignored
- Entity invocations must use `cd /tmp` first — CWD hook waterfall can fire wrong hook
- `REMOTE_HARNESS_BIN=claude` (name only, not path) — `REMOTE_NVM_INIT` sets PATH on remote

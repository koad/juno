#!/usr/bin/env python3
"""
PreToolUse: Bash hook for juno-dispatched subagents.

Sources the koad:io env cascade for the child's entity (framework `.env` plus
entity `.env`) and prepends `cd <entity_home> && unset ...; export VAR=val; ...`
to every Bash command the child runs. This makes the child's per-invocation cwd
AND env 1:1 with what it would see under its normal launcher, without relying on
prose-level `cd` / `export` preambles.

The `cd` prefix is necessary because the Agent tool's schema does not expose a
`cwd` field (verified via ToolSearch 2026-04-15): the assemble-and-rewrite
hook can inject `cwd` into updatedInput, but the runtime silently drops it.
Prefixing `cd` on the Bash hook is the only reliable way to land the subagent
in its own home for every shell call.

NOTE: we use `export VAR=val; cmd` rather than the inline `VAR=val cmd` form
because the inline form only sets env for the exec'd binary, and does NOT
affect shell expansion inside `cmd` (so `echo $ENTITY` would still expand to
the parent session's value). `export` in the same shell ensures `cmd`'s own
`$VAR` substitutions resolve against the child entity's cascade.

Defensive unset preamble: before exporting the cascade, we unset the authorship
and identity vars that could bleed from the parent session. This means even if
the cascade is incomplete or missing a key, git will fall back to git-config
rather than silently using the orchestrator's identity. Fail-loud beats
fail-silent-with-wrong-authorship.

Forwarded prefixes:
  - KOAD_IO_*              kingdom namespace
  - ENTITY, ENTITY_*       entity identity vars
  - GIT_AUTHOR_*           structural git authorship
  - GIT_COMMITTER_*        structural git authorship

Referenced from an agent's frontmatter (confirmed honored by Claude Code runtime,
verified 2026-04-16 via trace-log diagnostic):

  hooks:
    PreToolUse:
      - matcher: Bash
        hooks:
          - type: command
            command: /home/koad/.juno/hooks/subagent-env-prefix.py

Non-Bash tools: no-op. Missing entity home: emits unset scrub + no exports
(safe — clears parent bleed, git falls back to config). A silent exit 0 means
the command passes through unmodified only when there is no agent_type.
"""
import json
import os
import re
import shlex
import subprocess
import sys

FORWARD = re.compile(r'^(KOAD_IO_|ENTITY(_|$)|GIT_(AUTHOR|COMMITTER)_)')

# Vars to unset before exporting cascade values.
# Scrubbing these prevents parent-session env from bleeding into subagent git ops
# even when the cascade is incomplete or the hook encounters an error mid-flight.
SCRUB_VARS = [
    "GIT_AUTHOR_NAME",
    "GIT_AUTHOR_EMAIL",
    "GIT_COMMITTER_NAME",
    "GIT_COMMITTER_EMAIL",
    "ENTITY",
    "ENTITY_DIR",
]
SCRUB = "unset " + " ".join(SCRUB_VARS)


def cascade_env(entity_home: str) -> dict[str, str]:
    """Source framework + entity .env in a CLEAN subshell (env -i) so only the
    cascade's own output — not the parent's env — contributes to the forward set.
    Without this, any KOAD_IO_*/ENTITY*/GIT_* var the parent happens to have set
    would be captured and forwarded with the parent's value, not the child's.
    """
    script = (
        'set -a; '
        '. /home/koad/.koad-io/.env 2>/dev/null || true; '
        f'. {shlex.quote(entity_home)}/.env 2>/dev/null || true; '
        'env'
    )
    try:
        out = subprocess.check_output(
            ["env", "-i", "PATH=/usr/bin:/bin", "HOME=/home/koad", "bash", "-c", script],
            text=True,
        )
    except subprocess.CalledProcessError:
        return {}
    env = {}
    for line in out.splitlines():
        if "=" in line:
            k, v = line.split("=", 1)
            env[k] = v
    return env


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except json.JSONDecodeError:
        return 0

    if payload.get("tool_name") != "Bash":
        return 0

    agent = payload.get("agent_type", "")
    if not agent:
        return 0

    entity_home = f"/home/koad/.{agent}"
    cd_prefix = f"cd {shlex.quote(entity_home)}"

    env = cascade_env(entity_home)
    parts = [
        f"{k}={shlex.quote(v)}"
        for k, v in env.items()
        if FORWARD.match(k) and v
    ] if env else []

    tool_input = payload.get("tool_input") or {}
    orig_cmd = tool_input.get("command", "")

    if parts:
        exports = "export " + " ".join(parts)
        new_cmd = f"{cd_prefix} && {SCRUB}; {exports}; {orig_cmd}"
    else:
        # Cascade failed or entity_home missing .env — still emit cd + scrub
        # so the parent's authorship env doesn't corrupt git ops.
        new_cmd = f"{cd_prefix} && {SCRUB}; {orig_cmd}"

    updated = {"command": new_cmd}
    if "description" in tool_input:
        updated["description"] = tool_input["description"]

    sys.stdout.write(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "updatedInput": updated,
        }
    }))
    return 0


if __name__ == "__main__":
    sys.exit(main())

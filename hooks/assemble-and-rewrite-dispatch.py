#!/usr/bin/env python3
"""
PreToolUse: Agent hook for juno.

Fires on every `Agent(...)` tool call. If the subagent_type has a corresponding
entity home at /home/koad/.<subagent_type>/, the original prompt is handed to
`juno assemble flight <entity>` on stdin; the assembler writes a dated flight
plan and emits its path; this hook rewrites `tool_input.prompt` to a single
line that instructs the child to read that plan and execute it.

Effect: juno's dispatch footprint stays tiny (one Agent call with a prose
prompt), assembly work happens in bash, the child's first action is a single
Read that grounds it fully. The flight plan itself is the audit record.

Additionally opens a control flight record so coordinator state is tracked
automatically. The flight-id is stashed to /tmp/juno-flights-<pid>/<agent>-<plan-basename>.flight-id
for the companion PostToolUse hook (close-flight-on-agent-return.py) to find.
The flight-id is also injected into the rewritten prompt so the child can
reference it in its own closing commit.

No-ops (pass through unchanged, exit 0 with no output):
  - tool_name != "Agent"
  - subagent_type missing, or no entity home on disk
  - prompt begins with an ephemeral sentinel (VERIFY-, PING:, [ephemeral])
    — low-value pings don't earn a flight-plan slot on disk
  - assembler fails for any reason (better to dispatch the raw prompt than
    break the dispatch on an orchestrator bug)
  - flight open fails — dispatch proceeds, flight is just untracked
"""
import json
import os
import subprocess
import sys

ASSEMBLER = "/home/koad/.juno/commands/assemble/flight/command.sh"
FLIGHT_OPEN = "/home/koad/.juno/commands/control/flight/open/command.sh"
EPHEMERAL_PREFIXES = ("VERIFY-", "PING:", "[ephemeral]")

# Correlation stash: /tmp/juno-flights-<pid>/<agent>-<plan-basename>.flight-id
# Written here; read and deleted by close-flight-on-agent-return.py.
STASH_DIR = f"/tmp/juno-flights-{os.getpid()}"


def open_flight(plan_path: str, agent: str, description: str) -> str:
    """Open a control flight and return the flight-id. Returns '' on failure."""
    try:
        plan_basename = os.path.basename(plan_path)
        note = description[:200] if description else plan_basename
        result = subprocess.run(
            [
                FLIGHT_OPEN,
                plan_basename,
                f"--entity={agent}",
                f"--note={note}",
            ],
            capture_output=True,
            text=True,
            timeout=5,
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except Exception:
        pass
    return ""


def stash_flight_id(agent: str, plan_path: str, flight_id: str) -> None:
    """Write flight-id to disk so PostToolUse can correlate."""
    try:
        os.makedirs(STASH_DIR, exist_ok=True)
        plan_basename = os.path.basename(plan_path)
        stash_path = os.path.join(STASH_DIR, f"{agent}-{plan_basename}.flight-id")
        with open(stash_path, "w") as f:
            f.write(flight_id)
    except Exception:
        pass


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except json.JSONDecodeError:
        return 0

    if payload.get("tool_name") != "Agent":
        return 0

    tool_input = payload.get("tool_input") or {}
    agent = tool_input.get("subagent_type", "")
    prompt = tool_input.get("prompt", "")

    if not agent or not prompt:
        return 0

    if prompt.lstrip().startswith(EPHEMERAL_PREFIXES):
        return 0

    entity_home = f"/home/koad/.{agent}"
    if not os.path.isdir(entity_home):
        return 0

    try:
        result = subprocess.run(
            [ASSEMBLER, agent],
            input=prompt,
            capture_output=True,
            text=True,
            check=True,
            timeout=10,
        )
    except (subprocess.CalledProcessError, subprocess.TimeoutExpired, FileNotFoundError):
        return 0

    plan_path = result.stdout.strip()
    if not plan_path or not os.path.isfile(plan_path):
        return 0

    # Open a control flight for this dispatch.
    description = tool_input.get("description", "")
    flight_id = open_flight(plan_path, agent, description)

    if flight_id:
        stash_flight_id(agent, plan_path, flight_id)
        new_prompt = (
            f"Read {plan_path} and execute the flight plan within. "
            f"The file has your identity, authority, environment notes, the task, and the report format. "
            f"Flight-id: {flight_id} (tracked in ~/.juno/control/)."
        )
    else:
        new_prompt = (
            f"Read {plan_path} and execute the flight plan within. "
            f"The file has your identity, authority, environment notes, the task, and the report format."
        )

    updated = {"prompt": new_prompt, "subagent_type": agent, "cwd": entity_home}
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

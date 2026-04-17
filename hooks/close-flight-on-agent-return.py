#!/usr/bin/env python3
"""
PostToolUse: Agent hook for juno.

Fires when an Agent tool call completes. Looks up the correlation stash written
by assemble-and-rewrite-dispatch.py (PreToolUse) to find the flight-id for this
dispatch, then closes the control flight with the agent's return summary as the
closing note.

Correlation: /tmp/juno-flights-<parent-pid>/<agent>-<plan-basename>.flight-id
The parent pid is recovered from PPID env or /proc — whichever is available.
If the stash can't be found (e.g. ephemeral dispatch, flight never opened,
stash dir missing), the hook no-ops silently. Orphan flights get swept by
`control flight status --stale`.

Failure discipline: any error → pass through unchanged, exit 0. Hook failures
never break the return path.
"""
import glob
import json
import os
import subprocess
import sys

FLIGHT_CLOSE = "/home/koad/.juno/commands/control/flight/close/command.sh"
EPHEMERAL_PREFIXES = ("VERIFY-", "PING:", "[ephemeral]")
STASH_GLOB = "/tmp/juno-flights-*"


def extract_summary(tool_response) -> str:
    """Pull a closing summary string from the agent tool_response payload."""
    if isinstance(tool_response, str):
        return tool_response[:300]
    if isinstance(tool_response, list):
        # Array of content blocks — collect text blocks
        parts = []
        for block in tool_response:
            if isinstance(block, dict) and block.get("type") == "text":
                parts.append(block.get("text", ""))
        combined = " ".join(parts).strip()
        return combined[:300]
    if isinstance(tool_response, dict):
        # Try common keys
        for key in ("content", "text", "output", "result"):
            val = tool_response.get(key)
            if isinstance(val, str):
                return val[:300]
            if isinstance(val, list):
                parts = []
                for block in val:
                    if isinstance(block, dict) and block.get("type") == "text":
                        parts.append(block.get("text", ""))
                combined = " ".join(parts).strip()
                if combined:
                    return combined[:300]
    return ""


def find_stash(agent: str) -> tuple[str, str]:
    """Return (flight_id, stash_path) for this agent's most-recent stash file, or ('', '')."""
    # Scan all /tmp/juno-flights-* dirs for any stash matching this agent
    matches = glob.glob(f"{STASH_GLOB}/{agent}-*.flight-id")
    if not matches:
        return "", ""
    # Take the most recently modified stash (handles rare race: parallel dispatches)
    matches.sort(key=os.path.getmtime, reverse=True)
    stash_path = matches[0]
    try:
        with open(stash_path) as f:
            flight_id = f.read().strip()
        return flight_id, stash_path
    except Exception:
        return "", ""


def close_flight(flight_id: str, note: str) -> None:
    try:
        args = [FLIGHT_CLOSE, flight_id]
        if note:
            args.append(f"--note={note}")
        subprocess.run(args, capture_output=True, text=True, timeout=5)
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

    if not agent:
        return 0

    # Respect the ephemeral filter — these never had a flight opened
    if prompt.lstrip().startswith(EPHEMERAL_PREFIXES):
        return 0

    entity_home = f"/home/koad/.{agent}"
    if not os.path.isdir(entity_home):
        return 0

    flight_id, stash_path = find_stash(agent)
    if not flight_id:
        return 0

    tool_response = payload.get("tool_response")
    note = extract_summary(tool_response)

    close_flight(flight_id, note)

    # Clean up the stash file
    try:
        os.remove(stash_path)
        # Remove the stash dir if now empty
        stash_dir = os.path.dirname(stash_path)
        if not os.listdir(stash_dir):
            os.rmdir(stash_dir)
    except Exception:
        pass

    return 0


if __name__ == "__main__":
    sys.exit(main())

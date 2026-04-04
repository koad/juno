---
name: Chain sleeps pattern
description: koad prefers chaining entity invocations with sleeps between them over loop scripts
type: feedback
---

When deploying multiple entities sequentially, use simple chained invocations with sleeps — not a loop script.

**Why:** Output streams to the terminal in real time — koad can watch each entity work as it happens. Loop scripts hide output (goes to log files or gets swallowed). The chain approach is also simpler with no complex loop state. `juno invoke entity` already does `cd ~/.$entity && claude --dangerously-skip-permissions -p "..." && sleep 120`.

**How to apply:** Suggest patterns like:
```bash
juno invoke entity salus "work on open issues" && \
juno invoke entity argus "run health check" && \
juno invoke entity sibyl "research sponsor landscape"
```

Or directly with `juno spawn process`:
```bash
juno spawn process salus "work on open issues"
sleep 60
juno spawn process argus "run health check"
```

Don't suggest loop scripts, /loop skill, or poll-and-repeat patterns. Chain sleeps and operate claude from entity folders.

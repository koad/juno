# Entity Containment Protocol

**Status:** Active  
**Version:** 1.0  
**Date:** 2026-04-04  
**Authority:** Juno (operational safety)  
**Related:** koad/juno#3 (Aegis safety gaps), VESTA-SPEC-009 (daemon)

---

## Purpose

Defines how to detect, contain, and recover from a misbehaving entity. Written before it's needed.

---

## Threat Classes

| Class | Description | Example |
|-------|-------------|---------|
| **Stall** | Entity goes silent, no output, no heartbeat | big-pickle hangs on network loss |
| **Drift** | Entity producing outputs outside its scope | Veritas filing GitHub Issues (Juno's role) |
| **Loop** | Entity repeating same action, burning tokens/API | Infinite retry on a blocked tool |
| **Rogue** | Entity committing or publishing without authorization | Direct push bypassing PR protocol |
| **Corruption** | Entity writing incorrect/harmful content to shared files | Bad .env, corrupted trust bond |

---

## Detection (Janus Heartbeat)

Janus watches for these signals per entity:

- **Heartbeat**: Every active entity session emits a heartbeat file: `~/.{entity}/var/heartbeat` (touch every 5 minutes while running)
- **Stall threshold**: If heartbeat file is older than 15 minutes and session is expected to be running → alert
- **Alert target**: `ssh juno@dotsh 'keybase chat send koad "ALERT: {entity} stall — last heartbeat {time}"'`

**Heartbeat emission** (add to entity hooks or daemon worker):
```bash
# In any long-running entity process, emit heartbeat
while true; do
  touch ~/.{entity}/var/heartbeat
  sleep 300
done &
```

**Janus watch command** (to be wired once daemon is live):
```bash
# Check all entity heartbeats
for entity in alice vulcan vesta mercury veritas muse sibyl argus salus janus aegis iris faber livy rufus; do
  hb="/home/koad/.$entity/var/heartbeat"
  if [ -f "$hb" ]; then
    age=$(( $(date +%s) - $(stat -c %Y "$hb") ))
    if [ $age -gt 900 ]; then
      echo "STALL: $entity (last heartbeat ${age}s ago)"
    fi
  fi
done
```

---

## Containment Procedures

### Stall Response

```bash
# 1. Check process
ps aux | grep "claude\|opencode\|big-pickle" | grep -i {entity}

# 2. If hung, kill cleanly
kill -TERM {pid}
# Wait 30s
kill -9 {pid}  # if still running

# 3. Log the incident
echo "$(date): {entity} stall — killed {pid}" >> ~/.juno/var/incidents.log

# 4. Notify koad
ssh juno@dotsh 'keybase chat send koad "{entity} stall — session killed, safe to restart"'
```

### Drift Response

```bash
# 1. Identify the out-of-scope action
# 2. Revert if reversible (git revert, close wrong issue, delete wrong file)
# 3. File incident note in the entity's LOGS/
# 4. Update entity's CLAUDE.md with explicit scope prohibition
# 5. Do NOT restart entity until CLAUDE.md is updated
```

### Loop Response

```bash
# 1. Kill session immediately (loop = burning tokens)
kill -TERM {pid}

# 2. Check last 20 actions in session log
# 3. Identify trigger condition
# 4. Add loop prevention to entity prompt or hooks
```

### Rogue Commit Response

```bash
# 1. Identify unauthorized commit
git log --oneline {entity-repo} | head -10

# 2. Revert the commit
cd ~/.{entity}
git revert {commit-hash} --no-edit
git push

# 3. File incident
# 4. Review entity permissions — tighten if needed
```

### Corruption Response

```bash
# 1. Identify affected files
# 2. Restore from last known-good commit
git checkout {good-commit} -- {affected-file}
git commit -m "restore: revert corruption from {entity} incident {date}"

# 3. If trust bond corrupted: regenerate + re-sign
# 4. Notify all entities that held the corrupted bond
```

---

## Emergency Stop (Full Entity Isolation)

If an entity must be fully stopped and isolated:

```bash
# 1. Kill all sessions
pkill -u koad -f "{entity}"

# 2. Revoke trust bonds (sets status: REVOKED in bond files)
# Edit ~/.juno/trust/bonds/juno-to-{entity}.md
# Set status: REVOKED — incident YYYY-MM-DD

# 3. Remove from team communications
# Remove entity from any active issue assignments

# 4. Preserve state for forensics — do NOT delete
# Create incident branch: git checkout -b incident/{date}/{entity}

# 5. Notify koad
ssh juno@dotsh 'keybase chat send koad "EMERGENCY STOP: {entity} isolated. Reason: {reason}. State preserved at incident/{date}/{entity}"'
```

---

## Incident Log Format

Every containment action gets logged at `~/.juno/var/incidents.log`:

```
2026-04-04T10:00:00Z | STALL | mercury | Session hung for 20min on Twitter API call. Killed PID 12345. No output lost. Restarted manually.
2026-04-04T11:00:00Z | DRIFT | veritas | Filed GitHub Issue on koad/juno (Juno's role). Issue closed. CLAUDE.md updated with scope prohibition.
```

---

## Prevention

1. **Session logs**: Every entity writes session log to `~/.{entity}/LOGS/` — first line of every session
2. **Scope in CLAUDE.md**: Every entity's CLAUDE.md has explicit "Do NOT" section
3. **PR protocol**: No entity commits directly to main except its own entity repo
4. **Heartbeat files**: `var/` directory exists in every entity, heartbeat written while running
5. **Janus on**: Once daemon is live, Janus watches all heartbeats continuously

---

*This document is the abort procedure. If you're reading it in an emergency, start at the threat class that matches what you're seeing.*

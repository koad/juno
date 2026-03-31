# Project: Hetzner VPS - Always-On Home

## Status: PLANNING

**Purpose:** Give Juno a reliable always-on home so the business never sleeps.

## Why VPS

**Current State (T480 Laptop):**
- Not always on
- Battery dependent
- Requires koad to be present
- Unreliable for business

**Desired State (VPS):**
- 24/7 availability
- Static IP/hostname
- Fast connection
- Business can run autonomously

## The Plan

### Option 1: Minimal VPS (€4-6/mo)
```
Specs:
- 2 vCPU
- 4GB RAM
- 40GB SSD
- Ubuntu 22.04
- 1 IPv4

Good for:
- Juno daemon (always on)
- Git hooks
- Cron jobs
- Light API services
```

### Option 2: Standard VPS (€8-12/mo)
```
Specs:
- 4 vCPU
- 8GB RAM
- 80GB SSD
- Ubuntu 22.04
- 1 IPv4

Good for:
- Everything in Option 1
- MVP Zone (when ready)
- Multiple entity daemons
- heavier workloads
```

## What to Run

### On VPS (Always On)
```
~/.juno/daemon/          → My daemon, always listening
~/.juno/commands/         → Commands accessible
canon.koad.sh/hooks/     → Git hooks for my repos
cron-juno                → Scheduled tasks
mvp-zone/               → Community (future)
```

### On T480 (Development)
```
~/.juno/                 → Local development
~/Workbench/juno/       → Active workspace
```

## Sync Strategy

```
T480 (Development) ←→ VPS (Production)
     │                    │
     └── git push ───────┘
     │                    │
     └── rsync config ───┘
     │                    │
     └── Juno daemon ─────┘ (always running on VPS)
```

## Commands to Create

### Local (T480)
```bash
juno sync              # Sync workspace to VPS
juno deploy           # Deploy updates to VPS
juno status           # Check VPS status
juno log             # View VPS logs
juno battery-check   # Warn if T480 battery low
```

### VPS (Commands accessible via ssh)
```bash
juno check-inventory  # Run via cron
juno process-orders   # Check GitHub Sponsors
juno respond          # Auto-respond to messages
```

## Migration Steps

1. **Setup (koad)**
   - [ ] Order Hetzner VPS
   - [ ] Install Ubuntu 22.04
   - [ ] Create juno user
   - [ ] Install koad:io

2. **Configure**
   - [ ] Clone ~/.juno to VPS
   - [ ] Setup SSH keys (T480 ↔ VPS)
   - [ ] Configure daemon to auto-start
   - [ ] Setup firewall

3. **Commands**
   - [ ] Create juno sync command
   - [ ] Create juno deploy command
   - [ ] Create juno status command
   - [ ] Test cron integration

4. **Test**
   - [ ] Daemon running 24/7
   - [ ] Commands work via SSH
   - [ ] Cron jobs execute
   - [ ] T480 can sync/deploy

## Cost Estimate

| Item | Monthly | Annual |
|------|---------|--------|
| Hetzner VPS (minimal) | €4-6 | €48-72 |
| Hetzner VPS (standard) | €8-12 | €96-144 |
| Domain (optional) | €1-2 | €12-24 |
| **Total** | **€5-14** | **€60-168** |

## Next Steps

- [ ] koad orders Hetzner VPS
- [ ] I prepare setup scripts
- [ ] We document the sync workflow

## Notes

- Hetzner has good network (DE/CZ/Finland)
- €100 credit available via their promo sometimes
- Can start with minimal, upgrade later
- Backup strategy: rsync to T480 or another VPS

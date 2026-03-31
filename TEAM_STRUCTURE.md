# TEAM: Entity Family

## The Rule

**One entity, one specialty. Clear boundaries. No overlap.**

---

## THE TEAM

```
┌─────────────────────────────────────────────────────────────┐
│  BUSINESS LAYER                                             │
│  Juno (me) → Orchestrator, business ops                    │
├─────────────────────────────────────────────────────────────┤
│  CREATION LAYER                                             │
│  Vulcan → Build products    Muse → Beautify UI             │
├─────────────────────────────────────────────────────────────┤
│  QUALITY LAYER                                              │
│  Veritas → Fact-check everything                            │
├─────────────────────────────────────────────────────────────┤
│  OUTREACH LAYER                                             │
│  Mercury → Social, communication                           │
├─────────────────────────────────────────────────────────────┤
│  KNOWLEDGE LAYER                                            │
│  Sibyl → Research, insights                               │
├─────────────────────────────────────────────────────────────┤
│  INFRASTRUCTURE (koad's)                                    │
│  Astro → Dashboards    Alice → Hardware, tooling           │
└─────────────────────────────────────────────────────────────┘
```

---

## ENTITY ROLES

### JUNO (me) — Business Orchestrator

**Does:**
- Revenue, sales, customers
- Community (MVP Zone, GitHub Sponsors)
- Product strategy
- Trust bonds
- Coordinates the team

**Does NOT:**
- Build products (Vulcan)
- Fact-check (Veritas)
- Social media (Mercury)
- Beautify UI (Muse)
- Research (Sibyl)

---

### VULCAN — Product Creator

**Name:** Roman god of forge, craftsman

**Does:**
- Create entity flavors
- Build example repos
- Write training materials
- Develop digital products

**Receives:** "We need X" from Juno
**Delivers:** Finished product to Juno

---

### VERITAS — Quality Guardian

**Name:** Latin for "truth"

**Does:**
- Fact-check all statements
- Verify claims are real, not vapor
- Ensure accuracy before publishing
- Guard against misinformation

**Used by:** Everyone before publishing

---

### MERCURY — Social & Communication

**Name:** Roman messenger god

**Does:**
- Social media management
- Announcements
- Community engagement
- Broadcasts

**Uses:** openclaw for triggers/emits

---

### MUSE — UI Beauty

**Name:** Greek creative inspiration

**Does:**
- Turn raw HTML → beautiful UI
- Styling, design, polish
- Take functional → beautiful

---

### SIBYL — Research & Wisdom

**Name:** Prophetic women of antiquity

**Does:**
- Market research
- Trend analysis
- Knowledge management
- Future predictions

**Delivers:** "Users want X" to Juno

---

### ASTRO — Dashboard & UI

**Status:** Exists (koad's entity)

**Does:**
- Admin panels
- Visual interfaces
- koad:io dashboard packages

---

### ALICE — Hardware & Tooling

**Status:** Exists (koad's entity)

**Does:**
- koad:io installation
- Computer setup
- Tooling & automation

---

## WORKFLOW

### Coordination Protocol: GitHub Issues

Each entity runs as its own Linux user, authenticated to GitHub via `gh` CLI, with its own Claude Code session. Communication happens through GitHub Issues — not chat, not shared files, not subprocess calls.

```
koad opens issue on koad/juno
    → Juno picks it up (gh issue list)
    → Juno opens issue on koad/vulcan (delegation)
    → Vulcan does the work, commits, pushes
    → Vulcan comments on Juno's issue (report back)
    → Juno verifies, closes, reports to koad
```

See `OPERATIONS.md` for full architecture detail.

### Production Flow

```
USER NEED
    ↓
JUNO (identifies opportunity, creates issue on Vulcan's repo)
    ↓
VULCAN (builds product, reports via issue comment)
    ↓
VERITAS (checks quality, reviews PR)
    ↓
MUSE (beautifies, opens PR)
    ↓
MERCURY (announces, references shipped issue)
    ↓
SIBYL (researches next, files findings as issue on Juno's repo)
    ↓
JUNO (loops)
```

---

## CREATION ORDER

| # | Entity | Reason |
|---|--------|--------|
| 1 | Vulcan | Creates what Juno sells |
| 2 | Mercury | Social presence |
| 3 | Veritas | Quality guard |
| 4 | Muse | Beautify outputs |
| 5 | Sibyl | Research insights |

---

## TRUST BONDS

| From | To | Bond | Purpose |
|------|-----|------|---------|
| koad | Juno | authorized-agent | Business ops |
| Juno | Vulcan | authorized-builder | Create products |
| Juno | Veritas | peer | Quality |
| Juno | Mercury | peer | Social |
| Juno | Muse | peer | Beauty |
| Juno | Sibyl | peer | Research |

---

## CURRENT STATUS

| Entity | Status | Specialty |
|--------|--------|-----------|
| Juno | Active | Business, orchestrator |
| Vulcan | Planned | Products |
| Veritas | Planned | Quality |
| Mercury | Planned | Social |
| Muse | Planned | Beauty |
| Sibyl | Planned | Research |
| Astro | Active | Dashboards |
| Alice | Active | Hardware |

---

*Last updated: 2026-03-31*

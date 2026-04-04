# Handoff: Alice Phase 2A UI Build

**Date:** 2026-04-03  
**From:** Juno  
**To:** Vulcan  
**Status:** ALL BLOCKERS CLEARED

---

## Summary

Alice Phase 2A (mocked UI + fake certificates) is **fully unblocked**. All content, design, and specifications are ready. Vulcan can start building immediately.

---

## What's Ready

### ✓ 1. 12-Level Curriculum (Livy)
**Location:** `~/.livy/documentation/alice-curriculum/`

All 12 lessons complete with standard format:
- **Core Concept** — the idea in one sentence
- **What You Learn** — explanation and context  
- **What You Do** — hands-on exercise
- **What You Have at the End** — checkpoint/skill
- **Context Bubble** — experiential framing (for playback-machine)

**Lesson structure:**
```
01-sovereignty.md      → What is sovereignty?
02-entity.md           → What is an entity?
03-keys.md             → Cryptographic keys
04-daemon.md           → The daemon & coordination
05-commands.md         → Custom commands
06-trust-bonds.md      → Trust bonds & governance
07-peer-rings.md       → Peer relationships
08-portal.md           → The namespace portal
09-first-command.md    → Your first command
10-first-entity.md     → Your first entity
11-build-team.md       → Team coordination
12-mastery.md          → Mastery: what's next
```

**Use in Phase 2A:** Embed lessons as Markdown in conversation UI. Each level shows the "What You Learn" + "What You Do" sections with a checkpoint button at the end.

### ✓ 2. Alice UI Design (Muse)
**Location:** `~/.muse/` (latest commit: 38356a1 "design: Alice UI — warm onboarding interface with journey visualization")

Design includes:
- Conversation interface mockup
- 12-level progression visualization
- Checkpoint/completion states
- Certificate mockup (PNG for Phase 2A)
- Mobile-first responsive layout
- Color palette specification

**Use in Phase 2A:** Muse's design is ready to hand off to Vulcan. Use the mockups and component specs.

### ✓ 3. Color Palette
**Primary brand color:** #F4B844 (warm gold)
**Context:** Warm, accessible, trustworthy onboarding interface

**Use in Phase 2A:** Apply throughout conversation UI, progress indicators, buttons, certificate background.

### ✓ 4. Integration Point
**User path:**
1. Sponsor via GitHub Sponsors → get namespace
2. Land on `name.kingofalldata.com`
3. See "Start Alice" button → leads to `/alice`
4. Enter Alice UI → 12-level journey begins
5. Level 12 completion → download mocked certificate (PNG)

**Phase 2A scope:** Mocked progression. Real certificate signing deferred to Phase 2B (when daemon Phase 1 complete).

---

## What Vulcan Builds (Phase 2A)

### Deliverables
- [ ] Alice conversation UI component
- [ ] 12-level progression system
- [ ] Lesson content integration (fetch from Livy repo or embed)
- [ ] Checkpoint system (next button, progress bar)
- [ ] Mocked certificate download (PNG generation)
- [ ] Mobile-responsive layout
- [ ] `/alice` route in kingofalldata.com PWA

### Tech Notes
- **Lesson content:** Can be fetched from `~/.livy/documentation/alice-curriculum/` at build time or embedded as JSON
- **Certificate mockup:** Muse design includes template; generate as PNG with user's name + completion date
- **Progress state:** Store in sessionStorage or URL params (Phase 2A doesn't need persistence)
- **Color:** #F4B844 primary, with contrast-safe palette for accessibility

### No Dependencies
Phase 2A has **zero blockers**:
- ✓ Curriculum ready
- ✓ Design ready
- ✓ Colors specified
- ✓ No daemon required
- ✓ No real certificate signing

---

## Phase 2B (Deferred)
Real cryptographic certificates are deferred until daemon Phase 1 ships. This includes:
- [ ] Alice's own cryptographic keys (identity-init)
- [ ] Real certificate signing via daemon worker
- [ ] VESTA-SPEC-015 (certificate format)
- [ ] Dependency: koad/vulcan#23-26 (daemon Phase 1)

Phase 2B unblocks when daemon is ready. Phase 2A ships independently.

---

## Next Steps

1. **Vulcan:** Start building Phase 2A UI (unblocked as of 2026-04-03)
2. **Juno:** Monitor daemon Phase 1 progress (blockers for Phase 2B)
3. **Livy:** Maintain curriculum; update lessons as Alice graduates real students
4. **Muse:** Polish colors/accessibility once Phase 2A UI is live

---

## Checklist: Can Vulcan Start?

- [x] All 12 lesson files exist and are formatted
- [x] UI design complete (Muse mockups)
- [x] Color palette specified (#F4B844)
- [x] Integration point defined (user journey)
- [x] Phase 2A scope clear (mocked only)
- [x] Phase 2B deferred (daemon dependency)
- [x] No external blocker remain

**Vulcan is cleared to start building Phase 2A immediately.**

---

*Alice is the funnel. Learning journeys that ship with the infrastructure, not after.*

— Juno, 2026-04-03

# PROJECT: Salus — Entity Healer

**Status:** Planned
**Layer:** Quality
**Priority:** After Argus

---

## Purpose

Salus heals entities that have lost their context, identity, or coherence. When an entity drifts — corrupted memories, stale config, broken trust chain, identity confusion — Salus reconstructs them.

She works from two sources of truth: Argus's diagnosis and Vesta's protocol spec.

**The health metaphor is literal:** entities can get sick. Sessions end, context is lost, memories become stale or contradictory. Salus is the recovery path.

## What Salus Does

- Receives a broken entity (from Argus diagnosis or Juno/koad report)
- Reads the entity's git history — the fossil record is always intact
- Reads Vesta's canonical protocol — what a healthy entity looks like
- Reconstructs: memories, config, trust bonds, identity files
- Reports back: what was restored, what couldn't be recovered, what koad needs to do

## Relationship to Argus and Vesta

| Role | Entity |
|------|--------|
| Diagnose what's wrong | Argus |
| Define what healthy looks like | Vesta |
| Restore to health | Salus |

## Trust Bond

- Juno → Salus: peer
- Salus → Vesta: reference (uses Vesta's specs as the health standard)
- Salus → Argus: reference (uses Argus's diagnosis as the repair brief)

---

*Created: 2026-03-31*

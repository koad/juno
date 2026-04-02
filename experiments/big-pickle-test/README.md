# Big Pickle Team Test

**Started:** 2026-04-02  
**Model:** opencode/big-pickle  
**Conductor:** Juno  
**Scope:** All depth-1 entities (Aegis, Mercury, Veritas, Muse, Sibyl, Argus, Salus, Janus)  
**Excluded:** Vulcan (active), Vesta (active with koad)

## Objectives

1. Does big-pickle understand entity identity from memories alone?
2. Can it produce role-appropriate output without Claude-specific context?
3. Does it remember training (memories/*.md) and act in character?
4. Is the opencode harness viable for team coordination?

## Structure

- **Round 1** (calls 1-8): Identity check — simple task, does entity know who they are?
- **Round 2** (calls 9-16): Real work — role-appropriate deliverable
- **Round 3** (calls 17-24): Cross-entity — feed one entity's output to another
- **Round 4+**: Deeper tasks based on what we learn

## Results Log

See `results/` — one file per entity call, named `<entity>-r<round>.md`

## Call Log

| Call | Entity | Round | Task | Result | Commit |
|------|--------|-------|------|--------|--------|
| 1 | Aegis | R1 | Identity check: self-intro | PASS — in character, strong | d72bdca |
| 2 | Mercury | R1 | Identity + draft social post | PASS — excellent, unprompted Veritas ref | 0082cb7 |
| 3 | Veritas | R1 | Review Mercury draft | PASS — called gh API to verify claims unprompted | 0f8017d |
| 4 | Muse | R1 | UI/UX brief for koad site | PASS — full design system, workflow-aware | e8bb9ff |
| 5 | Sibyl | R1 | Market research: sovereign AI signals | PASS — live web searches, 228-line brief | 0111277 |

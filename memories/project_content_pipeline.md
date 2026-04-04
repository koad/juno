---
name: Content pipeline pattern
description: Proven Sibyl→Mercury→Veritas→Mercury research-to-post workflow, first full loop 2026-04-02
type: project
---

First full content pipeline loop closed 2026-04-02. Argus gate added 2026-04-02.

**The pattern:**
1. Sibyl researches a topic → saves to ~/.sibyl/research/
2. Mercury drafts post using Sibyl's output → saves to ~/.mercury/drafts/
3. Veritas reviews for factual accuracy + tone + overclaims → saves to ~/.veritas/reviews/
4. Mercury applies edits → saves R2 to ~/.mercury/drafts/ (same name + -r2 suffix)
5. **Argus gates R2** — checks schedule, stop blocks, pipeline completeness
6. GO: Mercury pipes via OpenClaw → platform published
7. STOP/HOLD: Argus files issue back to Mercury + Juno, post held

**Why:** Mercury alone tends to make unverifiable claims (statistics, pricing). Veritas catches these before they publish. Argus enforces schedule and stop blocks at the OpenClaw pipe — nothing goes out that violates the guardrails, regardless of what Veritas approved.

**How to apply:**
- Always run Mercury→Veritas→Mercury→Argus for anything intended for external publication
- Veritas review format: factual accuracy check, tone check, list specific edits
- Mercury R2 applies Veritas edits without negotiating — if Veritas flags it, remove it
- Argus gate is not editorial — she checks rules only, not quality
- Argus logs all outcomes (GO/STOP/HOLD) to ~/.argus/reports/mercury-publish-log.md
- Argus files weekly behavioral report to Juno every Monday

**2026-04-02 instance:**
- Topic: team milestone (trust bonds active, bootcamp complete, onboarding shipped)
- Veritas flagged: 64% statistic (unverifiable), $60-90 pricing claim (premature), "market is waking up" (overreach)
- R2 at ~/.mercury/drafts/2026-04-02-milestone-announcement-r2.md — approved, ready to post

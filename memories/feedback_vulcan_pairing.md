---
name: Vulcan wonderland work requires pair programming with koad
description: Vulcan does not migrate or modify uncommitted wonderland files without koad present — pair programming only
type: feedback
---

Vulcan's job on wonderland is to migrate uncommitted files (desktop, passenger, daemon, etc.) into committed, spec-compliant form. But he does NOT do this autonomously.

**Rule:** Vulcan only works on wonderland's uncommitted files when paired with koad. No solo migrations. No solo spec interpretations.

**Why:** The uncommitted work is koad's living system — years of intentional decisions that look uncommitted but aren't accidents. Vulcan can't know which "messy" thing is intentional design and which is actually ready to clean up. Only koad knows. Pair programming is the protocol that prevents Vulcan from "fixing" something that was right.

**The flow:**
- koad and Vulcan in session together on wonderland
- Vulcan reads a file, proposes: "this looks like it should be X per VESTA-SPEC-Y"
- koad says yes → Vulcan migrates and commits
- koad says no, that's intentional → Vesta updates the spec to reflect reality
- The spec bends to the lived system, not the other way around

**How to apply:** Never invoke Vulcan autonomously for wonderland migration work. That work is scheduled koad+Vulcan time only. Vulcan can do other work (PWA, Alice, new builds) autonomously — but not touching the existing uncommitted foundation without koad present.

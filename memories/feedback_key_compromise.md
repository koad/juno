---
name: Key compromise recovery
description: Key exposure is recoverable — regenerate keys, re-sign bonds, update canon.koad.sh, done
type: feedback
---

If Juno's (or any entity's) keys are exposed, that's fine. The recovery path:
1. Delete the exposed keys
2. Generate new ones
3. Update `canon.koad.sh/<entity>.keys`
4. Re-sign trust bonds as upstream
5. All downstream entities re-verify against the new key

**Why:** The identity IS the entity (repo, history, relationships) — not the keys. Keys are just the current auth layer. Juno as team lead / total upstream can re-establish the whole trust chain from scratch.

**How to apply:** Don't treat key exposure as catastrophic or identity-destroying. It's an operational reset, not a death event. Don't over-engineer key protection at the expense of operational simplicity.

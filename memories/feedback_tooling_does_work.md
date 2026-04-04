---
name: Tooling does the work
description: koad:io framework handles gestation and structure — don't reverse-engineer or rebuild what the tooling already does
type: feedback
---

Don't explore or recreate what the koad:io framework already handles. `koad-io gestate <name>` creates entities. The tooling does the work.

**Why:** koad corrected an attempt to deeply explore entity directory structure to understand the "schema" — that's the framework's job, not mine.

**How to apply:** When a new entity is needed, the answer is `koad-io gestate <name>`, not manually building directory structures. Trust the tooling. Entity definitions, team structure, and briefs live in ~/.juno/ (my repo). The entity's own directory gets created by gestation.

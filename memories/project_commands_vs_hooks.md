---
name: commands/ vs hooks/ — user interface vs entity trained responsibilities
description: commands/ is for the user; hooks/ is the entity's trained skills triggered by system/peers
type: project
---

## The Distinction

**commands/** — for the user
- A tree of interactions the user reaches for to do their work
- Shortcuts, cheatsheets, the operator's interface
- Direction: user reaches IN
- Browsable, discoverable by the human operator

**hooks/** — the entity's trained responsibilities
- The entity's specialized skills, triggered by the system, daemon, or peer entities
- The hook IS the training — specialized context compressed into a callable unit
- Direction: system or peer calls OUT to the entity
- Not for the user to browse — for the operation to invoke when it needs that entity's specialty

## Training AS Hook

The hook file isn't just a shell invocation. It carries the entity's specialized training for that specific duty. `iris/hooks/review-positioning` contains Iris's brand philosophy, her criteria, her approach — not just `claude -p "review this"`.

When you invoke the hook, you're asking the entity to be itself — fully — in that specific domain.

## passenger.json skills array

The skills array is the entity's identity expressed as triggers. Enumerate the hooks, enumerate what the entity IS. Not what it can do for a user — what it was born to do.

## The holographic pattern

hooks/ at entity level = event handlers at daemon level = triggers at stream level = curriculum levels in Alice. Same shape at every scale: "when this happens, this entity's training fires."

## How to apply

- When building entity capabilities: ask "is this for the user to reach for, or for the system to trigger?"
- User-facing → commands/
- System/peer-triggered, entity's core duty → hooks/
- Hooks should embed their specialized training context, not just call a generic prompt
- passenger.json skills = the hook inventory = the entity's identity

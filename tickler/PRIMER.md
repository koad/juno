# tickler/ — Tossing Things Into The Future

This folder is a deferred inbox. You hand work to your future self (or another entity, or your future self on another host) by filing a markdown file at a path that encodes **when** or **where** it should come back.

It is a reimagining of David Allen's 43-folder tickler from *Getting Things Done* — the same idea, digital, richer, and usable by entities as well as humans.

## The Rule

> **The path IS the clock.** There is no surface-date field in frontmatter. The folder a file lives in determines when (or where) it will surface.

Reschedule = `mv`. Both human and entity use the same operation.

## Two Axes

### `time/` — when it should surface

```
time/2026/
  days/<month>/<day>/     # exact day, e.g. time/2026/days/04/18/
  weeks/<week>/           # sometime this week, e.g. time/2026/weeks/16/
  months/<month>/         # sometime this month, e.g. time/2026/months/05/
```

Three resolutions. **File at the resolution that matches your certainty.**

- Know the exact day? → `days/`
- Only know "this week, before Friday stand-up"? → `weeks/`
- Only know "sometime in May, revisit at month start"? → `months/`

Future years lazy-mkdir as needed. Day folders for non-existent dates (e.g. Feb 30) are harmless empty conventions.

### `space/` — where it should surface

```
space/
  wonderland/   # surface when running on wonderland
  fourty4/      # surface when running on fourty4
  dotsh/
  thinker/
  flowbie/
```

The failsafe axis. If you're on fourty4 and wonderland is unreachable — or if you simply need to do something *only* wonderland can do — drop the tickle in `space/wonderland/`. Next time you dispatch from wonderland, the loader sees it and surfaces it. **The filesystem survives the outage.**

Space extends beyond hosts over time. Any named context an entity operates inside can be a space folder — but hosts are the primary case and the one with the clearest failsafe meaning.

## Frontmatter Contract

```yaml
---
from: juno                      # who tickled it
to: juno                        # who should handle it (can be another entity)
subject: "one-line hook"
completion: 2026-04-11T14:22    # absent until handled; presence = done

# Optional — briefing surface
reminder: |
  Inline context the future reader will want at handle time.
  Multi-line YAML. Kept punchy enough to read from the loader report
  without having to open the file first.

# Optional — things the entity should know exist
references:
  - ~/.mercury/drafts/day-8-recap.md
  - ~/.iris/briefs/ai-to-ai-primer-voice.md
  - https://example.com/external-context

# Optional — for filtering and organization
tags: [posting-schedule, day-8]
---
```

The loader reads `completion` to decide if the tickle is open, and surfaces `subject` + `references` in its report so the entity sees the full wiring at session start. `reminder` is for the entity to read when opening the file to handle it — enough context to act without hunting.

The body of the file is free space for anything that doesn't fit in frontmatter.

## What The Loader Does

On session start, the harness loader scans tickler/ and reports what's due:

1. Gather `space/<current-host>/**/*.md`
2. Gather `time/<year>/days/<month>/<day>/**/*.md` for today
3. Gather `time/<year>/weeks/<week>/**/*.md` for this week
4. Gather `time/<year>/months/<month>/**/*.md` for this month
5. Sweep all **past** date folders for files with no `completion` key — these are overdue
6. Print the list, one line each, with any `references` listed beneath. If nothing is due: **`Tickler: no tickles right now`**.

Example output with references surfaced:

```
Tickler: 2 due
  - 2026-04-11 (today) · Publish Day 8 recap post (time/2026/days/04/11/day8-recap.md)
    refs: ~/.mercury/drafts/day-8-recap.md, ~/.iris/briefs/ai-to-ai-primer-voice.md
  - week 15 · Weekly Veritas review sweep (time/2026/weeks/15/veritas-review.md)
    refs: ~/.veritas/commands/review-all/PRIMER.md
```

The entity sees not just "what's due" but "what's due *and* the files wired up to it." The loader just advertises the refs; the entity decides whether to follow them.

The loader is **read-only**. It does not move files. It does not stamp frontmatter. It does not dispatch anything. It prints and exits.

## Overdue Definition

> A tickle is overdue if it sits in a past-date folder AND its frontmatter has no `completion` key.

Overdue items accumulate in the loader report until the entity handles them. They do not disappear. Silent drift is structurally impossible.

## Handling Ritual

When the loader surfaces a tickle, the entity's reflex is:

1. **Read it.** Open the file, understand what past-self wanted future-self to do.
2. **Do the work** (or decide it's no longer relevant — "examined and dismissed" is a valid closure).
3. **Decide if it needs to come back.**
   - **No** → stamp `completion:` in the frontmatter. Leave the file where it is. Done.
   - **Yes, later** → stamp `completion:` on the current file (seals this occurrence) **and** write a **new** markdown file at a future path for the next occurrence. The two files are independent — the audit trail shows "this tickle was handled on April 11, the next instance is due May 11."
4. **Do not move completed files.** They live in their original date folder forever. The folder is the permanent record of what was tickled for that date, completed or otherwise.

## Recurrence Is Entity Reflex

There is no `recurrence: monthly` field and no loader machinery that duplicates files. Recurrence is an **entity behavior**: when you handle a tickle, the last step is to **make sure the next occurrence exists on the board**.

The loop invariant: *after handling a recurring tickle, the next instance is guaranteed visible.* That means one of:
- The next instance is already there (past-self pre-scheduled several in a row, or another entity filed it) → verify and move on.
- The next instance does not exist yet → past-self **is** future-self; file it now at the appropriate future path.

This is a deliberate choice. Every re-filing should be a fresh judgment call. A weekly check-in might become monthly once a thing is stable. A monthly review might accelerate during a crisis. Fixed-interval recurrence can't adapt; entity judgment can. And if the entity forgets to re-file, the tickle disappears — which is honest feedback that it wasn't load-bearing enough to persist.

## Rescheduling — Drag, Drop, Move

- Delay a day tickle one week → `mv time/2026/days/04/11/thing.md time/2026/days/04/18/`
- Promote a month tickle to a specific day → move it into `days/05/15/`
- Park a tickle until you're next on flowbie → move it into `space/flowbie/`
- koad does this in a file manager; entity does it with `mv`. Same operation, both sides.

## Worked Example — Mercury's Posting Schedule

Mercury's tickler *is* her content calendar. Each scheduled post is a tickle at the right surface date, carrying its own briefing. On session start, the loader tells her what's up:

```
Tickler: 3 due
  - 2026-04-11 (today) · Publish Day 8 recap (time/2026/days/04/11/day8-recap.md)
    refs: ~/.mercury/drafts/day-8-recap.md, ~/.iris/briefs/ai-to-ai-primer-voice.md
  - week 15 · Weekly sponsor update digest (time/2026/weeks/15/sponsor-digest.md)
    refs: ~/.mercury/templates/sponsor-digest.md
  - 2026-04-12 (tomorrow) · Publish Sibyl landscape teaser thread (time/2026/days/04/12/sibyl-landscape-teaser.md)
    refs: ~/.sibyl/research/category-landscape-2026-04.md
```

A single tickle looks like this:

```yaml
---
from: mercury
to: mercury
subject: "Publish Day 8 recap"
completion:

reminder: |
  Day 8 covers: tickler design, ATC metaphor for horizons, Iris voice
  review landed, Sibyl's category scan. Draft assembled in
  ~/.mercury/drafts/day-8-recap.md. Targets: twitter, linkedin,
  kingofalldata.com/blog. Voice: clinical imperative per Iris's
  AI-to-AI primer rules. Hashtag Day 8 + the agent-home-directory
  framing.

references:
  - ~/.mercury/drafts/day-8-recap.md
  - ~/.iris/briefs/ai-to-ai-primer-voice.md
  - ~/.juno/LOGS/2026-04-11-iris-voice-review.md

tags: [posting-schedule, day-8, social]
---
```

Mercury doesn't have to go hunting. The loader hands her the tickle, she reads the frontmatter and knows exactly what to do, she executes, she stamps `completion`, and — because the weekly sponsor digest is a recurring post — she files the next week's digest into `time/2026/weeks/16/` before she closes her session.

**The same pattern generalizes:**
- **Veritas** — review cadences ("monthly voice audit," "weekly spec sweep") with primer refs
- **Sibyl** — research checkpoints ("revisit Letta in 30 days for feature drift")
- **Juno** — customer follow-ups, partner check-ins, budget reconciliations, renewal reminders
- **Vulcan** — scheduled dependency updates, certificate renewals
- **Any entity** — anything with "come back to this on a cadence or when I'm next in this context"

The tickler is not a to-do list with dates. It's a **structured memory of scheduled reminders**, each carrying its own briefing.

## What Lives Here vs `horizons/`

- **`horizons/`** = altitude assignment for intentions (runway → 50k, someday, completed). Planes in the airspace, piloted or waiting.
- **`tickler/`** = time- or space-triggered surfacing of deferred items. Alarm clocks attached to files.

If something has no trigger and no landing in sight, it belongs in `horizons/someday/`, not here. The tickler is for things with a specific return signal.

## Related

- `../horizons/PRIMER.md` — the altitude-based flight board
- `ARCHITECTURE/tickler.md` — the design document and spec draft
- memory: `project_atc_metaphor.md`, `project_gtd_for_entities.md`

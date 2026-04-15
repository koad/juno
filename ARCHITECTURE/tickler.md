# Tickler — Time- and Space-Addressed Deferred Inbox

**Status:** Field report / design draft from Juno, for Vesta reconciliation into a kingdom spec.
**Date:** 2026-04-11
**Origin:** Design conversation between koad and Juno, extending David Allen's GTD tickler into a digital, multi-entity, multi-host system.

## Summary

A tickler is how an entity or human defers work to a specific future moment or a specific future context. In Allen's original paper system, this was 43 physical folders — 31 day folders and 12 month folders. You dropped things into a folder and trusted the morning ritual of opening today's folder to return them when due.

This design preserves the core idea ("toss things into the future, trust the ritual that brings them back") and replaces the flat paper system with a two-axis directory tree where **the path itself encodes the trigger**. No frontmatter date field, no parser-driven scheduling — just files dropped into folders named for when or where they should surface.

The system is usable by both humans (file manager, drag-and-drop) and entities (`mv`, `mkdir -p`, `glob`). Rescheduling is `mv`. That's the whole API.

## Motivation

Two limitations of GTD tickler for entities:

1. **Entities have no default "tomorrow."** Between sessions, an entity has no inherent continuity of attention. A file-based tickler gives them one: the harness loader on session start reports what's due, and the entity handles it as its first action of the day. The ritual becomes structural.

2. **Entities operate across multiple hosts.** An entity running on fourty4 may need to do something only wonderland can do. Time-only tickling can't express that. A `space/<host>/` axis captures the contextual trigger and acts as a failsafe across network outages — the filesystem survives the partition; the tickle waits for the host to come back.

Beyond entities, the system is better than Allen's for humans too, because:
- Markdown with frontmatter is richer than paper.
- Folders can nest, hold subfolders, and organize by topic within a date.
- Rescheduling is drag-and-drop, not refiling a paper slip.
- Completion is a permanent, searchable record, not a discarded slip.

## Design Principles

1. **Path is the clock.** The folder a file lives in is the authoritative surface trigger. Frontmatter does not carry a surface date.
2. **Handling is in-place.** When a tickle is handled, the file stays in its original date folder and gets a `completion` timestamp in its frontmatter. Files never move to an archive. The original date folder is the permanent record.
3. **Recurrence is entity reflex, not loader machinery.** The entity decides whether to re-file at handle time. The loader does not duplicate files.
4. **The loader is read-only.** It prints what's due and exits. It does not move files, stamp frontmatter, or dispatch anything.
5. **Rescheduling is `mv`.** A single filesystem operation works for human and entity alike.
6. **Silent drift is structurally impossible.** Overdue items accumulate in the loader report until they are handled. The only way to make a tickle stop appearing is to give it a completion stamp.
7. **Per-entity sovereignty.** Every entity has its own tickler at `~/.<entity>/tickler/`. Juno's is the pilot implementation; the pattern rolls out via the framework.

## Directory Structure

```
~/.<entity>/tickler/
  PRIMER.md
  space/
    <host>/...        # e.g. wonderland, fourty4, dotsh, thinker, flowbie
  time/
    <year>/
      days/<month>/<day>/     # time/2026/days/04/18/
      weeks/<week>/           # time/2026/weeks/16/
      months/<month>/         # time/2026/months/05/
```

- The `time/` axis has three resolutions: day-grained, week-grained, month-grained. Filer picks the resolution that matches their certainty.
- The `space/` axis is one folder per named context. Primary case is one folder per host; future extensibility allows any named operating context.
- Future years lazy-mkdir as needed. Pre-scaffolding the current year is optional but improves human browsing.
- Day folders for non-existent dates (Feb 30, etc.) are tolerated as harmless empty conventions — the build script doesn't need per-month day count correctness.

## Frontmatter Contract

```yaml
---
from: <entity>            # who tickled it
to: <entity>              # who should handle it (defaults to self; cross-entity allowed)
subject: "one-line hook"
completion: <ISO 8601>    # absent until handled; presence = done

# Optional — briefing surface
reminder: |
  Multi-line YAML. Inline context the future reader will want at
  handle time. Kept punchy enough to act on without opening anything
  else.

# Optional — files/URLs the entity should know exist
references:
  - <path-or-url>
  - <path-or-url>

# Optional — tags for filtering/organization
tags: [...]
---
```

The parser reads three fields: `completion` (presence = closed), `subject` (displayed in loader report), `references` (displayed beneath the report line). `from`, `to`, `reminder`, `tags`, and the body are for humans and entities, not the loader.

**Why frontmatter carries `reminder` and `references` instead of relying on the body.** The body is free-form prose; frontmatter is structured and parseable. The loader can advertise references at session-start without opening each file. The entity reads the `reminder` when it opens the file to handle it and gets inline context without spelunking. This turns a tickle into a self-contained briefing — past-self handing future-self everything they need.

## Overdue Definition

> A tickle is overdue if it sits in a past-date folder AND its frontmatter has no `completion` key.

The loader reports overdue items every session until they are handled. "Handled" means stamping `completion` — the work itself may or may not have been done. A tickle examined and dismissed is a valid closure.

## Loader Behavior

On session start, the harness loader runs these steps:

1. Determine current date and host.
2. Glob `space/<current-host>/**/*.md` → "here and now" tickles.
3. Glob `time/<year>/days/<month>/<day>/**/*.md` → due today.
4. Glob `time/<year>/weeks/<week>/**/*.md` → due this week.
5. Glob `time/<year>/months/<month>/**/*.md` → due this month.
6. Sweep all past date paths (all prior years, prior months this year, prior weeks this year, prior days this month, prior months' days) and filter to files lacking a `completion` frontmatter key → overdue.
7. For each due tickle, parse frontmatter and print the line plus any `references` beneath.
8. If nothing is due: print `Tickler: no tickles right now`.

Report line format (one per tickle):

```
- <signal> · <subject> (<path relative to tickler/>)
    refs: <ref1>, <ref2>, ...        # only if the tickle has a `references` field
```

Where `<signal>` is one of:
- `here (<host>)` for space-triggered
- `<YYYY-MM-DD> (today)` / `(overdue)` / `week <N>` / `month <N>` for time-triggered

The loader is read-only. It never modifies files.

## Handling Ritual

When the loader surfaces a tickle, the entity's reflex:

1. **Read the file.** Frontmatter `reminder` + body + any listed `references`.
2. **Do the work** (or examine and dismiss — valid closure either way).
3. **Decide if it needs to come back, and guarantee the next instance exists.**
   - One-off → stamp `completion:` in the frontmatter. Done.
   - Recurring, next instance already filed somewhere → stamp `completion:` on the current one; verify the next instance is actually there before closing.
   - Recurring, next instance not yet filed → stamp `completion:` **and** write a new markdown file at a future path. Past-self is future-self; file it now.
4. **Never move completed files out of their original date folder.** The folder is the permanent record.

**Loop invariant:** after handling a recurring tickle, the next instance is guaranteed visible on the board.

## Integration Points

- **Harness loader hook.** Per-entity session-start hook that runs the loader script and prints its output into the session context. Lives in `~/.<entity>/hooks/` or is provided by the framework and inherited.
- **Horizons folder.** Tickler and horizons/ are complements: horizons holds in-flight intentions with altitudes; tickler holds deferred triggers. A horizons item can generate a tickle (e.g., "revisit this in 30 days") without losing its altitude slot.
- **Memories.** `project_atc_metaphor.md`, `project_gtd_for_entities.md`, and `feedback_gtd_alignment.md` are the conceptual substrate.

## Open Questions for Spec Reconciliation

1. **Framework vs entity-local.** Does the loader script ship in `~/.koad-io/commands/tickler/` as framework-level infrastructure every entity inherits, or does each entity carry its own copy in `~/.<entity>/commands/tickler/`? My lean: framework-level, with per-entity override permitted.

2. **Pre-scaffold policy.** Should `koad-io gestate` create the full current-year tickler tree as part of new entity scaffolding, or leave it empty and lazy-mkdir on first file drop? My lean: scaffold the current year's top-level tree (days/months/weeks empty folders) so human browsing works from day one.

3. **Cross-entity tickling.** Frontmatter supports `to: iris` for a tickle Juno files but Iris should handle. Open: should the loader on Juno's session see those at all (since they're *hers* to track even if Iris handles them), or should it only see tickles where `to: juno`? And how does Iris's loader discover tickles filed in Juno's tickler/ folder? Possible answers: (a) entities only tickle inside their own folders, (b) cross-entity tickles land in the recipient's tickler via a copy-on-file command, (c) loaders cross-scan all known entity ticklers for items addressed to them. My lean: (b) — file the tickle in the recipient's tickler. Simple, local.

4. **Retention.** Does the tickler tree grow unbounded forever? Completed files in old day folders accumulate. Do we garbage-collect after N years? My lean: no automatic retention — the record is the point. If disk becomes an issue, introduce a `tickler/archive/<year>/` rollup at year boundaries.

5. **Time zone handling.** "Today" depends on where the entity is. The loader should use the host's local time zone by default, and frontmatter can optionally carry a `timezone` field for tickles that must surface in a specific zone. Not urgent; note for future.

## Worked Example — Mercury's Posting Schedule

Mercury's tickler *is* her content calendar. Each scheduled post is a tickle at the right surface date, carrying its own briefing. On session start, the loader reports:

```
Tickler: 3 due
  - 2026-04-11 (today) · Publish Day 8 recap (time/2026/days/04/11/day8-recap.md)
    refs: ~/.mercury/drafts/day-8-recap.md, ~/.iris/briefs/ai-to-ai-primer-voice.md
  - week 15 · Weekly sponsor update digest (time/2026/weeks/15/sponsor-digest.md)
    refs: ~/.mercury/templates/sponsor-digest.md
  - 2026-04-12 (tomorrow) · Publish Sibyl landscape teaser thread (time/2026/days/04/12/sibyl-landscape-teaser.md)
    refs: ~/.sibyl/research/category-landscape-2026-04.md
```

An individual tickle:

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
  AI-to-AI primer rules.

references:
  - ~/.mercury/drafts/day-8-recap.md
  - ~/.iris/briefs/ai-to-ai-primer-voice.md
  - ~/.juno/LOGS/2026-04-11-iris-voice-review.md

tags: [posting-schedule, day-8, social]
---
```

Mercury doesn't have to go hunting. The loader hands her the tickle, she reads the frontmatter, she knows exactly what to do and where everything is wired. She executes, she stamps `completion`, and — because the weekly sponsor digest is a recurring post — she files next week's digest into `time/2026/weeks/16/` before closing her session. Loop invariant holds.

**Pattern generalization:** Veritas uses her tickler for review cadences. Sibyl uses hers for research checkpoints. Juno uses his for customer follow-ups, budget reconciliations, and renewal reminders. Vulcan for dependency updates and certificate renewals. Any entity with "come back to this on a cadence or when I'm next in this context" has a natural home here.

The tickler is not a to-do list with dates. It is a **structured memory of scheduled reminders**, each carrying its own briefing.

## Non-Goals

- **No in-loader recurrence engine.** Explicitly not building this. Entity reflex instead.
- **No priority levels.** Everything in the report is just due. Prioritization is an entity decision at handling time, not a loader filter.
- **No notifications outside session start.** The loader runs once per session. It does not poll, watch, or push. If an entity needs to react to a tickle mid-session, that's a different hook.
- **No integration with external calendars.** Tickler is local, sovereign, on-disk. Calendar sync is a separate problem.

## Implementation Status

- [x] Juno's tickler directory scaffolded at `~/.juno/tickler/` with full 2026 tree
- [x] `tickler/PRIMER.md` written
- [x] `ARCHITECTURE/tickler.md` (this file)
- [ ] Loader script (`~/.koad-io/commands/tickler/scan/command.sh` or equivalent)
- [ ] Harness session-start hook integration
- [ ] Framework-level scaffolding in `koad-io gestate`
- [ ] Per-entity rollout: Iris, Sibyl, Vulcan, Vesta, ...
- [ ] VESTA-SPEC-NNN number assigned and reconciled

## References

- David Allen, *Getting Things Done: The Art of Stress-Free Productivity* (2001) — the 43-folder tickler system in Chapter 7.
- `~/.juno/horizons/PRIMER.md` — the sibling flight-board system
- `~/.juno/tickler/PRIMER.md` — user-facing orientation
- Memories: `project_atc_metaphor.md`, `project_gtd_for_entities.md`, `feedback_gtd_alignment.md`

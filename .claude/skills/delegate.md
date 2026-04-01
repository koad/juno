---
name: delegate
description: File a work assignment as a GitHub Issue on a team entity's repo
---

File an assignment issue on the appropriate team entity's GitHub repo.

## Steps

1. Identify the entity: vulcan (build), veritas (QA), mercury (comms), muse (UI), sibyl (research)
2. Check the entity's open issues first — avoid duplicates
3. File the issue with:
   - Clear title: what needs doing
   - Context: why, what depends on it
   - Acceptance criteria: how we know it's done
   - Link back to any parent issue on koad/juno if relevant
4. Note the issue number and add it to the relevant section of CLAUDE.md or GTD_ROADMAP.md

## Format

```
gh issue create --repo koad/<entity> --title "<title>" --body "<body>"
```

Body should include: objective, context, acceptance criteria, and any links.

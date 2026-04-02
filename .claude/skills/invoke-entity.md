# Skill: invoke-entity

Spawn a team entity non-interactively, give them a task, wait for their output, read it back.

## Usage

```
/invoke-entity <entity> "<task>" [read-back-path]
```

Examples:
```
/invoke-entity aegis "Read today's logs and write counsel to ~/.aegis/counsel/today.md. Commit and push."
/invoke-entity sibyl "Research X, write to ~/.sibyl/research/001.md. Commit and push."
/invoke-entity argus "Diagnose ~/.mercury/ and write report to ~/.argus/diagnoses/mercury.md. Commit and push."
```

## What this skill does

1. Runs the entity non-interactively with the given task
2. Waits for completion
3. Reads back the committed output
4. Reports what the entity produced

## The command

```bash
cd ~/.<entity> && claude --dangerously-skip-permissions -p "<task>"
```

## Task prompt template

```
Read <input-files>.
<What to produce>.
Write output to <path>.
Commit and push as <Entity>.
```

Be specific about input, output path, and commit instruction.
No ambiguity about what "done" looks like.

## Read-back

After completion, check:
- The output file the entity was asked to write
- `git -C ~/.<entity> log --oneline -3` for what they committed
- Their GitHub issues for any comments they left

## Scope discipline

Use `--dangerously-skip-permissions` only for:
- Tasks within the entity's own directory
- Reading explicitly specified files from known locations
- Committing to the entity's own repo

Not for: modifying infrastructure, pushing to foreign repos, touching credentials.

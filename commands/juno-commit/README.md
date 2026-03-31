# Juno Commit Command

A hardcoded commit command for Juno with baked-in commit instructions.

## Usage

```bash
cd ~/.juno
juno-commit
```

Or from anywhere:
```bash
~/.juno/commands/juno-commit/command.sh
```

## What It Does

1. Checks if inside git repository
2. Opens opencode with Juno's commit instructions
3. Creates a well-formatted commit message
4. Does NOT push automatically

## Juno Commit Rules (Hardcoded)

1. **Always explain the WHY** - Not just what changed, but why it matters
2. **Subject line**: Max 72 chars, imperative mood
3. **Body**: Focus on business impact
4. **One logical change per commit** - Split unrelated changes
5. **No auto-push** - Commit only

## Example

```bash
cd ~/.juno
git add .
juno-commit
# opencode opens
# Creates: "Add team structure documentation for entity family"
```

## Files

```
commands/juno-commit/
├── command.sh    # The executable command
└── README.md     # This file
```

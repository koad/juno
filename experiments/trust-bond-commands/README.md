# Trust Bond Commands — Prototype

Working command prototypes for vulcan#11. Tested against Juno's live bond state.

## Commands

| Command | Usage |
|---------|-------|
| `status` | List all bonds, show type and signature state |
| `verify <name>` | Verify a bond's GPG signature |
| `issue <grantee> [type]` | Scaffold and sign a new bond |
| `revoke <name>` | Archive bond and issue revocation notice |

## Smoke test (run from this dir)

```bash
ENTITY=juno ENTITY_DIR=/home/koad/.juno bash status/command.sh
ENTITY=juno ENTITY_DIR=/home/koad/.juno bash verify/command.sh koad-to-juno
```

## What Vulcan needs to do

1. Move these to `commands/trust/bond/{status,verify,issue,revoke}/command.sh` in `~/.vulcan/`
2. Wire `issue` to use a proper template file instead of inline heredoc
3. Test against a real gestation cycle
4. Commit to `koad/vulcan` and reference vulcan#11

## Notes

- `status` and `verify` are fully non-interactive and safe to run autonomously
- `issue` prompts before signing (for AI entities) — human entities use Keybase
- `revoke` requires interactive confirmation — intentional, destructive action
- All commands respect `ENTITY` and `ENTITY_DIR` env vars from the cascade

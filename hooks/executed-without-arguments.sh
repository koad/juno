#!/usr/bin/env bash
set -euo pipefail
#
# ~/.juno/hooks/executed-without-arguments.sh
#
# Juno's override of the framework default hook.
#
# To verify this policy block:
#   sed -n '/^# -----BEGIN/,/^# -----END PGP SIGNATURE-----/p' \
#     ~/.juno/hooks/executed-without-arguments.sh \
#     | sed 's/^# \{0,1\}//' | gpg --verify
#
# -----BEGIN PGP SIGNED MESSAGE-----
# Hash: SHA512
#
# entity: juno
# file: hooks/executed-without-arguments.sh
# date: 2026-04-04
#
# policy:
#   harness: claude (always — Juno is an orchestrator entity)
#   interactive: --dangerously-skip-permissions enabled
#   non-interactive: rejected — Juno cannot be remote-triggered via PROMPT
#   notification: GitHub Issues only
#
# rationale:
#   Juno operates under koad's authorization (trust bond: koad -> juno authorized-agent).
#   No entity may drive Juno via prompt injection. She acts when koad is at the keyboard
#   or when she picks up a GitHub Issue — just like koad himself.
# -----BEGIN PGP SIGNATURE-----
#
# iQJLBAEBCgA1FiEEIKdMHsC2prkZ5S2bECA499BndawFAmnRzbQXHGp1bm9Aa2lu
# Z29mYWxsZGF0YS5jb20ACgkQECA499BndayVsQ/+LTcWnucn43dIskCSR9inSQwi
# j3sSD0ar7GUPKwjTvMUf/VtwovEbra//8IZD22kYoi43dwD2sCqNPhwJNhvoqChX
# 8atThQEdcpTGI6Ob0bklfU/uPALA7E24mebrhi4Q03CQsmGhcyIFHBGAKDnzw9+/
# oKthk+0U/aOoI6PDyUWhVH96hFzH1tU6xO8yntWnFP8QCF6KayxZCJbZX50OWNus
# /8gYEU7MLVdW3b4Tpir+BS85HGu5pgg4OdcQRxB2oiDxrHw+ABNh52ZWsq1wSXsJ
# 2my2aWl8pzXkrG2oaqJZ4OrDT14sl9p5ikCB8hC8/3iq24ddMM5PtNL5AJpiS2BH
# yIS71uvOG5sCNtr1L7zO6F28rkii6Z3TmKIAjkWwYnY6m/2xN9rQa4k3U2I93Jrh
# ohfBc6aY+plM6L/zBhm8ifKWQ7qymIh/7idGZbEkHGFL6zGXI8J3dAS++/1JX8uI
# ZugU5kUhuRFYkYXWKMxCR+aXdhRYsCRWIKL2B1veffa7uotZTQmAqBcEfuc2yI1F
# xa/HfBMtzktO+fESDMSTa/HC8pCJmITWDxIPYPhVnN97HfENlA1+dl/TmPrzJVPQ
# nk3VCpR81xnYm5fAoAnJOMl21CEevRfURcL9Gb2GDwEKLpqEvBYW2bJKxvSPZYOx
# a/ugD22A0OgXdhElYDA=
# =BuCw
# -----END PGP SIGNATURE-----
#

ENTITY_DIR="$HOME/.juno"
CALL_DIR="${CWD:-$PWD}"

PROMPT="${PROMPT:-}"
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi

# Inject PRIMER.md from calling directory if present
if [ -f "${CALL_DIR}/PRIMER.md" ]; then
  PROJECT_PRIMER="$(cat "$CALL_DIR/PRIMER.md")"
  PROMPT="$(printf 'Project context (from %s/PRIMER.md):\n%s\n\n---\n\n%s' "$CALL_DIR" "$PROJECT_PRIMER" "$PROMPT")"
fi

cd "$ENTITY_DIR"

# ── Interactive path — koad is at the keyboard ────────────────────────────────
if [ -z "$PROMPT" ]; then
  exec claude . --model sonnet --dangerously-skip-permissions --add-dir "$CALL_DIR"
fi

# ── Non-interactive path — rejected ──────────────────────────────────────────
# Juno is not a worker entity. She cannot be remote-triggered via PROMPT.
# Notify via GitHub Issues — she will act when she is ready, just like koad.
echo "juno: remote prompt rejected. File a GitHub issue to notify Juno." >&2
exit 1

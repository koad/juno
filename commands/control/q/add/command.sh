#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
#
# control/q/add — bookmark a question for koad against a brief.
#
# Usage: juno control q add [<brief-slug>] "<question text>" [--from <entity>] [--flight <flight-id>]
#
# Appends a timestamped, attributed line to ~/.juno/control/questions/<brief-slug>.md.
# If brief-slug is omitted, the question is session-scoped (stored under __session__).
# Purpose: overnight unattended flights bookmark their questions here so they
# surface at session start — they no longer depend on a terminal koad may
# never return to.

set -euo pipefail

exec node "${ENTITY_DIR:-$HOME/.juno}/control/app/bin/control.js" q add "$@"

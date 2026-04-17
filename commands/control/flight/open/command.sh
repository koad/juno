#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
#
# control/flight/open — claim a flight in the coordinator registry.
#
# Usage: juno control flight open <brief-slug> [--entity <e>] [--session <s>] [--note <n>] [--work-dir <path>]
#
# Writes a new record to ~/.juno/control/flights/<flight-id>.json with
# status=flying. Prints the flight-id to stdout so the caller can capture it
# and hand it to `juno control flight close <flight-id>` when done.
#
# A single brief may have many concurrent flights (many team members, parallel
# sessions, overnight runs). Each flight is a first-class record.

set -euo pipefail

exec node "${ENTITY_DIR:-$HOME/.juno}/control/app/bin/control.js" flight open "$@"

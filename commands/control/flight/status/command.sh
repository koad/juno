#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
#
# control/flight/status — list flights with optional filters.
#
# Usage: juno control flight status [--brief <slug>] [--entity <e>] [--active] [--json]
#
# Default: all flights, newest first. Stale flights (status=flying but holder
# pid gone on same host, or started > 8h ago) get a "stale"/"stale?" marker.

set -euo pipefail

exec node "${ENTITY_DIR:-$HOME/.juno}/control/app/bin/control.js" flight status "$@"

#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
#
# control/flight/close — land a flight and stamp the ended timestamp.
#
# Usage: juno control flight close <flight-id> [--note <n>] [--no-commit]
#
# Flips status=flying → status=landed and performs the landing commit in the
# flight's work_dir (recorded at open time). On empty flight (nothing to commit)
# lands cleanly with a skip log. On hook failure, leaves status=landing for retry.
# Pass --no-commit to skip the commit and land without one.

set -euo pipefail

exec node "${ENTITY_DIR:-$HOME/.juno}/control/app/bin/control.js" flight close "$@"

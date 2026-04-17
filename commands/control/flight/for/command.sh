#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
#
# control/flight/for — all flights (historical + real-time) for a single brief.
#
# Usage: juno control flight for <brief-slug> [--json]
#
# Sorted oldest → newest. Active flights are flagged; summary line reports
# total / active / landed counts.

set -euo pipefail

exec node "${ENTITY_DIR:-$HOME/.juno}/control/app/bin/control.js" flight for "$@"

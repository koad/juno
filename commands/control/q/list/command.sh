#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
#
# control/q/list — list bookmarked questions, optionally filtered to a brief.
#
# Usage: juno control q list [--brief <slug>]
#
# Prints each question file with its full contents. Session-start may call
# this to surface anything pending from prior flights.

set -euo pipefail

exec node "${ENTITY_DIR:-$HOME/.juno}/control/app/bin/control.js" q list "$@"

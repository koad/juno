#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
#
# control/q/clear — remove all bookmarked questions for a brief.
#
# Usage: juno control q clear <brief-slug>  OR  juno control q clear --session
#
# Deletes the questions file for the named brief, or for the session scope.
# q clear with no args is a no-op with a usage error — not a nuke.
# Use `juno control q list` to see what briefs have open questions.

set -euo pipefail

exec node "${ENTITY_DIR:-$HOME/.juno}/control/app/bin/control.js" q clear "$@"

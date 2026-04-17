#!/usr/bin/env bash
# SPDX-License-Identifier: 0BSD
#
# usage — read the harness sensor state and print a human-readable summary
#
# The statusline hook (shared, ~/.koad-io/commands/harness/claude/statusline.sh)
# tees its rich payload to ~/.<entity>/.local/state/harness/last-payload.json
# on every turn when the entity is rooted. This command reads that file and
# shows the entity what the last harness turn looked like from the outside:
# which model, how much was spent, context window pressure, rate-limit burn,
# reset countdowns.
#
# Part of the self-awareness loop:
#
#   statusline (sensor) -> state file -> `entity usage` read -> awareness
#
# `usage` is the read side that proves the tee is working and gives the
# entity (and operator) a quick way to check current harness state without
# scraping the statusline visually.
#
# Usage:
#   juno usage            pretty summary (default)
#   juno usage --json     raw payload (cat the file)
#   juno usage --path     print the state file path and exit
#   juno usage -h         show help
#
# Exit codes:
#   0  success
#   2  state file missing (entity not rooted, or statusline hasn't fired yet)
#   64 bad args
#   69 jq missing

set -euo pipefail

_entity_dir="${ENTITY_DIR:-$HOME/.juno}"
_state="$_entity_dir/.local/state/harness/last-payload.json"

MODE=pretty

while [ $# -gt 0 ]; do
  case "$1" in
    --json)   MODE=json; shift ;;
    --path)   MODE=path; shift ;;
    -h|--help|help)
      sed -n '3,28p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)
      echo "usage: unknown arg: $1" >&2; exit 64 ;;
  esac
done

if [ "$MODE" = path ]; then
  printf '%s\n' "$_state"
  exit 0
fi

if [ ! -r "$_state" ]; then
  {
    echo "usage: no sensor state at $_state"
    echo
    echo "  The statusline hook writes this file on every turn for rooted"
    echo "  entities. If you're seeing this:"
    echo "    - the entity may not be rooted (KOAD_IO_ROOTED != true)"
    echo "    - the statusline hasn't fired yet in a Claude Code session"
    echo "    - statusLine isn't wired in settings.json"
  } >&2
  exit 2
fi

if [ "$MODE" = json ]; then
  cat "$_state"
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "usage: 'jq' not found on PATH" >&2
  exit 69
fi

# --- Extract fields -------------------------------------------------------

_tsv=$(jq -r '[
  (.model.display_name // .model.id // ""),
  (.model.id // ""),
  (.cost.total_cost_usd // 0),
  (.cost.total_duration_ms // 0),
  (.cost.total_api_duration_ms // 0),
  (.cost.total_lines_added // 0),
  (.cost.total_lines_removed // 0),
  (.context_window.used_percentage // 0),
  (.context_window.total_input_tokens // 0),
  (.context_window.total_output_tokens // 0),
  (.context_window.context_window_size // 0),
  (.rate_limits.five_hour.used_percentage // 0),
  (.rate_limits.five_hour.resets_at // 0),
  (.rate_limits.seven_day.used_percentage // 0),
  (.rate_limits.seven_day.resets_at // 0),
  (.session_id // ""),
  (.cwd // .workspace.current_dir // ""),
  (.version // "")
] | @tsv' "$_state")

IFS=$'\t' read -r \
  _model_name _model_id _cost_usd _dur_ms _api_ms _lines_add _lines_rm \
  _ctx_pct _tok_in _tok_out _ctx_size \
  _5h_pct _5h_reset _7d_pct _7d_reset \
  _session_id _cwd _version \
  <<<"$_tsv"

# --- Helpers --------------------------------------------------------------

_now=$(date +%s)

# File age (seconds since mtime)
_mtime=$(stat -c%Y "$_state" 2>/dev/null || echo "$_now")
_age_s=$(( _now - _mtime ))

fmt_age() {
  local s="$1"
  if [ "$s" -lt 60 ]; then printf '%ds ago' "$s"
  elif [ "$s" -lt 3600 ]; then printf '%dm%ds ago' $((s/60)) $((s%60))
  elif [ "$s" -lt 86400 ]; then printf '%dh%dm ago' $((s/3600)) $(((s%3600)/60))
  else printf '%dd ago' $((s/86400))
  fi
}

fmt_countdown() {
  local ts="$1"
  [ -z "$ts" ] || [ "$ts" = 0 ] && { echo ""; return; }
  local delta=$(( ts - _now ))
  if [ "$delta" -le 0 ]; then echo "now"; return; fi
  if [ "$delta" -lt 3600 ]; then printf '%dm' $((delta/60))
  elif [ "$delta" -lt 86400 ]; then printf '%dh%dm' $((delta/3600)) $(((delta%3600)/60))
  else printf '%dd%dh' $((delta/86400)) $(((delta%86400)/3600))
  fi
}

fmt_reset_at() {
  local ts="$1"
  [ -z "$ts" ] || [ "$ts" = 0 ] && { echo ""; return; }
  date -d "@$ts" '+%a %H:%M' 2>/dev/null || echo ""
}

# pace = elapsed_fraction_of_window - used_fraction_of_quota
#   0  = on pace (burning to hit 100% exactly at reset)
#   +  = slack
#   -  = over-burning
# args: used_pct  resets_at  window_duration_seconds
fmt_pace() {
  local used_pct="$1" resets_at="$2" window="$3"
  [ -z "$resets_at" ] || [ "$resets_at" = 0 ] && { echo ""; return; }
  awk -v used="$used_pct" -v reset="$resets_at" -v now="$_now" -v dur="$window" '
    BEGIN {
      remain = reset - now
      if (remain < 0) remain = 0
      if (remain > dur) remain = dur
      elapsed_frac = 1 - (remain / dur)
      used_frac = used / 100
      pace = elapsed_frac - used_frac
      if (pace > 1) pace = 1
      if (pace < -1) pace = -1
      printf "%+.2f", pace
    }'
}

# pace -> color (green >=+0.10 slack, yellow in ±0.10, red <=-0.10 over-burning)
pace_c() {
  local p="$1"
  [ -z "$p" ] && { printf ''; return; }
  awk -v p="$p" 'BEGIN {
    if (p >= 0.10) printf "\033[32m"
    else if (p <= -0.10) printf "\033[31m"
    else printf "\033[33m"
  }'
}

fmt_duration_ms() {
  local ms="$1"
  local s=$(( ms / 1000 ))
  if [ "$s" -lt 60 ]; then printf '%ds' "$s"
  elif [ "$s" -lt 3600 ]; then printf '%dm%ds' $((s/60)) $((s%60))
  else printf '%dh%dm' $((s/3600)) $(((s%3600)/60))
  fi
}

# pct -> ansi color (green <60, yellow 60-84, red 85+)
pct_c() {
  local p="${1%.*}"
  if [ "$p" -ge 85 ] 2>/dev/null; then printf '\033[31m'
  elif [ "$p" -ge 60 ] 2>/dev/null; then printf '\033[33m'
  else printf '\033[32m'
  fi
}
_R=$'\033[0m'
_dim=$'\033[2m'
_b=$'\033[1m'

# --- Render ---------------------------------------------------------------

_ctx_c=$(pct_c "$_ctx_pct")
_5h_c=$(pct_c "$_5h_pct")
_7d_c=$(pct_c "$_7d_pct")

_cost_fmt=$(printf '%.2f' "$_cost_usd" 2>/dev/null || echo "$_cost_usd")
_dur_fmt=$(fmt_duration_ms "$_dur_ms")
_api_fmt=$(fmt_duration_ms "$_api_ms")
_age_fmt=$(fmt_age "$_age_s")

_5h_cd=$(fmt_countdown "$_5h_reset")
_5h_at=$(fmt_reset_at "$_5h_reset")
_7d_cd=$(fmt_countdown "$_7d_reset")
_7d_at=$(fmt_reset_at "$_7d_reset")

_5h_pace=$(fmt_pace "$_5h_pct" "$_5h_reset" 18000)
_7d_pace=$(fmt_pace "$_7d_pct" "$_7d_reset" 604800)
_5h_pace_c=$(pace_c "$_5h_pace")
_7d_pace_c=$(pace_c "$_7d_pace")

# Header: entity + session
printf '%s%s%s  %ssession%s %s%s%s\n' \
  "$_b" "${ENTITY:-juno}" "$_R" \
  "$_dim" "$_R" "$_dim" "${_session_id:0:8}" "$_R"

printf '%s%s%s  %s%s%s\n\n' \
  "$_dim" "sensor captured $_age_fmt" "$_R" \
  "$_dim" "$_cwd" "$_R"

# Model
printf '  %smodel%s    %s%s%s  %s(%s)%s\n' \
  "$_dim" "$_R" "$_b" "$_model_name" "$_R" "$_dim" "$_model_id" "$_R"

# Cost
printf '  %scost%s     %s$%s%s  %s%s wall / %s api  +%s -%s lines%s\n' \
  "$_dim" "$_R" "$_b" "$_cost_fmt" "$_R" \
  "$_dim" "$_dur_fmt" "$_api_fmt" "$_lines_add" "$_lines_rm" "$_R"

# Context
printf '  %scontext%s  %s%s%%%s  %s(%s in, %s out, %s total)%s\n' \
  "$_dim" "$_R" "$_ctx_c" "${_ctx_pct%.*}" "$_R" \
  "$_dim" "$_tok_in" "$_tok_out" "$_ctx_size" "$_R"

# Rate limits
echo
printf '  %s5h quota%s %s%s%%%s' "$_dim" "$_R" "$_5h_c" "${_5h_pct%.*}" "$_R"
if [ -n "$_5h_pace" ]; then
  printf ' %s(pace %s%s%s)%s' "$_dim" "$_5h_pace_c" "$_5h_pace" "$_R$_dim" "$_R"
fi
if [ -n "$_5h_cd" ]; then
  printf '  %sresets in %s (%s)%s' "$_dim" "$_5h_cd" "$_5h_at" "$_R"
fi
echo

printf '  %s7d quota%s %s%s%%%s' "$_dim" "$_R" "$_7d_c" "${_7d_pct%.*}" "$_R"
if [ -n "$_7d_pace" ]; then
  printf ' %s(pace %s%s%s)%s' "$_dim" "$_7d_pace_c" "$_7d_pace" "$_R$_dim" "$_R"
fi
if [ -n "$_7d_cd" ]; then
  printf '  %sresets in %s (%s)%s' "$_dim" "$_7d_cd" "$_7d_at" "$_R"
fi
echo

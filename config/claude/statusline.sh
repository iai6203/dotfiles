#!/usr/bin/env bash
# Claude Code status line: week N% session N% ctx N%
input=$(cat)

# GNU date(-d)와 BSD date(-r) 모두 지원
fmt_ts() { date -d "@$1" "$2" 2>/dev/null || date -r "$1" "$2"; }

used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

parts=()
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
if [ -n "$week" ]; then
  w=$(printf '\033[01;35mweek %.0f%%\033[00m' "$week")
  if [ -n "$week_reset" ]; then
    w="$w$(printf ' \033[35m(reset %s)\033[00m' "$(fmt_ts "$week_reset" '+%m/%d %H:%M')")"
  fi
  parts+=("$w")
fi
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [ -n "$five" ]; then
  s=$(printf '\033[01;33msession %.0f%%\033[00m' "$five")
  if [ -n "$five_reset" ]; then
    s="$s$(printf ' \033[33m(reset %s)\033[00m' "$(fmt_ts "$five_reset" +%H:%M)")"
  fi
  parts+=("$s")
fi
[ -n "$used" ] && parts+=("$(printf '\033[01;36mctx %.0f%%\033[00m' "$used")")

printf '%s' "${parts[*]}"

#!/usr/bin/env bash
# Waybar custom/agenda: next event of today as text, the coming 7 days as tooltip.
# Reads the local vdir synced by vdirsyncer (see ../../khal/README.md).
set -uo pipefail

export PYTHONWARNINGS=ignore
icon=""
soon_minutes=15

escape() { sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'; }

# Next timed event today that has not started yet ("HH:MM|title").
next=$(khal list now eod --notstarted --format '{start-time}|{title}' --day-format '' 2>/dev/null |
    grep -m1 -E '^[0-9]{2}:[0-9]{2}\|')

text=$icon
class=""
if [[ -n $next ]]; then
    start=${next%%|*}
    title=${next#*|}
    ((${#title} > 30)) && title="${title:0:29}…"
    text="$icon $start $(escape <<<"$title")"
    minutes_left=$((($(date -d "$start" +%s) - $(date +%s)) / 60))
    ((minutes_left <= soon_minutes)) && class="soon"
fi

tooltip=$(khal list now 7d --format '{start-end-time-style} {title}' --day-format '@@{name}, {date}' 2>/dev/null |
    escape |
    sed -E -e 's/^@@(.*)$/<b>\1<\/b>/' -e 's/^ /all day /')
[[ -z $tooltip ]] && tooltip="No events in the next 7 days"

jq --compact-output --null-input \
    --arg text "$text" --arg tooltip "$tooltip" --arg class "$class" \
    '{text: $text, tooltip: $tooltip, class: $class}'

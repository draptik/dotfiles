#!/usr/bin/env bash
# Waybar custom/agenda: next timed event as text, the coming 7 days as tooltip.
# Reads the local vdir synced by vdirsyncer (see ../../khal/README.md).
# In minimal mode (toggled by agenda-toggle.sh) only the icon is shown.
# Calendars hidden via agenda-calendars.sh are excluded.
set -uo pipefail

export PYTHONWARNINGS=ignore
icon=$'\U000f00f0' # nf-md-calendar_clock
soon_minutes=15
state_dir=${XDG_STATE_HOME:-$HOME/.local/state}/waybar-agenda
minimal_flag=$state_dir/minimal
hidden_file=$state_dir/hidden-calendars

# khal aborts on unknown calendar names, so only exclude calendars that still exist.
# Excluding every calendar makes khal show all of them, hence all_hidden.
exclude=()
all_hidden=false
if [[ -s $hidden_file ]]; then
    mapfile -t calendars < <(khal printcalendars 2>/dev/null)
    for cal in "${calendars[@]}"; do
        grep -qFx -- "$cal" "$hidden_file" && exclude+=(-d "$cal")
    done
    ((${#calendars[@]} && ${#exclude[@]} == 2 * ${#calendars[@]})) && all_hidden=true
fi

escape() { sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'; }

# Next timed event of the coming 7 days that has not started yet ("DD.MM.YYYY|HH:MM|title").
next=$($all_hidden || khal list now 7d "${exclude[@]}" --notstarted --format '{start-date}|{start-time}|{title}' --day-format '' 2>/dev/null |
    grep -m1 -E '^[0-9.]+\|[0-9]{2}:[0-9]{2}\|')

text=$icon
class=""
if [[ -n $next ]]; then
    IFS='|' read -r start_date start title <<<"$next"
    IFS=. read -r day month year <<<"$start_date"
    start_iso="$year-$month-$day $start"
    ((${#title} > 30)) && title="${title:0:29}…"
    if [[ $year-$month-$day == "$(date +%F)" ]]; then
        when=$start
        minutes_left=$((($(date -d "$start_iso" +%s) - $(date +%s)) / 60))
        ((minutes_left <= soon_minutes)) && class="soon"
    else
        when="$(date -d "$start_iso" +%a) $start"
    fi
    text="$icon $when $(escape <<<"$title")"
fi
[[ -e $minimal_flag ]] && text=$icon

tooltip=$($all_hidden || khal list now 7d "${exclude[@]}" --format '{start-end-time-style} {title}' --day-format '@@{name}, {date}' 2>/dev/null |
    escape |
    sed -E -e 's/^@@(.*)$/<b>\1<\/b>/' -e 's/^ /all day /')
if $all_hidden; then
    tooltip="All calendars hidden (middle-click to pick)"
elif [[ -z $tooltip ]]; then
    tooltip="No events in the next 7 days"
fi

jq --compact-output --null-input \
    --arg text "$text" --arg tooltip "$tooltip" --arg class "$class" \
    '{text: $text, tooltip: $tooltip, class: $class}'

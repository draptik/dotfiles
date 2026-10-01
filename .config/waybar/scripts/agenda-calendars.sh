#!/usr/bin/env bash
# Pick which calendars custom/agenda shows: Enter toggles a calendar, Esc closes.
# Hidden calendars are stored one per line (khal display names) and read by agenda.sh.
# Bound to middle-click on the module and Mod+Ctrl+G in sway/niri.
set -uo pipefail

export PYTHONWARNINGS=ignore
state_dir=${XDG_STATE_HOME:-$HOME/.local/state}/waybar-agenda
hidden_file=$state_dir/hidden-calendars
shown=$'\U000f0132'  # nf-md-checkbox_marked
hidden=$'\U000f0131' # nf-md-checkbox_blank_outline

mkdir -p "$state_dir" && touch "$hidden_file"
mapfile -t calendars < <(khal printcalendars 2>/dev/null)
((${#calendars[@]})) || exit 1

row=0
while true; do
    menu=$(for cal in "${calendars[@]}"; do
        if grep -qFx -- "$cal" "$hidden_file"; then
            echo "$hidden  $cal"
        else
            echo "$shown  $cal"
        fi
    done)
    row=$(rofi -dmenu -i -no-custom -format i -selected-row "$row" \
        -p "Agenda calendars" -mesg "Enter: show/hide · Esc: close" <<<"$menu") || break
    cal=${calendars[row]}
    if grep -qFx -- "$cal" "$hidden_file"; then
        grep -vFx -- "$cal" "$hidden_file" >"$hidden_file.tmp"
        mv "$hidden_file.tmp" "$hidden_file"
    else
        echo "$cal" >>"$hidden_file"
    fi
    # Must match "signal" of custom/agenda in the waybar config.
    pkill -RTMIN+8 -x waybar
done

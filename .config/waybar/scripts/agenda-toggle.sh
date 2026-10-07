#!/usr/bin/env bash
# Toggle custom/agenda between full and minimal (icon only) and refresh waybar.
# Bound to right-click on the module and Mod+Shift+G in sway/niri.
set -uo pipefail

state_dir=${XDG_STATE_HOME:-$HOME/.local/state}/waybar-agenda
flag=$state_dir/minimal

if [[ -e $flag ]]; then
  rm -f "$flag"
else
  mkdir -p "$state_dir" && touch "$flag"
fi

# Must match "signal" of custom/agenda in the waybar config.
pkill -RTMIN+8 -x waybar

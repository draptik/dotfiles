#!/bin/bash
#
# Purpose:
#
# This script toggles the laptop's internal keyboard.
# It also toggles the laptop's internal keyboard backlight.
#
# Scenario:
#
# Linux/SwayWM on Lenovo Laptop with ZSA Voyager Keyboard.
#
# Why?
#
# When travelling I don't have any external monitors.
#
# I want to physically place the Voyager keyboard on top of my laptop keyboard
# without triggering keyboard events from the "underlying" keyboard by accident.
#
# Requirements:
#
# - sway
# - notify-send
# - jq

set -euo pipefail

# Early exit in case the script is not executed in a sway context
if ! swaymsg -t get_inputs -r >/dev/null 2>&1; then
  notify-send "⚠️ Sway is not running, cannot toggle keyboard."
  exit 1
fi

# Internal keyboard identifier from swaymsg -t get_inputs
INTERNAL_KB="1:1:AT_Translated_Set_2_keyboard"
VOYAGER_ID=$(lsusb | grep -i voyager | awk '{print $6}')

# Backlight device name is located in `/sys/class/leds/`
# Search for a folder containing "kbd_backlight"
BACKLIGHT_DEVICE="tpacpi::kbd_backlight"
BACKLIGHT_FOLDER="/sys/class/leds/${BACKLIGHT_DEVICE}"
BRIGHTNESS_OFF=0
# On my laptop, the maximum brightness value is stored in the file `max_brightness`
BRIGHTNESS_ON=$(<"${BACKLIGHT_FOLDER}/max_brightness")

# This function requires `visudo` permissions for the `tee` command.
# Create a file `keyboard-watcher` (or any other name) in
# folder `/etc/sudoers.d/` with the folllowing content:
#
#   yourusername ALL=(ALL) NOPASSWD: /usr/bin/tee
#
# This function requires an input argument of `0` or `2` (see
# $BRIGHTNESS_ON and $BRIGHTNESS_OFF)
set_backlight() {
  echo "$1" | sudo tee "${BACKLIGHT_FOLDER}/brightness" >/dev/null
}

# Get current internal keyboard status
current_internal_status=$(swaymsg -t get_inputs -r |
  jq -r ".[] | select(.identifier==\"${INTERNAL_KB}\") | .libinput.send_events")

# Toggle based on current internal status
if [[ "${current_internal_status}" == "enabled" ]]; then
  # Only disable internal keyboard if external keyboard is present
  if lsusb | grep -Fq "${VOYAGER_ID}"; then
    swaymsg input "${INTERNAL_KB}" events disabled
    set_backlight "${BRIGHTNESS_OFF}"
    notify-send "🔒 Internal keyboard disabled"
  fi
else
  swaymsg input "${INTERNAL_KB}" events enabled
  set_backlight "${BRIGHTNESS_ON}"
  notify-send "🔓 Internal keyboard enabled"
fi

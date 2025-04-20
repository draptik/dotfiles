#!/bin/bash
#
# Purpose:
#
# This script toggles the laptop's internal keyboard.
#
# Scenario:
#
# Linux/SwayWM on Lenovo Laptop with ZSA Voyager Keyboard
#
# Requirements:
#
# - sway
# - notify-send
# - jq

# Internal keyboard identifier from swaymsg -t get_inputs
INTERNAL_KB="1:1:AT_Translated_Set_2_keyboard"
VOYAGER_ID="3297:1977"

# Get current status of the internal keyboard
current_internal_status=$(swaymsg -t get_inputs -r |
  jq -r ".[] | select(.identifier==\"$INTERNAL_KB\") | .libinput.send_events")

# Toggle based on current status
if [ "$current_internal_status" = "enabled" ]; then
  # only disable internal keyboard if external keyboard is present
  if lsusb | grep -q "$VOYAGER_ID"; then
    swaymsg input "$INTERNAL_KB" events disabled
    notify-send "🔒 Internal keyboard disabled"
  fi
else
  swaymsg input "$INTERNAL_KB" events enabled
  notify-send "🔓 Internal keyboard enabled"
fi

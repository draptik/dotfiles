#!/bin/bash
#
# Purpose:
#
# This script toggles the laptop's internal keyboard when a ZSA Voyager keyboard is attached/detached.
#
# Scenario:
#
# Linux/SwayWM on Lenovo Laptop with ZSA Voyager Keyboard
#
# Why?
#
# When travelling I don't have any external monitors.
#
# I want to physically place the Voyager keyboard on top of my laptop keyboard
# without triggering keyboard events from the "underlying" keyboard by accident.
#
# This seems to work, and it also disables the keyboard backlight on my Lenovo laptop.
#
# Obviously, adapt to your needs...
#
VOYAGER_ID="3297:1977"
INTERNAL_KB="1:1:AT_Translated_Set_2_keyboard"
LOGFILE="$HOME/keyboard-watcher.log"

# Backlight device name is located in `/sys/class/leds/`
# Search for a folder containing "kbd_backlight"
BACKLIGHT_DEVICE="tpacpi::kbd_backlight"
BRIGHTNESS_MAX=2

log() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $*" >>"${LOGFILE}"
}

internal_kb_disabled=false

# Invoke with 0 (turn off backlight) or max value for backlight brightness
#
# This requires `visudo` permissions:
#
#   sudo cat /etc/sudoers.d/keyboard-watcher
#
#   homer ALL=(ALL) NOPASSWD: /usr/bin/tee
set_backlight() {
  log "Skipping backlight function ..."
  #echo "$1" | sudo tee "/sys/class/leds/$BACKLIGHT_DEVICE/brightness" >/dev/null
  #log "Set keyboard backlight to $1"
}

disable_internal_keyboard() {
  if [ "$internal_kb_disabled" = false ]; then
    swaymsg input "$INTERNAL_KB" events disabled && internal_kb_disabled=true
    set_backlight 0
    log "Internal keyboard disabled"
  else
    log "Internal keyboard already disabled, skipping"
  fi
}

enable_internal_keyboard() {
  if [ "$internal_kb_disabled" = true ]; then
    swaymsg input "$INTERNAL_KB" events enabled && internal_kb_disabled=false
    set_backlight "$BRIGHTNESS_MAX"
    log "Internal keyboard enabled"
  else
    log "Internal keyboard already enabled, skipping"
  fi
}

monitor_usb() {
  log "Starting USB monitor..."
  udevadm monitor --udev --subsystem-match=usb | while read -r line; do
    log "$line"

    if echo "$line" | grep -q -E "add|remove"; then
      if lsusb | grep -q "$VOYAGER_ID"; then
        log "lsusb: Found Voyager"
        disable_internal_keyboard
      else
        log "lsusb: Could not find Voyager"
        enable_internal_keyboard
      fi
    fi
  done
}

log "starting..."
monitor_usb

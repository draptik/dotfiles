#!/bin/bash

VOYAGER_ID="3297:1977"
INTERNAL_KB="1:1:AT_Translated_Set_2_keyboard"

log() {
  echo "[$(date)] $*" >>~/keyboard-watcher.log
}

monitor_usb() {
  udevadm monitor --udev --subsystem-match=usb | while read -r line; do

    log "$line"

    if echo "$line" | grep -q "add"; then
      # New USB device connected. Check if it's the Voyager
      if lsusb | grep -q "$VOYAGER_ID"; then
        log "Voyager connected: disabling internal keyboard"
        swaymsg input "$INTERNAL_KB" events disabled
      fi
    elif echo "$line" | grep -q "remove"; then
      # USB device removed: check if Voyager is now gone
      if ! lsusb | grep -q "$VOYAGER_ID"; then
        log "Voyager disconnected: enabling internal keyboard"
        swaymsg input "$INTERNAL_KB" events enabled
      fi
    fi
  done
}

log "starting..."
monitor_usb

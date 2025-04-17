#!/bin/bash

VOYAGER_ID="3297:1977"
INTERNAL_KB="1:1:AT_Translated_Set_2_keyboard"
LOGFILE="$HOME/keyboard-watcher.log"

log() {
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $*" >>"${LOGFILE}"
}

internal_kb_disabled=false

disable_internal_keyboard() {
  if [ "$internal_kb_disabled" = false ]; then
    swaymsg input "$INTERNAL_KB" events disabled && internal_kb_disabled=true
    log "Internal keyboard disabled"
  else
    log "Internal keyboard already disabled, skipping"
  fi
}

enable_internal_keyboard() {
  if [ "$internal_kb_disabled" = true ]; then
    swaymsg input "$INTERNAL_KB" events enabled && internal_kb_disabled=false
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

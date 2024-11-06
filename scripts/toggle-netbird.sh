#!/bin/bash

# Check if netbird command is available before executing it
if ! which netbird >/dev/null; then
  echo "Error: NetBird command not found."
  exit 1
fi

# Toggle NetBird connection state based on the signal status
NETBIRD_SIGNAL=$(netbird status | grep -oP '(?<=Signal: )\w+')
if [ "$NETBIRD_SIGNAL" = "Disconnected" ]; then
  netbird up
else
  netbird down
fi

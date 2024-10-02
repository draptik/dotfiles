#!/bin/bash
#
# Toggle VPN connection.
#
# Requirements:
#
# - command `nmcli`
# - a text file `~/.my-vpn-name.txt` containing the name of the VPN connection.
#
# Setup:
#
# Add script to path. Example (`~/bin/` is in path`):
#
# `ln -s ~/.dotfiles/sh_common_aliases/toggle-vpn.sh ~/bin/toggle-vpn`

# Check if the 'nmcli' command is available
if ! command -v nmcli &>/dev/null; then
  echo "'nmcli' command not found. Please install NetworkManager to use this script."
  exit 1
fi

# This file should only contain the name of the VPN connection
VPN_FILE="${HOME}/.my-vpn-name.txt"

# Check if VPN_FILE exists
if [ ! -f "$VPN_FILE" ]; then
  echo "The file does not exist: $VPN_FILE"
  exit 1
fi

VPN_NAME=$(cat "$VPN_FILE")

# Check if VPN_NAME is empty
if [ -z "$VPN_NAME" ]; then
  echo "The VPN connection name is empty in the file."
  exit 1
fi

# Check the status of the VPN connection
if nmcli connection show --active | grep -q "$VPN_NAME"; then
  # If VPN is active, disconnect it
  echo "Disconnecting VPN: $VPN_NAME"
  if nmcli connection down id "$VPN_NAME"; then
    echo "VPN $VPN_NAME disconnected successfully."
  else
    echo "Failed to disconnect VPN $VPN_NAME."
  fi
else
  # If VPN is not active, connect it
  echo "Connecting to VPN: $VPN_NAME"
  if nmcli connection up id "$VPN_NAME"; then
    echo "VPN $VPN_NAME connected successfully."
  else
    echo "Failed to connect to VPN $VPN_NAME."
  fi
fi

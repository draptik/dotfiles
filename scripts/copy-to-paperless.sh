#!/bin/bash
#
# Copies file(s) to paperless inbox.
#
# Requirements:
#
# - `scp` (we could also use `rsync`, but for this scenario it does not make a difference...)
# - a text file `~/.my-paperless-inbox.txt` containing the name of the paperless inbox.
#   format: `<username>@<machine-name>:<paperless-inbox-folder-name>`

# If no arguments are provided: return
if [ $# -eq 0 ]; then
  echo "No arguments provided"
  return 1
fi

# This file should only contain the name of the VPN connection
PAPERLESS_FILE="${HOME}/.my-paperless-inbox.txt"

# Check if PAPERLESS_FILE exists
if [ ! -f "$PAPERLESS_FILE" ]; then
  echo "The file does not exist: $PAPERLESS_FILE"
  exit 1
fi

PAPERLESS_INBOX=$(cat "$PAPERLESS_FILE")

# Check if PAPERLESS_INBOX is empty
if [ -z "$PAPERLESS_INBOX" ]; then
  echo "The PAPERLESS_INBOX variable is empty."
  exit 1
fi

# Pass all input arguments to scp and copy them to the paperless-inbox
scp "$@" "$PAPERLESS_INBOX/"

exit 0

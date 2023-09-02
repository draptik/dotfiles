#!/bin/sh

# If no arguments are provided: return
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    return 1
fi

PAPERLESS_INBOX="patrick@sheep:paperless-inbox"

# Pass all input arguments to scp and copy them to the paperless-inbox
scp "$@" "$PAPERLESS_INBOX/"

exit 0

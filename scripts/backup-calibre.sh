#!/bin/bash
set -euo pipefail

CALIBRE_LIBRARY_LOCATION="$HOME/library/calibre-library/"

# Bail out if calibre (GUI) or the content server is running, to avoid
# backing up metadata.db mid-write.
if pgrep -f "/usr/bin/calibre($| )" >/dev/null || pgrep -f "/usr/bin/calibre-server($| )" >/dev/null; then
  echo "#### $(date +%T) calibre is running - skipping backup #######################################"
  exit 1
fi

# shellcheck disable=SC2043
for i in /mnt/archive; do
  if [[ -d $i/backup/$HOSTNAME/rsync-calibre ]]; then
    echo "#### $(date +%T) rsync calibre backup $i starting #######################################"
    logfile="/tmp/.rsync-calibre-$(basename $i).log"
    rm -rf "$i/backup/$HOSTNAME/rsync-calibre/last/"
    mkdir -p "$i/backup/$HOSTNAME/rsync-calibre/current/"
    cp -a --reflink=auto "$i/backup/$HOSTNAME/rsync-calibre/current" "$i/backup/$HOSTNAME/rsync-calibre/last"
    mkdir -p "$i/backup/$HOSTNAME/rsync-calibre/current/"
    rsync -aAXHq --delete-before \
      "${CALIBRE_LIBRARY_LOCATION}" "$i/backup/$HOSTNAME/rsync-calibre/current/" | tee -a "$logfile"
  else
    echo "#### $(date +%T) rsync calibre backup not possible #######################################"
  fi
done

sync
echo "#### $(date +%T) sync complete #######################################"

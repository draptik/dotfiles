#!/bin/bash

exclude_file="./backup-laptop-excludes.txt"

# shellcheck disable=SC2043
for i in /mnt/archive; do

  backupfile="$i/backup/$HOSTNAME/tar/current.tar.zst"

  if [[ -d $i/backup/$HOSTNAME/tar ]]; then
    echo "#### $(date +%T) tar ${i} starting ######################################"
    logfile="/tmp/.tar-$(basename $i).log"
    sudo touch "$i/backup/$HOSTNAME/tar/current.tar.zst"
    sudo mv \
      "$i/backup/$HOSTNAME/tar/current.tar.zst" \
      "$i/backup/$HOSTNAME/tar/last.tar.zst"

    sudo tar \
      --exclude-from="$exclude_file" \
      --acls --xattrs -cpaf \
      "$backupfile" / |
      tee -a "$logfile"
  else
    echo "#### $(date +%T) tar ${i} is unavailabe ######################################"
  fi
done

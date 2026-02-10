#!/bin/bash
# shellcheck disable=SC2043
for i in /mnt/archive; do
  if [[ -d $i/backup/$HOSTNAME/bsdtar ]]; then
    echo "#### $(date +%T) bsdtar ${i} starting ######################################"
    logfile="/tmp/.bsdtar-$(basename $i).log"
    sudo touch "$i/backup/$HOSTNAME/bsdtar/current.tar.zst"
    sudo mv "$i/backup/$HOSTNAME/bsdtar/current.tar.zst" "$i/backup/$HOSTNAME/bsdtar/last.tar.zst"
    sudo bsdtar \
      --exclude='/etc/pacman.d/gnupg/*' \
      --exclude='/dev/*' \
      --exclude="$HOME/.cache/ibus/*" \
      --exclude="$HOME/.dropbox/*" \
      --exclude="$HOME/.local/share/JetBrains/Toolbox/apps/*" \
      --exclude="$HOME/.ollama/*" \
      --exclude="$HOME/cloud/*" \
      --exclude="$HOME/Documents/private-git/*" \
      --exclude="$HOME/Downloads/*" \
      --exclude="$HOME/Music/*" \
      --exclude="$HOME/projects/*" \
      --exclude="$HOME/Public/os/*" \
      --exclude="$HOME/transient/*" \
      --exclude='/home/.snapshots/*' \
      --exclude='/lost+found/' \
      --exclude='/media/*' \
      --exclude='/mnt/*' \
      --exclude='/proc/*' \
      --exclude='/run/*' \
      --exclude='/.snapshots/*' \
      --exclude='/srv/minio/*' \
      --exclude='/sys/*' \
      --exclude='/tmp/*' \
      --exclude='/var/lib/docker/volumes/*' \
      --exclude='/var/lib/libvirt/images/*' \
      --exclude='/var/.snapshots/*' \
      --acls --xattrs -cpaf "$i/backup/$HOSTNAME/bsdtar/current.tar.zst" / | tee -a "$logfile"
  else
    echo "#### $(date +%T) bsdtar ${i} is unavailabe ######################################"
  fi
done

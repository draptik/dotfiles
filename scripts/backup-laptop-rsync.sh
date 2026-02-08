for i in /mnt/archive; do
  if [[ -d $i/backup/$HOSTNAME/rsync ]] ; then
    echo "#### $(date +%T) rsync full system backup $i starting #######################################"
    logfile="/tmp/.rsync-$(basename $i).log"
    sudo rm -rf $i/backup/$HOSTNAME/rsync/last/
    sudo mkdir -p $i/backup/$HOSTNAME/rsync/current/
    sudo cp -a --reflink=auto $i/backup/$HOSTNAME/rsync/current $i/backup/$HOSTNAME/rsync/last
    sudo mkdir -p $i/backup/$HOSTNAME/rsync/current/
    sudo rsync -aAXHq --delete-before \
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
      --exclude='/var/lib/libvirt/images/*' \
      --exclude='/var/.snapshots/*' \
      / $i/backup/$HOSTNAME/rsync/current/ | tee -a $logfile
  else
    echo "#### $(date +%T) rsync full system backup not possible #######################################"
  fi
done

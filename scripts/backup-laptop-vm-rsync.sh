#!/usr/bin/env bash
# libvirt-backup.sh — simple rsync-based backup for libvirt VMs

set -euo pipefail

# --- Configuration ---
BACKUP_DEST="/mnt/archive/backup/fly/libvirt"
LOG="/var/log/libvirt-backup.log"

SOURCES=(
  "/etc/libvirt"
  "/var/lib/libvirt/images"
  "/var/lib/libvirt/qemu/nvram"
  "/var/lib/libvirt/qemu/snapshot"
)

# --- Helpers ---
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"; }

# --- Pre-flight checks ---
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if ! command -v rsync &>/dev/null; then
  echo "rsync is not installed." >&2
  exit 1
fi

mkdir -p "$BACKUP_DEST"

# --- Abort if any VMs are running ---
RUNNING=$(virsh list --name 2>/dev/null | grep -c '\S' || true)
if [[ $RUNNING -gt 0 ]]; then
  log "ERROR: $RUNNING VM(s) are still running. Shut them down before backing up."
  virsh list --name | grep '\S'
  exit 1
fi

# --- Backup ---
log "Starting libvirt backup to $BACKUP_DEST"

for SRC in "${SOURCES[@]}"; do
  if [[ -d "$SRC" ]]; then
    log "Syncing $SRC ..."
    rsync -aAX --delete \
      --log-file="$LOG" \
      "$SRC" "$BACKUP_DEST/"
  else
    log "Skipping $SRC (not found)"
  fi
done

log "Backup complete."

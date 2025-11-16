#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# fit-backup.sh
#
# Safely create a trimmed, space-efficient backup image of an SD card or drive.
#
# Features:
#   • Takes two arguments:  <source device>  and  <output image file>.
#     Example:  sudo ./fit-backup.sh /dev/sdb rpi-backup_2025_11_12.img
#   • Automatically determines the end of the last used partition and backs up
#     only the meaningful data region, not the entire card capacity.
#   • Avoids wasted space and “oversized” images that don’t fit on equal cards.
#   • Refuses to run if any partitions of the source device are mounted to
#     avoid capturing an inconsistent live filesystem.
#   • Uses bs=4M and conv=noerror,sync for reliable reads with padding on
#     errors, and shows progress during the copy.
#
# Usage:
#     sudo ./fit-backup.sh /dev/mmcblk0 rpi-backup.img
#
# Result:
#     Creates a compact image containing all partitions up to the last used
#     sector of the device, suitable for later restoration with fit-restore.sh.
# -----------------------------------------------------------------------------
set -euo pipefail

usage() {
  echo "Usage: $0 <source-device> <output-image>"
  echo "Example: $0 /dev/mmcblk0 rpi-backup_2025_11_12.img"
  exit 1
}

[[ $# -eq 2 ]] || usage

DEV="$1"
IMG="$2"

# Must be root
if [[ "$EUID" -ne 0 ]]; then
  echo "ERROR: This script must be run as root (try: sudo $0 ...)" >&2
  exit 1
fi

# Basic checks
[[ -b "$DEV" ]] || {
  echo "ERROR: Not a block device: $DEV" >&2
  exit 2
}

if [[ -e "$IMG" ]]; then
  echo "ERROR: Output image already exists: $IMG" >&2
  echo "Refusing to overwrite. Choose a different filename or remove it."
  exit 3
fi

# Check if source device or any of its partitions are mounted
if findmnt -rno TARGET -S "$DEV" >/dev/null 2>&1 ||
  findmnt -rno TARGET -S "${DEV}"?* >/dev/null 2>&1; then
  echo "ERROR: $DEV (or one of its partitions) appears to be mounted." >&2
  echo "Unmount all partitions before backing up to avoid an inconsistent image." >&2
  exit 4
fi

# Ensure parted is available
if ! command -v parted >/dev/null 2>&1; then
  echo "ERROR: 'parted' is required but not installed. Install it with:" >&2
  echo "       sudo apt install parted" >&2
  exit 5
fi

# Get device size
BYTES_DEV=$(blockdev --getsize64 "$DEV")
echo "Device: $DEV"
echo "Total device size: ${BYTES_DEV} bytes"

# Use parted to find end of last partition in sectors
PARTED_OUT=$(parted -ms "$DEV" unit s print || true)

LAST_SECTOR=""
if [[ -n "$PARTED_OUT" ]]; then
  LAST_SECTOR=$(echo "$PARTED_OUT" | awk -F: '/^[0-9]+:/{ gsub("s","",$3); last=$3 } END{ if (last != "") print last }')
fi

if [[ -n "$LAST_SECTOR" ]]; then
  # Convert last sector to bytes (sector size assumed 512 for SD cards)
  BYTES_BACKUP=$(((LAST_SECTOR + 1) * 512))
  # Safety: do not exceed device size
  if ((BYTES_BACKUP > BYTES_DEV)); then
    BYTES_BACKUP="$BYTES_DEV"
  fi
  echo "Last partition ends at sector: $LAST_SECTOR"
else
  # Fallback: no partitions detected or parted failed; back up full device
  BYTES_BACKUP="$BYTES_DEV"
  echo "WARNING: Could not determine last partition end. Backing up full device."
fi

echo "Backup size (bytes to copy): ${BYTES_BACKUP}"
echo "Output image will be:        ${IMG}"
echo
echo "About to READ from $DEV and WRITE to $IMG"
read -rp "Type 'YES' to proceed: " CONFIRM
[[ "$CONFIRM" == "YES" ]] || {
  echo "Aborted."
  exit 0
}

# Perform the backup
# iflag=count_bytes: count is interpreted as bytes, not blocks
dd if="$DEV" bs=4M iflag=count_bytes count="$BYTES_BACKUP" conv=noerror,sync status=progress | xz -T0 -3 -c >"${IMG}.xz"

sync
echo "Backup complete: $IMG"

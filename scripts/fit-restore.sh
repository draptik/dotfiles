#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# fit-restore.sh
#
# Safely restore a Raspberry Pi (or other) disk image onto an SD card or drive.
#
# Features:
#   • Takes two arguments:  <image file>  and  <target device>  (e.g. /dev/sdb)
#   • Automatically detects the device size in bytes.
#   • If the image is slightly larger than the device, makes a temporary
#     trimmed copy matching the device capacity before writing.
#   • Refuses to run if the target device or its partitions are mounted.
#   • Uses bs=4M and conv=fsync for fast, reliable, fully-flushed writes.
#   • Prompts for confirmation before overwriting the target.
#
# Usage:
#     sudo ./fit-restore.sh rpi-backup.img /dev/sdX
#
# Result:
#     Writes the image (or a trimmed copy) to the device, ensuring the restore
#     fits exactly and avoids the “no space left on device” error.
# -----------------------------------------------------------------------------
set -euo pipefail

usage() {
  echo "Usage: $0 <image.img> <block-device>"
  echo "Example: $0 rpi-cow_2025_10_17.img /dev/sdb"
  exit 1
}

[[ $# -eq 2 ]] || usage

IMG="$1"
DEV="$2"

# Basic checks
[[ -f "$IMG" ]] || {
  echo "ERROR: Image not found: $IMG"
  exit 2
}
[[ -b "$DEV" ]] || {
  echo "ERROR: Not a block device: $DEV"
  exit 3
}

# Warn if the device (or its partitions) are mounted
if findmnt -rno TARGET -S "$DEV" >/dev/null 2>&1 || findmnt -rno TARGET -S "${DEV}?"* >/dev/null 2>&1; then
  echo "ERROR: $DEV (or one of its partitions) appears to be mounted."
  echo "Unmount it first (e.g., sudo umount /dev/sdX1 /dev/sdX2 ...)."
  exit 4
fi

# Get sizes
BYTES_DEV=$(sudo blockdev --getsize64 "$DEV")
BYTES_IMG=$(stat -c%s "$IMG")

echo "Device size: ${BYTES_DEV} bytes"
echo "Image size : ${BYTES_IMG} bytes"

# Decide what to write
FIT_IMG="$IMG.fit"

if ((BYTES_IMG > BYTES_DEV)); then
  echo "Image is larger than device. Creating trimmed copy: $FIT_IMG"
  cp "$IMG" "$FIT_IMG"
  truncate -s "$BYTES_DEV" "$FIT_IMG"
  WRITE_IMG="$FIT_IMG"
else
  echo "Image fits device. No trimming needed."
  WRITE_IMG="$IMG"
fi

echo
echo "About to WRITE to $DEV from $WRITE_IMG"
echo "This will destroy all data on $DEV."
read -rp "Type 'YES' to proceed: " CONFIRM
[[ "$CONFIRM" == "YES" ]] || {
  echo "Aborted."
  exit 0
}

# Restore (aligned, flushed)
sudo dd if="$WRITE_IMG" of="$DEV" bs=4M conv=fsync status=progress

# Optional: clean up trimmed copy if we created one
if [[ "$WRITE_IMG" == "$FIT_IMG" ]]; then
  echo "Trimmed copy used: $FIT_IMG"
  # Uncomment to auto-remove:
  # rm -f "$FIT_IMG"
fi

echo "Done."

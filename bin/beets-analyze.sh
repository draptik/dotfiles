#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# analyze-beets.sh
#
# Analyzes the results of a beets import by comparing the music library
# on disk against what beets has in its database.
#
# Usage: ./analyze-beets.sh [music-dir] [beets-config]
#
# Example:
#   ./analyze-beets.sh /mnt/nas-music /home/patrick/.config/beets/config.yaml
# -----------------------------------------------------------------------------
set -euo pipefail

MUSIC_DIR="${1:-/mnt/nas-music}"
BEETS_CONFIG="${2:-$HOME/.config/beets/config.yaml}"
REPORT_DIR="$HOME/beets-report"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$REPORT_DIR"

echo "Analyzing beets import results..."
echo "Music directory: $MUSIC_DIR"
echo "Beets config:    $BEETS_CONFIG"
echo "Report output:   $REPORT_DIR"
echo

# ── 1. All tracks in beets database ──────────────────────────────────────────
echo "Collecting imported tracks from beets database..."
beet --config "$BEETS_CONFIG" list --format '$path' | sort >"$REPORT_DIR/imported.txt"
IMPORTED=$(wc -l <"$REPORT_DIR/imported.txt")
echo "  → $IMPORTED tracks in beets database"

# ── 2. All audio files on disk ───────────────────────────────────────────────
echo "Scanning audio files on disk..."
find "$MUSIC_DIR" -type f \( \
  -iname "*.mp3" -o \
  -iname "*.flac" -o \
  -iname "*.ogg" -o \
  -iname "*.m4a" -o \
  -iname "*.aac" -o \
  -iname "*.wma" -o \
  -iname "*.wav" -o \
  -iname "*.ape" \
  \) | sort >"$REPORT_DIR/all-files.txt"
TOTAL=$(wc -l <"$REPORT_DIR/all-files.txt")
echo "  → $TOTAL audio files on disk"

# ── 3. Files NOT in beets database (skipped/failed) ──────────────────────────
echo "Finding skipped/unmatched files..."
comm -23 "$REPORT_DIR/all-files.txt" "$REPORT_DIR/imported.txt" >"$REPORT_DIR/skipped.txt"
SKIPPED=$(wc -l <"$REPORT_DIR/skipped.txt")
echo "  → $SKIPPED files not imported"

# ── 4. Summary report ────────────────────────────────────────────────────────
REPORT="$REPORT_DIR/summary_$TIMESTAMP.txt"
cat >"$REPORT" <<EOF
Beets Import Analysis — $(date)
════════════════════════════════════════
Music directory : $MUSIC_DIR
Beets config    : $BEETS_CONFIG

Total audio files on disk : $TOTAL
Successfully imported     : $IMPORTED
Skipped / not matched     : $SKIPPED

════════════════════════════════════════
SKIPPED FILES:
$(cat "$REPORT_DIR/skipped.txt")
EOF

echo
echo "Done! Report written to: $REPORT"
echo
echo "Quick summary:"
echo "  Total audio files : $TOTAL"
echo "  Imported          : $IMPORTED"
echo "  Skipped           : $SKIPPED"

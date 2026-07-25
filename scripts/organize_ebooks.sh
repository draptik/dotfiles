#!/usr/bin/env bash
#
# organize_ebooks.sh
# Wrapper to invoke organize_ebooks.py with sane defaults and basic checks.
#
# USAGE:
#   ./organize_ebooks.sh /path/to/source /path/to/output [--copy] [--move] [--dry-run] [--formats pdf,epub,...]
#
# Example:
#   ./organize_ebooks.sh ~/Downloads/Books ~/Books-Organized --dry-run
#
set -euo pipefail

# Directory this script lives in (assumes organize_ebooks.py is alongside it).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="${SCRIPT_DIR}/organize_ebooks.py"

# Allow overriding which python interpreter to use, e.g. PYTHON_BIN=python3.11
PYTHON_BIN="${PYTHON_BIN:-python3}"

if ! command -v "${PYTHON_BIN}" >/dev/null 2>&1; then
  echo "ERROR: '${PYTHON_BIN}' not found on PATH. Install Python 3 or set PYTHON_BIN." >&2
  exit 1
fi

if [[ ! -f "${PYTHON_SCRIPT}" ]]; then
  echo "ERROR: Could not find organize_ebooks.py in ${SCRIPT_DIR}" >&2
  echo "Place this shell script in the same folder as organize_ebooks.py, or edit PYTHON_SCRIPT above." >&2
  exit 1
fi

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 /path/to/source /path/to/output [--copy] [--move] [--dry-run] [--formats pdf,epub,...]" >&2
  exit 1
fi

exec "${PYTHON_BIN}" "${PYTHON_SCRIPT}" "$@"

#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'

TERMINAL=kitty

# Folder is passed in as $1, fallback to ~/notes
folder="$(realpath -m -- "${1:-$HOME/notes}")"
readonly folder

menu() {
  # usage: menu "Prompt" [lines]
  local prompt="$1"
  local lines="${2:-5}"
  rofi -dmenu -i -p "$prompt" -l "$lines"
}

# Resolve a directory name so it always stays INSIDE $folder
resolve_dir_in_folder() {
  local input="${1:-.}"
  local real_folder candidate real_candidate

  # Canonicalize base folder
  real_folder="$(realpath -m -- "$folder")"

  # Treat user input as relative to folder
  input="${input#/}"
  [[ -z "$input" ]] && input="."

  candidate="$real_folder/$input"
  real_candidate="$(realpath -m -- "$candidate")"

  # Ensure result is inside folder
  case "$real_candidate" in
  "$real_folder" | "$real_folder"/*) ;;
  *) return 1 ;;
  esac

  printf '%s\n' "$real_candidate"
}

newnote() {
  local dir_choice dir_abs name file

  # Show directories RELATIVE to $folder
  dir_choice="$(
    {
      printf '%s\n' "."
      find "$folder" -mindepth 1 -type d -printf '%P\n' 2>/dev/null | sort
    } | menu 'Choose directory (relative to notes)' 10
  )" || exit 0
  : "${dir_choice:=.}"

  if ! dir_abs="$(resolve_dir_in_folder "$dir_choice")"; then
    exit 0
  fi

  name="$(printf '\n' | menu 'Enter a name (without extension)' 0)" || exit 0
  : "${name:=$(date +%F_%H-%M-%S)}"

  file="$dir_abs/$name.md"
  setsid -f "$TERMINAL" -e nvim "$file" >/dev/null 2>&1
}

selected() {
  local choice

  choice="$(
    {
      printf '%s\n' "New"
      find "$folder" -type f -printf '%T@ %P\n' 2>/dev/null |
        sort -nr |
        cut -d' ' -f2-
    } | menu "Choose note or create new" 20
  )" || exit 0

  case "$choice" in
  New)
    newnote
    ;;
  *.md)
    setsid -f "$TERMINAL" -e nvim "$folder/$choice" >/dev/null 2>&1
    ;;
  *)
    exit
    ;;
  esac
}

selected

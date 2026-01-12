#!/usr/bin/env bash

TERMINAL=kitty
folder=$HOME/notes/

newnote() {
  dir="$(
    {
      printf '%s\n' "$folder"
      find "$folder" -mindepth 1 -maxdepth 1 -type d -print
    } |
      dmenu -l 5 -i -p 'Choose directory: '
  )" || exit 0
  : "${dir:=$folder}"
  name="$(echo "" | dmenu -sb "#a3be8c" -nf "#d8dee9" -p "Enter a name (without extension): " <&-)" || exit 0
  : "${name:=$(date +%F_%H-%M-%S)}"
  setsid -f "$TERMINAL" -e nvim "$dir$name.md" >/dev/null 2>&1
}

selected() {
  choice=$(
    {
      echo "New"
      find "$folder" -type f -printf '%T@ %P\n' |
        sort -nr |
        cut -d' ' -f2-
    } | dmenu -l 5 -i -p "Choose note or create new: "
  )
  case "$choice" in
  New) newnote ;;
  *.md) setsid -f "$TERMINAL" -e nvim "$folder$choice" >/dev/null 2>&1 ;;
  *) exit ;;
  esac
}

selected

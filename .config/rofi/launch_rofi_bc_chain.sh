#!/usr/bin/env bash
set -euo pipefail

last=""

while true; do
  # Show last result as a hint; user can type new expression
  expr="$(
    rofi -dmenu -p "bc" \
      -mesg "Enter expression. Use 'ans' for last result. (Esc to quit)  Last: ${last:-—}" \
      -no-fixed-num-lines
  )" || exit 0 # Esc / cancel

  # Empty input => quit
  [[ -z "${expr// /}" ]] && exit 0

  # Replace 'ans' with last result (if available)
  if [[ -n "$last" ]]; then
    expr="${expr//ans/$last}"
  fi

  # Evaluate
  out="$(printf '%s\n' "$expr" | bc -l 2>&1)" || true

  # If bc errored, show error and continue
  if [[ "$out" == *"error"* || "$out" == *"syntax"* ]]; then
    rofi -e "$out"
    continue
  fi

  # bc may output multiple lines; take the last non-empty one as "answer"
  last="$(printf '%s\n' "$out" | awk 'NF{v=$0} END{print v}')"

  # Copy answer (Wayland); remove this line if you don't want clipboard
  printf '%s' "$last" | wl-copy

  # Optional: show the computed line briefly (you’ll see it as the next prompt anyway)
done

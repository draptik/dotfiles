#!/bin/bash
echo "wtf"

# Make sure we always use the current directory when calling other scripts
# https://stackoverflow.com/a/246128/1062607
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# called by i3 window manager:
# bindsym $mod+Return exec "<this-folder>/<this-file>"

# if KITTY_THEME is not defined: use LIGHT
#
# `-z` checks for zero-length
if [[ -z "${KITTY_THEME}" ]]; then
    echo "1"
    KITTY_THEME="LIGHT"
fi

if [[ "${KITTY_THEME}" -eq "DARK" ]]; then
    echo "2"
    "${DIR}"/switch-dark.sh
elif [[ "${KITTY_THEME}" -eq "LIGHT" ]]; then
    echo "3"
    "${DIR}"/switch-light.sh
fi

echo "starting kitty..."
#kitty -v --debug-config
kitty

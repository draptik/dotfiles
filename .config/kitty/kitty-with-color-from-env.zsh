#!/bin/zsh

# zsh: https://unix.stackexchange.com/a/115431/57915
DIR=${0:a:h}

# if KITTY_THEME is not defined: use LIGHT
#
# `-v` checks if variable is set in zsh
if [[ -v "${KITTY_THEME}" ]]; then
    KITTY_THEME="LIGHT"
fi

if [[ "${KITTY_THEME}" == "DARK" ]]; then
    "${DIR}"/switch-dark.sh
elif [[ "${KITTY_THEME}" == "LIGHT" ]]; then
    "${DIR}"/switch-light.sh
fi

kitty

#!/bin/sh

echo 'export KITTY_THEME="LIGHT"' >~/.zshenv

ln -sf ~/.dotfiles/.config/ghostty/config-light config

~/.dotfiles/sh_common_aliases/switch-to-light.sh

exec /bin/zsh

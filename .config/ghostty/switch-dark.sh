#!/bin/sh

echo 'export KITTY_THEME="DARK"' >~/.zshenv

ln -sf ~/.dotfiles/.config/ghostty/config-dark config

~/.dotfiles/sh_common_aliases/switch-to-dark.sh

exec /bin/zsh

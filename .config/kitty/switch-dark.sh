#!/bin/bash
echo 'export KITTY_THEME="DARK"' >~/.zshenv

# This script must be executed from within kitty
# Also see the `background-opacity` value in the currently used `kitty.conf`
kitty @ set-background-opacity 1

## This line must be executed from within kitty
kitty @ set-colors -a ~/.config/kitty/kitty-themes/themes/Tango_Dark.conf

ln -sf \
  ~/.dotfiles/.config/kitty/kitty-themes/themes/Tango_Dark.conf \
  ~/.dotfiles/.config/kitty/theme.conf

~/.dotfiles/sh_common_aliases/switch-to-dark.sh

~/.dotfiles/.config/ranger/switch-to-kitty-dark.sh

## Reload zsh configs
##
## "Sourcing" `source ~/.zshrc` didn't work. Use `exec /bin/zsh` instead:
exec /bin/zsh

## Same for bash...
exec /bin/bash

#!/bin/sh

## This line must be executed from within kitty
kitty @ set-colors -a /home/patrick/.config/kitty/kitty-themes/themes/Tango_Dark.conf

~/.dotfiles/sh_common_aliases/switch-to-dark.sh

~/.dotfiles/.config/ranger/switch-to-kitty-dark.sh

export KITTY_THEME="DARK"

## Reload zsh configs
##
## "Sourcing" `source ~/.zshrc` didn't work. Use `exec /bin/zsh` instead:
exec /bin/zsh 

## Same for bash...
exec /bin/bash

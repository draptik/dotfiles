#!/bin/sh
echo "dark script starting..."
## This line must be executed from within kitty
kitty @ set-colors -a ~/.config/kitty/kitty-themes/themes/Tango_Dark.conf

~/.dotfiles/sh_common_aliases/switch-to-dark.sh

~/.dotfiles/.config/ranger/switch-to-kitty-dark.sh

export KITTY_THEME="DARK"

## Reload zsh configs
##
## "Sourcing" `source ~/.zshrc` didn't work. Use `exec /bin/zsh` instead:
echo "dark script zsh"
exec /bin/zsh 

## Same for bash...
echo "dark script bash"
exec /bin/bash
echo "dark script done"

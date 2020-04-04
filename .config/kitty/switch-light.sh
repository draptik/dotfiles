#!/bin/sh

# This script must be executed from within kitty
kitty @ set-colors -a /home/patrick/.config/kitty/kitty-themes/mythemes/Tango_Light_patched.conf

# switch shell aliases
~/.dotfiles/sh_common_aliases/switch-to-light.sh

# ranger (has to know the terminal: image support)
~/.dotfiles/.config/ranger/switch-to-kitty-light.sh

export KITTY_THEME="LIGHT"

## "Sourcing" `source ~/.zshrc` didn't work. Use `exec /bin/zsh` instead:
exec /bin/zsh 

## Same for bash...
exec /bin/bash

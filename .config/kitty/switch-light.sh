#!/bin/sh

echo 'export KITTY_THEME="LIGHT"' >~/.zshenv

# This script must be executed from within kitty
# Light background is used in presentations: so no opacity!
kitty @ set-background-opacity 1

# This script must be executed from within kitty
kitty @ set-colors -a ~/.config/kitty/kitty-themes/themes/3024_Day.conf

ln -sf \
  ~/.dotfiles/.config/kitty/kitty-themes/themes/3024_Day.conf \
  ~/.dotfiles/.config/kitty/theme.conf

# switch shell aliases
~/.dotfiles/sh_common_aliases/switch-to-light.sh

# ranger (has to know the terminal: image support)
~/.dotfiles/.config/ranger/switch-to-kitty-light.sh

## "Sourcing" `source ~/.zshrc` didn't work. Use `exec /bin/zsh` instead:
exec /bin/zsh

## Same for bash...
exec /bin/bash

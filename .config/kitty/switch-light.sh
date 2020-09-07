#!/bin/sh

echo 'export KITTY_THEME="LIGHT"' > ~/.zshenv

# This script must be executed from within kitty
kitty @ set-colors -a ~/.config/kitty/kitty-themes/mythemes/Tango_Light_patched.conf

ln -sf \
    ~/.dotfiles/.config/kitty/kitty-themes/mythemes/Tango_Light_patched.conf \
    ~/.dotfiles/.config/kitty/theme.conf

# switch shell aliases
~/.dotfiles/sh_common_aliases/switch-to-light.sh

# ranger (has to know the terminal: image support)
~/.dotfiles/.config/ranger/switch-to-kitty-light.sh

## "Sourcing" `source ~/.zshrc` didn't work. Use `exec /bin/zsh` instead:
exec /bin/zsh 

## Same for bash...
exec /bin/bash

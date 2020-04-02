#!/bin/sh

# This script should be executed from within kitty

kitty @ set-colors -a /home/patrick/.config/kitty/kitty-themes/themes/Tango_Light.conf

#./switch-other-apps-to-light.sh
~/.dotfiles/sh_common_aliases/switch-to-light.sh


## "Sourcing" `source ~/.zshrc` didn't work. Use `exec /bin/zsh` instead:
exec /bin/zsh 

## Same for bash...
exec /bin/bash
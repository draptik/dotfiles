#!/bin/sh
# -*- mode: sh -*-

# some more ls aliases
alias ll='ls -lAF'
alias la='ls -lAh'
alias l='ls -CF'
alias lt='ls -Alhrt'

## Projecteur
alias projecteur='projecteur --cfg ~/.dotfiles/projecteur-logitech-spotlight/projecteur.config'

## ripgrep, fd, and fzf
## https://bluz71.github.io/2018/06/07/ripgrep-fd-command-line-search-tools.html
export FZF_DEFAULT_COMMAND='fd --type f --color=never'
export FZF_ALT_C_COMMAND='fd --type d . --color=never'

## flameshot (screenshot tool)
alias flameshot='flameshot gui -p ~/screenshots'
alias screenshot='flameshot'

## exa
alias le='exa -la --icons --git --group-directories-first'

## include themes aliases
source ~/.dotfiles/sh_common_aliases/themed_aliases

## Switch between kitty themes

if [ "$TERM" = "xterm-kitty" ]; then
    # echo "Kitty rules"

    alias darkkitty='~/.dotfiles/.config/kitty/switch-dark.sh'
    alias lightkitty='~/.dotfiles/.config/kitty/switch-light.sh'

    if [ "$KITTY_THEME" = "DARK" ]; then
        alias togglekitty='~/.dotfiles/.config/kitty/switch-light.sh'
    else
        alias togglekitty='~/.dotfiles/.config/kitty/switch-dark.sh'
    fi
else
    # echo "not kitty"
    # only change the common aliases in gnome-terminal:
    #echo "not a kitty terminal"
    true
fi

# Load patched xmodmap: caps lock now behaves like windows key
xmodmap ~/.Xmodmap

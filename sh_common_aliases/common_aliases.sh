#!/bin/sh
# -*- mode: sh -*-

# some more ls aliases
alias ll='ls -lAF'
alias la='ls -lAh'
#alias l='ls -CF'
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
alias le='exa -la --group --color-scale --icons --git --group-directories-first'

## eza
## NOTE: In case the option `--color-scale` crashes in certain folders,
## make sure there are no files/folders with an invalid btime.
## This can be checked using `ls -altr --time=birth .`.
alias l='eza --all --long --group --icons --git --git-repos --group-directories-first --color-scale'

## bat
alias bat='bat --theme=ansi'

## ChatGPT OpenAI
if [ -f ~/.openai-key.txt ]; then
    OPENAI_KEY=$(cat ~/.openai-key.txt)
    export OPENAI_KEY
fi

## include themes aliases
# shellcheck disable=SC3046,SC1090
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

    ## https://sw.kovidgoyal.net/kitty/faq/#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-when-sshing-into-a-different-computer
    alias ssh="kitty +kitten ssh"
else
    # echo "not kitty"
    # only change the common aliases in gnome-terminal:
    #echo "not a kitty terminal"
    true
fi

# Load patched xmodmap: caps lock now behaves like windows key
#xmodmap ~/.Xmodmap

## When using Sway, set environment for rider
if [ "$XDG_SESSION_DESKTOP" = "sway" ]; then
    alias riderx="_JAVA_AWT_WM_NONREPARENTING=1 /usr/share/rider/bin/rider.sh %f"
fi

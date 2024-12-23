#!/bin/sh
# -*- mode: sh -*-

# some more ls aliases
alias ll='ls -lAF'
alias la='ls -lAh'

## ripgrep, fd, and fzf
## https://bluz71.github.io/2018/06/07/ripgrep-fd-command-line-search-tools.html
export FZF_DEFAULT_COMMAND='fd --type f --color=never'
export FZF_ALT_C_COMMAND='fd --type d . --color=never'

## flameshot (screenshot tool)
alias flameshot='flameshot gui -p ~/screenshots'
alias screenshot='flameshot'

## eza
## NOTE: In case the option `--color-scale` crashes in certain folders,
## make sure there are no files/folders with an invalid btime.
## This can be checked using `ls -altr --time=birth .`.
alias l='eza --all --long --group --icons --git --git-repos --group-directories-first --color-scale'
alias lt='l --sort=modified'
alias ltr='lt --reverse'

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
  if [ "$KITTY_THEME" = "DARK" ]; then
    alias togglekitty='~/.dotfiles/.config/kitty/switch-light.sh'
  else
    alias togglekitty='~/.dotfiles/.config/kitty/switch-dark.sh'
  fi

  ## https://sw.kovidgoyal.net/kitty/faq/#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-when-sshing-into-a-different-computer
  alias ssh="kitty +kitten ssh"
fi

# Custom aliases for current projects
if [ -f ~/cloud/Nextcloud/klog-time-tracker/aliases.sh ]; then
  # shellcheck disable=SC1090
  . ~/cloud/Nextcloud/klog-time-tracker/aliases.sh
fi

alias task='go-task'

# PNPM
if [ -d "$HOME/.local/share/pnpm" ]; then
  export PNPM_HOME="$HOME/.local/share/pnpm"
  export PATH="$PNPM_HOME:$PATH"
fi

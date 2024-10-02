# vim:ft=zsh:ts=2:sw=2:

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="~/.oh-my-zsh"

# THEMES
#ZSH_THEME="agnoster"
#ZSH_THEME="robbyrussel"
#ZSH_THEME="avit"

DEFAULT_USER=patrick

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#
# PD oh-my-zsh (installed via arch linux)
plugins=(
  git
  git-auto-fetch
  archlinux
  sudo
  fzf
  extract
  emoji
)

ZSH="/usr/share/oh-my-zsh"

source $ZSH/oh-my-zsh.sh

# git plugin: Unset `gdu` alias (it's in conflict with the tool `gdu`)
case $(type gdu) in
  (*alias*) unalias gdu;;
esac

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

alias zshconfig="vim ~/.zshrc"

# smart move/rename with zmv
autoload zmv
# zrename: Usage example:
# zrename *.pdf foo-*.pdf
alias zrename="noglob zmv -W"

# zsh-autosuggestions (installed via arch linux)
[[ -r "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# configure color of autosuggestion
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"

# zsh-syntax-highlighting (installed via arch linux)
[[ -r "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# command-not-found (installed via arch linux: pkgfile)
## initialize the pkgfile database once using `sudo pkgfile -u`
[[ -r "/usr/share/doc/pkgfile/command-not-found.zsh" ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

# the-fuck (installed via arch linux)
if (( ${+commands[thefuck]} )); then
  eval $(thefuck --alias)
fi

# broot (installed via arch linux)
source ~/.config/broot/launcher/bash/br

# xkcd for kitty
source ~/.dotfiles/zsh/.oh-my-zsh/custom/function-xkcd.zsh

# Load common aliases shared between bash and zsh. Also handles light/dark theme switching.
source ~/.dotfiles/sh_common_aliases/common_aliases.sh

# dotnet
#export PATH=$PATH:/opt/dotnet
#export DOTNET_ROOT="$(dirname $(which dotnet))"
#export DOTNET_ROOT=/opt/dotnet

# Add .NET Core SDK tools
export PATH="$PATH:/home/patrick/.dotnet/tools"

# dotnet core completions: https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete#zsh
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  # If the completion is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}

compctl -K _dotnet_zsh_complete dotnet

# java: use system default (set via `archlinux-java`)
unset JAVA_HOME

# make sure that PATH only contains unique entries
# https://unix.stackexchange.com/a/62599/57915
typeset -U path

# add ~/bin to PATH
path+=(~/bin)
#path+=(~/.dotnet)

# Haskell ghcup
# prepend to path (don't append)
path=(~/.ghcup/bin $path)

# NVM
[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
if [[ -a "/usr/share/nvm/nvm.sh" ]]; then
  source /usr/share/nvm/nvm.sh
  source /usr/share/nvm/bash_completion
  source /usr/share/nvm/install-nvm-exec
fi

# place this after nvm initialization!
#
# From https://github.com/nvm-sh/nvm#nvmrc
#
# Usage: if an `.nvmrc` file is found defining a specific nvm version to use, use it automatically
autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
# Only load nvm stuff if nvm is installed
if [ -f /usr/share/nvm/nvm.sh ]; then
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

# atuin (alternative to McFly)
eval "$(atuin init zsh)"

# arch package: starship-bin
if (( ${+commands[starship]} )); then
  eval "$(starship init zsh)"
fi

# NNN (file manager)
if type nnn &> /dev/null; then
  export NNN_FIFO=/tmp/nnn.fifo
  export NNN_PLUG="p:preview-tui"
fi

# Ripgrep configuration
export RIPGREP_CONFIG_PATH=~/.dotfiles/.config/ripgrep/ripgreprc

# SSH: Echo timestamp after closing the connection -----------------------------
#
# Always echo the current time if the previous command starts with 'ssh'
# 
# Why?
#
# I find this info useful when restarting remote server(s) via ssh: 
# "When can I consider testing the rebooted server/service?"
#
# In the past I just manually entered the current time at the prompt. 
# This saves me the hassle.
typeset -U ssh_connected # flag indicating if an ssh connection is active

precmd() {
  if [[ -n "$ssh_connected" ]]; then
    echo "SSH connection closed at: $(date +%T)"
    ssh_connected=() # unset the flag
  fi
}

ssh_with_logout_time() {
  # When using kitty terminal: 
  # I already aliased the 'ssh' command to use kitty's kittens feature.
  # Therefore I need to check if we are currently using zsh in kitty.
  if [ "$TERM" = "xterm-kitty" ]; then
    command kitty +kitten ssh "$@"
  else
    command ssh "$@"
  fi

  ssh_connected=1 # set the flag
}

alias ssh="ssh_with_logout_time"

# direnv https://direnv.net
if [ -e "/usr/bin/direnv" ]; then
  eval "$(direnv hook zsh)"
fi

# ------------------------------------------------------------------------------

# not sure why, but somehow starship messes with auto_cd feature.
# unsetopt/setopt seems to fix auto_cd
#unsetopt auto_cd
#setopt auto_cd

export VISUAL=nvim
export EDITOR="$VISUAL"

# zoxide ----------------------------------------------------------------------
if (( ${+commands[zoxide]} )); then
  eval "$(zoxide init --cmd cd zsh)"
fi

# tmux history ----------------------------------------------------------------
# This ensures that zsh within tmux writes to history
setopt inc_append_history

# Nix -------------------------------------------------------------------------
export PATH="$PATH:$HOME/.nix-profile/bin"

# dnvm (dotnet version manager) -----------------------------------------------
#if [ -f "$HOME/.local/share/dnvm/env" ]; then
#    . "$HOME/.local/share/dnvm/env"
#fi

# klog ------------------------------------------------------------------------
if (( ${+commands[klog]} )); then
  source <(klog completion -c zsh)
fi

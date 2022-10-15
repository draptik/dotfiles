# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="~/.oh-my-zsh"

# THEMES
#ZSH_THEME="agnoster"
#ZSH_THEME="robbyrussel"
#ZSH_THEME="avit"

# Theme Liquid Prompt: Only load Liquid Prompt in interactive shells, not from a script or from scp
#[[ $- = *i* ]] && source /usr/bin/liquidprompt
## Use starship prompt instead. Starship is loaded at end of file.

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
# DISABLE_UNTRACKED_FILES_DIRTY="true"

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
    z
)

ZSH="/usr/share/oh-my-zsh"

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

alias zshconfig="vim ~/.zshrc"

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
eval $(thefuck --alias)

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

# dotnet core completions https://khalidabuhakmeh.com/dotnet-core-tab-completion-with-zsh
_dotnet_zsh_complete()
{
    local completions=("$(dotnet complete "$words")")

    reply=( "${(ps:\n:)completions}" )
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

# McFly (arch package: mcfly)
if [[ -r "/usr/share/doc/mcfly/mcfly.zsh" ]]; then
    source "/usr/share/doc/mcfly/mcfly.zsh"
fi

# arch package: starship-bin
eval "$(starship init zsh)"

# NNN (file manager)
if type nnn &> /dev/null; then
    export NNN_FIFO=/tmp/nnn.fifo
    export NNN_PLUG="p:preview-tui"
fi

# Ripgrep configuration
export RIPGREP_CONFIG_PATH=~/.dotfiles/.config/ripgrep/ripgreprc

# not sure why, but somehow starship messes with auto_cd feature.
# unsetopt/setopt seems to fix auto_cd
unsetopt auto_cd
setopt auto_cd

export VISUAL=vim
export EDITOR="$VISUAL"

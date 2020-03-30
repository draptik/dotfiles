
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

source /home/patrick/.config/broot/launcher/bash/br

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/patrick/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Prompt themes
autoload -Uz promptinit
promptinit

# Powerline
#powerline-daemon -q
#. /usr/lib/python3.8/site-packages/powerline/bindings/zsh/powerline.zsh

# Oh-my-zsh
plugins=(
    archlinux
    git
    zsh-autosuggestions
    zsh-syntax-hightlighting
    )

ZSH_THEME="agnoster"

# Aliases
alias lc='colorls -lA --sd --gs'

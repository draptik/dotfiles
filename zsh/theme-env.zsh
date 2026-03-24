# shellcheck shell=bash
# Theme-sensitive zsh config — safe to source multiple times
# Sourced at startup from .zshrc and live by the `theme` function

# zsh-syntax-highlighting colors
# shellcheck disable=SC2034,SC2154  # false positives: shellcheck doesn't understand zsh associative array subscripts
if (( ${+ZSH_HIGHLIGHT_STYLES} )); then
  if [[ "$KITTY_THEME" == "DARK" ]]; then
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=yellow'
  else
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=24'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=24'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=26'
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=30'
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=32'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=26,bold'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=26,bold'
  fi
fi

# eza: disable color-scale on light themes (white = unreadable for newest/largest)
if [ "$KITTY_THEME" = "LIGHT" ]; then
  alias l='eza --all --long --group --icons --git --git-repos --group-directories-first'
else
  alias l='eza --all --long --group --icons --git --git-repos --group-directories-first --color-scale'
fi

# LS_COLORS: always derive from the base captured at startup to stay idempotent
if [[ "$KITTY_THEME" == "DARK" ]]; then
  export LS_COLORS="${_BASE_LS_COLORS}:ln=01;36"
else
  export LS_COLORS="${_BASE_LS_COLORS}:ln=01;34"
fi

#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

ln -sf "${DIR}"/aliases_theme_light "${DIR}"/themed_aliases

# switch btop's theme
ln -sf "${DIR}"/../.config/btop/btop_light.conf "${DIR}"/../.config/btop/btop.conf

# switch klog's theme
ln -sf "${DIR}"/../.config/klog/klog_light.ini "${DIR}"/../.config/klog/config.ini

# switch eza
ln -sf "${DIR}"/../.config/eza/theme-light.yml "${DIR}"/../.config/eza/theme.yml

# switch starship
ln -sf "${DIR}"/../.config/starship-prompt/starship-light.toml "${DIR}"/../.config/starship-prompt/starship.toml

# switch tldr
ln -sf "${DIR}"/../.config/tealdeer/config-light.toml "${DIR}"/../.config/tealdeer/config.toml

# switch glow
ln -sf "${DIR}"/../.config/glow/glow-light.yml "${DIR}"/../.config/glow/glow.yml

# switch rofi
ln -sf "${DIR}"/../.config/rofi/theme-light.rasi "${DIR}"/../.config/rofi/theme.rasi

# switch dunst
ln -sf "${DIR}"/../.config/dunst/theme-light.conf "${DIR}"/../.config/dunst/dunstrc.d/50-theme.conf
dunstctl reload 2>/dev/null

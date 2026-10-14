#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

ln -sf "${DIR}"/aliases_theme_dark "${DIR}"/themed_aliases

# switch btop's theme
ln -sf "${DIR}"/../.config/btop/btop_dark.conf "${DIR}"/../.config/btop/btop.conf

# switch klog's theme
ln -sf "${DIR}"/../.config/klog/klog_dark.ini "${DIR}"/../.config/klog/config.ini

# switch eza
ln -sf "${DIR}"/../.config/eza/theme-dark.yml "${DIR}"/../.config/eza/theme.yml

# switch starship
ln -sf "${DIR}"/../.config/starship-prompt/starship-dark.toml "${DIR}"/../.config/starship-prompt/starship.toml

# switch tldr
ln -sf "${DIR}"/../.config/tealdeer/config-dark.toml "${DIR}"/../.config/tealdeer/config.toml

# switch glow
ln -sf "${DIR}"/../.config/glow/glow-dark.yml "${DIR}"/../.config/glow/glow.yml

# switch rofi
ln -sf "${DIR}"/../.config/rofi/theme-dark.rasi "${DIR}"/../.config/rofi/theme.rasi

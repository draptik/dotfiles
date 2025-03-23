#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

ln -sf "${DIR}"/aliases_theme_dark "${DIR}"/themed_aliases

# switch btop's theme
ln -sf "${DIR}"/../.config/btop/btop_dark.conf "${DIR}"/../.config/btop/btop.conf

# switch klog's theme
ln -sf "${DIR}"/../.config/klog/klog_dark.ini "${DIR}"/../.config/klog/config.ini

# switch eza
ln -sf "${DIR}"/../.config/eza/theme-dark.yml "${DIR}"/../.config/eza/theme.yml

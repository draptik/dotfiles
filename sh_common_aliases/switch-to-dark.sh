#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

ln -sf "${DIR}"/aliases_theme_dark "${DIR}"/themed_aliases

# switch btop's theme
ln -sf "${DIR}"/../.config/btop/btop_dark.conf "${DIR}"/../.config/btop/btop.conf

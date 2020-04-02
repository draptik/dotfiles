#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rm ${DIR}/themed_aliases

ln -s ${DIR}/aliases_theme_dark ${DIR}/themed_aliases


#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rm ${DIR}/theme.conf

ln -s ${DIR}/kitty-themes/themes/CLRS.conf theme.conf

## Switch other apps to light theme and reload current shell
${DIR}/switch-other-apps-to-light.sh


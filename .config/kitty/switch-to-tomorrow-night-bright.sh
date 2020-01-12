#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rm ${DIR}/theme.conf

ln -s ${DIR}/kitty-themes/themes/Tomorrow_Night_Bright.conf theme.conf


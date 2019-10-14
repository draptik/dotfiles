#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rm ${DIR}/theme.conf

ln -s ${DIR}/kitty-themes/themes/Solarized_Light.conf ${DIR}/theme.conf


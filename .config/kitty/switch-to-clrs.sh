#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#rm ${DIR}/theme.conf
ln -sf ${DIR}/kitty-themes/themes/CLRS.conf theme.conf


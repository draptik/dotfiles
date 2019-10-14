#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rm ${DIR}/rc.conf
ln -s ${DIR}/rc.original.conf ${DIR}/rc.conf

rm scope.sh
ln -s ${DIR}/scope-light.sh ${DIR}/scope.sh


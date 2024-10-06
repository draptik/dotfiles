#!/bin/bash
#
# Remove all 'bin' and 'obj' folders recursively.
#
# For details, see https://stackoverflow.com/a/755433
#
find . -iname "bin" -print0 | xargs -0 rm -rf
find . -iname "obj" -print0 | xargs -0 rm -rf

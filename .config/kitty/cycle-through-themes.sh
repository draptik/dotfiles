#!/bin/zsh
##
## just an experiment...
##
## Cycling through all kitty color themes

THEME_FOLDER="kitty-themes/themes"

cnt=0
for file in $THEME_FOLDER/*(.); do
    # only loop through first 2 elements
    if [[ $cnt -ge 2 ]]; then exit 0; fi

    # Sample: access iterator and cnt
    echo $file + $cnt;
    cnt=$((cnt+1));

    # kitty stuff starts here

done


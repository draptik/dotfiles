#!/bin/bash

cliphist list | rofi -dmenu -b -p "Clipboard" -i | cliphist decode | wl-copy

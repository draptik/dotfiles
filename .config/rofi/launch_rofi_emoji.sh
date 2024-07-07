#!/bin/bash

# Requires arch packages rofimoji
#
# For some reason the default rofimoji.rc config file does not work.
# I'll add the "--action=copy" here - this works.
#
rofi -modi "emoji:rofimoji --action=copy" -show emoji

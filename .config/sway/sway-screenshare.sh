#!/usr/bin/zsh

# Script from https://audijo.de/posts/screen-sharing-in-sway/

# softlink from ~/bin/ (~/bin must be in $PATH)

# share-screen
#
# This script starts or restarts `xdg-desktop-portal` and
# `xdg-desktop-portal-wlr`. While doing so the currently focused output (read
# screen) is passed to `xdg-desktop-portal-wlr`. This makes the respective
# screen available for sharing in apps and websites that can do so.
#
# Usage:
#
# Still a bit clunky, but it works with spatialchat...
# When selecting the screen from the browser app (ie spacialchat) we have to (1) use the crosshair
# to select the screen, then (2) click on the selection in the browser app modal window, and then
# (3) again click on the actual screen being used.

echo "Keep this shell alive as long as screen sharing is taking place..."

export XDG_CURRENT_DESKTOP=sway

#output=$(swaymsg -pt get_outputs | grep focused | awk '{print $2}')
/usr/lib/xdg-desktop-portal -r & /usr/lib/xdg-desktop-portal-wlr -r &

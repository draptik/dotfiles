#!/usr/bin/env bash

## Lockscreen script
## Lockicon downloaded from https://creazilla.com/nodes/58783-locked-emoji-clipart
## No modifications were made on the lockicon
## Lockicon License: https://creativecommons.org/licenses/by/4.0/

## Uses swaylock-effects

## No --screenshots / --effect-*: swaylock-effects mishandles outputs
## hotplugged after locking (red screen, wedged input, hard reboot).
swaylock --daemonize --clock --indicator \
  --color 2E3440 \
  --indicator-radius 100 \
  --indicator-thickness 12 \
  --ring-color 2E3440 \
  --key-hl-color ECEFF4 \
  --line-color 88C0D0 \
  --inside-color 00000088 \
  --separator-color 00000000 \
  --datestr %Y-%m-%d \
  --timestr %H:%M \
  --text-color ECEFF4 \
  --text-caps-lock-color ECEFF4 \
  --show-failed-attempts \
  --fade-in 3 \
  --grace 10

#!/usr/bin/env bash

## Lockscreen script

## Uses upstream swaylock, not swaylock-effects: swaylock-effects takes
## screenshots (even without --screenshots, e.g. for --fade-in) and
## segfaults when an output is hotplugged while locked. sway then keeps
## the session locked with red outputs and no input.
swaylock --daemonize --indicator-idle-visible \
  --ignore-empty-password \
  --indicator-caps-lock \
  --color 2E3440 \
  --indicator-radius 100 \
  --indicator-thickness 12 \
  --ring-color 2E3440 \
  --key-hl-color ECEFF4 \
  --line-color 88C0D0 \
  --inside-color 00000088 \
  --separator-color 00000000 \
  --text-color ECEFF4 \
  --text-caps-lock-color ECEFF4 \
  --show-failed-attempts

#!/bin/bash
emacs -Q --batch \
  -l "$HOME/.dotfiles/emacs/update-clocktables.el" \
  "$1"

#!/bin/bash
#
# Script to backup LazyVim setup.

mv ~/.config/nvim{,.lazyvim_backup}
mv ~/.local/share/nvim{,.lazyvim_backup}
mv ~/.local/state/nvim{,.lazyvim_backup}
mv ~/.cache/nvim{,.lazyvim_backup}

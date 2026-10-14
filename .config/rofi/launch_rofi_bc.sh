#!/bin/bash

# Requires linux program `bc`

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

rofi -show calc -modi "calc:$SCRIPT_DIR/rofi_bc.py" -p "bc"

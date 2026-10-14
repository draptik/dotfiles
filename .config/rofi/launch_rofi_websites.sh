#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

rofi -show websites -modi "websites:$SCRIPT_DIR/website_launcher.py"

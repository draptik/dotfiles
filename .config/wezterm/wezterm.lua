-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = {}

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "terminal.sexy"

config.font = wezterm.font("JetBrains Mono")
config.font_size = 9.0

-- and finally, return the configuration to wezterm
return config

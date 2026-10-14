# Ranger

- image preview does work when using `ranger` within `tmux`
- image preview with kitty requires arch package `python-pillow`
- The previews are configured in the `scope` files.
- The actual ranger theme is defined in `rc.conf`: search for the variable `colorscheme`.
  - There are only 4 color themes to choose from: `default`, `jungle`, `snow`, and `solarized`
  - Although the color of directory highlighting is a bit light for my taste,
    it's still better than the alternatives.

## Markdown preview

- Markdown files (`.md`, `.markdown`) are previewed with `glow` (arch package `glow`).
- The style is set explicitly per scope file: `light` in `scope-light.sh`, `dark` in `scope.original.sh`.
  glow can't detect the terminal background when its output is piped to ranger.
- glow wraps links in OSC 8 hyperlink escapes, which ranger can't render (garbled lines).
  They are stripped with `sed`; glow has no option to disable them.
- If glow is not installed, the preview falls back to `bat`.

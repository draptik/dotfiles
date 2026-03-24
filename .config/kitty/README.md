# README

`~/.config/kitty` should link to this folder (via `ln -s`).

`kitty.conf` should be a soft link pointing to the desired config file. Example: `ln -sf
kitty-main.conf kitty.conf`

## Usage: theme switching

From any terminal (kitty, ghostty, tmux, or plain shell):

```sh
theme        # toggle
theme dark   # explicit
theme light  # explicit
```

The `theme` command lives in `~/.dotfiles/bin/theme`. It updates all
terminal configs (kitty, ghostty, tmux) and shared tools in one go.
Inside kitty, colors are applied live to all open windows via IPC.

## Light themes

Light themes which work ok-ish with programs like `bat`, `ranger`, `colorls`, `exa`, etc.:

- CLRS
- Material
- Tango Light
- Tomorrow

## Image preview

- image preview will work in `tmux`
- image preview requires `python-pillow`

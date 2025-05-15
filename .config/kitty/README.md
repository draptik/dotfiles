# README

`~/.config/kitty` should link to this folder (via `ln -s`).

`kitty.conf` should be a soft link pointing to the desired config file. Example: `ln -sf
kitty-main.conf kitty.conf`

## Usage: Inline theme switching

From within kitty terminal (!)

Prerequisites: Add to PATH: I currently have a `~/bin` folder in PATH, so soft-linking from there to here works.

```sh
# to dark them...
./switch-dark.sh

# to light them...
./switch-light.sh

# or use the toggle function defined in `common_aliases.sh`:
togglekitty
```

## Usage: setting theme when starting kitty

Use script `kitty-with-color-from-env.zsh` from `i3`. The toggle scripts from the previous section
now (2020-09-07) also change the soft link `theme.conf`, which in turn is loaded by `kitty.conf`.

Basic idea: Switching the theme saves an environment variable `KITTY_THEME` to `~/.zshenv`, which
can be read from other scripts. Works with combo `i3`, `zsh` and `kitty` on both desktop and laptop.

## Light themes

Light themes which work ok-ish with programs like `bat`, `ranger`, `colorls`, `exa`, etc.:

- CLRS
- Material
- Tango Light
- Tomorrow

## Image preview

- image preview will work in `tmux`
- image preview requires `python-pillow`

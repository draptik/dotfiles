# cliphist

This is a simple Clipboard Management Tool which works with Wayland/Sway.

The data is stored here:

- `~/.cache/cliphist/`, and not in `~/.local/share/cliphist/` as some older documentation might suggest.

## Sway

Add the following to the `sway` configuration:

```bash
exec wl-paste --type text  --watch cliphist store
exec wl-paste --type image --watch cliphist store
```

This activates the clipboard history collection.

## Rofi

Call the following script from a `sway` keybinding:

```bash
# file `launch_rofi_cliphist.sh`
cliphist list | rofi -dmenu -p "Clipboard" -i | cliphist decode | wl-copy
```

```bash
# `sway` config
bindsym $mod+Shift+s exec $HOME/.dotfiles/.config/rofi/launch_rofi_cliphist.sh
```

## CLI / Zsh

Add this to `.zshrc`:

```bash
# cliphist (Clipboard history manager) ----------------------------------------
if (( ${+commands[cliphist]} && ${+commands[fzf]} )); then

  # Paste last clip to stdout
  pst() {
    local id
    id="$(cliphist list | head -n1 | awk '{print $1}' | tr -d '\r\n')"
    [[ -n "$id" ]] || return 1
    cliphist decode "$id"
  }

  # Show tui for selecting from clipboard
  cclip() {
    local id
    id="$(cliphist list | fzf --reverse | awk '{print $1}' | tr -d '\r\n')"
    [[ -n "$id" ]] || return 0
    cliphist decode "$id" | wl-copy
  }
fi
```

# Rofi

`rofi`: a window switcher, application launcher and `dmenu` replacement

- `config.rasi`: The main configuration file containing default values. Values can be overridden by command line options.
- `*.sh`: Shell scripts for customized command line options. This scripts can be invoked f.ex. by `sway`.

## Example usages

```bash
# default application launcher
rofi -show drun

# file browser
rofi -show filebrowser

# ssh (opens new terminal with the select ssh connection)
rofi -show ssh

# Combining different modes with `-combi-modi`
rofi -combi-modi drun,run -show combi -show-icons
```

## Scripts

| Script | Purpose | sway |
| --- | --- | --- |
| [`launch_rofi_default.sh`](./launch_rofi_default.sh) | Application launcher (`drun`) | `Mod+D` |
| [`launch_rofi_emoji.sh`](./launch_rofi_emoji.sh) | Emoji picker, copies to clipboard (requires `rofimoji`) | `Mod+Shift+A` |
| [`launch_rofi_cliphist.sh`](./launch_rofi_cliphist.sh) | Clipboard history (requires `cliphist`) | `Mod+Shift+S` |
| [`launch_rofi_notes_personal.sh`](./launch_rofi_notes_personal.sh) | Open or create personal notes (via [`rofi_notes.sh`](./rofi_notes.sh)) | `Mod+Shift+N` |
| [`launch_rofi_notes_wiki.sh`](./launch_rofi_notes_wiki.sh) | Open or create wiki notes (via [`rofi_notes.sh`](./rofi_notes.sh)) | `Mod+Shift+M` |
| [`launch_rofi_bc_chain.sh`](./launch_rofi_bc_chain.sh) | Calculator using `bc`; `ans` is the last result, results are copied | – |

## Theme and keys

- The color theme (`gruvbox-dark-hard` / `gruvbox-light-hard`) is switched by the `theme` command: `theme.rasi` is a symlink to `theme-dark.rasi` or `theme-light.rasi`.
- Matching is fuzzy, results are ranked like `fzf`.
- `Ctrl+J` / `Ctrl+K` move down / up (in addition to the arrow keys and `Ctrl+N` / `Ctrl+P`).

## Fonts

```bash
yay -S noto-fonts otf-fira-sans
```

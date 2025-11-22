# tmux

## Initial setup

- link `~/.config/tmux` to this folder
- TPM: tmux-package-manager <https://github.com/tmux-plugins/tpm>
- create folder `~/.local/share/tmux`. Note: This folder will NOT be under version control!
- install `tpm`: `git clone https://github.com/tmux-plugins/tpm ~/.local/share/tmux/plugins/tpm`
- install packages
  - start tmux
  - run tpm: `<tmux-prefix> I` (i.e. `Ctrl-b Shift-i`)
  - this should have installed all packages in the folder `~/.local/share/tmux/plugins`

```bash
~/.local/share/tmux/plugins
❯ l
drwxr-xr-x - patrick patrick 22 Nov 19:31 | master  tmux-sensible
drwxr-xr-x - patrick patrick 22 Nov 19:31 | master  tmux-yank
drwxr-xr-x - patrick patrick 22 Nov 19:29 | master  tpm
```

# My dotfiles

<!-- markdownlint-disable MD031 -->

All configurations are manually soft-linked via `ln -s ...`.

This approach has been good enough for the past decades.

I am aware of the great resource site [dotfiles.github.io/](https://dotfiles.github.io/). Something to keep in mind for future setups. But I'll also keep tools like [`nix`](https://nixos.org/nix/), and [`ansible`](https://www.ansible.com/) in mind...

## Color Theme switching

- My default setup is: `kitty` -> `tmux` -> `zsh`.
- My default color scheme is dark (gruvbox).
- The main reasons for using a light theme are: outdoors, presentations.
- Theme switching is handled by a single `theme` command (`~/.dotfiles/bin/theme`):
  ```sh
  theme        # toggle
  theme dark
  theme light
  ```
- Works from kitty, ghostty, tmux, bash, or any plain shell.
- Switches: kitty (live IPC to all windows), ghostty (config reload), tmux (live),
  starship, eza, btop, tealdeer, mcfly, ranger, zsh-syntax-highlighting.
- Active theme is persisted in `~/.zshenv` (zsh) and `~/.config/current-theme` (all shells).

### Theme symlinks and git

Each tool's `theme.conf` inside `.dotfiles/` is a symlink that points to the active dark/light variant.
Switching themes rewrites these symlinks, which git would otherwise flag as modifications.

To prevent git from tracking theme switches, the three `theme.conf` symlinks are marked with `skip-worktree`.
This is stored in `.git/index` — it persists on the current clone but must be re-run after cloning on a new machine:

```sh
git update-index --skip-worktree \
  .config/ghostty/theme.conf \
  .config/kitty/theme.conf \
  .config/tmux/theme.conf \
  .config/btop/btop.conf \
  .config/eza/theme.yml \
  .config/klog/config.ini \
  .config/starship-prompt/starship.toml \
  .config/tealdeer/config.toml
```

The committed targets represent the **default dark theme**. To inspect which files have this flag:

```sh
git ls-files -v | grep ^S
```

To temporarily lift the flag (e.g. to commit a new default):

```sh
git update-index --no-skip-worktree .config/kitty/theme.conf  # etc.
# make your change, git add, commit
git update-index --skip-worktree .config/kitty/theme.conf
```

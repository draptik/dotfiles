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

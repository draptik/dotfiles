# My dotfiles

<!-- markdownlint-disable MD031 -->

All configurations are manually soft-linked via `ln -s ...`.

This approach has been good enough for the past decades.

I am aware of the great resource site [dotfiles.github.io/](https://dotfiles.github.io/). Something to keep in mind for future setups. But I'll also keep tools like [`nix`](https://nixos.org/nix/), and [`ansible`](https://www.ansible.com/) in mind...

## Color Theme switching

- My default setup is: `kitty` -> `tmux` -> `zsh`.
- My default color scheme is dark.
- The main reasons for using a light theme are:
  - outdoors
  - presentations (!)
- I have invested a lot of time in color theme switching
  - the main script for triggering color theme switching is `togglekitty`.
  - `togglekitty` must be called from the `kitty` terminal before `tmux` is invoked.
  - `togglekitty` is located at: `./sh_common_aliases/common_aliases.sh`
    ```sh
    # `KITTY_THEME` is my custom environment variable
    if [ "$KITTY_THEME" = "DARK" ]; then
      alias togglekitty='~/.dotfiles/.config/kitty/switch-light.sh'
      # ...
    else
      alias togglekitty='~/.dotfiles/.config/kitty/switch-dark.sh'
      # ...
    fi
    ```
  - there are many derived color theme switches from there on...

# NNN

## Configuration

`nnn` is configured using environment variables. Most environment variables seem to start with `NNN_`.

## Plugins

According to the official docs at https://github.com/jarun/nnn/tree/master/plugins plugins are
installed using:

```sh
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
```

This will install all plugins to folder `~/.config/nnn/`. I then moved the folder `nnn/plugins` to my dotfile
folder and created a soft link:

```sh
# after running above curl command
cd ~/.config/nnn
mkdir ~/.dotfiles/.config/nnn
mv plugins* ~/.dotfiles/.config/nnn/
ln -s ~/.dotfiles/.config/nnn/plugins
```

2022-06-07 Currently there is no Arch package for the plugins, so I probably have to run the curl
command above in case one of the plugins changes in the future.

### Preview-TUI plugin

Preview images (and other files) within `nnn`. Currently this only works with some terminals (`kitty` FTW).

#### Usage

Highlight the file within `nnn` -> `;p` shows the preview.

#### Configuration

- in `kitty.conf`: `allow_remote_control` and `listen_on`
- in `.zshrc`: `export NNN_FIFO=/tmp/nnn.fifo` and `export NNN_PLUG="p:preview-tui"`. Note: exporting
  these values in `~/.profile` did not work for me.


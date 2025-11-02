# ZSA Voyager Keyboard configs

Customization for the [ZSA Voyager Keyboard](https://www.zsa.io/voyager)

This folder contains config files for flashing the keyboard.

## History of config files

- 2025-11-02 Move `left-alt` to right bottom pinky position: `zsa-voyaer-ZPeb7z_sanity2.bin`

## Toggle internal laptop keyboard using user systemd

Goal: disable/enable internal laptop keyboard depending on connection state of Voyager keyboard.

There are 3 files involved:

- `keyboard-watcher.service`
  - located at `~/.dotfiles/.config/systemd/user/keyboard-watcher.service`
  - the folder should be linked from `~/.config`
- `keyboard-monitor.sh`
  - this is where the actual logic resides
- `~/keyboard-watcher.log`
  - defined in `keyboard-monitor.sh` script

After making changes ensure to run the following commands (as user):

```bash
systemctl --user daemon-reload
systemctl --user restart keyboard-watcher.service
```

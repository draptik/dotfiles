# Personal patches for desktop files

Create a soft link from `~/.local/share/applications/*` pointing to files in this folder.

Why? This folder contains things such as scaling patches.

Example `signal-desktop-patched.desktop`. Note the line starting with `Exec` contains additional
parameter `--force-device-scale-factor=1.7`:

```txt
[Desktop Entry]
Type=Application
Name=Signal (with scale patch)
Comment=Signal Private Messenger for Linux
Icon=signal-desktop
Exec=signal-desktop --force-device-scale-factor=1.7
Terminal=false
Categories=Network;InstantMessaging;
StartupWMClass=Signal
```

Infos from [Arch Wiki HiDPI#Slack](https://wiki.archlinux.org/index.php/HiDPI#Slack).

## Updating database for desktop entries

- Source: https://wiki.archlinux.org/title/Desktop_entries#Update_database_of_desktop_entries

```shell
update-desktop-database ~/.local/share/applications
```


# i3

## Required dependencies used in i3 configuration

- `kitty` terminal
- `j4-dmenu-desktop` fast `dmenu` replacement
- `pactl` PulseAudio controller
- `playerctl` Media player controller

## Applets

- `pavucontroller` PulseAudio mixer
- `alsamixer` Alsa mixer
- `volumeicon` Audio applet

## Different systems, different setups: Laptop vs Desktop

- gitignore `config` file
- manualy create soft-link `ln -s config-laptop config` (or `desktop`)

## TODOs

- same config for desktop and laptop
- multi-monitor setup (and presentation setup)
- lockscreen (logout, reboot, poweroff, hibernate, etc)
- scratch

## Laptop

- audio volume: works, but requires pressing key sequence twice (muting works as expected)
- TODO xbacklight
- untested: multi-monitor / presentation mode
- autostart:
    - nm-applet (started automatically on desktop?)
    - volumeicon


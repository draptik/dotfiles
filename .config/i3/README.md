# i3

## Required dependencies used in i3 configuration

- `kitty` terminal
- `rofi` fast `dmenu` replacement
- `pactl` PulseAudio controller
- `playerctl` Media player controller

## Applets

- `pavucontroller` PulseAudio mixer
- `alsamixer` Alsa mixer
- `volumeicon` Audio applet

## Different systems, different setups: Laptop vs Desktop

- gitignore `config` file
- manually create soft-link `ln -s config-laptop config` (or `config-desktop`)

## TODOs

- multi-monitor setup (and presentation setup)
- ~~same config for desktop and laptop~~ use soft links instead
- ~~logout, reboot, poweroff, hibernate, etc~~

## Laptop

- untested: multi-monitor / presentation mode
- autostart:
  - ~~nm-applet (started automatically on desktop?)~~
  - ~~volumeicon~~
- TODO xbacklight
- audio volume: works, but requires pressing key sequence twice (muting works as expected)

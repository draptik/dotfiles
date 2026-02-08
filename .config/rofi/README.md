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

Here some more advanced examples using custom python scripts:

- [`./launch_rofi_websites.sh`](./launch_rofi_websites.sh): A demo launcher for websites
- [`./launch_rofi_bc.sh`](./launch_rofi_bc.sh): An interactive calculator using `bc`

## Fonts

```bash
yay -S noto-fonts otf-fira-sans
```

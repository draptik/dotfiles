# khal + vdirsyncer (Nextcloud calendar)

Nextcloud calendars are synced via CalDAV by `vdirsyncer` into
`~/.local/share/calendars/`. `khal` reads that local vdir, and so does the
waybar `custom/agenda` module ([`../waybar/scripts/agenda.sh`](../waybar/scripts/agenda.sh)).

## Setup

```sh
ln -s ~/.dotfiles/.config/khal ~/.config/khal
ln -s ~/.dotfiles/.config/vdirsyncer ~/.config/vdirsyncer

# Nextcloud: Settings > Security > "Create new app password"
secret-tool store --label="vdirsyncer nextcloud" service vdirsyncer account nextcloud

vdirsyncer discover
vdirsyncer metasync
vdirsyncer sync

# sync every 15 minutes (timer ships with the vdirsyncer package)
systemctl --user enable --now vdirsyncer.timer
```

## Usage

- `khal list now 7d`, `ikhal` (TUI), `khal new 2026-10-01 10:00 1h Meeting -a <calendar>`
- waybar: the next event of today is shown next to the clock,
  hover for the next 7 days, click opens `ikhal`.

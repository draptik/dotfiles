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

Dates are `dd.mm.yyyy` (year required) or `today`, `tomorrow`, `monday`, ...
Calendars are addressed by display name, e.g. `"Patrick Drechsler (Work)"`
(`khal printcalendars` lists them).

### ikhal (TUI)

| Key                   | Action                                            |
| --------------------- | ------------------------------------------------- |
| `h j k l` / arrows    | move (calendar left, events right)                |
| `t`                   | jump to today                                     |
| `Enter`               | show event details, `Enter` again to edit         |
| `Alt+Enter`           | save in the editor                                |
| `n`                   | new event on the selected day                     |
| `d`                   | mark event for deletion (deleted on quit)         |
| `p`                   | duplicate event                                   |
| `/`                   | search                                            |
| `q`                   | quit                                              |

### CLI

```sh
# view
khal list                     # today and the next days
khal list monday 7d           # one week starting monday
khal calendar                 # month grid + agenda
khal at 14:00                 # what is on at 14:00 today
khal search Zahnarzt          # find events (incl. past ones)
khal search Zahnarzt -f '{title}\n{start-long} – {end-long}\n{location}\n{description}'

# add: khal new [options] START [END|DURATION] TITLE [:: DESCRIPTION]
khal new -a "Patrick Drechsler (Work)" tomorrow 10:00 1h Review -l "Room 2"
khal new 05.10.2026 18:00 20:00 Kerwa :: with Kerstin
khal new 24.12.2026 Heiligabend                          # all-day
khal new -r weekly -u 31.12.2026 monday 09:00 30m Jour fixe
khal new -m 15m friday 08:00 1h Dentist                  # alarm 15 min before
khal new -i                                              # interactive

# edit / delete (prompts for each match, delete is one of the options)
khal edit Zahnarzt
```

Changes are written locally and reach Nextcloud with the next sync (timer,
every 15 min) – run `vdirsyncer sync` to push immediately. Shared calendars
(kerstin) and "Contact birthdays" are probably read-only.

### waybar

- text: next timed event (`18:05 Title`, or `Fr 09:30 Title` if not today),
  highlighted 15 min before start; hover for the next 7 days
- left-click: `ikhal`
- right-click / `Mod+Shift+G`: toggle full / minimal (icon only)
- middle-click / `Mod+Ctrl+G`: pick visible calendars
  (rofi, Enter toggles, Esc closes)

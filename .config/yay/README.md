# Yay configuration

This tries to add some safety to AUR helper yay.

- `recently_modified.lua`: prevents AUR downloads younger than 3 days.
- `maintainer_change.lua`: warns of recent maintainer changes.

For details, see <https://www.reddit.com/r/archlinux/comments/1vd0xnh/setting_up_yay_hooks_to_warn_on_maintainer/>

## Files

- `~/.cache/yay/maintainer_cache`:
  Contains recorded maintainer names.
  The file is created/updated by the script.
- `~/.cache/yay/recently_modified_allowlist`:
  Contains package names to be excluded from the `recently_modified.lua` script.
  The file is manually maintained: add/remove package names yourself.

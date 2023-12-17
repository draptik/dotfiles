# kanshi

This is the wayland equivalent of `autorandr`.

> kanshi allows you to define output profiles that are automatically enabled and disabled on hotplug. For instance, this can be used to turn a laptop's internal screen off when docked.

The different profiles should be ordered from the most specific to the most generic.

Also see `../sway/sway.d/01_general.conf` for clamshell handling (open/close laptop lid).

## Current status

```sh
systemctl --user status kanshi
```


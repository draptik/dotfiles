# Hyprland

## TODOs

I am trying to port my sway config to hypr. 
I have been using sway for a long time and I am very happy with it. I am trying to make hypr as close as possible to sway.

- [ ] switching between stacked and tabbed layout
  - in sway I use `super+e` and `super+w` to switch between stacked and tabbed layout
  - https://wiki.hyprland.org/0.35.0/Configuring/Dispatchers/#grouped-tabbed-windows
  - `hy3` didn't work for me...
- [x] setup default workspaces per monitor
  - i.e. laptop monitor has workspace 1, first external monitor has workspace 2, second external monitor has workspace 7
- [x] wlogout: `bindsym $mod+Shift+q exec wlogout`
- [ ] sway "scratchpad" like feature: how does it work in hypr? See `magic`
- [ ] sway: swayidle is handled by systemd service (see `~/.dotfiles/.config/systemd/user/`)

# Useful links

- https://github.com/Madic-/Sway-DE
- https://github.com/Madic-/Sway-DE/blob/master/config/sway/sway.d/06_floating.conf

## Using kanshi as systemd user service

See https://wiki.archlinux.org/title/Sway#Manage_Sway-specific_daemons_with_systemd for details.

Summary:

- create `~/.config/systemd/user/sway-session.target`
- load the target in sway's config using `exec_always "systemctl --user import-environment; systemctl --user start sway-session.target"`
- create `~/.config/systemd/user/kanshi.service`
- enable `systemctl --user enable --now kanshi.service`
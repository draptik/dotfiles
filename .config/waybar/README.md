# Waybar

To restart `waybar`:

```sh
killall -SIGUSR2 waybar

# or
pkill waybar
```

(Source:
<https://github-wiki-see.page/m/Alexays/Waybar/wiki/FAQ#how-can-I-reload-the-configuration-without-restarting-waybar>)

Since `waybar` should/must be redrawn after monitor changes,
this is used during live-reloads in my `kanshi` (see [`../kanshi/config`](../kanshi/config)).

## Theme switching

- Theme switching is a built-in feature of Waybar. It follows the system theme.
- For details see: <https://github.com/Alexays/Waybar/wiki/Styling#style-file>
- Usage: provide a `color-[dark|light].css` file: The theme switches automatically when the GTK theme changes.
- Both CSS files import [`common.css`](./common.css) for all other, non-color related CSS settings.

## Why do I used to keep waybar at the bottom?

- It's an easy way to determine if the screen resolution works.
  Think about external monitor during a presentation, or setting up a with new monitors:
  - The coordinate system usually starts at the top (!) left.
  - If I can't see `waybar`, I need to fix something.
- It doesn't really matter to me: top/bottom, I don't see a benefit either way..

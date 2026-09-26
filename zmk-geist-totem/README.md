# TOTEM firmware

Prebuilt ZMK firmware for my [GEIST TOTEM](https://github.com/GEIGEIGEIST/TOTEM)
split keyboard (Seeed XIAO BLE), plus a script to flash it.

The keymap and build config live in
[draptik/zmk-config-totem](https://github.com/draptik/zmk-config-totem).
GitHub Actions there builds the firmware and publishes it as `firmware.zip`.

## Layout

- `YYYY-MM-DD_<n>-<description>/` — one folder per firmware build, each with
  `totem_left-*.uf2` and `totem_right-*.uf2`
- `flash-totem` — flashes one half of the keyboard

## Flashing

1. Download `firmware.zip` from the GitHub Actions build and put it next to
   `flash-totem`.
2. Run `./flash-totem left` (or `right`).
   - If `firmware.zip` is present, it asks for a short description and
     unpacks the `.uf2` files into a new dated folder.
   - Otherwise it uses the current directory (if it contains `.uf2` files) or
     the newest firmware folder.
3. Double-tap the reset button on that half when prompted. The script waits
   for the `XIAO-SENSE` drive, mounts it via `udiskie-mount` and copies the
   firmware.
4. Repeat for the other half.

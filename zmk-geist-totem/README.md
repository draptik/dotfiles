# TOTEM firmware

Prebuilt ZMK firmware for my [GEIST TOTEM](https://github.com/GEIGEIGEIST/TOTEM)
split keyboard (Seeed XIAO BLE) with a wireless USB dongle, plus a script to
flash it.

The keymap and build config live in
[draptik/zmk-config-totem](https://github.com/draptik/zmk-config-totem).
GitHub Actions there builds the firmware and publishes it as `firmware.zip`.
The dongle setup (first-time setup, settings reset, ZMK Studio) is described in
[docs/dongle-setup](https://github.com/draptik/zmk-config-totem/blob/main/docs/dongle-setup/README.md).

## Layout

- `YYYY-MM-DD_<n>-<description>/` — one folder per firmware build
  - since `2026-10-30_1-dongle-zmk-studio`: `totem_dongle-*.uf2`,
    `totem_left-*.uf2`, `totem_right-*.uf2` and `settings_reset-*.uf2`
  - older folders: only `totem_left-*.uf2` and `totem_right-*.uf2`, from
    before the dongle (left half as central). Don't mix them with the
    dongle builds.
- `flash-totem` — flashes one device: a half, the dongle, or the settings reset

## Which device to flash

The dongle is the central and holds the keymap. Both halves are peripherals.

- **Keymap changes:** flash only the dongle.
- **ZMK update or hardware config change:** flash the dongle and both halves,
  all from the same build.
- **Pairing problems / first-time setup:** flash `settings_reset` on all three
  devices first, then the real firmware (see the dongle setup guide).

## Flashing

1. Download `firmware.zip` from the GitHub Actions build and put it next to
   `flash-totem`.
2. Run `./flash-totem dongle` (or `left`, `right`, `settings_reset`).
   - If `firmware.zip` is present, it asks for a short description and
     unpacks the `.uf2` files into a new dated folder.
   - Otherwise it uses the current directory (if it contains `.uf2` files) or
     the newest firmware folder.
3. Put the device into the bootloader when prompted. The script waits for the
   `XIAO-SENSE` drive, mounts it via `udiskie-mount` and copies the firmware.
   - **Dongle:** double-tap the button on the case.
   - **Halves:** double-tap the reset button on the PCB. They don't need to be
     switched on, USB powers them.
4. Repeat for other devices if needed. Plug in only one device in bootloader
   mode at a time.

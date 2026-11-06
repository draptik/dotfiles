# TOTEM firmware

Prebuilt ZMK firmware for my [GEIST TOTEM](https://github.com/GEIGEIGEIST/TOTEM)
split keyboard (Seeed XIAO BLE) with a wireless USB dongle, plus scripts to
download and flash it.

The keymap and build config live in
[draptik/zmk-config-totem](https://github.com/draptik/zmk-config-totem).
GitHub Actions there builds the firmware and publishes it as the `firmware` artifact.
The dongle setup (first-time setup, settings reset, ZMK Studio) is described in
[docs/dongle-setup](https://github.com/draptik/zmk-config-totem/blob/main/docs/dongle-setup/README.md).

## Layout

- `YYYY-MM-DD_<n>-<description>/` — one folder per firmware build
  - since `2026-10-30_1-dongle-zmk-studio`: `totem_dongle-*.uf2`,
    `totem_left-*.uf2`, `totem_right-*.uf2` and `settings_reset-*.uf2`
  - older folders: only `totem_left-*.uf2` and `totem_right-*.uf2`, from
    before the dongle (left half as central). Don't mix them with the
    dongle builds.
  - folders fetched with `fetch-totem` (since `2026-11-06_1`) also hold
    `BUILD-INFO` (commit, Actions run, artifact digest, ZMK revision) and
    `SHA256SUMS`; their files are read-only
- `fetch-totem` — downloads a build from GitHub Actions into a new folder
- `flash-totem` — flashes one device: a half, the dongle, or the settings reset
- `totem-lib.sh` — checks shared by both scripts

## Which device to flash

The dongle is the central and holds the keymap. Both halves are peripherals.

- **Keymap changes:** flash only the dongle.
- **ZMK update or hardware config change:** flash the dongle and both halves,
  all from the same build.
- **Pairing problems / first-time setup:** flash `settings_reset` on all three
  devices first, then the real firmware (see the dongle setup guide).

## Fetching

`./fetch-totem` downloads the newest successful build of `main`;
`./fetch-totem <commit>` or `./fetch-totem <run-id>` picks a specific one. It
needs `gh` (logged in) and `jq`.

It accepts only successful push builds of `main`, checks the artifact zip
against the SHA-256 digest GitHub reports, rejects anything in the zip that
isn't a `.uf2` file, and checks every file is a valid nRF52840 UF2 image. It
then asks for a folder description (default: the commit title) and saves the
files with `BUILD-INFO` and `SHA256SUMS`. GitHub deletes artifacts after 90
days, so fetch a build soon after it finishes.

## Flashing

1. Run `./flash-totem` and pick the folder (newest first) and device from the
   menus, or pass them: `./flash-totem [-f FOLDER] dongle|left|right|settings_reset`.
   Run inside a firmware folder, it uses that folder.
2. It verifies `SHA256SUMS` and the UF2 files. Older folders without
   `SHA256SUMS` need an explicit "y"; pre-dongle folders are refused.
3. Put the device into the bootloader when prompted:
   - **Dongle:** double-tap the button on the case.
   - **Halves:** double-tap the reset button on the PCB. They don't need to be
     switched on, USB powers them.
4. The script waits up to 2 minutes for exactly one USB drive labelled
   `XIAO-SENSE`, mounts it with `udisksctl`, checks its `INFO_UF2.TXT` is the
   XIAO nRF52840 bootloader, shows what it will flash and asks for
   confirmation. After copying it waits for the reboot; for the dongle it also
   checks that the TOTEM keyboard comes back.
5. Repeat for other devices if needed. Put only one device into bootloader
   mode at a time: the bootloader can't tell the dongle from a half, so make
   sure it's the one you picked.

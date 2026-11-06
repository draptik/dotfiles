# Voyager + IntelliJ/Rider + IdeaVim: Recommendations

Status: open, to revisit. Applied so far: IdeaVim `<C-j>` window-navigation fix, IdeaVim `<leader>b`
debug mappings, both IDEs on the XWin keymap.

Based on Oryx layout [`Lmdrq`](https://configure.zsa.io/voyager/layouts/Lmdrq/latest/0) ("sanity3"), revision `3vAY3W` ("add ins and del keys", 2026-10-26),
and [`ideavim/ideavimrc`](../ideavim/ideavimrc).

## Context

- Layout settings: home-row mods (GUI/Alt/Shift/Ctrl), tapping term 250 ms,
  chordal hold on (thumbs excluded)
- Combos (base layer): Q+A → `=`, Tab+outer-left-home → `+`, P+`;` → `-`, `\`+`'` → `_`
- Keymaps:
  - Both IDEs: **Default for XWin** (Rider shows it as "IntelliJ (XWin)").
    XWin is `$default` with ~15 overrides that avoid Alt+F-key and Ctrl+Alt+F-key shortcuts,
    e.g. Run to Cursor Shift+Alt+9, Quick Evaluate Ctrl+Alt+8, Show Usages Ctrl+Alt+7.
  - Rider uses XWin only through a config-file hack, see "Rider keymap hack" below.

## Rider keymap hack

Rider's settings don't offer the XWin keymap (only IntelliJ, IntelliJ (GNOME), IntelliJ (KDE)),
and IntelliJ doesn't offer `$default` on Linux. To get the same keymap in both, Rider's config
file was edited by hand (2026-11-06):

1. Close Rider.
2. Edit `~/.config/JetBrains/Rider<version>/options/linux/keymap.xml`:

   ```xml
   <application>
     <component name="KeymapManager">
       <active_keymap name="Default for XWin" />
     </component>
   </application>
   ```

3. Start Rider. Settings → Keymap shows **IntelliJ (XWin)**.

Why XWin: the XKB layout (EurKEY) maps Ctrl+Alt+F1–F12 to the `XF86Switch_VT_1`–`12` keysyms,
and Sway handles those by switching virtual terminals. So `$default` shortcuts such as
Show Usages (Ctrl+Alt+F7) never reach the IDE. XWin moves those to other keys.
Test: Ctrl+Alt+F3 goes to a text console, Ctrl+Alt+F2 returns to Sway (VT 2).

Caveats:
- Not part of the dotfiles; the setting lives in Rider's per-version config directory.
- After a Rider upgrade (new `Rider<version>` directory) or a settings reset, check
  Settings → Keymap and repeat the steps if it shows **IntelliJ** again.
- Selecting another keymap in Rider's settings overwrites the hack.
- To revert: select **IntelliJ** in Settings → Keymap (stored as `$default`).

## Keyboard (Oryx)

Deferred (low priority, debugging isn't a main use case right now):

- **Change the L3 debug cluster to IntelliJ keys.** Both IDEs now use the XWin keymap
  (see Context). The L3 cluster (F5, F10, F11, Shift+F10, Shift+F11) is Visual Studio style
  and doesn't match anymore. Until then, use the IdeaVim `<leader>b` mappings. Target keys:

  | Action            | Key       |
  |-------------------|-----------|
  | Step over         | F8        |
  | Step into         | F7        |
  | Step out          | Shift+F8  |
  | Resume            | F9        |
  | Toggle breakpoint | Ctrl+F8   |
  | Debug             | Shift+F9  |
  | Stop              | Ctrl+F2   |

Decided:
- `/` stays AltGr when held (needed for German umlauts with EurKEY).
- Left outer home key stays as is.
- Chordal hold stays on: it prevents most accidental mods when rolling keys in normal mode.
  Alt+Enter still works with `S` + Enter thumb, because thumbs are excluded.
- Key repeat on home-row mod keys (`j`/`k`/`l`) works: tap, then press and hold repeats the key.

## IdeaVim ([`ideavim/ideavimrc`](../ideavim/ideavimrc))

- Done: debug mappings under `<leader>b` (commit `8693566`). They need editor focus,
  so keep the F-keys as well.

## How the layout was retrieved

The layout data came from Oryx's public GraphQL API (no login, generic User-Agent):

```sh
# layers and keys
curl -sS -A curl -H 'Content-Type: application/json' https://oryx.zsa.io/graphql \
  -d '{"query":"query { layout(hashId: \"Lmdrq\", geometry: \"voyager\", revisionId: \"latest\") { hashId title geometry revision { hashId title createdAt layers { title position keys } } } }"}' \
  -o layout.json

# settings (tapping term, chordal hold, ...) and combos
curl -sS -A curl -H 'Content-Type: application/json' https://oryx.zsa.io/graphql \
  -d '{"query":"query { layout(hashId: \"Lmdrq\", geometry: \"voyager\", revisionId: \"latest\") { revision { config combos { keyIndices layerIdx trigger name } } } }"}' \
  -o cfg.json
```

`revisionId: "latest"` returns the newest revision; use a revision hash (e.g. `"3vAY3W"`) to
fetch a specific one.

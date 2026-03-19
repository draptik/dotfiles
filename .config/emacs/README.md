# Emacs Notes

## Configuration file location

- Comply to XDG conventions: Use `~/.config/emacs/init.el`.
- Make sure there are no configuration files at the old locations (for example `~/.emacs`).

## Starting Emacs with different configuration files

- `emacs -Q load ~/.config/emacs/experimental-init.el`

## Navigation: Neovim ↔ Emacs

| Action                  | Neovim       | Emacs          |
|-------------------------|--------------|----------------|
| **Character**           |              |                |
| Left / Right            | `h` / `l`    | `C-b` / `C-f`  |
| Up / Down               | `k` / `j`    | `C-p` / `C-n`  |
|-------------------------|--------------|----------------|
| **Word**                |              |                |
| Word forward            | `w`          | `M-f`          |
| Word backward           | `b`          | `M-b`          |
|-------------------------|--------------|----------------|
| **Line**                |              |                |
| Start of line           | `0`          | `C-a`          |
| End of line             | `$`          | `C-e`          |
| Go to line N            | `:<N>`       | `M-g g <N>`    |
|-------------------------|--------------|----------------|
| **Buffer**              |              |                |
| Top of buffer           | `gg`         | `M-<`          |
| Bottom of buffer        | `G`          | `M->`          |
|-------------------------|--------------|----------------|
| **Scroll**              |              |                |
| Page down               | `C-f`        | `C-v`          |
| Page up                 | `C-b`        | `M-v`          |
| Scroll down line        | `C-e`        | —              |
| Scroll up line          | `C-y`        | —              |
| Center cursor           | `zz`         | `C-l`          |
|-------------------------|--------------|----------------|
| **Search**              |              |                |
| Search forward          | `/`          | `C-s`          |
| Search backward         | `?`          | `C-r`          |
| Next / prev match       | `n` / `N`    | `C-s` / `C-r`  |
|-------------------------|--------------|----------------|
| **Jumps**               |              |                |
| Jump back               | `C-o`        | `C-x C-SPC`    |
| Jump forward            | `C-i`        | —              |
| Match bracket           | `%`          | `C-M-f`        |

## early-init.el

Loaded by Emacs before the package system and UI are initialized.

- **GC tuning**: raises the garbage collection threshold to 50MB during startup
  to reduce pauses while Emacs loads packages, then resets to 2MB for normal use.
- **UI chrome**: disables the menu bar, tool bar, and scroll bars before they are
  ever rendered, preventing a flicker on startup.
- **Package init**: defers package initialization to `init.el` where it is done
  explicitly.

## init.el

Main configuration file, loaded after `early-init.el`.

### Package management

- `package.el` (built-in): installs packages from MELPA.
- `use-package` (built-in since Emacs 29): declarative package configuration —
  each package's keybindings, hooks, and settings are colocated with its install directive.

### Defaults

Sane built-in settings: no backup files, no bell, spaces over tabs, smooth
scrolling, auto-revert buffers changed on disk, persistent minibuffer history,
and recent file tracking.

### Theme

Reads the `KITTY_THEME` environment variable (`LIGHT`/`DARK`) to select between
`modus-operandi` (light) and `modus-vivendi` (dark), both built into Emacs 28+.
Also applies correctly when running as a daemon via `after-make-frame-functions`.

### Completion — the "minad stack"

The modern consensus replacement for Helm/Ivy:

- `vertico`: vertical completion UI in the minibuffer.
- `orderless`: fuzzy/space-separated completion matching style.
- `marginalia`: adds annotations (docstrings, file sizes, etc.) to completion candidates.
- `consult`: enhanced versions of built-in commands — buffer switching, search,
  jump to line, yank history, and more.
- `embark`: context-sensitive actions on the current candidate or thing at point,
  analogous to a right-click menu.
- `embark-consult`: integration glue between embark and consult.

### Org-mode

The org directory is read from the `ORG_DIR` environment variable (set in `.zshenv`),
with `~/org` as fallback. Set it in `.zshenv`:

```sh
export ORG_DIR="$HOME/cloud/Nextcloud_wolke/org"
```

Files live in `$ORG_DIR/`:
- `inbox.org` — tasks and notes captured during the day
- `journal.org` — dated journal entries (date tree: year → month → day)

**Todo states** (GTD-style):
`TODO` → `NEXT` → `WAITING` → `DONE` / `CANCELLED`

**Global keybindings:**

| Keys    | Action                        |
|---------|-------------------------------|
| `C-c a` | Open agenda                   |
| `C-c c` | Open capture menu             |
| `C-c l` | Store link to current location|

**Capture templates** (`C-c c`):

| Key | Template      | Destination              |
|-----|---------------|--------------------------|
| `t` | Task          | `inbox.org` → Tasks      |
| `n` | Note          | `inbox.org` → Notes      |
| `j` | Journal entry | `journal.org` (date tree)|
| `c` | Clock entry   | `inbox.org` → Tasks      |

**Common org keybindings:**

| Keys              | Action                        |
|-------------------|-------------------------------|
| `C-RET`           | New heading at same level     |
| `M-RET`           | New item / subheading         |
| `C-c C-t`         | Cycle todo state              |
| `C-c C-s`         | Schedule item                 |
| `C-c C-d`         | Set deadline                  |
| `C-c C-x C-i`     | Clock in                      |
| `C-c C-x C-o`     | Clock out                     |

### Other

- `magit`: Git interface. Widely considered the best Git UI of any editor.
- `eglot` (built-in): LSP client. Hooks for specific languages are included but
  commented out — uncomment as needed.
- `save-place` (built-in): remembers cursor position in previously visited files.
- `custom.el`: Emacs's customize system writes to a separate file to keep
  `init.el` clean.

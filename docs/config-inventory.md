# Config inventory

<!-- markdownlint-disable MD060 -->

Which config is deployed where, as input for `home/.chezmoiignore`
(see [multi-device-plan.md](multi-device-plan.md)).

Legend: ✅ deploy · ➖ skip · ⚠️ deploy, needs OS adjustments · ⏳ nice-to-have, later

Everything marked ✅ or ⚠️ on a work machine is essential (see "Priorities" in the plan).

## Shell & terminal

| Config                                   | personal | work-mac | work-win-vm | Notes |
|------------------------------------------|----------|----------|-------------|-------|
| `zsh/.zshrc`, `zsh/theme-env.zsh`        | ✅       | ⚠️       | ➖          | remove hardcoded `/home/patrick`; OS guards |
| oh-my-zsh + custom plugins/themes        | ✅       | ✅       | ➖          | via `.chezmoiexternal.toml` |
| `bash/.bashrc`, `.bash_aliases`          | ✅       | ⚠️       | ⚠️          | Windows: Git Bash |
| `sh_common_aliases/`                     | ✅       | ⚠️       | ⚠️          | GNU vs BSD flags; Windows: port subset to PowerShell |
| PowerShell profile (new)                 | ➖       | ➖       | ✅          | starship, zoxide, aliases |
| `bin/theme`                              | ✅       | ⏳       | ➖          | rewrite to target paths; no `gsettings` on mac |
| `.config/tmux`                           | ✅       | ⚠️       | ➖          | clipboard: `pbcopy` vs `wl-copy` |
| `.config/kitty`                          | ✅       | ⚠️       | ➖          | main Mac terminal; `include ${KITTY_OS}.conf`; upstream themes as external |
| `.config/ghostty`                        | ✅       | ⚠️       | ➖          | fallback if kitty is blocked; macOS keybinds |
| `.config/wezterm`                        | ✅       | ⏳       | ⏳          | candidate terminal for Windows |
| `.config/starship-prompt`                | ✅       | ✅       | ✅          | target `~/.config/starship.toml` |
| `.config/atuin`                          | ✅       | ✅       | ⚠️          | sync: personal server reachable from work? |

## Editors

| Config                                   | personal | work-mac | work-win-vm | Notes |
|------------------------------------------|----------|----------|-------------|-------|
| `.config/nvim-lazyvim` (+ kickstart, vanilla) | ✅  | ✅       | ✅          | `symlink_nvim` on Unix, `NVIM_APPNAME` on Windows (plan 3.5) |
| `.vim/vimrc`                             | ✅       | ✅       | ✅          | |
| `ideavim/ideavimrc`                      | ✅       | ✅       | ✅          | |
| `.config/markdownlint`                   | ✅       | ✅       | ✅          | |

## CLI tools

| Config                                   | personal | work-mac | work-win-vm | Notes |
|------------------------------------------|----------|----------|-------------|-------|
| git (`.gitconfig`, `git-aliases`)        | ✅       | ✅       | ✅          | new `dot_gitconfig.tmpl`, e-mail per machine |
| `.config/gitmoji-nodejs`                 | ✅       | ✅       | ✅          | |
| `.config/bat`, `ripgrep`, `eza`, `glow`, `tealdeer`, `yazi` | ✅ | ⚠️ | ⚠️ | mac/Windows may default to non-XDG paths → env vars |
| `.config/btop`                           | ✅       | ✅       | ➖          | |
| `.config/klog`                           | ✅       | ✅       | ✅          | time tracking — useful at work |
| `.config/ranger`                         | ✅       | ⚠️       | ➖          | yazi preferred cross-platform |
| `.config/zathura`                        | ✅       | ➖       | ➖          | |
| `~/.claude` (settings, CLAUDE.md)        | ➖       | ➖       | ➖          | not in the repo today; `theme` edits settings.json — add later if wanted |

## Linux desktop only

`➖` on both work machines:

`.config/sway`, `waybar`, `kanshi`, `dunst`, `rofi`, `rofimofi`, `wlogout`,
`swappy`, `cliphist`, `niri`, `wayscribar`, `systemd/user`, `environment.d`
(+ `user-dirs.dirs`), `yay`, `chromium-flags.conf`, `code-flags.conf`,
`.local/share/applications`, `kitty-desktop.conf`.

## Personal only

`➖` on both work machines (private data, personal infrastructure):

`.config/khal`, `.config/vdirsyncer`, `.config/youtube-dl`, `.config/ytfzf`,
`bin/beets-analyze.sh`, `bash/copy-to-paperless.sh`, and from `scripts/`:
`backup-*`, `fit-*`, `organize_ebooks.*`, `copy-to-paperless.sh`/`c2p`,
`toggle-netbird*`, `toggle-vpn*`.

Remaining `scripts/` (`dnclean`, `dotnet-install.sh`, `purge-dotnet.sh`,
`mksh`, `slidev-replicate`, `switch-nvim-setup`, `keyboard-toggle`) are
candidates for work-mac; decide per script.

## Repo-only (never deployed)

`.config/emacs` (unused for now), `uhk-configs/`, `zsa-voyager-configs/`, `zmk-geist-totem/`, `docs/`,
`git-notes.md`, `git-kitty-gitmoji-arrow-issue.md`, `README.md`,
`chocolatey/` (superseded by `packages/scoopfile.json`, kept for reference).

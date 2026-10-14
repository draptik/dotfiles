# Multi-device plan

<!-- markdownlint-disable MD031 MD060 -->

Status: **proposal**, nothing migrated yet. Tool: **chezmoi** (see 1.4).

Goal: keep the Arch laptop working exactly as today, and make the same repo
usable on

| Device        | OS      | Privileges (assumed)                                   |
|---------------|---------|--------------------------------------------------------|
| `personal`    | Arch    | root; current reference setup                          |
| `work-mac`    | macOS   | standard user, no `sudo`, MDM-managed, maybe proxy     |
| `work-win-vm` | Windows | standard user, no admin, GPO/AppLocker may apply       |

Guiding rule: **nothing in the bootstrap needs admin/root.** Anything that does
(Homebrew, Chocolatey, WSL, changing the login shell) is optional and goes
through IT or a self-service portal.

See [config-inventory.md](config-inventory.md) for which config goes where.

## 0. Priorities

### Essential

- **Linux**: migrate it to chezmoi too — one source of truth for all machines.
- **work-mac**
  - Shell: zsh + oh-my-zsh, common aliases, starship, atuin
  - Terminal: kitty + tmux (fallback: ghostty, if kitty can't be installed or is blocked)
  - Editors: nvim (lazyvim), vim, ideavim
  - CLI tool configs: git (aliases + identity), bat, ripgrep, eza, yazi, glow,
    tealdeer, klog, gitmoji
- **work-win-vm**
  - PowerShell 7 profile (starship, zoxide, PSReadLine vi-mode, ported aliases)
  - Git Bash with the existing `.bashrc`
  - Editors: nvim (lazyvim), vim, ideavim
  - CLI tools installed via Scoop, no admin

### Nice-to-have (later)

- `theme` switching on the Mac (dark stays the default until then)
- Pushing from work machines (scoped token / deploy key)
- Fully unattended bootstrap (no prompts)
- Secrets via KeePassXC / age
- wezterm on work machines

### Not wanted

- Emacs anywhere for now — config stays in the repo but isn't deployed

## 1. Tool choice

Researched 2026-10-15. Sources are listed at the end of this section; anything
marked *unverified* comes from general knowledge, not from a source checked
on that date.

### 1.1 Requirements

Taken from [0. Priorities](#0-priorities):

| #  | Requirement                                              | Weight     |
|----|----------------------------------------------------------|------------|
| R1 | Install and run as a standard user on macOS and Windows  | must       |
| R2 | Works on Windows **without** symlink rights (no Developer Mode, no admin) | must |
| R3 | Per-OS / per-profile selection of files (Linux desktop, personal-only) | must |
| R4 | Per-OS target paths (e.g. nvim on Windows)               | must       |
| R5 | Keep "edit in repo, live immediately" on Linux/macOS     | strong     |
| R6 | Small migration cost: repo layout, `theme`, git history  | **none** (one-time effort) |
| R7 | Third-party content (oh-my-zsh, plugins, kitty-themes)   | nice       |
| R8 | Secrets / password-manager integration                   | nice       |
| R9 | One-command unattended bootstrap                         | nice       |
| R10 | Mature, actively maintained                             | strong     |

### 1.2 Candidates

| Tool | R1 no-admin | R2 Windows w/o symlinks | R3/R4 per-machine | R5 live edits | R6 migration (no weight) | R7–R9 | R10 |
|---|---|---|---|---|---|---|---|
| **chezmoi** | ✅ single Go binary | ✅ copies by default (`mode = "file"`) | ✅ templates, `.chezmoiignore`, data | ⚠️ symlink mode only for plain files; templates, **executables**, private and encrypted files stay copies | ❌ every path renamed (`dot_`, `executable_`, …) | ✅ externals, password managers, age/gpg, `init --apply` one-liner | ✅ very active (2.70.x, monthly releases in 2026) |
| **dotter** | ✅ single Rust binary (Scoop, winget, release binary) | ✅ detects missing symlink rights and **falls back to copying automatically** (verified in source) | ✅ packages in `global.toml`, per-machine `local.toml`, per-OS `includes`, Handlebars with `dotter.macos/linux/windows` | ✅ symlinks by default, incl. executables | ✅ **repo layout stays**; mapping lives in `.dotter/global.toml` | ⚠️ hooks only (pre/post deploy, `.bat` on Windows); no externals, no secret managers | ⚠️ active (0.13.5, last commit 2026-07), essentially one maintainer, ~2k stars |
| yadm | ⚠️ bash script; Windows via Git Bash/MSYS (*unverified* how well) | ⚠️ alternates are symlinks; behaviour under Git Bash without symlink rights *unverified* | ✅ alternates by OS/host/class, templates | ✅ `$HOME` is the work tree | ⚠️ files move to their real paths in `$HOME` | ⚠️ encryption (gpg/openssl, git-crypt, transcrypt); no externals | ✅ mature |
| bare git repo | ✅ git only | ✅ files are real files | ❌ only via branches or hand-written logic | ✅ `$HOME` is the work tree | ⚠️ files move to their real paths | ❌ | n/a |
| dotbot | ⚠️ needs Python + git submodule | ⚠️ symlink-based | ⚠️ alternative config files | ✅ | ⚠️ | ❌ | ✅ |
| GNU stow / rcm | ✅ | ❌ no Windows | ❌ | ✅ | ✅ close to today | ❌ | ✅ |
| nix / home-manager | ❌ macOS installers need `sudo` to create `/nix`; single-user install no longer supported on macOS | ❌ no Windows | ✅ excellent | ⚠️ store links, read-only | ❌ rewrite in Nix | ✅ | ✅ |
| ansible | ⚠️ Python; can't run from Windows | ⚠️ | ✅ | ❌ | ❌ rewrite as playbooks | ✅ vault | ✅ |
| keep `ln -s` + `install.sh` / `install.ps1` | ✅ | ✅ PowerShell can copy | ⚠️ hand-written | ✅ | ✅ none | ❌ | n/a (yours) |

Ruled out on a **must**: stow/rcm, home-manager, ansible, bare git, dotbot.
yadm is only a serious option for Linux + macOS; on Windows it's the weakest
of the three remaining options.

### 1.3 Finalists: chezmoi vs dotter

What each one means for this repo specifically. Migration effort (repo
restructure, renames, adapting `theme`) has **no weight**: it's a one-time
task. Those rows are kept for information only.

| Topic | chezmoi | dotter |
|---|---|---|
| Live edits on Linux/macOS (R5) | Only plain files are symlinks; the ~136 executable files (scripts, rofi launchers, `theme`) and templates are copies → `chezmoi apply` after editing them, or `chezmoi edit --watch` | All non-templates are symlinks, including executables |
| Whole-directory links (R5) | Not possible: per-file symlinks only. Files an app creates later (caches, new plugin files) end up outside the repo | `recurse = false` links the whole directory, as today |
| Windows without symlink rights (R2) | Copy mode by design, files copied as they are | Falls back to copies, but **renders every file as a Handlebars template** — any `{{` in a config breaks it; whole-directory targets need per-file overrides |
| Per-machine config (R3/R4) | Templates, templated `.chezmoiignore`, prompted data in `~/.config/chezmoi/chezmoi.toml` | Packages + per-OS `includes`, `local.toml` in the checkout (git-ignored), Handlebars |
| Templates | Explicit (`.tmpl` suffix) | Implicit (`{{` → template) unless `default_target_type = "symbolic"` |
| Third-party content (R7, nice) | `.chezmoiexternal.toml` with refresh periods | `post_deploy` hook (`git clone` if missing) |
| Secrets (R8, nice) | KeePassXC, age, gpg, keyring built in | Not built in |
| Unattended bootstrap (R9, nice) | `chezmoi init --apply <url> --promptChoice …` | Own script: clone + download dotter + write `local.toml` |
| Maturity (R10) | Large project, frequent releases (2.70.x in 2026) | Small project, one main maintainer (0.13.5, 2026-07); release binaries without checksums, no Intel macOS binary |
| Undo | `chezmoi purge` + manual | `dotter undeploy` removes everything it deployed |
| *Repo layout (no weight)* | *Move under `home/`, rename to `dot_config/…`, `executable_…`* | *Unchanged; add `.dotter/`* |
| *`theme` (no weight)* | *Selector links move to the target side (3.2)* | *Works as is (after making links relative)* |

### 1.4 Verdict

Re-scored without migration cost (2026-10-15):

- **dotter's only remaining advantage is R5**: scripts and whole directories
  stay symlinked, so editing in the repo is live everywhere on Linux/macOS.
- **chezmoi is ahead on everything else that differs**: Windows copies
  without template pitfalls (R2), maturity (R10), and all three
  nice-to-haves (R7–R9).

Recommendation: **chezmoi**. The price is one extra step:
`chezmoi apply` (or `chezmoi edit --apply`) after editing a script or
template, and no whole-directory links (3.1).

### 1.5 Sources

- chezmoi comparison table: <https://www.chezmoi.io/comparison-table/>
- chezmoi design FAQ (symlink mode limits, Windows): <https://www.chezmoi.io/user-guide/frequently-asked-questions/design/>
- chezmoi release history: <https://www.chezmoi.io/reference/release-history/>
- dotter repo + wiki (symlinks vs templates, packages, `local.toml`, hooks): <https://github.com/SuperCuber/dotter>, <https://github.com/SuperCuber/dotter/wiki>
- dotter Windows fallback: `src/deploy.rs` in the dotter repo ("Proceeding by copying instead of symlinking")
- yadm alternates / FAQ: <https://yadm.io/docs/alternates>, <https://yadm.io/docs/faq>
- Nix on macOS needs sudo, no single-user install: <https://nix.dev/manual/nix/2.28/installation/installing-binary>

## 2. Repo layout and chezmoi config

The repo stays at `~/.dotfiles` and becomes chezmoi's source directory.
A `.chezmoiroot` file makes only `home/` the source state; keyboard firmware,
docs and notes stay outside and are never deployed.

```text
~/.dotfiles/
├── .chezmoiroot                 # contains: home
├── docs/
├── uhk-configs/ zsa-voyager-configs/ zmk-geist-totem/   # repo-only
├── chocolatey/                  # reference only (needs admin)
└── home/                        # == $HOME
    ├── .chezmoi.toml.tmpl       # prompts + per-machine data
    ├── .chezmoiignore           # templated: OS / profile exclusions, theme selectors
    ├── .chezmoiexternal.toml    # oh-my-zsh, zsh-autosuggestions, kitty-themes
    ├── .chezmoiscripts/         # run_once_ / run_onchange_ scripts
    ├── .packages/               # Brewfile, scoopfile.json, mise.toml (dot-dirs aren't deployed)
    ├── dot_zshrc
    ├── dot_bashrc, dot_bash_aliases
    ├── dot_ideavimrc
    ├── dot_vim/vimrc
    ├── dot_gitconfig.tmpl
    ├── dot_local/bin/executable_theme
    ├── dot_config/…             # from today's .config/, plus sh_common_aliases, zsh, patrick (scripts)
    └── Documents/PowerShell/Microsoft.PowerShell_profile.ps1   # Windows only
```

### 2.1 Mapping from today's layout

| Today                              | chezmoi source (`home/…`)                   | Target                         |
|------------------------------------|---------------------------------------------|--------------------------------|
| `.config/<tool>/`                  | `dot_config/<tool>/`                        | `~/.config/<tool>/`            |
| `zsh/.zshrc`                       | `dot_zshrc`                                 | `~/.zshrc`                     |
| `zsh/theme-env.zsh`                | `dot_config/zsh/theme-env.zsh`              | `~/.config/zsh/`               |
| `zsh/.oh-my-zsh/custom/`           | `dot_config/zsh/omz-custom/` (`ZSH_CUSTOM`) | `~/.config/zsh/omz-custom/`    |
| `bash/.bashrc`, `.bash_aliases`    | `dot_bashrc`, `dot_bash_aliases`            | `~/`                           |
| `sh_common_aliases/`               | `dot_config/sh_common_aliases/`             | `~/.config/sh_common_aliases/` |
| `bin/theme`                        | `dot_local/bin/executable_theme`            | `~/.local/bin/theme`           |
| `scripts/`                         | `dot_config/patrick/`                       | `~/.config/patrick/` (as today) |
| `ideavim/ideavimrc`                | `dot_ideavimrc`                             | `~/.ideavimrc`                 |
| `.vim/vimrc`                       | `dot_vim/vimrc`                             | `~/.vim/vimrc`                 |
| `git-aliases` + untracked `~/.gitconfig` | `dot_gitconfig.tmpl`                  | `~/.gitconfig`                 |
| `.local/share/applications/`       | `dot_local/share/applications/`             | same                           |
| `.config/nvim-lazyvim` + `~/.config/nvim` link | `dot_config/nvim-lazyvim/` + `dot_config/symlink_nvim` | see 3.5 |
| `.config/kitty/kitty-themes/` (vendored upstream) | external (3.4); `mythemes/` stays  | `~/.config/kitty/kitty-themes/` |
| committed theme selector links     | **removed** from the repo (3.2)             | created by `theme`             |

`chezmoi add` does the renaming (`dot_`, `executable_`, `symlink_`) when
files are added from their target location, so most of this is mechanical.
Relative symlinks in the repo (`scripts/c2p -> ./copy-to-paperless.sh`,
eza theme links) become `symlink_` entries automatically. The absolute
systemd `*.wants/` links get `{{ .chezmoi.homeDir }}` in a `symlink_….tmpl`.

### 2.2 Paths into the repo must go

Many configs source files from `~/.dotfiles/…` directly. After the
restructure those paths don't exist any more (`home/dot_config/…`), so they
point to the **target** paths instead (`~/.config/…`, `~/.local/bin`):

- `zsh/.zshrc`: `theme-env.zsh`, `function-xkcd.zsh`, `common_aliases.sh`,
  `path+=(~/.dotfiles/bin)`, `RIPGREP_CONFIG_PATH`
- `bash/.bashrc` (`PATH`), `bash/.bash_aliases`
- `sh_common_aliases/common_aliases.sh` (4×), `bin/theme` (whole script)
- `.config/tmux/tmux.conf` (`source-file …/theme.conf`)
- `.config/ripgrep/ripgreprc` (`--ignore-file=/home/patrick/.dotfiles/…`)
- `.config/sway/sway.d/01_general.conf`, `07_hotkeys.conf`, `.config/wlogout/layout`
- `.local/share/applications/*.desktop` (`Exec=/home/patrick/.dotfiles/…`)
- `scripts/switch-nvim-setup.sh`
- `nvim-lazyvim` `extend-nvim-lint.lua` (markdownlint config) and
  `autocmds.lua` (emacs clocktables — emacs isn't deployed; drop or guard it)

`git grep -n -e '\.dotfiles' -e DOTFILES -- ':!docs' ':!*README*'` lists them.

### 2.3 Per-machine data (`home/.chezmoi.toml.tmpl`)

```toml
{{- $profile := promptChoiceOnce . "profile" "Machine profile" (list "personal" "work") -}}
{{- $email   := promptStringOnce . "email" "Git e-mail for this machine" -}}

{{- if eq .chezmoi.os "windows" }}
mode = "file"
{{- else }}
mode = "symlink"
{{- end }}

[data]
    profile = {{ $profile | quote }}
    email   = {{ $email | quote }}
    work    = {{ eq $profile "work" }}
```

The answers are stored only in `~/.config/chezmoi/chezmoi.toml` on that
machine, **never in the repo**. No hostnames anywhere: the repo is public.

### 2.4 Ignore rules (`home/.chezmoiignore`)

Patterns are target paths; the lists come from [config-inventory.md](config-inventory.md).

```text
{{ if ne .chezmoi.os "linux" }}
.config/sway
.config/waybar
.config/systemd
.local/share/applications
# … all "Linux desktop only" entries
{{ end }}

{{ if .work }}
.config/khal
.config/vdirsyncer
.config/patrick
# … all "personal only" entries
{{ end }}

{{ if eq .chezmoi.os "windows" }}
.zshrc
.config/zsh
.config/tmux
.config/kitty
.config/ghostty
.config/nvim
.local/bin/theme
{{ else }}
Documents
{{ end }}

.config/emacs

# theme selectors: created by `theme`, never managed (3.2)
.config/kitty/theme.conf
.config/ghostty/theme.conf
.config/tmux/theme.conf
.config/starship.toml
.config/btop/btop.conf
.config/eza/theme.yml
.config/glow/glow.yml
.config/klog/config.ini
.config/tealdeer/config.toml
.config/rofi/theme.rasi
.config/dunst/dunstrc.d/50-theme.conf
.config/current-theme
.zshenv
```

## 3. Design decisions

### 3.1 Symlink mode, and what stays a copy

On Linux and macOS, `mode = "symlink"` makes each managed **plain file** a
symlink into `~/.dotfiles/home/…`, so editing either side is live. chezmoi
can't link whole directories: it creates real directories and links each file.

Always copies, even in symlink mode: **templates, executables** (~136 files:
`scripts/`, rofi launchers, sway helpers, `theme`), private and encrypted
files. For those:

- edit via `chezmoi edit --apply <target>` (or `--watch`), or
- edit in the repo and run `chezmoi apply`.

New files an app creates in `~/.config/<tool>/` stay local until `chezmoi add`ed.
That's the main difference from today's whole-directory links.

### 3.2 Theme switching without repo symlinks

Today `theme` rewrites symlinks **inside the repo**, hidden from git by
`skip-worktree`. Most of those links are absolute `/home/patrick/…` paths,
which would break on macOS (`/Users/…`) and Windows anyway. New design:

- The repo contains only the `*-dark` / `*-light` variants. The selector
  links are deleted from git, and so is the `skip-worktree` setup.
- `theme` writes **relative** selector links in the target, e.g.
  `~/.config/kitty/theme.conf -> theme-dark.conf`, next to the per-file links
  chezmoi created. `.chezmoiignore` hides them from chezmoi (2.4).
- `theme`, `switch-to-dark.sh`/`switch-to-light.sh` and the ranger switch
  scripts use `~/.config/…` paths instead of `$DOTFILES`.
- `run_once_after_10-theme-default.sh` runs `theme dark` on first apply
  (Linux and macOS), so a fresh machine is complete without further steps.
- macOS (nice-to-have): skip `gsettings`; optionally switch the system
  appearance via `osascript`; check where kitty puts its sockets.
- Windows: no `theme`. Point tools at the dark variant directly, by env var
  where one exists (`STARSHIP_CONFIG`, `BAT_CONFIG_PATH`), otherwise with a
  Windows-only template `{{ include "dot_config/…/…-dark…" }}`.
- Remove the stray `sh_common_aliases/config -> …/ghostty/config-light` link.

### 3.3 Prefer tool-native conditionals over templates

Templates are copies, so they lose the live-edit benefit. OS differences go
into the tools' own mechanisms where possible:

- kitty: `include ${KITTY_OS}.conf` (`linux.conf`, `macos.conf`).
- tmux: `if-shell 'uname | grep -q Darwin' …` (inline the test, see memory note
  on if-shell variables).
- zsh/bash: `case "$OSTYPE" in darwin*) …;; msys*) …;; esac`.
- git: `includeIf` for work repos.

`.tmpl` only where there is no alternative: `dot_gitconfig.tmpl` (identity,
aliases from `git-aliases`), the Windows-only config targets, the systemd
links.

### 3.4 Third-party content (`home/.chezmoiexternal.toml`)

```toml
[".oh-my-zsh"]
    type = "archive"
    url = "https://github.com/ohmyzsh/ohmyzsh/archive/master.tar.gz"
    exact = true
    stripComponents = 1
    refreshPeriod = "168h"

[".config/zsh/omz-custom/plugins/zsh-autosuggestions"]
    type = "git-repo"
    url = "https://github.com/zsh-users/zsh-autosuggestions.git"
    refreshPeriod = "168h"

[".config/kitty/kitty-themes"]
    type = "archive"
    url = "https://github.com/dexpota/kitty-themes/archive/master.tar.gz"
    stripComponents = 1
    refreshPeriod = "720h"
```

- `ZSH_CUSTOM=~/.config/zsh/omz-custom` keeps our own oh-my-zsh additions
  outside the downloaded tree.
- `zsh-autosuggestions` is an orphan gitlink today (no `.gitmodules`), so it
  gets removed from the repo.
- Our patched themes move from `kitty-themes/mythemes/` to
  `dot_config/kitty/mythemes/`, so the external can own `kitty-themes/` completely.
- Verify the kitty-themes upstream URL when doing this; the vendored copy's
  README says where it came from.

### 3.5 Neovim variants

- Linux/macOS: `dot_config/symlink_nvim` contains `nvim-lazyvim`, so
  `~/.config/nvim -> nvim-lazyvim` stays as today.
- `switch-nvim-setup` can't re-link `~/.config/nvim` any more (the next
  `chezmoi apply` would undo it). It switches via `NVIM_APPNAME` instead
  (`NVIM_APPNAME=nvim-kickstart nvim`), which needs no link at all.
- Windows: no symlinks. Set `XDG_CONFIG_HOME=%USERPROFILE%\.config` and
  `NVIM_APPNAME=nvim-lazyvim` as user env vars (3.7); Neovim honours both on Windows.

### 3.6 Secrets and privacy

- No secrets in the repo today: vdirsyncer reads from the keyring, and
  `~/.gitconfig` isn't tracked. Keep it that way.
- When needed (nice-to-have): chezmoi's `keepassxc` template functions or
  `age`-encrypted files (`encrypted_` prefix).
- The repo is public (Codeberg + GitHub). Nothing work-related goes into it:
  no employer name, work e-mail, hostnames, internal URLs, proxy settings.
- Before the first work-machine checkout, scan the full git history once with
  `gitleaks` or `git log -p | rg -i 'pass|token|secret'`.

### 3.7 Windows specifics

- `mode = "file"`: everything is a copy. Don't create `symlink_` entries for
  Windows targets (they need Developer Mode or admin).
- `run_once_before_10-env.ps1` sets user env vars without admin
  (`[Environment]::SetEnvironmentVariable(…, 'User')`): `XDG_CONFIG_HOME`,
  `NVIM_APPNAME`, `RIPGREP_CONFIG_PATH`, `BAT_CONFIG_PATH`, `YAZI_CONFIG_HOME`,
  `STARSHIP_CONFIG`, `TEALDEER_CONFIG_DIR`. Then the same `dot_config/` tree
  works unchanged.
- The PowerShell profile target may be redirected to OneDrive by policy:
  check `$PROFILE` first; the target path can be templated.

## 4. Package installation without admin

chezmoi doesn't install packages, but a `run_onchange_` script re-runs when
the package list changes. The script embeds a hash of the list:
`# {{ include ".packages/Brewfile" | sha256sum }}`.

### macOS (`work-mac`)

Homebrew needs admin to create `/opt/homebrew`. Order of preference:

1. **IT/Self Service installs Homebrew** (or grants it once) → `brew bundle --file ~/.dotfiles/home/.packages/Brewfile`.
   Casks with `--appdir=~/Applications`.
2. **No Homebrew**: [mise](https://mise.jdx.dev) (user-space, `~/.local/share/mise`)
   for CLI tools: rg, fd, bat, eza, fzf, starship, zoxide, atuin, yazi, glow,
   tealdeer, neovim, node. One `mise.toml` works on mac **and** Windows.
3. GUI apps: kitty's official installer puts `kitty.app` into `~/Applications`
   (no admin); same for dragging any `.app` there (ghostty, wezterm).
   MDM may still block unsigned/unapproved apps — then fall back to ghostty
   or ask IT.
4. Fonts: copy to `~/Library/Fonts` (per-user).

Don't use "untar anywhere" Homebrew in `$HOME` — unsupported, no bottles.
zsh is the default shell on macOS, so no `chsh` needed.

### Windows (`work-win-vm`)

Chocolatey defaults to admin, so `chocolatey/packages.config` becomes reference only.

1. **Scoop** (designed for no-admin, installs to `~/scoop`):
   `scoopfile.json` via `scoop import`. Covers nearly the whole current choco
   list (git, neovim, rg, fd, fzf, bat, starship, zoxide, yazi, gh, pwsh,
   nodejs, nerd fonts via the `nerd-fonts` bucket, keepassxc, meld) and chezmoi itself.
2. **winget `--scope user`** for what Scoop lacks (vscode user installer, signal).
3. mise as alternative/complement if Scoop is blocked.
4. Fonts: per-user font install works without admin (Windows 10 1809+).

Things that may be blocked by policy — check first, don't work around:

- `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` (needed for Scoop and
  chezmoi's `.ps1` scripts). If GPO forces it, ask IT.
- AppLocker/WDAC blocking executables in `%USERPROFILE%`.
- WSL: needs admin to enable. If IT provides it, treat WSL as another
  Linux machine with its own `chezmoi init` (profile `work`).

### Shell on Windows

zsh isn't native. Plan:

- **PowerShell 7** as main shell, with a small profile: starship, zoxide,
  PSReadLine vi-mode, and the most-used aliases from `common_aliases.sh`
  ported by hand.
- **Git Bash** (from Scoop's git) uses the existing `.bashrc`; `case "$OSTYPE"`
  guards (`msys*`) keep Linux-only parts out.

## 5. Bootstrap per device

Read-only HTTPS clone everywhere; no push credentials on work machines by
default (least privilege). If pushing from work is wanted later, use a
fine-grained token / deploy key scoped to this one repo.

Install chezmoi as a single binary into a user directory. Prefer downloading
the release and checking it against the release's checksums file over
`curl | sh`, at least on work machines (EDR tends to flag pipe-to-shell).

### Bootstrap Linux (`personal`) — migration in place

```sh
pacman -S chezmoi
# on a branch: restructure into home/ (2.1), fix repo paths (2.2), add .chezmoi* files
find ~ ~/.config -maxdepth 1 -lname '*/.dotfiles/*' -printf '%p -> %l\n' > ~/old-links.txt
chezmoi init --source ~/.dotfiles     # answers: personal, private e-mail
chezmoi diff                          # review: old dir links → real dirs with per-file links
```

The old whole-directory links (`~/.config/kitty -> ~/.dotfiles/.config/kitty`)
point to paths that no longer exist after the restructure. Remove them right
before the first `chezmoi apply -v`. Rollback: check out `main`, then restore
the links from `~/old-links.txt`.

### Bootstrap macOS (`work-mac`)

```sh
# chezmoi release binary → ~/.local/bin, checksum verified
chezmoi init --apply https://codeberg.org/<user>/dotfiles.git   # profile: work
```

`chezmoi init` clones into `~/.local/share/chezmoi` by default. Pass
`--source ~/.dotfiles` so the path is the same on every machine.

### Bootstrap Windows (`work-win-vm`)

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
irm get.scoop.sh | iex          # or: scoop's manual install
scoop install git chezmoi
chezmoi init --apply --source $HOME\.dotfiles https://codeberg.org/<user>/dotfiles.git   # profile: work
```

The *nice-to-have* unattended bootstrap is the same command with the answers
as flags: `--promptChoice profile=work --promptString email=…`.

## 6. Phases

1. **Prep (Linux, still `ln -s`, no behaviour change)**
   - Point the in-repo paths (2.2) at target paths, keeping the old links
     working in the meantime (e.g. `~/.local/bin/theme` link).
   - Rework `theme` and the switch scripts (3.2): target-side, relative links.
   - Add OS guards to `.zshrc`, `.bashrc`, `common_aliases.sh`, `tmux.conf`
     (GNU-only flags like `ls --color`, `sed -i`; `wl-copy`, `xdg-open`).
   - Create the git config template content from `~/.gitconfig` + `git-aliases`.
   - Secret audit of history.
2. **Restructure + chezmoi on Linux** (one branch): `git mv` into `home/`
   (2.1), `.chezmoiroot`, `.chezmoi.toml.tmpl`, `.chezmoiignore`, externals,
   remove selector links + orphan gitlink, `run_once_` theme script.
   Done when `chezmoi diff` is empty after apply and `theme` toggles cleanly.
   Replace the README's `ln -s` and `skip-worktree` sections with the chezmoi steps.
3. **work-mac (essentials only)**: Brewfile or mise config, kitty `macos.conf`
   (ghostty as fallback), tmux clipboard. Check that every `cli` tool reads
   `~/.config` (`bat --config-file`, `tldr --show-paths`, …), and set env vars
   in `.zshrc` where it doesn't.
4. **work-win-vm (essentials only)**: scoopfile, PowerShell profile, Git Bash
   guards, env-var script (3.7), Windows-only templates.
5. **Nice-to-haves**, in any order: `theme` on macOS, scoped push access,
   unattended bootstrap flags, KeePassXC/age secrets, `run_onchange_` package installs.
6. **Steady state**: see below.

Each phase is one branch / PR-sized step; Linux keeps working at every step.

## 7. Day-to-day workflow

| Task                         | Linux / macOS (symlink mode)                 | Windows (file mode)                |
|------------------------------|----------------------------------------------|------------------------------------|
| Edit a plain config          | edit in `~/.dotfiles/home/…` or via the target — same file | `chezmoi edit --apply <target>` |
| Edit a script or template    | `chezmoi edit --apply <target>`, or edit in repo + `chezmoi apply` | same                 |
| Add a new config             | `chezmoi add ~/.config/foo`                  | same                               |
| Pull changes                 | `chezmoi update`                             | same                               |
| What would change?           | `chezmoi diff`                               | same                               |
| Commit                       | `chezmoi cd` → usual git workflow            | same                               |
| Health check                 | `chezmoi doctor`                             | same                               |

## 8. Open questions

- Does the work-mac MDM allow user-installed binaries in `~/.local/bin` /
  `~/Applications`? Is Homebrew available via Self Service?
- Is Codeberg/GitHub reachable from work networks, and is there a TLS-intercepting
  proxy (then git/curl/mise and chezmoi externals need the corporate CA)?
- Is the Windows VM persistent or re-imaged? If it gets re-imaged often, the
  unattended bootstrap moves from nice-to-have to essential.
- Is the work-only scripts repo (`~/.config/patrick-work`) wanted on work machines?
  It's private — keep it a separate manual clone, not a chezmoi external whose
  URL would land in the public repo.

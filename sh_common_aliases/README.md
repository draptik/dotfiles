# Shared shell aliases between bash and zsh

- `common_aliases`: aliases which can be shared between different shells (bash, zsh)
- `aliases_theme_[dark|light]`: aliases which are configured differently depending on the
  background color of the current terminal.
- `themed_aliases` (excluded from git on purpose): soft link pointing to either `aliases_theme_dark` or `aliases_theme_light`.

  When switching a terminal theme -> only update the soft link to point to the correct file
  (`aliases_theme_[dark|light]`).

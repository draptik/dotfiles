# Spell checking

## Workflow for adding words to custom dictionary

- add word(s) to `my-custom`
- within NeoVim: `:mkspell! my-custom` (this generates the binary `my-custom.utf-8.spl`)
- NOTE: the previous command depends on the current root folder, so when started from the `dotfiles` folder, one has to use `:mkspell! $HOME/.dotfiles/.config/nvim-lazyvim/spell/my-custom`.

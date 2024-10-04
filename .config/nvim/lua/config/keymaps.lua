-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Markdown navigation ========================================================
--
-- TODO These keybindings should only be active in markdown files. Maybe `after/ftplugin` or something similar?
--
-- Idea from:
--
-- https://github.com/linkarzu/dotfiles-latest/blob/867193a6f905efaabd78675d9b9562df14fa60aa/neovim/nvim-lazyvim/lua/config/keymaps.lua#L282-L314
--
-- Search UP for a markdown header
-- Make sure to follow proper markdown convention, and you have a single H1
-- heading at the very top of the file.
-- This will only search for H2 headings and above.
vim.keymap.set("n", "gk", function()
  -- Regex explained:
  --
  -- `?`   - Start a search backwards from the current cursor position.
  -- `^`   - Match the beginning of a line.
  -- `##`  - Match 2 ## symbols
  -- `\\+` - Match one or more occurrences of prev element (#)
  -- `\\s` - Match exactly one whitespace character following the hashes
  -- `.*`  - Match any characters (except newline) following the space
  -- `$`    - Match extends to end of line
  vim.cmd("silent! ?^##\\+\\s.*$")
  -- Clear the search highlight
  vim.cmd("nohlsearch")
end, { desc = "Go to previous markdown header" })

-- Search DOWN for a markdown header.
-- Make sure to follow proper markdown convertion, and you have a single H1
-- heading at the very top of the file.
-- This will only search for H2 headings and above.
vim.keymap.set("n", "gj", function()
  -- Regex explained:
  --
  -- `/`   - Start a search forward from the current cursor position.
  -- `^`   - Match the beginning of a line.
  -- `##`  - Match 2 ## symbols
  -- `\\+` - Match one or more occurrences of prev element (#)
  -- `\\s` - Match exactly one whitespace character following the hashes
  -- `.*`  - Match any characters (except newline) following the space
  -- `$`    - Match extends to end of line
  vim.cmd("silent! /^##\\+\\s.*$")
  -- Clear the search highlight
  vim.cmd("nohlsearch")
end, { desc = "Go to next markdown header" })

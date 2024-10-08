-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Markdown navigation ========================================================
--
-- TODO: These keybindings should only be active in markdown files. Maybe `after/ftplugin` or something similar?
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

-- Folding ====================================================================
--
-- For details, see
-- https://github.com/linkarzu/dotfiles-latest/blob/f06a965f8545d9769d9f3be046c9960d5d168aef/neovim/neobean/lua/config/keymaps.lua#L1092
--
-- Summary:
--
-- `zu`: Unfold everything
-- `zj`: Fold everything
-- `zk`: Fold level 2
-- `zl`: Fold level 3
-- `z;`: Fold level 4

local function set_foldmethod_expr()
  -- These are lazyvim.org defaults but setting them just in case a file doesn't have them set
  if vim.fn.has("nvim-0.10") == 1 then
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
    vim.opt.foldtext = ""
  else
    vim.opt.foldmethod = "indent"
    vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  end
  vim.opt.foldlevel = 99
end

local function fold_headings_of_level(level)
  vim.cmd("normal! gg")
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      vim.fn.cursor(line, 1)
      if vim.fn.foldclosed(line) == -1 then
        vim.cmd("normal! za")
      end
    end
  end
end

local function fold_markdown_headings(levels)
  set_foldmethod_expr()
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  vim.fn.winrestview(saved_view)
end

vim.keymap.set("n", "zu", function()
  vim.cmd("edit!")
  vim.cmd("normal! zR")
end, { desc = "[P]Unfold all headings level 2 or above" })

vim.keymap.set("n", "zj", function()
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
end, { desc = "[P]Fold all headings level 1 or above" })

vim.keymap.set("n", "zk", function()
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
end, { desc = "[P]Fold all headings level 2 or above" })

vim.keymap.set("n", "zl", function()
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
end, { desc = "[P]Fold all headings level 3 or above" })

vim.keymap.set("n", "z;", function()
  vim.cmd("edit!")
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
end, { desc = "[P]Fold all headings level 4 or above" })

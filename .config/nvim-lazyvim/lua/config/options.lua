-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable relative line numbers because I don't need them for navigation.
vim.opt.relativenumber = false

vim.opt.spelllang = "en_us,de_de,my-custom"

-- Enables c# syntax highlighting in markdown code blocks
-- NOTE: `c_sharp` is the treesitter name, `csharp` is the name of the new alias.
-- NOTE: The default name in markdown code blocks is `cs`.
vim.treesitter.language.register("c_sharp", "csharp")

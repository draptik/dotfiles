-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Swap : and ;
vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", ":", ";", { noremap = true })

local map = vim.keymap.set

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", {
  desc = "Tmux/Vim left",
})
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", {
  desc = "Tmux/Vim down",
})
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", {
  desc = "Tmux/Vim up",
})
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", {
  desc = "Tmux/Vim right",
})
map("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", {
  desc = "Tmux/Vim previous",
})

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Swap : and ;
vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", ":", ";", { noremap = true })

-- Insert current date (insert mode)
vim.keymap.set("i", "<C-d>", function()
  return os.date("%Y-%m-%d")
end, { expr = true, desc = "Insert current date" })

-- Insert current date (normal mode)
vim.keymap.set("n", "<leader>id", function()
  vim.api.nvim_put({
    os.date("%Y-%m-%d") --[[@as string]],
  }, "c", true, true)
end, { desc = "Insert current date" })

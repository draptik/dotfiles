-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable auto formatting in markdown files
-- See https://github.com/LazyVim/LazyVim/discussions/141#discussioncomment-9266704
local set_autoformat = function(pattern, bool_val)
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = pattern,
    callback = function()
      vim.b.autoformat = bool_val
    end,
  })
end

set_autoformat({ "markdown" }, false)

-- Org mode calling Emacs
vim.api.nvim_create_autocmd("FileType", {
  pattern = "org",
  callback = function()
    vim.keymap.set("n", "<leader>oC", function()
      local file = vim.fn.expand("%:p")
      vim.notify("Updating Org clocktables…")
      vim.fn.system({
        "emacs",
        "-Q",
        "--batch",
        "-l",
        vim.fn.expand("~/.dotfiles/emacs/update-clocktables.el"),
        file,
      })
      vim.cmd("edit!")
    end, { buffer = true, desc = "Org: Update clocktables (Emacs batch)" })
  end,
})

-- Jinja files
local function jinja_host_from_name(name)
  if name:match("^Caddyfile%.j2$") or name:match("^Caddyfile%..+%.j2$") then
    return "caddyfile"
  end
  if name:match("^Dockerfile%.j2$") or name:match("^Dockerfile%..+%.j2$") then
    return "dockerfile"
  end
  return name:match("%.([%w_]+)%.j2$") -- e.g. deploy.bash.j2 -> bash
end

-- Whenever jinja.vim's ftdetect sets filetype=jinja, immediately upgrade it
-- to a compound "host.jinja" filetype based on the actual filename.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "jinja",
  callback = function(args)
    local name = vim.fn.fnamemodify(args.file, ":t")
    local host = jinja_host_from_name(name)
    if host then
      vim.bo[args.buf].filetype = host .. ".jinja"
    end
  end,
})

-- Force legacy :syntax alongside Tree-sitter so jinja.vim's rules render.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*.jinja",
  callback = function()
    vim.cmd("syntax on")
  end,
})

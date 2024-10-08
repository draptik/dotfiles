return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
        -- Don't accept suggestions by pressing enter, because this is annoying at the end of line
        -- Instead, use `C-y` to select the suggestion.
        -- See https://github.com/linkarzu/dotfiles-latest/blob/f06a965f8545d9769d9f3be046c9960d5d168aef/neovim/neobean/lua/plugins/nvim-cmp.lua#L10
        ["<CR>"] = cmp.config.disable,
      })
    end,
  },
}

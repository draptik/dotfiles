return {
  -- {
  --   "miikanissi/modus-themes.nvim",
  --   lazy = false,
  --   priority = 1000,
  -- },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      style = "night",
      -- Make the border color more prominent
      -- For details see https://github.com/folke/tokyonight.nvim/issues/34#issuecomment-2309000368
      on_colors = function(colors)
        colors.border = "#565f89"
      end,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}

return {
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
      -- The default color for flash's label (`FlashLabel`) are difficult to read.
      -- The original values are defined here:
      -- https://github.com/folke/tokyonight.nvim/blob/057ef5d260c1931f1dffd0f052c685dcd14100a3/extras/lua/tokyonight_night.lua#L926
      on_highlights = function(highlights)
        highlights.FlashLabel.bold = true
        highlights.FlashLabel.bg = "#fefbbd"
        highlights.FlashLabel.fg = "black"

        -- improve readability of comments
        highlights.Comment = {
          fg = "#a5a29f",
          bg = "#1a1d2a",
        }
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

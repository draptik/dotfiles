return {
  {
    -- plugin for learning nvim
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },

    -- See https://github.com/m4xshen/hardtime.nvim/issues/31#issuecomment-1685762701
    -- Now repetitive 'j|k' key strokes are recognized correcty and give a warning.
    -- TODO BUT now up/down arrow keys aren't seem to be disabled anymore (left/right arrow keys are disabled).
    lazy = false,
    keys = {
      { "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"' },
      { "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"' },
    },

    -- TODO disable left/right arrow key warning when in insert mode ("i")
    -- See https://github.com/m4xshen/hardtime.nvim/discussions/107
    -- TODO This Doesn't work:
    -- opts = {
    --   disabled_keys = {
    --     ["<Left>"] = {},
    --     ["<Right>"] = {},
    --   },
    -- },
    opts = {},
  },
}

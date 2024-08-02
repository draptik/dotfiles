return {
  {
    -- new UI which replaces messages, cmdline, and popupmenu
    "folke/noice.nvim",
    opts = {
      presets = {
        bottom_search = true,
      },
      cmdline = {
        -- location of command input: use traditional bottom location
        view = "cmdline",
      },
    },
  },
}

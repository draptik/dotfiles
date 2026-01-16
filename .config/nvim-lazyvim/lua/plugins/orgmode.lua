return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  ft = { "org" },
  config = function()
    -- Setup orgmode
    local org = require("orgmode")
    org.setup({
      org_agenda_files = "~/tmp/org-demo/**/*",
      org_default_notes_file = "~/tmp/org-demo/mydefault.org",

      -- The default keybindings are located here:
      -- https://github.com/nvim-orgmode/orgmode/blob/master/lua/orgmode/config/defaults.lua
      mappings = {
        org = {
          -- default keybindings (i.e. for `org_todo` and `org_todo_prev`) seem to be
          -- in conflict with LazyVim's defaults:
          org_todo = "<Leader>os",
          org_todo_prev = "<Leader>oS",
          org_priority_up = "<Leader>oP",
          org_priority_down = "<Leader>op",
        },
      },

      -- Optional: set what the *default* built-in agenda shows
      org_agenda_span = "week",

      -- These will show as extra choices in <Leader>oa
      org_agenda_custom_commands = {
        d = {
          description = "Agenda (day)",
          types = {
            { type = "agenda", org_agenda_span = "day" },
          },
        },
        w = {
          description = "Agenda (week)",
          types = {
            { type = "agenda", org_agenda_span = "week" },
          },
        },
      },
    })
  end,
}

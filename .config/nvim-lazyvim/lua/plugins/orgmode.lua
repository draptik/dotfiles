return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  config = function()
    -- Setup orgmode
    local org = require("orgmode")
    org.setup({
      org_agenda_files = "~/tmp/org-demo/**/*",
      org_default_notes_file = "~/tmp/org-demo/mydefault.org",
    })
  end,
}

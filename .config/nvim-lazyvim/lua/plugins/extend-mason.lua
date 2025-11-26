return {
  {
    "mason-org/mason.nvim",
    ---@param opts table
    opts = function(_, opts)
      -- keep the official registry *first*
      ---@diagnostic disable-next-line: inject-field
      opts.registries = opts.registries or { "github:mason-org/mason-registry" }
      table.insert(opts.registries, "github:Crashdummyy/mason-registry")

      ---@diagnostic disable-next-line: inject-field
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "roslyn" })
    end,
  },
}

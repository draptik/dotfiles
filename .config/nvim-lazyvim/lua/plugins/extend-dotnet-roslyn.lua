return {
  -- Use Roslyn LSP plugin (instead of the default omnisharp)
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- leave empty for defaults, or tweak here
    },
  },

  -- 2. Disable OmniSharp from the dotnet extra
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- this overrides the server entry added by extras.lang.dotnet
        omnisharp = { enabled = false },
      },
    },
  },

  -- 3. Tweak Neotest adapters: disable Rust, keep vstest
  {
    "nvim-neotest/neotest",
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}

      -- 🚫 disable Rust neotest adapter from extras.lang.rust
      -- This is a workaround! Remove once upstream rustaceanvim is fixed.
      opts.adapters["rustaceanvim.neotest"] = false

      -- ✅ keep & extend neotest-vstest from extras.lang.dotnet
      local vstest_cfg = opts.adapters["neotest-vstest"] or {}
      vstest_cfg.timeout_ms = vstest_cfg.timeout_ms or 5 * 60 * 1000
      opts.adapters["neotest-vstest"] = vstest_cfg
    end,
  },
}

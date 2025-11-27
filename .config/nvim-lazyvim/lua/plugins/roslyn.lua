-- NOTE: This package is not included in the default mason registry (yet)
-- Therefore the mason config must be extended to include the additional registry.
-- See file `extend-mason.lua`.
-- Install roslyn from the mason menu:
-- - :Mason
-- - serch `roslyn` and press `i` to install it
--
-- NOTE: Ensure that LazyVim's lang.extra.dotnet is uninstalled first:
-- - from file `lazy.lua`: remove the entry `{ import = "lazyvim.plugins.extras.lang.dotnet" }`
-- - uninstall from Mason
return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs" },
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },
  },

  -- NOTE: The following code is copied and adapted from `~/.local/share/nvim-lazyvim/lazy/lazyvim/plugins/extras/lang/dotnet.lua`
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "c_sharp", "fsharp" })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    -- optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      -- NOTE: Let none-ls handle everything except formatting. Formatting is done by conform.nvim.
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
        csproj = { "csharpier" },
        fsproj = { "csharpier" },
        fsharp = { "fantomas" },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "csharpier", "netcoredbg", "fantomas" } },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      if not dap.adapters["netcoredbg"] then
        require("dap").adapters["netcoredbg"] = {
          type = "executable",
          command = vim.fn.exepath("netcoredbg"),
          args = { "--interpreter=vscode" },
          options = {
            detached = false,
          },
        }
      end
      for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
        if not dap.configurations[lang] then
          dap.configurations[lang] = {
            {
              type = "netcoredbg",
              name = "Launch file",
              request = "launch",
              ---@diagnostic disable-next-line: redundant-parameter
              program = function()
                return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "Nsidorenco/neotest-vstest",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}

      -- 🚫 turn off the Rust adapter added by extras.lang.rust
      opts.adapters["rustaceanvim.neotest"] = false

      -- ✅ configure neotest-vstest (and ensure it’s present)
      local vstest_cfg = opts.adapters["neotest-vstest"] or {}
      vstest_cfg.timeout_ms = 5 * 60 * 1000
      opts.adapters["neotest-vstest"] = vstest_cfg
    end,
  },
}

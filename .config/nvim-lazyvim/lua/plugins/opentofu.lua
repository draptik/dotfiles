return {
  -- LSP: swap terraformls for tofu-ls (OpenTofu's own server)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = false, -- disable, it assumes the HashiCorp registry
        tofu_ls = {
          cmd = { "tofu-ls", "serve" },
          filetypes = { "terraform", "terraform-vars" },
        },
      },
    },
  },

  -- Formatter: use `tofu fmt` instead of `terraform fmt`
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        terraform = { "tofu_fmt" },
        tf = { "tofu_fmt" },
        ["terraform-vars"] = { "tofu_fmt" },
      },
    },
  },

  -- Linter: use `tofu validate` instead of `terraform validate`
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        terraform = { "tofu" },
        tf = { "tofu" },
      },
    },
  },
}

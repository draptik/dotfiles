local HOME = os.getenv("HOME")
return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      sh = { "shellcheck" },
    },
    linters = {
      -- For details see https://github.com/LazyVim/LazyVim/discussions/4094
      -- and https://github.com/LazyVim/LazyVim/discussions/4094#discussioncomment-15525364
      ["markdownlint-cli2"] = {
        prepend_args = { "--config", HOME .. "/.dotfiles/.config/markdownlint/.markdownlint-cli2.yaml", "--" },
      },
    },
  },
}

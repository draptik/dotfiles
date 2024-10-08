# Markdownlint

- [Project page](https://github.com/DavidAnson/markdownlint)

## Global settings in NeoVim

See `../nvim-lazyvim/lua/plugins/nvim-lint.lua` (the NeoVim configuration file references `./.markdownlint-cli2.yaml`).

## Settings in folder

Create a file similar to `./.markdownlint-cli2.yaml` in a folder.

## Settings in file

[Documentation](https://github.com/DavidAnson/markdownlint?tab=readme-ov-file#configuration)

Use HTML comments in the markdown file.

Examples:

```markdown
<!-- markdownlint-disable -->

<!-- markdownlint-disable MD001 MD005 -->
```

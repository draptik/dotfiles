# IdeaVim

IdeaVim is not Vim / NeoVim - it's independently reprogrammed for Jetbrains-IDEs. It offers many of the same features as the original.

## Configuration file


Link the desired configuration file (f. ex. `ideavimrc_experiment0`) to the `$HOME` directory:

``` sh
ln -s ~/.dotfiles/ideavim/ideavimrc_experiment0 ~/.ideavimrc
```

## Keybindings for JetBrains IDE (f. ex. Rider) actions

Example:
- `nmap <leader>fg <Action>(GotoFile)`
  - `<Action(*)` map IDE action `*`
- How to get the name of the action?
  - [Finding action IDs](https://github.com/JetBrains/ideavim?tab=readme-ov-file#finding-action-ids)

## Resolving conflicts between IdeaVim and JetBrains (f. ex. Rider) default keybindings

There are two ways to resolve keybinding conflicts between IDE and IdeaVim:
- using the IDE: Settings -> Editor -> Vim. Choose preference in dropdown
- defining the preference within the config file (`~/.ideavimrc`) using `sethandler`:
  - Example: `sethandler <c-k> a:IdeaVim` (This ensures that `c-k` is mapped to IdeaVim instead of the default IDE keybinding)

## Plugins

- Overview of available [IdeaVim Plugins](https://github.com/JetBrains/ideavim/wiki/IdeaVim-Plugins)
- Some plugins are integrated in IdeaVim:
  - `commentary`
  - `surround`
- Other plugins must be installed using the JetBrains Marketplace:
  - `easymotion` (also requires `AceJumo`)
  - `sneak`
  - `which-key`
- Syntax: `set` vs `Plug` - both are equivalent. Here is an example:
  - `set easymotion`
  - `Plug 'easymotion/vim-easymotion'`
  - The former is shorter, the later has the advantage that it includes the git repo which makes looking up the documentation easier.

## Resources

- [IdeaVim Marketing](https://lp.jetbrains.com/ideavim/)
- [IdeaVim](https://github.com/JetBrains/ideavim)
- [IdeaVim Wiki](https://github.com/JetBrains/ideavim/wiki)
- [IdeaVim Wiki - Plugins](https://github.com/JetBrains/ideavim/wiki/IdeaVim-Plugins)
- [A practical IdeaVim setup for IntelliJ IDEA](https://medium.com/@dbilici/a-practical-ideavim-setup-for-intellij-idea-cf74222e7b45)
- [A practical IdeaVim setup for IntelliJ IDEA (config file)](hhttps://github.com/dbilici/IdeaVim/blob/main/.ideavimrc)
- [YT: IdeaVim Casts](https://www.youtube.com/playlist?list=PLYDrCnplQfmG2aoNeu5_RP3GfcBiD1wl7)


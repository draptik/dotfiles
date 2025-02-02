# IdeaVim

IdeaVim is a VIM engine for Jetbrains-IDEs (written in Java). It offers many of the same features as the original.

## Audience

There are 2 types of people using IdeaVim. Power users of:

- JetBrains IDEs
- (N)Vim

Both groups will want to continue using keyboard shortcuts they are used to.

## Jetbrains power keybindings don't have to be remapped

- `Alt+Enter`: still works!
- As long as the 'Jetbrains' keybinding does not conflict with any Vim keybindings it will work.

## Configuration file

Link the desired configuration file (f. ex. `ideavimrc_experiment0`) to the `$HOME` directory:

``` sh
ln -s ~/.dotfiles/ideavim/ideavimrc_experiment0 ~/.ideavimrc
```

## Keybindings for JetBrains IDE (f. ex. Rider) "Actions"

Example:

- `nmap <leader>fg <Action>(GotoFile)`
  - `<Action(*)` map IDE action `*`
- How to get the name of the action?
  - [Finding action IDs](https://github.com/JetBrains/ideavim?tab=readme-ov-file#finding-action-ids)

## Resolving conflicts between IdeaVim and JetBrains (f. ex. Rider) default keybindings

There are two ways to resolve keybinding conflicts between IDE and IdeaVim:

- using the IDE: Settings -> Editor -> Vim. Choose preference in dropdown
- defining the preference within the config file (`~/.ideavimrc`) using `sethandler`:
  - Example: `sethandler <c-k> a:vim` (This ensures that `c-k` is mapped to IdeaVim instead of the default IDE keybinding)

## Plugins

- Overview of available [IdeaVim Plugins](https://github.com/JetBrains/ideavim/wiki/IdeaVim-Plugins)
- There seem to be more plugins available:
  - [CamelCasePlugin](https://github.com/netnexus/camelcaseplugin)
- Some plugins are bundled with IdeaVim:
  - `commentary`
  - `surround`
  - `highlightedyank`
  - `nerdtree`
- Other plugins must be installed using the JetBrains Marketplace:
  - `easymotion` (also requires `AceJump`)
  - `sneak`
  - `which-key`
- Syntax: `set` vs `Plug` - both are equivalent. Here is an example:
  - `set easymotion`
  - `Plug 'easymotion/vim-easymotion'`
  - The former is shorter, the later has the advantage that it includes the git repo which makes looking up the documentation easier.

## surround Plugin usage

Documentation: <https://github.com/tpope/vim-surround/blob/master/doc/surround.txt>

In example below, `*` indicates the cursor position.

### Delete surroundings: `ds`

```txt
x
Old text                  Command     New text ~
"Hello *world!"           ds"         Hello world!
(123+4*56)/2              ds)         123+456/2
<div>Yo!*</div>           dst         Yo!
```

### Change surroundings: `cs`

```txt
Old text                  Command     New text ~
"Hello *world!"           cs"'        'Hello world!'
"Hello *world!"           cs"<q>      <q>Hello world!</q>
(123+4*56)/2              cs)]        [123+456]/2
(123+4*56)/2              cs)[        [ 123+456 ]/2
<div>Yo!*</div>           cst<p>      <p>Yo!</p>
```

### Add surroundings: `ys`

```txt
Old text                  Command     New text ~
Hello w*orld!             ysiw)       Hello (world)!
     Hello w*orld!        yssB            {Hello world!}
```

## Resources

- [IdeaVim Marketing](https://lp.jetbrains.com/ideavim/)
- [IdeaVim](https://github.com/JetBrains/ideavim)
- [IdeaVim Wiki](https://github.com/JetBrains/ideavim/wiki)
- [IdeaVim Wiki - Plugins](https://github.com/JetBrains/ideavim/wiki/IdeaVim-Plugins)
- [A practical IdeaVim setup for IntelliJ IDEA](https://medium.com/@dbilici/a-practical-ideavim-setup-for-intellij-idea-cf74222e7b45)
- [A practical IdeaVim setup for IntelliJ IDEA (config file)](hhttps://github.com/dbilici/IdeaVim/blob/main/.ideavimrc)
- [YT: IdeaVim Casts](https://www.youtube.com/playlist?list=PLYDrCnplQfmG2aoNeu5_RP3GfcBiD1wl7)
- [The ultimate IdeaVim setup](https://www.cyberwizard.io/posts/the-ultimate-ideavim-setup/)

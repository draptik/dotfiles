# -*- mode: sh -*-

## Some aliases from https://computingforgeeks.com/pacman-and-yaourt-package-manager-mastery-cheat-sheet/
##
## pacman Alias commands.
##
## Update/install
##
alias pacu='sudo pacmatic -Syu' # Update the system and upgrade all system packages.
alias paci='sudo pacmatic -S' # Install a specific package from repos added to the system

## Search (online/local)
alias pacs='pacman -Ss' # Search for package or packages in the repositories
alias paclocs='pacman -Qs' # Search for package/packages in the local database

## Remove
alias pacr='sudo pacman -R' # Remove the specified package or packages but retain its configuration and required dependencies
alias pacrall='sudo pacman -Rns' # Remove the specified package or packages , its configuration and all unwanted dependencies

## Misc
alias pacl='sudo pacman -U' # Install specific package that has been downloaded to the local system
alias pacinfo='pacman -Si' # Display information about a given package located in the repositories
alias pacsl='pacman -Qi' # Display information about a given package in the local database

## Alias for shutdown
alias reboot='sudo systemctl reboot'
alias poweroff='sudo systemctl poweroff'


## Temporary dotnet fix
#alias dotnet='TERM=xterm dotnet'

## Cleanup
alias cleanup='sudo paccache -r'

# Load common aliases shared between bash and zsh
source ~/.dotfiles/sh_common_aliases/common_aliases.sh


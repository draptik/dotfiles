#!/bin/bash

# Example from https://wiki.archlinux.org/title/.NET#Uninstall_manually_installed_version
#
# $ SDK_VERSION="5.0.100"
# $ DOTNET_VERSION="5.0.0"
# $ DOTNET_UNINSTALL_PATH="/usr/share/dotnet"
# # rm -rf $DOTNET_UNINSTALL_PATH/sdk/$SDK_VERSION
# # rm -rf $DOTNET_UNINSTALL_PATH/shared/Microsoft.NETCore.App/$DOTNET_VERSION
# # rm -rf $DOTNET_UNINSTALL_PATH/shared/Microsoft.AspNetCore.All/$DOTNET_VERSION
# # rm -rf $DOTNET_UNINSTALL_PATH/shared/Microsoft.AspNetCore.App/$DOTNET_VERSION
# # rm -rf $DOTNET_UNINSTALL_PATH/host/fxr/$DOTNET_VERSION

$ SDK_VERSION="5.0.100"
$ DOTNET_VERSION="5.0.0"
$ DOTNET_UNINSTALL_PATH="/usr/share/dotnet"

sudo rm -rf "$DOTNET_UNINSTALL_PATH/sdk/$SDK_VERSION"
sudo rm -rf "$DOTNET_UNINSTALL_PATH/shared/Microsoft.NETCore.App/$DOTNET_VERSION"
sudo rm -rf "$DOTNET_UNINSTALL_PATH/shared/Microsoft.AspNetCore.All/$DOTNET_VERSION"
sudo rm -rf "$DOTNET_UNINSTALL_PATH/shared/Microsoft.AspNetCore.App/$DOTNET_VERSION"
sudo rm -rf "$DOTNET_UNINSTALL_PATH/host/fxr/$DOTNET_VERSION"

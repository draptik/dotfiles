#!/bin/bash
#
# Purpose: switch nvim setup between (1) LazyVim, (2) kickstart, and (3) vanilla interactively
#
# The script
#
# - manages configuration, local share, and state directories by switching symlinks.
# - ensures nvim is not running during the switch and creates missing directories if needed.
# - includes a rollback mechanism to restore previous symlink states in case of failure.
#
# The script was created with the help of ChatGPT.
# Adding the prompt "Respect ShellCheck best practices" helped.

# Define paths for the Neovim configurations and corresponding local directories
LAZYVIM_DIR="$HOME/.dotfiles/.config/nvim-lazyvim"
KICKSTART_DIR="$HOME/.dotfiles/.config/nvim-kickstart"
VANILLA_DIR="$HOME/.dotfiles/.config/nvim-vanilla"

LAZYVIM_SHARE_DIR="$HOME/.local/share/nvim-lazyvim"
KICKSTART_SHARE_DIR="$HOME/.local/share/nvim-kickstart"
VANILLA_SHARE_DIR="$HOME/.local/share/nvim-vanilla"

LAZYVIM_STATE_DIR="$HOME/.local/state/nvim-lazyvim"
KICKSTART_STATE_DIR="$HOME/.local/state/nvim-kickstart"
VANILLA_STATE_DIR="$HOME/.local/state/nvim-vanilla"

# Actual Neovim directories (symlinks)
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_SHARE_DIR="$HOME/.local/share/nvim"
NVIM_STATE_DIR="$HOME/.local/state/nvim"

# Function to check if Neovim is running
check_neovim_running() {
  if pgrep -x "nvim" >/dev/null; then
    echo "Neovim is currently running. Please close it before switching configurations."
    exit 1
  fi
}

# Function to create a directory if it does not exist
create_dir_if_not_exists() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    echo "Directory $dir does not exist. Creating it..."
    mkdir -p "$dir" || return 1
  fi
}

# Function to store current symlink targets before making changes
store_current_state() {
  CONFIG_BACKUP=$(readlink "$NVIM_CONFIG_DIR" 2>/dev/null || echo "none")
  SHARE_BACKUP=$(readlink "$NVIM_SHARE_DIR" 2>/dev/null || echo "none")
  STATE_BACKUP=$(readlink "$NVIM_STATE_DIR" 2>/dev/null || echo "none")
}

# Function to rollback to the previous state if something goes wrong
rollback() {
  echo "An error occurred. Attempting to revert to the previous state..."

  if [ "$CONFIG_BACKUP" != "none" ]; then
    rm -rf "$NVIM_CONFIG_DIR"
    ln -s "$CONFIG_BACKUP" "$NVIM_CONFIG_DIR"
    echo "Restored previous config symlink to $CONFIG_BACKUP."
  fi

  if [ "$SHARE_BACKUP" != "none" ]; then
    rm -rf "$NVIM_SHARE_DIR"
    ln -s "$SHARE_BACKUP" "$NVIM_SHARE_DIR"
    echo "Restored previous share symlink to $SHARE_BACKUP."
  fi

  if [ "$STATE_BACKUP" != "none" ]; then
    rm -rf "$NVIM_STATE_DIR"
    ln -s "$STATE_BACKUP" "$NVIM_STATE_DIR"
    echo "Restored previous state symlink to $STATE_BACKUP."
  fi

  echo "Rollback complete. Exiting."
  exit 1
}

# Function to switch symlinks for config, share, and state directories
switch_config() {
  local config_name="$1"
  local config_dir="$2"
  local share_dir="$3"
  local state_dir="$4"

  # Store current symlink targets before switching
  store_current_state

  # Switch the ~/.config/nvim symlink
  if [ -d "$config_dir" ]; then
    # Remove existing symlink or folder in ~/.config/nvim
    rm -rf "$NVIM_CONFIG_DIR"
    # Create the new symlink to the desired config
    ln -s "$config_dir" "$NVIM_CONFIG_DIR" || rollback
    echo "Switched to $config_name Neovim configuration in ~/.config/nvim."
  else
    echo "Directory $config_dir does not exist. Cannot switch to $config_name."
    rollback
  fi

  # Switch the ~/.local/share/nvim symlink
  create_dir_if_not_exists "$share_dir" || rollback
  if [ -d "$share_dir" ]; then
    rm -rf "$NVIM_SHARE_DIR"
    ln -s "$share_dir" "$NVIM_SHARE_DIR" || rollback
    echo "Switched to $config_name Neovim local data in ~/.local/share/nvim."
  else
    echo "Failed to create or access $share_dir. Cannot switch $config_name's local data."
    rollback
  fi

  # Switch the ~/.local/state/nvim symlink
  create_dir_if_not_exists "$state_dir" || rollback
  if [ -d "$state_dir" ]; then
    rm -rf "$NVIM_STATE_DIR"
    ln -s "$state_dir" "$NVIM_STATE_DIR" || rollback
    echo "Switched to $config_name Neovim state data in ~/.local/state/nvim."
  else
    echo "Failed to create or access $state_dir. Cannot switch $config_name's state data."
    rollback
  fi
}

# Check if Neovim is running before proceeding
check_neovim_running

# Display menu options
echo "Choose a Neovim configuration to switch to:"
echo "1) LazyVim"
echo "2) Kickstart"
echo "3) Vanilla"

# Read user input
read -r -p "Enter the number of your choice: " choice

# Switch based on the user's choice
case "$choice" in
1)
  switch_config "LazyVim" "$LAZYVIM_DIR" "$LAZYVIM_SHARE_DIR" "$LAZYVIM_STATE_DIR"
  ;;
2)
  switch_config "Kickstart" "$KICKSTART_DIR" "$KICKSTART_SHARE_DIR" "$KICKSTART_STATE_DIR"
  ;;
3)
  switch_config "Vanilla" "$VANILLA_DIR" "$VANILLA_SHARE_DIR" "$VANILLA_STATE_DIR"
  ;;
*)
  echo "Invalid choice. Exiting."
  exit 1
  ;;
esac

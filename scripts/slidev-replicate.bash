#!/bin/bash
##
## The script automates setting up a new GitHub repository and branch to deploy Slidev presentations via GitHub Pages.
## It streamlines the process by validating inputs, creating the repository, setting up a local branch,
## and generating a GitHub Actions workflow for automated deployment.
## This reduces manual setup, ensures consistent configuration, and guides users on managing deployment permissions.

# Exit script if any command fails
set -euo pipefail

# Check if the gh tool is installed
if ! command -v gh &>/dev/null; then
  echo "Error: gh (GitHub CLI) is not installed. Please install it and try again."
  exit 1
fi

GITHUB_USER=$(gh api user --jq ".login")

# Prompt the user to enter the branch name
read -r -p "Enter the name of the new branch: " BRANCH_NAME

# Check if the branch name is not empty
if [[ -z "$BRANCH_NAME" ]]; then
  echo "Error: Branch name cannot be empty. Please provide a valid name."
  exit 1
fi

# Check if the branch name is valid according to Git rules (basic check)
if [[ "$BRANCH_NAME" =~ [\ /\\\~\^:?*\[] ]]; then
  echo "Error: Branch name contains invalid characters. Avoid using spaces, slashes, or special characters like ~, ^, :, *, ?, [, ]."
  exit 1
fi

# Assign the branch name to the repository name
REPO_NAME="$BRANCH_NAME"

# Create a new repository using gh (no initialization, just creation)
if ! gh repo create "$REPO_NAME" --public --confirm; then
  echo "Error: Failed to create the GitHub repository. Ensure you have proper permissions, and the repository name is unique."
  exit 1
fi

# Switch to the new branch
if ! git checkout -b "$BRANCH_NAME"; then
  echo "Error: Failed to create a new Git branch. Make sure the branch name does not already exist."
  exit 1
fi

# Generate the GitHub Actions workflow file with dynamic name 'deploy-branch-name.yml'
WORKFLOW_FILE=".github/workflows/deploy-${BRANCH_NAME}.yml"

cat <<EOF >"$WORKFLOW_FILE"
name: Deploy pages
on:
  push:
    branches:
      - $BRANCH_NAME

jobs:
  deploy:

    env:
      PRESENTATION_FOLDER: 'presentation'
      TARGET_REPO_NAME: '$REPO_NAME'
      TARGET_GITHUB_OWNER: '$GITHUB_USER'
      NODE_VERSION: 'lts/*'

    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: \${{ env.NODE_VERSION }}

      - name: Install dependencies
        run: |
          cd \${{ env.PRESENTATION_FOLDER }}
          npm ci

      - name: Build
        run: |
          cd \${{ env.PRESENTATION_FOLDER }}
          npm run build -- --base '/\${{ env.TARGET_REPO_NAME }}/'

      - name: Deploy to target repository
        uses: crazy-max/ghaction-github-pages@v4
        with:
          build_dir: \${{ env.PRESENTATION_FOLDER }}/dist
          repo: '\${{ env.TARGET_GITHUB_OWNER }}/\${{ env.TARGET_REPO_NAME }}'
        env:
          GITHUB_TOKEN: \${{ secrets.SLIDEV_TOKEN }}
EOF

# Add and commit the new workflow file
git add "$WORKFLOW_FILE"
git commit -m "Add GitHub Actions workflow for branch '$BRANCH_NAME'"

# Push the workflow to the remote branch
if ! git push origin "$BRANCH_NAME"; then
  echo "Error: Failed to push the GitHub Actions workflow to the remote repository."
  exit 1
fi

# Confirm setup
echo "New GitHub repository '$REPO_NAME' created, branch '$BRANCH_NAME' pushed, and GitHub Actions workflow '$WORKFLOW_FILE' added."
echo "It is ok that this fails the first time..."
echo "Add the target repo to the 'allowed' repos for SLIDEV_TOKEN"
echo "Then rerun the action"

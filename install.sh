#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# Your GitHub username (automatically set)
GH_USER="7Sleeps"
# Your repository name (automatically set)
REPO_NAME="7SploitHydrogen"
# The directory where the repo will be cloned (defaults to the repo name)
INSTALL_DIR="$REPO_NAME"
# The default branch of your repository to clone
# IMPORTANT: Make sure this matches the branch where your install.sh and project code reside.
# Common examples: "main", "master", "develop"
BRANCH="main"

REPO_URL="https://github.com/$GH_USER/$REPO_NAME.git"

# --- Helper Functions ---
# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# --- Main Script ---
echo "-----------------------------------------------------"
echo " Starting installation for $GH_USER/$REPO_NAME"
echo "-----------------------------------------------------"
echo ""

# 1. Check for Git
echo "Checking for Git..."
if ! command_exists git; then
  echo "Error: Git is not installed. Please install Git and try again."
  echo "On Debian/Ubuntu: sudo apt update && sudo apt install git"
  echo "On Fedora: sudo dnf install git"
  echo "On macOS (with Homebrew): brew install git"
  exit 1
fi
echo "Git is installed."
echo ""

# 2. Check if the target directory already exists
if [ -d "$INSTALL_DIR" ]; then
  echo "Warning: Directory '$INSTALL_DIR' already exists at $(pwd)/$INSTALL_DIR."
  read -p "Do you want to remove it and re-clone? (yes/no): " choice
  case "$choice" in
    yes|YES|Y|y)
      echo "Removing existing directory '$INSTALL_DIR'..."
      rm -rf "$INSTALL_DIR"
      ;;
    *)
      echo "Installation aborted. The existing directory '$INSTALL_DIR' was not modified."
      exit 0
      ;;
  esac
fi
echo ""

# 3. Clone the repository
echo "Cloning $REPO_NAME from $REPO_URL (branch: $BRANCH)..."
# The --depth 1 flag can be added for a shallow clone if you only need the latest version:
# git clone --branch "$BRANCH" --depth 1 "$REPO_URL" "$INSTALL_DIR"
git clone --branch "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
echo "Repository cloned successfully into $(pwd)/$INSTALL_DIR."
echo ""

# 4. Change into the cloned directory
echo "Changing directory to '$INSTALL_DIR'..."
cd "$INSTALL_DIR"
echo "Successfully changed directory to $(pwd)."
echo ""

# 5. (Optional) Run a setup script if it exists
# If you create a setup.sh or similar script in your repository's root,
# you can uncomment and modify the lines below to execute it.
# The original repository (OutlawedDev/7sploit) uses a setup.sh with sudo.
# Adapt this to your needs.

# SETUP_SCRIPT_NAME="setup.sh" # Or whatever your setup script is named

# if [ -f "$SETUP_SCRIPT_NAME" ]; then
#   echo "Found '$SETUP_SCRIPT_NAME'. Attempting to make it executable and run it..."
#   chmod +x "$SETUP_SCRIPT_NAME"
#
#   # Option A: Run without sudo
#   # echo "Executing ./$SETUP_SCRIPT_NAME"
#   # ./$SETUP_SCRIPT_NAME
#
#   # Option B: Run with sudo (if your script needs root privileges)
#   # if command_exists sudo; then
#   #   echo "Executing sudo ./$SETUP_SCRIPT_NAME"
#   #   sudo ./$SETUP_SCRIPT_NAME
#   # else
#   #   echo "Error: sudo command not found, but script might require it. Please run with sudo privileges or install sudo."
#   #   # As a fallback, you could try running without sudo, but it might fail:
#   #   # echo "Attempting to execute ./$SETUP_SCRIPT_NAME without sudo..."
#   #   # ./$SETUP_SCRIPT_NAME
#   # fi
#   echo "Setup script execution finished (or was skipped if commented out)."
# else
#   echo "No setup script (e.g., '$SETUP_SCRIPT_NAME') found in the root of the repository. Skipping automatic setup script execution."
#   echo "If your project requires manual setup steps, please refer to its README."
# fi
echo "" # Add a blank line for readability after the optional setup script section

echo "-------------------------------------------------------------------"
echo " $GH_USER/$REPO_NAME installation script finished."
echo "-------------------------------------------------------------------"
echo ""
echo "Successfully cloned to the '$INSTALL_DIR' directory."
echo "Current directory: $(pwd)"
echo ""
echo "Next steps:"
echo "1. Review the contents of the '$INSTALL_DIR' directory."
echo "2. If your project has a specific setup script (e.g., setup.sh, configure, Makefile) that was not automatically run,"
echo "   you may need to execute it now. (The section for this in install.sh is commented out by default)."
echo "3. Follow any further setup or usage instructions in your project's README.md."
echo ""

exit 0

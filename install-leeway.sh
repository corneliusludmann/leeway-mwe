#!/bin/bash
set -e

# Script to install Leeway from source
# Usage: ./install-leeway.sh [branch_name]
#   branch_name: Optional Git branch/tag/commit to checkout (defaults to main)

# Get branch name from command line argument or use default
BRANCH_NAME=${1:-main}

echo "Installing Leeway from source (branch: $BRANCH_NAME)..."

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "Error: Go is required to build Leeway but it's not installed."
    echo "Please install Go first: https://golang.org/doc/install"
    exit 1
fi

# Define installation directories
INSTALL_DIR="/usr/local/bin"
CACHE_DIR="$HOME/.cache/leeway"
BUILD_DIR="/tmp/leeway-build"

# Create a temporary directory for the repo
LEEWAY_REPO_DIR=$(mktemp -d -t leeway-repo-XXXXXXXXXX)
echo "Using temporary directory: $LEEWAY_REPO_DIR"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"
mkdir -p "$BUILD_DIR"

# Clone the repository into the temporary directory
echo "Cloning Leeway repository into temporary directory..."
git clone https://github.com/gitpod-io/leeway "$LEEWAY_REPO_DIR"
cd "$LEEWAY_REPO_DIR"

# Switch to the specified branch/tag/commit
echo "Switching to branch/tag: $BRANCH_NAME"
# For tags and commits, we need to use --detach
if git show-ref --verify --quiet "refs/tags/$BRANCH_NAME" || git rev-parse --verify --quiet "$BRANCH_NAME^{commit}" > /dev/null; then
    git switch --detach "$BRANCH_NAME"
else
    # It's a branch
    git switch "$BRANCH_NAME"
fi

# Build Leeway
echo "Building Leeway..."
go build -o leeway

# Install Leeway
echo "Installing Leeway to $INSTALL_DIR..."
sudo install -m 755 leeway "$INSTALL_DIR/"

# Set up environment variables
echo "Setting up environment variables..."
cat > "$HOME/.leeway.env" << EOF
# Leeway environment variables
export LEEWAY_WORKSPACE_ROOT=\$PWD
export LEEWAY_CACHE_DIR="$CACHE_DIR"
export LEEWAY_BUILD_DIR="$BUILD_DIR"
EOF

# Clean up
echo "Cleaning up temporary files..."
cd /
rm -rf "$LEEWAY_REPO_DIR"

echo ""
echo "Leeway has been installed successfully from branch: $BRANCH_NAME"
echo "To set up the environment variables, run:"
echo "  source ~/.leeway.env"
echo ""
echo "You can add this to your ~/.bashrc or ~/.zshrc to make it permanent:"
echo "  echo 'source ~/.leeway.env' >> ~/.bashrc"
echo ""
echo "Leeway version information:"
leeway version

exit 0

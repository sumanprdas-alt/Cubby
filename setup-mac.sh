#!/bin/bash
# FamilyOS — Local Mac Setup Script
# Run this on your Mac to set up the project locally.
# Usage: chmod +x setup-mac.sh && ./setup-mac.sh

set -e

echo "🏠 Setting up FamilyOS on your Mac..."

# Create project directory
PROJECT_DIR="$HOME/Projects/FamilyOS"
mkdir -p "$PROJECT_DIR"

echo "📁 Created project directory: $PROJECT_DIR"

# Clone the repo (or init if pushing for the first time)
if [ -d "$PROJECT_DIR/.git" ]; then
  echo "📦 Git repo already exists. Pulling latest..."
  cd "$PROJECT_DIR"
  git pull origin main
else
  echo "📦 Cloning repository..."
  cd "$PROJECT_DIR"
  git init
  git remote add origin https://github.com/sumanprdas-alt/FamilyOS.git
  echo "⚡ Remote set to: https://github.com/sumanprdas-alt/FamilyOS"
fi

echo ""
echo "✅ FamilyOS project ready at: $PROJECT_DIR"
echo ""
echo "Next steps:"
echo "  1. Copy all files from the downloaded scaffold into $PROJECT_DIR"
echo "  2. cd $PROJECT_DIR"
echo "  3. git add -A"
echo "  4. git commit -m 'feat: initial project scaffold with CLAUDE.md and documentation structure'"
echo "  5. git push -u origin main"
echo "  6. Open Claude Code in $PROJECT_DIR"
echo "  7. Paste the Phase 1 prompt from plan/phase-1-product-discovery.md"
echo ""
echo "🚀 Let's build the operating system for families."

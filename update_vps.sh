#!/bin/bash

# Script to update VPS with latest code from GitHub
# Run this on your VPS server

set -e  # Exit on error

echo "🚀 Starting VPS update process..."

# Configuration
GITHUB_REPO="https://github.com/kxaviera/pikkar_admin_panel.git"
OLD_DIR="/path/to/admin_panel"  # Update this with your actual VPS path
NEW_DIR="/path/to/pikkar_admin_panel"  # Update this with your desired new path
BACKUP_DIR="/path/to/backups/admin_panel_$(date +%Y%m%d_%H%M%S)"

# Step 1: Backup current directory (if exists)
if [ -d "$OLD_DIR" ]; then
    echo "📦 Creating backup of current directory..."
    mkdir -p "$(dirname $BACKUP_DIR)"
    cp -r "$OLD_DIR" "$BACKUP_DIR"
    echo "✅ Backup created at: $BACKUP_DIR"
fi

# Step 2: Clone or update the repository
if [ -d "$NEW_DIR" ]; then
    echo "🔄 Updating existing repository..."
    cd "$NEW_DIR"
    git fetch origin
    git reset --hard origin/main
    git clean -fd
else
    echo "📥 Cloning repository..."
    mkdir -p "$(dirname $NEW_DIR)"
    git clone "$GITHUB_REPO" "$NEW_DIR"
    cd "$NEW_DIR"
fi

# Step 3: Install dependencies
echo "📦 Installing dependencies..."
npm install

# Step 4: Build TypeScript (if needed)
if [ -f "tsconfig.json" ]; then
    echo "🔨 Building TypeScript..."
    npm run build || echo "⚠️ Build step skipped (may not be needed)"
fi

# Step 5: Restart the service
echo "🔄 Restarting service..."
# Uncomment the appropriate restart command for your setup:

# If using PM2:
# pm2 restart pikkar-api || pm2 start npm --name "pikkar-api" -- start

# If using systemd:
# sudo systemctl restart pikkar-api

# If using Docker:
# docker-compose restart

# If running directly, stop current process and start:
# pkill -f "node.*server" || true
# nohup npm start > logs/app.log 2>&1 &

echo "✅ Update completed!"
echo "📝 Please manually restart your service using the appropriate command above"

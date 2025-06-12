#!/bin/bash
set -e

APP_DIR="/opt/leaderboard_app"

# Ensure system packages are up to date and Python venv is available
sudo apt update -y
sudo apt install -y python3-pip python3-venv

# Create app directory with proper permissions
sudo mkdir -p "$APP_DIR/templates"
sudo chown -R ubuntu:ubuntu "$APP_DIR"

# Create virtual environment
python3 -m venv "$APP_DIR/venv"
source "$APP_DIR/venv/bin/activate"

# Upgrade pip and install required Python packages inside the venv
"$APP_DIR/venv/bin/pip" install --upgrade pip
"$APP_DIR/venv/bin/pip" install flask redis python-dotenv

echo "Flask + Redis app installed in virtual environment"

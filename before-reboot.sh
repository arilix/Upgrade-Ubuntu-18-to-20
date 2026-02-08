#!/bin/bash
# Script to prepare and upgrade Jetson Nano from Ubuntu 18.04 to 20.04
# Run this script BEFORE rebooting the system

set -e  # Exit on any error

echo "================================================"
echo "Jetson Nano Ubuntu 20.04 Upgrade - Part 1"
echo "================================================"

# Step 1: Remove conflicting packages
echo ""
echo "[1/7] Removing conflicting packages..."
sudo apt-get remove --purge -y chromium-browser chromium-browser-l10n

# Step 2: Update and upgrade system
echo ""
echo "[2/7] Updating and upgrading system..."
sudo apt-get update
sudo apt-get install -y nano
sudo apt-get upgrade -y
sudo apt-get autoremove -y

# Step 3: Enable distribution upgrade
echo ""
echo "[3/7] Enabling distribution upgrade..."
sudo sed -i 's/Prompt=.*/Prompt=normal/' /etc/update-manager/release-upgrades

# Step 4: Refresh system and dist-upgrade
echo ""
echo "[4/7] Running dist-upgrade..."
sudo apt-get update
sudo apt-get dist-upgrade -y

# Step 5: Upgrade to Ubuntu 20.04
echo ""
echo "[5/7] Starting upgrade to Ubuntu 20.04..."
echo "NOTE: Always choose default options and ignore Ubuntu 21.04 notifications"
sudo do-release-upgrade

# Step 6: Configuration fixes (Disable Wayland)
echo ""
echo "[6/7] Disabling Wayland..."
sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf
sudo sed -i 's/WaylandEnable=true/WaylandEnable=false/' /etc/gdm3/custom.conf

# Step 7: Enable NVIDIA driver
echo ""
echo "[7/7] Enabling NVIDIA driver..."
if [ -f /etc/X11/xorg.conf ]; then
    sudo sed -i 's/#.*Driver.*"nvidia"/    Driver      "nvidia"/' /etc/X11/xorg.conf
fi

# Reset upgrade manager
echo ""
echo "Resetting upgrade manager..."
sudo sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades

echo ""
echo "================================================"
echo "Part 1 completed successfully!"
echo "================================================"
echo ""
echo "IMPORTANT: The system will reboot now."
echo "After reboot, run: ./after-reboot.sh"
echo ""
read -p "Press Enter to reboot now, or Ctrl+C to cancel..."

sudo reboot

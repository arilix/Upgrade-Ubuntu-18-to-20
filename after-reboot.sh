#!/bin/bash
# Script to complete Jetson Nano Ubuntu 20.04 upgrade
# Run this script AFTER rebooting from Part 1

set -e  # Exit on any error

echo "================================================"
echo "Jetson Nano Ubuntu 20.04 Upgrade - Part 2"
echo "================================================"

# Step 1: Post-install cleanup
echo ""
echo "[1/3] Running post-install cleanup..."
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y
sudo rm -rf /usr/share/vulkan/icd.d

# Step 2: UI fixes
echo ""
echo "[2/3] Applying UI fixes..."
if [ -f /usr/share/applications/vpi1_demos ]; then
    sudo rm /usr/share/applications/vpi1_demos
fi

if [ -f /usr/share/nvpmodel_indicator/nv_logo.svg ]; then
    cd /usr/share/nvpmodel_indicator
    sudo mv nv_logo.svg no_logo.svg
fi

# Step 3: Install GCC 8 (CUDA requirement)
echo ""
echo "[3/3] Installing GCC 8 for CUDA compatibility..."
sudo apt-get install -y gcc-8 g++-8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 8
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 9
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 8

echo ""
echo "================================================"
echo "Part 2 completed successfully!"
echo "================================================"
echo ""
echo "To select GCC version, run:"
echo "  sudo update-alternatives --config gcc"
echo "  sudo update-alternatives --config g++"
echo ""
echo "Ubuntu 20.04 upgrade is now complete!"
echo "================================================"

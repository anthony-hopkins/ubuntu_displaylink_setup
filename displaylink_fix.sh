#!/bin/bash

# =============================================================================
# DisplayLink Driver Installation and Setup Script for Ubuntu
# =============================================================================
# 
# This script automates the complete setup process for DisplayLink drivers
# on Ubuntu systems, enabling multi-monitor support through USB-connected
# displays. It handles:
# 
# - Driver installation and DKMS module management
# - Secure Boot compatibility through MOK key generation and signing
# - Kernel module signing for the evdi driver
# - Proper module loading and configuration
#
# Use this script when you need to connect additional monitors via
# DisplayLink-enabled USB docks, adapters, or similar devices.
# =============================================================================

set -e

# === CONFIGURATION ===
# Environment variables with sensible defaults
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DISPLAYLINK_VERSION="${DISPLAYLINK_VERSION:-5.8.0-59}"
DISPLAYLINK_DEB="$SCRIPT_DIR/displaylink-driver-${DISPLAYLINK_VERSION}.run"

# MOK key configuration
MOK_KEY="${MOK_KEY:-$SCRIPT_DIR/mok.key}"
MOK_CRT="${MOK_CRT:-$SCRIPT_DIR/mok.crt}"
MOK_CERT_CN="${MOK_CERT_CN:-DisplayLink}"
MOK_CERT_DAYS="${MOK_CERT_DAYS:-365}"
MOK_KEY_SIZE="${MOK_KEY_SIZE:-2048}"

# === STEP 1: Install System Dependencies ===
echo "[+] Installing required packages for DisplayLink driver compilation..."
sudo apt update
sudo apt install -y dkms linux-headers-$(uname -r) build-essential mokutil openssl

# === STEP 2: Generate MOK Keys for Secure Boot ===
if [[ ! -f "$MOK_KEY" || ! -f "$MOK_CRT" ]]; then
    echo "[+] Generating MOK keys for Secure Boot compatibility in: $SCRIPT_DIR"
    echo "[+] Using certificate CN: $MOK_CERT_CN, validity: $MOK_CERT_DAYS days, key size: $MOK_KEY_SIZE bits"
    openssl req -new -x509 -newkey rsa:$MOK_KEY_SIZE -keyout "$MOK_KEY" -out "$MOK_CRT" -nodes -days $MOK_CERT_DAYS -subj "/CN=$MOK_CERT_CN/"
    sudo mokutil --import "$MOK_CRT"
    echo
    echo "[!] Reboot now and enroll the key in the MOK manager."
    echo "[!] After reboot, rerun this script from the SAME directory:"
    echo "    $SCRIPT_DIR"
    exit 0
fi

# === STEP 3: Install DisplayLink Driver Package ===
if [[ ! -f "$DISPLAYLINK_DEB" ]]; then
    echo "[!] DisplayLink installer not found at: $DISPLAYLINK_DEB"
    echo "    Please place the .run file in the same directory as this script."
    echo "    Expected filename: displaylink-driver-${DISPLAYLINK_VERSION}.run"
    echo "    Or set DISPLAYLINK_VERSION environment variable to match your file."
    exit 1
fi

echo "[+] Installing DisplayLink driver version ${DISPLAYLINK_VERSION} for multi-monitor support..."
chmod +x "$DISPLAYLINK_DEB"
sudo ./"$DISPLAYLINK_DEB"

# === STEP 4: Sign the evdi Kernel Module ===
echo "[+] Locating evdi module for DisplayLink display support..."
EVDI_PATH=$(find /usr/src -name "evdi.ko" | head -n 1)

if [[ -f "$EVDI_PATH" ]]; then
    echo "[+] Signing evdi module for Secure Boot compatibility..."
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 "$MOK_KEY" "$MOK_CRT" "$EVDI_PATH"
else
    echo "[!] evdi module not found. Check DKMS status."
    exit 1
fi

# === STEP 5: Load and Configure DisplayLink Module ===
echo "[+] Reloading evdi module for DisplayLink display detection..."
sudo modprobe -r evdi || true
sudo modprobe evdi

echo "[✓] DisplayLink multi-monitor setup complete with Secure Boot signing."
echo "[✓] Your DisplayLink-connected displays should now be detected and working."

# === STEP 6: Post-Reboot Instructions ===
echo
echo "[!] IMPORTANT: After rebooting to enroll the MOK key, you MUST:"
echo "    1. Reboot your system when prompted by the MOK manager"
echo "    2. Run this script again from the EXACT same directory:"
echo "       $SCRIPT_DIR"
echo "    3. The script will complete the remaining setup steps"
echo
echo "[!] If you run the script from a different location, the MOK keys"
echo "    won't be found and the setup will fail!"
echo
echo "[✓] DisplayLink setup phase 1 complete. Reboot and rerun for phase 2."

#!/usr/bin/env bash

# Simple WiFi setup script using SOPS
# Run this script after booting to automatically connect to your WiFi network

set -e

echo "Setting up WiFi connection using SOPS secrets..."

# Check if SOPS is available and age key exists
if ! command -v sops &> /dev/null; then
    echo "Error: sops command not found. Please install sops."
    exit 1
fi

AGE_KEY_FILE="/home/jon/.config/sops/age/keys.txt"
if [ ! -f "$AGE_KEY_FILE" ]; then
    echo "Error: Age key file not found at $AGE_KEY_FILE"
    echo "Please set up your SOPS age key first."
    exit 1
fi

SECRETS_FILE="/etc/nixos/hosts/procyon/secrets/secrets.yaml"
if [ ! -f "$SECRETS_FILE" ]; then
    echo "Error: Secrets file not found at $SECRETS_FILE"
    exit 1
fi

# Extract WiFi credentials from SOPS
export SOPS_AGE_KEY_FILE="$AGE_KEY_FILE"
WIFI_SSID=$(sops -d --extract '["wifi-ssid"]' "$SECRETS_FILE")
WIFI_PSK=$(sops -d --extract '["wifi-psk"]' "$SECRETS_FILE")

if [ -z "$WIFI_SSID" ] || [ -z "$WIFI_PSK" ]; then
    echo "Error: Could not extract WiFi credentials from SOPS"
    exit 1
fi

echo "Creating NetworkManager connection for SSID: $WIFI_SSID"

# Create NetworkManager connection file
CONNECTION_FILE="/etc/NetworkManager/system-connections/devnullvoid.nmconnection"
sudo tee "$CONNECTION_FILE" > /dev/null << EOF
[connection]
id=devnullvoid
uuid=$(uuidgen)
type=wifi
autoconnect=true
autoconnect-priority=1

[wifi]
mode=infrastructure
ssid=$WIFI_SSID

[wifi-security]
auth-alg=open
key-mgmt=wpa-psk
psk=$WIFI_PSK

[ipv4]
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=auto
EOF

# Set correct permissions
sudo chmod 600 "$CONNECTION_FILE"
sudo chown root:root "$CONNECTION_FILE"

# Reload NetworkManager
sudo systemctl reload-or-restart NetworkManager

echo "WiFi connection configured successfully!"
echo "NetworkManager should now automatically connect to $WIFI_SSID" 
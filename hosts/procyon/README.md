# Procyon Host Configuration

This directory contains the configuration for the `procyon` host (laptop).

## WiFi Setup

Since the SOPS integration has circular dependency issues in the flake context, WiFi setup is handled via a manual script approach.

### Prerequisites

1. **SOPS Age Key**: Make sure your age key is set up at `/home/jon/.config/sops/age/keys.txt`
2. **Secrets File**: The secrets file should be available at `/etc/nixos/hosts/procyon/secrets/secrets.yaml`

### Setting Up WiFi

After booting the system, run the WiFi setup script:

```bash
sudo /etc/nixos/hosts/procyon/setup-wifi.sh
```

This script will:
1. Extract WiFi credentials from the SOPS secrets file
2. Create a NetworkManager connection configuration
3. Reload NetworkManager to apply the connection

The system will then automatically connect to the configured WiFi network.

### Manual NetworkManager Setup

If you prefer to set up WiFi manually without SOPS:

```bash
# Connect to WiFi network
sudo nmcli device wifi connect "YOUR_SSID" password "YOUR_PASSWORD"

# Or create a persistent connection
sudo nmcli connection add type wifi ifname wlp0s20f3 con-name "YOUR_CONNECTION_NAME" \
  802-11-wireless.ssid "YOUR_SSID" \
  802-11-wireless-security.key-mgmt wpa-psk \
  802-11-wireless-security.psk "YOUR_PASSWORD"
```

## Configuration Structure

- `configuration.nix` - Main configuration entry point
- `hardware-configuration.nix` - Hardware-specific settings (generated)
- `home.nix` - Home-manager configuration for the user
- `variables.nix` - Host-specific variables and settings
- `networking.nix` - Basic networking configuration (NetworkManager only)
- `secrets/` - SOPS encrypted secrets
- `setup-wifi.sh` - WiFi setup script using SOPS

## Rebuilding

To rebuild the system:

```bash
sudo nixos-rebuild switch --flake .#procyon
```

## Power Management

The system includes intelligent power management that prevents suspend when on AC power while still allowing screen blanking and power saving:

### Features

- **Smart Suspend**: Only suspends when on battery power (AC power = no suspend)
- **Screen Blanking**: Screen turns off after 15 minutes of inactivity
- **Screen Locking**: Screen locks after 10 minutes of inactivity
- **Power Profiles**: Adaptive power management via `power-profiles-daemon`
- **Thermal Management**: Automatic thermal throttling via `thermald`

### Power Management Commands

```bash
# Check current power status
power-status

# Test smart suspend logic (shows what would happen)
test-smart-suspend

# Actually test suspend (only works on battery)
test-smart-suspend --execute

# Toggle power profile (power-saver -> balanced -> performance)
toggle-power-profile

# Manual power profile control
powerprofilesctl set balanced|performance|power-saver
```

### Timeouts

- **10 minutes**: Screen locks (hyprlock)
- **15 minutes**: Screen turns off (DPMS off)
- **20 minutes**: Smart suspend (battery only)

### Caffeine Mode

Use the existing `caffeine` script to temporarily disable hypridle:

```bash
# Toggle caffeine mode (disables all timeouts)
caffeine
```

## Notes

- The system uses NetworkManager for network management
- SOPS is available as a system package for manual secret decryption
- The configuration is optimized for laptop usage with power management enabled
- Power management prevents suspend when plugged into AC power
- Lid switch behavior: suspend when closed (regardless of power source) 
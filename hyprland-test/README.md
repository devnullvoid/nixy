# Hyprland VirtIO-GPU Test Flake

A minimal, clean flake specifically for testing Hyprland with VirtIO-GPU in VMs.

## Setup

1. Copy your VM's hardware configuration:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
   ```

2. Edit `hardware-configuration.nix` to replace the UUID with your actual disk UUID.

## Test Configurations

### 1. Stable Hyprland (Recommended)
Uses nixpkgs-24.05 with pre-Aquamarine Hyprland:
```bash
sudo nixos-rebuild switch --flake .#hyprland-test-stable
```

### 2. Headless Mode (Guaranteed to work)
Forces headless backend only - access via VNC:
```bash
sudo nixos-rebuild switch --flake .#hyprland-test-headless

# Then run the test script:
sudo /etc/test-hyprland.sh

# Connect via VNC to VM_IP:5900
```

### 3. Unstable Hyprland (For comparison)
Uses latest nixpkgs with Aquamarine:
```bash
sudo nixos-rebuild switch --flake .#hyprland-test-unstable
```

## Debugging

- Login: `test` / `test`
- SSH enabled with root login
- All configs have minimal Hyprland settings
- Environment variables force software rendering

## Expected Results

- **Headless**: Should always work, accessible via VNC
- **Stable**: Should work with VirtIO-GPU (pre-Aquamarine)
- **Unstable**: May fail due to Aquamarine backend issues

This isolates Hyprland testing from any other configuration interference. 
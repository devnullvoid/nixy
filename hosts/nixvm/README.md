# NixVM Host Configuration

This is a lean NixOS configuration designed for VM testing, based on the `procyon` host but with minimal packages and optimizations for virtual machine environments.

## Purpose

- **Testing**: Safe environment to test NixOS configurations without affecting main system
- **Development**: Lightweight setup for configuration development and debugging
- **VM Optimized**: Disabled heavy features like blur, shadows, and unnecessary services

## Key Differences from Procyon

### Disabled/Removed:
- WiFi configuration (not needed in VM)
- Bluetooth support
- Tailscale VPN
- nix-ld (VSCode server support)
- SSH server
- Heavy applications (Discord, Obsidian, etc.)
- Cloud sync (Nextcloud)
- Advanced theming (SDDM, Stylix)
- Performance-heavy Hyprland effects (blur, shadows)

### Included:
- Essential Hyprland desktop environment
- Basic development tools (Git, Neovim, terminal)
- Firefox browser
- Basic file manager (Thunar)
- System utilities (htop, tree, etc.)
- Screenshot and notification scripts

## Building

```bash
# Build the VM configuration
sudo nixos-rebuild switch --flake .#nixvm

# Or build without switching (for testing)
nixos-rebuild build --flake .#nixvm
```

## VM Setup Notes

1. **Hardware Configuration**: The `hardware-configuration.nix` is generic and may need adjustment based on your VM setup
2. **Disk Layout**: Assumes `/dev/sda1` for root and `/dev/sda2` for boot - adjust as needed
3. **VM Guest Tools**: Includes QEMU guest tools and SPICE support for better VM integration
4. **Performance**: Optimized for VM environments with reduced visual effects

## Customization

To customize for your VM environment:

1. Update `hardware-configuration.nix` with your actual disk layout
2. Adjust `variables.nix` for your preferences
3. Enable/disable VM guest tools in `configuration.nix` based on your hypervisor
4. Add additional packages to `home.nix` as needed for testing

## VM Hypervisor Support

The configuration includes support for:
- **QEMU/KVM**: Default configuration
- **VMware**: Enable `virtualisation.vmware.guest.enable`
- **VirtualBox**: Enable `virtualisation.virtualbox.guest.enable`

Uncomment the appropriate line in `configuration.nix` based on your hypervisor. 
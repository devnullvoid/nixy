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
- systemd-boot (replaced with GRUB for MBR compatibility)

### Included:
- Essential Hyprland desktop environment
- Basic development tools (Git, Neovim, terminal)
- Firefox browser
- Basic file manager (Thunar)
- System utilities (htop, tree, etc.)
- Screenshot and notification scripts

## Building

### Safe Build Method (Recommended)
```bash
# Use the provided build script for safer builds
./hosts/nixvm/build-vm.sh build    # Build without switching (safe)
./hosts/nixvm/build-vm.sh switch   # Build and switch
./hosts/nixvm/build-vm.sh check    # Check system resources
```

### Manual Build Method
```bash
# Build the VM configuration
sudo nixos-rebuild switch --flake .#nixvm

# Or build without switching (for testing)
nixos-rebuild build --flake .#nixvm
```

## Troubleshooting Build Issues

### System Freezes During Build
If your system freezes during builds, try these solutions:

1. **Use the safe build script**: `./hosts/nixvm/build-vm.sh build`
2. **Increase VM resources**:
   - RAM: Minimum 2GB, recommended 4GB+
   - Disk: Minimum 20GB, recommended 40GB+
   - CPU: 2+ cores recommended

3. **Check available resources**:
   ```bash
   # Check memory
   free -h
   # Check disk space
   df -h
   # Check swap
   swapon --show
   ```

### Journal Restoration Issues
If the system freezes on "restoring journal":

1. **Boot from a previous generation**:
   - Select older generation in GRUB/systemd-boot
   - Or restore from VM snapshot

2. **Clear journal manually**:
   ```bash
   sudo journalctl --vacuum-time=1d
   sudo systemctl restart systemd-journald
   ```

3. **Check disk space**: Journal issues often indicate full disk

### Memory Issues
The configuration includes several memory optimizations:
- 4GB swap file
- Limited parallel builds (`max-jobs = 1`)
- Reduced journal size
- Memory pressure optimizations

### Build Performance Tips
- Close unnecessary applications before building
- Use `build` first, then `switch` if successful
- Monitor resources with `htop` during builds
- Consider building on host system and copying result

## VM Setup Notes

1. **Hardware Configuration**: The `hardware-configuration.nix` is generic and may need adjustment based on your VM setup
2. **Disk Layout**: Assumes single partition `/dev/sda1` with label `nixos` for root filesystem (MBR partitioning)
3. **Bootloader**: Uses GRUB for MBR partitioning instead of systemd-boot (UEFI/GPT)
4. **VM Guest Tools**: Includes QEMU guest tools and SPICE support for better VM integration
5. **Performance**: Optimized for VM environments with reduced visual effects

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
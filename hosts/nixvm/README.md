# NixVM Host Configuration

This is a comprehensive NixOS configuration designed for VM testing that matches the main flake configuration as closely as possible, but uses nixpkgs packages instead of building from source for faster builds.

## Purpose

- **Testing**: Safe environment to test NixOS configurations without affecting main system
- **Development**: Full-featured setup for comprehensive configuration testing
- **Flake Validation**: Ensures all flake features work correctly in a controlled environment

## Key Differences from Procyon

### Only Removed:
- Heavy user applications: Discord, Zen Browser, Spicetify, Nextcloud, Obsidian, Figma
- Hardware-specific configurations (laptop-specific keyboard backlight, etc.)
- systemd-boot (replaced with GRUB for MBR compatibility in VMs)

### Key Changes for VM Testing:
- **Hyprland**: Uses nixpkgs version instead of building from source (much faster)
- **All Core Features**: SDDM, Stylix, blur, shadows, animations all fully functional
- **Complete Desktop**: Full Hyprland ecosystem for comprehensive testing

### Included (Full Flake Testing):
- Complete Hyprland desktop environment with all effects
- SDDM display manager with theming
- Stylix theming system
- All system scripts and utilities
- Development tools (Git, Neovim, Lazygit, etc.)
- Essential applications (Firefox, Bitwarden, VLC, etc.)
- File manager, PDF viewer, clipboard manager
- Tailscale VPN, SSH, audio, bluetooth
- All home-manager configurations

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

### Shell/Login Issues
If you can't log in or get shell errors:

1. **Boot into single-user mode**:
   - At GRUB menu, press `e` to edit
   - Add `init=/bin/bash` to kernel line
   - Boot with `Ctrl+X`

2. **In single-user mode** (only `sh` is available):
   ```bash
   # Make filesystem writable
   mount -o remount,rw /
   
   # Navigate to config directory
   cd /home/jon/Dev/nixy
   
   # Use full path to nixos-rebuild
   /run/current-system/sw/bin/nixos-rebuild switch --flake .#nixvm
   
   # Or if that doesn't work, build manually
   nix build .#nixosConfigurations.nixvm.config.system.build.toplevel
   ./result/bin/switch-to-configuration switch
   ```

3. **Temporary shell fix**:
   ```bash
   # Edit /etc/passwd to change shell from fish to bash temporarily
   vi /etc/passwd
   # Change: jon:x:1000:1000:jon account:/home/jon:/run/current-system/sw/bin/fish
   # To:     jon:x:1000:1000:jon account:/home/jon:/bin/bash
   ```

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
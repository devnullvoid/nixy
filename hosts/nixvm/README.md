# NixVM Configuration

A streamlined NixOS VM configuration for testing the nixy flake configuration with minimal bloat.

## Features

### Core System
- **Fast builds**: Uses `pkgs.hyprland` instead of building from source
- **Minimal footprint**: Removes unnecessary components while maintaining full flake testing capability
- **Complete Hyprland ecosystem**: Full window manager, panel, idle management, etc.
- **SDDM with theming**: Login manager with Stylix integration
- **Fonts and styling**: Complete font stack and theming system

### What's Included
- **Essential system**: Users, SSH, fonts, nix configuration
- **Hyprland environment**: Full WM setup with all components
- **Development essentials**: Neovim, Git, shell configuration
- **GUI applications**: Firefox, file manager, terminal, PDF viewer
- **System scripts**: Screenshot, brightness, night-shift, panel management
- **Minimal utilities**: File tools, system monitoring, compression

### What's Removed (Bloat Reduction)
- **Audio system**: No PipeWire/audio in VM
- **Bluetooth**: Not needed for VM testing
- **VPN/Networking**: Tailscale and OpenVPN scripts removed
- **Development SDKs**: No Go, Node.js, Python, etc.
- **Media players**: No VLC, MPV, or video applications
- **Heavy applications**: No Bitwarden, calendar, text manipulation tools
- **Fun terminal apps**: No cmatrix, pipes, cbonsai, etc.
- **Image optimization**: No optipng, jpegoptim
- **Power management**: No caffeine, power-status scripts (VM doesn't need them)
- **Wine/Bottles**: No Windows compatibility layer

## Usage

### Building the VM
```bash
# Build the VM disk image
just build-vm nixvm

# Run the VM
just run-vm nixvm
```

### Testing Focus
This configuration is optimized for testing:
- **Hyprland functionality**: Window management, effects, animations
- **Theming system**: Stylix integration and color schemes  
- **Panel and widgets**: HyprPanel functionality
- **Login experience**: SDDM theming and login flow
- **Core workflows**: File management, terminal usage, basic GUI apps

### Performance
- **Faster builds**: No source compilation of Hyprland
- **Reduced memory**: Minimal package set and no unnecessary services
- **Quick iteration**: Essential components only for efficient testing

## VM Optimizations
- GRUB bootloader for MBR compatibility
- VM-specific environment variables
- Optimized for virtualization environments
- No unnecessary hardware support

This configuration provides the full flake testing experience with significantly reduced build times and resource usage. 
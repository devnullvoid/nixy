# NixVM Configuration - Ultra-Minimal

An ultra-minimal NixOS VM configuration for basic Hyprland testing with drastically reduced storage footprint (~3-5GB instead of 30GB+).

## Key Space Optimizations

### Major Reductions
- **Fonts**: Removed full font collection (~3GB), kept only essential fonts
- **Neovim**: Removed full nvf setup with plugins (~1GB+)
- **Shell tools**: Removed heavy shell dependencies and tools (~500MB+)
- **File manager**: Removed Thunar + icon themes (~800MB+)
- **Browser**: Kept Firefox but removed qutebrowser with custom homepage
- **Scripts**: Removed ALL custom scripts to eliminate dependencies
- **Panel**: Removed HyprPanel to eliminate heavy dependencies
- **Documentation**: Disabled all man pages, docs, and dev docs
- **Hardware support**: Disabled firmware, microcode updates

### What's Included (Minimal Set)
- **Core Hyprland**: Window manager, wallpaper, screen lock, launcher
- **Essential apps**: Firefox browser, terminal (kitty)
- **Basic tools**: Git, vim, shell (fish), tree, btop
- **SDDM**: Login manager with basic theming
- **Fonts**: Only DejaVu, emoji, and one nerd font

### What's Removed
- **Development tools**: No Neovim, no language servers, no development packages
- **System scripts**: No screenshot, brightness, panel management scripts
- **File management**: No file manager, no auto-mounting
- **Heavy Hyprland components**: No panel, no idle management, no clipboard manager
- **Shell enhancements**: Minimal shell setup without heavy tooling
- **GPG/Signing**: No GPG setup or git signing
- **System info tools**: No fetch programs or system monitoring extras
- **Archive tools**: No zip/unzip utilities
- **Network tools**: No VPN, minimal networking

## Expected Size
- **VM image**: ~3-5GB (down from 30GB+)
- **Memory usage**: ~1-2GB RAM
- **Build time**: Significantly faster due to fewer packages

## Usage

### Building the Minimal VM
```bash
# Build the ultra-minimal VM
nix build .#nixosConfigurations.nixvm.config.system.build.toplevel

# For actual VM usage, build disk image
just build-vm nixvm
```

### What You Can Test
- **Basic Hyprland functionality**: Window management, tiling
- **Login experience**: SDDM with basic theming
- **Core workflows**: Terminal usage, basic GUI
- **Theme system**: Basic Stylix theming (limited scope)

### What You Cannot Test
- **Full development workflow**: No Neovim, limited dev tools
- **Advanced Hyprland features**: No panel, limited scripting
- **File management**: No GUI file manager
- **System management**: No custom scripts or tools

## Limitations
This is a **basic testing environment** only. It's designed for:
- Quick Hyprland testing
- Login/theme validation
- Basic functionality verification
- Space-constrained VMs

For full feature testing, use the regular nixvm configuration or the main system.

## Performance Optimizations
- **Aggressive memory management**: Minimal swap, optimized kernel parameters
- **Reduced journaling**: Smaller logs, shorter retention
- **Minimal documentation**: No man pages, docs disabled
- **Single-threaded builds**: Prevents memory exhaustion
- **Optimized filesystem**: NoAtime, discard for SSDs

This configuration prioritizes **minimal disk usage** over **comprehensive testing capabilities**. 